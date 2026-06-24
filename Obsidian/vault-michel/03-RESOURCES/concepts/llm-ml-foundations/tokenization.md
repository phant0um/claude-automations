---
title: "Tokenization"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, llm-ml-foundations]
status: developing
---

# Tokenization

Converter texto em sequências de IDs inteiros que o modelo processa — a interface entre linguagem humana e matemática de LLMs.

## O que é

Tokenização é o pré-processamento que transforma texto bruto em tokens: unidades sub-palavra que o LLM processa. Token ≠ palavra. "tokenization" pode ser 1 token; "tokenização" pode ser 3. O vocabulário (geralmente 32k–128k tokens) é fixo após o treinamento.

## Como funciona

**Algoritmos principais:**

- **BPE (Byte-Pair Encoding)**: começa com bytes individuais e iterativamente une os pares mais frequentes. Usado em GPT-2/3/4, Claude.
- **WordPiece**: variante bayesiana do BPE; divide palavras em subunidades maximizando probabilidade do corpus. Usado em BERT.
- **SentencePiece**: tokeniza diretamente do texto raw (sem pré-tokenização por espaços); suporta qualquer língua. Usado em LLaMA, Gemma.

**Tokens especiais**: `<BOS>` (início), `<EOS>` (fim), `<PAD>` (padding em batches), tokens de sistema (instruções, roles).

**Português tokeniza pior que inglês**: palavras portuguesas são morfologicamente mais ricas e menos representadas no corpus de treino dos tokenizadores. "desfragmentação" → ~5 tokens; "defragmentation" → ~3. Isso significa mais tokens por palavra = maior custo e menor capacidade efetiva de context window para texto em PT.

**Implicações no comportamento do modelo:**
- Aritmética falha porque números são tokenizados de forma não-compositional ("123" pode ser 1 token, "1 2 3" são 3).
- Soletração é difícil: o modelo vê tokens, não letras.
- Splitting de palavras raras cria representações fragmentadas.

## Por que importa

Tokenização determina custo (tokens faturados), capacidade de contexto efetiva, e comportamentos emergentes do modelo. Saber tokenizar bem — escolher vocabulário, controlar token count, entender overhead de idiomas — é essencial para otimizar custo e qualidade em produção.

## Related
- [[03-RESOURCES/concepts/llm-ml-foundations/_index]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-pretraining]]
- [[03-RESOURCES/concepts/llm-ml-foundations/kv-caching]]

## Evidências
- **[2026-06-24]** Today we're open-sourcing `renderers`, a standalone Python library that gives developers full contro — [[renderers-token-level-templating-for-agentic-rl]]
- **[2026-06-24]** Quanyan Zhu Department of Electrical and Computer Engineering, New York University Tandon School of  — [[ai-tokenomics-the-economics-of-tokens-computation-and-pricing-in-foundation-models]]
