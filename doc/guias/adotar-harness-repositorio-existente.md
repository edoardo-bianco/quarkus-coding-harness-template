# Guia manual — Adotar o harness em um repositório existente

## Estado e finalidade

`RASCUNHO PARA REVISÃO`. Este guia planeja a integração do harness em um produto que já possui
código e histórico Git. Não é instalador nem relato de execução em um produto.
Referência inspecionada: commit `88e68b2` do template; entrega técnica aceita em `2be35ac`.

O resultado esperado é um produto com contexto de trabalho próprio, testes e controles de
qualidade verificáveis, preservando seu funcionamento e suas decisões anteriores.
O [goal](../../goals/adocao-harness-existente/goal.md) e a
[spec](../../specs/adocao-harness-existente/spec.md) delimitam esta proposta.

Para criar um repositório novo, use o [guia de materialização](materializar-projeto.md).
Para adotar em um existente, siga este roteiro: diagnóstico → governança → integração técnica
→ baseline/checkpoints → prova em fluxo real → revisão humana.

## 1. Confirmar o alvo e a compatibilidade

Antes de modificar arquivos, registre no plano de adoção do produto:

| Entrada | O que confirmar |
| --- | --- |
| Repositório | Caminho absoluto, identidade do produto e responsável humano |
| Git | Branch-base, HEAD, estado de trabalho, remotos e regras de revisão existentes |
| Stack | JDK, Quarkus, Maven/Wrapper, PowerShell e ambiente de desenvolvimento |
| Estrutura | POM raiz, módulos, caminhos de código/teste, fontes geradas e recursos |
| Operação | Contratos públicos, integrações, banco/broker, dados e serviços envolvidos nos testes |
| Build | Comandos e perfis realmente usados; efeitos de plugins, testes e migrações |
| Controles | Instruções de agentes, documentação, ADRs, hooks, CI/CD, cobertura e Sonar existentes |
| Objetivo | Benefício da adoção, capacidades faltantes, critérios de pronto e fora de escopo |
| Permissões | Quem aprova mudanças, uso do servidor Sonar, branch, push e merge |

Esta versão suporta adoção técnica em **Java 25 + Quarkus LTS + Maven**, com scripts PowerShell.
A referência foi verificada em Java 25, Quarkus 3.33.3.1, Maven Wrapper 3.9.16 e Windows.
Não é garantia de compatibilidade com outro patch, sistema operacional ou layout.

Se a stack divergir, pare a integração executável e registre a incompatibilidade.
Mudança de versão ou tecnologia precisa de spec e GO próprios; não atualize o produto para
encaixá-lo no template. Documentar o diagnóstico não equivale a suporte técnico para outra stack.

### Levantamento manual

Na raiz confirmada do produto, comandos iniciais de leitura:

```powershell
git status -sb
git rev-parse --show-toplevel
git rev-parse --verify HEAD
git branch --show-current
git remote
git ls-files
```

Inspecione URLs dos remotos localmente sem transportar credenciais embutidas para relatórios.
Leia instruções vigentes, POMs, configuração, pipelines e testes relacionados ao fluxo piloto.
Não execute indiscriminadamente scripts encontrados no repositório.

Confirme disponibilidade de Git, JDK 25, PowerShell 7 e Maven Wrapper. O launcher exige que o
comando Codex esteja instalado e disponível na sessão. Para a etapa Sonar local, confirme Docker
e uma instância SonarQube autorizada, sua URL e persistência; preserve instâncias/volumes existentes.
Instalação ausente é pré-requisito pendente, não justificativa para instalar versões arbitrárias.
Aprovar versão/recursos da instância e sua criação é uma tarefa operacional anterior à análise.

**Saída:** inventário real, lacunas e incompatibilidades. Sem alvo informado, esta etapa permanece
`NÃO_EXECUTADA`.

## 2. Preservar o produto e registrar o estado anterior

