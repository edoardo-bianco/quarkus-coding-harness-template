# Plano de implementação — Bootstrap do harness Quarkus

## Estado

- Fase: `PLAN`
- Estado do plano: `Aprovado`
- Goal: `goals/template-harness/goal.md`
- Especificação: `specs/template-harness/spec.md` (`Aprovado`)
- Arquitetura: `doc/arquitetura/arquitetura-harness.md` (`Aceito`)
- ADRs: `doc/adr/README.md` (`Aceitos`)
- Implementação autorizada: **somente o Incremento 8**, nas Tasks 8A e 8B e dentro do contrato
  observável registrado neste plano. O humano aprovou explicitamente o Checkpoint C em
  2026-08-24.
- Próxima decisão: revisão humana do Incremento 8 depois das duas tasks verificadas; o
  Incremento 9 não está autorizado.
- Sonar neste estágio: `UNVERIFIED` **transitório**; não existem ainda `sonar/`, script de sessão
  ou script de checkpoint. Esse estado não satisfaz a definição de pronto e deve ser eliminado
  pelos Incrementos 9–13 antes da entrega do template.

## Intenção

Transformar o repositório vazio em um template interno, executável e verificável para iniciar projetos Java 25, Quarkus 3.33.3.1 LTS e Maven com harness de desenvolvimento assistido por agente, qualidade SonarQube, observabilidade e decisões humanas explícitas.

## Premissas aprovadas

- `groupId`, `artifactId` e pacote-base de um projeto derivado são entradas obrigatórias, não defaults organizacionais.
- a feature neutra permanece até a primeira feature real comprovar o harness;
- CI/CD não faz parte da primeira versão;
- atualização Quarkus é manual, planejada e aprovada;
- banco e broker não entram preventivamente;
- Transactional Outbox é a decisão quando dupla escrita for necessária;
- o repositório-fonte é somente leitura e não recebe qualquer alteração.

## Escopo

- instruções para humanos e agentes;
- goals, specs, ADRs, plano, checklist e templates reutilizáveis;
- base Maven/Quarkus/JDK 25 reproduzível;
- feature neutra vertical;
- testes unitários, HTTP, arquiteturais e de observabilidade;
- cobertura JaCoCo e integração SonarQube;
- scripts, módulo, hooks e testes PowerShell do fluxo Sonar;
- guia e ensaio de materialização de um novo projeto;
- auditoria contra negócio, segredos, estados e artefatos proibidos.

## Fora de escopo

- template independente de tecnologia;
- domínio real, persistência e mensageria executável;
- Debezium, XA/2PC, cloud, Kubernetes e deploy;
- CI/CD, CODEOWNERS e proteção de branch sem requisitos organizacionais;
- guardrails/evals ainda não especificados;
- alteração ou limpeza do repositório-fonte.

## Dependências e ordem

```text
governança aprovada
  -> instruções e templates
     -> build reproduzível
        -> feature neutra vertical
           -> ArchUnit + observabilidade
              -> cobertura e Sonar
                 -> hooks e testes do controle
                    -> materialização ensaiada
                       -> auditoria e aceite humano
```

O fluxo é sequencial nos pontos de contrato e build. Documentação Sonar pode ser elaborada junto aos scripts, mas não será tratada como evidência até os testes do próprio harness passarem.

## Estratégia de destilação do repositório de referência

O repositório-fonte informado pelo humano é uma referência de padrões em modo somente leitura. A
implementação do template não é uma cópia integral: cada capacidade abaixo será reconstruída por
RED → GREEN → REFACTOR, com identidade neutra, versões do template e testes próprios.

| Capacidade | Evidência consultada na referência | Destino no template | Adaptação obrigatória |
| --- | --- | --- | --- |
| Cobertura Maven | `pom.xml` com `quarkus-jacoco` | `pom.xml` e teste de configuração | preservar Quarkus 3.33.3.1/JDK 25 do template; não copiar dependências de negócio |
| Sessão segura | `iniciar-codex-com-sonar.ps1` | script homônimo | token somente no processo filho, nunca em parâmetro, arquivo, log ou saída |
| Análise local | `analisar-sonarqube.ps1` | script homônimo | identidade Sonar neutra/parametrizável, Maven Wrapper e espera da análise completa |
| Gate e baseline | `SonarQuality.psm1` e `validar-checkpoint-sonarqube.ps1` | módulo e script homônimos | política 85%/5%, fontes explícitas, `UNVERIFIED` offline e decisão exclusivamente humana |
| Hooks | `hooks.json`, `sonar-session-start.ps1` e `sonar-stop.ps1` | `.codex/hooks*` | lembretes não bloqueantes, isenção Markdown-only e nenhum default identitário da referência |
| Evidência offline | `exportar-relatorios-sonarqube.ps1` e documentação operacional | script, documentação e entrada local `sonar/` | pacote não versionado, imutável e tratado como dado não confiável; autenticação excluída |
| Provas do harness | oito testes em `test/powershell/` | testes PowerShell independentes | fixtures sintéticas e temporárias, sem servidor/token real e sem linguagem de negócio |

