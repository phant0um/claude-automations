---
title: "How to Build an Agent Platform"
type: source
source_file: "clippings/How to Build an Agent Platform.md"
author: "@ashpreetbedi"
published: 2026-05-07
ingested: 2026-05-09
tags: [agent-platform, multi-agent, infrastructure, agent-runtime, agentic-architecture]
---

# How to Build an Agent Platform

**Source:** https://x.com/ashpreetbedi/status/2052413981487427871
**Author:** [[03-RESOURCES/entities/Ashpreet-Bedi]] ([@ashpreetbedi](https://x.com/ashpreetbedi))
**Published:** 2026-05-07

## Thesis

Every company building a fleet of agents needs an **agent platform** — a unified OS-like system that runs agents, collects data, manages security, and enables recursive self-improvement. Stitching multiple vendors (separate trace tools, memory services, orchestration layers) reproduces the painful unbundling of the data era. Owning the stack is what closes the improvement loop.

> "The agents you ship today are the smallest part of what you've built. The platform underneath them, and the iteration loop it enables, is the thing that matters."

## Platform Layers (5 components)

| Layer | Role |
|---|---|
| **Runtime** | Service that runs agents — heavy lifting. FastAPI + Docker. |
| **Storage** | Postgres: sessions, memory, knowledge, traces, eval history. |
| **Connectors** | Tools via MCP, API, or CLI in one place (security boundary). |
| **Interfaces** | Slack, Discord, Telegram, custom UIs. Unified user identity across surfaces. |
| **Infrastructure** | Docker (local) / Railway (prod, ~$20/mo). |

Implementation: [[03-RESOURCES/entities/Agno]] framework, `AgentOS` class. Template: `agno-agi/agentos-railway-template`.

## Orchestration Modes (beyond single agents)

- **Coordinate** — leader decomposes, calls specialists, synthesizes.
- **Route** — router picks one specialist per request.
- **Broadcast** — all specialists run in parallel, aggregated.

Rule: *agents for open questions, teams for routing, workflows for processes.*

## Recursive Improvement Loop

1. Run agent live on platform.
2. Claude Code hits live agent via curl.
3. Traces in Postgres are readable by Claude Code.
4. Claude Code iterates agent code.
5. Evals (`evals/cases.py`) lock in behavior — run on schedule, fail on drift.

Key insight: the loop only closes because **trace data and iteration tool share the same stack**. Vendor-stitched setups split this surface and the loop never closes.

## Security Model

- JWT-based token auth ON by default.
- Per-request identity: `user_id`, `session_id` injected from token.
- Granular RBAC: user tokens vs admin tokens.
- Rationale: auth-off defaults get deployed to public internet and stay there.

## Opinions / Recommendations

- Don't split data across 3 providers — you lose the auto-improvement loop.
- Data sovereignty: traces in your own DB = compliance + iteration capability.
- Railway for fast/cheap hosting; auto-deploy from GitHub main.
- Non-technical users: no-code UI at `os.agno.com`.
- Scheduled evals weekly in production — catch drift before users feel it.

## Conexoes

- [[03-RESOURCES/concepts/agent-platform-architecture]] — five-layer model extracted here
- [[03-RESOURCES/concepts/agent-evaluation-production]] — evals as regression tests, eval_db pattern
- [[03-RESOURCES/concepts/multi-agent-orchestration]] — coordinate/route/broadcast modes
- [[03-RESOURCES/entities/Agno]] — framework providing AgentOS, teams, workflows
- [[03-RESOURCES/entities/Ashpreet-Bedi]] — author, ex-cloud/data platform builder