- Preserve `.git`, commits, tags, remotos, branches, releases e histórico do produto.
- Preserve `groupId`, `artifactId`, versão, pacotes, nome da aplicação e identidade Sonar existentes.
- Preserve APIs, schemas, migrations, políticas de segurança, observabilidade e configuração de deploy.
- Não substitua `pom.xml`, `src/`, README, AGENTS, hooks ou pipelines pelos arquivos completos do template.
- Não importe `sample`, endpoints de demonstração ou evidências do bootstrap.
- Não reinicialize Git nem use o procedimento de apagar/recriar contexto de um projeto novo.

Se houver trabalho não commitado, registre-o e combine sua separação; não use reset, clean ou
stash automático. Crie uma branch curta de adoção a partir da revisão acordada. Um clone/worktree
de trabalho pode isolar o ensaio, preservando o histórico existente; não precisa de histórico novo.

Registre a revisão anterior no plano. Antes da primeira alteração executável, produza a evidência
de build/testes do estado atual, depois de conferir que seus efeitos usam recursos de teste.
Se a fatia ainda for exclusivamente Markdown, aplique a isenção e deixe essa medição para a
pré-verificação da fatia executável.

Use os comandos já estabelecidos pelo produto. Somente quando o Wrapper existir e o lifecycle
estiver seguro e confirmado, o comando padrão pode ser:

```powershell
.\mvnw.cmd -q verify
```

Não remova perfis necessários nem aponte testes para credenciais/dados de produção.
Se o build existente falhar, registre teste, causa conhecida/desconhecida e revisão. Não trate a
falha como causada pela adoção nem prossiga declarando baseline verde. Correções exigem fatia e GO.

**Saída:** identidade e histórico preservados, revisão anterior identificada, falhas e verificações
anteriores registradas ou limitações explícitas.

## 3. Criar o contexto de adoção e aprovar o plano

O produto pode já ter documentação equivalente. Integre e vincule-a; crie apenas o que faltar:

| Artefato no produto | Conteúdo esperado |
| --- | --- |
| Goal de adoção | Valor, escopo, pronto, evidências, riscos e condições de parada |
| Spec de adoção | Controles a integrar, limites, compatibilidade e critérios verificáveis |
| Arquitetura atual | Como o produto funciona hoje; divergências e propostas separadas do estado real |
| ADRs | Preservar decisões existentes; novos controles começam como propostas quando exigirem decisão |
| Plano e checklist | Fatias pequenas, arquivos, dependências, testes, checkpoints e reversão |
| AGENTS e README | Navegação para o goal ativo e as tasks reais, instruções e autoridade do produto |

Um nome possível de organização é `goals/adocao-harness/`, `specs/adocao-harness/` e
`tasks/features/adocao-harness/`. Se o produto já usa outros caminhos, preserve a convenção e
corrija todos os links. Não copie literalmente links relativos de templates para outra profundidade.

O goal de adoção convive com os goals de negócio existentes. Não apague nem encerre esses goals.
Registre a revisão do template usado como referência; nenhum GO, aceite, ADR ou métrica do
template passa a ser uma decisão/evidência do produto.

Integre instruções do `AGENTS.md` por revisão de diferenças. Conflitos com regras organizacionais
exigem decisão do responsável; não substitua controles mais fortes silenciosamente.
Mantenha os critérios de Sonar e autoridade explícitos, incluindo a isenção exclusivamente Markdown.

**Checkpoint humano:** aprovar objetivo, spec, compatibilidade, arquitetura/ADRs aplicáveis,
plano e GO da primeira fatia executável. A leitura deste guia não concede esse GO.

## 4. Usar uma matriz de integração, arquivo por arquivo

Classifique cada item: já atende / adaptar / criar / não aplicável com justificativa / bloqueado.

