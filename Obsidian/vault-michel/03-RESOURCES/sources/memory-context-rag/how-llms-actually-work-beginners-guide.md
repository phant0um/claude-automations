---
title: "How LLMs Actually Work — A Complete Beginner's Guide"
type: source
source: "Clippings/How LLMs Actually Work — A Complete Beginner's Guide.md"
source_url: "https://x.com/hrswatigupta/status/2060304091356791118"
author: "@hrswatigupta"
published: 2026-05-29
created: 2026-05-31
ingested: 2026-05-31
tags: [ai-agents, memory-context-rag, llm-fundamentals, tokens, training, hallucination]
---

## Tese central

LLMs são fundamentalmente máquinas de autocomplete superpoderosas — preveem o próximo token baseando-se em padrões aprendidos durante treinamento em trilhões de tokens de texto, sem "entender" ou "saber" nada no sentido humano. Compreender o mecanismo subjacente torna o usuário dramaticamente mais eficaz.

## Argumentos principais

- LLM = Large Language Model: bilhões de parâmetros numéricos ("dials") que codificam padrões de linguagem de forma distribuída — não há banco de dados de fatos, apenas pesos
- O único "truque" real do modelo é prever o próximo token com probabilidade; tudo mais (raciocínio, código, poesia) emerge desse mecanismo simples repetido milhares de vezes
- Tokens, não palavras: o modelo processa chunks subpalavra (~1,3 tokens por palavra em média); contexto e pricing são medidos em tokens, não palavras
- Treinamento em 3 estágios: (1) pré-treino — predict-next-token em internet/books/code; (2) fine-tuning supervisionado — exemplos de conversas ideais; (3) RLHF — feedback humano que orienta preferências
- Conhecimento congelado no cutoff de treino — sem acesso a eventos posteriores a menos que conectado a ferramentas/search
- Alucinações são features do mecanismo, não bugs: o modelo gera texto plausível sem conceito de verdade — fatos errados soam tão "corretos" quanto os certos
- Contexto rico e prompts específicos são a alavanca mais alta de qualidade: o modelo só "sabe" o que está na conversa + treino

## Key insights

- A metáfora mais precisa: "autocomplete que engoliu a internet" — não um gênio nem um buscador de fatos
- Parâmetros como knobs de equalizer: 175 bilhões de dials ajustados durante treino para produzir predições corretas — nenhum dial individual "armazena" um fato
- "Lossy compressed summary of everything it read — like a blurry JPEG of the internet"
- Por que LLMs erram contagem de letras: veem tokens, não caracteres — "unbelievable" = 3–4 tokens
- Context window = o único "campo visual" do modelo; 128K tokens ≈ livro de 300 páginas
- Iteração bate perfeição inicial: tratar como junior developer que precisa de coaching, não oráculo

## Exemplos e evidências

- Exemplo probabilístico concreto: "The sky is ___" → blue 62%, clear 18%, cloudy 12%, falling 5%, spaghetti 1%
- Tabela de tokens: "cat" = 1 token; "unbelievable" = 3-4 tokens; 1 página (~500 palavras) ≈ 650 tokens
- Tabela de usos seguros vs. verificar: drafting/brainstorm = seguros; fatos específicos/citações/math/advice = verificar sempre
- Livros recomendados: Co-Intelligence (Mollick), The Coming Wave (Suleyman), You Look Like a Thing and I Love You (Shane)

## Implicações para o vault

- Confirma e aprofunda a base teórica para [[03-RESOURCES/concepts/llm-ml-foundations/]] — bom material de referência introdutório
- A explicação de tokens é relevante para entender pricing, context window e por que RTK existe
- A seção de treinamento (3 estágios) conecta com os conceitos de fine-tuning e RLHF já presentes no vault
- Útil como leitura de onboarding para qualquer pessoa nova ao vault que precise entender LLMs

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/]]
- [[03-RESOURCES/entities/hrswatigupta]]
