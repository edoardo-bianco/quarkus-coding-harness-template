# Ensaio humano — Copilot CLI e VS Code com o harness atual

## O que vamos verificar

Você executa o ensaio e devolve as evidências. Este roteiro foi preparado em 2026-09-17;
nenhum passo foi executado por sua elaboração. O comportamento dos scripts, dos hooks Codex,
dos critérios Sonar e da autoridade humana permanece o mesmo.

O fluxo combinado é:

1. Copilot lê o contexto e ajuda na tarefa autorizada.
2. Ao precisar de baseline ou checkpoint, prepara o comando e encerra sua resposta aguardando você.
3. Você executa o script no terminal seguro e espera o resultado completo.
4. Você envia uma nova mensagem com a evidência na mesma conversa.
5. Copilot confere o resultado e retoma somente o próximo passo já autorizado.

Neste roteiro, **aguardar** significa terminar a resposta e esperar uma nova mensagem sua.
Não deixar um comando do agente monitorando o terminal nem presumir retomada automática.

Há duas verificações distintas:

| Verificação | Condição atual |
| --- | --- |
| Instruções, skills e fluxo acima no CLI/VS Code | Pode ser ensaiado após a montagem manual e os pré-requisitos |
| Lembretes automáticos equivalentes aos do Codex | Integração Copilot ainda precisa ser preparada e testada; veja §8 |

Configurar lembretes equivalentes é uma adaptação de integração possível. O teste manual não
comprova que esses hooks estão instalados. A futura configuração deve manter o papel de lembrete,
sem disparar Sonar, bloquear o trabalho ou decidir aprovação.

A montagem de pastas, arquivos e skills está no [guia de adoção](adotar-harness-repositorio-existente.md).
Este roteiro acrescenta a sequência do ensaio; não substitui a montagem.

## 1. Preencher a ficha e conferir a montagem

Registre no checklist do produto:

```text
Ambiente da rodada: Copilot CLI / Copilot no VS Code
Caminho do repositório:
Branch e HEAD:
Versão do Copilot CLI ou VS Code + extensão:
Revisões do template e das skills:
Caminhos do goal, spec, plano e checklist do produto:
URL Sonar, ProjectKey e ProjectName autorizados (sem credencial):
Situação do baseline: ausente / READY / OFFLINE_ONLY_READY / UNVERIFIED
Próxima fatia autorizada e referência do GO, se houver:
```

