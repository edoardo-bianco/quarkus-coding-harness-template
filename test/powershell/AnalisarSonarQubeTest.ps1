$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repositoryRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot "../.."))
$analyzerPath = Join-Path $repositoryRoot "analisar-sonarqube.ps1"

if (-not (Test-Path -LiteralPath $analyzerPath -PathType Leaf)) {
    throw "Analisador SonarQube ausente: $analyzerPath"
}

$parseErrors = $null
[System.Management.Automation.Language.Parser]::ParseFile(
    $analyzerPath,
    [ref]$null,
    [ref]$parseErrors
) | Out-Null
if ($parseErrors.Count -ne 0) {
    throw "Falha de sintaxe no analisador SonarQube."
}

$analyzerText = Get-Content -LiteralPath $analyzerPath -Raw
if ($analyzerText -match "param\s*\([^)]*(SONAR_TOKEN|SonarToken|Token)" -or
    $analyzerText -match "-Dsonar\.(token|login)" -or
    $analyzerText -notmatch "mvnw\.cmd" -or
    $analyzerText -notmatch "sonar-maven-plugin:5\.5\.0\.6356:sonar") {
    throw "O analisador deve fixar o scanner, usar o Wrapper e nunca receber o token por parametro."
}

$testRoot = Join-Path ([IO.Path]::GetTempPath()) (
    "sonar-analysis-test-" + [guid]::NewGuid().ToString("N")
)
$resolvedTestRoot = [IO.Path]::GetFullPath($testRoot)
New-Item -ItemType Directory -Path $resolvedTestRoot | Out-Null
$testAnalyzerPath = Join-Path $resolvedTestRoot "analisar-sonarqube.ps1"
$testPomPath = Join-Path $resolvedTestRoot "pom.xml"
$testWrapperPath = Join-Path $resolvedTestRoot "mvnw.cmd"
$capturedArgumentsPath = Join-Path $resolvedTestRoot "captured-arguments.txt"
$metadataPath = Join-Path $resolvedTestRoot "target/sonar/report-task.txt"

Copy-Item -LiteralPath $analyzerPath -Destination $testAnalyzerPath
@'
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0">
    <modelVersion>4.0.0</modelVersion>
    <groupId>fixture.group</groupId>
    <artifactId>fixture-artifact</artifactId>
    <version>1.0.0-SNAPSHOT</version>
    <name>Fixture Project</name>
</project>
'@ | Set-Content -LiteralPath $testPomPath -Encoding UTF8
@'
@echo off
set "WRAPPER_DIR=%~dp0"
if "%SONAR_TOKEN%"=="" exit /b 91
if "%SONAR_ANALYSIS_TEST_EXIT_CODE%"=="7" exit /b 7
if exist "%WRAPPER_DIR%captured-arguments.txt" del "%WRAPPER_DIR%captured-arguments.txt"
:capture
if "%~1"=="" goto metadata
>> "%WRAPPER_DIR%captured-arguments.txt" echo %~1
shift
goto capture
:metadata
if "%SONAR_ANALYSIS_TEST_SKIP_METADATA%"=="1" exit /b 0
if not exist "%WRAPPER_DIR%target\sonar" mkdir "%WRAPPER_DIR%target\sonar"
> "%WRAPPER_DIR%target\sonar\report-task.txt" echo ceTaskId=FIXTURE_CE_TASK
>> "%WRAPPER_DIR%target\sonar\report-task.txt" echo ceTaskUrl=http://localhost:9000/api/ce/task?id=FIXTURE_CE_TASK
echo saida-maven-simulada
exit /b 0
'@ | Set-Content -LiteralPath $testWrapperPath -Encoding Ascii

$previousToken = [Environment]::GetEnvironmentVariable("SONAR_TOKEN", "Process")
$previousExitCodeControl = [Environment]::GetEnvironmentVariable(
    "SONAR_ANALYSIS_TEST_EXIT_CODE",
    "Process"
)
$previousMetadataControl = [Environment]::GetEnvironmentVariable(
    "SONAR_ANALYSIS_TEST_SKIP_METADATA",
    "Process"
)
$syntheticSecret = "segredo-sintetico-" + [guid]::NewGuid().ToString("N")
$global:simulateServerFailure = $false
$global:restCallCount = 0

function global:Invoke-RestMethod {
    param($Method, $Uri, $TimeoutSec)

    $global:restCallCount++
    if ($global:simulateServerFailure) {
        throw "servidor-sintetico-indisponivel"
    }
    if ($Method -ne "Get" -or $Uri -ne "http://localhost:9000/api/system/status") {
        throw "Chamada inesperada ao servidor SonarQube."
    }
    return [pscustomobject]@{ status = "UP" }
}

