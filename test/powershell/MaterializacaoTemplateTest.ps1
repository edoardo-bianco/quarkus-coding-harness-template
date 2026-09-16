$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repositoryRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot "../.."))
$guidePath = Join-Path $repositoryRoot "doc/guias/materializar-projeto.md"
$checklistPath = Join-Path $repositoryRoot "doc/guias/checklist-materializacao.md"

function Assert-FileExists {
    param([Parameter(Mandatory)][string]$Path)

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "Artefato do Incremento 14 ausente: $Path"
    }
}

function Assert-ContainsAll {
    param(
        [Parameter(Mandatory)][string]$Content,
        [Parameter(Mandatory)][string[]]$Expected,
        [Parameter(Mandatory)][string]$Label
    )

    foreach ($item in $Expected) {
        if (-not $Content.Contains($item, [StringComparison]::OrdinalIgnoreCase)) {
            throw "$Label deve registrar: $item"
        }
    }
}

Assert-FileExists -Path $guidePath
Assert-FileExists -Path $checklistPath

$guide = Get-Content -Raw -LiteralPath $guidePath
$checklist = Get-Content -Raw -LiteralPath $checklistPath

Assert-ContainsAll -Content $guide -Label "Guia de materialização" -Expected @(
    "Java 25 + Quarkus 3.33 LTS + Maven",
    "nome do repositório",
    "descrição curta",
    "groupId",
    "artifactId",
    "versão inicial",
    "pacote-base",
    "goal inicial",
    "capacidades",
    "destino local",
    "destino GitHub",
    "visibilidade",
    "estratégia de branch",
    "diretório novo e vazio",
    "pare",
    "commit ou tag aceita",
    "pom.xml",
    "quarkus.application.name",
    "src/main/java",
    "src/test/java",
    "ROOT_PACKAGE",
    "template.harness",
    "goals/template-harness/goal.md",
    "specs/template-harness/spec.md",
    "tasks/plan.md",
    "tasks/todo.md",
    "doc/arquitetura/arquitetura-harness.md",
    "doc/adr/README.md",
    'estado `Aceito`',
    "goals/templates/goal.md",
    "specs/templates/spec.md",
    "tasks/templates/plan.md",
    "tasks/templates/todo.md",
    ".git/",
    ".codex/.state/",
    "target/",
    "sonar/README.md",
    "ProjectKey",
    "groupId:artifactId",
    "commit local antes do baseline",
    ".\validar-checkpoint-sonarqube.ps1 -InitializeBaseline",
    "UNVERIFIED",
    ".\mvnw.cmd -q verify",
    "Get-ChildItem .\test\powershell\*Test.ps1",
    "{{",
    "feature neutra"
)

Assert-ContainsAll -Content $checklist -Label "Checklist de materialização" -Expected @(
    "Entradas e autorização",
    "Cópia limpa",
    "Identidade técnica",
    "Contexto próprio",
    "Baseline próprio",
    "Auditoria final",
    "Java 25 + Quarkus 3.33 LTS + Maven",
    "diretório novo e vazio",
    "goals/template-harness/goal.md",
    "specs/template-harness/spec.md",
    "doc/arquitetura/arquitetura-harness.md",
    "doc/adr/README.md",
    "README.md",
    ".codex/.state/",
    "target/",
    "groupId:artifactId",
    "commit local antes do baseline",
    "UNVERIFIED",
    "Nenhum push"
)

if ($guide -match '(?im)^\s*\$?env:SONAR_TOKEN\s*=' -or
    $guide -match '(?i)-Token\b' -or
    $checklist -match '(?im)^\s*\$?env:SONAR_TOKEN\s*=' -or
    $checklist -match '(?i)-Token\b') {
    throw "A documentação não pode ensinar token por atribuição ou argumento."
}

Write-Host "GREEN: contrato documental e operacional de materialização aprovado."
