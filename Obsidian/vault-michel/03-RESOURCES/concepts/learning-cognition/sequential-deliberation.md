---
title: "Sequential Deliberation"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, agent-systems, reasoning]
status: developing
---

# Sequential Deliberation

Thinking through a problem step-by-step before committing to an action — the slow, careful reasoning mode that improves agentic task quality.

## O que é / What it is

Sequential deliberation is the **System 2** counterpart to fast, pattern-matched responses. The agent generates a chain of reasoning steps, checking each against known constraints, before producing a final answer or taking an action. It trades speed for accuracy and auditability.

## Como funciona

**Chain-of-thought (CoT):** The model generates a scratchpad of intermediate reasoning steps as tokens before the final output. Each step conditions the next, allowing multi-hop inference that single-step responses cannot achieve.

**Sequence:**
```
Problem → Step 1 reasoning → Step 2 reasoning → ... → Conclusion → Action
```

The key property: each step is **visible and checkable**. A critic agent or human reviewer can inspect the chain and catch errors before they propagate.

## Padrões / Patterns

- **Zero-shot CoT:** Append "Let's think step by step" to prompt. Activates deliberation without examples.
- **Few-shot CoT:** Provide exemplar chains in the prompt. Steers the reasoning style.
- **Extended thinking (Claude 3.5+):** Model is given a dedicated "thinking" budget before responding. Steps are generated but may not be exposed to the user.
- **Tree of Thought:** Branch multiple reasoning paths; prune dead ends; select best. A parallel extension of sequential deliberation.

**Contrast with fast response:** Direct answers are faster and cheaper but miss multi-step dependencies. Use deliberation when the task has >2 logical dependencies or when errors are costly.

## Por que importa

The vault's Karpathy principle "Think before acting" is a governance enforcement of sequential deliberation. Agents that skip deliberation and act on first instinct produce more errors, especially on multi-step ingest or restructuring tasks.

## Related
- [[03-RESOURCES/concepts/multi-step-planning]]
- [[03-RESOURCES/concepts/parallel-reasoning]]
- [[03-RESOURCES/concepts/agentic-execution]]
- [[03-RESOURCES/concepts/agent-systems/_index]]
