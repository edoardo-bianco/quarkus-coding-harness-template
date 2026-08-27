[CmdletBinding()]
param(
    [string]$ProjectKey = "",
    [string]$ProjectName = "",
    [string]$SonarUrl = "http://localhost:9000"
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$pomPath = Join-Path $PSScriptRoot "pom.xml"
if (-not (Test-Path -LiteralPath $pomPath -PathType Leaf)) {
    throw "pom.xml não encontrado junto ao analisador."
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
    throw "O POM deve informar groupId e artifactId para identificar o projeto Sonar."
}

if ([string]::IsNullOrWhiteSpace($ProjectKey)) {
    $ProjectKey = "$($groupNode.InnerText):$($artifactNode.InnerText)"
}
if ([string]::IsNullOrWhiteSpace($ProjectName)) {
    $ProjectName = if ($null -ne $nameNode) {
        $nameNode.InnerText
    }
    else {
        $artifactNode.InnerText
    }
}

if ($ProjectKey.Length -gt 400 -or
    $ProjectKey -notmatch '^[A-Za-z0-9_.:-]+$' -or
    $ProjectKey -match '^\d+$') {
    throw "ProjectKey deve ter até 400 caracteres, incluir um caractere não numérico e usar apenas letras, números, '-', '_', '.' ou ':'."
}
if ([string]::IsNullOrWhiteSpace($ProjectName) -or
    $ProjectName -notmatch '^[\p{L}\p{N} ._:-]+$') {
    throw "ProjectName deve conter somente letras, números, espaços, '-', '_', '.' ou ':'."
}

$parsedSonarUrl = $null
if (-not [Uri]::TryCreate($SonarUrl, [UriKind]::Absolute, [ref]$parsedSonarUrl) -or
    $parsedSonarUrl.Scheme -notin @("http", "https")) {
    throw "SonarUrl deve ser uma URL absoluta HTTP ou HTTPS."
}
if (-not [string]::IsNullOrWhiteSpace($parsedSonarUrl.UserInfo)) {
    throw "SonarUrl não pode conter usuário ou senha."
}
if (-not [string]::IsNullOrWhiteSpace($parsedSonarUrl.Query) -or
    -not [string]::IsNullOrWhiteSpace($parsedSonarUrl.Fragment)) {
    throw "SonarUrl não pode conter query ou fragmento."
}
if ($parsedSonarUrl.AbsolutePath -notmatch '^/[A-Za-z0-9._~/-]*$') {
    throw "SonarUrl contém caracteres não permitidos no caminho."
}
$normalizedSonarUrl = $parsedSonarUrl.AbsoluteUri.TrimEnd('/')

# O SonarScanner for Maven 5 aceita SONAR_TOKEN e recomenda não passá-lo na linha de comando:
# https://docs.sonarsource.com/sonarqube-server/analyzing-source-code/scanners/sonarscanner-for-maven
if ([string]::IsNullOrWhiteSpace(
    [Environment]::GetEnvironmentVariable("SONAR_TOKEN", "Process")
)) {
    throw "SONAR_TOKEN não está disponível no processo. Inicie uma sessão segura antes da análise."
}

try {
    $status = Invoke-RestMethod `
        -Method Get `
        -Uri "$normalizedSonarUrl/api/system/status" `
        -TimeoutSec 15
}
catch {
    throw "Não foi possível acessar o SonarQube em '$normalizedSonarUrl'."
}
if ($null -eq $status -or $status.status -ne "UP") {
    throw "O SonarQube não informou status UP."
}

$wrapperName = if ([IO.Path]::DirectorySeparatorChar -eq '\') { "mvnw.cmd" } else { "mvnw" }
$mavenWrapper = Join-Path $PSScriptRoot $wrapperName
if (-not (Test-Path -LiteralPath $mavenWrapper -PathType Leaf)) {
    throw "Maven Wrapper não encontrado: $mavenWrapper"
}
if ($wrapperName -eq "mvnw.cmd" -and $mavenWrapper.Contains("%", [StringComparison]::Ordinal)) {
    throw "O caminho do Maven Wrapper não pode conter '%' no Windows."
}

# A versão fixa evita mudanças involuntárias do scanner. O metadado contém o ceTaskId:
# https://docs.sonarsource.com/sonarqube-server/analyzing-source-code/analysis-parameters/parameters-not-settable-in-ui
$metadataRelativePath = "target/sonar/report-task.txt"
$scannerGoal = "org.sonarsource.scanner.maven:sonar-maven-plugin:5.5.0.6356:sonar"
$mavenArguments = @(
    "clean",
    "verify",
    $scannerGoal
)
$analysisProperties = @(
    "-Dsonar.projectKey=$ProjectKey",
    "-Dsonar.projectName=$ProjectName",
    "-Dsonar.host.url=$normalizedSonarUrl",
    "-Dsonar.scanner.metadataFilePath=$metadataRelativePath",
    "-Dsonar.scanner.skipJreProvisioning=true"
)
$mavenArguments += $analysisProperties
$metadataPath = Join-Path $PSScriptRoot $metadataRelativePath
if (Test-Path -LiteralPath $metadataPath -PathType Leaf) {
    Remove-Item -LiteralPath $metadataPath -Force
}

Write-Host "Executando análise Sonar de '$ProjectName' em $normalizedSonarUrl com o Maven Wrapper."
Push-Location -LiteralPath $PSScriptRoot
try {
    if ($wrapperName -eq "mvnw.cmd") {
        # cmd /s remove somente as aspas externas; cada item validado permanece delimitado:
        # https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/cmd
        $processStartInfo = [Diagnostics.ProcessStartInfo]::new()
        $processStartInfo.FileName = $env:ComSpec
        $processStartInfo.UseShellExecute = $false
        $quotedCommandParts = @($mavenWrapper) + $mavenArguments | ForEach-Object {
            '"' + $_ + '"'
        }
        $processStartInfo.Arguments = '/d /v:off /s /c "' + ($quotedCommandParts -join " ") + '"'

        $mavenProcess = [Diagnostics.Process]::Start($processStartInfo)
        try {
            $mavenProcess.WaitForExit()
            $mavenExitCode = $mavenProcess.ExitCode
        }
        finally {
            $mavenProcess.Dispose()
        }
    }
    else {
        & $mavenWrapper @mavenArguments | Out-Host
        $mavenExitCode = $LASTEXITCODE
    }

    if ($mavenExitCode -ne 0) {
        throw "A análise Maven falhou com código de saída $mavenExitCode."
    }
}
finally {
    Pop-Location
}

if (-not (Test-Path -LiteralPath $metadataPath -PathType Leaf)) {
    throw "A análise terminou sem produzir $metadataRelativePath."
}

Write-Host "Análise enviada. Metadados do Compute Engine: $metadataRelativePath"
Write-Host "Dashboard: $normalizedSonarUrl/dashboard?id=$([Uri]::EscapeDataString($ProjectKey))"
