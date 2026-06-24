---
title: "Agentic Harness Engineering: Observability-Driven Automatic Evolution of Coding-Agent Harnesses"
type: source
source_type: paper
source_url: https://arxiv.org/abs/2604.25850
created: 2026-05-31
updated: 2026-06-10
tags: [ai-agents, harness-engineering, papers, self-improvement]
status: seed
---

# AHE — Agentic Harness Engineering (Fudan/PKU/NexAU)

**Autores:** Fudan University, Peking University, Shanghai Qiji Zhifeng Co. (NexAU)
**Código:** [china-qijizhifeng/agentic-harness-engineering](https://github.com/china-qijizhifeng/agentic-harness-engineering)

## Resumo

AHE = sistema observability-driven que evolui automaticamente o **harness** ao redor de um coding agent — modelo base fica fixo, o que evolui são os componentes do harness: system prompts, tool descriptions, tool implementations, middleware, skills, sub-agents e memória de longo prazo.

3 pilares de observability:
1. **Component observability** — cada componente editável do harness vira representação file-level (action space explícito + revertível)
2. **Experience observability** — destila milhões de tokens de trajetórias brutas em corpus de evidência em camadas (drill-down)
3. (terceiro pilar — meta-harness, evolução concorrente)

## Resultados

10 iterações AHE: pass@1 no Terminal-Bench 2 sobe de 69.7% → 77.0% (GPT-5.5), superando harness humano Codex-CLI (71.9%) e baselines self-evolving (ACE, TF-GRPO). NexAU-AHE atinge 84.7% ± 2.1 pass@1. Harness congelado transfere para SWE-bench-Verified.

## Por que importa (vault)

Evidência direta para [[03-RESOURCES/concepts/agent-systems/harness-adaptation]] e [[03-RESOURCES/concepts/agent-systems/skill-optimization-gradient-descent]] — harness evolution automatizada via observability, não fine-tuning do modelo.

## Notes
Conteúdo via WebSearch (2026-06-10) — Clippings original consumido.
