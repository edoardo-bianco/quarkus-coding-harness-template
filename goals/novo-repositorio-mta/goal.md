# Goal — Construir um template independente para migração conservadora JBoss EAP

> Continuidade transferida para C:\desenvolvimento\repositorio\jboss-eap-copilot-harness-template,
> branch chore/bootstrap-jboss-harness. Este documento preserva a referência da origem;
> os artefatos de construção ativos pertencem ao novo checkout.

## Identificação

- ID: `novo-repositorio-mta`; caminho preservado desde o rascunho inicial.
- Estado: `EM_PREPARACAO_NO_DESTINO`; GO H01A recebido e fundação documental criada; aceite final pendente.
- Responsável e autoridade de aceite: usuário solicitante.
- Criado em: 2026-09-21. Última revisão: 2026-09-21.
- Nome do novo produto: `jboss-eap-copilot-harness-template`.
- Requisitos de origem: [prompt fornecido pelo usuário](origem/prompt-codex-criar-novo-repositorio-template-jboss-eap-main-arquitetura-preserv.md).
- Referência para a migração posterior: [guia MTA, VS Code e EAP](../../doc/guias/guia-completo-mta-vscode-jboss-eap70-eap74-copilot-java8.md).
- Inventário dos documentos: [origem/README.md](origem/README.md).
- [Spec proposta](../../specs/novo-repositorio-mta/spec.md),
  [diagnóstico e plano H00–H07](../../tasks/features/novo-repositorio-mta/plan.md) e
  [checklist](../../tasks/features/novo-repositorio-mta/todo.md): `EM_REVISAO`.
  Arquitetura/ADRs próprios serão propostos no destino; os históricos dos goals anteriores
  não são o plano deste novo produto.

## Problema e valor esperado

O harness Quarkus possui controles reutilizáveis, mas suas premissas de runtime, PowerShell,
layout, build, arquitetura e uso de Codex não atendem diretamente ao trabalho com aplicações
Java EE 7/JBoss EAP existentes. Copiar o template integralmente imporia escolhas incompatíveis
com uma migração conservadora e misturaria históricos, identidade e evidências.

O valor esperado é disponibilizar um harness próprio, funcional e verificável, pelo qual
Copilot e DevSquad possam conduzir migrações com evidências, intervenções mínimas e decisão
humana, preservando a organização e o comportamento das aplicações existentes.

## Objetivo

Construir, após diagnóstico, planejamento e GOs por incremento, o repositório-template local
independente `jboss-eap-copilot-harness-template`. Ele deve adaptar os controles reutilizáveis
do harness Quarkus para Windows PowerShell 5.1, VS Code/Copilot, DevSquad, MTA local e SonarQube
corporativo, apoiando a migração EAP 7.0 → EAP 7.4 com Java 8 e arquitetura preservada.

O produto entregue é um harness de desenvolvimento, não uma aplicação JBoss de negócio.
Produzir somente documentos não conclui sua preparação. O guia de migração será utilizado
na etapa posterior à preparação e validação do ambiente/harness, em uma aplicação identificada
com plano e autorização próprios.

## Branch de trabalho, origem e destinos

| Papel | Definição |
| --- | --- |
| Trabalho documental atual com Codex | `chore/preparacao-jboss-harness`, no repositório Quarkus; diagnóstico e planejamento do goal |
| Máquina de trabalho do usuário | Acompanha `main`; ambiente distinto e ainda não inspecionado nesta sessão |
| Fonte exclusiva dos componentes reutilizados | Snapshot de `refs/heads/main` do repositório Quarkus; não é o working tree desta branch documental |
| SHA fixado de `main` no H00 | `22512766897bca4146e940cdca39ab9089f545f4` |
| Referência remota armazenada localmente | `origin/main` aponta para o mesmo SHA após fetch do H00 |
| Origem local | `C:\desenvolvimento\repositorio\quarkus-coding-harness-template` |
| Destino local definido | `C:\desenvolvimento\repositorio\jboss-eap-copilot-harness-template` |
| Git do novo produto | Independente, sem histórico, remotes, tags, branches ou estado herdados |
| Branches no destino | `main` com fundação documental e `chore/bootstrap-jboss-harness` para continuidade; H01B e executáveis aguardam GO |
| GitHub proposto | `edoardo-bianco/jboss-eap-copilot-harness-template`, privado e Template repository; publicação depende de autorização externa específica |

