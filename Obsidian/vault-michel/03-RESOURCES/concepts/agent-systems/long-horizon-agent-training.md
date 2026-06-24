---
title: "Long-Horizon Agent Training"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, agent-systems, training, long-horizon]
status: developing
---

# Long-Horizon Agent Training

Training LLMs to complete tasks that unfold over many steps — requiring curriculum design, synthetic environments, and reward structures that bridge short demonstrations to long tasks.

## O que é / What it is

Standard SFT and RLHF optimize for single-turn or short-horizon quality. Long-horizon agent training extends these to multi-step task completion, where the model must learn to **sustain intent, recover from errors, and generalize across task lengths** it hasn't seen before.

## Como funciona

**Key challenge:** You can't simply collect 1000-step demonstrations — they're expensive, slow, and brittle. Instead, training uses:

- **Macro actions + subgoal decomposition:** Teach the model to operate at multiple levels of abstraction. A macro action ("implement authentication") decomposes into micro actions (edit file, run test, fix error).
- **Curriculum learning:** Start with short-horizon tasks; gradually extend. Model learns horizon generalization rather than memorizing specific tasks.
- **Synthetic computers (Microsoft approach):** Fully simulated computer environments where the agent can take any action. Enables cheap, parallelizable, safe long-horizon rollouts.
- **Behavior tree expansion:** Pre-define high-level behavior trees; use RL to fill in the leaves. Structure guides exploration in a vast action space.

## Padrões / Patterns

- **Horizon generalization:** Evaluate on tasks 2–10× longer than training tasks. Good training should generalize; brittle agents collapse.
- **Subgoal checkpoints as reward shaping:** Give partial credit for reaching intermediate milestones, not just final success.
- **Failure recovery data:** Intentionally include failed trajectories with recovery actions. Models need negative examples to learn robustness.

## Por que importa

As the vault goal evolves toward longer autonomous operation (hill agent running multi-day improvement cycles), understanding how agents are trained for long horizons helps set realistic expectations and identify where human oversight remains essential.

## Related
- [[03-RESOURCES/concepts/long-horizon-agents]]
- [[03-RESOURCES/concepts/agentic-reinforcement-learning]]
- [[03-RESOURCES/concepts/agent-systems/_index]]
- [[03-RESOURCES/concepts/multi-step-planning]]
