# Checklist — Preparação do guia de adoção

- Estado: `AGUARDANDO_REVISAO_HUMANA` — revisão ampliada preparada; rascunhos sem aceite.
- Goal: [adoção](../../../goals/adocao-harness-existente/goal.md).
- Spec: [rascunho](../../../specs/adocao-harness-existente/spec.md).
- Plano: [proposta](plan.md).
- Guia: [procedimento manual](../../../doc/guias/adotar-harness-repositorio-existente.md).
- Responsável humano: usuário solicitante.

## Decisões e limites

| Data | Autoridade | Registro | Efeito |
| --- | --- | --- | --- |
| 2026-09-16 | Humano | Planejar adoção em repositório com produção e preparar primeiro guia manual | Preparação documental |
| 2026-09-17 | Humano | Retomar revisão do guia/links, inclusão no README e apresentação para aprovação | Retomada documental; sem aplicação em produto |
| 2026-09-17 | Humano | Explicitar reconstrução manual, skills Addy Osmani, Codex e Copilot CLI/VS Code, com Sonar existente em URL própria | Revisão ampliada; sem instalação nem alteração executável |
| 2026-09-17 | Humano | Corrigir todos os documentos: execução autorizada pelo agente em CLI/VS Code, decisão humana e ciclo de ajustes | Alinhamento documental; sem execução do ensaio nesta entrega |
| — | Humano | Aprovação do novo goal/spec/plano | `PENDENTE` |
| 2026-09-17 | Humano | Reconhecer ambiente existente, perguntar manter/alterar JDK, Quarkus e Maven e mostrar locais de ajuste | D9–D11 documentais; sem escolher versões nem aplicar ao produto |
| — | Humano | GO para aplicação no produto | `PENDENTE`; candidato `simtr-documento-assinc` indicado; escolha de versões e plano próprio pendentes |
| — | Humano | Aceite/encerramento deste goal | `PENDENTE` |

## Preparação

- [x] Confirmar bootstrap anterior encerrado e manter seus arquivos intactos.
- [x] Ler modelos de goal/spec/tasks e ADRs aplicáveis.
- [x] Inspecionar scripts, hooks e testes reais do harness.
- [x] Registrar premissas, limitações e divergências encontradas.
- [x] Criar rascunhos de goal/spec e proposta documental de plano.
- [x] Preparar guia com matriz de artefatos, sequência, checkpoints e checklist de adoção.
- [x] Conferir os requisitos A01–A12, links e arquivos referenciados.
- [x] Revisar escopo e diff, sem segredos nem artefatos gerados.
- [x] Adicionar acesso pelo README e publicar os commits documentais.
- [x] Apresentar o conjunto para revisão humana.

## Revisão ampliada — D3/D4

A preparação acima registra D1/D2. O feedback humano reabriu o detalhamento operacional;
essas marcações não significam aceite nem cumprimento de A13–A17.

- [x] Registrar escopo e critérios ampliados antes de reescrever o guia.
- [x] Conferir fontes oficiais de Codex/Copilot e instalação das skills.
- [x] Explicitar diretórios, arquivos, colisões, dependências e sequência de cópia.
- [x] Documentar skills completas, referências compartilhadas e descoberta por agente.
- [x] Documentar sessões Codex/Copilot CLI/VS Code e limites dos hooks.
- [x] Dar comandos completos com URL/identidade Sonar consistentes.
- [x] Validar A01–A17, links, sintaxe dos exemplos e escopo do diff.
- [x] Preparar a revisão documental em commit separado para publicação e checkpoint humano.

## Evidências anteriores — D1/D2

A inspeção do código identificou os limites descritos no plano, em especial fingerprint de
diretórios da raiz e ausência de parâmetros de perfis no analisador.
Nenhum repositório de produto foi inspecionado ou alterado. Não houve teste, instalação,
análise ou ensaio de adoção. As contagens e métricas do bootstrap não se transferem a outro produto.

Nesta entrega, Markdown é isento de Maven, testes PowerShell, baseline e checkpoint Sonar.
Revisão D1: 37 links locais válidos nos cinco rascunhos e README; 42 caminhos de artefatos
existentes. Inspeção de scripts/testes sem execução; matriz A01–A12 no plano.
Validação documental D2: 48 links locais válidos nos seis documentos e 42 caminhos de referência
existentes; `git diff --check` e revisão do diff/staging sem alteração executável, segredo ou
artefato gerado. Commit D1: `945dc12`; navegação e evidências D2 em commit separado na mesma branch.

## Evidências da revisão ampliada — D3/D4

- D3 registrado no commit `878a545`: goal/spec/plano/checklist atualizados antes do guia.
- D4 detalha origem/destino e ordem, skills com recursos/licença, três agentes e Sonar com URL própria.
- Fontes oficiais OpenAI, GitHub, VS Code e do pacote Addy Osmani consultadas em 2026-09-17.
- Conferência dos seis documentos: 63 links locais válidos, incluindo 15 âncoras; 42 caminhos
  reais de referência existentes. Os 14 links externos são referências às fontes consultadas.
