---
title: agentmemory
type: entity
subtype: tool
tags: [agent-memory, coding-agent, persistence, mcp, benchmark, open-source]
created: 2026-05-31
github: https://github.com/rohitg00/agentmemory
npm: "@agentmemory/agentmemory"
author: rohitg00
ingested: 2026-05-16
updated: 2026-05-19
---

# agentmemory

Sistema de memória persistente para AI coding agents. Instalação única (`npm install -g @agentmemory/agentmemory`), roda como servidor local `:3111`, integra com qualquer agente via hooks, MCP ou REST. Todos os agentes compartilham o mesmo memory server — memória cross-agent, cross-session.

**Trending:** +1,879 GitHub stars em 2026-05-16. #1 persistent memory system para coding agents por benchmark.

## Resumo técnico

| Métrica | Valor |
|---|---|
| Retrieval R@5 (LongMemEval-S) | 95.2% |
| Token savings vs full context | 92% menos |
| MCP tools | 51 |
| Claude Code hooks | 12 (auto, zero config) |
| External DBs necessários | 0 (SQLite + iii-engine) |
| Testes passing | 950+ |

## Arquitetura

Built on **iii engine** (Rust, WebSocket `:49134`). Stack sem dependências externas: SQLite para persistência, iii-engine para execução, BM25+vector+graph para retrieval com RRF fusion.

### 4-Tier Memory Consolidation

| Tier | Analogia | Conteúdo |
|---|---|---|
| Working | Short-term | Raw tool use observations |
| Episodic | "O que aconteceu" | Sessões comprimidas |
| Semantic | "O que sei" | Fatos e padrões extraídos |
| Procedural | "Como fazer" | Workflows e decisões |

Decaimento por curva de Ebbinghaus. Contraditórias detectadas e resolvidas. Auto-eviction de memórias stale.

## Agentes suportados

Claude Code · Codex CLI · OpenClaw · Hermes · pi · Cursor · Gemini CLI · OpenCode · Cline · Goose · Kilo Code · Aider · Claude Desktop · Windsurf · Roo Code · OpenHuman · qualquer MCP client

## Comparação

Superior a mem0 (68.5% R@5), Letta/MemGPT (83.2% R@5) e CLAUDE.md nativo (sem retrieval real) em benchmarks LongMemEval-S.

## Instalação rápida (Claude Code)

```bash
npm install -g @agentmemory/agentmemory
agentmemory                          # :3111
# Em Claude Code:
/plugin marketplace add rohitg00/agentmemory
/plugin install agentmemory
```

Viewer em tempo real: `http://localhost:3113`

## Links

- [[03-RESOURCES/entities/rohitg00]] — autor
- [[03-RESOURCES/sources/memory-context-rag/agentmemory-persistent-coding-agent]] — source completo (README)
- [[03-RESOURCES/sources/memory-context-rag/rohitg00-agentmemory-persistent-llm-wiki]] — ingest anterior (stub)
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — contexto arquitetural
- [[03-RESOURCES/concepts/agent-systems/agent-memory-four-layers]] — 4 camadas de memória
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern]] — base intelectual (Karpathy)
- [[03-RESOURCES/entities/Cognee]] — alternativa (graph-vector, requer Qdrant)
- [[03-RESOURCES/entities/claude-mem]] — alternativa leve (SQLite + Chroma, sem MCP completo)
