---
title: "CSS"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, dev-foundations, frontend]
status: developing
---

# CSS

A linguagem que transforma HTML sem estilo em interfaces visuais — e que parece simples até você tentar centralizar um div.

## O que é

CSS (Cascading Style Sheets) é a linguagem de estilos da web. Funciona em três camadas: **seletores** identificam os elementos HTML a estilizar, **propriedades** definem o que mudar (cor, tamanho, espaçamento), e a **cascata** define qual regra prevalece quando há conflito — por especificidade, ordem de declaração e herança.

O **box model** é o conceito central: todo elemento HTML é uma caixa com conteúdo + `padding` (espaço interno) + `border` + `margin` (espaço externo). A propriedade `box-sizing: border-box` (padrão recomendado) faz `width` incluir padding e border, evitando surpresas de layout.

Especificidade é a regra de quem ganha em conflitos: IDs (`#id`) > classes (`.classe`, `[attr]`, `:pseudo`) > elementos (`div`, `p`). `!important` sobrescreve tudo mas é anti-pattern — indica que o CSS está mal estruturado.

## Como funciona

```css
/* Seletores */
p { color: #333; }          /* elemento */
.destaque { font-weight: bold; }  /* classe */
#header { background: #fff; }     /* ID */
nav > a:hover { color: blue; }    /* combinador + pseudo-classe */

/* Box model */
.card {
    width: 300px;
    padding: 16px;
    border: 1px solid #ddd;
    margin: 8px auto;
    box-sizing: border-box;
}

/* Flexbox — layout 1D */
.container {
    display: flex;
    justify-content: space-between; /* eixo principal */
    align-items: center;            /* eixo cruzado */
    gap: 16px;
}

/* Grid — layout 2D */
.grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 24px;
}

/* Unidades */
/* px = absoluto | em = relativo ao pai | rem = relativo ao root | % = relativo ao pai */

/* Media query */
@media (max-width: 768px) {
    .grid { grid-template-columns: 1fr; }
}
```

## Por que importa

Todo projeto web da FIAP tem interface — e interface sem CSS é HTML bruto. Flexbox e Grid são os dois sistemas de layout modernos que substituíram floats e tabelas; saber os dois é obrigatório. Media queries são a base do responsive design. Para concursos com questões de web, CSS é cobrado junto com HTML e JavaScript.

## Exemplo

Centralizar um elemento vertical e horizontalmente (o clássico "problema do CSS"):
```css
.pai { display: flex; justify-content: center; align-items: center; min-height: 100vh; }
```

## Related
- [[03-RESOURCES/concepts/dev-foundations/_index]]
- [[03-RESOURCES/concepts/responsive-design]]
- [[03-RESOURCES/concepts/uml]]
