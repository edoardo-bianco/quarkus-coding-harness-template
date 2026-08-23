# Especificação — {{NOME_DA_MUDANCA}}

## Metadados

- ID: `{{ID_DA_SPEC}}`
- Estado: `RASCUNHO`
- Goal principal: `{{CAMINHO_DO_GOAL}}`
- Responsável humano: `{{RESPONSAVEL_HUMANO}}`
- Data de criação: `{{DATA_CRIACAO_AAAA_MM_DD}}`
- Última revisão: `{{DATA_REVISAO_AAAA_MM_DD}}`
- Arquitetura: `{{CAMINHO_DA_ARQUITETURA}}`
- ADRs aplicáveis: `{{ADRS_OU_NENHUM}}`

> Substitua todos os marcadores `{{CAMPO}}`. Campo desconhecido deve virar questão ou bloqueio explícito; não invente.

## Problema e contexto

{{PROBLEMA_CONTEXTO_E_EVIDENCIA_ATUAL}}

## Objetivo

{{RESULTADO_ESPERADO_E_VALOR_PARA_O_USUARIO}}

## Usuários e cenários

- Usuário/ator principal: {{ATOR_PRINCIPAL}}
- Cenário principal: {{CENARIO_PRINCIPAL}}
- Cenários secundários: {{CENARIOS_SECUNDARIOS_OU_NENHUM}}

## Hipóteses a confirmar

| Hipótese | Evidência atual | Impacto se falsa | Decisão humana |
| --- | --- | --- | --- |
| {{HIPOTESE_1}} | {{EVIDENCIA_HIPOTESE_1}} | {{IMPACTO_HIPOTESE_1}} | `PENDENTE` |
| {{HIPOTESE_2_OU_REMOVER}} | {{EVIDENCIA_HIPOTESE_2}} | {{IMPACTO_HIPOTESE_2}} | `PENDENTE` |

Hipótese material pendente impede aprovação.

## Escopo

- {{ITEM_EM_ESCOPO_1}}
- {{ITEM_EM_ESCOPO_2}}

## Fora de escopo

- {{ITEM_FORA_DE_ESCOPO_1}}
- {{ITEM_FORA_DE_ESCOPO_2}}

## Stack e versões

| Componente | Versão | Motivo/fonte oficial | Estado |
| --- | --- | --- | --- |
| Java | `25` | {{FONTE_JAVA}} | `CONFIRMADO` |
| Quarkus | `3.33.3.1 LTS` | {{FONTE_QUARKUS}} | `CONFIRMADO` |
| Maven | `{{VERSAO_MAVEN_WRAPPER}}` | {{FONTE_MAVEN}} | `PENDENTE` |
| {{DEPENDENCIA_ADICIONAL_OU_REMOVER}} | `{{VERSAO_DEPENDENCIA}}` | {{MOTIVO_E_FONTE}} | `PENDENTE` |

Dependência nova exige necessidade concreta, fonte oficial e checkpoint quando alterar arquitetura, segurança ou operação.

## Comandos

| Finalidade | Comando completo | Estado | Última evidência |
| --- | --- | --- | --- |
| Validar ambiente | `{{COMANDO_VALIDAR_AMBIENTE}}` | `NÃO_VERIFICADO` | — |
| Build/teste | `{{COMANDO_BUILD_TESTE}}` | `NÃO_VERIFICADO` | — |
| Teste focado | `{{COMANDO_TESTE_FOCADO}}` | `NÃO_VERIFICADO` | — |
| Executar local | `{{COMANDO_EXECUCAO_LOCAL}}` | `NÃO_VERIFICADO` | — |
| Qualidade/Sonar | `{{COMANDO_QUALIDADE}}` | `NÃO_VERIFICADO` | — |

Só mude para `VERIFICADO` após executar o comando no repositório atual e registrar resultado.

## Estrutura do projeto

```text
{{ESTRUTURA_DE_DIRETORIOS_E_RESPONSABILIDADES}}
```

Regras de dependência relevantes:

- {{REGRA_DE_DEPENDENCIA_1}}
- {{REGRA_DE_DEPENDENCIA_2}}
- {{REGRA_DE_DEPENDENCIA_3_OU_REMOVER}}

## Estilo e convenções

- Nomes de domínio refletem a linguagem aprovada; nomes técnicos não criam domínio.
- DTOs e mappers permanecem na borda proprietária.
- Portas existem somente para fronteiras e consumidores concretos.
- {{CONVENCAO_ESPECIFICA_1}}

Exemplo de estilo pretendido — substitua por um padrão real da capacidade quando ele existir:

