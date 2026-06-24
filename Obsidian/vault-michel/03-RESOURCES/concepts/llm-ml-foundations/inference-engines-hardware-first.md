---
title: "Inference Engines — Hardware-First Framework (2026)"
type: concept
status: developing
created: 2026-05-23
updated: 2026-05-23
tags: [concept, inference, llm-infrastructure, hardware, local-ai, vllm, sglang, llamacpp]
---

# Inference Engines — Hardware-First Framework

**Princípio central:** Não se escolhe engine primeiro. Escolhe-se hardware strategy, workload shape e serving model — o engine segue.

> "Pick hardware strategy, workload shape, serving model. Engine follows." — @TheAhmadOsman

---

## O Que um Inference Engine Faz

Carrega weights → tokeniza input → forward pass → sampling → mantém KV cache → stream output.

Engines sérios adicionam: batching, scheduling, prefix caching, quantização, execução paralela, API serving, métricas, distributed execution.

---

## Prefill vs Decode — A Divisão Fundamental

| Fase | Natureza | Bottleneck |
|------|----------|-----------|
| **Prefill** | Lê prompt, constrói KV cache | Compute-intensive |
| **Decode** | Gera 1 token por vez, lê weights + KV cache repetidamente | Memory-bandwidth-bound |

**Decode speed ≈ memory bandwidth.** Isso explica quase tudo sobre escolha de engine.

- Short prompt, long answer → decode domina → memory bandwidth + batching
- Long prompt, short answer → prefill domina → attention kernels + chunked prefill
- Many users → scheduling e batching críticos

---

## Decision Guide por Contexto

| Contexto | Engine | Motivo |
|---------|--------|--------|
| Laptop / edge / hardware heterogêneo | **llama.cpp** | Portabilidade máxima, GGUF |
| Mac-first / Apple Silicon | **MLX / MLX-LM** | Unified memory nativa |
| Single RTX local | **ExLlamaV2** | CUDA consumer otimizado |
| 2-4+ NVIDIA GPUs | **ExLlamaV3** | Multi-GPU CUDA |
| Produção geral | **vLLM** | Flexibilidade + ecosystem |
| Long-context / MoE / routing | **SGLang** | Structured outputs, disaggregation |
| NVIDIA datacenter máximo | **TensorRT-LLM** | Kernels otimizados NVIDIA |
| Fleet orchestration | **NVIDIA Dynamo** | Cluster-level scheduling |

---

## Apple Silicon — Superpower com Tradeoff

- Unified memory = capacidade (pode rodar modelos que não cabem em VRAM discreta)
- Mas bandwidth é limitado vs HBM NVIDIA
- **Use para**: desenvolvimento, modelos médios, privacidade local
- **Não use para**: throughput máximo em produção com muitos usuários simultâneos

---

## 10 Perguntas Antes de Escolher Engine

1. Qual hardware disponível?
2. Model cabe em fast memory ou só em system/unified memory?
3. Decode ou prefill é o gargalo?
4. Context length e concurrency alvo?
5. Prompts compartilhados suficientemente para prefix caching valer?
6. Model é dense, MoE, multimodal ou hybrid?
7. Local convenience, production serving ou fleet orchestration?
8. Qual quantization format tem kernels otimizados no target engine?
9. Interconnect: PCIe, NVLink, NVSwitch, Ethernet, RDMA ou Thunderbolt?
10. Otimizando latência, throughput, custo, privacidade, portabilidade ou dev speed?

---

## Relação com KV Cache

Prefix caching (cache de KV de prefixos compartilhados) é feature crítica de engines de produção. Prompts com system prompt longo + queries variáveis = KV cache do system prompt reutilizado. vLLM e SGLang implementam; llama.cpp tem suporte básico.

→ [[03-RESOURCES/concepts/llm-ml-foundations/kv-cache-llms]]
→ [[03-RESOURCES/concepts/llm-ml-foundations/inference-optimization]]

---

## Ver Também

- [[03-RESOURCES/concepts/llm-ml-foundations/kv-cache-llms]] — KV cache: fundamento do decode
- [[03-RESOURCES/concepts/llm-ml-foundations/model-quantization]] — quantização afeta choice de engine
- [[03-RESOURCES/concepts/llm-ml-foundations/binary-quantization-embeddings]] — quantização binária: extreme compression para embeddings
- [[03-RESOURCES/concepts/llm-ml-foundations/local-ai]] — contexto de self-hosted inference
- [[03-RESOURCES/sources/ai-agents-harness/clipping-inference-engines-llms-2026]] — fonte primária (série de 3 partes)

## Evidências

- **[2026-06-21]** Programar GPU não é uma otimização do código sequencial — é uma forma diferente de pensar computação (paralela em massa vs. sequencial). Essa mudança de modelo mental, não sintaxe, é por que a skill é escassa e engenheiros seniores com e... — [[cuda-from-scratch-how-to-write-code-for-the-gpu-and-why-it-is-a-scarce-skill]]
- **[2026-06-21]** Walkthrough de código de implementação de CUDA Graphs num servidor de inferência LLM próprio: em vez de lançar kernels um a um a cada passo de decode, captura-se o padrão de execução fixo de cada batch size num grafo e o replay substitui... — [[cuda-graph-implementation-in-llm-inference-server]]
- **[2026-06-21]** Marketing técnico do banco de dados Polygres, usando a Copa do Mundo como caso ilustrativo: previsão esportiva séria não é problema de tabela única, mas de 4 camadas combinadas — dados estruturados (rows), dados de mercado (odds ao longo... — [[could-polygres-predict-the-world-cup]]
- **[2026-06-21]** Gemma 4 31B (Google DeepMind, denso, Apache 2.0) entra em preview na Cerebras Inference rodando a mais de 1.500 tokens/s — 15x mais rápido que Claude Haiku (~100 tok/s) em qualidade comparável — e é o primeiro modelo multimodal (visão) n... — [[gemma-4-on-cerebras-the-fastest-inference-is-now-multimodal]]
- **[2026-06-22]** Intel Computex 2026: DDR5 prices tripled, Moore's Law (economic rule: cost-per-dollar doubling every 2yr) estruturalmente quebrado. 3 DRAM makers (Samsung/SK Hynix/Micron) realocaram fab para HBM. Memory = binding constraint para AI: DeepSeek-V3 redesenhado (MLA+MoE+FP8) para contornar memória, não computation — [[03-RESOURCES/sources/articles/intel-moores-law-broken-memory-constraint]]
