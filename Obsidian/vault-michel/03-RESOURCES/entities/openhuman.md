---
title: openhuman
type: entity
entity_type: product
created: 2026-05-16
updated: 2026-05-19
tags: [rust, local-ai, privacy, agent, self-hosted, open-source, tauri, sqlite]
---

# openhuman

**openhuman** is an open-source, local-first AI agent harness built by [[03-RESOURCES/entities/tinyhumansai]]. Written in Rust (desktop shell via Tauri + CEF), it runs entirely on-device with no mandatory cloud dependency. Stars at ingest: 10,724 (+3,329 spike on 2026-05-16).

**Repo:** https://github.com/tinyhumansai/openhuman
**License:** GNU GPL v3.0
**Status:** Early Beta

## Core Design Principles

1. **Privacy-first** — all workflow data stored locally, encrypted on-device; no cloud sync by default
2. **Local SQLite memory** — hierarchical memory trees in ≤3k-token Markdown chunks
3. **Karpathy-style Obsidian vault** — same `.md` chunks land in an Obsidian-compatible vault the user can browse and edit
4. **Thin one-subscription model** — built-in model routing (reasoning / fast / vision) eliminates BYOK sprawl
5. **TokenJuice compression** — up to 80% token/cost reduction on every tool call before LLM contact

## Key Features

| Feature | Detail |
|---------|--------|
| Memory Tree | Local SQLite + Markdown, Obsidian-compatible |
| Auto-Fetch | 20-min polling loop for all 118+ integrations |
| Integrations | 118+ via one-click OAuth (Gmail, Notion, GitHub, Slack, etc.) |
| TokenJuice | HTML→MD compression, URL shortening, up to 80% savings |
| Model Routing | reasoning / fast / vision, one subscription |
| Voice | STT in, ElevenLabs TTS out, mascot lip-sync |
| Meeting Agent | joins Google Meet as real participant |
| Local AI | optional Ollama backend for on-device inference |
| agentmemory | optional backend proxy shared with Claude Code / Cursor |

## Tech Stack

- **Core:** Rust 1.93.0 (`rustfmt` + `clippy`)
- **Desktop shell:** Tauri + CEF
- **UI:** Node.js 24+ / pnpm 10.10.0
- **Storage:** SQLite (local)
- **Build:** CMake, Ninja, ripgrep

## Trending Context

Trended on 2026-05-16 with +3,329 stars — the largest single-day spike across five trending repos that day. Featured on Product Hunt as top post of the day.

## Conexoes

- [[03-RESOURCES/entities/tinyhumansai]] — org criadora
- [[03-RESOURCES/entities/Hermes-Agent]] — categoria "personal agent platform" relacionada
- [[03-RESOURCES/sources/open-source-ecosystems/openhuman-local-ai-agent]] — fonte primaria
- [[03-RESOURCES/sources/misc-low-confidence/how-openhuman-works-and-how-to-set-it-up-in-5-minutes]] — setup guide (ingest 2026-05-19)
- [[03-RESOURCES/sources/open-source-ecosystems/tinyhumansaiopenhuman-your-personal-ai-super-intelligence-private-simple-and-ext]] — README repo (ingest 2026-05-19)
- [[03-RESOURCES/concepts/llm-ml-foundations/local-ai]] — executar AI completamente on-device
- [[03-RESOURCES/concepts/ai-strategy-org/privacy-first-ai]] — soberania de dados local
- [[03-RESOURCES/concepts/dev-foundations/rust-systems]] — Rust como linguagem de AI systems
- [[03-RESOURCES/concepts/agent-systems/agent-architecture]] — padrao harness + memory + tools
- [[03-RESOURCES/concepts/llm-ml-foundations/self-hosted-ai]] — infraestrutura AI self-hosted
- [[03-RESOURCES/entities/Andrej Karpathy]] — inspiracao (LLM Knowledgebase / Obsidian workflow)
