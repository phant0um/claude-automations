---
title: "Nemotron 3 Super: Open, Efficient Hybrid Mamba-Transformer for Agentic Reasoning"
type: research-paper
authors: NVIDIA
date_published: 2026-04-14
arxiv: "2604.12374v1"
license: CC BY 4.0
created: 2026-05-01
updated: 2026-05-01
tags:
  - llm
  - moe
  - hybrid-architecture
  - agentic-reasoning
  - inference-optimization
  - quantization
triagem_score: 7
---

## Summary

Nemotron 3 Super is a 120B parameter (12B active) hybrid Mamba-Attention Mixture-of-Experts model from NVIDIA. It achieves state-of-the-art inference throughput (2.2-7.5× vs GPT-OSS-120B, Qwen3.5-122B) while maintaining competitive accuracy across benchmarks. Pre-trained on 25T tokens with emphasis on agentic capabilities (tool-use, long-horizon reasoning).

## Key Innovations

### 1. LatentMoE Architecture
- **Hardware-aware expert design** optimizing for both accuracy-per-FLOP and accuracy-per-parameter
- **Reduces memory bandwidth costs** in low-latency serving by decreasing hidden dimension `d` and expert FFN intermediate `m`
- **Reduces all-to-all communication overhead** in distributed throughput-oriented serving by controlling top-K and expert count `N`
- Preserves model quality by maintaining effective nonlinear budget `K·m`
- **5 design principles** derived from Pareto frontier analysis

### 2. Multi-Token Prediction (MTP)
- **Inference acceleration** through native speculative decoding
- Improves overall model quality alongside throughput gains
- 2 MTP layers with shared weights in architecture

### 3. Hybrid Mamba-Attention Pattern
- **88 layers** alternating Mamba and Attention operations strategically
- Mamba layers: low-latency sequence modeling (O(N) complexity)
- Attention layers: long-range dependency modeling + critical benchmarks
- Global attention at strategic points for semantic coherence

### 4. NVFP4 Pre-training
- **Stable low-precision pre-training** in 4-bit quantization
- First model to achieve this at scale (120B)
- Demonstrates viability of NVFP4 for large-scale LLM training

## Architecture Details

| Component | Value |
|-----------|-------|
| Total Parameters | 120.6B |
| Active Parameters | 12.7B (~12.1B excl. embeddings) |
| Total Layers | 88 |
| Model Dimension | 4096 |
| Total Experts per Layer | 512 |
| Top-K (Activated) | 22 |
| MoE Latent Size | 1024 |
| Context Length | 1M tokens |

**Sparse Selection:** Only 22/512 experts activate per token (4.3% sparsity), reducing compute while maintaining quality.

## Training Approach

### Pre-training
- **25 trillion tokens** across 2 phases:
  - Phase 1 (80%, 20T): Diversity and broad coverage
  - Phase 2 (20%, 5T): High-quality data + benchmark optimization
- Maintains fine-grained token distribution

### Post-training
- **Strong agentic emphasis:**
  - Scaled RL environments (breadth, volume, quality)
  - Large agentic training dataset
  - Substantial RL focus on multi-step tool-using behavior
- **Resilient RL infrastructure** for large-scale asynchronous training
- **Benchmark gains** across:
  - Software engineering (OpenHands)
  - Terminal use + bash commands
  - General tool use

### Quantization
- **NVFP4** (FP4 with adaptive exponents)
- **FP8 + KV-Cache** variant
- **BF16** base model
- Checkpoints open-sourced on HuggingFace

## Performance

### Throughput
- **2.2× higher** than GPT-OSS-120B (8k input, 64k output)
- **7.5× higher** than Qwen3.5-122B (same setting)
- Measured on B200 GPUs with vLLM + TRT-LLM

### Accuracy
- **Competitive** across benchmarks (comparable to GPT-OSS-120B, Qwen3.5-122B)
- **Better than base models** (GLM-4.5-Air-Base, Ling-flash-Base-2.0)
- Agentic benchmarks: substantial gains over Nemotron 3 Nano

## Open Releases

**Checkpoints (HuggingFace):**
- Nemotron 3 Super 120B-A12B NVFP4 (post-trained + quantized)
- Nemotron 3 Super 120B-A12B FP8 (post-trained + quantized)
- Nemotron 3 Super 120B-A12B BF16 (post-trained)
- Nemotron 3 Super 120B-A12B Base BF16 (base)
- Qwen3-Nemotron-235B-A22B-GenRM-2603 (for RLHF)

**Datasets (HuggingFace Collections):**
- Nemotron-Pretraining-Specialized-v1.1 (synthetic datasets for code, logic, economics)
- Nemotron-Super-Post-Training-Data (RL environments + SFT datasets for agentic capabilities)

**Code & Recipes:** GitHub NVIDIA-NeMo repository

## Implications for Agentic AI

1. **Efficiency at Scale:** 120B model achieves Qwen3.5 accuracy with 7.5× throughput — enables cost-effective agent deployment
2. **1M Context:** Supports long-horizon reasoning and multi-document analysis in agentic workflows
3. **Tool-Use Optimized:** Explicitly trained on multi-step tool chains — native strength in OpenHands, terminal, general tools
4. **Quantization Path:** NVFP4 demonstrates stable low-precision training; production deployments can use FP8/NVFP4
5. **Open Infrastructure:** Datasets + checkpoints + recipes enable reproducible, customizable agentic systems

## Related Concepts

