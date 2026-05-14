---
title: "HeavySkill: Heavy Thinking as the Inner Skill in Agentic Harness"
type: source
source_url: "https://arxiv.org/html/2605.02396v1"
authors: ["Jianing Wang", "Linsen Guo", "Zhengyu Chen", "Qi Guo", "Hongyu Zang", "Wenjie Shi", "Haoxiang Ma", "Xiangyu Xi", "Xiaoyu Li", "Wei Wang", "Xunliang Cai"]
created: 2026-05-13
tags: [agentic-harness, heavy-thinking, parallel-reasoning, sequential-deliberation, test-time-scaling, rlvr, skills]
---

# HeavySkill: Heavy Thinking as the Inner Skill in Agentic Harness

**Claim:** Heavy thinking (parallel reasoning + sequential deliberation) can be encapsulated as a single portable SKILL.md file, making it harness-agnostic inner capability rather than an artifact of orchestration infrastructure.

## Core Framework

Heavy thinking decomposes into two stages:

1. **Parallel Reasoning** — spawn K independent reasoning agents, each solving the same problem without seeing each other's outputs. Diversity of strategy is encouraged (algebraic vs. geometric approaches, etc.).
2. **Sequential Deliberation** — a second LLM reads a serialized memory cache of all K trajectories and synthesizes a final answer. It critically evaluates, can re-derive when all thinkers are wrong, and refuses naive concatenation.

Performance hierarchy observed: `Heavy-Pass@k ≥ Heavy-Mean@K ≥ Vote@K ≥ Mean@k`

## HeavySkill as a Readable Skill

The workflow is distilled into a SKILL.md with four components:
- **Activation Conditions** — triggers on complex reasoning tasks; dormant for factual queries
- **Parallel Reasoning Protocol** — instructs the orchestrator to spawn K subagents in parallel
- **Deliberation Prompt** — classify query, critically evaluate each trajectory, re-derive if all wrong, maintain format consistency
- **Output Constraints** — final answer only (not meta-analysis), domain-appropriate format

**Portability:** The same HeavySkill document tested successfully under both Claude Code and custom harnesses without modification.

## Key Findings

- HeavySkill consistently outperforms Best-of-N (BoN) / majority voting strategies
- Stronger models can approach Pass@N performance via sequential deliberation
- Sequential deliberation can synthesize correct answers not present in any single trajectory (HP@k > P@k in ~50% of frontier model trials)
- RLVR can further optimize both breadth (parallel) and depth (deliberation), improving HM@k and HP@k
- **Iterative deliberation** shows diminishing returns due to context interference from earlier rounds
- **Model selection for deliberation:** general-purpose instruction-following models work well even if weaker at raw reasoning — the deliberation stage needs synthesis ability, not peak reasoning power
- Max-Answer-Num trajectory selection strategy outperforms random, diversity, and length-based selection

## Experiment Benchmarks

STEM: AIME25, BeyondAIME, HMMT25-Feb, GPQA-Diamond  
General: LiveCodeBench, Arena-Hard, IFEval, IMO (Answer Bench)  
Tool use: AIME25 + HMMT25 with Python interpreter

Models tested: GPT-5 Thinking, Claude 4.5 Thinking, Gemini 3 Pro Preview, DeepSeek R1-0528, Kimi K2 Thinking, GLM 4.6, Qwen3-8B/32B, R1-Distill series, GPT-OSS-20B, DeepSeek V3.2 Thinking

## Relationships

- [[03-RESOURCES/concepts/heavy-thinking]] — core concept formalized here
- [[03-RESOURCES/concepts/parallel-reasoning]] — Stage 1 of HeavySkill
- [[03-RESOURCES/concepts/sequential-deliberation]] — Stage 2 of HeavySkill
- [[03-RESOURCES/concepts/agentic-skills]] — HeavySkill is a readable skill artifact
- [[03-RESOURCES/concepts/agentic-harness-engineering]] — framework context
- [[03-RESOURCES/concepts/agent-memory-architecture]] — serialized memory cache bridges the two stages
- [[03-RESOURCES/sources/skills-verifiable-artifacts-biconditional-correctness]] — companion paper on skill trust
