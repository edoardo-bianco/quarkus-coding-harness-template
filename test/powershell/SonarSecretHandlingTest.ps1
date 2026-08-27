$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repositoryRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot "../.."))
$launcherPath = Join-Path $repositoryRoot "iniciar-codex-com-sonar.ps1"

if (-not (Test-Path -LiteralPath $launcherPath -PathType Leaf)) {
    throw "Inicializador seguro ausente: $launcherPath"
}

$parseErrors = $null
[System.Management.Automation.Language.Parser]::ParseFile(
    $launcherPath,
    [ref]$null,
    [ref]$parseErrors
) | Out-Null
if ($parseErrors.Count -ne 0) {
    throw "Falha de sintaxe no inicializador seguro."
}

$launcherText = Get-Content -LiteralPath $launcherPath -Raw
if ($launcherText -match "param\s*\([^)]*(SONAR_TOKEN|SonarToken|Token)" -or
    $launcherText -notmatch "Read-Host[\s\S]*-AsSecureString" -or
    $launcherText -notmatch "ZeroFreeBSTR") {
    throw "O inicializador deve mascarar, limpar e nunca receber o token por parametro."
}
if ($launcherText -match 'SetEnvironmentVariable\([^\r\n]+,\s*"(User|Machine)"\)') {
    throw "O inicializador nao pode persistir o token fora do escopo Process."
}

$previousToken = [Environment]::GetEnvironmentVariable("SONAR_TOKEN", "Process")
$syntheticSecret = "segredo-sintetico-" + [guid]::NewGuid().ToString("N")
$global:syntheticSecureSecret = [Security.SecureString]::new()
foreach ($character in $syntheticSecret.ToCharArray()) {
    $global:syntheticSecureSecret.AppendChar($character)
}
$global:syntheticSecureSecret.MakeReadOnly()
$global:capturedChildToken = $null
$global:capturedChildArguments = @()

function global:Read-Host {
    param($Prompt, [switch]$AsSecureString)

    if (-not $AsSecureString) {
        throw "O inicializador solicitou o segredo sem AsSecureString."
    }
    return $global:syntheticSecureSecret
}

function global:codex-session-test-double {
    param([Parameter(ValueFromRemainingArguments = $true)][object[]]$Arguments)

    $global:capturedChildToken = [Environment]::GetEnvironmentVariable("SONAR_TOKEN", "Process")
    $global:capturedChildArguments = @($Arguments)
    $global:LASTEXITCODE = 0
    Write-Output "saida-segura-do-processo-filho"
}

function global:codex-session-failing-double {
    $global:LASTEXITCODE = 7
    Write-Output "falha-segura-do-processo-filho"
}

try {
    [Environment]::SetEnvironmentVariable("SONAR_TOKEN", "valor-anterior", "Process")

    $launcherOutput = @(
        & $launcherPath `
            -CodexCommand "codex-session-test-double" `
            -CodexArguments @("primeiro", "argumento com espaco")
    )

    if ($global:capturedChildToken -ne $syntheticSecret) {
        throw "O processo filho nao recebeu o token somente pelo ambiente."
    }
    if (($global:capturedChildArguments -join "|") -ne "primeiro|argumento com espaco") {
        throw "Os argumentos do processo filho nao foram preservados."
    }
    if ([Environment]::GetEnvironmentVariable("SONAR_TOKEN", "Process") -ne "valor-anterior") {
        throw "O ambiente anterior nao foi restaurado depois da sessao."
    }
    if (($launcherOutput -join [Environment]::NewLine).Contains(
        $syntheticSecret,
        [StringComparison]::Ordinal
    )) {
        throw "O inicializador exibiu o token na saida."
    }

    $global:syntheticSecureSecret = [Security.SecureString]::new()
    $emptyTokenFailed = $false
    try {
        & $launcherPath -CodexCommand "codex-session-test-double"
    }
    catch {
        $emptyTokenFailed = $_.Exception.Message -match "não pode ser vazio"
    }
    if (-not $emptyTokenFailed) {
        throw "O inicializador aceitou um token vazio ou produziu uma falha ambigua."
    }
    if ([Environment]::GetEnvironmentVariable("SONAR_TOKEN", "Process") -ne "valor-anterior") {
        throw "A falha de validacao nao restaurou o ambiente anterior."
    }

    $global:syntheticSecureSecret = [Security.SecureString]::new()
    foreach ($character in $syntheticSecret.ToCharArray()) {
        $global:syntheticSecureSecret.AppendChar($character)
    }
    $global:syntheticSecureSecret.MakeReadOnly()
    $childFailureMessage = $null
    try {
        & $launcherPath -CodexCommand "codex-session-failing-double"
    }
    catch {
        $childFailureMessage = $_.Exception.Message
    }
    if ($childFailureMessage -notmatch "código de saída 7" -or
        $childFailureMessage.Contains($syntheticSecret, [StringComparison]::Ordinal)) {
        throw "A falha do processo filho nao foi propagada de forma segura."
    }
    if ([Environment]::GetEnvironmentVariable("SONAR_TOKEN", "Process") -ne "valor-anterior") {
        throw "A falha do processo filho nao restaurou o ambiente anterior."
    }

    Write-Host "GREEN: segredo existe somente em memoria de processo e nao vaza na sessao."
}
finally {
    Remove-Item Function:\Read-Host -ErrorAction SilentlyContinue
    Remove-Item Function:\codex-session-test-double -ErrorAction SilentlyContinue
    Remove-Item Function:\codex-session-failing-double -ErrorAction SilentlyContinue
    if ($null -ne $global:syntheticSecureSecret) {
        $global:syntheticSecureSecret.Dispose()
    }
    Remove-Variable syntheticSecureSecret -Scope Global -ErrorAction SilentlyContinue
    Remove-Variable capturedChildToken -Scope Global -ErrorAction SilentlyContinue
    Remove-Variable capturedChildArguments -Scope Global -ErrorAction SilentlyContinue
    [Environment]::SetEnvironmentVariable("SONAR_TOKEN", $previousToken, "Process")
}
