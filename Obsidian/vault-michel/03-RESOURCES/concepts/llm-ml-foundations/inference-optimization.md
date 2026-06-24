---
title: Inference Optimization
type: concept
status: developing
created: 2026-05-01
updated: 2026-05-01
tags:
  - llm
  - performance
  - deployment
  - throughput
---

## Overview

Inference optimization encompasses techniques to reduce latency, increase throughput, and lower cost of serving LLMs in production. Critical for agentic systems that must respond quickly.

## Key Optimization Techniques

### 1. Quantization
Reducing precision of weights/activations while maintaining quality.

- **NVFP4:** 4-bit with adaptive exponents (NVIDIA innovation)
- **FP8:** 8-bit fixed-point (production-ready)
- **INT8/INT4:** Integer quantization
- **Benefit:** 2-4× memory reduction; 2-8× faster inference

### 2. Architecture Efficiency
Designing models for hardware constraints.

- **[[03-RESOURCES/concepts/llm-ml-foundations/mixture-of-experts|MoE]]:** Sparse activation reduces FLOPs
- **[[03-RESOURCES/concepts/agent-systems/hybrid-architectures|Hybrid Mamba-Attention]]:** Mamba layers (O(N)) + Attention at critical points
- **Multi-Token Prediction (MTP):** Speculative decoding acceleration

### 3. Sequence Optimization
Reducing compute per sequence position.

- **KV-Cache:** Reuse attention keys/values from previous tokens
- **Rotary embeddings:** Efficient position encoding
- **Paged attention:** GPU memory management for variable-length sequences

### 4. System-Level Optimization
GPU/infrastructure improvements.

- **vLLM:** GPU kernel optimization for batch processing
- **TRT-LLM:** CUDA kernels for Tensor RT inference
- **Distributed inference:** Tensor parallelism, pipeline parallelism
- **Batching:** Amortize startup overhead across requests

## Throughput vs Latency Trade-off

| Setting | Optimized For | Example |
|---------|---|---|
| Batch inference | Throughput (tokens/sec) | Offline processing, backfill tasks |
| Interactive | Latency (ms per token) | Chat, agentic tool-calls |
| Long-horizon agents | Latency + sustained throughput | Multi-step planning + execution |

## Nemotron 3 Super Results

- **2.2× throughput** vs GPT-OSS-120B (LatentMoE + MTP)
- **7.5× throughput** vs Qwen3.5-122B (same settings)
- Same accuracy profile as 120B+ competitors
- Sustainable on B200 GPUs (TRT-LLM backend)

## Related Concepts

[[03-RESOURCES/concepts/llm-ml-foundations/mixture-of-experts]] · [[03-RESOURCES/concepts/llm-ml-foundations/model-quantization]] · [[03-RESOURCES/concepts/llm-ml-foundations/speculative-decoding]] · [[03-RESOURCES/concepts/agent-systems/hybrid-architectures]]

---

**Sources:** [[03-RESOURCES/sources/ml-research-papers/nemotron-3-super-hybrid-mamba-attention-moe]]

## Evidências

