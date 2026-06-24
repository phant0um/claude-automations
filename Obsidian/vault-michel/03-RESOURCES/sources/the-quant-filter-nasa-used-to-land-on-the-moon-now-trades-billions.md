---
title: "The Quant Filter NASA Used To Land On The Moon Now Trades Billions"
type: source
source: "Clippings/The Quant Filter NASA Used To Land On The Moon Now Trades Billions.md"
created: 2026-06-21
ingested: 2026-06-21
tags: [articles, quant-trading]
---

## Tese central
O Filtro de Kalman (1960), usado pela NASA para estimar posição da Apollo em tempo real a partir de instrumentos ruidosos, é hoje a mesma máquina matemática usada em pairs trading para estimar o hedge ratio "verdadeiro" entre dois ativos — tratando-o como estado oculto que deriva no tempo, não como número fixo medido por regressão única.

## Argumentos principais
- Problema do hedge ratio estático: regressão única sobre uma janela histórica assume que a relação entre dois ativos é constante — na prática ela deriva (mudança de regime, alavancagem, liquidez) e o "market neutral" vira silenciosamente direcional.
- Patch ingênuo (janela rolante) só troca um problema por dois: janela curta = beta ruidoso; janela longa = beta obsoleto — equivalente a "chutar a resposta via tamanho de janela".
- Mudança de perspectiva central do Kalman filter: parar de tratar o hedge ratio como número medido e tratá-lo como estado oculto nunca observado diretamente, estimado continuamente a partir de evidência ruidosa (preços = sinal + ruído) — exatamente o mesmo problema que a NASA resolveu para posição de nave com radar/giroscópio ruidosos.

## Key insights
- O padrão "parar de tratar X como medição fixa, tratar como estado oculto que deriva e precisa de estimação contínua" generaliza bem além de trading — é a mesma lógica de qualquer score/triagem deste vault que hoje é calculado uma vez e tratado como verdade permanente (ex.: score de qualidade de fonte, ou peso de roteamento de modelo) quando na prática a "verdadeira" relevância de uma fonte muda com o tempo.
- Janela rolante como "patch ingênuo que troca um problema por dois" é um aviso direto contra qualquer heurística deste vault que dependa de escolher arbitrariamente um tamanho de janela (ex.: "últimos N dias" para hot.md ou triagem) sem mecanismo de adaptação.

## Exemplos e evidências
- Caso de uso de pairs trading com explicação passo a passo do problema do beta estático e da solução via Kalman filter (estado oculto + duas fontes de incerteza balanceadas pelo filtro).

## Implicações para o vault
Nenhuma ação direta — referência conceitual cruzada com HMM regime-adaptive trading já ingerido nesta leva (`how-quants-use-hidden-markov-models...`), reforçando que modelagem de estado oculto que se adapta no tempo é tema recorrente em quant trading aplicável como metáfora a sistemas de scoring adaptativo.

## Links
- [[03-RESOURCES/sources/how-quants-use-hidden-markov-models-to-build-regime-adaptive-trading-strategies-]]
