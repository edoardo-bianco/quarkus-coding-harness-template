$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repositoryRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot "../.."))
$checkpointSource = Join-Path $repositoryRoot "validar-checkpoint-sonarqube.ps1"
if (-not (Test-Path -LiteralPath $checkpointSource -PathType Leaf)) {
    throw "Orquestrador de checkpoint Sonar ausente: $checkpointSource"
}

$testRoot = Join-Path ([IO.Path]::GetTempPath()) (
    "sonar-human-flow-" + [guid]::NewGuid().ToString("N")
)
$checkpointPath = Join-Path $testRoot "validar-checkpoint-sonarqube.ps1"
$moduleDirectory = Join-Path $testRoot ".codex/hooks"
$offlinePackage = Join-Path $testRoot "sonar/referencia-externa"
$wrapperPath = Join-Path $testRoot "mvnw.cmd"
$previousToken = [Environment]::GetEnvironmentVariable("SONAR_TOKEN", "Process")
$syntheticSecret = "credencial-sintetica-" + [guid]::NewGuid().ToString("N")
$global:humanFlowMode = "baseline"
$global:humanFlowRequestCount = 0
$global:humanFlowServerUnavailable = $false

function global:Invoke-RestMethod {
    param($Method, $Uri, $Headers, $TimeoutSec)

    $global:humanFlowRequestCount++
    $requestUri = [uri]$Uri
    if ($requestUri.AbsolutePath -eq "/api/system/status") {
        if ($global:humanFlowServerUnavailable) {
            throw "servidor-sintetico-indisponivel"
        }
        return [pscustomobject]@{ status = "UP" }
    }
    if ($Headers.Authorization -ne "Bearer $syntheticSecret") {
        throw "Header de autenticação sintético incorreto."
    }

    switch ($requestUri.AbsolutePath) {
        "/api/ce/task" {
            return [pscustomobject]@{
                task = [pscustomobject]@{ id = "CE1"; status = "SUCCESS" }
            }
        }
        "/api/project_analyses/search" {
            return [pscustomobject]@{
                analyses = @([pscustomobject]@{
                    key = if ($global:humanFlowMode -eq "baseline") {
                        "BASE-1"
                    }
                    else {
                        "CURRENT-1"
                    }
                    revision = "abc123"
                })
            }
        }
        "/api/measures/component" {
            $coverage = if ($global:humanFlowMode -eq "baseline") { "86.5" } else { "80.0" }
            $duplication = if ($global:humanFlowMode -eq "baseline") { "4.5" } else { "6.0" }
            return [pscustomobject]@{
                component = [pscustomobject]@{ measures = @(
                    [pscustomobject]@{ metric = "coverage"; value = $coverage },
                    [pscustomobject]@{ metric = "duplicated_lines_density"; value = $duplication }
                ) }
            }
        }
        "/api/issues/search" {
            $issues = @([pscustomobject]@{
                key = "I1"
                severity = "MAJOR"
                impacts = @([pscustomobject]@{ severity = "MEDIUM" })
            })
            if ($global:humanFlowMode -ne "baseline") {
                $issues += [pscustomobject]@{
                    key = "I2"
                    severity = "BLOCKER"
                    impacts = @([pscustomobject]@{ severity = "HIGH" })
                }
            }
            return [pscustomobject]@{
                paging = [pscustomobject]@{
                    pageIndex = 1
                    pageSize = 500
                    total = $issues.Count
                }
                issues = $issues
            }
        }
        default {
            throw "Endpoint sintético inesperado: $($requestUri.AbsolutePath)"
        }
    }
}

