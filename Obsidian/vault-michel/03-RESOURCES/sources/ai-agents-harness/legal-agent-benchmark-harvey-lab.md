---
title: "Initial Results on Legal Agent Benchmark (LAB) — Harvey"
type: source
source_url: "https://x.com/gabepereyra/status/2059320727988224128"
author: "@gabepereyra (Harvey AI)"
published: 2026-05-26
ingested: 2026-05-28
tags: [ai-agents, legal-ai, benchmark, harvey, LAB, evaluation, jagged-intelligence, multi-model]
---

# Legal Agent Benchmark: Initial Results

**Tese central:** Modelos frontier completam menos de 10% das tarefas legais sob o padrão all-pass estrito do LAB. O leaderboard muda por área de prática: nenhum modelo lidera tudo. A frontier de inteligência não pode ainda entregar trabalho legal completo — e benchmarks de uma única dimensão escondem o custo e latência crescentes.

## Key insights

### Performance geral

- Sob all-pass (cada critério de rubric deve passar para a task contar): Claude Opus 4.7 lidera em 7.1%, Sonnet 4.6 em 5.4%, Opus 4.6 em 4.2%, GPT-5.5 em 2.1%, Gemini 3.5 Flash em 0.8%.
- **Legal work is far from saturated.**

### Jagged Intelligence por área de prática

- GPT-5.5 lidera em regulated/emerging-company (research-heavy).
- Opus 4.7 lidera em corporate transactions/funds (synthesis e análise).
- Sonnet 4.6 lidera em privacy, tax, private-client (comparação estruturada contra statutes).
- **Conclusão**: deployment de produção forte será multi-model desde o início — não há silver bullet.

### Custo e latência

- Opus 4.7: ~$50.90/task, ~22 min de latência.
- GPT-5.5: ~3x mais barato que Opus 4.7.
- Gemini 3.5 Flash: <6 min, mas score menor.
- O custo de operar na frontier cresce com ela.

### Análise comportamental (agent traces)

Comportamentos que correlacionam com sucesso (melhora no all-pass score):
- Pesquisa ampla antes de redigir (>90% document coverage): +0.4 pts
- Validação pós-draft: +0.8 pts
- **Revisar E revisar após check**: +1.5 pts (sinal mais forte)
- Retrieval targetado: +0.3 pts
- Análise estruturada (code/shell para computar): +0.3 pts
- Grounding no record após draft: +0.3 pts

Comportamentos negativos:
- Alto parallel tool use (5+ tool calls em 1 turn): -0.5 pts (noisy fan-out)
- Draft sem review posterior: -1.2 pts

### Implicação de design

Opus 4.7 é o mais self-corrective — mais tempo em drafting, frequentemente re-checks e revisa antes de finalizar. GPT-5.5 tem o maior segmento de search. Os padrões emergentes se parecem com o que um associate competente faria: contexto antes do draft, check antes de submeter, revisão substantiva.

## Implicações para o vault

- Os dados de Harvey 6x Dreaming aparecem em [[03-RESOURCES/sources/memory-context-rag/claude-agent-memory-12-steps-dreaming]].
- Jagged intelligence é conceito de [[03-RESOURCES/entities/Andrej Karpathy]] aplicado a work product especializado.
- Self-correction como comportamento mais correlacionado com sucesso reforça [[03-RESOURCES/concepts/agent-systems/agent-error-correction]].
- Multi-model deployment necessário para maximizar performance real: nova entrada para [[03-RESOURCES/concepts/agent-systems/multi-model-orchestration]].
- Custo frontier ($50/task, 22 min) é dado concreto para [[03-RESOURCES/concepts/agent-systems/regulated-domain-agents]].

## Links

- [[03-RESOURCES/entities/Claude-Opus-47]]
- [[03-RESOURCES/entities/Claude-Sonnet-46]]
- [[03-RESOURCES/concepts/agent-systems/multi-model-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/regulated-domain-agents]]
- [[03-RESOURCES/concepts/agent-systems/agent-error-correction]]
- [[03-RESOURCES/concepts/agent-systems/agent-eval-framework]]
