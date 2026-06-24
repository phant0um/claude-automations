---
title: "A near-autonomous AI chemist improves a challenging reaction in medicinal chemistry"
type: source
source_url: "https://openai.com/index/ai-chemist-improves-reaction/"
author: "OpenAI + Molecule.one"
published: 2026-06-16
created: 2026-06-22
updated: 2026-06-22
score: B
category: articles
tags: [source, articles, openai, gpt-5-4, molecule-one, maria, medicinal-chemistry, chan-lam-coupling, tempo, ai-science, autonomous-research]
---

# A near-autonomous AI chemist improves a challenging reaction in medicinal chemistry

OpenAI e Molecule.one mostram GPT-5.4 conectado a Maria (agentic chemistry AI + high-throughput lab) melhorando Chan-Lam Coupling para sulfonamides — TEMPO como additive surpreendente boostou yields para 88% dos substrates testados. 10,080 reações em 3 meses.

## Tese Central

GPT-5.4, integrado ao Maria (Molecule.one's agentic chemistry AI + lab autônomo), recebeu goal open-ended de melhorar uma reaction class. O sistema: gerou research proposals, designed e ran experiments, analyzed data, proposed follow-ups. Humanos remained in the loop (steering/grading prompts, proposal selection, corrections, bench-scale validation). OAI-M1-03 identificou TEMPO como additive — surprising hypothesis que human chemists found "both surprising and interesting." Near-autonomous, não fully autonomous: human judgment foi essential em todo o processo.

## Pontos-Chave

### O Resultado

- TEMPO (mild oxidant) como additive para Chan-Lam coupling de primary sulfonamides com boronic acids
- Yields melhoraram para 88% dos boronic acids e 83% dos sulfonamides
- Mean yield: 16.6% → 25.2%; share >30% yield: 15.6% → 37.5%
- Bench-scale: 11 de 14 substrate pairs com yield maior, maioria >2× increase
- 10,080 reações totais (vs. 3/dia = uma década de químico manual)
- 4-hydroxy-TEMPO (análogo mais barato) funciona com little loss

### Por que Chan-Lam Coupling Importa

- Forma carbon-nitrogen bonds (comuns em medicines)
- Coupling de primary sulfonamides com boronic acids: historicamente low yields
- Sulfonamides aparecem em anticancer, antimicrobials, diuretics
- Synthesis é major bottleneck em drug discovery: só se testa molecules que se pode fazer

### O Sistema: GPT-5.4 + Maria AI + Maria Lab

1. Scientists + Maria AI escrevem prompts → GPT-5.4 em harness gera/ranka thousands de research proposals
2. Human chemists selecionam 4 proposals para lab testing
3. Maria AI traduz plans em lab instructions, roda thousands de high-throughput experiments
4. Maria analyze raw data, returns structured results para GPT-5.4
5. GPT-5.4 propõe follow-up experiments

### Near-Autonomous, não Fully Autonomous

Humanos: high-level steering, judgment, corrections (ex: evitar DMSO com stronger oxidants), prep lab consumables, bench-scale validation. Modelo propôs key research ideas; humanos forneceram steering.

### Timeline

3 meses: primeiro prompt (Mar 4) → resultados shared com independent experts (Jun 4)

### Limitações

- Não mostra que AI pode independentemente run chemistry research end-to-end
- Dependeu de specialized high-throughput infrastructure
- Não estabelece generalização para outras coupling reactions/substrate classes/manufacturing
- Bench validation cobriu 14 representative pairs

### Preparedness

- Scoped a legitimate medicinal-chemistry problem (known coupling reaction, drug-like molecules)
- Sem toxins, chemical weapons, harmful compounds
- UK AI Security Institute evaluations
- Human chemists selecionaram proposals, reviewed plans, controlled physical infrastructure

## Conceitos

- [[03-RESOURCES/concepts/agent-systems/automated-research-agents]] — research agents autônomos
- [[03-RESOURCES/concepts/agent-systems/human-in-the-loop]] — human oversight
- [[03-RESOURCES/concepts/agent-systems/agent-eval-framework]] — evaluation
- [[03-RESOURCES/concepts/agent-systems/synthetic-training-environments]] — training environments

## Links

- [[03-RESOURCES/entities/OpenAI]] — empresa autora
- [[03-RESOURCES/entities/gpt]] — GPT-5.4