---
title: "EverMind-AI/EverOS — Self-evolving Memory for Agents"
type: source
created: 2026-06-23
updated: 2026-06-23
source: "https://github.com/EverMind-AI/EverOS"
author: "EverMind-AI"
grade: B
tags: [ai-agents, memory, self-evolving, markdown, local-first, source]
---

# EverMind-AI/EverOS — Self-evolving Memory

**Tese central**: EverOS é uma Python library e local-first memory runtime que dá uma portable memory layer across coding assistants (Claude Code, Codex, OpenClaw, Hermes). Store conversations, files, agent trajectories como Markdown legível, synca SQLite + LanceDB para retrieval e self-evolving reuse.

## Diferenciação vs outras memory libraries

| Feature | EverOS | Outras |
|---------|--------|--------|
| Markdown source of truth | ✅ Canonical .md, editable, diffable, Git-versioned | ❌ API/vector/graph state |
| Direct file editing | ✅ Edit .md, cascade watcher syncs | ❌ SDK/API only |
| Local stack | ✅ Markdown + SQLite + LanceDB | ❌ Managed services |
| User + agent tracks | ✅ Separate first-class surfaces | ❌ Chat history only |
| Orthogonal retrieval | ✅ user_id, agent_id, app_id, project_id, session_id | ❌ App/namespace scoped |

## Arquitetura

- **Markdown canonical**: .md files são source of truth — readable, editable, diffable
- **SQLite + LanceDB**: local indexes sync from Markdown, fast retrieval
- **User episodes/profile** + **agent cases/skills**: separate tracks
- **OpenAI-protocol compatible**: OpenAI / OpenRouter / vLLM / Ollama / DeepInfra
- **Multimodal**: image/pdf/audio/office via everalgo-parser

## Features upcoming

- **Knowledge Wiki**: editable, source-backed Markdown knowledge pages from memory
- **Reflection**: idle-time/offline memory evolution — connects signals, compresses history, improves profiles/skills between sessions

## Por que importa para o vault

- **Paradigm mirror**: EverOS faz para agents externos o que vault-michel faz para Michel — Markdown as source of truth, local-first, self-evolving
- **Memory architecture**: 7-layer memory-os do Hermes vs EverOS tracks — comparative analysis valiosa
- **Reflection feature** = Hermes Dreaming — staged mutations with receipts
- **Cascade watcher**: quando .md editado, indexes re-syncam — equivalente ao hot.md update pattern
- **Portability**: "one portable memory layer for every agent" é o mesmo objetivo do vault com wikilinks

## Links

- [[03-RESOURCES/concepts/ai-agents/agent-memory-architecture]]
- [[03-RESOURCES/entities/Hermes-Agent]]
- [[04-SYSTEM/agents/nexus-agent-system/model-router]]