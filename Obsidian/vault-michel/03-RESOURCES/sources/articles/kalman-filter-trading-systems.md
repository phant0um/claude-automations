---
title: "Kalman Filter for Smarter Trading Systems"
type: source
created: 2026-06-23
updated: 2026-06-23
source: "https://x.com/RuujSs/status/2069430225801490602"
author: "@RuujSs"
published: 2026-06-23
grade: A
tags: [finance, trading, kalman-filter, quant, pairs-trading, source]
---

# Kalman Filter for Smarter Trading Systems

**Tese central**: O Kalman filter é a ferramenta matematicamente ótima para estimar estados ocultos (hedge ratio, trend) a partir de observações ruidosas (preços de mercado) em tempo real. Supera rolling OLS em pairs trading por não ter lookback window arbitrário, não ter descontinuidades, e adaptar incerteza continuamente.

## Framework completo (5 capítulos)

### Cap 1 — A ideia antes das equações
- Hidden state + observações ruidosas = problema de estimação
- Kalman combina prediction (model) + measurement (sensor), ponderado por confiabilidade
- Para sistemas lineares com ruído Gaussiano: provavelmente ótimo

### Cap 2 — Matemática from scratch
- State transition: `x_t = F × x_{t-1} + w_t`
- Observation: `y_t = H_t × x_t + v_t`
- 7 equações executadas a cada timestep: predict → innovation → Kalman gain → update
- Kalman gain K é o mecanismo chave: automaticamente balancea confiança model vs measurement

### Cap 3 — Dynamic hedge ratio (aplicação core)
- Rolling OLS: lookback arbitrário, descontinuidades, swing de 50%+
- Kalman: no lookback, transições suaves, incerteza adaptativa
- Delta controla velocidade de adaptação: 1e-5 a 1e-4 (equities), 1e-3 a 1e-2 (crypto)
- Z-score normalizado por √S_t → threshold adaptativo

### Cap 4 — Price trend filtering
- State = [price level, velocity] — constant velocity model da física
- Velocity component é tradeable: zero crossings = trend reversal
- Versão adaptativa: Q dinâmico baseado em realized volatility
- Melhor como componente em ensemble, não standalone

### Cap 5 — Sistema completo
- Signal generation: z-score + confidence gate (P_trace)
- Position sizing: proporcional a signal strength × filter confidence
- Health monitoring: P_trace persistente acima do histórico = relação pode ter quebrado

## Código

Inclui implementações Python completas para: `kalman_hedge_ratio()`, `kalman_zscore()`, `kalman_pairs_backtest()`, `kalman_trend_filter()`, `adaptive_kalman_trend()`, `kalman_signal_with_confidence()`, `kalman_position_size()`, `kalman_health_monitor()`.

## Evidência

- Palomar's Portfolio Optimization Book (Cambridge, 2025): "Kalman filtering is a must in pairs trading"
- Rolling OLS perde tracking no COVID-19 shock 2020; Kalman mantém drawdown controlado
- QuantConnect production implementation: 300+ hedge funds usam entry z=1.0 (não 2.0) porque √S_t já accountable for uncertainty

## Minha Síntese

A ideia central transcende trading: **qualquer parâmetro que evolve over time e que você está estimando com janela fixa é um candidato para Kalman**. A pergunta "what parameters are you currently estimating with a fixed window that should actually be treated as an evolving hidden state?" é aplicável a portfolio optimization, risk management, e até ao vault (scoring de sources com baseline fixo vs adaptativo). Conecta com [[03-RESOURCES/concepts/finance/trading-systems]] e com a ideia de adaptive scoring no pipeline-semanal.

## Links

- [[03-RESOURCES/concepts/finance/trading-systems]]
- [[03-RESOURCES/concepts/finance/pairs-trading]]
- [[04-SYSTEM/agents/finance-system/quant]]
- [[04-SYSTEM/agents/finance-system/fluxo]]