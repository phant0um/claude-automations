---
title: "HyperQuant: A Rate–Distortion-Optimal Quantization Pipeline for Large Language and Diffusion Models"
type: source
source: "Clippings/HyperQuant A Rate–Distortion-Optimal Quantization Pipeline for Large Language and Diffusion Models.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [concurso, source-page]
---

## Tese central
We present HyperQuant (Hadamard, optimallY Packing, Entropy Rice-coding), a unified post-training quantization pipeline for the weights and the KV cache of large language and diffusion transformers. Across a suite of self-contained experiments (LABEL:tab:abstract-best), HyperQuant outperforms the recent HIGGS scheme at every operating point from 3 to 5 bits per scalar (bps) on weights, and beats both TurboQuant and OCTOPUS on KV quantization down to 1.7 bps. Beyond the LLM setting, HyperQuant qu

## Argumentos principais
### 1 Introduction
Frontier language and generative models [^1] [^17] routinely exceed tens of billions of parameters and produce KV caches that dominate inference memory at modern context lengths. Autoregressive decoding is memory-bandwidth-bound: each token requires streaming the entire weight set and KV cache while performing only a thin matrix-vector product, keeping arithmetic intensity well below the hardware’s compute-to-bandwidth ratio [^28]. Post-training quantization (PTQ) turns this bottleneck into a *rate-distortion* compression problem.
For weight quantization, a long line of work (GPTQ [^14], AWQ [^18], SmoothQuant [^37], OmniQuant [^33]) has chipped away at the rate, typically at the cost of a calibration dataset and per-layer optimization. Data-free schemes are simpler and generally preferred for deployment. The state of the art among them, HIGGS [^20], identifies two levers: (1) apply an RHT to weights so their per-coordinate distribution is approximately Gaussian, and (2) quantize to multi-dimensional codebooks that are MSE-optimal for that Gaussian. Its headline result, a linearity theorem reducing global perplexity damage to per-layer $\ell_{2}$ error, justifies focusing the design on per-layer MSE.
HIGGS, however, leaves rate on the table: its codebooks are finite Lloyd grids with *fixed-rate* indices, and information theory predicts that an *entropy-coded* quantizer of equal MSE always needs fewer bits [^19]. Our measurements on real LLM weights (Section˜6.1) confirm the gap: HIGGS’s index entropy is $0.6$ – $5.9\,\%$ below its fixed bit budget at 3–5 bps. Lattice coding theory provides the solution [^6] [^39]: combine a *lattice* quantizer with a variable-length code over its indices.

### 2 Related work
##### Weight quantization with rotations and finite codebooks.
HIGGS [^20] is the data-free state of the art: RHT plus a multi-dimensional Lloyd codebook with fixed-rate indices. HyperQuant shares this architecture but replaces the finite Lloyd codebook with an infinite lattice (codeword density set by a continuous SNR knob) and bit-strips and entropy-codes the index stream with a Rice code rather than transmitting at a fixed $\log_{2}N$ bits per index. Section˜6.1 quantifies both differences.
##### Calibration-based methods.

### 3 Preliminaries
This section reviews the four classical ingredients the rest of the paper builds on: the RHT, optimal low-dimensional lattices as vector quantizers, Rice entropy coding, and the subtractive-dither and random-rotation bias-correction mechanisms. The material is well-established and included to fix notation. Section˜4 assembles these ingredients into HyperQuant, identifying the design choices that diverge from the classical constructions.

### 3.1 Randomized Hadamard Transform
The RHT composes the Walsh-Hadamard matrix $H_{n}$ (an $n\times n$ orthonormal matrix, $O(n\log n)$ Cooley-Tukey butterfly) with a random sign diagonal $D=\operatorname{diag}(\pm 1)$:
$$
\text{RHT}_{n}(x)\;=\;H_{n}D\,x,\qquad D_{ii}\in\{-1,+1\}\text{ iid uniform.}

### 3.2 Optimal low-dimensional lattices
A lattice $\Lambda\subset\mathbb{R}^{n}$ is the set of integer linear combinations of $n$ basis vectors. Two lattice invariants characterize its quality as a vector quantizer:
- the *normalized second moment*
$$

