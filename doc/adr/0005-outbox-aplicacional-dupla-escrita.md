# ADR-0005: Consistência de dupla escrita com Outbox aplicacional

- **Status:** Proposto
- **Decisão em uma frase:** quando uma decisão exigir banco e broker, persistir agregado e outbox na mesma transação local e publicar por relay Quarkus com polling, sem Debezium, XA ou 2PC.
- **Quando consultar:** introdução de persistência + evento, broker, relay, ack, retry, idempotência, ordenação, concorrência ou quarentena.

## Contexto

Gravar no banco e depois publicar diretamente no broker cria uma janela de falha: o commit pode concluir e o broker estar indisponível. Inverter a ordem cria a janela oposta. Uma transação distribuída acopla tecnologias e aumenta custo operacional, e Debezium não estará disponível no contexto inicial.

## Decisão

Quando a mesma decisão de negócio exigir alteração persistente e evento de integração:

- agregado e registro imutável de outbox são gravados na mesma transação local;
- cada registro possui `event_id` imutável, tipo, versão, timestamps, payload e metadados mínimos de correlação;
- relay Quarkus busca lotes por polling e usa lease para concorrência;
- publicação ocorre fora de transação longa;
- registro só é marcado como publicado após confirmação do broker;
- falhas usam retry com backoff e limite; poison messages vão para quarentena;
- semântica é at-least-once; consumidores usam inbox ou restrição única para idempotência;
- ack, ordenação, concorrência, schema, retenção, dados sensíveis e observabilidade são definidos por feature.

O template registra decisão, contrato de planejamento, testes esperados e métricas, mas não adiciona banco ou broker antes de uma necessidade aprovada.

## Verificações obrigatórias quando aplicado

- rollback mantém agregado e outbox consistentes;
- broker indisponível preserva registro pendente;
- retry publica após recuperação;
- queda após publicação pode duplicar sem duplicar efeito no consumidor;
- relays concorrentes respeitam lease;
- ordenação declarada é preservada no escopo escolhido;
- evento inválido alcança quarentena;
- logs e spans não expõem payload sensível.

Métricas mínimas: pendentes, idade do mais antigo, em processamento, publicados, retries, quarentena, duração e última publicação bem-sucedida.

## Consequências

- commit de negócio não depende da disponibilidade imediata do broker;
- existe consistência eventual e operação adicional do relay;
- duplicidade é esperada e precisa ser segura;
- backlog, idade e quarentena precisam de observabilidade e procedimento operacional.

## Alternativas rejeitadas

- **Banco seguido de broker diretamente:** perde evento quando a segunda escrita falha.
- **Broker seguido de banco:** pode publicar evento de estado que nunca foi persistido.
- **XA/2PC:** aumenta acoplamento e fragilidade operacional.
- **Debezium/CDC:** indisponível no contexto definido pelo usuário.
- **Retry em memória:** perde intenção de publicação quando o processo encerra.