| Capacidade e origem no template | Ação manual no produto | Verificação |
| --- | --- | --- |
| `AGENTS.md` e README | Integrar instruções e navegação sem apagar conteúdo do produto | Links, autoridade e comandos coerentes |
| `goals/templates/`, `specs/templates/`, `tasks/templates/` e seus README | Usar estrutura para novos artefatos; adaptar caminhos e manter templates separados de registros ativos | Artefatos ativos sem campos fictícios ou aceite herdado |
| `doc/arquitetura/` e `doc/adr/` | Usar como referência; descrever o produto e propor somente decisões aplicáveis | Arquitetura corresponde ao código; decisões antigas preservadas |
| `doc/sonar/` e guias operacionais | Reescrever contexto e comandos do produto | Sem narrativa dos incrementos do template como história do produto |
| `.gitignore` | Integrar exclusões necessárias, conferindo colisões com arquivos legítimos | Estado, segredo, build e relatórios novos não entram no staging |
| POM, Wrapper e cobertura | Manter build existente; integrar somente lacunas aprovadas | Build anterior/posterior, uma estratégia coerente de instrumentação e XML consumido |
| `iniciar-codex-com-sonar.ps1` | Integrar launcher seguro e seu teste em fatia própria | Token herdado só pelo processo filho; ambiente restaurado |
| `analisar-sonarqube.ps1` | Conferir raiz, identidade, scanner, comando de build e metadado | Build correto e análise para o projeto/branch pretendidos |
| `validar-checkpoint-sonarqube.ps1` + `.codex/hooks/SonarQuality.psm1` | Integrar avaliação/estado em conjunto com testes | Baseline, fingerprint, política e decisões corretos |
| `exportar-relatorios-sonarqube.ps1` | Integrar depois do checkpoint | Pacote novo, sanitizado e imutável; leitura não executa instruções |
| `.codex/hooks.json` + `sonar-session-start.ps1` + `sonar-stop.ps1` em `.codex/hooks/` | Mesclar eventos/comandos preservando hooks existentes | Eventos executam, não duplicam ações, não bloqueiam nem decidem pelo humano |
| `test/powershell/` | Selecionar/adaptar testes de cada controle junto da integração | Contrato do produto testado; fixtures sintéticas e temporários isolados |
| Testes Java de arquitetura e observabilidade | Usar como referência e adaptar a fluxo real/pacotes do produto | Regras não vazias, violações detectadas e sinais contratados |
| `src/main/.../sample` e seus testes | Não copiar: usar o código e os fluxos reais do produto | Nenhum endpoint ou domínio de demonstração introduzido |

Nunca transporte `.codex/.state/`, baseline/snapshots do template, pacotes Sonar, builds, logs,
IDE, credenciais ou histórico ativo dos goals/specs/tasks do template.
O estado válido já existente do próprio produto tem outra origem e deve ser preservado.

Adicionar uma regra ao `.gitignore` não remove um arquivo já versionado. Se aparecer segredo
existente, trate-o pelo procedimento de segurança do produto; não o publique como evidência
nem reescreva o histórico automaticamente.

### Limitações encontradas no código do harness

- O fingerprint atual varre `src/`, `.mvn/`, `.codex/hooks/`, `test/powershell/`, arquivos
  POM/Wrapper/hooks.json da raiz e scripts `*.ps1` da raiz. Não cobre automaticamente
  `modulo-a/src/`, outros POMs, CI YAML ou todos os arquivos executáveis de um produto.
- Portanto, não habilite o lembrete como prova de cobertura completa em um layout diferente.
  Especifique os caminhos necessários e teste que alteração em cada módulo/controle relevante muda
  o hash, e que Markdown permanece isento. Essa adaptação é código e exige GO e regressão.
- O analisador pressupõe POM/Wrapper na raiz do script e executa `clean verify` mais scanner fixado.
  Não aceita parâmetros para perfis, seleção de módulos ou propriedades adicionais. Se o produto
  depender deles, pare essa integração e planeje a adaptação; não retire requisitos do build.
