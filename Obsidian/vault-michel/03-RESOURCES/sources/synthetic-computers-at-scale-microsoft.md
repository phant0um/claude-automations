---
title: "Synthetic Computers at Scale for Long-Horizon Productivity Simulation"
type: source
source_file: "Clippings/Synthetic Computers at Scale for Long-Horizon Productivity Simulation.md"
url: "https://arxiv.org/html/2604.28181v1"
authors: [Tao Ge, Baolin Peng, Hao Cheng, Jianfeng Gao]
org: Microsoft
dataset: "huggingface.co/datasets/microsoft/synthetic-computers-at-scale"
created: 2026-05-14
updated: 2026-05-14
tags: [source, synthetic-data, long-horizon, productivity, agent-training, agentic-rl, microsoft]
---

# Synthetic Computers at Scale

## Core Contribution

A scalable methodology for generating synthetic user computer environments — complete with realistic personas, filesystem hierarchies, and content-rich artifacts — to serve as grounding environments for long-horizon productivity simulations. Each environment is then used to run month-equivalent agentic work sessions that produce rich experiential training signals for improving agents in productivity scenarios.

## The Problem Being Solved

Real long-horizon productivity work (reports, spreadsheets, presentations spanning weeks) requires agent access to rich, user-specific context: existing files, project history, collaborator feedback, and evolving work state. But real user computers contain private data, making real trajectory collection at scale impossible. Generic synthetic data fails because it lacks the user-specific context that grounds real work.

**Three guiding principles:**
1. Productivity work is context-heavy by nature
2. The key challenge is using rich user context over long horizons
3. Synthetic data must synthesize the context, not only the task

## Method: Synthetic Computer Creation Pipeline

**Phase 1 — Persona elaboration:**
- Start from large persona pools (abundant at billion scale)
- Expand persona → detailed user profile (identity, occupation, responsibilities, document habits, naming preferences, collaborators, current projects)

**Phase 2 — Filesystem planning:**
- Generate user-specific filesystem policy (drive layout, storage patterns, organization style, naming conventions)
- Plan file inventory: logical paths, artifact types, timestamps, cross-file dependencies

**Phase 3 — Artifact instantiation:**
- Populate directory with realistic, content-rich artifacts (Word docs, Excel sheets, PDFs, presentations)
- Content reflects user's actual work context, project history, and collaborator communications

**Phase 4 — Long-horizon simulation:**
- Setup agent: creates productivity objectives tailored to the computer's user (~1 month of human work, multiple professional deliverables)
- Work agent: acts as that user, navigates filesystem, coordinates with simulated collaborators, iteratively produces deliverables
- Each run: **>8 hours agent runtime, >2,000 turns on average**

## Scale of Preliminary Experiments

- **1,000 synthetic computers** created (50/50 Windows/macOS split in released subset of 100)
- 900 used for training signal extraction, 100 held-out for evaluation
- Releases: 100 synthetic computers + 500 retrospective analysis reports

## Evaluation

### Rubric-Based Outcome Scoring
- Judge agent (Claude Opus 4.6 via Claude Code SDK) scores final deliverables against per-computer rubric
- 5 simulation runs per computer → merged rubric for generality
- Baseline score distribution: most computers score **60–80%** (substantial room for improvement)

### In-Domain Results (occupation skills)
- Experience extracted from 900 training simulations → occupation-specific skills
- Skill-augmented agent: mean rubric score **61.6% → 68.6%**
- Skill-augmented agent wins on **83/100 test computers** vs baseline
- Scaling trend: 10 training computers → marginal gain; 100→64% wins, 500→75% wins, 900→83% wins
- With 10 computers: some harm (skill mismatch) — occupation coverage matters

### Out-of-Domain Evaluation
- Tested on real productivity benchmarks beyond synthetic distribution
- Shows significant improvement — demonstrates experiential learning generalizes

## Key Insight: Environment-Conditioned Synthetic Data

The methodology's core claim: synthetic data without realistic user environments degenerates into generic, toy workflows. The environment IS the signal — the agent must navigate actual filesystem structure, reference real files, and coordinate with realistic collaborators to produce grounded work.

**Claude Cowork is cited** as the frontier product requiring this capability: long-horizon agents grounded in entire user computers.

## Implications for Vault

- Directly relevant to [[03-RESOURCES/concepts/agentic-rl]] — provides a scalable environment generation substrate
- Addresses the "environment diversity" challenge identified in agentic RL literature
- Extends [[03-RESOURCES/concepts/synthetic-data-for-agents]] thinking beyond code/math to realistic productivity work
- The persona-driven pipeline could scale to billions of environments — theoretical ceiling for synthetic data diversity

## Connections

- [[03-RESOURCES/concepts/synthetic-data-for-agents]] — concept page for this pattern
- [[03-RESOURCES/concepts/agentic-rl]] — RL framework this enables
- [[03-RESOURCES/concepts/horizon-length]] — the training bottleneck this methodology addresses by providing grounded environments
- [[03-RESOURCES/concepts/dual-data-flywheel]] — complementary approach to agentic data diversity
- [[03-RESOURCES/entities/Microsoft-Research-Asia]] — authoring lab (MSRA affiliation)
- [[03-RESOURCES/entities/Claude-Cowork]] — cited product requiring this capability
