---
title: "Observability-Driven Evolution"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, dev-foundations, agent-systems]
status: developing
---

# Observability-Driven Evolution

Using runtime metrics, logs, and error patterns to drive continuous improvement of agent behavior — without retraining or manual intervention.

## O que é / What it is

Observability-driven evolution closes the feedback loop between **what agents do** and **how agents are configured**. Instead of waiting for a model update, the system improves by learning from its own operational history: error logs, success rates, latency patterns, retry frequencies.

## Como funciona

**Feedback loop:**
```
Agent runs → Emits logs/errors/metrics →
Observer analyzes patterns → Identifies improvement opportunities →
Updates config, prompts, skills, or rules →
Agent runs with improvements → Observe again
```

No retraining required — improvement happens via prompt engineering, rule changes, skill updates, or workflow restructuring.

**Key observability artifacts:**
- **Error logs:** Frequency and pattern of failures by task type
- **Retry counts:** High retries indicate fragile tool integrations or ambiguous instructions
- **Success rate by agent:** Which agents are reliable; which need refinement
- **Latency / token cost:** Signals inefficient prompts or unnecessary tool calls

## Padrões / Patterns

- **Errors.md as evolution signal:** Michel's vault logs errors with root causes. Recurring patterns trigger skill or CLAUDE.md updates. This is observability-driven evolution in practice.
- **Hill agent pattern:** A dedicated agent reviews operational metrics and proposes improvements to the vault system. See `04-SYSTEM/agents/core/hill.md`.
- **Drift detection:** Review agent (`review`) periodically checks for behavioral drift from intended patterns — another observability loop.
- **A/B at prompt level:** Try two prompt variants on similar tasks; compare error rates to select the better one.

## Por que importa

The vault's self-improvement goal is only achievable through observability. Without structured error logging and periodic review, improvements are ad-hoc and regressions go undetected. The errors.md + hill + review triad is this vault's observability stack.

## Related
- [[03-RESOURCES/concepts/action-memory]]
- [[03-RESOURCES/concepts/verification-driven-development]]
- [[03-RESOURCES/concepts/agent-systems/_index]]
- [[03-RESOURCES/concepts/dev-foundations/_index]]
- [[03-RESOURCES/concepts/long-horizon-agents]]
