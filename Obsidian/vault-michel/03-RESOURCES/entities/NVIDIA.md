---
title: NVIDIA
type: entity
category: organization
created: 2026-05-01
updated: 2026-05-01
tags:
  - ai
  - llm
  - infrastructure
  - gpu
---

## Overview

NVIDIA is a leading AI infrastructure and model development company. Active in LLM development, inference optimization, and quantization research.

## Key Projects

- **Nemotron Series:** Open hybrid Mamba-Attention MoE models
  - Nemotron 3 Nano (first Mamba-Attention hybrid)
  - [[03-RESOURCES/sources/ml-research-papers/nemotron-3-super-hybrid-mamba-attention-moe|Nemotron 3 Super]] (120B-A12B, SOTA throughput)
- **NVFP4:** Low-precision training format enabling stable 4-bit pre-training
- **NeMo Framework:** Model training and inference optimization
- **TRT-LLM:** CUDA kernel-optimized LLM inference
- **X-Token:** Projection-guided cross-tokenizer knowledge distillation (P-KL + H-KL losses, sparse projection matrix W); +3,82 avg over GOLD on Qwen3-4B, 6× GSM8k improvement

- **SkillSpector:** Scanner de segurança open-source para AI agent skills. 64 padrões em 16 categorias. Baseado em pesquisa com 42.447 skills (26,1% vulneráveis, 5,2% maliciosos). [github.com/NVIDIA/SkillSpector](https://github.com/NVIDIA/SkillSpector) — ver [[03-RESOURCES/entities/SkillSpector]]

## Relevance to Vault

[[03-RESOURCES/concepts/llm-ml-foundations/mixture-of-experts]] · [[03-RESOURCES/concepts/llm-ml-foundations/inference-optimization]] · [[03-RESOURCES/concepts/agent-systems/agentic-reasoning]]

---

**Sources:** [[03-RESOURCES/sources/ml-research-papers/nemotron-3-super-hybrid-mamba-attention-moe]] · [[03-RESOURCES/sources/ml-research-papers/x-token-cross-tokenizer-knowledge-distillation]]
