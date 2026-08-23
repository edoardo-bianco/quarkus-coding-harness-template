# ADR-0001: Java 25, Quarkus LTS e Maven

- **Status:** Aceito
- **Decisão em uma frase:** usar JDK 25, Quarkus 3.33.3.1 da linha 3.33 LTS e Maven 3.9+ com Maven Wrapper, atualizados somente por mudança planejada e aprovada.
- **Quando consultar:** alterações de JDK, Quarkus, BOM, plugins Maven, Wrapper, lifecycle ou política de suporte.

## Contexto

O template precisa iniciar projetos reproduzíveis com uma base suportada, sem herdar automaticamente a versão do repositório-fonte nem seguir cada release de alta cadência. A linha Quarkus 3.33 é a LTS recomendada na data da decisão e incorpora suporte completo ao Java 25. Quarkus 3.31 passou a exigir Maven 3.9 ou superior.

## Decisão

O build fixa Java em 25 e o BOM/plugin Quarkus em `3.33.3.1`. O Maven Wrapper é versionado para eliminar dependência de uma instalação Maven arbitrária, respeitando o mínimo 3.9 exigido pela linha.

Atualizações de patch dentro de 3.33 LTS não são automáticas: começam por task própria, verificam notas oficiais, segurança, compatibilidade e testes, e recebem GO humano antes da alteração. Mudança de linha LTS, Java ou build tool exige novo ADR que substitua este.

## Consequências

- projetos derivados partem de versões explícitas e reproduzíveis;
- correções não entram silenciosamente, exigindo rotina humana de atualização;
- JDK 25 é requisito de desenvolvimento e CI futuro;
- a versão patch pode ficar defasada se o backlog de manutenção não for executado.

## Alternativas rejeitadas

- **Copiar Quarkus 3.33.2.1 do repositório-fonte:** já não é o patch LTS comunitário mais recente verificado.
- **Usar a release não LTS mais nova:** reduz previsibilidade e janela de manutenção.
- **Faixa de versão ou atualização automática:** compromete reprodutibilidade e pode introduzir mudança sem revisão.

## Fontes oficiais

- [Quarkus Releases](https://quarkus.io/releases/)
- [Quarkus 3.33 LTS](https://quarkus.io/blog/quarkus-3-33-released/)
- [Quarkus 3.31 e suporte ao Java 25](https://quarkus.io/blog/quarkus-3-31-released/)