```java
public record SampleValue(String value) {
    public SampleValue {
        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException("value must not be blank");
        }
    }
}
```

## Requisitos funcionais

### RF-001 — {{NOME_REQUISITO_1}}

- Dado: {{PRECONDICAO_1}}
- Quando: {{ACAO_1}}
- Então: {{RESULTADO_1}}
- Erro/limite: {{ERRO_OU_LIMITE_1}}

### RF-002 — {{NOME_REQUISITO_2_OU_REMOVER}}

- Dado: {{PRECONDICAO_2}}
- Quando: {{ACAO_2}}
- Então: {{RESULTADO_2}}
- Erro/limite: {{ERRO_OU_LIMITE_2}}

## Requisitos não funcionais

| ID | Requisito mensurável | Evidência |
| --- | --- | --- |
| RNF-001 | {{REQUISITO_NAO_FUNCIONAL_1}} | {{EVIDENCIA_RNF_1}} |
| RNF-002 | {{REQUISITO_NAO_FUNCIONAL_2}} | {{EVIDENCIA_RNF_2}} |

## Contratos e interfaces

| Borda/contrato | Entrada | Saída | Erros | Compatibilidade |
| --- | --- | --- | --- | --- |
| {{BORDA_1}} | {{ENTRADA_1}} | {{SAIDA_1}} | {{ERROS_1}} | {{REGRA_COMPATIBILIDADE_1}} |

Se não houver contrato público ou externo, registre `NÃO_APLICÁVEL` e explique. Path, verbo, status, JSON, validação, schema e OpenAPI exigem checkpoint humano antes da implementação.

## Dados e consistência

- Persistência necessária: {{SIM_NAO_E_MOTIVO}}
- Modelo/ownership: {{MODELO_E_PROPRIETARIO_OU_NAO_APLICAVEL}}
- Transação local: {{LIMITE_TRANSACIONAL_OU_NAO_APLICAVEL}}
- Dupla escrita banco-broker: {{NAO_APLICAVEL_OU_ESTRATEGIA_OUTBOX}}
- Idempotência: {{ESTRATEGIA_OU_NAO_APLICAVEL}}
- Retenção/expurgo: {{POLITICA_OU_NAO_APLICAVEL}}

É proibida dupla escrita sequencial direta. Quando aplicável, consulte o [ADR-0005](../../doc/adr/0005-outbox-aplicacional-dupla-escrita.md).

## Mensageria e assincronicidade

- Aplicável: {{SIM_NAO}}
- Evento de domínio: {{EVENTO_DOMINIO_OU_NAO_APLICAVEL}}
- Evento de integração/schema: {{EVENTO_INTEGRACAO_OU_NAO_APLICAVEL}}
- Semântica de entrega: {{SEMANTICA_OU_NAO_APLICAVEL}}
- Momento do ack: {{ACK_OU_NAO_APLICAVEL}}
- Retry/quarentena: {{POLITICA_OU_NAO_APLICAVEL}}
- Ordenação/concorrência/backpressure: {{DECISOES_OU_NAO_APLICAVEL}}
- Idempotência do consumidor: {{ESTRATEGIA_OU_NAO_APLICAVEL}}

## Segurança e privacidade

- Superfícies de entrada: {{SUPERFICIES}}
- Autenticação/autorização: {{ESTRATEGIA_OU_NAO_APLICAVEL}}
- Dados sensíveis: {{DADOS_E_TRATAMENTO_OU_NENHUM}}
- Ameaças/abuso relevantes: {{AMEACAS_E_MITIGACOES}}
- Segredos/configuração: {{ORIGEM_E_PROTECAO}}

## Observabilidade

| Sinal | Nome/contrato | Atributos permitidos | Atributos proibidos | Evidência |
| --- | --- | --- | --- | --- |
| Log | {{LOG}} | {{ATRIBUTOS_LOG}} | {{PROIBIDOS_LOG}} | {{TESTE_LOG}} |
| Span | {{SPAN}} | {{ATRIBUTOS_SPAN}} | {{PROIBIDOS_SPAN}} | {{TESTE_SPAN}} |
| Métrica | {{METRICA}} | {{LABELS_BAIXA_CARDINALIDADE}} | {{LABELS_PROIBIDAS}} | {{TESTE_METRICA}} |
| Health | {{HEALTH_OU_NAO_APLICAVEL}} | {{DETALHES_HEALTH}} | {{PROIBIDOS_HEALTH}} | {{TESTE_HEALTH}} |

Mudança observável exige checkpoint humano. Não registre payload, credencial ou identificador de alta cardinalidade sem decisão de segurança.

