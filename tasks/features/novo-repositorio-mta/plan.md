# Plano — Construção do harness JBoss EAP

> Continuidade transferida para C:\desenvolvimento\repositorio\jboss-eap-copilot-harness-template,
> branch chore/bootstrap-jboss-harness. Este documento preserva a referência da origem;
> os artefatos de construção ativos pertencem ao novo checkout.

- Estado: `REFERENCIA_H00_TRANSFERIDA`; não manter este plano como execução paralela.
- H01A recebeu GO explícito em 2026-09-21 e criou a fundação no novo destino.
- Plano canônico: `tasks/features/preparacao-harness/plan.md` no checkout JBoss indicado abaixo.
- O restante deste documento preserva o diagnóstico/proposta H00; seus checkpoints futuros não são novos GOs.
- Data: 2026-09-21.
- [Goal](../../../goals/novo-repositorio-mta/goal.md), [spec proposta](../../../specs/novo-repositorio-mta/spec.md) e [checklist](todo.md).
- Branch documental: `chore/preparacao-jboss-harness`.
- Máquina de trabalho do usuário: acompanha `main`; seu ambiente ainda não foi inspecionado aqui.

## Intenção e escopo

Preparar outro repositório-template, `jboss-eap-copilot-harness-template`, para Windows
PowerShell 5.1, Copilot/VS Code, DevSquad, MTA local e Sonar corporativo. A aplicação
permanece Java 8/Java EE 7, com arquitetura preservada no salto EAP 7.0 → 7.4.

Este repositório hospeda somente o diagnóstico e a proposta documental autorizados.
A implementação futura será no destino independente, após GO. Não alterar scripts,
POM, configuração ou arquitetura Quarkus para facilitar a derivação. Não transportar
histórico, resultados verdes, aceites, baseline, sample, binários ou segredos.
Publicação do novo remoto e migração de aplicação não fazem parte do primeiro GO.

## H00 — Evidências de origem

| Item | Observação de 2026-09-21 |
| --- | --- |
| Origem local | `C:\desenvolvimento\repositorio\quarkus-coding-harness-template` |
| Remoto conferido | `https://github.com/edoardo-bianco/quarkus-coding-harness-template.git` |
| Fonte exclusiva | `main`, SHA `22512766897bca4146e940cdca39ab9089f545f4` |
| Correspondência | `git fetch origin --prune` concluído; `main` e `origin/main` coincidentes |
| Branch de trabalho | `chore/preparacao-jboss-harness`, iniciada no mesmo SHA; árvore limpa antes deste registro |
| Revisão anterior | `094ebab9fa776e5b737b830f599b0cc67529f93a`; avanço registrado após integração do PR #2 |
| Branch documental anterior | `docs/goal-origem-mta`, integrada e removida; apenas referência histórica |
| Destino planejado | `C:\desenvolvimento\repositorio\jboss-eap-copilot-harness-template`; `Test-Path` retornou `False` |
| PowerShell local | `powershell.exe -NoProfile`: `5.1.26100.9444`; inspeção de metadados, sem execução do harness |
| Ambiente corporativo | NÃO_VERIFICADO; não confundir com este checkout e este PowerShell |

As leituras técnicas foram feitas por `git show main:<arquivo>`, inventário por
`git ls-tree -r --name-only main` e buscas focadas no checkout inicialmente idêntico.
O SHA acima fica fixado para a proposta. Avanços futuros da `main` exigem nova comparação
e registro, sem mistura silenciosa de snapshots. O prompt e o guia já constam desse SHA,
mas continuam classificados como requisitos humanos e referência de migração.

## Arquivos e controles inspecionados

Inspeção integral ou de trechos/funções pertinentes, sem execução dos arquivos:

