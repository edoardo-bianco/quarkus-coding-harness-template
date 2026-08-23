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

- [ ] Congelar nome, regras e pacote após checkpoint humano.
- [ ] RED: testes do valor e caso de uso.
- [ ] GREEN: implementação mínima.
- [ ] REFACTOR: simplificar sem mudar comportamento.
- [ ] Executar testes focados e suíte.

## Incremento 6 — HTTP

- [ ] Congelar path, verbo, status, JSON, validação e OpenAPI.
- [ ] RED: teste HTTP de sucesso e falha.
- [ ] GREEN: DTOs, mapper simples e resource.
- [ ] REFACTOR e verificar independência da borda.
- [ ] Checkpoint B: obter aprovação humana do contrato público.

## Incremento 7 — ArchUnit

- [ ] RED: provar que violações-exemplo seriam detectadas.
- [ ] Proteger domain, application e adapters.
- [ ] Proteger contratos independentes por borda.
- [ ] Confirmar que framework não é proibido genericamente.

## Incremento 8 — Observabilidade

- [ ] Confirmar fontes oficiais de logging, OTel, Micrometer e health.
- [ ] RED: testes de contrato observável.
- [ ] GREEN: log, span, métrica e health mínimos.
- [ ] Verificar baixa cardinalidade e ausência de conteúdo sensível.
- [ ] Checkpoint C: obter aprovação humana de arquitetura, segurança e sinais.

## Incremento 9 — Cobertura e Sonar build

- [ ] RED: teste da configuração esperada.
- [ ] Configurar JaCoCo XML e propriedades Sonar justificadas.
- [ ] Verificar política 85%/5% e exclusões.
- [ ] Executar `./mvnw -q verify`.

## Incremento 10 — Sessão e análise Sonar

- [ ] RED: testes de token, ausência de servidor e argumentos.
- [ ] Destilar script seguro de início de sessão.
- [ ] Destilar script de análise sem acoplamento de negócio.
- [ ] Verificar que token não é persistido nem exibido.

## Incremento 11 — Baseline e decisão

- [ ] RED: testes local, local+offline e offline-only.
- [ ] RED: testes NON_COMPLIANT e três decisões humanas.
- [ ] Implementar módulo e script de checkpoint.
- [ ] Verificar fingerprint e estado UNVERIFIED.

## Incremento 12 — Hooks

- [ ] RED: eventos session-start e stop.
- [ ] RED: isenção Markdown-only.
- [ ] Implementar hooks e configuração Codex.
- [ ] Verificar lembrete sem bloqueio ou decisão automática.

## Incremento 13 — Evidência offline

- [ ] RED: exportação sem segredo e leitura adversarial.
- [ ] Implementar exportação e documentação offline.
- [ ] Verificar imutabilidade e instruções ignoradas.
- [ ] Checkpoint D: apresentar harness Sonar ao humano.

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

Nenhum novo item de implementação está autorizado. O Incremento 4 foi concluído tecnicamente e o
agente deve parar para revisão humana. Somente um `GO` explícito pode autorizar o Incremento 5.
Antes desse GO, não criar arquivos em `src/` nem implementar a feature neutra.
