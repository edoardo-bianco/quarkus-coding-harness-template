# Diagnóstico de Diferenças entre `develop` e Feature/Tag com Git e TortoiseGit

**Nome sugerido do arquivo:**

```text
GUIA_DIAGNOSTICO_DIFERENCAS_DEVELOP_FEATURE_TORTOISEGIT.md
```

---

# 1. Escopo

Este documento define um procedimento simples para analisar diferenças entre:

```text
develop
```

que é a branch principal de integração do projeto, e:

```text
feature/<nome>
```

ou uma:

```text
<tag>
```

que representa uma versão ou conjunto de alterações utilizado como origem de um Pull Request para `develop`.

O procedimento utiliza:

* comandos Git para uma validação inicial objetiva;
* TortoiseGit para diagnóstico visual;
* histórico Git para entender a origem das diferenças.

Não é objetivo deste procedimento realizar:

* merge;
* rebase;
* cherry-pick;
* alteração das branches;
* correção automática das diferenças.

O objetivo é exclusivamente **diagnóstico e validação**.

---

# 2. Objetivo

Responder, de forma objetiva, às seguintes perguntas:

1. Quais alterações a feature pretende introduzir em `develop`?
2. Quais arquivos são diferentes?
3. Quais commits existem na feature e não estão em `develop`?
4. O conteúdo atual de `develop` ainda é diferente da feature ou tag?
5. Depois de um PR, existe alguma diferença que precisa ser investigada?
6. Onde as branches divergiram?
7. Quais diferenças são de conteúdo e quais são apenas diferenças de histórico?

O princípio utilizado será:

```text
Git CLI
   ↓
validação inicial

TortoiseGit
   ↓
diagnóstico visual

Revision Graph / Show Log
   ↓
contexto histórico

TortoiseGitMerge
   ↓
análise arquivo a arquivo
```

---

# 3. Índice

1. Escopo
2. Objetivo
3. Índice
4. Convenções
5. Conceito fundamental: `..` e `...`
6. Procedimento de validação
7. Diagnóstico com TortoiseGit
8. Como interpretar os resultados
9. Fluxo recomendado
10. Referências oficiais
11. Anexo A — Resumo de uma página

---

# 4. Convenções

Neste documento utilizaremos:

```text
BASE = develop
ALVO = feature ou tag
```

Exemplo com branch:

```text
origin/develop
origin/feature/minha-feature
```

Exemplo com tag:

```text
origin/develop
v1.2.0
```

Depois de atualizar o repositório, prefira utilizar a referência remota da branch quando a comparação deve refletir o que está no servidor:

```text
origin/develop
origin/feature/minha-feature
```

em vez de depender de uma branch local eventualmente desatualizada.

---

# 5. Conceito fundamental: `..` e `...`

Esta é a distinção mais importante deste procedimento.

Considere:

```text
                   F1────F2────F3   feature
                  /
A────B────C──────X────D1────D2      develop
                 ↑
             merge-base
```

`X` é o ancestral comum das duas branches.

---

## 5.1 Comparar os estados atuais

```bash
git diff origin/develop origin/feature/minha-feature
```

ou:

```bash
git diff origin/develop..origin/feature/minha-feature
```

compara:

```text
D2 ↔ F3
```

Ou seja:

> Qual é a diferença entre o conteúdo atual de `develop` e o conteúdo atual da feature?

Essa comparação é adequada para verificar se **os estados finais ainda são diferentes**.

A documentação oficial do Git define `git diff <commit> <commit>` como a comparação entre duas árvores/commits arbitrários.

---

## 5.2 Descobrir o que a feature introduziu

```bash
git diff origin/develop...origin/feature/minha-feature
```

compara conceitualmente:

```text
X → F3
```

Ou seja:

> Quais alterações a feature introduziu desde o ancestral comum com `develop`?

O Git documenta que:

```text
A...B
```

para `git diff` utiliza o `merge-base` de `A` e `B` como lado inicial e compara esse ponto com `B`.

Para analisar o conteúdo que uma feature pretende levar para `develop`, esta normalmente é a comparação mais útil.

---

# 6. Procedimento de validação

## 6.1 Atualizar as referências

Antes da análise:

```bash
git fetch origin --tags
```

O `fetch` atualiza branches remotas e objetos Git sem realizar merge no working tree. A opção `--tags` solicita também as tags do remoto.

No TortoiseGit:

```text
Botão direito no repositório
→ TortoiseGit
→ Fetch
```

---

## 6.2 Verificar o estado local

```bash
git status --short --branch
```

