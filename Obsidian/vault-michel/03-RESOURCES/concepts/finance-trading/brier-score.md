---
title: Brier Score
type: concept
status: developing
created: 2026-05-09
updated: 2026-05-19
tags: [scoring, forecasting, calibration, probabilistic-evaluation, proper-scoring]
---

# Brier Score

Regra de pontuação estritamente própria para previsões probabilísticas binárias, introduzida por Brier (1950). Para previsão $p$ e outcome $y \in \{0,1\}$:

$$B = (p - y)^2$$

Valores menores são melhores. "Estritamente própria" significa que o forecaster maximiza sua pontuação esperada somente reportando sua crença calibrada real — não há incentivo para misrepresentar.

## Decomposição

Ver [[03-RESOURCES/concepts/learning-cognition/murphy-decomposition]] para a partição B = UNC + REL − RES (Murphy 1973).

## Benchmarks de referência (Foresight Arena / Karger et al.)

| Forecaster | Brier Score |
|---|---|
| Human superforecasters | 0.096 |
| General public | 0.121 |
| Frontier LLMs | 0.122–0.136 |

## Uso em avaliação de agentes LLM

Em [[03-RESOURCES/sources/ai-agents-harness/coordination-architectural-layer-multi-agent-prediction-markets|Nechepurenko & Shuvalov 2026]], o Brier Score é a métrica base para avaliar 5 configurações de coordenação em 100 mercados Polymarket pós-cutoff. A decomposição de Murphy é usada para separar calibração de poder discriminativo — configurações com Brier similar podem ter perfis (REL, RES) muito diferentes.

## Conexões

- [[03-RESOURCES/concepts/learning-cognition/murphy-decomposition]]
- [[03-RESOURCES/concepts/finance-trading/prediction-markets]]
- [[03-RESOURCES/entities/Polymarket]]
- [[03-RESOURCES/sources/ai-agents-harness/coordination-architectural-layer-multi-agent-prediction-markets]]
