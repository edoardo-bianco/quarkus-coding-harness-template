# Especificações

Uma spec define **o que** será construído, **por que** e **como** será verificado antes de escrever código. Ela transforma intenção aprovada em requisitos e contratos testáveis. Não substitui goal, arquitetura, ADR ou plano.

## Quando criar

Crie uma spec para:

- novo projeto ou feature;
- mudança comportamental em mais de um arquivo;
- contrato público ou externo;
- decisão arquitetural, de segurança ou observabilidade;
- migração, descontinuação ou integração;
- requisito ainda ambíguo que levaria o agente a adivinhar.

Correção textual ou alteração trivial e autocontida pode usar critérios curtos no plano, desde que não esconda mudança comportamental.

## Comece por aqui

1. Tenha um goal principal revisado.
2. Copie [templates/spec.md](templates/spec.md) para `specs/<nome-curto>/spec.md`.
3. Substitua todos os marcadores `{{CAMPO}}`; desconhecido vira questão explícita.
4. Confirme hipóteses, contratos e critérios com o humano.
5. Mantenha estado `RASCUNHO` até não existirem questões que mudem materialmente a solução.
6. Registre aprovação humana antes do plano e do código.

## Conteúdo obrigatório

Toda spec cobre seis áreas centrais:

1. **Objetivo:** problema, usuário, resultado e sucesso.
2. **Comandos:** comandos completos de build, teste, análise e execução, cada um com estado verificado ou pendente.
3. **Estrutura:** packages e locais de fonte, teste, documentação e evidência.
4. **Estilo:** convenções e um exemplo de código pretendido ou real.
5. **Testes:** níveis, riscos cobertos, cobertura e comandos.
6. **Limites:** sempre fazer, perguntar antes e nunca fazer.

Quando aplicável, inclua contratos, dados, segurança, observabilidade, mensageria, consistência, migração e rollback.

## Ciclo de vida

```text
RASCUNHO -> EM_REVISAO -> APROVADO -> IMPLEMENTADO
                           -> SUBSTITUIDO por nova spec
```

- Somente o humano muda para `APROVADO`.
- Aprovar spec não autoriza código: plano, checklist e GO continuam obrigatórios.
- Mudança de requisito atualiza a spec antes da implementação correspondente.
- Spec substituída não é apagada; registre sucessora e motivo.

## Relação com outros artefatos

```text
goal: por que e pronto
spec: o que e critérios
arquitetura/ADR: desenho e decisões permanentes
plan: como e em qual ordem
todo: próximo item e evidência
```

A spec aponta para goal, arquitetura e ADRs aplicáveis. O plano aponta de volta para a spec. Não copie a mesma decisão detalhada nos quatro lugares; registre a fonte de verdade e faça referências.

## Hipóteses e dúvidas

Liste hipóteses antes de decidir. Uma hipótese que muda contrato, persistência, segurança, integração ou operação bloqueia aprovação até o humano confirmar. Não esconda decisão dentro de exemplo ou critério.

Questões abertas precisam mostrar impacto e opções conhecidas. Se não houver evidência suficiente, registre “desconhecido”; não escolha o default mais conveniente ao agente.

## Critérios de aceitação

Critério bom é observável e falsificável:

- identifica condição, ação e resultado;
- inclui erro e limite relevante;
- informa evidência ou teste esperado;
- evita “funciona corretamente”, “melhor desempenho” ou “boa cobertura” sem medida.

## Revisão humana

Antes de aprovar, confirme:

- goal e valor continuam alinhados;
- todos os marcadores obrigatórios foram substituídos;
- comandos não verificados estão marcados como pendentes;
- contratos e casos de erro são explícitos;
- segurança e dados sensíveis foram considerados;
- sinais observáveis não expõem payload ou alta cardinalidade;
- dupla escrita possui estratégia consistente quando aplicável;
- critérios têm evidência e não dependem de interpretação do agente;
- fora de escopo impede expansão especulativa.
