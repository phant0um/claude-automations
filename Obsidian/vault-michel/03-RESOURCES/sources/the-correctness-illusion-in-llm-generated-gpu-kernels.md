---
title: "The Correctness Illusion in LLM-Generated GPU Kernels"
type: source
source: "Clippings/The Correctness Illusion in LLM-Generated GPU Kernels.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
Benchmarks for LLM-generated GPU kernels (KernelBench, TritonBench, GEAK) score correctness through fixed-shape, small-sample allclose-style checks. The number of inputs varies between benchmarks. The shape, dtype, and tolerance are fixed for each kernel.

## Argumentos principais
### 1 Introduction
LLM-generated GPU kernels are now load-bearing. KernelBench [^6], TritonBench-G (the basis of TritonBench-revised referenced from [^13]), and GEAK [^13] generate hundreds of CUDA and Triton kernels per evaluation. Agentic systems such as KernelBand [^7] and STARK [^3] compose generated kernels into longer pipelines. Every published benchmark in this family scores correctness through a fixed-shape, small-sample allclose-style check. KernelBench [^6] draws five random inputs at the reference shape, for example. The number of samples varies. The shape, dtype, and tolerance are fixed per kernel.
We test the oracle. We argue, and measure, that it is systematically optimistic in three specific ways. (i) The shape candidate set is one shape per op. Kernels with tail masking, off-by-one accumulation, or block-size assumptions pass at the chosen shape and fail elsewhere. (ii) The dtype candidate set is one dtype per op. fp16 and bf16 are rarely tested when fp32 is the listed input. Mixed-precision overflow, underflow, and accumulation errors stay undetected. (iii) The tolerance is hand-picked per op. atol and rtol are typically set one to three orders of magnitude looser than the kernel’s measured error envelope, so loose tolerances absorb real wrongness.
We construct a controlled corpus of 24 kernels and re-evaluate it under seeded, op-schema-aware fuzzing with a high-precision (fp64) reference. 15 of the 24 are correct controls. 9 are LLM-style buggy variants seeded with documented transcription errors (missing $0.5\times$ in GELU, other=0.0 versus -inf in softmax tail masking, missing sqrt in RMSNorm, accumulator overwrite in matmul, missing $1/\sqrt{D}$ in attention, wrong alpha in LeakyReLU, and three others). The full per-kernel listing is in Section 3.3, Table 1. The contributions are four.

### 2 Related Work
LLM kernel benchmarks. KernelBench [^6] and its KernelBench-X extension [^12] evaluate LLM-generated CUDA on 250 GPU workloads. Correctness is torch.allclose against PyTorch reference operators. TritonBench-G hosts 183 Triton kernels at five difficulty levels; GEAK [^13] introduces TritonBench-revised (a harness-tightened subset) and a 30-kernel ROCm benchmark. KernelBand [^7] and STARK [^3] are agentic kernel-optimization systems built on these benchmarks. None of the five systems vary input shape or dtype during correctness scoring.
DL library fuzzing. FreeFuzz [^14], DocTer [^15], DeepREL [^2], and NablaFuzz [^16] fuzz the API layer of PyTorch, TensorFlow, JAX, and OneFlow. Their oracles are differential (cross-backend) or metamorphic. A 2023 benchmarking study [^10] and its TOSEM 2025 extension [^11] measure that the seven SOTA API-level fuzzers in this family collectively catch only 6.5% of real-world bugs. None of them target the kernel layer (CUDA or Triton source) where LLM kernel generation operates.
GPU memory bugs. GPU-Fuzz [^5] generates inputs that probe memory boundary conditions in DL framework CUDA kernels and uncovered 13 previously-unknown bugs. Its scope is memory safety. Ours is numerical correctness.

