# Goal — Entregar o template de harness Quarkus

## Identificação

- Estado técnico: concluído
- Aceite: `ACEITO` pelo humano em 2026-09-16
- Encerramento: `PENDENTE`
- Responsável pela decisão final: humano
- Especificação: `specs/template-harness/spec.md`
- Implementação do bootstrap: [plano](../../tasks/plan.md) e [checklist](../../tasks/todo.md)

## Objetivo

Entregar um repositório-template interno, executável e verificável para iniciar projetos Java 25 com Quarkus 3.33.3.1 LTS e Maven, incorporando o harness de planejamento, arquitetura, qualidade, SonarQube, observabilidade e aprovação humana.

## Valor esperado

- Reduzir decisões repetidas e omissões ao iniciar um projeto.
- Dar ao agente contexto persistente, limites de autonomia e significado objetivo de pronto.
- Proteger o núcleo de negócio sem impedir o uso pragmático do ecossistema Quarkus.
- Tornar qualidade e decisões humanas evidenciáveis, sem fingir garantias quando ferramentas estiverem indisponíveis.
- Reutilizar aprendizado técnico sem transportar lógica ou histórico de negócio do repositório-fonte.

## Escopo

- Harness documental e operacional para o SDLC assistido por agente.
- Projeto Maven com JDK 25 e Quarkus 3.33.3.1 LTS.
- Feature neutra executável.
- Testes de comportamento, integração, arquitetura e observabilidade.
- Hooks, scripts e testes do fluxo SonarQube local e offline.
- Padrões registrados para DDD hexagonal pragmático, mensageria e Transactional Outbox.
- Guia para materializar um projeto real a partir do template.

## Fora de escopo

- Variante independente de tecnologia.
- CI/CD e deploy sem requisitos aprovados.
- Banco, broker, Debezium, XA ou cloud provisionados preventivamente.
- Domínio de negócio real.
- Guardrails e evals ainda não especificados.

## Definição de pronto

O goal estará tecnicamente pronto quando:

- todos os critérios da especificação estiverem demonstrados;
- `mvn verify` passar com JDK 25;
- feature neutra, arquitetura e observabilidade tiverem testes verdes;
- hooks e scripts Sonar tiverem testes automatizados verdes;
- um baseline novo puder ser criado sem segredo persistido;
- o conteúdo tiver sido auditado contra conceitos e artefatos do projeto-fonte;
- o guia de materialização tiver sido ensaiado em uma cópia descartável;
- riscos, limitações e eventuais exceções estiverem registrados;
- o diff final tiver revisão de correção, simplicidade, arquitetura, segurança, desempenho, testes e escopo.

## Evidências obrigatórias

- relatórios Maven, testes e cobertura;
- resultados ArchUnit e dos testes PowerShell;
- evidência da feature neutra e dos sinais observáveis;
- evidência do ensaio de materialização;
- auditoria de segredos, estados, relatórios e vocabulário de negócio proibidos;
- resultado Sonar ou limitação explicitamente marcada como `UNVERIFIED`;
- registros dos checkpoints humanos.

## Condições de parada do agente

O agente deve parar e solicitar decisão humana:

- antes da primeira alteração de código ou tooling;
- antes de alterar contrato público, arquitetura, segurança ou comportamento observável;
- quando o escopo necessário divergir da especificação ou do plano;
- quando surgir não conformidade Sonar;
- quando uma credencial, destino remoto ou requisito organizacional estiver ausente;
- quando todos os critérios técnicos estiverem atendidos, para verificação e encerramento humanos.

## Significado de encerramento

Pronto técnico não encerra este goal. Somente o humano pode registrar `ACEITO` e `ENCERRADO`, após revisar as evidências. O agente não transforma silêncio, sucesso de testes ou Quality Gate em aceitação humana.

## Checkpoints