Objetivo:

* saber qual branch está ativa;
* identificar alterações locais;
* evitar confundir mudanças locais com a análise entre referências.

O `git status` apresenta o estado do working tree e do index em relação ao `HEAD`.

---

# 7. Validação da feature antes ou durante o PR

Supondo:

```text
BASE = origin/develop
ALVO = origin/feature/minha-feature
```

---

## 7.1 Quais arquivos a feature introduz?

```bash
git diff --name-status origin/develop...origin/feature/minha-feature
```

Exemplo:

```text
M   pom.xml
M   src/main/resources/application.properties
A   src/main/java/.../NovoService.java
D   src/main/java/.../LegacyService.java
```

Onde:

```text
M = Modified
A = Added
D = Deleted
R = Renamed
```

Esta deve ser a primeira visão do conteúdo do PR.

---

## 7.2 Qual é o tamanho da mudança?

```bash
git diff --stat origin/develop...origin/feature/minha-feature
```

Exemplo:

```text
pom.xml                  | 15 +++++---
Service.java             | 48 +++++++++++++++++---
application.properties   | 10 ++++
```

Use para identificar rapidamente os arquivos mais afetados.

---

## 7.3 Ver as diferenças completas

```bash
git diff origin/develop...origin/feature/minha-feature
```

Esse é o diff detalhado do conteúdo introduzido pela feature desde o ponto comum com `develop`.

---

## 7.4 Quais commits estão na feature e não em develop?

```bash
git log --oneline origin/develop..origin/feature/minha-feature
```

O Git define:

```text
A..B
```

como os commits alcançáveis a partir de `B`, excluindo os que também são alcançáveis a partir de `A`.

Portanto:

```text
develop..feature
```

responde:

> Quais commits estão na feature e ainda não fazem parte do histórico de develop?

---

# 8. Validar as diferenças atuais

Depois do PR, ou sempre que for necessário comparar o estado atual das duas referências, faça uma comparação direta.

```bash
git diff --name-status origin/develop origin/feature/minha-feature
```

### Resultado vazio

Se não houver saída:

```text
nenhuma diferença de conteúdo detectada
```

entre os dois snapshots comparados.

### Resultado com arquivos

Por exemplo:

```text
M   pom.xml
M   Service.java
A   OutraClasse.java
```

significa:

```text
develop
   ≠
feature
```

no estado atual.

Isso exige diagnóstico.

Não significa automaticamente que o PR esteja errado.

`develop` pode ter recebido outras alterações depois do PR.

---

# 9. Diagnóstico das diferenças com TortoiseGit

Depois da validação rápida pelo Git, use o TortoiseGit para investigar visualmente.

---

## 9.1 Atualizar o repositório

```text
Botão direito
→ TortoiseGit
→ Fetch
```

O TortoiseGit disponibiliza o Fetch para atualizar referências do remoto.

---

## 9.2 Abrir as referências

```text
Botão direito
→ TortoiseGit
→ Browse References
```

O Reference Browser permite trabalhar diretamente com:

```text
local branches
remote branches
tags
stash
```

A documentação oficial confirma que duas referências selecionadas podem ser comparadas diretamente.

---

## 9.3 Selecionar `develop` e a feature

Por exemplo:

```text
refs/remotes/origin/develop

refs/remotes/origin/feature/minha-feature
```

ou:

```text
origin/develop

tag v1.2.0
```

Selecione exatamente as duas referências.

---

## 9.4 Executar Compare

Use a opção de comparação das duas referências.

O resultado apresenta uma lista semelhante a:

```text
Action      Path

Modified    pom.xml
Modified    application.properties
Added       NovoService.java
Deleted     LegacyService.java
```

Essa visão responde:

> Quais arquivos são diferentes entre os dois estados atuais?

O manual do TortoiseGit documenta explicitamente a comparação entre branches e tags pelo Reference Browser.

---

# 10. Analisar um arquivo específico

Na lista de arquivos:

```text
duplo clique no arquivo
```

O TortoiseGit abrirá o:

```text
TortoiseGitMerge
```

permitindo analisar:

```text
versão A
    ↕
versão B
```

linha a linha.

O TortoiseGit utiliza o TortoiseGitMerge como ferramenta padrão para comparação visual de arquivos de texto.

---

# 11. Analisar o histórico pelo Show Log

Abra:

```text
TortoiseGit
→ Show Log
```

O Log apresenta:

* commits;
* autor;
* data;
* mensagem;
* arquivos alterados.

O painel inferior mostra os arquivos alterados pelo commit selecionado.

