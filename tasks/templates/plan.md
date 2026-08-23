# Plano de implementação — {{NOME_DA_FEATURE}}

## Metadados

- ID: `{{ID_DO_PLANO}}`
- Estado: `RASCUNHO`
- Goal: `{{CAMINHO_DO_GOAL}}`
- Spec aprovada: `{{CAMINHO_DA_SPEC}}`
- Arquitetura: `{{CAMINHO_DA_ARQUITETURA}}`
- ADRs aplicáveis: `{{ADRS_APLICAVEIS_OU_NENHUM}}`
- Responsável humano: `{{RESPONSAVEL_HUMANO}}`
- Data de criação: `{{DATA_CRIACAO_AAAA_MM_DD}}`
- Última revisão: `{{DATA_REVISAO_AAAA_MM_DD}}`

> Substitua todos os marcadores `{{CAMPO}}`. Desconhecido vira hipótese, questão aberta ou bloqueio;
> não invente. Aprovação deste plano não equivale a `GO`; registre o `GO` somente no checklist.

## Intenção

{{INTENCAO_DA_IMPLEMENTACAO}}

## Resultado e valor

- Resultado observável: {{RESULTADO_OBSERVAVEL}}
- Valor para o usuário: {{VALOR_PARA_USUARIO}}
- Relação com o goal: {{CONTRIBUICAO_PARA_GOAL}}

## Contexto confirmado

- Estado atual verificado: {{ESTADO_ATUAL_E_EVIDENCIA}}
- Contratos existentes afetados: {{CONTRATOS_AFETADOS_OU_NENHUM}}
- Padrões reais encontrados: {{PADROES_REUTILIZADOS}}
- Divergências entre documentação e implementação: {{DIVERGENCIAS_OU_NENHUMA}}

## Hipóteses e questões que condicionam o plano

| Item | Evidência atual | Impacto se falso/indefinido | Responsável | Estado |
| --- | --- | --- | --- | --- |
| {{HIPOTESE_OU_QUESTAO_1}} | {{EVIDENCIA_1}} | {{IMPACTO_1}} | {{RESPONSAVEL_1}} | `PENDENTE` |
| {{HIPOTESE_OU_QUESTAO_2_OU_REMOVER}} | {{EVIDENCIA_2}} | {{IMPACTO_2}} | {{RESPONSAVEL_2}} | `PENDENTE` |

Questão que altere escopo, contrato, arquitetura, segurança ou observabilidade impede o `GO` até
decisão humana.

## Escopo

- {{ITEM_EM_ESCOPO_1}}
- {{ITEM_EM_ESCOPO_2}}
- {{ITEM_EM_ESCOPO_3_OU_REMOVER}}

## Fora de escopo

- {{ITEM_FORA_DE_ESCOPO_1}}
- {{ITEM_FORA_DE_ESCOPO_2}}
- {{ITEM_FORA_DE_ESCOPO_3_OU_REMOVER}}

## Critérios de aceitação e rastreabilidade

| ID | Critério observável | Requisito da spec | Tarefa | Evidência esperada |
| --- | --- | --- | --- | --- |
| CA-001 | {{CRITERIO_ACEITACAO_1}} | {{REQUISITO_1}} | T1 | {{EVIDENCIA_CA_1}} |
| CA-002 | {{CRITERIO_ACEITACAO_2}} | {{REQUISITO_2}} | T2 | {{EVIDENCIA_CA_2}} |
| CA-003 | {{CRITERIO_ACEITACAO_3_OU_REMOVER}} | {{REQUISITO_3}} | {{TAREFA_3}} | {{EVIDENCIA_CA_3}} |

## Arquitetura e decisões aplicáveis

- Capacidade/package proprietário: {{CAPACIDADE_E_PACKAGE}}
- Direção de dependência preservada por: {{REGRA_DE_DEPENDENCIA}}
- Portas e adapters concretos: {{PORTAS_ADAPTERS_OU_NENHUM}}
- Contratos de borda e ownership de DTOs: {{CONTRATOS_E_OWNERSHIP}}
- Uso pragmático de Quarkus/bibliotecas: {{USO_JUSTIFICADO_OU_NENHUM}}
- ADR novo ou atualização necessária: {{ADR_NECESSARIO_OU_NAO}}

Não introduza abstração, dependência, integração ou workflow apenas para uso futuro. Mudança de
arquitetura exige checkpoint humano antes da tarefa correspondente.

