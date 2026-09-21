# Checklist — Novo harness JBoss EAP

- Estado: `EM_REVISAO`; construção ainda não iniciada.
- Data: 2026-09-21.
- [Goal](../../../goals/novo-repositorio-mta/goal.md), [spec](../../../specs/novo-repositorio-mta/spec.md), [plano e diagnóstico](plan.md).
- Branch de trabalho: `chore/preparacao-jboss-harness`.
- Fonte técnica: `main` em `22512766897bca4146e940cdca39ab9089f545f4`.

## Decisões humanas

| Registro | Efeito |
| --- | --- |
| 2026-09-21: seguir `main` na máquina de trabalho e prosseguir com o goal aqui | Retomar H00 e planejamento nesta branch; ambientes são distintos |
| 2026-09-21: fazer referência à branch correta | Atualizar documentação ativa para `chore/preparacao-jboss-harness`; preservar histórico e prompt original |
| Aprovação da spec/plano | PENDENTE |
| GO H01A — Git independente e fundação documental | PENDENTE |
| GO executável/baseline e checkpoints posteriores | PENDENTE; não inferir da retomada do diagnóstico |
| Publicação do novo remoto, aceite e encerramento | PENDENTE |

## H00 — Diagnóstico e proposta

- [x] Conferir Git e remoto após fetch; main/origin/main no mesmo SHA; árvore inicialmente limpa.
- [x] Distinguir branch de trabalho, main da máquina de trabalho e SHA técnico fixado.
- [x] Registrar avanço da main após PR #2; branch antiga permanece apenas no histórico.
- [x] Verificar destino local: inexistente; nenhum arquivo criado fora da origem.
- [x] Inspecionar requisitos, arquitetura/ADRs, código e testes pertinentes no snapshot.
- [x] Registrar matriz origem → destino e lacunas D01–D08 no plano.
- [x] Inspecionar metadados de powershell.exe local: 5.1.26100.9444; não executar o harness.
- [x] Preparar spec, organização proposta e plano H00–H07 para revisão.
- [x] Conferir os cinco documentos: 21 links locais válidos, cercas Markdown pareadas e diff sem erros de whitespace; somente Markdown.
- [ ] Obter revisão humana e GO específico H01A.

Maven, testes do harness, baseline/API Sonar, MTA, EAP, instalação/atualização de plugins e
materialização: NÃO EXECUTADOS. Compatibilidade operacional: NÃO_VERIFICADA. A inspeção
de parâmetros/APIs do PowerShell é evidência de diagnóstico, não teste de regressão.

## Construção futura

- [ ] H01A: criar fundação documental/Git próprios, após GO e acesso ao destino.
- [ ] H01B: preparar arquitetura e ADRs próprios propostos; revisão humana.
- [ ] H01C: entrada operacional/configuração, somente após GO e tratamento de baseline.
- [ ] H02A–B: ambiente/PS5.1 e núcleo de qualidade portátil.
- [ ] H03A–D: sessão, análise, baseline/gates e exportação.
- [ ] H04A–B: workspace/build e laboratório EAP.
- [ ] H05A–B: inventário/atualização autorizada DevSquad e integração por cliente.
- [ ] H06A–C: MTA, inventários, adoção e ensaio integrado.
- [ ] H07: publicação somente após aceite local e autorização externa.
- [ ] Verificação humana da entrega, aceite e encerramento do goal.

Cada etapa futura seguirá somente a fatia autorizada do plano, com evidências e decisão
registradas no novo destino. Nenhuma caixa futura é autorização de execução.

## Próximo item autorizado

H00 verificado documentalmente; apresentar a proposta para decisão humana. Parar antes de H01A para
receber revisão e GO local previstos no goal/prompt. O primeiro GO proposto se limita aos
seis documentos e ao Git independente descritos no plano; não alcança configuração
executável, scripts, integrações, migração ou publicação do novo template.
