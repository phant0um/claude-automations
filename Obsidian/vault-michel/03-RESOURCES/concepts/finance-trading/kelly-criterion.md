---
title: Kelly Criterion
type: concept
status: developing
updated: 2026-04-16
tags: [kelly, bankroll, sizing, prediction-markets, trading, probabilidade]
---

# Kelly Criterion

Fórmula matemática para o dimensionamento ótimo de apostas/posições quando se tem uma vantagem conhecida. Maximiza o crescimento geométrico do bankroll no longo prazo.

## Origem

**John Kelly Jr.** (1956) — Bell Telephone Laboratories, NJ. Trabalhava em teoria da informação (ruído em linhas telefônicas). Percebeu que o problema era matematicamente idêntico ao sizing ótimo de apostas. Publicou na Bell System Technical Journal.

**Ed Thorp** — contador de cartas em Vegas, depois gestor de um dos hedge funds mais bem-sucedidos da história — chamou de "o princípio de aposta mais importante já descoberto." Os cassinos odeiam.

## A Fórmula

**Geral:** f* = (bp - q) / b

| Variável | Significado |
|---|---|
| f* | Fração do bankroll a apostar |
| b | Odds líquidas (quanto se ganha por 1 apostado) |
| p | Probabilidade de ganhar |
| q | Probabilidade de perder (1 - p) |

**Para contratos binários (Polymarket — pagam R$1 se YES):**

```python
def kelly_fraction(p_win, price_cents):
    """
    Fração ótima de bankroll para contrato binário do Polymarket.
    
    p_win: probabilidade estimada de YES (0 a 1)
    price_cents: preço atual em centavos (0 a 100)
    """
    cost = price_cents / 100
    payout = 1.0
    if cost >= payout:
        return 0  # Sem edge
    b = (payout - cost) / cost  # Odds líquidas
    f = (b * p_win - (1 - p_win)) / b
    return max(0, f)

# Exemplos:
# Mercado em 40¢, probabilidade real 60% → Kelly: 26.7%
# Mercado em 70¢, probabilidade real 80% → Kelly: 9.5%
# Mercado em 80¢, probabilidade real 82% → Kelly: 2.5% (edge pequeno, aposta pequena)
```

## Por que Kelly é fundamental

Kelly faz algo que nenhuma intuição consegue: **escala automaticamente a aposta com o edge**.

- **Edge pequeno** → aposta pequena (protege o bankroll)
- **Edge grande** → aposta grande (maximiza crescimento)
- **Sem edge** → aposta zero (não entra no trade)

**A garantia matemática:** Um trader que usa Kelly fiel terá crescimento geométrico máximo no longo prazo. Qualquer outra estratégia produz crescimento subótimo — ou ruína.

> [!key-insight] Regra inviolável
> Apostar **mais** que Kelly diz matematicamente **destrói** retornos de longo prazo. Não às vezes. Não provavelmente. Sempre. Cada trade acima do Kelly é uma subtração composta dos retornos futuros.

## Quarter-Kelly: O Ajuste Prático

Full Kelly é matematicamente ótimo mas emocionalmente brutal — sequências de perdas a full Kelly parecem catastróficas mesmo quando a matemática está funcionando.

Maioria dos traders profissionais usa **0.25× Kelly**:

```python
def position_size(p_win, price_cents, bankroll, fraction=0.25):
    f = kelly_fraction(p_win, price_cents)
    return bankroll * f * fraction

# $10.000 bankroll, mercado em 35¢, probabilidade real 55%
# Full Kelly: 34.3% → $3.430
# Quarter Kelly: $857 → compra 2.449 cotas
```

## Relação com o sistema completo

Kelly é o **passo 3** do sistema Bayes + Black-Scholes + Kelly:
1. **Bayes** estima a probabilidade real
2. **Black-Scholes** confirma onde o mercado erra na precificação de risco
3. **Kelly** determina exatamente quanto apostar

Ver [[03-RESOURCES/sources/financial-trading/3-formulas-polymarket-trading]] para o pipeline Python completo.

## Traders referência no Polymarket

- **Sharky6999** — 99.1% win rate nos mercados de 5/15 minutos; usa Kelly-based sizing
- **ColdMath** — melhor trader de mercados de clima; sizing baseado em Kelly

## Fontes

- [[03-RESOURCES/sources/financial-trading/3-formulas-polymarket-trading]] — context + implementação Python completa
- [[03-RESOURCES/concepts/finance-trading/prediction-markets]] — contexto de prediction markets
- [[03-RESOURCES/concepts/llm-ml-foundations/bayesian-reasoning]] — fórmula que alimenta a estimativa de probabilidade do Kelly
