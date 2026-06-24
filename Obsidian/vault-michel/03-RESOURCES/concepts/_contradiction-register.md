---
title: Contradiction Register
type: register
created: 2026-06-18
updated: 2026-06-18
tags: [contradictions, register, cumulative]
---

# Contradiction Register

Registro cumulativo de contradições detectadas pelo pipeline diário (F3.1).
Cada contradição é uma tensão entre 2+ sources sobre o mesmo tópico.

**Princípio**: contradições não são bugs — são sinais de onde o conhecimento
ainda está se formando. Accumular até resolver ou confirmar como paradoxo.

**Status:** `aberta` · `resolvida` · `paradoxo`

---

## Contradições

| Data | Tópico | Fonte A → tese | Fonte B → tese | Status |
|------|--------|----------------|----------------|--------|
| 2026-06-21 | Qual modelo é melhor que Opus em coding | [[stop-paying-200month-for-opus-glm-5-2-just-matched-it-for-0]] → GLM-5.2 (open-source) "troca golpes reais" com Opus em benchmarks de coding (Terminal-Bench, SWE-bench Pro) | [[grok-build-0-1-beat-every-frontier-model-in-a-kilo-code-reviews-test]] → Grok Build 0.1 supera Opus 4.8, Sonnet 4.6, GPT-5.5 e Gemini 3.1 Pro em teste informal de code review (10 bugs plantados) | aberta |
| 2026-06-22 | Scale vs efficiency no AI paradigm | [[intel-moores-law-broken-memory-constraint]] → AI Americano = "resource-eating monster", brute-force scale é dead end, DeepSeek prova que constraint-driven innovation é superior | [[6x-faster-migration-tensorflow-to-jax]] → Google usa multi-agent system em scale massivo (YouTube models) com 6-8x speedup — scale + AI agents como solução, não contra scale | aberta |

---

## Resolvidas

| Data | Tópico | Resolução | Fonte que resolveu |
|------|--------|-----------|---------------------|
| _(contradições resolvidas movidas para cá)_ | | | |

---

## Paradoxos

| Data | Tópico | Razão do paradoxo |
|------|--------|-------------------|
| _(contradições confirmadas como paradoxo — ambas válidas em contextos diferentes)_ | | |

---

## Stale (> 14 dias aberta)

Populado automaticamente pelo report-agent F3.4 stale check. Itens stale
são flagados para revisão manual do Nexus.