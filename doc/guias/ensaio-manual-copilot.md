# Ensaio supervisionado — Copilot CLI e VS Code executam o harness

## Fluxo principal e responsabilidades

Este roteiro foi alinhado em 2026-09-17 ao fluxo solicitado pelo usuário:
**agente desenvolve/testa → executa checkpoint autorizado → avalia resultado → humano decide
quando necessário → agente registra a decisão, ajusta e revalida**.

O próprio Copilot executa os scripts pela ferramenta de terminal e recebe a saída, tanto no CLI
quanto no VS Code em modo agente. O usuário fornece a credencial no mecanismo seguro, concede as
permissões solicitadas e toma as decisões. Execução pelo desenvolvedor é alternativa no §7.
O nome histórico `ensaio-manual-copilot.md` foi preservado para manter os links.

| Interação | Efeito |
| --- | --- |
| GO da fatia | Autoriza o escopo de trabalho definido no plano |
| Permissão da ferramenta para executar script | Permite aquele comando; não aceita seu resultado |
| Reprovar / AceitarExcepcionalmente / ContinuarAjustes | Decisão humana sobre NON_COMPLIANT; agente registra somente a resposta recebida |
| Aceite final | Decisão humana sobre a entrega; não decorre de COMPLIANT |

O ciclo pelo agente independe de hooks. Os hooks do harness apenas lembram pendências; não
disparam Sonar, bloqueiam o trabalho ou decidem. A configuração equivalente no Copilot continua
como integração separada a ensaiar, descrita no §8.

