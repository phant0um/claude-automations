---
title: "Anatomy of Boris Cherny's CLAUDE.md — 13 Operating Principles"
type: source
source_type: clipping
hash: cbfeeca9a4fd42e493ef4cbde7ea5bd7
ingested: 2026-05-14
tags: [claude-code, CLAUDE.md, workflow, boris-cherny, operating-principles, self-improvement, plan-mode]
triagem_score: 8
---

# Anatomy of Boris Cherny's CLAUDE.md

This file defines how the agent should behave day-to-day in a project, functioning as a working "constitution". 13 explicit rules mapped from CLAUDE.md verbatim to practical meaning.

## The 13 Rules Table

| # | Rule | CLAUDE.md Verbatim | Practical Meaning |
|---|------|--------------------|-------------------|
| 1 | **Plan Mode Default** | `### 1. Plan Mode Default` | Forces Claude to write the plan first. Prevents running in the wrong direction and wasting tokens. |
| 2 | **Subagent Strategy** | `### 2. Subagent Strategy` | Guides use of subagents to keep main context clean. Allows multiple research flows while main thread focuses on execution. |
| 3 | **Self-Improvement Loop** | `### 3. Self-Improvement Loop` | After any correction, error + solution must be logged to `tasks/lessons.md`. Goal: the same mistake never happens twice. |
| 4 | **Verification Before Done** | `### 4. Verification Before Done` | "Done" does not exist without proof. Claude must prove work functions via test, log, or diff comparison. |
| 5 | **Demand Elegance (Balanced)** | `### 5. Demand Elegance (Balanced)` | If a solution feels like a hack, implement the correct version. But: avoid over-engineering on simple fixes. |
| 6 | **Autonomous Bug Fixing** | `### 6. Autonomous Bug Fixing` | Given an error report, Claude reads logs, finds the cause, and fixes without hand-holding. |
| 7 | **Plan First** | `### 7. Plan First` | Maintains a live to-do list in `tasks/todo.md` with checkable items updated in real time. |
| 8 | **Verify Plan, Track Progress** | `### 8. Verify Plan, Track Progress` | Requires re-reading the plan before starting and marking each item as work advances. |
| 9 | **Explain Changes & Results** | `### 9. Explain Changes & Results` | One-line summary for each step taken. No mysterious edits without explanation. |
| 10 | **Capture Lessons** | `### 10. Capture Lessons` | Every lesson learned from a correction is saved for the next session. |
| 11 | **Simplicity First** | `### 11. Simplicity First` | Prioritize a simple one-line fix over a complex, "intelligent" rewrite. |
| 12 | **No Laziness** | `### 12. No Laziness` | No band-aids or temporary fixes. Claude must find the root cause to prevent breakage next week. |
| 13 | **Minimal Impact** | `### 13. Minimal Impact` | Touch only what is necessary. Avoid unsolicited refactors that introduce bugs in unrelated files. |

---

## Relationship to Existing Coverage

This source presents Cherny's principles in a structured 13-rule table format. The earlier source [[03-RESOURCES/sources/skills-prompting-mcp/clipping-claudemd-senior-engineer-srishticodes]] covers similar content as a CLAUDE.md template with narrative explanations. Together they give both the rule-set and the implementation template.

**Key delta this source adds:**
- Explicit rule numbering (1–13) as a canonical reference
- Rule 13 (Minimal Impact) not prominently named in the earlier source
- "Demand Elegance Balanced" as a named, numbered principle

---

## See Also

- [[03-RESOURCES/entities/Boris-Cherny]] — creator of Claude Code at Anthropic
- [[03-RESOURCES/sources/skills-prompting-mcp/clipping-claudemd-senior-engineer-srishticodes]] — drop-in CLAUDE.md template from same principles
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]] — EPCC workflow; Cherny's principles extend and reinforce it
- [[03-RESOURCES/concepts/claude-code-tooling/claude-folder-anatomy]] — CLAUDE.md role in project configuration

---

## Por que 13 regras, não mais ou menos

