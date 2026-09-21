# Prompt para Codex — criar um novo repositório-template JBoss EAP a partir do harness Quarkus

Você está trabalhando como Codex no meu ambiente local. Sua tarefa é **criar outro repositório-template, independente**, para migração conservadora de aplicações JBoss EAP. Use o harness Quarkus existente como referência e fonte de componentes reutilizáveis, sem convertê-lo, renomeá-lo ou alterá-lo. O trabalho inclui diagnóstico, planejamento, criação do novo Git local, implementação por incrementos autorizados e validação; produzir somente documentos não conclui a preparação.

## 0. Decisão de separação dos repositórios

A topologia pretendida é:

```text
C:\desenvolvimento\repositorio\
├── quarkus-coding-harness-template\       # origem preservada
└── jboss-eap-copilot-harness-template\    # novo template independente
```

Não é uma nova branch no repositório Quarkus, um subdiretório dele, uma renomeação, um worktree permanente, um fork nem um clone que retenha seu histórico. É outro produto de tooling, com diretório, `.git`, histórico, identidade, configuração, documentação e baseline próprios.

Nesta solicitação, as decisões de criar outro template e utilizar exclusivamente a branch `main` do repositório Quarkus como referência já estão tomadas. Não volte a perguntar se devemos adaptar o original, criar outro ou escolher outra branch. Registre o SHA de `main` utilizado para garantir rastreabilidade; o plano e os GOs de execução continuam sujeitos aos controles existentes. O objetivo local é explícito; publicação no GitHub continua sendo uma etapa externa separada.

O template não é uma aplicação JBoss de negócio. Ele entrega controles, instruções, scripts e modelos adotáveis pelas aplicações existentes. Não exige copiar a aplicação corporativa para outro repositório nem substituir seu POM. Não crie uma aplicação de demonstração fictícia apenas para aparentar build/cobertura verdes.

**Decisão obrigatória: preservar a estrutura arquitetural da aplicação Java EE 7/JBoss EAP 7.0 que será migrada. O novo harness adapta o ambiente de trabalho à aplicação existente; não adapta a aplicação à arquitetura do template Quarkus.** Essa restrição já está definida e deve orientar Codex, Copilot e DevSquad, conforme a seção 2.1.

## 1. Contexto e resultado pretendido

Repositório de referência local:

`C:\desenvolvimento\repositorio\quarkus-coding-harness-template`

Branch de referência definida pelo usuário:

**`main` — única origem de conteúdo para a derivação.**

Não utilizar `docs/adocao-harness-existente` nem outra branch como fonte alternativa ou complementar. Se o checkout local estiver em outra branch, inspecione o snapshot de `main` sem mudar o working tree. A branch atualmente aberta não redefine a referência escolhida.

Repositório remoto correspondente a conferir com o clone local:

`https://github.com/edoardo-bianco/quarkus-coding-harness-template`

Nome a utilizar para o novo template: `jboss-eap-copilot-harness-template`.

Destino local da criação:

`C:\desenvolvimento\repositorio\jboss-eap-copilot-harness-template`

Não sobrescreva um destino existente. Se a pasta já contiver material, inspecione e relate o estado antes de qualquer alteração, sem limpar, excluir ou misturar repositórios.

Na origem Quarkus: somente leitura dos arquivos; fetch autorizado pode atualizar referências remotas, mas não o working tree, HEAD ou branches locais. Não converta, refatore nem "prepare para copiar" o template Quarkus.

No novo destino: inicialize um Git independente, sem copiar `.git`, hooks locais, remotes, credenciais, tags ou branches da origem. Não use clone/checkout do repositório Quarkus como resultado final da criação. Registre procedência por SHA e manifesto de arquivos, não por histórico compartilhado.

Destino GitHub proposto para uma etapa posterior: `edoardo-bianco/jboss-eap-copilot-harness-template`, privado e marcado como Template repository. Não criar o remoto, configurar origin, publicar commits ou alterar visibilidade sem autorização externa explícita. A ausência dessa autorização não impede planejar e, após o GO local, construir o template local.

O novo harness deve atender a este cenário:

- Origem: JBoss EAP 7.0, Java EE 7, JDK 8, aplicações e bibliotecas internas existentes.
- Destino: JBoss EAP 7.4, atualização aprovada e JDK 8 compatível com a matriz aplicável.
- IDE principal: VS Code, com workspace e tarefas locais.
- Agente operacional principal: GitHub Copilot no VS Code.
- Alternativa de uso: GitHub Copilot CLI, quando seus requisitos de execução forem atendidos por ferramentas autorizadas, utilizando os mesmos controles e artefatos.
- DevSquad Copilot já instalado, mas precisando de atualização e adaptação.
- Scripts: Windows PowerShell 5.1, executados por powershell.exe, sem exigir PowerShell 7.
- Maven e servidores JBoss executados localmente, sem Docker/WSL como requisito.
- MTA CLI local, com JDK separado; Java 25 pode ser utilizado após validar compatibilidade da ferramenta.
- SonarQube corporativo existente, acessado pela URL autorizada e por token temporário de sessão. Não existe Sonar em Docker nesta máquina.

Codex prepara o harness. Depois, Copilot + DevSquad utilizam esse harness para analisar evidências, planejar e executar a migração em fatias. Não torne Codex uma dependência obrigatória do fluxo diário.

## 2. Limites da migração que o harness deve impor

Preserve Java 8, namespace javax.*, empacotamento EAR/WAR, arquitetura, contratos, regras de negócio, schema e comportamento observável. O código compartilhado deve continuar compatível com o sistema ativo no EAP 7.0.

Primeiro tentar o mesmo EAR/WAR no destino configurado; corrigir somente incompatibilidades demonstradas ou exigências de segurança identificadas. Atualizar Hibernate, adaptador SSO, driver Oracle e outras dependências apenas quando necessário e após verificar a combinação real.

