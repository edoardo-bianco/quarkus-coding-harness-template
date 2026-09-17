# Goal — Adoção manual do harness em repositório existente

## Identificação

- ID: `adocao-harness-existente`
- Estado: `RASCUNHO`, preparado para revisão humana.
- Responsável e autoridade de aceite: usuário solicitante.
- Criado em: 2026-09-16.
- Spec: [adoção manual](../../specs/adocao-harness-existente/spec.md).
- Planejamento: [plano](../../tasks/features/adocao-harness-existente/plan.md) e [checklist](../../tasks/features/adocao-harness-existente/todo.md).
- Goal anterior: [bootstrap encerrado](../template-harness/goal.md), preservado como histórico.

## Problema e valor

Um repositório com código em produção precisa receber os controles de desenvolvimento do harness
sem perder identidade, histórico, contratos, infraestrutura ou decisões já existentes. O guia de
materialização atual pressupõe um produto novo e não atende essa adoção.

O valor desta entrega é permitir que uma pessoa planeje e execute a integração manual por etapas,
com evidência anterior e posterior, sabendo o que preservar, adaptar, verificar e submeter ao humano.

## Objetivo e resultados observáveis

Preparar um guia manual reutilizável para diagnosticar um repositório existente e planejar a adoção
de governança, testes, arquitetura, observabilidade e qualidade Sonar do harness.

Resultados: matriz de artefatos; roteiro com dependências e critérios de saída; checklist de
adoção; tratamento de dívida e incompatibilidades; checkpoints e reversão sem reescrever histórico.

## Escopo desta solicitação

- Guia manual e planejamento documental, publicados neste template.
- Novo goal, spec em rascunho e proposta de etapas, vinculados sem reabrir o bootstrap.
- Adoção técnica destinada à stack suportada: Java 25, Quarkus LTS e Maven.
- Diagnóstico de estruturas, ferramentas e controles já presentes.
- Preservação de código, identidade, histórico, decisões e configuração operacional do produto.
- Identificação das adaptações necessárias antes de aplicar o harness.

## Fora de escopo

- Alterar qualquer repositório de produção nesta entrega.
- Executar instalação, migração, refatoração, análise Sonar, deploy ou ensaio em produto.
- Criar instalador/gerador, substituir POM ou atualizar versões automaticamente.
- Implementar suporte para outra stack ou resolver dívida preexistente.
- Aprovar o goal, a spec, ADRs do produto, merge, release ou configuração GitHub por inferência.

## Critérios de sucesso e pronto

- [ ] Humano revisou o objetivo, limites e critérios da spec.
- [x] Guia distingue adoção de produto existente da materialização de um produto novo.
- [x] Cada capacidade do harness possui origem, destino, ação e verificação.
- [x] Roteiro cobre diagnóstico, preservação, governança, testes, Sonar, hooks, observabilidade e reversão.
- [x] Limitações reais dos scripts e casos de dívida/indisponibilidade estão explícitos.
- [x] Links, arquivos referenciados e escopo documental foram conferidos.
- [x] Evidências documentais foram apresentadas; execução no produto permanece `NÃO_EXECUTADA`.

A entrega documental não comprova adoção em um produto. Um piloto real exige identificação do
repositório, plano próprio, aprovação e GO antes de alterações executáveis.

## Evidências obrigatórias

| Evidência | Local | Estado |
| --- | --- | --- |
| Guia manual e checklist de adoção | [Guia](../../doc/guias/adotar-harness-repositorio-existente.md) | Revisado documentalmente em 2026-09-17; aprovação pendente |
| Requisitos e critérios | Spec relacionada | Rascunho |
| Inspeções e revisão documental | Checklist da feature | 48 links locais e 42 caminhos conferidos; matriz A01–A12 no plano |
| Adoção ou testes em produto | Futuro repositório piloto | `NÃO_EXECUTADO`; fora desta entrega |
| Maven/Sonar do template nesta entrega | Não aplicável: somente Markdown | Isenção do AGENTS.md |

## Dependências, riscos e parada

O repositório piloto ainda não foi informado; isso não impede escrever o guia genérico, mas impede
declarar sua compatibilidade, comandos de build ou cobertura como verificados.

| Risco | Mitigação |
| --- | --- |
| Sobrescrever controles ou histórico do produto | Integração por diff; preservar decisões aceitas e remotos |
| Executar testes contra serviços de produção | Conferir perfis, efeitos do build e dependências antes de executar |
| Copiar pressupostos do exemplo | Selecionar fluxo real e adaptar testes sem importar sample |
| Declarar conformidade sem medir módulos e dívida | Validar escopo do fingerprint, relatório e política antes da análise |

Parar antes de aplicação em um produto, diante de incompatibilidade material, alteração de contrato,
arquitetura, segurança ou observabilidade, ou quando o guia estiver pronto para revisão humana.

## Decisões humanas

| Data | Registro | Efeito |
| --- | --- | --- |
| 2026-09-16 | Usuário pediu planejar a adoção em repositório existente e preparar primeiro um guia manual | Autoriza esta preparação documental; não é GO para alterar produto |

Aprovação do goal/spec, aceite final e encerramento: `PENDENTES`. Somente o humano decide.
