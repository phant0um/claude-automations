---
title: Modal
type: entity
categoria: ferramenta
website: https://modal.com
tags: [modal, deployment, serverless, automation, claude-code]
created: 2026-05-05
updated: 2026-05-19
---

# Modal

Serverless deployment platform that turns any Python function (or Claude Code skill) into a live HTTPS endpoint in under 2 minutes. Used in AI agent stacks to expose skills as URLs callable by VAs, webhooks, and automation platforms (n8n, Make, Zapier).

## Key Use Case: Skill Deployment

Claude Code wraps a working skill in a Modal function (writes the code automatically). One `modal deploy` command returns a live URL. Forms or webhooks sit on top of that URL — no Claude Code access required by the operator.

**Pattern:**
```
claude-skill → modal function → modal deploy → live URL → 3-field form / webhook
```

## LinkedIn GTM Applications
- VA submits Sales Navigator export → receives scored lead list with openers
- Chief of staff submits post idea → receives 3 hook variations + draft
- DM reply webhook → skill classifies + drafts response → Slack approval notification
- Lead magnet comment triggers → delivery skill sends doc + opener DM

## Related
- [[03-RESOURCES/concepts/ai-strategy-org/linkedin-gtm-system]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]
- [[03-RESOURCES/entities/Claude Code]]

## Sources
- [[03-RESOURCES/sources/ai-agents-harness/claude-code-linkedin-playbook]]
