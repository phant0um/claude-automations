---
title: "Algorithmic Trading"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, finance-trading]
status: developing
---

# Algorithmic Trading

Execução sistemática de estratégias de trading via código — remove viés emocional, escala decisões e possibilita backtesting rigoroso antes de arriscar capital real.

## O que é

Algorithmic trading é o uso de programas computacionais para definir, testar e executar estratégias de compra e venda de ativos com base em regras quantitativas, sem intervenção manual em cada trade.

## Como funciona

**Tipos de estratégia:**
- _Momentum_: compra ativos em alta, short em queda; exploita persistência de tendência
- _Mean reversion_: aposta que preços extremos retornam à média; funciona em mercados laterais
- _Arbitragem_: explora diferença de preço de mesmo ativo em diferentes mercados ou instrumentos correlatos
- _ML-based_: features técnicas/fundamentais → modelo preditivo → sinal de entrada/saída

**Armadilhas de backtesting:**
- _Lookahead bias_: usar dados futuros inadvertidamente nos cálculos (ex: normalizar pelo max histórico incluindo o futuro)
- _Overfitting_: estratégia otimizada para o passado falha no futuro; validar com walk-forward ou out-of-sample holdout
- _Survivorship bias_: testar apenas em ativos que ainda existem ignora falências

**Live vs paper trading:** sempre rodar paper trading (simulação com dados reais) antes de capital real. Valida execução, latência e edge cases de API.

**Stack prático:** Claude Code como orchestrator + TradingView MCP para dados e sinais + API de corretora (Alpaca para US equities, Interactive Brokers para global) para execução.

## Por que importa

Trading manual é insustentável em escala e sujeito a vieses cognitivos. Algo trading exige disciplina quantitativa — mas backtests enganosos geram confiança falsa. O ciclo correto é: hipótese → backtest rigoroso → paper → live com tamanho mínimo → escalar.

## Related
- [[03-RESOURCES/concepts/trading-automation]]
- [[03-RESOURCES/concepts/bayes-theorem-trading]]
- [[03-RESOURCES/concepts/finance-trading/market-microstructure]]
- [[03-RESOURCES/sources/quant-hmm-regime-adaptive-trading-strategies]] — HMM para regime-adaptive trading (21y backtest, 19.41% annualized)
