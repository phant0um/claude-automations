---
title: "MemPalace — The Best-Benchmarked Open-Source AI Memory System"
type: source
source_url: https://github.com/MemPalace/mempalace
author: MemPalace
published: 2026-05-09
ingested: 2026-05-09
tags: [ai-memory, open-source, vector-search, rag, claude-code, mcp]
triagem_score: 7
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

## Como funciona a busca semântica verbatim

O design de preservar conteúdo original sem sumarização é uma escolha deliberada contra uma tendência comum: sistemas de memória que sumarizam conversas antes de armazenar. O problema com sumarização:

- Perde detalhes específicos que podem ser críticos em contextos futuros
- Introduce viés do modelo de sumarização (o que o modelo considerou relevante pode não ser o que o usuário precisará mais tarde)
- Torna o recall não-determinístico — perguntar "o que exatamente eu disse sobre X?" retorna a sumarização, não o texto original

MemPalace armazena o texto verbatim e indexa separadamente para retrieval semântico. Quando a query de retrieval encontra um drawer relevante, o conteúdo retornado é o original não modificado. O score de 96.6% R@5 sem LLM valida que embeddings semânticos são suficientes para retrieval de alta precisão sem precisar de reranking custoso.

## A estrutura hierárquica wings → rooms → drawers

A metáfora de palácio da memória (memory palace / method of loci) não é só estética — ela impõe estrutura que melhora retrieval:

**Wings (pessoas e projetos):** o nível mais alto separa contextos que não devem contaminar uns aos outros. Conversas sobre o projeto FIAP vivem na wing FIAP; conversas sobre o vault vivem na wing vault. Uma query sobre "migrations do banco de dados" busca primeiro na wing ativa, evitando confusão entre projetos diferentes.

**Rooms (tópicos):** dentro de uma wing, rooms agrupam conversas por tema. A wing vault pode ter rooms "agentes", "wiki-ingest", "sources", etc. Isso permite queries temáticas mais precisas sem buscar em todo o histórico.

**Drawers (conteúdo):** cada mensagem individual em uma conversa é um drawer. Granularidade de mensagem permite que o retrieval encontre exatamente a frase relevante, não a conversa inteira.

Esta hierarquia permite que o MCP server do MemPalace faça navegação contextual: cross-wing navigation busca em todas as wings, mas room-scoped queries são mais precisas e rápidas.

## Knowledge graph temporal — diferencial sobre RAG simples

O knowledge graph temporal é a feature mais sofisticada: entidades (pessoas, projetos, conceitos) são vinculadas em grafos de relacionamento com janelas de validade. Uma relação "trabalha em X" pode expirar depois de 6 meses se não for reafirmada.

Isso resolve um problema real de memória AI: informação desatualizada sendo retornada como fato atual. Sem validade temporal, um sistema que registrou "framework preferido: Vue" em 2024 ainda retornaria Vue em 2026 mesmo que o usuário tenha migrado para React em 2025.

O backend SQLite local para o knowledge graph é uma escolha pragmática: SQLite não precisa de servidor, é zero-config, e suporta queries de grafo via CTEs recursivas suficientes para a maioria dos casos.

## Os 29 tools MCP em contexto

O MCP server com 29 ferramentas cobre um espectro amplo:
- **Reads:** busca por query, retrieval por wing/room, listagem de entidades do grafo
- **Writes:** adicionar memories manualmente, atualizar relacionamentos no grafo
- **Knowledge graph:** criar entidades, vincular relacionamentos, definir janelas de validade
- **Cross-wing navigation:** busca global com filtros de data ou wing
- **Agent diaries:** registro estruturado de decisões de agentes (permite que agentes autônomos documentem raciocínio para retrieval futuro)

Os auto-save hooks para Claude Code são especialmente úteis: um hook periódico salva o estado da conversa em andamento, e um hook pre-compaction salva antes que o contexto seja comprimido e informação potencialmente perdida.

## Comparação com alternativas

| Sistema | Approach | Vantagem | Limitação |
|---|---|---|---|
| MemPalace | Verbatim + semantic | Alta precisão, sem sumarização | ~300MB disco |
| claude-mem | SQLite + Chroma flat | Simples, menos setup | Sem hierarquia, sem knowledge graph |
| Cognee | Graph-vector hybrid | Multi-hop queries | Mais complexo, menos documentado |
| mem0 | Extração de fatos | Compacto, leve | Perde contexto, sumarização introduz viés |

## Relações

- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — MemPalace é uma implementação de Layer 3 (vector) + estrutura hierárquica além do flat corpus
- [[03-RESOURCES/entities/claude-mem]] — alternativa com SQLite+Chroma; menos estruturada, mais simples
- [[03-RESOURCES/entities/Cognee]] — alternativa com graph-vector híbrido; foco em multi-hop queries
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern]] — padrão de construção de wiki via LLM
