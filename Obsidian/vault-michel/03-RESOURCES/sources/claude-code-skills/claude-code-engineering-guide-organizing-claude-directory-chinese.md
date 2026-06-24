---
title: "Claude Code 工程化指南：高效组织 .claude 目录"
type: source
source: "https://x.com/vincemask/status/2056757482152960110"
created: 2026-06-22
updated: 2026-06-22
tags: [claude-code-skills, claude-code, engineering, directory-structure, chinese]
---

## Tese Central

Um .claude/ bem organizado torna Claude mais fácil de guiar, confiável, e escalável em projetos reais. Quando projeto cresce, um CLAUDE.md e poucos settings não bastam — instruções ficam difíceis de manter, workflows se espalham, pasta vira mix de config útil e caos. A blueprint separa top-level leve (CLAUDE.md para guidance, settings.json para control) de modular rules/, hooks/ (auto-run), commands/ (reusable prompts), skills/ (packaged capabilities), agents/ (subagents).

## Pontos-Chave

1. **顶层要轻**: CLAUDE.md explica como projeto funciona (stack, architecture, key commands, global conventions). settings.json controla como Claude opera (permissions, hooks, project behavior). CLAUDE.local.md/settings.local.json são personal overrides (não commitados). Um guia, um controla.
2. **CLAUDE.md vs rules/**: CLAUDE.md = global guidance (todo session precisa). rules/ = domain/workflow-specific rules (frontend.md, backend-api.md, testing.md). Split quando CLAUDE.md fica crowded, áreas diferentes precisam guidance diferente, team atualiza conventions frequentemente, quer path-scoped instructions.
3. **hooks/ vs commands/**: hooks = auto-run scripts (block-dangerous-commands, format-edits, run-tests-before-stop). commands = reusable prompt workflows, não auto-run (review-pr.md, write-tests.md, summarize-changes.md). Naming claro: format-edits.sh > script1.sh.
4. **skills/ e agents/**: skills = packaged capabilities com múltiplos steps e docs de acompanhamento (release-prep/). agents = subagents dedicados para tasks específicas.
5. **Core principles**: 顶层轻 (top-level light), modular split, hooks auto vs commands manual, naming claro, path-scoped rules.

## Conceitos

- **CLAUDE.md vs rules/ split**: global guidance vs domain-specific rules
- **hooks (auto) vs commands (manual)**: scripts que rodam sozinhos vs prompts reusáveis invocados
- **skills/ e agents/**: packaged capabilities com steps vs subagents dedicados
- **Path-scoped instructions**: rules que aplicam apenas a certas áreas do repo

## Links

- [[03-RESOURCES/entities/Claude-Code]]
- [[03-RESOURCES/concepts/agent-systems/claude-code-skills]]
- [[03-RESOURCES/concepts/agent-systems/agentsmd-pattern]]
- [[03-RESOURCES/concepts/agent-systems/claude-skills-architecture]]