---

## 11.1 Commits existentes somente na feature

Pelo Reference Browser ou filtro do Log, utilize conceitualmente:

```text
develop..feature
```

Isso mostra os commits alcançáveis pela feature e não por `develop`.

É a visão histórica equivalente a:

```bash
git log origin/develop..origin/feature/minha-feature
```

---

## 11.2 Commits exclusivos dos dois lados

Para investigar divergência histórica:

```text
develop...feature
```

No contexto do `git log`, `A...B` representa a diferença simétrica dos históricos: commits que pertencem a um lado ou ao outro, excluindo os commits comuns aos dois.

No Git CLI:

```bash
git log --left-right --graph --oneline origin/develop...origin/feature/minha-feature
```

Exemplo:

```text
< alteração existente somente em develop
< outra alteração de develop

> alteração da feature
> outro commit da feature
```

---

# 12. Visualizar a topologia com Revision Graph

Quando o histórico não estiver claro:

```text
Botão direito
→ TortoiseGit
→ Revision Graph
```

Use para visualizar:

```text
                     feature
                        ●
                       /
                 ●────●
                /
●────●────●────●────●────● develop
             ↑
         divergência
```

O Revision Graph permite selecionar duas revisões com `Ctrl` e executar:

```text
Compare Revisions
```

A documentação oficial também recomenda a comparação pelos pontos finais das branches, normalmente os respectivos `HEADs`.

Use o Revision Graph principalmente para identificar:

* ponto de divergência;
* HEAD de cada branch;
* merges;
* commits exclusivos;
* relação histórica entre as referências.

---

# 13. Compare Revisions

Também é possível trabalhar pelo:

```text
TortoiseGit
→ Show Log
```

Selecionar:

```text
commit A

CTRL

commit B
```

e executar:

```text
Compare revisions
```

O TortoiseGit abrirá a lista dos arquivos diferentes entre as duas revisões.

Dois commits selecionados também permitem:

```text
Show differences as unified diff
```

para obter todas as diferenças em formato textual.

---

# 14. Como interpretar os resultados

Use esta regra.

| Pergunta                                           | Comparação                                 |
| -------------------------------------------------- | ------------------------------------------ |
| O que a feature pretende levar para `develop`?     | `git diff develop...feature`               |
| Quais arquivos a feature altera?                   | `git diff --name-status develop...feature` |
| Qual o tamanho da alteração?                       | `git diff --stat develop...feature`        |
| Quais commits estão somente na feature?            | `git log develop..feature`                 |
| O conteúdo atual das duas referências é diferente? | `git diff develop feature`                 |
| Quais commits existem exclusivamente de cada lado? | `git log --left-right develop...feature`   |
| Onde as branches divergiram?                       | TortoiseGit Revision Graph                 |
| Quero analisar visualmente os arquivos             | Browse References → Compare                |
| Quero analisar linha a linha                       | TortoiseGitMerge                           |

---

# 15. Atenção: conteúdo e histórico são análises diferentes

É importante não confundir:

```text
git diff
```

com:

```text
git log
```

`git diff` responde:

```text
O conteúdo é diferente?
```

`git log` responde:

```text
O histórico é diferente?
```

Por isso:

```text
git diff develop feature
```

e:

```text
git log develop..feature
```

não substituem um ao outro.

Isso é especialmente importante quando o processo de PR utiliza estratégias que podem alterar o histórico dos commits.

A validação principal de conteúdo deve continuar sendo feita pelo `diff`.

---

# 16. Fluxo recomendado

Para evitar análise desnecessária, siga sempre esta sequência.

```text
1. Fetch
      ↓
2. Status
      ↓
3. Diff --name-status com ...
      ↓
4. Diff --stat com ...
      ↓
5. Git log develop..feature
      ↓
6. Diff direto develop ↔ feature
      ↓
7. TortoiseGit Browse References
      ↓
8. Compare
      ↓
9. Revision Graph, se houver dúvida histórica
      ↓
10. TortoiseGitMerge para os arquivos relevantes
```

A ideia é começar pelo diagnóstico mais barato e somente aprofundar quando houver diferença.

---

# 17. Cenário com tag

O mesmo procedimento pode ser utilizado quando o alvo não for uma branch.

Exemplo:

```text
develop
versus
v1.2.0
```

Para comparar os estados atuais:

```bash
git diff origin/develop v1.2.0
```

Lista de arquivos:

```bash
git diff --name-status origin/develop v1.2.0
```

No TortoiseGit:

```text
Browse References
```

selecionar:

```text
origin/develop

v1.2.0
```

e executar a comparação.

O Reference Browser do TortoiseGit trabalha tanto com branches quanto com tags.

---

# 18. Critério de diagnóstico

Ao terminar a análise, deve ser possível responder:

```text
1. Qual era o conteúdo introduzido pela feature?

2. Quais arquivos foram modificados?

3. Quais commits pertenciam à feature?

4. O conteúdo atual de develop é diferente do alvo?

5. Se existe diferença, em quais arquivos?

6. A diferença vem da feature ou de alterações posteriores em develop?

7. Existe alguma diferença que precisa ser corrigida?
```

Não tomar uma decisão apenas olhando a quantidade de commits.

Usar conjuntamente:

```text
DIFF
+
LOG
+
REVISION GRAPH
```

quando existir divergência que precise ser explicada.

---

# 19. Referências oficiais

As verificações e os comandos deste documento estão baseados nas seguintes documentações oficiais:

* **Git — git-diff Documentation**: comparação de working tree, commits e uso de `A...B`.
* **Git — git-log Documentation**: intervalos `A..B` e diferença simétrica `A...B`.
* **Git — git-merge-base Documentation**: determinação do ancestral comum utilizado em comparações de três vias.
* **Git — git-fetch Documentation**: atualização de objetos, branches remotas e tags.
* **Git — git-status Documentation**: estado do working tree e index.
* **TortoiseGit — Viewing Differences**: comparação de revisões, branches, tags e arquivos.
* **TortoiseGit — Browse All Refs**: seleção e comparação de branches e tags.
* **TortoiseGit — Log Dialog**: histórico e comparação de revisões.
* **TortoiseGit — Revision Graph**: visualização e comparação da topologia das branches.

---

# Anexo A — Resumo de uma página

## Objetivo

Comparar:

```text
develop
   ↕

feature/tag
```

e determinar:

```text
o que a feature introduz
+
o que atualmente é diferente
+
qual é a origem histórica da diferença
```

---

## 1. Atualizar referências

```bash
git fetch origin --tags
```

---

## 2. Verificar estado local

```bash
git status --short --branch
```

---

## 3. Ver o que a feature introduz

```bash
git diff --name-status origin/develop...origin/feature/minha-feature
```

Detalhes:

```bash
git diff origin/develop...origin/feature/minha-feature
```

Estatística:

```bash
git diff --stat origin/develop...origin/feature/minha-feature
```

---

## 4. Ver commits somente da feature

```bash
git log --oneline origin/develop..origin/feature/minha-feature
```

---

## 5. Comparar o estado atual das duas referências

```bash
git diff --name-status origin/develop origin/feature/minha-feature
```

Detalhes:

```bash
git diff origin/develop origin/feature/minha-feature
```

Se não houver saída:

```text
não há diferença de conteúdo entre os snapshots comparados
```

Se houver saída:

```text
existe diferença
→ diagnosticar
```

---

## 6. Diagnóstico pelo TortoiseGit

```text
TortoiseGit
→ Fetch
```

Depois:

```text
TortoiseGit
→ Browse References
```

Selecionar:

```text
origin/develop
+
origin/feature/minha-feature
```

Executar:

```text
Compare
```

Analisar:

```text
Modified
Added
Deleted
Renamed
```

Duplo clique:

```text
TortoiseGitMerge
```

para comparação linha a linha.

---

## 7. Se a origem da diferença não estiver clara

```text
TortoiseGit
→ Revision Graph
```

Verificar:

```text
divergência
commits
merges
HEADs
```

Depois:

```text
TortoiseGit
→ Show Log
```

ou no Git:

```bash
git log --left-right --graph --oneline origin/develop...origin/feature/minha-feature
```

---

## Regra rápida

```text
git diff develop...feature
→ o que a feature introduz
```

```text
git diff develop feature
→ diferença entre os estados atuais
```

```text
git log develop..feature
→ commits existentes na feature e não em develop
```

```text
Revision Graph
→ explica a topologia
```

```text
TortoiseGitMerge
→ explica a diferença no arquivo
```

---

## Fluxo mínimo

```text
Fetch
  ↓
diff --name-status develop...feature
  ↓
log develop..feature
  ↓
diff develop feature
  ↓
Browse References → Compare
  ↓
Revision Graph se necessário
  ↓
TortoiseGitMerge
```

Esse é o fluxo mínimo para validar **o que a feature leva para `develop`**, identificar **diferenças atuais** e investigar sua **origem histórica** sem executar merge ou modificar as branches.