| Origem no SHA fixado | Decisão e destino proposto | Motivo e verificação no destino |
| --- | --- | --- |
| `AGENTS.md`, `goals/templates/goal.md`, `specs/templates/spec.md`, `tasks/README.md`, `tasks/templates/plan.md`, `tasks/templates/todo.md` | ADAPTAR para governança e modelos equivalentes | Retirar premissas Quarkus; conferir uma fonte por plano, GOs e nenhuma decisão herdada |
| `specs/template-harness/spec.md`, `specs/adocao-harness-existente/spec.md`, `tasks/plan.md`, `tasks/todo.md` | NÃO TRANSPORTAR como contexto ativo | Histórico consultado; novo produto terá requisitos, tarefas e evidências próprios |
| `doc/arquitetura/arquitetura-harness.md`, `doc/adr/README.md`, ADRs 0002/0005 | NÃO TRANSPORTAR como arquitetura da aplicação | Camadas e Outbox/no-XA conflitam com preservação Java EE; revisar política e modelo AS-IS |
| ADRs 0003/0004/0006 | ADAPTAR conceitos em novos ADRs inicialmente propostos | Governança, qualidade e reconhecimento são úteis; nenhum aceite é transferido |
| `iniciar-codex-com-sonar.ps1` | ADAPTAR para `scripts/iniciar-sessao-com-sonar.ps1` | Preservar prompt protegido/finally; retirar Codex obrigatório; provar herança no processo efetivo da IDE/CLI |
| `analisar-sonarqube.ps1` | ADAPTAR para `scripts/analisar-sonarqube.ps1` | Separar raízes, Maven/JDK e análise do build; regressão sem clean/recompilação e sem token em argumento |
| `validar-checkpoint-sonarqube.ps1` | ADAPTAR para `scripts/validar-checkpoint-sonarqube.ps1` | Preservar baseline/estados/decisões; vincular análise exata, identidade e Quality Gate corporativo |
| `.codex/hooks/SonarQuality.psm1` | ADAPTAR para `scripts/SonarQuality.psm1` | Uma implementação compartilhada, sem Codex obrigatório; portar APIs PS5.1 e reforçar associação da análise |
| `exportar-relatorios-sonarqube.ps1` | ADAPTAR para `scripts/exportar-relatorios-sonarqube.ps1` | Manter allowlist, limites, hash e proteção de paths; retirar premissas de raiz/POM; testar imutabilidade |
| `.codex/hooks.json`, hooks session-start/stop | NÃO TRANSPORTAR formato; ADAPTAR comportamento de lembrete em H05 | Hooks atuais chamam pwsh e usam protocolo Codex; integração Copilot depende de formato realmente suportado |
| `test/powershell/SonarQualityGateTest.ps1` | ADAPTAR path/runtime; MANTER contrato 85/5 e severidades | Limites inclusivos, issue nova, dívida bloqueante e métrica inválida devem manter resultado |
| `test/powershell/AnalisarSonarQubeTest.ps1`, `SonarQualityApiTest.ps1`, `SonarSecretHandlingTest.ps1` | ADAPTAR em `test/powershell/` | Preservar testes de falha/segredo/paginação; trocar expectativa clean+verify e acrescentar concorrência/análise exata |
| `test/powershell/SonarHumanDecisionFlowTest.ps1`, `SonarOfflineOnlyBaselineTest.ps1`, `ExportarRelatoriosSonarQubeTest.ps1` | ADAPTAR em `test/powershell/` | Estados, decisões recebidas e dados externos continuam protegidos; compatibilidade PS5.1 ainda não ensaiada |
| `test/powershell/SonarAgentHooksTest.ps1`, `SonarDocumentationOnlyFlowTest.ps1` | ADAPTAR cenários ao novo cliente/fingerprint | Lembretes não decidem; distinguir documentos explicativos de instruções operacionais |
| `test/powershell/SonarBuildConfigurationTest.ps1`, `MaterializacaoTemplateTest.ps1` | NÃO TRANSPORTAR asserções Quarkus; ADAPTAR somente cenários pertinentes | Criar contratos próprios de adoção e build da aplicação, sem POM fictício |
| `pom.xml`, `.mvn/wrapper/maven-wrapper.properties`, `mvnw`, `mvnw.cmd`, `src/` | NÃO TRANSPORTAR | Java 25/Quarkus/sample não pertencem ao destino; inspecionados POM e propriedades, demais caminhos inventariados |
| `.gitignore` | ADAPTAR para `.gitignore` próprio | Hoje ignora `.vscode/` inteira; permitir modelos revisados e ignorar configuração real, estados e relatórios |
| Guia MTA em `doc/guias/` | ADAPTAR em H06 como guia canônico da operação futura | Exemplos condicionados ao harness implementado; não executar agora |
| DevSquad, configurações corporativas e aplicação | A CONFIRMAR | Não estão entre os componentes versionados observados; inventário real antes de H05/adopção |

