# Especificação — Guia de adoção do harness em repositório existente

- Estado: `RASCUNHO`; aprovação humana pendente.
- Data: 2026-09-16.
- Goal: [adoção manual](../../goals/adocao-harness-existente/goal.md).
- Arquitetura de referência: [harness](../../doc/arquitetura/arquitetura-harness.md).
- ADRs consultados: 0001 (compatibilidade), 0002 (fronteiras), 0003 (autoridade), 0004 (Sonar) e 0006 (adoção com reconhecimento do ambiente; `Proposto`).
- Entrega solicitada: documentação para revisão, sem aplicação em repositório de produção.

## Objetivo e usuário

Orientar a pessoa responsável por um produto existente na integração gradual de todos os controles
do harness, identificando controles equivalentes já implantados e lacunas que exigem tarefas próprias.

## Premissas e limites

O produto mantém repositório Git, identidade Maven, pacotes, contratos, releases e histórico próprios.
Não se aplica a criação de histórico novo nem a substituição da aplicação por `sample`.

A adoção começa pelo ambiente Java/Quarkus/Maven do produto, sem impor as versões do template.
O agente apresenta o diagnóstico e pede escolha explícita entre manter a configuração existente
ou propor alterações em componentes selecionados. Nenhuma opção é presumida por silêncio.
Diferença de versão, sozinha, não impede planejar a adoção; incompatibilidade concreta limita
cada controle afetado até adaptação aprovada e ensaiada. Outra linguagem/build tool exige plano próprio.
O template continua verificado em Java 25, Quarkus 3.33.3.1 e Maven 3.9.16; essas evidências não
certificam o produto. Esta entrega altera instruções e documentação, não scripts ou versões reais.

Candidato indicado: `edoardo-bianco/simtr-documento-assinc`, `main`, commit `3ff6249`.
Inventário remoto: release Java 11, Quarkus 2.16.7.Final, Maven 3.8.8 no Wrapper; ambiente local,
comandos de teste, escolha de versões e autorização de aplicação ainda não confirmados.

## Requisitos e critérios de aceitação

| ID | Requisito verificável |
| --- | --- |
| A01 | Diferenciar explicitamente produto existente e novo; preservar Git, remotos, identidade, contratos e dados. |
| A02 | Levantar stack, módulos, comandos, perfis, pipelines, instruções e controles existentes antes de copiar arquivos. |
| A03 | Mapear o que criar, integrar, adaptar e não transportar, incluindo templates, scripts, hooks, cobertura e testes. |
| A04 | Criar goal/spec/tasks de adoção próprios; conservar documentação, decisões e histórico anteriores do produto. |
| A05 | Estabelecer evidência anterior à mudança, tratar falhas preexistentes e exigir ambientes de teste seguros. |
| A06 | Distinguir baseline existente do produto, baseline ausente e bootstrap sem ferramentas; preservar estado próprio válido e nunca herdar o do template. |
| A07 | Explicar token só no processo, seleção humana de fonte offline, `UNVERIFIED` e decisão humana para `NON_COMPLIANT`. |
| A08 | Explicitar limites de fingerprint, layout, identidade Sonar, perfis e testes acoplados ao template. |
| A09 | Adaptar regras arquiteturais e observabilidade a um fluxo real, com checkpoints e tratamento explícito de dívida. |
| A10 | Fornecer ordem, pré-condições, critérios de saída, checklist, evidências, revisão e reversão por etapa. |
| A11 | Não alegar testes/adoção em produto sem execução; diferenciar guia proposto de capacidade instalada e verificada. |
| A12 | Tornar o guia encontrável pelo README, mantendo o histórico do bootstrap encerrado. |
| A13 | Dar passos distintos para Codex, Copilot CLI e VS Code; distinguir instruções, skills, scripts e hooks. |
| A14 | Explicar instalação manual de `addyosmani/agent-skills`, revisão de origem, escopo, recursos compartilhados, licença, atualização e descoberta. |
| A15 | Listar todas as pastas e arquivos do harness por origem/destino, necessidade, ordem de cópia e colisões; incluir arquivos ocultos e testes. |
| A16 | Documentar Sonar já instalado com URL própria: pré-requisitos, identidade, sessão segura e exemplos completos de análise, baseline, checkpoint e exportação. |
| A17 | Fornecer verificação por agente/componente; declarar hooks Copilot ausentes e instalações/sessões não ensaiadas. |
| A18 | Fornecer ensaio supervisionado em Copilot CLI e VS Code com execução dos scripts pelo agente: pré-condições, sessão, prompts, permissões e formulário de retorno. |
| A19 | Descrever o ciclo agente executa/aguarda/avalia; humano decide NON_COMPLIANT; agente registra a resposta, ajusta, testa e repete dentro da autorização. Separar permissão de comando, decisão técnica e aceite final; execução humana é alternativa. |
| A20 | Preservar scripts, política e autoridade; o ciclo pelo agente independe dos hooks. Lembretes Copilot equivalentes exigem ensaio próprio e não disparam Sonar, bloqueiam nem decidem. |
| A21 | Antes da cópia, apresentar versões declaradas, origem real, herança/perfis e ambiente efetivo ou NÃO_VERIFICADO; não confundir release Java, JDK de execução e Maven Wrapper. |
| A22 | Perguntar manter configuração ou alterar componentes selecionados; exigir versões-alvo explícitas e registrar a resposta sem presumir escolha ou GO. |
| A23 | Mapear arquivos/chaves de JDK, Quarkus e Maven com valores atuais/propostos, BOM/plugin, parent, toolchains, IDE, CI e imagens quando existentes. |
| A24 | Manter versões permite planejar adaptação dos controles; alterar exige impacto, compatibilidade oficial, plano/GO e validação posterior. Não prometer suporte nem atualizar o legado implicitamente. |
| A25 | Alinhar AGENTS, guias, prompt Copilot, README e registros; conferir caminhos manter/alterar/indefinido e o exemplo Java 11/Quarkus 2/Maven 3.8.8 sem executar o produto. |

