# Plano de implementação — Bootstrap do harness Quarkus

## Estado

- Fase: `PLAN`
- Estado do plano: `Aprovado`
- Goal: `goals/template-harness/goal.md`
- Especificação: `specs/template-harness/spec.md` (`Aprovado`)
- Arquitetura: `doc/arquitetura/arquitetura-harness.md` (`Aceito`)
- ADRs: `doc/adr/README.md` (`Aceitos`)
- Implementação autorizada: **Incremento 2 em execução**
- Próxima decisão: GO humano para o Incremento 3; o Checkpoint A formal ocorre após o Incremento 3.

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

## Contratos aceitos no GO arquitetural

O GO humano de 2026-08-23 aceitou:

1. identidade compilável do template: `template.harness:quarkus-coding-harness-template`, substituída obrigatoriamente na materialização;
2. feature neutra: `sample`, com transformação determinística e sem persistência;
3. endpoint de prova: `POST /api/sample/normalize`, validando texto e retornando valor normalizado e tamanho;
4. logs, spans e métricas da feature neutra, limitados a nomes e atributos de baixa cardinalidade, sem conteúdo recebido;
5. os cinco ADRs em estado `Aceito`.

Esses contratos orientam os incrementos futuros; o GO atual permanece limitado ao Incremento 1.

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

### Incremento 5 — Núcleo e caso de uso neutros por TDD

**Entrega:** primeira fatia do comportamento determinístico, sem adapter.

**Arquivos prováveis:**

- `src/main/java/template/harness/sample/domain/NormalizedText.java`
- `src/main/java/template/harness/sample/application/NormalizeTextUseCase.java`
- `src/test/java/template/harness/sample/domain/NormalizedTextTest.java`
- `src/test/java/template/harness/sample/application/NormalizeTextUseCaseTest.java`

**Aceitação:** RED comprova regras ainda ausentes; GREEN implementa apenas regras aprovadas; REFACTOR preserva testes.

**Verificação:** testes focados e depois `./mvnw -q test`.

### Incremento 6 — Adapter HTTP vertical

**Entrega:** fluxo executável da entrada HTTP ao núcleo.

**Arquivos prováveis:**

- `src/main/java/template/harness/sample/adapter/in/rest/NormalizeTextResource.java`
- `src/main/java/template/harness/sample/adapter/in/rest/NormalizeTextRequest.java`
- `src/main/java/template/harness/sample/adapter/in/rest/NormalizeTextResponse.java`
- `src/test/java/template/harness/sample/adapter/in/rest/NormalizeTextResourceTest.java`
- `src/main/resources/application.properties`

**Aceitação:** contrato aprovado, validação de borda e mapeamento sem DTO no núcleo; sucesso e erro testados.

**Verificação:** teste HTTP focado e `./mvnw -q test`.

### Checkpoint B — Contrato público

- path, verbo, status, JSON, validação e OpenAPI apresentados ao humano;
- nenhuma persistência ou integração externa adicionada;
- GO humano antes de consolidar contrato público.

### Incremento 7 — Regras arquiteturais executáveis

**Entrega:** proteger direção de dependência e independência de bordas.

**Arquivos prováveis:**

- `src/test/java/template/harness/architecture/LayerDependencyTest.java`
- `src/test/java/template/harness/architecture/BoundaryContractTest.java`

**Aceitação:** testes falham para dependência domain→adapter, application→adapter e DTO compartilhado entre bordas; uso pragmático de Quarkus não é bloqueado genericamente.

**Verificação:** testes ArchUnit focados e suíte completa.

### Incremento 8 — Observabilidade mínima verificável

**Entrega:** logs, span, métrica e health na feature neutra.

**Arquivos prováveis:**

- `pom.xml`
- `src/main/resources/application.properties`
- `src/main/java/template/harness/sample/application/NormalizeTextUseCase.java`
- `src/test/java/template/harness/observability/ObservabilityContractTest.java`
- `src/test/java/template/harness/observability/HealthContractTest.java`

**Aceitação:** sinais têm nomes estáveis, correlação e baixa cardinalidade; entrada não aparece em log, span ou label; readiness e liveness respondem.

**Verificação:** testes de contrato, inspeção de logs de teste e `./mvnw -q verify`.

### Checkpoint C — Arquitetura, segurança e comportamento observável

- diff e evidências apresentados ao humano;
- dependências novas justificadas por fonte oficial;
- contrato observável aprovado antes de prosseguir.

### Incremento 9 — Cobertura e propriedades Sonar

**Entrega:** relatório JaCoCo consumível e configuração sem segredo.

**Arquivos prováveis:**

- `pom.xml`
- `sonar-project.properties`, somente se o Maven não expressar a configuração necessária
- `doc/sonar/sonarqube-local.md`
- `test/powershell/SonarBuildConfigurationTest.ps1`

**Aceitação:** `jacoco.xml` é gerado, exclusões são justificadas, nenhum token é persistido e a política 85%/5% está documentada.

**Verificação:** `./mvnw -q verify` e teste PowerShell de configuração.

### Incremento 10 — Sessão segura e análise Sonar

**Entrega:** iniciar Codex com token somente em memória e executar análise local.

**Arquivos prováveis:**

- `iniciar-codex-com-sonar.ps1`
- `analisar-sonarqube.ps1`
- `test/powershell/AnalisarSonarQubeTest.ps1`
- `test/powershell/SonarSecretHandlingTest.ps1`

**Aceitação:** token não aparece em argumentos, arquivos ou saída; ausência de token/servidor é informada sem aprovação falsa.

**Verificação:** testes PowerShell isolados com processos e respostas simuladas.

### Incremento 11 — Baseline, checkpoint e decisão humana

**Entrega:** núcleo do controle Sonar local/offline.

**Arquivos prováveis:**

- `.codex/hooks/SonarQuality.psm1`
- `validar-checkpoint-sonarqube.ps1`
- `test/powershell/SonarQualityGateTest.ps1`
- `test/powershell/SonarOfflineOnlyBaselineTest.ps1`
- `test/powershell/SonarHumanDecisionFlowTest.ps1`

**Aceitação:** fontes de baseline são explícitas; offline-only é `UNVERIFIED`; NON_COMPLIANT aguarda decisão; fingerprint evita análise por edição isolada.

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
- `test/powershell/ExportarRelatoriosSonarQubeTest.ps1`
- `test/powershell/SonarQualityApiTest.ps1`

**Aceitação:** exportação não inclui token; importação não executa instruções do pacote; comparação entre servidores declara limitações.

**Verificação:** testes com fixtures temporárias e conteúdo adversarial.

### Checkpoint D — Harness Sonar

- todos os testes PowerShell passam;
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

Em 2026-08-23, o humano aprovou arquitetura, ADRs, plano, checklist e contratos neutros e registrou `GO` para o Incremento 1. Depois de revisar a entrada operacional, registrou `GO` para o Incremento 2. O GO não se estende automaticamente aos incrementos seguintes. Ao concluir os templates de goal e especificação, o agente para e solicita GO para o Incremento 3. O Checkpoint A formal permanece depois do Incremento 3, quando toda a governança reutilizável estiver implementada.