Não incluir atualização geral de bibliotecas, migração para Quarkus/Spring Boot/EAP 8, Java novo na aplicação, Hibernate 6, conversão para jakarta.* ou redesenho do SSO. Não confundir referências a Jakarta EE 8 na documentação do EAP 7.4 com uma exigência de trocar javax.* por jakarta.*.

A preservação arquitetural é um critério obrigatório de planejamento, implementação e aceite, detalhado na seção 2.1. Não se limita a manter endpoints ou resultados funcionais.

Não pergunte novamente se quero manter Java 8 ou qual é o servidor de destino: essas escolhas já estão definidas. Versões de bibliotecas, caminhos e parâmetros ainda não observados ficam A CONFIRMAR.

### 2.1. Preservação obrigatória da arquitetura da aplicação Java EE 7

**Esta entrega é uma migração técnica de plataforma e compatibilidade, não uma modernização ou refatoração arquitetural.** Migrar de EAP 7.0 para EAP 7.4 não autoriza mudar como a aplicação está organizada, como seus componentes colaboram ou onde suas responsabilidades estão implementadas.

#### Separar arquitetura do harness e arquitetura do produto

A organização do novo harness (`goals/`, `specs/`, `tasks/`, scripts, agentes, skills e workspace) serve para governar o trabalho. Ela não é um modelo de arquitetura a impor à aplicação. A referência arquitetural do produto é sua implementação Java EE 7 existente, confirmada por código, configuração, documentação e validação da equipe — não o exemplo Quarkus nem a preferência de um agente.

A criação deste template não exige acesso imediato a uma aplicação corporativa: prepare os controles e modelos. Quando o harness for adotado em cada aplicação, faça o reconhecimento arquitetural real; o que ainda não foi observado permanece A CONFIRMAR.

#### O que deve permanecer preservado

Antes de planejar correções, registre no inventário arquitetural da aplicação, quando existentes:

- Estrutura de repositórios, módulos Maven, camadas, pacotes, responsabilidades e dependências entre componentes; composição e limites dos EARs, WARs e JARs.
- Modelo de execução e colaboração dos componentes Java EE: EJB, CDI, servlets, endpoints, interfaces locais/remotas, mensageria, jobs e timers. Não introduza componentes dessa lista quando não existirem.
- Persistência e transações: entidades, DAOs/repositórios existentes, unidades de persistência, uso de JPA/Hibernate, gerenciamento de EntityManager, datasource/JNDI, limites e propagação transacional, JTA/XA, concorrência e rollback.
- Segurança e integrações: responsabilidades de autenticação/autorização, contrato SSO, pontos de integração com Red Hat SSO/Keycloak, contratos públicos/internos, formatos de mensagens e chamadas entre módulos.
- Bibliotecas customizadas, seus contratos, localização e modo de carregamento, consumidores conhecidos e responsabilidades compartilhadas.

Preservar essa arquitetura não significa congelar versões ou impedir ajustes técnicos necessários no código e na configuração. Significa manter as responsabilidades, limites, contratos e semântica enquanto se aplicam somente as correções justificadas para o destino. Registre ajustes técnicos de empacotamento/classloading que forem necessários; não os use para redesenhar os limites dos módulos.

#### O que não está autorizado

Não reorganizar a aplicação em `domain/application/adapter`, ports and adapters, clean architecture ou outra estrutura para alinhá-la ao template de origem. Não criar interfaces, wrappers, factories ou novas camadas apenas para acomodar o harness ou satisfazer preferência arquitetural.

Não substituir EJB por outro modelo de serviço, transformar um monólito em microsserviços, mudar síncrono para reativo/assíncrono, introduzir Quarkus Flow/Outbox, trocar o mecanismo de persistência ou refazer a segurança. Não copiar a proibição de XA do template Quarkus: preserve a semântica transacional já utilizada pela aplicação.

Não mover ou renomear pacotes/classes, redistribuir responsabilidades entre módulos, alterar assinaturas/contratos ou remodelar entidades para corrigir um alerta genérico de ferramenta. Não importar testes ArchUnit, regras de camadas ou receitas de refatoração que obriguem o legado a reproduzir a arquitetura Quarkus. Reutilize somente verificações compatíveis com os invariantes reais da aplicação.

#### Ajustes permitidos e tratamento de impedimentos

São candidatos a correções mínimas, após evidência e GO da fatia: atualizar uma dependência necessária, adequar uma chamada de API incompatível, ajustar um binding de consulta, configurar o driver Oracle/datasource, adaptar um descritor ou a integração do adaptador SSO. A mudança deve ocorrer no componente responsável atual, preservar contratos e semântica e ser validada nos dois ambientes conforme o plano. Esses exemplos não autorizam escolher versões ou executar alterações sem diagnóstico.

Se a correção proposta exigir mudança arquitetural, registre **DESVIO ARQUITETURAL PROPOSTO**, demonstre a incompatibilidade, as alternativas mínimas e os impactos. Suspenda somente a ação afetada e apresente a decisão necessária; não a execute como parte ordinária da migração. Uma mudança desse tipo exige alteração de escopo explícita e específica pelo humano. GO genérico da fatia, recomendação do MTA/Sonar/DevSquad ou testes verdes não autorizam redesenho.

#### Como o harness deve impor esta regra

Registre esta restrição no goal/spec de migração e mantenha uma política canônica de preservação arquitetural na documentação do novo harness. `AGENTS.md`, instruções do Copilot e especializações DevSquad devem referenciá-la, sem criar versões divergentes. As instruções reutilizadas do Quarkus que conflitem com essa política precisam ser adaptadas no novo template antes da adoção em aplicações; não altere a origem.

Na adoção, registre a estrutura AS-IS e os invariantes observados em uma única seção/documento canônico, com referências aos arquivos e configurações reais. Não invente um diagrama ou uma arquitetura ideal como substituto desse inventário.

