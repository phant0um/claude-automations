---
title: "Performance Audit"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, dev-foundations]
status: developing
---

# Performance Audit

Processo sistemático de medir, diagnosticar e priorizar gargalos de performance em aplicações web ou backend antes de otimizar.

## O que é

Um performance audit é uma análise estruturada que quantifica onde tempo e recursos são desperdiçados. Sem auditoria, otimização é especulação. O princípio de Knuth se aplica: *"premature optimization is the root of all evil"* — meça primeiro.

## Como funciona / Detalhes

**Core Web Vitals (Google, padrão de mercado):**
- **LCP** (Largest Contentful Paint) — tempo até o maior elemento visível renderizar; alvo: < 2.5s
- **FID** / **INP** (Interaction to Next Paint, desde 2024) — responsividade a input; alvo: < 200ms
- **CLS** (Cumulative Layout Shift) — instabilidade visual; alvo: < 0.1

**Ferramentas de frontend:**
- **Lighthouse** — audit automatizado (performance, a11y, SEO, boas práticas); integrado no Chrome DevTools
- **WebPageTest** — teste de múltiplas localizações, waterfall visual
- **Chrome DevTools Performance tab** — flame chart de runtime, long tasks

**Causas comuns de lentidão no frontend:**
- Render-blocking resources (CSS/JS no `<head>` sem `async`/`defer`)
- Bundle size excessivo (sem code splitting, sem tree shaking)
- Imagens não otimizadas (falta de WebP, lazy loading, `srcset`)
- Excesso de re-renders (React sem memoização)

**Backend / Banco de dados:**
- **N+1 problem** — query que dispara N queries adicionais em loop; resolver com eager loading / JOIN
- Query profiling: `EXPLAIN ANALYZE` (PostgreSQL), slow query log (MySQL)
- **Performance budget** — definir limites máximos de bundle, LCP, etc. como critério de CI

## Por que importa

Para Michel: performance é critério de avaliação em projetos FIAP (especialmente fase de arquitetura e cloud). Em concursos de analista de sistemas, N+1 e Core Web Vitals aparecem em questões de engenharia de software e banco de dados.

## Related
- [[03-RESOURCES/concepts/dev-foundations/_index]]
- [[03-RESOURCES/concepts/ux-ui-design]]
