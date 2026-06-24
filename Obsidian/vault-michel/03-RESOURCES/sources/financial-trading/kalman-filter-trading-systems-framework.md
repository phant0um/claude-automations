---
title: "How To Use The Kalman Filter To Build Smarter Trading Systems (Complete Framework)"
type: source
created: 2026-06-23
updated: 2026-06-23
source: "https://x.com/RuujSs/status/2069430225801490602"
author: "@RuujSs"
published: 2026-06-23
grade: A
tags: [financial-trading, kalman-filter, pairs-trading, quant, hedge-ratio, trend-filtering, source]
---

# How To Use The Kalman Filter To Build Smarter Trading Systems (Complete Framework)

**Tese central**: O Kalman filter é a ferramenta matematicamente ótima para estimar estados ocultos (hedge ratio, trend) a partir de observações ruidosas (preços de mercado) em tempo real, de forma recursiva. Supera rolling OLS em pairs trading por não ter lookback window arbitrário, não ter descontinuidades, e adaptar incerteza continuamente. NASA usou para navegar Apollo; quant funds usam para navegar mercados.

## Contexto: NASA para Apollo → quant funds para mercados

O problema: rastrear algo que se move (spacecraft, sinal, hidden state) com medições ruidosas. NASA leu o paper de Rudolf Kalman e aplicou nas missões Apollo — processava radar ruidoso, estimava posição/velocidade, atualizava continuamente. Sem batch reprocessamento. Recursive updating.

Mercados têm o mesmo problema: hedge ratio verdadeiro entre dois ativos é hidden; trend genuíno sob preço ruidoso; relação entre cointegrated assets evolui lentamente. O que observamos é o preço de mercado a cada momento.

Referência: *Portfolio Optimization Book* (Cambridge University Press, 2025) de Palomar testa múltiplas abordagens em pairs data reais e conclui: **"Kalman filtering is a must in pairs trading."** Rolling OLS produz hedge ratio entre 0.6–1.2 nas mesmas pairs onde Kalman fica estável entre 0.55–0.65. Essa diferença determina se o spread é stationário e tradeable ou ruidoso e unreliable.

## Capítulo 1 — A ideia antes das equações

Você quer saber o true state de um sistema mas não pode medir diretamente — só observa medições relacionadas com ruído.

Duas fontes de informação a cada momento:
- **Modelo (prediction)**: o que você prevê baseado em como o sistema evolui. Tem incerteza (process variance Q).
- **Medição (sensor)**: o que o sensor diz agora. Tem incerteza (measurement variance R).

O Kalman filter combina os dois ponderando por confiabilidade relativa. Quando medição é ruidosa (R alto) → confia mais no modelo. Quando modelo é incerto (Q alto) → confia mais na medição. O peso = **Kalman gain K**, atualiza automaticamente a cada step.

Para sistemas lineares com ruído Gaussiano: **provably optimal estimator**. Nenhum outro método extrai mais informação dos dados disponíveis.

Two-step cycle recursivo em tempo real:
- **Predict**: projeta state estimate forward um step. Incerteza aumenta.
- **Update**: incorpora nova medição para corrigir prediction. Incerteza diminui.

## Capítulo 2 — Matemática from scratch

State space model com duas equações:

**State transition**: `x_t = F × x_{t-1} + w_t` (w_t = process noise, cov Q)
**Observation**: `y_t = H_t × x_t + v_t` (v_t = measurement noise, var R)

Para pairs trading:
- `y_t`: preço observado de P₁
- `x_t = [β_t, μ_t]`: hedge ratio + intercept (hidden)
- `H_t = [P₂_t, 1]`: preço do segundo ativo + constante
- `F = I`: identidade (hedge ratio segue random walk)
- `Q`: process noise cov — controla velocidade de β
- `R`: measurement noise var — confiança em cada preço

**7 equações a cada timestep:**

Prediction:
- `x_{t|t-1} = F × x_{t-1|t-1}` (state prediction)
- `P_{t|t-1} = F × P_{t-1|t-1} × F' + Q` (uncertainty prediction)

Innovation:
- `e_t = y_t − H_t × x_{t|t-1}` (forecast error = spread signal)
- `S_t = H_t × P_{t|t-1} × H_t' + R` (innovation variance)

Kalman gain:
- `K_t = P_{t|t-1} × H_t' / S_t` (peso ótimo)

Update:
- `x_{t|t} = x_{t|t-1} + K_t × e_t` (state update)
- `P_{t|t} = (I − K_t × H_t) × P_{t|t-1}` (uncertainty update)

Três outputs importam para trading:
- `x_{t|t}`: hedge ratio + intercept atualizados (best estimate do relacionamento)
- `e_t`: forecast error (spread signal — quão longe P₁ estava do predito)
- `S_t`: innovation variance (normalizar e_t por √S_t → z-score adaptativo)

Kalman gain intuição: S_t grande → medições unreliable → K_t pequeno → update conservador. S_t pequeno → medições precisas → K_t grande → update agressivo.

## Capítulo 3 — Dynamic hedge ratio (aplicação core)

Rolling OLS tem três shortcomings: lookback window arbitrário, estimates jump quando window rola, hedge ratio swing 50%+ sem mudança real. Kalman resolve os três: no lookback, no discontinuous transitions, uncertainty adapta continuamente.

