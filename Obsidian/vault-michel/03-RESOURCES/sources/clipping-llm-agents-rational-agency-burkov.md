---
title: "LLM Agents Are Not Rational Agents (Burkov, X/Twitter)"
type: source
source_type: social-media
platform: X/Twitter
url: "https://x.com/burkov/status/2048942593480794260"
author: "[[03-RESOURCES/entities/Andriy-Burkov]]"
published: 2026-04-27
created: 2026-05-05
tags:
  - llm
  - agents
  - rationality
  - expected-utility
  - ai-limitations
---

## Summary

Andriy Burkov (PhD in agent systems) argues that LLM-based agents are fundamentally not rational agents in the decision-theoretic sense. A rational agent maximizes expected utility for its user; an LLM optimizes next-token prediction conditioned on prompt, context window, and training distribution. These are not the same objective.

Wrapping an LLM in a loop does not produce a rational decision-maker — it produces a text generator that mimics the surface form of deliberation. The LLM may output phrases like "I will compare expected outcomes" but its internal mechanism is statistical continuation, not utility maximization.

## Core Argument

- **Rational agent** (formal def.): always selects the action with maximum expected utility — even if a worse-sounding action has better numerical consequences.
- **LLM "agent"**: generates text statistically appropriate to the prompt + context. This can simulate rationality for narrow tasks where training distribution closely matches the environment.
- **The gap becomes fatal** for general-purpose problem solving: stable preferences, calibrated beliefs, causal world models, and utility computation are absent by default.

## Key Distinction

| Rational Agent | LLM-Based Agent |
|---|---|
| Maximizes expected utility | Optimizes next-token probability |
| Selects action via utility calculus | Generates plausible continuation |
| Fails predictably (bad model) | Fails strangely, fragilely, irreparably |
| Has causal world model | Has pattern compression |

## Why Failures Are "Irremediable"

For narrow tasks, imitation suffices. For open-ended responsibility, the mismatch produces failures that are not fixable by better prompting — they stem from the architectural gap between token prediction and utility maximization.

> "We are asking a simulator of rational agency to be a rational agent."

## Related Pages

- [[03-RESOURCES/concepts/llm-rational-agency-gap]] — core concept extracted from this source
- [[03-RESOURCES/concepts/expected-utility-maximization]] — decision-theoretic framework
- [[03-RESOURCES/concepts/agentic-reasoning]] — related (tool-use focus, not utility theory)
- [[03-RESOURCES/entities/Andriy-Burkov]] — author
