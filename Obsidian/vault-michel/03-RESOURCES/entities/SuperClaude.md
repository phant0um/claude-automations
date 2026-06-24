---
title: SuperClaude
type: entity
category: framework / tool
created: 2026-05-31
updated: 2026-05-31
tags: [claude-code, framework, slash-commands, meta-programming, open-source, community]
---

# SuperClaude Framework

Repositório: [github.com/SuperClaude-Org/SuperClaude_Framework](https://github.com/SuperClaude-Org/SuperClaude_Framework)
Versão atual: v4.3.0 (v5.0 com TypeScript plugin system em desenvolvimento)
Licença: MIT
Org: SuperClaude-Org (community, **não afiliado à Anthropic**)

Framework de meta-programação que transforma [[03-RESOURCES/entities/Claude Code]] em plataforma de desenvolvimento estruturada via behavioral instruction injection — sem modificar o modelo, modifica o que ele recebe.

## Estatísticas

| Commands | Agents | Modes | MCP Servers |
|---|---|---|---|
| 30 | 20 | 7 | 8 |

## Instalação

```bash
pipx install superclaude
superclaude install        # 30 slash commands
superclaude mcp            # servidores MCP (opcional, 2-3× mais rápido)
superclaude doctor         # verificação
```

## 30 Slash Commands `/sc:*`

Categorias: Planning & Design (4) · Development (5) · Testing & Quality (4) · Documentation (2) · Version Control (1) · Project Management (3) · Research & Analysis (2) · Utilities (9)

Comandos chave: `/sc:research`, `/sc:implement`, `/sc:test`, `/sc:pm`, `/sc:brainstorm`, `/sc:spawn` (tarefas paralelas), `/sc:business-panel`

## 7 Modos Comportamentais

Brainstorming · Business Panel · Deep Research · Orchestration · **Token-Efficiency** (-30-50% tokens) · Task Management · Introspection

## 8 MCP Servers

Tavily (web search) · Context7 (docs) · Sequential-Thinking · Serena (memória) · Playwright · Magic (UI) · Morphllm-Fast-Apply · Chrome DevTools

## Deep Research (v4.2)

Estratégias: Planning-Only / Intent-Planning / **Unified** (default)
Multi-hop: até 5 iterações | Quality score: 0.0-1.0 (threshold 0.6, target 0.8)
Profundidades: Quick ~2min → Exhaustive ~10min (40+ fontes)

## Documentação de sessão

Claude Code lê no início de cada sessão:
- `PLANNING.md` — arquitetura e regras absolutas
- `TASK.md` — tarefas atuais e prioridades
- `KNOWLEDGE.md` — insights acumulados

## Relação com o vault

O vault-michel já tem arquitetura equivalente (CLAUDE.md + 40+ agentes + skills + hooks). SuperClaude pode ser referência para padrões específicos (PLANNING/TASK/KNOWLEDGE pattern, deep research multi-hop) sem necessariamente adotar o framework completo.

> [!caution] Não afiliado à Anthropic — risco de incompatibilidade com updates do Claude Code.

- [[03-RESOURCES/entities/Claude Code]] — plataforma base
- [[03-RESOURCES/sources/claude-code-cowork/superclaude-framework]] — fonte completa