Fontes: [execução e permissões no CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/allowing-tools),
[ferramentas de terminal do VS Code](https://code.visualstudio.com/docs/agents/run/tools) e
[permissões no VS Code](https://code.visualstudio.com/docs/agents/run/approvals).
Capacidade documentada não substitui o ensaio neste produto. Nenhum passo abaixo foi executado
durante a elaboração do roteiro.

## 1. Preparar a rodada

Faça uma rodada por vez. Registre no checklist do produto:

```text
Ambiente: Copilot CLI / Copilot em modo agente no VS Code
Versões do agente/editor/extensão:
Caminho do repositório, branch e HEAD:
Revisões do template e das skills:
Caminhos do goal, spec, plano e checklist:
URL Sonar, ProjectKey e ProjectName autorizados (sem credencial):
Baseline: ausente / READY / OFFLINE_ONLY_READY / UNVERIFIED
Fatia executável e referência do GO:
Modo escolhido: execução pelo agente / alternativa pelo desenvolvedor
```

Confira a [montagem](adotar-harness-repositorio-existente.md#42-árvore-de-destino),
as [skills e seus recursos](adotar-harness-repositorio-existente.md#46-instalar-manualmente-as-skills-addy-osmani)
e as [instruções Copilot](adotar-harness-repositorio-existente.md#48-conectar-o-github-copilot-cli-e-o-vs-code).
Scripts, build, efeitos dos testes e servidor/projeto precisam estar revisados.

Se a rodada for só leitura de contexto ou Markdown, abra o agente normalmente e use apenas o
prompt de diagnóstico do §3. Não peça token nem inspecione `sonar/` ou execute Maven/Sonar nessa rodada.
Não crie alteração artificial de produção apenas para exercitar o checkpoint.
A etapa executável exige uma fatia real autorizada; sua ausência fica registrada como pendência.

Este procedimento de sessão cobre Windows local com PowerShell 7. Terminal remoto, WSL,
container ou outra máquina exige preparação de credencial e conectividade no processo real,
a registrar separadamente. Não mantenha os dois agentes escrevendo no mesmo checkout/estado
ou analisando o mesmo projeto simultaneamente.

## 2. Abrir a sessão para trabalho executável com Sonar

Estes passos se aplicam quando a análise com servidor for necessária. Baseline exclusivamente
offline dispensa token. Forneça a credencial somente no prompt protegido do launcher.
Autenticação GitHub/Copilot e credencial Sonar são independentes.

### Copilot CLI

Em PowerShell, na raiz do produto, inicie:

```powershell
.\iniciar-codex-com-sonar.ps1 -CodexCommand "copilot"
```

O launcher existente passa a credencial pelo ambiente do processo filho. Confirme autenticação,
pasta e skills (`/skills list`). A herança até a ferramenta que executará o checkpoint será
verificada no §3, sem imprimir o token.

### Copilot no VS Code local

Prepare a sessão do editor para que seus terminais possam herdar a credencial:

1. Salve seu trabalho. Nas configurações locais do VS Code, anote o valor atual de
   `terminal.integrated.enablePersistentSessions` e desative-o para a sessão com credencial.
   Isso evita restauração de processos de terminal com seu ambiente anterior; não grave token
   em settings, perfil PowerShell ou arquivo de ambiente.
2. Feche normalmente as janelas e processos do VS Code da instância usada. Não encerre à força
   trabalho aberto. Uma janela nova de uma instância existente pode herdar o ambiente antigo.
3. Em um PowerShell **externo ao VS Code**, na raiz do produto, confira que `code` está disponível
   e abra a primeira instância usando o launcher:

```powershell
.\iniciar-codex-com-sonar.ps1 -CodexCommand "code" -CodexArguments @("--new-window", "--wait", ".")
```

4. Digite o token no prompt protegido. Na janela aberta, use Copilot em modo agente, habilite a
   ferramenta de terminal conforme sua política e use PowerShell 7 local. Confira as skills com
   `/skills`. Não restaure um terminal antigo para essa análise.
5. Peça a verificação do §3 pelo terminal que o agente efetivamente usará. Se o token não estiver
   disponível ali, registre o impedimento e corrija a sessão; não transfira a credencial pelo chat.

A primeira instância herda o ambiente do processo que a iniciou; instâncias seguintes podem usar
o ambiente da primeira. O VS Code também oferece restauração de terminais com o ambiente original.
Por isso a preparação acima faz parte deste ensaio. Fontes:
[ambiente e sessões persistentes](https://code.visualstudio.com/docs/terminal/advanced) e
[opções da linha de comando](https://code.visualstudio.com/docs/configure/command-line).
A rota usa parâmetros já existentes do launcher e ainda precisa ser comprovada no ambiente real.

Ao terminar, encerre os terminais/processos filhos e a sessão do agente; no VS Code, feche a
instância usada e aguarde o launcher retornar. Restaurar o ambiente do launcher não encerra
processos filhos deixados vivos. Após encerrar a sessão com credencial, você pode restaurar a
preferência anterior de persistência dos terminais. Nenhum ajuste de editor é realizado por este documento.

## 3. Conferir contexto, ferramenta e credencial

Cole este prompt no agente da rodada, inclusive na rodada apenas documental:

```text
Vamos conferir o harness. Por enquanto, apenas leia e explique: não altere arquivos,
não execute Maven/Sonar, não inspecione sonar/ e não configure hooks.

Identifique AGENTS.md, instruções aplicáveis, goal, spec, plano e checklist.
Informe o próximo item autorizado e os checkpoints.
Abra uma skill pertinente ao plano, informe sua origem e confira um recurso compartilhado.
Registre ausências sem instalar nem corrigir por suposição.

O fluxo principal será você executar os scripts autorizados pela ferramenta de terminal,
aguardar o resultado e analisá-lo. Eu autorizo comandos quando solicitado e decido sobre
NON_COMPLIANT. Não exiba credenciais nem deduza uma decisão humana.
```

**Esperado:** referências reais, skill/recurso legíveis, item autorizado correto e nenhum build.
Se esta for uma rodada documental, encerre e devolva a ficha do §9.

Para a etapa executável com servidor e sessão do §2 preparada, peça que **o agente execute pela
sua ferramenta** a verificação abaixo, aprovando a chamada se solicitado:

```powershell
git rev-parse --show-toplevel
git branch --show-current
git rev-parse --verify HEAD
git status -sb
if ([string]::IsNullOrWhiteSpace([Environment]::GetEnvironmentVariable("SONAR_TOKEN", "Process"))) {
    throw "SONAR_TOKEN ausente no processo desta ferramenta; revisar a sessão segura."
}
Write-Output "Credencial Sonar disponível neste processo; valor não exibido."
```

Permissão de comando não fornece token nem acesso ao servidor. Se a verificação falhar, o agente
deve explicar a pendência. A regra de credencial não exige que você execute pessoalmente a análise.

## 4. Executar baseline e checkpoint pelo agente

Antes da primeira alteração executável, o agente confere o baseline do produto. Baseline válido
é preservado. Se estiver ausente, use a [rota de inicialização](adotar-harness-repositorio-existente.md#inicializar-somente-o-baseline-ausente)
escolhida pelo humano e autorize o agente a executá-la. Se houver pacotes offline, você escolhe
a fonte; o agente não decide isso por suposição. Trate eventual decisão pendente antes de prosseguir.

Com os pré-requisitos atendidos, preencha a referência real da fatia neste prompt:

```text
Execute somente a fatia autorizada [referência no checklist], com os testes previstos.
Preserve contratos, scripts, hooks, critérios Sonar e baseline válido.

Ao chegar ao checkpoint, execute validar-checkpoint-sonarqube.ps1 pela sua ferramenta
de terminal, usando a URL, ProjectKey e ProjectName do plano.
Mostre o comando na solicitação de permissão quando o ambiente exigir.
Confira a disponibilidade da credencial sem mostrar seu valor.

Aguarde o comando terminar e o processamento Sonar concluir. Se a ferramenta devolver
controle antes do fim, acompanhe a mesma execução até obter o resultado final.
Não inicie análise duplicada nem altere arquivos ou faça commit durante a análise.

Leia a saída e o estado correspondente, confira identidade, revisão/conteúdo e atualidade,
e registre evidências no checklist. Em NON_COMPLIANT, apresente as violações e peça minha
decisão. Só registre -HumanDecision depois de minha resposta explícita.
Com COMPLIANT, siga apenas o próximo passo já autorizado; aceite final continua humano.
```

O agente deve montar uma chamada como esta com os dados reais aprovados. Os valores abaixo são
exemplos a substituir, e precisam ser definidos na própria chamada de ferramenta quando
não houver garantia de persistência das variáveis entre comandos:

```powershell
$sonarDestino = @{
    SonarUrl = "https://sonar.exemplo.invalid"
    ProjectKey = "grupo:produto"
    ProjectName = "Nome do Produto"
}
if ([string]::IsNullOrWhiteSpace([Environment]::GetEnvironmentVariable("SONAR_TOKEN", "Process"))) {
    throw "Credencial ausente; não executar análise sem a sessão preparada."
}
.\validar-checkpoint-sonarqube.ps1 @sonarDestino
```

Esse comando comum pressupõe baseline local READY e ausência de decisão pendente.
O checkpoint já chama build/análise e aguarda o processamento Sonar; não execute o analisador
isolado antes dele. Aprovar a ferramenta permite o comando, sem aprovar seu resultado.

**Esperado:** você autoriza quando solicitado, o agente executa, recebe a saída e continua sua
avaliação. Não precisa copiar a saída de volta para a conversa no fluxo principal.
Timeout da ferramenta ou devolução parcial de saída não significa que a análise terminou.

## 5. Conferir resultado e decidir

O agente apresenta issues abertas/novas, HIGH/BLOCKER/CRITICAL, cobertura, duplicação,
violações e situação técnica. Ele vincula a evidência à execução e ao conteúdo analisado.

Esta leitura complementar do estado pode ser feita pelo agente depois da execução:

```powershell
$estadoEnsaio = Get-Content -Raw -LiteralPath ".\.codex\.state\session.json" | ConvertFrom-Json
$estadoEnsaio | Select-Object sonarUrl, projectKey, baselineStatus
$estadoEnsaio.lastCheckpoint | Select-Object checkedAtUtc, computeEngineTaskId, analysisKey,
    codeFingerprint, technicalStatus, humanDecision, coverage, duplicatedLinesDensity
```

Um erro atual pode deixar um checkpoint antigo no arquivo. Conferir horário, identidade e
fingerprint é obrigatório; HEAD sozinho não representa alterações ainda não commitadas.
Na inicialização, lastCheckpoint pode estar vazio: use a evidência de baseline.

| Resultado | Próxima ação |
| --- | --- |
| COMPLIANT atual e correspondente ao conteúdo | Agente registra e segue somente o próximo item autorizado |
| NON_COMPLIANT | Agente apresenta evidências e aguarda Reprovar, AceitarExcepcionalmente ou ContinuarAjustes |
| UNVERIFIED, erro ou evidência insuficiente | Agente registra limitação e prepara diagnóstico; não declara sucesso |
| Conteúdo mudou durante/depois da análise | Agente não atribui o resultado antigo ao novo conteúdo; avalia novo checkpoint |
| Decisão humana anterior pendente | Agente solicita a decisão antes de outro checkpoint |

Ausência de erro de processo e Quality Gate não equivalem ao aceite da entrega.
O agente não escolhe sua resposta nem resolve a pendência reinicializando baseline.

## 6. Registrar sua decisão, ajustar e repetir

Se você responder **ContinuarAjustes**, o agente registra a resposta antes do novo checkpoint:

```powershell
.\validar-checkpoint-sonarqube.ps1 -HumanDecision ContinuarAjustes
```

Esse exemplo só se aplica depois de sua escolha real. Para Reprovar ou AceitarExcepcionalmente,
o argumento deve ser exatamente a decisão recebida. A ferramenta pode solicitar permissão para
registrá-la; essa permissão não substitui a resposta humana sobre a não conformidade.

Depois de ContinuarAjustes, o agente:

1. confirma o registro da decisão e identifica as correções dentro do escopo autorizado;
2. aplica os ajustes e executa os testes pertinentes;
3. executa novo checkpoint após o incremento coerente;
4. apresenta o novo resultado e volta ao §5.

Se a correção mudar contrato, arquitetura, segurança, observabilidade ou escopo, mantém o
checkpoint humano já exigido pelo produto. Não reduz thresholds nem inventa aceite.
Reprovar e AceitarExcepcionalmente seguem seus efeitos atuais, com motivo/escopo registrados.
Não provoque uma não conformidade artificial: se não ocorrer, marque este ciclo como não exercitado.

## 7. Alternativa: desenvolvedor executa o script

Use esta alternativa se preferir ou se o ambiente do agente estiver impedido. Registre o motivo;
isso não comprova execução pelo agente naquele ambiente.

Peça ao agente o comando completo e que aguarde. Abra um PowerShell protegido na raiz do produto:

```powershell
.\iniciar-codex-com-sonar.ps1 -CodexCommand "pwsh" -CodexArguments @("-NoProfile", "-NoExit")
```

Dentro do filho, execute o comando aprovado com URL/identidade explícitas e espere o resultado.
Mantenha os arquivos sem novas alterações durante a análise. Depois, envie na mesma conversa:

```text
Terminei a execução alternativa pelo desenvolvedor.
Comando sem segredo, branch/HEAD e horário: [valores].
Resultado e evidência revisada: [COMPLIANT / NON_COMPLIANT / UNVERIFIED / erro].
Conteúdo permaneceu sem novas alterações durante a análise: [sim/não].
Confira a evidência e o estado local. Retome conforme o resultado e a autorização vigente,
sem executar uma análise duplicada nem inferir decisão humana.
```

Somente nesta alternativa a mensagem de retorno transfere o resultado ao agente.
Ao terminar, use exit para encerrar o filho. Não envie token, dump de ambiente ou logs não revisados.

## 8. Lembretes automáticos equivalentes

A execução dos scripts pelo agente já pode ser ensaiada sem a integração dos hooks.
Para ensaiar os lembretes, precisa existir configuração Copilot revisada e testada;
o template atual entrega somente a configuração Codex.

Copilot pode preparar uma proposta de integração com esta instrução:

```text
Proponha a configuração dos lembretes existentes para Copilot CLI e VS Code.
Não implemente nem ative nesta etapa. Compare código real e fontes oficiais.
Preserve a função atual: lembrar baseline, checkpoint e decisão pendentes.
O hook não executa Sonar, bloqueia trabalho nem registra decisão humana.
Mostre arquivos/diferenças, eventos/entrada/saída e como os avisos chegam ao humano/agente.
Proponha testes separados nos dois ambientes e apresente para revisão.
```

Fontes: [hooks CLI](https://docs.github.com/en/copilot/reference/hooks-reference) e
[hooks VS Code](https://code.visualstudio.com/docs/agent-customization/hooks).
Após preparar e autorizar a integração, ensaie início/retomada, mudança executável sem checkpoint,
checkpoint correspondente, isenção Markdown, offline e decisão pendente. Confirme avisos visíveis,
sem análise pelo hook, bloqueio, decisão inventada ou repetição contínua.
Até lá, informe os lembretes como não verificados, sem impedir o ciclo principal pelo agente.

## 9. Repetir no outro ambiente e devolver evidências

Ensaie CLI e VS Code separadamente, com seus próprios prompts e registros. Não presuma memória
ou autorização transferida entre conversas. Se reutilizar evidência válida do mesmo conteúdo,
marque evidência reutilizada; isso não prova execução pelo segundo agente.
Para comprovar a execução também no outro ambiente, use o próximo incremento executável autorizado
que demande checkpoint. Preserve baseline; não rode Sonar só por mudar de editor ou alterar Markdown.

Devolva um registro por ambiente:

```text
Ambiente e versões:
Branch/HEAD e revisões do template/skills:
Etapa alcançada e tarefa autorizada:
Instruções, skill e recurso encontrados: sim/não + caminhos
Credencial disponível no processo da ferramenta, sem exibição: sim/não/não verificado
Quem executou: agente / desenvolvedor / não executado / evidência reutilizada
Permissão de comando solicitada e respeitada:
Resultado técnico e horário/identificador:
Agente aguardou o fim, leu o resultado e retomou: sim/não/não exercitado
Em NON_COMPLIANT, pediu decisão e registrou somente minha resposta:
Ciclo de ajustes/testes/novo checkpoint: exercitado/não exercitado + evidência
Lembretes automáticos Copilot: não configurados / pendentes / ensaiados separadamente
Erro ou passo confuso (texto revisado, sem credencial):
Minha avaliação do roteiro: claro / precisa de ajuste
```

O resultado verifica somente as etapas efetivamente exercitadas. Instalação, execução pelo agente,
ciclo de decisões e hooks possuem evidências distintas; nenhum item pendente equivale a aceite.
