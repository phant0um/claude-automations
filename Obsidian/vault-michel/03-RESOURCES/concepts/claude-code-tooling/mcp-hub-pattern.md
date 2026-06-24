---
title: MCP Hub Pattern
type: concept
status: developing
tags: [mcp, claude, projects, productivity, orchestration, integrations]
created: 2026-05-09
updated: 2026-05-19
---

# MCP Hub Pattern

A Claude Projects configuration pattern where a dedicated project ("MCP Hub") holds a system prompt listing all active MCP connectors and instructing Claude to proactively select the relevant server per query — no manual specification needed.

## System Prompt Template

```
You are my personal AI assistant with access to the following live MCP connections.
Use them proactively whenever relevant — do not wait for me to specify which server to use.

[list each MCP and what it covers]

My role: [your role]
My primary tools: [apps you use most]
My priorities right now: [current projects]
Format all outputs clearly. Lead with the key insight or action. Never pad responses.
```

## Benefit

Eliminates "use my X MCP to do Y" boilerplate. Claude auto-routes queries to the correct server based on context.

## Extension: Vibe-Coded Dashboard

Using the same MCPs, Claude Code can build a `productivity-hub.html` — a live dashboard auto-refreshing every 5 min with panels for Notion tasks, Gmail, Calendar, Stripe revenue, Slack, and a Perplexity search input.

## Related

- [[03-RESOURCES/concepts/claude-code-tooling/mcp-server-curation]]
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]]
- [[03-RESOURCES/sources/skills-prompting-mcp/top-12-claude-mcps-complete-setup-guide]]
