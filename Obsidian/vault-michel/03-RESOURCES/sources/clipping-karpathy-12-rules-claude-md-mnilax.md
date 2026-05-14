---
title: "Karpathy's 4 CLAUDE.md rules → 12 rules (41% → 3% mistake rate)"
type: source
source_type: clipping
platform: X/Twitter
author: "@Mnilax"
url: "https://x.com/Mnilax/status/2053116311132155938"
published: 2026-05-09
created: 2026-05-09
updated: 2026-05-09
tags: [karpathy, claude-md, behavioral-rules, agent-engineering, token-budget]
---

# Karpathy's 4 → 12 CLAUDE.md Rules

Extensão prática do template Karpathy (Forrest Chang, 120K stars) com 8 regras adicionais testadas em 30 codebases por 6 semanas.

## Resultado

| Config | Mistake Rate | Compliance |
|--------|-------------|------------|
| Sem CLAUDE.md | 41% | — |
| Karpathy 4 regras | 11% | 78% |
| 12 regras completas | 3% | 76% |

## As 12 Regras

**Originais (Karpathy/Forrest Chang):**
1. Think Before Coding — state assumptions, ask before guessing
2. Simplicity First — minimum code, nothing speculative
3. Surgical Changes — touch only what you must
4. Goal-Driven Execution — define success criteria, loop until verified

**Adicionais (@Mnilax):**
5. Use model only for judgment calls — routing/retries/deterministic = code, not LLM
6. Token budgets are not advisory — 4K/task, 30K/session, surface breaches
7. Surface conflicts, don't average them — pick one pattern, flag other for cleanup
8. Read before you write — read exports, callers, utilities before adding code
9. Tests verify intent, not just behavior — test WHY, not just WHAT
10. Checkpoint after every significant step — summarize done/verified/remaining
11. Match codebase conventions — conformance > taste inside codebase
12. Fail loud — "completed" wrong if anything skipped silently

## Onde Karpathy Quebra (4 gaps)

1. **Long-running agent tasks** — sem budget, sem checkpoint, sem fail-loud
2. **Multi-codebase consistency** — "match existing style" assume 1 style
3. **Test quality** — "tests pass" ≠ tests meaningful
4. **Production vs prototype** — Simplicity First overfires em early-stage code

## O que NÃO funcionou

- Mais de 14 regras → compliance cai para 52%
- 200 linhas = teto real do CLAUDE.md
- Exemplos > regras em custo de contexto (3 examples ≈ 10 rules)
- Identity prompts ("be senior") → 0 efeito
- "Be careful" / "think hard" → compliance ~30%

## Mental Model

> CLAUDE.md is not a wishlist. It's a behavioral contract that closes specific failure modes you've observed. Every rule should answer: what mistake does this prevent?

## Relações

- [[03-RESOURCES/concepts/karpathy-four-principles]] — regras 1-4 originais
- [[03-RESOURCES/concepts/claude-md-behavioral-contract]] — CLAUDE.md como contrato comportamental
- [[03-RESOURCES/entities/forrest-chang]] — autor do template original (5,828 stars dia 1)
- [[03-RESOURCES/entities/andrej-karpathy]] — thread original (Janeiro 2026)