### 3.3 Entropy coding and Rice codes
##### Entropy coding.
For a discrete source $X$ with probability mass function $p$, Shannon’s source coding theorem bounds the average code length per symbol of any uniquely decodable code below by the entropy
$$

### 3.4 Bias correction: rotation and subtractive dither
A nearest-neighbor lattice quantizer is *deterministic* in its input, hence biased: the reconstruction $\hat{x}=Q_{\Lambda}(x)$ satisfies $\hat{x}=x+e(x)$ with a non-zero, $x$ -dependent error $e(x)\in-\mathcal{V}(\Lambda)$. For weight quantization this is harmless: biased reconstructions are absorbed by surrounding affine parameters and disappear into the linearity theorem [^20]. For the KV cache, however, attention
$$
\mathrm{Attention}(q,k,v)=\mathrm{softmax}\bigl(\tfrac{1}{\sqrt{d}}q^{\top}k\bigr)v

### 4 The HyperQuant design
Figure˜1 is the end-to-end HyperQuant block diagram and the map for this section. The *encode* path (top, left to right) turns a bf16 tile into a compact code; the *decode* path (bottom, right to left) inverts every active block in reverse order and feeds the low-precision matrix-multiply-accumulate (MMA). A single encode path serves both linear weights (offline) and the KV cache (online), differing only in the two bias-correction blocks, Rotate and Add dither, which run for the KV cache alone. We cover the blocks in figure order, each forward block with its inverse under one heading (marked *KV only* where applicable), folding the integer-lattice detail into the Quantize and Strip blocks where it is used.
Figure 1: HyperQuant end-to-end pipeline. Encode (top, left to right) and Decode (bottom, right to left), each inverse directly below its forward block. Colour marks applicability: blue is the shared core (weights and KV), orange dashed is bias correction (KV cache only, ablated in Section˜7), and purple is the cast to the Tensor-Core format. The RHT has no decode block: orthogonal along the contraction axis, it is absorbed into the matching rotation on the other MMA operand (ghosted). The MMA is the terminal consumer, not a codec step. Each block names the subsection that documents it.

### 4.1 RHT
*RHT.* Partition $x\in\mathbb{R}^{n}$ into tiles of size $n_{\mathrm{tile}}=2^{k}$ matched to the MMA unit ($128$ on H100/Blackwell) and apply the RHT (1); the $O(n_{\mathrm{tile}}\log n_{\mathrm{tile}})$ butterfly folds into the preceding LayerNorm.
*Inverse RHT.* None is applied explicitly. The RHT is orthogonal along the contraction axis, so $W=(WH^{\top})H$: the rotation cancels against the matching rotation on the other MMA operand, and the decoder never runs an $\mathrm{RHT}^{-1}$ block (ghosted in Figure˜1).

### 4.2 Rotate (KV only)
*Rotate.* Optionally rotate by none, signs ($S=\operatorname{diag}(\pm 1)$, one bit/coordinate, self-inverse), or qjl (Haar $S\sim\operatorname{Uniform}(\mathrm{O}(n))$); the best choice tracks the bit-rate (Section˜6.2).
*Derotate.* Apply $S^{\top}$. Storage cost and the rotation-dither interaction are detailed in Section˜5.2.

### 4.3 Normalize
*Normalize.* Rescale to the lattice’s calibration radius: for KV, each (head, token) vector by its own norm,
$$
\tilde{x}\;=\;\alpha\sqrt{n}\,\frac{Sx}{\lVert Sx\rVert},

### 4.4 Add dither (KV only)
*Add dither.* Optionally add a fresh $U\sim\operatorname{Uniform}(\mathcal{V}(\Lambda))$ before quantization.
*Undither.* Subtract the same $U$ after dequantization. By the Crypto Lemma the error is then uniform on $\mathcal{V}(\Lambda)$ and the reconstruction is strictly inner-product unbiased (Corollary˜2, Appendix˜A).

