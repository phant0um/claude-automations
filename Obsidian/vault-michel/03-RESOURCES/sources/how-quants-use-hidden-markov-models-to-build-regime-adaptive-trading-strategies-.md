---
title: "How Quants Use Hidden Markov Models To Build Regime-Adaptive Trading Strategies"
type: source
source: "Clippings/How Quants Use Hidden Markov Models To Build Regime-Adaptive Trading Strategies (Quant Framework).md"
created: 2026-06-20
ingested: 2026-06-21
tags: [articles, quant-finance]
---

## Tese central
Toda estratégia quant funciona bem em apenas um regime de mercado (momentum vence em tendência, mean-reversion vence em lateralização) — Hidden Markov Models (Hamilton, 1989) resolvem isso inferindo o regime oculto (bull/bear/neutro) a partir dos retornos observáveis, permitindo trocar de estratégia conforme o regime detectado. Backtest de 21 anos: retorno anualizado 19.41% / Sharpe 1.22 / drawdown máx 19.54%, contra buy-and-hold SPY 10.80% / drawdown 55.19%.

## Argumentos principais
- Mercados não são passeios aleatórios estacionários: exibem volatility clustering, momentum e mean-reversion — mas esses comportamentos alternam ao longo do tempo porque o regime subjacente muda; o mesmo ativo pode ter momentum num período e mean-reversion em outro.
- HMM modela 3 elementos: estado oculto z_t (bull/bear/neutro), matriz de transição A_ij (probabilidade de mudar de regime), distribuição de emissão (retornos ~ N(μ,σ²) específica por regime). Baum-Welch (EM) estima parâmetros; Viterbi decodifica a sequência de estados mais provável.
- Implementação prática usa retornos diários + volatilidade realizada de 20 dias como features — combinar ambas melhora dramaticamente a separação de regimes (vs. usar só retorno).

## Key insights
- O ganho de performance não vem de prever o retorno em si, mas de inferir corretamente QUAL regime está ativo e então alocar a estratégia já validada para aquele regime — é um problema de classificação de estado oculto, não de previsão de preço.
- A queda de drawdown (55%→19%) é mais significativa que o ganho de retorno (10.8%→19.4%) — regime-detection funciona primariamente como controle de risco (evitar a estratégia errada no regime errado), não como alpha generation pura.

## Exemplos e evidências
- Código Python completo usando `hmmlearn.GaussianHMM` com 3 regimes, covariância full, normalização via StandardScaler.
- Métricas de backtest de 21 anos comparadas diretamente contra buy-and-hold.

## Implicações para o vault
Relevante para `02-AREAS/fiap` (MVC + Fintech) e qualquer exploração futura de modelos quantitativos — HMM como técnica de regime-detection é aplicável além de trading (qualquer série temporal com estados ocultos alternantes, ex.: análise de carga de sistema, padrões de uso).

## Links
- [[02-AREAS/fiap/fiap-index]]
