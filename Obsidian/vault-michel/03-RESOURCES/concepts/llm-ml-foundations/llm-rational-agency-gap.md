---
title: LLM–Rational Agency Gap
type: concept
status: developing
created: 2026-05-05
updated: 2026-05-05
tags:
  - llm
  - agents
  - rationality
  - decision-theory
  - ai-limitations
---

## Definition

The **LLM–Rational Agency Gap** is the fundamental mismatch between what a formal rational agent does (maximize expected utility for its principal) and what an LLM-based "agent" actually does (generate statistically plausible token continuations given a prompt and context).

## Formal Rational Agent

A rational agent, in decision theory, always selects the action `a*` such that:

```
a* = argmax_a Σ P(outcome | a) · U(outcome)
```

This requires:
1. **Stable preferences** (utility function `U`)
2. **Calibrated beliefs** (probability estimates `P`)
3. **Causal world model** (predicting outcomes of actions)
4. **Utility discipline** — choosing the numerically optimal action even if it seems less plausible in natural language

## What LLMs Actually Optimize

LLMs optimize:

```
P(next_token | prompt, context_window, training_distribution)
```

When wrapped in an agentic loop, the LLM produces text that *resembles* deliberation — phrases like "I will compare expected outcomes" — but the mechanism is statistical continuation, not utility calculation.

## The Imitation Ceiling

For **narrow tasks** where the environment is constrained and success criteria match training distribution patterns, LLM imitation of rationality can be good enough.

For **general-purpose problem solving**, the gap becomes fatal because:
- Actions can be non-linguistic or outside training distribution
- Consequences require causal reasoning, not pattern matching
- Failures become "strange, fragile, and irremediable" rather than predictably fixable

## Why Better Prompting Does Not Fix This

Failures from this gap are architectural, not prompt-level. Prompts operate on the LLM's token-prediction objective; they cannot install a utility function or causal world model. This is why the failures are described as *irremediable* by prompt engineering alone.

## Distinction from Agentic Reasoning

[[03-RESOURCES/concepts/agent-systems/agentic-reasoning]] covers multi-step tool use and planning capabilities. The LLM–Rational Agency Gap is a deeper claim: even when planning and tool use work correctly at the surface level, the *objective being optimized* is still next-token probability, not user utility.

> "We are asking a simulator of rational agency to be a rational agent." — [[03-RESOURCES/entities/Andriy-Burkov]]

## Sources

- [[03-RESOURCES/sources/ml-research-papers/clipping-llm-agents-rational-agency-burkov]] — primary source (Burkov, X/Twitter, 2026-04-27)