Confira a [árvore e a cópia dos arquivos](adotar-harness-repositorio-existente.md#42-árvore-de-destino),
as [skills e referências compartilhadas](adotar-harness-repositorio-existente.md#46-instalar-manualmente-as-skills-addy-osmani)
e as [instruções Copilot](adotar-harness-repositorio-existente.md#48-conectar-o-github-copilot-cli-e-o-vs-code).
Capacidade ausente vira pendência; não peça ao agente para instalar ou corrigir tudo implicitamente.

Faça uma rodada por vez no mesmo checkout. Não mantenha CLI e VS Code alterando arquivos,
executando checkpoints ou escrevendo o mesmo estado simultaneamente.

Para começar, basta testar a leitura do contexto. A etapa com Sonar exige scripts/build revisados,
servidor/projeto autorizados e uma necessidade executável real. Revisão somente Markdown permanece
isenta: não crie mudança artificial nem execute Sonar para tornar esse teste mais completo.

## 2. Abrir o agente e conferir contexto

**Copilot CLI:** abra um terminal na raiz do produto, inicie `copilot`, autentique-se se necessário
e use `/skills list` para conferir descoberta.

**VS Code:** abra a mesma pasta do produto, use uma conversa Copilot em modo agente, confira as
instruções carregadas e use `/skills` para conferir as skills. Registre a versão da extensão.

As instruções de skills estão nas fontes de [Copilot CLI](https://github.com/addyosmani/agent-skills/blob/main/docs/copilot-cli-setup.md)
e [VS Code](https://code.visualstudio.com/docs/agent-customization/agent-skills).
As duas conversas devem receber seus próprios prompts. Não presuma transferência automática
de conversa, autorizações ou memória entre CLI e VS Code.

Cole este prompt no ambiente da rodada:

```text
Vamos ensaiar o harness preservando seu comportamento atual.
Nesta etapa, apenas leia e explique: não altere arquivos, não execute Maven/Sonar,
não inspecione sonar/, não solicite token e não configure hooks.

Identifique AGENTS.md e as demais instruções aplicáveis, goal, spec, plano e checklist.
Informe o próximo item autorizado e onde precisa parar.
Abra uma skill pertinente à revisão do plano, informe seu caminho e confira um recurso
compartilhado referenciado por ela. Se faltar algo, registre a ausência sem instalar.

Nos próximos passos deste ensaio, eu executarei manualmente os scripts Sonar.
Você deve preparar o comando exato, explicar o resultado esperado e encerrar sua resposta
aguardando minha mensagem. Não execute o comando, não monitore em segundo plano
e não trate ausência de resposta como aprovação.
```

**Esperado:** caminhos reais, referências legíveis e próximo passo correto; nenhuma execução
Sonar, instalação ou alteração de arquivo. Informe-me qualquer divergência antes de continuar.
Se só deseja testar leitura e skills, encerre aqui e devolva a ficha do §7.

## 3. Preparar o ponto de passagem para o desenvolvedor

Esta etapa corresponde a uma fatia executável real já autorizada no produto.
Se não houver uma, mantenha-a `NÃO_EXECUTADA`; o teste inicial não autoriza criar uma feature.

Antes da primeira alteração executável, o agente deve conferir a situação do baseline.
Se estiver ausente, deve preparar o comando de inicialização e aguardar sua execução.
Preserve baseline válido. Se houver pacotes offline, a fonte é escolhida por você.
As três rotas estão em [inicialização de baseline](adotar-harness-repositorio-existente.md#inicializar-somente-o-baseline-ausente).
Não reinicialize baseline apenas para mudar de agente ou limpar uma pendência.

Após cumprir essa pré-condição, use este prompt, preenchendo a referência da tarefa autorizada:

```text
Trabalhe somente na fatia autorizada identificada no checklist: [referência real].
Siga os testes e checkpoints já previstos. Preserve scripts, hooks e política do harness.
Se houver pré-condição pendente, pare e explique antes de alterar arquivos.

Ao chegar ao checkpoint Sonar, não o execute. Informe:
- raiz do repositório, branch e HEAD;
- arquivos alterados e testes já realizados;
- URL, ProjectKey e ProjectName do plano;
- comando PowerShell completo para eu executar;
- qual saída devo conferir e qual será o próximo passo autorizado.

Registre a pendência no checklist documental e encerre sua resposta com
AGUARDANDO_EXECUCAO_HUMANA_DO_CHECKPOINT.
Não altere mais arquivos nem faça commit enquanto eu executar a análise.
```

A frase final é um marcador de conversa, sem criar novo status nos scripts.
O comando esperado para baseline é diferente do checkpoint comum. Confirme qual foi pedido.

## 4. Desenvolvedor executa no terminal seguro

Use outro terminal PowerShell 7 na raiz do produto; pode ser um terminal integrado do VS Code.
O terminal deve permanecer sob seu controle, sem execução simultânea pelo agente.

Após a revisão do build e autorização de análise descritas no guia, execute:

```powershell
.\iniciar-codex-com-sonar.ps1 -CodexCommand "pwsh" -CodexArguments @("-NoProfile", "-NoExit")
```

Digite o token somente no prompt protegido do launcher. O PowerShell filho que fica aberto é
o terminal dos próximos comandos. O agente pode permanecer em sua própria conversa sem token.
O nome do launcher não obriga usar Codex; o parâmetro de processo filho já existe.

**Dentro do filho**, confirme a pasta, branch e revisão:

```powershell
git rev-parse --show-toplevel
git branch --show-current
git rev-parse --verify HEAD
git status -sb
```

Compare com o pedido do agente. Não altere arquivos, faça checkout ou commit durante a análise.

Defina os três dados públicos aprovados; substitua todos os valores de exemplo:

```powershell
$sonarDestino = @{
    SonarUrl = "https://sonar.exemplo.invalid"
    ProjectKey = "grupo:produto"
    ProjectName = "Nome do Produto"
}
```

Se o pedido for **inicializar baseline ausente**, execute somente a rota escolhida no §3 e
devolva o resultado ao agente antes de qualquer alteração executável.

Se o pedido for **checkpoint**, com baseline local READY e sem decisão humana pendente, execute:

```powershell
.\validar-checkpoint-sonarqube.ps1 @sonarDestino
```

Aguarde o script terminar e o prompt voltar. Ele já chama build/análise e espera o processamento
Sonar. Não execute o analisador isolado antes dele nem inicie outra análise paralela.

Confira as linhas finais: issues abertas/novas, HIGH/BLOCKER/CRITICAL, cobertura, duplicação,
violações e situação técnica. Mensagem de indisponibilidade, exceção ou UNVERIFIED não comprova análise.
Ausência de erro de processo também não comprova conformidade.

Anote horário e resultado desta execução. Um checkpoint anterior pode permanecer no arquivo de
estado se a execução atual falhar; não o apresente como resultado novo.
Para ajudar a identificar o checkpoint, após uma execução concluída, esta leitura seleciona
somente campos técnicos do estado local:

```powershell
$estadoEnsaio = Get-Content -Raw -LiteralPath ".\.codex\.state\session.json" | ConvertFrom-Json
$estadoEnsaio | Select-Object sonarUrl, projectKey, baselineStatus
$estadoEnsaio.lastCheckpoint | Select-Object checkedAtUtc, computeEngineTaskId, analysisKey,
    codeFingerprint, technicalStatus, humanDecision, coverage, duplicatedLinesDensity
```

Para inicialização, `lastCheckpoint` pode estar vazio: use a saída do baseline, sem inventar
um checkpoint. A leitura acima é complementar e não substitui o resultado da execução.
Nunca cole token, dump de ambiente ou logs completos sem revisão.

## 5. Desenvolvedor devolve o resultado; agente retoma

Volte à **mesma conversa** que aguardou e cole, preenchendo os campos com fatos:

```text
Terminei a execução humana solicitada.
Ambiente desta rodada: [CLI ou VS Code].
Comando executado: [comando sem segredo].
Branch e HEAD: [valores].
Horário da execução: [valor].
Arquivos permaneceram sem novas alterações durante a análise: [sim/não].
Resultado: [COMPLIANT / NON_COMPLIANT / UNVERIFIED / erro].
Evidência: [linhas finais revisadas, análise/CE/horário quando disponíveis].

Retome pela conferência desta evidência e do estado local, sem executar Sonar novamente.
Confira URL/projeto, atualidade do resultado e vínculo com o conteúdo analisado.
Não aprove, reinicialize baseline, configure hooks nem corrija pendências por suposição.
Atualize o checklist documental. Se não houver impedimento, identifique e execute apenas
o próximo passo que já estiver autorizado. Se faltar autorização, apresente esse passo e pare.
```

**Esperado conforme o resultado:**

| Resultado observado | Ação esperada do agente |
| --- | --- |
| COMPLIANT com evidência atual e conteúdo correspondente | Registrar; seguir somente o próximo passo autorizado; aceite final continua humano |
| NON_COMPLIANT | Apresentar violações e aguardar sua escolha entre Reprovar, AceitarExcepcionalmente e ContinuarAjustes |
| UNVERIFIED, erro ou evidência antiga/incompleta | Registrar limitação, explicar impedimento e preparar orientação; não declarar sucesso |
| Código alterado durante/depois da análise | Não aplicar o resultado ao novo conteúdo; avaliar necessidade de novo checkpoint |
| Execução informou pendência de decisão anterior | Resolver a decisão com o humano antes de outro checkpoint |

Se houver decisão humana, você a informa explicitamente. Para registrá-la no terminal,
conforme o fluxo atual:

```powershell
$decisaoEnsaio = Read-Host "Sua decisão: Reprovar, AceitarExcepcionalmente ou ContinuarAjustes"
.\validar-checkpoint-sonarqube.ps1 -HumanDecision $decisaoEnsaio
```

Esse comando registra uma decisão; não executa outra análise nem muda a situação técnica.
Devolva a confirmação ao agente. Ao terminar os comandos Sonar, use `exit` para encerrar o
PowerShell filho e permitir que o launcher restaure o ambiente anterior.

Não há retomada automática por término do Sonar neste ensaio. Você envia a mensagem de retorno;
o agente então lê a evidência e retoma a conversa. Se perder a sessão, abra outra e forneça
goal/checklist/branch/HEAD e o registro da pendência, antes de pedir continuidade.

## 6. Repetir no outro ambiente

Comece, por exemplo, no CLI; depois confira a leitura do contexto e a retomada no VS Code.
Use outra conversa, o mesmo contexto documental e nenhuma escrita simultânea.

Se o código continua igual e o checkpoint é atual, o outro agente pode conferir essa evidência.
Marque `EVIDÊNCIA_REUTILIZADA`, não uma execução nova naquele ambiente.
Para ensaiar também a execução humana solicitada pelo segundo agente, use o próximo incremento
executável autorizado que demande checkpoint. Não reinicialize baseline ou rode Sonar por mudança
somente Markdown. Cada rodada informa exatamente o que foi e o que não foi exercitado.

## 7. O que devolver para revisão

Envie um registro por ambiente, inclusive se parar antes da análise:

```text
Ambiente e versões:
Branch/HEAD e revisões do template/skills:
Etapa alcançada:
Instruções e skill/recurso compartilhado encontrados: sim/não + caminhos
Agente preparou comando e aguardou: sim/não/não exercitado
URL/projeto do comando corretos: sim/não/não exercitado
Execução humana: executada / não executada / evidência reutilizada
Resultado técnico e horário/identificador, quando disponíveis:
Agente conferiu a evidência e retomou corretamente: sim/não/não exercitado
Algum arquivo/hook/política foi alterado indevidamente:
Erro ou passo confuso (texto revisado, sem credencial):
Lembretes automáticos Copilot: não configurados / pendentes / ensaiados separadamente
Minha avaliação do roteiro: claro / precisa de ajuste
```

Sem evidência, mantenha o item pendente. O teste manual bem-sucedido comprova a passagem entre
agente e desenvolvedor, não toda a adoção, equivalência dos hooks ou aceite do produto.

## 8. Como incluir os lembretes automáticos sem mudar sua função

Esta parte continua no objetivo de integração. Ela depende de uma configuração Copilot revisável
e de ensaios no runtime: o template atual entrega somente a configuração de hooks Codex.

Copilot pode ajudar a preparar essa configuração. O primeiro pedido deve produzir uma proposta
de arquivos e testes, preservando a função de lembrete:

```text
Prepare uma proposta para conectar Copilot CLI e VS Code aos lembretes existentes do harness.
Não implemente nem ative nada nesta etapa. Inspecione os hooks reais e as fontes oficiais.

Preserve exatamente a função atual: lembrar baseline, checkpoint e decisão pendentes.
Não execute Sonar no hook, não bloqueie trabalho, não registre decisão humana automaticamente.
Não altere thresholds, fingerprint, scripts de análise ou política sem apontar a necessidade.

Mostre arquivos e diferenças necessárias, compatibilidade de eventos/entrada/saída,
como o aviso chega ao humano/agente e testes separados para CLI e VS Code.
Registre limitações e apresente o plano e o diff proposto para revisão antes da ativação.
```

A configuração pode aproveitar compatibilidade entre os agentes, mas precisa verificar caminhos,
eventos, valores de entrada e formato de resposta. Fontes oficiais:
[hooks Copilot CLI](https://docs.github.com/en/copilot/reference/hooks-reference) e
[hooks VS Code](https://code.visualstudio.com/docs/agent-customization/hooks).

Após preparação e autorização da integração executável, o ensaio dos lembretes deve comprovar:
início/retomada de sessão; pendência real após mudança executável; ausência da pendência após
checkpoint correspondente; isenção Markdown; estado offline; decisão humana pendente; avisos
visíveis; nenhuma análise automática, bloqueio, decisão inventada ou repetição contínua.

Enquanto isso não for executado nos dois ambientes, registre `HOOKS_COPILOT_NÃO_VERIFICADOS`.
Esse rótulo pertence ao relatório do ensaio; não modifica os estados do harness.
