---
title: "Opus 4.7 for 33% less: How Auggie beats Claude Code on cost and quality"
slug: auggie-vs-claude-code-opus-33-percent-less
type: source
category: benchmarks
author: "@augmentcode"
source_url: "https://x.com/augmentcode/status/2056406584700567836"
published: 2026-05-18
ingested: 2026-05-18
tags: [benchmarks, augment, auggie, claude-code, opus-4.7, token-efficiency, terminal-bench, swe-bench, cost-optimization]
triagem_score: 8
---

# Opus 4.7 for 33% less: How Auggie beats Claude Code on cost and quality

## Tese central

Augment's Auggie CLI beats Claude Code on both quality and cost using the same underlying model (Opus 4.7): 67.4% vs 66.3% pass rate on Terminal Bench 2.0, at 33% lower cost — driven by sharper retrieval reducing wasted context tokens, not model differences.

## Key insights

1. **Same model, different harness:** both Auggie and Claude Code run Opus 4.7 with default settings. Cost and quality difference comes from the harness, not the model. This is the clearest published evidence that harness engineering is a first-class cost/quality lever.

2. **Terminal Bench 2.0 results:** Auggie 67.4% vs Claude Code 66.3% pass rate (1.1% gap — within run variance). Cost gap: 33% lower. Token breakdown — cache reads down 32%, output tokens down 37%.

3. **SWE-Bench Pro results:** Auggie ahead on quality, 23% cheaper per task. Cache reads down 30%, cache writes down 17%, total tokens substantially reduced.

4. **Where savings come from:** Augment's Context Engine reduces cache reads (historical context replayed each turn) and output tokens — "less wasted exploration, fewer expensive turns." The retrieval layer selects only relevant context rather than injecting everything.

5. **Token spend as board-level concern:** engineering leaders have shifted from "can it do this?" to "what does it cost at our scale?" Usage exploding → token spend is now a board-level line item.

6. **Incentive asymmetry:** OpenAI and Anthropic dominate the frontier model market and are not motivated to make coding agents cheaper. For third-party harness builders (Augment, etc.), token efficiency is a key differentiator.

7. **Prism model routing compounding:** combined with Augment's Prism optimal model routing, customers can expect up to 50% savings on state-of-the-art models at same quality. Multi-lever approach: better retrieval + intelligent routing.

8. **Benchmark setup:** Harbor framework, GCP n4-highcpu-16 (16 vCPU, 32 GB RAM), 5 attempts per task, 4 parallel tasks (Terminal Bench). 3 attempts, 8 batches parallel (SWE-Bench Pro).

## Links

- [[03-RESOURCES/entities/Terminal-Bench-2]] — benchmark used; Auggie score adds new data point
- [[03-RESOURCES/entities/SWE-Bench-Verified]] — companion benchmark; SWE-Bench Pro variant used here
- [[03-RESOURCES/entities/Claude-Opus-47]] — shared underlying model for both agents
- [[03-RESOURCES/entities/Claude Code]] — baseline compared against
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-caching]] — cache reads/writes are the primary token reduction lever identified
- [[03-RESOURCES/concepts/agent-systems/agent-model-routing]] — Prism routing as compounding lever
- [[03-RESOURCES/concepts/agent-systems/agent-harness]] — harness engineering as cost/quality differentiator; core finding of this benchmark

## What "Harness Engineering" Actually Explains the Gap

The finding that two agents using the same underlying model (Opus 4.7) at default settings produce a 33% cost difference is the clearest empirical validation published in 2026 that harness engineering is a first-class lever — not a marginal optimization.

The token breakdown tells the mechanism:
- **Cache reads down 32%:** Augment's Context Engine retrieves only relevant historical context rather than replaying the full conversation history on each turn. Less total context injected = fewer cache read tokens.
- **Output tokens down 37%:** "less wasted exploration" — Auggie reaches the correct approach faster, producing fewer tokens of incorrect reasoning or false starts.

Both reductions come from the retrieval layer, not from prompt engineering or model fine-tuning. The retrieval layer selects which context is injected before the model sees anything. Better selection = shorter effective context = cheaper turns.

## Terminal Bench 2.0 — Benchmark Design and Limitations

Terminal Bench 2.0 measures an agent's ability to complete real software engineering tasks in a terminal environment. Tasks include: debugging, feature implementation, test writing, refactoring. The benchmark is more realistic than synthetic benchmarks because it requires actual command execution, not just code generation.

The 67.4% vs 66.3% quality gap (1.1%) is within run variance and should not be read as a definitive quality advantage. The meaningful number is the cost gap (33%) at comparable quality — this demonstrates that Augment is achieving the same output with substantially fewer tokens.

**Benchmark setup limitations:** Harbor framework on standardized GCP hardware (n4-highcpu-16) with 5 attempts per task, 4 parallel tasks. This is a fair comparison (same hardware, same model, concurrent runs) but represents a specific task distribution. Production workloads with different task distributions may show different relative efficiency.

## SWE-Bench Pro — Harder Tasks, Larger Gap

SWE-Bench Pro (the harder variant of SWE-Bench Verified) shows a larger cost gap: 23% cheaper per task, with cache reads down 30% and cache writes down 17%. The larger gap on harder tasks is meaningful: harder tasks typically require more retrieval (more relevant context needed) — Augment's retrieval quality advantage compounds on tasks where more context is needed.

The cache writes reduction (17%) suggests that Auggie is also more selective about what it writes to the cache — a secondary optimization that reduces cache maintenance overhead.

## The Incentive Asymmetry — Why Third-Party Harnesses Have an Advantage

The observation that OpenAI and Anthropic "are not motivated to make coding agents cheaper" is structural, not cynical. The model providers' revenue is directly proportional to token consumption. A 33% efficiency improvement at the harness layer is a 33% revenue reduction for the model provider, all else equal.

Third-party harness builders (Augment, Cursor, Windsurf) have the opposite incentive: token efficiency is a competitive differentiator that makes their product cheaper for the same quality. Engineers choosing between coding assistants will choose the one that costs less per task at equivalent quality. This incentive alignment drives harness-level innovation that model providers have no reason to prioritize.

**Implication for the industry:** harness engineering investment will continue to concentrate at the third-party layer. Model providers will focus on capability and context window; harness builders will focus on retrieval quality, context compression, and routing efficiency. The model is commoditizing; the harness is differentiating.

## Prism Routing — The Second Lever

Augment's Prism optimal model routing compounds with the Context Engine efficiency. Prism routes different subtasks within a coding session to the most cost-effective model that can handle that subtask's complexity. Combined effect (Context Engine + Prism): "up to 50% savings on state-of-the-art models at same quality."

The architecture: Context Engine reduces per-turn cost by injecting less context. Prism reduces per-task cost by routing some turns to cheaper models. These are independent levers — Context Engine savings apply regardless of which model handles the turn; Prism savings apply on top by reducing the proportion of turns that require the most expensive model.

## Implications for Systems Using Claude Code Directly

For teams using Claude Code directly (without Augment), the benchmark implies that a substantial portion of Claude Code's cost comes from harness inefficiency rather than model capability requirements. The practical takeaways:

1. Measure cache read volume per session — if it's growing linearly with conversation length, the harness is replaying full history
2. Implement context compression (similar to `/compact`) to replace full history with structured summaries
3. Consider whether every turn needs Opus or if subtasks can route to cheaper models
4. Profile output token volume — high output tokens may indicate wasted reasoning from poor context quality

The benchmark makes the theoretical guidance concrete: the same model with a better harness costs 33% less. Harness engineering is not optional for production systems at scale.
