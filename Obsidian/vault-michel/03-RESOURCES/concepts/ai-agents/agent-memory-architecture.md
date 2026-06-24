---
title: Agent Memory Architecture
type: concept
created: 2026-06-23
updated: 2026-06-23
tags: [concept, ai-agents, memory, architecture, local-first]
---

# Agent Memory Architecture

Padrões para dar memória persistente e portável a agents de IA.

## EverOS pattern

- **Markdown source of truth**: .md files canonical, readable, editable, diffable, Git-versioned
- **SQLite + LanceDB**: local indexes sync from Markdown
- **User episodes/profile** + **agent cases/skills**: separate tracks
- **Orthogonal retrieval**: user_id, agent_id, app_id, project_id, session_id
- **Cascade watcher**: edit .md → indexes re-sync

## Comparison: EverOS vs vault-michel

| Feature | EverOS | vault-michel |
|---------|--------|-------------|
| Source of truth | Markdown | Markdown |
| Local-first | ✅ | ✅ |
| Self-evolving | ✅ (Reflection feature) | ✅ (hill + Hermes Dreaming) |
| Portable across agents | ✅ (Claude Code, Codex, Hermes) | ✅ (wikilinks) |
| Index | SQLite + LanceDB | Obsidian + manifest |

## Evidências

- [[03-RESOURCES/sources/ai-agents/evermind-everos-self-evolving-memory]]

## Links

- [[03-RESOURCES/entities/Hermes-Agent]]
- [[04-SYSTEM/agents/nexus-agent-system/model-router]]