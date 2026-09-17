# Proposta de plano — Guia manual de adoção

- Estado: `RASCUNHO`, preparado junto do guia solicitado; não é plano aprovado para código.
- Goal: [adoção](../../../goals/adocao-harness-existente/goal.md).
- Spec: [requisitos](../../../specs/adocao-harness-existente/spec.md), em revisão.
- Checklist: [andamento](todo.md).
- Referência do harness inspecionada: `88e68b2`, descendente da entrega aceita `2be35ac`.
- Branch documental: `docs/adocao-harness-existente`.
- Autoridade: solicitação humana de 2026-09-16 para planejar e preparar primeiro um guia manual.

## Intenção e limites

Produzir uma proposta completa e revisável antes de qualquer aplicação ao produto. A revisão
humana da spec/plano permanece pendente; o roteiro no guia não autoriza sua execução.
O bootstrap encerrado e seus arquivos de execução serão preservados.

Dependências: ferramentas e contratos existentes do template, instruções do AGENTS.md e ADRs 0001–0004.
Sem dependência de token, servidor, caminho de produto ou repositório remoto novo para escrever o guia.

## Etapas desta preparação documental

### D1 — Preparar o conjunto para revisão

Arquivos (cinco): novo goal, spec, este plano, todo e guia manual.
Entregar inventário dos controles, diferenças em relação a materialização, sequência manual,
checklist, evidências, checkpoints e reversão. O guia é uma proposta documental, sem código novo.

Aceitação: requisitos A01–A11 abordados; dados não informados explícitos; nenhum estado humano
inferido; bootstrap preservado.
Verificação: inspeção direta dos scripts/testes, matriz dos requisitos, links e diff.
Parada: apresentar proposta ao humano; nenhum passo de adoção é executado implicitamente.

### D2 — Tornar a proposta encontrável

Dependência: D1 preparado. Arquivo: README.
Acrescentar acesso ao novo goal e guia em rascunho, preservando a aceitação e o encerramento
do bootstrap. Não declarar o produto adaptado nem o guia validado por ensaio.
Aceitação: A12; links válidos e distinção clara entre materialização e adoção.
Verificação: links locais e revisão do diff; commit documental separado de D1.

## Revisão ampliada solicitada — D3 e D4

O feedback humano de 2026-09-17 mostrou que a matriz anterior não explicava suficientemente
a reconstrução manual. A03, A08 e A10 são reabertos em profundidade operacional; A13–A17
acrescentam Codex, Copilot CLI/VS Code, skills e Sonar existente com URL própria.
Os resultados D1/D2 abaixo são históricos e não comprovam esses novos critérios.

- D3: atualizar goal, spec, este plano e checklist antes do guia; manter aprovação pendente.
- D4: completar guia e navegação e consolidar evidências no goal/plano/checklist; até cinco
  arquivos, em commit separado de D3.
- Entrega: árvore final, inventário origem/destino, sequência de cópia/mescla, skills com
  recursos compartilhados, entrada por agente, comandos Sonar com URL explícita e verificação.
- Verificação: arquivos/parâmetros reais, fontes oficiais abertas, links locais, sintaxe dos
  exemplos PowerShell sem execução, revisão de diff e escopo Markdown.
- Riscos: hooks distintos, referências ausentes nas skills, token não herdado por processo
  já aberto, testes acoplados ao template e diferenças entre servidores.
- Parada: revisão humana documental; sem instalar skills, alterar tooling, habilitar hooks
  Copilot, acessar produto ou executar Sonar/Maven.

## Proposta de execução futura no produto

O guia decompõe o trabalho em diagnóstico, governança, bootstrap técnico, cobertura/baseline,
controles de arquitetura/observabilidade e validação final. Os nomes de arquivos e o número
de fatias dependem do inventário real; cada fatia terá normalmente até cinco arquivos.

Pré-condições: repo e responsável identificados, stack e comandos confirmados, spec/plano do
produto aprovados e GO específico. Não transformar esta proposta em checklist de execução
do produto sem cumprir essas condições.

## Constatações da inspeção do template

- `Get-SonarCodeFingerprint` cobre `src/`, `.mvn/`, `.codex/hooks/`, `test/powershell/`,
  POM/Wrapper/hooks.json e scripts PowerShell da raiz; módulos em outros diretórios ficam fora.
