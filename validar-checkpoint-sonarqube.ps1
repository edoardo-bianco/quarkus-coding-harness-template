[CmdletBinding()]
param(
    [string]$ProjectKey = "",
    [string]$ProjectName = "",
    [string]$SonarUrl = "http://localhost:9000",
    [ValidateRange(0, 100)][double]$MinimumCoverage = 85,
    [ValidateRange(0, 100)][double]$MaximumDuplication = 5,
    [ValidateRange(1, 3600)][int]$ComputeEngineTimeoutSec = 300,
    [string]$OfflineReportPath = "",
    [ValidateSet("", "Reprovar", "AceitarExcepcionalmente", "ContinuarAjustes")]
    [string]$HumanDecision = "",
    [switch]$InitializeBaseline,
    [switch]$OfflineOnlyBaseline
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$modulePath = Join-Path $PSScriptRoot ".codex/hooks/SonarQuality.psm1"
if (-not (Test-Path -LiteralPath $modulePath -PathType Leaf)) {
    throw "Módulo de qualidade SonarQube ausente."
}
Import-Module $modulePath -Force
$stateDirectory = Get-SonarAgentStateDirectory -RepositoryRoot $PSScriptRoot
$statePath = Join-Path $stateDirectory "session.json"

function Get-ProjectIdentity {
    $pomPath = Join-Path $PSScriptRoot "pom.xml"
    if (-not (Test-Path -LiteralPath $pomPath -PathType Leaf)) {
        throw "pom.xml não encontrado junto ao checkpoint."
    }
    [xml]$pom = Get-Content -LiteralPath $pomPath -Raw
    $namespace = [Xml.XmlNamespaceManager]::new($pom.NameTable)
    $namespace.AddNamespace("m", "http://maven.apache.org/POM/4.0.0")
    $groupNode = $pom.SelectSingleNode("/m:project/m:groupId", $namespace)
    if ($null -eq $groupNode) {
        $groupNode = $pom.SelectSingleNode("/m:project/m:parent/m:groupId", $namespace)
    }
    $artifactNode = $pom.SelectSingleNode("/m:project/m:artifactId", $namespace)
    $nameNode = $pom.SelectSingleNode("/m:project/m:name", $namespace)
    if ($null -eq $groupNode -or $null -eq $artifactNode) {
        throw "O POM deve informar groupId e artifactId."
    }

    $resolvedKey = if ([string]::IsNullOrWhiteSpace($ProjectKey)) {
        "$($groupNode.InnerText):$($artifactNode.InnerText)"
    }
    else {
        $ProjectKey
    }
    $resolvedName = if (-not [string]::IsNullOrWhiteSpace($ProjectName)) {
        $ProjectName
    }
    elseif ($null -ne $nameNode -and -not [string]::IsNullOrWhiteSpace($nameNode.InnerText)) {
        $nameNode.InnerText
    }
    else {
        $artifactNode.InnerText
    }
    if ($resolvedKey.Length -gt 400 -or
        $resolvedKey -notmatch "^[A-Za-z0-9_.:-]+$" -or $resolvedKey -match "^\d+$") {
        throw "ProjectKey inválida."
    }
    if ([string]::IsNullOrWhiteSpace($resolvedName) -or
        $resolvedName -notmatch "^[\p{L}\p{N} ._:-]+$") {
        throw "ProjectName inválido."
    }
    return [pscustomobject]@{ Key = $resolvedKey; Name = $resolvedName }
}

function Read-SonarState {
    if (-not (Test-Path -LiteralPath $statePath -PathType Leaf)) {
        throw "Baseline da sessão ausente. Execute com -InitializeBaseline."
    }
    if ((Get-Item -LiteralPath $statePath).Length -gt 20MB) {
        throw "O estado SonarQube excede o limite de 20 MB."
    }
    $state = Get-Content -Raw -LiteralPath $statePath | ConvertFrom-Json -Depth 30
    if ($null -eq $state -or
        $null -eq $state.PSObject.Properties["schemaVersion"] -or
        $state.schemaVersion -ne 1) {
        throw "Estado SonarQube inválido ou incompatível."
    }
    return $state
}

function New-Assessment {
    param([Parameter(Mandatory)][object]$Result)

    return [pscustomobject]@{
        technicalStatus = if ($Result.Passed) { "COMPLIANT" } else { "NON_COMPLIANT" }
        humanDecision = if ($Result.Passed) { "NOT_REQUIRED" } else { "PENDING" }
        decidedAtUtc = $null
        issueCount = $Result.IssueCount
        baselineIssueCount = $Result.BaselineIssueCount
        newIssueKeys = @($Result.NewIssueKeys)
        highOrBlockerIssueKeys = @($Result.HighOrBlockerIssueKeys)
        coverage = $Result.Coverage
        duplicatedLinesDensity = $Result.DuplicatedLinesDensity
        violations = @($Result.Violations)
    }
}

function New-UnverifiedAssessment {
    param([Parameter(Mandatory)][string[]]$Limitations)

    return [pscustomobject]@{
        technicalStatus = "UNVERIFIED"
        humanDecision = "NOT_REQUIRED"
        decidedAtUtc = $null
        limitations = @($Limitations)
    }
}

function New-BaselineState {
    param(
        [Parameter(Mandatory)][object]$Identity,
        [Parameter(Mandatory)][string]$NormalizedSonarUrl,
        [Parameter(Mandatory)][bool]$TokenAvailable,
        [Parameter(Mandatory)][string]$BaselineStatus,
        [Parameter(Mandatory)][string]$BaselineSource,
        [AllowNull()][object]$Baseline,
        [Parameter(Mandatory)][object]$BaselineAssessment,
        [AllowNull()][object]$OfflineReport
    )

    return [ordered]@{
        schemaVersion = 1
        projectKey = $Identity.Key
        sonarUrl = $NormalizedSonarUrl
        startedAtUtc = [DateTime]::UtcNow.ToString(
            "O",
            [Globalization.CultureInfo]::InvariantCulture
        )
        initialCodeFingerprint = Get-SonarCodeFingerprint -RepositoryRoot $PSScriptRoot
        tokenAvailable = $TokenAvailable
        baselineStatus = $BaselineStatus
        baselineSource = $BaselineSource
        baseline = $Baseline
        baselineAssessment = $BaselineAssessment
        offlineReport = $OfflineReport
        lastCheckpoint = $null
    }
}

function Write-TechnicalEvidence {
    param(
        [Parameter(Mandatory)][object]$Result,
        [Parameter(Mandatory)][string]$Label
    )

    Write-Host "$Label - issues abertas: $($Result.IssueCount) (baseline: $($Result.BaselineIssueCount))"
    Write-Host "$Label - issues novas: $(@($Result.NewIssueKeys).Count)"
    Write-Host "$Label - HIGH/BLOCKER/CRITICAL: $(@($Result.HighOrBlockerIssueKeys).Count)"
    Write-Host "$Label - cobertura: $($Result.Coverage)% (mínimo: $MinimumCoverage%)"
    Write-Host "$Label - duplicação: $($Result.DuplicatedLinesDensity)% (máximo: $MaximumDuplication%)"
}

function Set-PendingHumanDecision {
    param(
        [Parameter(Mandatory)][object]$State,
        [Parameter(Mandatory)][string]$Decision
    )

    $target = $null
    $checkpointProperty = $State.PSObject.Properties["lastCheckpoint"]
    if ($null -ne $checkpointProperty -and $null -ne $checkpointProperty.Value -and
        $checkpointProperty.Value.humanDecision -eq "PENDING") {
        $target = $checkpointProperty.Value
    }
    else {
        $baselineProperty = $State.PSObject.Properties["baselineAssessment"]
        if ($null -ne $baselineProperty -and $null -ne $baselineProperty.Value -and
            $baselineProperty.Value.humanDecision -eq "PENDING") {
            $target = $baselineProperty.Value
        }
    }
    if ($null -eq $target) {
        throw "Não existe evidência NON_COMPLIANT com decisão humana pendente."
    }

    $target.humanDecision = switch ($Decision) {
        "Reprovar" { "REJECTED_BY_USER" }
        "AceitarExcepcionalmente" { "ACCEPTED_EXCEPTION" }
        "ContinuarAjustes" { "CONTINUE_ADJUSTMENTS" }
    }
    $target.decidedAtUtc = [DateTime]::UtcNow.ToString(
        "O",
        [Globalization.CultureInfo]::InvariantCulture
    )
}

function Test-SonarUnavailableError {
    param([Parameter(Mandatory)][Management.Automation.ErrorRecord]$ErrorRecord)

    return $ErrorRecord.Exception.Message -match
        "Não foi possível acessar o SonarQube|não informou status UP"
}

function Invoke-AnalysisSnapshot {
    param(
        [Parameter(Mandatory)][object]$Identity,
        [Parameter(Mandatory)][string]$NormalizedSonarUrl
    )

    $analyzerPath = Join-Path $PSScriptRoot "analisar-sonarqube.ps1"
    if (-not (Test-Path -LiteralPath $analyzerPath -PathType Leaf)) {
        throw "Analisador SonarQube ausente."
    }
    & $analyzerPath -ProjectKey $Identity.Key -ProjectName $Identity.Name -SonarUrl $NormalizedSonarUrl

    $metadataPath = Join-Path $PSScriptRoot "target/sonar/report-task.txt"
    if (-not (Test-Path -LiteralPath $metadataPath -PathType Leaf)) {
        throw "Metadados atuais da análise não encontrados."
    }
    if ((Get-Item -LiteralPath $metadataPath).Length -gt 1MB) {
        throw "Metadados da análise excedem o limite de 1 MB."
    }
    $reportTask = @{}
    foreach ($line in Get-Content -LiteralPath $metadataPath) {
        $separator = $line.IndexOf("=")
        if ($separator -gt 0) {
            $reportTask[$line.Substring(0, $separator)] = $line.Substring($separator + 1)
        }
    }
    if (-not $reportTask.ContainsKey("ceTaskUrl")) {
        throw "ceTaskUrl ausente nos metadados atuais da análise."
    }
    $ceTask = Wait-SonarComputeEngine -SonarUrl $NormalizedSonarUrl `
        -TaskUrl $reportTask.ceTaskUrl -TimeoutSec $ComputeEngineTimeoutSec
    $snapshot = Get-SonarQualitySnapshot -SonarUrl $NormalizedSonarUrl `
        -ProjectKey $Identity.Key
    return [pscustomobject]@{ ComputeEngineTask = $ceTask; Snapshot = $snapshot }
}

if (-not [string]::IsNullOrWhiteSpace($HumanDecision)) {
    if ($InitializeBaseline -or $OfflineOnlyBaseline -or
        -not [string]::IsNullOrWhiteSpace($OfflineReportPath)) {
        throw "HumanDecision não pode ser combinada com baseline ou pacote offline."
    }
    $decisionState = Read-SonarState
    Set-PendingHumanDecision -State $decisionState -Decision $HumanDecision
    Write-SonarAgentState -Path $statePath -State $decisionState
    Write-Host "Decisão humana registrada: $HumanDecision."
    return
}

if ($OfflineOnlyBaseline -and -not $InitializeBaseline) {
    throw "OfflineOnlyBaseline exige -InitializeBaseline."
}
if ($OfflineOnlyBaseline -and [string]::IsNullOrWhiteSpace($OfflineReportPath)) {
    throw "OfflineOnlyBaseline exige -OfflineReportPath."
}
if (-not $InitializeBaseline -and -not [string]::IsNullOrWhiteSpace($OfflineReportPath)) {
    throw "OfflineReportPath só pode ser usado com -InitializeBaseline."
}

$identity = Get-ProjectIdentity
$baseUri = Assert-SonarUrl -Url $SonarUrl
$normalizedSonarUrl = $baseUri.AbsoluteUri.TrimEnd("/")
$offlineReport = if (-not [string]::IsNullOrWhiteSpace($OfflineReportPath)) {
    Get-SonarOfflineReportSummary -ReportPath $OfflineReportPath -RepositoryRoot $PSScriptRoot
}
else {
    $null
}
$tokenAvailable = -not [string]::IsNullOrWhiteSpace(
    [Environment]::GetEnvironmentVariable("SONAR_TOKEN", "Process")
)

if ($OfflineOnlyBaseline) {
    $offlineAssessment = [pscustomobject]@{
        technicalStatus = "UNVERIFIED"
        humanDecision = "OFFLINE_BASELINE_SELECTED"
        decidedAtUtc = [DateTime]::UtcNow.ToString(
            "O",
            [Globalization.CultureInfo]::InvariantCulture
        )
        limitations = @(
            "O servidor SonarQube atual não foi consultado.",
            "Cobertura e duplicação atuais não foram verificadas.",
            "O pacote offline não comprova o estado atual das issues."
        )
    }
    $state = New-BaselineState -Identity $identity -NormalizedSonarUrl $normalizedSonarUrl `
        -TokenAvailable $tokenAvailable -BaselineStatus "OFFLINE_ONLY_READY" `
        -BaselineSource "OFFLINE_REPORT" -Baseline $null `
        -BaselineAssessment $offlineAssessment -OfflineReport $offlineReport
    Write-SonarAgentState -Path $statePath -State $state
    Write-Host "Baseline exclusivamente offline registrado: $($offlineReport.path)"
    Write-Warning "Status UNVERIFIED: servidor, cobertura, duplicação e issues atuais não foram verificados."
    return
}

if ($InitializeBaseline) {
    $baselineSource = if ($null -eq $offlineReport) {
        "LOCAL_SONAR"
    }
    else {
        "LOCAL_SONAR_WITH_OFFLINE_REPORT"
    }
    if (-not $tokenAvailable) {
        $assessment = New-UnverifiedAssessment -Limitations @(
            "SONAR_TOKEN indisponível no processo; o servidor SonarQube não foi consultado."
        )
        $state = New-BaselineState -Identity $identity -NormalizedSonarUrl $normalizedSonarUrl `
            -TokenAvailable $false -BaselineStatus "UNVERIFIED" `
            -BaselineSource $baselineSource -Baseline $null `
            -BaselineAssessment $assessment -OfflineReport $offlineReport
        Write-SonarAgentState -Path $statePath -State $state
        Write-Warning "Status UNVERIFIED: SONAR_TOKEN indisponível. Não informe o token no chat."
        return
    }

    try {
        $analysis = Invoke-AnalysisSnapshot -Identity $identity `
            -NormalizedSonarUrl $normalizedSonarUrl
    }
    catch {
        if (-not (Test-SonarUnavailableError -ErrorRecord $_)) {
            throw
        }
        $assessment = New-UnverifiedAssessment -Limitations @(
            "Servidor SonarQube indisponível; análise, cobertura, duplicação e issues atuais não foram verificadas."
        )
        $state = New-BaselineState -Identity $identity -NormalizedSonarUrl $normalizedSonarUrl `
            -TokenAvailable $true -BaselineStatus "UNVERIFIED" `
            -BaselineSource $baselineSource -Baseline $null `
            -BaselineAssessment $assessment -OfflineReport $offlineReport
        Write-SonarAgentState -Path $statePath -State $state
        Write-Warning "Status UNVERIFIED: servidor SonarQube indisponível."
        return
    }

    $snapshot = $analysis.Snapshot
    $comparison = Compare-SonarQualitySnapshot -Baseline $snapshot -Current $snapshot `
        -MinimumCoverage $MinimumCoverage -MaximumDuplication $MaximumDuplication
    $assessment = New-Assessment -Result $comparison
    $state = New-BaselineState -Identity $identity -NormalizedSonarUrl $normalizedSonarUrl `
        -TokenAvailable $true -BaselineStatus "READY" -BaselineSource $baselineSource `
        -Baseline $snapshot -BaselineAssessment $assessment -OfflineReport $offlineReport
    Write-SonarAgentState -Path $statePath -State $state
    Write-TechnicalEvidence -Result $comparison -Label "Baseline"
    if ($comparison.Passed) {
        Write-Host "Baseline tecnicamente conforme e registrado."
    }
    else {
        Write-Warning "Baseline NON_COMPLIANT; decisão humana pendente."
    }
    return
}

$state = Read-SonarState
if ($state.baselineStatus -eq "OFFLINE_ONLY_READY") {
    throw "O baseline atual é exclusivamente offline; crie um baseline local quando o servidor estiver disponível."
}
if ($state.baselineStatus -ne "READY" -or $null -eq $state.baseline) {
    throw "Baseline Sonar local não está READY."
}
if ($state.projectKey -ne $identity.Key -or
    ([uri]$state.sonarUrl).AbsoluteUri.TrimEnd("/") -ne $normalizedSonarUrl) {
    throw "ProjectKey ou SonarUrl não correspondem ao baseline da sessão."
}
if ($state.baselineAssessment.humanDecision -eq "PENDING" -or
    ($null -ne $state.lastCheckpoint -and $state.lastCheckpoint.humanDecision -eq "PENDING")) {
    throw "Existe decisão humana pendente antes de um novo checkpoint."
}

$fingerprint = Get-SonarCodeFingerprint -RepositoryRoot $PSScriptRoot
if (-not $tokenAvailable) {
    $state.lastCheckpoint = [pscustomobject]@{
        checkedAtUtc = [DateTime]::UtcNow.ToString(
            "O",
            [Globalization.CultureInfo]::InvariantCulture
        )
        codeFingerprint = $fingerprint
        technicalStatus = "UNVERIFIED"
        humanDecision = "NOT_REQUIRED"
        decidedAtUtc = $null
        limitations = @("SONAR_TOKEN indisponível; checkpoint atual não executado.")
    }
    Write-SonarAgentState -Path $statePath -State $state
    Write-Warning "Status UNVERIFIED: SONAR_TOKEN indisponível."
    return
}

try {
    $analysis = Invoke-AnalysisSnapshot -Identity $identity `
        -NormalizedSonarUrl $normalizedSonarUrl
}
catch {
    if (-not (Test-SonarUnavailableError -ErrorRecord $_)) {
        throw
    }
    $state.lastCheckpoint = [pscustomobject]@{
        checkedAtUtc = [DateTime]::UtcNow.ToString(
            "O",
            [Globalization.CultureInfo]::InvariantCulture
        )
        codeFingerprint = $fingerprint
        technicalStatus = "UNVERIFIED"
        humanDecision = "NOT_REQUIRED"
        decidedAtUtc = $null
        limitations = @("Servidor SonarQube indisponível; checkpoint atual não executado.")
    }
    Write-SonarAgentState -Path $statePath -State $state
    Write-Warning "Status UNVERIFIED: servidor SonarQube indisponível."
    return
}

