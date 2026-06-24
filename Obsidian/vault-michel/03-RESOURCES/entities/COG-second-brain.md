---
title: "COG — Self-Evolving Second Brain"
type: entity
subtype: project
created: 2026-05-23
updated: 2026-05-23
tags: [second-brain, ai-agents, obsidian, open-source, skills-system]
---

# COG — Self-Evolving Second Brain

**COG** (Cognition + Obsidian + Git) is an open-source self-evolving second brain by [huytieu](https://github.com/huytieu). It layers 17 AI skills and 6 worker agents on top of plain markdown files, with no database or vendor lock-in.

- GitHub: https://github.com/huytieu/COG-second-brain
- License: MIT
- Latest stable: v3.5

## Architecture

- **17 skills** across Personal Knowledge, Team Intelligence, PM Workflow, and Strategic Research domains
- **6 worker agents** (all Sonnet) handling I/O; lead session (Opus) handles reasoning
- **People CRM** with tiered enrichment (Stub → Moderate → Full) adapted from [[03-RESOURCES/entities/Garry-Tan]]'s gbrain
- **Multi-platform:** full Claude Code surface; core Kiro + Gemini CLI surfaces; AGENTS.md universal fallback

## Design Principles

- Workers write results to `/tmp/`, return status + path only — eliminates slow token generation in agent output
- Framework files and personal content cleanly separated — safe updates
- 7-day freshness requirement on all sourced intelligence
- Self-healing cross-references on file renames

## Inspiration

Directly derived from [[03-RESOURCES/entities/Garry-Tan]]'s [gstack](https://github.com/garrytan/gstack) (specialist sessions, model routing) and [gbrain](https://github.com/garrytan/gbrain) (Compiled Truth, tiered people profiles).

## Related Concepts

- [[03-RESOURCES/concepts/agent-systems/harness-engineering]] — COG's skill/worker split is a harness pattern
- [[03-RESOURCES/concepts/agent-systems/agent-memory-layers]] — daily→weekly→monthly knowledge cycle
- [[03-RESOURCES/entities/Hermes-Agent]] — comparable agentic second-brain approach

## Source

[[03-RESOURCES/sources/pkm-obsidian-second-brain/huytieu-cog-second-brain]]
