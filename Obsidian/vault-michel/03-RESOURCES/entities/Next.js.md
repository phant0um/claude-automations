---
title: Next.js
type: entity
entity_type: framework
created: 2026-05-04
updated: 2026-05-19
related: [[02-AREAS/fiap/fase-7/CONTENT]]
tags: [react, fullstack, framework, vercel]
---

# Next.js

Framework React full-stack mantido pela Vercel. Lançado em 2016. Atualmente padrão de mercado p/ apps React em produção (App Router 13+ com React Server Components default).

## Características

- **File-based routing** — `app/page.tsx` vira rota
- **App Router** (13+) com **Server Components** default
- **Estratégias de render**: SSG, SSR, ISR, CSR
- **API Routes** — backend embutido (`route.ts`)
- **Server Actions** — mutações sem endpoint manual
- **Otimizações nativas**: `next/image`, `next/font`, `next/script`
- **Turbopack** (Rust) — bundler moderno
- **Edge Runtime** — funções na edge da CDN

## Estrutura App Router

```
app/
├── layout.tsx        # layout raiz
├── page.tsx          # rota /
├── loading.tsx       # Suspense fallback
├── error.tsx         # error boundary
├── produtos/
│   ├── page.tsx      # /produtos
│   ├── [id]/
│   │   └── page.tsx  # /produtos/:id
│   └── route.ts      # API
└── globals.css
```

## Comandos

```bash
npx create-next-app@latest
npm run dev      # dev server
npm run build    # build prod
npm run start    # serve prod
```

## Conceitos relacionados

- [[03-RESOURCES/concepts/dev-foundations/server-components|React Server Components]]
- [[03-RESOURCES/concepts/dev-foundations/server-actions|Server Actions]]
- [[03-RESOURCES/concepts/dev-foundations/ssr-ssg-isr|SSG / SSR / ISR]]

## Deploy

- **Vercel** (nativo, zero-config via Git)
- **Self-host** (Node)
- **Docker** (output: standalone)
- **Cloudflare Workers**, **AWS Amplify**, **Netlify**

## Visto em

- [[02-AREAS/fiap/fase-7/CONTENT|Fase 7 — Integration]] — cap. 07 (Next.js), cap. 08 (API/Mock), cap. 09 (Estudo de Caso)

## Relacionado

- [[03-RESOURCES/entities/React|React]]
- [[03-RESOURCES/entities/Vercel|Vercel]]
