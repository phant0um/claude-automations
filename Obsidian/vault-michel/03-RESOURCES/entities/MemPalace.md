---
title: MemPalace
type: entity
category: tool / open-source library
tags: [ai-memory, vector-search, local-first, mcp, open-source, python, claude-code]
created: 2026-05-09
updated: 2026-05-19
---

# MemPalace

Repositório: [github.com/MemPalace/mempalace](https://github.com/MemPalace/mempalace)
Docs: [mempalaceofficial.com](https://mempalaceofficial.com/)
PyPI: `mempalace`

Sistema de memória AI **local-first** de código aberto. Armazena histórico de conversas como texto verbatim e recupera via busca semântica estruturada — sem sumarização, sem chamadas de API obrigatórias.

## Diferencial arquitetural

Enquanto soluções como Mem0, Mastra ou Zep sumarizam/extraem, MemPalace preserva o texto original e organiza via hierarquia semântica:

- **Wings** — pessoas e projetos
- **Rooms** — tópicos dentro de um wing
- **Drawers** — conteúdo verbatim original

A camada de retrieval é pluggável: ChromaDB por padrão; interface definida em `mempalace/backends/base.py`.

## Benchmarks (destaque)

| Benchmark | Score | LLM necessário? |
|-----------|-------|-----------------|
| LongMemEval R@5 raw | **96.6%** | Não |
| LongMemEval R@5 hybrid held-out | **98.4%** | Não |
| LoCoMo hybrid v5 R@10 | **88.9%** | Não |
| MemBench (ACL 2025) R@5 | **80.3%** | Não |

O pipeline raw (96.6%) funciona com zero API key, zero cloud, zero LLM.

## Componentes

- **CLI** — `mempalace mine`, `mempalace search`, `mempalace wake-up`, `mempalace sweep`
- **Knowledge graph** — grafo temporal entidade-relacionamento com janelas de validade; SQLite local
- **MCP server** — 29 ferramentas MCP para reads/writes, navegação cross-wing, diários de agentes
- **Auto-save hooks** — integração nativa com Claude Code (salva periodicamente + antes de compressão)

## Instalação

```bash
uv tool install mempalace   # recomendado
# ou: pip install mempalace
```

Requisitos: Python 3.9+, ~300 MB disco (modelo embedding padrão).

## Segurança

Dados ficam na máquina local. Opt-in explícito para qualquer saída de dados.

> [!caution] Fontes oficiais únicas: GitHub, PyPI, mempalaceofficial.com. O domínio `mempalace.tech` é impostora/malware.

## Relação com o vault

- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — implementa Layer 3+ com hierarquia estruturada
- [[03-RESOURCES/entities/claude-mem]] — alternativa mais simples (SQLite+Chroma flat)
- [[03-RESOURCES/entities/Cognee]] — alternativa com foco em graph multi-hop
- [[03-RESOURCES/sources/memory-context-rag/mempalace-open-source-ai-memory]] — fonte completa
