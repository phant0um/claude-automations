---
title: AImirage
type: entity
subtype: product
created: 2026-05-09
updated: 2026-05-09
tags: [ai-agents, virtual-filesystem, vfs, bash, agent-infrastructure, open-source]
---

# AImirage (mirage)

**"A Unified Virtual File System for AI Agents"** — open-source library by [[03-RESOURCES/entities/Strukto-AI]].

Mounts heterogeneous backends (S3, Slack, Google Drive, GitHub, Redis, MongoDB, SSH, Linear, Notion, Telegram, Discord, …) as a single Unix directory tree. Agents issue standard bash commands (`cat`, `cp`, `grep`, `find`, `ls`) across all services.

## Core Properties

- Zero new vocabulary — any LLM fluent in bash works out of the box
- Custom commands scoped per resource + filetype
- Two-layer cache (Index + File; RAM or Redis)
- Portable workspaces (`snapshot` + `load`)
- Python and TypeScript SDKs; embeddable, no daemon required
- Adapters for OpenAI Agents SDK, Vercel AI SDK, LangChain, Pydantic AI, CAMEL, OpenHands, Claude Code

## Install

```bash
uv add mirage-ai
npm install @struktoai/mirage-node
```

## Related

- [[03-RESOURCES/entities/Strukto-AI]] — org
- [[03-RESOURCES/sources/memory-context-rag/strukto-aimirage-virtual-filesystem-ai-agents]] — full source
- [[03-RESOURCES/concepts/agent-systems/agent-vfs-pattern]] — design pattern
- [[03-RESOURCES/concepts/pkm-obsidian/virtual-filesystem-llm]] — theoretical framing
- [[03-RESOURCES/concepts/dev-foundations/ai-legible-backend]] — complementary concept
