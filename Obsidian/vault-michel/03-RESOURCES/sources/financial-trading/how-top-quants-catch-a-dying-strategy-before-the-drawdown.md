---
title: "How Top Quants Catch a Dying Strategy Before the Drawdown (Full Framework)"
type: source
source: "[x.com/horizon_trade_x](https://x.com/horizon_trade_x/status/2065077566763925924)"
created: 2026-06-13
ingested: 2026-06-13
tags: [articles]
---

## Tese central

Framework institucional completo para monitorar uma estratégia de trading em
produção e decidir quando matá-la, retuná-la, ou deixá-la rodar — incluindo
as 3 forças de decay, as 4 métricas monitoradas semanalmente, e kill criteria
escritos antes do deploy.

## Argumentos principais

- **Estatística de abertura**: estudo de 2016 testou 97 estratégias
  publicadas — edge médio caiu 58% após publicação. Toda estratégia tem
  half-life.
- **3 forças que matam estratégias** (cada uma exige resposta diferente):
  1. **Crowding** — sinal paga porque pouca gente o explora; conforme
     capital chega, trades executam mais caro e o retorno comprime
     (responsável pela maior parte do 58% acima). Sem cura — retirar.
  2. **Regime change** — premissa da estratégia (ex: momentum assume que
     tendências persistem) quebra quando o regime muda. Re-tunável.
  3. **Overfitting exposto** — backtest encontrou padrão em ruído; live
     trading é o primeiro teste out-of-sample honesto. Morrem rápido
     (semanas).
- **Problema central: variância vs decay**. Mesmo uma estratégia com Sharpe
  real de 1.0 tem ~1 em 6 anos perdedores. O Medallion (melhor track record
  da história) acertava só ~50.75% dos trades. Resposta institucional:
  resample do histórico de trades milhares de vezes → "performance cone"
  (dentro = ruído normal, fora = informação real).
- **4 métricas monitoradas semanalmente vs baseline do backtest**:
  1. Rolling Sharpe (90 dias) — abaixo do percentil 5 do backtest = early flag
  2. Drawdown depth E duration (duration é subestimado — estratégia pode
     morrer "de lado" por 2 anos sem drawdown profundo)
  3. Trade-level drift — hit rate, profit factor, win/loss médio (decay
     aparece como "vencedores ficando menores" por ~6 meses seguidos)
  4. Slippage drift — gap entre fills modelados e reais; gap crescente
     geralmente precede decay do sinal (execution decay vem antes)
- **Kill criteria escritos ANTES do deploy** (porque "a versão de você que
  está -12% vai negociar"):
  - Soft breach: Rolling Sharpe < percentil 5 do backtest, OU drawdown >
    1.0x o máximo do backtest → corta tamanho da posição pela metade
  - Hard breach: drawdown > 1.5x o máximo, OU tempo underwater > 1.5x o
    stretch mais longo do backtest → pausa a estratégia
- **Re-tune ou retire** (decisão pós hard-breach): regime change → re-tunar
  parâmetros (lookbacks, vol filters, sizing); crowding → retirar e
  realocar (nenhum parâmetro ressuscita um sinal arbitrado).
- **Disciplina crítica**: todo re-tune precisa ser validado em dados que os
  novos parâmetros nunca viram. Refit no último drawdown produz uma
  estratégia que teria evitado exatamente aquela dor — e nada mais
  (curve-fitting em produção).
- **4 erros mais comuns**: matar cedo demais (drawdown estatisticamente
  normal), matar tarde demais (sunk cost), refit após cada losing streak
  (curve-fitting progressivo), e não ter regras escritas (decisões sob
  stress).

## Key insights

- Half-life é a regra, não a excessão: edge médio cai 58% após publicação.
- Duration do drawdown é uma métrica subestimada — morte lenta "de lado" é
  tão perigosa quanto drawdown profundo.
- Slippage drift (execution decay) geralmente precede o decay do sinal —
  é um early warning antes das métricas de retorno se moverem.

## Checklist operacional

- Pré-deploy: max drawdown, longest underwater, distribuição de rolling
  Sharpe, expectancy, slippage modelado + kill criteria por escrito
- Semanal: rolling Sharpe vs percentil backtest, drawdown depth/duration vs
  máximos, hit rate/profit factor vs baseline, fills reais vs modelados
- Soft breach → meia posição. Hard breach → pausa + diagnóstico
  crowding-vs-regime. Re-tune → fresh out-of-sample run + comparação de
  versões antes de redeploy

## Implicações para o vault

- O kill-criteria framework forma a segunda metade de um blueprint completo
  para qualquer agente de trading autônomo no vault (ex:
  `polymarket-bot-200-to-14300-trackmind`,
  `i-built-a-self-improving-ai-trading-agent-with-hermes`): após gerar e
  combinar sinais (ver artigo companheiro sobre combinação de 50 sinais
  fracos) → operar → monitorar 4 métricas semanais → kill criteria
  automatizados.

## Links

- [[03-RESOURCES/concepts/finance-trading/kelly-criterion]]
- [[03-RESOURCES/concepts/finance-trading/algorithmic-trading]]
- [[03-RESOURCES/sources/financial-trading/polymarket-bot-200-to-14300-trackmind]]