Trabalhar nesta branch não muda a fonte técnica `main` definida no prompt. O prompt e o guia
fornecidos pelo usuário são entradas de requisitos/referência deste trabalho. Agora integram
o snapshot consolidado, mas não são classificados como controles executáveis reutilizados.

O H00 conferiu a correspondência local/remota e registrou o inventário no plano. A referência
anterior `094ebab9fa776e5b737b830f599b0cc67529f93a` avançou após integração do PR #2;
`docs/goal-origem-mta` foi integrada e removida. O novo SHA deverá constar no futuro manifesto
canônico `doc/origem-harness.md`. Avanços posteriores exigem registro explícito, sem misturar snapshots.

A autorização documental atual permite estas revisões na branch de trabalho. Durante a
materialização, a origem técnica permanece somente leitura: adaptações executáveis acontecem
exclusivamente no novo destino, sem converter, renomear ou refatorar o template Quarkus.

## Usuários e responsabilidades

- Codex: diagnosticar, planejar e preparar o novo harness nas fatias autorizadas.
- GitHub Copilot no VS Code + DevSquad: fluxo operacional principal após a preparação.
- Copilot CLI: alternativa condicionada aos requisitos reais do cliente e às ferramentas autorizadas.
- Equipe da aplicação: confirmar arquitetura AS-IS, ambiente, integrações e evidências da migração.
- Usuário solicitante: aprovar GOs, desvios, publicação, aceite e encerramento.

Codex não será dependência obrigatória da operação diária do novo harness.

## Escopo e restrições já definidos

1. Reutilizar seletivamente controles do SHA de `main`, com matriz origem → destino, motivo,
   adaptação e teste. Criar identidade, governança, Git e baseline próprios.
2. Preservar Java 8, Java EE 7/`javax.*`, EAR/WAR, arquitetura, contratos, schema e comportamento
   da aplicação e a compatibilidade do código compartilhado com o EAP 7.0 ativo.
3. Preservar módulos, pacotes, responsabilidades, EJB/CDI, persistência, limites transacionais,
   JTA/XA quando existentes, segurança, SSO e integrações. Não impor DDD hexagonal, Outbox,
   Quarkus Flow, testes de camadas Quarkus ou a proibição de XA à aplicação Java EE.
4. Manter uma política canônica de preservação arquitetural no novo harness e inventário AS-IS
   por aplicação. Cada fatia deve registrar `PRESERVADO`, `NÃO VERIFICADO` ou
   `DESVIO ARQUITETURAL PROPOSTO` com evidências; redesenho exige mudança explícita de escopo.
5. Entregar scripts e testes em Windows PowerShell 5.1 real (`powershell.exe`), com argumentos,
   códigos de saída, timeouts e restauração de ambiente corretos. Sem PowerShell 7, Docker,
   WSL, administrador ou alteração global de ExecutionPolicy como requisito do fluxo principal.
6. Separar JDK 8 da aplicação/EAPs, JDK do MTA, JDK do scanner Sonar e runtime da extensão Java.
   Java 25 para MTA é possibilidade sujeita à compatibilidade; não é versão imposta à aplicação.
7. Preservar Maven/Wrapper, perfis e toolchains da aplicação. Usar configuração local única,
   ignorada, e exemplo versionado sem segredos; distinguir raiz do harness e raiz Maven do produto.
8. Preparar workspace e tarefas VS Code com scripts comuns reutilizáveis no CLI, operação
   local dos dois EAPs e artefatos identificados por hash. Usar laboratório isolado, um servidor
   por vez; standalone não comprova homologação de domain/cluster.
9. Inventariar, atualizar após GO e especializar DevSquad a partir da fonte oficial, preservando
   customizações. Verificar descoberta e execução por cliente e mapear planos para arquivos
   canônicos, sem manter `PLAN.md`/`TODO.md` concorrentes com `tasks/features/.../plan.md` e `todo.md`.
10. Adaptar sessão segura e controles Sonar existentes para servidor corporativo: token apenas
    no processo, entrada protegida, herança real até a ferramenta do agente e evidências próprias.
    Separar build/testes/cobertura com JDK 8 da análise com scanner/JDK compatíveis, preservando
    bytecodes/relatórios e sem recompilar sob outro JDK durante a análise.
11. Preservar política do harness e Quality Gate corporativo como avaliações distintas,
    baseline próprio, estados técnicos, associação da análise e decisão humana sobre
    `NON_COMPLIANT`. Ausência de acesso ou relatório permanece `UNVERIFIED`.
