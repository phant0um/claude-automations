---
title: "RAGEN-2: Reasoning Collapse in Agentic RL"
type: source
source: Clippings/RAGEN-2 Reasoning Collapse in Agentic RL.md
created: 2026-06-20
ingested: 2026-06-21
tags: [ai-agents, agentic-rl, reasoning-collapse, source, score-B]
---

## Tese central

RAGEN-2 identifica template collapse: modelos com entropy estável podem usar templates fixos input-agnostic que parecem diversos mas não respondem a diferentes inputs. Mutual Information (MI) entre input e reasoning é métrica melhor que entropy para reasoning quality. SNR-Aware Filtering (reward variance as proxy) mitiga o problema.

## Argumentos principais

- **Template collapse**: reasoning parece diverse within-input mas é input-agnostic across inputs — invisível a entropy e todas métricas existentes
- **MI proxy**: mede cross-input distinguishability sem external models, correlaciona mais fortemente com performance que entropy
- **SNR mechanism**: low reward variance weakening task gradients + input-agnostic regularization erasing cross-input reasoning differences
- **SNR-Aware Filtering**: seleciona high-signal prompts por reward variance per iteration

## Key insights

- Entropy estável ≠ reasoning saudável — template collapse é failure mode silencioso
- MI > entropy como diagnostic para reasoning quality
- Low SNR lets noise dominate, erasing input dependence

## Links

- [[03-RESOURCES/concepts/agent-systems/agentic-reasoning]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-as-a-verifier]]
- [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]]