$current = $analysis.Snapshot
$result = Compare-SonarQualitySnapshot -Baseline $state.baseline -Current $current `
    -MinimumCoverage $MinimumCoverage -MaximumDuplication $MaximumDuplication
$assessment = New-Assessment -Result $result
$state.lastCheckpoint = [pscustomobject]@{
    checkedAtUtc = [DateTime]::UtcNow.ToString(
        "O",
        [Globalization.CultureInfo]::InvariantCulture
    )
    codeFingerprint = $fingerprint
    technicalStatus = $assessment.technicalStatus
    humanDecision = $assessment.humanDecision
    decidedAtUtc = $assessment.decidedAtUtc
    computeEngineTaskId = [string]$analysis.ComputeEngineTask.id
    analysisKey = $current.analysisKey
    issueCount = $assessment.issueCount
    baselineIssueCount = $assessment.baselineIssueCount
    newIssueKeys = @($assessment.newIssueKeys)
    highOrBlockerIssueKeys = @($assessment.highOrBlockerIssueKeys)
    coverage = $assessment.coverage
    duplicatedLinesDensity = $assessment.duplicatedLinesDensity
    violations = @($assessment.violations)
    offlineReportPath = if ($null -eq $state.offlineReport) {
        $null
    }
    else {
        $state.offlineReport.path
    }
    offlineEvidenceStatus = if ($null -eq $state.offlineReport) {
        "NOT_SELECTED"
    }
    else {
        "REFERENCE_ONLY"
    }
}
Write-SonarAgentState -Path $statePath -State $state
Write-TechnicalEvidence -Result $result -Label "Checkpoint"
if ($result.Passed) {
    Write-Host "Situação técnica COMPLIANT; nenhuma decisão humana é necessária."
}
else {
    Write-Warning "Situação técnica NON_COMPLIANT; decisão humana pendente: Reprovar, AceitarExcepcionalmente ou ContinuarAjustes."
}
