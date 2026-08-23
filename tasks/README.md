# Planejamento e execução por feature

A pasta `tasks/` transforma uma especificação aprovada em trabalho pequeno, ordenado e verificável.
O plano explica como entregar; o checklist registra andamento, evidência e o único próximo item
autorizado. Nenhum dos dois substitui goal, spec, arquitetura ou ADR.

## Estrutura

```text
tasks/
  README.md
  templates/
    plan.md
    todo.md
  features/
    <nome-curto>/
      plan.md
      todo.md
```

`tasks/plan.md` e `tasks/todo.md` podem governar o bootstrap ou outra iniciativa que abranja todo o
repositório. Uma feature normal usa sua própria pasta em `tasks/features/<nome-curto>/` para não
misturar decisões e histórico.

## Pré-condições

Antes de criar tarefas:

1. identifique o goal ativo e sua definição de pronto;
2. confirme que a spec aplicável foi revisada e aprovada pelo humano;
3. leia a arquitetura e selecione os ADRs aplicáveis pelo índice;
4. inspecione os contratos, arquivos e testes relacionados no estado atual;
5. transforme divergências, riscos e dúvidas em itens explícitos; não escolha silenciosamente.

Se uma dúvida alterar contrato, arquitetura, segurança, observabilidade ou escopo, interrompa o
planejamento e solicite decisão humana.

## Criar uma feature

1. Crie `tasks/features/<nome-curto>/`.
2. Copie `templates/plan.md` e `templates/todo.md` para a nova pasta.
3. Substitua todos os marcadores e remova linhas opcionais não aplicáveis.
4. Ordene as tarefas por dependência e escreva aceitação e verificação para cada uma.
5. Revise plano e checklist com o humano.
6. Registre o `GO` explícito no checklist; aprovação do plano sem `GO` não autoriza implementação.
7. Execute somente o próximo item pendente e pare nos checkpoints indicados.

## Responsabilidade de cada artefato

| Artefato | Responde | Não deve conter |
| --- | --- | --- |
| Goal | Por que fazer e o que significa pronto | Sequência detalhada de arquivos |
| Spec | O que deve acontecer e como aceitar | Histórico diário de execução |
| Arquitetura/ADR | Como o sistema se organiza e por que uma decisão permanece | Decisão específica de uma execução |
| Plan | Como entregar, em qual ordem, com quais riscos e checkpoints | Resultado mutável de cada comando |
| Todo | Qual é o próximo item, seu estado, evidência e decisão humana | Novas decisões arquiteturais implícitas |

Faça referência à fonte de verdade em vez de copiar a mesma decisão em vários arquivos.

## Qualidade das tarefas

Cada tarefa deve:

- entregar uma fatia coerente, preferencialmente vertical;
- declarar dependências e deixar o repositório em estado verificável;
- ter critérios observáveis e comandos ou inspeções de verificação;
- indicar os arquivos prováveis;
- tocar normalmente de um a cinco arquivos.

Uma tarefa com mais de cinco arquivos precisa ser decomposta ou justificar explicitamente por que
os arquivos formam uma única mudança indivisível. Títulos com duas entregas independentes também
indicam que a tarefa deve ser dividida.

## Estado e próximo item

Use os estados `PENDENTE`, `EM_EXECUCAO`, `BLOQUEADO` e `CONCLUIDO`. Somente uma tarefa pode estar
em execução. O checklist termina com uma seção **Próximo item autorizado**, escrita de forma que
outro agente saiba exatamente onde retomar.

Marcar item como concluído exige evidência. Falha, indisponibilidade ou comando não executado deve
permanecer visível; não converta `UNVERIFIED` em aprovação.

## Checkpoints humanos

Além do `GO` inicial, pare antes de alterar:

- contrato público ou externo;
- domínio, responsabilidade, porta, dependência ou ADR;
- autenticação, autorização, credencial, dado sensível ou superfície de entrada;
- log, span, métrica, health, configuração, timeout, retry ou circuit breaker;
- definição de pronto, escopo ou exceção de qualidade.

Somente o humano registra `GO`, `NO-GO`, aceitação excepcional, ADR aceito, rejeição ou encerramento.
O agente registra evidência e solicita a decisão; nunca a infere.

## Mensageria e dupla escrita

Se a feature envolver banco e broker na mesma decisão, consulte o
[ADR-0005](../doc/adr/0005-outbox-aplicacional-dupla-escrita.md). O plano deve explicitar estratégia
de consistência, limite transacional, ack, entrega, retry, quarentena, idempotência, ordenação,
concorrência, schema/versionamento, retenção, dados sensíveis e observabilidade.

Dupla escrita sequencial direta, retry apenas em memória, XA/2PC ou Debezium não são defaults deste
template. Banco e broker só entram quando a feature aprovada exigir.

## Evidência e encerramento

Para cada verificação, registre:

- comando ou inspeção realmente executado;
- resultado objetivo e artefato relevante;
- limitação, falha ou estado não verificado;
- checkpoint e decisão humana, quando aplicável.

Não versione token, `.env`, estado de agente, baseline ou relatório Sonar, saída de build ou fixture
com dado sensível. Mudança exclusivamente Markdown não executa Sonar; mudança executável segue o
fluxo de baseline e checkpoint definido em `AGENTS.md`.

Quando todos os itens técnicos estiverem concluídos, atualize as evidências e pare. Pronto técnico
não encerra a feature ou o goal: o encerramento continua sendo uma decisão humana.
