---
title: "LLMs 101 — A Practical Guide (2026)"
type: source
created: 2026-05-24
updated: 2026-05-24
tags: [source, llm-foundations, inference, kv-cache, quantization, local-ai, hardware]
score: 7
author: "@TheAhmadOsman"
source_url: "https://x.com/TheAhmadOsman/status/2057590224729911346"
domain: guides-courses-howtos
---

# LLMs 101 — A Practical Guide (2026)

**@TheAhmadOsman** (mesmo autor da série Inference Engines): guia model-first para mechanics de LLMs. Complementa a série de hardware.

## Ponto de Partida: O Loop

```
Text → Tokens → Transformer → Attention → KV Cache → Next Token → repeat
```

Uma vez que esse loop fica claro, as escolhas de hardware e software se tornam raciocináveis.

## Sequência do Guia

**Model mechanics primeiro:**
- Inference, tokens, Transformers, attention
- KV cache (working memory que torna o loop usável)
- Prefill vs decode
- Decoding controls (temperature, top-p, top-k)
- Model packages, chat templates, model types
- Long context, RAG, agents, fine-tuning, multimodal

**Depois: deployment layer:**
- O que "local" realmente significa
- Quantization, VRAM math, hardware tiers
- Runtime choices, serving modes, licenses
- Model selection, privacy, troubleshooting, benchmarks

**Por que essa ordem**: entenda por que prompt longo custa memória *antes* de escolher GPU. Entenda por que decode é sequencial *antes* de se importar com tokens/segundo.

## Princípio

> "Start with the loop: Tokens in, probabilities out, one next token at a time. Weights tell the model what patterns it learned. Context tells it what it is looking at now. The KV cache is the working memory that keeps the loop usable."

## Série Relacionada (mesmo autor)

- Part 1: GPU Memory Math for LLMs (2026)
- Part 2: Memory Bandwidth for Local AI Hardware (2026)
- Part 3: Inference Engines for LLMs (2026) — fonte do `inference-engines-hardware-first`

## Ver Também

- [[03-RESOURCES/concepts/llm-ml-foundations/inference-engines-hardware-first]]
- [[03-RESOURCES/concepts/llm-ml-foundations/kv-cache-llms]]
- [[03-RESOURCES/concepts/llm-ml-foundations/model-quantization]]
- [[03-RESOURCES/sources/ai-agents-harness/clipping-inference-engines-llms-2026]]
