---
title: SWE-Bench Verified
type: entity
subtype: benchmark
created: 2026-04-19
updated: 2026-04-19
tags: [benchmark, software-engineering, coding-agent, evaluation]
---

# SWE-Bench Verified

The canonical benchmark for evaluating software engineering agents on real GitHub issues.

- **Tasks:** 500 instances
- **Trajectories per task (dataset):** 3
- **Leaderboard:** github.com/swe-bench/experiments

## Reference Scores (LLM-as-a-Verifier paper)

| Method | Score |
|---|---|
| mini-swe-agent + Claude-Opus-4.5 high reasoning (Pass@1) | 76.1% |
| LLM-as-a-Verifier | **77.8%** |
| Oracle Bo3 | 84.4% |

## Connections

- [[03-RESOURCES/concepts/llm-ml-foundations/llm-as-a-verifier]] — trajectory reward model
- [[03-RESOURCES/concepts/llm-ml-foundations/test-time-scaling]]
- [[03-RESOURCES/entities/Terminal-Bench-2]] — companion benchmark
- [[03-RESOURCES/entities/Claude-Opus-47]] — model family used in trajectories
