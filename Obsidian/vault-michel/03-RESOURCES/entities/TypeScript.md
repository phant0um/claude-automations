---
title: TypeScript
type: entity
entity_type: language
created: 2026-05-04
updated: 2026-05-19
related: [[02-AREAS/fiap/fase-7/CONTENT]]
tags: [typescript, language, frontend, backend]
---

# TypeScript

Superset tipado de JavaScript criado pela Microsoft (Anders Hejlsberg, 2012). Compila p/ JS via `tsc`. Tipagem estática opcional, gradualmente adotável.

## Características

- **Superset** — todo JS válido é TS válido
- **Compila p/ JS** (transpiler), não roda nativamente em browser/Node sem build
- **Tipagem estrutural** (duck typing tipado)
- **Inferência de tipos** poderosa
- **Generics**, **union/intersection types**
- **Interfaces** vs **types** (intercambiáveis em ~90% dos casos)
- **Enums**, **tuples**, **literal types**

## Tipos primitivos

`number`, `string`, `boolean`, `null`, `undefined`, `void`, `unknown`, `any`, `never`, `bigint`, `symbol`

## Tipos complexos

```ts
// Object
type User = { id: number; name: string };

// Array
const nums: number[] = [1, 2, 3];

// Function
const add: (a: number, b: number) => number = (a, b) => a + b;

// Union / Intersection
type Status = "ok" | "error";
type Admin = User & { role: "admin" };

// Generic
function first<T>(arr: T[]): T | undefined { return arr[0]; }
```

## Config

```jsonc
// tsconfig.json
{
  "compilerOptions": {
    "target": "ES2020",
    "strict": true,
    "module": "ESNext"
  }
}
```

## Adoção

React, Vue, Angular (default), Node, Deno (default), Next.js, Vite. ~80% de novos projetos JS modernos.

## Visto em

- [[02-AREAS/fiap/fase-7/CONTENT|Fase 7 — Integration]] — cap. 03 (Node + TS), cap. 04+ (React + TS)

## Relacionado

- [[03-RESOURCES/entities/Node.js|Node.js]]
- [[03-RESOURCES/entities/React|React]]
