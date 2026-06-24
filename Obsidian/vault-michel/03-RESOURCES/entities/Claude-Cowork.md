---
title: Claude Cowork
type: entity
entity_type: Tool
created: 2026-04-25
updated: 2026-05-09
tags: [claude-cowork, anthropic, agentic-platform, knowledge-work, entity]
---

# Claude Cowork

**Type:** Tool — Agentic knowledge-work platform by [[03-RESOURCES/entities/anthropic]]

Available in the Claude Desktop app (paid plans). Built on the same architecture as Claude Code. Mode selector: Chat | Cowork | Code.

## What it is

Cowork shifts the interaction model from conversation to **delegation**. You describe an outcome; Claude plans the steps, executes them in an isolated environment on your machine, and delivers a finished file to your drive — not text to paste somewhere else.

## Core Capabilities

| Capability | Description |
|-----------|-------------|
| **Connectors** | Slack, Gmail, Google Drive, Calendar — set up once, referenced naturally in prompts |
| **File operations** | Read, edit, create real files (PPTX, XLSX, DOCX) saved directly to drive |
| **Plugins** | Domain expertise bundles: skills + connectors + subagents for a role |
| **Scheduled tasks** | Any task on a recurring cadence (hourly/daily/weekly) |
| **Subagents** | Parallel workstreams for independent task pieces |
| **Local computation** | Run code on files in-place; no upload/download cycle |
| **Claude in Chrome** | Reach pages without connectors (dashboards, portals) |

## Projects

A project wraps a folder with persistent Instructions and memory across sessions. Instructions panel content is read on every task from that project. Global instructions (Settings → Cowork → Global Instructions) apply across all tasks.

## Task Loop

1. Describe (input + transformation + output)
2. Claude asks clarifying questions
3. Execute (watch via progress panel, or step away)
4. Open finished file → treat as capable colleague's draft

## Safety Boundaries

- Isolated execution environment
- Controlled folder access (explicit grant required)
- Deletion gated (requires explicit approval)
- Conversation history stored locally

## Model Tiers

Opus (complex, high cost) · Sonnet (default) · Haiku (lightweight)

## Financial Services (May 2026)

Ten agent templates released as Cowork plugins for finance work (Pitch Builder, KYC Screener, Month-End Closer, etc.). Microsoft 365 add-ins (Excel, PowerPoint, Word GA; Outlook coming) allow context to persist across apps. Dispatch enables voice/text task assignment from anywhere. See [[03-RESOURCES/sources/financial-trading/agents-for-financial-services]] and [[03-RESOURCES/concepts/agent-systems/financial-services-agents]].

## Sources

- [[03-RESOURCES/sources/claude-code-cowork/introduction-to-claude-cowork]] — official Anthropic intro course
- [[03-RESOURCES/sources/claude-code-cowork/cowork-setup-guide-coreyganim]] — setup walkthrough
- [[03-RESOURCES/sources/claude-code-cowork/cowork-plugin-guide-coreyganim]] — plugins guide
- [[03-RESOURCES/sources/claude-code-cowork/cowork-obsidian-second-brain-rubenhassid]] — Obsidian integration
- [[03-RESOURCES/sources/claude-code-cowork/clipping-claude-cowork-ultimate-starter-pack-2026]]

## Related

- [[03-RESOURCES/concepts/claude-code-tooling/claude-cowork-plugins]]
- [[03-RESOURCES/concepts/claude-code-tooling/cowork-scheduled-automations]]
- [[03-RESOURCES/concepts/claude-code-tooling/cowork-slash-commands]]
