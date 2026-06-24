---
title: Karpathy's Four Principles for LLM Coding
type: concept
status: developing
created: 2026-04-27
updated: 2026-04-27
tags: [claude-code, best-practices, software-engineering, andrej-karpathy]
---

# Karpathy's Four Principles for LLM Coding

[[Andrej Karpathy]]'s observations on LLM pitfalls in software work, formalized by [[Forrest-Chang]] as guidance for Claude Code users.

## Root Problems

1. **Hidden assumptions** — Models pick interpretations silently; no clarification-seeking; inconsistencies & tradeoffs buried
2. **Overcomplication** — Bloat abstractions, 1000-line solutions for 100-line problems, unnecessary error handling
3. **Uncontrolled edits** — Change/remove code not fully understood as side effects, even if orthogonal to task

## The Four Principles

### 1. Think Before Coding

**Rule:** Don't assume. Don't hide confusion. Surface tradeoffs.

Actions:
- State assumptions explicitly; ask rather than guess
- Present multiple interpretations when ambiguity exists
- Push back on simpler approaches if they exist
- Name unclear things; ask for clarification before proceeding

Opposes: Silent assumption-picking, lack of due diligence.

### 2. Simplicity First

**Rule:** Minimum code solving the problem. Nothing speculative.

Actions:
- No features beyond what's asked
- No abstractions for single-use code
- No "flexibility" or "configurability" not requested
- No error handling for impossible scenarios
- If 200 lines could be 50, rewrite it

Test: "Would a senior engineer call this overcomplicated?" → Yes = rewrite.

Opposes: Feature creep, premature abstraction, gold-plating.

### 3. Surgical Changes

**Rule:** Touch only what you must. Clean up only your own mess.

Actions:
- Don't "improve" adjacent code, comments, formatting
- Don't refactor things that aren't broken
- Match existing style (even if you'd do it differently)
- When your changes orphan symbols: remove only what YOU made unused
- Never remove pre-existing dead code unless asked

Test: Every changed line traces directly to user's request.

Opposes: Drive-by refactoring, scope creep, invisible cleanup.

### 4. Goal-Driven Execution

**Rule:** Define success criteria. Loop until verified.

Transform imperative instructions into verifiable goals:

```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong criteria let LLM loop independently. Weak criteria ("make it work") require constant clarification.

Quote: "LLMs are exceptionally good at looping until they meet specific goals. Don't tell it what to do, give it success criteria and watch it go." — [[Andrej Karpathy]]

Opposes: Vague requirements, one-shot instructions without verification.

## How to Know It's Working

✅ Fewer unnecessary changes in diffs  
✅ Fewer rewrites due to overcomplication  
✅ Clarifying questions come before implementation  
✅ Clean, minimal PRs (no drive-by refactoring)

## Installation & Use

**Claude Code Plugin (recommended)**
```bash
/plugin marketplace add forrestchang/andrej-karpathy-skills
/plugin install andrej-karpathy-skills@karpathy-skills
```

**Per-project CLAUDE.md**
```bash
curl -o CLAUDE.md https://raw.githubusercontent.com/forrestchang/andrej-karpathy-skills/main/CLAUDE.md
```

**Cursor Support** — `.cursor/rules/karpathy-guidelines.mdc`

## Tradeoff Note

These principles bias toward caution over speed. For trivial tasks (typo fixes, obvious one-liners), use judgment — not every change needs full rigor. Goal: reduce costly mistakes on non-trivial work, not slow down simple tasks.

---

**Formalized by:** [[Forrest-Chang]] (@forrestchang)  
**Original observations:** [[Andrej Karpathy]] (@karpathy)  
**Repository:** forrestchang/andrej-karpathy-skills (MIT)  
**Related project:** Multica (agent platform leveraging these principles; arquivado)  
**See Also:** [[04-SYSTEM/wiki/principles]] (seção II — Karpathy 4P aplicado ao vault)

## Social Validation

Repo viral atingiu 130K★ + 12.9K forks no GitHub (jan 2026). Evidência de adoção em massa do padrão — 4 princípios mapeiam diretamente em failure modes mais comuns de LLM coding: wrong assumptions, bloated abstractions, unrelated edits, weak verification.

Ver: [[03-RESOURCES/sources/skills-prompting-mcp/viral-claudemd-130k-stars-karpathy]]

## Tensão com /goal command

[[03-RESOURCES/concepts/claude-code-tooling/goal-command]] pula clarifying questions (princípio 1 exige ask if uncertain). Resolução: criticidade decide — tasks reversíveis → /goal autônomo; tasks irreversíveis → clarifying gate mantido.

## Evidências

- **[2026-06-21]** Tutorial passo-a-passo (em chinês, voltado a leigos) para montar um knowledge base pessoal combinando Obsidian (armazenamento local em Markdown) + Claude Code (curadoria/organização) — propõe estrutura de pastas fixa (Inbox → Raw → Notes... — [[claude-code-obsidian-ai]]
- **[2026-06-21]** Os 4 princípios originais de Karpathy para CLAUDE.md (Think Before Coding, Simplicity First, Surgical Changes, Goal-Driven Execution — janeiro 2026, popularizados por Forrest Chang) fecham ~40% das falhas de sessões Claude Code não super... — [[claude-keeps-breaking-your-code-because-you-re-missing-one-file-here-are-the-12-]]
- **[2026-06-21]** Loop engineering trata codificação não como prompt único mas como ciclo repetido de feedback: planejar, agir, observar o resultado, ajustar até o trabalho estar de fato pronto. Diferente de prompt engineering (escrever uma pergunta melho... — [[loop-engineering-teaching-ai-agents-to-learn-from-their-own-mistakes]]
- **[2026-06-21]** Thread viral propondo conectar um vault Obsidian completo (notas de cliente, SOPs, logs de reunião, decisões de negócio) ao Hermes Agent, que o usa como contexto persistente e auto-evoluído ao longo do tempo, sugerindo e construindo auto... — [[miles-deutscher-on-x-i-connected-my-entire-business-to-hermes-x-obsidian-client-]]
- **[2026-06-21]** Lista (chinesa) das 10 AI Skills mais populares para Obsidian, ranqueadas por instalações — argumenta que o real diferencial do Obsidian não é escrever notas, mas se tornar um knowledge base local que um agente de IA pode ler, buscar, or... — [[obsidian-10-ai-skill-1-37]]
- **[2026-06-21]** Autor que há 2 anos escreveu post viral contra uso de LLM em programação (argumentando que tiraria a diversão do pensamento arquitetural) reverte a posição: LLMs só são tão bons quanto quem os usa — não substituem julgamento técnico/artí... — [[the-art-of-programming-and-why-i-was-wrong-about-llms]]
- **[2026-06-21]** Código gerado por IA pode rodar e parecer limpo enquanto não é seguro de fato — estudo 2026 achou apenas ~35% de código backend gerado por IA seguro E correto; teste da Veracode em 100+ modelos achou que quase metade do código gerado emb... — [[how-to-review-ai-generated-code-like-a-senior-developer]]
