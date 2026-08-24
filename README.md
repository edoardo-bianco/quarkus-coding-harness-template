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
| Incremento 5 — núcleo neutro | `Concluído; GO do Incremento 6 registrado` |
| Incremento 6 — adapter HTTP | `Contrato proposto; Checkpoint B pendente` |
| Feature neutra | Núcleo e aplicação implementados; adapter e controles ainda planejados |
| Hooks e scripts Sonar | Não implementados |
| Uso como template de produto | Ainda não liberado |

Neste checkpoint o repositório contém documentação, fundação Maven e o núcleo determinístico da feature neutra, comprovado por testes. O `GO` para iniciar o Incremento 6 foi registrado e seu contrato HTTP está proposto no plano, mas nenhum adapter, DTO ou dependência será criado antes do Checkpoint B humano. ArchUnit, observabilidade e harness Sonar continuam planejados; a situação Sonar permanece `UNVERIFIED`.

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

Execute também a suíte disponível:

```powershell
.\mvnw.cmd -q test
```

Em ambientes POSIX, use `./mvnw` nos mesmos comandos. A saída verificada no bootstrap foi Maven 3.9.16 com Temurin JDK 25.0.3. Neste estágio, a suíte cobre somente o núcleo e o caso de uso; ainda não prova HTTP, arquitetura executável ou observabilidade.

## SonarQube

Mudanças exclusivamente Markdown dispensam baseline e checkpoint. Código, build, scripts, hooks e configuração executável exigem o fluxo Sonar descrito em [AGENTS.md](AGENTS.md). Neste bootstrap, os scripts de baseline/checkpoint ainda não existem; por isso os Incrementos 4 e 5 estão tecnicamente verificados pelo Maven, mas o estado Sonar permanece `UNVERIFIED`.

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
