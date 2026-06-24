---
title: Crypto Trading Agent
type: concept
status: developing
tags: [crypto, trading, ai-agents, automação, fintech]
created: 2026-04-18
updated: 2026-05-19
---

# Crypto Trading Agent

Agente de AI que executa estratégias de trading de criptomoedas de forma autônoma, combinando uma data layer (APIs de mercado), uma intelligence layer (LLM + orchestrator) e uma execution layer (exchange APIs / wallets).

## Arquitetura padrão (3 camadas)

```
Data Layer     →  Intelligence Layer  →  Execution Layer
(CoinGecko,       (LLM + OpenClaw       (Exchange APIs,
 TradingView)      orchestrator)          Wallets)
```

Veja [[03-RESOURCES/concepts/claude-code-tooling/claude-agent-harness-architecture]] — a mesma estrutura de 3-4 camadas se aplica a agentes de trading.

## Estratégias principais

### 1. Cross-Exchange Arbitrage
Monitora desvio entre preço de benchmark agregado e preços individuais de exchange. Sinal: desvio > threshold líquido de taxas.

- **Realidade:** janelas capturadas em milissegundos por market makers colocados; melhor como ferramenta de aprendizado
- **Data:** WebSocket benchmark (CGSimplePrice)

### 2. On-Chain Token Discovery
Escaneia DEX pools em múltiplas redes com filtros de segurança/qualidade. Identifica tokens early-stage antes da descoberta pelo mercado.

- **Filtros:** liquidez mínima, volume 24h, txns, age, buy/sell ratio, bonding curve progress, holder distribution
- **Data:** Pools Megafilter + OHLCV onchain

### 3. Copy Trading
Identifica wallets consistentemente lucrativas e espelha suas trades. Requer avaliação qualitativa (não apenas PnL bruto) e **confirmação explícita do usuário** antes de executar.

- **Critérios de qualidade:** consistency, trade count, buy/sell balance, ausência de wash-trading, recency
- **Regra:** $3K PnL em 30 trades consistentes > $10K de um único pump

### 4. News-Based Sentiment
Classifica headlines de notícias cripto por sentimento e executa trades em thresholds configurados (strong_positive → BUY; strong_negative → SELL).

- **Risco:** sentiment pode lag atrás do movimento de preço
- **Data:** /news endpoint (100+ fontes, 30+ idiomas)

## Backtesting

Processo crítico antes de live trading. CLI de dados (CoinGecko CLI) puxa OHLCV histórico em bulk; agente escreve scripts Python para processar — mantém context window do LLM pequena, reduz custo.

Métricas: total return, trade count, win rate, max drawdown, Sharpe ratio, vs buy-and-hold.

## SKILL.md como estratégia

Cada estratégia de trading é codificada num SKILL.md — o agente recebe as instruções de como usar os dados e executar decisões. Padrão idêntico ao [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]].

Exemplo de estrutura de SKILL.md para arbitrage:
1. Load configuration
2. Subscribe WebSocket benchmark
3. On each update, fetch exchange prices
4. Detect & decide (spread > threshold?)
5. Execute trade (buy cheap, sell expensive)
6. Alert via Telegram

## Riscos

| Risco | Mitigação |
|---|---|
| AI hallucination / context drift | Sessões curtas; supervisão humana; /compact |
| Modelo pequeno = decisões ruins | Escolher modelo proporcional à complexidade |
| Segurança (API keys + wallet) | Nunca dar permissões de saque; IP restriction; wallet fresh |
| Mercado adverso | Paper trading primeiro; Kelly Criterion para sizing |

## Implementações no vault

- **[[03-RESOURCES/entities/OpenClaw]]** + **[[03-RESOURCES/entities/CoinGecko]]** — guia completo com 4 estratégias
- **[[03-RESOURCES/entities/TradingView-MCP]]** — análise técnica automatizada (S&P 500, BTC)
- **[[03-RESOURCES/entities/Polymarket]]** — prediction markets (evento-driven, não price-driven)

## Diferença vs Prediction Markets

| Dimensão | Crypto Trading Agent | Prediction Market Bot |
|---|---|---|
| Ativo | Tokens/cryptos | Contratos de evento (0-1) |
| Edge | Arbitrage, momentum, sentiment | Bayes, edge em lag de dados |
| Sizing | Fixed size ou Kelly | Kelly Criterion obrigatório |
| Data | Price feeds, onchain | Odds, notícias, dados de evento |
| Frameworks | OpenClaw, TradingView | Polymarket API, custom |

Veja [[03-RESOURCES/concepts/finance-trading/prediction-markets]] para o lado de prediction markets.

## Relação com outros conceitos do vault

- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — orchestrator + sub-agents é o padrão de produção
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — context window do LLM focada em raciocínio, não dados brutos
- [[03-RESOURCES/concepts/finance-trading/kelly-criterion]] — sizing ótimo de posições (guia OpenClaw usa tamanho fixo; Kelly é o próximo passo)
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — SKILL.md é o mecanismo de codificação de estratégias
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — CoinGecko e TradingView têm MCP servers (menos eficiente que CLI para bulk)

## Ver também

- [[03-RESOURCES/sources/financial-trading/how-to-build-openclaw-ai-crypto-trading-agent]]
- [[03-RESOURCES/sources/financial-trading/claude-tradingview-full-guide]]
- [[03-RESOURCES/sources/financial-trading/polymarket-infrastructure-business]]