### 3.1 Op-schema-aware fuzzing
Each kernel ships a schema. The schema declares shared symbolic dims with concrete candidate values, plus per-input tensor names that reference those dims. For matmul: dims $\{M,K,N\}$, inputs $\{a:[M,K],b:[K,N]\}$, output $[M,N]$. For attention: dims $\{M,N,D\}$, inputs $\{q:[M,D],k:[N,D],v:[N,D]\}$. The fuzzer samples one value per dim per test case, deterministically from a master seed through Blake2b sub-key derivation, then materialises every input. The implementation lives in crates/gpuemu-daemon/src/fuzzer.rs of the gpuemu source.
Every dim’s candidate set deliberately includes *boundary* values alongside regular values. For example $H\in\{1,3,7,256,1025\}$. The companion paper [^9] ablates this choice and shows that removing the boundary values from the candidate set drops recall on shape-dependent bugs to zero.

### 3.2 Reference oracle
For each test case the daemon invokes the op’s reference script. The script is a Python subprocess that reads inputs through base64-encoded JSON on stdin, computes the operation in fp64, and casts back to the test dtype. The reference is therefore a high-precision (fp64) mathematical reference rounded to the target dtype. It is not necessarily byte-identical to the kernel’s chosen PyTorch or Triton implementation contract, and we do not claim it is. The reference defines the oracle’s notion of “correct” for the purposes of this paper.
The validator compares the kernel’s output against the reference with a per-(op, dtype) absolute tolerance. We use absolute-only thresholds per (op, dtype) deliberately, in contrast to PyTorch’s allclose which combines an absolute and a relative term as $|x-y|\leq\texttt{atol}+\texttt{rtol}\cdot|y|$. The companion paper [^8] measures the calibration of these absolute thresholds against the kernel’s observed error envelope.
The validator also runs NaN and Inf detection extended to fp16 and bf16, and records the full element-wise ErrorStats distribution per case: count, num\_exceeding, max abs, mean abs, p50 abs, p90 abs, p99 abs, max rel, mean rel, max ULP, mean ULP. The ULP distribution becomes the empirical basis for the tolerance calibration in [^8].