Revisão ampliada solicitada em 2026-09-17: A03, A08 e A10 exigem detalhamento operacional;
A13–A17 cobrem Codex, Copilot CLI/VS Code, skills e Sonar existente. Aprovação humana pendente.
Copilot cloud agent fica fora do escopo. No CLI e no VS Code local, o agente executa o checkpoint
pela ferramenta de terminal, sujeito às permissões e à sessão preparada. Hooks automáticos
exigem integração própria e não são pré-condição para essa execução.

A orientação humana vigente é testar o comportamento existente com execução pelo agente nos
dois ambientes. O desenvolvedor fornece a credencial pelo mecanismo seguro, autoriza comandos
quando solicitado e decide sobre os resultados. Copiar resultados manualmente é alternativa.
Conferir a disponibilidade do token no processo efetivo da ferramenta sem mostrar seu valor;
um terminal ou editor já aberto não comprova herança. Instalação e ensaio continuam pendentes.
Hooks equivalentes podem ser planejados sem alterar a função de lembrete.

## Comandos e verificações

Nesta entrega: `git diff --check`, revisão de links locais e inspeção dos arquivos referenciados.
Não executar Maven, scripts PowerShell do harness ou Sonar, conforme isenção exclusivamente Markdown.
Exemplos de cópia e instalação são conteúdo do guia; não serão executados. Consultar fontes
oficiais dos agentes e das skills e validar a sintaxe PowerShell em memória, sem invocar os blocos.

No produto: começar por `git status -sb`, `git rev-parse --show-toplevel` e
`git rev-parse --verify HEAD`. Os comandos de build/teste são os do produto, inspecionados antes
de executar; `.\mvnw.cmd -q verify` é exemplo condicionado à existência do Wrapper e à validação
dos perfis e efeitos. O guia inclui comandos do harness somente após integração e GO.

## Estrutura e estilo

- `goals/adocao-harness-existente/goal.md`: valor, pronto e autoridade.
- `specs/adocao-harness-existente/spec.md`: requisitos desta entrega.
- `tasks/features/adocao-harness-existente/`: plano/checklist desta feature documental.
- `doc/guias/adotar-harness-repositorio-existente.md`: procedimento manual e checklist para o produto.
- `doc/guias/ensaio-manual-copilot.md`: roteiro supervisionado, execução pelo agente e devolutiva;
  nome do arquivo preservado para manter links existentes.
- `README.md`: acesso ao novo goal e guia.
- `AGENTS.md`: reconhecimento e escolha de versões antes da adoção.
- Arquitetura e índice de ADRs: distinguir template, adoção existente e proposta de decisão própria.

Usar português, passos manuais e comandos condicionados a pré-requisitos. Exemplos de destinos
são formatos, não escolhas para o produto. Não há código de produção novo nem mudança de estilo Java.

## Fronteiras e revisão

Sempre: preservar o produto e apontar evidências/limitações reais.
Pedir decisão: antes de aplicar ao produto, alterar contrato, arquitetura, segurança, observabilidade
ou política de qualidade.
Nunca: substituir árvore de código ou POM, apagar histórico, redefinir baseline para ocultar dívida,
copiar segredos/estado, instalar infraestrutura ou executar comandos do guia implicitamente.

A revisão é documental. Um ensaio futuro depende de GO próprio e não integra os critérios de execução
desta solicitação. O guia não altera os ADRs aceitos nem declara uma adoção arquitetural automática.
