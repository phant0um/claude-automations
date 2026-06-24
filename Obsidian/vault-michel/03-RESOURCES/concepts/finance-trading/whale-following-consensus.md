---
title: Whale Following & Consensus Filter
type: concept
status: developing
created: 2026-04-24
updated: 2026-04-24
tags: [polymarket, copy-trading, whale-following, consensus, prediction-markets, trading-bot]
---

# Whale Following & Consensus Filter

Estratégia de trading em prediction markets que combina **copy trading de carteiras de alto desempenho** com um **filtro de consenso multi-agente** para eliminar sinais fracos.

## O Problema que Resolve

Mercados como Polymarket concentram retornos extremamente: os top 20 wallets lucram mais que os 13.000 de baixo combinados. Copiar esses wallets ingenuamente falha porque:
- Wallets especialistas são bons em **uma categoria** (crypto, política, clima)
- Copiar tudo dilui o edge
- Um único agente de copy pode errar o timing ou a categoria

## Como Funciona

### 1. Identificação de Target Wallets
Filtragem de wallets com:
- 100+ trades no histórico
- Win rate >70%
- Ranqueamento por total PnL

Resultado típico: 47 targets de um universo de 14.000+ wallets.

### 2. Whale Check como Sinal
Quando **3 ou mais** das 47 target wallets estão simultaneamente com posição YES em um mercado → **convergência de smart money** — acharam o mesmo edge por ângulos diferentes.

> [!key-insight] Convergência vs Coincidência
> 1 wallet em YES pode ser noise. 3+ wallets independentes em YES simultaneamente é sinal. Isso é diferente de seguir influenciadores — são wallets *verificadas por desempenho histórico*.

### 3. Filtro de Consenso Multi-Agente
Três agentes independentes avaliam cada mercado:
- **Arbitrage agent** — gaps de preço entre mercados relacionados
- **Convergence agent** — preço se movendo na direção da estimativa
- **Whale_copy agent** — espelha as target wallets com 60s de delay

**Regra:**
- 2/3 concordam → posição cheia
- 1/3 → meia posição
- Discordam → sem trade

Resultado: eliminou 40% dos losing trades apenas por exigir acordo.

### 4. Saída Baseada em Comportamento Observado
Análise empírica dos top 47 wallets revelou:
- 91% saem antes da resolução
- Saída média: 73% do lucro máximo
- Trigger principal: **volume spike** (volume 10min > 3× média) — smart money saindo

## Filtros Antes de Entrar

| Filtro | Threshold | Motivo |
|---|---|---|
| Gap de edge | ≥7¢ | Custos de transação comem edge menor |
| Profundidade | $500+ em ambos os lados | Não mover preço ao entrar |
| Tempo até resolução | 4–168h | Curto demais = tarde demais; longo demais = capital preso |
| Market size | $50K+ | Slippage em mercados pequenos apaga edge |
| Categoria | Crypto only (para copy) | Wallets crypto-specialist têm edge em crypto, não em sports |

## Relação com Kelly Criterion

O whale check + consensus vote determina **se** entrar. O [[03-RESOURCES/concepts/finance-trading/kelly-criterion]] determina **quanto**:

```python
def kelly_size(p_win, market_price, bankroll, max_fraction=0.25):
    b = (1 / market_price) - 1
    q = 1 - p_win
    f_star = (p_win * b - q) / b
    if f_star <= 0:
        return 0
    return round(bankroll * min(f_star, max_fraction), 2)
```

Sweet spot: f* entre 0.05 e 0.15. Cap em 0.25 (quarter Kelly).

## O Que Não Colar

- **Sports markets** — precificados antes do bot flagear; win rate ~52%
- **Copy sem filtro de categoria** — top wallets são especialistas em nichos
- **Hold até settlement** — 15–30% de retorno dado de volta em média

## Fontes

- [[03-RESOURCES/sources/financial-trading/polymarket-bot-200-to-14300-trackmind]] — implementação completa; $200→$14.300 em 27 dias
- [[03-RESOURCES/concepts/finance-trading/prediction-markets]] — contexto de Polymarket
- [[03-RESOURCES/concepts/finance-trading/kelly-criterion]] — position sizing
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — consensus de agentes independentes
- [[03-RESOURCES/concepts/llm-ml-foundations/bayesian-reasoning]] — base rate + disposition check (4 verificações do "brain")
