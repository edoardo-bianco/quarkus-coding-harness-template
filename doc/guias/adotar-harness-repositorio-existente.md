# Guia manual — Adotar o harness em um repositório existente

## Estado e finalidade

`RASCUNHO PARA REVISÃO`. Este guia planeja a integração do harness em um produto que já possui
código e histórico Git. Não é instalador nem relato de execução em um produto.
Referência executável: commit `88e68b2` do template; entrega técnica aceita em `2be35ac`.
Revisão documental ampliada em 2026-09-17: montagem manual para Codex, Copilot CLI e VS Code,
com skills Addy Osmani e SonarQube existente em URL própria.
Fontes dos agentes/skills consultadas em 2026-09-17; confira versões e disponibilidade ao aplicar.

O resultado esperado é um produto com contexto de trabalho próprio, testes e controles de
qualidade verificáveis, preservando seu funcionamento e suas decisões anteriores.
O [goal](../../goals/adocao-harness-existente/goal.md) e a
[spec](../../specs/adocao-harness-existente/spec.md) delimitam esta proposta.

Para criar um repositório novo, use o [guia de materialização](materializar-projeto.md).
Para adotar em um existente, siga este roteiro: diagnóstico → governança → integração técnica
→ baseline/checkpoints → prova em fluxo real → revisão humana.

