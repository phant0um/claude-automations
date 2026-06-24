---
title: "Responsive Design"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, dev-foundations, frontend]
status: developing
---

# Responsive Design

Fazer a mesma interface funcionar bem em qualquer tamanho de tela — do celular de 320px ao monitor ultrawide de 2560px.

## O que é

Responsive design é a abordagem de construir interfaces web que se adaptam fluidamente ao tamanho e características do dispositivo do usuário, sem criar versões separadas para mobile e desktop. O termo foi cunhado por Ethan Marcotte em 2010 e se tornou padrão da indústria com a explosão mobile.

Os três ingredientes originais de Marcotte: **fluid grids** (layouts baseados em porcentagens, não pixels fixos), **flexible images** (imagens que respeitam seu container) e **media queries** (regras CSS condicionais por tamanho de tela).

A estratégia **mobile-first** inverte a ordem do desenvolvimento: você começa pelo layout mobile (mais restrito) e vai adicionando complexidade para telas maiores via media queries com `min-width`. O oposto (desktop-first com `max-width`) é mais intuitivo mas gera CSS mais difícil de manter.

A tag `<meta name="viewport">` é obrigatória — sem ela, o browser mobile simula uma tela de 980px e o responsive não funciona.

## Como funciona

```html
<!-- Obrigatório no <head> -->
<meta name="viewport" content="width=device-width, initial-scale=1.0">
```

```css
/* Mobile-first: começa com o layout mobile */
.container {
    width: 100%;
    padding: 16px;
}

.grid {
    display: grid;
    grid-template-columns: 1fr; /* 1 coluna no mobile */
    gap: 16px;
}

/* Tablet — a partir de 768px */
@media (min-width: 768px) {
    .grid { grid-template-columns: repeat(2, 1fr); }
}

/* Desktop — a partir de 1024px */
@media (min-width: 1024px) {
    .container { max-width: 1200px; margin: 0 auto; }
    .grid { grid-template-columns: repeat(3, 1fr); }
}

/* Imagem fluida */
img { max-width: 100%; height: auto; }
```

Breakpoints comuns: 320px (mobile pequeno), 480px (mobile), 768px (tablet), 1024px (desktop), 1280px+ (wide).

## Por que importa

Mais de 60% do tráfego web global vem de mobile. Qualquer projeto de front-end na FIAP precisa ser responsivo — é critério de avaliação. O Google penaliza sites não-responsivos no ranking de busca (mobile-first indexing desde 2019). Para o mercado, entregar um site que quebra no celular é simplesmente inaceitável em 2026.

## Exemplo

Padrão "card grid" responsivo: 1 coluna no mobile, 2 no tablet, 3 no desktop — implementado em 6 linhas de CSS com Grid + media queries (ver código acima).

## Related
- [[03-RESOURCES/concepts/dev-foundations/_index]]
- [[03-RESOURCES/concepts/css]]
- [[03-RESOURCES/concepts/prototipagem]]
