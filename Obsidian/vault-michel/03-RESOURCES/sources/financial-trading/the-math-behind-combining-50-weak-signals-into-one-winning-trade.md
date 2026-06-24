---
title: "The Math Behind Combining 50 Weak Signals Into One Winning Trade"
type: source
source: "[x.com/RohOnChain](https://x.com/RohOnChain/status/2041180375838498950)"
created: 2026-06-13
ingested: 2026-06-13
tags: [articles]
---

## Tese central

Como desks quant institucionais combinam dezenas de sinais fracos e
individualmente pouco confiáveis em um sinal de trading forte, via matemática
de alocação ótima de pesos. O framework é o mesmo para equities, futures e
prediction markets — só troca "retorno esperado" por "probabilidade implícita".

## Argumentos principais

- **Lei Fundamental da Gestão Ativa**: `IR = IC × √N` — Information Ratio
  (edge ajustado a risco) escala com a raiz quadrada do número de sinais
  **genuinamente independentes**. Sinais institucionais reais têm IC
  (information coefficient) entre 0.05 e 0.15 — i.e., estão errados na
  maioria das vezes, individualmente.
  - Exemplo: 50 sinais com IC=0.05 → IR = 0.05×√50 = 0.354, mais de 3x
    superior a um único sinal com IC=0.10.
- **5 categorias de sinal usadas por desks sistemáticos**:
  1. Momentum/price (`E(i) = (1/d)·Σ R(i,s)` sobre janela d)
  2. Mean reversion (desvio cross-sectional do fair value)
  3. Volatility (gap implied vs realized vol — volatility risk premium)
  4. Factor (Fama-French 3-factor: `R(i) = α + β1·MKT + β2·SMB + β3·HML + ε`)
  5. Microstructure (orderbook imbalance, effective spread =
     `2 × |Trade Price − Mid Price|`)
- **Motor de combinação em 11 passos** (de retornos brutos a pesos ótimos):
  1. Coletar série de retornos realizados por sinal
  2. Demean serial: `X(i,s) = R(i,s) − média(R(i,s))`
  3. Variância amostral: `σ(i)² = (1/M)·Σ X(i,s)²`
  4. Normalizar: `Y(i,s) = X(i,s)/σ(i)`
  5. Reter M períodos, descartar observação mais recente (anti-overfitting)
  6. Demean cross-sectional: `Λ(i,s) = Y(i,s) − média(Y(j,s))` em cada período
     (remove efeito de mercado comum a todos os sinais)
  7. Reter M-1 períodos
  8. Retorno esperado via média móvel d-dias, normalizado:
     `E_normalized(i) = E(i)/σ(i)`
  9. Regressão sem intercepto de `E_normalized` sobre `Λ(i,s)` → resíduos
     `ε(i)` = contribuição genuinamente independente de cada sinal
  10. Peso: `w(i) = η · ε(i)/σ(i)` (proporcional ao edge independente,
      inverso à volatilidade)
  11. Normalizar vetor de pesos: Σ|w(i)| = 1
- **Insight central**: o "N" na fórmula IR=IC×√N não é a contagem de sinais,
  é o número *efetivo* de sinais independentes após remover variância
  compartilhada. 50 sinais correlacionados podem valer só 6-15 efetivos —
  e usar leverage calibrado para 20 sinais independentes quando você só tem
  6 é o mecanismo por trás da maioria dos blowups sistemáticos.
- **Aplicação a prediction markets**: substitui "retorno esperado" por
  "probabilidade implícita". Cada sinal (cross-venue pricing, calibração
  histórica, Bayesian update `P(H|E) = [P(E|H)·P(H)]/P(E)`, microstructure
  via VPIN, momentum) produz uma probabilidade implícita; roda-se pelo motor
  de 11 passos → probabilidade combinada → compara com preço atual do
  Polymarket = edge.
- **Position sizing**: Kelly empírico ajustado por incerteza —
  `f_empirical = f_kelly × (1 − CV_edge)`, onde `CV_edge` vem de simulação
  Monte Carlo (10k paths) dos retornos históricos.
- Cita estatística: mercados precificados entre 5-15% de probabilidade
  resolvem YES em apenas 4-9% das vezes — gap = traders rodando modelos
  incompletos (single-signal).

## Key insights

- "A pessoa que sempre está certa não existe. A desk que ganha é a que
  combina corretamente sinais cada um ligeiramente certo." (citação do Head
  of Quant Research do autor)
- Correlação não-detectada entre sinais é a causa mais comum de "estava
  certo na direção, errado no tamanho da posição".
- O framework é o mesmo para equities, futures e prediction markets — só
  troca "retorno esperado" por "probabilidade implícita".

## Implicações para o vault

- O motor de 11 passos forma a primeira metade de um blueprint completo para
  qualquer agente de trading autônomo no vault (ex:
  `polymarket-bot-200-to-14300-trackmind`,
  `i-built-a-self-improving-ai-trading-agent-with-hermes`): gerar N sinais →
  combinar via IR=IC×√N → operar → (ver framework de monitoramento de decay
  no artigo companheiro sobre kill criteria).
- Conecta com Kelly empírico (sizing), microstructure (effective spread,
  VPIN) e prediction markets (aplicação a Polymarket).

## Links

- [[03-RESOURCES/concepts/finance-trading/kelly-criterion]]
- [[03-RESOURCES/concepts/finance-trading/market-microstructure]]
- [[03-RESOURCES/concepts/finance-trading/prediction-markets]]
- [[03-RESOURCES/concepts/finance-trading/algorithmic-trading]]
- [[03-RESOURCES/sources/financial-trading/polymarket-bot-200-to-14300-trackmind]]
- [[03-RESOURCES/sources/financial-trading/3-formulas-polymarket-trading]]