Cada item do plan/todo deve declarar o impacto arquitetural esperado. Ao revisar o diff da fatia, registre **PRESERVADO**, **NÃO VERIFICADO** ou **DESVIO ARQUITETURAL PROPOSTO**, com evidências: módulos/pacotes afetados, contratos, persistência/transações e integrações pertinentes. Não considerar a verificação arquitetural concluída apenas porque o build, MTA ou Sonar passaram. Desvio não autorizado impede o encerramento da fatia; informação ausente não comprova preservação.

## 3. Primeira etapa: verificar e registrar a referência `main`

A branch de referência já está definida: **`main`**. Esta etapa verifica sua revisão e o estado local; não é uma seleção entre branches.

Leia primeiro AGENTS.md e todas as instruções aplicáveis à sessão. Confirme o caminho do repositório, branch atualmente aberta, HEAD, estado do working tree e remotes, sem exibir credenciais eventualmente presentes em URLs. Para o inventário e a extração do harness de origem, leia os arquivos pertencentes ao snapshot de `main`, não uma cópia modificada do working tree ou o conteúdo de outra branch.

Inspecione separadamente:

1. A referência local `refs/heads/main` e seu SHA completo.
2. A referência remota correspondente, normalmente `origin/main`, quando disponível e vinculada ao remoto esperado.
3. Alterações locais e arquivos novos, somente para preservá-los e impedir sua inclusão acidental no novo template.
4. Os controles, scripts, testes e documentos efetivamente presentes em `main`.

Utilize comandos de inspeção como status, rev-parse, log, diff, ls-tree e show conforme necessário. Um fetch autorizado pode atualizar somente referências remotas, sem alterar working tree, HEAD ou branches locais. Se não houver acesso ao remoto, registre a limitação; não afirme que a referência local foi conferida com o servidor.

Confira a correspondência entre `main` local e sua referência remota. Se apontarem para o mesmo commit, registre esse SHA como fonte. Se houver diferença, apresente os SHAs e as diferenças relevantes, sem sincronizar automaticamente nem escolher outra branch. Continue o inventário da `main` local; qualquer decisão de utilizar a revisão remota de `main` deve ficar explícita antes da extração. Não misture snapshots. Essa verificação não reabre a escolha da branch, que permanece `main`.

Não execute pull, merge, rebase, reset, clean, troca de branch ou stash automático na origem. Não compare `docs/adocao-harness-existente` para decidir de onde copiar controles e não transporte arquivos dela para suprir ausências em `main`.

Produza um diagnóstico respondendo:

- Qual é o SHA completo de `main` inspecionado?
- A referência local corresponde à remota ou essa correspondência está não verificada?
- Quais arquivos reutilizáveis existem nesse snapshot de `main`?
- Que conteúdo está aceito e que conteúdo permanece proposto nos documentos dessa revisão?
- Quais requisitos do novo template precisarão ser implementados porque não existem em `main`?

Fixe o SHA de `main` no plano e no manifesto de procedência. Se `main` avançar durante o trabalho, não atualize a base silenciosamente. Arquivo ausente em `main` é uma lacuna a tratar no novo repositório, não autorização para buscar conteúdo em outra branch.

O GO continua necessário para materializar e implementar o novo template. Não peça nova confirmação da branch de referência nem suponha que `main` está desatualizada com base em conversas anteriores. A origem Quarkus permanece preservada.

## 4. Reutilizar o harness real, não reconstruí-lo por suposição

Inspecione, quando existentes no SHA fixado da branch `main`:

- AGENTS.md e README.md;
- goals/, specs/, tasks/, doc/arquitetura/ e doc/adr/;
- doc/guias/adotar-harness-repositorio-existente.md;
- doc/guias/ensaio-manual-copilot.md;
- iniciar-codex-com-sonar.ps1;
- analisar-sonarqube.ps1;
- validar-checkpoint-sonarqube.ps1;
- exportar-relatorios-sonarqube.ps1;
- .codex/hooks/SonarQuality.psm1 e os hooks associados;
- test/powershell/, POMs, configuração JaCoCo, .gitignore e demais instruções/skills.

Monte uma tabela origem → destino com decisão MANTER, ADAPTAR, NÃO TRANSPORTAR ou A CONFIRMAR, motivo e teste necessário. Inclua a triagem de regras/ADRs/testes arquiteturais: controles que imponham a arquitetura Quarkus à aplicação Java EE 7 não devem ser transportados. A seção 2.1 é o critério dessa triagem.

Preserve os contratos de qualidade e seus testes. Se código reutilizável estiver sob .codex/, avalie colocá-lo em módulo neutro, com adaptação mínima e testes de regressão, para não exigir Codex no uso com Copilot. Não duplique toda a lógica Sonar em scripts novos.

Não copie a aplicação demonstrativa Quarkus, seu POM como POM de produto, históricos operacionais, aceites, baseline Sonar ou resultados de teste como se pertencessem ao novo projeto. Registre origem e SHA dos controles reutilizados. Não transforme ADRs aceitos para Quarkus em decisões automaticamente aceitas para JBoss.

Mantenha o fluxo:

`goal → spec → arquitetura/ADRs aplicáveis → plan/todo → GO humano → fatia → testes/evidências → checkpoint → decisão humana`

Use goals/, specs/ e tasks/features/<iniciativa>/plan.md e todo.md como convenção preferencial, por já existirem. Integre o DevSquad por mapeamento explícito. Não mantenha PLAN.md/TODO.md e outros planos equivalentes editáveis em paralelo. Índices podem apontar para os arquivos canônicos.

### 4.1. Materializar como repositório novo, depois do GO

