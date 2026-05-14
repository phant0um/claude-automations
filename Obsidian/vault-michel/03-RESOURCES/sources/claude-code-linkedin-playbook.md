---
title: "The SaaS Founder's Guide to Claude Code on LinkedIn"
type: source
source_type: article
category: articles
hash: dbee4ede7e82a4a2daa5df2897f6a061
ingested: 2026-05-05
author: Gott Content
tags: [claude-code, linkedin, gtm, skills, saas, content-automation, subagents, mcp]
---

# The SaaS Founder's Guide to Claude Code on LinkedIn

**Author:** [[03-RESOURCES/entities/Gott-Content]]
**Category:** GTM / LinkedIn automation for SaaS founders

## Summary

Practical 8-section playbook for wiring Claude Code as the execution layer under a SaaS founder's full LinkedIn motion — content writing, lead qualification, DM personalization, reply triage, and lead magnet delivery — all running through reusable skills, MCPs, and Modal-deployed automations.

## Key Sections

### 1. Getting Set Up
- **Plan choice:** Claude Max removes Pro's mid-day usage ceiling; essential for full-day LinkedIn motion.
- **Install:** Mac/Linux via one `curl` command (Node 18+ required); Windows via WSL (avoid native PowerShell).
- **GUI option:** VS Code extension or Antigravity for founders who don't live in terminal.
- **`--dangerously-skip-permissions`** (bypass mode): enable after workflows are trusted; scope it to the LinkedIn sandbox folder.

### 2. The CLAUDE.md Brain File
The highest-leverage single file in the setup. Loaded every session before any action.

**What belongs in it (for LinkedIn):**
- ICP description in plain language (pull from sales call transcripts, their words)
- Offer, pricing, and competitor contrast
- Voice rules: sentence length, forbidden punctuation/words, energy constraints
- 10 best-performing hook patterns pasted in directly
- DM 3-sentence framework + opener style + soft opt-in CTA
- Active MCPs, skills, and reference files

**What stays out:** full post archive (→ separate reference file), full sales playbook (→ dedicated skill), company history.

**Auto-updating:** tell Claude "Add this rule to CLAUDE.md so you don't make this mistake again." Over 60 days it becomes a personalized voice profile.

### 3. Plan Mode
Toggle `/plan` before tasks that are public-facing or high-stakes. Plan mode shows a numbered execution plan for approval before acting.

**Use it for:** lead magnet posts, DM sequences, profile rewrites, first skill runs, batched weekly content.
**Skip it for:** single comment replies, quick tweaks, skills run 50+ times.

### 4. The Five Skills to Build First

| Skill | Input | Output |
|-------|-------|--------|
| **Content Writer** | idea + hook type + post format | Full post in your voice; ends "I don't have time to post" problem |
| **ICP Qualifier** | Sales Navigator lead list | Qualification score + personalized opener per qualified prospect |
| **DM Personalizer** | Qualified prospect + recent activity + DM structure | Personalized 3-sentence DM; drives 15–20% reply rate vs 2% generic |
| **Reply Triage** | Batch of DM replies | Classification + drafted response per category; inbox review ~10 min |
| **Lead Magnet Generator** | Client result + pain point + desired outcome | Post + Notion/PDF doc + DM template; fuels a month of inbound |

**Building a skill:** create `skills/skill-name/SKILL.md`. Top section = trigger description (specific phrases). Body = instructions as you'd onboard a hire. If Claude doesn't load it, the trigger description is too vague.

### 5. MCPs for the LinkedIn Stack
Worth installing: Gmail, Notion, Google Sheets, Slack, HubSpot/CRM.

**Token cost check:** every MCP loads its schema into context. 6 MCPs = 30–50K tokens burned before first message. After installing any MCP, check token count on a fresh session; if it jumped >5K tokens, decide whether it earns that daily.

**Converting MCPs to skills:** cuts token usage 50–100x for workflows run daily but not constantly. MCPs load always; skills load only when triggered. Example: `log-dm-to-notion` skill fires the Notion MCP only when explicitly invoked.

### 6. Sub-agents for Batching
Three cases where parallel agents pay off:
1. **Batching lead qualification:** 500 leads × 10 parallel agents → 12 min instead of 2 hours.
2. **Writing + critiquing in same session:** separate critic sub-agent with different instructions produces honest feedback.
3. **Parallel hook exploration:** 5 sub-agents each write same post with different hook types; compare and ship the best.

**Reliability math:** 10 parallel agents at 95% individual success = ~60% joint success (probabilities multiply). Build retry loops for critical tasks. For viral-candidate content: run two agents + a third comparing outputs.

### 7. Context Management
**What eats context before first message:** CLAUDE.md, all skill descriptions, all MCP schemas, system prompt, recently viewed files. On a loaded LinkedIn project = 30–40% consumed before typing.

**`/compact`:** summarizes conversation, retains compressed version. Use when batch-writing posts for an hour, after a DM batch before switching to qualifying leads, or before handing off to a sub-agent.

**`/clear`:** wipes context entirely. Use when switching task types (content → outbound), starting a new week fresh, or recovering from a derailed session. Rule: clear between task types, compact within them.

**Model selection:** main session (posts, DMs) → strongest model. Sub-agents doing narrow tasks (qualify, classify, summarize) → faster/cheaper model.

### 8. Modal Deployment
Turns any skill into a live URL in under 2 minutes. Enables VA-operated workflows with no Claude Code access.

**Use cases:**
- VA pastes Sales Navigator export → gets scored lead list with openers
- Chief of staff drops post idea → gets 3 hook variations + draft
- New DM reply triggers webhook → skill classifies, drafts response, Slack notification with one-click approval
- "sent" comment on lead magnet → Modal fires delivery skill automatically

**Deploy process:** skill → Claude Code wraps it in a Modal function → `modal deploy` → live URL → form/webhook on top. Keep forms to 3 fields max.

**Connecting to n8n/Make/Zapier:**
- New connection accepted → DM personalizer fires → drops in approval queue
- New lead magnet comment → delivery skill fires → DM + doc sent
- Positive reply → booking skill fires → calendar options in thread
- Every Monday → content writer generates 5 post drafts

## Concepts Linked
- [[03-RESOURCES/concepts/claude-skills]]
- [[03-RESOURCES/concepts/mcp-model-context-protocol]]
- [[03-RESOURCES/concepts/subagent-spawning]]
- [[03-RESOURCES/concepts/claude-code-workflow]]
- [[03-RESOURCES/concepts/content-automation-pipeline]]
- [[03-RESOURCES/concepts/context-window]]
- [[03-RESOURCES/concepts/linkedin-gtm-system]]

## Entities Linked
- [[03-RESOURCES/entities/Claude Code]]
- [[03-RESOURCES/entities/Gott-Content]]
- [[03-RESOURCES/entities/Modal]]
- [[03-RESOURCES/entities/vs-code]]
