---
title: "Market Microstructure"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, finance-trading]
status: developing
---

# Market Microstructure

Como mercados realmente funcionam abaixo do gráfico de candles: order book, formação de preço, e por que execução imperfeita corrói retornos teóricos.

## O que é

Market microstructure estuda os mecanismos pelos quais ordens se transformam em trades e preços — o layer entre estratégia e execução que backtests frequentemente ignoram.

## Como funciona

**Order Book:** lista de ordens de compra (bids) e venda (asks) pendentes, ordenadas por preço. O melhor bid e melhor ask formam o _top of book_; a diferença é o bid-ask spread.

**Tipos de ordem:**
- _Market order_: executa imediatamente ao melhor preço disponível; garantia de execução, sem garantia de preço
- _Limit order_: especifica preço máximo (compra) ou mínimo (venda); pode não executar se o mercado não tocar o preço

**Price discovery:** processo pelo qual informação nova é incorporada nos preços via fluxo de ordens. Participantes informados (com edge informacional) empurram preço; market makers ajustam quotes.

**Liquidez:** facilidade de executar ordens grandes sem mover o preço. Ativos ilíquidos têm spreads largos e book raso — um trade de 10k ações pode mover o preço 1–2%.

**Slippage:** diferença entre preço esperado (backtesting) e preço real de execução. Causado por spread, impacto de mercado e latência. Em estratégias de alta frequência, domina o P&L.

**Impacto do HFT:** market makers de alta frequência reduzem spreads em ativos líquidos mas podem amplificar volatilidade em eventos de estresse (flash crashes).

## Por que importa

Uma estratégia com 0.3% de retorno esperado por trade é destruída por 0.15% de spread + 0.2% de slippage. Ignorar microestrutura é o erro mais comum em backtests de varejo. Estratégias ao vivo precisam modelar custo de execução explicitamente.

## Related
- [[03-RESOURCES/concepts/finance-trading/algorithmic-trading]]
- [[03-RESOURCES/concepts/trading-automation]]
