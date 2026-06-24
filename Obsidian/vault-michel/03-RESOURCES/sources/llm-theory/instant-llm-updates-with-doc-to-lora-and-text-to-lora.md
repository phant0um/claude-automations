---
title: "Instant LLM Updates with Doc-to-LoRA and Text-to-LoRA"
type: source
source: Clippings/Instant LLM Updates with Doc-to-LoRA and Text-to-LoRA.md
created: 2026-06-22
ingested: 2026-06-22
tags: [ml-research, lora, hypernetwork, adaptation, sakana]
---

## Tese central

Hypernetwork gera LoRA adapters on-the-fly — transforma expensive fine-tuning em single forward pass. Doc-to-LoRA: documento → adapter. Text-to-LoRA: task description → adapter. Cost amortization: meta-train uma vez, gerar adapters sob demanda.

## Argumentos principais

1. **Problema**: adicionar long-term memory ou adaptar LLM exige fine-tuning caro ou context distillation memory-intensive
2. **Solução**: hypernetwork meta-learns update rules para instant LoRA generation
3. **Doc-to-LoRA**: longo documento → LoRA adapter que internaliza a informação
4. **Text-to-LoRA**: natural language task description → specialized model adapter
5. **Cost amortization**: meta-training cost pago uma vez, per-task é forward pass barato

## Key insights

- LoRA generation como forward pass — não optimization per-task
- Hypernetwork = meta-learned update rules, não per-task training
- Biologically inspired: durable long-term memory + rapid adaptation
- Elimina necessidade de long prompts para document grounding

## Links

- [[03-RESOURCES/concepts/llm-ml-foundations]]
- [[03-RESOURCES/entities/AI-Scientist-Sakana]]