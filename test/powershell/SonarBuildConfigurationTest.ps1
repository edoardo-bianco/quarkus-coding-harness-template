$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repositoryRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot "../.."))
$pomPath = Join-Path $repositoryRoot "pom.xml"
$guidePath = Join-Path $repositoryRoot "doc/sonar/sonarqube-local.md"

function Assert-FileExists {
    param([Parameter(Mandatory)][string]$Path)

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "Arquivo obrigatorio ausente: $Path"
    }
}

function Assert-Contains {
    param(
        [Parameter(Mandatory)][string]$Content,
        [Parameter(Mandatory)][string]$Expected,
        [Parameter(Mandatory)][string]$Message
    )

    if (-not $Content.Contains($Expected, [StringComparison]::Ordinal)) {
        throw $Message
    }
}

Assert-FileExists -Path $pomPath

[xml]$pom = Get-Content -LiteralPath $pomPath -Raw
$namespace = [Xml.XmlNamespaceManager]::new($pom.NameTable)
$namespace.AddNamespace("m", "http://maven.apache.org/POM/4.0.0")

$jacocoDependencies = $pom.SelectNodes(
    "/m:project/m:dependencies/m:dependency[m:groupId='io.quarkus' and m:artifactId='quarkus-jacoco']",
    $namespace
)
if ($jacocoDependencies.Count -ne 1) {
    throw "O build deve declarar exatamente uma dependencia io.quarkus:quarkus-jacoco."
}
if ($jacocoDependencies[0].scope -ne "test") {
    throw "quarkus-jacoco deve permanecer restrito ao escopo de teste."
}

$jacocoPlugin = $pom.SelectSingleNode(
    "/m:project/m:build/m:plugins/m:plugin[m:artifactId='jacoco-maven-plugin']",
    $namespace
)
if ($null -ne $jacocoPlugin) {
    throw "O plugin JaCoCo nao deve duplicar a instrumentacao fornecida pela extensao Quarkus."
}

$coveragePath = $pom.SelectSingleNode(
    "/m:project/m:properties/*[local-name()='sonar.coverage.jacoco.xmlReportPaths']",
    $namespace
)
if ($null -eq $coveragePath) {
    throw "O build deve informar ao Sonar o caminho do relatorio JaCoCo XML."
}
if ($coveragePath.InnerText -ne '${project.build.directory}/jacoco-report/jacoco.xml') {
    throw "O caminho Sonar deve apontar para o XML produzido pela extensao Quarkus."
}

foreach ($forbiddenProperty in @(
    "sonar.jacoco.reportPaths",
    "sonar.coverage.exclusions",
    "sonar.login",
    "sonar.token",
    "sonar.host.url",
    "sonar.projectKey",
    "sonar.projectName"
)) {
    $node = $pom.SelectSingleNode(
        "/m:project/m:properties/*[local-name()='$forbiddenProperty']",
        $namespace
    )
    if ($null -ne $node) {
        throw "Propriedade Maven proibida neste incremento: $forbiddenProperty"
    }
}

Assert-FileExists -Path $guidePath
$guide = Get-Content -LiteralPath $guidePath -Raw
foreach ($requiredGuidance in @(
    "target/jacoco-report/jacoco.xml",
    "cobertura mínima de 85%",
    "duplicação máxima de 5%",
    "nenhuma exclusão de cobertura",
    "UNVERIFIED"
)) {
    Assert-Contains -Content $guide -Expected $requiredGuidance `
        -Message "Guia Sonar deve registrar: $requiredGuidance"
}

Write-Host "GREEN: configuracao de cobertura e propriedades Sonar aprovada."
