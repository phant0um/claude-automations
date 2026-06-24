---
title: superpowers
type: entity
category: ferramenta
tags: [skills-framework, agentic, tdd, subagent, claude-code, open-source, mit]
created: 2026-05-17
updated: 2026-05-17
---

# superpowers

Framework open-source de skills composáveis para coding agents. Metodologia completa de desenvolvimento que cobre o ciclo inteiro — da ideia ao merge — com workflows que ativam automaticamente conforme o contexto.

- **Repo:** https://github.com/obra/superpowers
- **Autor:** [[03-RESOURCES/entities/obra]] (Jesse Vincent / Prime Radiant)
- **Licença:** MIT
- **Instalação Claude Code:** `/plugin install superpowers@claude-plugins-official`
- **Discord:** https://discord.gg/35wsABTejz
- **Release list:** https://primeradiant.com/superpowers/

## O que faz

Adiciona ao agent um conjunto de skills que:
1. **Brainstorming Socrático** — extrai spec antes de qualquer código
2. **Git Worktrees** — workspace isolado por feature em nova branch
3. **Writing Plans** — plano de implementação em tarefas de 2–5 min com código completo e critérios de verificação
4. **Subagent-Driven Development** — subagente por tarefa com revisão dois estágios (spec compliance → qualidade)
5. **TDD estrito** — RED-GREEN-REFACTOR; código escrito antes do teste é deletado
6. **Code Review** — issues críticas bloqueiam avanço; não são apenas relatadas
7. **Branch Finishing** — verificação final + decisão merge/PR/keep/discard + cleanup

## Agentes Suportados

Claude Code, Codex CLI, Codex App, Factory Droid, Gemini CLI, OpenCode, Cursor, GitHub Copilot CLI.

## Skills Incluídas (13)

| Categoria | Skill |
|-----------|-------|
| Testing | `test-driven-development` |
| Debugging | `systematic-debugging`, `verification-before-completion` |
| Collaboration | `brainstorming`, `writing-plans`, `executing-plans`, `dispatching-parallel-agents`, `requesting-code-review`, `receiving-code-review`, `using-git-worktrees`, `finishing-a-development-branch`, `subagent-driven-development` |
| Meta | `writing-skills`, `using-superpowers` |

## Diferencial vs Outros Repos de Skills

| Aspecto | superpowers | mattpocock/skills |
|---------|-------------|-------------------|
| Foco | Metodologia completa end-to-end | Skills individuais plug-and-play |
| Ativação | Automática por contexto | Manual (invocação explícita) |
| Agents | Multi-harness (8+ agents) | Principalmente Claude Code |
| TDD | Obrigatório (RED-GREEN-REFACTOR) | Via `/tdd` skill |
| Subagents | Padrão central (SDD) | Via `/dispatching-parallel-agents` |

## Conexões

- [[03-RESOURCES/entities/obra]] — Jesse Vincent, criador e maintainer
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — paradigma de SKILL.md composáveis
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — subagent-driven-development como core
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — fat skills que ativam por contexto
- [[03-RESOURCES/sources/claude-code-skills/obrasuperpowers-an-agentic-skills-framework-software-development-methodolog]] — análise completa
- [[03-RESOURCES/sources/claude-code-skills/67-claude-skills-full-dev-team]] — curadoria que inclui superpowers
- [[03-RESOURCES/entities/Matt-Pocock]] — repositório de skills paralelo (mattpocock/skills)
