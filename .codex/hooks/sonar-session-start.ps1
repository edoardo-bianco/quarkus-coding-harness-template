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

function Read-ExistingState {
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

$repositoryRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot "../.."))
$modulePath = Join-Path $PSScriptRoot "SonarQuality.psm1"
Import-Module $modulePath -Force

$rawHookInput = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($rawHookInput)) {
    $rawHookInput = (@($input) -join [Environment]::NewLine)
}
$inputData = Read-HookInput -ExpectedEvent "SessionStart" -RawInput $rawHookInput
$sessionId = [string](Get-StateProperty -State $inputData -Name "session_id")
$source = [string](Get-StateProperty -State $inputData -Name "source")
if ([string]::IsNullOrWhiteSpace($sessionId) -or $sessionId.Length -gt 500 -or
    $sessionId -match "[\x00-\x1F\x7F]" -or
    $source -notin @("startup", "resume", "clear", "compact")) {
    throw "Entrada de SessionStart inválida."
}

$statePath = Join-Path (Get-SonarAgentStateDirectory -RepositoryRoot $repositoryRoot) `
    "session.json"
$fingerprint = Get-SonarCodeFingerprint -RepositoryRoot $repositoryRoot
$tokenAvailable = -not [string]::IsNullOrWhiteSpace(
    [Environment]::GetEnvironmentVariable("SONAR_TOKEN", "Process")
)
$state = Read-ExistingState -Path $statePath
$baselineWasAbsent = $null -eq $state
if ($baselineWasAbsent) {
    $state = [ordered]@{
        schemaVersion = 1
        sessionId = $sessionId
        sessionStartedAtUtc = [DateTime]::UtcNow.ToString(
            "O",
            [Globalization.CultureInfo]::InvariantCulture
        )
        sessionInitialCodeFingerprint = $fingerprint
        initialCodeFingerprint = $fingerprint
        tokenAvailable = $tokenAvailable
        baselineStatus = "NOT_REQUIRED_UNTIL_CODE_CHANGE"
        baseline = $null
        baselineAssessment = $null
        offlineReport = $null
        lastCheckpoint = $null
    }
}
else {
    $state | Add-Member -NotePropertyName "sessionId" -NotePropertyValue $sessionId -Force
    $state | Add-Member -NotePropertyName "sessionStartedAtUtc" -NotePropertyValue (
        [DateTime]::UtcNow.ToString("O", [Globalization.CultureInfo]::InvariantCulture)
    ) -Force
    $state | Add-Member -NotePropertyName "sessionInitialCodeFingerprint" `
        -NotePropertyValue $fingerprint -Force
    $state | Add-Member -NotePropertyName "tokenAvailable" `
        -NotePropertyValue $tokenAvailable -Force
}
Write-SonarAgentState -Path $statePath -State $state

$message = if ($baselineWasAbsent) {
    "Tarefas exclusivamente documentais dispensam token, baseline e checkpoint SonarQube. " +
    "O baseline local ainda está ausente; antes da primeira mudança executável, verifique as " +
    "fontes permitidas e execute ./validar-checkpoint-sonarqube.ps1 -InitializeBaseline."
}
else {
    $baselineStatus = [string](Get-StateProperty -State $state -Name "baselineStatus")
    if ($baselineStatus -eq "READY") {
        "Tarefas exclusivamente documentais dispensam SonarQube. Para mudança executável, " +
        "preserve o baseline e execute o checkpoint após o incremento coerente."
    }
    elseif ($baselineStatus -eq "OFFLINE_ONLY_READY") {
        "Tarefas exclusivamente documentais dispensam SonarQube. O baseline atual é somente " +
        "offline e permanece UNVERIFIED para qualquer mudança executável."
    }
    else {
        "Tarefas exclusivamente documentais dispensam token, baseline e checkpoint SonarQube. " +
        "O baseline não está READY para uma mudança executável."
    }
}
if (-not $tokenAvailable) {
    $message += " Não informe token no chat; quando uma análise for necessária, inicie uma nova " +
        "sessão com ./iniciar-codex-com-sonar.ps1."
}
[pscustomobject]@{ continue = $true; systemMessage = $message } |
    ConvertTo-Json -Compress
