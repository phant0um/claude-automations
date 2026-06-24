---
title: LinkedIn GTM System (Claude Code)
type: concept
status: developing
created: 2026-05-05
updated: 2026-05-05
tags: [linkedin, gtm, saas, claude-code, content, outbound, pipeline]
---

# LinkedIn GTM System (Claude Code)

A structured approach to using [[03-RESOURCES/entities/Claude Code]] as the execution layer for an entire LinkedIn go-to-market motion — replacing 5+ hours of daily manual work with a skill-driven, semi-autonomous system.

## Core Problem Solved

Consistent LinkedIn presence requires ~6 hours/day (posting, outreach, DM management, lead magnets). Founders abandon it around week 6. Claude Code changes the math by handling execution while the founder stays in the approval seat.

## System Architecture

```
CLAUDE.md (brain file)
    ↓
Skills (5 core)
    ↓
MCPs (Gmail, Notion, Sheets, Slack, CRM)
    ↓
Sub-agents (parallel batching)
    ↓
Modal (deployment → VA-accessible URLs)
    ↓
n8n / Make / Zapier (trigger automation)
```

## The Five Core Skills

1. **Content Writer** — voice-matched post drafting from a rough idea + hook type + format
2. **ICP Qualifier** — scores Sales Navigator leads against ICP criteria; produces personalized openers
3. **DM Personalizer** — 3-sentence DMs referencing prospect-specific activity; drives 15–20% reply rates
4. **Reply Triage** — classifies inbox replies + drafts category-appropriate responses; 45 min → 10 min
5. **Lead Magnet Generator** — post + asset doc + delivery DM from one client result

## CLAUDE.md as Voice Profile

The brain file holds ICP description, offer + competitor contrast, voice rules, top 10 hook patterns, and DM framework. Auto-updated via "Add this rule to CLAUDE.md" commands. Compounds into a precise voice profile over 60–90 days.

## Token Economics

- 6 MCPs = 30–50K tokens consumed before first message
- Converting MCPs to skills cuts that cost 50–100x for workflows run daily but not constantly
- 30–40% of context window consumed before first prompt on a loaded project

## Reliability Math for Sub-agents

If one agent succeeds 95% of the time, 10 parallel agents succeed together ~60% of the time. Always build retry loops; for high-stakes content run two agents + a third comparator.

## Modal Deployment Pattern

```
Skill → Claude Code wraps in Modal function → modal deploy → live URL
→ 3-field form / webhook → VA or automation trigger
```

## Related
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]
- [[03-RESOURCES/concepts/agent-systems/subagent-spawning]]
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]]
- [[03-RESOURCES/concepts/ai-strategy-org/content-automation-pipeline]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-window]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]]
- [[03-RESOURCES/entities/Claude Code]]
- [[03-RESOURCES/entities/Modal]]
- [[03-RESOURCES/entities/Gott-Content]]

## Sources
- [[03-RESOURCES/sources/ai-agents-harness/claude-code-linkedin-playbook]]
