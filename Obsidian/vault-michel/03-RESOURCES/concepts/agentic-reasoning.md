---
title: Agentic Reasoning
type: concept
created: 2026-05-01
updated: 2026-05-01
tags:
  - ai
  - agents
  - llm
  - tool-use
---

## Definition

Agentic reasoning is the capability of an LLM to **plan and execute multi-step tasks using external tools** without human intervention between steps. The model must:

1. **Understand task decomposition** — break a goal into steps
2. **Select appropriate tools** — decide which actions to invoke
3. **Interpret tool outputs** — update internal state based on feedback
4. **Continue planning** — adjust strategy based on results

## Core Skills

- **Tool-use:** Invoking APIs, commands, file operations
- **Error handling:** Recovering from failed tool calls
- **Long-horizon reasoning:** Maintaining goal state across 5-20+ steps
- **Verification:** Checking intermediate results match expectations
- **Backtracking:** Undoing failed paths and trying alternatives

## Agentic Training

Models optimized for agentic reasoning require:

1. **Diverse RL environments** — training on varied task types (terminal, web, APIs, file systems)
2. **Multi-step trajectories** — SFT data with explicit planning → execution → verification
3. **Tool-specific corpora** — code, terminal output, API documentation
4. **Failure modes** — safe error recovery without user intervention

**Example:** Nemotron 3 Super trained on OpenHands (software engineering), terminal commands, and general tool-use benchmarks.

## Metrics

- **Success rate** on benchmark tasks (e.g., SWE-Bench, OpenHands)
- **Steps-to-completion** (lower = more efficient planning)
- **Error recovery rate** (what % of failures lead to recovery vs giving up)
- **Tool invocation accuracy** (correct API calls vs hallucinated calls)

## Related Concepts

[[03-RESOURCES/concepts/multi-agent-orchestration]] · [[03-RESOURCES/concepts/tool-use-behavior-opus47]] · [[03-RESOURCES/concepts/multi-step-planning]]

---

**Sources:** [[03-RESOURCES/sources/nemotron-3-super-hybrid-mamba-attention-moe]]
