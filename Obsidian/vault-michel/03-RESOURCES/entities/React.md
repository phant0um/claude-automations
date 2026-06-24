---
title: React
type: entity
entity_type: library
created: 2026-05-04
updated: 2026-05-19
related: [[02-AREAS/fiap/fase-7/CONTENT]]
tags: [react, frontend, ui, javascript]
---

# React

Biblioteca JavaScript p/ construir UIs criada pela Meta (Facebook) em 2013. Foco em componentes declarativos e reutilizáveis. Mantida open-source com adoção massiva (60%+ devs frontend).

## Características

- **Virtual DOM** — diff em memória, atualização mínima do DOM real
- **Declarativa** — descreve UI p/ um state, não passos
- **Componentes** funcionais (modernos) ou classes (legado)
- **JSX/TSX** — sintaxe XML-like dentro de JS/TS
- **Fluxo unidirecional** — props descem, eventos sobem
- **Hooks** (16.8+) — state e lifecycle em funções

## Lib vs framework

React é **biblioteca**, não framework. Dev decide roteador, fetch, state global, build. Frameworks como Next.js empacotam tudo.

## Versões marco

| Versão | Marco |
|---|---|
| 16.8 (2019) | Hooks |
| 17 (2020) | sem features (gradual upgrade) |
| 18 (2022) | Concurrent Mode, Suspense melhorado |
| 19 (2024) | Actions, `use` hook, Server Components estáveis |

## Ecossistema

- **Roteamento**: React Router, TanStack Router
- **State**: Redux, Zustand, Jotai, Context API
- **Frameworks**: Next.js, Remix, Gatsby, Astro
- **Mobile**: React Native
- **Build**: Vite, Create React App (deprecated), Next.js

## Visto em

- [[02-AREAS/fiap/fase-7/CONTENT|Fase 7 — Integration]] — cap. 04 (React + Vite), cap. 05–06 (Router, Hooks, Context)

## Relacionado

- [[03-RESOURCES/entities/Next.js|Next.js]]
- [[03-RESOURCES/entities/React-Router|React Router]]
- [[03-RESOURCES/concepts/dev-foundations/react-hooks|React Hooks]]
- [[03-RESOURCES/concepts/dev-foundations/context-api|Context API]]
