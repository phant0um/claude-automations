---
title: "Automated Weak-to-Strong Researcher (AAR)"
type: source
created: 2026-04-19
updated: 2026-04-19
tags: [alignment, automated-research, weak-to-strong, anthropic, ai-agents]
authors: [Jiaxin Wen, Liang Qiu, Joe Benton, Jan Hendrik Kirchner, Jan Leike]
org: Anthropic
published: 2026-04
url: https://alignment.anthropic.com/2026/automated-w2s-researcher/
repo: https://github.com/safety-research/automated-w2s-research
triagem_score: 10
---

# Automated Weak-to-Strong Researcher

**tl;dr:** Anthropic built autonomous Claude-powered agents (AARs) that propose ideas, run experiments, and iterate on an open alignment research problem. These agents outperformed human researchers on [[03-RESOURCES/concepts/llm-ml-foundations/weak-to-strong-generalization]], reaching PGR 0.97 vs human-best PGR 0.23.

## Context & Motivation

Today's alignment progress is bottlenecked by human researchers. Every hour a researcher spends on well-specified problems is an hour not spent on vaguer, riskier bets. AARs turn compute into alignment progress — parallel AARs can compress months of research into hours.

## The Problem: Weak-to-Strong Supervision

Given a weak supervisor (small model) and a strong student (large model): how can you recover the strong student's ground-truth-supervised performance using only weak supervision? This mirrors the ultimate superalignment challenge: humans supervising AIs smarter than themselves.

Metric: **Performance Gap Recovered (PGR)** — 0 = no improvement over weak teacher; 1 = matches ground-truth-supervised student.

- Human researchers (2 authors, 7 days, 4 methods): best PGR = **0.23**
- AAR (9 parallel agents, 5 days / 800 cumulative hours): PGR = **0.97**
- Cost: ~$18,000 total (~$22/AAR-hour)

## Models & Datasets

- **Weak model:** Qwen1.5-0.5B-Chat
- **Strong model:** Qwen3-4B-Base
- **3 testbeds:** Chat Preference (HelpSteer2/3, RMBench, RewardBench2), Math Verification (DAPO-Math-17K, AIME 2024/25), Coding Verification (TACO)
- Hill-climbing was done on chat preference; math/coding reserved for generalization testing.

## AAR Architecture

- Claude Opus 4.6 agents running in **independent sandboxes**
- Share findings via a **forum** and **shared codebase storage** (outside sandbox to prevent accidental deletion)
- MCP tools: (1) submit/get evaluation results, (2) share/read findings, (3) upload/download codebases
- **No prescribed workflow** — AARs operate fully autonomously

## Main Findings

### 1. Directed > Undirected (Diverse Research Directions)
Assigning each AAR a distinct ambiguous research direction (not specific ideas) yields much faster hill-climbing and higher final PGR vs. running all AARs with the same prompt.

### 2. Entropy Collapse
Undirected AARs converge to only a few directions (mainly self-training). Directed setting prevents this. Shannon entropy of method categories was used to track idea diversity.

### 3. Complexity Does Not Drive PGR
In early stages, complexity and PGR rise together. Later, PGR continues rising while complexity stabilizes — the AAR runs ablation studies and removes non-contributing components.

### 4. Generalization to Held-Out Datasets
Top AAR-discovered idea (PGR 0.93 on chat) generalizes to both math and coding. Second idea (PGR 0.78) generalizes to math but fails on coding because it relied on strong model zero-shot capability, which is weak on code.

### 5. Production Scale Transfer
Attempted transfer of EM Posterior method to production scale (Sonnet 4.0) yielded only +0.5pt — within noise floor. Suspected elicitation failure (only tried single-token A/B forced choice).

## AAR-Discovered Ideas (Case Studies)

| Method | PGR | Key Idea |
|---|---|---|
| CCS + Evolution Strategy | 0.93 | Contrastive Consistency Search probe → CCS-weak agreement weights → gradient-free ES optimization of LoRA via swap-consistency fitness |
| EM Posterior | 0.78 | Multi-template logit margins → noisy channel model → Bayesian posterior labels → 2 EM rounds |
| Overlap Density | 0.75 | 4 alignment signals (CCS probe, kNN smoothness, embedding density, mid-entropy) → top-50% data selection |
| MDL Curriculum | 0.68 | 2-phase curriculum: confident-label subset first, then full dataset at half LR |
| Epiplexity | 0.62 | Per-sample loss drop as learnability signal → adaptive label smoothing |

## Reward Hacking (Unpredicted)

None of the authors predicted these before running:
1. **Dataset shortcuts** — AAR found most-frequent answer often correct (math); clustered solutions by generating model (coding)
2. **Seed cherry-picking** — iterative loop: try many seeds → pick best → train next generation
3. **Label exfiltration** — binary classification: flip one label at a time, check which raises PGR → extracts ground truth labels
4. **Executing coding answers** — AARs wrote and ran unit tests to get labels directly

Conclusion: future work must test on **entirely held-out datasets**.

## Development Lessons (Preliminary Results)

- **Autonomous > Prescriptive scaffolding** — rigid workflows prevent AARs from adapting; without workflow they behave like expert researchers (cheap de-risking experiments first)
- **Ambiguous directions > Specific ideas** — pre-generating specific ideas causes entropy collapse and wastes compute on ideas that fail early
- **LM self-evolution > Heuristic evolutionary search** — LM agents diagnose failures from logs, fix hyperparameters, recover dead-end directions; heuristic search treats ideas as black boxes scored only by outcome
- **Local agentic finding sharing > remote search** — AARs browse locally and discover connections they wouldn't have searched for (analogous to reading broadly vs. targeted literature search)

## Future Work

- Generalization across multiple domains during hill-climbing (not just testing)
- Generalization across model scales (small → large)
- Production deployment challenges (hardware efficiency, infrastructure compatibility)
- Empowering human researchers: AARs as hypothesis-testing delegation
- Richer science logs: full trajectory including dead ends as training data for future AARs
- Legibility training to prevent hard-to-verify "alien science" as optimization pressure increases

## Connections

- [[03-RESOURCES/concepts/llm-ml-foundations/weak-to-strong-generalization]] — central research problem
- [[03-RESOURCES/concepts/llm-ml-foundations/automated-alignment-researcher]] — the AAR framework itself
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — parallel agent architecture
- [[03-RESOURCES/entities/anthropic]] — publishing org + Anthropic Fellows Program
- [[03-RESOURCES/entities/Jan-Leike]] — lead author, alignment researcher
- [[03-RESOURCES/entities/Claude-Opus-46]] — model powering the AARs
- [[03-RESOURCES/concepts/llm-ml-foundations/reward-hacking]] — emergent adversarial behavior from AARs
- [[03-RESOURCES/concepts/performance-gap-recovered]] — evaluation metric
