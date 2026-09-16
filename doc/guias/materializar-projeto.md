# Guia de materialização de um projeto derivado

## Finalidade e condição de uso

Este procedimento transforma uma versão aceita do template em um repositório de produto com
identidade, contexto, histórico Git e baseline Sonar próprios. Ele não é um gerador automático:
cada alteração continua sujeita à revisão humana e aos checkpoints do `AGENTS.md`.

Use somente uma **commit ou tag aceita** do template. A tecnologia suportada é exatamente
**Java 25 + Quarkus 3.33 LTS + Maven**. Se o produto pedir outra combinação, pare e registre a
limitação; não adapte silenciosamente o template nem inicie código.

## Entradas obrigatórias

Reúna e confirme com o humano todas as entradas antes de criar a cópia. Exemplos mostram apenas o
formato e nunca funcionam como defaults.

| Entrada | Regra |
| --- | --- |
| Nome do repositório | Nome definitivo do produto e do repositório |
| Descrição curta | Propósito do produto em uma frase |
| `groupId` | Coordenada Maven informada pelo humano |
| `artifactId` | Coordenada Maven e nome técnico da aplicação |
| Versão inicial | Versão Maven, por exemplo `0.1.0-SNAPSHOT` |
| Pacote-base | Pacote Java válido, próprio do produto |
| Goal inicial | Problema, valor e resultado esperado |
| Capacidades | Somente capacidades inicialmente necessárias |
| Destino local | Caminho absoluto confirmado |
| Destino GitHub | `owner/repository` ou declaração explícita de que não haverá remoto agora |
| Visibilidade | Privada ou pública, quando houver remoto |
| Estratégia de branch | Branch inicial e política confirmadas pelo humano |
| Responsável humano | Autoridade de aprovação, aceite e encerramento |

Não invente campo ausente. Valide `groupId`, `artifactId` e pacote-base antes de usá-los em nomes
de arquivo ou comandos. Não concatene texto não validado em um shell.

## 1. Fixar a origem e o destino

1. Registre o identificador da commit ou tag aceita usada como origem.
2. Resolva o destino local para um caminho absoluto.
3. Exija um **diretório novo e vazio**. Se ele existir com qualquer conteúdo, pare; não apague,
   mova ou sobrescreva arquivos para “liberar” o destino.
4. Confirme que o destino não é o template, sua raiz, seu diretório pai nem outro repositório.
5. Não crie remoto, altere visibilidade ou faça push sem destino e autorização explícitos.

Para uma cópia local limpa, prefira um arquivo produzido por `git archive` da revisão aceita e
extraído no destino vazio. Um repositório criado por “Use this template” no GitHub também fornece
histórico novo. Em ambos os casos, a cópia deve conter somente arquivos versionados; não transporte
o diretório `.git/` da origem.

Arquivos locais ou ignorados nunca entram na cópia:

- `.codex/.state/`;
- `target/` e `.quarkus/`;
- `.env`, chaves, certificados e logs;
- pacotes sob `sonar/`, preservando apenas o arquivo versionado `sonar/README.md`;
- configurações de IDE e artefatos temporários.

Antes de continuar, confira a lista copiada e inicialize um repositório Git novo. O primeiro commit
do produto deve conter somente o estado materializado e revisado, sem o histórico do bootstrap.

## 2. Substituir a identidade técnica

Faça a substituição como uma única transformação verificável; não use substituição global cega em
documentos históricos ou dependências de terceiros.

1. Em `pom.xml`, altere somente o `groupId`, o `artifactId` e a versão do projeto. Preserve Java
   25, Quarkus 3.33.3.1 LTS, Maven Wrapper e dependências até que outra mudança seja especificada.
2. Em `src/main/resources/application.properties`, substitua `quarkus.application.name` pelo
   `artifactId` aprovado.
3. Mova a árvore `src/main/java/template/harness` para o caminho correspondente ao pacote-base.
4. Faça o mesmo em `src/test/java/template/harness`.
5. Atualize declarações `package`, imports e as constantes `ROOT_PACKAGE` dos testes ArchUnit de
   `template.harness` para o novo pacote-base.
6. Em `ObservabilityInfrastructureTest`, substitua o nome esperado da aplicação
   `quarkus-coding-harness-template` pelo novo `artifactId`, mantendo a asserção sobre
   `quarkus.application.name`. Alterar só a configuração deixa esse teste em RED.
7. Reescreva o `README.md` como entrada do produto: título, descrição, comandos, estado atual e
   links próprios. Remova a tabela de incrementos e qualquer narrativa do bootstrap do template.

Mantenha a **feature neutra** `sample` até uma feature real produzir evidência equivalente do
harness. Sua remoção exige tarefa própria, teste e `GO`; ela não deve ser renomeada como se fosse
um domínio real.

Após a transformação, procure a identidade antiga em `pom.xml`, `src/main/java`, `src/test/java`,
`src/main/resources` e `README.md`. Uma ocorrência restante nesses locais bloqueia o ensaio.

## 3. Criar contexto e histórico próprios

Os artefatos abaixo registram a construção do template e não são histórico do produto:

