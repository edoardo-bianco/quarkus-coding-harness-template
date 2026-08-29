[CmdletBinding()]
param(
    [string]$ProjectKey = "",
    [string]$SonarUrl = "http://localhost:9000",
    [string]$OutputDirectory = ""
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Assert-PathWithoutReparsePoint {
    param(
        [Parameter(Mandatory)][string]$Root,
        [Parameter(Mandatory)][string]$Candidate
    )

    $resolvedRoot = [IO.Path]::GetFullPath($Root).TrimEnd('\', '/')
    $current = [IO.Path]::GetFullPath($Candidate).TrimEnd('\', '/')
    while ($true) {
        if (Test-Path -LiteralPath $current) {
            $item = Get-Item -LiteralPath $current -Force
            if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
                throw "O caminho de exportação não pode conter link ou reparse point."
            }
        }
        if ($current.Equals($resolvedRoot, [StringComparison]::OrdinalIgnoreCase)) {
            return
        }
        $parent = Split-Path -Parent $current
        if ([string]::IsNullOrWhiteSpace($parent) -or $parent -eq $current) {
            throw "O caminho de exportação está fora da raiz do repositório."
        }
        $current = $parent.TrimEnd('\', '/')
    }
}

function Get-ProjectKeyFromPom {
    param([Parameter(Mandatory)][string]$RepositoryRoot)

    $pomPath = Join-Path $RepositoryRoot "pom.xml"
    if (-not (Test-Path -LiteralPath $pomPath -PathType Leaf)) {
        throw "pom.xml não encontrado junto ao exportador."
    }
    [xml]$pom = Get-Content -Raw -LiteralPath $pomPath
    $namespace = [Xml.XmlNamespaceManager]::new($pom.NameTable)
    $namespace.AddNamespace("m", "http://maven.apache.org/POM/4.0.0")
    $groupNode = $pom.SelectSingleNode("/m:project/m:groupId", $namespace)
    if ($null -eq $groupNode) {
        $groupNode = $pom.SelectSingleNode("/m:project/m:parent/m:groupId", $namespace)
    }
    $artifactNode = $pom.SelectSingleNode("/m:project/m:artifactId", $namespace)
    if ($null -eq $groupNode -or $null -eq $artifactNode) {
        throw "O POM deve informar groupId e artifactId para identificar o projeto Sonar."
    }
    return "$($groupNode.InnerText):$($artifactNode.InnerText)"
}

function ConvertTo-SafeEvidenceIdentifier {
    param([AllowNull()][object]$Value)

    $text = [string]$Value
    if ($text -notmatch "^[A-Za-z0-9_.:-]{1,500}$") {
        return ""
    }
    return $text
}

$repositoryRoot = [IO.Path]::GetFullPath($PSScriptRoot).TrimEnd('\', '/')
$modulePath = Join-Path $repositoryRoot ".codex/hooks/SonarQuality.psm1"
if (-not (Test-Path -LiteralPath $modulePath -PathType Leaf)) {
    throw "Módulo de qualidade Sonar ausente: $modulePath"
}
Import-Module $modulePath -Force

if ([string]::IsNullOrWhiteSpace($ProjectKey)) {
    $ProjectKey = Get-ProjectKeyFromPom -RepositoryRoot $repositoryRoot
}
if ($ProjectKey.Length -gt 400 -or
    $ProjectKey -notmatch "^[A-Za-z0-9_.:-]+$" -or
    $ProjectKey -match "^\d+$") {
    throw "ProjectKey deve ter até 400 caracteres, incluir um caractere não numérico e usar somente letras, números, '-', '_', '.' ou ':'."
}
$normalizedSonarUrl = (Assert-SonarUrl -Url $SonarUrl).AbsoluteUri.TrimEnd('/')

$sonarRoot = [IO.Path]::GetFullPath((Join-Path $repositoryRoot "sonar")).TrimEnd('\', '/')
if ([string]::IsNullOrWhiteSpace($OutputDirectory)) {
    $safeProjectKey = $ProjectKey -replace "[^A-Za-z0-9_.-]", "_"
    $timestamp = [DateTime]::UtcNow.ToString(
        "yyyyMMddTHHmmssfffZ",
        [Globalization.CultureInfo]::InvariantCulture
    )
    $OutputDirectory = Join-Path $sonarRoot "$safeProjectKey-$timestamp"
}
elseif (-not [IO.Path]::IsPathRooted($OutputDirectory)) {
    $OutputDirectory = Join-Path $repositoryRoot $OutputDirectory
}

$resolvedOutputPath = [IO.Path]::GetFullPath($OutputDirectory).TrimEnd('\', '/')
$allowedPrefix = $sonarRoot + [IO.Path]::DirectorySeparatorChar
if ($resolvedOutputPath.Equals($sonarRoot, [StringComparison]::OrdinalIgnoreCase) -or
    -not $resolvedOutputPath.StartsWith($allowedPrefix, [StringComparison]::OrdinalIgnoreCase)) {
    throw "OutputDirectory deve apontar para um pacote novo dentro de sonar/."
}
Assert-PathWithoutReparsePoint -Root $repositoryRoot -Candidate $resolvedOutputPath
if (Test-Path -LiteralPath $resolvedOutputPath) {
    throw "O diretório de saída já existe; evidência offline não é sobrescrita: $resolvedOutputPath"
}

$snapshot = Get-SonarQualitySnapshot `
    -SonarUrl $normalizedSonarUrl `
    -ProjectKey $ProjectKey
foreach ($issue in @($snapshot.issues)) {
    $issueKey = [string]$issue.key
    if ($issueKey -notmatch "^[A-Za-z0-9_.:-]{1,500}$") {
        throw "A resposta SonarQube contém chave de issue inadequada para evidência offline."
    }
}

if (-not (Test-Path -LiteralPath $sonarRoot -PathType Container)) {
    New-Item -ItemType Directory -Path $sonarRoot | Out-Null
}
Assert-PathWithoutReparsePoint -Root $repositoryRoot -Candidate $sonarRoot
$stagingPath = Join-Path $sonarRoot (".tmp-export-" + [guid]::NewGuid().ToString("N"))

try {
    New-Item -ItemType Directory -Path $stagingPath | Out-Null
    $issuesPath = Join-Path $stagingPath "issues.json"
    $issuesDocument = [ordered]@{
        schemaVersion = 1
        issues = @($snapshot.issues)
    }
    $issuesJson = ConvertTo-Json -InputObject $issuesDocument -Depth 20
    [IO.File]::WriteAllText($issuesPath, $issuesJson, [Text.UTF8Encoding]::new($false))
    $issuesSha256 = (Get-FileHash -LiteralPath $issuesPath -Algorithm SHA256).Hash.ToLowerInvariant()

    $manifest = [ordered]@{
        schemaVersion = 1
        packageFormat = "sonar-offline-evidence"
        exportedAtUtc = [DateTime]::UtcNow.ToString(
            "O",
            [Globalization.CultureInfo]::InvariantCulture
        )
        capturedAtUtc = $snapshot.capturedAtUtc
        sonarUrl = $normalizedSonarUrl
        projectKey = $ProjectKey
        analysisKey = ConvertTo-SafeEvidenceIdentifier -Value $snapshot.analysisKey
        revision = ConvertTo-SafeEvidenceIdentifier -Value $snapshot.revision
        issueCount = $snapshot.issueCount
        metrics = [ordered]@{
            coverage = $snapshot.metrics.coverage
            duplicatedLinesDensity = $snapshot.metrics.duplicatedLinesDensity
        }
        issuesSha256 = $issuesSha256
        authenticationIncluded = $false
        freeTextIncluded = $false
        immutableEvidence = $true
    }
    $manifestJson = ConvertTo-Json -InputObject $manifest -Depth 20
    [IO.File]::WriteAllText(
        (Join-Path $stagingPath "manifest.json"),
        $manifestJson,
        [Text.UTF8Encoding]::new($false)
    )

    Assert-PathWithoutReparsePoint -Root $repositoryRoot -Candidate $resolvedOutputPath
    Move-Item -LiteralPath $stagingPath -Destination $resolvedOutputPath
    $stagingPath = $null
}
finally {
    if (-not [string]::IsNullOrWhiteSpace([string]$stagingPath) -and
        (Test-Path -LiteralPath $stagingPath)) {
        $resolvedStagingPath = [IO.Path]::GetFullPath($stagingPath)
        if ($resolvedStagingPath.StartsWith($allowedPrefix, [StringComparison]::OrdinalIgnoreCase) -and
            (Split-Path -Leaf $resolvedStagingPath) -match "^\.tmp-export-[a-f0-9]{32}$") {
            Remove-Item -LiteralPath $resolvedStagingPath -Recurse -Force
        }
    }
}

$relativePackagePath = $resolvedOutputPath.Substring($repositoryRoot.Length).TrimStart('\', '/') `
    -replace '\\', '/'
Write-Host "Pacote offline exportado em $relativePackagePath."
Write-Host "Issues sanitizadas: $($snapshot.issueCount). Credencial e texto livre não foram exportados."
