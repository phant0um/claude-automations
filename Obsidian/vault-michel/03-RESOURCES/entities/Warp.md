---
title: Warp
type: entity
category: product/company
tags: [terminal, developer-experience, ai-agents, warp-terminal]
created: 2026-05-14
updated: 2026-05-14
---

# Warp

**Website:** warp.dev  
**Category:** Developer tools — AI-powered terminal

## About

Warp is a developer experience company best known for its AI-powered terminal. The team is also active in building internal AI agents for community management and developer relations.

## Warp's Buzz Agent

Buzz is Warp's internal social-listening and community engagement agent. It monitors thousands of mentions per month across Twitter, Reddit, LinkedIn, Bluesky, and other platforms. For each mention it decides whether to reply, like, note, or skip; if a reply is warranted it drafts one and posts it to Slack for human review.

Key design decisions:
- Principles-based skill (not rules-based)
- Slack emoji = feedback signal; no special tooling required
- Daily PR of skill updates; human reviews diff before merge
- Separate meta-learning skill that generalizes corrections into principles

Buzz runs on ~15 skills covering triage, drafting, learning, analytics, and reporting.

## Oz

Warp's internal agent management and orchestration platform (warp.dev/oz). Used to run Buzz in the background and trigger it via scheduled jobs or incoming mentions.

## Related Concepts

- [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]] — pattern pioneered at Warp
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — skill-as-code model Warp uses

## Sources

- [[03-RESOURCES/sources/ai-agents-harness/agents-need-feedback-loops-not-perfect-prompts]] — Petra Donka, 2026-05-14