1. Confirme que a pasta de destino é nova ou que há autorização específica para seu conteúdo preexistente. Ela não pode estar contida na raiz Git da origem.
2. Utilize exclusivamente o SHA de `main` registrado no plano. Extraia somente arquivos rastreados selecionados desse snapshot, por mecanismo compatível com o Git instalado. Não copie o working tree inteiro: ele pode conter segredos, artefatos e mudanças não commitadas. Não inclua conteúdo de outras branches ou alterações locais não commitadas como se pertencesse à referência. Adaptações novas serão implementadas no destino, nas fatias autorizadas.
3. Use uma lista explícita de arquivos com decisão MANTER, ADAPTAR ou NÃO TRANSPORTAR. Preserve licenças/avisos aplicáveis. Não distribuir binários do JBoss, JDKs, drivers proprietários nem bibliotecas corporativas no template.
4. Crie o `.git` próprio no destino. Confira `git rev-parse --show-toplevel`, diretório Git e remotes para comprovar a separação. Não reutilize `origin` apontando para Quarkus.
5. Planeje `main` como branch principal do novo projeto e `chore/bootstrap-jboss-harness` como branch de implementação. O primeiro commit local, se autorizado, deve conter somente a fundação revisada e a identidade do projeto. Não criar código executável diretamente em main nem inventar usuário/e-mail Git. Se a ferramenta Git não suportar um parâmetro recente, use procedimento equivalente compatível e documente.
6. Adapte arquivos exclusivamente dentro do destino. Respeite controles de baseline e GO antes das alterações executáveis; a inexistência de baseline do novo projeto não permite herdar um resultado verde da origem.
7. Crie `doc/origem-harness.md` com repositório de origem, branch `main`, referência local/remota efetivamente utilizada, SHA completo, data, arquivos/componentes reutilizados, adaptações, descartes, motivos e testes. Escolha um único manifesto canônico; não duplique registros equivalentes.
8. Prove ao final que o working tree e as branches locais da origem ficaram intactos, descontando apenas metadados de fetch expressamente autorizados. Apresente o novo estado Git e todos os destinos de escrita efetivamente utilizados.

Se a sessão Codex estiver restrita ao diretório de origem, solicite acesso somente ao destino necessário ou reinicie no novo diretório quando possível. Não desabilite a sandbox nem amplie a escrita para todos os repositórios como atalho. Depois de materializar as instruções do novo template, inicie uma sessão no destino e confirme quais AGENTS.md e regras estão ativos antes de implementar a primeira fatia. Não continue aplicando implicitamente regras arquiteturais específicas do Quarkus carregadas pela sessão anterior.

Não transportar: código demonstrativo Quarkus, POM/BOM/plugins específicos, `.git`, `target/`, `.m2/`, credenciais, `.env` locais, logs, relatórios MTA/Sonar reais, baseline de sessão, pacotes corporativos, caches, decisões humanas passadas ou tarefas da origem marcadas como concluídas. Ignore também artefatos de segurança do agente que sejam estado de sessão, preservando apenas configurações reutilizáveis revisadas.

Na criação do novo template, não há necessidade de sincronização automática futura com o Quarkus. Melhorias compartilhadas serão avaliadas por diff e transportadas seletivamente, com seus testes, em trabalho separado. Não inventar uma plataforma universal, submódulo ou monorepo para resolver este objetivo.

### 4.2. Estrutura e adoção em aplicações existentes

Reutilize as convenções já presentes em vez de renomear tudo. A estrutura esperada, a ajustar à inspeção, inclui:

```text
jboss-eap-copilot-harness-template/
├── README.md
├── AGENTS.md
├── .gitignore
├── .github/                # instruções/skills compatíveis com Copilot
├── .vscode/                # tarefas e exemplos; nenhum segredo
├── config/                 # modelo versionado; configuração real ignorada
├── scripts/                # somente módulos/scripts necessários, PS 5.1
├── test/powershell/         # testes reaproveitados e adaptados
├── goals/                  # objetivos próprios e templates
├── specs/                  # especificações próprias e templates
├── tasks/                  # plan/todo próprios; sem aceites herdados
└── doc/                    # procedência, arquitetura, ADRs e guia de adoção
```

Essa árvore descreve somente o repositório do harness; não é a estrutura que a aplicação Java EE 7 deverá adotar. É uma orientação, não motivo para reorganizar scripts funcionais sem necessidade. Não forçar um POM de aplicação no diretório raiz para satisfazer suposições dos scripts Sonar. Diferencie a raiz do harness da raiz Maven do produto por configuração explícita, inclusive em workspaces com múltiplos repositórios.

O template deve documentar adoção seletiva em uma aplicação existente: comparar arquivos antes de copiar, preservar POM/README/AGENTS/instruções/IDE já presentes, relacionar colisões e só aplicar alterações autorizadas. Não recriar o Git da aplicação, mover seu código ou substituir configurações corporativas. Repetir a adoção não deve duplicar instruções, sobrescrever customizações nem limpar evidências.

Separe exemplos reutilizáveis de evidências reais e das tarefas de construção do próprio template. Ao adotar em outra aplicação, crie goal, plan/todo, identidade Sonar e baseline próprios. Planos do DevSquad devem apontar para esses arquivos canônicos, não para tarefas herdadas desta criação.

## 5. Planejar a construção do harness em incrementos

Crie goal, spec, plano e todo próprios para a adaptação. Proponha incrementos pequenos nesta ordem, ajustando dependências conforme a inspeção:

- H00: diagnóstico Git somente leitura, inventário da `main` e registro de seu SHA como revisão-base, sem modificar a origem nem selecionar outra branch.
- H01: criação do novo Git independente, manifesto de procedência, governança própria e configuração local de exemplo.
- H02: compatibilidade PowerShell 5.1 e separação das toolchains.
- H03: Sonar corporativo, sessão segura e regressão dos controles existentes.
- H04: workspace VS Code, build Java 8, operação local dos dois JBoss e evidências.
- H05: atualização DevSquad, instruções/skills Copilot e paridade IDE/CLI.
- H06: entrada MTA, inventário arquitetural e de bibliotecas, planejamento da migração, adoção não destrutiva e ensaio integrado com verificação de preservação arquitetural.
- H07: preparação da publicação e uso como template GitHub, somente após aceite local e autorização externa específica.

Cada incremento precisa de escopo, arquivos prováveis, testes, dependências, critérios de pronto, checkpoint e autorização. Não interprete o GO de um incremento como aprovação de todos os seguintes.

