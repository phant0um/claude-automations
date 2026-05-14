---
title: "50 Claude Plugins & MCP Integrations That Most Users Don't Know"
type: source-summary
source_type: social-media-thread
author: "@eng_khairallah1"
source_url: "https://x.com/eng_khairallah1/status/2049784265613967730"
published: 2026-04-30
created: 2026-05-01
tags: [mcp, claude, integrations, connectors, plugins]
---

# 50 Claude Plugins & MCP Integrations

**Author:** @eng_khairallah1 (Khairallah AL-Awady)
**Signal:** Comprehensive catalog of Claude integrations — built-in connectors + MCP servers organized by domain.

## Three Integration Types

| Type | Install method | Config required |
|------|---------------|----------------|
| **Built-in Connectors** | Click in Desktop settings | None |
| **MCP Servers** | npm/pip + config file | Yes (5-10 min) |
| **Plugins** | Marketplace | Varies |

## Built-In Connectors (01-10)

Gmail, Google Calendar, Google Drive, Slack, Notion, OneDrive, SharePoint, Microsoft 365, Google Docs, Google Sheets.
No API keys. Click to enable in Claude Desktop.

## Essential MCP Servers (11-20)

| # | Server | What it does |
|---|--------|-------------|
| 11 | **Tavily** | Real-time web search; 4 tools: search/extract/crawl/map |
| 12 | **Context7** | Injects live library docs; add "use context7" to prompt |
| 13 | **Task Master AI** | PRD → structured tasks with dependencies |
| 14 | **GitHub MCP** | Read repos, issues, PRs |
| 15 | **Postgres MCP** | Direct DB queries (read-only recommended) |
| 16 | **Supabase MCP** | DB + auth + storage |
| 17 | **Linear MCP** | Issues, status, tasks |
| 18 | **Sentry MCP** | Error reports, stack traces, pattern detection |
| 19 | **Jira MCP** | Enterprise project management |
| 20 | **Confluence MCP** | Enterprise wiki search |

## Communication & Collaboration (21-28)

Discord, Teams, Telegram, Twilio (SMS/voice), Intercom, Zendesk, HubSpot, Salesforce.

## Development & DevOps (29-36)

Docker, Vercel, AWS (S3/CloudWatch/DynamoDB), Cloudflare, GitLab, npm, Playwright, Stealth Browser.

## Data & Analytics (37-42)

BigQuery, Snowflake, MongoDB, Airtable, Google Analytics, Mixpanel.

## File & Document (43-47)

Markdownify (PDF/image→markdown), Excel MCP, Firecrawl (site→LLM data), Dropbox, Box.

## Specialized (48-50)

| # | Tool | Purpose |
|---|------|---------|
| 48 | **FastMCP** | Build custom MCP servers in Python (one decorator) |
| 49 | **MCPHub** | Manage 10+ servers via HTTP |
| 50 | **Codebase Memory MCP** | Persistent knowledge graph of codebase across sessions |

## Recommended Power Stack (5 First)

1. Gmail + Google Calendar — daily operating view
2. Google Drive — frictionless file access
3. Tavily — real-time research
4. Slack or Microsoft 365 — team comms
5. GitHub or GitLab — code access

> "Covers 90% of knowledge work."

## MCP Install Steps

1. Find GitHub repo
2. `npm install` or `pip install`
3. Add server config to Claude config file
4. Restart Claude Desktop
5. Test with simple request

## Connections
- [[03-RESOURCES/entities/Khairallah-AL-Awady]] — author entity
- [[03-RESOURCES/concepts/mcp-model-context-protocol]] — MCP concept page
- [[03-RESOURCES/concepts/mcp-model-context-protocol]] — protocol details
- [[03-RESOURCES/concepts/claude-connectors]] — connectors overview
- Prior guide: [[03-RESOURCES/sources/mcp-servers-complete-guide-khairallah]]