- O fingerprint inclui `.md` dentro dos diretórios monitorados. O teste documental cobre apenas
  README na raiz e `doc/`; a divergência com a isenção por tipo de arquivo exige tarefa futura
  com regressão. Nenhum hook ou teste foi alterado nesta revisão.
- O checkpoint comum recusa baseline `OFFLINE_ONLY_READY`; a passagem para análise local precisa
  preservar evidências e registrar uma inicialização local na revisão acordada. Offline-only
  dispensa token. O guia explicita ambos os limites.
- O analisador usa POM/Wrapper da própria raiz, identidade extraída do XML e `clean verify`;
  não expõe parâmetros para perfis, módulos ou propriedades extras do build.
- Testes de configuração exigem caminhos e decisões particulares do template; não são uma
  certificação universal para cobertura e layout de um produto existente.
- A feature sample e os testes Java de exemplo não devem substituir código/testes do produto.
- `doc/sonar/sonarqube-local.md` conserva narrativa histórica dos Incrementos 9–10, embora o
  harness completo exista. O guia novo usa scripts, AGENTS.md e ADR-0004 como referência do
  comportamento atual; revisão dessa narrativa fica como divergência documental futura.
- O guia de materialização cria identidade e histórico novos; reutilizá-lo no produto existente
  poderia apagar contexto válido. O novo guia mantém procedimentos separados.

## Riscos e verificação

| Risco | Tratamento no guia |
| --- | --- |
| Layout não coberto pelo fingerprint | Parar antes de confiar no hook; especificar adaptação e regressão |
| Dívida preexistente tratada como regressão ou apagada | Inventariar antes/depois e manter política/decisão explícita |
| Scripts dispararem efeitos do build em produção | Inspeção de perfis, plugins e dependências antes da execução |
| Conflito com instruções, hooks e ADRs existentes | Integração por diff, sem sobrescrita ou aceite herdado |
| Confundir guia com ensaio executado | Declarar execução em produto `NÃO_EXECUTADA` |

Verificação desta entrega: documentação, escopo e consistência. Maven, baseline, API Sonar e
checkpoint não se aplicam a esta mudança exclusivamente Markdown.
Revisão: correção da sequência, simplicidade, arquitetura, segurança, custo das verificações,
preservação dos testes e escopo do diff.

## Revisão documental D1 — 2026-09-17

A retomada humana autoriza revisar o guia, seus links, incluir navegação no README e apresentar
a proposta. Não aprova goal/spec/plano nem autoriza aplicação em produto.
O guia foi conferido contra scripts e testes existentes, sem executá-los. Foram esclarecidos
destinos da matriz, referências de testes, isenção Markdown no fingerprint, credencial offline
e transição de baseline offline para local.

| Requisito | Evidência documental | Resultado |
| --- | --- | --- |
| A01 | Guia, introdução e §2: adoção preserva produto; materialização cria outro contexto | Conferido |
| A02 | §1: inventário de stack, módulos, perfis, comandos e controles | Conferido |
| A03 | §4: origem, destino, ação, verificações e testes de cada controle | Conferido |
| A04 | §3: contexto próprio, convenções e decisões anteriores preservados | Conferido |
| A05 | §2 e §5: evidência anterior, falhas preexistentes e recursos de teste | Conferido |
| A06 | §5: baseline próprio válido, Sonar sem harness e bootstrap sem ferramentas | Conferido |
| A07 | §5: token em memória, fonte humana, offline-only e decisão sobre não conformidade | Conferido |
| A08 | §4: limites de fingerprint, Markdown, identidade, branch, perfis e testes | Conferido |
| A09 | §6: fluxo real, fronteiras, sinais e dívida explícita | Conferido |
| A10 | §1–7 e checklist: ordem, pré-condições, saídas, evidências e reversão | Conferido |
| A11 | Estado do guia e limites do goal/spec: nenhum ensaio em produto alegado | Conferido |
| A12 | README: proposta em revisão, goal/spec/plano/checklist e distinção da materialização | Conferido em D2 |

A conferência inicial dos cinco rascunhos e do README encontrou 37 links locais válidos e
42 caminhos de artefatos de referência existentes. Caminhos ilustrativos do produto, estado,
pacotes e relatórios gerados não são artefatos instalados a verificar nesta entrega.
Nenhum destino externo foi consultado e nenhum arquivo em `sonar/` foi inspecionado.
`git diff --check` passou no guia. A validação será repetida após a navegação D2.

