---
title: "CodeGraph — Pre-Indexed Code Knowledge Graph"
type: source
created: 2026-05-24
updated: 2026-05-24
tags: [source, claude-code, code-intelligence, knowledge-graph, token-efficiency, local]
score: 7
author: "colbymchenry"
source_url: "https://github.com/colbymchenry/codegraph"
domain: ai-agents-harness
---

# CodeGraph — Pre-Indexed Code Knowledge Graph

**colbymchenry/codegraph**: semantic code intelligence local para Claude Code, Codex, Cursor, OpenCode, Hermes Agent.

## Métricas

- **~35% mais barato** (tokens)
- **~70% menos tool calls**
- **100% local** (sem cloud, sem dados enviados)

## Instalação

```bash
# macOS / Linux (sem Node.js necessário)
curl -fsSL https://raw.githubusercontent.com/colbymchenry/codegraph/main/install.sh | sh

# Com Node.js
npx @colbymchenry/codegraph
```

```bash
cd seu-projeto
codegraph init -i  # instalação interativa, auto-configura agent(s)
```

## Como Funciona

Pre-indexa o codebase em um knowledge graph (`.codegraph/`). Agentes consultam o grafo em vez de fazer tool calls repetidas para explorar arquivos. Resultado: menos tokens gastos em descoberta de estrutura, mais tokens disponíveis para raciocínio.

Auto-configura: Claude Code, Cursor, Codex CLI, opencode, Hermes Agent.

## Por Que Importa

Tokens gastos em tool calls de navegação de código = waste. Knowledge graph = estrutura pré-computada disponível como contexto comprimido. 70% menos tool calls = agente mais direto ao objetivo.

## Ver Também

- [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
- [[03-RESOURCES/sources/ai-agents-harness/clipping-claude-code-large-codebases]]
