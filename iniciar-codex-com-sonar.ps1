[CmdletBinding()]
param(
    [string]$CodexCommand = "codex",
    [Parameter(ValueFromRemainingArguments = $true)][string[]]$CodexArguments = @()
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

if ($null -eq (Get-Command $CodexCommand -ErrorAction SilentlyContinue)) {
    throw "Comando Codex não encontrado: '$CodexCommand'."
}

$previousToken = [Environment]::GetEnvironmentVariable("SONAR_TOKEN", "Process")
$secureToken = $null
$plainToken = $null
$tokenPointer = [IntPtr]::Zero

try {
    # https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/read-host
    $secureToken = Read-Host -Prompt "Cole o token do SonarQube para esta sessão" -AsSecureString

    # https://learn.microsoft.com/en-us/dotnet/api/system.runtime.interopservices.marshal.securestringtobstr
    $tokenPointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureToken)
    $plainToken = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($tokenPointer)
    if ([string]::IsNullOrWhiteSpace($plainToken)) {
        throw "O token não pode ser vazio."
    }

    # O escopo Process é herdado pelo filho e não persiste em User/Machine:
    # https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_environment_variables
    [Environment]::SetEnvironmentVariable("SONAR_TOKEN", $plainToken, "Process")
    $plainToken = $null

    & $CodexCommand @CodexArguments
    if ($LASTEXITCODE -ne 0) {
        throw "O Codex terminou com código de saída $LASTEXITCODE."
    }
}
finally {
    [Environment]::SetEnvironmentVariable("SONAR_TOKEN", $previousToken, "Process")
    $plainToken = $null

    if ($tokenPointer -ne [IntPtr]::Zero) {
        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($tokenPointer)
    }
    if ($null -ne $secureToken) {
        $secureToken.Dispose()
    }
}