Os demais testes foram triados por referências e trechos relevantes; a tabela não declara
revisão integral de todas as linhas. A lista exata de cada lote reutilizado, blobs de origem,
destino, adaptação e testes deverá compor `doc/origem-harness.md` no novo produto.
Não copiar diretórios indiscriminadamente. Não foi inspecionado conteúdo de `sonar/`.

## Incompatibilidades e lacunas observadas

| ID | Evidência no código | Tratamento planejado |
| --- | --- | --- |
| D01 | `ConvertFrom-Json -Depth/-NoEnumerate`, SHA256.HashData, Convert.ToHexString e File.Move com três argumentos no módulo; Contains com StringComparison no analisador/testes | Portar e testar no PS5.1; metadados do runtime local confirmam ausência dessas assinaturas/parâmetros |
| D02 | Analisador monta `clean`, `verify`, scanner `5.5.0.6356`; testes exigem esses argumentos | Separar build Java 8 e scanner; atualizar contrato/testes no destino; versão do scanner depende do servidor real |
| D03 | Analisador/checkpoint exigem POM junto ao script; Wrapper, target e estado derivados dessa mesma raiz | Configuração explícita HarnessRoot/ApplicationRoot, Maven/Wrapper e identidade Sonar própria |
| D04 | `Get-SonarQualitySnapshot` consulta a última análise (`ps=1`); checkpoint espera CE e depois consulta snapshot sem confrontar analysisId | Rejeitar resultado de outra análise, verificar revisão/fingerprint antes/depois e concorrência; testar corrida no destino |
| D05 | Módulo compara métricas/issues, sem consultar Quality Gate corporativo | Acrescentar resultado corporativo separado da política do harness, associado à análise correta; servidor sem dados fica não verificado |
| D06 | Fingerprint cobre src, .mvn, .codex/hooks, testes, POM, wrappers e ps1 raiz | Incluir scripts/configuração e instruções operacionais do destino; não considerar todo Markdown automaticamente isento |
| D07 | Launcher chama Codex; hooks chamam pwsh; estado em `.codex/.state` | Launcher e módulo neutros; validar herança real em processo novo do cliente; não supor que editor já aberto herdou token |
| D08 | `WaitForExit()` do Maven sem timeout; URL default localhost | Timeout explícito e configuração corporativa, com checkpoints prévios de segurança/comportamento |

Riscos D04/D05 são lacunas identificadas por leitura para a derivação, sem correção fora de
escopo na origem. Nenhuma chamada à API Sonar ou exposição de credencial ocorreu.

## Fontes consultadas e limites

