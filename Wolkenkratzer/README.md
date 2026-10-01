# Wolkenkratzer (Arranha-céu) em Haskell
---

Resolvedor do quebra-cabeça Wolkenkratzer (também chamado de *Skyscrapers* ou *Arranha-céu*), feito em Haskell para a disciplina de Paradigmas de Programação.

Grupo: Lorena Quintino do O, Maria Eduarda Teixeira Costa, Sofia Gazolla da Costa Silva.

Os puzzles vêm do site: https://www.janko.at/Raetsel/Wolkenkratzer/index.htm

O programa recebe as pistas do puzzle, resolve usando **backtracking** e imprime o tabuleiro completo.

Se o puzzle tiver solução, ela é impressa. Se não tiver (ou se a entrada estiver inválida), aparece `Nenhuma solucao foi encontrada.`

---

## Como jogar

Você preenche uma grade N x N com prédios. As regras são:

1. Em cada **linha** e em cada **coluna**, cada altura aparece **no máximo uma vez**.
2. Os números nas bordas da grade indicam **quantos prédios dá para ver** olhando naquela direção (para dentro da linha ou da coluna).
3. Um prédio é **visível** se todos os prédios na frente dele forem **mais baixos**. Prédios mais baixos que um prédio na frente ficam escondidos atrás dele.
4. Em alguns puzzles a altura máxima é menor que o tamanho da grade. Nesse caso sobram células **vazias**, que o programa mostra como `X`.
5. Uma borda **sem número** significa que não há pista naquele lado.

**Exemplo:** na linha `1 2 6 5 4 3`, olhando da esquerda, você vê os prédios 1, 2 e 6 (o 6 esconde todos os seguintes), ou seja, **3 prédios**. Olhando da direita, você vê 3, 4, 5 e 6, ou seja, **4 prédios**.

---

## Escolha um quebra-cabeça

No site vá até a seção **"Escolha um quebra-cabeça"**.

---
### O que preencher

| Constante | O que colocar |
|-----------|---------------|
| `n` | Tamanho da grade (6 para um puzzle 6x6) |
| `maxAltura` | Maior altura de prédio do puzzle. Costuma ser igual a `n`. Se for menor, sobram células vazias (`X`) |
| `topo` | Números **acima** da grade, da **esquerda para a direita** |
| `baixo` | Números **abaixo** da grade, da **esquerda para a direita** |
| `esquerda` | Números à **esquerda** da grade, de **cima para baixo** |
| `direita` | Números à **direita** da grade, de **cima para baixo** |
