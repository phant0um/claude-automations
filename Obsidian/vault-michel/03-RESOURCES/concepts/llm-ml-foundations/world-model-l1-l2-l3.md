---
title: World Model Capability Hierarchy (L1/L2/L3)
type: concept
status: developing
category: ai-agents
created: 2026-05-05
updated: 2026-05-05
tags:
  - world-models
  - taxonomy
  - l1-predictor
  - l2-simulator
  - l3-evolver
  - agentic-ai
---

# World Model Capability Hierarchy (L1/L2/L3)

A three-level taxonomy proposed in the Agentic World Modeling survey (arXiv 2604.22748v1) to classify what a world model is capable of, regardless of modality or domain.

> Source: [[03-RESOURCES/sources/ml-research-papers/agentic-world-modeling-survey-2026]]

---

## L1 — Predictor

**What it does:** Learns one-step local transition operators.

Given current state + action → predicts next state. No multi-step planning.

**Philosophical grounding:** Hume's *constant conjunction* — extracts statistical co-occurrences without certifying why they hold. Equivalent to the Uniformity Principle (the future resembles the past).

**Formal object:** `p_θ(z_t | z_{t-1}, a_t)` — forward dynamics, one-step latent transition.

**Failure mode:** Distribution shift. i.i.d. assumption breaks when environment changes.

**Runtime use:** Fast reactive decisions — perception, low-level motor control, token-by-token generation.

**Examples:** Any trained latent dynamics model; early DreamerV1; basic video frame predictors.

---

## L2 — Simulator

**What it does:** Composes L1 operators into multi-step, action-conditioned rollouts that respect domain laws.

Enables counterfactual reasoning — "what would happen if I took action A instead of B?"

**Philosophical grounding:** David Lewis's theory of *closest possible worlds* — effective counterfactual reasoning explores worlds maximally similar to ours where only a minimal intervention differs.

**Three boundary conditions (all required for L2):**
1. **Long-horizon coherence** — trajectory remains consistent over H steps
2. **Intervention sensitivity** — different actions produce distinguishably different rollouts
3. **Constraint consistency** — rollouts satisfy governing-law constraints (e.g., physics, program semantics)

**Formal object:** `p̂(τ | z_0, a_{1:H}, c)` — trajectory distribution conditioned on anchor, actions, and constraints.

**Risk:** Epistemic drift — Plato's Cave analogy: a simulator mastering shadows on a wall cannot access the fire casting them. Internally coherent but wrong for out-of-training-distribution regions.

**Runtime use:** Comparing candidate action sequences, counterfactual reasoning, verifying planned trajectory satisfies constraints.

**Examples:** DreamerV3, MuZero, TD-MPC2, EfficientZero, DIAMOND, Genie, iVideoGPT; CWM (digital); Sotopia (social); GraphCast, NeuralGCM (scientific).

---

## L3 — Evolver

**What it does:** Autonomously revises its own model when predictions fail against new evidence.

Closes the full **design–execute–observe–reflect loop**: the system not only simulates but actively designs experiments, executes them, observes outcomes, and reflects to revise its model stack.

**Philosophical grounding:** Lakatos's distinction between:
- *Hard core* (architecture, inductive biases) — rarely changed
- *Protective belt* (learned parameters) — adjusted by gradient steps
- L3 revision can target the hard core when structured errors persist

Also Duhem–Quine holism: errors redistribute across modules until diagnostics isolate the brittle component.

**Formal objects:**
- `M_t` — world-modeling stack at revision step t
- `d_t` — deployment evidence (trajectories, errors, tests)
- `H` — hypothesis space for model revision

**L3 is NOT a replacement for L1/L2**: it is a **governance layer** that improves the stack when evidence demands it.

**Runtime use:** When current model produces systematic prediction failures that cannot be resolved by re-planning — model structure itself must be revised.

**Current strongest examples:**
- **Scientific:** CAMEO, A-Lab (closed-loop autonomous experimentation)
- **Digital (partial):** FunSearch (cap-set problem, bin-packing), AlphaEvolve (Strassen matrix multiply, 20% open math problems)
- **Computational science:** AI Scientist-v2 (produced peer-reviewed ICLR workshop paper autonomously)

---

## Runtime Dispatch View

A single deployed system can operate at all three levels:

```
Task arrives
  ├─ Simple/reactive → L1 (fast one-step prediction)
  ├─ Action comparison needed → L2 (multi-step rollout)
  └─ Systematic prediction failure → L3 (model revision)
```

L3 is not triggered by re-planning failure but by **model structure failure** — when no plan within the existing model resolves the error.

---

## Relationship to Other Taxonomies

| Other taxonomy | Comparison |
|----------------|-----------|
| G1–G4 (visual world models, 2D) | Complementary; G-levels focus on visual generation; L-levels are modality-agnostic and ask about rollout validity and revision |
| RL: model-free vs. model-based | L2+ = model-based RL domain; L3 adds self-revision |
| Agent: planning vs. acting | World model is the *predictive substrate* for planning |

---

## Open Problems per Level

| Level | Key open problem |
|-------|-----------------|
| L1 | Causal representation learning (vs. spurious correlations) |
| L2 | Law-consistent rollout; compositional generalization across regimes |
| L3 | Safe autonomous experiment design; stability/plasticity/auditability trilemma |

---

## See Also

- [[03-RESOURCES/concepts/agent-systems/agentic-world-modeling]] — full taxonomy overview
- [[03-RESOURCES/concepts/governing-law-regimes]] — four-regime framework (second axis)
- [[03-RESOURCES/concepts/model-based-reinforcement-learning]] — L1/L2 in physical world
- [[03-RESOURCES/concepts/meta-world-modeling]] — L4 / beyond L3
- [[03-RESOURCES/entities/AlphaEvolve]] — partial L3, digital/scientific