Separe o plano de construção do harness dos templates de plano de migração de aplicações. Não inicie a migração de uma aplicação não identificada para demonstrar o harness.

## 6. PowerShell 5.1 e separação das toolchains

Verifique $PSVersionTable e teste scripts no Windows PowerShell 5.1 real. Não basta analisar sintaxe ou rodar no pwsh.

Elimine dependência obrigatória de sintaxe/cmdlets/APIs indisponíveis nesse ambiente: ??, operador ternário, &&/|| do PowerShell 7, ForEach-Object -Parallel, ConvertFrom-Json -AsHashtable, ProcessStartInfo.ArgumentList e sobrecargas exclusivas de .NET moderno. Revise especialmente Contains com StringComparison nos scripts herdados.

Use processos/argumentos com tratamento correto de espaços e caracteres especiais, códigos de saída explícitos para executáveis nativos, timeouts, restauração de ambiente em finally e encoding compatível com PowerShell 5.1. Teste caminhos com espaços e texto com acentos. Não utilize Invoke-Expression para montar comandos.

Não alterar ExecutionPolicy global, não usar bypass como solução padrão, não exigir administrador nem instalar ferramentas não aprovadas. Módulos de teste devem respeitar o que está disponível; não presumir Pester instalado.

Separe estas funções:

1. JDK 8: compilação, testes da aplicação, bibliotecas internas e execução dos EAPs.
2. JDK do MTA: ferramenta de análise, isolada do build.
3. JDK do scanner Sonar: escolhido conforme scanner e servidor corporativo.
4. Runtime da extensão Java do VS Code: ferramenta do editor, independente do Java do projeto.

Crie configuração local única, ignorada pelo Git, com exemplo versionado sem segredos: caminhos de JDKs, Maven/wrapper, settings.xml, raízes das aplicações/bibliotecas, EAPs, arquivos standalone, portas, Sonar URL e identidade autorizada. Não espalhe caminhos pessoais em vários arquivos.

Preserve o Maven/wrapper, perfis, plugins e toolchains existentes da aplicação sempre que viáveis. Não impor o Maven ou os plugins do template Quarkus. Comprove o Java efetivo do Maven e dos testes, não apenas source/target no POM.

## 7. Preparar VS Code como entrada principal

Entregue workspace de exemplo e configurações que possam ser adotadas sem sobrescrever configurações existentes. Suporte a raiz Maven multimódulo e, quando necessário, um workspace com aplicação e bibliotecas internas em repositórios distintos, com escopo explícito de escrita.

Configure Java 8 para projetos e terminais da aplicação. Configure separadamente o runtime da extensão Java. Não copie tokens para settings.json, tasks.json, launch.json, .code-workspace ou envFile.

As tarefas devem chamar scripts comuns, também executáveis pelo Copilot CLI, para:

- diagnosticar ambiente e pré-requisitos;
- compilar/testar/coletar cobertura com Java 8;
- gerar inventário Maven/artefatos;
- executar e importar análise MTA;
- iniciar, consultar, implantar, remover deployment e encerrar cada JBoss local;
- executar checkpoint Sonar e coletar evidências.

Para JBoss, use os scripts e CLI oficiais da instalação selecionada. Separe homes, dados, logs, configuração e portas. Confirme produto/versão antes de implantar; valide status do deployment e da aplicação, não apenas servidor running.

Use o mesmo artefato identificado por hash na comparação 7.0/7.4. Verifique overrides em standalone.conf.bat. Configurações de datasource, driver, módulos e SSO são pré-requisitos explícitos; um servidor vazio não equivale ao ambiente atual.

O padrão é laboratório local, um servidor por vez, sem acesso a dados ou filas de produção. Portas distintas não isolam banco, cluster, timers ou consumidores. Para domain/cluster, registre a necessidade de homologação correspondente, sem declarar a validação standalone suficiente.

Documente a sequência de cliques/tarefas para abrir o workspace, conferir Java, iniciar o 7.0, fazer deploy, testar, encerrar e repetir no 7.4. Depuração por attach pode ser opcional, restrita ao ambiente local e validada para o JDK 8.

## 8. Atualizar e integrar DevSquad com Copilot

Fonte obrigatória:

`https://github.com/microsoft/devsquad-copilot`

Inspecione a instalação existente: plugin, versão/revisão, local, customizações e diferenças entre IDE e CLI. Consulte README, changelog, instalação e extensibilidade oficiais antes de modificar qualquer arquivo.

Não trate o DevSquad inteiro como se fosse somente uma skill isolada. Reutilize seus agentes/skills e pontos de extensão; crie somente a especialização necessária para EAP/Java 8/MTA/Sonar.

Depois do GO, utilize o procedimento de atualização compatível com a instalação. A documentação consultada apresenta Chat: Update Plugins no VS Code e copilot plugin update devsquad no CLI; confirme essas opções na versão instalada. Não suponha que atualizar um ambiente atualiza o outro.

Registre versão/revisão antes e depois e detecte alterações do plugin entre ensaios. Preserve customizações. Não execute inicialização que sobrescreva .github/copilot-instructions.md, convenções de documentação ou decisões existentes.

Distinga o shell exigido pelo próprio Copilot CLI do shell dos scripts do harness. O README oficial do CLI consultado lista PowerShell 6 ou superior no Windows; reconfirme o requisito da versão instalada. Com somente PowerShell 5.1 disponível, não declare essa rota homologada nem instale outro PowerShell automaticamente: mantenha o fluxo principal no VS Code e registre o CLI como condicionado a pré-requisito autorizado. Mesmo com um host CLI compatível, os scripts deste harness devem ser chamados explicitamente por powershell.exe 5.1 e testados nesse processo.

Verifique requisitos de VS Code, CLI, Node e hooks/MCP. Não introduza dependência obrigatória de Bash, WSL, Docker ou PowerShell 7 no fluxo principal. Se um componente upstream não for compatível, explicite a limitação e proponha uma adaptação testável; não declare compatibilidade nem remova controles silenciosamente.

