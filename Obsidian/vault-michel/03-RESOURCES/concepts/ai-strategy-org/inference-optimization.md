---
title: "Inference Optimization"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, ai-strategy-org]
status: developing
---

# Inference Optimization

Técnicas para reduzir custo e latência de inferência LLM em produção — o que acontece entre "enviar prompt" e "receber resposta".

## O que é

Inference optimization é o conjunto de técnicas de engenharia aplicadas à fase de inferência de modelos de linguagem, visando reduzir três métricas: **custo por token**, **latência (TTFT + geração)**, e **throughput** (requisições/segundo).

## Como funciona

**Técnicas principais:**

| Técnica | Como funciona | Ganho típico |
|---|---|---|
| **KV Cache** | Reutiliza atenção de tokens já processados | 2–5× TTFT em prompts longos |
| **Quantização (INT8/INT4)** | Reduz precisão dos pesos sem grande perda de qualidade | 2–4× memória, ~1.5× throughput |
| **Speculative decoding** | Draft model gera candidatos; modelo principal verifica | 2–3× velocidade de geração |
| **Batching dinâmico** | Agrupa requisições para usar GPU eficientemente | Escala throughput |
| **Pruning** | Remove pesos de baixo impacto | Modelos menores, mais rápidos |
| **Destilação** | Treina modelo menor para imitar modelo grande | Menor custo sem API external |

**KV Cache no contexto do vault:** é o mecanismo que torna `hot.md` valioso — ao carregar sempre os mesmos documentos no início da sessão, o KV cache da API Anthropic os reutiliza entre chamadas, reduzindo custo e latência das leituras de contexto fixo.

**Hardware:** GPUs (NVIDIA H100, A100), TPUs (Google), NPUs (chips custom como Trainium da AWS). A escolha de hardware afeta quais otimizações são viáveis.

## Por que importa

Para Michel como futuro dev/engenheiro de IA, entender inference optimization é necessário para projetar sistemas de IA economicamente viáveis em produção. No vault, explica por que KV caching via hot.md é uma otimização de primeira ordem — não apenas uma conveniência.

## Related
- [[03-RESOURCES/concepts/llm-ml-foundations/kv-caching]]
- [[03-RESOURCES/concepts/token-efficiency]]
- [[03-RESOURCES/concepts/ai-strategy-org/_index]]
