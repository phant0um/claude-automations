---
title: "Beyond LoRA: Can You Beat the Most Popular Fine-Tuning Technique?"
type: source
source: "Clippings/Beyond LoRA Can you beat the most popular fine-tuning technique?.md"
author: "Benjamin Bossan, Sayak Paul, Marian, Kashif Rasul (Hugging Face)"
published: 2026-06-17
created: 2026-06-22
ingested: 2026-06-22
tags: [llm-theory, peft, fine-tuning, lora, huggingface]
score: B
---

## Tese Central

LoRA é quase certamente a PEFT technique mais comum (98.4% de model cards com uma técnica, 95% de image gen checkpoints, 71.3% de GitHub code snippets). Mas LoRA não é necessariamente a melhor choice. Hugging Face benchmarked 6+ PEFT techniques em equal footing e encontrou que LoRA works well mas outras techniques podem beat it em um ou múltiplos axes.

## Pontos-Chave

1. **LoRA dominance**: 20,509 de 20,834 model cards (98.4%), 7,111 de 10,000 image gen checkpoints (95.0%), 71.3% de GitHub snippets. LoRA's popularity feeds on itself — highest visibility, tutorials, downstream support.
2. **Paper results problem**: researchers under pressure para beat benchmark. Bias por spend less time tuning alternatives. One study found LoRA can match supposedly better techniques by tuning learning rate. Different papers, different techniques compared, different benchmarks, code often unavailable.
3. **PEFT library benchmarks**: LLM Math (chain-of-thought reasoning) + image generation (cat plushy concept). Same base model, dataset, training/eval code, hardware. Tracks VRAM, forgetting/drift, runtime, checkpoint size.
4. **LLM Math results**: LoRA on Pareto frontier (53.2% accuracy, 22.6GB VRAM with rank stabilized init). BEFT (32.9% accuracy, 20.2GB — more memory efficient). Lily (54.9% accuracy, 25.6GB — more accurate). Vanilla LoRA only 48.1% at 22.5GB — should be avoided in favor of variants.
5. **Image gen results**: LoRA below Pareto frontier. OFT strictly dominates LoRA (0.708 vs 0.697 similarity, 9.01GB vs 9.97GB memory). LoRA is beaten.
6. **LoRA variants**: rs-LoRA (rank stabilized init), LoRA-FA (frozen A matrix, memory efficient), DoRA. Check variants before defaulting.
7. **Conversion support**: PEFT now supports converting non-LoRA adapters into LoRA for vLLM/llama.cpp. GraLoRA → LoRA conversion: scores virtually identical (0.702→0.694, 0.260→0.269).
8. **PEFT shop**: browse by benchmark metrics e capabilities (quantization support, layer types, merging support).

## Conceitos

- PEFT (Parameter-Efficient Fine-Tuning) landscape
- Pareto frontier: accuracy vs memory tradeoff
- LoRA variants: rs-LoRA, LoRA-FA, DoRA
- Self-reinforcing popularity (visibility → tutorials → support → adoption)
- Adapter conversion (non-LoRA → LoRA para serving compatibility)

## Links

- [[03-RESOURCES/concepts/llm-ml-foundations/fine-tuning]]
- [[03-RESOURCES/sources/llm-theory/instant-llm-updates-doc-to-lora-text-to-lora]]