12. Preparar MTA por ZIP/local, inventário de aplicação/bibliotecas internas e compartilhadas,
    evidências Maven/artefato/runtime, triagem e matrizes de compatibilidade. Confirmar versões,
    regras e opções reais; não inventar target nem prometer cobertura completa da migração.
13. Documentar adoção seletiva e não destrutiva, sem sobrescrever POM, instruções ou configurações,
    e fornecer um guia canônico em português para o fluxo posterior de migração.
14. Tratar a política/fingerprint de instruções operacionais e prompts no novo harness
    explicitamente; sua extensão `.md` não deve ocultar alterações de comportamento do agente.
    Esta revisão de goal/guia é documental e não instala essas instruções operacionais.

## Fora de escopo

- Converter o repositório Quarkus ou compartilhar seu histórico Git com o novo template.
- Criar sample fictício, importar POM/BOM Quarkus, copiar aceites, baseline ou resultados verdes.
- Migrar uma aplicação corporativa nesta preparação ou exigir acesso imediato a uma aplicação
  para construir modelos/controles; fatos ainda não observados ficam `A CONFIRMAR`.
- Modernização para EAP 8, Quarkus/Spring Boot, Java novo na aplicação, Hibernate 6 ou `jakarta.*`;
  atualizações em lote, redesenho arquitetural, de persistência ou SSO.
- Distribuir JBoss/JDKs, drivers proprietários, bibliotecas corporativas, credenciais ou relatórios reais.
- Publicar remoto, configurar `origin`, visibilidade ou Template repository sem autorização externa.
- Acessar produção, promover releases ou substituir decisões humanas por resultado de ferramenta.

## Sequência e checkpoints

A sequência requerida no prompt orienta o futuro plano; não constitui GO cumulativo:

| Etapa | Resultado e checkpoint |
| --- | --- |
| Consolidação anterior | PR #2 integrado à `main`; branch documental anterior removida |
| H00 | Diagnóstico somente leitura do snapshot realizado; spec/plano/checklist preparados nesta branch documental para revisão, sem materialização |
| H01 | Após GO local: Git independente, manifesto, governança e configuração de exemplo |
| H02 | Scripts/testes PS5.1 e separação das toolchains |
| H03 | Sonar corporativo, sessão segura e regressão dos controles |
| H04 | Workspace, build Java 8, operação dos EAPs e evidências |
| H05 | DevSquad, instruções/skills e validação IDE/CLI conforme requisitos |
| H06 | MTA, modelos de inventário/arquitetura, adoção seletiva e ensaio integrado do harness |
| H07 | Após aceite local e autorização externa: publicação e reutilização como template GitHub |
| Migração posterior | Usar o guia em aplicação identificada, com goal/spec/plan/todo e GOs próprios |

O plano detalhado deve declarar arquivos, verificações, dependências e critérios por incremento.
Construção do harness e migração da aplicação possuem planos separados e uma única fonte
editável por plano. O prompt fornecido não autoriza executar todos os incrementos.

## Critérios de sucesso e definição de pronto

A preparação local estará tecnicamente pronta quando houver evidência de que:

- [ ] O novo Git e a identidade são independentes; origem e arquivos reutilizados estão rastreados por SHA.
- [ ] Goal/spec/arquitetura, decisões e plan/todo próprios foram revisados nos checkpoints aplicáveis.
- [ ] Scripts e regressões dos controles passaram no Windows PowerShell 5.1 real.
- [ ] JDKs e processos estão separados e as tarefas respeitam Maven/Java 8 da aplicação.
- [ ] Workspace, configuração de exemplo e operações locais autorizadas possuem evidências reais.
- [ ] Sessão, build/análise separados, baseline e decisões Sonar foram verificados; limitações reais
  ou indisponibilidades foram registradas e submetidas ao humano, sem aprovação inferida.
- [ ] Copilot/DevSquad carregam e respeitam os controles no VS Code; CLI foi validado ou permanece
  explicitamente condicionado a pré-requisito/decisão, sem reduzir o fluxo principal.
- [ ] Modelos cobrem AS-IS, bibliotecas, MTA, compatibilidade, testes e preservação arquitetural por fatia.
- [ ] Adoção seletiva e repetida preserva configurações, customizações e evidências da aplicação.
- [ ] Guia, evidências, limitações e pendências de validação corporativa estão coerentes com o implementado.
- [ ] Revisão final demonstra escopo, preservação da origem e ausência de segredos/artefatos indevidos.

Documentação, mocks, análise sintática, MTA ou Sonar isoladamente não comprovam ambiente,
compatibilidade ou aceite. Publicação H07 e migração posterior possuem evidências e autorizações
próprias; não são resultados implícitos da preparação local. O agente não aceita nem encerra o goal.

