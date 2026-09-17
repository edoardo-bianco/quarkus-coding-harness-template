# ADR-0006: Reconhecer o ambiente existente antes de adotar o harness

- **Status:** Proposto
- **Decisão em uma frase:** diagnosticar o ambiente do produto e obter escolha humana entre manter versões ou planejar alterações antes de integrar controles executáveis.
- **Quando consultar:** adoção em repositório existente, escolha de JDK/Quarkus/Maven ou avaliação de compatibilidade dos controles.

## Contexto

A stack de um template comprova uma combinação de ferramentas; ela não descreve todos os produtos
existentes. Obrigar um legado a atualizar versões para receber governança mistura adoção do harness
com migração da aplicação. Por outro lado, copiar scripts e declarar suporte sem ensaio esconde
dependências reais do build, scanner, cobertura e ambiente.

## Decisão proposta

1. Reconhecer versões declaradas, sua origem e o ambiente efetivo. Separar alvo Java, JDK que
   executa Maven, eventual toolchain, plataforma/plugin Quarkus e distribuição Maven/Wrapper.
2. Apresentar arquivos/chaves e lacunas. Pedir ao humano manter a configuração existente ou
   selecionar componentes e versões-alvo. Se ainda não souber os alvos, apresentar opções com
   fontes oficiais e aguardar sua escolha; não preencher com versões do template.
3. Ao manter, preservar versões, identidade, contratos e arquitetura do produto, planejando
   somente a integração dos controles. Compatibilidade continua não verificada até evidência.
4. Ao alterar, preparar matriz atual/proposto, impacto, plano, validação e reversão. Mudanças
   reais exigem GO e checkpoints aplicáveis; a escolha de uma versão não os substitui.
5. Registrar incompatibilidades por controle. Parar o controle afetado quando não houver
   execução válida; propor adaptação ou decisão humana, sem atualizar o produto automaticamente.
6. Repetir a conferência do ambiente efetivo, build/testes/cobertura e Sonar no produto após as
   alterações autorizadas. Baseline e decisões pertencem ao produto.

O [ADR-0001](0001-java-25-quarkus-lts-maven.md) continua regendo a fundação do template e a
materialização de novos projetos. Esta proposta trata a adoção em produtos já existentes;
não substitui aquela decisão nem altera versões do template. Build tools ou tecnologias diferentes
de Java/Quarkus/Maven exigem planejamento próprio dos controles.

## Consequências

- Adoção e atualização podem ser planejadas separadamente, com escolhas humanas rastreáveis.
- O guia precisa mapear parent, perfis, IDE, CI e imagens quando existentes, sem presumir que
  editar uma propriedade do POM altera o JDK instalado.
- Uma combinação antiga pode exigir adaptação de scanner, cobertura ou testes; não se promete
  compatibilidade universal nem se transferem métricas do template.
- Instruções são interpretadas pelo agente; não há instalador nem detector executável novo.

## Alternativas consideradas

- **Impor versões do template a todo produto:** mistura migração com o objetivo de adoção.
- **Copiar tudo sem diagnóstico:** pode substituir configuração válida e produzir evidência falsa.
- **Escolher versões pelo humano após diagnóstico:** preserva autoridade e permite limitar cada
  mudança ao que foi efetivamente pedido e verificado.

## Referências

- [Guia de adoção](../guias/adotar-harness-repositorio-existente.md).
- [ADR-0003 — autoridade humana](0003-governanca-sdlc-humano-agente.md).
- [ADR-0004 — evidências e decisão Sonar](0004-sonarqube-checkpoint-decisao-humana.md).
