# Índice de decisões arquiteturais

Leia este índice depois da [arquitetura do harness](../arquitetura/arquitetura-harness.md). As descrições permitem selecionar decisões relevantes sem abrir todos os ADRs. Leia o arquivo completo quando a coluna **Consultar quando** alcançar a mudança planejada ou quando restar dúvida.

| ADR | Status | Descrição suficiente para triagem | Consultar quando |
| --- | --- | --- | --- |
| [0001 — Java 25, Quarkus LTS e Maven](0001-java-25-quarkus-lts-maven.md) | Proposto | O template usa JDK 25, Quarkus 3.33.3.1 da linha 3.33 LTS e Maven 3.9+ com Wrapper; atualização é manual, planejada e aprovada. | Alterar Java, Quarkus, Maven, BOM, lifecycle, Wrapper ou política de atualização. |
| [0002 — DDD e arquitetura hexagonal pragmática](0002-ddd-hexagonal-pragmatica.md) | Proposto | A aplicação é organizada package-by-domain; portas e adapters protegem responsabilidades e direção de dependência, sem proibir APIs estáveis de Quarkus no núcleo. | Alterar packages, camadas, dependências, modularização, ownership ou regras ArchUnit. |
| [0003 — Governança do SDLC entre humano e agente](0003-governanca-sdlc-humano-agente.md) | Proposto | Goal, especificação, arquitetura, plano e checklist precedem código; somente humano registra GO, exceção, aceite de ADR e encerramento. | Criar ou alterar instruções do agente, checkpoints, definição de pronto, tasks ou autoridade decisória. |
| [0004 — SonarQube como checkpoint técnico com decisão humana](0004-sonarqube-checkpoint-decisao-humana.md) | Proposto | Baseline e checkpoints produzem evidência técnica; offline-only é UNVERIFIED, NON_COMPLIANT não reprova sozinho e hooks não substituem a decisão humana. | Alterar hooks, scripts, token, baseline, fingerprint, thresholds, relatórios ou fluxo de exceção. |
| [0005 — Consistência de dupla escrita com Outbox aplicacional](0005-outbox-aplicacional-dupla-escrita.md) | Proposto | Quando uma decisão exigir banco e broker, agregado e outbox são gravados na mesma transação local e um relay Quarkus publica por polling, sem Debezium, XA ou 2PC. | Introduzir persistência + evento, broker, relay, retry, ack, idempotência, ordenação ou quarentena. |

## Ciclo de vida

- ADR novo começa como **Proposto** e exige checkpoint humano de arquitetura.
- Depois do GO explícito, muda para **Aceito**.
- Uma decisão substituída não é apagada: recebe status **Substituído por ADR-NNNN**.
- O índice é atualizado no mesmo incremento do ADR.
