---
title: Pairs Trading
type: concept
created: 2026-06-23
updated: 2026-06-23
tags: [concept, finance, trading, pairs, cointegration]
---

# Pairs Trading

Estratégia que explora desvios temporários na relação entre dois ativos cointegrados.

## Mecanismo

1. Identificar par cointegrado (ex: KO-PEP, EWA-EWC)
2. Estimar hedge ratio (β) — quantas unidades do ativo 2 para cada 1 do ativo 1
3. Spread = P₁ - β × P₂
4. Quando spread desvia da média → trade (long um, short outro)
5. Convergência → profit

## Rolling OLS vs Kalman Filter

| Aspecto | Rolling OLS | Kalman Filter |
|---------|-------------|---------------|
| Lookback | Arbitrário | Não tem |
| Discontinuidade | Jump quando window rolls | Suave |
| Hedge ratio swing | 0.6-1.2 | 0.55-0.65 |
| Uncertainty | Estática | Adaptativa |

## Delta controla velocidade

- Equity pairs (relação estável): delta 1e-5 a 1e-4
- Crypto pairs (relação muda rápido): delta 1e-3 a 1e-2

## Evidências

- [[03-RESOURCES/sources/articles/kalman-filter-trading-systems]] — Implementação completa com backtest
- Palomar's Portfolio Optimization Book (Cambridge, 2025): "Kalman filtering is a must in pairs trading"

## Links

- [[03-RESOURCES/concepts/finance/trading-systems]]
- [[04-SYSTEM/agents/finance-system/quant]]