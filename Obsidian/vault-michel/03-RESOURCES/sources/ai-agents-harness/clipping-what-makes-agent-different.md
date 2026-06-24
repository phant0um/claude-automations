---
title: "What Makes an AI Agent Different From ChatGPT?"
type: source
created: 2026-05-24
updated: 2026-05-24
tags: [source, ai-agents, fundamentals, rpa, goal-directed, semantic-robustness]
score: 6
author: "Sairam Sundaresan (System Design Newsletter #111)"
source_url: "https://newsletter.systemdesign.one/p/ai-agents-explained"
domain: ai-agents-harness
---

# What Makes an AI Agent Different From ChatGPT?

**Sairam Sundaresan** em System Design Newsletter #111: explicação clara de agente ≠ chatbot via caso de uso de web scraping de voos.

## O Exemplo

Scraper de preço de voo: funciona hoje. Amanhã, airline redesignou UI — botão "Cheapest" virou "Lowest fare". Selector CSS aponta pro nada. Script quebra silenciosamente.

Fixo manualmente. Semana seguinte, outra coisa muda. Isso é **automação frágil**.

Alternativa: dar ao agente um *goal* — "Find cheapest flight to Tokyo this month." Agente *infere* que "Lowest fare" = "Cheapest" e escolhe o controle certo.

## A Distinção Fundamental

> "Instead of telling software **how** to do something step by step, you tell it **what** you want. The agent figures out how."

Não é mágica: agente quebra o goal em passos, tenta, observa resultados, ajusta. Quando falha, pode retentar *se* você configurou error handling e fallbacks. Sem isso: loop no mesmo erro ou para no step limit.

## Agente vs RPA

- RPA: segue passos predeterminados
- Agent: tenta entender o que vê, decide como agir
- Mas: ambos dependem de estrutura de página e labels — não "entendimento humano real"
- Agentes ainda quebram em páginas bagunçadas sem fallbacks explícitos

## Semantic Robustness

Robustez semântica não acontece automaticamente. Requer: fallbacks explícitos, label-matching strategies, error recovery. Agente sem esses quebra em mudanças de UI tanto quanto script RPA.

## Ver Também

- [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
- [[03-RESOURCES/sources/ai-agents-harness/clipping-first-agent-incident-response]]
- [[03-RESOURCES/sources/ai-agents-harness/clipping-9-agentic-patterns]]
