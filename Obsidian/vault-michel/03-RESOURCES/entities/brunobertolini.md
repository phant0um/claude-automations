---
title: brunobertolini
type: entity
category: person
tags: [agent-system, code-review, pre-commit, quality-gate, developer]
created: 2026-05-14
updated: 2026-05-19
---

# brunobertolini

**Handle:** @brunobertolini (X/Twitter)

Engenheiro de software que construiu um sistema de revisão de código totalmente automatizado usando Claude Code, eliminando a revisão manual. Articulou o conceito de "o trabalho sobe uma camada" — de revisor para arquiteto do sistema de revisão.

## Contribuições relevantes

- **Sistema autônomo de code review:** agentes especializados em paralelo (bugs, security, arquitetura, estilo) rodando no `/pr-review`
- Rules auto-carregadas por path em `.claude/rules/` como trilhos que o agente não consegue sair
- Memory persistente: cada feedback vira regra permanente
- Quality-gate com pre-commit hooks bloqueando commits inválidos
- E2E automático no browser gerando issues quando encontra problemas
- **Pipeline full-stack de dev com AI (2026):** workflow completo ideia → PR com 8 passos usando slash commands `/pm`, `/epic`, `/code`, `/distill`; GitHub como sistema nervoso; `/distill` integra Obsidian como second brain; git worktrees para paralelismo; PR com 6 agentes de review
- **`/pm prioritize`:** priorização de épicos por análise dos dados do próprio projeto, não por intuição
- **`/pm plan`:** destrincha épico em issues executáveis lendo o codebase completo + handoff do Claude Design

## Fontes no vault

- [[03-RESOURCES/sources/skills-prompting-mcp/post-brunobertolini-sistema-revisao-codigo]]
- [[03-RESOURCES/sources/skills-prompting-mcp/brunobertolini-ai-dev-workflow]] — pipeline full-stack 2026: Claude Chat → GitHub Discussions → épicos → `/pm plan` → worktrees → PR com 6 agentes; `/distill` integra Obsidian como second brain do fluxo de dev