## Grafo de dependências

```text
{{GRAFO_DE_DEPENDENCIAS}}
```

Explique a ordem crítica: {{JUSTIFICATIVA_DA_ORDEM}}

## Estratégia de implementação

- Estratégia de fatiamento: {{VERTICAL_CONTRATO_RISCO_E_JUSTIFICATIVA}}
- Primeiro risco a provar: {{RISCO_PRIORITARIO}}
- Estado verificável após cada tarefa: {{COMO_PERMANECE_VERIFICAVEL}}
- Estratégia RED → GREEN → REFACTOR: {{ESTRATEGIA_TDD_OU_NAO_APLICAVEL}}

## Tarefas

Repita o bloco abaixo somente quando necessário. Cada tarefa toca normalmente até cinco arquivos.
Se exceder, decomponha ou registre justificativa de indivisibilidade antes do `GO`.

### Tarefa 1 — {{TITULO_TAREFA_1}}

**Descrição:** {{DESCRICAO_TAREFA_1}}

**Resultado verificável:** {{RESULTADO_TAREFA_1}}

**Critérios de aceitação:**

- [ ] {{ACEITACAO_TAREFA_1_A}}
- [ ] {{ACEITACAO_TAREFA_1_B}}
- [ ] {{ACEITACAO_TAREFA_1_C_OU_REMOVER}}

**Verificação:**

| Tipo | Comando ou inspeção | Resultado esperado |
| --- | --- | --- |
| Teste focado | `{{COMANDO_FOCADO_TAREFA_1}}` | {{RESULTADO_FOCADO_1}} |
| Suíte/build | `{{COMANDO_SUITE_TAREFA_1}}` | {{RESULTADO_SUITE_1}} |
| Manual/contrato | {{INSPECAO_TAREFA_1}} | {{RESULTADO_INSPECAO_1}} |

**Dependências:** {{DEPENDENCIAS_TAREFA_1_OU_NENHUMA}}

**Arquivos prováveis:**

1. `{{ARQUIVO_TAREFA_1_A}}`
2. `{{ARQUIVO_TAREFA_1_B_OU_REMOVER}}`
3. `{{ARQUIVO_TAREFA_1_C_OU_REMOVER}}`
4. `{{ARQUIVO_TAREFA_1_D_OU_REMOVER}}`
5. `{{ARQUIVO_TAREFA_1_E_OU_REMOVER}}`

**Tamanho:** `{{XS_S_M}}` — {{JUSTIFICATIVA_TAMANHO_1}}

**Checkpoint antes/depois:** {{CHECKPOINT_TAREFA_1_OU_NENHUM}}

### Tarefa 2 — {{TITULO_TAREFA_2}}

**Descrição:** {{DESCRICAO_TAREFA_2}}

**Resultado verificável:** {{RESULTADO_TAREFA_2}}

**Critérios de aceitação:**

- [ ] {{ACEITACAO_TAREFA_2_A}}
- [ ] {{ACEITACAO_TAREFA_2_B}}
- [ ] {{ACEITACAO_TAREFA_2_C_OU_REMOVER}}

**Verificação:**

| Tipo | Comando ou inspeção | Resultado esperado |
| --- | --- | --- |
| Teste focado | `{{COMANDO_FOCADO_TAREFA_2}}` | {{RESULTADO_FOCADO_2}} |
| Suíte/build | `{{COMANDO_SUITE_TAREFA_2}}` | {{RESULTADO_SUITE_2}} |
| Manual/contrato | {{INSPECAO_TAREFA_2}} | {{RESULTADO_INSPECAO_2}} |

**Dependências:** {{DEPENDENCIAS_TAREFA_2}}

**Arquivos prováveis:**

1. `{{ARQUIVO_TAREFA_2_A}}`
2. `{{ARQUIVO_TAREFA_2_B_OU_REMOVER}}`
3. `{{ARQUIVO_TAREFA_2_C_OU_REMOVER}}`
4. `{{ARQUIVO_TAREFA_2_D_OU_REMOVER}}`
5. `{{ARQUIVO_TAREFA_2_E_OU_REMOVER}}`

**Tamanho:** `{{XS_S_M}}` — {{JUSTIFICATIVA_TAMANHO_2}}

**Checkpoint antes/depois:** {{CHECKPOINT_TAREFA_2_OU_NENHUM}}

