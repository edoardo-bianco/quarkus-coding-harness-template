# ADR-0004: SonarQube como checkpoint técnico com decisão humana

- **Status:** Proposto
- **Decisão em uma frase:** usar SonarQube, scripts e hooks para produzir evidência técnica verificável, preservando estados de incerteza e autoridade humana sobre não conformidades.
- **Quando consultar:** mudanças em hooks, scripts, token, baseline, fingerprint, thresholds, pacotes offline, Quality Gate ou exceções.

## Contexto

Qualidade precisa ser comparada a um baseline e vinculada ao incremento atual. O servidor, token ou pacote offline pode estar indisponível ou representar outro ambiente. Um hook também não deve alegar aprovação nem bloquear trabalho documental que não altera o produto executável.

## Decisão

- token Sonar existe somente na memória do processo iniciado por script seguro;
- escopo exclusivamente Markdown não solicita token nem executa baseline ou checkpoint;
- se houver pacote offline, humano escolhe baseline local, local + pacote específico ou offline-only específico;
- offline-only é registrado como `UNVERIFIED` e não comprova Quality Gate, cobertura, duplicação ou estado atual;
- checkpoint ocorre após incremento executável coerente que altere o fingerprint;
- política inicial exige zero issue nova, zero issue `HIGH/BLOCKER/CRITICAL`, cobertura mínima de 85% e duplicação máxima de 5%;
- violação produz `NON_COMPLIANT`; humano decide `Reprovar`, `AceitarExcepcionalmente` ou `ContinuarAjustes`;
- hook de parada apenas lembra pendências.

Cada projeto derivado cria baseline próprio. Estado, snapshot e relatório do template ou de outro projeto não são copiados.

## Consequências

- resultado técnico não é confundido com decisão de produto;
- indisponibilidade permanece visível;
- scripts e hooks tornam-se software crítico e precisam de testes automatizados;
- a primeira versão depende de SonarQube local para verificação completa.

## Alternativas rejeitadas

- **Quality Gate como aprovação humana automática:** ferramenta não conhece escopo nem valor aceito.
- **Bloquear todo Markdown sem Sonar:** custo sem alteração do fingerprint executável.
- **Tratar pacote offline como servidor atual:** produz garantia falsa.
- **Persistir token para facilitar uso:** expõe segredo em arquivos, argumentos ou histórico.
