---
title: Git Worktrees como Paralelismo de Agentes
type: concept
status: developing
tags: [git-worktrees, claude-code, multi-agent, senior-engineering, parallelism]
created: 2026-05-14
updated: 2026-05-14
---

# Git Worktrees como Paralelismo de Agentes

Técnica de usar **git worktrees** para lançar múltiplas sessões de Claude Code em paralelo, cada uma operando em uma branch/tarefa diferente sem interferência. Multiplica o throughput de engenharia quando combinado com agentes especializados.

## Mecanismo

Git worktrees permitem ter múltiplos working directories do mesmo repositório simultaneamente, cada um em um branch diferente. No contexto de AI coding:

- Cada worktree = 1 sessão isolada de Claude Code
- Sessões podem trabalhar em tarefas independentes ao mesmo tempo
- Sem conflitos de estado entre sessões

## Workflow combinado (5 agentes + worktrees)

**Plugin divide cada tarefa:**
1. Brainstorming
2. Design do plano técnico
3. Implementação
4. Revisão
5. Validação de ângulos distintos

**Worktrees amplificam:**
- 4–8 sessões de Claude Code simultâneas
- Cada sessão = uma tarefa completa ou subtarefa

## Custo-benefício

Mais lento individualmente (cada agente tem papel claro, há mais espera), mas a qualidade sobe e o throughput total aumenta por paralelismo real.

## Princípio maior

> "A nova habilidade de engenharia não é só saber codificar. É saber dirigir vários agentes sem perder o controle do sistema."

A competência crítica migra de "escrever código" para "arquitetar, planejar, revisar e orquestrar agentes."

## Fontes

- [[03-RESOURCES/sources/post-nicos-ai-senior-engineer-worktrees]]

## Relacionado

- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]]
- [[03-RESOURCES/concepts/agent-systems/agentic-reasoning]]
- [[03-RESOURCES/entities/nicos-ai]]
- [[03-RESOURCES/entities/Claude Code]]