### 3.3 The corpus
The single-GPU evaluation runs on 24 ops: 15 correct controls and 9 LLM-style buggy variants. We extend the corpus to 26 ops by adding a flash-attention control plus its buggy variant for the cross-GPU sweep in Section 4.1. Table 1 lists the full canonical corpus. Each row gives the kernel name, the implementation (numpy stand-in or Triton), the role (correct control or LLM-style buggy variant), the dtypes covered, and the bug pattern each buggy variant encodes.
Table 1: Canonical corpus. 16 controls and 10 LLM-style buggy variants across 26 kernel entries. The single-GPU evaluation (Section 4) runs on rows 1–24; the cross-GPU sweep (Section 4.1) extends to rows 25–26 (flash-attention pair).
<table><tbody><tr><th>#</th><td>kernel name</td><td>impl.</td><td>role</td><td>dtypes</td><td>bug encoded (buggy rows only)</td></tr><tr><th>1</th><td>softmax</td><td>numpy</td><td>control</td><td>fp32, fp16</td><td>—</td></tr><tr><th>2</th><td>layernorm</td><td>numpy</td><td>control</td><td>fp32, fp16</td><td>—</td></tr><tr><th>3</th><td>matmul</td><td>numpy</td><td>control</td><td>fp32, fp16</td><td>—</td></tr><tr><th>4</th><td>softmax_llm_buggy</td><td>numpy</td><td>buggy</td><td>fp32, fp16</td><td>tail-mask leak</td></tr><tr><th>5</th><td>softmax_triton</td><td>triton</td><td>control</td><td>fp32, fp16</td><td>—</td></tr><tr><th>6</th><td>softmax_triton_buggy</td><td>triton</td><td>buggy</td><td>fp32, fp16</td><td>other=0.0 instead of -inf</td></tr><tr><th>7</th><td>gelu_triton</td><td>triton</td><td>control</td><td>fp32, fp16</td><td>—</td></tr><tr><th>8</th><td>gelu_triton_buggy</td><td>triton</td><td>buggy</td><td>fp32, fp16</td><td>dropped leading <math><semantics><mn>0.5</mn> <annotation>0.5</annotation></semantics></math></td></tr><tr><th>9</th><td>silu_triton</td><td>triton</td><td>control</td><td>fp32, fp16</td><td>—</td></tr><tr><th>10</th><td>silu_triton_buggy</td><td>triton</td><td>buggy</td><td>fp32, fp16</td><td>sigmoid(2x) (<math><semantics><mi>β</mi> <annotation>\beta</annotation></semantics></math> confusion)</td></tr><tr><th>11</th><td>rmsnorm_triton</td><td>triton</td><td>control</td><td>fp32, fp16</td><td>—</td></tr><tr><th>12</th><td>rmsnorm_triton_buggy</td><td>triton</td><td>buggy</td><td>fp32, fp16</td><td>forgot sqrt</td></tr><tr><th>13</th><td>l2norm_triton</td><td>triton</td><td>control</td><td>fp32, fp16</td><td>—</td></tr><tr><th>14</th><td>l2norm_triton_buggy</td><td>triton</td><td>buggy</td><td>fp32, fp16</td><td>forgot sqrt</td></tr><tr><th>15</th><td>relu_triton</td><td>triton</td><td>control</td><td>fp32, fp16</td><td>—</td></tr><tr><th>16</th><td>leaky_relu_triton</td><td>triton</td><td>control</td><td>fp32, fp16</td><td>—</td></tr><tr><th>17</th><td>leaky_relu_triton_buggy</td><td>triton</td><td>buggy</td><td>fp32, fp16</td><td><math><semantics><mrow><mi>α</mi> <mo>=</mo> <mn>0.1</mn></mrow> <annotation>\alpha=0.1</annotation></semantics></math> instead of <math><semantics><mn>0.01</mn> <annotation>0.01</annotation></semantics></math></td></tr><tr><th>18</th><td>sigmoid_triton</td><td>triton</td><td>control</td><td>fp32, fp16</td><td>—</td></tr><tr><th>19</th><td>tanh_triton</td><td>triton</td><td>control</td><td>fp32, fp16</td><td>—</td></tr><tr><th>20</th><td>elu_triton</td><td>triton</td><td>control</td><td>fp32, fp16</td><td>—</td></tr><tr><th>21</th><td>matmul_triton</td><td>triton</td><td>control</td><td>fp32, fp16</td><td>—</td></tr><tr><th>22</th><td>matmul_triton_buggy</td><td>triton</td><td>buggy</td><td>fp32, fp16</td><td>acc= instead of acc+=</td></tr><tr><th>23</th><td>attention_triton</td><td>triton</td><td>control</td><td>fp32, fp16</td><td>—</td></tr><tr><th>24</th><td>attention_triton_buggy</td><td>triton</td><td>buggy</td><td>fp32, fp16</td><td>dropped <math><semantics><mrow><mn>1</mn> <mo>/</mo> <msqrt><mi>D</mi></msqrt></mrow> <annotation>1/\sqrt{D}</annotation></semantics></math> score scale</td></tr><tr><th colspan="6">Cross-GPU extension (Section 4.1):</th></tr><tr><th>25</th><td>flash_attention_triton</td><td>triton</td><td>control</td><td>fp32, fp16</td><td>—</td></tr><tr><th>26</th><td>flash_attention_triton_buggy</td><td>triton</td><td>buggy</td><td>fp32, fp16</td><td>dropped <math><semantics><mrow><mtext>acc</mtext> <mo>⋅</mo> <mi>α</mi></mrow> <annotation>\text{acc}\cdot\alpha</annotation></semantics></math> rescale after max update</td></tr></tbody></table>

### 3.4 Pipeline
The experimental harness provisions an ephemeral GPU instance on vast.ai, labelled for safe teardown, builds the daemon from source, installs the Python client and Triton, runs the P1 driver against the corpus, and uploads results to Backblaze B2 under a run id. Teardown is guaranteed by a context-manager \_\_exit\_\_, with a label-strict reaper that cleans up orphan instances. The full artefact details are in the public corpus repository (see Section 7).

