# Proposta de plano — Guia manual de adoção

- Estado: `RASCUNHO`, preparado junto do guia solicitado; não é plano aprovado para código.
- Goal: [adoção](../../../goals/adocao-harness-existente/goal.md).
- Spec: [requisitos](../../../specs/adocao-harness-existente/spec.md), em revisão.
- Checklist: [andamento](todo.md).
- Referência do harness inspecionada: `88e68b2`, descendente da entrega aceita `2be35ac`.
- Branch documental: `docs/adocao-harness-existente`.
- Autoridade: solicitação humana de 2026-09-16 para planejar e preparar primeiro um guia manual.

## Intenção e limites

Produzir uma proposta completa e revisável antes de qualquer aplicação ao produto. A revisão
humana da spec/plano permanece pendente; o roteiro no guia não autoriza sua execução.
O bootstrap encerrado e seus arquivos de execução serão preservados.

Dependências: ferramentas e contratos existentes do template, instruções do AGENTS.md e ADRs 0001–0004.
Sem dependência de token, servidor, caminho de produto ou repositório remoto novo para escrever o guia.

## Etapas desta preparação documental

### D1 — Preparar o conjunto para revisão

Arquivos (cinco): novo goal, spec, este plano, todo e guia manual.
Entregar inventário dos controles, diferenças em relação a materialização, sequência manual,
checklist, evidências, checkpoints e reversão. O guia é uma proposta documental, sem código novo.

Aceitação: requisitos A01–A11 abordados; dados não informados explícitos; nenhum estado humano
inferido; bootstrap preservado.
Verificação: inspeção direta dos scripts/testes, matriz dos requisitos, links e diff.
Parada: apresentar proposta ao humano; nenhum passo de adoção é executado implicitamente.

### D2 — Tornar a proposta encontrável

Dependência: D1 preparado. Arquivo: README.
Acrescentar acesso ao novo goal e guia em rascunho, preservando a aceitação e o encerramento
do bootstrap. Não declarar o produto adaptado nem o guia validado por ensaio.
Aceitação: A12; links válidos e distinção clara entre materialização e adoção.
Verificação: links locais e revisão do diff; commit documental separado de D1.

## Proposta de execução futura no produto

O guia decompõe o trabalho em diagnóstico, governança, bootstrap técnico, cobertura/baseline,
controles de arquitetura/observabilidade e validação final. Os nomes de arquivos e o número
de fatias dependem do inventário real; cada fatia terá normalmente até cinco arquivos.

Pré-condições: repo e responsável identificados, stack e comandos confirmados, spec/plano do
produto aprovados e GO específico. Não transformar esta proposta em checklist de execução
do produto sem cumprir essas condições.

## Constatações da inspeção do template

- `Get-SonarCodeFingerprint` cobre `src/`, `.mvn/`, `.codex/hooks/`, `test/powershell/`,
  POM/Wrapper/hooks.json e scripts PowerShell da raiz; módulos em outros diretórios ficam fora.
- O analisador usa POM/Wrapper da própria raiz, identidade extraída do XML e `clean verify`;
  não expõe parâmetros para perfis, módulos ou propriedades extras do build.
- Testes de configuração exigem caminhos e decisões particulares do template; não são uma
  certificação universal para cobertura e layout de um produto existente.
- A feature sample e os testes Java de exemplo não devem substituir código/testes do produto.
- `doc/sonar/sonarqube-local.md` conserva narrativa histórica dos Incrementos 9–10, embora o
  harness completo exista. O guia novo usa scripts, AGENTS.md e ADR-0004 como referência do
  comportamento atual; revisão dessa narrativa fica como divergência documental futura.
- O guia de materialização cria identidade e histórico novos; reutilizá-lo no produto existente
  poderia apagar contexto válido. O novo guia mantém procedimentos separados.

## Riscos e verificação

| Risco | Tratamento no guia |
| --- | --- |
| Layout não coberto pelo fingerprint | Parar antes de confiar no hook; especificar adaptação e regressão |
| Dívida preexistente tratada como regressão ou apagada | Inventariar antes/depois e manter política/decisão explícita |
| Scripts dispararem efeitos do build em produção | Inspeção de perfis, plugins e dependências antes da execução |
| Conflito com instruções, hooks e ADRs existentes | Integração por diff, sem sobrescrita ou aceite herdado |
| Confundir guia com ensaio executado | Declarar execução em produto `NÃO_EXECUTADA` |

Verificação desta entrega: documentação, escopo e consistência. Maven, baseline, API Sonar e
checkpoint não se aplicam a esta mudança exclusivamente Markdown.
Revisão: correção da sequência, simplicidade, arquitetura, segurança, custo das verificações,
preservação dos testes e escopo do diff.

## Checkpoint

Submeter goal/spec/guia ao humano. Não solicitar GO de aplicação antes de existir repositório
piloto, inventário e plano específico revisável. Aceite e encerramento do novo goal permanecem pendentes.
