---
title: "Trinity: An Evolved LLM Coordinator"
type: source
source: "Clippings/Trinity An Evolved LLM Coordinator.md"
author: "Sakana AI"
published: 2026-04-25
created: 2026-06-22
ingested: 2026-06-22
tags: [llm-theory, multi-agent, model-composition, evolutionary-optimization, sakana-ai]
score: A
---

## Tese Central

Em vez de endlessly scale um monolithic model, evoluir um coordinator para orquestrar uma team de AIs especializadas. Trinity é test-time model composition: um coordinator leve assigna 3 roles (Thinker, Worker, Verifier) a LLMs do pool, sem modificar weights. Fewer que 20K learnable parameters, otimizado por evolutionary algorithm onde gradient-based methods fail.

## Pontos-Chave

1. **3 roles**: Thinker (high-level strategies, analyzes state), Worker (concrete problem-solving steps), Verifier (evaluates completeness e correctness). Coordinator assigna dinamicamente.
2. **Extreme efficiency**: coordinator relia em hidden states de compact LM + small routing head. <20K learnable parameters total. Offloads reasoning e skill execution para external models.
3. **Training challenge**: REINFORCE falhou (low signal-to-noise ratio, binary rewards, weak parameter coupling). Imitation learning ruled out (multi-turn labels prohibitively expensive). Solução: derivative-free evolutionary algorithm.
4. **Evolution > gradient**: evolution é uniquely suited para tight, high-dimensional coordination problem onde traditional gradient-based methods fail. Nature-inspired algorithms.
5. **Results**: SOTA no LiveCodeBench (86.2% pass@1). Zero-shot generalization para 4 unseen tasks (AIME, BigCodeBench, MT-Bench, GPQA). Superou every individual model no pool (GPT-5, Gemini 2.5-Pro, Claude-4-Sonnet) em average.
6. **Sakana Fugu**: Trinity é core engine powering multi-agent product Sakana Fugu 🐡.

## Conceitos

- Test-time model composition (vs weight modification)
- 3-role coordination: Thinker, Worker, Verifier
- <20K parameters coordinator via hidden states + routing head
- Evolutionary optimization onde REINFORCE/SFT fail
- Zero-shot task generalization sem retraining

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/agent-model-routing]]
- [[03-RESOURCES/concepts/llm-ml-foundations/generator-verifier-loop]]
- [[03-RESOURCES/sources/ai-agents/co-scientist-multi-agent-ai-partner-research]]