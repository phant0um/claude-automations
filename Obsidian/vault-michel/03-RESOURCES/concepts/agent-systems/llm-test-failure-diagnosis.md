---
title: "LLM Test Failure Diagnosis"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, agent-systems]
status: developing
---

# LLM Test Failure Diagnosis

Using LLMs to automatically analyze test failures, categorize error types, and suggest fixes — closing the loop in agentic dev pipelines.

## O que é / What it is

In agentic software development, tests run as part of the agent loop. When tests fail, instead of surfacing raw stack traces to the model, a diagnosis agent classifies the failure, extracts the relevant context, and produces a structured fix suggestion. This reduces the number of tokens the main agent needs to consume to understand what went wrong.

## Como funciona

**Diagnosis pipeline (Bertolini pattern):**
```
Test runner → raw output (stdout/stderr)
Diagnosis agent reads output → classifies failure type
Structured diagnosis → main agent receives: {type, location, suggested_fix}
Main agent applies fix → re-runs tests
```

**Failure taxonomy:**
| Type | Signal | Likely cause |
|------|--------|-------------|
| Assertion error | Expected vs. actual diff | Logic bug |
| Import/compile error | Syntax/type error | Bad edit |
| Timeout | Test hangs | Infinite loop, deadlock |
| Permission error | File/network access denied | Harness misconfiguration |
| Hallucinated API | `AttributeError` on non-existent method | Model invented an interface |

**Pre-commit quality gate:** Running diagnosis before committing catches hallucinated APIs and broken imports — the two most common LLM coding failure modes.

## Por que importa

Raw test output is noisy. A 2000-line stack trace contains ~50 tokens of actual signal. Diagnosis agents compress the signal, reduce context bloat, and let the main agent focus on the fix rather than parsing output.

## Related
- [[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]]
- [[03-RESOURCES/concepts/agent-systems/dynamic-workflows]]
- [[03-RESOURCES/concepts/agent-systems/agentic-engineering-levels]]
- [[03-RESOURCES/concepts/agent-systems/_index]]
