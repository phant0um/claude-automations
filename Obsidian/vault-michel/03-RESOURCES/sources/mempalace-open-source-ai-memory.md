---
title: "MemPalace — The Best-Benchmarked Open-Source AI Memory System"
type: source
source_url: https://github.com/MemPalace/mempalace
author: MemPalace
published: 2026-05-09
ingested: 2026-05-09
tags: [ai-memory, open-source, vector-search, rag, claude-code, mcp]
---

# MemPalace — The Best-Benchmarked Open-Source AI Memory System

GitHub: [MemPalace/mempalace](https://github.com/MemPalace/mempalace)
Docs: [mempalaceofficial.com](https://mempalaceofficial.com/)
PyPI: `pip install mempalace` / `uv tool install mempalace`

## O que é

[[03-RESOURCES/entities/MemPalace]] é um sistema de memória AI local-first: armazena histórico de conversas como texto verbatim e recupera via busca semântica. Sem sumarização, sem extração — conteúdo original, sempre.

A estrutura é hierárquica: **wings** (pessoas e projetos) → **rooms** (tópicos) → **drawers** (conteúdo original). A camada de retrieval é pluggável (padrão: ChromaDB).

Nada sai da máquina sem opt-in explícito.

## Benchmarks

**LongMemEval — R@5 (500 perguntas):**

| Modo | R@5 | Requer LLM? |
|------|-----|-------------|
| Raw (semantic search, sem heurísticas) | **96.6%** | Não |
| Hybrid v4 (held-out 450q) | **98.4%** | Não |
| Hybrid v4 + LLM rerank | ≥99% | Qualquer modelo |

O 96.6% raw não requer API key, nem cloud, nem LLM em nenhuma fase.

**Outros benchmarks:**

| Benchmark | Métrica | Score |
|-----------|---------|-------|
| LoCoMo (top-10, sem rerank) | R@10 | 60.3% |
| LoCoMo (hybrid v5, top-10) | R@10 | 88.9% |
| ConvoMem (250 itens, 5 categorias) | Avg recall | 92.9% |
| MemBench (ACL 2025, 8.500 itens) | R@5 | 80.3% |

## Quickstart

```bash
uv tool install mempalace
mempalace init ~/projects/myapp

# Minerar conteúdo
mempalace mine ~/projects/myapp
mempalace mine ~/.claude/projects/ --mode convos

# Buscar
mempalace search "why did we switch to GraphQL"

# Carregar contexto para nova sessão
mempalace wake-up
```

## Funcionalidades

- **Knowledge graph temporal** — entidade-relacionamento com janelas de validade; backend SQLite local
- **MCP server** — 29 ferramentas MCP: reads/writes, knowledge-graph, cross-wing navigation, agent diaries
- **Auto-save hooks** — dois hooks para Claude Code (periódico + antes de compressão de contexto)
- **Sweep** — `mempalace sweep <transcript-dir>` armazena um drawer por mensagem, idempotente

## Requisitos

- Python 3.9+
- Vector-store backend (ChromaDB padrão)
- ~300 MB disco para modelo de embedding padrão

## Contexto

> [!caution] Scam Alert
> Fontes oficiais: GitHub, PyPI, mempalaceofficial.com. Qualquer outro domínio (ex: `mempalace.tech`) é impostora.

> [!important] Claude Code sessions expiram em 30 dias sem auto-save hooks configurados.

## Relações

- [[03-RESOURCES/concepts/agent-memory-architecture]] — MemPalace é uma implementação de Layer 3 (vector) + estrutura hierárquica além do flat corpus
- [[03-RESOURCES/entities/claude-mem]] — alternativa com SQLite+Chroma; menos estruturada, mais simples
- [[03-RESOURCES/entities/Cognee]] — alternativa com graph-vector híbrido; foco em multi-hop queries
- [[03-RESOURCES/concepts/llm-wiki-pattern]] — padrão de construção de wiki via LLM
