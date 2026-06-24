---
title: "Agentic Execution"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, agent-systems, execution]
status: developing
---

# Agentic Execution

An LLM taking multi-step autonomous actions in a real environment — reading, planning, acting, and iterating until a goal is complete.

## O que é / What it is

Agentic execution is what happens when an LLM is given tools and a goal, then **loops autonomously** through perception → reasoning → action → observation until done or blocked. The key distinction from chat: the model is the driver, not the passenger.

## Como funciona

**Read-Plan-Act loop:**
1. **Observe** — read environment state (files, APIs, tool outputs)
2. **Plan** — reason about the next action (may use CoT or structured plan)
3. **Act** — call a tool, write a file, run a command
4. **Observe result** — parse output, update internal state
5. **Repeat** until goal satisfied or abort condition met

**Checkpointing:** Long runs save intermediate state so execution can resume after failure without starting over.

## Padrões / Patterns

- **Reversible vs irreversible actions:** Prefer reversible (read, draft) before irreversible (delete, send, push). Gate irreversible ops with [[03-RESOURCES/concepts/human-in-the-loop]] checkpoints.
- **Action budget:** Cap tool calls per run to contain runaway loops.
- **Abort on ambiguity:** If the next action is unclear, surface to user rather than guess.
- **State serialization:** Write partial results to disk so context window pressure doesn't erase progress.

## Por que importa

Every Claude Code session is agentic execution. Understanding the loop helps diagnose where agents get stuck (bad observation parsing, replanning failures, irreversible action regret) and design better scaffolds.

## Related
- [[03-RESOURCES/concepts/agent-systems/_index]]
- [[03-RESOURCES/concepts/ai-agents]]
- [[03-RESOURCES/concepts/multi-step-planning]]
- [[03-RESOURCES/concepts/sequential-deliberation]]
- [[03-RESOURCES/concepts/human-in-the-loop]]
- [[03-RESOURCES/concepts/long-horizon-agents]]
- [[03-RESOURCES/concepts/agent-security]]

## Evidências
- **[2026-06-24]** This post is about Loops. And TypeScript. In fact, it covers a few things:A bad pattern I found in our codebaseWhy the p — [[loops-are-dead-and-typescript-sucks]]

- **[2026-06-24]** Deploy the full Claude desktop experience - chat, Claude Cowork, and Claude Code - using inference on AWS, Google Cloud — [[claude-desktop-on-aws-google-cloud-and-microsoft-foundry]]
- **[2026-06-24]** Since January, our internal AI agent Archie has 10x'd in cost - now ~$35K/month run-rate ($420K+ a year). That's more th — [[our-ai-agent-now-costs-more-than-human-junior-bankers]]
- **[2026-06-24]** This two-part series explores how ontology-grounded agentic AI transforms Design Failure Mode and Effects Analysis (DFME — [[reimagining-b-pillar-dfmea-why-ontology-grounded-ai-is-the-future-of-automotive-engineering]]
- **[2026-06-24]** tags: — [[data-recipes-for-agentic-models]]
- **[2026-06-24]** tags: — [[grading-the-grader-lessons-from-evaluating-an-agentic-data-analysis-systemcode-and-data-available-at-github-httpsgithub-comtzstats-columbiastai-x-grade-the-grader]]
- **[2026-06-24]** tags: — [[the-latent-bridge-a-continuous-slow-fast-channel-for-real-time-game-agents]]
- **[2026-06-24]** Introduction Migration assessment and planning is rarely a single-pass exercise. Inventory data is incomplete; assumptio — [[accelerating-migration-assessments-and-planning-with-aws-transform]]
- **[2026-06-24]** 4 paradigms shifts em 10 anos de TiDB: técnico→produto, software→serviço, humano→AI-assistido,... — [[distributed-db-paradigm-migration]]
