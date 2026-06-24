---
title: RL Conductor Orchestration
type: concept
status: developing
created: 2026-05-14
updated: 2026-05-14
tags: [concept, multi-agent, reinforcement-learning, orchestration, meta-agent, test-time-scaling, grpo]
---

# RL Conductor Orchestration

A training paradigm where a small language model is trained via reinforcement learning to act as a meta-orchestrator over a pool of larger, more capable LLMs. Rather than manual prompt engineering or fixed topologies, the Conductor learns to discover optimal coordination strategies end-to-end.

**Core claim**: small model as RL-trained orchestrator > large model self-orchestration via prompting.

## Key Innovation vs Prior Multi-Agent Approaches

| Approach | Topology | Subtask Spec | Training |
|----------|----------|--------------|---------|
| MoA, MASRouter, RouterDC | Fixed / human-designed | Predefined | Supervised routing |
| RL Conductor | Fully flexible, per-problem | Natural language, emergent | End-to-end RL reward |

The Conductor has **complete specification freedom**: it outputs natural language subtasks, worker assignments, and access lists — any topology expressible in language is learnable.

## Architecture (Conductor Paper, Sakana AI 2026)

- **Conductor**: Qwen2.5-7B trained with GRPO on 960 problems (MATH, MMLU, RLPR, LiveCodeBench)
- **Output**: three Python lists — `subtasks`, `model_ids`, `access_list` — parsed from chain-of-thought
- **Workflow**: up to 5 steps; workers execute sequentially with specified context visibility
- **Reward**: format correctness + workflow outcome correctness
- **No KL regularization needed**: powerful workers provide exploration signal naturally

## Emergent Behaviors

Training with this recipe produces spontaneous emergence of:
- Problem decomposition into planner/writer/verifier roles
- Targeted prompt engineering per worker's specialization
- Difficulty-adaptive step count (2 steps for MMLU, 3-4 for LiveCodeBench)
- Debate and verification rounds in final steps
- Model-specific routing (e.g., Gemini for planning, GPT-5 for final code)

## Recursive Topologies

By finetuning the Conductor to assign itself as a worker, it can instantiate recursive workflows:
- Parent Conductor → child Conductor call → revises strategy based on initial output
- Enables **dynamic test-time scaling**: increasing recursion depth = more compute = better performance
- Distinct from chain-of-thought scaling: operates at the workflow level, not token level

## OOD Few-Shot Insight

Counter-intuitively, providing few-shot examples from **out-of-domain tasks** improves performance more than in-domain examples. The OOD examples prevent strategy exploitation and incentivize genuine exploration of the coordination space.

## Scale and Efficiency

- 7B Conductor outperforms all individual workers (Gemini 2.5 Pro, GPT-5, Claude Sonnet 4, etc.)
- ~3 avg steps per workflow (self-regulating efficiency, below 5-step limit)
- 1,820 tokens/sample vs MoA's 11,203 — ~6x more efficient while outperforming by ~10 points
- Cost-adjusted performance: Conductor = 103.49 vs GPT-5 consensus = 66.34

## Relation to Vault Concepts

- Extends [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — replaces hand-designed patterns with learned ones
- Instantiates [[03-RESOURCES/concepts/agent-systems/agentic-rl]] at the meta-coordination level
- Provides new axis for [[03-RESOURCES/concepts/llm-ml-foundations/test-time-scaling]] via recursive topology
- Complements [[03-RESOURCES/concepts/agent-systems/internalized-multi-agent-debate]] — external vs internalized coordination

## Source

- [[03-RESOURCES/sources/ml-research-papers/conductor-rl-orchestration-sakana]] — full paper summary
- [[03-RESOURCES/entities/Sakana-AI]] — authoring lab

## Evidências
- **[2026-06-22]** Sakana Fugu/Fugu-Ultra (2026) é a versão produtizada do Conductor — 2 variantes (Fugu: lightweight selection head, 1 worker/step, baixa latência; Fugu-Ultra: workflow agêntico completo via Conductor), treino SFT+evolutionary (Fugu) e GRPO (Fugu-Ultra), bate todos workers da própria pool em SWE Bench Pro/Terminal Bench — [[03-RESOURCES/sources/decoding-sakana-fugu-technical-report]]