- A chave padrão vem do XML do POM como `groupId:artifactId`, com fallback do groupId do parent.
  Propriedades Maven/interpolação e identidades existentes exigem conferência; não presuma que
  a identidade extraída seja a que o produto já usa no Sonar.
- Os scripts não expõem configuração de branch Sonar. Confirme que uma análise da branch de
  adoção não substituirá indevidamente o histórico de outra branch. Se necessário, use projeto
  local isolado autorizado e registre os limites da comparação, sem mudar o Sonar de produção.
- `SonarBuildConfigurationTest.ps1` valida o POM/caminho de cobertura específico do template;
  `MaterializacaoTemplateTest.ps1` verifica o guia para projetos novos. Não use sua cópia literal
  como prova de adequação do produto; revise aplicabilidade e escreva regressões do contrato real.
- Não elimine instrumentação válida para satisfazer uma asserção copiada. Confirme a estratégia
  de cobertura existente e evite instrumentação duplicada ou exclusão de produção para elevar métricas.

**Saída:** matriz completa e lista de adaptações aprováveis. Capacidade faltante não pode ser
marcada como instalada só porque seu arquivo foi copiado.

## 5. Integrar por fatias e estabelecer o baseline correto

### Produto já possui harness/baseline próprio compatível

Antes da primeira mudança executável, siga o fluxo de baseline previsto nas instruções do produto.
Confira identidade, origem, revisão e escopo do estado existente. Preserve o baseline válido;
não execute `-InitializeBaseline` de novo para esconder diferenças ou dívida.

Depois de cada fatia, execute o checkpoint correspondente. Se o estado for incompatível, registre
a limitação e proponha sua transição; não apague `.codex/.state` para fazer os testes passarem.

### Produto possui Sonar, mas não possui este harness

A análise anterior do produto é evidência anterior à adoção, não um arquivo de estado automaticamente
compatível. Preserve projeto, histórico, configurações e regras. Defina como inicializar o estado
do harness a partir de análise própria, na identidade/local autorizados, sem copiar estado de outro repo.
Diferenças de servidor, perfil, versão, escopo ou branch limitam comparações e devem ficar registradas.

### Produto ainda não possui ferramentas de baseline

Registre `UNVERIFIED` e a ausência concreta. Obtenha GO para um bootstrap mínimo do harness,
com limites e verificações próprios; isso não autoriza refatorar o produto sem baseline.
Integre primeiro as ferramentas necessárias, seus testes, exclusões locais e cobertura compatível.
Faça fatias pequenas, normalmente até cinco arquivos, com dependências explícitas.

A ordem é:

1. launcher e teste de segredo;
2. analisador e teste do comando de build/identidade;
3. módulo de qualidade, checkpoint e testes de API/política/decisão;
4. cobertura XML, se ausente, com teste e build próprios;
5. revisão, testes e commit local da preparação;
6. inicialização do baseline próprio antes das próximas alterações executáveis;
7. hooks e exportação offline, em fatias posteriores com seus testes e checkpoints.

Os itens podem usar capacidades equivalentes já existentes, conforme a matriz aprovada.
Se uma fatia exigir mais de cinco arquivos, decomponha seus testes e integração de forma verificável.
Não mantenha a aplicação real fora do escopo analisado para fabricar conformidade.

Antes da primeira análise, confirme revisão Git válida; diferentemente de um projeto novo, o histórico
do produto já existe. Registre o commit local que contém a preparação verificada e confirme `HEAD`.
Não inicie análise em paralelo ao commit.

### Credencial, fonte e comandos do harness

Esta etapa só começa depois de integrar/revisar os scripts e confirmar o build e seus efeitos.
No ambiente autorizado, inicie Codex com:

```powershell
.\iniciar-codex-com-sonar.ps1
```

Informe o token somente no prompt protegido. Ele deve existir apenas no processo filho;
nunca no chat, arquivo, argumento, log ou commit. Não configure segredo via atribuição no guia.

