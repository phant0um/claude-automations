---
title: React Router
type: entity
entity_type: library
created: 2026-05-04
updated: 2026-05-19
related: [[02-AREAS/fiap/fase-7/CONTENT]]
tags: [react, routing, spa]
---

# React Router

Biblioteca de roteamento padrão do ecossistema React. Mantida pela Remix Software (hoje parte da Shopify). Versão atual: v6 (DOM via `react-router-dom`); v7 unifica com Remix.

## Características

- **Roteamento declarativo** via componentes
- **Rotas aninhadas** com `<Outlet>`
- **Rotas dinâmicas** (`:id`)
- **Lazy loading** de rotas
- **Data routers** (v6.4+) — `loader`, `action`, `errorElement`
- **História** via History API (push/replace)

## API básica (v6)

```tsx
import { BrowserRouter, Routes, Route, Link, Outlet } from "react-router-dom";

<BrowserRouter>
  <Routes>
    <Route path="/" element={<Layout />}>
      <Route index element={<Home />} />
      <Route path="produtos" element={<Produtos />} />
      <Route path="produtos/:id" element={<Detail />} />
      <Route path="*" element={<NotFound />} />
    </Route>
  </Routes>
</BrowserRouter>
```

## Hooks

| Hook | Função |
|---|---|
| `useNavigate` | navegação programática |
| `useParams` | params da URL (`:id`) |
| `useLocation` | location atual |
| `useSearchParams` | query string |
| `useMatch` | match de rota |
| `useNavigation` | state de navegação (data routers) |

## Componentes

`<Link>`, `<NavLink>` (active state), `<Outlet>` (slot p/ rotas filhas), `<Navigate>` (redirect).

## Visto em

- [[02-AREAS/fiap/fase-7/CONTENT|Fase 7 — Integration]] — cap. 05 (Estrutura, Props e React Router)

## Relacionado

- [[03-RESOURCES/entities/React|React]]
