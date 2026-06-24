---
title: "Coleções Java"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, dev-foundations, java]
status: developing
---

# Coleções Java

O Java Collections Framework oferece as estruturas de dados prontas que você usará em todo projeto — saber qual escolher é o que separa código eficiente de código lento.

## O que é

O Java Collections Framework (JCF) é um conjunto de interfaces e classes que implementam as principais estruturas de dados: listas, conjuntos, filas e mapas. As três interfaces centrais são `List` (elementos ordenados, com duplicatas), `Set` (sem duplicatas) e `Map` (pares chave-valor).

Todas as coleções do JCF suportam generics (`<T>`), o que garante type safety em tempo de compilação — você define o tipo uma vez e o compilador impede que você insira o tipo errado. Antes dos generics (Java < 5), tudo era `Object` e exigia cast, fonte constante de `ClassCastException`.

O `Iterator` é o mecanismo padrão para percorrer coleções de forma segura, inclusive removendo elementos durante a iteração (via `iterator.remove()`). O for-each (`for (T item : colecao)`) é syntactic sugar sobre o Iterator.

## Como funciona

```java
// List — ordenada, permite duplicatas
List<String> nomes = new ArrayList<>();  // acesso O(1), inserção O(n)
List<String> fila = new LinkedList<>();  // inserção O(1), acesso O(n)
nomes.add("Ana"); nomes.get(0);

// Set — sem duplicatas
Set<String> emails = new HashSet<>();    // O(1) médio, sem ordem
Set<String> ordenado = new TreeSet<>();  // O(log n), ordem natural

// Map — chave → valor
Map<String, Integer> idades = new HashMap<>();
idades.put("Michel", 22);
idades.get("Michel"); // 22
idades.getOrDefault("X", 0); // sem NPE

// Iterando com for-each
for (Map.Entry<String, Integer> e : idades.entrySet()) {
    System.out.println(e.getKey() + ": " + e.getValue());
}
```

## Por que importa

Todo projeto FIAP que vai além do "Hello World" usa coleções — lista de produtos, mapa de usuários, conjunto de tags. Saber a diferença de complexidade entre `ArrayList` (acesso rápido) e `LinkedList` (inserção rápida) ou entre `HashMap` (não-ordenado) e `TreeMap` (ordenado) é pergunta frequente em entrevistas e concursos de TI.

## Exemplo

Regra rápida de escolha:
- Precisa de índice/acesso por posição → `ArrayList`
- Precisa inserir/remover no meio com frequência → `LinkedList`
- Precisa de chave única → `HashMap` (rápido) ou `TreeMap` (ordenado)
- Precisa de elementos únicos sem ordem → `HashSet`

## Related
- [[03-RESOURCES/concepts/dev-foundations/_index]]
- [[03-RESOURCES/concepts/heranca]]
- [[03-RESOURCES/concepts/dao-pattern]]
