# Checklist — Bootstrap do harness Quarkus

## Regra de execução

- Executar somente o próximo item pendente após os checkpoints exigidos.
- Somente o humano marca GO, NO-GO, aceitação excepcional, ADR aceito ou encerramento.
- Mudança de escopo atualiza `specs/template-harness/spec.md`, `tasks/plan.md` e este checklist antes da implementação.

## Planejamento

- [x] Criar repositório privado e branch curta.
- [x] Registrar especificação inicial.
- [x] Obter aprovação humana da especificação e das quatro decisões abertas.
- [x] Registrar goal, definição de pronto, evidências e condições de parada.
- [x] Propor arquitetura consolidada.
- [x] Propor ADR-0001 — Java 25, Quarkus LTS e Maven.
- [x] Propor ADR-0002 — DDD e arquitetura hexagonal pragmática.
- [x] Propor ADR-0003 — Governança do SDLC entre humano e agente.
- [x] Propor ADR-0004 — SonarQube como checkpoint técnico com decisão humana.
- [x] Propor ADR-0005 — Consistência com Outbox aplicacional.
- [x] Elaborar plano e checklist por dependência.
- [x] Revisar arquitetura, ADRs, plano e contratos neutros com o humano.
- [x] Registrar `GO` humano em 2026-08-23 e aceitar ADRs 0001–0005.

## Incremento 1 — Entrada operacional

- [x] Atualizar README com início rápido e navegação.
- [x] Criar `AGENTS.md` com ordem de leitura, limites e checkpoints.
- [x] Criar guia humano de início.
- [x] Verificar links e ausência de duplicação de decisões.
- [x] Obter decisão humana sobre a entrada operacional e registrar `GO` para o Incremento 2 em 2026-08-23.

## Incremento 2 — Goals e specs reutilizáveis

- [x] Criar README e template de goal.
- [x] Criar README e template de especificação.
- [x] Ensaiar preenchimento em cópias descartáveis.
- [x] Registrar evidência: goal com 53 marcadores e spec com 139 marcadores preenchidos somente em
  memória; seções obrigatórias, links locais, diff e auditoria textual aprovados.
- [x] Obter decisão humana e registrar `GO` para o Incremento 3 em 2026-08-23.

## Incremento 3 — Planos e checklists reutilizáveis

- [x] Criar `tasks/README.md`.
- [x] Criar templates de plano e todo.
- [x] Incluir checklist arquitetural e de dupla escrita.
- [x] Ensaiar feature fictícia em memória: plan com 176 marcadores, todo com 76, duas tarefas
  ordenadas e no máximo cinco arquivos por tarefa.

## Checkpoint A — Governança reutilizável

- [x] Confirmar documentação coerente e navegável: 21 arquivos Markdown com links locais válidos.
- [x] Confirmar templates ensaiados em memória: goal 53, spec 139, plan 176 e todo 76 marcadores.
- [x] Auditar ausência de negócio do repositório-fonte, possíveis segredos e arquivos não Markdown.
- [x] Obter `GO` humano para o Incremento 4 em 2026-08-23.

## Incremento 4 — Build Maven

- [x] Verificar pré-condição Sonar: nenhum pacote `sonar/` e nenhum script de baseline/checkpoint;
  situação `UNVERIFIED`, sem aprovação implícita.
- [x] Confirmar fontes oficiais e versões antes do tooling: Quarkus 3.33.3.1 LTS, Java 25,
  Maven 3.9.16 e Maven Wrapper Plugin 3.3.4 `only-script`, com checksum da distribuição.
- [x] Ensaiar scaffold oficial em pasta temporária: `platformVersion` precisa ser explícito para
  impedir que o plugin 3.33.3.1 selecione uma plataforma mais nova.
- [x] Executar verificação RED mínima: confirmar que `pom.xml`, `mvnw`, `mvnw.cmd`,
  `.mvn/wrapper/maven-wrapper.properties` e `.gitignore` ainda não existiam; cinco falhas esperadas.
- [x] Adicionar `pom.xml`, Maven Wrapper e `.gitignore` sem código de aplicação.
- [x] Verificar pelo Wrapper: Maven 3.9.16, Temurin JDK 25.0.3 e `mvnw.cmd -q validate` verdes.
- [x] Registrar limitação: checkpoint Sonar `UNVERIFIED` porque os scripts do harness ainda não
  existem; nenhuma aprovação ou Quality Gate foi inferido.

## Incremento 5 — Núcleo neutro

- [x] Congelar nome, regras e pacote após checkpoint humano em 2026-08-23: `sample`,
  `template.harness.sample`, rejeição de `null`/blank, trim e colapso de whitespace Unicode,
  preservação de conteúdo/capitalização e tamanho por pontos de código Unicode.
