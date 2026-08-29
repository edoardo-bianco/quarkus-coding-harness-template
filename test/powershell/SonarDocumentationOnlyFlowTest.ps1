$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repositoryRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot "../.."))
$hooksPath = Join-Path $repositoryRoot ".codex/hooks.json"
$sessionHookPath = Join-Path $repositoryRoot ".codex/hooks/sonar-session-start.ps1"
$stopHookPath = Join-Path $repositoryRoot ".codex/hooks/sonar-stop.ps1"
$qualityModulePath = Join-Path $repositoryRoot ".codex/hooks/SonarQuality.psm1"
$testRoot = Join-Path ([IO.Path]::GetTempPath()) `
    ("sonar-documentation-only-" + [guid]::NewGuid().ToString("N"))
$fixtureHooks = Join-Path $testRoot ".codex/hooks"
$previousToken = [Environment]::GetEnvironmentVariable("SONAR_TOKEN", "Process")

try {
    New-Item -ItemType Directory -Path $fixtureHooks -Force | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $testRoot "src/main") -Force | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $testRoot "doc") -Force | Out-Null
    Copy-Item -LiteralPath $hooksPath -Destination (Join-Path $testRoot ".codex/hooks.json")
    Copy-Item -LiteralPath $sessionHookPath -Destination $fixtureHooks
    Copy-Item -LiteralPath $stopHookPath -Destination $fixtureHooks
    Copy-Item -LiteralPath $qualityModulePath -Destination $fixtureHooks
    Set-Content -LiteralPath (Join-Path $testRoot "pom.xml") -Value "<project />"
    Set-Content -LiteralPath (Join-Path $testRoot "src/main/code.txt") -Value "code-1"
    [Environment]::SetEnvironmentVariable("SONAR_TOKEN", $null, "Process")

    $sessionInput = [pscustomobject]@{
        session_id = "session-documentation-only"
        cwd = $testRoot
        hook_event_name = "SessionStart"
        source = "startup"
    } | ConvertTo-Json -Compress
    $sessionOutput = $sessionInput |
        & (Join-Path $fixtureHooks "sonar-session-start.ps1") |
        ConvertFrom-Json -Depth 20
    if ($sessionOutput.continue -ne $true -or
        $sessionOutput.systemMessage -notmatch "documenta") {
        throw "SessionStart não informou a isenção documental."
    }

    Set-Content -LiteralPath (Join-Path $testRoot "README.md") -Value "documentação"
    Set-Content -LiteralPath (Join-Path $testRoot "doc/nota.md") -Value "evidência"
    $stopInput = [pscustomobject]@{
        session_id = "session-documentation-only"
        cwd = $testRoot
        hook_event_name = "Stop"
        stop_hook_active = $false
    } | ConvertTo-Json -Compress
    $stopOutput = $stopInput |
        & (Join-Path $fixtureHooks "sonar-stop.ps1") |
        ConvertFrom-Json -Depth 20
    if ($stopOutput.continue -ne $true -or
        $null -ne $stopOutput.PSObject.Properties["systemMessage"] -or
        $null -ne $stopOutput.PSObject.Properties["decision"] -or
        $null -ne $stopOutput.PSObject.Properties["stopReason"]) {
        throw "Stop cobrou Sonar ou tentou decidir em mudança somente Markdown."
    }

    Write-Host "GREEN: fluxo exclusivamente documental dispensado do Sonar."
}
finally {
    [Environment]::SetEnvironmentVariable("SONAR_TOKEN", $previousToken, "Process")
    if (Test-Path -LiteralPath $testRoot) {
        Remove-Item -LiteralPath $testRoot -Recurse -Force
    }
}
