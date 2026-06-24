---
title: Black-Scholes para Contratos Binários
type: concept
status: developing
updated: 2026-04-16
tags: [black-scholes, volatilidade, options, polymarket, trading, precificacao]
---

# Black-Scholes para Contratos Binários

Adaptação da fórmula de precificação de opções de Fischer Black e Myron Scholes (1973) para contratos binários do tipo Polymarket. Uso principal: extrair **volatilidade implícita** do mercado e detectar onde o mercado erra na precificação de risco.

## Origem

**Fischer Black + Myron Scholes** (1973) — "The Pricing of Options and Corporate Liabilities", Journal of Political Economy. Rejeitado 2 vezes antes de publicar. Ganhou Nobel (Scholes + Merton, 1997 — Black havia morrido).

**O colapso do LTCM (1998):** Long-Term Capital Management, fundo gerido pelos próprios criadores da fórmula + 2 Nobel adicionais, alavancou $125B usando Black-Scholes e quase colapsou o sistema financeiro global. O Fed organizou um bailout de $3.6B. **A fórmula estava correta. O sizing estava insano.** (Lição: Kelly Criterion aplicado ao Black-Scholes é obrigatório.)

## A Fórmula Original vs. Adaptação Binária

Black-Scholes foi construído para opções europeias que expiram em qualquer valor ao longo de uma faixa. Contratos Polymarket são **binários** — expiram em exatamente $0 ou $1.

**Adaptação para contrato digital binário:**

```
Price = e^(-rT) × N(d2)

d2 = [ln(S/K) + (r - σ²/2)T] / (σ√T)
```

| Variável | Significado |
|---|---|
| Price | Preço do contrato (= probabilidade implícita) |
| r | Taxa livre de risco (≈ 0 para contratos curtos) |
| T | Tempo até expiração em anos |
| N() | Distribuição normal cumulativa |
| S | "Probabilidade" atual (preço do contrato) |
| K | Strike probability (tipicamente 0.50) |
| σ | Volatilidade implícita |

## Implementação Python

```python
import numpy as np
from scipy.stats import norm
from scipy.optimize import brentq

def binary_black_scholes_price(S, K, T, r, sigma):
    """
    Preço teórico de contrato binário tipo Polymarket.
    
    S: preço/probabilidade atual (0 a 1)
    K: strike probability (tipicamente 0.5)
    T: tempo até expiração em anos
    r: taxa livre de risco (use 0 para mercados curtos)
    sigma: volatilidade implícita
    """
    d2 = (np.log(S/K) + (r - 0.5 * sigma**2) * T) / (sigma * np.sqrt(T))
    return np.exp(-r * T) * norm.cdf(d2)


def implied_volatility(market_price, S, K, T, r=0):
    """
    Inverte Black-Scholes para encontrar a volatilidade implícita do mercado.
    
    market_price: preço atual do contrato (0 a 1)
    Retorna: volatilidade implícita (IV) ou None se sem solução
    """
    def objective(sigma):
        return binary_black_scholes_price(S, K, T, r, sigma) - market_price
    try:
        return brentq(objective, 0.01, 10.0)
    except ValueError:
        return None


def find_vol_surface_edge(price_march, price_june, days_march, days_june):
    """
    Vol Surface Arbitrage: mesmo evento em 2 timeframes.
    Quando a relação Black-Scholes se quebra → oportunidade explorável.
    """
    T_march = days_march / 365
    T_june = days_june / 365
    
    iv_march = implied_volatility(price_march, price_march, 0.5, T_march)
    iv_june = implied_volatility(price_june, price_june, 0.5, T_june)
    
    if iv_march and iv_june:
        iv_ratio = iv_june / iv_march
        # Relação esperada: IV deve escalar com √T
        expected_ratio = np.sqrt(T_june / T_march)
        edge = iv_ratio / expected_ratio
        return {"iv_march": iv_march, "iv_june": iv_june, "edge_ratio": edge}
```

## O Edge Real: Volatilidade Implícita

Inverter Black-Scholes para encontrar a IV revela **o que o mercado está "precificando" de incerteza**:

- **IV baixa** → mercado subprecifica risco (oportunidade de compra de opcionalidade)
- **IV alta** → mercado superprecifica certeza (oportunidade de venda)

### Vol Surface Arbitrage

Mesmo evento em múltiplos timeframes cria superfície de volatilidade:
- "X acontece até março?" e "X acontece até junho?" deveriam ter uma relação matemática definida
- Black-Scholes define o que essa relação DEVE ser
- Quando a relação se quebra → **arbitragem explorável entre contratos**

## No sistema completo

Black-Scholes é o **passo 2** do sistema Bayes + Black-Scholes + Kelly:
1. **Bayes** estima a probabilidade real
2. **Black-Scholes** confirma onde o mercado erra na precificação de risco (IV check)
3. **Kelly** dimensiona a posição

```python
# Checagem de IV no pipeline completo
market_price = market_price_cents / 100
T = days_to_expiry / 365
iv = implied_volatility(market_price, current_prob, K=0.5, T=T)
# IV baixa + edge Bayesiano = sinal duplo de oportunidade
```

## Ver também

- [[03-RESOURCES/sources/financial-trading/3-formulas-polymarket-trading]] — contexto completo e pipeline Python integrado
- [[03-RESOURCES/concepts/finance-trading/kelly-criterion]] — passo 3 do sistema (sizing)
- [[03-RESOURCES/concepts/llm-ml-foundations/bayesian-reasoning]] — passo 1 do sistema (probabilidade)
- [[03-RESOURCES/concepts/finance-trading/prediction-markets]] — contexto de prediction markets
