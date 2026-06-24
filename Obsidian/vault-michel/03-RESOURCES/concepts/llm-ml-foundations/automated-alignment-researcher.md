---
title: Automated Alignment Researcher (AAR)
type: concept
status: developing
created: 2026-04-19
updated: 2026-04-19
tags: [ai-agents, alignment, automated-research, anthropic, multi-agent]
---

# Automated Alignment Researcher (AAR)

## What It Is

A **Claude-powered autonomous research agent** built by Anthropic that:
1. Proposes research hypotheses
2. Designs and runs experiments
3. Analyzes results
4. Shares findings with parallel agents
5. Iterates toward a measurable objective (PGR score)

Multiple AARs run in parallel, each in an independent sandbox, cooperating via a shared forum and codebase storage. Introduced in [[03-RESOURCES/sources/ml-research-papers/automated-weak-to-strong-researcher]].

## Architecture

```
Dashboard → Launch N parallel AARs
Each AAR:
  ├── Independent sandbox (compute + code)
  ├── Access to baseline implementations + helper functions
  ├── MCP tools:
  │   ├── submit predictions → get PGR score
  │   ├── read/write shared forum (findings)
  │   └── upload/download codebase snapshots
  └── No prescribed workflow — fully autonomous
Shared (outside sandbox):
  ├── Forum (findings + discussion)
  └── Codebase storage (snapshots)
```

Model powering AARs: **Claude Opus 4.6**

## Key Design Decisions

### Autonomous > Prescriptive Scaffolding
A fixed workflow (propose → plan → code → test → train → analyze → repeat) **underperforms giving AARs no workflow at all**. Rigid steps prevent adaptation. Without constraints, AARs behave like expert researchers: they design cheap de-risking experiments before committing to full training.

### Directed Directions > Undirected
Each AAR should be seeded with a distinct, ambiguous research direction (e.g., "combine weak-to-strong supervision and unsupervised elicitation"). This prevents **entropy collapse** (all agents converging to the same few approaches). Specific pre-generated ideas perform worse.

### Local Finding Sharing > Remote Search
Syncing all findings directly into each AAR's sandbox (local agentic search) outperforms keyword search or MCP-backed remote search. Local access allows AARs to browse and discover unexpected connections — analogous to researchers reading broadly.

### LM Self-Evolution > Heuristic Evolutionary Search
LM-driven iteration naturally benefits from general capability improvements in planning and experiment analysis. Heuristic search treats ideas as black boxes scored only by outcome — it abandons directions that fail because of fixable bugs (gradient norm explosion, wrong hyperparameters). LM agents diagnose from training logs and recover.

## Performance

On the [[03-RESOURCES/concepts/llm-ml-foundations/weak-to-strong-generalization]] problem (chat preference dataset):
- **Human researchers** (2 authors, 7 days, 4 methods): best PGR = 0.23
- **9 parallel AARs** (5 days, 800 cumulative hours): PGR = **0.97**
- Cost: ~$18,000 total (~$22/AAR-hour)

## Entropy Collapse

A failure mode where parallel AARs converge to only a few research directions. Tracked via **Shannon entropy** of method category distribution across active agents. Undirected AARs collapse quickly to self-training. Directed AARs maintain diversity throughout.

Method categories tracked: self-training, ensemble, distillation, data filtering, confidence weighting, loss function, unsupervised elicitation, curriculum, model internal, evolutionary, other.

## Reward Hacking (Emergent)

AARs discovered unexpected exploits not anticipated by the researchers. See [[03-RESOURCES/concepts/llm-ml-foundations/reward-hacking]] for details. Key lesson: **future work must test ideas on entirely held-out datasets**, not just OOD splits of the same domain.

## Implications for Alignment

- Automated research on outcome-gradable problems is **already practical** (April 2026)
- Solving weak-to-strong supervision in a general way would unlock bootstrapping on broader non-outcome-gradable problems
- Key bottleneck: designing evals (metrics, data, models) that AARs can reliably hill-climb without overfitting
- AAR logs (including failures and dead-ends) are valuable training data for future AARs

## Future Directions

- Multiple domains for hill-climbing (not just testing) to combat data-specific tricks
- Generalization across model scales
- Legibility training to prevent "alien science" (hard-to-verify ideas from pure outcome optimization)
- Empowering human researchers: delegate hypothesis-testing to AARs

## Connections

- [[03-RESOURCES/sources/ml-research-papers/automated-weak-to-strong-researcher]] — source paper
- [[03-RESOURCES/concepts/llm-ml-foundations/weak-to-strong-generalization]] — the problem being solved
- [[03-RESOURCES/concepts/llm-ml-foundations/reward-hacking]] — emergent behavior to mitigate
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — architectural pattern used
- [[03-RESOURCES/entities/Jan-Leike]] — lead researcher
- [[03-RESOURCES/entities/anthropic]] — developing org
- [[03-RESOURCES/entities/Claude-Opus-46]] — model powering agents