try {
    [Environment]::SetEnvironmentVariable("SONAR_TOKEN", $null, "Process")
    $missingTokenMessage = $null
    try {
        & $testAnalyzerPath
    }
    catch {
        $missingTokenMessage = $_.Exception.Message
    }
    if ($missingTokenMessage -notmatch "SONAR_TOKEN" -or $global:restCallCount -ne 0) {
        throw "A ausencia de token nao falhou antes de rede ou Maven."
    }

    [Environment]::SetEnvironmentVariable("SONAR_TOKEN", $syntheticSecret, "Process")
    $global:simulateServerFailure = $true
    $serverFailureMessage = $null
    try {
        & $testAnalyzerPath
    }
    catch {
        $serverFailureMessage = $_.Exception.Message
    }
    if ($serverFailureMessage -notmatch "Não foi possível acessar" -or
        $serverFailureMessage.Contains($syntheticSecret, [StringComparison]::Ordinal) -or
        $serverFailureMessage -match "APROVADO|COMPLIANT") {
        throw "A indisponibilidade do servidor nao foi informada de forma segura."
    }

    $global:simulateServerFailure = $false
    $unsafeNameFailed = $false
    try {
        & $testAnalyzerPath -ProjectName "Fixture & comando"
    }
    catch {
        $unsafeNameFailed = $_.Exception.Message -match "ProjectName"
    }
    if (-not $unsafeNameFailed) {
        throw "O analisador aceitou metacaractere de shell em ProjectName."
    }

    $unsafePathFailed = $false
    try {
        & $testAnalyzerPath -SonarUrl "http://localhost:9000/prefixo%20sufixo"
    }
    catch {
        $unsafePathFailed = $_.Exception.Message -match "caracteres não permitidos"
    }
    if (-not $unsafePathFailed) {
        throw "O analisador aceitou escape de ambiente no caminho da SonarUrl."
    }

    New-Item -ItemType Directory -Path (Split-Path -Parent $metadataPath) | Out-Null
    Set-Content -LiteralPath $metadataPath -Value "ceTaskId=STALE" -Encoding Ascii
    [Environment]::SetEnvironmentVariable("SONAR_ANALYSIS_TEST_SKIP_METADATA", "1", "Process")
    $missingMetadataMessage = $null
    try {
        $null = @(& $testAnalyzerPath *>&1)
    }
    catch {
        $missingMetadataMessage = $_.Exception.Message
    }
    [Environment]::SetEnvironmentVariable("SONAR_ANALYSIS_TEST_SKIP_METADATA", $null, "Process")
    if ($missingMetadataMessage -notmatch "sem produzir" -or
        (Test-Path -LiteralPath $metadataPath -PathType Leaf)) {
        throw "O analisador aceitou metadado obsoleto após uma execução incompleta."
    }

    [Environment]::SetEnvironmentVariable("SONAR_ANALYSIS_TEST_EXIT_CODE", "7", "Process")
    $mavenFailureMessage = $null
    try {
        $null = @(& $testAnalyzerPath *>&1)
    }
    catch {
        $mavenFailureMessage = $_.Exception.Message
    }
    [Environment]::SetEnvironmentVariable("SONAR_ANALYSIS_TEST_EXIT_CODE", $null, "Process")
    if ($mavenFailureMessage -notmatch "código de saída 7") {
        throw "O analisador não propagou a falha do Maven Wrapper."
    }

    $analysisOutput = @(& $testAnalyzerPath *>&1)
    if (-not (Test-Path -LiteralPath $capturedArgumentsPath -PathType Leaf)) {
        throw "O Maven Wrapper sintetico nao foi executado."
    }
    if (-not (Test-Path -LiteralPath $metadataPath -PathType Leaf)) {
        throw "A analise nao produziu report-task.txt para o Compute Engine."
    }

    $capturedArguments = @(
        Get-Content -LiteralPath $capturedArgumentsPath | ForEach-Object { $_.Trim() }
    )
    $expectedArguments = @(
        "clean",
        "verify",
        "org.sonarsource.scanner.maven:sonar-maven-plugin:5.5.0.6356:sonar",
        "-Dsonar.projectKey=fixture.group:fixture-artifact",
        "-Dsonar.projectName=Fixture Project",
        "-Dsonar.host.url=http://localhost:9000",
        "-Dsonar.scanner.metadataFilePath=target/sonar/report-task.txt",
        "-Dsonar.scanner.skipJreProvisioning=true"
    )
    if ($capturedArguments.Count -ne $expectedArguments.Count) {
        throw "Quantidade inesperada de argumentos Maven: $($capturedArguments -join ' | ')"
    }
    foreach ($expectedArgument in $expectedArguments) {
        if ($capturedArguments -notcontains $expectedArgument) {
            throw "Argumento Maven esperado ausente: $expectedArgument. Capturados: $($capturedArguments -join ' | ')"
        }
    }

    $observableText = ($capturedArguments + $analysisOutput) -join [Environment]::NewLine
    if ($observableText.Contains($syntheticSecret, [StringComparison]::Ordinal) -or
        $observableText -match "-Dsonar\.(token|login)") {
        throw "A analise exibiu ou incluiu o token nos argumentos Maven."
    }

    $credentialUrlFailed = $false
    try {
        & $testAnalyzerPath -SonarUrl "http://usuario:senha@localhost:9000"
    }
    catch {
        $credentialUrlFailed = $_.Exception.Message -match "não pode conter usuário ou senha"
    }
    if (-not $credentialUrlFailed) {
        throw "O analisador aceitou credencial embutida em SonarUrl."
    }

    Write-Host "GREEN: analise usa Wrapper, metadados e ambiente sem expor credencial."
}
finally {
    Remove-Item Function:\Invoke-RestMethod -ErrorAction SilentlyContinue
    Remove-Variable simulateServerFailure -Scope Global -ErrorAction SilentlyContinue
    Remove-Variable restCallCount -Scope Global -ErrorAction SilentlyContinue
    [Environment]::SetEnvironmentVariable("SONAR_TOKEN", $previousToken, "Process")
    [Environment]::SetEnvironmentVariable(
        "SONAR_ANALYSIS_TEST_EXIT_CODE",
        $previousExitCodeControl,
        "Process"
    )
    [Environment]::SetEnvironmentVariable(
        "SONAR_ANALYSIS_TEST_SKIP_METADATA",
        $previousMetadataControl,
        "Process"
    )
    if ($resolvedTestRoot.StartsWith([IO.Path]::GetFullPath([IO.Path]::GetTempPath()))) {
        Remove-Item -LiteralPath $resolvedTestRoot -Recurse -Force
    }
}
