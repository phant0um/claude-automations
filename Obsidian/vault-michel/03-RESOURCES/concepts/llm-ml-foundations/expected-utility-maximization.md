---
title: "Expected Utility Maximization"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, llm-ml-foundations, agent-systems]
status: developing
---

# Expected Utility Maximization

Framework formal de decisão racional: escolha a ação que maximiza a utilidade esperada sobre os possíveis resultados.

## O que é

Expected utility maximization (EUM) é o princípio central da teoria da decisão racional. Um agente racional, dado um conjunto de ações possíveis e incerteza sobre os resultados, deve escolher a ação que maximiza:

```
EU(a) = Σ P(outcome | action) × U(outcome)
```

onde U é a função de utilidade — uma representação das preferências do agente sobre os estados do mundo.

## Como funciona

**Axiomas de Von Neumann-Morgenstern:** um agente com preferências que satisfazem completude, transitividade, continuidade e independência *necessariamente* age como se maximizasse utilidade esperada.

**Componentes:**
- **Crença (belief):** distribuição de probabilidade sobre estados do mundo
- **Utilidade (utility):** função que mapeia resultados em números reais
- **Decisão:** arg max_a EU(a)

**Rational agency gap (Burkov et al.):** LLMs são treinados por next-token prediction — maximizam a probabilidade do próximo token, não uma função de utilidade sobre resultados no mundo. Isso significa que LLMs puros **não são agentes racionais** no sentido formal: não possuem crenças explícitas sobre o mundo nem função de utilidade estável.

## Variantes

- **Utilidade esperada subjetiva (SEU):** crença subjetiva (Bayesian) em vez de probabilidades objetivas
- **Teoria dos jogos:** EUM aplicado a múltiplos agentes com utilidades concorrentes
- **Reward em RL:** função de recompensa é uma proxy para utilidade — RLHF tenta aproximar preferências humanas como função de utilidade

## Por que importa

Agentes LLM verdadeiramente autônomos precisam ir além de next-token prediction: precisam de um mecanismo de crença-atualização e uma função de objetivo estável. Isso explica por que sistemas como ReAct, CoT-SC e agentes com memória explícita são necessários — eles retrofitam estrutura de decision-theory em cima de um LLM que não a possui nativamente.

## Related
- [[03-RESOURCES/concepts/llm-ml-foundations/_index]]
- [[03-RESOURCES/concepts/reinforcement-learning]]
- [[03-RESOURCES/concepts/reasoning-models]]
