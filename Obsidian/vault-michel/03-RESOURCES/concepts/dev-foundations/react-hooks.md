---
title: React Hooks
type: concept
status: developing
created: 2026-05-04
updated: 2026-05-19
related: [[02-AREAS/fiap/fase-7/CONTENT]]
tags: [react, frontend, hooks]
---

# React Hooks

API introduzida no React 16.8 (2019) p/ usar state e lifecycle em componentes funcionais. Substitui classes em ~quase todos casos.

## Conceitos-chave

- **Função pura** + hooks = componente funcional moderno
- Regras: top-level only, dentro componente React (ou outro hook)
- Custom hooks reutilizam lógica entre componentes (prefixo `use`)
- ESLint plugin `react-hooks/rules-of-hooks` valida

## Hooks principais

| Hook | Função |
|---|---|
| `useState` | estado local |
| `useEffect` | side effects (API, DOM, subscriptions) |
| `useContext` | consume Context |
| `useReducer` | state complexo (action/reducer) |
| `useCallback` | memoiza função |
| `useMemo` | memoiza valor computado |
| `useRef` | ref DOM ou valor mutável |
| `useLayoutEffect` | effect síncrono pós-render |
| `useImperativeHandle` | expõe API via ref |

## Padrões

- Atualização funcional: `setX(prev => prev + 1)`
- Cleanup em `useEffect`: `return () => { ... }`
- Otimização: `React.memo` + `useMemo` + `useCallback`

## Visto em

- [[02-AREAS/fiap/fase-7/CONTENT|Fase 7 — Integration]] — cap. 06 (State, Effect, Context)

## Relacionado

- [[03-RESOURCES/concepts/dev-foundations/context-api|Context API]]
- [[03-RESOURCES/entities/React|React]]
