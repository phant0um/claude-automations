---
title: React Server Components (RSC)
type: concept
status: developing
created: 2026-05-04
updated: 2026-05-19
related: [[02-AREAS/fiap/fase-7/CONTENT]]
tags: [react, nextjs, ssr, rsc]
---

# React Server Components (RSC)

Componentes React renderizados exclusivamente no servidor. Default no Next.js App Router (13+). Zero JS enviado ao cliente p/ esses componentes.

## Conceitos-chave

- **Render no server** — HTML + payload RSC streamado p/ cliente
- **Sem `useState`/`useEffect`/event handlers** (não tem JS no client)
- **Acesso direto** a DB, filesystem, secrets, APIs internas
- **`async`/`await` no componente** — nativo
- **Bundle menor** no cliente (libs server-only não baixadas)
- **`"use client"`** marca Client Component (para interatividade)

## Server vs Client

| | Server | Client |
|---|---|---|
| Hooks | ❌ | ✅ |
| Event handlers | ❌ | ✅ |
| DB direto | ✅ | ❌ |
| `localStorage` | ❌ | ✅ |
| Bundle JS | 0 | sim |

## Composição

Server Components podem importar Client Components. Client não importa Server diretamente — passa via children pattern:

```tsx
// ServerLayout.tsx (server)
import ClientWrapper from "./ClientWrapper";
import ServerData from "./ServerData";

export default function Page() {
  return (
    <ClientWrapper>
      <ServerData />  {/* server component as child */}
    </ClientWrapper>
  );
}
```

## Visto em

- [[02-AREAS/fiap/fase-7/CONTENT|Fase 7 — Integration]] — cap. 07 (Next.js), cap. 09 (Estudo de Caso Front)

## Relacionado

- [[03-RESOURCES/concepts/dev-foundations/server-actions|Server Actions]]
- [[03-RESOURCES/concepts/dev-foundations/ssr-ssg-isr|SSR / SSG / ISR]]
- [[03-RESOURCES/entities/Next.js|Next.js]]
