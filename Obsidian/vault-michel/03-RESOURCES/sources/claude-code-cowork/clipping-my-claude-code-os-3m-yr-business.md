---
title: "My Claude Code OS Runs my $3M/yr Business. Steal This."
type: source
created: 2026-05-01
updated: 2026-05-02
author: Nate Herkling (@nateherk)
source_url: "https://x.com/nateherk/status/2050116705322512766"
tags: [claude-code, ai-os, automation, business-framework, claude-code-architecture, context-connections-capabilities-cadence]
category: articles
triagem_score: 8
---

# My Claude Code OS Runs my $3M/yr Business. Steal This

**Author:** Nate Herkling (@nateherk)
**Published:** 2026-05-01
**GitHub Starter Repo:** https://github.com/nateherkai/AIS-OS

---

## Core Concept: The AI Operating System

An "AI OS" is a layer of intelligence managing your digital tools, files, context, and workflows—analogous to macOS or Windows, but running on an LLM + Claude Code harness.

**Value proposition:** One all-day Claude Code session is more productive than clicking through 30 different apps.

---

## The Three Ms (Mindset Habits)

Before touching any code, internalize three habits:

### 1️⃣ The Default Shift
**Principle:** Before any task, ask "how could AI do this, or at least 30% of it?"

**Example:** Instead of clicking through 300+ YouTube video descriptions, brainstorm with Claude Code to find an API path → automate in minutes.

### 2️⃣ The Function Breakdown
**Principle:** Your role is a tree of tasks. Break multi-step workflows into automatable chunks; each chunk is reusable.

**Example:** Don't automate "YouTube video." Automate ideation → scripting → packaging → descriptions → comment replies separately.

### 3️⃣ The Curiosity Rule
**Principle:** Never accept AI output without asking why. Treat AI as a mentor sharpening your judgment, not a vending machine dispensing answers.

---

## The Four Cs (Core Framework — Build in Order)

### 1. Context
**What AI knows about you:** Your team, tools, voice, money, priorities, constraints.

**Test:** Open a new Claude session. Ask a real business question. Does it answer like a teammate or a stranger? If stranger = zero context. Start here.

### 2. Connections
**What data it can reach:** APIs, MCPs, CLI bridges. Every revenue, customer, calendar, comms, task, meeting, knowledge source needs a connection.

**Mapping exercise:** Sketch seven tier-one domains on paper:
- Revenue (Skool, Stripe, QuickBooks)
- Customer (Skool, YouTube)
- Calendar (Google Workspace)
- Comms (Google Workspace, ClickUp, Slack)
- Tasks (ClickUp, Notion)
- Meetings (Fireflies)
- Knowledge (YouTube transcripts, Google Workspace, local files)

If you can't see your entire business in one diagram, your AI OS won't either.

### 3. Capabilities
**What it can produce:** Outputs dependent on context + connections. Without context, capabilities are generic. With context, they're personalized to your business.

### 4. Cadence
**When it acts autonomously:** Routines that run while you sleep, pulling from context + connections to produce capability-based outputs.

**Dependency:** Can't have cadence without connections. Can't have capability without context. Build in order: 1 → 2 → 3 → 4.

---

## Repo Anatomy (Starter Template)

Nate's GitHub template: https://github.com/nateherkai/AIS-OS

### Folder Structure

| Folder | Purpose |
|--------|---------|
| `.claude/skills/` | Reusable recipes. Ships with three: Audit, Level Up, Onboard |
| `Archives/` | Old documents you don't actively need (archive, don't delete) |
| `Contexts/` | Files like About Business, About Me, Priorities |
| `Decisions/` | Append-only log: date + reasoning + context for meaningful decisions |
| `References/` | External knowledge: API docs, SOPs, Three Ms manifesto |
| `claude.md` | Master prompt: who you are, how folders work, skill invocation, file locations |
| `.env` | Secrets file. API keys only. `.gitignore` prevents public push |

### Critical File: `claude.md`
- Evolves frequently (2x/day in Nate's setup)
- Source of truth for project structure, skill invocation, context references
- Updates as you add folders, skills, connections

---

## Onboarding (Day One)

1. Clone repo → open in VS Code → open Claude Code
2. Ask: "I want to set up my AI operating system. Help me get onboarded."
3. Claude invokes **Onboard skill** → 7-question interview
4. Output: About Me, About Business, Priorities, voice sample (if using Glaido)
5. Test: "What should I focus on this week?" → Claude pulls from three files just created

**Tip:** Answer with voice (Glaido) or paragraphs, not single sentences. Richer context = better outputs.

---

## Connecting Tools the Right Way (Day Two)

### 1️⃣ Create Separate AI Accounts
Don't give Claude Code your personal API key with full permissions.

**Example:** Created "Up at AI" account in ClickUp, ClickUp-specific API key only. Same for Stripe, QuickBooks, anywhere it touches money.

**Benefit:** Audit trail (see which automation spent what) + security isolation.

### 2️⃣ Prefer API Endpoints over MCP Servers
MCPs load every endpoint/function whether needed or not = token waste.

**Better approach:** Tell Claude: "Research the docs once. Save as markdown reference. Pull from that file when needed."

Markdown reads are cheap; API doc crawls are expensive.

### 3️⃣ Store Keys in `.env`, Never in Chat
- Tell Claude to create `.env` with placeholders
- You paste keys into file and save
- Never paste keys into chat history

### 4️⃣ Permission Progression: Plan → Auto → Bypass
- **Plan mode:** Brainstorming, no execution
- **Auto mode:** Safe tasks automatically, asks before risky
- **Bypass mode:** Full execution (default to bypass only after trust is proven)

---

## Key Gotchas & Learnings

1. **Expect a 20% productivity dip for 3–5 days** when implementing major changes. Most people quit during the dip. Don't.

2. **Tools deprecate every 6 months.** The Three Ms and Four Cs are durable; SDKs, models, endpoints change. Build on durable layer.

3. **Rich context beats model quality.** System design (context, cache, memory, tools, delegation) > model intelligence.

4. **Decision log is load-bearing.** When something matters, log: date + decision + reasoning + context. Prevents re-litigating the same calls.

---

## Related Concepts

- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]] — workflow orchestration
- [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]] — system automation
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-caching]] — token efficiency
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — context optimization
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — API + MCP integration strategy
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — delegation patterns

---

## Source

**Platform:** X/Twitter
**Author:** Nate Herkling (@nateherk)
**Original URL:** https://x.com/nateherk/status/2050116705322512766
**Archival Date:** 2026-05-01
