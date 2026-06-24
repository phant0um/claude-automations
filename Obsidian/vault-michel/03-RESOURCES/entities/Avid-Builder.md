---
title: Avid (@Av1dlive)
type: entity
created: 2026-04-25
updated: 2026-04-25
category: person
tags:
  - ai-agents
  - builders
---

# Avid (@Av1dlive)

**Twitter:** [@Av1dlive](https://x.com/Av1dlive)

**Known for:** Author of the AI Agent Stack architecture — a comprehensive guide to building agent systems with externalized memory, skills, and protocols.

## Contributions

### AI Agent Stack Architecture
- 3-month research and implementation project
- Built complete four-layer memory system (working, episodic, semantic, personal)
- Created thin harness conductor (~200 LOC)
- Developed skill framework with self-rewrite hooks
- Implemented dream cycle for automatic memory consolidation

### Key Insights
- Core principle: "You don't need to build your own model. You need to build the infrastructure around the model."
- Memory, skills, and protocols should be plain text in git — portable, versionable, owned by you
- The harness should be thin (reading files, calling tools) with all intelligence in skills and memory
- Progressive disclosure prevents context budget bloat

### Philosophy
- Bitter Lesson Engineering: write destinations and fences, not driving directions
- Skills should describe "what good looks like" not "how to do step by step"
- Memory layers need different retention policies and retrieval strategies
- Agent systems compound over time — consistency matters more than raw intelligence

## Key Resources

- **GitHub:** github.com/codejunkie99/agentic-stack — see [[agentic-stack-repo]]
- **Article:** "AI Agent Stack Everyone Must Use in 2026 (Builder's Guide)" (~4000 words)
- **Sources:** [[03-RESOURCES/sources/ai-agents-harness/ai-agent-stack-2026]], [[03-RESOURCES/sources/ai-agents-harness/ai-agent-stack-2026]]
- **Maxim (PT):** *"Se sua memória morre quando seu harness morre, você construiu o harness grosso demais."*

## Lessons from 90-Day Build

1. Write memory-manager on day one (not week 3)
2. Build four-layer memory separation from start
3. Create context-rich skills (destinations) not procedure-based
4. Build protocol layer on day one (not week 6)
5. Don't overload the harness — keep it thin
6. Progressive disclosure solves context budget bloat

## Platforms Supported
- Claude Code
- Cursor
- OpenClaw
- Any agent that reads markdown

## Related

- [[ai-agent-stack-2026]] — complete system design
- [[agent-harness]] — harness architecture
- [[agent-memory-four-layers]] — memory system
- [[03-RESOURCES/entities/Garry-Tan]] — inspired by his insight on harness vs brain separation

