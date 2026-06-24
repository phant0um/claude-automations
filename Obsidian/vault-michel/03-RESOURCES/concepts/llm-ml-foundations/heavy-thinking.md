---
title: Heavy Thinking
type: concept
status: developing
created: 2026-05-14
updated: 2026-05-14
tags: [heavy-thinking, parallel-reasoning, sequential-deliberation, test-time-scaling, rlvr, agentic-harness, skills]
---

# Heavy Thinking

## Definition

Heavy thinking is a **test-time scaling (TTS) strategy** that abstracts the agentic harness pattern into two internal stages:

1. **Parallel Reasoning** — spawn K independent reasoning agents, each solving the same problem from scratch without access to other agents' outputs
2. **Sequential Deliberation** — a second LLM reads a serialized memory cache of all K trajectories and synthesizes a final answer

This is isomorphic to a multi-agent orchestrator loop, but framed as an **inner skill** — a capability inherent to sufficiently capable LLMs, not an artifact of external orchestration infrastructure.

## Performance Hierarchy

```
Heavy-Pass@k ≥ Heavy-Mean@K ≥ Vote@K ≥ Mean@k
```

Sequential deliberation consistently outperforms majority voting (Vote@K), especially on hard benchmarks where the ceiling effect doesn't apply.

## Key Findings (HeavySkill paper, 2026)

- HM@4 consistently outperforms M@K across all models and benchmarks
- Sequential deliberation can **synthesize correct answers not present in any single trajectory** (HP@k > P@k in ~50% of frontier model trials)
- For deliberation: general instruction-following ability matters more than peak reasoning power — the model needs synthesis capability, not the strongest reasoner
- Best trajectory selection strategy: **Max-Answer-Num** (consensus-based) outperforms random, diversity, and length-based selection
- Iterative deliberation shows diminishing returns — later rounds suffer context interference from earlier stages
- RLVR can optimize both breadth (parallel) and depth (deliberation) simultaneously

## HeavySkill: Packaging as a Portable Skill

The two-stage pipeline can be distilled into a single SKILL.md file with four components:
- **Activation conditions** — triggers on complex reasoning; dormant for factual queries
- **Parallel reasoning protocol** — spawn K subagents in parallel, encourage strategy diversity
- **Deliberation prompt** — classify query, critically evaluate each trajectory, re-derive if all thinkers wrong, maintain format consistency
- **Output constraints** — answer only (no meta-analysis), domain-appropriate format

**Portability:** Tested under both Claude Code and custom harnesses without modification.

## Relationship to Other Patterns

| Pattern | Relationship |
|---|---|
| [[03-RESOURCES/concepts/agent-systems/internalized-multi-agent-debate]] | IMAD internalizes debate via post-training; Heavy Thinking does it at inference time with explicit subagent spawning |
| [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] | Heavy thinking IS multi-agent orchestration abstracted as a single skill |
| [[03-RESOURCES/concepts/llm-ml-foundations/generator-verifier-loop]] | Deliberation stage acts as an implicit verifier over parallel generator outputs |
| [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] | Serialized memory cache is the bridge between parallel and deliberation stages |

## Distinction from Best-of-N

Best-of-N (BoN) / majority voting selects among answers statistically. Sequential deliberation **reasons about the trajectories** — it can identify why each trajectory succeeded or failed and synthesize a new answer that corrects all of them.

## Sources

- [[03-RESOURCES/sources/ai-agents-harness/heavyskill-heavy-thinking-agentic-harness]] — primary source (arXiv 2605.02396)