Mantenha uma fonte canônica de regras, com AGENTS.md como roteador e arquivos Copilot apontando para ela quando apropriado. Utilize .github/instructions/, .github/skills/ e agentes apenas nos formatos realmente suportados. Não presumir que hooks Codex funcionam diretamente no Copilot.

As especializações precisam cobrir triagem MTA, análise de bibliotecas, planejamento, implementação de uma fatia, verificação de preservação arquitetural da seção 2.1 e checkpoint Sonar. Reutilize capacidades existentes antes de criar novos agentes ou skills. Valide descoberta/carregamento e execução no VS Code e, quando seus pré-requisitos forem atendidos, no CLI. Identifique testes pendentes por cliente.

DevSquad deve obedecer aos GOs e decisões do harness, sem autoaprovação de fatias, commits, PRs ou encerramento. Não usar --yolo, aprovação irrestrita, criação automática de issues/boards ou MCP externo sem autorização. Hooks continuam lembretes; os scripts produzem a avaliação técnica e o humano decide.

Não permitir IDE e CLI escrevendo simultaneamente no mesmo checkout ou executando análises concorrentes sobre o mesmo estado Sonar.

## 9. Adaptar o Sonar corporativo sem perder os controles

Reutilize e teste a lógica existente de sessão, análise, baseline, checkpoint, decisão e exportação sanitizada. Remova a suposição de localhost:9000/Docker do caminho principal, sem substituir o servidor corporativo por outro produto.

Confirme URL, versão/edição do Sonar, ProjectKey/ProjectName, permissões do token, perfis, Quality Gate, suporte a branches e parâmetros de análise. Não crie projeto nem sobrescreva a análise de uma branch corporativa por inferência. A identidade de análise precisa estar autorizada.

### Credencial

Preserve o token somente no ambiente do processo necessário, por entrada protegida fora do chat. Nunca coloque token em argumento Maven, arquivo, log, relatório, commit ou mensagem. Não peça ao agente para revelar variáveis de ambiente.

Adapte o launcher existente para iniciar Copilot CLI ou o workspace VS Code. Teste a herança até o terminal realmente utilizado pelo agente. Trate instâncias VS Code já abertas e restauração de terminais, sem encerrar à força o trabalho do usuário. Limpe/restaure o ambiente no fim e documente processos filhos ainda ativos.

Não desabilite TLS nem validação de certificados. Reutilize proxy, truststores e políticas corporativas aprovadas.

### Build e análise em processos separados

Revise analisar-sonarqube.ps1: na versão de referência ele combina clean verify e sonar na mesma execução Maven. Não copie essa premissa para a aplicação Java 8.

Implemente este contrato:

1. Compilar e executar testes/cobertura com JDK 8 e o Maven da aplicação.
2. Preservar os bytecodes e relatórios produzidos.
3. Executar o scanner em etapa separada, com JDK e versão fixa compatíveis com o Sonar corporativo, sem clean/recompilação sob o JDK moderno.
4. Apontar sonar.java.jdkHome para o JDK 8 e conferir a configuração de source e classpath da análise.
5. Em multimódulo, resolver as necessidades do reactor e eventual install local, sem publicar artefatos corporativos automaticamente.
6. Associar resultado ao mesmo código/fingerprint, testes, dependências e artefato validados.

Não forçar scanner incompatível a rodar no Java 8. Não presumir que o Java 25 do MTA é automaticamente adequado ao scanner. Provisionamento automático de JRE ou downloads precisam respeitar a política corporativa.

### Política e resultados

Confirme os valores nos scripts/testes do SHA de `main` registrado como referência. A referência consultada documenta cobertura mínima de 85%, duplicação máxima de 5%, issues novas e issues HIGH/BLOCKER/CRITICAL. Preserve a definição real das métricas; não trocar cobertura total por cobertura de código novo ou ignorar issues preexistentes sem decisão.

Registre separadamente o Quality Gate corporativo e o resultado das regras do harness. Não reduza exigências de nenhum deles. Diferencie novas issues, dívida preexistente e ausência de dados; não amplie a migração para corrigir todo o legado automaticamente.

Se o baseline já não atender à política, apresente o resultado e opções ao humano. Preserve NON_COMPLIANT, UNVERIFIED e os demais estados reais. Não fabrique aprovação, não redefina baseline para apagar regressões e não altere exclusões/regras/limites para fazer passar.

Cada produto terá baseline próprio. Não transportar o baseline do template Quarkus. Ausência de token, servidor, permissão ou relatório completo significa não verificado; pacote offline não comprova aprovação online.

Aguarde o processamento da análise correspondente: relacione report-task.txt, ceTaskId e analysisId. Não consulte apenas o último resultado disponível no servidor. Trate paginação, timeout, permissões, versões das APIs e mudanças de severidade sem ignorar resultados silenciosamente.

Após cada lote coerente de mudanças executáveis e suas correções, execute testes/cobertura e checkpoint antes de encerrar a fatia ou avançar. Não rodar Sonar a cada tecla; não deixar fatia alterada com evidência antiga. Mudança exclusivamente Markdown mantém a dispensa existente. Skills, prompts ou configurações operacionais que alterem o comportamento do agente não devem ser classificados como documentação inofensiva apenas pela extensão .md; proponha essa distinção explicitamente na política e no fingerprint.

NON_COMPLIANT exige a decisão humana prevista no harness: Reprovar, AceitarExcepcionalmente ou ContinuarAjustes. O agente registra somente a resposta recebida. Evidência verde não equivale a aceite humano.

Teste código de decisão, falhas, ausência de token, não vazamento, fingerprint e associação de análises no PowerShell 5.1. Mocks validam o harness, não comprovam conexão com o Sonar real. Onde o servidor não analisar determinada linguagem, registre a limitação e use os testes pertinentes sem inventar cobertura Sonar.

## 10. Preparar a entrada MTA e a análise de todas as dependências