### 3.5 Assumptions
The empirical claim that follows depends on five assumptions, which we state plainly so readers can audit them.
1. The 10 buggy variants (9 in the single-GPU corpus plus a flash- attention variant in the cross-GPU extension) are author-seeded with documented LLM transcription patterns. They are not pulled directly from real LLM outputs. The result is therefore about which bug patterns the allclose-on-one-shape oracle certifies as correct, not about the bug rate of any specific deployed LLM. Section 6 discusses why we accept this trade.
2. The high-precision (fp64) reference, rounded to the target dtype, defines the oracle’s notion of “correct” for the purposes of this paper. The reference is not guaranteed to be byte-identical to any particular library’s correctness contract. Treating fp64 round-off as zero is standard practice in mixed-precision validation [^1] [^4].

### 4 Evaluation
Setup. The primary single-GPU run uses an RTX 3060 instance on vast.ai with image pytorch/pytorch:2.4.0-cuda12.4-cudnn9-devel, 30 iterations per (op, dtype) for the 24 single-GPU ops and 2 dtypes, about 1,440 cases. The run id on Backblaze B2 is run-20260611-095210-889b18.
P1 headline. Across the 24-op single-GPU corpus, the seeded oracle flags 9 of 9 LLM-style buggy variants and passes 15 of 15 correct controls. There are no false positives on controls. Table 2 reports the verdict per kernel for a 12-op subset; the full per-kernel result is in summary.json alongside the run id above and in the corpus repository.
Table 2: P1 verdict per kernel on the 24-op single-GPU corpus, 12-op subset. *bench* is the fixed-shape allclose-style oracle. *gpuemu* is the seeded oracle. An *illusion* is a kernel the bench oracle passes but the seeded oracle fails.

### 4.1 Cross-architecture consistency
We extend the corpus to 26 ops by adding a flash-attention control and its LLM-style buggy variant (rows 25–26 in Table 1). We then re-run the same protocol on five GPU classes: RTX 3060 (sm\_86), A10 (sm\_86), A100 SXM4 (sm\_80), L40S (sm\_89), and H100 NVL (sm\_90). The verdicts are identical across all five GPUs: 16 of 16 controls pass cleanly, and 10 of 10 LLM-style illusions are caught. The 10 illusions include the real Triton matmul, attention, and flash-attention buggy variants.
The harness’s safety contract (label-strict reaper, confirmed destroy, context-manager teardown) prevented orphan instances across the five parallel launches even when two providers returned Bind for 0.0.0.0:18433 failed: port is already allocated during provisioning. Figure 2 reports the per-kernel verdicts as two stacked panels (kernels 1–13 on top, 14–26 on bottom) so the per-cell labels stay readable at textwidth.
Figure 2: Cross-GPU verdict consistency on the 26-op corpus. Each panel covers half the corpus; rows are the five GPU classes; cells are per-kernel fail rates. Controls stay green on every GPU. Illusions stay red on every GPU.

### 5 Discussion
The bug categories gpuemu surfaces partition cleanly into two classes.
Magnitude-uniform bugs (gelu missing $0.5$, silu sigmoid(2x), leaky\_relu wrong $\alpha$, rmsnorm and l2norm missing sqrt, attention missing the score scale) are caught on essentially every shape. The LLM benchmark missed them only because it tested one shape and the absolute tolerance was set above the constant bias the bug introduces.
Shape-dependent bugs (softmax tail mask, matmul acc= instead of acc+=) are visible only when the schema includes the right boundary shape. Without boundary-aware fuzzing they are invisible. The companion paper [^9] measures this gap.

