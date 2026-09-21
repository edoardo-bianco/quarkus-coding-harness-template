# Origem dos requisitos do template JBoss EAP

> Continuidade transferida para C:\desenvolvimento\repositorio\jboss-eap-copilot-harness-template,
> branch chore/bootstrap-jboss-harness. Este documento preserva a referência da origem;
> os artefatos de construção ativos pertencem ao novo checkout.

Esta pasta registra o material fornecido pelo usuário para o [goal](../goal.md).

## Prompt recebido

[Prompt para criar o template JBoss EAP](prompt-codex-criar-novo-repositorio-template-jboss-eap-main-arquitetura-preserv.md)
recebido em 2026-09-21. Seu conteúdo foi indicado pelo usuário como o objetivo real e está
preservado como origem dos requisitos. Ele define o novo produto, os destinos, a fonte técnica
`main`, a preparação do harness e a preservação obrigatória da arquitetura das aplicações.

O [goal revisado](../goal.md) consolida esses requisitos e registra estados, evidências e
pendências. O prompt não é substituído silenciosamente a cada revisão do planejamento.

## Guia de migração recebido em outro local

O [guia completo MTA, VS Code e EAP](../../../doc/guias/guia-completo-mta-vscode-jboss-eap70-eap74-copilot-java8.md)
foi adicionado pelo usuário em `doc/guias/`. Esse é seu local canônico; não há cópia nesta pasta.
Ele será utilizado depois da preparação do ambiente/harness, com uma aplicação identificada e
seu próprio plano/GO. Seus exemplos não foram executados durante esta revisão.

O rascunho inicial reservava esta pasta para o guia, antes de o usuário explicar o objetivo.
A organização atual distingue o prompt de requisitos, mantido aqui, do roteiro de migração,
mantido em `doc/guias/`.

## Branch de trabalho e procedência técnica

Trabalhamos no diagnóstico e nos documentos em `chore/preparacao-jboss-harness`. Na máquina
de trabalho, o usuário acompanha `main`. A fonte exclusiva dos componentes reutilizados é
`main` em `22512766897bca4146e940cdca39ab9089f545f4`, conferido local/remoto no H00.
O [plano](../../../tasks/features/novo-repositorio-mta/plan.md) registra evidências e adaptações.

A branch anterior `docs/goal-origem-mta` foi integrada pelo PR #2 e removida. O SHA anterior
`094ebab9fa776e5b737b830f599b0cc67529f93a` fica somente como registro histórico. Prompt e guia
já estão na main consolidada; continuam entradas humanas, não controles executáveis reutilizados.

A leitura exclusiva da origem durante a materialização protege a `main` e o harness executável.
A revisão documental atual foi solicitada pelo usuário e não autoriza copiar arquivos,
instalar ferramentas, criar o novo Git, migrar aplicações ou publicar repositórios.

## Registro da revisão documental

Os dois arquivos foram recebidos sem alteração no commit `4a557fb`. O prompt original permanece
preservado. A revisão do guia explicita sua fase posterior, as pré-condições de adoção/GO/baseline,
os caminhos canônicos de plan/todo, o inventário e a verificação arquitetural por fatia, além da
separação entre descoberta das opções MTA e análise com seleção/limites registrados.

A consulta documental não homologa versões, instalações, scripts ou ambiente corporativo.
Os comandos do guia e a migração continuam não executados; os ensaios pertencem às fatias futuras.

## Consolidação anterior à execução do goal

Em 2026-09-21, o usuário solicitou consolidar todos os documentos e abrir PR para `main`
antes de prosseguir. O PR #2 foi integrado e a limpeza das branches foi concluída. Em seguida,
o usuário autorizou retomar o goal aqui, mantendo a máquina de trabalho na main. O H00 e o
planejamento foram retomados; criação do novo template, instalações e migração continuam
sujeitas aos checkpoints próprios. Depois, o usuário respondeu “Autoriza o H01A”: a fundação
foi materializada no destino independente, com primeiro commit `c0b6d5d981383cb496ae590ece8e15a65d0058f8`.
Aprovação global da spec/plano, GO H01B e publicação continuam pendentes.

Verificação documental: seis arquivos Markdown, dez links locais válidos, treze blocos
PowerShell analisados sintaticamente em memória e quatro exemplos JSON válidos. Nenhum
exemplo foi executado; isso não certifica compatibilidade operacional com PowerShell 5.1,
MTA, JBoss, Copilot ou Sonar. `git diff --check` passou. O prompt original e o guia TortoiseGit
foram preservados; o último integra esta consolidação como material de apoio ao diagnóstico Git.
