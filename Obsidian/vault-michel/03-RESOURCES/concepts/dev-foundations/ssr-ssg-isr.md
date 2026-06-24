---
title: SSR / SSG / ISR
type: concept
status: developing
created: 2026-05-04
updated: 2026-05-19
related: [[02-AREAS/fiap/fase-7/CONTENT]]
tags: [nextjs, rendering, performance, seo]
---

# SSR / SSG / ISR

Estratégias de renderização do Next.js. Trade-offs entre frescor de dados, performance e custo de server.

## Conceitos-chave

- **CSR** (Client-Side Rendering) — JS no browser monta tudo. Ruim p/ SEO + FCP.
- **SSG** (Static Site Generation) — HTML gerado em build-time. Mais rápido. Para conteúdo estático.
- **SSR** (Server-Side Rendering) — HTML gerado a cada request. Dinâmico mas custa server.
- **ISR** (Incremental Static Regeneration) — SSG + revalidação periódica. Melhor dos mundos.

## Comparativo

| | SSG | SSR | ISR |
|---|---|---|---|
| Build time | sim | não | sim (regen depois) |
| TTFB | <50ms | 200-500ms | <50ms |
| Frescor | build-time | sempre fresh | até `revalidate` |
| Custo server | mínimo | alto | médio |
| SEO | ✅ | ✅ | ✅ |

## Next.js App Router (13+)

```tsx
// SSG (default)
export default async function Page() {
  const data = await fetch("https://api/produtos");
}

// SSR forçado
export const dynamic = "force-dynamic";

// Cache opt-out
fetch(url, { cache: "no-store" });

// ISR
export const revalidate = 60; // segundos
```

## Quando usar

- **SSG**: blog, docs, marketing
- **SSR**: dashboards autenticados, dados em tempo real
- **ISR**: e-commerce, listings (atualiza a cada N min)

## Visto em

- [[02-AREAS/fiap/fase-7/CONTENT|Fase 7 — Integration]] — cap. 07 (Next.js)

## Relacionado

- [[03-RESOURCES/concepts/dev-foundations/server-components|RSC]]
- [[03-RESOURCES/entities/Next.js|Next.js]]
