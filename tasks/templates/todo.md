# Checklist de execução — {{NOME_DA_FEATURE}}

## Metadados

- ID: `{{ID_DO_CHECKLIST}}`
- Estado da feature: `PLANEJADA`
- Goal: `{{CAMINHO_DO_GOAL}}`
- Spec aprovada: `{{CAMINHO_DA_SPEC}}`
- Plano: `{{CAMINHO_DO_PLANO}}`
- Responsável humano: `{{RESPONSAVEL_HUMANO}}`
- Criado em: `{{DATA_CRIACAO_AAAA_MM_DD}}`
- Última atualização: `{{DATA_ATUALIZACAO_AAAA_MM_DD}}`

> Substitua todos os marcadores `{{CAMPO}}`. Este arquivo registra fatos e decisões explícitas;
> não marque aprovação, exceção ou encerramento por inferência.

## Regra de execução

- Execute somente o item descrito em **Próximo item autorizado**.
- Mantenha no máximo uma tarefa em `EM_EXECUCAO`.
- Conclua item apenas com evidência registrada.
- Atualize spec, plano e checklist antes de executar mudança de escopo.
- Pare nos checkpoints de contrato, arquitetura, segurança, observabilidade e qualidade.
- Somente o humano registra `GO`, `NO-GO`, exceção, ADR aceito, rejeição ou encerramento.

Estados permitidos: `PENDENTE`, `EM_EXECUCAO`, `BLOQUEADO`, `CONCLUIDO`, `NAO_APLICAVEL`.

## Prontidão para implementação

- [ ] Goal ativo, valor e definição de pronto compreendidos.
- [ ] Spec aplicável está aprovada pelo humano.
- [ ] Arquitetura e índice de ADRs foram revisados.
- [ ] Contratos, código e testes relacionados foram inspecionados.
- [ ] Hipóteses materiais e questões abertas foram resolvidas.
- [ ] Plano possui escopo, fora de escopo, riscos, dependências, verificações e checkpoints.
- [ ] Todas as tarefas possuem critérios observáveis e normalmente até cinco arquivos.
- [ ] Plano foi revisado pelo humano.
- [ ] `GO` explícito de implementação foi registrado abaixo.

## Decisões humanas

| Decisão | Autoridade | Data | Evidência/registro | Estado |
| --- | --- | --- | --- | --- |
| Aprovação do plano | {{RESPONSAVEL_HUMANO}} | — | {{REGISTRO_APROVACAO_PLANO}} | `PENDENTE` |
| `GO` de implementação | {{RESPONSAVEL_HUMANO}} | — | {{REGISTRO_GO}} | `PENDENTE` |
| Checkpoint de contrato | {{RESPONSAVEL_HUMANO}} | — | {{REGISTRO_CONTRATO_OU_NA}} | `{{ESTADO_CONTRATO}}` |
| Checkpoint de arquitetura | {{RESPONSAVEL_HUMANO}} | — | {{REGISTRO_ARQUITETURA_OU_NA}} | `{{ESTADO_ARQUITETURA}}` |
| Checkpoint de segurança | {{RESPONSAVEL_HUMANO}} | — | {{REGISTRO_SEGURANCA_OU_NA}} | `{{ESTADO_SEGURANCA}}` |
| Checkpoint de observabilidade | {{RESPONSAVEL_HUMANO}} | — | {{REGISTRO_OBSERVABILIDADE_OU_NA}} | `{{ESTADO_OBSERVABILIDADE}}` |
| Decisão Sonar, se necessária | {{RESPONSAVEL_HUMANO}} | — | {{REGISTRO_SONAR_OU_NA}} | `{{ESTADO_SONAR}}` |
| Aceite/encerramento | {{RESPONSAVEL_HUMANO}} | — | {{REGISTRO_ENCERRAMENTO}} | `PENDENTE` |

Copie somente uma decisão que o humano realmente declarou. Quality Gate, testes verdes e silêncio
não preenchem esta tabela.

## Tarefa 1 — {{TITULO_TAREFA_1}}

- Estado: `PENDENTE`
- Plano: {{REFERENCIA_TAREFA_1_NO_PLANO}}
- Dependências: {{DEPENDENCIAS_TAREFA_1_OU_NENHUMA}}
- Arquivos previstos: {{QUANTIDADE_ARQUIVOS_TAREFA_1}} — {{JUSTIFICATIVA_SE_MAIOR_QUE_CINCO_OU_NA}}
- Checkpoint anterior: {{CHECKPOINT_ANTERIOR_TAREFA_1_OU_NENHUM}}

