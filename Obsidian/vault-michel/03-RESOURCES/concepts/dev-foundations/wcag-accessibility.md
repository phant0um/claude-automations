---
title: WCAG Accessibility
type: concept
status: developing
created: 2026-05-14
updated: 2026-05-14
tags: [frontend, accessibility, wcag, aria, html5, a11y, standards]
---

# WCAG Accessibility

Web Content Accessibility Guidelines — padrão internacional de acessibilidade para conteúdo web. O [[Frontend-Dev-Fullstack|Frontend Dev]] do [[Fullstack-Agent-System|Fullstack Agent System]] implementa **WCAG 2.2 AA** como obrigatório.

## Níveis de conformidade

- **A** — requisitos mínimos
- **AA** — padrão de mercado (obrigatório no sistema)
- **AAA** — conformidade máxima (ideal quando viável)

## Checklist obrigatório (WCAG 2.2 AA)

- Semantic HTML: `<header>`, `<nav>`, `<main>`, `<section>`, `<article>`, `<footer>`
- `alt` em toda `<img>` — descritivo ou `alt=""` para decorativas
- Touch targets ≥ 44×44px em todos os elementos interativos
- Body text ≥ 16px — previne zoom automático no iOS
- `prefers-reduced-motion` respeitado em animações
- Dark mode via `prefers-color-scheme`
- ARIA roles quando semântica HTML não é suficiente
- Navegação por teclado funcional em todos os componentes

## Ferramentas

axe DevTools, Lighthouse (a11y score), WAVE, Screen readers (NVDA, VoiceOver)

## Relações

- Implementado por: [[Frontend-Dev-Fullstack]]
- Sistema: [[Fullstack-Agent-System]]
