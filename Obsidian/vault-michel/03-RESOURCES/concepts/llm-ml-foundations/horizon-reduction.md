---
title: Horizon Reduction
type: concept
status: developing
created: 2026-05-09
updated: 2026-05-09
tags: [concept, long-horizon, rl, agent-training, macro-actions, subgoal-decomposition, horizon-reduction]
---

# Horizon Reduction

A training design principle: structurally reduce the **effective horizon** $h_\pi(s_0, g)$ required to solve a task, rather than engineering more complex RL algorithms to handle long horizons. Identified by Kim et al. (2026) as the primary solution to [[03-RESOURCES/concepts/llm-ml-foundations/horizon-length]] instability in LLM agent training.

> "The best way to escape from a problem is to solve it." — Kim et al. (2026)

## Two Mechanisms

### 1. Macro Actions
Allow the agent to emit multiple atomic actions in a single step. Formally, a macro policy $\pi'$ achieves smaller effective horizon $h_{\pi'}$ than an atomic policy $\pi$ with the same base capability.

Examples:
- Sudoku: fill multiple cells per turn instead of one
- Rush Hour: `move(car, direction, N)` moves N cells instead of 1
- Code agents: write executable programs (loops/conditionals) — collapses tool call sequences into compact executions
- GUI agents: augment low-level clicks with high-level API calls

**Design note:** flexible macro length (dynamic $n \leq k$) outperforms fixed-length macros ($n = k$) because rigidity causes overshooting. Policy-controlled granularity is essential.

### 2. Subgoal Decomposition
Decompose global goal $g$ into verifiable sub-goals $(g_1, g_2, \ldots, g_k)$. Compute return $G_t$ independently per segment rather than end-to-end. Equivalent to **process reward models** with dense intermediate feedback.

$$d(s_0, g) = \sum_{i=1}^{k} d(s_0^{(i-1)}, g_i)$$

Each segment is a short-horizon task → credit assignment becomes tractable.

## Why It Works

1. **Reduces decision count:** fewer opportunities for errors to accumulate.
2. **Localizes credit assignment:** rewards are attributed over shorter windows.
3. **Enables exploration:** fewer steps to reach goal → higher probability of discovering successful trajectories.

The benefit of macro actions is not "stronger policy" (using a macro policy with forced atomic execution still collapses) — it is strictly the reduction in effective horizon.

## Horizon Generalization

A downstream benefit of horizon reduction: models trained on shorter horizons generalize to **unseen longer horizons** at inference time. Mechanism: higher per-step accuracy from stable training compounds multiplicatively, maintaining performance even when the rollout is longer than anything seen in training. See [[03-RESOURCES/concepts/llm-ml-foundations/horizon-length]] §Empirical Evidence.

## Curriculum Implication

Short-horizon competence is a prerequisite for long-horizon capability. Training directly on long horizons without a curriculum yields near-zero improvement. Train short → fine-tune long.

## Connections to Existing Practices

| System/Method | Implicit Horizon Reduction Mechanism |
|---------------|--------------------------------------|
| Code-writing agents | Programs collapse tool call sequences |
| Hierarchical RL | High-level policy produces subgoal sequence |
| Process reward models | Reward per verified subgoal |
| SWE-bench agents | Function-level edits vs. character-level diffs |

## Vault Connections

- [[03-RESOURCES/concepts/llm-ml-foundations/horizon-length]] — the problem being solved
- [[03-RESOURCES/concepts/llm-ml-foundations/credit-assignment]] — mechanism horizon reduction fixes
- [[03-RESOURCES/concepts/agent-systems/agentic-rl]] — RL context where horizon reduction applies
- [[03-RESOURCES/concepts/llm-ml-foundations/post-training-llm]] — SFT → RL pipeline
- [[03-RESOURCES/sources/ml-research-papers/training-llms-long-horizon-tasks-empirical-study]] — source paper