## Estratégia de testes e verificações

| Risco/comportamento | Nível | Comando completo | Evidência esperada |
| --- | --- | --- | --- |
| {{RISCO_TESTE_1}} | {{UNITARIO_COMPONENTE_CONTRATO_INTEGRACAO}} | `{{COMANDO_TESTE_1}}` | {{EVIDENCIA_TESTE_1}} |
| {{RISCO_TESTE_2}} | {{NIVEL_TESTE_2}} | `{{COMANDO_TESTE_2}}` | {{EVIDENCIA_TESTE_2}} |
| Direção arquitetural | ArchUnit ou `NÃO_APLICÁVEL` | `{{COMANDO_ARCHUNIT_OU_NA}}` | {{EVIDENCIA_ARQUITETURA}} |
| Regressão | Suíte | `{{COMANDO_VERIFY}}` | {{EVIDENCIA_REGRESSAO}} |

Não marque comando como verificado antes de executá-lo no repositório atual.

## Qualidade e SonarQube

- Classificação do escopo: {{MARKDOWN_OU_EXECUTAVEL}}
- Fingerprint executável alterado: {{SIM_NAO_E_ARQUIVOS}}
- Fonte do baseline escolhida pelo humano: {{FONTE_BASELINE_OU_NAO_APLICAVEL}}
- Momento do checkpoint: {{MOMENTO_CHECKPOINT_OU_NAO_APLICAVEL}}
- Evidência esperada: {{EVIDENCIA_SONAR_OU_ISENCAO_DOCUMENTAL}}

Mudança exclusivamente Markdown não solicita token nem executa Sonar. Mudança executável segue
`AGENTS.md`: offline-only permanece `UNVERIFIED`; `NON_COMPLIANT` exige decisão humana.

## Checkpoints humanos

| Checkpoint | Gatilho | Antes de qual tarefa | Evidência para decisão | Estado |
| --- | --- | --- | --- | --- |
| Plano e `GO` inicial | Plano e checklist revisados | T1 | {{EVIDENCIA_GO_INICIAL}} | `PENDENTE` |
| Contrato público/externo | {{GATILHO_CONTRATO_OU_NA}} | {{TAREFA_CONTRATO_OU_NA}} | {{EVIDENCIA_CONTRATO}} | `{{ESTADO_CONTRATO}}` |
| Arquitetura/ADR | {{GATILHO_ARQUITETURA_OU_NA}} | {{TAREFA_ARQUITETURA_OU_NA}} | {{EVIDENCIA_ARQUITETURA_CHECKPOINT}} | `{{ESTADO_ARQUITETURA}}` |
| Segurança | {{GATILHO_SEGURANCA_OU_NA}} | {{TAREFA_SEGURANCA_OU_NA}} | {{EVIDENCIA_SEGURANCA}} | `{{ESTADO_SEGURANCA}}` |
| Observabilidade | {{GATILHO_OBSERVABILIDADE_OU_NA}} | {{TAREFA_OBSERVABILIDADE_OU_NA}} | {{EVIDENCIA_OBSERVABILIDADE}} | `{{ESTADO_OBSERVABILIDADE}}` |
| Não conformidade Sonar | Resultado `NON_COMPLIANT`, se houver | Após checkpoint | Relatório técnico e opções humanas | `PENDENTE_SE_APLICAVEL` |
| Aceite técnico/final | Critérios e evidências completos | Encerramento | {{EVIDENCIA_FINAL}} | `PENDENTE` |

## Mensageria, assincronicidade e dupla escrita

- Aplicável: {{SIM_NAO}}
- Motivo: {{MOTIVO_APLICABILIDADE}}
- Adapter/broker: {{ADAPTER_BROKER_OU_NAO_APLICAVEL}}
- Contrato assíncrono interno: {{CONTRATO_ASSINCRONO_OU_NAO_APLICAVEL}}
- Evento de domínio → integração: {{MAPEAMENTO_EVENTO_OU_NAO_APLICAVEL}}

Quando não aplicável, registre a justificativa e remova o restante desta subseção. Quando aplicável,
consulte o [ADR-0005](../../doc/adr/0005-outbox-aplicacional-dupla-escrita.md) e preencha tudo:

| Decisão obrigatória | Definição da feature |
| --- | --- |
| Consistência e limite transacional | {{ESTRATEGIA_CONSISTENCIA_E_TRANSACAO}} |
| Ack e confirmação do broker | {{MOMENTO_ACK_E_CONFIRMACAO}} |
| Semântica de entrega | {{AT_LEAST_ONCE_E_IMPACTO}} |
| Retry, backoff e limite | {{POLITICA_RETRY}} |
| Quarentena e recuperação | {{POLITICA_QUARENTENA}} |
| Idempotência de produtor/consumidor | {{ESTRATEGIA_IDEMPOTENCIA}} |
| Ordenação | {{ESCOPO_E_CHAVE_ORDENACAO}} |
| Concorrência, lease e backpressure | {{ESTRATEGIA_CONCORRENCIA}} |
| Schema e versionamento | {{SCHEMA_E_COMPATIBILIDADE}} |
| Retenção e expurgo | {{POLITICA_RETENCAO}} |
| Dados sensíveis | {{CLASSIFICACAO_E_PROTECAO}} |
| Observabilidade | {{LOGS_SPANS_METRICAS_ALERTAS}} |

Verificações obrigatórias quando houver outbox:

- [ ] rollback mantém agregado e outbox consistentes;
- [ ] broker indisponível preserva registro pendente;
- [ ] retry publica após recuperação;
- [ ] queda após publicação pode duplicar sem duplicar efeito;
- [ ] relays concorrentes respeitam lease e ordenação declarada;
- [ ] evento inválido alcança quarentena;
- [ ] logs e spans não expõem payload sensível;
- [ ] métricas cobrem pendentes, idade, processamento, publicação, retries e quarentena.

## Migração, compatibilidade e rollback

- Migração necessária: {{SIM_NAO_E_PLANO}}
- Compatibilidade preservada: {{CONTRATOS_OU_NAO_APLICAVEL}}
- Estratégia de rollback/reversão: {{ESTRATEGIA_ROLLBACK}}
- Dados existentes: {{TRATAMENTO_DADOS_OU_NAO_APLICAVEL}}

## Dependências externas e operacionais

| Dependência | Necessidade | Disponibilidade/evidência | Responsável |
| --- | --- | --- | --- |
| {{DEPENDENCIA_1}} | {{NECESSIDADE_1}} | {{DISPONIBILIDADE_1}} | {{RESPONSAVEL_DEPENDENCIA_1}} |
| {{DEPENDENCIA_2_OU_REMOVER}} | {{NECESSIDADE_2}} | {{DISPONIBILIDADE_2}} | {{RESPONSAVEL_DEPENDENCIA_2}} |

## Riscos e mitigação

| Risco | Probabilidade | Impacto | Mitigação | Sinal de materialização |
| --- | --- | --- | --- | --- |
| {{RISCO_1}} | {{PROBABILIDADE_1}} | {{IMPACTO_RISCO_1}} | {{MITIGACAO_1}} | {{SINAL_1}} |
| {{RISCO_2}} | {{PROBABILIDADE_2}} | {{IMPACTO_RISCO_2}} | {{MITIGACAO_2}} | {{SINAL_2}} |

## Revisão antes de cada commit

- [ ] diff staged faz uma única mudança coerente;
- [ ] critérios da tarefa possuem evidência;
- [ ] testes e verificações proporcionais passaram ou a limitação está explícita;
- [ ] nenhum segredo, estado, relatório ou artefato de build entrou no diff;
- [ ] correção, simplicidade, arquitetura, segurança, desempenho, testes e escopo foram revisados;
- [ ] documentação e checklist refletem o estado real.

## Aprovação do plano

| Decisão | Autoridade | Data | Registro |
| --- | --- | --- | --- |
| Revisão do plano | {{RESPONSAVEL_HUMANO}} | — | `PENDENTE` |
| Aprovação do plano | {{RESPONSAVEL_HUMANO}} | — | `PENDENTE` |

O `GO` de implementação é uma decisão separada e deve aparecer em `todo.md`.

## Histórico de mudanças

| Data | Autoridade | Mudança | Motivo | Impacto em tarefas/checkpoints |
| --- | --- | --- | --- | --- |
| {{DATA_MUDANCA_AAAA_MM_DD}} | {{AUTOR_MUDANCA}} | Plano criado como `RASCUNHO` | {{MOTIVO_INICIAL}} | {{IMPACTO_INICIAL}} |
