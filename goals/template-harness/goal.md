# Goal — Entregar o template de harness Quarkus

## Identificação

- Estado: `PLANEJADO`
- Responsável pela decisão final: humano
- Especificação: `specs/template-harness/spec.md`
- Feature de implementação: `tasks/features/bootstrap-harness/`

## Objetivo

Entregar um repositório-template interno, executável e verificável para iniciar projetos Java 25 com Quarkus 3.33.3.1 LTS e Maven, incorporando o harness de planejamento, arquitetura, qualidade, SonarQube, observabilidade e aprovação humana.

## Valor esperado

- Reduzir decisões repetidas e omissões ao iniciar um projeto.
- Dar ao agente contexto persistente, limites de autonomia e significado objetivo de pronto.
- Proteger o núcleo de negócio sem impedir o uso pragmático do ecossistema Quarkus.
- Tornar qualidade e decisões humanas evidenciáveis, sem fingir garantias quando ferramentas estiverem indisponíveis.
- Reutilizar aprendizado técnico sem transportar lógica ou histórico de negócio do repositório-fonte.

## Escopo

- Harness documental e operacional para o SDLC assistido por agente.
- Projeto Maven com JDK 25 e Quarkus 3.33.3.1 LTS.
- Feature neutra executável.
- Testes de comportamento, integração, arquitetura e observabilidade.
- Hooks, scripts e testes do fluxo SonarQube local e offline.
- Padrões registrados para DDD hexagonal pragmático, mensageria e Transactional Outbox.
- Guia para materializar um projeto real a partir do template.

## Fora de escopo

- Variante independente de tecnologia.
- CI/CD e deploy sem requisitos aprovados.
- Banco, broker, Debezium, XA ou cloud provisionados preventivamente.
- Domínio de negócio real.
- Guardrails e evals ainda não especificados.

## Definição de pronto

O goal estará tecnicamente pronto quando:

- todos os critérios da especificação estiverem demonstrados;
- `mvn verify` passar com JDK 25;
- feature neutra, arquitetura e observabilidade tiverem testes verdes;
- hooks e scripts Sonar tiverem testes automatizados verdes;
- um baseline novo puder ser criado sem segredo persistido;
- o conteúdo tiver sido auditado contra conceitos e artefatos do projeto-fonte;
- o guia de materialização tiver sido ensaiado em uma cópia descartável;
- riscos, limitações e eventuais exceções estiverem registrados;
- o diff final tiver revisão de correção, simplicidade, arquitetura, segurança, desempenho, testes e escopo.

## Evidências obrigatórias

- relatórios Maven, testes e cobertura;
- resultados ArchUnit e dos testes PowerShell;
- evidência da feature neutra e dos sinais observáveis;
- evidência do ensaio de materialização;
- auditoria de segredos, estados, relatórios e vocabulário de negócio proibidos;
- resultado Sonar ou limitação explicitamente marcada como `UNVERIFIED`;
- registros dos checkpoints humanos.

## Condições de parada do agente

O agente deve parar e solicitar decisão humana:

- antes da primeira alteração de código ou tooling;
- antes de alterar contrato público, arquitetura, segurança ou comportamento observável;
- quando o escopo necessário divergir da especificação ou do plano;
- quando surgir não conformidade Sonar;
- quando uma credencial, destino remoto ou requisito organizacional estiver ausente;
- quando todos os critérios técnicos estiverem atendidos, para verificação e encerramento humanos.

## Significado de encerramento

Pronto técnico não encerra este goal. Somente o humano pode registrar `ACEITO` e `ENCERRADO`, após revisar as evidências. O agente não transforma silêncio, sucesso de testes ou Quality Gate em aceitação humana.

## Checkpoints

| Checkpoint | Estado | Autoridade |
| --- | --- | --- |
| Especificação e decisões de escopo | `APROVADO` em 2026-08-22 | Humano |
| Arquitetura, ADRs e plano | `APROVADO` em 2026-08-23 | Humano |
| Primeira alteração de código/tooling | `APROVADO` em 2026-08-23 para o Incremento 4 | Humano |
| Contratos, arquitetura, segurança e observabilidade | `PENDENTE conforme incremento` | Humano |
| Não conformidade Sonar, se houver | `PENDENTE conforme evidência` | Humano |
| Aceite e encerramento do goal | `PENDENTE` | Humano |

## Evidências parciais

- Incrementos 1–3 e o Checkpoint A de governança foram concluídos e aprovados pelo humano.
- O Incremento 4 criou somente a fundação Maven planejada: POM, Wrapper e exclusões locais.
- O Wrapper confirmou Maven 3.9.16 sobre Temurin JDK 25.0.3; `mvnw.cmd -q validate` passou.
- Sonar permanece `UNVERIFIED`, pois os scripts de baseline e checkpoint ainda não existem.
- Esta evidência não encerra o goal nem autoriza o Incremento 5.

## Decisões já registradas

- Quarkus 3.33.3.1 LTS com JDK 25.
- Identidade Maven informada ao materializar cada projeto, sem namespace fixo.
- Feature neutra removida somente após uma feature real comprovar o harness.
- Execução e SonarQube locais na primeira versão; CI/CD no backlog.
- Atualização Quarkus manual, planejada e aprovada dentro da linha LTS.
