---
title: Agno
type: entity
created: 2026-05-09
updated: 2026-05-09
tags: [framework, agent-platform, agentos, python, open-source, multi-agent]
---

# Agno

**Website:** https://agno.com | **Docs:** https://docs.agno.com
**UI:** https://os.agno.com
**Template:** `agno-agi/agentos-railway-template` (GitHub)

## What it is

Python framework for building unified agent platforms. Provides the `AgentOS` class that bundles runtime, storage, connectors, interfaces, and scheduler into a single deployable unit.

## Core Primitives

| Primitive | Description |
|---|---|
| `AgentOS` | Top-level platform object. Wraps agents, interfaces, scheduler. |
| Agents | Individual AI agents with tools, memory, model config. |
| Teams | Multi-agent routing: Coordinate / Route / Broadcast modes. |
| Workflows | Deterministic, repeatable processes (when agents need predictability). |
| Scheduler | Cron-based task runner built in. |
| Interfaces | Slack, Discord, Telegram, custom UI adapters. |

## Storage

Postgres for everything: sessions, memory, knowledge base, traces, eval history. Intentionally co-located so the improvement loop closes (trace data + iteration tool in same stack).

## Security

JWT-based token auth on by default. Per-request `user_id` and `session_id` injection. Admin vs user token RBAC.

## Deployment

Docker Compose (local) + Railway PaaS (prod). Auto-deploy from GitHub main supported.

## Related

- [[03-RESOURCES/entities/Ashpreet-Bedi]] — creator
- [[03-RESOURCES/concepts/agent-systems/agent-platform-architecture]]
- [[03-RESOURCES/sources/guides-courses-howtos/how-to-build-an-agent-platform]]
