---
title: Sakana AI
type: entity
created: 2026-05-14
updated: 2026-05-14
tags: [entity, ai-lab, japan, research, multi-agent, rl]
---

# Sakana AI

Japanese AI research laboratory founded in 2023, focused on nature-inspired AI and emergent intelligence. Name derived from "sakana" (fish), reflecting interest in swarm and collective intelligence.

## Research Focus

- Nature-inspired AI systems
- Emergent multi-agent coordination
- AI Scientist (automated scientific discovery)
- Collective intelligence through LLM orchestration

## Vault Appearances

- **Conductor paper** (2026): RL-trained 7B orchestrator achieving SOTA on reasoning benchmarks by coordinating frontier LLM pools. See [[03-RESOURCES/sources/ml-research-papers/conductor-rl-orchestration-sakana]].

## Key Researchers (in vault context)

- **Stefan Nielsen** — proposed Conductor as LLM reasoning over collaboration topologies; implemented and tuned
- **Edoardo Cetin** — co-proposed Conductor; core algorithm and training paradigm
- **Peter Schwendeman** (University of Michigan intern) — prompting and training improvements, baseline suite
- **Qi Sun** — out-of-domain evaluation
- **Jinglue Xu** — training dataset design and curation
- **Yujin Tang** — initiated and led the project; first experiments

## Key Results from Vault

- 7B Conductor surpasses GPT-5, Gemini 2.5 Pro, Claude Sonnet 4 on aggregate across 7 benchmarks (avg 77.27 vs GPT-5's 74.78)
- SOTA on LiveCodeBench at time of writing, surpassing all O-series models

## Related

- [[03-RESOURCES/concepts/agent-systems/rl-conductor-orchestration]] — core concept from Sakana's Conductor paper
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/agentic-rl]]
