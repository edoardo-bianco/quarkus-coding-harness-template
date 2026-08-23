# Especificação — Template de harness de codificação Quarkus

## Metadados

- Estado: `Aprovado`
- Fase do SDLC: `SPECIFY`
- Responsável pela aprovação: humano
- Data de elaboração: 2026-08-22
- Versão da especificação: 0.2

## Aprovação humana

- Decisão: `APROVADO`
- Data: 2026-08-22
- Registro: aprovação explícita do usuário na conversa de criação do repositório-template.
- Efeito: autoriza desenho arquitetural, ADRs propostos, plano e checklist; não autoriza ainda a implementação do harness.

## Problema

O início de um novo projeto exige repetir decisões sobre arquitetura, planejamento, orientação de agentes, qualidade, observabilidade e aprovação humana. Quando essas decisões ficam apenas na memória ou misturadas à lógica de negócio de um projeto anterior, o novo desenvolvimento começa de forma inconsistente e o agente não possui critérios claros para avançar, parar ou solicitar uma decisão.

## Objetivo

Disponibilizar um repositório-template interno que permita a um humano solicitar a criação de um novo projeto Java 25, Quarkus LTS e Maven com um harness de codificação pronto para conduzir o SDLC: objetivo do projeto, desenho da solução, ADRs, planejamento por feature, implementação incremental, testes, verificações arquiteturais, observabilidade, SonarQube, evidências e decisões humanas.

O template deve conter uma feature neutra executável que prove o funcionamento do conjunto sem introduzir conceitos de um domínio de negócio real.

## Usuários e fluxo principal

### Usuário humano

1. Cria um novo repositório a partir deste template.
2. Informa ao agente, no mínimo, nome do projeto, identidade Maven, pacote-base e objetivo/épico inicial.
3. Revisa os artefatos de objetivo, solução, ADRs, plano e checklist.
4. Registra explicitamente `GO`, `NO-GO`, aceitação excepcional ou encerramento quando solicitado.

### Agente de codificação

1. Lê as instruções de entrada e o estado atual do repositório.
2. Valida os dados mínimos de inicialização e não inventa os ausentes.
3. Materializa a identidade do novo projeto sem carregar histórico do template como se fosse histórico do produto.
4. Registra objetivo/épico, desenho da solução e decisões arquiteturais aplicáveis.
5. Planeja a primeira feature e para para obter `GO` humano antes de alterar código de produção.
6. Implementa somente o próximo incremento aprovado, produz evidências e respeita checkpoints adicionais.
7. Ao satisfazer tecnicamente a definição de pronto, para e solicita verificação e encerramento humanos.

## Escopo da versão inicial

### Base tecnológica

- JDK 25.
- Quarkus 3.33.3.1, pertencente à linha 3.33 LTS.
- Maven 3.9 ou superior, com Maven Wrapper versionado.
- Estrutura package-by-domain e arquitetura DDD hexagonal pragmática.
- Testes unitários, de componente/integração, de contrato e de arquitetura conforme o risco de cada mudança.
- Cobertura e análise estática integradas ao Maven e ao SonarQube.
- Observabilidade com logs estruturados, métricas, traces e health checks, demonstrada pela feature neutra.

### Harness de trabalho

- `AGENTS.md` como mapa operacional, sem duplicar a documentação permanente.
- Guia humano de início e de operação do fluxo.
- Artefato persistente de objetivo/épico com definição de pronto, evidências e condições de parada.
- Especificações anteriores ao código para projetos, features e mudanças significativas.
- Arquitetura consolidada e ADRs com estados `Proposto`, `Aceito` e `Substituído`.
- Plano e checklist por feature, com intenção, escopo, fora de escopo, critérios de aceitação, riscos, dependências, arquivos prováveis, verificações e checkpoints.
- Ciclo RED → GREEN → REFACTOR para comportamento.
- Revisão final de correção, simplicidade, arquitetura, segurança, desempenho, testes e escopo.
- Pontos explícitos de extensão para guardrails e evals futuros, sem implementações especulativas.

### Aprovações humanas

- `GO` obrigatório antes da primeira alteração de produção de cada feature.
- Checkpoint adicional antes de mudar contrato público/externo, arquitetura, segurança ou comportamento observável.
- Decisão humana para não conformidades do SonarQube: `Reprovar`, `AceitarExcepcionalmente` ou `ContinuarAjustes`.
- Encerramento do objetivo/épico somente pelo humano.
- O agente nunca infere aprovação, exceção ou encerramento.

### Qualidade e SonarQube