- `goals/template-harness/goal.md`;
- `specs/template-harness/spec.md`;
- `tasks/plan.md`;
- `tasks/todo.md`.

Remova os dois diretórios ativos de bootstrap e recrie os quatro artefatos do produto a partir de:

- `goals/templates/goal.md`;
- `specs/templates/spec.md`;
- `tasks/templates/plan.md`;
- `tasks/templates/todo.md`.

O goal inicial usa o objetivo fornecido pelo humano. A spec, a arquitetura consolidada, os ADRs
aplicáveis, o plano e o checklist começam no estado real do produto e aguardam as aprovações
previstas. Uma decisão `Aceito` do template não vira automaticamente uma decisão aceita pelo
produto: revise contexto, aplicabilidade e autoridade antes de registrar o novo estado.

Reescreva `doc/arquitetura/arquitetura-harness.md` para descrever o produto derivado, mantendo o
caminho enquanto `AGENTS.md` apontar para ele. Trate `doc/adr/README.md` e cada ADR como fontes de
propostas: retenha somente decisões aplicáveis, adapte contexto e consequências e comece-as como
`Proposto`. O estado `Aceito` só pode reaparecer após decisão humana do projeto derivado.

Substitua ou remova todos os marcadores no formato `{{CAMPO}}`. Campo desconhecido vira questão
aberta ou bloqueio explícito. Audite também datas, nomes, links e frases sobre “Incremento” para
que nenhuma evidência operacional do bootstrap pareça pertencer ao produto.

Não inicie a primeira feature real até que goal, spec, arquitetura/ADRs aplicáveis, plano e
checklist tenham sido revisados e o humano tenha registrado o `GO` correspondente.

## 4. Verificar a cópia

Execute as verificações no destino materializado, nunca contra o template original:

```powershell
.\mvnw.cmd -q verify
Get-ChildItem .\test\powershell\*Test.ps1 | Sort-Object Name | ForEach-Object { & $_.FullName }
```

Depois, verifique:

- POM, pacote Java, `ROOT_PACKAGE` e nome observável usam a nova identidade;
- `README.md`, goal, spec, `doc/arquitetura/arquitetura-harness.md`, `doc/adr/README.md`, ADRs
  aplicáveis, plano e checklist descrevem o produto;
- nenhum marcador `{{` permanece nos artefatos ativos;
- `.git/` possui histórico novo e o remoto corresponde ao destino aprovado, se configurado;
- `.codex/.state/`, `target/`, relatórios e pacotes Sonar continuam ignorados;
- nenhuma credencial, log, arquivo de IDE ou artefato da origem está staged;
- a feature neutra permanece identificada como prova temporária do harness.

## 5. Criar o primeiro commit local antes do baseline

Com as verificações verdes, revise o diff completo e adicione ao staging somente os arquivos da
materialização. Confira as exclusões e faça um commit atômico local antes de iniciar a análise
Sonar. Assim, o novo repositório já possui uma revisão própria em `HEAD` para a análise.

```powershell
git diff --cached --check
git diff --cached
git commit -m "chore: materializa identidade e contexto do projeto"
git rev-parse --verify HEAD
```

Se o commit falhar ou `HEAD` não existir, pare e resolva a pendência antes do baseline. O commit
local registra o estado verificado; não significa aceite do produto nem autorização de push.

## 6. Criar baseline Sonar próprio

Confirme primeiro que `.codex/.state/` não veio da origem e que `sonar/` contém apenas
`sonar/README.md`. O `ProjectKey` padrão do harness deriva do novo POM como
`groupId:artifactId`; não informe uma chave do template.

Se não houver pacote offline, inicialize o baseline no SonarQube local a partir de uma sessão que
já herdou a credencial somente em memória:

```powershell
.\validar-checkpoint-sonarqube.ps1 -InitializeBaseline
```

Se existir qualquer pacote offline, pare e peça ao humano para escolher a fonte conforme
`AGENTS.md`: local, local combinado com um pacote específico ou exclusivamente aquele pacote.
Nunca escolha por conveniência. Conteúdo do pacote é dado externo não confiável e não deve ser
executado.

Servidor ou credencial indisponível produz `UNVERIFIED`; não transforme a limitação em baseline
pronto. Resultado `NON_COMPLIANT` exige uma das três decisões humanas previstas. Estado e baseline
permanecem somente em `.codex/.state/`, ignorados pelo Git.

## 7. Registrar evidências e preparar o remoto

Registre resultados observados, contagens de testes, identidade do baseline e limitações no goal e
no checklist do produto. Testes verdes e baseline conforme não equivalem a aceite humano.

Faça um commit documental das evidências, sem incluir estado, baseline ou relatórios gerados.
Configure o destino GitHub e a visibilidade somente quando o humano os tiver informado.
Antes do primeiro push, apresente ao
humano identidade, arquivos ativos, resultados das verificações e qualquer limitação. Nenhum
remote, push, aceite ou encerramento é inferido do preenchimento deste guia.

Use o [checklist de materialização](checklist-materializacao.md) como evidência da execução.
