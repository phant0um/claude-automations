---
title: Test-Time Scaling
type: concept
status: developing
created: 2026-04-19
updated: 2026-04-19
tags: [inference-scaling, test-time-compute, reward-model, best-of-n, trajectory-selection]
---

# Test-Time Scaling

The practice of spending more compute at **inference time** (rather than training time) to improve output quality. Instead of a single generation, the model produces N candidate outputs and a selection mechanism picks the best one.

## Core Mechanisms

- **Best-of-N (BoN):** generate N outputs, pick the one with the highest reward score
- **Majority vote:** generate N outputs, pick the most common answer
- **Beam search / MCTS:** structured tree search during generation

## The Verifier Bottleneck

Best-of-N quality is bounded by the reward model. A coarse verifier (binary pass/fail) has low discriminative power when N is large. This motivates more expressive reward signals like [[03-RESOURCES/concepts/llm-ml-foundations/llm-as-a-verifier]].

## Empirical Ceiling

On [[03-RESOURCES/entities/SWE-Bench-Verified]]:
- Pass@1: 76.1%
- LLM-as-a-Verifier (N=3): 77.8%
- Oracle Bo3: 84.4%

The gap between verifier and oracle represents the headroom still available if the reward model were perfect.

## Recursive Topology Scaling (Conductor)

[[03-RESOURCES/concepts/agent-systems/rl-conductor-orchestration]] (Sakana AI, 2026) introduces a new TTS axis: a 7B Conductor can assign itself as a worker, creating recursive agentic workflows. Increasing the max recursion depth at inference = more compute = better performance. Unlike open-ended chain-of-thought scaling, this operates at the workflow level — each recursion call can revise the entire coordination strategy. BigCodeBench: Conductor 37.8 → Conductor-Recursive 40.0 with <2x call overhead.

## Connections

- [[03-RESOURCES/concepts/llm-ml-foundations/llm-as-a-verifier]] — probabilistic reward model enabling better TTS
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — TTS is a natural fit for agent pipelines (run sub-agents in parallel, select best)
- [[03-RESOURCES/entities/SWE-Bench-Verified]] · [[03-RESOURCES/entities/Terminal-Bench-2]]
