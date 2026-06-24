---
title: "Structured CLAUDE.md Template (srishticodes)"
type: source
source_type: social-media
author: "srishticodes"
created: 2026-05-06
tags: [claude-code, claude-md, template, best-practices]
triagem_score: 8
---

Structured CLAUDE.md template based on Boris Cherny's internal Anthropic workflows. Pattern of encoding corrections into CLAUDE.md so the model accumulates project-specific rules across sessions.

## Source

Ingested from: `clippings/Thread by @srishticodes on Thread Reader App.md`
Ingested: 2026-05-06 (daily scheduled task)

---

## Core Insight

The CLAUDE.md file is not documentation — it is a stateful memory artifact. Every correction you give Claude Code mid-session is a signal that your CLAUDE.md is missing a rule. The Boris Cherny workflow (Anthropic internal) formalizes this: whenever you correct Claude, you immediately encode that correction into CLAUDE.md so future sessions don't repeat the mistake.

This transforms CLAUDE.md from a static config file into a living correction log that improves the agent's project-specific behavior over time.

## Template Structure

The recommended structure from the srishticodes thread (derived from Boris Cherny's Anthropic workflow):

```markdown
# [Project Name] — Claude Code Instructions

## Project Overview
Brief: what this project is, stack, current state.

## Principles
Behavioral rules that override defaults. Ordered by importance.
Example: "Never modify files outside the explicit scope of the current task."

## Architecture
Core structural facts the model must know to navigate the codebase correctly.
Example: "Authentication lives in /src/auth/. Never mock it in tests."

## Conventions
Naming, formatting, import order, test patterns — the things that differ from defaults.

## Common Corrections
[This section grows over time]
- "Do not add console.log statements unless explicitly asked."
- "Use our custom useFetch hook, not raw fetch()."
- "Run `make lint` before marking any task done."

## Commands
Key commands the agent should know: build, test, lint, deploy.
```

## The Accumulation Pattern

The critical practice:

1. Claude makes a mistake → you correct it
2. You immediately ask Claude: "Add that correction to CLAUDE.md"
3. CLAUDE.md grows a new rule in the "Common Corrections" section
4. Future sessions don't repeat that mistake

Over 2–4 weeks, CLAUDE.md becomes a precise specification of how Claude should behave in this project. The model's effective performance in the project increases not because the model improved, but because the context it receives improved.

## Why Boris Cherny's Version Matters

Boris Cherny is an engineer at Anthropic who worked on Claude Code's core design. His internal workflow being shared externally validates that CLAUDE.md-as-correction-log is the intended use pattern, not a workaround.

Key distinction from naive CLAUDE.md usage:
- **Naive:** write CLAUDE.md once at project start, never touch it
- **Cherny pattern:** treat every correction as a CLAUDE.md update event

## Practical Section: What Goes in CLAUDE.md vs What Doesn't

**Put in CLAUDE.md:**
- Corrections to repeated mistakes
- Project-specific conventions that differ from language defaults
- Architectural facts (directory layout, key files, naming patterns)
- Commands (build, test, lint)
- Rules that should fire on every task

**Do not put in CLAUDE.md:**
- Task-specific context (put it in the prompt)
- Information that changes frequently (it goes stale and becomes noise)
- Everything — CLAUDE.md compliance drops past ~200 lines; be selective

## Sizing and Compliance

Research on CLAUDE.md effectiveness (from vault memory: [[03-RESOURCES/entities/feedback-claudemd-limits]]):
- Compliance begins degrading past 14 rules
- 200 lines is a practical ceiling before the model routinely ignores rules
- Rules > examples: a single clear prohibition outperforms 3 examples of the wrong thing

Implication: the Cherny accumulation pattern must be paired with periodic pruning. When "Common Corrections" grows past ~10 entries, consolidate similar rules and remove those that no longer apply.

## Vault Application

This vault's CLAUDE.md (`/Users/michelcsasznik/Obsidian/vault-michel/CLAUDE.md`) implements this pattern:
- Top-level structure follows the Cherny template (principles, architecture, conventions, commands)
- The `04-SYSTEM/wiki/errors.md` file serves the "Common Corrections" role — capped at 30 entries with consolidation before adding
- Session-end hooks prompt for CLAUDE.md updates when drift is detected

## Related

- [[03-RESOURCES/concepts/claude-code-tooling/claude-md-cost-optimization]]
- [[03-RESOURCES/sources/guides-courses-howtos/clipping-post-learnwithbrij-claude-5-layers]]
- [[03-RESOURCES/entities/Claude Code]]
- [[04-SYSTEM/wiki/errors]]

## Por que o CLAUDE.md como log de correções é mais eficaz do que documentação inicial

Documentação escrita antes do uso é baseada em suposições sobre o que o agente vai errar. Documentação escrita a partir de correções reais é baseada em evidência. O padrão Cherny faz uma aposta contraintuitiva: é mais eficiente deixar o agente errar, identificar o erro, e encodificar a correção do que tentar antecipar todos os erros possíveis antecipadamente.

Isso funciona porque os erros reais têm uma distribuição muito mais estreita do que os erros possíveis. Na prática, um agente trabalhando em um projeto específico erra os mesmos tipos de coisas repetidamente — convenções de import, padrões de teste, estrutura de arquivos, comandos de build. Após 2-4 semanas de uso ativo com o padrão Cherny, o CLAUDE.md converge para um conjunto denso de regras de alta especificidade que cobre exatamente os erros que aquele projeto específico induz.

## O trade-off entre especificidade e tamanho

O limite de 200 linhas / ~14 regras cria uma tensão real: à medida que o CLAUDE.md cresce com correções, o compliance cai. A solução correta não é parar de adicionar correções — é consolidar periodicamente. Regras similares podem ser combinadas; regras que já foram internalizadas pelo uso extensivo (o agente não erra mais aquele comportamento) podem ser removidas.

Para o vault-michel, a separação entre CLAUDE.md (regras de alta prioridade, sempre ativas) e `04-SYSTEM/wiki/errors.md` (log de erros específicos, lido sob demanda) implementa essa hierarquia: o que o agente precisa em toda sessão fica no CLAUDE.md; o que serve como referência histórica fica no errors.md. O cap de 30 entradas no errors.md força a mesma curadoria que o cap de 200 linhas no CLAUDE.md.

## Quando o padrão não funciona

O padrão Cherny assume que o custo de uma sessão com erro é baixo o suficiente para ser absorvido. Em domínios onde um erro pode causar dano irreversível (deploy em produção, deletar dados, executar código externo não revisado), esperar o erro para depois encodificar a correção não é uma estratégia aceitável. Nesses domínios, o CLAUDE.md precisa ser pré-populado com regras de segurança antes do primeiro uso, não construído iterativamente a partir de falhas reais.