### 4.5 Quantize
*Quantize.* Map $\tilde{x}$ (plus dither, if enabled) to its nearest point $c=Q_{\Lambda}(\cdot)$ in the integer realization of $\Lambda$; decoding is $O(1)$ for $E_{8},D_{4},A_{2}$ [^6] and nearest-integer rounding for $\mathbb{Z}$.
*Dequantize.* Re-embed the stored integer code vector as its lattice point.
##### Integer realizations.

### 4.6 Strip
*Strip.* Strip the bits that lattice membership pins deterministically (lossless), leaving a compact symbol stream for Rice coding.
*Unstrip.* Reconstruct the pinned bits from the parity relation and undo the halving.
##### Membership constraints.

### 4.7 Rice encode
*Rice encode.* Entropy-code the stripped symbols with the calibrated Rice code (Section˜3.3); on-the-fly bit accounting, fed by the SNR calibration of Section˜B.1, lands the realized rate within $\sim\!0.01$  bps of any target. $E_{8}^{\mathrm{int}}$ and $\mathbb{Z}_{1}^{\mathrm{int}}$ each use a single Rice parameter (for $E_{8}^{\mathrm{int}}$, the coset bit $c$ is folded into its remainder, above); $D_{4}^{\mathrm{int}}$ uses two ($k_{s}$ and $k_{t}=k_{s}{-}1$) and $A_{2}^{\mathrm{int}}$ two ($k_{t_{y}},k_{n_{x}}$). *Rice decode.* Unpack the bitstream into symbols.


## Key insights
- A two-regime characterization of KV-cache quantization quality (Section˜6.2): a high-quality regime ($\geq 2.5$ bps) where all bias-correction variants lie within $0.04$ PPL, and a high-compression regime ($1.7$ – $2.5$ bps) where QJL-style rotation pulls ahead by up to $\sim\!0.5$ PPL.
- An end-to-end stress test on the 19B-parameter LTX-2 video DiT, showing that the same pipeline transfers to a non-LLM transformer architecture and delivers $3.7\times$ weight compression with no perceptible quality loss (Section˜6.5).
- the *normalized second moment*
- Closed-form membership constraints. Each lattice obeys a small set of integer linear constraints (parity, coset, sum modulo a power of two). These pin a fixed number of bits per code vector, which can be stripped from the bitstream before Rice coding without loss.
- $E_{8}^{\mathrm{int}}$: there exists a *coset bit* $c\in\{0,1\}$ such that all coordinates share the same parity, $c_{i}\equiv c\pmod{2}$ for $i=0,\ldots,7$, and the halved coordinates satisfy $\sum_{i=0}^{7}(c_{i}-c)/2\equiv 0\pmod{2}$.
- $D_{4}^{\mathrm{int}}$: $\sum_{i=0}^{3}c_{i}\equiv 0\pmod{2}$.
- $A_{2}^{\mathrm{int}}$: $n_{y}+n_{x}\equiv 0\pmod{2}$.
- $\mathbb{Z}_{1}^{\mathrm{int}}$: no constraint.
- $D_{4}^{\mathrm{int}}$: with no coset bit to fold, the halved symbol $t$ keeps its own parameter, so the stream uses *two* levels: $k_{s}$ for $c_{0},c_{1},c_{2}$ and $k_{t}=k_{s}-1$ for $t$.
- $A_{2}^{\mathrm{int}}$: the two coordinates have different spreads (the $\sqrt{3}$ -scaled $y$ -axis is wider), so they too use *two* levels: $k_{t_{y}}$ for $t_{y}$ and $k_{n_{x}}$ for $n_{x}$.

## Exemplos e evidências
See original source at `Clippings/HyperQuant A Rate–Distortion-Optimal Quantization Pipeline for Large Language and Diffusion Models.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/ai-agents/harness]]
- [[03-RESOURCES/concepts/software-engineering/runtime]]
- [[03-RESOURCES/entities/NVIDIA]]
- [[03-RESOURCES/entities/Python]]
- [[03-RESOURCES/entities/CUDA]]
