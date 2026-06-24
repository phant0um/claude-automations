---
title: "@marcusyul — Superpowers: Transformando Agentes em Dev Sênior"
type: source
source_url: "https://x.com/marcusyul/status/2058999264294883680"
author: "@marcusyul"
published: 2026-05-25
ingested: 2026-05-28
tags: [superpowers, tdd, subagents, git-worktrees, workflow, claude-code, codex, cursor, open-source]
---

# @marcusyul — Superpowers: Transformando Agentes em Dev Sênior

## Tese central

O framework [[03-RESOURCES/entities/superpowers]] (204k stars) resolve os problemas de qualidade de agentes em projetos grandes forçando o processo de um engenheiro sênior: brainstorm → spec → plan → TDD → subagentes → review → ship.

## Key insights

- **Problema que resolve:** agentes vão direto para o código, debugam às cegas, abandonam testes e alucinam em projetos grandes.
- **Flow obrigatório:** Brainstorm → Spec → Plan → TDD → Subagentes → Review → Ship. Zero código antes de testes passando.
- **TDD red/green sem exceções:** código escrito antes do teste é deletado automaticamente.
- **Git worktrees isolados:** cada subagente em branch + workspace isolado — sem conflito de contexto entre threads paralelas.
- **Controle de contexto:** mantido durante horas de trabalho autônomo (via hooks + precompact patterns).
- **Compatibilidade:** Claude Code, Codex, Cursor, Gemini CLI, OpenCode, Copilot CLI — multi-harness.
- 204k stars no GitHub (na data do post) — validação de adoção em escala.

## Implicações para o vault

- Confirma [[03-RESOURCES/entities/superpowers]] como framework de referência para coding agentic workflows.
- Alinha com Karpathy 4P do vault: simplicity first + surgical changes + verify before done.
- O flow Brainstorm→Spec→Plan→TDD→Ship é candidato a skill `full-feature-workflow` no vault.
- Referência cruzada: [[03-RESOURCES/sources/claude-code-skills/obrasuperpowers-an-agentic-skills-framework-software-development-methodolog]] tem análise completa.

## Links

- [[03-RESOURCES/entities/superpowers]]
- [[03-RESOURCES/entities/obra]]
- [[03-RESOURCES/sources/claude-code-skills/obrasuperpowers-an-agentic-skills-framework-software-development-methodolog]]
