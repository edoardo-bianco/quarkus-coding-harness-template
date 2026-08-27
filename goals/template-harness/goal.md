# Goal — Entregar o template de harness Quarkus

## Identificação

- Estado: `PLANEJADO`
- Responsável pela decisão final: humano
- Especificação: `specs/template-harness/spec.md`
- Feature de implementação: `tasks/features/bootstrap-harness/`

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
| Não conformidade Sonar, se houver | `PENDENTE conforme evidência` | Humano |
| Aceite e encerramento do goal | `PENDENTE` | Humano |

## Evidências parciais

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
- Sonar permanece `UNVERIFIED`: a sessão atual não foi iniciada com credencial e não houve análise
  autenticada de servidor; baseline, espera do Compute Engine, checkpoint e decisão serão tratados
  somente nos incrementos ainda bloqueados.
- O humano revisou o Incremento 9 e registrou `GO` em 2026-08-27 para executar somente o
  Incremento 10. A decisão autoriza sessão segura e análise local, mas não autoriza baseline,
  decisão, hooks ou evidência offline dos Incrementos 11–13.
- O humano revisou o Incremento 10 e registrou `GO` em 2026-08-27 para executar somente o
  Incremento 11. A decisão autoriza baseline, checkpoint e o fluxo das três decisões, mas não
  autoriza hooks nem evidência offline dos Incrementos 12–13.
- Esta evidência não encerra o goal.

## Decisões já registradas

- Quarkus 3.33.3.1 LTS com JDK 25.
- Identidade Maven informada ao materializar cada projeto, sem namespace fixo.
- Feature neutra removida somente após uma feature real comprovar o harness.
- Execução e SonarQube locais na primeira versão; CI/CD no backlog.
- Atualização Quarkus manual, planejada e aprovada dentro da linha LTS.
