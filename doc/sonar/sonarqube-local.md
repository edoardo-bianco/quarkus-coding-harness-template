# Cobertura local e propriedades Sonar

Este guia descreve somente a configuração de build entregue no Incremento 9. Os scripts de
sessão, análise, baseline e checkpoint pertencem aos incrementos seguintes e ainda não existem.
Por isso, o estado do SonarQube permanece `UNVERIFIED`: um relatório local não comprova Quality
Gate, issues, duplicação nem o estado de um servidor.

## Gerar o relatório de cobertura

Na raiz do repositório, execute:

```powershell
.\mvnw.cmd -q verify
```

A dependência de teste `io.quarkus:quarkus-jacoco` instrumenta os testes Quarkus e gera o relatório
XML em `target/jacoco-report/jacoco.xml`. A propriedade Maven
`sonar.coverage.jacoco.xmlReportPaths` aponta o analisador para esse artefato. O
`jacoco-maven-plugin` não é configurado em paralelo, evitando instrumentação duplicada com a
extensão Quarkus.

## Política e exclusões

A política inicial do futuro checkpoint exige:

- nenhuma issue nova;
- nenhuma issue `HIGH`, `BLOCKER` ou `CRITICAL`;
- cobertura mínima de 85%;
- duplicação máxima de 5%.

Não há nenhuma exclusão de cobertura configurada. Todas as classes de produção da feature neutra
continuam elegíveis para o relatório; excluir código nesse estágio reduziria a utilidade da prova.
Diretórios de build, relatórios e fontes de teste já não pertencem ao conjunto de fontes de produção
e não exigem uma regra adicional.

O Incremento 9 gera evidência consumível, mas não aplica sozinho os limites acima. A comparação e a
decisão humana serão implementadas apenas no incremento autorizado correspondente.

## Segurança e identidade

O POM não persiste token, URL de servidor, chave ou nome de projeto Sonar. Uma futura sessão segura
deverá fornecer `SONAR_TOKEN` somente pela memória do processo, nunca por arquivo, argumento, log,
relatório ou commit. Nenhuma credencial é necessária para gerar o relatório JaCoCo local.

## Referências oficiais

- [Cobertura de testes no Quarkus 3.33](https://quarkus.io/version/3.33/guides/tests-with-coverage)
- [Parâmetros de cobertura do SonarQube](https://docs.sonarsource.com/sonarqube-server/analyzing-source-code/test-coverage/test-coverage-parameters)
- [Cobertura Java no SonarQube](https://docs.sonarsource.com/sonarqube-server/analyzing-source-code/test-coverage/java-test-coverage)