- Token SonarQube somente na memória do processo; nunca em chat, arquivo, argumento, log, relatório ou commit.
- Mudanças exclusivamente documentais dispensam baseline e checkpoint Sonar.
- Quando existirem pacotes offline, a fonte do baseline será escolhida pelo humano: servidor local, servidor local combinado com pacote específico ou pacote específico em modo offline.
- Baseline exclusivamente offline permanece `UNVERIFIED` e não comprova Quality Gate, cobertura, duplicação ou estado atual do servidor.
- Checkpoint por incremento executável coerente, não por edição isolada.
- Política inicial: nenhuma issue nova; nenhuma issue `HIGH`, `BLOCKER` ou `CRITICAL`; cobertura mínima de 85%; duplicação máxima de 5%.
- Resultado técnico `NON_COMPLIANT` exige decisão humana e não significa reprovação automática.
- Hooks orientam e lembram pendências, mas não falsificam nem substituem decisões humanas.
- Um projeto gerado cria seu próprio baseline; não herda estados, pacotes ou snapshots do template.

### Arquitetura pragmática

- O núcleo de domínio concentra regras e linguagem do negócio e não depende de adapters, clientes externos ou DTOs de borda.
- Casos de uso coordenam o domínio e dependem de portas explícitas quando há fronteira relevante.
- Adapters implementam REST, persistência, mensageria e integrações externas.
- DTOs e mappers permanecem em suas bordas; não existem atalhos entre bordas nem dependência direta entre domínios.
- Quarkus, Jakarta, Mutiny, Jackson, OpenTelemetry, Quarkus Flow e bibliotecas estáveis podem ser usados quando simplificam uma necessidade concreta sem inverter a direção de dependência.
- Não serão criados wrappers apenas para esconder bibliotecas estáveis nem abstrações para necessidades futuras.
- Quarkus Flow pertence à camada de aplicação e será usado apenas para orquestrações duráveis ou longas, inclusive interação humana, e não para chamadas triviais.

### Mensageria e assincronicidade

- Mensageria é adapter; conceitos do broker não vazam para o domínio.
- Contratos internos tornam assincronicidade, falhas e semântica de entrega explícitas.
- `Uni` pode ser usado pragmaticamente em portas e casos de uso; `Multi` somente representa fluxo real.
- Eventos de domínio e eventos de integração são conceitos distintos e possuem mapeamento explícito.
- Consumidores são idempotentes e confirmam a mensagem somente após tornar os efeitos exigidos duráveis.
- Concorrência, backpressure, ordenação, retry, quarentena e correlação observável são decisões obrigatórias por fluxo.

### Dupla escrita entre banco e broker

- É proibido tratar gravação no banco seguida de publicação no broker como uma operação atômica por sequência direta.
- Quando a mesma decisão de negócio exigir banco e mensagem, o padrão inicial será Transactional Outbox gerenciado pela aplicação, por polling, sem Debezium, XA ou transação distribuída.
- Agregado e registro imutável de outbox são persistidos na mesma transação local.
- Um relay Quarkus adquire lotes com lease, publica fora de transações longas e marca o registro como publicado somente após confirmação do broker.
- Falhas usam retry com backoff e registros problemáticos seguem para quarentena.
- A entrega é pelo menos uma vez; cada evento possui `event_id` imutável e consumidores usam inbox ou chave única para idempotência.
- O plano de qualquer fluxo desse tipo deve definir ack, retry, quarentena, ordenação, concorrência, schema, retenção, dados sensíveis e observabilidade.
- A implementação deve ser provada contra rollback, broker indisponível, retry, queda após publicação, relays concorrentes, duplicidade, ordenação e quarentena.
- Métricas mínimas: pendentes, idade do mais antigo, em processamento, publicados, retries, quarentena, duração e última publicação bem-sucedida.
- O template registra o padrão e seus testes esperados, mas não adiciona banco ou broker antes de uma necessidade aprovada.

## Feature neutra de prova

A implementação deverá incluir um caso de uso sem significado de negócio específico, acessível por uma borda HTTP, que:

- atravesse adapter de entrada, aplicação e núcleo;
- aplique validação e produza resposta determinística;
- tenha teste unitário do núcleo, teste do caso de uso, teste HTTP e teste arquitetural;
- emita log estruturado, span, métrica e exponha health check;
- gere cobertura para o pipeline e possa ser removido ou renomeado ao materializar um produto;
- não exija banco, broker, serviço externo ou credencial.

O nome e o contrato exatos serão decididos no desenho da solução e submetidos a checkpoint humano antes da implementação.

### Contrato aprovado da primeira fatia

Em 2026-08-23, o humano aprovou para o Incremento 5:

- capacidade e pacote-base: `sample` sob `template.harness.sample`;
- objeto de valor: `NormalizedText`; caso de uso: `NormalizeTextUseCase`;
- entrada `null`, vazia ou composta apenas por whitespace é rejeitada com `IllegalArgumentException`;
- whitespace Unicode nas extremidades é removido e sequências internas são reduzidas a um espaço;
- letras, acentos, capitalização e demais conteúdos não-whitespace são preservados;
- o tamanho corresponde aos pontos de código Unicode do valor normalizado;
- o caso de uso recebe texto e devolve o objeto de valor, sem I/O, persistência ou adapter.

## Inicialização de um projeto derivado

O template deverá fornecer um procedimento reproduzível que solicite:

