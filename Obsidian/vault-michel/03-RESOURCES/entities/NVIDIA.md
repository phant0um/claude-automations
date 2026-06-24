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

## Evidências
- **[2026-06-23]** Computer use agents (CUAs) have advanced rapidly in desktop automation, and a growing number of users deploy CUAs such as OpenClaw on Mac Mini for alw — [[macagentbench-benchmarking-ai-agents-on-real-world-macos-desktop]]
- **[2026-06-23]** Real-world users typically have access to multiple Large Language Models (LLMs) from different providers, and these LLMs often excel at distinct domai — [[agent-as-a-router-agentic-model-routing-for-coding-tasks]]
- **[2026-06-23]** As AI systems move from single-turn interactions to coordinated multiagent workflows, low-latency [inference]() becomes increasing — [[boost-inference-performance-up-to-15x-on-nvidia-blackwell-using-dflash-speculati]]
- **[2026-06-23]** Time series forecasting is a fundamental machine learning task. Recent work has explored Large Language Models (LLMs) for this purpose due to their st — [[distribution-aware-diffusion-llm-for-robust-ultra-long-term-time-series-forecast]]
- **[2026-06-23]** --- title: "From Models to Systems: Enabling Heterogeneous AI Inference with Open Orchestration" source: " author:   - "[[KiranAtmakuri]]"   - "[[Tom_ — [[from-models-to-systems-enabling-heterogeneous-ai-inference-with-open-orchestrati]]
- **[2026-06-23]** Translating sequential programming priors into the parallel temporal logic of hardware design remains a crucial bottleneck for large language models ( — [[how-llms-fail-and-generalize-in-rtl-coding-for-hardware-design]]
- **[2026-06-23]** Telecom operators are adopting AI across network operations, customer care, and back-office workflows, but most are still early in the journey to auto — [[how-telcos-build-autonomous-networks-with-agentic-ai]]
- **[2026-06-23]** [Physical AI]() —robots working autonomously alongside people in factories, warehouses, hospitals, and homes—is arri — [[inside-nvidia-halos-for-robotics-a-full-stack-functional-safety-system-for-physi]]
- **[2026-06-23]** LLM-based coding agents need higher-level operational knowledge about a repository (which files house which subsystems, how to run the test suite, whi — [[probe-and-refine-tuning-of-repository-guidance-for-coding-agents]]
- **[2026-06-23]** Large model inference optimization serves as a key foundation for supporting the scalable, low-cost, and highly stable operation of large model servic — [[token-operations-oriented-inference-optimization-techniques-for-large-models]]
- **[2026-06-23]** Open-weight Large Language Models (LLMs) enable scientific progress and broad deployment. However, they make it difficult to control access to sensiti — [[toward-open-weight-models-without-risks-separating-public-and-private-capabiliti]]
- **[2026-06-23]** The partial deployment of Route Origin Validation (ROV) poses an unexpected security threat known as stealthy BGP hijacking, *i.e.,* a particularly el — [[understanding-the-stealthy-bgp-hijacking-risk-in-the-rov-era]]
- **[2026-06-23]** Security & Identity — [[verifiable-trust-in-the-ai-era-whats-new-in-confidential-computing]]
- **[2026-06-23]** As AI agents become long lived and concurrent, memory capacity, not just compute, has emerged as the deciding factor in real world AI workstation perf — [[why-memory-capacity-is-the-real-performance-bottleneck-in-agentic-ai-workstation]]
- **[2026-06-23]** Yifei Wang [0000-0003-0100-6896]( "ORCID identifier") [whiten@whu.edu.cn]() School of Computer Science, Wuhan UniversityWuhanChina, Ruiyin Li [0000-00 — [[codeteam-an-llm-powered-multi-agent-framework-for-repository-level-code-generati]]