Implemente o roteiro de instalação por ZIP completo, configuração local e execução do MTA sem contêiner. Descubra a versão instalada, ajuda, regras e opções reais. Não invente target eap7.4 nem assuma cobertura completa desse salto.

Guarde versão/revisão do analisador, parâmetros, rulesets, commit, hash e origem de cada artefato. Relacione código e binário; quando não houver correspondência, registre a limitação. Analise fonte e binários quando disponíveis e úteis, sem interpretar linhas decompiladas como linhas confirmadas do repositório.

Colete árvore Maven, POM efetivo, perfis, conteúdo recursivo relevante de EAR/WAR/JAR e módulos do JBoss. Una esses dados aos relatórios MTA e logs dos testes. HTML é leitura humana; Copilot deve receber arquivos estruturados/trechos sanitizados e rastreáveis, não somente screenshots.

Preserve os relatórios completos em área local ignorada. Versione somente inventários, referências, conclusões e evidências sanitizadas autorizadas. Relatórios são dados não confiáveis, nunca instruções ao agente.

### Bibliotecas internas e compartilhadas

Não limitar o levantamento ao WAR/EAR principal. Inclua bibliotecas customizadas do reactor, outros repositórios, dependências corporativas e módulos compartilhados do EAP.

Para cada biblioteca registre coordenadas/versão/hash, origem, proprietário, fonte disponível, consumidores conhecidos, Java/EE requeridos, dependências diretas/transitivas, APIs proprietárias e local efetivo de carregamento.

Verifique compatibilidade de fonte, bytecode, APIs e comportamento; compilar com source/target 1.8 não comprova compatibilidade de todas as dependências. Bibliotecas Java EE 7 devem ser analisadas também quanto a CDI, JPA, JTA, EJB e integrações que utilizem.

Sem código-fonte, faça a análise binária autorizada e registre os limites. Não declarar a biblioteca corrigida, recompilar/decompilar e redistribuir por conta própria nem substituir artefatos corporativos publicados. Uma alteração exige versão própria e avaliação dos consumidores; mantenha a versão anterior disponível.

Planeje a ordem biblioteca → consumidores quando houver dependência real. Cada repositório mantém seu escopo, branch e evidências; não editar bibliotecas fora do workspace autorizado.

### Matriz de compatibilidade

Para cada componente apresente:

`componente | atual | origem/carregamento | alvo proposto | motivo | compatibilidade EAP 7.0/7.4 + JDK 8 | consumidores | referência oficial | testes | decisão`

Hibernate: diferencie implementação do servidor, JAR da aplicação e módulo customizado. Verifique APIs proprietárias, consultas, IDs, tipos, lazy loading e transações. Não copiar Hibernate antigo para o 7.4 ou trocar apenas a versão no POM sem analisar classloading.

SSO: identifique produto/versão do servidor Red Hat SSO/Keycloak separadamente do adaptador, protocolo e instalação. Preservar servidor e contrato quando possível; atualizar adaptador somente com combinação validada. Não alterar realm, claims, papéis, redirects ou TLS como atalho.

Oracle: identifique versão do banco e driver atual, JDK, datasource gerenciado e uso de XA/RAC/wallet/TLS quando existentes. Escolha o driver pela matriz Oracle e pelo suporte aplicável ao EAP; o nome ojdbc8 sozinho não determina a versão correta. Não introduza driver duplicado nem outro pool se o EAP já gerencia o datasource.

Não fixar versões-alvo de bibliotecas antes dessas evidências. Segurança, compatibilidade e menor intervenção devem ser conciliadas; dependência vulnerável não deve ser preservada sem avaliação e decisão registradas.

## 11. Fluxo de migração que o Copilot executará depois

O harness deve materializar esta sequência para cada aplicação:

1. Reconhecimento, inventário AS-IS da arquitetura/aplicação/bibliotecas e restrições da seção 2.1.
2. Build Java 8 e baseline funcional/Sonar próprio.
3. Execução no EAP 7.0 e tentativa do mesmo artefato no 7.4 configurado.
4. MTA, inventário Maven/runtime e triagem dos achados.
5. Goal/spec de migração e plan/todo com etapas e dependências.
6. GO para uma fatia específica.
7. Alteração mínima, testes, cobertura e revisão do diff, comprovando a preservação arquitetural da seção 2.1.
8. Comparação pertinente nos dois EAPs e checkpoint Sonar.
9. Correções/revalidação, registro da decisão e checkpoint humano.
10. Próxima fatia somente após autorização correspondente.

Classifique achados como APLICÁVEL, FORA_DO_ESCOPO, NÃO_APLICÁVEL ou A_CONFIRMAR, com justificativa. Falta de informação gera investigação antes da correção.

Um item do todo deve conter ID, evidência de origem, objetivo, pré-requisitos, arquivos/bibliotecas/servidor afetados, ação, impacto arquitetural esperado e verificado conforme a seção 2.1, testes, critério de conclusão, reversão, resultado Sonar e estado real. Prefira fatias pequenas como no harness de origem; desvios do tamanho esperado precisam de justificativa.

Compatibilidade binária, de build e funcional são verificações diferentes. Prefira mesmo artefato nos dois servidores; diferenças inevitáveis de empacotamento/configuração precisam de decisão explícita, não de builds silenciosamente distintos.

Inclua testes negativos de autorização e cenários relevantes de persistência/rollback. Deploy OK não basta. Não declarar migração concluída apenas porque MTA deixou de apontar issues ou Sonar ficou verde.

O planejamento de implantação deve manter origem reversível e considerar efeitos em banco, mensagens e sessões. Nenhuma promoção para produção é autorizada por este prompt.

## 12. Publicação como template GitHub: etapa distinta

Primeiro construir e validar localmente. Depois, com autorização explícita para o destino remoto:

- Criar um repositório GitHub independente, privado, na conta/organização autorizada; conferir a inexistência de conflito de nome.
- Associar somente o novo projeto local a esse origin, revisar conteúdo/licenças/segredos e publicar apenas commits e branches autorizados.
- Consolidar a versão aprovada na main do novo repositório e marcar a configuração Template repository. Essa marcação do GitHub é separada da criação de uma pasta local de modelos.
- Não marcar nem modificar o repositório Quarkus como consequência. Não utilizar sua configuração remota por herança.
- Validar a reutilização a partir da main aprovada do novo template. Testar em diretório local temporário é diferente de criar um terceiro remoto; criação desse remoto de ensaio também precisa de autorização.
- Comprovar o nome, URL, visibilidade, branch padrão e configuração de template efetivos. Sem execução autorizada, registrar publicação PENDENTE, nunca afirmar que o template está publicado.

Não escolher "incluir todas as branches" por padrão ao reutilizar templates. Não é necessário trazer branches de adoção do Quarkus para o novo projeto. Para aplicações já existentes, a rota é adoção seletiva do harness, não substituição do repositório da aplicação.

## 13. Entregáveis e aceite da preparação

Entregue, após os GOs e incrementos executados:

- Novo template sem dependências operacionais de Quarkus ou Codex.
- Rastreabilidade dos arquivos reutilizados e do SHA de `main` usado como revisão-base.
- Goal/spec/ADRs propostos e plan/todo próprios, coerentes com DevSquad.
- Workspace, configuração de exemplo e tarefas VS Code; equivalentes para CLI.
- Scripts e testes compatíveis com Windows PowerShell 5.1.
- Sessão segura e adaptação do Sonar corporativo, preservando regras/decisões.
- Templates de inventário arquitetural AS-IS, matriz de bibliotecas, ingestão/triagem MTA e revisão da preservação arquitetural por fatia.
- Prompts operacionais para analisar evidências, gerar plan/todo, executar uma fatia e corrigir/revalidar Sonar, todos subordinados à preservação arquitetural da seção 2.1.
- Guia único, em português, com ordem de execução, local de cada ação e resultado esperado, desde MTA ZIP até comparação dos dois EAPs.
- Relatório de testes, resultados reais, limitações e pendências para validar na máquina corporativa.

Não simule instalação, acesso corporativo, teste PS5.1, execução de JBoss ou resultado Sonar. Marque NÃO EXECUTADO/NÃO VERIFICADO quando for o caso. Não copie o resultado verde do template para o derivado.

Scripts/configurações/plugins são mudanças executáveis: respeite baseline e GO aplicáveis. Durante a adaptação, se a infraestrutura necessária à validação ainda estiver indisponível, registre o bloqueio e a decisão necessária; não aprove a própria exceção.

Antes de finalizar cada incremento, revise diff, segredos, testes e escopo. Não commitar arquivos indiscriminadamente, publicar repositórios, aceitar ADRs ou encerrar o goal automaticamente.

## 14. Primeira resposta esperada de você

Comece pelo diagnóstico, não pela cópia de arquivos. O resultado a construir depois do GO é um repositório-template novo e funcional, não uma alteração no Quarkus nem apenas um plano.

Apresente: estado Git, SHA da branch de referência `main` e correspondência local/remota verificada ou pendente; arquivos efetivamente inspecionados nesse snapshot; controles reutilizáveis; incompatibilidades a tratar; estrutura proposta; plano H00–H07 ajustado; e o primeiro checkpoint para aprovação da execução. Não proponha outra branch de referência.

Nesta primeira etapa, apenas leitura/diagnóstico e comandos de inspeção necessários: não executar Maven, Sonar, atualização de plugins, cópia de relatórios, alteração de scripts ou materialização. Não solicitar token para diagnóstico documental. Depois do GO, execute o incremento aprovado e traga suas evidências.

O objetivo é reaproveitar o harness e seus controles, mudando somente o necessário para EAP/Java 8, Copilot, Sonar corporativo e PowerShell 5.1. O novo harness deve manter a estrutura arquitetural da aplicação Java EE 7 migrada, não convertê-la à arquitetura do template Quarkus.

## 15. Fontes para consulta e confirmação de versões

Priorize os arquivos reais do repositório e documentação correspondente às versões instaladas. Registre data, URL/seção, aplicabilidade e limites. Conteúdo inacessível não deve ser apresentado como verificado.

- GitHub, criar um template: https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-template-repository
- GitHub, criar a partir de um template: https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template
- DevSquad: https://github.com/microsoft/devsquad-copilot
- Instalação/atualização: https://microsoft.github.io/devsquad-copilot/getting-started/
- Extensibilidade: https://microsoft.github.io/devsquad-copilot/extensibility/
- Copilot, instruções na IDE: https://docs.github.com/en/copilot/how-tos/configure-custom-instructions-in-your-ide/add-repository-instructions-in-your-ide
- Copilot CLI, requisitos: https://github.com/github/copilot-cli
- Copilot CLI, skills: https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-skills
- VS Code, Java: https://code.visualstudio.com/docs/java/java-project
- VS Code, ambiente dos terminais: https://code.visualstudio.com/docs/terminal/advanced
- PowerShell 5.1/7: https://learn.microsoft.com/en-us/powershell/scripting/whats-new/differences-from-windows-powershell
- SonarScanner Maven: https://docs.sonarsource.com/sonarqube-server/analyzing-source-code/scanners/sonarscanner-for-maven
- Sonar Java/JDK da aplicação: https://docs.sonarsource.com/sonarqube-server/analyzing-source-code/languages/java
- EAP 7.4 Migration Guide: https://docs.redhat.com/en/documentation/red_hat_jboss_enterprise_application_platform/7.4/html/migration_guide/index
- EAP Supported Configurations: https://access.redhat.com/articles/2026253
- Red Hat SSO Supported Configurations: https://access.redhat.com/articles/2342861
- Oracle JDBC: https://www.oracle.com/database/technologies/faq-jdbc.html
- MTA, documentação da versão instalada: https://docs.redhat.com/en/documentation/migration_toolkit_for_applications
- Codex AGENTS.md: https://developers.openai.com/pt-BR/docs/agent-configuration/agents-md