## Estratégia de testes

| Risco/comportamento | Nível de teste | Local provável | Comando/evidência |
| --- | --- | --- | --- |
| {{RISCO_1}} | {{UNITARIO_COMPONENTE_CONTRATO_INTEGRACAO}} | {{LOCAL_TESTE_1}} | {{COMANDO_1}} |
| {{RISCO_2}} | {{NIVEL_2}} | {{LOCAL_TESTE_2}} | {{COMANDO_2}} |
| Direção arquitetural | ArchUnit | `src/test/java/.../architecture` | {{COMANDO_ARCHUNIT}} |
| Regressão e cobertura | Suíte + JaCoCo | `target/` | {{COMANDO_VERIFY}} |

Meta de cobertura Sonar inicial: 85%; duplicação máxima: 5%. Metas não substituem testes dos riscos relevantes.

## Limites de atuação

### Sempre fazer

- validar entradas e preservar contratos aprovados;
- executar testes proporcionais ao incremento;
- atualizar spec/plano/todo antes de mudança de escopo;
- {{SEMPRE_FAZER_ESPECIFICO}}.

### Perguntar antes

- mudar contrato, arquitetura, segurança ou observabilidade;
- adicionar dependência, persistência, broker ou workflow;
- aceitar não conformidade ou alterar definição de pronto;
- {{PERGUNTAR_ANTES_ESPECIFICO}}.

### Nunca fazer

- inventar requisito, decisão humana, credencial ou destino;
- persistir segredo ou copiar baseline/estado Sonar;
- remover teste falho para obter verde;
- criar abstração ou integração futura não aprovada;
- {{NUNCA_FAZER_ESPECIFICO}}.

## Critérios de aceitação e rastreabilidade

| ID | Critério observável | Requisito | Evidência esperada | Estado |
| --- | --- | --- | --- | --- |
| CA-001 | {{CRITERIO_ACEITACAO_1}} | {{RF_RNF_1}} | {{EVIDENCIA_CA_1}} | `PENDENTE` |
| CA-002 | {{CRITERIO_ACEITACAO_2}} | {{RF_RNF_2}} | {{EVIDENCIA_CA_2}} | `PENDENTE` |
| CA-003 | {{CRITERIO_ACEITACAO_3}} | {{RF_RNF_3}} | {{EVIDENCIA_CA_3}} | `PENDENTE` |

## Migração, compatibilidade e rollback

- Migração necessária: {{SIM_NAO_E_PLANO}}
- Compatibilidade a preservar: {{CONTRATOS_OU_NAO_APLICAVEL}}
- Rollback/reversão: {{ESTRATEGIA_OU_NAO_APLICAVEL}}
- Dados existentes: {{TRATAMENTO_OU_NAO_APLICAVEL}}

## Dependências e riscos

| Item | Tipo | Impacto | Mitigação/responsável |
| --- | --- | --- | --- |
| {{DEPENDENCIA_OU_RISCO_1}} | {{DEPENDENCIA_RISCO}} | {{IMPACTO_1}} | {{MITIGACAO_RESPONSAVEL_1}} |
| {{DEPENDENCIA_OU_RISCO_2}} | {{TIPO_2}} | {{IMPACTO_2}} | {{MITIGACAO_RESPONSAVEL_2}} |

## Questões abertas

| Questão | Opções conhecidas | Impacto | Responsável pela decisão | Estado |
| --- | --- | --- | --- | --- |
| {{QUESTAO_1_OU_NENHUMA}} | {{OPCOES_1}} | {{IMPACTO_QUESTAO_1}} | {{HUMANO_1}} | `PENDENTE` |

Questão material pendente impede `APROVADO`. Se nenhuma existir, substitua a tabela por “Nenhuma”.

## Aprovação humana

| Decisão | Autoridade | Data | Registro |
| --- | --- | --- | --- |
| Revisão da spec | {{RESPONSAVEL_HUMANO}} | — | `PENDENTE` |
| Aprovação da spec | {{RESPONSAVEL_HUMANO}} | — | `PENDENTE` |

Aprovação da spec autoriza planejamento, não código. GO de implementação é registrado em `tasks/todo.md`.

## Histórico de mudanças

| Data | Autoridade | Mudança | Motivo | Impacto |
| --- | --- | --- | --- | --- |
| {{DATA_MUDANCA_AAAA_MM_DD}} | {{AUTOR_DA_MUDANCA}} | Spec criada como `RASCUNHO` | {{MOTIVO_INICIAL}} | {{IMPACTO_INICIAL}} |
