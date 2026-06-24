---
title: "Post — AI as Senior Engineer via Git Worktrees"
type: source
source_type: post-x
created: 2026-05-31
updated: 2026-06-10
tags: [architecture-design, ai-agents-harness, git-worktrees]
status: seed
---

# AI as Senior Engineer — Git Worktrees Pattern

> Autor "Nicos" não localizado — conteúdo geral sobre padrão worktrees + agentes paralelos.

## Resumo

Padrão: usar `git worktree` pra rodar múltiplos agentes (Claude Code etc.) em paralelo, cada um numa branch/worktree isolada — evita conflito de estado, permite "agente sênior" revisar/integrar trabalho de "agentes júnior" rodando em worktrees separados.

## Por que importa (vault)

Relaciona com `Agent` tool `isolation: "worktree"` já disponível neste harness — ver [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]].

## Notes
WebSearch (2026-06-10) — autor "Nicos" não localizado, conteúdo cobre tema geral (worktrees + agentes paralelos).
