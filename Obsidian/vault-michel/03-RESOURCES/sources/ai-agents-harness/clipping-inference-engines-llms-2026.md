---
title: "Inference Engines for LLMs & Local AI Hardware (2026 Edition)"
type: source
source: "Clippings/Inference Engines for LLMs & Local AI Hardware (2026 Edition).md"
author: "@TheAhmadOsman"
published: 2026-05-20
created: 2026-05-23
ingested: 2026-05-23
tags: [ai-agents, clippings, inference, llm-infrastructure, hardware, local-ai]
---

## Tese central

Não se escolhe inference engine primeiro. Escolhe-se hardware strategy, workload shape e serving model — o engine segue. O engine é o traffic cop, memory manager, kernel dispatcher, scheduler, cache accountant, parallelism planner, API surface e deployment framework.

## Argumentos principais

- **Hardware-first**: engine ótimo depende de memory hierarchy, interconnect, quantization format, latency/throughput targets, model architecture e operational maturity.
- **Prefill vs Decode**: prefill (lê prompt, constrói KV cache) = compute-intensive. Decode (gera token por token) = memory-bandwidth-bound. Isso explica quase tudo sobre escolha de engine.
- **Um-page decision guide**: para cada hardware context, há um engine dominante — não é escolha arbitrária.

## Key insights

### Workload phases
- **Prefill-dominant** (long prompt, short answer): attention kernels e chunked prefill importam
- **Decode-dominant** (short prompt, long answer): memory bandwidth e batching importam
- **Multi-user**: scheduling e batching são críticos para throughput

### Decision guide por contexto

| Contexto | Engine |
|---------|--------|
| Laptop / edge / hardware estranho | llama.cpp |
| Mac-first workflows | MLX / MLX-LM |
| Single RTX local | ExLlamaV2 |
| 2-4+ NVIDIA / CUDA GPUs | ExLlamaV3 |
| Produção geral | vLLM |
| Long-context / MoE / routing | SGLang |
| NVIDIA máximo desempenho | TensorRT-LLM |
| Cluster orchestration | NVIDIA Dynamo |

### O que um inference engine faz
Carrega weights → tokeniza input → forward pass → sampling → mantém KV cache → stream output. Engines sérios adicionam: batching, scheduling, prefix caching, quantização, execução paralela, API serving, métricas, distributed execution.

### Apple Silicon: superpower + tradeoff
- Unified memory = capacidade; mas bandwidth é limitado vs HBM.
- MLX para desenvolvimento nativo; llama.cpp para GGUF.

### Princípio final — 10 perguntas antes de escolher engine
1. Qual hardware você tem?
2. Model cabe em fast memory ou só em system/unified memory?
3. Decode ou prefill é o gargalo?
4. Context length e concurrency que importam?
5. Prompts compartilhados suficientemente para prefix caching?
6. Model é dense, MoE, multimodal ou hybrid?
7. Local convenience, production serving ou fleet orchestration?
8. Qual quantization format tem kernels otimizados no target engine?
9. Interconnect: PCIe, NVLink, NVSwitch, Ethernet, RDMA ou Thunderbolt?
10. Otimizando latência, throughput, custo, privacidade, portabilidade ou dev speed?

## Exemplos e evidências

- Série de 3 partes: Part 1 = GPU Memory Math, Part 2 = Memory Bandwidth, Part 3 = este artigo.
- llama.cpp: portabilidade máxima, roda em hardware heterogêneo.
- vLLM: flexibilidade; SGLang: structured outputs + MoE + routing.
- TensorRT-LLM: desempenho máximo NVIDIA datacenter.

## Implicações para o vault

- Conceito `inference-engines` faltando — este artigo é o fundamento. Criar concept em `03-RESOURCES/concepts/llm-ml-foundations/`.
- Conecta com KV cache knowledge: prefill/decode split explica por que KV cache existe e o que ele otimiza
- Complementa [[03-RESOURCES/sources/ai-agents-harness/clipping-29-llm-eval-concepts]] — eval em produção deve considerar latência de inference

## Links

- [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern]]
- [[03-RESOURCES/entities/Anthropic]]