### 6 Limitations
The 10 buggy variants are author-seeded with documented LLM transcription bugs. They are not pulled from real LLM-generated kernel outputs. The result is therefore about which bug patterns the allclose-on-one-shape oracle certifies as correct, not about the bug rate of any specific deployed LLM. We choose author-seeded for two reasons. First, ground truth is exact. Second, the eight bug families we seed are documented in the LLM-Triton literature and represent a deliberate threat model rather than a sample of convenience. A natural extension is to fuzz LLM-generated kernels from GEAK [^13] or KernelBench [^6] directly.
The validator currently does same-dtype comparison: kernel-fp16 against reference-fp16 rounded from fp64. Cross-dtype comparison (kernel-fp16 against reference-fp64) is a noted future extension.
The Python client decodes received tensors as contiguous, so non-contiguous layout fuzzing is nominal at the client boundary even when the daemon-side fuzzer varies strides.

### 7 Conclusion
LLM-style transcription bugs in GPU kernels can pass a fixed-shape, small-sample allclose-style oracle as “correct”. The op-schema-aware seeded oracle in this paper exposes the gap. On the 24-op single-GPU corpus, every LLM-style buggy variant is caught and every correct kernel passes. The extended 26-op cross-GPU sweep replays the same verdict on five GPU classes. The countermeasures (boundary-aware shape sets, per-(op, dtype) tolerance calibration [^8], principled input generation [^9]) are within reach of any project that already runs an allclose-style oracle today.
#### Artefact.
The validator daemon and Python client live in the public gpuemu repository at [). The 26-op kernel corpus used in this paper is installable from source at [). The arXiv source for this paper and its three companions is at [); cite the v1.0 release tag on that repository for the exact submitted version. Each flagged failure replays byte for byte from a stored seed.


## Key insights
- A method. Op-schema-aware shape generation produces per-input shapes from shared symbolic dims (matmul $A[M,K]\cdot B[K,N]$, attention $B,H,S,D$). The fuzzer covers the operator’s real domain instead of an arbitrary rank-3 cube.
- A reproducible pipeline. Each failure stores its full input snapshot in the ReproductionInfo payload; a replay script re-runs any flagged case through the daemon and verifies the verdict matches bit for bit.
- The corpus result is about LLM-style transcription bugs that the allclose-on-one-shape oracle certifies as correct, not about the bug rate of any specific deployed LLM.
- ## 1 Introduction

LLM-generated GPU kernels are now load-bearing.
- Every published benchmark in this family scores correctness through a fixed-shape, small-sample allclose-style check.
- 9 are LLM-style buggy variants seeded with documented transcription errors (missing $0.5\times$ in GELU, other=0.0 versus -inf in softmax tail masking, missing sqrt in RMSNorm, accumulator overwrite in matmul, missing $1/\sqrt{D}$ in attention, wrong alpha in LeakyReLU, and three others).
- ## 2 Related Work

LLM kernel benchmarks.
- KernelBench [^6] and its KernelBench-X extension [^12] evaluate LLM-generated CUDA on 250 GPU workloads.
- TritonBench-G hosts 183 Triton kernels at five difficulty levels; GEAK [^13] introduces TritonBench-revised (a harness-tightened subset) and a 30-kernel ROCm benchmark.
- None of them target the kernel layer (CUDA or Triton source) where LLM kernel generation operates.

## Exemplos e evidências
See original source at `Clippings/The Correctness Illusion in LLM-Generated GPU Kernels.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/entities/AWS]]
- [[03-RESOURCES/entities/Python]]
- [[03-RESOURCES/entities/CUDA]]

## Minha Síntese
**O que muda:** Benchmarks de código LLM passam bugs como "corretos" porque testam uma shape, um dtype, com tolerância frouxa — a ilusão de corretude é sistêmica e reproduzível cross-GPU.

**Conexão pessoal:** Ao avaliar código gerado por agentes no vault, preciso de testes boundary-aware, não apenas testes que passam no caso feliz.

**Próximo passo:** Adicionar fuzzing com boundary values como camada de verificação pós-geração de código agent.
