# Quarkus Coding Harness Template

Template interno para iniciar projetos Java 25 com Quarkus LTS e Maven, acompanhados por um harness de desenvolvimento assistido por agente, arquitetura DDD hexagonal pragmática, qualidade SonarQube e checkpoints humanos.

## Estado atual

| Item | Estado |
| --- | --- |
| Especificação | `Aprovado` |
| Arquitetura e ADRs 0001–0005 | `Aceito` |
| Plano e contratos neutros | `Aprovado` |
| Incremento 1 — entrada operacional | `Concluído` |
| Incremento 2 — goals e specs reutilizáveis | `Concluído` |
| Incremento 3 — planos e checklists reutilizáveis | `Concluído; Checkpoint A aprovado` |
| Incremento 4 — fundação Maven reproduzível | `Concluído; GO do Incremento 5 registrado` |
| Incremento 5 — núcleo neutro | `Concluído` |
| Incremento 6 — adapter HTTP | `Concluído; GO do Incremento 7 registrado` |
| Incremento 7 — regras ArchUnit | `Concluído` |
| Incremento 8 — observabilidade | `Concluído` |
| Incremento 9 — cobertura e Sonar build | `Concluído` |
| Incremento 10 — sessão e análise Sonar | `Concluído` |
| Incremento 11 — baseline e decisão | `Concluído; checkpoint local COMPLIANT` |
| Incremento 12 — hooks Codex | `Concluído e revisado` |
| Incremento 13 — evidência offline | `Concluído; Checkpoint D aprovado` |
| Incremento 14 — materialização | `Concluído; GO do Incremento 15 registrado` |
| Incremento 15 — entrega integrada | `ACEITO pelo humano em 2026-09-16` |
| Feature neutra | Fluxo HTTP, núcleo, arquitetura e observabilidade implementados |
| Hooks e scripts Sonar | Sessão, análise, baseline, checkpoint, decisão, hooks e exportação offline implementados |
| Versão aceita para materialização | Commit `2be35ac`; seguir o guia de materialização |

A implementação e a verificação técnica estão concluídas. O humano registrou `ACEITO` em
2026-09-16 para a entrega do commit `2be35ac` e, posteriormente, autorizou o encerramento do
goal na mesma data. O bootstrap está `ENCERRADO`; um próximo goal será definido separadamente.
O procedimento de materialização foi ensaiado com identidade, goal, histórico e baseline próprios.

A entrega consolida as evidências de 2026-09-16: 26 testes Maven e 11 testes PowerShell verdes;
checkpoint `COMPLIANT`, cobertura 97,6%, duplicação 0%, zero issue nova ou bloqueante. Permanecem
seis issues preexistentes não bloqueantes. No Incremento 15, somente Markdown mudou e o
fingerprint executável foi conferido contra essas evidências, sem nova execução Maven ou Sonar.
A rastreabilidade por critério e os limites da verificação estão no [plano](tasks/plan.md).

## Comece por aqui

### Para humanos

Leia o [guia Por onde começar](doc/guias/iniciar-novo-projeto.md). Ele explica como contribuir com o template, quais dados fornecer para um projeto derivado e onde o agente deve parar.

### Para agentes

Leia [AGENTS.md](AGENTS.md) e siga a ordem de contexto indicada. O próximo item autorizado está sempre em [tasks/todo.md](tasks/todo.md); um GO não se estende automaticamente ao incremento seguinte.

## Mapa do conhecimento

