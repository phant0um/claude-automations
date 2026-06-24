---
title: "LLM Pretraining"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, llm-ml-foundations]
status: developing
---

# LLM Pretraining

Fase inicial de treinamento de LLMs: predição do próximo token em corpus massivo, construindo conhecimento de mundo e capacidade de raciocínio.

## O que é

Pretraining é o treinamento em escala web de um modelo Transformer do zero. O objetivo é simples — prever o próximo token — mas o que emerge desse processo em escala é surpreendente: gramática, fatos, código, raciocínio lógico, e até capacidades não antecipadas (in-context learning, aritmética, tradução zero-shot).

## Como funciona

1. **Dados**: corpus de texto web (Common Crawl, livros, código, Wikipedia) com curadoria rigorosa — deduplicação, filtragem de qualidade, balanceamento de domínios.
2. **Tokenização**: texto → sequências de IDs via BPE/SentencePiece.
3. **Arquitetura**: Transformer decoder-only (GPT-style); atenção causal (cada token vê só o passado).
4. **Objetivo**: cross-entropy loss na predição token-a-token (causal language modeling).
5. **Escala**: Lei de Chinchilla — para compute ótimo, escalar tokens proporcionalmente aos parâmetros (≈20 tokens/parâmetro). GPT-4 estima-se ~1–2T parâmetros; Llama 3 70B treinou em ~15T tokens.
6. **Emergência**: capacidades qualitativas surgem abruptamente em certas escalas (ex.: in-context learning emerge ~10B parâmetros).

## Por que importa

Pretraining é o que torna um LLM um LLM. Todo fine-tuning, RLHF, e prompt engineering opera sobre a base construída aqui. Entender pretraining explica: por que modelos maiores são mais capazes em geral, por que dados de qualidade importam mais que quantidade bruta, e por que algumas falhas (alucinação, viés de corpus) são estruturais e não corrigíveis só com prompting.

## Related
- [[03-RESOURCES/concepts/llm-ml-foundations/_index]]
- [[03-RESOURCES/concepts/llm-ml-foundations/fine-tuning]]
- [[03-RESOURCES/concepts/llm-ml-foundations/tokenization]]
