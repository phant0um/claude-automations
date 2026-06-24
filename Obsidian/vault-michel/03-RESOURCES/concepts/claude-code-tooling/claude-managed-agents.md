---
title: Claude Managed Agents
type: concept
status: developing
created: 2026-04-27
updated: 2026-04-27
tags: [agents, anthropic, infrastructure, deployment]
---

# Claude Managed Agents

Anthropic's hosted agent execution platform. Abstracts infrastructure (servers, security, sandboxing). Users define agent job; Anthropic handles plumbing.

## Four Building Blocks

**Agent** — Job descriptor
- Model choice
- Agent instructions
- Tool access (web search, code execution, file operations)
- Like a detailed job description for a human assistant

**Environment** — Pre-loaded workspace
- Software & tools ready to use
- Like onboarding a new employee's laptop before day 1

**Session** — Persistent conversation thread
- Agent remembers everything within session
- Can work for hours
- Files persist between interactions

**Events** — Message loop
- Send: task/query
- Receive: status updates, interim results, approval requests

## Permission System

**Auto-run** — Agent executes all actions automatically
- Use: internal tools, trusted workflows
- Faster, no friction

**Approval-required** — Agent pauses before sensitive actions
- Use: client-facing, financial, deletion, external writes
- Gets risk-averse stakeholders to say yes: "drafts but won't send without your OK"

Can mix both modes in single agent: auto-read + auto-search, but approval before email/update.

## Pricing

Usage-based:
- **API tokens:** Standard Claude rates
- **Session runtime:** $0.08/hour of active agent runtime
- **Web search:** $10 per 1,000 searches

Typical 10-minute session: a few cents. Heavy usage rarely exceeds $100/month.

## Use Cases

**Internal:**
- Email draft assistant (read incoming, compose in your voice)
- Competitive monitoring + weekly digest
- Content agent (notes → finished blogs/social/newsletters)

**As service ($500–5K/month):**
- Client onboarding agents
- Multi-source report generators
- Customer support + escalation
- Document processors (extract → organize)
- Project management (Asana/Linear integration)

## Business Model

Non-technical founders can build AI services without hiring:

1. **Audit** ($999) — identify client's top time waster
2. **Build** — configure managed agent to solve it
3. **Deploy** — Anthropic infrastructure
4. **Recurring** — $500/month SaaS

4 clients = $2K/mo recurring, 10 = $5K/mo. Low maintenance overhead.

---

**Introduced:** 2026 (recent Anthropic announcement)  
**Key Barrier:** Dropped from "hire dev team" to "describe the job"  
**See Also:** [[Agent Skills]], [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol|mcp]], [[04-SYSTEM/agents/claude-code-agent]]