| Checkpoint | Estado | Autoridade |
| --- | --- | --- |
| Especificação e decisões de escopo | `APROVADO` em 2026-08-22 | Humano |
| Arquitetura, ADRs e plano | `APROVADO` em 2026-08-23 | Humano |
| Primeira alteração de código/tooling | `APROVADO` em 2026-08-23 para o Incremento 4 | Humano |
| Contrato e implementação do núcleo neutro | `APROVADO` em 2026-08-23 para o Incremento 5 | Humano |
| Adapter HTTP | `GO` e Checkpoint B `APROVADO` em 2026-08-24 para o Incremento 6 | Humano |
| Regras arquiteturais executáveis | `APROVADO` em 2026-08-24 após o Incremento 7 | Humano |
| Contrato observável exato — Checkpoint C | `APROVADO` em 2026-08-24 para as Tasks 8A e 8B; MDC aninhado aprovado após evidência da versão | Humano |
| Cobertura e configuração Sonar build | `GO` em 2026-08-27 para o Incremento 9 | Humano |
| Sessão segura e análise Sonar | `GO` em 2026-08-27 para o Incremento 10 | Humano |
| Baseline, checkpoint e decisão Sonar | `GO` em 2026-08-27 para o Incremento 11 | Humano |
| Não conformidade Sonar do Incremento 11 | `ContinuarAjustes` em 2026-08-28; checkpoint posterior `COMPLIANT` | Humano |
| Hooks Codex e isenção documental | `GO` em 2026-08-28 para o Incremento 12 | Humano |
| Evidência offline | Incremento 12 revisado; `GO` em 2026-08-29 para o Incremento 13 | Humano |
| Checkpoint D — Harness Sonar | `APROVADO` em 2026-08-29; `GO` para o Incremento 14 | Humano |
| Materialização descartável | Evidências apresentadas; humano autorizou prosseguir ao Incremento 15 em 2026-09-16 | Humano |
| Verificação integrada e entrega | `ACEITO` em 2026-09-16 após apresentação das evidências do Incremento 15 | Humano |
| Aceite do goal | `ACEITO` em 2026-09-16 | Humano |
| Encerramento do goal | `PENDENTE` | Humano |

## Evidências consolidadas da entrega

O Incremento 15 conferiu o estado executável e consolidou, sem repetir Maven ou Sonar, a execução
do Incremento 14 de 2026-09-16. Os 26 testes Maven, 11 testes PowerShell e o checkpoint
`COMPLIANT` correspondem ao fingerprint preservado. A cobertura Sonar é 97,6%, a duplicação é
0% e não há issue nova ou bloqueante; seis issues preexistentes permanecem abertas.

A [matriz do Incremento 15 no plano](../../tasks/plan.md) relaciona os 12 critérios da spec aos
artefatos e às verificações. Inclui a auditoria do conteúdo versionado, a revisão do código e
das fronteiras, e o novo ensaio descartável com goal e baseline próprios do Incremento 14.
Também registra os limites: execução JVM/Windows, perfil nativo não executado, ausência de CI/CD
no escopo e verificação documental de links locais sem consulta a destinos externos.

O humano respondeu `ACEITO` em 2026-09-16 à entrega apresentada no commit
`2be35ac8ed4362961a06661d43d781eddc510153`. O aceite está registrado; `ENCERRADO` permanece
pendente, pois não foi declarado nessa resposta.

## Histórico de evidências

- Incrementos 1–3 e o Checkpoint A de governança foram concluídos e aprovados pelo humano.
- O Incremento 4 criou somente a fundação Maven planejada: POM, Wrapper e exclusões locais.
- O Wrapper confirmou Maven 3.9.16 sobre Temurin JDK 25.0.3; `mvnw.cmd -q validate` passou.
- O Incremento 5 implementou `NormalizedText` e `NormalizeTextUseCase` em domínio e aplicação,
  sem adapter, I/O ou dependência adicional.
- O RED falhou pelas duas classes ausentes; depois do GREEN, a suíte passou com sete testes, zero
  falhas, zero erros e zero ignorados.
- O humano registrou `GO` para iniciar o Incremento 6 e aprovou explicitamente o Checkpoint B em
  2026-08-24. Nenhum adapter, DTO ou dependência foi alterado antes dessa decisão.
- O Incremento 6 implementou o contrato HTTP e OpenAPI aprovado. O RED teve oito falhas pela
  ausência do endpoint e da operação OpenAPI; depois do GREEN e da revisão, a suíte completa
  passou com 15 testes, zero falhas, zero erros e zero ignorados.
- O humano revisou essa entrega e registrou `GO` para o Incremento 7 em 2026-08-24.
- O Incremento 7 adicionou regras ArchUnit para direção das camadas e isolamento do contrato REST.
  No RED, três violações sintéticas falharam como esperado; depois do GREEN, os seis testes
  arquiteturais e a suíte completa de 21 testes passaram sem falhas, erros ou ignorados.
