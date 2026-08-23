# ADR-0003: Governança do SDLC entre humano e agente

- **Status:** Aceito
- **Decisão em uma frase:** goal, especificação, arquitetura, plano e checklist governam incrementos, enquanto somente o humano concede GO, aceita exceção, aceita ADR e encerra o trabalho.
- **Quando consultar:** alterações em `AGENTS.md`, goals, specs, tasks, checkpoints, definição de pronto, autonomia ou encerramento.

## Contexto

Um agente pode executar rapidamente mudanças coerentes, mas não deve adivinhar significado de pronto, ampliar escopo ou tratar sucesso técnico como aceitação de produto. Conversa isolada também não é contexto persistente suficiente para sessões futuras.

## Decisão

Todo desenvolvimento significativo segue:

1. goal/épico com valor, escopo, pronto, evidências e condições de parada;
2. especificação revisada pelo humano;
3. arquitetura e ADRs aplicáveis;
4. plano e checklist ordenados por dependência;
5. GO humano antes da primeira alteração de produção;
6. incrementos pequenos com testes e evidências;
7. verificação e encerramento humanos.

Checkpoints adicionais precedem mudanças de contrato, arquitetura, segurança e comportamento observável. Mudança de escopo atualiza artefatos antes do código. `AGENTS.md` funciona como mapa operacional; decisões permanentes ficam nos ADRs e andamento fica em tasks.

## Consequências

- contexto e autoridade sobrevivem a sessões e agentes diferentes;
- haverá mais paradas conscientes antes de mudanças de alto impacto;
- o humano precisa registrar decisões explicitamente;
- planos e documentação precisam permanecer alinhados ao estado implementado.

## Alternativas rejeitadas

- **Agente executa até considerar pronto:** confunde evidência técnica com valor aceito.
- **Aprovação somente na conversa:** perde rastreabilidade e contexto persistente.
- **Todos os detalhes em `AGENTS.md`:** mistura mapa operacional, arquitetura e histórico e degrada o contexto.
- **Hook bloqueia automaticamente:** transforma automação local em autoridade que ela não possui.
