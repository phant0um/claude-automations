---
title: Trading Systems
type: concept
created: 2026-06-23
updated: 2026-06-23
tags: [concept, finance, trading, quant, systems]
---

# Trading Systems

Frameworks para construção de sistemas de trading quantitativo.

## Kalman Filter em trading

Estados ocultos (hedge ratio, trend) estimados a partir de observações ruidosas (preços) em tempo real. Matematicamente ótimo para sistemas lineares com ruído Gaussiano.

**Vantagens sobre rolling OLS**: no lookback window arbitrário, no discontinuous transitions, uncertainty adapts continuously.

**3 aplicações**:
1. Dynamic hedge ratio (pairs trading)
2. Price trend filtering (signal vs noise)
3. Sistema completo (signal + sizing + monitoring)

## Sistema completo

- **Signal**: z-score normalizado por √S_t (adaptive threshold)
- **Sizing**: proporcional a signal strength × filter confidence
- **Monitoring**: P_trace persistente alto = relação pode ter quebrado

## Evidências

- [[03-RESOURCES/sources/articles/kalman-filter-trading-systems]] — Framework completo 5 capítulos com código Python

## Links

- [[03-RESOURCES/concepts/finance/pairs-trading]]
- [[04-SYSTEM/agents/finance-system/quant]]