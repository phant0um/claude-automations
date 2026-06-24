---
title: "String Seed of Thought (SSoT): Distribution-Faithful and Diverse Generation"
type: source
source: "Clippings/String Seed of Thought Prompting LLMs for Distribution-Faithful and Diverse Generation.md"
author: "Sakana AI"
published: 2026-04-20
created: 2026-06-22
ingested: 2026-06-22
tags: [llm-theory, prompting, diversity, sampling, sakana-ai]
score: B
---

## Tese Central

LLMs não conseguem flip coins in their heads. Quando pedidos para "flip a fair coin" 100 vezes, ratio drifta far de 50:50. SSoT (String Seed of Thought) resolve: instruir o LLM para gerar uma random string no próprio output, depois manipular essa string para derivar a resposta. Sem external RNG, apenas small addition ao prompt.

## Pontos-Chave

1. **Bias problem**: LLMs entendem qual probabilidade target deveria ser, mas gerar outputs que faithfulmente seguem uma distribution é problema separado. Bias se estende: brainstorming de ideias clusteram em narrow range.
2. **SSoT method**: LLM gera random string no próprio output → manipula string → deriva answer. Pequena adição ao prompt, sem external random number generator.
3. **Results**: significant reduction de output bias across wide range de LLMs, open e closed. Reasoning models (DeepSeek-R1) alcançam accuracy close a actual random sampling.
4. **Generalization**: binary choices → n-way selections → arbitrary probability distributions.
5. **NoveltyBench**: SSoT outperformed other approaches across all 6 categories enquanto maintaining output quality.
6. **ICLR 2026**: aceito como conference paper.

## Conceitos

- Distribution-faithful generation como problema distinto de understanding
- String Seed of Thought: random string generation → manipulation → answer derivation
- NoveltyBench diversity benchmark
- Sampling bias em LLMs (coin flips, creative generation)

## Links

- [[03-RESOURCES/concepts/llm-ml-foundations/llm-rational-agency-gap]]
- [[03-RESOURCES/sources/llm-theory/trinity-evolved-llm-coordinator]]