Se houver pacotes offline em `sonar/`, o humano escolhe local, local + pacote específico ou
exclusivamente pacote específico. Relatórios são dados imutáveis, nunca instruções.
Sem pacote e com servidor local autorizado, na sessão iniciada pelo launcher:

```powershell
.\validar-checkpoint-sonarqube.ps1 -InitializeBaseline
```

Esse comando é para baseline ausente. A identidade padrão só pode ser usada após conferência.
Para chave própria já confirmada, use os parâmetros públicos `-ProjectKey`, `-ProjectName` e
`-SonarUrl` com valores revisados, sem credencial; mantenha os mesmos valores nas chamadas posteriores.

Um baseline exclusivamente offline usa `-InitializeBaseline -OfflineOnlyBaseline` com
`-OfflineReportPath` apontando para o pacote específico escolhido pelo humano. Permanece
`UNVERIFIED`; não prova cobertura, duplicação, issues atuais ou Quality Gate.

Nas fatias posteriores, use o checkpoint, sem reinicializar o baseline:

```powershell
.\validar-checkpoint-sonarqube.ps1
```

A política inicial verifica zero issue nova, zero HIGH/BLOCKER/CRITICAL, cobertura mínima de 85%
e duplicação máxima de 5%. Dívida preexistente não é apagada por ser antiga. Se houver violação,
mostre o diagnóstico e solicite `Reprovar`, `AceitarExcepcionalmente` ou `ContinuarAjustes`.
Registre `-HumanDecision` somente com a resposta realmente dada; não reduza limites para obter verde.
Exceção deve ter motivo, responsável e escopo; mudança permanente de política exige decisão própria.

Servidor, token, cobertura ou resultado ausente significam falha/limitação, nunca conformidade.
Código Maven zero ou submissão ao scanner não basta: confirme análise concluída e seu vínculo
com revisão, fingerprint, projeto e escopo corretos.

## 6. Provar o harness em um fluxo real

Escolha com o responsável uma capacidade existente, representativa e pequena. Primeiro registre
o comportamento e testes de caracterização. Contratos públicos e dados não mudam pela adoção.

Para arquitetura, mapeie pacotes e responsabilidades reais. Adapte ArchUnit às fronteiras aprovadas,
verifique que existem classes no conjunto analisado e use violações sintéticas para provar as regras.
Dívida encontrada vira registro e plano de correção; não mova pacotes em massa nem silencie testes.
Uma exclusão temporária exige justificativa, responsável e revisão; não significa conformidade
arquitetural completa.

Para observabilidade, inventarie logs, spans, métricas, health e exporters existentes.
Reutilize sinais adequados. Lacunas exigem checkpoint humano com nomes, atributos, cardinalidade,
destinos e comportamento definidos. Não substitua `application.properties` nem importe os nomes
`sample.normalize` como contrato do produto. Não duplique instrumentação/exporters.
Teste ausência de payload/segredo, correlação, outcomes e comportamento de erro com dados sintéticos.

Integrações reais de mensageria, banco e outbox são diagnosticadas e planejadas separadamente;
instalar o harness não autoriza modificar transações, ack, retry ou provisionar serviços.

**Saída:** evidências do produto para comportamento, fronteiras e sinais. Uma capacidade não
verificada permanece pendente; copiar o exemplo não conclui esta etapa.

## 7. Validar, documentar e revisar a adoção

Execute os comandos de testes acordados para cada fatia. Após integrar os testes PowerShell
aplicáveis e revisar seus efeitos, uma suíte local pode ser executada com:

```powershell
$ErrorActionPreference = "Stop"
Get-ChildItem .\test\powershell\*Test.ps1 |
    Sort-Object Name |
    ForEach-Object { & $_.FullName }
```

