---
title: Core Web Vitals
type: concept
status: developing
created: 2026-05-14
updated: 2026-05-14
tags: [frontend, performance, google, metrics, lcp, inp, cls, web-vitals]
---

# Core Web Vitals

Métricas de performance web definidas pelo Google para medir experiência do usuário. O [[Frontend-Dev-Fullstack|Frontend Dev]] do [[Fullstack-Agent-System|Fullstack Agent System]] as monitora como critério de qualidade.

## Métricas (2024+)

| Métrica | O que mede | Meta |
|---|---|---|
| **LCP** (Largest Contentful Paint) | Tempo de carregamento do maior elemento visível | ≤ 2.5s |
| **INP** (Interaction to Next Paint) | Responsividade a interações do usuário | ≤ 200ms |
| **CLS** (Cumulative Layout Shift) | Estabilidade visual (elementos que se movem) | ≤ 0.1 |

> INP substituiu FID (First Input Delay) em março 2024.

## Ferramentas de análise

- Lighthouse (Chrome DevTools)
- PageSpeed Insights
- Web Vitals JS library
- Chrome User Experience Report (CrUX)

## Estratégias de otimização

- `loading="lazy"` em imagens abaixo do fold
- Preloading de fontes e recursos críticos
- Code splitting e lazy loading de componentes
- Imagens com `width`/`height` definidos (previne CLS)
- Server-side rendering (Next.js) para LCP

## Relações

- Monitorado por: [[Frontend-Dev-Fullstack]]
- Sistema: [[Fullstack-Agent-System]]
