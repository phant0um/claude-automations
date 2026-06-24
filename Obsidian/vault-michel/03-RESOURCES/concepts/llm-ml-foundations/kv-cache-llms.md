---
title: KV Cache em LLMs
type: concept
status: developing
created: 2026-05-18
updated: 2026-05-19
tags: [kv-cache, transformer, attention, llm, inference-optimization, prompt-caching]
---

# KV Cache em LLMs

Mecanismo que elimina recomputação de key/value vectors em tokens anteriores durante inferência autoregressive. Reduz complexidade de atenção de O(n²) por token para O(n) incremental.

## O Mecanismo em 3 Etapas

**1. Forward Pass Básico**

```
tokens → Transformer Layers → Hidden States → Projection → Logits → ArgMax
```

Insight: a rede só precisa do último hidden state para prever o próximo token.

**2. Mecanismo de Atenção**

```
Attention(Q, K, V) = softmax(QK^T / sqrt(d_k)) * V
```

O último hidden state depende apenas do query vector do último token e de todos os key/value vectors anteriores.

**3. Cache em Ação**

Para cada novo token gerado:
- K e V dos tokens anteriores: **reutilizados do cache**
- K e V do token atual: computados uma vez, adicionados ao cache
- Nenhuma recomputação de tokens passados

Invariante chave: **key/value vectors de tokens anteriores não mudam entre geração de tokens.**

## Por Que Importa para Agentes

Sem KV cache: cada token gerado relê o contexto inteiro → custo quadrático.
Com KV cache: geração é linear no comprimento do output.

No contexto de **prompt caching** (Anthropic):
- System prompt cacheado = KV cache persistido entre requests
- Custo: $0.02/sessão vs $0.20/sessão sem cache (~10×)
- TTL do cache: 5 minutos (Anthropic) → hot.md deve ser acessado em <5min para hit

## Conexão com o Vault

O `[[04-SYSTEM/wiki/hot]]` é o mecanismo de custo-eficiência do vault precisamente porque o sistema prompt cacheado (incluindo hot.md) aproveita KV cache. Uma vez cacheado, releituras do hot.md dentro do TTL não custam tokens de input.

Ver também `[[03-RESOURCES/concepts/llm-ml-foundations/prompt-caching]]` — camada de produto em cima deste mecanismo.

## Relacionados

- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-caching]] — implementação Anthropic do KV cache persistido
- [[03-RESOURCES/concepts/pkm-obsidian/hot-cache]] — aplicação prática no vault
- [[03-RESOURCES/concepts/llm-ml-foundations/context-window]] — KV cache cresce com context window
- [[03-RESOURCES/concepts/llm-ml-foundations/inference-optimization]] — família de técnicas de eficiência
- [[03-RESOURCES/sources/kv-caching-llms-diagram]] — diagrama educacional (DailyDoseofDS)

## Evidências
- **[2026-06-19]** Diferença de custo 10x no Claude Sonnet ($0.30/M cacheado vs $3.00/M não-cacheado); regra prática: conteúdo estável no topo, dinâmico no fundo, usar tool masking em vez de remoção de ferramentas — [[03-RESOURCES/sources/ai-agents-harness/context-engineering-complete-playbook]]

- **[2026-06-24]** tags: — [[compresskv-semantic-retrieval-guided-kv-cache-compression-for-resource-efficient-long-context-llm-inference]]