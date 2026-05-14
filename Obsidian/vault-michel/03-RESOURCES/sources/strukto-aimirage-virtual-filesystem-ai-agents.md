---
title: "strukto-ai/mirage: A Unified Virtual Filesystem For AI Agents"
type: source
slug: strukto-aimirage-virtual-filesystem-ai-agents
source: "https://github.com/strukto-ai/mirage"
author: strukto-ai (org)
created: 2026-05-09
updated: 2026-05-09
tags: [ai-agents, virtual-filesystem, vfs, tool-abstraction, bash, agent-infrastructure, strukto]
---

# strukto-ai/mirage — A Unified Virtual Filesystem For AI Agents

**Mirage** is an open-source library by [[03-RESOURCES/entities/Strukto-AI]] that exposes every backend (S3, Google Drive, Slack, Gmail, Redis, GitHub, MongoDB, SSH, …) as a single Unix-style directory tree. AI agents navigate all services using a handful of bash-like commands instead of N SDKs.

## What AImirage Does

- **Single mount tree.** Every resource (`RAMResource`, `S3Resource`, `SlackResource`, `GDocsResource`, etc.) is mounted under `/path` in a `Workspace`. The agent issues `cat`, `cp`, `grep`, `find`, `ls` — all cross-resource.
- **Zero new vocabulary for LLMs.** Any model already trained on bash can use Mirage immediately; no new tool names or argument formats to learn.
- **Custom commands.** `ws.command('summarize', ...)` registers a new command available across all mounts. Commands can be scoped per resource + filetype (e.g., `cat` on a Parquet file renders rows as JSON).
- **Portable workspaces.** `ws.snapshot("demo.tar")` + `workspace load` let you clone, version, and transfer agent environments across machines with no reconfiguration.
- **Embedded SDKs.** Python (`mirage-ai`) and TypeScript (`@struktoai/mirage-node`, `@struktoai/mirage-browser`, `@struktoai/mirage-core`) let you embed a VFS inside FastAPI, Express, or any async runtime — no separate process.

## VFS Architecture

```
AI Agent / Application
        ↓
  Mirage Bash + VFS   ← single abstraction layer
        ↓
  Dispatcher & Cache  ← two-layer cache (Index + File; RAM or Redis backends)
        ↓
  Infrastructure & Remote  (S3, Slack, GDrive, GitHub, MongoDB, SSH …)
```

**Two-layer cache:**
- *Index cache* — directory listings/metadata; TTL-based (default 10 min). First `ls` hits the API; subsequent ones are free.
- *File cache* — object bytes; 512 MB RAM default or Redis for multi-process/serverless. First `cat` streams from origin; repeats are free.

Both layers are pluggable: swap `RAMFileCacheStore` for `RedisFileCacheStore`.

## Agent Framework Integration

Mirage drops into major agent frameworks without changing the mount surface:

| Framework | Integration point |
|---|---|
| OpenAI Agents SDK (Python) | `MirageSandboxClient` as sandbox |
| Vercel AI SDK (TypeScript) | `mirageTools(ws)` typed tool set |
| LangChain | adapter |
| Pydantic AI | adapter |
| CAMEL | adapter |
| OpenHands | adapter |
| Claude Code / Codex | lightweight CLI + daemon |

## Supported Resources (partial list)

RAM, Disk, Redis, S3/R2/OCI/Supabase/GCS, Gmail/GDrive/GDocs/GSheets/GSlides, GitHub/Linear/Notion/Trello, Slack/Discord/Telegram/Email, MongoDB, SSH.

## Installation

```bash
uv add mirage-ai           # Python ≥ 3.12
npm install @struktoai/mirage-node   # Node.js ≥ 20
curl -fsSL https://strukto.ai/mirage/install.sh | sh  # CLI
```

## Key Insight

The core thesis: LLMs are most fluent in bash/Unix semantics — that's the dominant corpus they trained on. Mirage turns that fluency into universal backend access. Instead of wiring N SDKs or M MCPs, the agent gets one surface it already knows. [[03-RESOURCES/concepts/agent-vfs-pattern]] captures the design pattern; [[03-RESOURCES/concepts/virtual-filesystem-llm]] covers the theoretical framing.

## Related

- [[03-RESOURCES/entities/Strukto-AI]] — org behind Mirage
- [[03-RESOURCES/concepts/agent-vfs-pattern]] — pattern: mount heterogeneous backends as one FS
- [[03-RESOURCES/concepts/virtual-filesystem-llm]] — why Unix semantics are LLM-native
- [[03-RESOURCES/concepts/ai-legible-backend]] — complementary: design backends for AI legibility
- [[03-RESOURCES/concepts/mcp-model-context-protocol]] — alternative integration layer Mirage replaces/reduces
- [[03-RESOURCES/concepts/agent-harness]] — Mirage functions as the tool/environment layer of a harness
