---
title: "5 Principles Every AI Research Stack Must Solve"
type: source
created: 2026-05-24
updated: 2026-05-24
tags: [source, ai-research, verification, human-ai-collaboration, automation-limits, research-lifecycle]
score: 7
author: "@AlphaSignalAI / Lingdong Kong et al. (NUS/Apple)"
source_url: "https://x.com/AlphaSignalAI/status/2057867718632550782"
domain: ml-research-papers
---

# 5 Principles Every AI Research Stack Must Solve

Síntese do paper **"AI for Auto-Research: Roadmap & User Guide"** (arXiv, Mai 2026) — 20 autores, Lingdong Kong (NUS/Apple), cobre 250+ tools, 52 benchmarks, 33 end-to-end systems.

## Contexto Quantitativo

- AI Scientist v2: ICLR score 6.33 a $25/paper — acima do threshold 5.69
- FARS: $1000/paper, score 5.05 — **abaixo** do threshold
- SWE-bench Verified: 76%+ (bug fixes conhecidos)
- ResearchCodeBench: 37-39% (implementar algoritmo de paper) — semantic error 58.6%
- MLR-Bench autônomo: **80% dos resultados reportados são fabricados**
- LLM-reviewer: 95.8% de papers rejeitados classificados como aceitáveis

## 5 Princípios

**1. Structured tasks work. Open-ended judgment does not.**
- Solid: retrieval, citation, plot drafts, grammar, format conversion
- Fragile: novelty assessment, experiment design, long-horizon reasoning

**2. Generation outpaces verification at every stage.**
- AI produz research-shaped artifacts mais rápido do que pode provar que estão corretos
- Ideias parecem novas na página e fracassam na implementação
- Risco: artefatos tratados como validados por parecerem completos

**3. Human-governed collaboration beats full autonomy.**
- ICLR 2025 study (22,467 reviews): 89% melhoraram quando LLM deu feedback sobre draft humano
- Mesmos modelos sozinhos: 95.8% misclassification
- "The strongest empirical result in the paper"

**4. Provenance and attribution must be first-class.**
- Campo não tem infraestrutura de auditoria ainda
- Fabricated results como falha sistêmica, não acidental

**5. Human handoffs são onde os sistemas falham.**
- Transition points entre fases são onde fabrication acontece
- Fully autonomous = sem checkpoint para verificação humana

## Framework: 4 Fases × 8 Estágios

- **Creation**: ideation, literature, coding, figures
- **Writing**: manuscript
- **Validation**: peer review, rebuttal
- **Dissemination**: Paper2X

## Reframe Central

Campo parou de ser capability-limited → passou a ser **reliability-limited**.

## Ver Também

- [[03-RESOURCES/concepts/agent-systems/agent-eval-framework]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-as-a-judge]]
- [[03-RESOURCES/sources/ml-research-papers/applying-statistics-to-llm-evaluations]]