- Os 16 blocos PowerShell do guia passaram na análise sintática em memória; nenhum foi executado.
- Parâmetros conferidos no código: o exportador não aceita ProjectName; a URL deve ser repetida
  nas chamadas de análise/baseline/checkpoint/exportação. O launcher apenas inicia o processo filho.
- Inspeção local encontrou ausente `~/.agents/references/definition-of-done.md`, embora skills
  o referenciem. Nenhuma skill pessoal foi modificada; §4.6 explica como evitar a cópia incompleta.
- Hooks Sonar nativos Copilot continuam ausentes; sessões reais Copilot CLI/VS Code e instalação
  no produto permanecem `NÃO_ENSAIADAS`. O procedimento manual não é evidência de integração automática.
- Revisão A01–A17 no plano; somente Markdown, sem Maven, testes do harness, API/baseline Sonar,
  instalação ou alteração em produto. Nenhuma decisão humana foi inferida.

## Ensaio humano — D5/D6 (histórico; fluxo principal substituído por D7/D8)

- [x] Registrar pedido humano de instruções para ensaio CLI/VS Code sem mudar comportamento.
- [x] Especificar A18–A20 antes do roteiro.
- [x] Preparar prompts, comandos condicionados, pausa/retomada e modelo de retorno.
- [x] Distinguir teste manual e futura verificação de lembretes equivalentes.
- [x] Validar links, sintaxe e escopo documental; preparar roteiro para publicação.
- [ ] Receber a devolutiva humana do ensaio; execução ainda não realizada nesta entrega.

Evidências D6: 71 links locais válidos, 19 âncoras, 42 caminhos e 6 novos blocos PowerShell
sem erro sintático. Os 16 exemplos anteriores não mudaram. Roteiro ligado ao guia, com prompts
de pausa/retomada e proposta futura dos lembretes equivalentes. D5: `c98f14b`.
Nenhum teste em produto, instalação ou alteração executável foi realizado.

## Alinhamento — D7/D8

- [x] Registrar esclarecimento humano: agente executa em CLI/VS Code; humano autoriza e decide.
- [x] Atualizar A18–A20 e escopo antes dos guias.
- [x] Alinhar roteiro, guia de adoção, prompts, credencial, matrizes e README.
- [x] Manter execução humana como alternativa e hooks como lembretes independentes.
- [x] Conferir documentos, links, sintaxe e ausência de alterações executáveis.
- [ ] Receber evidências do ensaio real nos dois ambientes.

Evidências D8: 72 links locais (20 âncoras), 42 caminhos e 24 exemplos PowerShell válidos
sintaticamente (17 no guia e 7 no roteiro); nenhum exemplo executado. Instruções antigas
permanecem somente no histórico substituído ou na alternativa manual. D7: `8b807aa`.
Fluxo principal: agente executa/aguarda/avalia; humano decide; agente registra/ajusta/testa/revalida.
Somente Markdown; nenhum script, hook, editor, configuração, Maven ou Sonar alterado/executado.

## Reconhecimento do ambiente — D9 a D11

- [x] Registrar pedido humano, candidato inspecionado e requisitos A21–A25 antes das instruções.
- [ ] Atualizar AGENTS e arquitetura; propor ADR e atualizar índice sem aceitar a própria decisão.
- [ ] Explicar diagnóstico, escolha manter/alterar e locais de configuração no guia.
- [ ] Alinhar prompts, ficha de retorno Copilot e navegação README.
- [ ] Conferir fontes, links, sintaxe, cenários documentais e diff; registrar evidências.
- [ ] Receber escolha de versões e GO específico para aplicação no candidato.

## Próximo item autorizado

Executar D10 e D11 documentais e apresentar o conjunto para revisão humana.
Nenhum GO de aplicação, aceite ou encerramento foi dado. O candidato foi inspecionado por leitura
remota; não executar o roteiro nele nem escolher suas versões. O checklist reutilizável fica no guia.

## Checkpoint de pausa — 2026-09-16 (histórico; retomado em 2026-09-17)

- Humano solicitou parar em ponto seguro e retomar amanhã.
- Branch de trabalho: `docs/adocao-harness-existente`, criada a partir de `88e68b2`.
- Cinco rascunhos foram gravados: goal, spec, plano, checklist e guia manual.
- A validação documental final e a integração de navegação pelo README continuam pendentes.
- A inspeção dos scripts já identificou limitações de fingerprint, perfis Maven e testes
  específicos do template; revisar esses pontos na retomada.
- Nenhum repositório de produção foi acessado ou alterado; nenhum ensaio ou comando do guia foi executado.
- Mudança somente Markdown: Maven e Sonar não foram executados.
- O bootstrap anterior permanece encerrado. Aprovação e GO do novo trabalho continuam pendentes,
  salvo a preparação documental já solicitada.
- Este checkpoint preserva trabalho em andamento; não declara conclusão ou aceite do novo goal.
