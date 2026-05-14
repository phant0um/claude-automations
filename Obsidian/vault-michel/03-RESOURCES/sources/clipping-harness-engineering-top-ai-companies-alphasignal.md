---
title: "A Closer Look at Harness Engineering from Top AI Companies"
type: source-summary
source_type: social-media-thread
author: "@AlphaSignalAI"
source_url: "https://x.com/AlphaSignalAI/status/2046952554421002393"
published: 2026-04-13
created: 2026-05-01
tags: [harness-engineering, agents, openai, anthropic, thoughtworks, langchain]
---

# Harness Engineering from Top AI Companies

**Author:** @AlphaSignalAI
**Signal:** Comparative analysis of OpenAI, Anthropic, ThoughtWorks harness approaches + Opus 4.7 implications.

## Core Definition

> "If you're not the model, you're the harness." — Vivek Trivedy, LangChain

Everything around the model = the harness: system prompts, tools, middleware, file system, documentation, verification loops.

## The Benchmark Evidence

- LangChain: same model (GPT-5.2-Codex), different harness → Terminal Bench 2.0: **52.8% → 66.5%** (rank 30+ → rank 5)
- Vercel: **deleted 80% of agent's tools** → performance went up
- "Maxing reasoning at every stage = worst score (53.9%)"
- **Reasoning sandwich:** high planning → reduced building → high verifying = **66.5%**

## Three Approaches

### OpenAI (Ryan Lopopolo / Codex)
- 1M lines, 5 months, zero human-written
- Four engineers, Sora Android: 28 days → #1 Play Store, 99.9% crash-free
- Codex handled 70% of PRs weekly
- Method: **encode rules as code, not prose**
  - Dependency layers: Types → Config → Repo → Service → Runtime → UI
  - Structural tests that fail if layer imports wrong direction
  - AGENTS.md files per module (distributed docs)
  - Linters written by Codex itself
- Principle: "design the environment thoroughly, then let the agent work inside it"

### Anthropic (GAN-inspired)
- Problem: agents can't honestly evaluate their own work
- Solution: Planner → Generator → Evaluator (Playwright)
- **Claude Managed Agents** (April 9, 2026) = "meta-harness"
  - Decoupled: brain (Claude) / hands (sandbox) / session (durable event log)
  - Crash brain → recovers from log; lose sandbox → tool error, not system failure
  - +10 points on structured file generation vs standard prompting
- Cost: solo agent broken demo = $9; full managed harness = $200 (**22x cost**)

### ThoughtWorks (Birgitta Böckeler)
- Not a system — a vocabulary/classification framework
- **Two axes:** Guide (before) vs Sensor (after); Computational vs Inferential
- Common failure: teams have 3 computational sensors (tests/linters/CI) + zero computational guides
- **Harnessability:** strongly-typed languages + clear module boundaries = more reliable agent work
- Weakness: current tools check maintainability but not whether agent did what was asked

## Opus 4.7 Disruption

Opus 4.7 ships self-verification: "devises ways to verify its own outputs before reporting back."
- Evaluator agent may carry less weight now
- LangChain prediction: "harness components are a bet on what the model can't do yet... some will be absorbed into the model"

## Contradictions / Tensions
> [!contradiction]
> ThoughtWorks argues you need both computational guides AND sensors. But Vercel's result (delete 80% of tools → better performance) suggests minimal harness outperforms maximal harness for certain task types. Resolution: harness size should match task complexity + model capability.

## Connections
- [[03-RESOURCES/concepts/agentic-harness-engineering]] — core concept page
- [[03-RESOURCES/entities/Claude-Opus-47]] — Opus 4.7 self-verification
- [[03-RESOURCES/sources/clipping-ahe-paper-fudan-nexau]] — academic counterpart (AHE paper)
- [[03-RESOURCES/concepts/multi-agent-orchestration]] — Anthropic Planner/Generator/Evaluator