O número 13 não é arbitrário — ele reflete uma tensão real no design de CLAUDE.md. Evidência empírica em prompt engineering mostra que modelos seguem instruções com fidelidade decrescente conforme o número de regras cresce além de 10-15. Abaixo de ~10 regras, cada regra individual recebe atenção adequada. Acima de ~20-30 regras, o modelo começa a tratar o CLAUDE.md como background de contexto e não como conjunto de constraints operacionais.

As 13 regras de Cherny cobrem os 6 domínios críticos:
- **Planejamento** (1, 7): plan mode + todo.md
- **Decomposição** (2): subagents
- **Aprendizagem** (3, 10): self-improvement loop + capture lessons
- **Qualidade** (4, 5, 6, 8): verification + elegance + autonomous bug fix + verify plan
- **Comunicação** (9): explain changes
- **Código** (11, 12, 13): simplicity + no laziness + minimal impact

Cada domínio tem pelo menos uma regra; nenhum tem mais de 4. Isso garante cobertura sem concentração excessiva em nenhuma área.

---

## Rule 13 — Minimal Impact: o mais violado

A Rule 13 (Minimal Impact: "touch only what is necessary") é consistentemente a mais violada em sessões de coding com agentes. O modelo tem tendência de "melhorar" código adjacente ao que foi solicitado — refactoring não solicitado, comments adicionados, imports reorganizados, style normalizado.

O problema não é que essas melhorias sejam ruins. O problema é que elas:
1. Aumentam o diff além do escopo acordado — code review fica mais difícil
2. Introduzem risco de bugs em código que funcionava — cada linha tocada é uma linha que poderia quebrar
3. Criam falsa sensação de progresso — o trabalho parece maior do que era, obscurecendo a mudança real

Minimal Impact é a formalização do princípio cirúrgico: um cirurgião não "melhora" tecido saudável adjacente enquanto opera o tecido doente. A operação tem escopo, e escopo é sacrossanto.

---

## Demand Elegance Balanced (Rule 5): a rule mais difícil de calibrar

A Rule 5 tem uma tensão explícita no nome — "Balanced" — que as outras regras não têm. Isso porque elegância sem limite vira over-engineering; ausência de elegância vira acumulação de dívida técnica.

O calibrador de Cherny: "Knowing everything I know now, implement the elegant solution." Isso força o agente a raciocinar a partir do contexto completo do problema — não do ponto específico onde o hack parece mais fácil. Se a solução elegante ainda é um one-liner depois dessa reflexão, use. Se requer refactor significativo que vai além do escopo da task atual, registre como debt e mova adiante.

"Skip for simple, obvious fixes" é a salvaguarda: não toda mudança de 3 linhas precisa passar por essa reflexão. A rule é para mudanças não-triviais onde a primeira solução que emerge pode ser um atalho que vai custar mais tarde.

---

## Aplicação das 13 regras no vault-michel

As 13 regras mapeiam para o CLAUDE.md do vault com algumas adaptações:

| Rule Cherny | Equivalente no vault |
|---|---|
| 1. Plan Mode Default | "enter plan mode, list steps, confirm scope" para ops 3+ passos |
| 2. Subagent Strategy | "Batch ingest → one subagent per source, parallel" |
| 3. Self-Improvement Loop | "After any correction → log in `04-SYSTEM/wiki/errors.md`" |
| 4. Verification Before Done | Checklist de 4 itens antes de marcar ingestão completa |
| 5. Demand Elegance | "Simplicity first — 1 consolidated page > multiple fragments" |
| 6. Autonomous Bug Fixing | Repair de wikilinks quebrados sem precisar de instrução |
| 7. Plan First | `.claude/todo.md` com checkable items |
| 8. Verify Plan | Re-read scope antes de editar |
| 9. Explain Changes | "Output: concise. One sentence per update." |
| 10. Capture Lessons | `errors.md` (max 30 entries; consolidar similares) |
| 11. Simplicity First | "Edit > Write; flat note se resolve" |
| 12. No Laziness | Wikilink verificado, manifesto atualizado — nunca skip |
| 13. Minimal Impact | "Do not modify files outside explicit scope of task" |

A única lacuna estrutural: o vault não tem `tasks/todo.md` permanente por projeto — o `.claude/todo.md` é sessional. Para projetos multi-sessão (ex: prep FIAP para uma fase), um todo.md persistente por projeto seria mais robusto.
