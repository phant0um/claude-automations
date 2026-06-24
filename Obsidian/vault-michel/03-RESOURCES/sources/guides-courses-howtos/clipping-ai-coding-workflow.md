---
title: "AI Coding Workflow — Iterative Loop"
type: source
created: 2026-05-24
updated: 2026-05-24
tags: [source, ai-coding, workflow, iterative, claude-code, neo-kim]
score: 6
author: "Neo Kim (System Design Newsletter #119)"
source_url: "https://newsletter.systemdesign.one/p/ai-coding-workflow"
domain: guides-courses-howtos
---

# AI Coding Workflow — Iterative Loop

**Neo Kim** + **Louis-François Bouchard**: por que AI coding não funciona como vending machine e como fazer funcionar de verdade.

## O Problema do Vending Machine

"Paste your problem, get a working solution." Na prática: modelo sugere código que chama funções que não existem, assume bibliotecas não usadas, ignora constraints óbvias.

Código parece polido. Roda — cai.

## A Solução: Iterative Loop

```
Define goal → Break into small steps → One step at a time →
Review output → Adjust → Next step → Repeat
```

**Princípio**: AI funciona melhor como loop iterativo, não one-shot request. Você guia. O modelo preenche lacunas. Menos suposições = menos limpeza de "confident mistakes."

## O Loop (detalhado)

1. **Define** — goal claro + constraints + existing code context
2. **One step** — peça somente o próximo passo, não a feature inteira
3. **Review** — leia o código antes de rodar
4. **Run** — execute + observe behavior
5. **Feedback** — erro ou resultado → volta para o modelo com contexto
6. **Repeat** — até feature completa

Parece mais lento. É muito mais rápido: menos debugging de código que parece certo mas está errado.

## Insight

> "What finally made AI useful wasn't a magic tool or a clever prompt. It was a simple loop that kept the model on a short leash and kept you in the driver's seat."

## Ver Também

- [[03-RESOURCES/sources/guides-courses-howtos/clipping-claude-code-cheat-sheet]]
- [[03-RESOURCES/sources/guides-courses-howtos/clipping-become-ai-developer-2026]]