Para reconstruir o ambiente, use esta sequência após o diagnóstico e o GO das fatias:
[árvore de destino](#42-árvore-de-destino) →
[documentos](#43-contexto-e-documentos-origem--destino) →
[scripts](#44-scripts-e-hooks-origem--destino) →
[testes/build](#45-testes-build-e-exclusões) →
[skills](#46-instalar-manualmente-as-skills-addy-osmani) →
[Codex](#47-conectar-o-codex) ou [Copilot](#48-conectar-o-github-copilot-cli-e-o-vs-code) →
[Sonar existente](#credencial-fonte-e-comandos-do-harness) →
[verificação](#7-validar-documentar-e-revisar-a-adoção).

Codex possui hooks no template. Copilot CLI e VS Code terão instruções/skills e operação manual
dos checkpoints; automação equivalente dos hooks continua pendente de implementação e ensaio.
Este guia documenta instalação e comandos, sem ter executado essas rotas em produto.
Para testar com o desenvolvedor executando os scripts e o agente aguardando/retomando, siga o
[roteiro de ensaio Copilot CLI e VS Code](ensaio-manual-copilot.md). Ele também explica a futura
verificação dos lembretes equivalentes, preservando o comportamento do harness.


## 1. Confirmar o alvo e a compatibilidade

Antes de modificar arquivos, registre no plano de adoção do produto:

| Entrada | O que confirmar |
| --- | --- |
| Repositório | Caminho absoluto, identidade do produto e responsável humano |
| Git | Branch-base, HEAD, estado de trabalho, remotos e regras de revisão existentes |
| Stack | JDK, Quarkus, Maven/Wrapper, PowerShell e ambiente de desenvolvimento |
| Estrutura | POM raiz, módulos, caminhos de código/teste, fontes geradas e recursos |
| Operação | Contratos públicos, integrações, banco/broker, dados e serviços envolvidos nos testes |
| Build | Comandos e perfis realmente usados; efeitos de plugins, testes e migrações |
| Controles | Instruções de agentes, documentação, ADRs, hooks, CI/CD, cobertura e Sonar existentes |
| Objetivo | Benefício da adoção, capacidades faltantes, critérios de pronto e fora de escopo |
| Permissões | Quem aprova mudanças, uso do servidor Sonar, branch, push e merge |

Esta versão suporta adoção técnica em **Java 25 + Quarkus LTS + Maven**, com scripts PowerShell.
A referência foi verificada em Java 25, Quarkus 3.33.3.1, Maven Wrapper 3.9.16 e Windows.
Não é garantia de compatibilidade com outro patch, sistema operacional ou layout.

Se a stack divergir, pare a integração executável e registre a incompatibilidade.
Mudança de versão ou tecnologia precisa de spec e GO próprios; não atualize o produto para
encaixá-lo no template. Documentar o diagnóstico não equivale a suporte técnico para outra stack.

### Levantamento manual

Na raiz confirmada do produto, comandos iniciais de leitura:

```powershell
git status -sb
git rev-parse --show-toplevel
git rev-parse --verify HEAD
git branch --show-current
git remote
git ls-files
```

Inspecione URLs dos remotos localmente sem transportar credenciais embutidas para relatórios.
Leia instruções vigentes, POMs, configuração, pipelines e testes relacionados ao fluxo piloto.
Não execute indiscriminadamente scripts encontrados no repositório.

Confirme disponibilidade de Git, JDK 25, PowerShell 7 e Maven Wrapper. O launcher exige que o
comando do agente escolhido esteja instalado e autenticado. Para Sonar já instalado, confirme
URL, projeto e acesso a partir da máquina de desenvolvimento; Docker só é pré-requisito se você
escolher hospedar uma instância local em container. Preserve instâncias/volumes existentes.
Instalação ausente é pré-requisito pendente, não justificativa para instalar versões arbitrárias.
Aprovar versão/recursos da instância e sua criação é uma tarefa operacional anterior à análise.

**Saída:** inventário real, lacunas e incompatibilidades. Sem alvo informado, esta etapa permanece
`NÃO_EXECUTADA`.

## 2. Preservar o produto e registrar o estado anterior

- Preserve `.git`, commits, tags, remotos, branches, releases e histórico do produto.
- Preserve `groupId`, `artifactId`, versão, pacotes, nome da aplicação e identidade Sonar existentes.
- Preserve APIs, schemas, migrations, políticas de segurança, observabilidade e configuração de deploy.
- Não substitua `pom.xml`, `src/`, README, AGENTS, hooks ou pipelines pelos arquivos completos do template.
- Não importe `sample`, endpoints de demonstração ou evidências do bootstrap.
- Não reinicialize Git nem use o procedimento de apagar/recriar contexto de um projeto novo.

Se houver trabalho não commitado, registre-o e combine sua separação; não use reset, clean ou
stash automático. Crie uma branch curta de adoção a partir da revisão acordada. Um clone/worktree
de trabalho pode isolar o ensaio, preservando o histórico existente; não precisa de histórico novo.

Registre a revisão anterior no plano. Antes da primeira alteração executável, produza a evidência
de build/testes do estado atual, depois de conferir que seus efeitos usam recursos de teste.
Se a fatia ainda for exclusivamente Markdown, aplique a isenção e deixe essa medição para a
pré-verificação da fatia executável.

Use os comandos já estabelecidos pelo produto. Somente quando o Wrapper existir e o lifecycle
estiver seguro e confirmado, o comando padrão pode ser:

```powershell
.\mvnw.cmd -q verify
```

Não remova perfis necessários nem aponte testes para credenciais/dados de produção.
Se o build existente falhar, registre teste, causa conhecida/desconhecida e revisão. Não trate a
falha como causada pela adoção nem prossiga declarando baseline verde. Correções exigem fatia e GO.

**Saída:** identidade e histórico preservados, revisão anterior identificada, falhas e verificações
anteriores registradas ou limitações explícitas.

## 3. Criar o contexto de adoção e aprovar o plano

O produto pode já ter documentação equivalente. Integre e vincule-a; crie apenas o que faltar:

| Artefato no produto | Conteúdo esperado |
| --- | --- |
| Goal de adoção | Valor, escopo, pronto, evidências, riscos e condições de parada |
| Spec de adoção | Controles a integrar, limites, compatibilidade e critérios verificáveis |
| Arquitetura atual | Como o produto funciona hoje; divergências e propostas separadas do estado real |
| ADRs | Preservar decisões existentes; novos controles começam como propostas quando exigirem decisão |
| Plano e checklist | Fatias pequenas, arquivos, dependências, testes, checkpoints e reversão |
| AGENTS e README | Navegação para o goal ativo e as tasks reais, instruções e autoridade do produto |

Um nome possível de organização é `goals/adocao-harness/`, `specs/adocao-harness/` e
`tasks/features/adocao-harness/`. Se o produto já usa outros caminhos, preserve a convenção e
corrija todos os links. Não copie literalmente links relativos de templates para outra profundidade.

O goal de adoção convive com os goals de negócio existentes. Não apague nem encerre esses goals.
Registre a revisão do template usado como referência; nenhum GO, aceite, ADR ou métrica do
template passa a ser uma decisão/evidência do produto.

Integre instruções do `AGENTS.md` por revisão de diferenças. Conflitos com regras organizacionais
exigem decisão do responsável; não substitua controles mais fortes silenciosamente.
Mantenha os critérios de Sonar e autoridade explícitos, incluindo a isenção exclusivamente Markdown.

**Checkpoint humano:** aprovar objetivo, spec, compatibilidade, arquitetura/ADRs aplicáveis,
plano e GO da primeira fatia executável. A leitura deste guia não concede esse GO.

## 4. Reconstruir manualmente as pastas e os arquivos

### 4.1. Separar origem, destino e modo de integração

Abra lado a lado no Explorer ou no editor:

- **Origem H:** checkout do template na revisão registrada, sem alterações locais.
- **Origem S:** checkout de [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills),
  em revisão escolhida e registrada por SHA. Não use a instalação pessoal como única origem.
- **Destino P:** raiz do repositório existente, na branch de adoção acordada.

A cópia de arquivos executáveis só começa após o GO da fatia e a pré-verificação da etapa 5.
As tabelas são um inventário completo para planejar essas fatias, não uma autorização de cópia em lote.

Ative a exibição de arquivos ocultos. Crie somente diretórios ausentes. Em cada linha, confira
o conteúdo de origem, copie para o destino indicado e revise o diff. Se o arquivo já existir,
compare e mescle manualmente; cancele a substituição automática oferecida pelo Explorer.
Preserve hooks, regras, versões e arquivos de outras ferramentas já instaladas.

**Copiar** significa transferir o arquivo inteiro quando ainda não existe.
**Mesclar** significa integrar somente os trechos necessários.
**Criar/adaptar** significa escrever conteúdo próprio a partir da referência.
Uma capacidade equivalente já instalada pode atender à linha, desde que tenha evidência.

### 4.2. Árvore de destino

Este exemplo usa os caminhos documentais da etapa 3. Preserve a convenção existente do produto
quando houver e ajuste os links. A estrutura de `src/` continua sendo a do produto.

```text
<repositorio-existente>/
  AGENTS.md                              # mesclar regras e caminhos próprios
  README.md                              # mesclar entrada operacional
  pom.xml                                # mesclar build/cobertura aprovados
  mvnw
  mvnw.cmd
  iniciar-codex-com-sonar.ps1
  analisar-sonarqube.ps1
  validar-checkpoint-sonarqube.ps1
  exportar-relatorios-sonarqube.ps1
  .mvn/wrapper/maven-wrapper.properties
  .codex/
    hooks.json                           # ativação somente para Codex
    hooks/
      SonarQuality.psm1                 # também usado pelos scripts manuais
      sonar-session-start.ps1
      sonar-stop.ps1
    .state/                              # gerado localmente; nunca copiar
  .github/
    copilot-instructions.md              # criar/mesclar para Copilot
  .agents/
    skills/<nome-da-skill>/SKILL.md       # copiar diretório completo da skill
    references/                          # recursos compartilhados de S
    LICENSE.addyosmani-agent-skills
    README.md                            # origem, SHA, seleção e adaptações
  goals/
    README.md
    templates/goal.md
    adocao-harness/goal.md
  specs/
    README.md
    templates/spec.md
    adocao-harness/spec.md
  tasks/
    README.md
    templates/plan.md
    templates/todo.md
    features/adocao-harness/plan.md
    features/adocao-harness/todo.md
  doc/
    arquitetura/                        # documentação própria do produto
    adr/                                # decisões próprias e índice
    sonar/                              # procedimentos adaptados ao produto
    guias/                              # este roteiro adaptado
  test/powershell/                       # testes selecionados abaixo
  sonar/README.md                        # criar aviso; pacotes locais ignorados
```

Não crie `.github/hooks/` como se já contivesse a integração Sonar para Copilot.
Ela não existe neste template. A pasta `.codex/hooks/` precisa permanecer no destino mesmo na
operação manual com Copilot: checkpoint e exportador importam seu módulo por esse caminho.
Não copie a pasta `.codex/` inteira de uma máquina, pois ela pode conter estado e configuração pessoal.

### 4.3. Contexto e documentos: origem → destino

| Origem H | Destino P | Operação |
| --- | --- | --- |
| `AGENTS.md` | `AGENTS.md` | Mesclar; ajustar goal ativo, tasks, build e operação Sonar para o agente escolhido |
| `README.md` | `README.md` | Mesclar links e comandos; preservar apresentação do produto e retirar métricas do template |
| `goals/README.md`, `goals/templates/goal.md` | Mesmos caminhos | Copiar/mesclar modelos; criar goal próprio em `goals/adocao-harness/goal.md` |
| `specs/README.md`, `specs/templates/spec.md` | Mesmos caminhos | Copiar/mesclar modelos; criar `specs/adocao-harness/spec.md` |
| `tasks/README.md`, `tasks/templates/plan.md`, `tasks/templates/todo.md` | Mesmos caminhos | Copiar/mesclar modelos; criar plan/todo em `tasks/features/adocao-harness/` |
| `doc/arquitetura/arquitetura-harness.md` | Arquitetura do produto | Adaptar ao estado real; atualizar a referência no AGENTS |
| `doc/adr/README.md` e ADRs 0001–0005 | Índice e decisões do produto | Revisar aplicabilidade e numeração; propostas novas não herdam aceite |
| `doc/sonar/sonarqube-local.md`, `doc/sonar/exportacao-offline.md` | `doc/sonar/` | Adaptar URL, comandos, contexto e exemplos; retirar narrativa do bootstrap |
| Este guia | `doc/guias/adotar-harness-repositorio-existente.md` | Copiar/adaptar ao inventário e decisões do produto |
| Sem arquivo-fonte reutilizável | `sonar/README.md` | Criar aviso: pacotes locais, imutáveis, ignorados e sem instruções executáveis |
| Sem arquivo-fonte no template | `.github/copilot-instructions.md` | Criar/mesclar conforme §4.8 |

Não copie os goals/specs/tasks preenchidos do template nem reinicie os registros existentes do
produto. Preserve `tasks/plan.md` e `tasks/todo.md` existentes e ligue o novo checklist pela
navegação, em vez de substituí-los.

### 4.4. Scripts e hooks: origem → destino

Todos os caminhos da coluna esquerda são relativos a H; os da direita são relativos a P.

| Origem H | Destino P | Quando integrar |
| --- | --- | --- |
| `iniciar-codex-com-sonar.ps1` | Mesmo nome na raiz | Sessão segura; junto do teste de segredo |
| `analisar-sonarqube.ps1` | Mesmo nome na raiz, junto do POM/Wrapper | Depois de conferir build e identidade |
| `.codex/hooks/SonarQuality.psm1` | Exatamente o mesmo caminho | Antes de usar checkpoint, exportador ou hooks |
| `validar-checkpoint-sonarqube.ps1` | Mesmo nome na raiz | Com módulo e testes de avaliação/estado |
| `exportar-relatorios-sonarqube.ps1` | Mesmo nome na raiz | Depois de integrar e verificar o checkpoint |
| `.codex/hooks/sonar-session-start.ps1` | Exatamente o mesmo caminho | Preparação dos lembretes Codex |
| `.codex/hooks/sonar-stop.ps1` | Exatamente o mesmo caminho | Preparação dos lembretes Codex |
| `.codex/hooks.json` | Exatamente o mesmo caminho | Mesclar e ativar por último, somente no Codex, após os testes |

Preserve a capitalização dos arquivos para ambientes que distinguem maiúsculas/minúsculas.
Não altere `localhost` por substituição global nos scripts: a URL é parâmetro das chamadas da etapa 5.
Copiar script não o executa nem instala servidor, scanner, JDK, PowerShell ou agente.

### 4.5. Testes, build e exclusões

Copie os testes aplicáveis de `H/test/powershell/` para `P/test/powershell/`, um arquivo por linha
abaixo, junto da capacidade correspondente. Leia-os antes: eles executam subprocessos e criam
fixtures temporárias. Adapte as expectativas ao contrato aprovado do produto.

| Arquivo | Capacidade verificada |
| --- | --- |
| `SonarSecretHandlingTest.ps1` | Launcher, herança de ambiente e limpeza |
| `AnalisarSonarQubeTest.ps1` | Comando Maven, identidade, indisponibilidade e metadados |
| `SonarQualityApiTest.ps1` | Consulta e normalização da API |
| `SonarQualityGateTest.ps1` | Política e comparação |
| `SonarHumanDecisionFlowTest.ps1` | Baseline, checkpoint e decisão humana |
| `SonarOfflineOnlyBaselineTest.ps1` | Baseline offline sem token e limites de caminhos |
| `SonarAgentHooksTest.ps1` | Eventos e estado dos hooks Codex |
| `SonarDocumentationOnlyFlowTest.ps1` | Isenção documental no layout ensaiado |
| `ExportarRelatoriosSonarQubeTest.ps1` | Exportação sanitizada e imutável |
| `SonarBuildConfigurationTest.ps1` | Configuração de cobertura; adaptar POM/caminhos/assertivas |

`MaterializacaoTemplateTest.ps1` trata da criação de projeto novo e não integra a suíte de adoção.
Registre essa exclusão de aplicabilidade; não remova testes existentes do produto.

Para Java, use estas origens como referência, copiando/adaptando somente os testes e fixtures
necessários para os pacotes e contratos reais:

- `src/test/java/template/harness/architecture/LayerDependencyTest.java`;
- `src/test/java/template/harness/architecture/BoundaryContractTest.java`;
- fixtures `DomainAdapterDependencyViolation.java` e `ApplicationAdapterDependencyViolation.java`,
  em `src/test/java/template/harness/sample/domain/fixture/` e
  `src/test/java/template/harness/sample/application/fixture/`;
- `src/test/java/template/harness/observability/ObservabilityInfrastructureTest.java`;
- `src/test/java/template/harness/observability/ObservabilityContractTest.java`.

Atualize packages, imports, `ROOT_PACKAGE`, DTO usado para localizar classes, endpoint,
nome da aplicação e contrato dos sinais. Não importe `sample` ou seu endpoint para satisfazer os testes.

| Arquivo existente em P | Trechos de H a avaliar | Critério de integração |
| --- | --- | --- |
| `pom.xml` | `io.quarkus:quarkus-jacoco` em escopo test; `sonar.coverage.jacoco.xmlReportPaths`; `argLine` em Surefire/Failsafe | Preservar instrumentação/perfis válidos; XML deve medir os módulos reais e ser consumido pelo scanner |
| `pom.xml` | `com.tngtech.archunit:archunit`, `quarkus-junit`, REST Assured e `opentelemetry-sdk-testing` | Somente dependências exigidas pelos testes adaptados, com versões compatíveis |
| `pom.xml` e configuração | Logging JSON, OpenTelemetry, Micrometer/Prometheus e SmallRye Health | Conferir o que já existe; mudanças observáveis exigem checkpoint próprio |
| `mvnw`, `mvnw.cmd`, `.mvn/wrapper/maven-wrapper.properties` | Wrapper completo da referência | Preservar o existente quando adequado; se faltar, copiar o conjunto após aprovação de versão/checksum |
| `src/main/resources/application.properties` | Configuração de logs/traces da referência | Mesclar somente lacunas; preservar nome, perfis, exporters, health e destinos do produto |
| `.gitignore` | `.codex/.state/`, `target/`, `.quarkus/`, segredos/logs e pacotes Sonar | Mesclar; conferir arquivos já versionados e colisões com conteúdo legítimo |

Para pacotes offline novos, o padrão de exclusão de referência é:

```gitignore
/sonar/*
!/sonar/README.md
.codex/.state/
```

Não copie `.git/`, `.codex/.state/`, pacotes `sonar/`, `target/`, `.env`, logs, configuração
pessoal, histórico operacional ou binários do template. O estado válido do próprio produto deve
ser preservado. Uma regra de ignore não retira arquivos já versionados.

### Limitações encontradas no código do harness

- O fingerprint atual varre `src/`, `.mvn/`, `.codex/hooks/`, `test/powershell/`, arquivos
  POM/Wrapper/hooks.json da raiz e scripts `*.ps1` da raiz. Não cobre automaticamente
  `modulo-a/src/`, outros POMs, CI YAML, scripts em `.agents/skills/`, `.github/hooks/`
  ou todos os arquivos executáveis de um produto.
- Dentro dos diretórios monitorados, a função inclui todos os arquivos, inclusive `.md`.
  O teste documental atual cobre README na raiz e Markdown em `doc/`; não comprova isenção
  em qualquer caminho. A isenção do AGENTS continua válida: registre eventual lembrete indevido
  e planeje a correção com regressão, sem executar Sonar só para satisfazer o hook.
- Portanto, não habilite o lembrete como prova de cobertura completa em um layout diferente.
  Especifique os caminhos necessários e teste que alteração em cada módulo/controle relevante muda
  o hash, e que Markdown permanece isento. Essa adaptação é código e exige GO e regressão.
- O analisador pressupõe POM/Wrapper na raiz do script e executa `clean verify` mais scanner fixado.
  Não aceita parâmetros para perfis, seleção de módulos ou propriedades adicionais. Se o produto
  depender deles, pare essa integração e planeje a adaptação; não retire requisitos do build.
- A chave padrão vem do XML do POM como `groupId:artifactId`, com fallback do groupId do parent.
  Propriedades Maven/interpolação e identidades existentes exigem conferência; não presuma que
  a identidade extraída seja a que o produto já usa no Sonar.
- Os scripts não expõem configuração de branch Sonar. Confirme que uma análise da branch de
  adoção não substituirá indevidamente o histórico de outra branch. Se necessário, use projeto
  local isolado autorizado e registre os limites da comparação, sem mudar o Sonar de produção.
- `SonarBuildConfigurationTest.ps1` valida o POM/caminho de cobertura específico do template;
  `MaterializacaoTemplateTest.ps1` verifica o guia para projetos novos. Não use sua cópia literal
  como prova de adequação do produto; revise aplicabilidade e escreva regressões do contrato real.
- Não elimine instrumentação válida para satisfazer uma asserção copiada. Confirme a estratégia
  de cobertura existente e evite instrumentação duplicada ou exclusão de produção para elevar métricas.

Consulte os arquivos citados em [test/powershell/](../../test/powershell/) e os testes Java de
[arquitetura](../../src/test/java/template/harness/architecture/) e
[observabilidade](../../src/test/java/template/harness/observability/).

### 4.6. Instalar manualmente as skills Addy Osmani

O harness deste repositório não contém o pacote de skills. Para uma instalação reproduzível
compartilhada entre os três ambientes, este guia propõe **escopo do repositório em `.agents/`**.
Codex e Copilot reconhecem `.agents/skills/`; registre e confira o escopo usado, pois uma
instalação pessoal não acompanha um clone do produto.
Fontes: [OpenAI — skills locais](https://learn.chatgpt.com/docs/build-skills) e
[GitHub — instalação de skills](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/add-skills).

1. Obtenha a revisão escolhida de S em diretório separado de P. Registre URL e SHA de S no
   plano; uma branch móvel não basta para reproduzir a instalação depois.
2. Leia o catálogo da revisão, as skills escolhidas e seus recursos. Preserve a licença de S.
3. Para reproduzir o pacote completo, copie **cada subpasta de `S/skills/`** para
   `P/.agents/skills/`, mantendo o nome. Não crie `.agents/skills/skills/`.
4. Copie **todo `S/references/`** para `P/.agents/references/`.
5. Copie `S/LICENSE` para `P/.agents/LICENSE.addyosmani-agent-skills` e crie
   `P/.agents/README.md` com origem, SHA, data, lista instalada, escopo e adaptações locais.
6. Dentro de cada skill, preserve também `scripts/`, `references/`, `assets/` e outros
   recursos que existirem. Não copie só o arquivo `SKILL.md`.
7. Confira todos os caminhos relativos referenciados. Por exemplo,
   `.agents/skills/using-agent-skills/../../references/definition-of-done.md`
   precisa resolver para `.agents/references/definition-of-done.md`.
8. Revise o diff, registre a origem e inicie uma nova sessão para conferir descoberta.

A distribuição de S contém [referências compartilhadas](https://github.com/addyosmani/agent-skills/tree/main/references);
a instalação parcial pode omiti-las. Copiar `skills/` e `references/` como irmãs preserva
o caminho `../../references/` observado nas skills.
Não copie os `AGENTS.md`/`CLAUDE.md` da raiz de S: são instruções para desenvolver o pacote,
não regras do seu produto. Veja a [orientação da origem](https://github.com/addyosmani/agent-skills/blob/main/docs/getting-started.md).

**Seleção de uso para este harness:** o pacote pode ficar instalado completo; carregue apenas
as skills pertinentes à tarefa. Se preferir instalar um subconjunto, estas são as recomendadas
para o fluxo Java/Quarkus e seus controles, preservando também seus recursos:

| Momento | Skills |
| --- | --- |
| Entender requisitos e contexto | `spec-driven-development`, `context-engineering` |
| Planejar | `planning-and-task-breakdown` |
| Implementar e testar | `incremental-implementation`, `test-driven-development` |
| Investigar falha | `debugging-and-error-recovery` |
| Revisar e proteger | `code-review-and-quality`, `security-and-hardening` |
| Versionar e registrar decisões | `git-workflow-and-versioning`, `documentation-and-adrs` |
| Contratos, bibliotecas e sinais | `api-and-interface-design`, `source-driven-development`, `observability-and-instrumentation` |

Use `interview-me`/`idea-refine` para requisitos incertos, `code-simplification` para refatoração,
`performance-optimization` quando houver demanda de desempenho e skills de UI, browser, CI/CD
ou deploy somente quando a tarefa exigir. `doubt-driven-development` pode exigir subagentes;
confira capacidades e autorização antes de adotá-la. Nenhuma dessas skills instala Sonar,
implementa hooks ou fornece automaticamente ferramentas MCP.

`using-agent-skills` pode permanecer instalada, mas não cole seu conteúdo inteiro como
instrução permanente quando o agente já faz descoberta nativa. Essa distinção está no
[guia Codex do pacote](https://github.com/addyosmani/agent-skills/blob/main/docs/codex-setup.md).
Mantenha em AGENTS regras curtas: usar a skill pertinente, verificar suas dependências e seguir
o goal/spec/checklist do produto. Resolva conflitos com as regras do produto antes de aplicar
uma recomendação genérica; não troque Maven por comandos npm copiados de exemplos.

Se optar por instalação pessoal equivalente à usada nesta máquina, os destinos correspondentes
são `~/.agents/skills/` e `~/.agents/references/`; registre também essa dependência no produto.
Evite duplicar a mesma skill em escopo pessoal, no projeto e em plugin sem conferir qual cópia
o agente utiliza. Para atualizar, selecione outra revisão, compare skills e recursos juntos,
preserve adaptações e repita a verificação; não sobrescreva a instalação silenciosamente.

Instaladores/plugins são alternativas à cópia manual, descritas pela origem para
[Codex](https://github.com/addyosmani/agent-skills/blob/main/docs/codex-setup.md) e
[Copilot CLI](https://github.com/addyosmani/agent-skills/blob/main/docs/copilot-cli-setup.md).
Não combine rotas para instalar duas vezes o mesmo conteúdo.

### 4.7. Conectar o Codex

1. Na raiz de P, revise `AGENTS.md` e eventuais instruções pessoais ou de subdiretórios.
   Confirme que a sessão abriu o repositório e o checklist corretos.
2. Confirme a descoberta das skills de `.agents/skills/` e invoque uma pelo nome, pedindo
   apenas diagnóstico ou revisão, sem alterar arquivos.
3. Copie/mescle `.codex/hooks.json` somente após os scripts, módulo e testes correspondentes.
   Revise e confie na configuração local pelo mecanismo do Codex instalado. Não desative
   proteções para forçar carregamento. A documentação oficial exige confiança da camada do
   projeto e informa que hooks de várias origens podem se acumular.
4. Após o GO e a integração do launcher, use a sessão segura da etapa 5 para análises reais.

As regras do produto ficam no [AGENTS.md](https://learn.chatgpt.com/docs/agent-configuration/agents-md);
a configuração dos eventos fica em [hooks](https://learn.chatgpt.com/docs/hooks).
Confirme no runtime que `SessionStart` e `Stop` são carregados e os lembretes aparecem.
Testes PowerShell do protocolo não comprovam sozinhos essa integração com a versão instalada.

### 4.8. Conectar o GitHub Copilot CLI e o VS Code

Crie ou mescle `.github/copilot-instructions.md` no produto com uma entrada curta como a
seguinte, ajustando os caminhos da etapa 3:

```markdown
Leia AGENTS.md na raiz e siga as instruções aplicáveis ao arquivo trabalhado.
O goal de adoção está em goals/adocao-harness/goal.md.
Requisitos em specs/adocao-harness/spec.md; próximo item em tasks/features/adocao-harness/todo.md.
Use as skills pertinentes de .agents/skills/ e confira seus recursos compartilhados.
Confirme o GO da fatia antes de alterar código, build, scripts ou hooks.
Para somente Markdown, não execute Maven nem Sonar.
Execute o checkpoint Sonar manual após cada incremento executável aprovado.
Use a URL e a identidade registradas no plano; não solicite nem imprima token no chat.
Registre evidências reais; somente o humano aprova, aceita exceções e encerra o goal.
```

O arquivo é uma proposta para o produto; não existe pronto neste template. No VS Code,
`AGENTS.md` também é reconhecido quando seu suporte está habilitado. Preserve instruções
organizacionais e outras regras já aplicáveis.
Fonte: [VS Code — instruções do agente](https://code.visualstudio.com/docs/agent-customization/custom-instructions).

**Copilot CLI:** abra P no terminal, confirme o comando `copilot` e a autenticação do agente.
As skills podem estar no projeto ou no perfil pessoal; use `/skills list` para conferir a
descoberta e solicite uma skill pelo nome. A autenticação do Copilot é distinta da credencial
do Sonar. A sessão segura por `-CodexCommand copilot` está explicada na etapa 5 como procedimento
a ensaiar. Fonte: [guia do pacote para Copilot CLI](https://github.com/addyosmani/agent-skills/blob/main/docs/copilot-cli-setup.md).

**VS Code:** abra a pasta P, use Copilot em modo agente e confira `.github/copilot-instructions.md`
e o suporte a AGENTS nas configurações. Abra `/skills` no chat e confira as skills detectadas;
invoque, por exemplo, `/spec-driven-development` para uma revisão documental.
Não copie novamente as skills para `.github/skills/` se já usar a rota comum `.agents/skills/`.
Fonte: [VS Code — descoberta e uso de skills](https://code.visualstudio.com/docs/agent-customization/agent-skills).

**Lembretes automáticos:** este template não entrega configuração Sonar nativa para Copilot.
Os formatos, caminhos e respostas dos hooks devem ser comparados com o runtime escolhido;
não basta mover `.codex/hooks.json` para `.github/hooks/`. Mesmo quando nomes de eventos ou
payloads são compatíveis, falta provar que o aviso chega ao agente e que nenhuma decisão
humana é tomada pelo hook. Consulte a [referência dos hooks Copilot](https://docs.github.com/en/copilot/reference/hooks-reference).
Copilot CLI e VS Code usam aqui o procedimento de checkpoints manuais.
No [ensaio com execução humana](ensaio-manual-copilot.md), o agente prepara o comando, aguarda
sua mensagem com o resultado e retoma a partir da evidência. Configurar lembretes equivalentes
é uma etapa de integração possível; não significa executar Sonar automaticamente. Se a spec do produto
exigir lembretes automáticos nos três agentes, registre essa parte como pendente e planeje
a implementação/testes dos adapters antes de declarar o harness completo.

**Saída:** matriz completa e lista de adaptações aprováveis. Capacidade faltante não pode ser
marcada como instalada só porque seu arquivo foi copiado.

## 5. Integrar por fatias e estabelecer o baseline correto

### Produto já possui harness/baseline próprio compatível

Antes da primeira mudança executável, siga o fluxo de baseline previsto nas instruções do produto.
Confira identidade, origem, revisão e escopo do estado existente. Preserve o baseline válido;
não execute `-InitializeBaseline` de novo para esconder diferenças ou dívida.

Depois de cada fatia, execute o checkpoint correspondente. Se o estado for incompatível, registre
a limitação e proponha sua transição; não apague `.codex/.state` para fazer os testes passarem.

### Produto possui Sonar, mas não possui este harness

A análise anterior do produto é evidência anterior à adoção, não um arquivo de estado automaticamente
compatível. Preserve projeto, histórico, configurações e regras. Defina como inicializar o estado
do harness a partir de análise própria, na identidade/local autorizados, sem copiar estado de outro repo.
Diferenças de servidor, perfil, versão, escopo ou branch limitam comparações e devem ficar registradas.

### Produto ainda não possui ferramentas de baseline

Registre `UNVERIFIED` e a ausência concreta. Obtenha GO para um bootstrap mínimo do harness,
com limites e verificações próprios; isso não autoriza refatorar o produto sem baseline.
Integre primeiro as ferramentas necessárias, seus testes, exclusões locais e cobertura compatível.
Faça fatias pequenas, normalmente até cinco arquivos, com dependências explícitas.

A ordem é:

1. launcher e teste de segredo;
2. analisador e teste do comando de build/identidade;
3. módulo de qualidade, checkpoint e testes de API/política/decisão;
4. cobertura XML, se ausente, com teste e build próprios;
5. revisão, testes e commit local da preparação;
6. inicialização do baseline próprio antes das próximas alterações executáveis;
7. hooks e exportação offline, em fatias posteriores com seus testes e checkpoints.

Os itens podem usar capacidades equivalentes já existentes, conforme a matriz aprovada.
Se uma fatia exigir mais de cinco arquivos, decomponha seus testes e integração de forma verificável.
Não mantenha a aplicação real fora do escopo analisado para fabricar conformidade.

Antes da primeira análise, confirme revisão Git válida; diferentemente de um projeto novo, o histórico
do produto já existe. Registre o commit local que contém a preparação verificada e confirme `HEAD`.
Não inicie análise em paralelo ao commit.

### Credencial, fonte e comandos do harness

#### Preparar um SonarQube já instalado, com URL própria

Confirme com o responsável a URL completa do servidor (incluindo porta/contexto quando houver),
a chave e o nome do projeto, permissões de análise/leitura, versão, perfil de qualidade e branch
atingida. O servidor pode estar em outra máquina. Não é necessário criar Docker local quando
a instância existente for a escolhida; não copie banco, volumes ou configuração do seu servidor.

Os scripts aceitam `-SonarUrl` HTTP/HTTPS e usam `http://localhost:9000` apenas como padrão.
A URL não contém credencial. Confirme acesso de rede e certificados no ambiente que executará
PowerShell e Maven. Compatibilidade com APIs, autenticação intermediária e configuração de outro
servidor precisa ser verificada no produto; aceitar o parâmetro não comprova interoperabilidade.

Esta etapa só começa após integrar/revisar scripts, build e efeitos, e escolher projeto/branch
autorizados. Uma análise de validação pode atualizar o projeto Sonar: não use inadvertidamente
a identidade de outra aplicação ou o histórico protegido de outra branch.

#### Abrir a sessão com a credencial somente em memória

Escolha a rota do agente para análise com servidor. Para baseline exclusivamente offline,
pule esta subseção e vá à definição dos valores públicos; token e launcher não são exigidos.

**Codex CLI**, na raiz de P, após integrar o launcher:

```powershell
.\iniciar-codex-com-sonar.ps1
```

**Copilot CLI**, na raiz de P, como variante a ensaiar:

```powershell
.\iniciar-codex-com-sonar.ps1 -CodexCommand "copilot"
```

O parâmetro `-CodexCommand` já existe no launcher: ele seleciona o processo filho. O mecanismo de
herança/argumentos tem teste com processo sintético; esta entrega não ensaiou o Copilot real.
O nome do script não configura automaticamente instruções, skills ou hooks do outro agente.

**Copilot no VS Code:** use um terminal PowerShell dedicado para executar os checkpoints manualmente.
A partir da raiz de P, abra um processo filho protegido usando o mesmo launcher:

```powershell
.\iniciar-codex-com-sonar.ps1 -CodexCommand "pwsh" -CodexArguments @("-NoProfile", "-NoExit")
```

Digite os comandos Sonar seguintes **dentro desse PowerShell filho**. O Copilot pode trabalhar no
editor e receber os resultados sem credencial; não se presume que um VS Code já aberto herdou
o token. Saia do filho com `exit` quando terminar. Esta rota manual também exige ensaio no
ambiente do produto; não é integração automática de terminal ou credencial com a extensão.

Nos três casos, digite o token somente no prompt protegido do launcher, nunca no chat.
Ele fica no ambiente do processo durante a sessão, é herdado pelo filho e o ambiente anterior é
restaurado ao terminar. Não use arquivo, argumento, atribuição de token em comando, log ou commit.
A verificação abaixo informa apenas disponibilidade, sem imprimir o valor:

```powershell
if ([string]::IsNullOrWhiteSpace([Environment]::GetEnvironmentVariable("SONAR_TOKEN", "Process"))) {
    throw "SONAR_TOKEN ausente neste processo; use a sessão iniciada pelo launcher."
}
```

Baseline exclusivamente offline dispensa token e launcher. A autenticação do agente na conta
OpenAI/GitHub é outra pré-condição, independente da credencial Sonar.

#### Definir os valores públicos da análise

Na sessão que executará os comandos, preencha os dados reais aprovados. São exemplos de formato,
não defaults de produto; `https://sonar.exemplo.invalid` deve ser substituída.
Esses valores podem ser registrados no plano do produto; não inclua token.

```powershell
$sonarDestino = @{
    SonarUrl = "https://sonar.exemplo.invalid"
    ProjectKey = "grupo:produto"
    ProjectName = "Nome do Produto"
}
```

Use os três valores em análise, baseline e checkpoints por `@sonarDestino`.
O parâmetro de URL não é recebido pelo launcher. Ele é informado aos scripts que acessam o servidor.
O checkpoint não recupera automaticamente a URL/chave dos argumentos usados antes:
a omissão volta aos defaults e pode causar divergência com o baseline.

#### Inicializar somente o baseline ausente

Se o produto já tiver baseline local válido, preserve-o e vá ao checkpoint.
Se houver pacotes em `sonar/`, peça a escolha explícita da fonte ao humano antes de inicializar.
Escolha **uma** das três rotas abaixo, nunca execute todas em sequência.

Servidor autorizado, sem evidência offline selecionada:

```powershell
.\validar-checkpoint-sonarqube.ps1 @sonarDestino -InitializeBaseline
```

Servidor autorizado mais um pacote específico escolhido pelo humano:

```powershell
$pacoteOffline = Read-Host "Caminho do pacote aprovado dentro de sonar/"
.\validar-checkpoint-sonarqube.ps1 @sonarDestino -InitializeBaseline -OfflineReportPath $pacoteOffline
```

Exclusivamente pacote offline aprovado, com servidor indisponível, sem exigir token:

```powershell
$pacoteOffline = Read-Host "Caminho do pacote aprovado dentro de sonar/"
.\validar-checkpoint-sonarqube.ps1 @sonarDestino -InitializeBaseline -OfflineOnlyBaseline -OfflineReportPath $pacoteOffline
```

O pacote é dado imutável; não execute arquivos dele. Offline-only permanece `UNVERIFIED`,
sem comprovar cobertura, duplicação, issues atuais ou Quality Gate.
Enquanto o baseline for `OFFLINE_ONLY_READY`, o checkpoint comum recusa a execução. Nas fatias
autorizadas, registre testes locais e a limitação. Quando o servidor voltar, preserve pacote e
evidências, registre a transição e inicialize um baseline local na revisão/identidade acordadas.
Isso não autoriza reinicializar um baseline local válido para apagar diferenças.

#### Checkpoint após cada fatia executável aprovada

Com baseline local `READY` e usando os mesmos dados públicos:

```powershell
.\validar-checkpoint-sonarqube.ps1 @sonarDestino
```

O checkpoint já invoca o analisador, executa `clean verify` mais scanner e aguarda os resultados.
Não é necessário executar `analisar-sonarqube.ps1` imediatamente antes dele.
Para diagnóstico de envio de análise, quando essa for a tarefa autorizada, o comando direto é:

```powershell
.\analisar-sonarqube.ps1 @sonarDestino
```

O analisador sozinho apenas envia e confere metadados; não registra um checkpoint conforme.
A política inicial verifica zero issue nova, zero HIGH/BLOCKER/CRITICAL, cobertura mínima de 85%
e duplicação máxima de 5%. Dívida preexistente não desaparece por ser antiga.
Se houver `NON_COMPLIANT`, apresente evidências e peça a decisão humana.
Depois de receber a resposta, registre-a; o prompt abaixo é respondido pelo humano:

```powershell
$decisaoHumana = Read-Host "Decisão humana recebida: Reprovar, AceitarExcepcionalmente ou ContinuarAjustes"
.\validar-checkpoint-sonarqube.ps1 -HumanDecision $decisaoHumana
```

`-HumanDecision` atua no estado local existente e não dispara análise. Registre motivo,
responsável e escopo de exceção. Não reduza a política para obter verde.

#### Exportar evidências do servidor selecionado

Após a análise concluída, quando a exportação fizer parte da fatia autorizada:

```powershell
.\exportar-relatorios-sonarqube.ps1 -SonarUrl $sonarDestino.SonarUrl -ProjectKey $sonarDestino.ProjectKey
```

O exportador não aceita `-ProjectName`: por isso não use `@sonarDestino` nessa chamada.
Ele cria um diretório novo sob `sonar/`; anote o caminho mostrado. Não sobrescreva pacote anterior
nem envie o pacote ao Git. O módulo de qualidade é dependência tanto do exportador como do checkpoint.

**Saída:** confirme identidade/URL no resultado, tarefa Compute Engine concluída, revisão,
fingerprint, cobertura/duplicação e situação técnica. Servidor, token, relatório ou resultado
ausente permanecem falha/limitação; código de saída zero não equivale a conformidade.
Mudança de servidor, chave ou branch exige transição planejada e limites de comparação explícitos.

## 6. Provar o harness em um fluxo real

Escolha com o responsável uma capacidade existente, representativa e pequena. Primeiro registre
o comportamento e testes de caracterização. Contratos públicos e dados não mudam pela adoção.

Para arquitetura, mapeie pacotes e responsabilidades reais. Adapte ArchUnit às fronteiras aprovadas,
verifique que existem classes no conjunto analisado e use violações sintéticas para provar as regras.
Dívida encontrada vira registro e plano de correção; não mova pacotes em massa nem silencie testes.
Uma exclusão temporária exige justificativa, responsável e revisão; não significa conformidade
arquitetural completa.

Para observabilidade, inventarie logs, spans, métricas, health e exporters existentes.
Reutilize sinais adequados. Lacunas exigem checkpoint humano com nomes, atributos, cardinalidade,
destinos e comportamento definidos. Não substitua `application.properties` nem importe os nomes
`sample.normalize` como contrato do produto. Não duplique instrumentação/exporters.
Teste ausência de payload/segredo, correlação, outcomes e comportamento de erro com dados sintéticos.

Integrações reais de mensageria, banco e outbox são diagnosticadas e planejadas separadamente;
instalar o harness não autoriza modificar transações, ack, retry ou provisionar serviços.

**Saída:** evidências do produto para comportamento, fronteiras e sinais. Uma capacidade não
verificada permanece pendente; copiar o exemplo não conclui esta etapa.

## 7. Validar, documentar e revisar a adoção

Execute os comandos de testes acordados para cada fatia. Após integrar os testes PowerShell
aplicáveis e revisar seus efeitos, uma suíte local pode ser executada com:

```powershell
$ErrorActionPreference = "Stop"
Get-ChildItem .\test\powershell\*Test.ps1 |
    Sort-Object Name |
    ForEach-Object { & $_.FullName }
```

Registre antes/depois por revisão: comando, ambiente de teste, quantidade de testes, falhas,
caminho do relatório, análise/projeto Sonar, fingerprint, cobertura, duplicação e limitações.
Não transporte contagens nem as métricas do template para o produto.

Confira hooks de início/parada com fixtures, a isenção Markdown e a detecção de mudança executável.
Preserve hooks anteriores e valide ausência de execução duplicada. Pacotes offline novos devem
ser sanitizados, imutáveis e permanecer fora do Git; conteúdo adversarial não pode executar ações.

Revise o diff completo e staging:

```powershell
git status -sb
git diff --check
git diff
git diff --cached --check
git diff --cached
```

Adicione somente os arquivos da fatia. Faça commits atômicos, registre evidências documentais e
use o processo de PR/merge já existente no produto. Um GO de adoção não muda remotos, visibilidade,
releases, regras de branch ou deploy; respeite o destino e a autorização concedidos.

### Conferência da montagem e da integração por agente

Copiar arquivos comprova somente presença. Registre resultado e evidência de cada linha no checklist
do produto, incluindo versões de agente/extensão. Um item não executado permanece pendente.

| Componente | Verificação no produto | Evidência esperada |
| --- | --- | --- |
| Origem e cópia | Comparar cada arquivo com H/S e revisar adaptações | SHA de H/S, inventário sem arquivo ausente e diff próprio |
| Skills | Conferir `SKILL.md`, recursos e `../../references/`; abrir uma skill pelo agente | Caminho da cópia carregada e leitura de recurso compartilhado sem erro |
| Instruções | Pedir ao agente que identifique goal, spec, próximo item e condição de parada | Referências corretas; nenhum GO inferido |
| Codex | Conferir skills e hooks de início/parada no runtime | Eventos executados uma vez, lembrete visível e sem decisão automática |
| Copilot CLI | Conferir skills/instruções; ensaiar sessão segura e checkpoint manual | Herança confirmada sem valor do token, comando/resultado vinculados à revisão |
| Copilot VS Code | Conferir instruções e menu de skills; usar terminal seguro dedicado | Resultado do checkpoint registrado, sem presumir herança no editor |
| Hooks Copilot | Verificar se existe adapter implementado e testado | Nesta referência está ausente; registrar pendência se a spec exigir automação |
| Build e cobertura | Executar comando aprovado e conferir XML real | Testes, módulos medidos, relatório e consumo pelo scanner |
| Sonar existente | Executar baseline/checkpoint autorizado com URL/chave explícitas | Servidor/projeto corretos, Compute Engine concluído e estado local correspondente |
| Arquitetura/observabilidade | Ensaiar regras, violações e sinais do fluxo real | Contratos preservados, correlação, cardinalidade e ausência de dados sensíveis |
| Encerramento de sessão | Encerrar processo filho protegido | Ambiente anterior restaurado; nenhuma credencial persistida |

Prompt de conferência, para os três agentes, sem pedir alterações:

```text
Sem alterar arquivos nem executar build/Sonar, identifique:
1. As instruções do repositório que você carregou.
2. O goal, a spec e o próximo item autorizado.
3. A skill adequada para revisar este plano e seu caminho de origem.
4. Um recurso compartilhado referenciado por essa skill e se ele existe.
5. Como será executado o checkpoint na URL registrada e onde você deve parar.
Não exiba variáveis de ambiente nem credenciais.
```

Não declare a integração Copilot integralmente automática com base nos testes dos hooks Codex.
A operação manual pode atender a uma spec que a aceite explicitamente; automação obrigatória
permanece pendente até implementação e prova. Nesta entrega documental, nenhum desses ensaios
foi executado em produto.

### Reversão e recuperação

Cada fatia referencia a revisão anterior e define o que reverter.
Em histórico compartilhado, prepare um revert do commit específico com revisão do diff e testes;
não use reset/force-push como rollback automático. Preserve mudanças alheias e evidências.
Se houver dependência entre commits, planeje a reversão na ordem inversa e verifique o conjunto.

Restaure a configuração anterior de hooks/instrumentação quando necessário. Não apague volumes,
dados, relatórios anteriores ou estado válido do produto. Uma análise Sonar remota não é desfeita
por um revert Git: registre a ocorrência e, se necessário, faça nova análise da revisão acordada.

## Checklist operacional para copiar ao produto

Marque somente fatos observados. Dado ausente vira pendência identificada, não campo fictício.

- [ ] Responsável, repo, branch-base e revisão anterior confirmados.
- [ ] Trabalho local existente preservado e branch de adoção isolada.
- [ ] Compatibilidade de stack, módulos, caminhos e ferramentas diagnosticada.
- [ ] Revisões H/S e inventário de cópia registrados; pastas ocultas incluídas e colisões resolvidas.
- [ ] Skills e recursos compartilhados instalados no escopo escolhido, com licença e origem.
- [ ] Codex, Copilot CLI e/ou VS Code reconheceram as instruções e skills próprias.
- [ ] Necessidade de hooks automáticos Copilot decidida; ausência não tratada como integração pronta.
- [ ] Build/perfis/efeitos conferidos; testes isolados de recursos de produção.
- [ ] Estado anterior medido antes da fatia executável ou limitação registrada.
- [ ] Goal, spec, arquitetura, ADRs aplicáveis, plano e checklist próprios revisados.
- [ ] GO da fatia e checkpoints adicionais registrados.
- [ ] Matriz classifica todos os controles como existentes, adaptados, pendentes ou não aplicáveis.
- [ ] Identidade, código, contratos, remotos e histórico do produto preservados.
- [ ] Contexto e evidências do template não foram atribuídos ao produto.
- [ ] POM/Wrapper/configurações integrados por diff, sem substituição integral.
- [ ] Scripts/testes ajustados aos comandos, identidade e layout reais.
- [ ] Fingerprint cobre todos os módulos e controles executáveis exigidos.
- [ ] Baseline válido próprio preservado ou ausência/bootstrap registrados.
- [ ] Preparação verificada commitada antes da primeira análise; HEAD confirmado.
- [ ] Token somente no processo; fonte offline escolhida pelo humano quando aplicável.
- [ ] URL/chave/nome Sonar registrados e repetidos nas chamadas; servidor existente preservado.
- [ ] Herança da credencial e limpeza ensaiadas na rota escolhida sem imprimir o token.
- [ ] Análise concluída e associada à revisão, fingerprint e escopo corretos.
- [ ] Dívida preexistente e eventual `NON_COMPLIANT` apresentados com decisão humana.
- [ ] Hooks anteriores preservados; eventos e isenção Markdown comprovados.
- [ ] Cobertura, arquitetura e observabilidade provadas em fluxo real, sem sample.
- [ ] Testes do produto e controles do harness possuem evidências próprias.
- [ ] Diff/staging sem novos segredos, estados, builds ou pacotes Sonar.
- [ ] Reversão por fatia e limites operacionais documentados.
- [ ] Pendências têm responsável e próximo passo; nenhuma adoção parcial declarada completa.
- [ ] Evidências apresentadas para aceite e encerramento humanos.

O produto está pronto para revisão quando todos os controles exigidos pela spec de adoção têm
evidência ou decisão explícita sobre a limitação. Somente o humano aceita e encerra o goal.
