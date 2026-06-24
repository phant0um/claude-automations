---
title: Repomix
type: entity
categoria: ferramenta
tags: [developer-tools, context, claude, ai-coding, open-source]
created: 2026-05-31
updated: 2026-05-19
---

# Repomix

## O que é

Ferramenta CLI open-source que combina um projeto inteiro em um formato legível para AI. Resolve o problema de AI gerando "código ruim" — na maioria das vezes, o problema é que a AI não vê o projeto completo.

**Repo:** [github.com/yamadashy/repomix](https://github.com/yamadashy/repomix)

## O que faz

- Combina o projeto inteiro em um único arquivo AI-readable
- Reduz uso de tokens
- Dá contexto total ao Claude (ou qualquer LLM)

## Instalação

```bash
npx repomix
```

## Por que importa

Sem contexto completo → Claude gera código que não se encaixa no projeto. Com Repomix → Claude escreve código que realmente funciona dentro da arquitetura existente.

## Onde aparece no vault

- [[03-RESOURCES/sources/misc-low-confidence/zero-to-30k-month-claude-saas]]