Não serão transportados `.codex/.state/`, logs, `report-task.txt`, baselines, snapshots, pacotes
offline, tokens, defaults ou coordenadas identitárias, planos de correção do produto ou
qualquer código de domínio da referência. O projeto derivado sempre criará estado e baseline
próprios.

O Checkpoint D somente poderá ser apresentado quando o conjunto destilado estiver materializado,
os testes PowerShell estiverem verdes e uma análise/baseline próprios do template tiverem sido
executados, ou quando uma indisponibilidade real estiver evidenciada como `UNVERIFIED`. Este último
estado documenta uma limitação, mas não conclui o goal.

## Contratos aceitos no GO arquitetural

O GO humano de 2026-08-23 aceitou:

1. identidade compilável do template: `template.harness:quarkus-coding-harness-template`, substituída obrigatoriamente na materialização;
2. feature neutra: `sample`, com transformação determinística e sem persistência; no Incremento 5,
   `NormalizedText` rejeita entrada `null`/blank, remove whitespace Unicode das extremidades,
   colapsa sequências internas, preserva conteúdo/capitalização e mede pontos de código Unicode;
3. endpoint de prova: `POST /api/sample/normalize`, validando texto e retornando valor normalizado e tamanho;
4. logs, spans e métricas da feature neutra, limitados a nomes e atributos de baixa cardinalidade, sem conteúdo recebido;
5. os cinco ADRs em estado `Aceito`.

Esses contratos orientam os incrementos futuros. Em 2026-08-23, o humano aprovou o Checkpoint A e
registrou `GO` limitado ao Incremento 4. A fundação Maven foi concluída tecnicamente; o Incremento
5 recebeu `GO` humano depois dessa revisão e também foi concluído tecnicamente. Em 2026-08-24, o
humano registrou `GO` para iniciar o Incremento 6. Como os detalhes públicos ainda não estavam
congelados, código e dependências do adapter permanecem bloqueados até o Checkpoint B.

## Estratégia de implementação

### Incremento 1 — Entrada operacional para humanos e agentes

**Entrega:** tornar o ponto de início inequívoco sem duplicar decisões permanentes.

**Arquivos prováveis:**

- `AGENTS.md`
- `README.md`
- `doc/guias/iniciar-novo-projeto.md`

**Aceitação:**

- humano encontra pré-requisitos, comandos e fluxo de criação;
- agente encontra ordem de leitura, limites, checkpoints e política Sonar;
- `AGENTS.md` aponta para arquitetura/ADRs/tasks em vez de copiar histórico.

**Verificação:** links Markdown, auditoria de instruções conflitantes e revisão humana.

### Incremento 2 — Templates de goal e especificação

**Entrega:** materializar contexto persistente antes do planejamento.

**Arquivos prováveis:**

- `goals/README.md`
- `goals/templates/goal.md`
- `specs/README.md`
- `specs/templates/spec.md`

**Aceitação:**

- goal exige valor, escopo, pronto, evidências, parada e encerramento humano;
- spec exige comandos, estrutura, estilo, testes, limites e critérios verificáveis;
- templates não carregam decisões do bootstrap como se fossem universais.

**Verificação:** preencher cópias descartáveis e conferir ausência de campos ambíguos obrigatórios.

### Incremento 3 — Planejamento e checklist reutilizáveis

**Entrega:** controlar uma feature por tarefas pequenas e verificáveis.

**Arquivos prováveis:**

- `tasks/README.md`
- `tasks/templates/plan.md`
- `tasks/templates/todo.md`

**Aceitação:**

- plano exige intenção, escopo, fora de escopo, riscos, dependências, arquivos, verificações e checkpoints;
- todo possui próximo item inequívoco e registra somente decisões humanas explícitas;
- dupla escrita exige estratégia, ack, retry, idempotência, ordenação, concorrência, schema, retenção, sensibilidade e observabilidade.

**Verificação:** criar uma feature fictícia descartável e validar que nenhuma tarefa excede cinco arquivos sem decomposição.

