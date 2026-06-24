---
title: "Speculative Decoding Patterns"
type: concept
created: 2026-06-23
updated: 2026-06-23
tags: [concept, llm-ml-foundations, inference, optimization, speculative-decoding]
---

# Speculative Decoding Patterns

## Definição

Speculative decoding é uma técnica de otimização de inferência onde um modelo pequeno (draft model) gera tokens candidatos que são verificados em paralelo por um modelo maior (verify model). Se o verify model aceita, múltiplos tokens são produzidos em uma única forward pass — reduzindo latency sem perder qualidade. O padrão evoluiu de kernel-level (DFlash) para API-level (RLM-Cascade).

## Variantes Observadas

1. **Kernel-level (hardware)**: [[boost-inference-performance-up-to-15x-on-nvidia-blackwell-using-dflash-speculative-decoding]] — DFlash no NVIDIA Blackwell, up to 15x speedup. Speculative decoding operando no nível do hardware/GPU.

2. **Response-level (API)**: [[rlm-cascade-response-level-speculative-decoding-for-cost-efficient-llm-api-serving]] — RLM-Cascade aplica speculative decoding no nível de resposta (proxy layer), sem requerer acesso aos pesos do modelo. Reduz custo de API sem retraining.

3. **Quantization-aware**: [[grinqh-graded-input-based-quantization-hierarchy-for-efficient-llm-generation]] — quantização hierárquica combinável com speculative decoding para reduzir ainda mais latency.

## Insight

A evolução é: speculative decoding saiu do hardware (GPU kernels) e subiu para a camada de API serving. Isto significa que qualquer aplicação que consome LLM APIs pode se beneficiar sem alterar o modelo — basta colocar um proxy na frente. O custo de implementação caiu de "retrain com draft model" para "configurar um proxy".

## Evidências

- **[2026-06-23]** DFlash: 15x speedup on NVIDIA Blackwell via speculative decoding — [[boost-inference-performance-up-to-15x-on-nvidia-blackwell-using-dflash-speculative-decoding]]
- **[2026-06-23]** RLM-Cascade: response-level speculative decoding reduces API cost without model access — [[rlm-cascade-response-level-speculative-decoding-for-cost-efficient-llm-api-serving]]
- **[2026-06-23]** GrINQH: graded quantization hierarchy for efficient generation — [[grinqh-graded-input-based-quantization-hierarchy-for-efficient-llm-generation]]
- **[2026-06-23]** HyperQuant: rate-distortion-optimal quantization pipeline — [[hyperquant-a-rate-distortion-optimal-quantization-pipeline-for-large-language-and-diffusion-models]]

## Links

- [[03-RESOURCES/concepts/llm-ml-foundations/inference]]
- [[03-RESOURCES/concepts/llm-ml-foundations/quantization]]
- [[03-RESOURCES/concepts/llm-ml-foundations/token]]
- [[03-RESOURCES/entities/NVIDIA]]