- nome do repositório e descrição;
- `groupId`, `artifactId`, versão e pacote-base;
- objetivo/épico inicial;
- capacidades iniciais realmente necessárias, como REST, persistência, mensageria ou workflow;
- destino local e destino GitHub;
- visibilidade e estratégia inicial de branch.

Se a tecnologia solicitada não for Java 25 + Quarkus LTS + Maven, o agente deve parar e informar que a variante não é suportada por esta versão do template.

## Fora de escopo

- Template independente de tecnologia.
- Domínio de negócio ou integração específica do repositório usado como fonte de aprendizado.
- Banco, broker, Debezium, XA, Kubernetes ou cloud adicionados preventivamente.
- Pipeline CI/CD, `CODEOWNERS`, regras de branch ou plataforma de deploy sem requisitos organizacionais aprovados.
- Guardrails e evals futuros ainda não definidos.
- Cópia de tokens, `.env`, estados de hooks, relatórios Sonar, snapshots, artefatos de build, arquivos de IDE ou documentação derivada.

## Critérios de aceitação do template implementado

1. Um humano sem contexto do projeto de origem encontra no README o ponto de entrada e consegue explicar o fluxo de trabalho.
2. O agente não inicia código de produto sem objetivo, especificação, plano, checklist e `GO` humano registrados.
3. A feature neutra compila e executa com JDK 25 e Quarkus 3.33.3.1 LTS por meio do Maven Wrapper.
4. Testes unitários, HTTP, arquiteturais e de observabilidade passam localmente.
5. A análise de cobertura produz relatório consumível pelo SonarQube.
6. Hooks e scripts de Sonar têm testes automatizados e preservam segredo, baseline, checkpoint e decisão humana.
7. Mudança somente documental não exige Sonar.
8. Regras ArchUnit protegem a direção de dependência sem proibir uso pragmático do framework.
9. O padrão de outbox está registrado como ADR proposto/aceito pelo humano e aparece nos templates de planejamento, sem infraestrutura ativada preventivamente.
10. O procedimento de materialização cria identidade própria e não transporta histórico operacional do template.
11. O repositório de origem permanece inalterado.
12. Nenhuma decisão de negócio do projeto de origem aparece como convenção genérica.

## Evidências esperadas

- Saída de `mvn verify` usando JDK 25.
- Relatórios de testes e cobertura.
- Resultado dos testes dos scripts e hooks do SonarQube.
- Resultado das regras ArchUnit.
- Demonstração local da feature neutra e dos sinais de observabilidade.
- Auditoria do conteúdo proibido e busca por nomes/conceitos do projeto de origem.
- Registro dos checkpoints e decisões humanas nos artefatos correspondentes.

## Riscos

- Copiar acidentalmente lógica ou linguagem de negócio da fonte.
- Transformar preferências locais em regras universais sem evidência.
- Excesso de abstração para suportar tecnologias que não fazem parte desta versão.
- Hooks darem falsa impressão de bloqueio ou aprovação automática.
- Feature neutra virar dependência permanente de produtos derivados.
- Fixar versões sem política explícita de atualização e suporte.
- Criar scaffolding de banco ou mensageria antes de existir um caso real.

## Decisões fechadas na revisão humana

1. Não existe namespace Maven fixo: `groupId`, `artifactId` e pacote-base são entradas obrigatórias ao materializar cada projeto.
2. A feature neutra permanece até a primeira feature real comprovar o harness; sua remoção será uma tarefa planejada e verificável.
3. A primeira versão inclui execução local e SonarQube local; CI/CD permanece backlog explícito até existirem requisitos organizacionais.
4. Quarkus permanece fixado em `3.33.3.1`; atualizações dentro da linha 3.33 LTS são manuais, planejadas e aprovadas por humano.

## Fontes técnicas oficiais

- [Quarkus Releases](https://quarkus.io/releases/): identifica 3.33 como LTS recomendada e 3.33.3.1 como patch comunitário mais recente na data desta especificação.
- [Quarkus 3.33 LTS](https://quarkus.io/blog/quarkus-3-33-released/): descreve a linha LTS e sua base no Quarkus 3.32.
- [Quarkus 3.31](https://quarkus.io/blog/quarkus-3-31-released/): registra suporte completo ao Java 25 e Maven 3.9 como requisito.
- [Creating Your First Application — Quarkus 3.33](https://quarkus.io/version/3.33/guides/getting-started): referência oficial para bootstrap Maven.
- [Testing Your Application — Quarkus 3.33](https://quarkus.io/version/3.33/guides/getting-started-testing): referência oficial para testes JVM e de integração.

## Condição para avançar

A aprovação desta especificação foi registrada. Serão produzidos, nesta ordem:

1. desenho arquitetural detalhado;
2. ADRs em estado `Proposto`;
3. plano de implementação;
4. checklist executável;
5. novo checkpoint humano para aceitar ou rejeitar arquitetura, ADRs e plano;
6. implementação incremental do harness e da feature neutra.
