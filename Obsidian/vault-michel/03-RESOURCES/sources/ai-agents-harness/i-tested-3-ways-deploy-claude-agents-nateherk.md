---
title: "I Tested 3 Ways to Deploy Claude Agents (Here's When to Use Each)"
type: source
source_url: "https://x.com/nateherk/status/2055313067144065352"
author: "@nateherk"
platform: X/Twitter
published: 2026-05-15
ingested: 2026-05-15
tags: [claude-code, deployment, sub-agents, schedule, mcp, social-media]
triagem_score: 8
---

## Tese central

3 deployment methods for Claude Code skills/agents each trade off portability vs autonomy vs scale — right choice depends on whether workflow is session-scoped or cloud-native.

## WAT Framework

Every deployment lives on two axes: **where** (local vs cloud) × **how agentic** (deterministic vs autonomous loop).

**WAT** = W (workflow) + A (agent/reasoning layer) + T (tools). Some methods give all 3, some only W+T.

## Método 1 — Loop (Cron)

Easiest. Zero setup. Claude Code creates internal cron via `cron_create/list/delete`.

- **Scope:** session-scoped — cron dies if Claude Code process ends
- **Terminal advantage:** `/clear` does NOT kill cron (desktop: `/clear` kills it)
- **Pattern:** 2 loops — one running automation, one compacting context to survive long sessions
- **Best for:** quick personal automations while laptop stays on

## Método 2 — MCP Server

Persistent background service. Runs without laptop open.

- Deploy skill as MCP server → Claude calls it via tool protocol
- No session dependency; survives restarts
- **Best for:** integrations that need to be always-available (Slack bots, monitoring)

## Método 3 — Cloud (Modal / Trigger.dev / VPS)

Full scalability. Completely decoupled from local machine.

- Push workflow to cloud runner → fires on trigger or schedule
- **Best for:** high-volume automations, multi-user, production reliability

## Distinção crítica

`/loop` = session-scoped, stops when Claude Code closes. `/schedule` = true infrastructure, fires independently. See [[03-RESOURCES/concepts/claude-code-tooling/goal-command]] — "Claude as infrastructure" section.

## Deployment Decision Framework

When choosing among the three methods, answer two questions in order:

**Q1: Does this automation need to survive the laptop closing?** If no → Loop (cron) is sufficient and zero-config. If yes → MCP Server or Cloud.

**Q2: Does this automation need to scale beyond one user or handle high volume?** If no → MCP Server. If yes → Cloud.

This gives a clean decision tree: personal, session-scoped → Loop. personal, persistent → MCP. multi-user or high-volume → Cloud.

## Método 1 — Loop (Cron): Mechanisms

`cron_create` takes a schedule expression and a command to run. Inside Claude Code terminal mode, the cron process is owned by the session daemon, not the Claude Code desktop app process — this is why `/clear` behavior differs. The two-loop pattern (one for the automation, one for context compaction) reflects a real constraint: long-running sessions accumulate context that degrades reasoning quality. The compaction loop periodically summarizes and truncates the active context window, keeping the automation loop effective over hours.

Practical example: run a portfolio monitor every 15 minutes while the laptop is on. Use `cron_create("*/15 * * * *", "check_portfolio")`. Add a compaction loop at 60-minute intervals. This handles a full workday without context rot.

## Método 2 — MCP Server: Mechanisms

An MCP (Model Context Protocol) server exposes tools over a local socket or HTTP endpoint. Claude connects to it via the MCP tool protocol — the server is just another tool in the tool registry. The key difference from Loop is that the MCP server process runs independently of any Claude Code session. It starts on system boot (via launchd or systemd), listens for tool calls, and remains available whether or not Claude Code is open.

For always-on integrations (Slack bots, webhook receivers, monitoring sidecars), MCP is the right abstraction. The server handles authentication, rate limiting, and retry logic once, rather than per-session.

## Método 3 — Cloud: Mechanisms

Cloud deployment decouples the automation from the local machine entirely. Options include Modal (Python-native, GPU-friendly), Trigger.dev (event-driven, background jobs with full observability), and a plain VPS with a cron daemon. The trade-off is operational complexity: cloud runners require deployment pipelines, secrets management, and monitoring — costs that Loop and MCP avoid.

For production reliability and multi-user scenarios, this complexity is unavoidable. A Slack bot that 50 people depend on cannot run on one engineer's laptop.

## WAT Framework — Detailed Mapping

| Layer | Loop | MCP Server | Cloud |
|-------|------|-----------|-------|
| Workflow (W) | Yes | Yes | Yes |
| Agent reasoning (A) | Yes | Partial | Yes |
| Tools (T) | Session tools only | Server's tools | Full tool access |
| Persistence | Session-scoped | System-scoped | Indefinite |
| Scalability | 1 user | 1 user | N users |

The MCP case is "partial" for agent reasoning because the MCP server itself is stateless — it exposes tools but does not maintain an agent loop. The Claude session connecting to it provides the reasoning layer.

## /loop vs /schedule — Critical Distinction

`/loop` is a Claude Code meta-command that runs a prompt on a repeating interval within the current session. It stops when the session ends or when `/loop stop` is called. It is suitable for tasks that are meaningful only during an active work session (live monitoring, iterative refinement, context compaction).

`/schedule` (or its equivalents via Modal/Trigger.dev) is true infrastructure. It fires based on a cron expression, independently of any active Claude session. A scheduled task runs at 3am whether or not you are awake. It is appropriate for: nightly reports, weekly summaries, polling external APIs, and any automation that must survive the laptop being closed.

Conflating these two is the most common deployment mistake: building something as `/loop` that needs to be `/schedule`, then wondering why it stopped running.

## Vault Relevance

This three-method taxonomy maps directly to the vault's automation layer. The `ingest-report` agent (weekly synthesis of Clippings/) should be a scheduled task — it runs whether or not a Claude session is active. The wiki-lint cycle (checking for dead links, missing cross-references) can run as a Loop during active editing sessions. Long-running research tasks that need to persist across days belong in a proper scheduled infrastructure, not a session-scoped loop.

## Links

- [[03-RESOURCES/concepts/claude-code-tooling/goal-command]] — /loop vs /schedule distinction
- [[03-RESOURCES/concepts/claude-code-tooling/cowork-scheduled-automations]] — scheduled tasks depth
- [[03-RESOURCES/concepts/agent-systems/agent-harness]] — WAT maps to harness layers
- [[03-RESOURCES/entities/nateherk]]
