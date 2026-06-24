---
title: Agent Platform Architecture
type: concept
status: developing
created: 2026-05-09
updated: 2026-05-09
tags: [agent-platform, infrastructure, agent-runtime, agentic-architecture, multi-agent, observability]
---

# Agent Platform Architecture

An agent platform is the OS-like system that runs a fleet of agents. The defining property is **unification**: trace data, agent code, storage, and iteration tooling co-located in one stack, enabling a closed recursive improvement loop.

## Five-Layer Model

| Layer | Responsibility |
|---|---|
| **Runtime** | Executes agents. FastAPI service; does most heavy lifting. |
| **Storage** | Postgres: sessions, memory, knowledge, traces, eval history. |
| **Connectors** | External integrations (MCP, API, CLI) in one place — security boundary. |
| **Interfaces** | User surfaces (Slack, Discord, Telegram, custom UI). Unified identity. |
| **Infrastructure** | Docker (local), Railway / cloud PaaS (prod). JWT auth by default. |

## The Recursive Improvement Loop

```
live agent → traces → Postgres → Claude Code reads traces
                                       ↓
                              iterates agent code
                                       ↓
                              evals catch regression
```

This loop only closes when trace data and the iteration tool share the same stack. Stitched vendor setups (separate trace SaaS + separate memory SaaS) break it.

## Multi-Agent Patterns

Within the platform, single agents can be composed into **teams**:
- **Coordinate** — leader plans and delegates to specialists.
- **Route** — router picks one specialist per request.
- **Broadcast** — all specialists run in parallel, results aggregated.

Rule of thumb: *agents for open questions, teams for routing, workflows for processes.*

## Evals as Platform Primitives

Evals are regression tests for agents. Defined as `Case` objects with `input`, `criteria`, `expected_tool_calls`. Run on a cron schedule against production; results stored in Postgres. Drift shows up in eval history before users feel it.

## Data Sovereignty Rationale

1. **Compliance** — customer data in your DB, not a third-party trace tool.
2. **Auto-improvement** — traces only readable by iteration tool when co-located.

## Cautionary Pattern (avoid)

The data era "great unbundling" — separate tools for ingestion, orchestration, transformation, BI, data quality — consumed 80% of engineering time on glue. Agent platforms risk the same if vendors sell features as products prematurely.

## References

- [[03-RESOURCES/sources/guides-courses-howtos/how-to-build-an-agent-platform]] — primary source, [[03-RESOURCES/entities/Ashpreet-Bedi]]
- [[03-RESOURCES/entities/Agno]] — reference implementation
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — decomposition and delegation patterns
- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]] — evaluation frameworks in production

## Evidências
- **[2026-06-19]** eve embute produção (durable execution, sandboxed compute, aprovações, sub-agentes, evals) por padrão em vez de adicionar depois do prototype — [[03-RESOURCES/sources/introducing-eve-open-source-agent-framework]]
- **[2026-06-19]** Agente que autora suas próprias skills duráveis e as registra no orchestration engine — hot-deploy sem restart, skills sobrevivem ao processo que as criou — [[03-RESOURCES/sources/the-agent-loop-architecture]]
- [[03-RESOURCES/sources/overview-1]] — eve frontend integration model: same-origin, hooks abstraem streaming e session state
- **[2026-06-24]** Eve é framework open-source da Vercel onde agent = diretório. Production built-in: durable execution, sandbox, HITL... — [[introducing-eve-vercel]]
- **[2026-06-24]** withEve() wrap Next.js config para rodar agente + app como 1 projeto — same-origin, sem CORS, cookie auth automática,... — [[next-js-eve-integration]]
- **[2026-06-24]** 3 peças para deploy eve agent: React UI (useEveAgent), channel auth (replace placeholderAuth), deploy Vercel. Web... — [[ship-it-eve-deploy]]
