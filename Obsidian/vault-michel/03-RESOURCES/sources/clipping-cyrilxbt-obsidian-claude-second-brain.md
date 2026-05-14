---
title: "Post by @cyrilXBT — Obsidian + Claude: Second Brain That Thinks Back"
type: source
source_type: clipping
category: articles
ingested: 2026-05-05
tags: [obsidian, claude, second-brain, mcp, claude-code, productivity, knowledge-management]
---

# Post by @cyrilXBT — Obsidian + Claude: Second Brain That Thinks Back

## Summary

@cyrilXBT shares a 6-month experiment connecting Obsidian to Claude Code via MCP, reframing Obsidian from a note-taking app into an active "second brain that thinks back." The core insight is that without this setup, every Claude session starts from zero — re-explaining project context, voice, and patterns each time. By storing everything in local Markdown files and connecting Claude Code via MCP, the vault becomes a permanent memory layer that Claude reads and writes to in real time. The `CLAUDE.md` file loads automatically at the start of each session, eliminating cold-start overhead. After 90 days, the system creates compounding value: Claude finds connections between notes written months apart, revealing forgotten insights and building on accumulated context.

## Key Takeaways

- Every note (projects, ideas, journals, meetings, content) lives in local Markdown files — the vault is Claude's persistent memory
- Claude Code connects to the Obsidian vault via MCP, reading and writing files in real time — not pasting into chat
- `CLAUDE.md` in the vault root auto-loads on every session: who you are, active projects, voice, what to never do
- "Morning briefing" command: Claude reads yesterday's daily note + active projects + inbox → outputs 3 priorities, open loops, one decision to make before noon
- Vault becomes active, not passive — the more you use it, the more valuable it becomes as Claude surfaces cross-note connections
- Cold start problem (re-explaining everything each session) is the core pain this system solves

## Concepts Linked

- [[03-RESOURCES/concepts/second-brain]] — vault as external cognitive layer
- [[03-RESOURCES/concepts/mcp-model-context-protocol]] — Claude Code connects to Obsidian vault via MCP
- [[03-RESOURCES/concepts/claude-hooks]] — CLAUDE.md auto-load mechanism
- [[03-RESOURCES/concepts/hot-cache]] — daily briefing pattern as hot cache query
- [[03-RESOURCES/concepts/knowledge-compounding]] — compounding value of accumulated context

## Entities Linked

- [[03-RESOURCES/entities/Obsidian]] — the PKM tool being supercharged
- [[03-RESOURCES/entities/Claude Code]] — the CLI connecting to Obsidian via MCP
- [[03-RESOURCES/entities/cyrilXBT]] — author (@cyrilXBT on X)
