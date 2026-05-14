---
title: "21 Things Most Claude Users Have Never Set Up"
type: source
source_type: clipping
category: articles
ingested: 2026-05-05
author: "@AnatoliKopadze"
platform: X/Twitter
tags: [claude-code, claude-md, prompt-engineering, productivity, setup]
---

# 21 Things Most Claude Users Have Never Set Up

**Author:** @AnatoliKopadze | **Published:** 2026-05-01

## Summary

Comprehensive guide to configuring CLAUDE.md for non-developers. Covers 21 behavioral instructions that eliminate repetitive corrections: kill filler phrases, show options before acting, admit uncertainty, match response length to task complexity, ask before big changes. Demonstrates that CLAUDE.md is not a developer-only tool — writers, marketers, researchers, and business owners all benefit from persistent session instructions.

## Key Takeaways
- CLAUDE.md eliminates "starting from zero" each session — Claude reads it automatically
- 21 instruction categories spanning communication style, behavior, and work quality
- Key instructions: no filler, show options, admit uncertainty, match length to task, checkpoint before changes
- File creation takes 2 minutes — start with 3-4 instructions that solve biggest frustrations
- Not developer-only: works for any Claude user who wants consistent outputs

## Developer Rules (16–21)

- Scope control: touch only explicitly requested files
- Confirm before destructive actions (delete, overwrite, migrations, deploys)
- Hard stops for: deploy/push to any env, migrations, external API calls
- Lock tech stack in CLAUDE.md to avoid unsolicited suggestions
- Post-task file-level summary of what changed
- Karpathy 4 rules (went viral, GitHub #1 trending): (1) Ask don't assume, (2) Simplest solution first, (3) Don't touch unrelated code, (4) Flag uncertainty explicitly — coding accuracy 65% → 94%

## Memory System

- MEMORY.md: log decisions with date/reasoning/rejected alternatives; read at session start
- ERRORS.md: log failures after 2+ attempts; check before suggesting similar approaches
- End-of-session summary: "session end" triggers structured write to MEMORY.md

## Permanent Context

- "About me" block calibrates depth of every response
- "What I'm working on" block provides project-level context
- "Permanent facts" block: constraints that apply to every session

## Key Takeaways
- CLAUDE.md eliminates "starting from zero" each session — Claude reads it automatically
- 21 instruction categories spanning communication style, behavior, and work quality
- Key instructions: no filler, show options, admit uncertainty, match length to task, checkpoint before changes
- File creation takes 2 minutes — start with 3-4 instructions that solve biggest frustrations
- Not developer-only: works for any Claude user who wants consistent outputs
- MEMORY.md + ERRORS.md = closest thing to real memory Claude currently has

## Concepts Linked
- [[03-RESOURCES/concepts/claude-folder-anatomy]]
- [[03-RESOURCES/concepts/prompt-engineering-patterns]]
- [[03-RESOURCES/concepts/context-engineering]]
- [[03-RESOURCES/concepts/claude-skills]]

## Entities Linked
- [[03-RESOURCES/entities/Claude Code]]
- [[03-RESOURCES/entities/Andrej Karpathy]]
