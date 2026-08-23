# ADR-0002: DDD e arquitetura hexagonal pragmática

- **Status:** Aceito
- **Decisão em uma frase:** organizar por domínio e usar portas e adapters para proteger responsabilidades e direção de dependência, sem impor pureza de framework.
- **Quando consultar:** mudanças de packages, camadas, dependências, ownership, APIs de framework no núcleo ou regras ArchUnit.

## Contexto

Projetos derivados precisam proteger regras de negócio de REST, persistência, broker e clientes externos. Uma organização global por tecnologia dilui ownership. Por outro lado, proibir Quarkus e bibliotecas estáveis em todo o núcleo tende a criar interfaces e wrappers que só repetem APIs existentes.

## Decisão

A aplicação usa package-by-domain. Dentro de cada capacidade:

- `domain` concentra regras e linguagem e não depende de `application` nem `adapter`;
- `application` coordena casos de uso, portas e workflows e não depende de adapters;
- `adapter/in` e `adapter/out` contêm contratos, DTOs, mappers e tecnologia de borda;
- capacidades colaboram por contratos explícitos, não por acesso interno direto.

Quarkus, Jakarta, Mutiny, Jackson, OpenTelemetry e Quarkus Flow podem ser usados quando cumprem uma responsabilidade concreta sem inverter dependências. Flow fica na aplicação para orquestração longa ou durável. ArchUnit verifica papéis e direção, não uma blacklist genérica de bibliotecas.

## Consequências

- o núcleo permanece protegido de detalhes externos;
- o ecossistema Quarkus continua disponível sem abstração cerimonial;
- DTOs e mappers podem se repetir entre bordas para preservar contratos independentes;
- exceções compartilhadas e dependências entre capacidades exigem justificativa e checkpoint.

## Alternativas rejeitadas

- **Packages globais por camada técnica:** escondem domínio e ownership.
- **Núcleo sem qualquer framework:** adiciona indireção sem benefício estrutural garantido.
- **Wrapper para toda biblioteca:** aumenta código, testes e manutenção sem mudar a direção de dependência.
- **Microserviço por domínio desde o template:** introduz rede e consistência distribuída sem necessidade real.