- **[2026-06-21]** Programar GPU não é uma otimização do código sequencial — é uma forma diferente de pensar computação (paralela em massa vs. sequencial). Essa mudança de modelo mental, não sintaxe, é por que a skill é escassa e engenheiros seniores com e... — [[cuda-from-scratch-how-to-write-code-for-the-gpu-and-why-it-is-a-scarce-skill]]
- **[2026-06-21]** Walkthrough de código de implementação de CUDA Graphs num servidor de inferência LLM próprio: em vez de lançar kernels um a um a cada passo de decode, captura-se o padrão de execução fixo de cada batch size num grafo e o replay substitui... — [[cuda-graph-implementation-in-llm-inference-server]]
- **[2026-06-21]** GLM-5.2 (Z.ai, 744B total/40B ativos, MIT license) torna-se o modelo open-weight líder no Artificial Analysis Intelligence Index v4.1 (score 51, +11 vs GLM-5.1), superando MiniMax-M3 (44), DeepSeek V4 Pro (44) e Kimi K2.6 (43), e fica na... — [[glm-5-2-is-the-new-leading-open-weights-model-on-the-artificial-analysis-intelli]]
- **[2026-06-21]** Gemma 4 31B (Google DeepMind, denso, Apache 2.0) entra em preview na Cerebras Inference rodando a mais de 1.500 tokens/s — 15x mais rápido que Claude Haiku (~100 tok/s) em qualidade comparável — e é o primeiro modelo multimodal (visão) n... — [[gemma-4-on-cerebras-the-fastest-inference-is-now-multimodal]]
- **[2026-06-21]** A arquitetura transformer é a parte que menos importa na construção de um LLM competitivo — é amplamente padronizada e publicada. O que separa um modelo bom de um mediano são as outras 4 etapas: dados, scaling laws, e (não capturadas no... — [[how-to-build-your-own-llm-from-scratch-in-5-stages-exact-pipeline-behind-gpt-and]]
- **[2026-06-21]** Artificial Analysis lança AA-AgentPerf, primeiro benchmark multi-vendor de hardware desenhado especificamente para medir quantos agentes de IA concorrentes um sistema de inferência suporta sob SLOs de velocidade/latência definidos — NVID... — [[nvidia-achieves-leading-agentic-coding-performance-on-first-agentic-ai-benchmark]]
- **[2026-06-21]** NVIDIA libera Nemotron 3 Ultra (MoE 550B total/55B ativos, open), modelo construído especificamente para orquestração e raciocínio frontier em sistemas agênticos de longa duração — entrega 5x mais throughput que modelos abertos comparáve... — [[nvidia-nemotron-3-ultra-powers-faster-more-efficient-reasoning-for-long-running-]]
- **[2026-06-21]** Thread mapeia a economia de "reasoning"/test-time compute desde o1 (2024) até modelos atuais: gastar mais tokens/tempo de computação melhora acurácia (~10-20%), mas custa 5-10x mais tokens de output — e há tensão direta com agentic workf... — [[the-economics-of-ai-reasoning]]
- **[2026-06-21]** MiniMax M3 (MoE 428B total/22B ativos, multimodal nativo, contexto 1M tokens) chega à infraestrutura NVIDIA com MiniMax Sparse Attention (MSA) — substitui atenção quadrática padrão por pré-filtragem que identifica blocos de contexto rele... — [[deploy-long-context-reasoning-and-agentic-workflows-with-minimax-m3-on-nvidia-ac]]
- **[2026-06-21]** Explicação fundacional de Knowledge Distillation (KD) — transferência de conhecimento de um modelo grande ("teacher") para um menor ("student"), permitindo ao menor herdar capacidades do maior sem treinar do zero — desde a origem (Model... — [[everything-you-need-to-know-about-knowledge-distillation]]
- **[2026-06-21]** Hardware local (Minisforum MS-S1 Max, ~$3.000, chip AMD Ryzen AI Max+ 395 com 128GB de memória unificada CPU+GPU) torna viável rodar 6 agentes de IA 24/7 com custo operacional de ~$11/mês em eletricidade — o argumento central não é "o mo... — [[i-have-6-ai-agents-running-247-on-a-box-under-my-desk-total-monthly-cost-11-in-e]]
- **[2026-06-21]** GLM-5.2 (Z.ai) é o primeiro modelo open-source a trocar golpes reais com Claude Opus em benchmarks de coding (não em slides de marketing) — salto geracional grande sobre GLM-5.1 (Terminal-Bench 2.1: 81.0 vs 62.0; SWE-bench Pro: 62.1 vs 5... — [[stop-paying-200month-for-opus-glm-5-2-just-matched-it-for-0]]

## Perspectivas

- **[2026-06-21]** Knowledge distillation e benchmarks agênticos de inferência (NVIDIA) convergem: otimização de inferência hoje é tão sobre arquitetura de serving quanto sobre o modelo treinado. — [[everything-you-need-to-know-about-knowledge-distillation]]
