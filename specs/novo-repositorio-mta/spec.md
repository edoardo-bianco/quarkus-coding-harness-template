# Especificação — Harness independente JBoss EAP

> Continuidade transferida para C:\desenvolvimento\repositorio\jboss-eap-copilot-harness-template,
> branch chore/bootstrap-jboss-harness. Este documento preserva a referência da origem;
> os artefatos de construção ativos pertencem ao novo checkout.

- Estado: `REFERENCIA_H00_TRANSFERIDA`; proposta preservada, sem aprovação global inferida.
- H01A autorizado por “Autoriza o H01A” em 2026-09-21 e materializado no novo destino.
- Spec canônica da construção: `specs/preparacao-harness/spec.md` no checkout JBoss indicado abaixo.
- Data: 2026-09-21.
- Goal: [novo-repositorio-mta](../../goals/novo-repositorio-mta/goal.md).
- Requisitos recebidos: [prompt original](../../goals/novo-repositorio-mta/origem/prompt-codex-criar-novo-repositorio-template-jboss-eap-main-arquitetura-preserv.md).
- Diagnóstico, proposta de arquitetura e sequência: [plano H00–H07](../../tasks/features/novo-repositorio-mta/plan.md).
- Decisões e evidências: [checklist](../../tasks/features/novo-repositorio-mta/todo.md).

## Resultado e limites

Entregar `jboss-eap-copilot-harness-template`, um produto de tooling independente para
Windows PowerShell 5.1 e Copilot/VS Code. Ele prepara a adoção em aplicações Java EE 7,
Java 8 e JBoss EAP 7.0 → 7.4 preservando arquitetura, contratos e comportamento.
Codex prepara o template; não será requisito da operação diária.

O diagnóstico e o planejamento ficam nesta branch documental. A implementação ocorrerá
exclusivamente em `C:\desenvolvimento\repositorio\jboss-eap-copilot-harness-template`, após
GO específico. Não criar aplicação de demonstração, POM de produto, remoto ou instalação
para aparentar validação. A migração de uma aplicação tem goal e autorização separados.

## Requisitos verificáveis

| ID | Requisito | Evidência necessária | Etapa |
| --- | --- | --- | --- |
| R01 | Novo Git e identidade próprios; origem exclusiva no SHA de `main` registrado no plano | Raiz Git distinta, sem remoto herdado; manifesto por arquivo; origem executável intacta | H01 |
| R02 | Goal, spec, arquitetura/ADRs e plan/todo próprios; decisões humanas explícitas | Artefatos revisados, ADRs inicialmente propostos, uma fonte editável por plano | H01 |
| R03 | Preservar arquitetura Java EE existente, inclusive JTA/XA quando usados | Política canônica, inventário AS-IS e revisão por fatia; nenhum transporte de regras Quarkus de camadas/Outbox | H01/H06 |
| R04 | Executar scripts no `powershell.exe` 5.1 real, sem PS7/Docker/WSL obrigatórios | Regressões de JSON, hash, arquivos, argumentos, encoding, timeout, códigos de saída e restauração de ambiente | H02 |
| R05 | Configuração local única e ignorada; raízes do harness e da aplicação separadas | Exemplo sem segredos, validação de caminhos, teste com espaços/acentos e configuração inválida | H01/H02 |
| R06 | Separar JDK 8 do build/EAP, JDK MTA, JDK scanner e runtime Java do editor | Processos e JDKs observados; configurações não alteram o ambiente global nem o Maven/Wrapper do produto | H02/H04 |
| R07 | Sessão Sonar segura, sem dependência de Codex | Token somente em processo, herança comprovada até o terminal do agente, testes de ausência e falha sem vazamento | H03/H05 |
| R08 | Build/testes/cobertura com Java 8 separados da análise Sonar | Scanner fixado e compatível, nenhum clean/rebuild na análise; bytecodes, relatórios, commit/fingerprint e hashes associados | H03/H04 |
| R09 | Preservar regras 85%/5%, issues novas e HIGH/BLOCKER/CRITICAL | Regressões dos limites inclusivos, dívida anterior e dados ausentes; baseline próprio; Quality Gate corporativo avaliado separadamente | H03 |
| R10 | Associar resultado à análise enviada | `report-task.txt`, ceTaskId, analysisId e revisão coerentes; concorrência/resultado obsoleto impedem declaração de conformidade | H03 |
| R11 | Preservar estados e autoridade humana | Offline-only e indisponibilidade ficam UNVERIFIED; NON_COMPLIANT exige decisão recebida; nenhum aceite herdado | H03 |
| R12 | Incluir instruções operacionais no fingerprint conforme seu efeito | Mudança de prompt/skill/configuração operacional invalida evidência; documentação explicativa continua isenta | H02/H05 |
| R13 | VS Code chama os mesmos scripts da rota CLI | Workspace adotável, sem tokens; descoberta de instruções e execução comprovadas por cliente; CLI condicionado a pré-requisitos | H04/H05 |
| R14 | Laboratório local EAP com artefato identificado | Versões/configuração confirmadas; um servidor por vez; mesma hash no ensaio 7.0/7.4, isolamento de dados/filas e validação funcional | H04/H06 |
| R15 | Atualizar DevSquad somente após inventário e GO | Versão, procedência, customizações e diferenças IDE/CLI antes/depois; planos canônicos e controles preservados | H05 |
| R16 | MTA por ZIP/local, opções e regras observadas | Versão/hash/parâmetros/rulesets registrados; relatórios completos ignorados e tratados como dados; limites da análise explícitos | H06 |
| R17 | Inventariar aplicação e bibliotecas internas/compartilhadas | Coordenadas, hashes, fonte, proprietário, consumidores, carregamento, Java/EE e matriz compatibilidade/testes/decisão | H06 |
| R18 | Adoção seletiva e repetível | Colisões apresentadas antes da escrita; POM, Git, instruções e customizações preservados; segunda adoção sem duplicação | H06 |
| R19 | Publicar somente após aceite local e autorização externa | Nome, URL, visibilidade, branch padrão e atributo Template verificados no novo remoto autorizado | H07 |

