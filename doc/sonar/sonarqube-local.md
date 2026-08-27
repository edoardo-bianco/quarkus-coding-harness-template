# SonarQube local: cobertura, sessão e análise

Os Incrementos 9 e 10 entregam cobertura XML, uma sessão Codex com credencial somente em memória e
o envio de análise local. Baseline, espera do Compute Engine, checkpoint e decisão humana
pertencem aos incrementos seguintes. Até que esses componentes sejam autorizados, implementados e
executados, o estado Sonar permanece `UNVERIFIED`: relatório ou envio local não comprovam Quality
Gate, issues, duplicação nem análise concluída.

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

## Iniciar uma sessão segura

Na raiz do repositório, execute:

```powershell
.\iniciar-codex-com-sonar.ps1
```

Informe a credencial somente no prompt protegido. Nunca cole token no chat, em parâmetro, arquivo,
log ou commit. O launcher disponibiliza `SONAR_TOKEN` apenas no ambiente do processo Codex filho,
restaura o valor anterior quando esse processo termina, zera/libera o BSTR e descarta as referências
temporárias usadas na conversão do `SecureString`.

Argumentos adicionais são encaminhados ao Codex. O token não é um argumento aceito pelo script.

## Enviar a análise

Dentro da sessão Codex iniciada pelo launcher, execute:

```powershell
.\analisar-sonarqube.ps1
```

Por padrão, a chave é `<groupId>:<artifactId>`, o nome vem do `pom.xml` e o servidor é
`http://localhost:9000`. Uma identidade própria e outra URL podem ser informadas sem credencial:

```powershell
.\analisar-sonarqube.ps1 `
  -ProjectKey "meu.grupo:meu-artefato" `
  -ProjectName "Meu Projeto" `
  -SonarUrl "http://localhost:9000"
```

O analisador rejeita credencial embutida na URL e metacaracteres nas entradas, exige
`SONAR_TOKEN` no processo e confirma `/api/system/status` como `UP`. Em seguida, remove metadado
antigo e usa o Maven Wrapper para executar `clean verify` e o SonarScanner for Maven fixado em
`5.5.0.6356`. O scanner usa o JDK da sessão, que deve ser o JDK 25 exigido pelo template, lê o token
somente do ambiente e deve produzir `target/sonar/report-task.txt` novo.

O arquivo contém o identificador necessário para consultar o Compute Engine no futuro checkpoint;
ele não comprova que a análise terminou. Token ausente, servidor indisponível, Maven não zero ou
metadado ausente são limitações/falhas explícitas, nunca aprovação ou conformidade.

## Segurança e identidade

O POM não persiste token, URL de servidor, chave ou nome de projeto Sonar. O launcher e o analisador
não aceitam token como parâmetro e os testes usam somente segredos sintéticos. Nenhuma credencial é
necessária para gerar o relatório JaCoCo local.

## Referências oficiais

- [Cobertura de testes no Quarkus 3.33](https://quarkus.io/version/3.33/guides/tests-with-coverage)
- [Parâmetros de cobertura do SonarQube](https://docs.sonarsource.com/sonarqube-server/analyzing-source-code/test-coverage/test-coverage-parameters)
- [Cobertura Java no SonarQube](https://docs.sonarsource.com/sonarqube-server/analyzing-source-code/test-coverage/java-test-coverage)
- [SonarScanner for Maven](https://docs.sonarsource.com/sonarqube-server/analyzing-source-code/scanners/sonarscanner-for-maven)
- [Parâmetros de análise Sonar](https://docs.sonarsource.com/sonarqube-server/analyzing-source-code/analysis-parameters/parameters-not-settable-in-ui)
- [`Read-Host -AsSecureString`](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/read-host)
- [Escopos de variáveis de ambiente](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_environment_variables)
- [`SecureStringToBSTR`](https://learn.microsoft.com/en-us/dotnet/api/system.runtime.interopservices.marshal.securestringtobstr)
- [`cmd /c`](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/cmd)
