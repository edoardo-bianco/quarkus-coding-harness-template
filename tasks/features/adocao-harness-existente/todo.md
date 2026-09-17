# Checklist — Preparação do guia de adoção

- Estado: `EM_EXECUCAO` — pausa solicitada pelo humano; retomada pendente.
- Goal: [adoção](../../../goals/adocao-harness-existente/goal.md).
- Spec: [rascunho](../../../specs/adocao-harness-existente/spec.md).
- Plano: [proposta](plan.md).
- Guia: [procedimento manual](../../../doc/guias/adotar-harness-repositorio-existente.md).
- Responsável humano: usuário solicitante.

## Decisões e limites

| Data | Autoridade | Registro | Efeito |
| --- | --- | --- | --- |
| 2026-09-16 | Humano | Planejar adoção em repositório com produção e preparar primeiro guia manual | Preparação documental |
| — | Humano | Aprovação do novo goal/spec/plano | `PENDENTE` |
| — | Humano | GO para aplicação no produto | `PENDENTE`; produto ainda não indicado |
| — | Humano | Aceite/encerramento deste goal | `PENDENTE` |

## Preparação

- [x] Confirmar bootstrap anterior encerrado e manter seus arquivos intactos.
- [x] Ler modelos de goal/spec/tasks e ADRs aplicáveis.
- [x] Inspecionar scripts, hooks e testes reais do harness.
- [x] Registrar premissas, limitações e divergências encontradas.
- [x] Criar rascunhos de goal/spec e proposta documental de plano.
- [x] Preparar guia com matriz de artefatos, sequência, checkpoints e checklist de adoção.
- [ ] Conferir os requisitos A01–A12, links e arquivos referenciados.
- [ ] Revisar escopo e diff, sem segredos nem artefatos gerados.
- [ ] Adicionar acesso pelo README e publicar os commits documentais.
- [ ] Apresentar o conjunto para revisão humana.

## Evidências e limitações

A inspeção do código identificou os limites descritos no plano, em especial fingerprint de
diretórios da raiz e ausência de parâmetros de perfis no analisador.
Nenhum repositório de produto foi inspecionado ou alterado. Não houve teste, instalação,
análise ou ensaio de adoção. As contagens e métricas do bootstrap não se transferem a outro produto.

Nesta entrega, Markdown é isento de Maven, testes PowerShell, baseline e checkpoint Sonar.
Validação documental final: `PENDENTE`.

## Próximo item autorizado

Aguardar a retomada solicitada pelo humano. Ao retomar, revisar os requisitos A01–A12 e o conteúdo
do guia, conferir links/arquivos e corrigir inconsistências. Depois, adicionar navegação pelo README
(D2 do plano), consolidar evidências documentais e apresentar os rascunhos para revisão humana.
Não executar o roteiro em produto nem iniciar automação. O checklist operacional reutilizável
fica no próprio guia e deve ser copiado/adaptado ao contexto do futuro produto.

## Checkpoint de pausa — 2026-09-16

- Humano solicitou parar em ponto seguro e retomar amanhã.
- Branch de trabalho: `docs/adocao-harness-existente`, criada a partir de `88e68b2`.
- Cinco rascunhos foram gravados: goal, spec, plano, checklist e guia manual.
- A validação documental final e a integração de navegação pelo README continuam pendentes.
- A inspeção dos scripts já identificou limitações de fingerprint, perfis Maven e testes
  específicos do template; revisar esses pontos na retomada.
- Nenhum repositório de produção foi acessado ou alterado; nenhum ensaio ou comando do guia foi executado.
- Mudança somente Markdown: Maven e Sonar não foram executados.
- O bootstrap anterior permanece encerrado. Aprovação e GO do novo trabalho continuam pendentes,
  salvo a preparação documental já solicitada.
- Este checkpoint preserva trabalho em andamento; não declara conclusão ou aceite do novo goal.
