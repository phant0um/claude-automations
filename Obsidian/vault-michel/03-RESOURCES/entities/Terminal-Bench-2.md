---
title: Terminal-Bench 2
type: entity
subtype: benchmark
created: 2026-04-19
updated: 2026-05-18
tags: [benchmark, coding-agent, evaluation, terminal]
---

# Terminal-Bench 2

An agent evaluation benchmark for terminal/shell task completion.

- **Tasks:** 89
- **Trajectories per task:** 5 (in the LLM-as-a-Verifier dataset)
- **Leaderboard:** HuggingFace (harborframework/terminal-bench-2-leaderboard)

## Reference Scores

| Method | Score |
|---|---|
| Forge + GPT-5.4 (Pass@1) | 81.8% |
| LLM-as-a-Verifier | **86.4%** |
| Oracle Bo5 | 89.9% |

## Connections

- [[03-RESOURCES/concepts/llm-ml-foundations/llm-as-a-verifier]] — used as trajectory reward model
- [[03-RESOURCES/concepts/llm-ml-foundations/test-time-scaling]]
- [[03-RESOURCES/entities/SWE-Bench-Verified]] — companion benchmark
