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

## Ensaio humano solicitado — D5 e D6 (histórico)

A opção de execução humana descrita nesta etapa foi substituída como padrão por D7/D8.
Ela permanece apenas como alternativa no roteiro atual.

- D5: registrar A18–A20 em goal/spec/plano/checklist, antes de redigir o roteiro.
- D6: criar guia de ensaio, vinculá-lo ao guia de adoção e registrar evidências em goal/plano/todo
  (cinco arquivos). Verificar links e sintaxe dos exemplos sem executá-los.
- Na versão D5/D6, o fluxo era: diagnóstico sem Sonar; preparação/baseline; incremento autorizado;
  agente preparava comando e parava; humano executava e informava resultado; agente retomava.
- Não introduzir alteração fictícia de produção para testar o fluxo. CLI e VS Code são ensaiados
  separadamente, sem análise concorrente, reset do baseline ou suposição de conversa compartilhada.
- Lembretes Copilot equivalentes são uma etapa de integração possível. Documentar critérios e como
  pedir proposta ao agente; não criar, ativar ou simular como instalados esses hooks nesta entrega.
- Parada desta preparação: entregar instruções ao usuário; execução e resultados ficam pendentes
  de sua devolutiva. Isso não representa aceite do conjunto documental nem GO para alterar produto.

## Alinhamento autorizado — D7 e D8

- D7: atualizar goal, spec, plano e checklist antes de corrigir os guias; A18–A20 passam a
  exigir o ciclo principal pelo agente, com permissão de ferramenta e decisão humana distintas.
- D8: alinhar os dois guias, README e evidências em goal/plano/todo. São seis arquivos Markdown
  para manter o roteiro, sua navegação e os três registros de evidência coerentes no mesmo incremento.
- Fluxo: agente desenvolve/testa na fatia autorizada, executa checkpoint permitido e acompanha
  seu término; humano decide eventual NON_COMPLIANT; agente registra a decisão, ajusta e revalida.
- Credencial: documentar launcher CLI e preparação de VS Code local/terminal; verificar presença
  no processo efetivo sem valor do token; preservar a regra de não persistir credencial.
- Execução humana com mensagem de retorno fica como alternativa. Hooks continuam lembretes e
  não são dependência para o agente executar scripts; sua integração real continua pendente.
- Verificação: busca de instruções contraditórias, fontes oficiais, links/âncoras, sintaxe dos
  exemplos em memória, revisão do diff exclusivamente Markdown. Não executar o ensaio, Maven/Sonar,
  scripts, instalações ou alterações de configuração nesta entrega.

## Reconhecimento do ambiente e escolha humana — D9 a D11

Pedido humano: reconhecer o ambiente existente e perguntar se deseja manter a configuração
ou alterar JDK, Quarkus e Maven, mostrando onde ajustar. Autoriza instruções e guias; não é
escolha de versões, aceite do conjunto nem GO para modificar `simtr-documento-assinc`.

- D9: atualizar goal/spec/plano/todo antes das instruções; critérios A21–A25.
- D10: ajustar AGENTS e arquitetura, criar ADR proposto e atualizar seu índice (quatro arquivos).
  Preservar ADR-0001 e o scaffold aceito; diferenciar nova materialização e adoção existente.
- D11: atualizar guia, ensaio Copilot, README e evidências em goal/plano/todo (seis arquivos para manter roteiro e registros coerentes).
  Incluir diagnóstico declarado/efetivo, pergunta explícita, matriz de versões e locais de ajuste,
  caminhos manter/alterar/pendente, limites reais e validação condicionada ao GO do produto.
- Verificação: fontes oficiais Maven/Quarkus, links/âncoras, análise sintática dos exemplos sem
  execução e revisão de cenários documentais. Somente Markdown; sem Maven, Sonar ou instalação.
- Riscos: confundir release com JDK instalado, alterar parent compartilhado, desalinhamento entre
  BOM/plugin/extensões, Wrapper/distribuição, IDE/CI/container; tratar versão diferente como
  incompatibilidade comprovada ou presumir que manter versões já valida os controles.