### Checkpoint A — Governança

- documentação coerente e navegável;
- nenhuma instrução específica do negócio-fonte;
- nenhuma alteração executável;
- revisão humana antes do build.

### Incremento 4 — Fundação Maven reproduzível

**Entrega:** build vazio com versões fixadas e exclusões seguras.

**Arquivos prováveis:**

- `pom.xml`
- `mvnw`
- `mvnw.cmd`
- `.mvn/wrapper/maven-wrapper.properties`
- `.gitignore`

**Aceitação:**

- Java 25 e Quarkus 3.33.3.1 estão explícitos;
- Maven Wrapper usa versão compatível com Maven 3.9+;
- `.gitignore` exclui target, IDE, `.env*`, `.codex/.state`, `sonar/` e segredos sem esconder documentação-fonte.

**Verificação:** `./mvnw --version` usa JDK 25 e `./mvnw -q validate` passa.

**Estado de execução:** `Concluído tecnicamente em 2026-08-23`.

**Evidência:** o RED inicial confirmou a ausência dos cinco artefatos planejados. O POM fixa Java
25, Quarkus 3.33.3.1 e a identidade transitória do template. O Wrapper oficial 3.3.4, no modo
`only-script`, resolve Maven 3.9.16 com checksum SHA-256 fixado; `mvnw.cmd --version` confirmou
Temurin 25.0.3 e `mvnw.cmd -q validate` passou. O checkpoint Sonar segue `UNVERIFIED` porque os
scripts de baseline e checkpoint serão implementados apenas nos incrementos próprios.

### Incremento 5 — Núcleo e caso de uso neutros por TDD

**Entrega:** primeira fatia do comportamento determinístico, sem adapter.

**Arquivos prováveis:**

- `src/main/java/template/harness/sample/domain/NormalizedText.java`
- `src/main/java/template/harness/sample/application/NormalizeTextUseCase.java`
- `src/test/java/template/harness/sample/domain/NormalizedTextTest.java`
- `src/test/java/template/harness/sample/application/NormalizeTextUseCaseTest.java`

**Aceitação:** RED comprova regras ainda ausentes; GREEN implementa apenas regras aprovadas; REFACTOR preserva testes.

**Verificação:** testes focados e depois `./mvnw -q test`.

**Estado de execução:** `Concluído tecnicamente em 2026-08-23`.

**Evidência:** o RED falhou na compilação pela ausência de `NormalizedText` e
`NormalizeTextUseCase`. O GREEN implementou somente os quatro arquivos planejados; os sete testes
focados e a suíte completa passaram sem falhas, erros ou testes ignorados. A revisão não encontrou
dependência invertida, I/O, adapter, abstração ou dependência adicional. O checkpoint Sonar segue
`UNVERIFIED` porque seus scripts ainda não existem.

### Incremento 6 — Adapter HTTP vertical

**Entrega:** fluxo executável da entrada HTTP ao núcleo.

**Estado de execução:** `Concluído e revisado pelo humano em 2026-08-24`.

**Contrato aprovado no Checkpoint B:**

| Dimensão | Proposta |
| --- | --- |
| Operação | `POST /api/sample/normalize`, com `operationId` `normalizeSampleText` |
| Media types | consome e produz `application/json` |
| Request | `{"text":"  Olá\t Mundo  "}`; body e campo `text` obrigatórios; propriedades adicionais são ignoradas para permitir evolução aditiva |
| Sucesso | `200 OK` com `{"value":"Olá Mundo","length":9}`; `length` conta pontos de código Unicode |
| Erro semântico | `400 Bad Request` com `{"code":"INVALID_TEXT","message":"text must contain non-whitespace content"}` para body ausente, `text` ausente, `null`, vazio ou somente whitespace Unicode |
| JSON malformado | `400 Bad Request` do Quarkus; o corpo técnico dessa falha não é contrato desta fatia e não pode expor stack trace |
| OpenAPI | documento gerado em `/q/openapi`, com operação, schemas e respostas `200`/`400`; sem snapshot estático |
| Segurança | sem autenticação, CORS, rate limiting, persistência ou integração; entrada não será registrada em log/span e permanece sujeita ao limite HTTP padrão de `10240K` do Quarkus 3.33 |

A validação estrutural de body/campo pertence ao adapter. A regra semântica Unicode continua
somente em `NormalizedText`; o resource traduz `IllegalArgumentException` para o erro público
genérico, sem expor mensagem interna nem repetir a regra. Alterar limite de body, autenticação,
CORS ou formato de erro exige novo checkpoint de contrato/segurança.

