---
title: "agentmemory — Persistent Memory for AI Coding Agents"
type: source
tags: [agent-memory, coding-agent, persistence, benchmark, context-management]
source: https://github.com/rohitg00/agentmemory
author: rohitg00
ingested: 2026-05-16
triagem_score: 8
---

# agentmemory — Persistent Memory for AI Coding Agents

**Repo:** https://github.com/rohitg00/agentmemory
**npm:** `@agentmemory/agentmemory`
**Trending:** +1,879 GitHub stars em 2026-05-16
**Design doc:** [Viral Gist](https://gist.github.com/rohitg00/2067ab416f7bbe447c1977edaaa681e2) — 1,200+ stars / 172 forks

## Tese central

O coding agent esquece tudo quando a sessão termina. Você gasta os primeiros 5 minutos de cada sessão re-explicando sua stack. agentmemory roda em background, captura silenciosamente cada tool use, comprime em memória estruturada e injeta o contexto certo na próxima sessão. Uma instalação; funciona com qualquer agente.

Implementa o LLM Wiki pattern de Karpathy estendido com confidence scoring, lifecycle, knowledge graphs e hybrid search.

## Benchmarks

### Retrieval (LongMemEval-S — ICLR 2025, 500 perguntas)

| Sistema | R@5 | R@10 | MRR |
|---|---|---|---|
| **agentmemory** | **95.2%** | **98.6%** | **88.2%** |
| BM25-only fallback | 86.2% | 94.6% | 71.5% |

### Token savings

| Abordagem | Tokens/ano | Custo/ano |
|---|---|---|
| Full context paste | 19.5M+ | Impossível (excede window) |
| LLM-summarized | ~650K | ~$500 |
| **agentmemory** | **~170K** | **~$10** |
| agentmemory + local embeddings | ~170K | **$0** |

## Comparação com concorrentes

| | agentmemory | mem0 (53K ★) | Letta/MemGPT (22K ★) | CLAUDE.md nativo |
|---|---|---|---|---|
| Retrieval R@5 | **95.2%** | 68.5% | 83.2% | N/A |
| Auto-capture | 12 hooks (zero esforço) | Manual `add()` | Agent self-edits | Edição manual |
| Search | BM25 + Vector + Graph (RRF) | Vector + Graph | Vector (archival) | Loads tudo no context |
| External deps | Nenhum (SQLite + iii-engine) | Qdrant / pgvector | Postgres + vector DB | Nenhum |
| Token efficiency | ~1,900 tokens/sessão ($10/ano) | Varies | Core memory in context | 22K+ em 240 obs |
| Self-hosted | Sim (padrão) | Opcional | Opcional | Sim |

## Instalação

```bash
npm install -g @agentmemory/agentmemory
agentmemory                          # inicia servidor :3111
agentmemory demo                     # seed sample sessions + prova de recall
agentmemory connect claude-code      # wiring do agente
```

Claude Code: `/plugin marketplace add rohitg00/agentmemory` → `/plugin install agentmemory`
Viewer em tempo real: `http://localhost:3113`

## Como funciona

### Memory Pipeline

```
PostToolUse hook fires
  -> SHA-256 dedup (5min window)
  -> Privacy filter (strip secrets, API keys)
  -> Store raw observation
  -> LLM compress -> structured facts + concepts + narrative
  -> Vector embedding (6 providers + local)
  -> Index in BM25 + vector

Stop / SessionEnd hook fires
  -> Summarize session
  -> Knowledge graph extraction
  -> Slot reflection

SessionStart hook fires
  -> Load project profile
  -> Hybrid search (BM25 + vector + graph)
  -> Token budget (default: 2000 tokens)
  -> Inject into conversation
```

### 4-Tier Memory Consolidation

| Tier | O quê | Analogia humana |
|---|---|---|
| **Working** | Raw observations de tool use | Memória de trabalho |
| **Episodic** | Sessões comprimidas | "O que aconteceu" |
| **Semantic** | Fatos e padrões extraídos | "O que eu sei" |
| **Procedural** | Workflows e decision patterns | "Como fazer" |

Memórias decaem pela curva de Ebbinghaus. Acessos frequentes fortalecem. Contraditórias são detectadas e resolvidas.

### Triple-stream Retrieval (RRF fusion)

- **BM25** — keyword matching com expansão de sinônimos
- **Vector** — cosine similarity sobre dense embeddings (`all-MiniLM-L6-v2`, local, grátis)
- **Graph** — knowledge graph traversal via entity matching

Fused via Reciprocal Rank Fusion (k=60), session-diversified (max 3 por sessão).

## Capacidades MCP

51 tools, 6 resources, 3 prompts, 4 skills. Tools core: `memory_smart_search`, `memory_save`, `memory_recall`, `memory_sessions`, `memory_profile`, `memory_relations`, `memory_export`.

## Agentes suportados

Claude Code (12 hooks + plugin), Codex CLI (6 hooks + plugin), OpenClaw, Hermes, pi, Cursor, Gemini CLI, OpenCode, Cline, Goose, Kilo Code, Aider, Claude Desktop, Windsurf, Roo Code, OpenHuman — qualquer agente via MCP ou REST.

## Infraestrutura

Construído sobre o **iii engine** (Rust, WebSocket `:49134`). Requer `iii-engine v0.11.2` (pinado; v0.11.6+ tem sandbox model incompatível). Sem bancos externos: SQLite + iii-engine basta.

Deploy: Fly.io, Railway, Render, Coolify (self-hosted).

## Por que triple-stream retrieval supera abordagens single-stream

A fusão BM25 + Vector + Graph via Reciprocal Rank Fusion não é engenharia de over-engineering — cada stream cobre falhas dos outros dois:

- **BM25 sem vector:** falha em correspondência semântica. "Corrigir autenticação JWT" não encontra memória sobre "resolver bug de token expirado" via keyword matching, mas as duas são sobre o mesmo problema.
- **Vector sem BM25:** falha em correspondência exata. Quando você busca "função `calculate_total`", embedding similarity retorna funções semanticamente próximas, mas BM25 encontra a função exata com prioridade.
- **Graph sem os outros dois:** falha em consultas que não têm entidades explícitas. "Como eu costumava resolver problemas de performance?" não tem um nó no grafo de conhecimento óbvio, mas BM25 e vector encontram memórias relevantes.

O Reciprocal Rank Fusion com k=60 combina os três rankings dando mais peso a itens que aparecem consistentemente no topo de múltiplos streams, em vez de apenas somar scores — o que tornaria o BM25 dominante por seus scores mais extremos.

## A curva de Ebbinghaus e decaimento de memória

Modelar o decaimento de memórias pela curva de Ebbinghaus é uma decisão de design com implicação de custo de contexto: memórias acessadas frequentemente consomem mais espaço permanentemente, enquanto memórias nunca acessadas decaem e eventualmente saem da janela de retrieval. Isso simula a memória humana de um modo que tem consequências práticas.

Para um coding agent, isso significa que o contexto de um projeto ativo (acessado diariamente) tem memórias sempre fortes, enquanto um projeto abandonado 3 meses atrás tem memórias decaídas que precisam ser reativadas explicitamente. Em vez de manter tudo com peso igual (como CLAUDE.md plano faz), o sistema tem priorização automática baseada em padrão de uso real.

## agentmemory vs CLAUDE.md nativo: quando usar cada um

A comparação da tabela mostra que CLAUDE.md nativo tem custo zero de infraestrutura mas escala mal: 240 observações = 22K+ tokens carregados em todo contexto. Para projetos com uma única área de foco, CLAUDE.md é suficiente. Para agentes que trabalham em múltiplos projetos, acumulam contexto de sessões ao longo de semanas, ou têm equipes de múltiplos usuários, a arquitetura de retrieval do agentmemory produz economia líquida mesmo com o overhead de infraestrutura.

O ponto de crossover estimado é ~50 observações persistentes: acima disso, carregar tudo no contexto começa a competir com o orçamento de tokens do task.

## Links

- [[03-RESOURCES/entities/agentmemory]] — página da ferramenta
- [[03-RESOURCES/entities/rohitg00]] — autor
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — arquitetura de memória de agentes
- [[03-RESOURCES/concepts/agent-systems/agent-memory-four-layers]] — 4 camadas de memória
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern]] — padrão Karpathy (base intelectual)
- [[03-RESOURCES/entities/Cognee]] — concorrente (graph-vector hybrid)
- [[03-RESOURCES/sources/memory-context-rag/rohitg00-agentmemory-persistent-llm-wiki]] — ingest anterior (stub, social media clipping)
- [[03-RESOURCES/sources/pkm-obsidian-second-brain/clipping-why-karpathys-second-brain-breaks-at-agent-scale-how-mercury]] — diagnóstico original que este projeto responde tecnicamente