### Execução

- [ ] Confirmar que dependências e checkpoint anterior estão satisfeitos.
- [ ] Executar RED quando houver comportamento novo ou regressão.
- [ ] Implementar somente o mínimo da tarefa.
- [ ] Executar GREEN e REFACTOR sem ampliar escopo.
- [ ] Revisar correção, simplicidade, arquitetura, segurança, desempenho, testes e escopo.
- [ ] Atualizar documentação e evidências afetadas.

### Evidências

| Verificação | Comando/inspeção executado | Resultado observado | Estado |
| --- | --- | --- | --- |
| Teste focado | `{{COMANDO_FOCADO_TAREFA_1}}` | {{RESULTADO_FOCADO_1}} | `PENDENTE` |
| Suíte/build | `{{COMANDO_SUITE_TAREFA_1}}` | {{RESULTADO_SUITE_1}} | `PENDENTE` |
| Manual/contrato | {{INSPECAO_TAREFA_1}} | {{RESULTADO_INSPECAO_1}} | `PENDENTE` |
| Diff e segredos | {{INSPECAO_DIFF_TAREFA_1}} | {{RESULTADO_DIFF_1}} | `PENDENTE` |

### Conclusão da tarefa

- [ ] Critérios da tarefa no plano foram satisfeitos.
- [ ] Evidências foram registradas sem segredo ou artefato proibido.
- [ ] Checkpoint posterior foi apresentado, quando aplicável.
- [ ] Commit atômico criado: `{{COMMIT_TAREFA_1_OU_PENDENTE}}`.

## Tarefa 2 — {{TITULO_TAREFA_2}}

- Estado: `PENDENTE`
- Plano: {{REFERENCIA_TAREFA_2_NO_PLANO}}
- Dependências: {{DEPENDENCIAS_TAREFA_2}}
- Arquivos previstos: {{QUANTIDADE_ARQUIVOS_TAREFA_2}} — {{JUSTIFICATIVA_SE_MAIOR_QUE_CINCO_OU_NA}}
- Checkpoint anterior: {{CHECKPOINT_ANTERIOR_TAREFA_2_OU_NENHUM}}

### Execução

- [ ] Confirmar que dependências e checkpoint anterior estão satisfeitos.
- [ ] Executar RED quando houver comportamento novo ou regressão.
- [ ] Implementar somente o mínimo da tarefa.
- [ ] Executar GREEN e REFACTOR sem ampliar escopo.
- [ ] Revisar correção, simplicidade, arquitetura, segurança, desempenho, testes e escopo.
- [ ] Atualizar documentação e evidências afetadas.

### Evidências

| Verificação | Comando/inspeção executado | Resultado observado | Estado |
| --- | --- | --- | --- |
| Teste focado | `{{COMANDO_FOCADO_TAREFA_2}}` | {{RESULTADO_FOCADO_2}} | `PENDENTE` |
| Suíte/build | `{{COMANDO_SUITE_TAREFA_2}}` | {{RESULTADO_SUITE_2}} | `PENDENTE` |
| Manual/contrato | {{INSPECAO_TAREFA_2}} | {{RESULTADO_INSPECAO_2}} | `PENDENTE` |
| Diff e segredos | {{INSPECAO_DIFF_TAREFA_2}} | {{RESULTADO_DIFF_2}} | `PENDENTE` |

### Conclusão da tarefa

- [ ] Critérios da tarefa no plano foram satisfeitos.
- [ ] Evidências foram registradas sem segredo ou artefato proibido.
- [ ] Checkpoint posterior foi apresentado, quando aplicável.
- [ ] Commit atômico criado: `{{COMMIT_TAREFA_2_OU_PENDENTE}}`.

## Checklist arquitetural

Marque `NAO_APLICAVEL` com justificativa quando o risco não existir.

