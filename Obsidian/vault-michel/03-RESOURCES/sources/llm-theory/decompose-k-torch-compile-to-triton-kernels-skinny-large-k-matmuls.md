---
title: "Decompose-K: From torch.compile to Hand-Tuned Triton Kernels for Skinny Large-K Matmuls"
type: source
source_url: "https://x.com/shreyansh_26/status/2069125463860302212"
author: "@shreyansh_26"
published: 2026-06-22
created: 2026-06-22
updated: 2026-06-22
score: A
category: llm-theory
tags: [source, llm-theory, gpu-optimization, triton, pytorch, matmul, decompose-k, split-k, inference-optimization, cuda, moe-router]
---

# Decompose-K: From torch.compile to Hand-Tuned Triton Kernels for Skinny Large-K Matmuls

Implementação e benchmark study do Decompose-K: técnica que reestrutura matmuls "skinny" com K dominante (M, N pequenos, K enorme) para paralelizar sobre o único eixo grande. Baseado em talk da PyTorch Conference (Elias Ellison & Paul Zhang, Meta).

## Tese Central

Matmuls skinny e K-dominante (ex: `M=N=16, K=32768` ou MoE router GEMM `[T,7168]@[7168,256]` com T=1) são reduction-bound com quase zero paralelismo exposto pelo tiling standard — 132 SMs idle enquanto 1-2 programs serialmente caminham a redução. **Decompose-K** splita K em S chunks, roda S partial GEMMs como batched matmul (bmm), soma os partials com epilogue fused opcional. Isto troca uma redução serial longa por S reduções paralelas curtas + uma redução final. Expresso como bmm + reduction (não atomic adds), é epilogue-friendly: ReLU pode ser fused no store da redução. Implementação vai de `torch.compile` (baseline) até kernel Triton hand-written que bate o próprio Inductor autotuned.

## Pontos-Chave

### O Problema: Skinny Large-K Matmul

- Standard GEMM tiling: cada program possui `BLOCK_M × BLOCK_N` tile de C, streams over K
- Funciona quando M, N grandes → muitos tiles independentes → GPU SMs ocupados
- **Skinny K-dominant**: `M=N=16, K=32768` → output 16×16=256 elementos = 1-2 tiles → 132 SMs idle
- Exemplo real: DeepSeek-V3 MoE router GEMM `[T,7168]@[7168,256]`, decode T=1..256

### Decompose-K: O Que Faz

```
A[M, K] @ B[K, N]
  → partials[S, M, N]
  → sum(partials, dim=0)
```

- Split K em S chunks → S partial GEMMs independentes → bmm com batch=S
- Para `M=N=16, K=32768, S=64`: 64 matmuls independentes vs 1 output tile
- Cada partial acumula só `K/S=512` da redução, não 32768
- Partials em fp32 (`out_dtype=torch.float32`) → sem custo de accuracy vs single fp32 matmul
- Essencialmente **split-K** mas expresso como bmm + reduction (não atomic adds)

### Epilogue-Friendly

- Split-K com atomic adds: output tile não é final até todos splits terminarem → não dá para fuse ReLU durante acumulação
- Decompose-K: partials em buffer `[S,M,N]` separado → redução **explícita** → epilogue foldado no store da redução
- `acc = sum(partials); acc = relu(acc); store C[m,n] = acc` — sem extra pass, sem segundo read/write
- ~1.2x-1.4x over unfused ReLU para tiny outputs memory-bound

### Quando Vale a Pena

**Vale:** K muito grande, M/N pequenos (16-64), workload latency-sensitive com shape fixo, epilogue fused (ReLU)
**Não vale:** M/N já grandes o suficiente para fill GPU, K pequeno, K divide mal, buffer `[S,M,N]` + redução dominam custo

### Baseline: torch.compile

- `decomposeK_compiled = torch.compile(decomposeK, mode="max-autotune-no-cudagraphs")`
- Inductor emite: `bmm` (external cuBLAS) + fused sum/cast kernel (Triton pointwise)
- Com ReLU: `bmm` + fused sum+relu kernel — epilogue é "free" (rida na redução que tem que rodar)
- PyTorch nightly (2.12.0.dev) já tem Decompose-K lowering dentro do Inductor — autotuna como candidato contra regular matmul templates
- Small K (M=N=16, K=256): Inductor emite single fused matmul template com ReLU no store suffix — no reason to decompose

### Progressão de Implementações

1. **Naive PyTorch + torch.compile** — baseline, Inductor decide
2. **PyTorch com Decompose-K explícito + torch.compile** — bmm + fused reduction
3. **Triton kernel hand-written** — bate Inductor's autotuned choice

Benchmark: BF16 em H100 (132 SMs), grid `M=N ∈ {16,32,48,64}`, `K ∈ {8192,...,32768}`

## Conceitos

- [[03-RESOURCES/concepts/llm-ml-foundations/inference-optimization]] — otimização de inferência
- [[03-RESOURCES/concepts/llm-ml-foundations/inference-engines-hardware-first]] — inference hardware-first
- [[03-RESOURCES/concepts/llm-ml-foundations/kv-cache-llms]] — KV cache
- [[03-RESOURCES/concepts/llm-ml-foundations/speculative-decoding]] — speculative decoding
- [[03-RESOURCES/concepts/llm-ml-foundations/model-compression]] — compressão
- [[03-RESOURCES/concepts/llm-ml-foundations/test-time-compute]] — compute em inference
- [[03-RESOURCES/concepts/llm-ml-foundations/mixture-of-experts]] — MoE (router GEMM)

## Links

- [[03-RESOURCES/entities/Meta]] — PyTorch team (origem da ideia)

## Minha Síntese

Decompose-K é um caso de estudo perfeito de como otimização de GPU é sobre *match entre algoritmo e hardware*, não sobre brute force. O insight estrutural — splitar o único eixo grande para expor paralelismo que o tiling standard esconde — é o mesmo pattern mental que uso ao pensar sobre pipelines: quando o gargalo é um eixo serial, você splita e paraleliza. A progressão de `torch.compile` → hand-tuned Triton também ilustra que o compiler é bom mas não ótimo: conhecer o problema específico (shapes fixas, epilogue opportunity) permite beating o autotuner. Para o vault, isto conecta com o pipeline de ingest: batch processing é o Decompose-K do meu workflow.