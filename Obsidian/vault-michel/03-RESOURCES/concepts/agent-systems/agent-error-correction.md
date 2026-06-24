---
title: Agent Error Correction & Self-Fixing
type: concept
status: developing
created: 2026-04-25
updated: 2026-04-25
tags: [agents, memory, error-correction, automation]
related: [[multi-agent-orchestration]], [[agent-memory-architecture]]
---

# Agent Error Correction & Self-Fixing

**Problem:** Agents make mistakes repetitively without learning from them.

**Solution:** Explicit error detection, root-cause analysis, and automated correction loops.

## Core Principles

### 1. Detection Phase
- Agents must recognize when outputs fail (parsing errors, validation failures)
- Implement checkpoints that verify results before moving forward
- Log all failures with context (input, output, expected)

### 2. Analysis Phase
- Root-cause analysis: Is it a data problem? Logic problem? Model limitation?
- Categorize errors: transient (retry) vs systemic (redesign)
- Extract the "why" not just the "what failed"

### 3. Correction Phase
- Transient errors: Exponential backoff, context reformulation
- Systemic errors: Change approach, delegate to different agent, restructure prompt
- Prevent infinite loops: Max retries, escalation thresholds

## Implementation Patterns

### Verification Loops
```
Agent Output → Validate → [Pass] → Return
                    ↓
                  [Fail] → Root Cause → Fix Approach → Retry
```

### Memory-Backed Corrections
- Store failed patterns in persistent memory (Instincts, Hot Cache)
- Before attempting task, check: "Have I failed here before?"
- If yes, apply previous solution or escalate

### Checkpoints
- Save state before risky operations
- Roll back on failure vs forward-fix decision
- Maintain audit trail of corrections

## Arquivar2 Reference
- Source: `how-to-really-stop-your-agents-from-making-the-same-mistakes.md`
- Key insight: "The difference between production agents and toys is error handling"
- Pattern: Systematic logging + pattern extraction into agent memory

## Related Concepts
- [[agent-memory-architecture]] — storing learned corrections
- [[multi-agent-orchestration]] — escalation & delegation on error
- [[verification-loops]] — checkpoint-based quality gates

## Evidências
- **[2026-06-19]** Protocolo "classify before fix": nomear tipo de erro (assertion/type/timeout/import/flaky) e causa raiz em uma frase antes de editar; se não consegue nomear a causa, está adivinhando — pare — [[how-to-build-a-claude-code-agent-that-fixes-its-own-bugs-in-a-loop]]
