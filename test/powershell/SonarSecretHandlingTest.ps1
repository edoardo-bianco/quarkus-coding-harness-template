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
$secretBytes = [Text.Encoding]::UTF8.GetBytes($syntheticSecret)
try {
    $syntheticSecretHash = [Convert]::ToHexString(
        [Security.Cryptography.SHA256]::HashData($secretBytes)
    )
}
finally {
    [Array]::Clear($secretBytes, 0, $secretBytes.Length)
}
$global:syntheticSecureSecret = [Security.SecureString]::new()
foreach ($character in $syntheticSecret.ToCharArray()) {
    $global:syntheticSecureSecret.AppendChar($character)
}
$global:syntheticSecureSecret.MakeReadOnly()

$testRoot = Join-Path ([IO.Path]::GetTempPath()) (
    "sonar-session-test-" + [guid]::NewGuid().ToString("N")
)
$resolvedTestRoot = [IO.Path]::GetFullPath($testRoot)
New-Item -ItemType Directory -Path $resolvedTestRoot | Out-Null
$childScriptPath = Join-Path $resolvedTestRoot "codex-child-test-double.ps1"
@'
param(
    [ValidateSet("success", "failure")][string]$Mode,
    [string]$ExpectedTokenHash,
    [Parameter(ValueFromRemainingArguments = $true)][string[]]$ForwardedArguments = @()
)

$token = [Environment]::GetEnvironmentVariable("SONAR_TOKEN", "Process")
$tokenBytes = [Text.Encoding]::UTF8.GetBytes($token)
try {
    $actualTokenHash = [Convert]::ToHexString(
        [Security.Cryptography.SHA256]::HashData($tokenBytes)
    )
}
finally {
    [Array]::Clear($tokenBytes, 0, $tokenBytes.Length)
    $token = $null
}

if ($actualTokenHash -cne $ExpectedTokenHash) {
    exit 92
}
if ($Mode -eq "failure") {
    Write-Output "falha-segura-do-processo-filho"
    exit 7
}

Write-Output "token-sintetico-confirmado-por-hash"
foreach ($argument in $ForwardedArguments) {
    Write-Output "argumento=$argument"
}
exit 0
'@ | Set-Content -LiteralPath $childScriptPath -Encoding UTF8

function global:Read-Host {
    param($Prompt, [switch]$AsSecureString)

    if (-not $AsSecureString) {
        throw "O inicializador solicitou o segredo sem AsSecureString."
    }
    return $global:syntheticSecureSecret
}

try {
    [Environment]::SetEnvironmentVariable("SONAR_TOKEN", "valor-anterior", "Process")

    $launcherOutput = @(
        & $launcherPath `
            -CodexCommand "pwsh" `
            -CodexArguments @(
                "-NoProfile",
                "-File",
                $childScriptPath,
                "success",
                $syntheticSecretHash,
                "primeiro",
                "argumento com espaco"
            )
    )

    if ($launcherOutput -notcontains "token-sintetico-confirmado-por-hash" -or
        $launcherOutput -notcontains "argumento=primeiro" -or
        $launcherOutput -notcontains "argumento=argumento com espaco") {
        throw "O processo filho não confirmou token e argumentos preservados."
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
        & $launcherPath -CodexCommand "pwsh" -CodexArguments @(
            "-NoProfile",
            "-File",
            $childScriptPath,
            "success",
            $syntheticSecretHash
        )
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
        & $launcherPath -CodexCommand "pwsh" -CodexArguments @(
            "-NoProfile",
            "-File",
            $childScriptPath,
            "failure",
            $syntheticSecretHash
        )
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
    if ($null -ne $global:syntheticSecureSecret) {
        $global:syntheticSecureSecret.Dispose()
    }
    Remove-Variable syntheticSecureSecret -Scope Global -ErrorAction SilentlyContinue
    [Environment]::SetEnvironmentVariable("SONAR_TOKEN", $previousToken, "Process")
    if ($resolvedTestRoot.StartsWith([IO.Path]::GetFullPath([IO.Path]::GetTempPath()))) {
        Remove-Item -LiteralPath $resolvedTestRoot -Recurse -Force
    }
}