## Preservação arquitetural

A arquitetura do harness organiza controles; não define a organização da aplicação.
Preservar módulos, pacotes, responsabilidades, EJB/CDI, persistência, propagação transacional,
JTA/XA, segurança, SSO e contratos observados. Cada fatia registra `PRESERVADO`,
`NÃO VERIFICADO` ou `DESVIO ARQUITETURAL PROPOSTO`, com evidências.

Não transportar a exigência `domain/application/adapter`, os testes ArchUnit Quarkus,
Quarkus Flow/Outbox nem a proibição de XA. Desvio necessário interrompe a ação afetada
e exige mudança de escopo e checkpoint humano. Ajustes mínimos de compatibilidade
mantêm as responsabilidades atuais e precisam de testes pertinentes nos dois EAPs.

## Versões e informações ainda necessárias

Java 8 na aplicação e EAP 7.4 como destino já foram escolhidos. Não reabrir essas escolhas.
Fornecedor/update do JDK, patches EAP, Maven/Wrapper/perfis/toolchains, scanner/JDK,
MTA/JDK, VS Code/runtime Java, DevSquad e CLI dependem do ambiente efetivo.
Nenhuma versão da origem Quarkus é automaticamente transferida.

URL/versão/permissões do Sonar corporativo, identidade do projeto e política de downloads
serão verificadas antes da integração real. Não solicitar token no chat.
O PowerShell observado nesta máquina não comprova a máquina de trabalho do usuário.
Falta de aplicação corporativa não impede preparar modelos, mas impede declarar sua migração validada.

## Aceitação e verificações

Cada requisito deve ser relacionado a testes ou evidência real do novo destino.
Fixtures sintéticas verificam controles, sem simular homologação de EAP, MTA, Copilot ou Sonar.
Build, compatibilidade binária, operação funcional e preservação arquitetural são verificações
distintas. Deploy OK, MTA sem achados e Sonar conforme não substituem aceite humano.

Mudanças executáveis exigem baseline e GO aplicáveis. No bootstrap sem infraestrutura,
registrar a limitação e obter a decisão antes da fatia afetada; não copiar baseline do Quarkus.
Não reduzir limites ou exclusões para aparentar sucesso. Aplicar revisão proporcional
de correção, simplicidade, segurança, desempenho, testes, arquitetura e escopo.

O primeiro checkpoint proposto cobre somente a fundação documental H01A descrita no plano.
Arquitetura/ADRs permanentes e instruções operacionais serão preparados e submetidos nos
checkpoints seguintes, antes de scripts ou configuração executável. Aprovar a proposta
não significa aceitar ADRs, autorizar todos os incrementos nem publicar o novo produto.