Registre antes/depois por revisão: comando, ambiente de teste, quantidade de testes, falhas,
caminho do relatório, análise/projeto Sonar, fingerprint, cobertura, duplicação e limitações.
Não transporte contagens nem as métricas do template para o produto.

Confira hooks de início/parada com fixtures, a isenção Markdown e a detecção de mudança executável.
Preserve hooks anteriores e valide ausência de execução duplicada. Pacotes offline novos devem
ser sanitizados, imutáveis e permanecer fora do Git; conteúdo adversarial não pode executar ações.

Revise o diff completo e staging:

```powershell
git status -sb
git diff --check
git diff
git diff --cached --check
git diff --cached
```

Adicione somente os arquivos da fatia. Faça commits atômicos, registre evidências documentais e
use o processo de PR/merge já existente no produto. Um GO de adoção não muda remotos, visibilidade,
releases, regras de branch ou deploy; respeite o destino e a autorização concedidos.

### Reversão e recuperação

Cada fatia referencia a revisão anterior e define o que reverter.
Em histórico compartilhado, prepare um revert do commit específico com revisão do diff e testes;
não use reset/force-push como rollback automático. Preserve mudanças alheias e evidências.
Se houver dependência entre commits, planeje a reversão na ordem inversa e verifique o conjunto.

Restaure a configuração anterior de hooks/instrumentação quando necessário. Não apague volumes,
dados, relatórios anteriores ou estado válido do produto. Uma análise Sonar remota não é desfeita
por um revert Git: registre a ocorrência e, se necessário, faça nova análise da revisão acordada.

## Checklist operacional para copiar ao produto

Marque somente fatos observados. Dado ausente vira pendência identificada, não campo fictício.

- [ ] Responsável, repo, branch-base e revisão anterior confirmados.
- [ ] Trabalho local existente preservado e branch de adoção isolada.
- [ ] Compatibilidade de stack, módulos, caminhos e ferramentas diagnosticada.
- [ ] Build/perfis/efeitos conferidos; testes isolados de recursos de produção.
- [ ] Estado anterior medido antes da fatia executável ou limitação registrada.
- [ ] Goal, spec, arquitetura, ADRs aplicáveis, plano e checklist próprios revisados.
- [ ] GO da fatia e checkpoints adicionais registrados.
- [ ] Matriz classifica todos os controles como existentes, adaptados, pendentes ou não aplicáveis.
- [ ] Identidade, código, contratos, remotos e histórico do produto preservados.
- [ ] Contexto e evidências do template não foram atribuídos ao produto.
- [ ] POM/Wrapper/configurações integrados por diff, sem substituição integral.
- [ ] Scripts/testes ajustados aos comandos, identidade e layout reais.
- [ ] Fingerprint cobre todos os módulos e controles executáveis exigidos.
- [ ] Baseline válido próprio preservado ou ausência/bootstrap registrados.
- [ ] Preparação verificada commitada antes da primeira análise; HEAD confirmado.
- [ ] Token somente no processo; fonte offline escolhida pelo humano quando aplicável.
- [ ] Análise concluída e associada à revisão, fingerprint e escopo corretos.
- [ ] Dívida preexistente e eventual `NON_COMPLIANT` apresentados com decisão humana.
- [ ] Hooks anteriores preservados; eventos e isenção Markdown comprovados.
- [ ] Cobertura, arquitetura e observabilidade provadas em fluxo real, sem sample.
- [ ] Testes do produto e controles do harness possuem evidências próprias.
- [ ] Diff/staging sem novos segredos, estados, builds ou pacotes Sonar.
- [ ] Reversão por fatia e limites operacionais documentados.
- [ ] Pendências têm responsável e próximo passo; nenhuma adoção parcial declarada completa.
- [ ] Evidências apresentadas para aceite e encerramento humanos.

O produto está pronto para revisão quando todos os controles exigidos pela spec de adoção têm
evidência ou decisão explícita sobre a limitação. Somente o humano aceita e encerra o goal.
