---
title: "Directional Prompting — Outcome-First Skill"
type: source
created: 2026-05-24
updated: 2026-05-24
tags: [source, prompting, skills, agent-skills, agentskills, claude-code, codex]
score: 7
author: "kingbootoshi"
source_url: "https://github.com/kingbootoshi/directional-prompting"
domain: skills-prompting-mcp
---

# Directional Prompting — Outcome-First Skill

**kingbootoshi/directional-prompting**: skill para escrever prompts, agent directives, SKILL.md bodies. Funciona em Claude Code e Codex CLI identicamente.

## Dois Layers

**Layer 1 — Outcome.** Abre com bloco que nomeia o destino:
- `Goal:` — o que fazer
- `Success means:` — o que "done" parece
- `Stop when:` — quando parar
- `Constraints:` — invariantes

**Layer 2 — Direction.** Cada sentença nomeia o caminho com verbos positivos: "Trace", "build", "use", "read", "return", "ask", "check".

> "Outcome without direction = wishful. Direction without outcome = wanders. Both together: model knows destination and walks toward it on every token."

## Por Que Positivo

Modelos frontier seguem instruções literalmente. Claude 4 guide: *"Positive examples more effective than negative examples."* GPT-5.5 guide: *"GPT-5.5 is strongest when prompt defines target outcome... then lets model choose the path."*

Negação (don't, avoid, never) planta conceito errado — modelo re-planta a cada turn.

## Before/After

**Antes:**
```
You are a code reviewer. Don't be too harsh. Don't nitpick formatting.
Never approve code with obvious bugs. Don't suggest changes that aren't actionable.
```

**Depois:**
```
Goal: Review the PR diff and decide APPROVE, REQUEST_CHANGES, or BLOCK.
Success means: Verdict issued. Each comment names file, line, replacement.
Stop when: Verdict issued and every comment is actionable.
Focus on bugs, security, unclear logic. Ask before interpreting intent.
```

## 4-Check Pass

1. **Outcome check** — tem goal + success + stopping condition?
2. **Direction check** — conta negações, reescreve como positivo
3. **Absolute-rule check** — ALWAYS/NEVER/MUST é invariante real? Demota decorativos
4. **Read-back** — cada sentença nomeia destino ou passo?

## Compatibilidade

Claude Code, Codex CLI, Cursor, Gemini Antigravity — qualquer agent que lê `SKILL.md`.

## Ver Também

- [[03-RESOURCES/sources/skills-prompting-mcp/clipping-anatomy-claude-skill]]
- [[03-RESOURCES/sources/skills-prompting-mcp/clipping-context-engineering-101]]
