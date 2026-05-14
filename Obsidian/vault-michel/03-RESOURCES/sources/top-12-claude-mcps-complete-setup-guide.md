---
title: "Top 12 Claude MCPs (Complete Setup Guide)"
type: source
source_file: "clippings/Top 12 Claude MCPs (Complete Setup Guide).md"
author: "@aiedge_"
ingested: 2026-05-09
tags: [mcp, claude, setup-guide, integrations, top-list, productivity]
---

# Top 12 Claude MCPs (Complete Setup Guide)

Source: https://x.com/aiedge_/status/2052044036735897826 — published 2026-04-15 by @aiedge_ (aiedgehq.co)

MCPs as "bridges" between AI and external data sources — connect Claude to real-time data, enable prompting over live tool data, and take actions inside those tools.

## Setup Methods

**Method 1 — Connectors (easiest):** Claude → Customize → Connectors. Official Anthropic-partnered servers (Google, Slack, Notion, etc.) connect in seconds.

**Method 2 — Claude Code config:** `claude mcp add` in Claude Code, paste server URL, supply API key. For full auto-setup: prompt Claude Code `"I want to install [MCP], find the connection and help me setup A-Z."`

---

## The 12 MCPs

### Category 4: Productivity

| # | MCP | One-line | Setup notes |
|---|-----|----------|-------------|
| 12 | [[03-RESOURCES/entities/Slack-MCP]] | Full workspace access — search messages, post, read channels | Official Anthropic Connector |
| 11 | [[03-RESOURCES/entities/Notion-MCP]] | Read/write pages, databases, CRMs; send chat output to Notion | Official Anthropic Connector |
| 10 | [[03-RESOURCES/entities/Zapier-MCP]] | 9,000+ connected apps; query HubSpot, Sheets, etc. via Claude | Useful only if already on Zapier; Connector available |

### Category 3: Google Suite

| # | MCP | One-line | Setup notes |
|---|-----|----------|-------------|
| 9 | [[03-RESOURCES/entities/Google-Drive-MCP]] | Prompt over all Drive files — Docs, Sheets, search & write | Official Connector |
| 8 | [[03-RESOURCES/entities/Gmail-MCP]] | Read threads, attachments, metadata; draft replies | Official Connector |
| 7 | [[03-RESOURCES/entities/Google-Calendar-MCP]] | Create/decline events, generate briefs, block focus time | Official Connector; combine all 3 Google MCPs for full ecosystem |

### Category 2: Creative

| # | MCP | One-line | Setup notes |
|---|-----|----------|-------------|
| 6 | [[03-RESOURCES/entities/Excalidraw-MCP]] | Claude draws hand-drawn-style diagrams and flowcharts on demand | Less known; setup via Claude Code |
| 5 | [[03-RESOURCES/entities/Figma-MCP]] | Read Figma files; generate React components from designs | Official partner |
| 4 | [[03-RESOURCES/entities/Canva-MCP]] | Produce visual content at scale — presentations, templates | Official Connector; partially superseded by Claude Design |

### Category 1: Finance

| # | MCP | One-line | Setup notes |
|---|-----|----------|-------------|
| 3 | [[03-RESOURCES/entities/TradingView-MCP]] | Live chart data and technical analysis inside Claude | Claude Code setup; dedicated guide by author |
| 2 | [[03-RESOURCES/entities/Perplexity-MCP]] | Real-time market data, news, deep research | Connection: https://docs.perplexity.ai/docs/getting-started/integrations/mcp-server |
| 1 | [[03-RESOURCES/entities/Stripe-MCP]] | Revenue overview, subscription intel, failed payment analysis | Claude Code setup; high value for digital product sellers |

### Honorable Mentions
Similarweb, Monday, ClickUp, Zoom, Granola, Gamma, n8n, Indeed.

---

## Usage Patterns

**Normal prompting** — `"Use my [X] MCP to do [Y]."` — sufficient for ad-hoc tasks.

**MCP Hub Project** — dedicated Claude Project with system prompt listing all connectors; Claude auto-selects relevant servers per query.

**Vibe-coded dashboard** — use Claude Code + all MCPs to build a single `productivity-hub.html` with live panels (Notion tasks, Gmail inbox, Calendar, Stripe revenue, Slack, Perplexity search bar). Auto-refreshes every 5 min.

---

## Conexoes

- [[03-RESOURCES/concepts/mcp-model-context-protocol]] — protocol underpinning all these servers
- [[03-RESOURCES/concepts/mcp-server-curation]] — curation and selection criteria for MCP stacks
- [[03-RESOURCES/concepts/mcp-hub-pattern]] — "MCP Hub" Project pattern for proactive multi-server orchestration
- [[03-RESOURCES/entities/Perplexity-AI]] — Perplexity as MCP source for real-time research
- [[03-RESOURCES/entities/TradingView-MCP]] — finance-specific MCP detail
