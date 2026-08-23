# Goal — {{NOME_DO_GOAL}}

## Identificação

- ID: `{{ID_DO_GOAL}}`
- Estado: `RASCUNHO`
- Responsável humano: `{{RESPONSAVEL_HUMANO}}`
- Data de criação: `{{DATA_CRIACAO_AAAA_MM_DD}}`
- Última revisão: `{{DATA_REVISAO_AAAA_MM_DD}}`
- Specs relacionadas: `{{CAMINHOS_DAS_SPECS_OU_NENHUMA}}`
- Features relacionadas: `{{CAMINHOS_DAS_FEATURES_OU_NENHUMA}}`

> Substitua todos os marcadores `{{CAMPO}}`. Campo desconhecido deve virar questão ou bloqueio explícito; não invente.

## Problema

{{PROBLEMA_ATUAL_E_QUEM_E_AFETADO}}

## Objetivo

{{RESULTADO_QUE_DEVE_EXISTIR_AO_FINAL}}

## Valor esperado

{{VALOR_PERCEBIDO_POR_PESSOAS_OU_SISTEMAS}}

## Usuários e partes interessadas

- Beneficiário principal: {{BENEFICIARIO_PRINCIPAL}}
- Outras partes interessadas: {{OUTRAS_PARTES_OU_NENHUMA}}
- Autoridade de aceite: {{AUTORIDADE_DE_ACEITE}}

## Resultados observáveis

- {{RESULTADO_OBSERVAVEL_1}}
- {{RESULTADO_OBSERVAVEL_2}}
- {{RESULTADO_OBSERVAVEL_3_OU_REMOVER}}

## Escopo

- {{ITEM_EM_ESCOPO_1}}
- {{ITEM_EM_ESCOPO_2}}

## Fora de escopo

- {{ITEM_FORA_DE_ESCOPO_1}}
- {{ITEM_FORA_DE_ESCOPO_2}}

## Critérios de sucesso

1. {{CRITERIO_MENSURAVEL_1}}
2. {{CRITERIO_MENSURAVEL_2}}
3. {{CRITERIO_MENSURAVEL_3}}

## Definição de pronto

O goal estará tecnicamente pronto quando:

- [ ] todas as specs aprovadas satisfizerem seus critérios de aceitação;
- [ ] verificações funcionais, arquiteturais, de segurança e observabilidade aplicáveis passarem;
- [ ] resultado Sonar estiver evidenciado ou corretamente marcado como `UNVERIFIED`;
- [ ] documentação e estado implementado estiverem alinhados;
- [ ] riscos, limitações e exceções estiverem registrados;
- [ ] {{CONDICAO_DE_PRONTO_ESPECIFICA_1}};
- [ ] {{CONDICAO_DE_PRONTO_ESPECIFICA_2}}.

Pronto técnico não significa aceite. Nesse estado, o agente para e solicita verificação humana.

## Evidências obrigatórias

| Critério | Evidência esperada | Local da evidência | Estado |
| --- | --- | --- | --- |
| {{CRITERIO_1}} | {{EVIDENCIA_1}} | {{CAMINHO_1}} | `PENDENTE` |
| {{CRITERIO_2}} | {{EVIDENCIA_2}} | {{CAMINHO_2}} | `PENDENTE` |
| {{CRITERIO_3}} | {{EVIDENCIA_3}} | {{CAMINHO_3}} | `PENDENTE` |

Não marque evidência como concluída sem resultado observável. Indisponibilidade fica explícita e não equivale a aprovação.

## Condições de parada do agente

O agente deve parar e solicitar decisão humana:

- antes da primeira alteração de produção;
- diante de mudança de escopo, valor ou definição de pronto;
- antes de alterar contrato, arquitetura, segurança ou comportamento observável;
- quando faltar requisito, credencial, destino ou autoridade material;
- quando houver não conformidade Sonar ou evidência `UNVERIFIED` relevante;
- quando os critérios técnicos estiverem atendidos;
- {{CONDICAO_DE_PARADA_ESPECIFICA_OU_REMOVER}}.

## Dependências

- {{DEPENDENCIA_1_OU_NENHUMA}}
- {{DEPENDENCIA_2_OU_REMOVER}}

## Riscos

| Risco | Impacto | Probabilidade | Mitigação | Responsável |
| --- | --- | --- | --- | --- |
| {{RISCO_1}} | {{ALTO_MEDIO_BAIXO}} | {{ALTA_MEDIA_BAIXA}} | {{MITIGACAO_1}} | {{RESPONSAVEL_1}} |
| {{RISCO_2_OU_REMOVER}} | {{IMPACTO_2}} | {{PROBABILIDADE_2}} | {{MITIGACAO_2}} | {{RESPONSAVEL_2}} |

## Checkpoints humanos

| Checkpoint | Decisão possível | Estado | Data | Registro humano |
| --- | --- | --- | --- | --- |
| Aprovação do goal | `GOAL_APROVADO` ou `REVISAR` | `PENDENTE` | — | — |
| GO de feature | `GO` ou `NO-GO` | `PENDENTE` | — | — |
| Exceção técnica | `Reprovar`, `AceitarExcepcionalmente` ou `ContinuarAjustes` | `NÃO_APLICÁVEL` | — | — |
| Aceite final | `ACEITO` ou `REVISAR` | `PENDENTE` | — | — |
| Encerramento | `ENCERRADO` | `PENDENTE` | — | — |

Somente o humano preenche decisões nas duas últimas colunas.

## Decisões e mudanças do goal

| Data | Autoridade | Decisão | Motivo | Impacto em specs/tasks |
| --- | --- | --- | --- | --- |
| {{DATA_DECISAO_AAAA_MM_DD}} | {{HUMANO}} | Goal criado como `RASCUNHO` | {{MOTIVO_INICIAL}} | {{IMPACTO_INICIAL}} |

Não reescreva registros anteriores. Acrescente uma linha para cada mudança aprovada.

## Significado de encerramento

Este goal só está encerrado quando {{AUTORIDADE_DE_ACEITE}} revisar evidências, registrar `ACEITO` e depois `ENCERRADO`. Testes verdes, build, Sonar ou conclusão do checklist não substituem essa decisão.