## Navegação e verificação documental D2 — 2026-09-17

O README dá acesso ao conjunto em rascunho e ao checklist desta feature, mantendo explícitos
o aceite e o encerramento do bootstrap. O commit D1 da revisão é `945dc12`; D2 registra
a navegação e estas evidências em commit separado.

- Os seis documentos possuem 48 links locais válidos; os 42 caminhos de referência existem.
- `git diff --check` e revisão do diff/staging confirmam escopo exclusivamente Markdown.
- A revisão conferiu sequência, fronteiras, preservação de contratos/dados, autoridade humana,
  custo das verificações e adaptação dos testes. Nenhum segredo ou artefato gerado foi adicionado.
- Goal, spec, plano e guia continuam em rascunho. Aprovação, GO de aplicação, aceite e encerramento
  permanecem pendentes; nenhuma decisão foi inferida.
- Maven, testes PowerShell e Sonar não foram executados. Não houve acesso a produto ou ensaio
  de adoção; a compatibilidade de um futuro piloto permanece `NÃO_VERIFICADA`.

As divergências do fingerprint/Markdown e da narrativa histórica do guia Sonar ficam registradas
para tarefas futuras; não foram corrigidas no tooling nem nos documentos do bootstrap.

## Reconstrução manual e verificação documental D4 — 2026-09-17

D3 foi registrado em `878a545` antes da reescrita. D4 reúne guia, navegação no README e
evidências neste plano, no goal e no checklist, sem alterar scripts ou instalar componentes.

| Critério reaberto/novo | Evidência no guia | Resultado documental |
| --- | --- | --- |
| A03 e A15 | §4.1–4.5: origens H/S/P, árvore, documentos, oito arquivos de scripts/hooks, testes, build e exclusões | Conferido |
| A08 | Limitações em §4: fingerprint, módulos, Markdown, perfis, identidade e testes; §4.8: hooks Copilot ausentes | Conferido |
| A10 | Sequência §4–5, pré-condições/saídas e matriz/checklist em §7 | Conferido |
| A13 | §4.7–4.8 e sessão segura §5: Codex, Copilot CLI e VS Code com passos próprios | Conferido |
| A14 | §4.6: revisão SHA, cópia completa, referências compartilhadas, licença, escopo, descoberta e atualização | Conferido |
| A16 | §5: servidor existente, URL/chave/nome, sessão e chamadas completas; exportador sem ProjectName | Conferido |
| A17 | §7: evidência por componente/agente; hooks Copilot ausentes e rotas reais não ensaiadas | Conferido |

A01, A02, A04–A07, A09, A11 e A12 foram reconferidos nas seções correspondentes da matriz D1/D2
e permanecem atendidos documentalmente. Esta avaliação não é aprovação humana nem ensaio em produto.

A validação dos seis documentos encontrou 63 links locais válidos, incluindo 15 âncoras, e
42 caminhos de referência existentes. Há 14 referências externas às fontes oficiais consultadas
em 2026-09-17, citadas junto às instruções no guia. Os 16 blocos PowerShell passaram na análise
sintática em memória, sem execução. Parâmetros foram comparados aos scripts existentes.
`git diff --check` e revisão do diff confirmam escopo Markdown, sem segredo ou artefato gerado.

A inspeção local também identificou ausência de `~/.agents/references/definition-of-done.md`
na instalação pessoal, embora skills apontem para esse recurso. O roteiro exige copiar
`skills/` e `references/` da mesma revisão. A instalação pessoal não foi corrigida nesta entrega.
A compatibilidade dos hooks Codex no runtime instalado, os lançamentos reais Copilot e a
integração com um Sonar externo permanecem verificações do produto; os scripts não foram alterados.

Maven, testes do harness, baseline, API e checkpoint Sonar não foram executados. Nenhum conteúdo
de `sonar/` foi inspecionado. Publicação documental não autoriza instalação, aplicação ou aceite.

## Checkpoint

Submeter goal/spec/guia ao humano. Não solicitar GO de aplicação antes de existir repositório
piloto, inventário e plano específico revisável. Aceite e encerramento do novo goal permanecem pendentes.