- Parada: apresentar alterações e ADR proposto para revisão humana; ensaio real permanece pendente.

### Candidato inspecionado somente por leitura

`edoardo-bianco/simtr-documento-assinc`, `main` no commit `3ff62495d960936ed334187f57be3d5a21e37e4b`:
POM com release 11, Quarkus 2.16.7.Final, um módulo e dependências JUnit/JaCoCo; Wrapper com Maven
3.8.8; árvore sem `src/test` e sem harness versionado. Fontes: [POM](https://github.com/edoardo-bianco/simtr-documento-assinc/blob/3ff62495d960936ed334187f57be3d5a21e37e4b/pom.xml),
[Wrapper](https://github.com/edoardo-bianco/simtr-documento-assinc/blob/3ff62495d960936ed334187f57be3d5a21e37e4b/.mvn/wrapper/maven-wrapper.properties)
e [árvore](https://github.com/edoardo-bianco/simtr-documento-assinc/tree/3ff62495d960936ed334187f57be3d5a21e37e4b).
Nenhum build, teste ou Sonar foi executado; JDK local e compatibilidade permanecem não verificados.

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

## Roteiro de ensaio humano D6 — 2026-09-17 (histórico)

Evidência da versão anterior: sua execução humana obrigatória foi substituída pelo fluxo D7/D8.
Os resultados abaixo não comprovam o roteiro corrigido nem um ensaio real.

D5 registrado em `c98f14b`. D6 acrescenta o roteiro de ensaio e sua ligação no guia de adoção.
O usuário executará os passos e devolverá evidências. Nenhum script, hook ou critério foi alterado.

| Critério | Evidência no roteiro | Resultado documental |
| --- | --- | --- |
| A18 | §1–4 e §6–7: ficha, contextos separados, montagem, prompts, comandos e retorno | Conferido |
| A19 | §3–5: agente termina a resposta, humano executa, informa o resultado e agente retoma | Conferido |
| A20 | §8: proposta futura de lembretes equivalentes, preservando política e separando ensaios | Conferido |

A expressão anterior de excluir hooks do escopo foi esclarecida: configuração equivalente pode
integrar o objetivo de adoção; esta entrega documental não a implementa nem declara seu ensaio.
A execução manual não certifica automação. Scripts Sonar continuam disparados explicitamente,
e a retomada naquela versão dependia de nova mensagem humana. No roteiro vigente, essa passagem
manual ficou restrita à alternativa pelo desenvolvedor; o fluxo principal recebe a saída da ferramenta.

Verificação: 71 links locais (19 âncoras) válidos em sete documentos; 42 caminhos existentes.
Os 6 novos blocos PowerShell passaram na análise sintática em memória, sem execução; os 16
blocos já verificados do guia principal não mudaram. Diff somente Markdown, sem segredo.
Maven, Sonar, instalação, hooks e ensaio em produto não foram executados. Devolutiva pendente.

## Alinhamento documental D8 — 2026-09-17

D7 registrado em `8b807aa` antes da correção dos guias. O usuário autorizou alinhar todos os
documentos ao fluxo com execução pelo agente no CLI e no VS Code. Foram corrigidos roteiro,
guia principal, instruções de exemplo, prompts, matrizes, checklist, README e evidências.
O histórico D5/D6 foi identificado como substituído, sem apagar decisões ou evidências.

| Critério | Evidência atual | Resultado documental |
| --- | --- | --- |
| A13 e A16 | Guia §4.8/5; roteiro §2–4: terminal do agente, permissões, identidade e sessão CLI/VS Code | Conferido |
| A18 | Roteiro §1–4/9: preparação, prompts, execução supervisionada e devolutiva | Conferido |
| A19 | Roteiro §4–6: agente aguarda resultado, humano decide, agente registra/ajusta/testa/revalida | Conferido |
| A20 | Roteiro §7–8: alternativa humana e lembretes independentes do ciclo de execução | Conferido |

A busca nos documentos de orientação encontrou as descrições antigas somente no histórico
explicitamente substituído ou na alternativa manual. Os demais critérios A01–A17 mantêm seus
limites e evidências documentais; nenhuma compatibilidade real foi declarada sem ensaio.

Verificação: 72 links locais válidos, incluindo 20 âncoras, em sete documentos; 42 caminhos de
referência existentes. Os 17 blocos PowerShell do guia e os 7 do roteiro passaram na análise
sintática em memória, sem execução. As fontes oficiais de execução/permissões e de ambiente/
sessões do VS Code foram consultadas; `git diff --check` passou.

A preparação do VS Code explica instância existente, restauração de terminais e verificação do
token no processo efetivo sem exibir seu valor. Nenhum editor foi aberto/configurado, nenhum
script/hook alterado e nenhum comando do roteiro, Maven ou Sonar foi executado.
A devolutiva do ensaio e o aceite documental continuam humanos.

## Reconhecimento do ambiente D10/D11 — 2026-09-17

D9 registrado em `f0a8ee6`; D10 em `42afd20`. AGENTS passou a orientar o reconhecimento e a
escolha humana; arquitetura/índice distinguem a adoção do scaffold e o ADR-0006 permanece Proposto.
D11 alinha guia, prompt e ficha Copilot, README e evidências. Nenhuma versão executável mudou.

| Critério | Evidência documental | Resultado |
| --- | --- | --- |
| A21 | Guia §1.1–1.2/1.5 e AGENTS: declarado/efetivo, origem, herança e lacunas | Conferido no texto |
| A22 | Guia §1.2/1.4 e prompt Copilot §3: manter/alterar, alvos faltantes e resposta prévia | Conferido no texto |
| A23 | Guia §1.3: matriz de POM/parent, JDK/toolchains, BOM/plugin, Wrapper, IDE/CI/imagens | Conferido no texto |
| A24 | Guia §1.2/1.4, AGENTS e ADR proposto: versão não imposta, GO e validação por controle | Conferido no texto |
| A25 | Guias, README e instruções alinhados; cenários abaixo | Conferido no texto |

Revisão de cenários, sem execução de agente ou produto:

| Cenário | Comportamento exigido pelo texto |
| --- | --- |
| Manter Java 11 / Quarkus 2.16.7 / Maven 3.8.8 | Preservar versões; planejar e ensaiar controles, sem declarar compatibilidade pronta |
| Alterar apenas Quarkus, sem informar alvo | Pedir alvo ou preparar opções; não atualizar também JDK/Maven por suposição |
| Alvos definidos, mas sem GO de aplicação | Apresentar matriz/impacto/plano; não editar arquivos executáveis |
| Sem resposta | Prosseguir só com leituras independentes; integração aguarda |
| Escolha já registrada na sessão | Respeitar a resposta sem repetir a pergunta |
| POM declara release 11, JDK efetivo desconhecido ou divergente | Separar os valores e registrar lacuna/conflito; não inferir JDK nem aplicar correção automática |

Verificação: 11 documentos, 99 links locais válidos (25 âncoras), 42 caminhos de referência.
Os 18 blocos PowerShell do guia e os 7 do ensaio passaram na análise sintática em memória.
Fontes oficiais Maven/Quarkus consultadas para release, toolchains, plataforma, migração e Wrapper.
Revisão de diff e `git diff --check` sem erro; somente Markdown, sem segredo ou artefato gerado.

O POM, Wrapper, scripts, hooks e testes do template não foram alterados. Maven, Sonar, instalação
e ensaio em produto não foram executados. O candidato permanece com escolha de versões/GO pendentes;
o ensaio nos agentes e o aceite documental/arquitetural continuam dependentes do humano.

## Checkpoint

Submeter goal/spec/guia e ADR-0006 proposto ao humano. Não solicitar GO de aplicação antes de existir repositório
piloto, inventário e plano específico revisável. Aceite e encerramento do novo goal permanecem pendentes.
