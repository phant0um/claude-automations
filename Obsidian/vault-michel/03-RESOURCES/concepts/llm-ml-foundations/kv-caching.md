---
title: "KV Caching"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, llm-ml-foundations]
status: developing
---

# KV Caching

Armazenar os tensores key/value das camadas de atenção para evitar recomputo a cada novo token gerado.

## O que é

Em Transformers, cada token gerado precisa "ver" todos os tokens anteriores via atenção. Sem cache, isso exige recomputo quadrático a cada step. O **KV cache** salva os vetores K e V já calculados, reduzindo o custo de geração de O(n²) para O(n) por step. É a razão pela qual gerar texto token a token é viável em produção.

## Como funciona

Durante o **prefill** (processamento do prompt), K e V de cada camada são calculados e salvos em memória (GPU VRAM ou memória de sistema). Durante o **decode** (geração), cada novo token usa os K/V do cache mais os novos K/V do token atual.

**Anthropic Prompt Cache** expõe isso na API:
- Prefixos marcados com `cache_control: {"type": "ephemeral"}` são cacheados por **5 minutos**.
- Cache hit = **90% de desconto** no custo dos tokens cacheados.
- Threshold mínimo: **1.024 tokens** para acionar o cache.
- Conteúdo estável (system prompt, docs longos) deve vir primeiro; dinâmico (pergunta do usuário) por último.

O `hot.md` do vault é um exemplo prático: um prefixo estável e denso que entra em cache quente na primeira chamada da sessão.

## Por que importa

KV caching é a peça central de eficiência na inferência de LLMs. Sem ele, latência e custo de sessões longas seriam proibitivos. Para praticantes, entender KV cache explica: por que o primeiro token demora mais (prefill), por que context window grande custa mais mesmo sem gerar muito, e como estruturar prompts para economizar 90% em chamadas repetidas.

## Related
- [[03-RESOURCES/concepts/llm-ml-foundations/_index]]
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-caching-patterns]]
- [[03-RESOURCES/concepts/llm-ml-foundations/kv-cache-llms]]
