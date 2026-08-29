$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repositoryRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot "../.."))
$hooksPath = Join-Path $repositoryRoot ".codex/hooks.json"
$sessionHookPath = Join-Path $repositoryRoot ".codex/hooks/sonar-session-start.ps1"
$stopHookPath = Join-Path $repositoryRoot ".codex/hooks/sonar-stop.ps1"
$qualityModulePath = Join-Path $repositoryRoot ".codex/hooks/SonarQuality.psm1"

$hooks = Get-Content -Raw -LiteralPath $hooksPath | ConvertFrom-Json -Depth 20
$eventNames = @($hooks.hooks.PSObject.Properties.Name | Sort-Object)
if (($eventNames -join ",") -ne "SessionStart,Stop") {
    throw "A configuração deve conter somente SessionStart e Stop."
}
if ([string]$hooks.description -match "edo|chatbot|simtr|hub|projectKey|localhost:9000") {
    throw "A configuração dos hooks contém identidade ou default da referência."
}

$sessionGroups = @($hooks.hooks.SessionStart)
$stopGroups = @($hooks.hooks.Stop)
if ($sessionGroups.Count -ne 1 -or @($sessionGroups[0].hooks).Count -ne 1 -or
    $stopGroups.Count -ne 1 -or @($stopGroups[0].hooks).Count -ne 1) {
    throw "Cada evento deve possuir um único handler."
}
if ($sessionGroups[0].matcher -ne "startup|resume|clear|compact") {
    throw "SessionStart não cobre as fontes oficiais previstas."
}
if ($null -ne $stopGroups[0].PSObject.Properties["matcher"]) {
    throw "Stop não deve declarar matcher ignorado pelo Codex."
}
foreach ($handler in @($sessionGroups[0].hooks[0], $stopGroups[0].hooks[0])) {
    if ($handler.type -ne "command" -or
        [string]$handler.command -notmatch "git rev-parse --show-toplevel" -or
        [string]::IsNullOrWhiteSpace([string]$handler.commandWindows) -or
        [int]$handler.timeout -lt 1 -or [int]$handler.timeout -gt 60) {
        throw "Handler de hook incompatível com o contrato local."
    }
}

foreach ($scriptPath in @($sessionHookPath, $stopHookPath)) {
    $parseErrors = $null
    [Management.Automation.Language.Parser]::ParseFile(
        $scriptPath,
        [ref]$null,
        [ref]$parseErrors
    ) | Out-Null
    if ($parseErrors.Count -ne 0) {
        throw "Falha de sintaxe em $scriptPath."
    }
}

