---
title: Server Actions (Next.js)
type: concept
status: developing
created: 2026-05-04
updated: 2026-05-19
related: [[02-AREAS/fiap/fase-7/CONTENT]]
tags: [nextjs, react, mutations, rsc]
---

# Server Actions

Funções server-side invocáveis do cliente sem criar API endpoint manual. Introduzidas no Next.js 13.4 (estável em 14). Marcadas com directive `"use server"`.

## Conceitos-chave

- Eliminam boilerplate de criar `route.ts` + fetch
- Funcionam com forms via `<form action={fn}>`
- Permitem progressive enhancement (formulário funciona sem JS)
- Revalidação automática via `revalidatePath` / `revalidateTag`
- Hooks de UX: `useFormStatus`, `useFormState` (renomeado `useActionState` no React 19)

## Exemplo

```tsx
// actions.ts
"use server";

export async function createProduct(formData: FormData) {
  const name = formData.get("name");
  await db.produto.create({ data: { name } });
  revalidatePath("/produtos");
}

// page.tsx
import { createProduct } from "./actions";

export default function Page() {
  return (
    <form action={createProduct}>
      <input name="name" />
      <button type="submit">Criar</button>
    </form>
  );
}
```

## Hooks auxiliares

- **`useFormStatus`** — `pending`, `data`, `method` (dentro do `<form>`)
- **`useActionState`** — gerencia state retornado pela action (errors, success)

## Cuidados

- Validar input no server (não confiar em client)
- Auth/authz dentro da action
- Não expor secrets

## Visto em

- [[02-AREAS/fiap/fase-7/CONTENT|Fase 7 — Integration]] — cap. 07 (Next.js)

## Relacionado

- [[03-RESOURCES/concepts/dev-foundations/server-components|RSC]]
- [[03-RESOURCES/entities/Next.js|Next.js]]
