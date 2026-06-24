---
title: Context API
type: concept
status: developing
created: 2026-05-04
updated: 2026-05-19
related: [[02-AREAS/fiap/fase-7/CONTENT]]
tags: [react, state, frontend]
---

# Context API

API nativa do React p/ compartilhar state entre componentes sem prop drilling. Combina `createContext` + `Context.Provider` + `useContext`.

## Conceitos-chave

- Evita passar props manualmente por múltiplos níveis
- Provider injeta valor; consumidores leem via `useContext`
- Re-render dispara em todos consumers quando valor muda
- Casos típicos: theme, auth, i18n, carrinho de compras
- Vs Redux/Zustand: nativo, simples, menos boilerplate; pior em apps grandes com updates frequentes

## Padrão de uso

```tsx
const CartContext = createContext<CartCtx | null>(null);

export function CartProvider({ children }) {
  const [items, setItems] = useState([]);
  return (
    <CartContext.Provider value={{ items, setItems }}>
      {children}
    </CartContext.Provider>
  );
}

export function useCart() {
  const ctx = useContext(CartContext);
  if (!ctx) throw new Error("useCart fora de CartProvider");
  return ctx;
}
```

## Otimização

- Split contextos por domínio (theme separado de auth)
- `useMemo` no `value` p/ evitar re-renders
- Combinar com `useReducer` p/ state complexo

## Visto em

- [[02-AREAS/fiap/fase-7/CONTENT|Fase 7 — Integration]] — cap. 06 (Context API), cap. 09 (carrinho e-commerce)

## Relacionado

- [[03-RESOURCES/concepts/dev-foundations/react-hooks|React Hooks]]
- [[03-RESOURCES/entities/React|React]]