- [x] Verificar novamente a pré-condição Sonar antes do primeiro arquivo em `src/`: zero pacotes,
  zero scripts e zero hooks; situação `UNVERIFIED`, sem aprovação implícita.
- [x] RED: sete testes do valor e caso de uso falharam na compilação pelas duas classes ausentes.
- [x] GREEN: implementação mínima nos dois arquivos de produção planejados.
- [x] REFACTOR: revisão confirmou solução mínima, sem CDI, adapter, I/O ou abstração adicional.
- [x] Executar testes focados e suíte: sete testes, zero falhas, zero erros e zero ignorados.
- [x] Revisar correção, simplicidade, arquitetura, segurança, desempenho, testes e escopo.
- [x] Registrar que o checkpoint Sonar permanece `UNVERIFIED` porque os scripts ainda não existem.

## Incremento 6 — HTTP

- [x] Registrar `GO` humano para iniciar o Incremento 6 em 2026-08-24.
- [x] Preparar proposta de path, verbo, status, JSON, validação, OpenAPI, dependências e limites.
- [x] Checkpoint B: aprovação humana explícita do contrato público registrada em 2026-08-24.
- [x] Congelar no plano o contrato aprovado, sem ajustes solicitados pelo humano.
- [x] RED: oito testes HTTP/OpenAPI falharam com endpoint `404` e operação ausente no documento.
- [x] GREEN: DTOs, mapeamento simples no resource e dependências oficiais implementados.
- [x] REFACTOR: confirmar contrato, tratamento genérico de erro e independência da borda.
- [x] Executar teste focal e suíte completa: 15 testes, zero falhas, zero erros e zero ignorados.
- [x] Registrar Sonar `UNVERIFIED`: scripts de baseline/checkpoint ainda não existem.
- [x] Obter revisão humana e `GO` para o Incremento 7 em 2026-08-24.

## Incremento 7 — ArchUnit

- [x] Registrar `GO` humano e confirmar Sonar `UNVERIFIED` por ausência do harness.
- [x] Confirmar ArchUnit 1.5.0 em fonte oficial e destilar somente o padrão estrutural da
  referência.
- [x] RED: seis testes executados; três violações sintéticas falharam como esperado.
- [x] Proteger domain, application e adapters.
- [x] Proteger contratos independentes por borda.
- [x] Confirmar com `@Unremovable` que framework não é proibido genericamente.
- [x] Executar testes focados e suíte completa: 21 testes, zero falhas, zero erros e zero ignorados.
- [x] Revisar correção, simplicidade, arquitetura, segurança, desempenho, testes e escopo.
- [x] Registrar Sonar `UNVERIFIED` porque os scripts do harness ainda não existem.
- [x] Obter revisão humana do Incremento 7 e `GO` em 2026-08-24 para preparar a proposta do
  Incremento 8, sem substituir seu checkpoint prévio de comportamento observável.

## Incremento 8 — Observabilidade

- [x] Confirmar fontes oficiais de logging JSON, OpenTelemetry, Micrometer/Prometheus e SmallRye
  Health para Quarkus 3.33.
- [x] Destilar da referência somente JSON/MDC, correlação OTel, exporter de teste em memória e
  health; excluir log em arquivo, exporter externo, campos e nomes de negócio.
- [x] Definir perguntas operacionais, contrato exato, dependências, riscos e duas tasks com no
  máximo quatro arquivos cada.
- [x] Checkpoint C: aprovação humana explícita registrada em 2026-08-24 antes de qualquer
  alteração em POM, configuração, teste RED ou código.
- [x] Ajuste do Checkpoint C aprovado em 2026-08-24 após evidência do runtime: manter correlação
  OpenTelemetry no objeto `mdc` aninhado e não criar formatter customizado.
- [x] Reconfirmar ausência do harness Sonar; registrar `UNVERIFIED` sem improvisar baseline.
- [x] Task 8A — RED: exigir JSON/MDC, exporter de teste em memória, métricas e health locais.
- [x] Task 8A — GREEN: adicionar dependências, configuração e infraestrutura mínima.
- [x] Task 8B — RED: exigir log correlacionado, span interno, timer/histogram e ausência de payload.
- [x] Task 8B — GREEN: instrumentar o bean CDI e preservar o contrato HTTP.
- [x] REFACTOR: confirmar apenas `success|invalid`, duas combinações próprias de tags e nenhum
  check sempre-UP.
- [x] Executar testes focados, inspecionar logs JSON e executar `./mvnw.cmd -q verify`: 26 testes,
  zero falhas, zero erros e zero ignorados.
- [x] Revisar correção, simplicidade, arquitetura, segurança, desempenho, testes e escopo.
- [x] Preparar diff e evidências do Incremento 8 para revisão humana.
- [x] Obter revisão humana do Incremento 8 e registrar `GO` para o Incremento 9 em 2026-08-27.

