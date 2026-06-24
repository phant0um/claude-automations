---
title: "How To Build a Pairs Trading System That Actually Works (Complete Framework)"
type: source
category: financial-trading
source: "https://x.com/RuujSs/status/2066545926467174765"
created: 2026-06-16
ingested: 2026-06-16
tags: [pairs-trading, quant, systematic, framework]
---

# How To Build a Pairs Trading System That Actually Works (Complete Framework)

## Tese Central

Pairs trading framework that actually works: the quant strategy running inside serious systematic funds, covering cointegration testing, entry/exit signals, and risk management.

---

## Conteudo Original

![Image](https://pbs.twimg.com/media/HK3TReYbMAAIqOK?format=jpg&name=large)

The quant strategy running inside every serious systematic fund. Here is the version that actually works.

Most traders look at two assets moving together and see a trade.

A quant looks at the same two assets and asks a different question entirely: is there a mathematical law anchoring these two series together such that when they drift apart, they are compelled to return?

That question has a precise answer. And it is the foundation of one of the most durable edges in systematic trading.

The strategy became known as pairs trading. A 2025 Cranfield University study examined 30 ETF pairs across 24 years of data and confirmed it still produces positive risk-adjusted returns when the statistical relationship is properly managed. A live system running 136 US equity pairs since January 2025 posted +17.4% net return with a Sortino ratio of 3.8. The strategy is not historical. It is running in production right now.

Two versions of this strategy exist and they are not the same thing.

The simple version find two correlated assets, normalize their price ratio, trade the z-score has degraded significantly since the mid-2000s. It is well-documented, widely replicated, and the easy edge in it has been taken. What still works is the version built on genuine statistical foundations. Cointegration rather than correlation. A properly calibrated spread model. Signals grounded in the actual economics of the trade. Active monitoring of the relationship over time.

Every layer of what follows exists for a precise reason. Remove any one of them and a specific, predictable weakness appears in the system.

By the end of this article you will understand how to select genuinely cointegrated pairs rather than correlated ones, how to model the spread mathematically so the dynamics are understood rather than assumed, how to build entry and exit signals calibrated to each specific pair, how to size positions correctly for a mean-reverting strategy, and how to keep the system synchronized with reality as markets evolve.

Note: Every Chapter builds directly on the one before it. Read it in order.

# Chapter 1: The Foundation Cointegration, Not Correlation

The single most important decision in building a pairs system is how you select pairs. Get this wrong and nothing downstream can save you.

Almost every beginner uses correlation. It seems logical two assets with high correlation move together, so when they diverge, they should converge again. The problem is that correlation measures co-movement over a historical window. It says nothing about whether a long-run equilibrium exists between the two series. Two assets can correlate at 0.92 over one year and diverge permanently over the next five.

Cointegration is the right test. It is a stricter claim.

Two price series P₁ and P₂ are cointegrated when there exists a coefficient **β** such that:

> **S\_t = P₁\_t − β × P₂\_t**

**S\_t** is stationary it fluctuates around a stable mean, has finite and bounded variance, and reverts to equilibrium when disturbed. Each individual series is a random walk that can go anywhere. Their linear combination **S\_t** is anchored. That anchor is what you are trading.

This distinction matters practically. A correlation-based strategy can survive for months before the relationship drifts permanently. A cointegration-based strategy has a mathematical guarantee underpinning the trade.

![Image](https://pbs.twimg.com/media/HKy-EwlbcAEihOV?format=jpg&name=large)

Correlation without cointegration vs. cointegration, why the selection criterion determines everything downstream.

**Testing Cointegration: Engle-Granger**

The Engle-Granger test, published in Econometrica in 1987, remains the standard entry-level test for pairs.

**Step 1:** Regress P₁ on P₂ to estimate **β** and the intercept **α**.

**Step 2:** Test the residuals the estimated spread for stationarity using the Augmented Dickey-Fuller test. Stationary residuals at p < 0.05 confirm cointegration.

```python
import math
import numpy as np
import pandas as pd
from statsmodels.tsa.stattools import adfuller, coint
from statsmodels.tsa.vector_ar.vecm import coint_johansen
from statsmodels.regression.linear_model import OLS
from statsmodels.tools import add_constant

def engle_granger_test(p1, p2):
   
    p1 = np.asarray(p1, dtype=float)
    p2 = np.asarray(p2, dtype=float)
 
    X     = add_constant(p2)          
    model = OLS(p1, X).fit()
    alpha = model.params[0]
    beta  = model.params[1]
 
    residuals  = p1 - alpha - beta * p2
    adf_result = adfuller(residuals, maxlag=1, autolag=None)   # [B1]
 
    t_stat          = adf_result[0]
    p_value         = adf_result[1]
    critical_values = adf_result[4]
 
    print(f"Hedge Ratio (β)  : {beta:.4f}")
    print(f"ADF t-statistic  : {t_stat:.4f}")
    print(f"p-value          : {p_value:.4f}")
    print(f"Critical 5%      : {critical_values['5%']:.4f}")
    print(f"Cointegrated     : {p_value < 0.05}")
 
    return {
        'beta':         beta,
        'alpha':        alpha,
        'residuals':    residuals,
        'p_value':      p_value,
        'cointegrated': p_value < 0.05,
    }
```

One limitation worth knowing: the test is sensitive to variable ordering. Running P₁ on P₂ versus P₂ on P₁ can produce different conclusions. Always run both directions. A genuine cointegration relationship confirms in both orderings. A pair that passes only one direction is weaker than it looks.

**The Johansen Test**

Research published in Computational Economics confirms the Johansen cointegration approach outperforms other pair selection methods. It treats both series symmetrically, removing the ordering sensitivity of Engle-Granger, and tests how many cointegrating relationships exist within the system.

```python
def johansen_test(p1, p2, det_order=0, k_ar_diff=1):
    p1 = np.asarray(p1, dtype=float)
    p2 = np.asarray(p2, dtype=float)
 
    data   = np.column_stack([p1, p2])
    result = coint_johansen(data, det_order, k_ar_diff)
 
    trace_stats = result.lr1      
    trace_cvs   = result.cvt      # shape (2, 3): rows = hypotheses, cols = 90/95/99 %
    coef_matrix = result.evec     
 
    r0_reject    = trace_stats[0] > trace_cvs[0, 1]   # reject r = 0
    r1_reject    = trace_stats[1] > trace_cvs[1, 1]   # reject r ≤ 1
    cointegrated = r0_reject and not r1_reject          # exactly one cointegrating vector
 
    print(f"Trace stat (r=0) : {trace_stats[0]:.4f}")
    print(f"Critical 5%      : {trace_cvs[0, 1]:.4f}")
    print(f"Cointegrated     : {cointegrated}")
 
    return {
        'cointegrated': cointegrated,
        'coef_vector':  coef_matrix[:, 0],
    }
```

One final confirmation is the Hurst exponent of the spread. Below 0.5 confirms mean-reverting dynamics. Exactly 0.5 is a random walk. Above 0.5 is trending. A cointegrated spread should sit clearly below 0.5.

```python
def hurst_exponent(series, max_lag=100):
    arr  = np.asarray(series, dtype=float)          
    lags = range(2, max_lag)
 
    tau = []
    for lag in lags:
        diff = arr[lag:] - arr[:-lag]                
        std  = np.std(diff, ddof=1)
        tau.append(max(std, 1e-10))                 
 
    poly = np.polyfit(np.log(list(lags)), np.log(tau), 1)
    return round(poly[0], 4)
```

A pair enters the system only when it passes all three: Engle-Granger in both directions, Johansen confirmed, and Hurst below 0.5. Most candidates will not. That is the point. The ones that do are genuinely anchored and worth building a position around.

# Chapter 2: Modeling the Spread, The Ornstein-Uhlenbeck Process

You have a cointegrated pair. Now the question is: how does this spread actually move, and what does that tell you about when and how to trade it?

The right model is the Ornstein-Uhlenbeck process:

> **dX\_t = θ(μ − X\_t)dt + σdW\_t**

![Image](https://pbs.twimg.com/media/HKy-cbBbcAATbwO?format=jpg&name=large)

The Ornstein-Uhlenbeck restoring force, mean reversion as a distance-proportional pull toward equilibrium.

Read this simply. At any moment, the spread changes by two things. First, a pull toward the long-run mean **μ,** the size of this pull is proportional to how far the spread currently is from **μ**, controlled by **θ**. Second, random noise **σdW\_t**. When the spread is above mean, the force is downward. When below, upward. The further from mean, the stronger the pull.

Three parameters define the process completely:

**θ:** mean reversion speed. How fast does the spread return to equilibrium? **μ:** long-run mean. The equilibrium level. **σ** diffusion. How much random noise is in the path back?

The discrete version of the OU equation is a standard AR(1) regression, which means you can estimate all parameters with OLS:

> **X\_t = a + b × X\_{t-1} + ε\_t**

Where **a = θμΔt** and **b = 1 − θΔt**.

```python
def fit_ou_parameters(spread, dt=1.0):
    arr   = np.asarray(spread, dtype=float)
    X_lag = arr[:-1]
    X_cur = arr[1:]
 
    model = OLS(X_cur, add_constant(X_lag)).fit()
    a     = model.params[0]     
    b     = model.params[1]     
 
    theta = max((1.0 - b) / dt, 1e-10)          
    mu    = a / (theta * dt)
    sigma = np.std(model.resid, ddof=1) / math.sqrt(dt)   
 
    return theta, mu, sigma
```

A half-life under 2 days: by the time you detect a signal, execute both legs, and account for costs, the spread has already moved substantially. A half-life over 200 days: capital committed for months waiting for convergence that may not arrive.

The practical tradeable range for daily data is 5 to 60 days. This is where signal-to-noise is high enough to survive transaction costs and holding period is short enough for capital to work efficiently.

The equilibrium standard deviation σ/√(2θ) tells you the typical magnitude of spread deviations at steady state. Save this number, it drives threshold calibration in chapter 3.

```python
def calibrate_spread(spread, dt=1.0):
    arr              = np.asarray(spread, dtype=float)
    theta, mu, sigma = fit_ou_parameters(arr, dt)
    half_life        = ou_half_life(theta)
    ou_std           = sigma / math.sqrt(2.0 * theta) if theta > 1e-10 else math.inf
 
    print(f"Mean Reversion Speed (θ) : {theta:.4f}")
    print(f"Long-Run Mean (μ)        : {mu:.6f}")
    print(f"Diffusion (σ)            : {sigma:.6f}")
    print(f"Half-Life                : {half_life:.1f} days")
    print(f"Equilibrium Std Dev      : {ou_std:.6f}")
    print(f"Tradeable                : {5 <= half_life <= 60}")
 
    return {
        'theta':     theta,
        'mu':        mu,
        'sigma':     sigma,
        'half_life': half_life,
        'ou_std':    ou_std,
    }
```

# Chapter 3: Building the Signal, Calibrated to Each Pair

With the OU parameters estimated, you can build entry and exit signals that are grounded in the actual dynamics of this specific pair not generic thresholds imposed from outside.

**The Z-Score**

Normalize the spread into units of recent standard deviations:

> **z\_t = (X\_t − μ\_rolling) / σ\_rolling**

Set the rolling lookback proportional to the half-life two to three times the half-life in days. A pair with a 10-day half-life uses a 20 to 30 day lookback.

Set the rolling lookback proportional to the half-life two to three times the half-life in days. A pair with a 10-day half-life uses a 20 to 30 day lookback.

```python
def compute_zscore(spread, lookback):
    arr        = np.asarray(spread, dtype=float)
    s          = pd.Series(arr)
    mu_roll    = s.rolling(lookback).mean()
    sigma_roll = s.rolling(lookback).std(ddof=1)
    sigma_roll = sigma_roll.replace(0.0, np.nan)
    return (s - mu_roll) / sigma_roll
```

When z is large and positive, P₁ is elevated relative to P₂. When large and negative, P₁ is depressed. The trade: buy the depressed leg, short the elevated leg, wait for the spread to revert.

**Why the Thresholds Cannot Be Generic**

The 2025 Cranfield University study found that threshold calibration directly affects profitability, lower thresholds increase trading frequency and Sharpe ratios but also increase drawdowns. There is no universally optimal threshold. Each pair needs its own.

The minimum viable entry z-score below which expected convergence profit does not cover round-trip transaction costs is derivable from the OU parameters:

> **min\_z = (4 × cost\_fraction) / ou\_std**

Four because each round trip involves four transactions. ou\_std is the equilibrium standard deviation from Chapter 2. A pair with small ou\_std needs a higher z-score to generate enough expected profit to survive costs.

![Image](https://pbs.twimg.com/media/HKy-2fNakAA1Tdl?format=jpg&name=large)

Asymmetric entry and exit thresholds. entering at ±2σ and exiting at ±1σ captures the majority of expected convergence profit while eliminating the low-return final stretch.

**For the exit:** set it at roughly half the entry threshold. Exiting at z = 0 means holding through the complete mean reversion, spending capital and time on the low-return final stretch. Exiting at half the entry threshold captures approximately 75% of the expected convergence profit at significantly lower average holding time.

```python
def minimum_entry_zscore(ou_params, cost_per_trade_bps):
    ou_std = ou_params['ou_std']
    if not math.isfinite(ou_std) or ou_std <= 0: 
        return math.inf
    cost_frac = cost_per_trade_bps / 10_000
    return (4.0 * cost_frac) / ou_std
 
 
def generate_signals(zscore, entry_z, exit_z):
    arr     = np.asarray(zscore, dtype=float)
    n       = len(arr)
    pos_arr = np.zeros(n, dtype=float)
    current = 0.0
 
    for i in range(1, n):
        z = arr[i]
 
        if math.isnan(z):  
            pos_arr[i] = current
            continue
 
        if current == 0.0:
            if z > entry_z:
                current = -1.0  
            elif z < -entry_z:
                current =  1.0  
        elif current == -1.0:
            if z < exit_z:   
                current = 0.0
        elif current == 1.0:
            if z > -exit_z:   
                current = 0.0
 
        pos_arr[i] = current
 
    idx = zscore.index if hasattr(zscore, 'index') else range(n)
    return pd.Series(pos_arr, index=idx)
```

Never enter below the minimum viable z-score. Across hundreds of trades, this filter is the difference between a system that compounds and one that slowly bleeds to transaction costs.

# Chapter 4: Position Sizing Derived From the Spread Dynamics

Position sizing in pairs trading is not about fractional risk or fixed lot sizes. The OU process gives you something better, a direct measure of expected return at any point in time based on how far the spread is from its attractor.

When the spread is far from mean, expected convergence return is high. When near mean, expected return is low. Sizing should reflect this directly.

The approach that follows from the OU dynamics is proportional sizing:

> **allocation\_t = max\_allocation × min(|z\_t| / entry\_z, 1.0)**

At the entry threshold, deploy maximum allocation. As the spread converges, scale down proportionally. This structure means you are largest when expected edge is largest and naturally de-risked as the trade approaches its target. It is not imposed from outside it follows from the shape of the expected return profile under the OU process.

This proportional structure is consistent with what the current academic literature derives from stochastic control and HJB frameworks for optimal trading under mean-reverting dynamics. The 2021 Mathematical Methods of Operations Research paper on optimal pairs trading under OU dynamics arrived at exactly this threshold-proportional structure for the optimal policy.

```python
def ou_position_size(zscore, entry_z, max_fraction):
    arr = np.asarray(zscore, dtype=float)
    idx = zscore.index if hasattr(zscore, 'index') else range(len(arr))
    raw = pd.Series(np.abs(arr), index=idx) / entry_z
    return raw.clip(upper=1.0) * max_fraction
 
 
def construct_pair_position(capital, signal, size_fraction, p1, p2, beta):
    allocation = capital * size_fraction
    units_p1   = signal * allocation / p1
    units_p2   = -signal * beta * allocation / p2
    gross      = abs(units_p1 * p1) + abs(units_p2 * p2)
    net        = units_p1 * p1 + units_p2 * p2
    return units_p1, units_p2, gross, net
```

The construction is dollar-neutral. Long β dollars in P₂ for every dollar long in P₁. Net dollar exposure zero. Broad market moves cancel between the legs. Only the spread drives P&L.

Here is the full backtest connecting all four parts:

```python
def pairs_backtest(p1, p2, beta, alpha, entry_z, exit_z,
                   max_fraction, cost_bps, lookback):
    p1_arr     = np.asarray(p1, dtype=float)
    p2_arr     = np.asarray(p2, dtype=float)
    spread_arr = p1_arr - beta * p2_arr - alpha 
 
    ou_params = calibrate_spread(spread_arr)
 
    if not (5 <= ou_params['half_life'] <= 60):
        print("Half-life outside tradeable range.")
        return None
 
    min_z = minimum_entry_zscore(ou_params, cost_bps)
    if not math.isfinite(min_z):
        print("Non-tradeable spread: ou_std is non-finite.")
        return None
 
    act_z  = max(entry_z, min_z)
    zscore = compute_zscore(spread_arr, lookback) 
    signal = generate_signals(zscore, act_z, exit_z)
    size   = ou_position_size(zscore, act_z, max_fraction)
 
    pos        = signal * size    
    spread_pct = pd.Series(spread_arr).pct_change()   
 
    gross_ret = pos.shift(1) * spread_pct
 
    transitions = signal.diff().abs().fillna(0.0)
    cost_drag   = transitions.shift(1) * 2 * (cost_bps / 10_000) 
 
    ret = (gross_ret - cost_drag).dropna()
 
    if ret.std(ddof=1) == 0 or len(ret) < 2:
        print("Insufficient return variance — check input data.")
        return None
 
    sharpe  = ret.mean() / ret.std(ddof=1) * math.sqrt(252)
    cum     = (1 + ret).cumprod()
    max_dd  = ((cum - cum.cummax()) / cum.cummax()).min()
    ann_ret = (1 + ret.mean()) ** 252 - 1  
 
    print(f"Annualized Sharpe : {sharpe:.4f}")
    print(f"Max Drawdown      : {max_dd:.4f}")
    print(f"Annual Return     : {ann_ret:.4f}")
    print(f"Effective Entry Z : {act_z:.2f}")
 
    return ret, pos
```

# Chapter 5: Keeping the System Honest, Dynamic Hedge Ratio and Relationship Monitoring

Everything in Chapter 1 through 4 assumes the pair relationship is stable. In practice, two things shift over time and both need active management.

**The Hedge Ratio Changes**

The hedge ratio β estimated from a regression months ago is wrong today. The true relationship between two assets evolves as their fundamentals, valuations, and market dynamics change. Using a stale β produces a spread with slow structural drift the stationarity degrades progressively and every downstream component suffers.

Rolling OLS partially addresses this but introduces a lookback window as a free parameter and creates discontinuous transitions when the window rolls.

The Kalman filter is the correct approach. It treats β as a hidden state that evolves continuously, updating at every new observation using a Bayesian framework. No lookback to choose. No cliff-edge transitions. The Portfolio Optimization Book (Palomar 2025) documents this as current best practice rolling OLS produces β estimates swinging between 0.6 and 1.2 on a canonical ETF pair while Kalman estimation stays between 0.55 and 0.65, producing a substantially more stationary spread.

```python
def kalman_hedge_ratio(p1, p2, delta=1e-4):
    p1_arr = np.asarray(p1, dtype=float)
    p2_arr = np.asarray(p2, dtype=float)
    n      = len(p1_arr)
 
    beta_arr  = np.zeros(n)
    alpha_arr = np.zeros(n)
    e_arr     = np.zeros(n)
    Q_arr     = np.zeros(n)
 
    state = np.array([1.0, 0.0])    
    P     = np.eye(2)
    Vw    = delta / (1.0 - delta) * np.eye(2)  
    Ve    = 1.0                                   
 
    beta_arr[0]  = state[0]
    alpha_arr[0] = state[1]
 
    for i in range(1, n):
        x_t = np.array([p2_arr[i], 1.0])
 
        # Predict
        P = P + Vw
 
        # Innovation
        e_arr[i] = p1_arr[i] - (x_t @ state)
 
        S = float(x_t @ P @ x_t) + Ve
        Q_arr[i] = S
 
        # Kalman gain
        K = (P @ x_t) / S
 
        state = state + K * e_arr[i]
 
        ImKH = np.eye(2) - np.outer(K, x_t)
        P    = ImKH @ P @ ImKH.T + Ve * np.outer(K, K)
 
        beta_arr[i]  = state[0]
        alpha_arr[i] = state[1]
 
    spread = p1_arr - beta_arr * p2_arr - alpha_arr
 
    idx = p1.index if hasattr(p1, 'index') else range(n)
    return (
        pd.Series(beta_arr,  index=idx),
        pd.Series(alpha_arr, index=idx),
        pd.Series(spread,    index=idx),
        pd.Series(e_arr,     index=idx),
        pd.Series(Q_arr,     index=idx),
    )
```

**The Relationship Itself Changes**

The 2025 Cranfield University study reached one central operational conclusion: pairs trading success depends on cointegration stability. The study found that short windows where cointegration holds limit long-term profitability, meaning the strategy needs adaptive monitoring, not static pair selection done once.

The solution is rolling cointegration testing, running the test continuously on recent data and tracking the p-value as a live health signal.

```python
def rolling_cointegration_pvalue(p1, p2, window=252):
    p1_arr = np.asarray(p1, dtype=float)
    p2_arr = np.asarray(p2, dtype=float)
    n      = len(p1_arr)
    pvals  = np.full(n, np.nan)
 
    for i in range(window, n):
        w1 = p1_arr[i - window:i]
        w2 = p2_arr[i - window:i]
        try:
            _, pvalue, _ = coint(w1, w2)
            pvals[i]     = pvalue
        except Exception:
            pvals[i] = np.nan 
 
    idx = p1.index if hasattr(p1, 'index') else range(n)
    return pd.Series(pvals, index=idx)
```

Combine this with half-life monitoring into a daily regime check that runs before any signal generation:

```python
def pair_regime_monitor(p1, p2, spread,
                        coint_window=252,
                        coint_warn=0.10,
                        coint_halt=0.20,
                        half_life_min=5,
                        half_life_max=60):

    p1_arr  = np.asarray(p1, dtype=float)
    p2_arr  = np.asarray(p2, dtype=float)
    spr_arr = np.asarray(spread, dtype=float)
 
    rolling_pval = rolling_cointegration_pvalue(p1_arr, p2_arr, coint_window)
    valid_pvals  = rolling_pval.dropna()
 
    if len(valid_pvals) == 0:
        print("Insufficient history for cointegration window - HALTED.")
        return {'status': 'HALTED', 'pvalue': np.nan,
                'half_life': np.nan, 'active': False}
 
    current_pval = float(valid_pvals.iloc[-1])
 
    recent = spr_arr[-coint_window:] if len(spr_arr) >= coint_window else spr_arr
    ou_params  = calibrate_spread(recent)
    current_hl = ou_params['half_life']
 
    coint_ok    = current_pval < coint_warn
    halflife_ok = half_life_min <= current_hl <= half_life_max
 
    if coint_ok and halflife_ok:
        status = 'ACTIVE'
    elif current_pval < coint_halt and halflife_ok:
        status = 'WARNING'
    else:
        status = 'HALTED'
 
    print(f"Rolling Coint p-value : {current_pval:.4f}")
    print(f"Current Half-Life     : {current_hl:.1f} days")
    print(f"Coint Status          : {'OK' if coint_ok else 'WEAKENING'}")
    print(f"Half-Life in Range    : {'OK' if halflife_ok else 'OUT OF RANGE'}")
    print(f"System Status         : {status}")
 
    return {
        'status':    status,
        'pvalue':    current_pval,
        'half_life': current_hl,
        'active':    status == 'ACTIVE',
    }
```

![Image](https://pbs.twimg.com/media/HKy_DadaQAAmrYc?format=jpg&name=large)

Rolling cointegration p-value as a three-state regime signal the operational boundary between trading, holding, and standing aside.

Three states. ACTIVE means the pair is healthy trade normally. WARNING means the relationship is weakening hold existing positions but open nothing new, watch closely. HALTED means stand aside close open positions and wait until the statistical evidence of stability returns.

The three-state design matters operationally. A binary switch creates a cliff fully active to completely off in one day when a threshold crosses. The WARNING state provides a transition that reduces unnecessary turnover and avoids exiting positions that are temporarily noisy rather than genuinely compromised.

Run this check every day before generating signals. It takes seconds and protects against the most common operational problem in pairs trading: holding a position on a relationship that has structurally shifted, accumulating losses while the system waits for a reversion that is no longer coming.

# The Summary

Pairs trading is not a simple strategy with statistics sprinkled on top. It is a statistical framework that produces trades when all conditions are correctly maintained simultaneously.

The team at Morgan Stanley in 1987 succeeded not because they had better predictions than everyone else. They succeeded because they asked a better question. Not where is the price going but what relationships in this market are mathematically anchored, and what happens when they stretch.

That question has a precise, implementable answer. The five parts of this article are that answer assembled into a complete working system.

Cointegration testing with Engle-Granger, Johansen, and the Hurst exponent ensures you are trading a genuine long-run equilibrium rather than recent co-movement. OU parameter estimation and half-life filtering tells you how the spread moves and whether it is fast enough or slow enough to trade given your cost structure. Cost-calibrated signal thresholds derived from the OU equilibrium standard deviation ensure every entry has positive expected value before you commit capital. OU-proportional position sizing derived from the structure of the process itself rather than imposed from outside keeps you largest when edge is largest and naturally de-risks as each trade approaches its target. The Kalman filter hedge ratio and rolling cointegration monitoring keep the whole system synchronized with reality rather than slowly drifting out of it.

Each layer is doing something specific that the others cannot do. Together they produce what the simple version cannot deliver: a system that knows what to trade, when to trade it, how much to put on, and when to stand aside. All this is educational content for actual builders and researchers. Not financial or investment advice. The math is real.

The naive version of pairs trading has run its course. This version built precisely, calibrated continuously, monitored actively still works. It always required more rigor than most people were willing to apply. That gap has not closed.

Here is the question worth sitting with.

You now have the complete five-layer framework. If you were applying this to a specific market today equities, crypto, ETFs, futures which asset class would you start with, and what fundamental reason would you use to justify the cointegration relationship beyond the statistical tests alone?

Drop it in the comments. There is no wrong answer. But there are very revealing ones.
