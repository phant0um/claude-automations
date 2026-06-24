---
title: "How LLMs Like ChatGPT & Claude Are Actually Built"
type: source
created: 2026-05-28
ingested: 2026-05-28
tags: [llm-fundamentals, transformer, rlhf, training, tokenization, embeddings, neural-networks, pedagogy]
source_url: "https://x.com/Tabbu_ai/status/2058511682381689001"
author: "@Tabbu_ai"
published: 2026-05-24
---

# How LLMs Like ChatGPT & Claude Are Actually Built

## Tese Central

LLMs são essencialmente máquinas de prever o próximo token treinadas em texto em escala de petabytes. Toda capacidade emergente (raciocínio, código, tradução) emerge dessa tarefa aparentemente simples de predição, executada bilhões de vezes com ajuste de gradiente.

## Key Insights

Sequência de construção de um LLM em 10 passos:

1. **Dados massivos:** trillhões de palavras de livros, Wikipedia, papers, fóruns, código, documentação.
2. **Tokenização:** texto dividido em sub-palavras/símbolos; tokens convertidos em números.
3. **Embeddings:** tokens → vetores capturando relações semânticas (king/queen matemáticamente próximos).
4. **Transformer (Attention is All You Need, 2017):** mecanismo de atenção identifica quais palavras importam em contexto.
5. **Treinamento:** predição de próximo token × bilhões de exemplos → gradient descent + backpropagation → ajuste de parâmetros.
6. **Parâmetros:** "tiny knobs" controláveis — mais parâmetros → melhor reasoning (7B, 70B, trilhões).
7. **GPUs:** milhares de GPUs em paralelo; custo de treino = dezenas a centenas de milhões de dólares.
8. **Fine-tuning:** dataset curado + instruction training → modelo aprende a responder helpfully.
9. **RLHF:** humanos ranqueiam respostas → modelo aprende preferências humanas → mais seguro e conversacional.
10. **Inferência:** ao receber query, modelo não busca em banco — gera token por token via predição probabilística.

- **Maior misconception:** LLMs são "databases com respostas". São motores de predição — por isso alucinam com confiança.
- **Emergência:** pesquisadores não entendem completamente por que certas capacidades emergem repentinamente em escala.

## Implicações para o Vault

- Fonte pedagógica de alta qualidade para `post-training-llm` e `context-engineering`.
- Útil como referência para explicar comportamentos do Claude (alucinação, confiança, token limits).

## Links

- [[03-RESOURCES/concepts/llm-ml-foundations/post-training-llm]] — fine-tuning + RLHF (passos 8-9)
- [[03-RESOURCES/concepts/llm-ml-foundations/context-window]] — relação com tokenização
- [[03-RESOURCES/concepts/llm-ml-foundations/factual-memory]] — LLM como prediction engine, não fact database
