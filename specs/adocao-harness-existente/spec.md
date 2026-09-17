# Especificação — Guia de adoção do harness em repositório existente

- Estado: `RASCUNHO`; aprovação humana pendente.
- Data: 2026-09-16.
- Goal: [adoção manual](../../goals/adocao-harness-existente/goal.md).
- Arquitetura de referência: [harness](../../doc/arquitetura/arquitetura-harness.md).
- ADRs consultados: 0001 (compatibilidade), 0002 (fronteiras), 0003 (autoridade) e 0004 (Sonar).
- Entrega solicitada: documentação para revisão, sem aplicação em repositório de produção.

## Objetivo e usuário

Orientar a pessoa responsável por um produto existente na integração gradual de todos os controles
do harness, identificando controles equivalentes já implantados e lacunas que exigem tarefas próprias.

## Premissas e limites

O produto mantém repositório Git, identidade Maven, pacotes, contratos, releases e histórico próprios.
Não se aplica a criação de histórico novo nem a substituição da aplicação por `sample`.

A adoção técnica nesta versão é limitada a Java 25 + Quarkus LTS + Maven. Outra stack requer
especificação própria. Mesmo nessa stack, versões, módulos, perfis e caminhos devem ser conferidos;
o guia não autoriza upgrade. O artefato ensaiado do template usa Quarkus 3.33.3.1 e Maven 3.9.16.

Repo piloto, branch-base, comandos e ambiente de testes: ainda não informados; solicitar quando a
adoção real for iniciada. Não são bloqueios para elaborar este documento genérico.

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

## Comandos e verificações

Nesta entrega: `git diff --check`, revisão de links locais e inspeção dos arquivos referenciados.
Não executar Maven, scripts PowerShell do harness ou Sonar, conforme isenção exclusivamente Markdown.

No produto: começar por `git status -sb`, `git rev-parse --show-toplevel` e
`git rev-parse --verify HEAD`. Os comandos de build/teste são os do produto, inspecionados antes
de executar; `.\mvnw.cmd -q verify` é exemplo condicionado à existência do Wrapper e à validação
dos perfis e efeitos. O guia inclui comandos do harness somente após integração e GO.

## Estrutura e estilo

- `goals/adocao-harness-existente/goal.md`: valor, pronto e autoridade.
- `specs/adocao-harness-existente/spec.md`: requisitos desta entrega.
- `tasks/features/adocao-harness-existente/`: plano/checklist desta feature documental.
- `doc/guias/adotar-harness-repositorio-existente.md`: procedimento manual e checklist para o produto.
- `README.md`: acesso ao novo goal e guia.

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
