---
title: "Harness Design for Long-Running Application Development"
type: source
source_type: clipping
source_file: "Clippings/Harness design for long-running application development.md"
source_url: "https://www.anthropic.com/engineering/harness-design-long-running-apps"
author: "Prithvi Rajasekaran (Anthropic Labs)"
created: 2026-05-14
tags: [harness, multi-agent, gan-pattern, planner-generator-evaluator, long-running, opus-4-6, context-anxiety, sprint-contract, anthropic]
---

# Harness Design for Long-Running Application Development

**Author:** Prithvi Rajasekaran — Anthropic Labs  
**Source:** Official Anthropic Engineering blog

## Core Thesis

Two failure modes plague long-running agentic coding:
1. **Context anxiety** — models wrap up work prematurely as they approach perceived context limits
2. **Self-evaluation bias** — agents praise their own mediocre work; evaluators trained on LLM outputs are systematically lenient

The solution is a **GAN-inspired three-agent architecture** (planner + generator + evaluator) where the evaluator is tuned to be skeptical rather than trying to make the generator self-critical.

## Architecture

### Three Agents

**Planner:**
- Takes 1–4 sentence user prompt, expands to full product spec
- Deliberately ambitious scope; emphasizes deliverables over implementation details
- Has access to `frontend-design` skill

**Generator:**
- Works sprint-by-sprint (or continuous on Opus 4.6+)
- Self-evaluates before handing to QA; uses git for version control

**Evaluator (QA):**
- Uses Playwright MCP to interact with live running application
- Grades against hardened criteria (design quality, originality, craft, functionality / product depth, visual design, code quality)
- Negotiates **sprint contract** with generator before each sprint: agreeing on "done" criteria before any code is written
- Files granular bug reports (27 criteria per sprint in one example)

### Key Design Insights

| Problem | Solution |
|---|---|
| Context anxiety (Sonnet 4.5) | Context resets — full clean slate + structured handoff artifact |
| Poor self-evaluation | Separate generator and evaluator agents; tune evaluator to be skeptical |
| Over-specified technical plans | Planner constrained to deliverables only; agents figure out implementation path |
| Evaluator leniency | Few-shot calibration examples with detailed score breakdowns |

## Frontend Design Criteria

Four grading criteria (weighted toward design quality + originality):
- **Design quality** — coherent whole; colors, typography, layout create distinct mood
- **Originality** — evidence of custom decisions vs. template defaults + AI slop (purple gradients over white cards = fail)
- **Craft** — technical execution: typography hierarchy, spacing, contrast
- **Functionality** — usability independent of aesthetics

## Opus 4.5 vs Opus 4.6 Harness Evolution

| Aspect | Opus 4.5 | Opus 4.6 |
|---|---|---|
| Context anxiety | Strong — context resets required | Largely resolved — compaction sufficient |
| Sprint structure | Required for coherence | Removable; Opus 4.6 runs 2+ hours coherently |
| Evaluator value | Load-bearing at every sprint | Only valuable for tasks at capability edge |

**Cost/Duration (DAW example with Opus 4.6 harness):**
- Planner: 4.7 min / $0.46
- Build Round 1: 2h 7min / $71
- QA Round 1: 8.8 min / $3.24
- Total: ~4 hours / $124.70

## Key Principles

> "Every component in a harness encodes an assumption about what the model can't do on its own, and those assumptions are worth stress testing."

> "Find the simplest solution possible, and only increase complexity when needed."

- When a new model lands: re-examine the harness, strip non-load-bearing components, add new pieces for greater capability
- The space of interesting harness combinations doesn't shrink as models improve — it *moves*

## Connections

- [[03-RESOURCES/concepts/agent-harness]] — extended: GAN-pattern as production harness design
- [[03-RESOURCES/concepts/claude-agent-harness-architecture]] — parent architecture concept
- [[03-RESOURCES/concepts/multi-agent-orchestration]] — three-agent planner/generator/evaluator pattern
- [[03-RESOURCES/concepts/context-engineering]] — context anxiety and context resets vs compaction
- [[03-RESOURCES/concepts/context-rot]] — context anxiety is the acute form during long tasks
- [[03-RESOURCES/concepts/agentic-harness-engineering]] — related engineering concept
- [[03-RESOURCES/entities/Claude-Opus-47]] — Opus 4.6 in harness; context anxiety resolved
- [[03-RESOURCES/concepts/claude-skills]] — frontend-design skill used by planner