- O humano revisou o Incremento 7 e registrou `GO` em 2026-08-24 para preparar o Incremento 8.
  Depois de revisar perguntas operacionais, nomes, atributos, endpoints, dependências e limites,
  aprovou explicitamente o Checkpoint C em 2026-08-24. A decisão autoriza somente as Tasks 8A e
  8B conforme o contrato registrado no plano.
- A inspeção do JSON real e do artefato `quarkus-logging-json` 3.33.3.1 mostrou que a propriedade
  de MDC plano usada pela referência não existe nessa versão. O humano aprovou manter os campos
  correlacionados no objeto `mdc` aninhado, sem formatter customizado.
- O Incremento 8 implementou JSON/MDC, traces, métricas e health locais nas Tasks 8A e 8B. A
  correção contratual teve RED com três testes e uma falha esperada pela propriedade incompatível;
  após remover somente essa propriedade, o GREEN passou com três testes. Os quatro testes focados
  da Task 8B e o `./mvnw.cmd -q verify` completo passaram; a suíte totalizou 26 testes, sem falhas,
  erros ou ignorados. O JSON inspecionado manteve `event`, `outcome`, `traceId` e `spanId` dentro de
  `mdc`, e os testes provaram ausência do payload nos sinais próprios.
- O humano revisou o Incremento 8 e registrou `GO` em 2026-08-27 para executar somente o
  Incremento 9. A decisão não autoriza sessão, análise, baseline, hooks ou qualquer item dos
  Incrementos 10–13.
- O Incremento 9 teve RED esperado pela ausência de `io.quarkus:quarkus-jacoco`; após o GREEN, o
  teste PowerShell aprovou dependência, caminho XML e ausência de plugin duplicado, configuração
  obsoleta, exclusão, identidade fixa ou segredo. O `./mvnw.cmd -q verify` passou com os mesmos 26
  testes e gerou `target/jacoco-report/jacoco.xml`. O relatório cobriu 61 de 62 linhas (98,4%), sem
  exclusões de produção. A política 85%/5% e seus limites estão documentados.
- O Incremento 10 implementou um launcher com prompt protegido, `SONAR_TOKEN` limitado ao processo
  e restauração do ambiente, além de um analisador neutro que valida identidade/URL, exige servidor
  `UP`, usa o Maven Wrapper e o scanner fixado e rejeita metadado obsoleto. Os testes usam somente
  segredo, servidor, wrapper e metadados sintéticos.
- Os três testes PowerShell passaram. O `./mvnw.cmd -q verify` passou com 26 testes, zero falhas,
  zero erros e zero ignorados. A auditoria do conteúdo versionado não encontrou token Sonar nem
  identidade do repositório-fonte.
- O Incremento 11 implementou o módulo de qualidade, paginação da API, espera do Compute Engine,
  comparação 85%/5%, fontes explícitas de baseline, fingerprint, estado atômico e as três decisões
  humanas. Os sete testes PowerShell passaram.
- O primeiro baseline autenticado encontrou sete issues abertas, uma bloqueante (`java:S1192`),
  cobertura 97,6% e duplicação 0%, portanto ficou `NON_COMPLIANT`. O humano registrou
  `ContinuarAjustes` em 2026-08-28; nenhuma decisão foi inferida do resultado técnico.
- Depois do ajuste pontual e do teste de regressão para o caminho absoluto dos metadados do
  SonarScanner, o checkpoint local ficou `COMPLIANT`: seis issues abertas, zero issue nova, zero
  issue bloqueante, cobertura 97,6% e duplicação 0%. O Maven passou com 26 testes, sem falhas,
  erros ou ignorados.
- Não existem pacotes em `sonar/`. Baseline e estado ficam somente em `.codex/.state/`, ignorado
  pelo Git, e a auditoria não encontrou credencial persistida nem identidade do repositório-fonte.
- O Incremento 12 implementou a configuração Codex e os hooks `SessionStart`/`Stop` com JSON
  limitado e validado, fingerprint executável, estado atômico e lembretes não bloqueantes. Os
  hooks não registram decisão humana e dispensam Sonar quando somente arquivos Markdown mudam.
