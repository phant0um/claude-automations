---
title: Cognee
type: entity
category: tool
tags: [agent-memory, knowledge-graph, vector-search, open-source, python]
created: 2026-04-17
updated: 2026-05-19
---

# Cognee

Engine de memória open-source para agentes. Combina busca vetorial, knowledge graphs e uma camada relacional de proveniência em um único sistema com API de 4 chamadas.

## Stack

| Camada | Dev/Default | Produção |
|--------|-------------|----------|
| Relational | SQLite | Postgres |
| Vector | LanceDB | Qdrant / Pinecone / pgvector |
| Graph | Kuzu | Neo4j / FalkorDB / Neptune |

Sem Docker para setup default. `pip install cognee` + API key de LLM.

## API

```python
await cognee.add("documento")    # ingere qualquer coisa
await cognee.cognify()           # pipeline completo: extract→graph→embed
await cognee.memify()            # otimização RL-inspired da memória
await cognee.search("query")     # retrieval com raciocínio multi-hop
```

## cognify() pipeline

1. Classificação de documento por tipo e domínio
2. Verificação de permissões (multi-tenant)
3. Chunk extraction respeitando estrutura de parágrafos
4. Extração de entidades e relações via LLM + deduplicação por hash de conteúdo
5. Geração de summaries
6. Dual indexing: vector store + graph store

Entidades repetidas em 50 documentos são mergeadas em 1 nó de grafo com 50 edges. O agente não vê "Alice" como 50 estranhos diferentes.

## memify() — Memoria que Aprende

RL-inspired optimization pass sobre o grafo:
- Fortalece paths que levaram a boa recuperação
- Poda nodes obsoletos por inatividade
- Auto-tune de edge weights por uso real
- Adiciona fatos derivados identificando relações implícitas

## Por que 3 Stores e não 1

Cada store captura uma dimensão que os outros não conseguem:
- **Relational**: proveniência (de onde, quando, quem tem acesso)
- **Vector**: semântica (o que significa, o que é similar)
- **Graph**: relacionamentos (como entidades se conectam, quem reporta a quem)

## Onde aparece no vault

- [[03-RESOURCES/sources/memory-context-rag/build-agents-that-never-forget]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]

## Links externos

- GitHub: https://github.com/topoteretes/cognee
