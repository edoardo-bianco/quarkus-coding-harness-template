# Goals e épicos

Goals tornam persistente o significado de sucesso e de parada. Eles registram **por que** o trabalho existe e **como** o humano decidirá que terminou. Não substituem especificação, arquitetura, plano ou checklist.

## Comece por aqui

1. Copie [templates/goal.md](templates/goal.md) para `goals/<nome-curto>/goal.md`.
2. Substitua todos os marcadores `{{CAMPO}}` por informação real ou registre a questão como bloqueio.
3. Revise objetivo, escopo, definição de pronto, evidências e condições de parada com o humano.
4. Mantenha o estado `RASCUNHO` até a revisão humana.
5. Vincule specs e features ao goal aprovado.

Um projeto derivado cria goals próprios. Não copie `goals/template-harness/goal.md` como histórico do produto; ele pertence à construção deste template.

## Goal em revisão

- [Template independente JBoss EAP](novo-repositorio-mta/goal.md): preparar o harness para
  Copilot/DevSquad, PowerShell 5.1, MTA e Sonar corporativo; migração conservadora com Java 8
  e arquitetura preservada em etapa posterior. Trabalho documental em `docs/goal-origem-mta`,
  com componentes reutilizados exclusivamente do snapshot definido da `main`.

## O que pertence ao goal

- problema e valor esperado;
- pessoas ou sistemas beneficiados;
- resultados observáveis;
- escopo e fora de escopo;
- critérios de sucesso;
- definição de pronto;
- evidências obrigatórias;
- riscos, dependências e condições de parada;
- checkpoints e decisões humanas;
- specs e features relacionadas.

## O que não pertence ao goal

- desenho detalhado da solução: fica na arquitetura e nos ADRs;
- requisitos detalhados: ficam na spec;
- ordem de implementação: fica no plano;
- andamento por tarefa: fica no todo;
- histórico de comandos e logs extensos: fica nas evidências da feature.

## Ciclo de vida

```text
RASCUNHO -> EM_REVISAO -> APROVADO -> EM_EXECUCAO
                                      -> PRONTO_TECNICO
                                      -> ACEITO -> ENCERRADO
```

- `RASCUNHO`: ainda possui hipóteses ou campos não confirmados.
- `EM_REVISAO`: pronto para o humano avaliar objetivo, pronto e limites.
- `APROVADO`: goal aceito; ainda não implica GO para código.
- `EM_EXECUCAO`: pelo menos uma feature foi autorizada.
- `PRONTO_TECNICO`: critérios técnicos atendidos; agente deve parar.
- `ACEITO`: humano verificou valor e evidências.
- `ENCERRADO`: humano encerrou formalmente o goal.

Se houver impedimento, registre-o sem transformar o goal em encerrado. Somente o humano muda para `APROVADO`, `ACEITO` ou `ENCERRADO`.

## Relação entre artefatos

```text
goals/<goal>/goal.md
  -> specs/<mudanca>/spec.md
     -> arquitetura + ADRs aplicáveis
        -> tasks/plan.md + tasks/todo.md
```

Cada spec declara seu goal principal. Se uma mudança servir a mais de um goal, escolha um principal e registre os demais como relacionados; não duplique critérios para parecer que existem dois donos.

## Qualidade de um goal

Um goal está pronto para revisão quando outra pessoa consegue responder sem conversa adicional:

- Qual problema será resolvido e para quem?
- Qual valor precisa ser percebido?
- O que está explicitamente fora?
- Quais evidências demonstram sucesso?
- Em quais situações o agente deve parar?
- Quem possui autoridade para aceitar e encerrar?

Evite verbos vagos como “melhorar”, “modernizar” ou “otimizar” sem medida observável. Reescreva-os como resultados verificáveis e peça confirmação humana.

## Mudança de goal

Se valor, escopo ou pronto mudar durante a execução:

1. pare o incremento afetado;
2. atualize o goal e as specs relacionadas;
3. mostre impacto em plano, riscos e evidências;
4. obtenha nova decisão humana antes do código.

Não altere retroativamente decisões humanas. Acrescente um registro datado explicando a mudança.
