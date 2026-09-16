# Checklist de materialização de projeto derivado

Use uma cópia deste checklist no projeto derivado. Marque somente fatos observados e decisões
humanas explícitas.

## Entradas e autorização

- [ ] A origem é uma commit ou tag aceita do template.
- [ ] Nome do repositório e descrição curta foram informados.
- [ ] `groupId`, `artifactId`, versão inicial e pacote-base foram informados e validados.
- [ ] Goal inicial e capacidades necessárias foram informados.
- [ ] Destino local absoluto e estratégia de branch foram confirmados.
- [ ] Destino GitHub e visibilidade foram informados, ou a ausência de remoto foi declarada.
- [ ] Responsável humano por checkpoints, aceite e encerramento foi identificado.
- [ ] A tecnologia é **Java 25 + Quarkus 3.33 LTS + Maven**; caso contrário, o trabalho parou.

## Cópia limpa

- [ ] O destino é um diretório novo e vazio e não coincide com a origem ou seu diretório pai.
- [ ] A cópia veio somente dos arquivos versionados da revisão aceita.
- [ ] O histórico `.git/` do template não foi transportado.
- [ ] `.codex/.state/`, `target/`, `.quarkus/`, `.env`, logs, IDE e arquivos temporários não foram
  copiados.
- [ ] `sonar/` contém somente o arquivo versionado `sonar/README.md`.
- [ ] Um histórico Git próprio foi iniciado sem sobrescrever conteúdo preexistente.

## Identidade técnica

- [ ] `pom.xml` contém o novo `groupId`, `artifactId` e versão inicial.
- [ ] Java 25, Quarkus 3.33.3.1 LTS e Maven Wrapper foram preservados.
- [ ] `quarkus.application.name` contém o novo `artifactId`.
- [ ] `src/main/java` foi movido para o novo pacote-base.
- [ ] `src/test/java` foi movido para o novo pacote-base.
- [ ] Declarações `package`, imports e constantes `ROOT_PACKAGE` foram atualizadas.
- [ ] A identidade `template.harness` não permanece no POM, código, testes ou configuração.
- [ ] README contém nome, descrição e comandos do produto.
- [ ] A feature neutra continua explicitamente temporária até a prova da primeira feature real.

## Contexto próprio

- [ ] `goals/template-harness/goal.md` foi removido e um goal próprio foi criado do template.
- [ ] `specs/template-harness/spec.md` foi removido e uma spec própria foi criada do template.
- [ ] `tasks/plan.md` e `tasks/todo.md` foram recriados para o produto.
- [ ] `README.md` foi reescrito sem tabela, status ou narrativa dos incrementos do bootstrap.
- [ ] `doc/arquitetura/arquitetura-harness.md` descreve o produto e não a construção do template.
- [ ] `doc/adr/README.md` e os ADRs aplicáveis foram recriados ou adaptados como `Proposto`;
  nenhum estado humano foi herdado por inferência.
- [ ] Todos os marcadores `{{CAMPO}}` foram substituídos, removidos ou registrados como questão
  explícita nos artefatos ativos.
- [ ] Nenhuma evidência, data ou decisão operacional do bootstrap foi atribuída ao produto.
- [ ] O primeiro `GO` de produção continua pendente até revisão humana dos novos artefatos.

## Verificações

- [ ] `.\mvnw.cmd -q verify` passou no projeto derivado.
- [ ] A suíte `Get-ChildItem .\test\powershell\*Test.ps1` passou no projeto derivado.
- [ ] Arquivos Java estão no caminho correspondente ao pacote-base e compilam.
- [ ] Testes ArchUnit usam a nova constante `ROOT_PACKAGE`.
- [ ] A identidade antiga e marcadores pendentes foram auditados nos artefatos ativos.

## Primeiro commit local antes do baseline

- [ ] As verificações passaram e o diff foi revisado antes do commit de materialização.
- [ ] O staging contém somente arquivos próprios, sem segredo, histórico ou artefato proibido.
- [ ] O commit local antes do baseline foi criado no histórico próprio do produto.
- [ ] `git rev-parse --verify HEAD` confirmou uma revisão válida antes da análise Sonar.

## Baseline próprio

- [ ] Nenhum estado ou baseline do template foi copiado de `.codex/.state/`.
- [ ] O `ProjectKey` esperado deriva do POM novo como `groupId:artifactId`.
- [ ] A ausência ou presença de pacote offline foi verificada antes do baseline.
- [ ] Quando havia pacote, o humano escolheu explicitamente a fonte do baseline.
- [ ] `.\validar-checkpoint-sonarqube.ps1 -InitializeBaseline` foi executado na cópia, ou a
  indisponibilidade real foi registrada como `UNVERIFIED`.
- [ ] Qualquer `NON_COMPLIANT` foi apresentado ao humano sem decisão automática.
- [ ] Estado e baseline próprios permanecem ignorados pelo Git.

## Auditoria final

- [ ] O staging não contém segredo, `.env`, chave, certificado, log ou dado sensível.
- [ ] O staging não contém `.codex/.state/`, `target/`, pacote Sonar ou relatório gerado.
- [ ] O staging não contém histórico operacional, goal, spec, plano ou checklist do bootstrap.
- [ ] O diff foi revisado por correção, simplicidade, arquitetura, segurança, desempenho, testes e
  escopo.
- [ ] Riscos e limitações observados foram registrados no goal e no checklist próprios.
- [ ] As evidências foram registradas em commit documental após o baseline ou sua limitação.
- [ ] Nenhum push, remoto, visibilidade, aceite ou encerramento foi inferido.
- [ ] Evidências foram apresentadas ao humano antes de qualquer próximo `GO`.