[[03-RESOURCES/concepts/agent-systems/agentic-reasoning]] · [[03-RESOURCES/concepts/llm-ml-foundations/mixture-of-experts]] · [[03-RESOURCES/concepts/llm-ml-foundations/inference-optimization]] · [[03-RESOURCES/concepts/agent-systems/hybrid-architectures]] · [[03-RESOURCES/concepts/llm-ml-foundations/speculative-decoding]] · [[03-RESOURCES/concepts/llm-ml-foundations/model-quantization]]

## Por que Mamba + Attention — o trade-off fundamental

Arquiteturas puras de Attention (todos os transformers) têm complexidade quadrática com o tamanho da sequência: dobrar o comprimento do contexto quadruplica o custo computacional de atenção. Para contextos de 1M tokens, isso é proibitivo sem otimizações.

Arquiteturas Mamba (State Space Models) têm complexidade linear com o comprimento da sequência — custo cresce proporcionalmente ao contexto, não ao quadrado. Porém, Mamba é menos capaz em tarefas que requerem atenção a tokens distantes no contexto (long-range dependencies) e performa pior em benchmarks que dependem de recuperação precisa de informação.

A arquitetura híbrida do Nemotron 3 Super resolve isso empiricamente: **88 camadas** onde Mamba domina (eficiência linear para a maioria do processamento) mas attention é inserida estrategicamente nos pontos onde long-range dependencies são críticas. O resultado é uma curva de eficiência que supera ambos os extremos para comprimentos de sequência longos.

## LatentMoE — os 5 princípios de design

O paper deriva 5 princípios para design de experts em MoE a partir de análise da fronteira de Pareto entre accuracy-per-FLOP e accuracy-per-parameter. Os princípios são hardware-aware — consideram os gargalos reais de hardware (memória bandwidth, all-to-all communication em multi-GPU):

1. **Reduzir `d` (hidden dimension)**: menos bandwidth de memória por expert ativo
2. **Reduzir `m` (FFN intermediate)**: menos bandwidth, menor latência de inferência
3. **Controlar top-K**: menos all-to-all communication entre GPUs
4. **Controlar `N` (número de experts)**: menos routing overhead
5. **Manter `K·m` (nonlinear budget)**: preservar capacidade expressiva mesmo reduzindo outros parâmetros

A diferença em relação a designs de MoE convencionais: a maioria dos MoEs otimiza para parâmetros totais e esparsidade, sem modelar explicitamente os custos de hardware. O LatentMoE otimiza para custo real de deployment.

## NVFP4 — significância da primeira pre-training estável em 4-bit

Modelos geralmente são treinados em BF16 ou FP8 e quantizados para 4-bit pós-treino para deployment. Treinar *diretamente* em 4-bit (NVFP4) é tecnicamente mais difícil porque gradientes em precisão baixa são instáveis — pequenos erros de arredondamento se acumulam ao longo de trilhões de tokens.

O Nemotron 3 Super sendo o "primeiro modelo a conseguir isso em escala" (120B, 25T tokens) significa que a NVIDIA desenvolveu técnicas de estabilização de treinamento em FP4 que não existiam publicamente. Isso tem implicações:
- **Para a NVIDIA**: vantagem competitiva em hardware (H200/B200 com suporte a FP4 nativo)
- **Para o ecossistema**: abre caminho para modelos ainda maiores com custo de treinamento equivalente ao de modelos menores em FP8
- **Para deployment**: checkpoints NVFP4 são menores e mais rápidos de carregar sem quantização pós-treino adicional

## Multi-Token Prediction — como funciona e por que importa

Geração padrão de LLMs é autoregressiva: o modelo gera um token por vez, cada token condicionado em todos os anteriores. Multi-Token Prediction (MTP) treina o modelo para prever os *próximos N tokens simultaneamente* em vez de apenas o próximo.

Durante inferência, isso habilita **speculative decoding nativo**: o modelo propõe múltiplos tokens em um forward pass, e um verificador mais rápido confirma ou rejeita. Quando aceitos, os tokens foram gerados com custo de um único forward pass.

O Nemotron 3 Super usa 2 camadas MTP com pesos compartilhados — uma forma eficiente que não duplica o tamanho do modelo mas habilita a predição especulativa. Resultados: throughput aumentado especialmente em tarefas onde o modelo tem alta confiança nos próximos tokens (código boilerplate, templates, padrões repetitivos).

## Implications for open-source agentic deployment

Com checkpoints disponíveis no HuggingFace (BF16, FP8, NVFP4) e datasets de post-training abertos, o Nemotron 3 Super é um dos modelos de código aberto mais completos para agentic deployment:

**Para infraestrutura própria**: 12B parâmetros ativos (de 120B total) significa que o custo de inferência é comparable a modelos de 12B parâmetros densos, mas com qualidade de modelo muito maior. Eficiência de 70B com qualidade próxima de modelos frontier.

**Para fine-tuning de agentes especializados**: os datasets de post-training (RL environments + SFT para agentic capabilities) estão disponíveis — possível reproduzir o processo de training para domínios específicos.

**Para o vault-michel**: este modelo não é diretamente usado neste setup (Claude é o modelo padrão), mas representa o estado da arte em eficiência de modelos open-source para agentic tasks — contexto importante para avaliar alternativas locais como Ollama + Nemotron via OpenHuman.

## References

- arXiv: 2604.12374v1 (April 14, 2026)
- License: CC BY 4.0
- Official repository: NVIDIA-NeMo/Nemotron
