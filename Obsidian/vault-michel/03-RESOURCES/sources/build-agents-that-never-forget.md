---
title: "Build Agents that never forget"
type: source
source_file: .raw/articles/Build Agents that never forget.md
author: Akshay (@akshay_pachaar)
ingested: 2026-04-17
tags: [agent-memory, cognee, vector-search, knowledge-graph, persistence]
---

# Build Agents that never forget

> [!summary]
> Akshay percorre 4 camadas de memória para agentes (lista Python → markdown → vector search → graph-vector híbrido) e apresenta Cognee como solução open-source que combina os três paradigmas de armazenamento em 4 chamadas de API.

## 7 Failure Modes sem Memória

1. Context amnesia — agente pede info que você já deu
2. Zero personalização — cada interação é genérica
3. Falha em tarefas multi-step — estado intermediário cai
4. Erros repetidos — sem recall episódico
5. Sem acumulação de conhecimento — cada sessão do zero
6. Alucinação por gaps — quando contexto transborda, modelo inventa
7. Colapso de identidade — sem continuidade, sem confiança

## Framework Cognitivo (Lilian Weng, 2023)

**Agent = LLM + Memory + Planning + Tool Use**

Memória humana mapeada para agentes:
- **Sensory** → input imediato (tokens atuais)
- **Working** → context window (~7±2 items)
- **Long-term** → persistência externa

Long-term se divide em:
- **Episódica**: eventos específicos passados
- **Semântica**: fatos e conceitos
- **Procedural**: skills e workflows

**Memory consolidation**: eventos episódicos repetidos destilados em conhecimento geral semântico.

## As 4 Camadas (Progressão)

### Layer 1: Lista Python
- Funciona para multi-turn básico
- Problemas: cresce unbounded, morre com o processo

### Layer 2: Markdown Files
- Persistência entre sessões; legível por humanos
- Claude Code usa esse padrão com CLAUDE.md/MEMORY.md
- Limite: com 2000+ fatos, não cabe no contexto; keyword search é frágil (sinônimos falham)

### Layer 3: Vector Search
- Resolve o problema de sinônimos via embeddings
- Problema crítico: **"lost in the middle"** — fatos de conexão entre entidades não surfaceiam
- "Was Alice's project affected by Tuesday's outage?" — o fato-ponte ("Project Atlas uses PostgreSQL") não aparece no resultado

### Layer 4: Graph-Vector Híbrido (Cognee)

Combina os 3 paradigmas de armazenamento:
- **Relational** → proveniência (de onde, quando, quem tem acesso)
- **Vector** → semântica (o que significa, o que é similar)
- **Graph** → relacionamentos (como entidades se conectam)

## Cognee: 4 Chamadas de API

```python
await cognee.add("documento")    # ingere qualquer coisa
await cognee.cognify()           # constrói knowledge graph + embeddings
await cognee.memify()            # self-improvement da memória (RL-inspired)
await cognee.search("query")     # recuperação com raciocínio
```

**Stack default:** SQLite + LanceDB + Kuzu (embedded, sem Docker)
**Stack produção:** Postgres + Qdrant/Pinecone + Neo4j/FalkorDB

**cognify()** pipeline:
1. Classificação de documento
2. Chunking respeitando estrutura de parágrafos
3. Extração de entidades e relações via LLM + deduplicação por hash
4. Dual indexing: vector store + graph store

**memify()** — otimização RL-inspired:
- Fortalece paths úteis que levaram a boa recuperação
- Poda nodes obsoletos
- Auto-tune de edge weights por uso

> [!insight]
> Todo nó do grafo tem um embedding correspondente. Entrar via vetores (conteúdo similar) e sair pelo grafo (seguir relacionamentos) — ou o reverso. Isso é o que faz queries multi-hop funcionarem sem sacrificar busca semântica.

## Conceitos Relacionados

- [[agent-memory-architecture]]
- [[knowledge-compounding]]
- [[context-engineering]]

## Entidades Mencionadas

- [[Akshay-pachaar]] — autor (@akshay_pachaar)
- [[Cognee]] — engine de memória open-source; graph+vector+relational
- [[Lilian-Weng]] — autora do framework cognitivo de agentes (2023)