try {
    New-Item -ItemType Directory -Path $moduleDirectory -Force | Out-Null
    New-Item -ItemType Directory -Path $offlinePackage -Force | Out-Null
    Copy-Item -LiteralPath $checkpointSource -Destination $checkpointPath
    Copy-Item -LiteralPath (Join-Path $repositoryRoot "analisar-sonarqube.ps1") `
        -Destination (Join-Path $testRoot "analisar-sonarqube.ps1")
    Copy-Item -LiteralPath (Join-Path $repositoryRoot ".codex/hooks/SonarQuality.psm1") `
        -Destination (Join-Path $moduleDirectory "SonarQuality.psm1")

    @'
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0">
    <modelVersion>4.0.0</modelVersion>
    <groupId>fixture.group</groupId>
    <artifactId>fixture-artifact</artifactId>
    <version>1.0.0-SNAPSHOT</version>
    <name>Fixture Project</name>
</project>
'@ | Set-Content -LiteralPath (Join-Path $testRoot "pom.xml") -Encoding UTF8
    @'
@echo off
set "WRAPPER_DIR=%~dp0"
if "%SONAR_TOKEN%"=="" exit /b 91
if not exist "%WRAPPER_DIR%target\sonar" mkdir "%WRAPPER_DIR%target\sonar"
> "%WRAPPER_DIR%target\sonar\report-task.txt" echo ceTaskId=CE1
>> "%WRAPPER_DIR%target\sonar\report-task.txt" echo ceTaskUrl=http://localhost:9000/api/ce/task?id=CE1
exit /b 0
'@ | Set-Content -LiteralPath $wrapperPath -Encoding Ascii
    [pscustomobject]@{
        projectKey = "fixture.external"
        sonarUrl = "https://sonar.exemplo.invalid"
    } | ConvertTo-Json | Set-Content `
        -LiteralPath (Join-Path $offlinePackage "manifest.json") -Encoding UTF8
    @(
        [pscustomobject]@{ key = "EXT-1"; severity = "HIGH"; rule = "java:S1" },
        [pscustomobject]@{ key = "EXT-2"; severity = "MEDIUM"; rule = "java:S2" }
    ) | ConvertTo-Json | Set-Content `
        -LiteralPath (Join-Path $offlinePackage "issues.json") -Encoding UTF8

    [Environment]::SetEnvironmentVariable("SONAR_TOKEN", $syntheticSecret, "Process")
    & $checkpointPath -InitializeBaseline -OfflineReportPath $offlinePackage

    $statePath = Join-Path $testRoot ".codex/.state/session.json"
    $baselineState = Get-Content -Raw -LiteralPath $statePath | ConvertFrom-Json
    if ($baselineState.projectKey -ne "fixture.group:fixture-artifact" -or
        $baselineState.baselineStatus -ne "READY" -or
        $baselineState.baselineSource -ne "LOCAL_SONAR_WITH_OFFLINE_REPORT" -or
        $baselineState.baseline.analysisKey -ne "BASE-1" -or
        $baselineState.baselineAssessment.technicalStatus -ne "COMPLIANT" -or
        $baselineState.offlineReport.issueCount -ne 2 -or
        $baselineState.initialCodeFingerprint -notmatch "^[a-f0-9]{64}$") {
        throw "O baseline local combinado com evidência offline está incorreto."
    }

    $noPendingFailed = $false
    try {
        & $checkpointPath -HumanDecision "Reprovar"
    }
    catch {
        $noPendingFailed = $_.Exception.Message -match "pendente"
    }
    if (-not $noPendingFailed) {
        throw "Uma decisão foi registrada sem evidência NON_COMPLIANT pendente."
    }

    New-Item -ItemType Directory -Path (Join-Path $testRoot "src/main/java") -Force | Out-Null
    Set-Content -LiteralPath (Join-Path $testRoot "src/main/java/Fixture.java") `
        -Value "final class Fixture {}" -Encoding UTF8
    $global:humanFlowMode = "current"
    & $checkpointPath

    $pendingStateText = Get-Content -Raw -LiteralPath $statePath
    $pendingState = $pendingStateText | ConvertFrom-Json
    if ($pendingState.lastCheckpoint.technicalStatus -ne "NON_COMPLIANT" -or
        $pendingState.lastCheckpoint.humanDecision -ne "PENDING" -or
        @($pendingState.lastCheckpoint.violations).Count -ne 4 -or
        $pendingState.lastCheckpoint.codeFingerprint -eq $pendingState.initialCodeFingerprint -or
        $pendingState.lastCheckpoint.analysisKey -ne "CURRENT-1") {
        throw "A não conformidade ou o fingerprint do checkpoint está incorreto."
    }

    $decisionMappings = [ordered]@{
        Reprovar = "REJECTED_BY_USER"
        AceitarExcepcionalmente = "ACCEPTED_EXCEPTION"
        ContinuarAjustes = "CONTINUE_ADJUSTMENTS"
    }
    foreach ($entry in $decisionMappings.GetEnumerator()) {
        [IO.File]::WriteAllText($statePath, $pendingStateText, [Text.UTF8Encoding]::new($false))
        & $checkpointPath -HumanDecision $entry.Key
        $decisionState = Get-Content -Raw -LiteralPath $statePath | ConvertFrom-Json
        if ($decisionState.lastCheckpoint.humanDecision -ne $entry.Value -or
            [string]::IsNullOrWhiteSpace([string]$decisionState.lastCheckpoint.decidedAtUtc)) {
            throw "A decisão $($entry.Key) não foi registrada corretamente."
        }
    }

    $requestsBeforeMissingToken = $global:humanFlowRequestCount
    [Environment]::SetEnvironmentVariable("SONAR_TOKEN", $null, "Process")
    & $checkpointPath -InitializeBaseline
    $missingTokenStateText = Get-Content -Raw -LiteralPath $statePath
    $missingTokenState = $missingTokenStateText | ConvertFrom-Json
    if ($missingTokenState.baselineStatus -ne "UNVERIFIED" -or
        $missingTokenState.baselineAssessment.technicalStatus -ne "UNVERIFIED" -or
        $missingTokenState.tokenAvailable -ne $false -or
        $global:humanFlowRequestCount -ne $requestsBeforeMissingToken -or
        $missingTokenStateText.Contains($syntheticSecret, [StringComparison]::Ordinal)) {
        throw "A ausência de credencial não foi registrada como UNVERIFIED de forma segura."
    }

    [Environment]::SetEnvironmentVariable("SONAR_TOKEN", $syntheticSecret, "Process")
    $global:humanFlowServerUnavailable = $true
    & $checkpointPath -InitializeBaseline
    $unavailableState = Get-Content -Raw -LiteralPath $statePath | ConvertFrom-Json
    if ($unavailableState.baselineStatus -ne "UNVERIFIED" -or
        $unavailableState.baselineAssessment.technicalStatus -ne "UNVERIFIED" -or
        (@($unavailableState.baselineAssessment.limitations) -join " ") -notmatch "indisponível") {
        throw "A indisponibilidade do servidor não foi registrada como UNVERIFIED."
    }

    Write-Host "GREEN: baseline, fingerprint, indisponibilidade e três decisões humanas aprovados."
}
finally {
    Remove-Item Function:\Invoke-RestMethod -ErrorAction SilentlyContinue
    Remove-Variable humanFlowMode -Scope Global -ErrorAction SilentlyContinue
    Remove-Variable humanFlowRequestCount -Scope Global -ErrorAction SilentlyContinue
    Remove-Variable humanFlowServerUnavailable -Scope Global -ErrorAction SilentlyContinue
    [Environment]::SetEnvironmentVariable("SONAR_TOKEN", $previousToken, "Process")
    $resolvedTempRoot = [IO.Path]::GetFullPath([IO.Path]::GetTempPath())
    $resolvedTestRoot = [IO.Path]::GetFullPath($testRoot)
    if ($resolvedTestRoot.StartsWith($resolvedTempRoot, [StringComparison]::OrdinalIgnoreCase) -and
        (Test-Path -LiteralPath $resolvedTestRoot)) {
        Remove-Item -LiteralPath $resolvedTestRoot -Recurse -Force
    }
}
