---
title: "The Agent Optimization Loop and How We Built It in Foundry"
type: source
source: "Clippings/The agent optimization loop and how we built it in Foundry.md"
author: "dan makeshift (Microsoft)"
published: 2026-06-02
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents, optimization, evaluation, microsoft-foundry, agent-config]
score: A
---

## Tese Central

Melhorar agent quality at scale é dos problemas operacionais mais difíceis. Você tem traces, tem evals, vê o que está errado e mede quão errado — mas fixar sem quebrar algo else é onde fica stuck. A solução: reframing agent improvement como search problem (não debug), com um optimizer que propõe, scoreia, e promove configs apenas se quality holds.

## Pontos-Chave

1. **Wall atual**: craft (prompt engineering) → traces (visibility) → evaluation (quality bars) → wall. Fix uma coisa quebra duas outras. Manual guess-and-check através de config changes.
2. **Reframing**: agent que skipa budget check não é "broken" como null pointer. Instruction não encode enough constraint. Dúzias de variants podem fix, maioria regressa algo else. Sem stack trace apontando broken line.
3. **4-step optimization loop**: (1) Optimizer gera candidates (instructions, models, skills, tool definitions). Reflector model lê failing traces, identifica por que scored poorly, propõe targeted changes. (2) Candidates scored e ranked (mesmos evaluators, mesmo dataset, comparison determinística). Per-dimension scoring. (3) Developer reviews e decide. (4) Winner ships como next version (versioned, reversible, auditable).
4. **Reflector é a peça mais importante**: qualidade do reflector (model que diagnosifica failures) tem impacto desproporcional. Mais que agent's own model, mais que tuning parameters. Swapping para stronger reflector melhorou results mais que qualquer single change. **Better diagnosis beats better execution.**
5. **Key takeaways**: (1) Quality é search problem não debug. (2) Invest in diagnosis. (3) Evaluators são o ceiling. (4) Keep human in the loop.
6. **Foundry Agent Service**: `azd ai agent eval init` (generate dataset & evaluator), `eval run` (score baseline), `optimize` (search candidates), `optimize apply --candidate <id>`, `deploy`. 5 commands.
7. **AI-assisted bootstrapping**: system gera dataset e evaluator baseado em agent config + traces. Descreva em parágrafo → multi-dimension evaluator.
8. **A/B deployment (next)**: promover candidate alongside current version, route fraction de traffic, comparar outcomes. Developer gate extends into production.
9. **Widening search space (next)**: integrar Foundry IQ (knowledge grounding) + Foundry Toolbox (curated tool sets) como tunable dimensions. Search over retrieval config, knowledge sources, tool composition.

## Conceitos

- Agent optimization como search problem (não debugging)
- Reflector: meta-cognition layer que diagnostica failures
- Per-dimension scoring rubric
- Configuration space: instructions, models, skills, tool definitions
- Evaluators como ceiling de optimization quality

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-eval-framework]]
- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]]
- [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]]
- [[03-RESOURCES/sources/ai-agents/is-it-agentic-enough-benchmarking-open-models]]- [[03-RESOURCES/concepts/agent-systems/rl-conductor-orchestration]] — structurally identical to RLHF pipeline, applied to agent config
