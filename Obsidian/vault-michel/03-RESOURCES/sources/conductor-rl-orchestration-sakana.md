---
title: "Learning to Orchestrate Agents in Natural Language with the Conductor"
type: source
source_file: "Clippings/Learning to Orchestrate Agents in Natural Language with the Conductor.md"
url: "https://arxiv.org/html/2512.04388v5"
authors: [Stefan Nielsen, Edoardo Cetin, Peter Schwendeman, Qi Sun, Jinglue Xu, Yujin Tang]
org: Sakana AI
created: 2026-05-14
updated: 2026-05-14
tags: [source, multi-agent, reinforcement-learning, orchestration, sakana-ai, grpo, test-time-scaling]
---

# Conductor: RL-Trained Orchestrator for LLM Pools

## Core Contribution

A 7B language model (the Conductor) is trained via reinforcement learning (GRPO) to dynamically design agentic workflows — dividing problems, delegating subtasks, and specifying communication topologies — over pools of much larger frontier LLMs. The key finding: a small model trained end-to-end with RL as a meta-orchestrator outperforms any individual worker and all prior hand-designed multi-agent baselines.

## Method

- **Base model**: Qwen2.5-7B
- **Algorithm**: GRPO — no KL regularization, 200 iterations, batch size 256
- **Output format**: three Python lists (subtasks, worker IDs, access lists) parsed from chain-of-thought
- **Worker pool**: Gemini-2.5-Pro, Claude-Sonnet-4, GPT-5, DeepSeek-R1-Distill-Qwen-32B, Gemma3-27B, Qwen3-32B
- **Training data**: 960 problems across MATH, MMLU, RLPR, LiveCodeBench-v1
- **Reward**: format correctness (0 or penalized) + workflow correctness (0.5 or 1.0)
- **Compute**: 2x NVIDIA H100 80GB

### Key Design Choices

- Conductor specifies workflows in **natural language** — no predefined topologies, full specification freedom
- Up to 5-step workflows; Conductor learns to use avg ~3 steps (self-regulating efficiency)
- Few-shot examples from **out-of-domain tasks** improve performance more than in-domain examples (OOD prevents exploitation, incentivizes strategy exploration)

### Extensions

1. **Adaptive worker selection**: finetuned with randomized k-model subsets to generalize to arbitrary agent pools (open-only, closed-only, mixed)
2. **Recursive topologies**: Conductor can assign itself as a worker, enabling iterative self-revision and a new axis of test-time scaling

## Key Results

| Benchmark | Best Individual Model | Conductor |
|-----------|----------------------|-----------|
| MATH500 | 96.0 (Claude/Gemini) | **99.4** |
| MMLU | 93.5 (GPT-5) | **94.1** |
| LiveCodeBench | 82.90 (GPT-5) | **83.93** |
| AIME25 | 90.8 (GPT-5) | **93.3** |
| GPQA-Diamond | 84.8 (Gemini) | **87.5** |
| BigCodeBench | 35.8 (Claude) | **37.8** |
| **Average** | 74.78 (GPT-5) | **77.27** |

- Conductor-Recursive improves BigCodeBench further to **40.0** and GPQA to **82.32**
- On MMLU efficiency: Conductor achieves 93.14% at avg cost $0.009/sample vs Claude 5x consensus at 91.0% for $0.0211 — **~2.3x cheaper for higher quality**
- Conductor uses ~1,820 tokens/sample vs MoA's 11,203 while beating MoA by ~10 points

### Emergent Behaviors Observed

- Task-difficulty adaptivity: allocates 2 steps for MMLU, 3-4 for LiveCodeBench
- Planner/writer role specialization (e.g., Gemini+Claude as planners, GPT-5 as final coder)
- Verification rounds emerge without being explicitly trained
- Model-scale matters for prompt engineering: 7B outperforms 3B not by agent selection but via better prompt engineering of subtasks

## Implications for Vault

- Validates [[03-RESOURCES/concepts/multi-agent-orchestration]] at SOTA scale with RL training instead of manual design
- Extends [[03-RESOURCES/concepts/agentic-rl]] to the meta-agent coordination domain
- Provides a new mechanism for [[03-RESOURCES/concepts/test-time-scaling]]: recursive calling as compute axis
- Demonstrates that "small model as orchestrator > large model self-orchestration" principle

## Connections

- [[03-RESOURCES/concepts/rl-conductor-orchestration]] — concept page for this pattern
- [[03-RESOURCES/concepts/multi-agent-orchestration]] — existing orchestration patterns
- [[03-RESOURCES/concepts/agentic-rl]] — GRPO and RL-trained agents
- [[03-RESOURCES/concepts/test-time-scaling]] — recursive topology as new axis
- [[03-RESOURCES/concepts/post-training-llm]] — GRPO training paradigm
- [[03-RESOURCES/entities/Sakana-AI]] — authoring lab