- [ConvertFrom-Json no PowerShell 5.1](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/convertfrom-json?view=powershell-5.1), consultado em 2026-09-21: sintaxe sem `-Depth`/`-NoEnumerate`; confirmada também por metadados do processo local.
- [SonarScanner for Maven](https://docs.sonarsource.com/sonarqube-server/analyzing-source-code/scanners/sonarscanner-for-maven), consultado em 2026-09-21: catálogo inclui `5.5.0.6356`, versão encontrada na origem. Isso não homologa o servidor corporativo nem escolhe upgrade.
- [Repositório oficial DevSquad](https://github.com/microsoft/devsquad-copilot), acessado em 2026-09-21 como fonte de procedência. Instalação, versão e procedimento aplicável continuam pendentes de inventário em H05.

Não foram escolhidas versões novas nem homologadas combinações EAP/JDK/MTA/scanner.
Documentação de cada versão instalada deverá ser conferida antes da fatia correspondente.

## Proposta de organização e decisões

```text
jboss-eap-copilot-harness-template/
  README.md, AGENTS.md, .gitignore
  goals/, specs/, tasks/features/preparacao-harness/
  doc/origem-harness.md
  doc/arquitetura/, doc/adr/, doc/guias/, doc/templates/
  config/                  exemplo versionado; configuração real ignorada
  scripts/                 PS5.1; módulo Sonar compartilhado
  test/powershell/          regressões próprias
  .vscode/, .github/        modelos e instruções revisados, sem segredos
```

Propostas sujeitas aos checkpoints: separar harness/aplicação; preservar arquitetura Java EE;
usar módulo de qualidade neutro; separar processos/JDKs; estado por produto em área ignorada;
uma política canônica acessada pelos agentes. Não criar arquitetura universal nem wrappers
apenas para esconder bibliotecas. ADRs próprios começarão `Proposto` no H01B.

Na transição H01A, os documentos próprios do destino passam a ser a fonte editável da construção.
Este plano permanece como diagnóstico/proposta de origem e recebe indicação de transferência;
não manter dois plan/todo ativos. O manifesto do destino será canônico para procedência.

## Sequência proposta

Dependência principal: H00 → H01A → H01B → H01C → H02 → H03 → H04 → H05 → H06 → H07.
Cada linha é uma fatia, normalmente até cinco arquivos de entrega; plano/todo/manifesto
recebem apenas o registro de evidência do lote. Cada H exige GO próprio e checkpoints
adicionais quando tocar arquitetura, segurança ou comportamento observável.

| Fatia | Arquivos prováveis no novo destino | Aceitação e verificação | Dependência |
| --- | --- | --- | --- |
| H01A — Fundação documental | `README.md`, `doc/origem-harness.md`, `goals/preparacao-harness/goal.md`, `specs/preparacao-harness/spec.md`, `tasks/features/preparacao-harness/plan.md`, `todo.md` na mesma pasta | Git independente; main e branch bootstrap; seis documentos próprios sem aceites herdados; links/diff/Git; exceção de seis arquivos justificada pela transferência conjunta de contexto e checklist | GO H01A após revisão desta proposta |
| H01B — Arquitetura proposta | `doc/arquitetura/arquitetura-harness.md`, `doc/adr/README.md`, três ADRs para preservação, governança e qualidade | Separar arquitetura do harness/aplicação e responsabilidades de processo; todos Proposto; revisão humana antes de operacionalizar | H01A + GO documental |
| H01C — Entrada operacional | `AGENTS.md`, `.gitignore`, `config/harness.example.json`, `test/powershell/ConfigurationContractTest.ps1` | Rotas e condições de parada; sem credenciais; configuração real ignorada; RED/GREEN de contratos; baseline/limitação deliberada antes da primeira alteração executável | H01B revisado + GO/checkpoints |
| H02A — Runtime e configuração | `scripts/HarnessEnvironment.psm1`, `scripts/diagnosticar-ambiente.ps1`, dois testes focais | PS5.1 real; raízes, JDKs e Maven distintos; caminhos com espaços/acentos; não alterar ambiente global | H01C |
| H02B — Núcleo de qualidade portátil | `scripts/SonarQuality.psm1`, testes de política, estado/JSON/hash e fingerprint | Contrato 85/5 preservado; APIs PS5.1; instruções operacionais incluídas; escrita de estado segura | H02A |
| H03A — Sessão segura | `scripts/iniciar-sessao-com-sonar.ps1`, teste de segredo/processo, guia de sessão | Herança, restauração, erro, cancelamento e processo efetivo; nenhuma credencial em arquivo/argumento/log | H02B + checkpoint segurança |
| H03B — Análise e identidade | `scripts/analisar-sonarqube.ps1`, `scripts/SonarQuality.psm1`, testes do analisador e API | Sem rebuild no scanner; timeout; taskId/analysisId/revisão; paginação e resultados concorrentes/obsoletos recusados | H03A + compatibilidade scanner definida |
| H03C — Baseline e gate | `scripts/validar-checkpoint-sonarqube.ps1`, módulo, testes de decisão/gate/offline | Baseline próprio, policy e gate separados; UNVERIFIED/decisões corretos; evidência real ou limitação submetida ao humano | H03B |
| H03D — Exportação | `scripts/exportar-relatorios-sonarqube.ps1`, teste e guia offline | Allowlist, hash, imutabilidade, limites e reparse points; nenhum dado real versionado | H03C |
| H04A — Build/workspace | script build, teste, workspace de exemplo, tasks e guia | Maven/perfis existentes; JDK8 real; cobertura/bytecode/artefato rastreados; configuração corporativa preservada | H03; integração final do build/análise aqui |
| H04B — Laboratório EAP | script de operação, teste, guia e modelo de evidências | CLI oficial, versão alvo, timeout/status/deploy; hash do artefato, um servidor por vez; ensaio real separado de mocks | H04A + instalações/configuração autorizadas |
| H05A — Inventário DevSquad | registro de inventário e matriz de integração por cliente | Procedência, versão, customizações, requisitos e mecanismo oficial observados; nenhuma atualização automática | H04; pode antecipar somente leitura |
| H05B — Integração Copilot | instruções roteadoras, especialização mínima, teste/roteiro por cliente; até cinco arquivos após H05A | Atualização somente com GO; descoberta/carga e GOs respeitados; IDE principal, CLI condicional; sem planos duplicados | H05A + GO/checkpoints específicos |
| H06A — MTA | script MTA, teste, guia ZIP e modelo de evidência | Versão/opções/rulesets reais; falha/timeout; hashes e limites; sem target inventado | H05 |
| H06B — Inventários | modelos AS-IS, bibliotecas, compatibilidade, triagem e revisão por fatia | Origem/carregamento/consumidores; estados arquiteturais; dependência biblioteca → consumidores; templates sem fatos inventados | H06A |
| H06C — Adoção e ensaio | guia canônico, checklist de adoção, teste/roteiro de colisões e repetição | POM/Git/customizações intactos, adoção repetível, relatório integrado com limitações; nenhuma migração implícita | H06B |
| H07 — Publicação | revisão de procedência/licenças, guia e evidência de publicação | Aceite local e autorização externa antes de remoto; conferir URL/privacidade/main/Template; nenhum terceiro remoto implícito | H06C + aceite humano |

H04–H07 terão os nomes exatos de arquivos e comandos refinados com o inventário real antes
do GO correspondente. Não são autorização aberta para implementar um conjunto indefinido.
Testes de comportamento seguem RED → GREEN → REFACTOR no destino; testes do harness
não certificam aplicações corporativas. Não criar sample Maven apenas para cobertura.

## Primeiro checkpoint — H01A

Submeter esta spec/plano e solicitar GO somente para criar o diretório novo e Git independente
no destino acima, com os seis documentos listados em H01A. Criar primeiro commit documental
em `main`, depois `chore/bootstrap-jboss-harness`; confirmar identidade Git existente, sem
inventar nome/e-mail. README deve declarar bootstrap sem scripts e apontar para goal/plano.
O manifesto deve fixar SHA, arquivos efetivamente derivados e adaptações; históricos não serão copiados.

Não inclui AGENTS operacional, configuração executável, scripts, plugins, build, Sonar,
MTA, EAP, aplicação ou remoto. Revalidar inexistência do destino antes da escrita; se existir,
inspecionar e interromper a criação até resolver a colisão. Não apagar nada como reversão.
A sessão atual só possui escrita autorizada na origem: a execução exigirá acesso estritamente
ao destino ou sessão nele. Confirmar as instruções efetivas do novo workspace antes de código.

Ao concluir H01A: comprovar raiz/.git/remotes próprios e origem preservada, revisar diff e links,
registrar evidências, solicitar revisão da fundação e GO documental H01B. Não inferir aceite
ou avançar até H02. Configuração operacional/AGENTS requerem arquitetura revisada e checkpoint.

## Riscos, pendências e verificações

- A máquina de trabalho permanece fora da observação desta sessão. Usuário fornece versões/caminhos
  e resultados sanitizados quando necessários; nenhum token no chat. Cada máquina mantém seus caminhos locais.
- Sonar corporativo: URL/versão/permissões/identidade/linguagens ainda desconhecidas; definir baseline
  próprio e tratamento de bootstrap antes de executáveis. Métrica indisponível não vira cobertura fictícia.
- Toolchains, DevSquad e MTA: validar versões instaladas e fontes oficiais antes de escolher alvos.
- EAP/Oracle/SSO/bibliotecas: dados e integrações reais necessários para homologação, sem bloquear
  desnecessariamente os modelos; incompatibilidade interrompe somente o controle afetado.
- H00: conferir links, diff, branch/SHA e escopo exclusivamente Markdown; nenhuma suíte necessária.
- H01 em diante: rever o manifesto por lote, realizar testes pertinentes e checkpoint quando aplicável;
  alterações na origem técnica estão fora do escopo. Reversão usa commits do destino, nunca limpeza da origem.