- A suíte PowerShell completa passou com nove testes. O `./mvnw.cmd -q verify` passou com 26
  testes, zero falhas, zero erros e zero ignorados. O checkpoint do fingerprint atual ficou
  `COMPLIANT`: seis issues abertas contra sete no baseline, zero issue nova, zero issue
  bloqueante, cobertura 97,6% e duplicação 0%.
- A revisão do Incremento 12 não encontrou segredo, identidade fixa, estado, pacote offline,
  dependência nova ou alteração fora de escopo. A conclusão técnica não autoriza o Incremento 13
  nem substitui a revisão humana.
- O Incremento 13 implementou exportação sanitizada e atômica sob `sonar/`, sem sobrescrita, ZIP,
  credencial ou texto livre. Somente `sonar/README.md` é versionado; pacotes permanecem ignorados.
- O primeiro RED falhou pela ausência do exportador. Um segundo RED provou que chave de issue com
  texto livre era exportada; o GREEN passou a rejeitá-la antes de criar o pacote. A leitura
  adversarial não executou script nem promoveu instruções para o estado.
- A suíte PowerShell completa passou com dez testes. O Maven passou com 26 testes, zero falhas,
  zero erros e zero ignorados, e o JaCoCo XML foi consumido pela análise. O checkpoint final ficou
  `COMPLIANT`: seis issues abertas contra sete no baseline, zero issue nova, zero issue bloqueante,
  cobertura 97,6% e duplicação 0%.
- A revisão do Incremento 13 não encontrou segredo, estado, pacote, log, identidade da referência,
  dependência nova ou alteração fora de escopo. A conclusão técnica aguarda revisão humana no
  Checkpoint D e não autoriza materialização nem os Incrementos 14–15.
- O humano revisou o Incremento 13, aprovou o Checkpoint D e registrou `GO` em 2026-08-29 para
  executar somente o Incremento 14. A decisão autoriza o guia, o checklist e o ensaio descartável
  de materialização, mas não autoriza o Incremento 15 nem o encerramento do goal.
- O humano revisou o Incremento 9 e registrou `GO` em 2026-08-27 para executar somente o
  Incremento 10. A decisão autoriza sessão segura e análise local, mas não autoriza baseline,
  decisão, hooks ou evidência offline dos Incrementos 11–13.
- O humano revisou o Incremento 10 e registrou `GO` em 2026-08-27 para executar somente o
  Incremento 11. A decisão autoriza baseline, checkpoint e o fluxo das três decisões, mas não
  autoriza hooks nem evidência offline dos Incrementos 12–13.
- O humano revisou o Incremento 11 e registrou `GO` em 2026-08-28 para executar somente o
  Incremento 12. A decisão autoriza hooks Codex e isenção Markdown-only, mas não autoriza a
  evidência offline do Incremento 13 nem encerra o goal.
- O humano revisou o Incremento 12 e registrou `GO` em 2026-08-29 para executar somente o
  Incremento 13. A decisão autoriza exportação e leitura offline dentro do plano aprovado, mas
  não autoriza materialização, os Incrementos 14–15 nem o encerramento do goal.
- A retomada de 2026-09-16 corrigiu o RED do Incremento 14: o procedimento exige verificações e
  commit local antes do baseline Sonar. Passaram 26 testes Maven e 11 testes PowerShell; o
  checkpoint do template ficou `COMPLIANT`, com zero issue nova ou bloqueante, cobertura 97,6%
  e duplicação 0%. Um novo ensaio descartável comprovou diretamente goal/contexto próprios,
  auditoria sem herança operacional, 26 testes Maven, 11 PowerShell e baseline próprio
  `COMPLIANT` ligado ao commit local anterior. A omissão de adaptação do nome esperado no teste
  de observabilidade foi corrigida no procedimento. Identificadores e evidências estão no plano.
- Esta evidência não encerra o goal.

## Decisões já registradas

- Quarkus 3.33.3.1 LTS com JDK 25.
- Identidade Maven informada ao materializar cada projeto, sem namespace fixo.
- Feature neutra removida somente após uma feature real comprovar o harness.
- Execução e SonarQube locais na primeira versão; CI/CD no backlog.
- Atualização Quarkus manual, planejada e aprovada dentro da linha LTS.
