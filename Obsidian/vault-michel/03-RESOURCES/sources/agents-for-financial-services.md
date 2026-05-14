---
title: "Agents for Financial Services"
type: source
source_url: "https://www.anthropic.com/news/finance-agents"
author: Anthropic
published: 2026-05-05
created: 2026-05-09
tags: [financial-services, agents, anthropic, claude-cowork, managed-agents, microsoft-365, mcp, fintech, source]
---

# Agents for Financial Services

**Source:** [Anthropic News](https://www.anthropic.com/news/finance-agents) — 5 May 2026
**Author:** [[03-RESOURCES/entities/anthropic]]

Anthropic releases ten ready-to-run agent templates for financial services, Microsoft 365 add-in integrations, and new data connectors/MCP apps targeting banks, asset managers, and insurers.

## Key Use Cases (10 Agent Templates)

### Research and Client Coverage
| Agent | Function |
|-------|----------|
| **Pitch Builder** | Target lists, comparables, pitchbook drafts |
| **Meeting Preparer** | Client/counterparty briefs ahead of calls |
| **Earnings Reviewer** | Reads transcripts/filings, updates models, flags thesis changes |
| **Model Builder** | Creates financial models from filings and data feeds |
| **Market Researcher** | Tracks sector/issuer news, synthesizes broker research |

### Finance and Operations
| Agent | Function |
|-------|----------|
| **Valuation Reviewer** | Checks valuations vs. comparables and firm standards |
| **General Ledger Reconciler** | GL reconciliation and NAV calculations |
| **Month-End Closer** | Close checklist, journal entries, close reports |
| **Statement Auditor** | Reviews financials for consistency and audit-readiness |
| **KYC Screener** | Assembles entity files, reviews source docs, packages compliance escalations |

## Technical Patterns

### Agent Template Architecture
Each template packages three components:
1. **Skills** — instructions and domain knowledge for the task
2. **Connectors** — governed, real-time access to required data
3. **Subagents** — specialist Claude models called for sub-tasks (e.g. comparables selection, methodology checks)

### Two Deployment Modes
- **Plugin (Cowork/Code):** runs alongside the analyst on their desktop; output lands directly in Excel/PowerPoint/Outlook
- **[[03-RESOURCES/entities/Claude-Managed-Agents|Claude Managed Agent]]:** runs autonomously on the Claude Platform for nightly schedules or whole-book-of-deals scope; includes long-running sessions, per-tool permissions, managed credential vaults, and full audit log in Claude Console

### Microsoft 365 Integration
Claude add-ins for Excel, PowerPoint, Word (GA), and Outlook (coming soon). Context persists across all four apps — a model started in Excel carries forward into a PowerPoint deck without re-explanation. Dispatch (voice or text task assignment) available in [[03-RESOURCES/entities/Claude-Cowork]].

### Data Ecosystem (Connectors + MCP)
- **Existing:** FactSet, S&P Capital IQ, MSCI, PitchBook, Morningstar, Chronograph, LSEG, Daloopa
- **New connectors:** Dun & Bradstreet, Fiscal AI, Financial Modeling Prep, Guidepoint, IBISWorld, SS&C IntraLinks, Third Bridge, Verisk
- **New MCP app:** Moody's — proprietary credit ratings + data on 600M+ public/private companies

### Model Recommendation
Claude Opus 4.7 recommended for financial tasks; leads Vals AI Finance Agent benchmark at **64.37%**.

## Regulatory Considerations

- Users remain in the loop — reviewing, iterating, and approving before work goes to clients, is filed, or acted on
- KYC and compliance escalation workflows built into agent templates
- Audit log in Claude Console for every tool call and decision (compliance + engineering visibility)
- Per-tool permissions and managed credential vaults isolate sensitive credentials from agent sandboxes
- Governed access controls on all data connectors

## Distribution

Available at [financial services marketplace](https://github.com/anthropics/financial-services) as plugins (all paid plans) or Managed Agents (Claude Platform public beta).

## Related

- [[03-RESOURCES/entities/Claude-Cowork]]
- [[03-RESOURCES/entities/Claude-Managed-Agents]]
- [[03-RESOURCES/concepts/financial-services-agents]]
- [[03-RESOURCES/concepts/regulated-domain-agents]]
