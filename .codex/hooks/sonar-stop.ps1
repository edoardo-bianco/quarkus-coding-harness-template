$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
try {
    [Console]::InputEncoding = [Text.Encoding]::UTF8
    [Console]::OutputEncoding = [Text.Encoding]::UTF8
}
catch {}

function Read-HookInput {
    param(
        [Parameter(Mandatory)][string]$ExpectedEvent,
        [Parameter(Mandatory)][string]$RawInput
    )

    if ([string]::IsNullOrWhiteSpace($RawInput) -or $RawInput.Length -gt 65536) {
        throw "$ExpectedEvent exige entrada JSON válida e limitada a 64 KiB."
    }
    try {
        $inputData = $RawInput | ConvertFrom-Json -Depth 10
    }
    catch {
        throw "$ExpectedEvent recebeu entrada JSON inválida."
    }
    $eventProperty = $inputData.PSObject.Properties["hook_event_name"]
    if ($null -eq $eventProperty -or [string]$eventProperty.Value -ne $ExpectedEvent) {
        throw "Evento de hook inválido; esperado $ExpectedEvent."
    }
    return $inputData
}

function Get-StateProperty {
    param(
        [AllowNull()][object]$State,
        [Parameter(Mandatory)][string]$Name
    )

    if ($null -eq $State) {
        return $null
    }
    $property = $State.PSObject.Properties[$Name]
    if ($null -eq $property) {
        return $null
    }
    return $property.Value
}

function Write-HookResult {
    param([string]$SystemMessage = "")

    $result = [ordered]@{ continue = $true }
    if (-not [string]::IsNullOrWhiteSpace($SystemMessage)) {
        $result.systemMessage = $SystemMessage
    }
    [pscustomobject]$result | ConvertTo-Json -Compress
}

function Read-SonarHookState {
    param([Parameter(Mandatory)][string]$Path)

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        return $null
    }
    $item = Get-Item -LiteralPath $Path -Force
    if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0 -or
        $item.Length -gt 20MB) {
        throw "Estado SonarQube inválido."
    }
    try {
        $state = Get-Content -Raw -LiteralPath $Path | ConvertFrom-Json -Depth 30
    }
    catch {
        throw "Estado SonarQube inválido."
    }
    if ((Get-StateProperty -State $state -Name "schemaVersion") -ne 1) {
        throw "Estado SonarQube inválido ou incompatível."
    }
    return $state
}

function Get-PendingDecisionMessage {
    return "A situação técnica está NON_COMPLIANT e aguarda decisão humana. Apresente as " +
        "evidências e solicite Reprovar, AceitarExcepcionalmente ou ContinuarAjustes; " +
        "registre somente a resposta explícita com -HumanDecision."
}

$repositoryRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot "../.."))
Import-Module (Join-Path $PSScriptRoot "SonarQuality.psm1") -Force
$rawHookInput = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($rawHookInput)) {
    $rawHookInput = (@($input) -join [Environment]::NewLine)
}
$null = Read-HookInput -ExpectedEvent "Stop" -RawInput $rawHookInput
$statePath = Join-Path (Get-SonarAgentStateDirectory -RepositoryRoot $repositoryRoot) `
    "session.json"
$state = Read-SonarHookState -Path $statePath
if ($null -eq $state) {
    Write-HookResult -SystemMessage (
        "Estado e baseline SonarQube da sessão estão ausentes. Antes de uma mudança executável, " +
        "execute ./validar-checkpoint-sonarqube.ps1 -InitializeBaseline. O hook não decide " +
        "aprovação ou reprovação."
    )
    return
}

$currentFingerprint = Get-SonarCodeFingerprint -RepositoryRoot $repositoryRoot
$baselineAssessment = Get-StateProperty -State $state -Name "baselineAssessment"
if ([string](Get-StateProperty -State $baselineAssessment -Name "humanDecision") -eq "PENDING") {
    Write-HookResult -SystemMessage (Get-PendingDecisionMessage)
    return
}

$lastCheckpoint = Get-StateProperty -State $state -Name "lastCheckpoint"
$checkpointDecision = [string](
    Get-StateProperty -State $lastCheckpoint -Name "humanDecision"
)
if ($checkpointDecision -eq "PENDING") {
    Write-HookResult -SystemMessage (Get-PendingDecisionMessage)
    return
}
$checkpointFingerprint = [string](
    Get-StateProperty -State $lastCheckpoint -Name "codeFingerprint"
)
if ($null -ne $lastCheckpoint -and $checkpointFingerprint -eq $currentFingerprint) {
    switch ($checkpointDecision) {
        "REJECTED_BY_USER" {
            Write-HookResult -SystemMessage (
                "A decisão humana Reprovar está registrada para o fingerprint atual. " +
                "O hook não a altera nem autoriza publicação."
            )
            return
        }
        "CONTINUE_ADJUSTMENTS" {
            Write-HookResult -SystemMessage (
                "A decisão humana ContinuarAjustes está registrada para o fingerprint atual; " +
                "ela não representa aprovação."
            )
            return
        }
        "ACCEPTED_EXCEPTION" {
            Write-HookResult -SystemMessage (
                "A decisão humana AceitarExcepcionalmente está registrada para o fingerprint " +
                "atual; preserve a situação técnica no relato."
            )
            return
        }
    }
    if ([string](Get-StateProperty -State $lastCheckpoint -Name "technicalStatus") -eq
        "UNVERIFIED") {
        Write-HookResult -SystemMessage (
            "O checkpoint do fingerprint atual está UNVERIFIED. Preserve a limitação; o hook " +
            "não a converte em aprovação ou reprovação."
        )
        return
    }
    Write-HookResult
    return
}

$baselineStatus = [string](Get-StateProperty -State $state -Name "baselineStatus")
$initialFingerprint = [string](
    Get-StateProperty -State $state -Name "initialCodeFingerprint"
)
if ($currentFingerprint -eq $initialFingerprint) {
    Write-HookResult
    return
}

if ($baselineStatus -eq "OFFLINE_ONLY_READY") {
    Write-HookResult -SystemMessage (
        "Há mudança executável usando somente baseline offline. Execute os testes locais e " +
        "registre o estado UNVERIFIED; não declare Quality Gate aprovado nem reprove " +
        "automaticamente."
    )
    return
}
if ($baselineStatus -ne "READY" -or
    $null -eq (Get-StateProperty -State $state -Name "baseline")) {
    Write-HookResult -SystemMessage (
        "O baseline SonarQube não está READY para a mudança executável atual. Execute " +
        "./validar-checkpoint-sonarqube.ps1 -InitializeBaseline conforme a fonte autorizada; " +
        "o hook não decide aprovação ou reprovação."
    )
    return
}

Write-HookResult -SystemMessage (
    "Há mudança executável sem checkpoint SonarQube para o fingerprint atual. Execute " +
    "./validar-checkpoint-sonarqube.ps1 após o incremento coerente. O hook não decide " +
    "aprovação ou reprovação."
)
