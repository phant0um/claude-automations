---
title: "Post by @kidpakerot — Hermes + Claude + Higgsfield + ViralBuilder Video Ad Stack"
type: source
source_type: clipping
category: articles
ingested: 2026-05-05
tags: [hermes, claude, mcp, video-generation, ai-agents, creative-automation, ecommerce, skills]
triagem_score: 6
---

# Post by @kidpakerot — Hermes + Claude + Higgsfield + ViralBuilder Video Ad Stack

## Summary

@kidpakerot demonstrates a four-tool agentic stack for ecommerce video ad production: ViralBuilder (market research on winning ad styles) → Claude skill `video-prompt-builder` (translates a creative brief into a structured shot-by-shot prompt) → Higgsfield MCP (renders the video from the prompt) — all orchestrated from a single Claude Code session via Hermes as the context/memory/routing layer. The claim is that this reduces ecommerce ad production from a half-day process costing $500–$2,000 per creative to 10 minutes at subscription cost. The `video-prompt-builder` skill generates four output sections: shot-by-shot effect timeline, master effect inventory, effect density map, and energy arc — structured specifically for Higgsfield's rendering pipeline.

## Key Takeaways

- Hermes acts as the context layer: loads brand context, stores skills, handles routing rules — Claude always enters the session informed
- ViralBuilder (similar to Gethookd) provides a database of top-performing ecommerce video formats across platforms — replaces guessing with validated market data
- The `video-prompt-builder` Claude skill converts any creative briefing into a complete Higgsfield-ready prompt with no rewriting required
- Higgsfield MCP connects at `https://mcp.higgsfield.ai/mcp` via Claude Code → Settings → Connectors
- One chained prompt can trigger all four tools in a single session: research → brief → prompt → render
- Cost before stack: $500–$2,000/creative + 3+ hours. Cost after: tool subscriptions + 10 minutes
- The skill outputs 4 sections every time: effect timeline, effect inventory, density map, energy arc

## Concepts Linked

- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — `video-prompt-builder` is a SKILL.md-standard Claude skill
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — Higgsfield connected via MCP
- [[03-RESOURCES/concepts/agent-systems/agent-harness]] — Hermes as context/routing/memory harness layer

## Entities Linked

- [[03-RESOURCES/entities/Hermes-Agent]] — context layer and skill host running beneath Claude Code
- [[03-RESOURCES/entities/Claude Code]] — orchestrator and brain of the stack
- [[03-RESOURCES/entities/Higgsfield]] — AI video generation platform; MCP endpoint
- [[03-RESOURCES/entities/ViralBuilder]] — ecommerce video analytics and winning ad database
- [[03-RESOURCES/entities/kidpakerot]] — author (@kidpakerot on X)