Implementação Python `kalman_hedge_ratio(p1, p2, delta=1e-4, R_noise=1.0)`:
- State `[1.0, 0.0]`, P = I(2), Q = δ/(1-δ) × I
- Loop: H = [p2[t], 1.0]; P += Q; e = p1 - H@state; S = H@P@H + R; K = P@H/S; state += K*e; P = (I - K⊗H)@P
- Retorna: beta, intercept, spread, e, S, P_trace

**Delta controla velocidade**: equity pairs (KO-PEP, EWA-EWC) → 1e-5 a 1e-4 (relacionamento estável). Crypto pairs → 1e-3 a 1e-2 (shifts mais rápidos). Delta = prior belief sobre daily variance do true hedge ratio (interpretável, ao contrário do lookback window).

**Z-score adaptativo**: `kalman_zscore(e, S) = e / √S`. Vantagem sobre rolling z-score: normalização é adaptativa. P grande (uncerto) → S_t grande → threshold widen. P pequeno (confiante) → S_t pequeno → threshold tighten. Filter calibra sensitivity automaticamente.

**Backtest**: `kalman_pairs_backtest` com entry_z=1.0, exit_z=0.0, cost_bps=10. Entry threshold naturalmente mais baixo que z=2.0 do rolling OLS porque √S_t já incorpora incerteza. Documentado em QuantConnect production implementation (300+ hedge funds). Resultado: Annualized Sharpe, Max Drawdown, Annual Return, Avg Spread StdDev.

## Capítulo 4 — Price trend filtering (separar signal de noise)

State = [price level, velocity] — constant velocity model da física. F = [[1,1],[0,1]], H = [1,0].

`kalman_trend_filter(prices, Q_level=1e-4, Q_velocity=1e-5, R_obs=1e-2)` retorna level + velocity series.

Velocity é diretamente tradeable: positiva → trend up, negativa → down. Zero crossings = trend reversal no smoothed series. Documentado (2025) como um de 8 inputs em ML ensemble signal — não standalone trigger.

**Versão adaptativa**: `adaptive_kalman_trend(prices, realized_vol, base_Q, R_obs, vol_scale)` — Q dinâmico baseado em realized volatility. Vol alta → Q maior → mais responsivo. Vol baixa → Q menor → smoother. Confirmado por PyQuantLab (maio 2025): adaptive outperforms fixed-parameter across regimes — tracks rapid moves em volátil sem lag, smooths noise em calm sem sacrificar trend detection.

## Capítulo 5 — Sistema completo conectando todas as camadas

Kalman é uma camada que feeda signal generation → sizing → monitoring.

**Signal generation com confidence gate**: `kalman_signal_with_confidence(e, S, P_trace, entry_z, max_P_trace=0.05)` — z-score é primary signal, mas gate adicional: quando P_trace elevado (filter incerto), reduz/pausa new positions.

**Position sizing scaled to confidence**: `kalman_position_size(zscore, P_trace, entry_z, max_fraction, max_P_trace)` — size proporcional a signal strength × filter confidence. Incerto → menor size. Confiante + signal forte → deploy mais.

**Monitoring filter health**: `kalman_health_monitor(P_trace_series, lookback=252, warn_pct=85, halt_pct=95)` — track P_trace. Persistent rise acima do histórico = relationship pode ter shifted. Status: ACTIVE / WARNING / HALTED. Equivalente Kalman-native do rolling cointegration p-value monitor.

## Evidência real

- Rolling OLS perde tracking completamente durante COVID-19 volatility shock (early 2020). Kalman mantém controlled drawdown, adapta ao shock, recupera clean.
- Adaptive version (Q dinâmico por realized vol) outperforms fixed-parameter across regimes.
- Cambridge 2025: "Kalman filtering is a must in pairs trading."

## Pergunta-chave do autor

> No seu systematic work atual, quais parâmetros você estima com fixed window ou static method que deveriam ser tratados como evolving hidden state? O Kalman filter é a ferramenta certa sempre que a resposta honesta é: o parâmetro muda ao longo do tempo e eu não estou tracking essa mudança corretamente.

## Por que importa para o vault

- **Diretamente alinhado com [[03-RESOURCES/sources/financial-trading/how-to-build-a-pairs-trading-system-that-actually-works-complete-framework]]** — este artigo builds diretamente on top do pairs trading framework
- Kalman filter é o upgrade production-grade do rolling OLS — mesma tese de [[03-RESOURCES/sources/financial-trading/the-math-behind-combining-50-weak-signals-into-one-winning-trade]] (signals adaptativos > fixed)
- Confidence-gated sizing conecta com risk management de [[03-RESOURCES/sources/financial-trading/how-top-quants-catch-a-dying-strategy-before-the-drawdown]]
- Health monitoring (P_trace) é equivalente Kalman-native de detecting strategy decay

## Links

- [[03-RESOURCES/sources/financial-trading/how-to-build-a-pairs-trading-system-that-actually-works-complete-framework]]
- [[03-RESOURCES/sources/financial-trading/the-math-behind-combining-50-weak-signals-into-one-winning-trade]]
- [[03-RESOURCES/sources/financial-trading/how-top-quants-catch-a-dying-strategy-before-the-drawdown]]
- [[03-RESOURCES/sources/financial-trading/the-math-that-turns-a-51-win-rate-into-100-billion]]