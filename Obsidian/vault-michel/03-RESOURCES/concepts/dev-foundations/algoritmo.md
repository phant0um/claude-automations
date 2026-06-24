---
title: "Algoritmo"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, dev-foundations]
status: developing
---

# Algoritmo

Uma sequência finita de passos bem definidos para resolver um problema — a fundação de tudo em computação, antes mesmo de qualquer linguagem.

## O que é

Um algoritmo é um conjunto de instruções ordenadas, finitas e não-ambíguas que transformam uma entrada em uma saída. Todo programa de computador implementa um ou mais algoritmos. A habilidade de pensar algoritmicamente — decompor um problema em passos executáveis — é mais valiosa do que saber qualquer linguagem específica.

**Complexidade de tempo (notação Big O)** mede como o tempo de execução cresce com o tamanho da entrada `n`. Os casos mais comuns: O(1) = constante (acesso a array por índice), O(log n) = busca binária, O(n) = percorrer uma lista, O(n log n) = ordenação eficiente (mergesort), O(n²) = bubble sort, O(2ⁿ) = recursão ingênua. Para concursos e entrevistas, saber classificar um algoritmo em Big O é essencial.

Pseudocódigo é uma forma de escrever algoritmos em português estruturado (sem sintaxe de linguagem específica). Fluxograma é a representação gráfica — útil para visualizar ramificações, mas o pseudocódigo é mais rápido de produzir.

## Como funciona

```
// Pseudocódigo — busca binária em lista ordenada
ALGORITMO BuscaBinaria(lista, alvo):
    inicio ← 0
    fim ← tamanho(lista) - 1

    ENQUANTO inicio <= fim:
        meio ← (inicio + fim) / 2
        SE lista[meio] == alvo: RETORNAR meio
        SE lista[meio] < alvo: inicio ← meio + 1
        SENÃO: fim ← meio - 1

    RETORNAR -1  // não encontrado
```

```java
// Implementação Java — O(log n)
int buscaBinaria(int[] arr, int alvo) {
    int ini = 0, fim = arr.length - 1;
    while (ini <= fim) {
        int meio = (ini + fim) / 2;
        if (arr[meio] == alvo) return meio;
        if (arr[meio] < alvo) ini = meio + 1;
        else fim = meio - 1;
    }
    return -1;
}
```

## Por que importa

Em concursos públicos de TI (CESGRANRIO, FCC, CESPE), questões de lógica de programação e algoritmos são das mais frequentes — ordenação, busca, recursão, complexidade. Na FIAP, toda disciplina de programação começa com raciocínio algorítmico. Saber estimar a complexidade de um loop aninhado (geralmente O(n²)) ou de uma busca binária (O(log n)) diferencia candidatos em qualquer processo seletivo técnico.

## Exemplo

Padrões recorrentes em provas:
- Loop simples percorrendo lista → O(n)
- Loop dentro de loop na mesma lista → O(n²)
- Dividir o problema ao meio a cada iteração → O(log n)
- Recursão que chama 2× com n-1 → O(2ⁿ) — evitar sem memoização

## Related
- [[03-RESOURCES/concepts/dev-foundations/_index]]
- [[03-RESOURCES/concepts/pensamento-computacional]]
- [[03-RESOURCES/concepts/colecoes-java]]
