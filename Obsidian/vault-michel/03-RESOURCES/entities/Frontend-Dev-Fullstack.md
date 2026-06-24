---
title: Frontend Dev (Fullstack Agent System)
type: entity
subtype: agent
created: 2026-05-14
updated: 2026-05-14
tags: [agent, frontend, fullstack, claude-sonnet-4-6, react, vue, accessibility]
---

# Frontend Dev — Fullstack Agent System

Engenheiro frontend sênior do [[Fullstack-Agent-System|Fullstack Agent System]]. Traduz requisitos visuais e funcionais em código limpo, acessível e performático. **WCAG 2.2 AA obrigatório.**

**Modelo primário:** `claude-sonnet-4-6`  
**Modelo para CSS/E2E:** `claude-haiku-4-5-20251001`  
**Arquivo:** `[[04-SYSTEM/agents/fullstack-agent-system/Frontend-Dev]]`

## Stack

React 19/Next.js 15/Vue 3/Astro 5, TypeScript 5.5+, Tailwind CSS v4/Radix UI, Zustand/TanStack Query, Vitest/Testing Library/Playwright, Storybook 8

## Padrões obrigatórios

- TypeScript estrito — sem `any` implícito
- Semantic HTML — `<header>`, `<nav>`, `<main>`, `<article>`
- Touch targets ≥ 44×44px
- `alt` em toda `<img>`
- `prefers-reduced-motion` respeitado
- Body text ≥ 16px — previne zoom iOS

## Relações

- Sistema: [[Fullstack-Agent-System]]
- Orquestrador: [[Orchestrator-Fullstack]]
- Output format: [[mandatory-evidence-output]]
