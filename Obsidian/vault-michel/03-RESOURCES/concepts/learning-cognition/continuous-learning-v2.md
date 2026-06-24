---
title: Continuous Learning (Instincts & Evolution)
type: concept
status: developing
created: 2026-04-25
updated: 2026-04-25
tags: [learning, instincts, memory, patterns]
---

# Continuous Learning v2: Instincts & Evolution

Agents extract patterns from sessions and evolve them into reusable skills.

## The Cycle

1. **Session Execution** — Agent works on task, makes decisions, discovers patterns
2. **Extraction** — At session end, /learn-eval extracts patterns (Instincts)
3. **Evaluation** — Confidence score, applicability check, contradiction detection
4. **Storage** — Instincts saved to persistent memory
5. **Evolution** — /evolve clusters similar instincts into generalizable skills
6. **Consolidation** — Best practices become team SKILL.md files

## Instincts

An instinct is a learned pattern with:
- **Action** — what to do
- **Evidence** — why it works (with examples)
- **Confidence** — 0-100 score
- **Applicability** — when to use it
- **Examples** — concrete instances

## Evolution Algorithm

Cluster instincts by:
- Similarity (semantic, not syntactic)
- Frequency (how often appears)
- Generalizability (scope of applicability)

Output: SKILL.md files ready for team use

## Arquivar2 Reference
Source: `everything-claude-code.md` section on continuous-learning-v2

## Related
- [[agentic-skills]]
- [[agent-memory-architecture]]
