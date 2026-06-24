---
title: Vercel
type: entity
entity_type: platform
created: 2026-05-04
updated: 2026-05-19
related: [[02-AREAS/fiap/fase-7/CONTENT]]
tags: [hosting, deploy, serverless, cloud, nextjs]
---

# Vercel

Plataforma cloud p/ hospedar apps frontend e funções serverless. Empresa criadora do Next.js (Guillermo Rauch, 2015 — antes "ZEIT"). Foco em DX e deploy zero-config.

## Características

- **Deploy via Git** — push em branch gera preview URL
- **Edge network global** (CDN + edge functions)
- **Serverless functions** + **Edge functions**
- **Preview deployments** — cada PR tem URL única
- **Domínios custom** + SSL automático
- **Env vars** por environment (dev/preview/prod)
- **Vercel Analytics** — Web Vitals e traffic
- **Vercel KV/Postgres/Blob** — storage gerenciado
- **Vercel AI SDK** — toolkit p/ LLMs

## Frameworks suportados (zero-config)

- **Next.js** (nativo)
- SvelteKit, Nuxt, Astro, Remix, Gatsby
- Vite (qualquer SPA)
- Static sites

## Tier free

- Hobby tier generoso (preview, custom domains, SSL)
- Limites: bandwidth, build time, serverless invocations
- Sem use comercial no free

## Deploy típico

```bash
# Via CLI
npm i -g vercel
vercel
vercel --prod

# Ou via dashboard: import GitHub repo → deploy
```

## Visto em

- [[02-AREAS/fiap/fase-7/CONTENT|Fase 7 — Integration]] — cap. 08 (deploy Next.js)

## Relacionado

- [[03-RESOURCES/entities/Next.js|Next.js]]