**Dependências oficiais previstas após o checkpoint:**

- `io.quarkus:quarkus-rest-jackson` para Jakarta REST e JSON;
- `io.quarkus:quarkus-smallrye-openapi` para gerar OpenAPI;
- `io.rest-assured:rest-assured` em escopo de teste para exercitar HTTP com `@QuarkusTest`.

Fontes oficiais: [REST/JSON 3.33](https://quarkus.io/version/3.33/guides/rest-json),
[referência REST 3.33](https://quarkus.io/version/3.33/guides/rest),
[testes 3.33](https://quarkus.io/version/3.33/guides/getting-started-testing),
[OpenAPI 3.33](https://quarkus.io/version/3.33/guides/openapi-swaggerui) e
[limites HTTP 3.33](https://quarkus.io/version/3.33/guides/http-reference).

**Arquivos prováveis após aprovação:**

- `pom.xml`
- `src/main/java/template/harness/sample/adapter/in/rest/NormalizeTextResource.java`
- `src/main/java/template/harness/sample/adapter/in/rest/NormalizeTextRequest.java`
- `src/main/java/template/harness/sample/adapter/in/rest/NormalizeTextResponse.java`
- `src/test/java/template/harness/sample/adapter/in/rest/NormalizeTextResourceTest.java`

`application.properties` saiu da lista porque o contrato proposto não exige configuração nesta
fatia; o `pom.xml`, ausente da previsão anterior, é necessário para as extensões oficiais.

**Aceitação:** Checkpoint B aprovado antes do RED; validação de borda e mapeamento sem DTO no
núcleo; sucesso, erro semântico e JSON malformado testados; OpenAPI coerente sem snapshot estático.

**Verificação:** teste HTTP focado e `./mvnw -q test`.

**Evidência:** antes da implementação, os oito testes HTTP/OpenAPI falharam como esperado: o
endpoint respondia `404` e a operação ainda não existia no documento OpenAPI. O GREEN adicionou
somente as três dependências oficiais e os cinco arquivos previstos, com mapeamento simples no
resource e sem DTO no núcleo. O teste focal passou com oito casos; a suíte completa passou com 15
testes, zero falhas, zero erros e zero ignorados. A revisão confirmou o contrato aprovado,
independência da borda, ausência de logging no adapter e ausência de integração, persistência ou
configuração adicional. Sonar permanece `UNVERIFIED` porque o harness ainda não existe.

**Checkpoint B — obrigatório antes do código:**

- path, verbo, status, JSON, validação e OpenAPI apresentados ao humano;
- nenhuma persistência ou integração externa adicionada;
- decisão humana explícita registrada antes do teste RED e da implementação.

**Decisão:** `APROVADO` pelo humano em 2026-08-24. A aprovação alcança somente o contrato acima e
o Incremento 6; não autoriza arquitetura executável do Incremento 7 nem observabilidade do
Incremento 8.

### Incremento 7 — Regras arquiteturais executáveis

**Entrega:** proteger direção de dependência e independência de bordas.

**Estado de execução:** `Concluído e revisado pelo humano em 2026-08-24`.

**Arquivos prováveis:**

- `pom.xml`
- `src/test/java/template/harness/architecture/LayerDependencyTest.java`
- `src/test/java/template/harness/architecture/BoundaryContractTest.java`
- `src/test/java/template/harness/sample/domain/fixture/DomainAdapterDependencyViolation.java`
- `src/test/java/template/harness/sample/application/fixture/ApplicationAdapterDependencyViolation.java`

**Dependência:** `com.tngtech.archunit:archunit:1.5.0` em escopo de teste. O core é suficiente
porque as regras serão executadas como testes JUnit 5 comuns já suportados pelo projeto. A
referência usa o mesmo padrão com 1.4.2; o template adota a versão atual documentada, construída e
testada pelo projeto ArchUnit com JDK 25.

Fontes oficiais: [guia ArchUnit 1.5.0](https://www.archunit.org/userguide/html/000_Index.html) e
[release 1.5.0](https://github.com/TNG/ArchUnit/releases/tag/v1.5.0).

**Aceitação:** fixtures sintéticas comprovam falha para dependência domain→adapter,
application→adapter e contrato REST compartilhado fora da borda; código de produção respeita as
regras; uso pragmático de APIs estáveis de framework não é bloqueado genericamente.

**Verificação:** testes ArchUnit focados e suíte completa.

**Evidência:** o RED executou seis testes e produziu três falhas ArchUnit esperadas: dependência
domain→adapter, application→adapter e contrato REST usado fora da borda. O GREEN converteu essas
violações sintéticas em provas de regressão e confirmou o código de produção. Uma fixture anotada
com `@Unremovable` demonstrou que a regra não cria blacklist genérica de framework. Os seis testes
focados passaram; a suíte completa passou com 21 testes, zero falhas, zero erros e zero ignorados.
O Maven resolveu `com.tngtech.archunit:archunit:1.5.0:test`. A revisão não encontrou alteração de
produção, segredo, I/O, custo de runtime ou dependência invertida. Sonar permanece `UNVERIFIED`
porque o harness ainda não existe.

### Incremento 8 — Observabilidade mínima verificável

**Entrega:** logs, span, métrica e health na feature neutra.

**Estado:** `Checkpoint C aprovado em 2026-08-24; Tasks 8A e 8B autorizadas`.

**Perguntas operacionais que os sinais devem responder:**

1. Quantas normalizações chegam ao HTTP, quais terminam em sucesso ou entrada inválida e com que
   frequência?
2. A normalização está mais lenta que o esperado, inclusive na cauda da distribuição?
3. Um evento de normalização pode ser correlacionado ao span HTTP e ao span interno sem registrar
   o texto recebido?
4. O processo está vivo e pronto para receber chamadas, sem fingir dependências que não existem?

**Contrato observável proposto:**

| Sinal | Contrato estável proposto | Limites de cardinalidade e segurança |
| --- | --- | --- |
| Log | evento `sample.normalize.completed` em `INFO`; MDC `event` com o mesmo nome e `outcome` em `success` ou `invalid`; `traceId` e `spanId` fornecidos pela integração Quarkus/OpenTelemetry | não registrar texto bruto ou normalizado, tamanho, body, header, token, stack trace de validação nem identificador de usuário |
| Span | `sample.normalize`, `SpanKind.INTERNAL`, filho do span HTTP automático; atributo `sample.normalize.outcome` em `success` ou `invalid` | nenhum parâmetro recebe `@SpanAttribute`; não incluir texto, tamanho ou mensagem de exceção em atributos próprios |
| Métrica | timer Micrometer `sample.normalize.duration`, com histogram e tag única `outcome=success|invalid`; o próprio timer fornece contagem e duração | exatamente duas combinações próprias de tags; buckets, count e sum derivam dessas combinações, sem texto, rota bruta, status livre, erro, trace/request ID ou outro valor não limitado |
| HTTP automático | timer Quarkus `http.server.requests`, exportado pelo registro Prometheus com método, template de URI, status e outcome | aceitar somente os labels automáticos documentados; JSON malformado fica visível neste sinal e no span HTTP, pois não entra no caso de uso |
| Health | `GET /q/health/live` e `GET /q/health/ready`, ambos com `200` e `status=UP` enquanto não houver dependência real | não criar check customizado sempre-UP; a extensão expõe checks vazios e projetos derivados acrescentam checks somente para dependências concretas |

O console será JSON compacto, com os campos de correlação e do evento dentro do objeto `mdc`, e
`quarkus.application.name` igual à identidade transitória do template. A propriedade
`quarkus.log.console.json.mdc.flat-fields` não será configurada: ela não existe no artefato exato
`quarkus-logging-json` 3.33.3.1 e, portanto, não altera o formato nessa versão. Traces serão gerados
e correlacionados, mas o exporter será `none` por padrão para não abrir conexão externa; no perfil
de teste, um exporter CDI em memória provará nome, parentesco e atributos. Não haverá formatter
customizado, log em arquivo nem OpenTelemetry Logs, que é preview na linha 3.33.

Os endpoints operacionais ficam na interface HTTP principal, como definido por padrão nas
extensões. Isso é aceitável somente para a prova local sem autenticação já aprovada. Antes de
deploy de um projeto derivado, exposição em interface de gerenciamento e controle de acesso devem
ser especificados e aprovados; este incremento não os inventa.

**Dependências propostas, todas gerenciadas pelo BOM Quarkus 3.33.3.1 salvo a utilidade de teste
também coberta pela plataforma:**

- `io.quarkus:quarkus-logging-json` para o formatter JSON do console;
- `io.quarkus:quarkus-opentelemetry` para trace HTTP, contexto e `@WithSpan` em bean CDI;
- `io.quarkus:quarkus-micrometer-registry-prometheus` para Micrometer, métricas HTTP e
  `/q/metrics` verificável localmente;
- `io.quarkus:quarkus-smallrye-health` para liveness e readiness;
- `io.opentelemetry:opentelemetry-sdk-testing` somente em teste para `InMemorySpanExporter`.

A referência possui as extensões de logging JSON, OpenTelemetry e SmallRye Health, configuração
de console JSON/MDC e producer CDI do exporter em memória. O template destila somente os padrões
suportados pela versão fixada; não replica a configuração sem efeito de MDC plano encontrada na
referência. Também não copia log em arquivo, exporter externo, campos, nomes ou wrappers de
negócio. Como a referência não possui Micrometer, o timer e o endpoint local seguem diretamente o
guia oficial do Quarkus 3.33.

**Task 8A — infraestrutura observável local, três arquivos:**

- `pom.xml`;
- `src/main/resources/application.properties`;
- `src/test/java/template/harness/observability/ObservabilityInfrastructureTest.java`.

O RED exigirá JSON/MDC configurados, exporter sem rede por padrão e CDI em memória nos testes,
`/q/metrics`, `/q/health/live` e `/q/health/ready`. O GREEN adicionará apenas extensões,
configuração e o producer de teste aninhado documentado pelo Quarkus.

**Task 8B — sinais da feature neutra, quatro arquivos:**

- `src/main/java/template/harness/sample/application/NormalizeTextUseCase.java`;
- `src/main/java/template/harness/sample/adapter/in/rest/NormalizeTextResource.java`;
- `src/test/java/template/harness/sample/application/NormalizeTextUseCaseTest.java`;
- `src/test/java/template/harness/observability/ObservabilityContractTest.java`.

O caso de uso passará a ser bean CDI instrumentado e receberá `MeterRegistry` por construtor. O
resource receberá o caso de uso por construtor, preservando o contrato HTTP. O RED provará evento
e MDC correlacionados, span interno e parentesco, timer/histogram com somente dois outcomes e
ausência de um marcador de payload em logs, atributos e labels. O teste unitário continuará
isolado com `SimpleMeterRegistry` real, sem mock.

**Aceitação:** nomes e valores correspondem à tabela; sucesso e entrada inválida são provados;
entrada não aparece em log, span ou label; health e métricas respondem; JSON malformado preserva o
contrato HTTP e não é falsamente atribuído ao caso de uso; nenhuma rede ou credencial é exigida.

**Verificação após aprovação:** RED focado por task, GREEN focado, inspeção dos registros
capturados e do JSON de console, suíte completa e `./mvnw.cmd -q verify`; revisão de correção,
simplicidade, arquitetura, segurança, desempenho, testes e escopo. O checkpoint Sonar continuará
`UNVERIFIED` até os scripts próprios existirem.

**Fontes oficiais:** [logging JSON](https://quarkus.io/extensions/io.quarkus/quarkus-logging-json/),
[OpenTelemetry 3.33](https://quarkus.io/version/3.33/guides/opentelemetry),
[tracing 3.33](https://quarkus.io/version/3.33/guides/opentelemetry-tracing),
[Micrometer 3.33](https://quarkus.io/version/3.33/guides/telemetry-micrometer) e
[SmallRye Health 3.33](https://quarkus.io/version/3.33/guides/smallrye-health).

### Checkpoint C — antes de código, dependência ou configuração

- aprovar ou ajustar as quatro perguntas operacionais;
- aprovar ou ajustar nomes, campos, outcomes, endpoints e ausência de payload;
- aprovar ou ajustar as cinco dependências e o exporter `none` por padrão;
- aceitar que `/q/metrics` e health ficam na interface principal somente nesta prova local;
- autorizar explicitamente as Tasks 8A e 8B antes do primeiro RED.

Depois das duas tasks verificadas, o agente apresentará diff e evidências e parará para revisão
humana do Incremento 8 antes de eventual `GO` para o Incremento 9.

**Decisão:** `APROVADO` pelo humano em 2026-08-24. A aprovação alcança somente o contrato acima e
as Tasks 8A e 8B; não autoriza cobertura, configuração Sonar ou qualquer item do Incremento 9.
Após inspeção do JSON real e do artefato 3.33.3.1, o humano aprovou em 2026-08-24 o ajuste do
formato para o objeto `mdc` aninhado, sem formatter customizado; os nomes, valores, correlação e
limites de segurança do contrato permanecem iguais.

### Incremento 9 — Cobertura e propriedades Sonar

**Entrega:** relatório JaCoCo consumível e configuração sem segredo.

**Arquivos prováveis:**

- `pom.xml`
- `sonar-project.properties`, somente se o Maven não expressar a configuração necessária
- `doc/sonar/sonarqube-local.md`
- `test/powershell/SonarBuildConfigurationTest.ps1`

**Aceitação:** `jacoco.xml` é gerado pelo build real do template, exclusões são justificadas,
nenhum token é persistido e a política 85%/5% está documentada. A configuração é destilada do
padrão da referência sem copiar dependências ou versões que não pertencem ao template.

**Verificação:** `./mvnw -q verify` e teste PowerShell de configuração.

### Incremento 10 — Sessão segura e análise Sonar

**Entrega:** iniciar Codex com token somente em memória e executar análise local.

**Arquivos prováveis:**

- `iniciar-codex-com-sonar.ps1`
- `analisar-sonarqube.ps1`
- `test/powershell/AnalisarSonarQubeTest.ps1`
- `test/powershell/SonarSecretHandlingTest.ps1`

**Aceitação:** token não aparece em argumentos, arquivos ou saída; ausência de token/servidor é
informada sem aprovação falsa; `ProjectKey` e `ProjectName` não carregam identidade da referência;
o script usa o Maven Wrapper e produz metadados para aguardar o Compute Engine.

**Verificação:** testes PowerShell isolados com processos e respostas simuladas.

### Incremento 11 — Baseline, checkpoint e decisão humana

**Entrega:** núcleo do controle Sonar local/offline.

**Arquivos prováveis:**

- `.codex/hooks/SonarQuality.psm1`
- `validar-checkpoint-sonarqube.ps1`
- `test/powershell/SonarQualityGateTest.ps1`
- `test/powershell/SonarQualityApiTest.ps1`
- `test/powershell/SonarOfflineOnlyBaselineTest.ps1`
- `test/powershell/SonarHumanDecisionFlowTest.ps1`

O incremento será entregue em duas tarefas pequenas: **11A**, módulo, API e comparação do gate;
**11B**, orquestração de baseline/checkpoint e decisões humanas.

**Aceitação:** fontes de baseline são explícitas; offline-only é `UNVERIFIED`; `NON_COMPLIANT`
aguarda decisão; fingerprint evita análise por edição isolada; estado fica somente em
`.codex/.state/` e não contém credencial.

**Verificação:** testes PowerShell cobrem baseline, indisponibilidade, thresholds e três decisões humanas.

### Incremento 12 — Hooks Codex e isenção documental

**Entrega:** lembretes de início/parada sem bloqueio indevido.

**Arquivos prováveis:**

- `.codex/hooks.json`
- `.codex/hooks/sonar-session-start.ps1`
- `.codex/hooks/sonar-stop.ps1`
- `test/powershell/SonarAgentHooksTest.ps1`
- `test/powershell/SonarDocumentationOnlyFlowTest.ps1`

**Aceitação:** sessão detecta baseline pendente; stop lembra checkpoint/decisão; Markdown-only não solicita token nem Sonar; hooks não registram decisão humana.

**Verificação:** testes PowerShell com eventos JSON e estados temporários descartáveis.

### Incremento 13 — Exportação e leitura offline

**Entrega:** pacote de evidência imutável tratado como dado não confiável.

**Arquivos prováveis:**

- `exportar-relatorios-sonarqube.ps1`
- `doc/sonar/exportacao-offline.md`
- `sonar/README.md`
- `.gitignore`
- `test/powershell/ExportarRelatoriosSonarQubeTest.ps1`

**Aceitação:** exportação não inclui token; importação não executa instruções do pacote;
comparação entre servidores declara limitações; `sonar/README.md` é versionado, mas pacotes e
relatórios colocados sob `sonar/` continuam ignorados pelo Git.

**Verificação:** testes com fixtures temporárias e conteúdo adversarial.

### Checkpoint D — Harness Sonar

- todos os testes PowerShell passam;
- `jacoco.xml` é produzido e consumido pela análise do template;
- scripts de sessão, análise, baseline, checkpoint e exportação estão presentes e testados;
- hooks distinguem Markdown de fingerprint executável e nunca decidem pelo humano;
- diff não contém segredo, estado ou pacote offline;
- baseline novo é criado somente após escolha humana da fonte;
- se NON_COMPLIANT, humano registra uma das três decisões.

### Incremento 14 — Guia e ensaio de materialização

**Entrega:** procedimento humano-agente para transformar uma cópia do template em projeto real.

**Arquivos prováveis:**

- `doc/guias/materializar-projeto.md`
- `doc/guias/checklist-materializacao.md`
- `test/powershell/MaterializacaoTemplateTest.ps1`, se a verificação estática justificar automação

**Aceitação:** solicita identidade, pacote, goal, capacidades, destino e visibilidade; cria baseline próprio; não transporta histórico do template; tecnologia diferente causa parada explícita.

**Verificação:** ensaio em diretório temporário, build/teste da cópia e auditoria de placeholders e artefatos proibidos.

### Incremento 15 — Verificação integrada e entrega

**Entrega:** evidência final do goal sem encerramento automático.

**Arquivos prováveis:**

- `README.md`
- `goals/template-harness/goal.md`
- `tasks/todo.md`
- documentos afetados por divergências realmente encontradas

**Aceitação:** todos os critérios da spec e do goal têm evidência; arquitetura reflete o estado implementado; limitações estão explícitas; agente para para aceite humano.

**Verificação:** `./mvnw -q verify`, suíte PowerShell, checkpoint Sonar aplicável, auditorias e revisão multidimensional do diff.

## Estratégia de testes

- JUnit para núcleo e aplicação;
- `@QuarkusTest` + REST Assured para HTTP e health;
- ArchUnit para direção de dependência e contratos de borda;
- testes de contrato para logs, spans e métricas;
- JaCoCo para cobertura XML;
- PowerShell isolado para scripts e hooks, sem depender de segredo real;
- ensaio descartável para materialização.

Comandos exatos serão confirmados contra o scaffold gerado e registrados antes da implementação. Nenhum comando será alegado como verificado antes de existir.

## Riscos e mitigação

| Risco | Impacto | Mitigação |
| --- | --- | --- |
| Vazamento de negócio da fonte | Alto | allowlist de artefatos, busca por termos e revisão humana |
| Harness Sonar produzir garantia falsa | Alto | estados UNVERIFIED/NON_COMPLIANT e testes do controle |
| Segredo persistido | Alto | token só no processo, auditoria e testes adversariais |
| Excesso de abstração hexagonal | Médio | portas apenas para fronteira concreta e ArchUnit estrutural |
| Feature neutra contaminar produto | Médio | contrato claramente sample e remoção planejada após prova real |
| Versão LTS ficar defasada | Médio | rotina manual de atualização com fontes oficiais |
| Muitos arquivos em um incremento | Médio | tarefas limitadas a aproximadamente cinco arquivos e commits atômicos |
| Dependência do Windows nos scripts | Médio | escopo explícito PowerShell; portabilidade futura exige nova spec |
| Ausência de CI | Médio | execução local documentada; CI permanece backlog visível |

## Verificações antes de cada commit

- diff staged revisado e coerente;
- nenhuma credencial, estado, relatório ou artefato de build;
- testes focados do incremento;
- suíte proporcional ao risco;
- documentação atualizada quando o estado arquitetural mudar;
- checkpoint humano registrado quando aplicável.

## Autorização de implementação

Em 2026-08-23, o humano aprovou arquitetura, ADRs, plano, checklist e contratos neutros e registrou
`GO` para o Incremento 1. Depois de revisar a entrada operacional, registrou `GO` para o Incremento
2. Os templates de goal e especificação foram concluídos e validados. Após essa revisão, o humano
registrou `GO` para o Incremento 3 em 2026-08-23. O guia e os templates de plano e checklist foram
concluídos e ensaiados com uma feature fictícia somente em memória. A autorização não alcança o
Incremento 4. Em 2026-08-23, o humano aprovou o Checkpoint A e registrou `GO` para a fundação Maven.
A pré-verificação confirmou ausência de pacotes `sonar/` e dos scripts Sonar ainda planejados;
baseline e checkpoint permanecem `UNVERIFIED`, sem equivaler a aprovação. A fundação Maven foi
concluída e verificada em 2026-08-23. Após a revisão, o humano registrou `GO` para o Incremento 5
e aprovou explicitamente as regras de normalização Unicode. O Incremento 5 foi concluído
tecnicamente com sete testes verdes. Em 2026-08-24, o humano registrou `GO` para o Incremento 6 e
aprovou seu contrato no Checkpoint B antes do RED. O Incremento 6 foi concluído tecnicamente com
15 testes verdes. Após revisar essa entrega, o humano registrou `GO` para o Incremento 7 em
2026-08-24. O Incremento 7 foi concluído com 21 testes verdes e posteriormente aprovado pelo
humano. Um novo `GO` em 2026-08-24 autorizou preparar a proposta do Incremento 8. O humano
aprovou explicitamente o Checkpoint C em 2026-08-24, autorizando somente as Tasks 8A e 8B dentro
do contrato observável registrado acima.
