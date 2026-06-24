---
title: "How we built the world's fastest API for GLM-5.2"
type: source
source: "https://x.com/philipkiely/status/2069212319746506968"
created: 2026-06-22
updated: 2026-06-22
tags: [llm-theory, inference-optimization, glm-5-2, baseten, quantization, nvidia-dynamo]
---

## Tese Central

Baseten construiu a API mais rápida para GLM-5.2 (280+ tokens/segundo medido pela Artificial Analysis) combinando cinco otimizações ao longo de todo o pipeline de inferência: shared DSA no inference engine customizado, quantização NVFP4 in-house, KV-aware routing, prefill-decode disaggregation, e Multi-Token Prediction. O resultado demonstra que frontier open intelligence requer inference engineering excepcional — não apenas um modelo inteligente, mas infraestrutura que entrega performance production-grade.

## Pontos-Chave

1. **GLM-5.2 overview**: 744B parâmetros, MoE com 40B active, 1M token context window, thinking/non-thinking modes, MIT license. Shared DSA weights (nova vs GLM-5.1). Compara a GPT 5.5 e Opus 4.8 a 70-80% menos custo.
2. **NVFP4 quantization**: In-house quantization de FP8 → NVFP4 usando NVIDIA ModelOpt. NVFP4 é 4-bit floating point com dual scale factors que retém high dynamic range. No BFCL (function calling), performance equivalente ao FP8 nativo dentro da margem de erro. Melhora TTFT e TPS via tensor cores mais rápidos e menos VRAM bandwidth burden.
3. **KV-aware routing com NVIDIA Dynamo**: Long context requests têm sequências de input muito longas. KV cache re-use entre requests evita re-prefill caro. Para reasoning models, time-to-first-answer-token (TTFAT) é mais relevante que TTFT — dos 7.9s médios para primeiro answer token, 7.1s são reasoning tokens vs 0.8s de input processing. KV-aware routing envia requests para replicas com context relevante já cached.
4. **Prefill-decode disaggregation**: Prefill (compute-bound, determina TTFT) e decode (memory-bound, determina TPS) em engines separadas. Benefícios: sem competição de recursos, alocação desigual, configs otimizadas para cada fase. Resultado: 2x higher TPS. NVIDIA Dynamo fornece prefill queue, conditional disaggregation, NIXL-based KV transfer.
5. **Multi-Token Prediction (MTP)**: GLM-5.2 shipou MTP layer melhorado que reduz custo de draft tokens e aumenta acceptance rate. Speculation é lossless (verification step garante correção). Balanceamento entre sequence length e acceptance rate.
6. **Production optimizations**: Para dedicated deployments — task-specific speculators trained em production data, consistent cache hits de single-tenant traffic, tuning de disaggregation ratio, parallelism/batching settings.

## Conceitos

- **NVFP4**: formato 4-bit floating point da NVIDIA com dual scale factors para high dynamic range
- **Prefill-decode disaggregation**: separar prefill (compute-bound) e decode (memory-bound) em engines independentes
- **KV-aware routing**: rotear requests para replicas com KV cache relevante já cached
- **Time-to-first-answer-token (TTFAT)**: TTFT + reasoning tokens — métrica mais relevante para reasoning models
- **Multi-Token Prediction (MTP)**: gerar múltiplos tokens por forward pass via speculation com verification lossless

## Links

- [[03-RESOURCES/concepts/llm-ml-foundations/inference-optimization]]
- [[03-RESOURCES/concepts/llm-ml-foundations/kv-cache-llms]]
- [[03-RESOURCES/concepts/llm-ml-foundations/kv-caching]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-window]]
- [[03-RESOURCES/entities/NVIDIA]]