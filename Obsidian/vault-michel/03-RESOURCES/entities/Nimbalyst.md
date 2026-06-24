---
title: "Nimbalyst"
type: entity
categoria: produto/repo
url: https://nimbalyst.com
github: https://github.com/nimbalyst/nimbalyst
tags: [produto, harness, coding-agents, workspace, open-source, multi-agent]
created: 2026-05-28
updated: 2026-05-28
---

# Nimbalyst

Workspace open-source criado por [[03-RESOURCES/entities/wirthkarl]] para montar e operar o harness de coding agents. Permite rodar múltiplos coding agents (Claude Code, Codex, outros) side by side sem reconstruir o layer acima quando o agente subjacente muda.

## O que é

Nimbalyst é o ponto de partida para o harness nos 8 pilares descritos em `docs/THE_HARNESS.md`. O repo contém a implementação viva: arquivos de regras, MCP tools, slash commands, tracker workflows.

## 8 Pilares implementados

| Pilar | Implementação |
|-------|-------------|
| Context | CLAUDE.md + path-scoped rules + skill system + persistent memory |
| Provenance | Typed link graph entre tracker items, sessions, diffs, commits |
| Capability | MCP tools (logs, DB queries, renderer-eval, Playwright, GitHub, analytics) |
| Workflow | Slash commands em `.claude/commands/` (plan, implement, review, release) |
| Restraint | Path-scoped blocks + hard rules + approval flows + audit trail |
| Verification | Failing-test-first + Vitest + Playwright + AI tool simulator |
| Visual Interface | Markdown editor com diffs red/green + mockup/diagram editors + voice channel |
| Coordination | Sessions em kanban + workstreams + meta-agent + git worktrees + handoff briefs |

## Fontes

- [[03-RESOURCES/sources/ai-agents-harness/wirthkarl-eight-pillars-coding-harness]] — framework completo
