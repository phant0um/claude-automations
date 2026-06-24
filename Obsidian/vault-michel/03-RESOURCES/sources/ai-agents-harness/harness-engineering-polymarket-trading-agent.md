---
title: "Harness Engineering: The 16-Step Roadmap to a Polymarket Trading Agent"
type: source
source: "Clippings/Harness engineering the 16-step roadmap to a Polymarket trading agent.md"
author: "@ArchiveExplorer"
published: 2026-06-22
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents-harness, forecasting, trading-agents, polymarket, harness-engineering]
score: A
---

## Tese Central

O loop que todos postam sobre é uma parte de uma máquina maior — o harness. Um forecasting agent é onde o harness fica interessante porque o verifier mais difícil (a parte 5) é entregue de graça: um mercado que settle em cash frio e un-gameable. Mas a versão honesta: deixado sozinho, não printa dinheiro — seis frontier models com cash real mostly lost. O ponto é manter honesto, mais rápido que P&L próprio.

## Pontos-Chave

1. **Harness = Model + Harness** (Viv Trivedy). O loop é 1 de 10 partes do harness (Addy Osmani): agentic loop, tools, context management, memory/state, gates/verification, orchestration/subagents, permissions/sandbox, errors/retries, observability, model routing.
2. **4-condition test antes de buildar**: (1) questão recorre, (2) verifier objetivo que você não controla (market resolution + CLV), (3) budget absorve research waste, (4) agent tem market e news tools. Miss uma → single good prompt ou no bet wins.
3. **Gate = mercado é o verifier**: para coding agent o gate é test suite (que você escreveu, agent pode overwrite). Para forecasting agent, resolution é adjudicada por exchange externa. CLV (closing-line value) é twin de trading: beating closing line = evidência direta de skill. Brier/log score minimized only when you report true probability.
4. **Split forecaster/skeptic**: o structural move mais útil — forecaster tem tool belt completo, skeptic tem ZERO market-data tools, vê só rationale + resolution text. Different context, restricted tools → não pode rubber-stamp.
5. **Scorecard é o spine**: arquivo fora da conversa que segura cada forecast, preço, close, resolution. Memory resets cada session; ledger não. CLV separa skill de variance em ~50-300 forecasts; raw profit precisa thousands.
6. **Baseline humbling**: 6 frontier models, $10K cada, 57 dias autonomous trades. Kalshi returns: −16% to −31%, avg −22.6%. Polymarket: −1.1%. Frontier model left to trade real money loses.
7. **Backtest lies**: out-of-sample collapses ~26% below in-sample, ~58% below after public. Haircut Sharpe by half. Paper-trade 200-300 forecasts before trust CLV, 500-1000 before trust edge.
8. **Security tax**: never auto-trade without human gate (PreToolUse hook). 520 de 17,022 agent skills com security issues. Trading harness holds exchange API keys — exactly what malicious skill exfiltrates.

## Conceitos

- Harness engineering: 10 partes, loop é 1 de 10
- Closing-Line Value (CLV) como metric de skill vs variance
- Proper scoring rules (Brier, log score) — no lie scores better
- Forecaster/Skeptic split (evaluator-optimizer pattern)
- Reward calibration (CLV/Brier) não profit — profit é o que reward-hacking otimiza
- Goodharting the backtest: tuning until history sparkles fits noise
- PreToolUse hooks como human gate

## Minha Síntese

**O que muda:** Este é o artigo mais completo de harness engineering aplicado. Os 10 componentes de Osmani e o 4-condition test são diretamente aplicáveis ao vault — o pipeline-semanal é um harness sem market gate. A separação forecaster/skeptic é exatamente o pattern evaluator-optimizer que falta no vault (F2.8/F3.5 spot-checks são rudimentares).

**Conexão pessoal:** O conceito de "gate on the thing you don't control" é profundo. Para o vault, o gate atual é validation heuristic (self-graded). Um gate externo seria: rodar ingest em uma amostra e medir precision/recall contra revisão humana — o mercado equivalente.

**Próximo passo:** Implementar scorecard pattern no pipeline-semanal: cada batch registra precision (source pages corretas / total), recall (concepts missed), e CLV-analog (tempo economizado vs manual). O skeptic agent com restricted tools é o próximo upgrade do adversarial-gate.

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
- [[03-RESOURCES/concepts/agent-systems/agent-loop]]
- [[03-RESOURCES/concepts/agent-systems/agent-eval-framework]]
- [[03-RESOURCES/concepts/agent-systems/agent-governance-layers]]
- [[03-RESOURCES/concepts/llm-ml-foundations/generator-verifier-loop]]
- [[03-RESOURCES/entities/Boris-Cherny]]
- [[03-RESOURCES/sources/ai-agents-harness/codex-symphony-orchestration-spec]]