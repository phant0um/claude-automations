---
title: "Post by @cyrilXBT — Obsidian + Claude: Second Brain That Thinks Back"
type: source
source_type: clipping
category: articles
ingested: 2026-05-05
tags: [obsidian, claude, second-brain, mcp, claude-code, productivity, knowledge-management]
triagem_score: 9
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

- [[03-RESOURCES/concepts/pkm-obsidian/second-brain]] — vault as external cognitive layer
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — Claude Code connects to Obsidian vault via MCP
- [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]] — CLAUDE.md auto-load mechanism
- [[03-RESOURCES/concepts/pkm-obsidian/hot-cache]] — daily briefing pattern as hot cache query
- [[03-RESOURCES/concepts/pkm-obsidian/knowledge-compounding]] — compounding value of accumulated context

## Entities Linked

- [[03-RESOURCES/entities/Obsidian]] — the PKM tool being supercharged
- [[03-RESOURCES/entities/Claude Code]] — the CLI connecting to Obsidian via MCP
- [[03-RESOURCES/entities/CyrilXBT]] — author (@cyrilXBT on X)

## Why MCP Changes the Architecture Fundamentally

Without MCP, using Claude with Obsidian means manually copying note content into the chat window. This has two fatal limitations: the model only sees what you paste (no cross-note awareness), and it cannot write back to the vault without you copying output into a file manually. The feedback loop is broken.

With MCP, Claude Code holds a live file-system connection to the vault directory. It can:
- Read any note by path without you pasting it
- Search across all notes for a concept or phrase
- Write new notes directly to the correct folder
- Update existing notes (adding wikilinks, expanding sections, correcting claims)
- Read graph structure by scanning all `[[wikilinks]]` in the vault

The result is an agent that doesn't just answer questions about your notes — it actively maintains them.

## The CLAUDE.md Auto-Load as a Cold-Start Eliminator

The cold-start problem is the dominant friction in AI workflows: every new session requires re-establishing context. Who you are, what projects are active, what voice to use, what you never do. Rebuilding this context costs time and tokens on every session.

CLAUDE.md loaded at session start eliminates this overhead. The key design principle: CLAUDE.md should contain only what changes slowly (identity, active projects, global rules) not what changes daily (current task state, open loops). Daily-changing state belongs in the daily note, which the morning briefing command reads explicitly.

**Three-tier context architecture:**
1. `CLAUDE.md` (global, session-persistent): identity, active projects, voice, hard prohibitions
2. Hot cache / active projects note: current sprint, immediate priorities, recent decisions
3. Daily note (read on demand): yesterday's work, today's agenda, open loops

This maps cleanly to vault-michel's own structure: `CLAUDE.md` at vault root, `04-SYSTEM/wiki/hot.md` as the hot cache, and `05-DAILY/` for the daily log.

## The Compounding Value Mechanism

Linear note-taking accumulates information. The MCP-connected vault compounds knowledge. The distinction is structural: each new note added to a vault with active wikilinks becomes a node in a graph that prior notes can point to. Claude, reading the graph, can follow chains of related concepts.

Six months of accumulated context means:
- Claude can surface connections between a meeting note from March and a research paper from May without you asking
- Patterns across project notes (recurring obstacles, successful approaches) become visible
- Cross-domain insights emerge that no single note would surface individually

The compounding effect only works if wikilinks are maintained. Notes that sit as isolated files contribute linearly. Notes with outgoing and incoming wikilinks contribute to every future query that touches connected concepts.

## Morning Briefing Pattern — Implementation Details

The "morning briefing" command reads three sources and synthesizes them:
1. Yesterday's daily note — what was done, open loops, decisions made
2. Active projects note — current sprint commitments, blockers
3. Inbox (`00-INBOX/`) — new captures since last session

Output: three priorities for today, three open loops to resolve, one decision to make before noon. This is not a summary — it is an actionable brief that requires cross-source reasoning about what matters most.

The token cost is predictable and bounded: three short files, not the entire vault. The value is high because the synthesis happens across sources that you would read sequentially anyway.

## Comparison: Vault-Michel Implementation vs. @cyrilXBT Pattern

@cyrilXBT's setup (6-month experiment, CLAUDE.md at root) is structurally identical to vault-michel's architecture. The differences are scale and formalization:

| Dimension | @cyrilXBT | vault-michel |
|-----------|-----------|--------------|
| Agent layer | Claude Code + CLAUDE.md | 40+ specialized agents + Nexus orchestrator |
| Context management | Morning briefing command | hot.md + AGENTS.md + daily notes |
| Skill system | Not mentioned | Formal skills in `04-SYSTEM/skills/` |
| Memory persistence | CLAUDE.md + vault notes | Distributed across agent-specific memory files |

The core insight is shared: the vault is the persistent memory layer; the model is the reasoning layer; MCP is the bridge between them. Scale and formalization differ, not the fundamental architecture.
