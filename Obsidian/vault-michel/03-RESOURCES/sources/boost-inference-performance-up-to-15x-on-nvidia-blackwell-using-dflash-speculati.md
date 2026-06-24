---
title: "Boost Inference Performance up to 15x on NVIDIA Blackwell Using DFlash Speculative Decoding"
type: source
source: "Clippings/Boost Inference Performance up to 15x on NVIDIA Blackwell Using DFlash Speculative Decoding.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
---
title: "Boost Inference Performance up to 15x on NVIDIA Blackwell Using DFlash Speculative Decoding"
source: "
author:
  - "[[Amr Elmeleegy]]"
published: 2026-06-23
created: 2026-06-23
description: "As AI systems move from single-turn interactions to coordinated multiagent workflows, low-latency inference becomes increasingly important."
tags:
  - "clippings"
---
As AI systems move from single-turn interactions to coordinated multiagent workflows, low-latency [inference]() becomes increasing

## Argumentos principais
### How does DFlash deliver higher throughput at the same interactivity on NVIDIA Blackwell?
Figure 1 shows the latency-throughput Pareto curve for gpt-oss-120b running with DFlash in TensorRT-LLM on an eight [NVIDIA DGX B300]() system using the [SPEED-Bench coding dataset](). Across the curve, DFlash delivers higher throughput at production-relevant latency targets compared with autoregressive decoding. This configuration serves gpt-oss-120b across all eight NVIDIA Blackwell GPUs in the system, providing the GPU memory, compute, and interconnect bandwidth needed to reach high interactivity targets for agentic use cases such as code generation.
Figure 1. Throughput-interactivity Pareto curve for gpt-oss-120b with DFlash on eight NVIDIA DGX B300 GPUs using TensorRT-LLM
At the high interactivity range of 500-600 tokens/sec per user, DFlash increases throughput on NVIDIA Blackwell by more than 15x compared with autoregressive decoding, 1.5x higher than EAGLE-3 speculative decoding. At the lowest concurrency point, with batch size 1, DFlash more than doubles interactivity on Blackwell.

### NVIDIA ecosystem brings DFlash to developers without application refactoring
Researchers at UC San Diego released the paper [DFlash: Block Diffusion for Flash Speculative Decoding]() in February 2026 as part of [ongoing work on faster, more efficient LLM inference]() on NVIDIA Blackwell. Built in PyTorch with native CUDA support, DFlash improves decode performance through block-diffusion speculative decoding. NVIDIA and the open source inference community helped ensure strong framework support across both SGLang and vLLM, giving developers a clear path to introduce DFlash into inference deployments on their serving stack of choice.
Since the paper’s release, the research team has released 20 DFlash model checkpoints on [Hugging Face]() with Blackwell and Hopper recipes, covering model families including Qwen, Kimi K2.6, Llama, Gemma, and gpt-oss. The recipes include support for popular inference frameworks such as SGLang and vLLM..
On vLLM, developers can swap EAGLE-3 with a DFlash checkpoint, with no code changes outside of the config. The integration runs through the open source [Speculators]() library, which connects the DFlash drafter to the target model’s hidden states inside the vLLM inference path on NVIDIA GPUs. On Gemma 4 31B running on a single Blackwell Ultra GPU, this path delivers up to 5.8x higher throughput at the same concurrency over autoregressive decoding (Table 2).

### How does DFlash speculative decoding work?
Speculative decoding has two phases: drafting and verification. A smaller draft model proposes future tokens. The target model verifies those tokens in parallel and accepts the longest valid prefix. If the draft is correct, the system generates multiple tokens with one target-model verification pass.
Traditional speculative decoding methods often use autoregressive draft models. These drafters still generate tokens sequentially, so drafting cost increases as the number of speculative tokens increases. This limits how far the method can push throughput.
DFlash replaces the autoregressive drafter with a lightweight block-diffusion drafter. Instead of generating tokens one by one, the DFlash drafter predicts a block of masked future tokens in a single forward pass.

### Get started boosting inference performance with DFlash
The research community continues to develop new inference optimizations on NVIDIA GPUs, and DFlash is a strong example of how the NVIDIA ecosystem can make these ideas available to developers quickly.
Ready to get started? DFlash is now available on NVIDIA GPUs across [open model checkpoints]() and is supported in SGLang, vLLM, and TensorRT-LLM.


## Key insights
- Block-diffusion drafting**: The drafter predicts multiple future tokens in parallel.
- Target hidden-state conditioning**: The drafter uses context features extracted from the target model.
- KV injection**: Target context features are injected into the draft model’s key-value projections across layers, helping maintain high acceptance rates.

## Exemplos e evidências
See original source at `Clippings/Boost Inference Performance up to 15x on NVIDIA Blackwell Using DFlash Speculative Decoding.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/NVIDIA]]
- [[03-RESOURCES/entities/CUDA]]

## Minha Síntese
**O que muda:** A ser analisado em revisão manual.

**Conexão pessoal:** A ser conectado com projetos/estudo atuais.

**Próximo passo:** Nenhum próximo passo imediato.