$testRoot = Join-Path ([IO.Path]::GetTempPath()) `
    ("sonar-agent-hooks-" + [guid]::NewGuid().ToString("N"))
$fixtureHooks = Join-Path $testRoot ".codex/hooks"
$previousToken = [Environment]::GetEnvironmentVariable("SONAR_TOKEN", "Process")
try {
    New-Item -ItemType Directory -Path $fixtureHooks -Force | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $testRoot "src/main") -Force | Out-Null
    Copy-Item -LiteralPath $hooksPath -Destination (Join-Path $testRoot ".codex/hooks.json")
    Copy-Item -LiteralPath $sessionHookPath -Destination $fixtureHooks
    Copy-Item -LiteralPath $stopHookPath -Destination $fixtureHooks
    Copy-Item -LiteralPath $qualityModulePath -Destination $fixtureHooks
    Set-Content -LiteralPath (Join-Path $testRoot "pom.xml") -Value "<project />"
    Set-Content -LiteralPath (Join-Path $testRoot "src/main/code.txt") -Value "code-1"
    [Environment]::SetEnvironmentVariable("SONAR_TOKEN", $null, "Process")

    $fixtureSessionHook = Join-Path $fixtureHooks "sonar-session-start.ps1"
    $fixtureStopHook = Join-Path $fixtureHooks "sonar-stop.ps1"
    $sessionInput = [pscustomobject]@{
        session_id = "session-test"
        cwd = $testRoot
        hook_event_name = "SessionStart"
        source = "startup"
    } | ConvertTo-Json -Compress
    $sessionOutput = $sessionInput | & $fixtureSessionHook | ConvertFrom-Json -Depth 20
    if ($sessionOutput.continue -ne $true -or
        $sessionOutput.systemMessage -notmatch "documenta" -or
        $sessionOutput.systemMessage -notmatch "baseline" -or
        $null -ne $sessionOutput.PSObject.Properties["decision"] -or
        $null -ne $sessionOutput.PSObject.Properties["stopReason"]) {
        throw "SessionStart não produziu o lembrete não bloqueante esperado."
    }
    if ($sessionOutput.systemMessage -match "sonar_[A-Za-z0-9_-]{20,}") {
        throw "SessionStart expôs valor com formato de token."
    }

    $statePath = Join-Path $testRoot ".codex/.state/session.json"
    $state = Get-Content -Raw -LiteralPath $statePath | ConvertFrom-Json -Depth 20
    if ($state.schemaVersion -ne 1 -or $state.sessionId -ne "session-test" -or
        $state.tokenAvailable -ne $false -or
        $state.baselineStatus -ne "NOT_REQUIRED_UNTIL_CODE_CHANGE" -or
        $null -ne $state.PSObject.Properties["projectKey"] -or
        $null -ne $state.PSObject.Properties["sonarUrl"]) {
        throw "O estado inicial do hook contém identidade, default ou valor inesperado."
    }

    $wrongEventFailed = $false
    try {
        '{"hook_event_name":"Stop"}' | & $fixtureSessionHook | Out-Null
    }
    catch {
        $wrongEventFailed = $_.Exception.Message -match "SessionStart"
    }
    if (-not $wrongEventFailed) {
        throw "SessionStart aceitou evento JSON incorreto."
    }

    Set-Content -LiteralPath (Join-Path $testRoot "root-tool.ps1") -Value "tool-1"
    $stopInput = [pscustomobject]@{
        session_id = "session-test"
        cwd = $testRoot
        hook_event_name = "Stop"
        stop_hook_active = $false
    } | ConvertTo-Json -Compress
    $missingBaselineOutput = $stopInput | & $fixtureStopHook |
        ConvertFrom-Json -Depth 20
    if ($missingBaselineOutput.continue -ne $true -or
        $missingBaselineOutput.systemMessage -notmatch "baseline" -or
        $missingBaselineOutput.systemMessage -notmatch "InitializeBaseline" -or
        $missingBaselineOutput.systemMessage -match
            "Reprovar|AceitarExcepcionalmente|ContinuarAjustes" -or
        $null -ne $missingBaselineOutput.PSObject.Properties["decision"] -or
        $null -ne $missingBaselineOutput.PSObject.Properties["stopReason"]) {
        throw "Stop não lembrou o baseline ausente de forma não bloqueante."
    }

    Import-Module (Join-Path $fixtureHooks "SonarQuality.psm1") -Force
    $currentFingerprint = Get-SonarCodeFingerprint -RepositoryRoot $testRoot
    $pendingState = [ordered]@{
        schemaVersion = 1
        initialCodeFingerprint = $currentFingerprint
        baselineStatus = "READY"
        baseline = [pscustomobject]@{}
        baselineAssessment = [pscustomobject]@{
            technicalStatus = "NON_COMPLIANT"
            humanDecision = "PENDING"
        }
        lastCheckpoint = $null
    }
    Write-SonarAgentState -Path $statePath -State $pendingState
    $pendingOutput = $stopInput | & $fixtureStopHook | ConvertFrom-Json -Depth 20
    foreach ($decision in @("Reprovar", "AceitarExcepcionalmente", "ContinuarAjustes")) {
        if ($pendingOutput.systemMessage -notmatch $decision) {
            throw "Stop não lembrou a decisão humana $decision."
        }
    }
    if ($pendingOutput.continue -ne $true -or
        $null -ne $pendingOutput.PSObject.Properties["decision"] -or
        $null -ne $pendingOutput.PSObject.Properties["stopReason"]) {
        throw "Stop tentou decidir ou bloquear a não conformidade."
    }

    $stalePendingState = [ordered]@{
        schemaVersion = 1
        initialCodeFingerprint = $currentFingerprint
        baselineStatus = "READY"
        baseline = [pscustomobject]@{}
        baselineAssessment = [pscustomobject]@{
            technicalStatus = "COMPLIANT"
            humanDecision = "NOT_REQUIRED"
        }
        lastCheckpoint = [pscustomobject]@{
            codeFingerprint = "fingerprint-anterior"
            technicalStatus = "NON_COMPLIANT"
            humanDecision = "PENDING"
        }
    }
    Write-SonarAgentState -Path $statePath -State $stalePendingState
    $stalePendingOutput = $stopInput | & $fixtureStopHook |
        ConvertFrom-Json -Depth 20
    if ($stalePendingOutput.systemMessage -notmatch "ContinuarAjustes" -or
        $stalePendingOutput.continue -ne $true -or
        $null -ne $stalePendingOutput.PSObject.Properties["decision"]) {
        throw "Stop ocultou decisão pendente de um fingerprint anterior."
    }

    Write-Host "GREEN: configuração, eventos e lembretes dos hooks aprovados."
}
finally {
    [Environment]::SetEnvironmentVariable("SONAR_TOKEN", $previousToken, "Process")
    if (Test-Path -LiteralPath $testRoot) {
        Remove-Item -LiteralPath $testRoot -Recurse -Force
    }
}
