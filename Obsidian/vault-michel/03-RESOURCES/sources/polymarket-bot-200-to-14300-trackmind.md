---
title: "How I Turned a $200 Seed Into $14,300 With 4 Free Repos and One Claude Prompt"
type: source
source_file: .raw/How I Turned a $200 Seed Into $14,300 With 4 Free Repos and One Claude….md
author: Trackmind (@0xTrackmind)
ingested: 2026-04-24
tags: [polymarket, prediction-markets, trading-bot, kelly-criterion, claude, copy-trading, whale-following, consensus-agents]
---

# How I Turned a $200 Seed Into $14,300 With 4 Free Repos and One Claude Prompt

**Autor:** [@0xTrackmind](https://x.com/0xTrackmind)

> [!summary]
> Guia técnico completo de um bot de Polymarket construído com 4 repos open-source e Claude Code. $200 seed → $14.300 em 27 dias. 271 trades, 74% win rate, Sharpe 2.47. Custo total: $25/mês.

## Stack Completo

| Tool | Custo | Função |
|---|---|---|
| poly_data | Free | 86M trades, todo wallet histórico |
| polymarket-cli | Free | Scanner de mercados, official API |
| Polymarket/agents | Free | Framework de agente, LLM integration |
| Polymarket-Trading-Bot | Free | 53.000 linhas TypeScript, 7 estratégias |
| Claude API | $20/mês | Análise, brain, glue logic |
| VPS Hetzner | $5/mês | 24/7 uptime |

## Os 4 Passos do Bot

### Passo 0 — Data (poly_data)
- Repo: [github.com/warproxxx/poly_data](https://github.com/warproxxx/poly_data) — 646 stars
- 86 milhões de trades históricos públicos
- Claude scaneou 14.000+ wallets em 4 min e retornou 47 "target wallets" com 100+ trades e >70% win rate
- **Insight:** top 20 wallets lucraram mais que os 13.000 de baixo combinados — concentração extrema

```python
import polars as pl
df = pl.scan_csv("processed/trades.csv").collect(streaming=True)
wallets = (
    df.group_by("maker")
    .agg([
        pl.count().alias("trades"),
        (pl.col("profit") > 0).mean().alias("win_rate"),
        pl.col("profit").sum().alias("total_pnl"),
    ])
    .filter((pl.col("trades") >= 100) & (pl.col("win_rate") > 0.70))
    .sort("total_pnl", descending=True)
    .head(50)
)
```

### Passo 1 — Scanner (polymarket-cli)
- Repo oficial Polymarket em Rust, feito para agentes
- Sem API key para leitura; JSON direto
- Score de mercado em 3 fatores: gap de edge (mín 7¢), profundidade de order book ($500+), horas para resolução (4–168h)
- 93% dos mercados eliminados: 487 → 35

### Passo 2 — Brain (Polymarket/agents)
- 4 verificações antes de abrir posição:
  1. **Base rate** — histórico do tipo de evento
  2. **News check** — mudança nas últimas 6h
  3. **Whale check** — quantas das 47 target wallets estão em YES
  4. **Disposition check** — o mercado está preso por viés cognitivo?
- Consenso 3/4 → gera thesis; confidence >75% → Kelly sizing
- Kelly cappado em quarter Kelly (max_fraction=0.25)

```python
def kelly_size(p_win, market_price, bankroll, max_fraction=0.25):
    b = (1 / market_price) - 1
    q = 1 - p_win
    f_star = (p_win * b - q) / b
    if f_star <= 0:
        return 0
    return round(bankroll * min(f_star, max_fraction), 2)
```

### Passo 3 — Execução (Polymarket-Trading-Bot)
- 53.000 linhas TypeScript com 7 estratégias; usou apenas 3:
  - **Arbitrage** — gaps entre mercados relacionados
  - **Convergence** — entrada quando preço se move para estimativa
  - **Whale_copy** — espelha as 47 target wallets com 60s de delay
- **Regra de consenso:** 2 agentes concordam → posição cheia; 1 agente → meia posição; discordam → sem trade
- Consensus filter eliminou 40% dos losing trades

### Passo 4 — Saída
- 91% das saídas dos top wallets acontecem antes da resolução
- Saída média: 73% do lucro máximo potencial capturado
- 3 triggers de saída:
  1. **TARGET_HIT** — preço atingiu 85% do gap esperado
  2. **VOLUME_EXIT** — volume 10min triplicou vs média
  3. **STALE_THESIS** — 24h sem movimento (|price_change| < 2¢)

## Resultados Dia a Dia

| Dia | PnL Cumulativo | Trades | Win Rate |
|---|---|---|---|
| 2 | +$310 | 4 | 75% |
| 5 | +$870 | — | — |
| 7 | +$2.100 | — | 68% → 73% após kill sports |
| 14 | +$8.200 | — | — |
| 19 | +$11.400 | 214 | 74% (Sharpe 2.31) |
| 27 | +$14.300 | 271 | 74% (Sharpe 2.47) |

## O Que Não Funcionou

- **Sports markets** — win rate 52%, eliminados no dia 7
- **Mercados <$10K** — slippage apaga o edge; mínimo agora $50K
- **Hold até settlement** — deu back 15–30% do profit; volume exit resolveu
- **7 estratégias simultâneas** — mais ruído; 3 focused > 7 unfocused
- **Copy sem filtro** — top wallets são especialistas em 1 categoria; copiar tudo dilui

## Insight Central

> Os top wallets não preveem eventos — **preveem outros traders**. Encontram mercados onde a multidão está errada e esperam.

Quatro repos públicos. Dados gratuitos. Claude como glue. $25/mês total.

## Ligações

- [[03-RESOURCES/concepts/kelly-criterion]] — position sizing com quarter-Kelly
- [[03-RESOURCES/concepts/prediction-markets]] — contexto de Polymarket
- [[03-RESOURCES/concepts/whale-following-consensus]] — conceito de copy trading com consensus filter
- [[03-RESOURCES/concepts/bayesian-reasoning]] — base rate + disposition check
- [[03-RESOURCES/concepts/multi-agent-orchestration]] — 3 agentes com consensus voting
- [[03-RESOURCES/sources/3-formulas-polymarket-trading]] — Kelly/Bayes/Black-Scholes pipeline
- [[03-RESOURCES/sources/polymarket-1m-year-claude-bot]] — perspectiva de negócio vs trading
