---
title: "Claude Code Cheat Sheet — 6 Months Daily Use"
type: source
created: 2026-05-24
updated: 2026-05-24
tags: [source, claude-code, workflow, harness, hooks, memory, skills]
score: 7
author: "@InduTripat82427"
source_url: "https://x.com/InduTripat82427/status/2057815250792317090"
domain: guides-courses-howtos
---

# Claude Code Cheat Sheet — 6 Months Daily Use

Síntese de lições de comunidade Reddit (senior engineers usando Claude Code daily). Compilação de 12 princípios que realmente mudaram workflow.

## Lições Principais

**1. Só o primeiro step.** Não peça a feature inteira. Só o primeiro passo. Review → adjust → continue → repeat. Mais lento 5 min, muito mais rápido 5 horas.

**2. Planning mode = arquiteto.** Workflow: Claude cria o plano → Codex ataca → Claude corrige → implementação começa. AI peer review.

**3. Hooks > Memory** (framework crítico):
- **Skills** = advice (sugestão)
- **Memory** = reminders (probabilístico)
- **Hooks** = laws (determinístico)

Memory é probabilística. Hooks são determinísticos. Hook BLOQUEIA ação se condição não atendida.

**4. CLAUDE.md não é knowledge dump.** Claude já sabe React, Python, APIs. Só coloque: business logic, architecture rules, domain context, naming conventions, project invariants. "Only include things Claude gets wrong without it."

**5. AGENTS.md como source of truth.** AGENTS.md = fonte canônica → CLAUDE.md = arquivo de import (`@AGENTS.md`). Portável entre Cursor/Codex/Gemini. Infraestrutura, não prompt.

**6. Retro sessions.** Fim de sessão: "What did we learn today?" → salva bugs, failed assumptions, arch decisions, rejected approaches. Constrói institutional memory. "Retro turns disposable context into durable context."

**7. Separação de memória em camadas:**
- `CLAUDE.md` → core project rules
- `AGENTS.md` → universal instructions
- `skills/` → reusable workflows
- `retro/` → session learnings
- `memory/` → temporary evolving state
- `ADR/` → architecture decisions

**8. Context drift destrói projetos silenciosamente.** Sessões longas "poisonam" o modelo. Agente começa a esquecer assumptions, contradizer decisões anteriores, reintroduzir bugs resolvidos. Fix: handoff notes + retros + fresh sessions agressivos.

**9. Preview mode dá "olhos" ao Claude.** Claude vê rendering bugs, broken flows, frontend issues visualmente.

**10. Multi-model workflows:** Claude → implementação; Codex → crítica; Gemini → segunda opinião; CodeRabbit → PR review. "One model builds. Another attacks."

**12. Mindset shift — system designers, não prompt engineers.** Os melhores usuários constroem: memory layers, hooks, review pipelines, retrospectives, handoff systems, reusable skills, deterministic workflows. "They're building operating systems around the model."

## Ver Também

- [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
- [[03-RESOURCES/sources/guides-courses-howtos/clipping-claude-code-large-codebases]]
- [[03-RESOURCES/sources/skills-prompting-mcp/clipping-anatomy-claude-skill]]
