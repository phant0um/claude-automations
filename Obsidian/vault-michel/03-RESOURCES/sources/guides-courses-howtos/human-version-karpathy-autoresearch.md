---
title: "Experiments: The Human Version of Karpathy's Autoresearch"
slug: human-version-karpathy-autoresearch
type: source
category: ai-agents
author: "@annabellschfr"
source_url: "https://x.com/annabellschfr/status/2056405166446854369"
published: 2026-05-18
ingested: 2026-05-18
tags: [ai-agents, autoresearch, experiments, evaluation, langfuse, ai-engineering-loop, evals]
triagem_score: 8
---

# Experiments: The Human Version of Karpathy's Autoresearch

## Tese central

Before automating the AI improvement loop (autoresearch), engineers must run it manually to build intuition: which variables matter, what "better" means for their use case, how to distinguish real improvement from noise. Automated optimization of the wrong metric just produces faster failure.

## Key insights

1. **AI Engineering Loop:** Production tracing/monitoring → structured iteration (datasets, experiments, evaluation) → shipped improvements → new production data → loop repeats. Published as part of Langfuse Academy series.

2. **Manual before automated:** Karpathy's autoresearch ran 700 experiments overnight, found 20 missed optimizations, improved training time 11%. But teams getting the most from autoresearch-style workflows are those who already understand how to run a good experiment manually.

3. **Anatomy of an experiment (4 parts):** dataset + baseline configuration + changed variable + comparison method. Change one variable at a time — exception: coupled variables (new model often needs new prompt to reveal true performance).

4. **Variable taxonomy:** Model (quality/speed/cost tradeoffs) · Prompt (instructions, examples, format) · Pipeline architecture · Evaluation criteria. Each variable interacts with others.

5. **Evaluation dependency:** experiments alone don't tell you "better by how much" — need structured evals to quantify improvement delta and distinguish real signal from variance.

6. **The faster-failure trap:** an automated loop optimizing the wrong fitness function produces faster failure, not faster improvement. Human intuition about what "better" means must precede automation.

7. **Langfuse Academy context:** this is one chapter in a series covering the full AI engineering lifecycle — tracing, monitoring, datasets, experiments, evals, deployment.

## The AI Engineering Loop — Detailed Mechanics

The loop has four distinct phases, each with a gate before the next begins:

**Phase 1 — Production tracing:** every inference call logs inputs, outputs, latency, cost, and (where possible) user feedback signals. Without this observability layer, experimentation has no ground truth to compare against.

**Phase 2 — Structured iteration:** datasets are built from production traces (especially failure cases). Each experiment changes exactly one variable against a frozen baseline. Running multiple experiments concurrently is valid only when variables are provably independent — but coupled variables (model + prompt, retrieval strategy + chunking) must move together because their interaction is the phenomenon under study.

**Phase 3 — Shipped improvements:** winning experiments graduate to a feature branch and go through the same deployment process as any other change. The experiment artifact (dataset + config + eval result) is preserved as documentation.

**Phase 4 — New production data:** the shipped change alters the distribution of production traces, which feeds back into Phase 1 with a richer signal. Each loop iteration narrows uncertainty about what "better" means for this specific use case.

## Why Manual-First Matters

Karpathy's 700-experiment run found 20 missed optimizations. The teams who replicate these results are those who have already run 20–30 manual experiments and built a taxonomy of what matters. Teams who jump directly to automation frequently optimize a proxy metric that diverges from real quality once the distribution shifts.

The intuition built by manual experimentation is not replaceable by more compute. It answers questions like: does a 0.3-point improvement on the eval correlate with user satisfaction, or is the eval itself broken? Is the variance in this metric real signal or prompt sensitivity? These questions require human judgment to answer the first time.

## Variable Taxonomy — Practical Notes

**Model changes** are the highest-leverage and highest-risk variable. A model upgrade can change latency, cost, and output format simultaneously. Always run the new model against the exact same prompt as the baseline first, then tune the prompt for the new model separately — otherwise you cannot attribute changes.

**Prompt changes** are the safest variable to explore rapidly. Within a single model, prompt variations are cheap to run, easy to version, and their effects are usually localized. The risk is overfitting the prompt to the evaluation dataset rather than the production distribution.

**Pipeline architecture changes** (adding retrieval, changing chunking, adding a re-ranker) have the widest blast radius. They affect every downstream component and often require rebuilding the evaluation dataset from scratch.

**Evaluation criteria changes** are the most dangerous variable to change silently. When the eval changes, all prior experiment results become incomparable. Version evaluation criteria explicitly, the same way you version code.

## The Faster-Failure Trap — Extended Analysis

Automated optimization amplifies whatever fitness function it is given. If the fitness function is well-calibrated to real quality, automation produces real improvement fast. If it is miscalibrated — even slightly — automation produces confident, fast, wrong results that look like progress in dashboards.

The trap is asymmetric: a manual experiment that optimizes the wrong thing wastes one engineer's afternoon. An automated loop that optimizes the wrong thing runs 700 overnight experiments, produces a "winning" configuration, gets shipped, and degrades production quality for weeks before anyone notices.

The prerequisite for safe automation is a validated fitness function. Validation means the eval score correlates with human judgment on a held-out set of real production examples — not just on the examples used to build the eval.

## Langfuse Academy Context

This source is one chapter in a curriculum covering the full AI engineering lifecycle. The adjacent chapters cover: prompt management and versioning, dataset curation from production traces, evaluation pipeline design, deployment with gradual rollout, and monitoring for distribution shift. The experiment-and-evaluation chapter sits in the middle of this sequence deliberately — it depends on tracing and datasets, and it enables everything downstream.

## Vault Relevance

The AI Engineering Loop is the operational backbone of the vault's self-improvement goal. Every wiki-ingest session is a manual experiment: input (raw source) + configuration (CLAUDE.md schema) + output (wiki page) + evaluation (lint cycle). The `04-SYSTEM/wiki/errors.md` log is the dataset of failed experiments. Autoresearch automation of the vault becomes safe only after enough manual cycles to validate that the fitness function (lint score, cross-link density, hot.md coverage) correlates with actual knowledge quality.

## Links

- [[03-RESOURCES/concepts/pkm-obsidian/autoresearch-loop]] — core pattern this source operationalizes manually
- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]] — evaluation as prerequisite to valid experiments
- [[03-RESOURCES/concepts/agent-systems/automated-research-agents]] — autoresearch agents context