## Evidências e pendências atuais

| Item | Evidência/estado nesta revisão |
| --- | --- |
| Objetivo real | Prompt recebido e lido; decisões explícitas incorporadas neste goal |
| Guia de migração | Recebido em `doc/guias/`, para uso posterior à preparação; nenhum comando executado |
| Branch de trabalho | `chore/preparacao-jboss-harness`; usuário acompanha `main` na máquina de trabalho |
| Referência técnica | SHAs de `main` e `origin/main` coincidentes após fetch H00; matriz e incompatibilidades registradas no plano |
| Novo destino | H01A materializado com seis documentos e Git independente; primeiro commit `c0b6d5d981383cb496ae590ece8e15a65d0058f8`; sem remoto |
| PowerShell desta máquina | `powershell.exe` 5.1.26100.9444; parâmetros/APIs inspecionados, sem executar scripts do harness; não comprova ambiente corporativo |
| Ambiente corporativo | Versões completas dos EAPs/JDKs/Maven/MTA/DevSquad e acesso Sonar ainda a verificar |
| Sonar | URL/identidade/permissões ainda a confirmar; nenhuma credencial solicitada nesta revisão |
| Execução | Maven, Sonar, MTA, EAPs, instalação/atualização de plugins e migração `NÃO EXECUTADOS` |

Patches EAP 7.4, fornecedor/update do JDK 8, versões de bibliotecas, configuração e matrizes
aplicáveis serão confirmados por evidências. Manter Java 8 e escolher EAP 7.4 já são decisões
humanas; não reabrir essas escolhas nem preencher os detalhes faltantes por suposição.

## Riscos e condições de parada

| Risco | Tratamento |
| --- | --- |
| Misturar branch documental e snapshot de origem | Fixar SHA e manifesto; classificar separadamente requisitos recebidos e controles reutilizados |
| Impor arquitetura do template à aplicação | Política canônica, triagem de regras herdadas e evidência AS-IS por produto |
| Incompatibilidade de PS5.1, scanner, plugin ou cliente | Testar combinação real; limitar o controle afetado e submeter adaptação/decisão |
| Confundir preparação do harness com migração já validada | Resultados e GOs separados; comparar mesmo artefato nos EAPs somente em etapa autorizada |
| Sobrescrever destino ou instruções existentes | Inspecionar antes; não limpar, misturar repositórios ou inicializar plugins indiscriminadamente |

Parar antes de materializar sem GO local, modificar código/build sem baseline e checkpoint
aplicáveis, alterar arquitetura da aplicação, acessar recurso fora do escopo, publicar sem
autorização externa ou declarar pronto com evidência ausente. Ao materializar, a sessão deverá
adotar as instruções próprias do destino e não importar implicitamente as regras Quarkus.

## Decisões humanas e histórico

| Data | Registro humano | Efeito |
| --- | --- | --- |
| 2026-09-21 | Criar um goal para receber uma origem, com explicação posterior | Rascunho inicial criado em `f4bb77e`, sem requisitos completos |
| 2026-09-21 | Prompt em `origem/` contém o objetivo real; seguir trabalhando em `docs/goal-origem-mta` | Revisão documental deste goal na branch atual; topologia, destino e restrições definidos pelo prompt |
| 2026-09-21 | Guia em `doc/guias/` será usado após preparar o ambiente | Guia passa a referência da migração posterior, sem mover/copiar para `origem/` |
| 2026-09-21 | Consolidar tudo e abrir PR para `main` antes de partir para o goal | Somente consolidação documental nesta rodada; diagnóstico H00 e execução ficam para depois |

Registros humanos posteriores à consolidação:

- Criar branch para perseguir o goal após a limpeza: criada `chore/preparacao-jboss-harness`.
- Na máquina de trabalho seguir `main`; aqui prosseguir com o goal e referenciar a branch correta:
  retomar H00 e planejamento na branch atual, sem reescrever o prompt original.

Em 2026-09-21, o usuário respondeu “Autoriza o H01A”. O GO limitou-se ao Git independente
e aos seis documentos iniciais. A continuação canônica está no novo destino, em
`goals/preparacao-harness/goal.md` e `tasks/features/preparacao-harness/`.
Este registro permanece como origem; não é um segundo goal de execução.

Aprovação global dos artefatos, GOs posteriores ao H01A, publicação do novo template,
aceite e encerramento continuam pendentes. Somente
as respostas humanas correspondentes poderão mudar esses estados.
