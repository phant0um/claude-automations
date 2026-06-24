---
title: "Research Papers Every LLM Engineer Must Read"
type: source
source_url: "https://x.com/amitiitbhu/status/2045390052755411114"
author: "@amitiitbhu"
published: 2026-04-18
created: 2026-06-22
score: B
category: articles
tags: [source, articles, llm, reading-list, foundational-papers, reference]
---

# Research Papers Every LLM Engineer Must Read

Curated list of 12 foundational LLM papers com resumo de cada. Útil como referência e checklist de coverage.

## Papers

1. **Attention Is All You Need** (2017) — Transformer architecture, self-attention replaces recurrence
2. **BERT** — Masked language modeling, bidirectional context para understanding/classification
3. **GPT-3: Language Models are Few-Shot Learners** — 175B params, in-context learning
4. **Scaling Laws for Neural Language Models** — loss decreases predictably with compute/data/parameters
5. **Chinchilla** — compute-optimal: ~20 tokens per parameter; smaller model + more data > bigger model + less data
6. **InstructGPT** — RLHF: SFT + reward modeling + PPO → ChatGPT
7. **Chain-of-Thought Prompting** — step-by-step reasoning melhora math/logic/multi-step
8. **Retrieval-Augmented Generation (RAG)** — retriever + generator, fresh factual docs sem retraining
9. **LoRA** — low-rank adaptation, 10,000x fewer trainable params; foundation for QLoRA
10. **LLaMA** — 13B open weights outperform GPT-3 on most benchmarks; open weights reshaped research
11. **FlashAttention** — IO-aware attention, cuts memory + speeds training sem changing math
12. **DPO: Direct Preference Optimization** — align on preference data sem reward model nem RL

## Por que é Score B

- Lista de referência útil mas sem análise original — é um thread de Twitter com 1-2 frases por paper
- Valor principal: checklist para garantir coverage no vault
- Papers já cobertos individualmente em concepts/entities do vault

## Conexões Vault

- [[03-RESOURCES/concepts/llm-ml-foundations/context-window]] — Attention/FlashAttention
- [[03-RESOURCES/concepts/llm-ml-foundations/fine-tuning]] — LoRA, DPO
- [[03-RESOURCES/concepts/memory-context-rag]] — RAG
- [[03-RESOURCES/concepts/llm-ml-foundations/scaling-laws]] — Scaling Laws/Chinchilla

## Coverage Check

Vault já tem concepts para: attention, fine-tuning, RAG, context engineering. Papers faltando como entities/concepts próprios: Chinchilla (compute-optimal training), InstructGPT (RLHF específico), FlashAttention (IO-aware). Considerar criar entities para os 3 que faltam.