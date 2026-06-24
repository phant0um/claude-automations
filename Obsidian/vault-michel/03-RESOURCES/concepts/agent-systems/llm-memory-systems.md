---
title: "LLM Memory Systems"
type: reference
created: 2026-05-31
updated: 2026-05-31
tags: [reference, memory, agent-systems, retrieval, persistence]
status: developing
---

# LLM Memory Systems

Arquiteturas para persistência e recuperação de informação em agentes LLM. Context window é RAM — memória externa é disco.

## Framework Cognitivo (Lilian Weng, 2023)

**Agent = LLM + Memory + Planning + Tool Use**

| Memória humana | Análogo em agente |
|----------------|-------------------|
| Sensory (fração de segundo) | Tokens do input atual |
| Working (7±2 items) | Context window |
| Long-term (sem limite) | Persistência externa |

## 4 Tipos de Memória Long-Term

| Tipo | O que guarda | Exemplo no vault |
|------|-------------|-----------------|
| **Episódica** | Eventos passados específicos | "Na sessão de quinta, Michel pediu para não usar emoji" |
| **Semântica** | Fatos e conceitos | "FIAP usa Maven, não Gradle" |
| **Procedural** | Skills e workflows | Como executar wiki-ingest |
| **Working** | Estado volátil da task atual | Arquivo aberto, plano ativo, checkpoints |

## 4 Camadas de Implementação

### Layer 1: Lista Python / In-Memory
- Multi-turn básico
- Morre com processo; cresce unbounded
- Uso: protótipos

### Layer 2: Markdown Files
- Persistência entre sessões; legível; Git-friendly
- **Claude Code usa esse padrão**: CLAUDE.md, MEMORY.md, hot.md
- Limite: 2000+ fatos → keyword search frágil (sinônimos falham)

### Layer 3: Vector Search
- Embeddings resolvem sinônimos e similaridade semântica
- Limite estrutural: queries multi-hop falham ("o projeto de Alice foi afetado pela queda de terça?" — fato-ponte não aparece)

### Layer 4: Graph-Vector Híbrido
- Combina relational + vector + graph
- Queries multi-hop via travessia de grafo
- Implementação de referência: Cognee

## 6 Camadas de Autoridade (Framework Voxyz)

| Camada | Lifespan | Autoridade |
|--------|----------|------------|
| Hot session | Duração da task | Alta — contexto imediato |
| Day-state | 1 dia | Instrução mais nova vence |
| Project memory | Weeks/meses | Lição atual supera antiga |
| Retrieval / Index | Persistente (decai) | Candidatos — não decide |
| Canonical policy | Longo prazo | Alta — "constituição" |
| Direct instruction | Task atual | Mais alta para task corrente |

**Citation order quando há conflito:** instrução direta > canonical policy > decisão de projeto mais recente > long-term memory com source > retrieval summary > compressed summary.

## 3 Jobs da Memória Confiável

1. **Remember** — por camada (qual decisão esta memória pode afetar?)
2. **Cite** — por proveniência (de onde veio? é derivada de outra memória?)
3. **Forget** — por expiração (hard expiry, bitemporal, soft decay)

> Memória velha que *parece* válida é mais perigosa que ausência de memória.

## Memória no Vault

| Arquivo | Tipo | Lifespan |
|---------|------|----------|
| `04-SYSTEM/wiki/hot.md` | Semântica quente | Permanente (atualizada) |
| `~/.claude/…/memory/MEMORY.md` | Episódica/semântica | Permanente (cross-session) |
| `.claude/todo.md` | Working (task atual) | Sessão / projeto |
| `04-SYSTEM/wiki/errors.md` | Procedural negativa | Permanente |
| `03-RESOURCES/concepts/` | Semântica profunda | Permanente |

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-memory-four-layers]] — 4 camadas detalhadas
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — framework cognitivo completo
- [[03-RESOURCES/concepts/agent-systems/agent-memory-layers]] — 6 camadas de autoridade + citation order
- [[03-RESOURCES/concepts/externalized-memory]] — memória fora do contexto
- [[03-RESOURCES/concepts/action-memory]] — memória de ações passadas
- [[04-SYSTEM/wiki/hot.md]] — implementação de hot cache no vault
