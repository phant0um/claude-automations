---
title: Behavior Tree Expansion
type: concept
status: developing
created: 2026-05-05
updated: 2026-05-05
tags: [concept, ai-agents, agentic-rl, synthetic-data, behavior-trees, tool-use, training]
---

# Behavior Tree Expansion

Mechanism within the [[03-RESOURCES/concepts/ai-strategy-org/dual-data-flywheel|agentic data flywheel]] (AgenticQwen, Alibaba 2026) that automatically transforms linear workflow training data into multi-branch decision trees, progressively increasing the complexity of agentic RL training.

## The Problem with Linear Workflows

Initial agentic training data (e.g., from SynthAgent) follows deterministic single-path execution:

```
A(Query) → B(Book) → C(Confirm)
```

This teaches tool semantics and basic invocation, but:
- No conditional reasoning required
- No exposure to ambiguous or adversarial environments
- Model learns one "happy path" per task → brittle in production

## Four-Phase Process

### Phase 1: Linear Task Initialization

Start with single-path open-source tasks. Each task has:
- **Environment state** (input to mock tool)
- **User instruction** (input to mock user)
- **Agent instruction / SOP** (input to agent)

SOP starts empty.

### Phase 2: Behavior Tree Expansion

After each RL round, a strong LLM (Qwen3-235B) analyzes the agent's successful trajectories and injects conditional branches triggered by distinct environment states:

```
A(Query) → B(Book) → C(Confirm)          [Available]
         → B(Search HSR) → ...            [Sold out]
         → ... → ...                       [...]
```

Each branch represents a distinct decision the agent must make based on environment state. The SOP expands alongside the tree.

### Phase 3: Branch-to-Task Inversion

Each branch of the behavior tree is inverted into a standalone training task:
1. Infer the environment condition that triggers the branch (e.g., "all flights sold out")
2. Construct a new environment state grounded in that condition
3. Generate a new user instruction consistent with that state (e.g., "I must arrive in Beijing tonight")
4. Update the SOP to include the new decision pattern

Result: every branch becomes a required (not optional) execution path in a distinct training example.

### Phase 4: Adversarial Mock-User Intervention

A mock user selects a "trap path" — an incorrect branch — and is instructed to push the agent toward it:

```
B(Delayed) → C(Gold) → D(Cash)      [Gold member → cash]
           → C(Standard) → D(Voucher) [Standard → voucher]

Trap: user claims "I should get cash" but is actually Standard member.
Agent must verify via tool query → take correct branch.
```

This teaches robustness against misleading user instructions and precise state-dependent reasoning.

## Iterative Evolution

```
Round k tasks → RL training → updated policy
             → rollout → behavior trees
             → branch-to-task inversion → harder Round k+1 tasks
```

Each iteration exposes new decision patterns; the SOP grows in depth. Emergent agentic behaviors can arise from this closed-loop curriculum.

## Validation

Before adding any task to training:
- Strong model must successfully solve it in the simulated environment
- Execution trace must follow the intended branch
This prevents noise and ensures bounded difficulty (not trivially hard or impossibly hard).

## Connection to Classical Behavior Trees

Classical behavior trees (game AI, robotics) are hierarchical structures of conditions and actions. This approach adapts the concept to **training data generation** rather than policy representation — the tree is a scaffold for creating diverse task instances, not the agent's planning structure itself.

## Related

- [[03-RESOURCES/concepts/ai-strategy-org/dual-data-flywheel]] — the broader flywheel framework this is part of
- [[03-RESOURCES/concepts/agent-systems/agentic-rl]] — the RL objective these tasks feed
- [[03-RESOURCES/sources/ml-research-papers/clipping-agenticqwen-small-agentic-llm-dual-flywheels]] — origin paper
- [[03-RESOURCES/entities/AgenticQwen]] — trained with this mechanism
