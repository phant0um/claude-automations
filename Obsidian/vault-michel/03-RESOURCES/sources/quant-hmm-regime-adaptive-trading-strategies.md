---
title: "How Quants Use Hidden Markov Models To Build Regime-Adaptive Trading Strategies"
type: source
source: Clippings/How Quants Use Hidden Markov Models To Build Regime-Adaptive Trading Strategies (Quant Framework).md
created: 2026-06-20
ingested: 2026-06-21
tags: [quant, hmm, regime-detection, trading, source, score-A]
---

## Tese central

Hidden Markov Models (HMMs) detectam o regime oculto do mercado (bull, bear, neutral) a partir de returns observados, permitindo deploy da estratégia correta para cada regime. Backtest de 21 anos: 19.41% annualized return, Sharpe 1.22, max drawdown 19.54% vs SPY buy-and-hold 10.80% com 55.19% drawdown.

## Argumentos principais

- **Regimes não são diretamente observáveis** mas seus efeitos são visíveis em returns, volatility, correlations
- **HMM formalização**: hidden states z_t ∈ {0,1,2}, transition matrix A_ij, emission distribution r_t|z_t ~ N(μ_z_t, σ²_z_t)
- **Baum-Welch (EM)** estima parâmetros; **Viterbi** decoda a sequência mais provável de estados
- **Cada regime tem diferentes propriedades estatísticas** — momentum funciona em trending, mean-reversion em sideways, nenhum funciona em todos
- **Volatility clustering, momentum persistence, mean-reversion** são behaviours que mudam entre regimes

## Key insights

- Markets não são random walks — exibem regimes com statistical properties distintas
- A diferença entre 19.41% return e 10.80% é saber qual regime você está
- HMMs são uma forma de regime detection que não precisa de dados externos (só returns)
- Framework aplicável a qualquer asset class com regime behavior

## Exemplos e evidências

- 21-year backtest: 19.41% annualized, Sharpe 1.22, max DD 19.54%
- SPY buy-and-hold: 10.80% annualized, max DD 55.19%
- Python implementation with hmmlearn, sklearn
- Hamilton (1989) origin — economic business cycles

## Implicações para o vault

- Diretamente relevante para sistema finance-system (agent `quant` e `macro`)
- Conecta com [[03-RESOURCES/concepts/agent-systems/world-model]] — HMM é um world model para markets
- Macro agent classifica regime — HMM é uma metodologia concreta para isto

## Minha Síntese

**O que muda:** Regime detection não é opcional para quant — é a diferença entre 19% e 10% annualized. O vault já tem o agente `macro` que classifica regime, mas não usa HMM. Implementar HMM como backbone do `macro` melhoraria significativamente a qualidade do regime classification.

**Conexão pessoal:** O finance-system tem `macro` (regime), `fluxo` (renda passiva), `valor` (fundamentalista), `quant` (quantitativo). HMM é exatamente o que falta para conectar `macro` e `quant` — `macro` detecta regime, `quant` deploya a estratégia certa.

**Próximo passo:** Implementar HMM-based regime detection como skill do agente `macro` — usar hmmlearn com dados do IBOVESPA/SPY, 3 estados, backtestar antes de deploy.

## Links

- [[03-RESOURCES/concepts/agent-systems/world-model]]
- [[03-RESOURCES/entities/Claude]]
- [[03-RESOURCES/concepts/finance-trading/algorithmic-trading]] — HMM como método de regime detection para algo trading
- [[03-RESOURCES/concepts/finance-trading/trading-automation]] — deploy automatizado por regime