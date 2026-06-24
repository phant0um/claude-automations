---
title: Credit Assignment
type: concept
status: developing
created: 2026-05-09
updated: 2026-05-09
tags: [concept, rl, credit-assignment, long-horizon, gradient-dynamics, reinforce]
---

# Credit Assignment

The problem of attributing reward (or blame) to specific actions in a sequence when feedback is delayed or sparse. In RL for LLM agents, credit assignment becomes increasingly pathological as [[03-RESOURCES/concepts/llm-ml-foundations/horizon-length]] grows.

## The Core Problem

In a sparse-reward setting (single reward at episode end), a failed trajectory assigns **negative advantage** to every action in the sequence — including steps that were individually correct. Under REINFORCE, the gradient for a token $y_i$ with advantage $A_i$ is:

$$\nabla_{z_v} \mathcal{J} = \begin{cases} (1 - \pi_\theta(y_i)) \cdot A_i, & v = y_i \\ -\pi_\theta(v) \cdot A_i, & v \neq y_i \end{cases}$$

**When $A_i < 0$ (negative advantage):** the gradient *increases* logits of all non-sampled tokens to compensate. The vocabulary is ~10^5 tokens; only a handful are semantically relevant for any context. Negative updates therefore spread probability mass across ~99,999 irrelevant tokens — injecting noise across the entire policy.

## Why It Worsens with Horizon

Over long trajectories:
- More steps are exposed to potentially incorrect negative advantage
- Gradient variance compounds multiplicatively across steps
- Each negative-advantage update corrupts future step distributions

This is distinct from exploration difficulty (though they co-occur). A model that can solve a task in isolation still collapses when trained end-to-end at long horizons.

## Mitigations

| Approach | Mechanism |
|----------|-----------|
| [[03-RESOURCES/concepts/llm-ml-foundations/horizon-reduction]] via subgoal decomposition | Compute $G_t$ per segment; localizes negative signals |
| Process reward models | Dense intermediate rewards reduce negative-advantage windows |
| Step-level reward component | Separate format/validity penalty from trajectory reward (α=0.2 weighting in Kim et al.) |
| GiGPO (hierarchical grouping) | Step-level advantage via trajectory + state grouping |
| Value baseline (PPO) | Reduce variance of advantage estimates; degrades at long horizons |

## Asymmetry of Positive vs. Negative Advantage

Positive advantage ($A_i > 0$): concentrates probability on the sampled token — focused, low-noise update.
Negative advantage ($A_i < 0$): diffuses probability across all other tokens — unfocused, high-noise update.

This asymmetry means negative reward signals are structurally more harmful than positive ones are beneficial, especially in large-vocabulary language models.

## Vault Connections

- [[03-RESOURCES/concepts/llm-ml-foundations/horizon-length]] — why credit assignment degrades at scale
- [[03-RESOURCES/concepts/llm-ml-foundations/horizon-reduction]] — structural fix
- [[03-RESOURCES/concepts/agent-systems/agentic-rl]] — RL context
- [[03-RESOURCES/concepts/llm-ml-foundations/post-training-llm]] — GRPO/REINFORCE as optimizer context
- [[03-RESOURCES/sources/ml-research-papers/training-llms-long-horizon-tasks-empirical-study]] — detailed gradient derivation (Appendix D.1)