- [Goal do template](goals/template-harness/goal.md): valor, definição de pronto, evidências e parada.
- [Guia e template de goal](goals/README.md): criação do objetivo persistente de um projeto ou épico.
- [Especificação](specs/template-harness/spec.md): escopo e critérios de aceitação.
- [Guia e template de spec](specs/README.md): requisitos, contratos, testes e limites de uma mudança.
- [Arquitetura](doc/arquitetura/arquitetura-harness.md): desenho do produto, SDLC e controles.
- [Índice de ADRs](doc/adr/README.md): decisões aceitas e aplicabilidade.
- [Guia e templates de plan/todo](tasks/README.md): planejamento e execução por feature.
- [Plano](tasks/plan.md): dependências, incrementos, verificações e riscos.
- [Checklist](tasks/todo.md): andamento e próximo checkpoint.
- [Materialização](doc/guias/materializar-projeto.md) e [checklist de materialização](doc/guias/checklist-materializacao.md): criação e verificação de um projeto derivado após aceite da versão.

## Stack e decisões-base

- JDK 25.
- Quarkus 3.33.3.1 da linha 3.33 LTS.
- Maven Wrapper 3.9.16 no modo `only-script`, com checksum da distribuição fixado.
- Package-by-domain e DDD hexagonal pragmático.
- Quarkus e bibliotecas estáveis permitidos quando simplificam uma necessidade concreta sem inverter dependências.
- Quarkus Flow na aplicação para orquestrações longas ou duráveis, não para chamadas triviais.
- Transactional Outbox por polling quando houver dupla escrita banco-broker, sem Debezium, XA ou 2PC.

## Fluxo de desenvolvimento

```text
goal -> especificação -> arquitetura/ADRs -> plano/todo -> GO humano
     -> incremento -> testes/evidências -> checkpoint -> aceite humano
```

Pronto técnico não encerra o trabalho. Somente o humano aceita exceções, ADRs, entrega e encerramento.

## Uso local neste estágio

```powershell
git clone https://github.com/edoardo-bianco/quarkus-coding-harness-template.git
Set-Location quarkus-coding-harness-template
git status -sb
```

Confirme a toolchain e a fundação do build no Windows:

```powershell
.\mvnw.cmd --version
.\mvnw.cmd -q validate
```

Execute a suíte Maven completa:

```powershell
.\mvnw.cmd -q verify
```

Execute também todos os testes PowerShell do harness:

```powershell
$ErrorActionPreference = "Stop"
Get-ChildItem .\test\powershell\*Test.ps1 | Sort-Object Name | ForEach-Object { & $_.FullName }
```

Em ambientes POSIX, use `./mvnw` nos mesmos comandos Maven. A saída verificada no bootstrap foi
Maven 3.9.16 com Temurin JDK 25.0.3. A suíte cobre domínio, caso de uso, HTTP, OpenAPI,
arquitetura, observabilidade e os controles PowerShell do SonarQube.

## SonarQube

Mudanças exclusivamente Markdown dispensam baseline e checkpoint. Código, build, scripts, hooks e
configuração executável exigem o fluxo Sonar descrito em [AGENTS.md](AGENTS.md). O harness local
possui sessão segura, análise, baseline, checkpoint, decisão humana, hooks e
[exportação offline sanitizada](doc/sonar/exportacao-offline.md) testados. Somente
`sonar/README.md` é versionado; os pacotes permanecem locais e ignorados.

Regras centrais:

- token somente na memória do processo;
- baseline escolhido pelo humano quando houver pacote offline;
- offline-only é `UNVERIFIED`;
- `NON_COMPLIANT` exige decisão humana;
- hooks lembram, mas não aprovam ou reprovam;
- cada projeto derivado cria baseline próprio.

## Repositório derivado

Este repositório será configurado como template GitHub somente após atingir sua definição de pronto e receber aceite humano. Um projeto derivado deverá substituir identidade Maven e pacote-base, criar goal e histórico próprios e não transportar baseline, estado Sonar ou histórico do bootstrap.

Tecnologias diferentes de Java 25 + Quarkus LTS + Maven não são suportadas por esta primeira versão.

## Privacidade

O repositório é interno e privado neste momento. Não inclua tokens, `.env`, relatórios Sonar, estados do agente, artefatos de build ou dados de negócio.
