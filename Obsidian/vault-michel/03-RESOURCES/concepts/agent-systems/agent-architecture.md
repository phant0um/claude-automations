---
title: Agent Architecture
type: concept
status: developing
created: 2026-05-16
updated: 2026-05-19
tags: [agent, architecture, harness, memory, tools, routing, local-ai]
---

# Agent Architecture

**Agent Architecture** describes the structural patterns for building AI agents: how a harness, memory system, tool layer, and model routing are composed to create a durable, capable autonomous system.

> Note: the concept of a thin harness is covered in detail in [[03-RESOURCES/concepts/agent-systems/agent-harness]]. This page focuses on the broader compositional pattern across the full stack.

## Core Layers

```
User / Interface
       |
   Agent Harness (thin orchestrator)
   /        |         \
Memory    Tools    Model Router
 |                     |
SQLite/MD          LLM APIs
Obsidian          (local/cloud)
```

### 1. Harness (thin orchestrator)
Reads files, calls tools, writes logs, runs hooks. Does NOT reason — all intelligence in skill/memory files. Target: <200 LOC. See [[03-RESOURCES/concepts/agent-systems/agent-harness]].

### 2. Memory System
Four layers (see [[03-RESOURCES/concepts/agent-systems/agent-memory-four-layers]]):
- **Working** — volatile, current task state
- **Episodic** — what happened in prior sessions
- **Semantic** — compressed abstractions (memory trees)
- **Personal** — user-specific preferences and identity

### 3. Tool Layer
Typed interfaces per tool (filesystem, git, web search, scraper, APIs). Each integration exposed as a deterministic tool the LLM calls via structured output.

### 4. Model Router
Routes tasks to the right model: reasoning model for complex planning, fast model for tool calls, vision model for image tasks. See [[03-RESOURCES/concepts/agent-systems/agent-model-routing]].

## Key Design Decisions

| Decision | Implication |
|----------|-------------|
| Thin vs fat harness | Thin = portable; fat = brittle, model-coupled |
| Local vs cloud memory | Local = private, auditable; cloud = scalable |
| One-sub vs BYOK | One-sub = simpler UX; BYOK = cheaper at scale |
| Sync vs async tool calls | Sync = simpler; async = parallel tool execution |

## Reference Implementations

- [[03-RESOURCES/entities/openhuman]] — Rust-based; local SQLite memory; Obsidian vault; 118+ OAuth integrations; TokenJuice compression; built-in model router
- [[03-RESOURCES/concepts/agent-systems/agent-harness]] — canonical thin harness pattern
- [[03-RESOURCES/concepts/claude-code-tooling/claude-agent-harness-architecture]] — Claude Code's 5-layer architecture

## Conexoes

- [[03-RESOURCES/concepts/agent-systems/agent-harness]] — harness pattern detalhado
- [[03-RESOURCES/concepts/agent-systems/agent-memory-four-layers]] — memoria em 4 camadas
- [[03-RESOURCES/concepts/agent-systems/agent-model-routing]] — roteamento de modelos
- [[03-RESOURCES/entities/openhuman]] — implementacao de referencia
- [[03-RESOURCES/concepts/llm-ml-foundations/local-ai]] — backend de inferencia local
- [[03-RESOURCES/concepts/llm-ml-foundations/self-hosted-ai]] — implantacao self-hosted

## Evidências
- **[2026-06-19]** Capacidade de agente com ferramentas é limitada por como tools são compostas, não por quais tools existem — interface de ação é o gargalo — [[03-RESOURCES/sources/spatialclaw-rethinking-action-interface]]
