$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repositoryRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot "../.."))
$modulePath = Join-Path $repositoryRoot ".codex/hooks/SonarQuality.psm1"
Import-Module $modulePath -Force

function New-SonarIssue {
    param(
        [Parameter(Mandatory)][string]$Key,
        [string]$Severity = "MAJOR",
        [string[]]$ImpactSeverities = @("MEDIUM")
    )

    $impacts = @($ImpactSeverities | ForEach-Object {
        [pscustomobject]@{
            softwareQuality = "MAINTAINABILITY"
            severity = $_
        }
    })
    return [pscustomobject]@{
        key = $Key
        severity = $Severity
        impacts = $impacts
    }
}

function New-SonarSnapshot {
    param(
        [object[]]$Issues,
        [double]$Coverage,
        [double]$Duplication
    )

    return [pscustomobject]@{
        issueCount = @($Issues).Count
        issues = @($Issues)
        metrics = [pscustomobject]@{
            coverage = $Coverage
            duplicatedLinesDensity = $Duplication
        }
    }
}

$baseline = New-SonarSnapshot -Issues @(
    (New-SonarIssue -Key "I1")
    (New-SonarIssue -Key "I2" -Severity "MINOR" -ImpactSeverities @("LOW"))
) -Coverage 85 -Duplication 5

$passing = Compare-SonarQualitySnapshot -Baseline $baseline -Current $baseline
if (-not $passing.Passed -or @($passing.Violations).Count -ne 0) {
    throw "Os limites inclusivos de cobertura e duplicacao deveriam passar."
}

$current = New-SonarSnapshot -Issues @(
    (New-SonarIssue -Key "I1")
    (New-SonarIssue -Key "I2" -Severity "MINOR" -ImpactSeverities @("LOW"))
    (New-SonarIssue -Key "I3" -ImpactSeverities @("HIGH"))
    (New-SonarIssue -Key "I4" -Severity "BLOCKER" -ImpactSeverities @())
    (New-SonarIssue -Key "I5" -Severity "CRITICAL" -ImpactSeverities @())
) -Coverage 84.9 -Duplication 5.1

$failing = Compare-SonarQualitySnapshot -Baseline $baseline -Current $current
$violationCodes = @($failing.Violations | ForEach-Object Code)
foreach ($expectedCode in @("NEW_ISSUES", "HIGH_OR_BLOCKER", "COVERAGE", "DUPLICATION")) {
    if ($violationCodes -notcontains $expectedCode) {
        throw "Violacao esperada ausente: $expectedCode"
    }
}
if ($failing.Passed -or @($failing.NewIssueKeys).Count -ne 3) {
    throw "O gate nao contabilizou corretamente as issues novas."
}
foreach ($expectedKey in @("I3", "I4", "I5")) {
    if ($failing.HighOrBlockerIssueKeys -notcontains $expectedKey) {
        throw "Severidade bloqueante nao reconhecida para $expectedKey."
    }
}

$invalidSnapshot = [pscustomobject]@{
    issueCount = 0
    issues = @()
    metrics = [pscustomobject]@{ coverage = "invalida"; duplicatedLinesDensity = 0 }
}
$invalidFailed = $false
try {
    Compare-SonarQualitySnapshot -Baseline $baseline -Current $invalidSnapshot | Out-Null
}
catch {
    $invalidFailed = $_.Exception.Message -match "coverage"
}
if (-not $invalidFailed) {
    throw "Metrica invalida nao falhou de forma fechada."
}

$outOfRangeSnapshot = New-SonarSnapshot -Issues @() -Coverage 101 -Duplication 0
$outOfRangeFailed = $false
try {
    Compare-SonarQualitySnapshot -Baseline $baseline -Current $outOfRangeSnapshot | Out-Null
}
catch {
    $outOfRangeFailed = $_.Exception.Message -match "coverage"
}
if (-not $outOfRangeFailed) {
    throw "Metrica percentual acima de 100 nao falhou de forma fechada."
}

Write-Host "GREEN: politica Sonar 85/5, issues novas e severidades bloqueantes aprovadas."