- [ ] Organização permanece por domínio/capacidade.
- [ ] `domain` não depende de `application` ou `adapter`.
- [ ] `application` não depende de adapter ou DTO de borda.
- [ ] DTOs e mappers permanecem na borda proprietária.
- [ ] Colaboração entre capacidades usa contrato explícito.
- [ ] Porta ou wrapper novo atende consumidor e fronteira concretos.
- [ ] Uso de Quarkus/biblioteca simplifica a solução sem inverter dependência.
- [ ] Regras ArchUnit aplicáveis foram executadas.
- Evidência ou justificativa: {{EVIDENCIA_ARQUITETURAL}}

## Checklist de mensageria e dupla escrita

- Aplicável: {{SIM_NAO}}
- Justificativa: {{JUSTIFICATIVA_MENSAGERIA}}

Quando aplicável, todos os itens abaixo são obrigatórios antes da implementação:

- [ ] Mensageria permanece adapter e contrato de broker não vaza para o domínio.
- [ ] Assincronicidade, semântica de entrega e momento do ack estão explícitos.
- [ ] Retry, backoff, limite e quarentena estão definidos.
- [ ] Idempotência de produtor e consumidor está definida.
- [ ] Ordenação, concorrência, lease e backpressure estão definidos.
- [ ] Evento de domínio e evento de integração possuem mapeamento explícito.
- [ ] Schema, compatibilidade e versionamento estão definidos.
- [ ] Retenção, expurgo e dados sensíveis estão definidos.
- [ ] Logs, spans, métricas e alertas possuem contrato verificável.
- [ ] Se houver banco + broker, agregado e outbox usam a mesma transação local.
- [ ] Publicação usa relay por polling, fora de transação longa e com confirmação do broker.
- [ ] Entrega at-least-once e duplicidade segura estão cobertas por testes.
- [ ] Rollback, indisponibilidade, retry, queda pós-publicação, concorrência e quarentena têm testes.
- Evidência ou justificativa: {{EVIDENCIA_MENSAGERIA_OUTBOX}}

É proibido concluir este checklist com dupla escrita sequencial direta. Consulte o
[ADR-0005](../../doc/adr/0005-outbox-aplicacional-dupla-escrita.md).

## Qualidade e SonarQube

- Classificação do incremento: {{MARKDOWN_OU_EXECUTAVEL}}
- [ ] Testes locais proporcionais foram executados ou a limitação foi registrada.
- [ ] Mudança exclusivamente Markdown foi tratada sem token, baseline ou checkpoint.
- [ ] Para mudança executável, baseline e checkpoint seguiram `AGENTS.md`.
- [ ] `UNVERIFIED` não foi transformado em aprovação.
- [ ] `NON_COMPLIANT`, se presente, foi apresentado ao humano.
- Decisão humana Sonar: {{REPROVAR_ACEITAR_CONTINUAR_OU_NAO_APLICAVEL}}
- Evidência: {{EVIDENCIA_QUALIDADE}}

## Verificação final técnica

- [ ] Todos os critérios de aceitação possuem evidência rastreável.
- [ ] Testes focados e suíte proporcional estão verdes.
- [ ] Build e análise aplicáveis estão verdes ou com limitação explícita.
- [ ] Arquitetura e documentação refletem o estado implementado.
- [ ] Nenhum segredo, estado, baseline, relatório ou artefato proibido foi versionado.
- [ ] Não há alteração fora do escopo aprovado.
- [ ] Riscos residuais e exceções estão registrados.
- [ ] Evidências foram apresentadas ao humano.

## Próximo item autorizado

- Estado: `{{PENDENTE_EM_EXECUCAO_BLOQUEADO_CONCLUIDO}}`
- Item exato: {{PROXIMO_ITEM_EXATO}}
- Pré-condições: {{PRECONDICOES_DO_PROXIMO_ITEM}}
- Arquivos permitidos: {{ARQUIVOS_PERMITIDOS}}
- Verificações exigidas: {{VERIFICACOES_EXIGIDAS}}
- Parar depois de: {{CONDICAO_DE_PARADA}}

Se não houver `GO`, dependência ou checkpoint satisfeito, escreva `NENHUM — AGUARDANDO DECISAO` e
não inicie outra tarefa.

## Histórico de execução

| Data | Autoridade/agente | Fato ou decisão | Evidência | Próximo estado |
| --- | --- | --- | --- | --- |
| {{DATA_EVENTO_AAAA_MM_DD}} | {{AUTORIDADE_OU_AGENTE}} | Checklist criado | {{EVIDENCIA_INICIAL}} | `PLANEJADA` |