## Incremento 9 — Cobertura e Sonar build

- [x] Registrar `GO` humano para iniciar somente o Incremento 9 em 2026-08-27.
- [x] Destilar a configuração JaCoCo da referência sem copiar dependências, versões ou identidade
  de negócio.
- [x] RED: teste da configuração esperada falhou pela ausência de `quarkus-jacoco`.
- [x] Configurar JaCoCo XML e propriedades Sonar justificadas.
- [x] Verificar política 85%/5% e exclusões: 61/62 linhas (98,4%), nenhuma exclusão; duplicação
  permanece `UNVERIFIED` sem análise Sonar.
- [x] Executar `./mvnw.cmd -q verify`: 26 testes, zero falhas, zero erros e zero ignorados.
- [x] Executar o GREEN PowerShell da configuração.
- [x] Revisar correção, simplicidade, arquitetura, segurança, desempenho, testes e escopo.
- [x] Preparar diff e evidências do Incremento 9 para revisão humana.
- [x] Obter revisão humana do Incremento 9 e registrar `GO` para o Incremento 10 em 2026-08-27.

## Incremento 10 — Sessão e análise Sonar

- [x] Registrar `GO` humano para iniciar somente o Incremento 10 em 2026-08-27.
- [x] Destilar os scripts da referência com identidade neutra e Maven Wrapper do template.
- [x] RED: testes falharam pela ausência do launcher e do analisador.
- [x] Destilar script seguro de início de sessão com prompt protegido, escopo de processo e limpeza.
- [x] Destilar script de análise sem acoplamento de negócio e com scanner fixado.
- [x] Verificar token/servidor ausentes, argumentos exatos, URL/nomes seguros, falha Maven e
  metadado obsoleto usando somente fixtures sintéticas.
- [x] Verificar que token não é persistido, passado como argumento nem exibido.
- [x] Executar três testes PowerShell e `./mvnw.cmd -q verify`: 26 testes Maven, zero falhas, zero
  erros e zero ignorados.
- [x] Auditar segredo e identidade do repositório-fonte; nenhuma ocorrência versionada.
- [x] Registrar Sonar `UNVERIFIED` por ausência de análise autenticada, baseline e checkpoint.
- [x] Preparar diff e evidências do Incremento 10 para revisão humana.

## Incremento 11 — Baseline e decisão

- [ ] Task 11A — RED: testes da API, métricas, severidades e comparação 85%/5%.
- [ ] Task 11A — implementar o módulo de qualidade e validar paginação/Compute Engine.
- [ ] Task 11B — RED: testes local, local+offline, offline-only, `NON_COMPLIANT` e três decisões.
- [ ] Task 11B — implementar o script de baseline/checkpoint e estado sem credencial.
- [ ] Verificar fingerprint e estado UNVERIFIED.

## Incremento 12 — Hooks

- [ ] Destilar hooks da referência removendo defaults, estado e vocabulário do produto-fonte.
- [ ] RED: eventos session-start e stop.
- [ ] RED: isenção Markdown-only.
- [ ] Implementar hooks e configuração Codex.
- [ ] Verificar lembrete sem bloqueio ou decisão automática.

## Incremento 13 — Evidência offline

- [ ] RED: exportação sem segredo e leitura adversarial.
- [ ] Implementar exportação, documentação e entrada local `sonar/` com somente o README
  versionado.
- [ ] Verificar imutabilidade e instruções ignoradas.
- [ ] Auditar ausência de `.codex/.state`, pacote, log, token e identidade da referência no diff.
- [ ] Checkpoint D: apresentar JaCoCo, scripts, hooks, testes e baseline do próprio template ao
  humano.

## Incremento 14 — Materialização

- [ ] Criar guia e checklist de materialização.
- [ ] Ensaiar em diretório temporário com identidade diferente.
- [ ] Criar goal e baseline próprios na cópia.
- [ ] Verificar ausência de placeholders, histórico e artefatos proibidos.

## Incremento 15 — Entrega

- [ ] Executar Maven verify e suíte PowerShell.
- [ ] Executar checkpoint Sonar aplicável ou registrar UNVERIFIED.
- [ ] Auditar termos de negócio, segredos, estados e builds.
- [ ] Revisar correção, simplicidade, arquitetura, segurança, desempenho, testes e escopo.
- [ ] Atualizar goal e checklist com evidências.
- [ ] Parar e solicitar aceite/encerramento humanos.

## Próximo item autorizado

O Incremento 10 está concluído tecnicamente e aguarda revisão humana. Não há próximo item
executável autorizado; os Incrementos 11–13 permanecem bloqueados.
