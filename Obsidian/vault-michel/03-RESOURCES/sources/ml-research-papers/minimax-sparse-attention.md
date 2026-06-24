---
title: "MiniMax Sparse Attention"
type: source
category: ml-research-papers
source: "https://arxiv.org/html/2606.13392v2"
created: 2026-06-16
ingested: 2026-06-16
tags: [minimax, sparse-attention, transformer, arxiv]
---

# MiniMax Sparse Attention

## Tese Central

MiniMax introduces a sparse attention mechanism that reduces computational complexity while maintaining model quality, enabling efficient long-context processing.

---

## Conteudo Original

Xunhao Lai MiniMax Peking University Weiqi Xu MiniMax Yufeng Yang MiniMax Qiaorui Chen NVIDIA Yang Xu MiniMax Zhejiang University Lunbin Zeng MiniMax Huazhong University of Science and Technology Xiaolong Li MiniMax Zhejiang University Haohai Sun MiniMax Haichao Zhu MiniMax Vito Zhang MiniMax Peking University Jinkai Hu MiniMax Jiayao Li MiniMax Rui Gao MiniMax Nanjing University Zekun Li MiniMax Songquan Zhu MiniMax Jingkai Zhou MiniMax Hangzhou Dianzi University Pengyu Zhao MiniMax

###### Abstract

Ultra-long-context capability is becoming indispensable for frontier LLMs: agentic workflows, repository-scale code reasoning, and persistent memory all require the model to jointly attend over hundreds of thousands to millions of tokens—yet the quadratic cost of softmax attention makes this untenable at deployment scale. We introduce MiniMax Sparse Attention (MSA), a blockwise sparse attention built upon Grouped Query Attention (GQA). A lightweight Index Branch scores key–value blocks and independently selects a Top- $k$ subset for each GQA group, enabling group-specific sparse retrieval while maintaining efficient block-level execution; the Main Branch then performs exact block-sparse attention over only the selected blocks. Designed around a principle of simplicity and scalability, MSA is deliberately streamlined, making it straightforward to deploy efficiently across a broad range of GPUs. To translate sparsity into practical speedups, we co-design MSA with a GPU execution path that uses exp-free Top- $k$ selection and KV-outer sparse attention to improve tensor-core utilization under block-granular access. On a 109B-parameter model with native multimodal training, MSA performs on par with GQA while reducing per-token attention compute by $28.4\times$ at 1M context. Paired with our co-designed kernel, MSA achieves $14.2\times$ prefill and $7.6\times$ decoding wall-clock speedups on H800. Our inference kernel is available at: [https://github.com/MiniMax-AI/MSA](https://github.com/MiniMax-AI/MSA). A production-grade natively multimodal model powered by MSA has been publicly released at: [https://huggingface.co/MiniMaxAI/MiniMax-M3](https://huggingface.co/MiniMaxAI/MiniMax-M3).

![Refer to caption](https://arxiv.org/html/2606.13392v2/figures/msa_arch.png)

Figure 1: Overview of MSA. The Index Branch (left) scores the full causal context with a single lightweight head and selects, for each query and GQA group, a set ℐ {\\mathcal{I}} of k key blocks; the local block is always included regardless of its score. The Main Branch (right) attends only to the selected blocks and produces the layer output. During training, a KL loss aligns the index distribution with the group-averaged Main Branch distribution on the selected blocks, and the Index Branch gradient is detached from the Main Branch.

## 1 Introduction

Large language models (LLMs) are rapidly shifting from short, single-turn interactions to long-horizon agentic workflows that span hundreds of interleaved reasoning and action steps—writing and deploying production code, navigating the open web, orchestrating diverse tools, and producing structured documents [^40] [^2] [^18] [^15] [^38] [^69]. However, the ultra-long contexts these tasks demand impose severe compute and memory bottlenecks on both training and inference, with quadratic-cost softmax attention being the primary culprit, further amplified by the latency and throughput constraints of production-scale deployment.

Context length is a critical scaling dimension for LLMs, where trading off model quality against efficiency remains a formidable challenge. The community is actively pushing the Pareto frontier on this front. Hybrid architectures [^37] [^42] replace a subset of softmax attention layers with efficient alternatives such as linear attention [^49] [^61] [^19] or sliding window attention [^39] [^35]. Alternatively, another line of work attempts to sparsify softmax attention [^14] [^15] [^50] [^31] itself to break the computational bottleneck.

We introduce MiniMax Sparse Attention (MSA), designed following Occam’s razor: after extensive ablation, we retain only the essential components. MSA follows the sparse softmax attention paradigm to maximally reuse existing software and hardware infrastructure. We adopt blockwise token selection with a smaller top- $k$, enabling efficient execution across a wider range of GPU architectures while relaxing the head-dimension constraints imposed by prior designs. Concretely, an ultra-lightweight Index Branch selects, for each attention group, the top- $k$ blocks via max-pooling scoring, while always retaining the most recent block to ensure training stability.

Turning MSA’s theoretical sparsity into practical end-to-end speedups requires co-designing the algorithm with its GPU execution path. To this end, we design an exp-free TopK kernel specialized for the small-k regime, leveraging the blockwise indexer to bypass unnecessary softmax computation before selection. For the main attention branch, we organize sparse attention in a KV-outer order: selected KV blocks gather their associated queries and concatenate them to fill tensor-core MMAs, using pre-scheduled chunking with a two-phase combine to handle highly skewed block popularity without atomic updates. For training, we further fuse the auxiliary LSE computation required by the sparse KL loss into the forward pass and employ persistent load balancing in the backward pass.

To validate that MSA preserves both textual and multimodal capabilities, we compare it against Grouped Query Attention on a 109B-parameter Mixture of Experts (MoE) model trained from scratch with a 3T-token budget. MSA matches GQA on downstream benchmarks while delivering $14.2\times$ prefill and $7.6\times$ decoding speedups at 1M context length.

Main contributions.

- We propose MSA, a minimal, scalable, and accelerated blockwise sparse attention mechanism that supports both training from scratch and near-lossless conversion from pretrained GQA checkpoints.
- We co-design efficient training and inference kernels that turn MSA’s theoretical compute savings into real wall-clock speedups at scale.
- We perform extensive ablations scaling up to a 109B-parameter MoE model with native multimodal training, dissecting MSA’s behavior across scales and modalities.

## 2 Preliminary

### 2.1 Causal Attention and GQA

We write $N$ for the sequence length, $d_{\rm model}$ for the hidden dimension, and $d_{h}$ for the head dimension. For each query position $t$ and head $h$, causal Softmax Attention computes

$$
{\bm{o}}_{t}^{(h)}\;=\;\sum_{i\leq t}\alpha_{t,i}^{(h)}\,{\bm{v}}_{i}^{(h)},\qquad\alpha_{t,i}^{(h)}\;=\;\frac{\exp\!\big(\langle{\bm{q}}_{t}^{(h)},{\bm{k}}_{i}^{(h)}\rangle/\sqrt{d_{h}}\big)}{\sum_{j\leq t}\exp\!\big(\langle{\bm{q}}_{t}^{(h)},{\bm{k}}_{j}^{(h)}\rangle/\sqrt{d_{h}}\big)}.
$$

The cost of eq.˜1 is $\Theta(2H_{q}N^{2}d_{h})$ FLOPs, which grows quadratically with the sequence length $N$. Grouped-Query Attention [^1] uses $H_{q}$ query heads and reduces the number of key-value heads to $H_{kv}$, tying $G=H_{q}/H_{kv}$ adjacent query heads to a single shared key-value head. Thus, each key-value head defines one GQA group.

### 2.2 Sparse Attention as a Two-Stage Process

A sparse attention layer factors causal attention into an indexer that selects which keys to attend to and a sparse attention computation over the selected keys. For each query position $i$,

$$
{\mathcal{I}}_{i}\;=\;\mathrm{Index}_{\phi}\!\big({\bm{q}}_{i},{\bm{K}}_{\leq i}\big),\qquad{\bm{o}}_{i}\;=\;\mathrm{Attn}\!\big({\bm{q}}_{i},{\bm{K}}[{\mathcal{I}}_{i}],{\bm{V}}[{\mathcal{I}}_{i}]\big),
$$

where $\mathrm{Index}_{\phi}$ is parameterized by $\phi$ (empty for fixed-rule indexers; learned for trainable ones), ${\mathcal{I}}_{i}\subseteq\{1,\dots,i\}$ denotes the selected index set, and $\mathrm{Attn}$ denotes standard scaled dot-product softmax attention restricted to this index set. We call the first stage the *Index Branch* and the second the *Main Branch*. In multi-head attention, each query, specified by a position $i$ and a query head $h$, can select a different key/value index set, written as ${\mathcal{I}}_{i}^{(h)}$; eq.˜2 omits the head index only for notational simplicity.

### 2.3 GQA-Based Block Sparse Attention

Per-head token-level selection offers the finest granularity, but such fine-grained computation is difficult to map efficiently to GPU matrix operations. For efficiency, sparse attention built on GQA can share the index result within each GQA group. Let $\mathcal{H}_{r}$ denote the $G$ query heads served by the $r$ -th key-value head. The group-shared index set can be written as

$$
{\mathcal{I}}_{i}^{(r)}={\mathcal{I}}_{i}^{(h)}={\mathcal{I}}_{i}^{(h^{\prime})},\qquad h,h^{\prime}\in\mathcal{H}_{r}.
$$

Selecting key/value blocks rather than individual tokens reduces routing overhead and makes sparse attention more regular. For block size $B_{k}$, define

$$
{\mathcal{B}}_{b}=\{(b{-}1)B_{k}+1,\dots,\min(bB_{k},N)\},\qquad b=1,\dots,B,\quad B=\lceil N/B_{k}\rceil.
$$

For query position $i$ and GQA group $r$, the set ${\mathcal{I}}_{i}^{(r)}\subseteq\{1,\dots,B\}$ denotes the selected block index set. The sparse attention output for any query head in group $r$ is then computed over the causally visible tokens in the selected blocks, using the key-value head of the same group. MSA follows this GQA-based block sparse formulation, with the concrete indexer architecture and training objective described in the next section.

## 3 MSA

We introduce MiniMax Sparse Attention (MSA), a GQA-based sparse attention mechanism with two branches, as illustrated in Figure 1. For each query token, a lightweight *Index Branch* selects a small set of key blocks from the causal context, and the *Main Branch* computes softmax attention over the tokens in those blocks. The Index Branch adds only two projection matrices to standard GQA, operates at block granularity, and makes selections independently for each GQA group. We describe the architecture in Section 3.1 and the training procedure in Section 3.2.

### 3.1 Architecture

MSA instantiates the two-stage sparse-attention formulation in Section 2.2 at GQA-group and block granularity (Figure 1). For each query token, the Index Branch selects $k$ key blocks of size $B_{k}$ for each GQA group, and the Main Branch attends only to tokens in the selected blocks, whose budget is at most $kB_{k}$. Let ${\bm{X}}\in\mathbb{R}^{N\times d_{\rm model}}$ be the input hidden states. Following Section 2.1, we write $H_{q}$ and $H_{kv}$ for the number of query heads and key-value heads, respectively, so each key-value head serves $G=H_{q}/H_{kv}$ query heads.

#### Index Branch.

The Index Branch introduces one index query head for each GQA group and a single index key head shared across groups:

$$
{\bm{Q}}^{\rm idx}={\bm{X}}{\bm{W}}_{q}^{\rm idx}\in\mathbb{R}^{N\times H_{kv}\times d_{\rm idx}},\qquad{\bm{K}}^{\rm idx}={\bm{X}}{\bm{W}}_{k}^{\rm idx}\in\mathbb{R}^{N\times 1\times d_{\rm idx}}.
$$

For query token $i$ and group $r$, the Index Branch first scores visible key tokens, then aggregates these scores to the block level. Using the block partition ${\mathcal{B}}_{1},\dots,{\mathcal{B}}_{B}$ defined in Section 2.3,

$$
{\bm{S}}^{\rm idx,(r)}_{i,j}\;=\;\frac{\bigl({\bm{Q}}^{\rm idx}\bigr)^{(r)}_{i}\,\bigl({\bm{K}}^{\rm idx}\bigr)_{j}^{\top}}{\sqrt{d_{\rm idx}}},\qquad M^{\rm idx,(r)}_{i,b}\;=\;\max_{\begin{subarray}{c}j\in{\mathcal{B}}_{b}\\
j\leq i\end{subarray}}{\bm{S}}^{\rm idx,(r)}_{i,j}.
$$

Here $r$ indexes the GQA group, $j\leq i$ enforces causality, and blocks with no visible token are assigned score $-\infty$. The Index Branch then selects the top- $k$ block indices:

$$
{\mathcal{I}}_{i}^{(r)}\;=\;\mathrm{TopK}_{b\in\{1,\dots,B\}}\!\bigl(M^{\rm idx,(r)}_{i,\cdot},\,k\bigr).
$$

Here $\mathrm{TopK}(\cdot,k)$ returns the indices of the $k$ largest blocks under $M^{\rm idx,(r)}_{i,\cdot}$. We always include the local block containing position $i$, and ${\mathcal{I}}_{i}^{(r)}$ is shared by all $G$ query heads in group $r$.

#### Main Branch.

Given the block index set ${\mathcal{I}}_{i}^{(r)}$ selected by the Index Branch, the Main Branch attends only to the causally visible tokens in the selected blocks. For any query head $h\in\mathcal{H}_{r}$, it applies standard scaled dot-product attention restricted to these tokens, using the key-value head associated with GQA group $r$:

$$
{\bm{O}}_{i}^{(h)}\;=\;\mathrm{softmax}\Biggl(\frac{{\bm{Q}}_{i}^{(h)}\,\bigl({\bm{K}}^{(r)}\!\bigl[{\mathcal{I}}_{i}^{(r)}\bigr]\bigr)^{\top}}{\sqrt{d_{h}}}\Biggr){\bm{V}}^{(r)}\!\bigl[{\mathcal{I}}_{i}^{(r)}\bigr],
$$

where ${\bm{Q}}_{i}^{(h)}$ denotes the query vector at position $i$ and query head $h$, while ${\bm{K}}^{(r)}$ and ${\bm{V}}^{(r)}$ denote the key and value matrices of the $r$ -th GQA group. The notation ${\bm{K}}^{(r)}[{\mathcal{I}}_{i}^{(r)}]$ and ${\bm{V}}^{(r)}[{\mathcal{I}}_{i}^{(r)}]$ denotes gathering the causally visible tokens from the selected blocks. The block index set ${\mathcal{I}}_{i}^{(r)}$ is shared by all query heads in $\mathcal{H}_{r}$, while each head keeps its own query projection. Since the selected blocks contain at most $kB_{k}$ causally visible tokens, the per-query attention cost is reduced from $O(N)$ to $O(kB_{k})$, which is fixed as the sequence length increases.

### 3.2 Training

The top- $k$ selection in Equation 7 is non-differentiable, so the language-modeling loss cannot train the index $Q/K$ projections ${\bm{W}}^{\rm idx}_{q},{\bm{W}}^{\rm idx}_{k}$ directly. We therefore train the Index Branch with a KL alignment loss and use three mechanisms to stabilise sparse training: Gradient Detach, Indexer Warmup, and a forced Local Block. We describe each component below.

#### KL Loss.

The KL loss gives the Index Branch a direct learning signal by matching its scores to the Main Branch on the selected tokens. Writing ${\mathcal{I}}_{i,\mathrm{tok}}^{(r)}=(\bigcup_{b\in{\mathcal{I}}_{i}^{(r)}}{\mathcal{B}}_{b})\cap\{1,\dots,i\}$ for the causally visible tokens induced by the selected block indices, for each query position $i$ and GQA group $r$, we define the Index Branch distribution $P^{\rm idx}$ and the Main Branch teacher $P$ over this token index set:

$$
P^{{\rm idx},(r)}_{i,j}=\frac{\exp(S^{{\rm idx},(r)}_{i,j})}{\sum_{u\in{\mathcal{I}}_{i,\mathrm{tok}}^{(r)}}\exp(S^{{\rm idx},(r)}_{i,u})},\qquad P^{(r)}_{i,j}=\frac{1}{G}\sum_{\ell\in\mathcal{H}_{r}}\frac{\exp(S^{(\ell)}_{i,j})}{\sum_{u\in{\mathcal{I}}_{i,\mathrm{tok}}^{(r)}}\exp(S^{(\ell)}_{i,u})},\qquad j\in{\mathcal{I}}_{i,\mathrm{tok}}^{(r)},
$$

where $S^{{\rm idx},(r)}_{i,j}=({\bm{Q}}^{\rm idx})^{(r)}_{i}({\bm{K}}^{\rm idx})_{j}^{\top}/\sqrt{d_{\rm idx}}$ is the token-level index score, and $S^{(\ell)}_{i,j}={\bm{Q}}^{(\ell)}_{i}({\bm{K}}^{(r)}_{j})^{\top}/\sqrt{d_{h}}$ is the Main Branch score for query head $\ell\in\mathcal{H}_{r}$. The teacher $P$ averages the per-head Main Branch distributions at the probability level. The indexer is then trained to match $P$, averaged over all query positions and GQA groups:

$$
\mathcal{L}_{\rm KL}=\frac{1}{NH_{kv}}\sum_{i=1}^{N}\sum_{r=1}^{H_{kv}}D_{\mathrm{KL}}\bigl(\mathrm{stopgrad}(P^{(r)}_{i,\cdot})\,\|\,P^{{\rm idx},(r)}_{i,\cdot}\bigr),
$$

where $N$ is the sequence length, and the teacher distribution $P^{(r)}_{i,\cdot}$ is detached from gradient computation. This auxiliary loss aligns the index distribution with the Main Branch attention pattern, making the subsequent block selection semantically meaningful.

#### Gradient Detach.

To isolate the auxiliary objective from the backbone, we apply stop-gradient to the Index Branch input:

$$
{\bm{Q}}^{\rm idx}\;=\;\mathrm{stopgrad}({\bm{X}}){\bm{W}}^{\rm idx}_{q},\qquad{\bm{K}}^{\rm idx}\;=\;\mathrm{stopgrad}({\bm{X}}){\bm{W}}^{\rm idx}_{k}.
$$

The teacher $P$ in Equation 9 is detached, so $\mathcal{L}_{\rm KL}$ leaves the Main Branch projections untouched; Equation 11 further prevents it from reaching the backbone through ${\bm{X}}$. Under this rule, $\mathcal{L}_{\rm KL}$ updates only ${\bm{W}}^{\rm idx}_{q}$ and ${\bm{W}}^{\rm idx}_{k}$, making the KL a clean alignment signal for the indexer.

#### Indexer Warmup.

We use a two-stage training schedule to initialise the Index Branch and avoid early random selections. During the first few iterations, the model runs full attention in both branches and trains the newly added index projections with $\mathcal{L}_{\rm KL}$. After warmup, the model switches to sparse attention, and $\mathcal{L}_{\rm KL}$ is computed over the top- $k$ selected positions. The same schedule is used when sparsifying a pretrained full-attention checkpoint, which helps align the newly added index projections before they control Main Branch routing.

#### Local Block.

For each query position $i$ and GQA group $r$, the local block containing $i$ is always selected as part of ${\mathcal{I}}_{i}^{(r)}$ during both training and inference. This fixed allocation reserves one block slot and leaves the remaining slots to be chosen by the Index Branch, preventing degenerate selections that omit the query’s immediate neighbourhood.

The complete layer-level training procedure is summarised in Algorithm 1.

Algorithm 1 One MSA layer: training forward and the auxiliary KL loss. The layer returns its output and per-layer $\mathcal{L}_{\rm KL}$; the model loss $\mathcal{L}=\mathcal{L}_{\rm LM}+\lambda\sum_{\rm layers}\mathcal{L}_{\rm KL}$ is assembled by the training loop.

 hidden states ${\bm{X}}\in\mathbb{R}^{N\times d_{\rm model}}$; block size $B_{k}$, number of selected blocks $k$.

  ${\bm{Q}},{\bm{K}},{\bm{V}}\leftarrow{\bm{X}}{\bm{W}}_{q},\,{\bm{X}}{\bm{W}}_{k},\,{\bm{X}}{\bm{W}}_{v}$ // $(N,H_{q},d_{h}),(N,H_{kv},d_{h}),(N,H_{kv},d_{h})$

  ${\bm{Q}}^{\rm idx},{\bm{K}}^{\rm idx}\leftarrow\mathrm{stopgrad}({\bm{X}}){\bm{W}}^{\rm idx}_{q},\,\mathrm{stopgrad}({\bm{X}}){\bm{W}}^{\rm idx}_{k}$ // $(N,H_{kv},d_{\rm idx}),(N,1,d_{\rm idx})$; detached

  $M^{\rm idx}\leftarrow\mathrm{BlockMaxPool}({\bm{Q}}^{\rm idx},{\bm{K}}^{\rm idx},B_{k})$ // $(N,H_{kv},B)$; per-group, causal

  ${\mathcal{I}}\leftarrow\mathrm{TopK}(M^{\rm idx},\,k)$ // selected block indices; local block included

  ${\bm{O}}\leftarrow\mathrm{TopKAttn}({\bm{Q}},{\bm{K}},{\bm{V}},{\mathcal{I}})$ // $(N,H_{q},d_{h})$; attends to selected blocks

  $\mathrm{output}\leftarrow{\bm{O}}{\bm{W}}_{o}$ // $(N,d_{\rm model})$

  $\mathcal{L}_{\rm KL}\leftarrow\mathrm{KLdiv}({\bm{Q}}^{\rm idx},{\bm{K}}^{\rm idx},\,\mathrm{stopgrad}({\bm{Q}}),\mathrm{stopgrad}({\bm{K}}),\,{\mathcal{I}})$ // over tokens induced by ${\mathcal{I}}$

 return $\mathrm{output},\ \mathcal{L}_{\rm KL}$

### 3.3 Computational Complexity

Under the same $H_{q}$, $H_{kv}$, $d_{h}$, and sequence length $N$, the causal attention FLOPs of GQA and MSA are

$$
F_{\rm GQA}(N)=2H_{q}d_{h}N^{2},\qquad F_{\textsc{MSA}{}}(N)=\underbrace{H_{kv}d_{\rm idx}N^{2}}_{\text{Index Branch}}+\underbrace{4H_{q}d_{h}NkB_{k}}_{\text{Main Branch}}.
$$

GQA scales its main attention path with the full context length, whereas MSA uses a fixed selection budget $kB_{k}$ plus a lightweight index computation; the FLOPs gap therefore grows with $N$ when $kB_{k}\ll N$ and $H_{kv}d_{\rm idx}\ll H_{q}d_{h}$.

## 4 Kernel Design

This section describes the GPU kernels used in our sparse prefill implementation, including the index TopK kernel, the KV-outer sparse attention forward, and the sparse KL loss backward.

### 4.1 Index & TopK

#### Exp-free selection.

To efficiently select the top- $k$ KV blocks, the index module ranks the index scores $s$ directly. Since softmax is order-preserving, the relative ordering of scores is preserved ($s_{i}\leq s_{j}\iff\mathrm{softmax}(s)_{i}\leq\mathrm{softmax}(s)_{j}$), leaving the top- $k$ indices unchanged. The forward pass, therefore, bypasses the max/exp/sum steps of softmax and passes raw scores directly to selection.

#### Benchmark.

We compare against torch.topk and the TileLang [^52] radix-select top- $k$ on an H800 GPU with fp32 inputs and unsorted outputs; latencies are the median of $50$ post-warmup iterations. Table 1 shows that our specialized kernel is fastest in all tested settings, with the largest gains at the deployed setting $k=16$.

| Seq. Len. $N$ | Blocks $B$ | $k$ | torch | TileLang | Ours | vs. torch | vs. TileLang |
| --- | --- | --- | --- | --- | --- | --- | --- |
| $128$ K | $1024$ | $16$ | $3970$ | $2864$ | $779$ | $5.1\times$ | $3.7\times$ |
| $128$ K | $2048$ | $32$ | $5378$ | $3630$ | $1991$ | $2.7\times$ | $1.8\times$ |
| $512$ K | $4096$ | $16$ | $33810$ | $17779$ | $7880$ | $4.3\times$ | $2.3\times$ |
| $512$ K | $8192$ | $32$ | $57659$ | $26100$ | $21326$ | $2.7\times$ | $1.2\times$ |

Table 1: Top- $k$ latency ($\mu$ s) for fp32 inputs of shape $(N,B)$, with rows processed independently. The deployed setting uses $B_{k}=128$, $k=16$, while for reference we also report $k=32$ with $B_{k}=64$. All implementations produce identical index sets.

### 4.2 Sparse Attention

We revisit the choice of iteration order under sparse prefill with equal query and key/value lengths. Let $H_{q}$, $H_{kv}$, $G=H_{q}/H_{kv}$, $d_{h}$, $N$, $B_{k}$, and $k$ denote the number of query heads, key-value heads, GQA ratio, head dimension, sequence length, KV block size, and number of blocks selected per query. For simplicity, the IO estimates below assume 2-byte elements (bfloat16-sized traffic). Our kernels also support fp8; using fp8 rescales the absolute IO volume but leaves the comparison between Q-outer and KV-outer iteration unchanged.

Iterating queries on the outer loop gives

$$
\displaystyle\mathrm{FLOPs}
$$
 
$$
\displaystyle=4\,H_{q}\,N\,d_{h}\,k\,B_{k},
$$
$$
\displaystyle\mathrm{IO}
$$
 
$$
\displaystyle=\underbrace{2\cdot 2\cdot H_{q}\,N\,d_{h}}_{\text{read}({\bm{Q}})+\text{write}({\bm{O}})}+\underbrace{2\cdot 2\cdot H_{kv}\,N\,k\,B_{k}\,d_{h}}_{\text{read}({\bm{K}}+{\bm{V}})},
$$

hence $\mathrm{FLOPs}/\mathrm{IO}\approx G$.

Iterating KV blocks on the outer loop and gathering the queries that selected each block requires an intermediate output buffer:

$$
\displaystyle\mathrm{FLOPs}
$$
 
$$
\displaystyle=4\,H_{q}\,N\,d_{h}\,k\,B_{k},
$$
$$
\displaystyle\mathrm{IO}
$$
 
$$
\displaystyle=\underbrace{2\cdot 2\cdot H_{kv}\,N\,d_{h}}_{\text{read}({\bm{K}}+{\bm{V}})}+\underbrace{2\cdot 2\cdot H_{q}\,N\,k\,d_{h}}_{\text{read}({\bm{Q}})+\text{write}({\bm{O}}_{\text{buf}})}+\underbrace{2\cdot H_{q}\,N\,(k{+}1)\,d_{h}}_{\text{read}({\bm{O}}_{\text{buf}})+\text{write}({\bm{O}})},
$$

hence $\mathrm{FLOPs}/\mathrm{IO}\approx\tfrac{2}{3}B_{k}$.

Since $\tfrac{2}{3}B_{k}\gg G$ in practice, we choose KV-outer iteration with Q gather to maximize arithmetic intensity. The kernel executes as a persistent grid over $(\textit{kv\_block},\textit{kv\_head})$ tiles. For each tile, a reverse sparse index from the TopK selection identifies the relevant query positions. These queries are loaded into shared memory via TMA copies, one per query token, dispatched in parallel by the 32 lanes of a warp.

#### Pre-scheduled tile chunking.

A direct one-CTA-per-tile mapping is dominated by sink rows—a single early KV block selected by nearly every query—and the same hotspot pattern can arise on any popular KV block. A GPU scheduler kernel therefore splits each KV tile along its query dimension into chunks of at most $\sim\!2kB_{k}$ queries each, fanning hot tiles across many CTAs that share the same $\mathbf{K}/\mathbf{V}$ load. Because each query’s $k$ partials are now produced by $k$ CTAs, the scheduler also preassigns each (query, chunk) pair a slot $s\in[0,k)$ in $\mathbf{O}_{\text{buf}}$ —packed with the query index $i$ into a $32$ -bit handle—so the attention kernel writes its partial to the preassigned offset without atomics. The combine kernel reads a per-query slot count to know how many partials to merge.

#### Two-phase forward.

The KV-outer split forbids inline softmax normalization since each query’s $k$ partials are produced by $k$ different CTAs. The forward is therefore split into two kernels separated by HBM buffers $\mathbf{O}_{\text{buf}}\in\mathbb{R}^{k\times n\times H_{q}\times d}$ (locally normalized partial outputs) and $\mathrm{LSE}_{\text{buf}}\in\mathbb{R}^{k\times n\times H_{q}}$ (per-partial logsumexps). The attention kernel runs the worklist above and writes each partial to its preassigned slot. The combine kernel reads the valid slots of each query, computes $a=\max_{s}\mathrm{LSE}_{s}$ and $\mathrm{LSE}[i,h]=a+\log\sum_{s}\exp(\mathrm{LSE}_{s}-a)$, then forms normalized split-K weights $w_{s}=\exp(\mathrm{LSE}_{s}-\mathrm{LSE}[i,h])$. It outputs $\mathbf{O}[i,h]=\sum_{s}w_{s}\,\mathbf{O}_{\text{buf}}[s,i,h]$ together with the final $\mathrm{LSE}[i,h]$. The two kernels use Programmatic Dependent Launch to hide the inter-kernel launch latency.

#### Query concatenation.

KV-outer iteration often associates each KV tile with only a few to a few tens of query positions. Processing these positions one at a time would under-fill the score MMA: with $G=16$, a single query position contributes only $G$ query heads, yielding an MMA $M$ dimension of only 16. Under Q-outer iteration, query positions cannot be concatenated along the sequence dimension because they generally select different KV subsets. Under KV-outer iteration, however, all gathered positions for a given tile share the same KV operands. The kernel, therefore, packs $\lceil 128/G\rceil$ query positions together with their $G$ associated query heads, all under the same KV head, into a $128\times 128$ score MMA.

### 4.3 Sparse KL Loss

#### LSE fusion.

In our initial implementation, we utilized a dedicated kernel to compute the KL divergence forward pass, storing $\mathrm{LSE}_{\rm main}$ and $\mathrm{LSE}_{\rm idx}$ to facilitate backpropagation. However, since the KL loss only affects the backward gradient, we optimize this by emitting these LSE values directly to global memory during the main pass, allowing us to skip the KL loss forward pass entirely. Additionally, during the index branch computation, we save the per-block LSEs and perform a reduction over the top- $k$ blocks to obtain $\mathrm{LSE}_{\rm idx}$. The backward kernel then loads these scalars directly into the softmax, eliminating the redundant forward computation.

#### Dynamic load balancing.

Per-tile work varies by orders of magnitude under variable-length sequences and data-dependent sparsity. The kernel runs as a persistent grid in which CTAs claim work through a global atomic counter; each tile is partitioned along its gathered-query dimension into sub-tiles whose count scales with the per-tile query count, subject to a minimum sub-tile granularity that amortizes per-sub-tile overhead.

## 5 Experiment

This section reports two 109B-scale experiments used to validate the final MSA design on a native multimodal model trained on a mixture of text and image/video data. The first trains a native MSA model from scratch, which we denote as MSA-PT. The second starts from a Full-Attention checkpoint and continues pretraining after replacing dense attention with MSA, which we denote as MSA-CPT. Both models use the same architecture family as the Full-Attention baseline, but replace dense attention with the MSA layer.

### 5.1 Setup

#### Model Structure.

All models use the same 41-layer MoE backbone, with approximately 109B total parameters and 6B activated parameters per token. The first three layers are dense layers, and the remaining 38 layers are MoE layers. The model uses a 200K-token vocabulary and hidden size $d_{\rm model}=3072$. Each attention module uses MSA with 64 query heads, 4 KV heads, head dimension 128, and RoPE dimension 64. Each MoE layer uses 128 routed experts, 1 shared expert, and top-4 routed expert selection. During sparse training and evaluation, both MSA models use block size $B_{k}=128$ and keep $k=16$ key-value blocks per query and GQA group.

#### Training Budget.

All models are trained under a total budget of 3T tokens. MSA-PT is trained from scratch: after a 40B-token indexer warmup, it remains in sparse training for the rest of pretraining. MSA-CPT starts from a GQA Full-Attention checkpoint trained on 2.6T tokens. We then replace dense attention with MSA and continue training for 400B tokens: the first 40B tokens are used for indexer warmup, followed by sparse continued pretraining.

#### Evaluations.

We evaluate Full, MSA-PT, and MSA-CPT on the same pretraining evaluation suite using matched checkpoints under the same training budget. For general reasoning and question answering, we use MMLU [^20], MMLU-Pro [^53], BBH [^47], GPQA Hard [^43], ARC Challenge [^9], TriviaQA [^24], and WinoGrande [^44]. For math and code, we use GSM8K [^10], MGSM [^45], MathVista [^32], OlymMATH [^46], HumanEval [^7], EvalPlus [^29], BigCodeBench [^71], and MultiPL-E MBPP [^6]. We also evaluate multimodal capability: image benchmarks include AI2D [^26], ChartQA [^34], MMMU [^64], OCRBench v2 [^17], CharXiv [^54], VisualWebBench [^30], and CVBench [^51], while video benchmarks include EgoSchema [^33], LongVideoBench [^55], MLVU [^70], MMVU [^68], VideoMME [^16], and TemporalBench [^5]. For long-context evaluation, we use RULER [^21] and HELMET [^62]. We additionally report perplexity on downstream agent tasks, including $\tau^{2}$ -bench [^3], TheAgentCompany [^59], Humanity’s Last Exam [^41], and SWE-bench [^23].

### 5.2 Training Dynamics

Figure 2 compares native sparse pretraining with the matched full-attention run. Over the 3T-token training process, the two LM-loss curves are nearly indistinguishable, showing that MSA does not introduce noticeable optimization degradation relative to full attention. The gradient-norm curves also remain within the same range throughout training, suggesting that MSA does not lead to abnormal gradient fluctuations or training instability. These results indicate that training a sparse attention model is as stable as training the full-attention baseline at a large scale.

Figure 3 illustrates the transition from a trained full-attention checkpoint to sparse continued pretraining. The indexer-warmup stage rapidly reduces the KL loss before sparse attention is enabled. After switching to sparse CPT, the KL loss remains low. For each query and GQA head, let ${\mathcal{I}}^{\star}$ be the corresponding Top- $k$ block set induced by the Main Branch scores and let $\widehat{{\mathcal{I}}}$ be the Index Branch selection. Block recall is $|{\mathcal{I}}^{\star}\cap\widehat{{\mathcal{I}}}|/|{\mathcal{I}}^{\star}|$, while score recall is $\sum_{b\in{\mathcal{I}}^{\star}\cap\widehat{{\mathcal{I}}}}P_{b}/\sum_{b\in{\mathcal{I}}^{\star}}P_{b}$, where $P_{b}$ is the Main Branch attention probability summed over tokens in block $b$. The block recall stays favorable, indicating reliable recovery of important blocks. The higher score recall further shows that the retrieved blocks account for most of the Main Branch attention mass. Together, these dynamics show that warmup provides a clean conversion phase and that the CPT indexer remains well aligned during sparse continued pretraining.

![Refer to caption](https://arxiv.org/html/2606.13392v2/x1.png)

(a) LM loss.

![Refer to caption](https://arxiv.org/html/2606.13392v2/x3.png)

(a) KL loss.

### 5.3 Main Results

Table 2 compares Full, MSA-PT, and MSA-CPT on a representative set of pretraining evaluations. Both sparse models remain broadly competitive with the Full-Attention baseline, indicating that replacing dense attention with MSA does not substantially degrade the model’s general language, reasoning, multimodal, or agent-oriented perplexity profile. The two training routes show different strengths. MSA-PT, which learns the sparse pattern throughout pretraining, obtains the strongest results on many math, image, video, and long-context retrieval benchmarks, suggesting that native sparse pretraining can adapt the model representations to the sparse attention pattern. MSA-CPT is more conservative: it preserves much of the Full-Attention checkpoint behavior and remains close on most text, code, and PPL evaluations, making it a practical conversion route when a trained dense checkpoint is already available. The remaining gaps are benchmark-dependent rather than concentrated in a single capability area.

Table 2: Representative evaluation results under the 3T-token training budget. Full denotes the Full-Attention baseline, MSA-PT denotes from-scratch sparse pretraining, and MSA-CPT denotes sparse continued pretraining. Best per-row results are bolded; lower is better for PPL and higher is better otherwise.

Group Benchmark Full MSA-PT MSA-CPT General MMLU 67.0 67.2 66.8 MMLU-Pro 38.5 38.8 39.1 BBH 67.7 66.6 66.1 GPQA Hard 25.9 26.3 26.3 ARC Challenge 82.7 82.5 82.9 TriviaQA 66.0 65.5 67.7 WinoGrande 58.3 60.9 62.0 Math GSM8K 76.2 77.7 73.7 MGSM 44.1 46.0 44.2 MathVista 43.8 46.8 44.5 OlymMATH Easy P@100 23.0 26.0 22.0 Code HumanEval 61.0 64.0 57.9 EvalPlus 59.4 61.8 60.0 BigCodeBench 44.8 44.0 45.7 MultiPL-E MBPP P@10 82.1 81.6 81.1 Retrieval RULER-8K 79.8 84.2 77.2 RULER-32K 75.0 77.5 75.7 Image AI2D 68.3 70.6 67.3 ChartQA 75.0 75.4 71.4 MMMU 46.8 45.9 44.5 OCRBench v2 55.0 55.7 54.3 CharXiv 37.55 41.55 37.15 VisualWebBench 55.6 68.4 59.4 CVBench 57.0 59.7 58.8 Video EgoSchema 29.6 37.6 25.8 LongVideoBench 38.5 41.8 38.9 MLVU 44.14 46.94 43.68 MMVU 45.8 47.5 45.8 VideoMME 41.11 45.48 39.65 TemporalBench 49.4 53.4 50.6 PPL $\downarrow$ TAU2 1.155 1.148 1.150 AgentCompany 1.248 1.249 1.247 HLE 1.275 1.278 1.275 SWE 1.216 1.218 1.216

To evaluate whether MSA remains effective after long-context scaling, we conduct an additional extension experiment on the MSA-CPT model. Starting from the sparse continued-pretraining checkpoint, we run approximately 140B tokens of long-context training and then evaluate on HELMET and RULER. The results are reported in Table 3. After the extension stage, MSA-CPT remains close to the Full-Attention baseline. Since each query and GQA group still attends to only $kB_{k}=16\times 128=2{,}048$ key-value tokens, these results indicate that MSA can preserve long-context capability under a highly tight attention budget.

Additional ablations supporting these design choices are provided in the appendix. In particular, Section B studies the training recipe for the Index Branch, including gradient sources, KL-gradient detachment, warmup, and the comparison with a sliding-window sparse baseline. Section C further examines architectural choices such as block size, forced sink, local selection, and the Index Branch value head. These ablations provide the empirical basis for the final MSA design used in the main experiments.

Table 3: Long-context extension results for MSA-CPT on HELMET and RULER. $\Delta$ reports the difference between MSA-CPT and the Full-Attention baseline. The "Overall" score is averaged across the fine-grained subtasks. Higher is better for all metrics.

Benchmark Subset Full MSA-CPT $\Delta$ HELMET-128K Overall 46.53 45.93 -0.60 ICL 70.40 72.80 +2.40 Rerank/RAG 34.60 32.50 -2.10 RULER-128K Overall 72.00 72.12 +0.12 CWE/FWE 46.35 45.00 -1.35 MK/MQ/MV 96.63 98.87 +2.24 QA1/QA2 47.80 46.80 -1.00 VT 97.80 96.80 -1.00

### 5.4 Efficiency

We instantiate the complexity analysis in Section 3.3 on our experimental model configuration and report both theoretical attention-FLOPs reduction and measured runtime speedup. Dense GQA and MSA use the same query head count, key-value head count, head dimension, and context length; the only difference is that dense GQA attends to the full context, whereas MSA performs index selection followed by sparse attention over a fixed KV budget. In our setting, MSA uses $B_{k}=128$ and $k=16$, corresponding to a selected budget of $kB_{k}=2{,}048$ tokens per query.

As shown in Figure 4, MSA reduces per-token attention FLOPs substantially relative to GQA in our setting, with the reduction increasing at longer contexts. At $1\mathrm{M}$ tokens, the FLOPs reduction reaches $28.4\times$ under the same head configuration. The measured runtime speedup follows the same scaling trend but is not expected to match the FLOPs reduction exactly. Sparse attention introduces index construction, top- $k$ selection, reverse-index materialization, query gathering, and load-balancing overheads, and its memory access pattern is less regular than dense attention. Therefore, the runtime speedup is smaller than the theoretical FLOPs reduction, but it increases with context length as the dense baseline continues to scale with the full sequence while MSA keeps the main attention budget fixed.

![Refer to caption](https://arxiv.org/html/2606.13392v2/x5.png)

Figure 4: Efficiency comparison between GQA and MSA under the shared experimental model configuration. The left subfigure reports the theoretical per-token attention-FLOPs. The middle and right subfigures report the measured implementation speedups for prefill and decode, respectively. All tests are conducted with 64 query heads, 4 key-value heads, and a head dimension of 128. uses B k = 128 B\_{k}=128 and 16 k=16, corresponding to a selected budget of 2, 048 2{,}048 tokens per query.

## 6 Related Works

Long-context efficiency has motivated a large body of work on efficient attention, which can be broadly grouped into two directions: replacing dense softmax attention with cheaper linear or recurrent alternatives, and retaining softmax attention while restricting its receptive field. Linear attention [^25] [^8] replaces the softmax kernel with a linear-complexity surrogate, while state-space models such as Mamba [^19] replace attention with a selective recurrence over hidden states. Hybrid stacks [^36] [^37] interleave linear blocks with full-attention blocks, reducing the number of quadratic layers while preserving part of the exact-softmax capacity. Fixed-pattern attention keeps softmax attention but imposes a predefined support, including local windows, global tokens [^4] [^65], and attention sinks with a sliding window [^58]. These approaches reduce long-context cost either by replacing dense attention in part or in full, or by using a content-agnostic attention pattern.

Beyond fixed sparse patterns, adaptive sparse attention makes the attended support depend on the input. Existing methods differ mainly in when this support is constructed and whether the selector is trained as part of the model. Inference-time sparsification operates on a pretrained Full-Attention backbone and constructs sparse supports only during serving. H2O [^66] and SnapKV [^28] prune the KV cache during decoding using accumulated attention statistics, Quest [^48] performs page-level importance estimation per query, MInference [^22] and FlexPrefill [^27] dispatch per-head sparse kernels at prefill, and InfLLM [^56] maintains attention sinks, a local context window, and retrievable chunks. These methods inherit the training cost of Full Attention and leave at least one inference phase near Full-Attention speed. Natively trained sparse-attention designs train the indexer during pretraining and form the closest prior work to MSA. NSA [^63] targets MQA/MHA backbones with three parallel branches: compressed attention for coarse global context, selected attention over fine-grained blocks, and a sliding window for local context. InfLLM-V2 [^67] achieves zero-shot dense-to-sparse switching by unifying parameter-free block selection with a local sliding window. MoBA [^31] also operates on GQA but uses very large KV blocks scored by block-averaged keys, and trains its indexer only through the language-modeling gradient. DSA [^14] sits on top of MLA in its MQA mode: a multi-head ReLU-based lightning indexer scores tokens individually, all query heads share a single Top- $k$ index, and selection is token-level. MSA differs from this neighborhood along two axes that are taken up together: per-GQA-group Top- $k$ sharing combined with block-level selection, which gives multi-group block-granular retrieval while keeping KV reads contiguous.

Efficient kernels are essential for sparse attention to translate theoretical FLOP reduction into wall-clock speedups. FlashAttention [^11] and FlashAttention-2 [^13] introduced IO-aware tiled softmax attention, and FlashDecoding [^12] extended this to memory-bound decoding. Open-source block-sparse kernels such as Flash-Sparse-Attention [^60] and FlashMoBA [^57] have made block-sparse variants of this recurrence available. MSA’s kernel, described in section˜4, reuses the FlashAttention algorithmic skeleton with a loop ordering tuned to the GQA-native, block-granular access pattern MSA produces.

## 7 Conclusion

We introduced MSA, a sparse-attention mechanism co-designed with Grouped-Query Attention. The architecture attaches a lightweight Index Branch to a standard GQA layer: each GQA group independently selects a small set of key-value blocks through a block-level dot-product indexer, and the Main Branch performs softmax attention restricted to the selected blocks. The Index Branch is a pure selector and is trained by a KL alignment loss against the Main Branch under a two-stage warmup schedule and a stop-gradient on the index input that confines the auxiliary loss to the index projections. At the 109B-MoE scale, MSA preserves the capability of a GQA Full-Attention baseline across most pretraining and agentic benchmarks while reducing per-token attention compute by $28.4\times$ at $1\mathrm{M}$ context, the regime in which long-context inference becomes the binding deployment constraint.

Outlook. MSA’s core decisions—per-GQA-group independent selection, block-level granularity, and an indexer trained with a KL alignment objective—compose with the GQA backbone shared by most current open-source frontier models, so the recipe should transfer with little modification. Two directions are natural next steps: closing the residual long-context retrieval gap, either through longer sparse training, a larger selection budget at inference time, or a richer indexer scoring function; and extending the same selector-only design to settings beyond pretraining, including reinforcement-learning post-training and agentic deployment, where long-context cost is the dominant operational constraint.

## References

## Appendix A Visualization

To better understand what the learned indexer selects, we visualize the per-head Index Branch selection probability over all query-block and key-block pairs in Figure 5. We show four heads from an early layer (Layer 1) and a later layer (Layer 18), corresponding to four different GQA groups. Across layers, the learned sparse pattern recovers the main structures expected from dense attention: all heads place high probability on the local diagonal, consistently select the sink column, and reserve the remaining budget for a small number of long-range relative positions. At the same time, the non-local selections are not identical across GQA groups. Different groups attend to different long-range stripes while sharing the common local and sink patterns, suggesting that the learned indexer captures group-specific sparse attention patterns rather than collapsing to a single global selection pattern.

![Refer to caption](https://arxiv.org/html/2606.13392v2/figures/vis_analysis_2.png)

(a) Layer 1, four GQA groups. Each group produces a different long-range selection pattern alongside the shared local diagonal and sink column.

We further examine the attention sink phenomenon in MSA models. Even without explicitly forcing the indexer to select the first key-value block, we observe that the learned Index Branch naturally assigns high selection probability to the initial block across all layers and heads. Figure 6 shows results for two representative layers (Layer 4 and Layer 24), each with eight sampled heads. Across both layers, every head directs a substantial fraction of its attention mass to the first token. This confirms that attention focal points naturally emerge and are universally present across different heads and layers, even in our sparse attention mechanism.

![Refer to caption](https://arxiv.org/html/2606.13392v2/figures/plot_sink_v2.png)

Figure 6: Mean attention score on the first token for each attention head in Layer 4 and Layer 24. All heads allocate a significant fraction of attention to the first token, confirming a pervasive attention sink effect across heads and layers.

## Appendix B Preliminary Experiments

This section presents small-scale ablation studies on a pilot model. Our goal is to identify the training-design choices that are essential for stable optimization and strong downstream performance. These results serve as the empirical basis for the final recipe described in Section 3.

### B.1 Setup

All ablations in this section use a 10B-parameter pilot Transformer with the same architecture family as the main paper MSA model but with 16 layers. The model uses a 200K-token vocabulary and hidden size $d_{\rm model}=2048$. Each attention module uses GQA with 32 query heads, 4 KV heads, head dimension 128, and RoPE dimension 64. The MoE contains 64 experts with top-4 expert routing and expert inner dimension 1536. The model has 10.53B total parameters and 1.47B active parameters per token. The optimizer, learning-rate schedule, and tokenizer match the full-scale configuration. Each run is trained on a subset of the same pretraining corpus used at full scale.

### B.2 Gradient Sources for the Index Branch

A central challenge in training the Index Branch is that the top- $k$ selection in Equation 7 is non-differentiable. Under the plain sparse-attention forward pass, the selected block indices are used only as a discrete routing decision. Consequently, the index projections ${\bm{W}}^{\rm idx}_{q}$ and ${\bm{W}}^{\rm idx}_{k}$ receive no useful gradient from the language-modelling objective, and the indexer cannot learn which blocks should be selected. There are several possible ways to introduce a training signal for the indexer. We investigate two mechanisms that preserve the sparse-attention structure while providing gradients to the Index Branch.

Index Branch output. The first mechanism lets the Index Branch contribute an additional attention output. Specifically, we attach a value projection to the Index Branch and compute ${\bm{O}}^{\rm idx}=\mathrm{Attn}({\bm{Q}}^{\rm idx},{\bm{K}}^{\rm idx},{\bm{V}}^{\rm idx})\in\mathbb{R}^{N\times H_{q}\times d_{h}}$. This output is added to the layer output through a separate output projection, ${\bm{O}}^{\prime}={\bm{W}}_{o}{\bm{O}}+{\bm{W}}^{\rm idx}_{o}{\bm{O}}^{\rm idx}$. This design trains the Index Branch through its contribution to next-token prediction.

KL loss. The second mechanism directly supervises the Index Branch by matching its selection distribution to the Main Branch on the selected support. We use the auxiliary loss $\mathcal{L}_{\rm KL}$ defined in Equation 10. This loss acts on ${\bm{W}}^{\rm idx}_{q}$ and ${\bm{W}}^{\rm idx}_{k}$, and provides an explicit training signal for the index selection.

To separate the effects of these two gradient sources, we train the model from scratch in three configurations, using sparse attention from the first step:

- LM Loss only: the Index Branch output is added to the layer output, and the model is trained only with the language-modelling loss,
	$$
	{\bm{O}}^{\prime}={\bm{W}}_{o}{\bm{O}}+{\bm{W}}^{\rm idx}_{o}{\bm{O}}_{\rm idx},\qquad\mathcal{L}=\mathcal{L}_{\rm LM}.
	$$
- KL Loss only: the Index Branch output is discarded, and the indexer is trained only through the auxiliary KL loss,
	$$
	{\bm{O}}^{\prime}={\bm{W}}_{o}{\bm{O}},\qquad\mathcal{L}=\mathcal{L}_{\rm LM}+\lambda\sum_{\rm layers}\mathcal{L}_{\rm KL}.
	$$
- LM Loss + KL Loss: both mechanisms are enabled,
	$$
	{\bm{O}}^{\prime}={\bm{W}}_{o}{\bm{O}}+{\bm{W}}^{\rm idx}_{o}{\bm{O}}_{\rm idx},\qquad\mathcal{L}=\mathcal{L}_{\rm LM}+\lambda\sum_{\rm layers}\mathcal{L}_{\rm KL}.
	$$

Figure 7 reports the per-benchmark delta of each configuration against the Full-Attention GQA baseline trained on the same data. The two single-signal configurations show complementary weaknesses. LM Loss only preserves short-context ability but performs poorly on long-context retrieval: without an objective on the top- $k$ selection itself, the indexer receives little direct pressure to select relevant blocks. KL Loss only improves retrieval but reduces short-context ability: removing ${\bm{O}}_{\rm idx}$ from the layer output reduces the attention capacity available to the language model. LM Loss + KL Loss gives the best balance across the two axes and is the configuration we use for the remaining ablations in this section.

![Refer to caption](https://arxiv.org/html/2606.13392v2/figures/idx_grad_1.png)

Figure 7: Evaluation-score deltas relative to the Full-Attention baseline for three indexer training signals in the pilot setting. Positive values indicate improvements over the baseline, and negative values indicate degradations.

Based on these results, we use the LM Loss + KL Loss configuration for the remaining ablations in this section. We later show in Section C.3 that, once the indexer warmup introduced in Section B.4 is used in the full-scale setting, the Index Branch output is no longer necessary. The final recipe, therefore, keeps the KL supervision but removes the Index Branch value head and its additive output path.

### B.3 Confining the KL Gradient to the Index Branch

The auxiliary KL loss is intended to train the Index Branch to match the Main Branch selection distribution. Under the default autograd graph, the KL gradient flows through the Index Branch query and key projections back into the hidden state, and then into the backbone through the residual stream. In this case, the KL loss becomes an additional objective on the backbone, rather than a local supervision signal for the indexer.

We observe two failure modes from this gradient routing. With larger KL coefficients, occasional KL-gradient spikes propagate into the backbone, causing gradient-norm spikes and LM-loss divergence within a few hundred steps (Figure 8). Even at stable coefficients, standard short-context benchmarks gradually regress during training (Figure 9). We attribute this regression to a self-distillation effect: the backbone can lower the KL loss by simplifying the Main Branch attention distribution, rather than by improving the Index Branch.

We address both failure modes by stopping the KL gradient at the Index Branch input (Section 3.2). Thus, each layer’s KL loss becomes a local supervision signal for its own indexer. With this detach, the LM loss and gradient norm remain stable under the same KL coefficients that cause divergence without detach (Figure 8), and the short-context regression is removed (Figure 9). We use this detach in all subsequent runs.

![Refer to caption](https://arxiv.org/html/2606.13392v2/figures/loss_gradnorm_replica.png)

Figure 8: Training LM loss and gradient norm with and without detaching the KL gradient from the backbone. Detaching confines the auxiliary loss to the Index Branch and avoids the gradient spikes observed without detach.

![Refer to caption](https://arxiv.org/html/2606.13392v2/figures/redrawn_four_benchmarks.png)

Figure 9: General benchmark scores with and without detaching the KL gradient from the backbone. Detaching the auxiliary loss reduces the general ability degeneration observed when the KL gradient updates the backbone.

### B.4 Indexer Warmup

We observe that the Main Branch attention distribution changes rapidly during the earliest stage of training. As shown in Figure 10, the attention entropy quickly drops from an initially smooth distribution to a much sharper one, before entering a slower phase of representation learning. This makes sparse selection fragile at initialization. If top- $k$ selection is enabled from step zero, the Index Branch must track a rapidly moving target while its own selections are still nearly random. Poor early selections then route the Main Branch to uninformative tokens, which weakens both backbone learning and the KL supervision received by the indexer.

We address this issue with a short indexer warmup. During warmup, the Main Branch uses full attention, while the Index Branch is trained by the KL loss against the full-sequence Main Branch distribution. This allows the backbone to pass through the early sharpening phase without sparse routing errors, and gives the indexer a meaningful initialization before it controls token selection. After $T_{\rm warm}$ steps, we enable top- $k$ sparse selection and continue training with the KL loss restricted to the selected support.

Figure 11 compares pretraining runs with and without this warmup. The warmed-up run achieves better short-context performance and stronger long-context retrieval. These results indicate that a short full-attention warmup provides a better initialization for sparse training. We therefore also adopt this warmup when converting Full-Attention checkpoints to sparse attention through continued pretraining.

![Refer to caption](https://arxiv.org/html/2606.13392v2/figures/redrawn_layers_2_7_12.png)

Figure 10: Per-layer entropy of the Main Branch attention distribution during early sparse training. Entropy drops rapidly in the first few hundred steps before partially recovering and stabilizing, motivating a brief full-attention warmup for the indexer.

![Refer to caption](https://arxiv.org/html/2606.13392v2/figures/msa_curves_reproduce.png)

Figure 11: Evaluation results of MSA with and without index warmup. Within the reported training range, index warmup improved scores on general tasks and long-context retrieval.

### B.5 Learnable Attention Sink

The visualization in Figure 6 shows that the first token often acts as an attention sink: many heads assign a non-trivial amount of attention mass to the sequence prefix, even when the sparse selector is not explicitly forced to include it. This raises the question of whether this sink behavior should be represented by an explicit learnable mechanism, rather than being absorbed by the first real token in the sequence. We therefore tested a GPT-OSS-style learnable attention sink. Concretely, each attention head is given an additional learnable sink logit, which competes with normal key positions in the attention softmax.

Figure 12 visualizes the resulting attention patterns. The learnable sink absorbs substantial attention mass in some heads, but it does not completely remove the original first-token sink. In several heads, especially those where the learned sink receives little mass, the first token still receives substantial attention and continues to behave as an implicit sink.

![Refer to caption](https://arxiv.org/html/2606.13392v2/figures/learnable_sink_vis.png)

Figure 12: Attention received by the learnable sink and the first token after introducing a GPT-OSS-style sink parameter. In some heads, the learnable sink absorbs most of the sink-like attention; in others, the first token remains the dominant sink, indicating that the explicit sink does not fully eliminate first-token sink behavior.

We also compare downstream perplexity with and without the learnable sink in Figure 13. The learnable-sink variant does not yield a clear or consistent improvement over the default design. Given its additional parameters, implementation complexity, and the fact that it does not fully suppress first-token sink behavior, we do not include the learnable attention sink in the final recipe.

![Refer to caption](https://arxiv.org/html/2606.13392v2/figures/learnable_sink_results.png)

Figure 13: Perplexity comparison with and without the learnable attention sink on downstream agent-oriented evaluations. Lower perplexity is better. Adding the learnable sink does not provide a consistent advantage over the default MSA design.

### B.6 Dynamic Sparse Selection vs. Sliding Window

To assess the value of dynamic selection, we compare MSA with a FLOP-matched sliding-window baseline. This baseline removes the Index Branch and uses a fixed sparse pattern: each query attends to the first key block and to a local window with the same token budget ending at the query. Therefore, the two methods have the same selection budget and differ only in whether the selected tokens are fixed by position or chosen dynamically.

Figure 14 reports perplexity on downstream agent tasks. Under the same sparse selection budget, the sliding-window model has higher perplexity than MSA across the training trajectory. Although both models benefit from additional training tokens, the fixed local-window pattern does not match the perplexity of dynamic sparse selection. This suggests that, for these agent tasks, a position-fixed sparse pattern is less suitable than content-dependent token selection.

![Refer to caption](https://arxiv.org/html/2606.13392v2/figures/abaltion_swa_ppl.png)

Figure 14: Perplexity comparison between MSA and a FLOP-matched sliding-window baseline on downstream agent-oriented evaluations. Lower Perplexity indicates better modeling performance under the same sparse selection budget.

## Appendix C Additional Ablation Study

### C.1 Block Size

The sparse attention calculation in MSA’s Main Branch processes key-value pairs in units of consecutive $B_{k}$ token blocks, which affects both model performance and efficiency. Larger blocks can improve kernel efficiency but may reduce retrieval quality because of coarser selection granularity. By adjusting $B_{k}$ while keeping the total number of selected tokens constant, we investigate this trade-off. Compared to the main experiment, these runs use fewer training iterations and a subset of the evaluation suite.

As shown in Table 4, varying the block size has a limited impact on model quality in this setting. The PPL results are nearly unchanged across different $B_{k}$ values, and the RULER scores show no clear degradation when increasing the block size from 32 to 64 or 128. This suggests that MSA can use larger key-value blocks to improve kernel efficiency with limited quality loss in these ablations.

Table 4: Perplexity and long-context retrieval scores for different key-value block sizes. Lower is better for perplexity, and higher is better for RULER scores.

<table><tbody><tr><th>Benchmark</th><td>Block 32</td><td>Block 64</td><td>Block 128</td></tr><tr><th colspan="4">PPL <math><semantics><mo>↓</mo> <annotation>\downarrow</annotation></semantics></math></th></tr><tr><th>TAU2</th><td>1.176</td><td>1.176</td><td>1.176</td></tr><tr><th>AgentCompany</th><td>1.266</td><td>1.276</td><td>1.266</td></tr><tr><th>HLE</th><td>1.299</td><td>1.299</td><td>1.300</td></tr><tr><th>SWE</th><td>1.233</td><td>1.233</td><td>1.233</td></tr><tr><th colspan="4">Long-context retrieval</th></tr><tr><th>RULER-8K</th><td>72.5</td><td>72.8</td><td>73.8</td></tr><tr><th>RULER-32K</th><td>66.1</td><td>65.3</td><td>64.6</td></tr></tbody></table>

### C.2 Forced Sink & Local Selection

In early sparse-training experiments, we explicitly forced the selector to include two types of blocks: the first block in the sequence and a fixed local window around the query position. The first block corresponds to the common attention-sink pattern, while the local window preserves nearby context that is important for short-range modeling and provides dense supervision for the indexer. This design was mainly introduced as a stabilization mechanism: before the indexer becomes reliable, forcing these blocks reduces the chance that the sparse branch misses basic context during early training.

We later found that these priors do not need to be hard-coded. When the forced selection of the first block and the fixed local window are removed, the trained model still exhibits both structures: attention concentrates on the sequence prefix when useful, and nearby tokens remain frequently selected. As shown in Table 6, removing forced sink and fixed local selection has little effect on standard model quality: reasoning, code, and PPL metrics remain nearly unchanged. Long-context retrieval is also comparable. These results indicate that the sparse model can learn sink and local-selection patterns without hard-coded selection rules. Therefore, the final recipe does not force the first block or a large local window, and only forces the special incomplete self block.

Table 5: Ablation of forced sink and local-window selection. Higher is better unless marked $\downarrow$.

<table><tbody><tr><th>Benchmark</th><td>No Forced</td><td>Forced</td></tr><tr><th colspan="3">General knowledge & reasoning</th></tr><tr><th>MMLU</th><td>60.5</td><td>60.5</td></tr><tr><th>MMLU-Pro</th><td>32.5</td><td>33.4</td></tr><tr><th>BBH</th><td>58.2</td><td>58.2</td></tr><tr><th>ARC Challenge</th><td>78.1</td><td>77.9</td></tr><tr><th colspan="3">Math</th></tr><tr><th>GSM8K</th><td>66.0</td><td>66.9</td></tr><tr><th>MGSM</th><td>35.8</td><td>36.3</td></tr><tr><th colspan="3">Code</th></tr><tr><th>EvalPlus</th><td>54.0</td><td>53.6</td></tr><tr><th>BigCodeBench</th><td>35.6</td><td>35.7</td></tr><tr><th>MultiPL-E MBPP P@10</th><td>80.1</td><td>79.5</td></tr><tr><th colspan="3">Image</th></tr><tr><th>ChartQA</th><td>73.5</td><td>73.7</td></tr><tr><th>MMMU</th><td>43.6</td><td>42.9</td></tr><tr><th colspan="3">Video</th></tr><tr><th>VideoMMMU</th><td>32.1</td><td>32.0</td></tr><tr><th colspan="3">PPL <math><semantics><mo>↓</mo> <annotation>\downarrow</annotation></semantics></math></th></tr><tr><th>TAU2</th><td>1.175</td><td>1.175</td></tr><tr><th>AgentCompany</th><td>1.268</td><td>1.266</td></tr><tr><th>HLE</th><td>1.301</td><td>1.300</td></tr><tr><th>SWE</th><td>1.235</td><td>1.233</td></tr><tr><th colspan="3">Long-context retrieval</th></tr><tr><th>RULER-8K</th><td>71.6</td><td>71.7</td></tr><tr><th>RULER-32K</th><td>61.5</td><td>65.8</td></tr></tbody></table>

Table 6: Continued pre-training ablation of the Index Branch value head.

<table><tbody><tr><th>Benchmark</th><td>With-value</td><td>No-value</td></tr><tr><th colspan="3">General knowledge & reasoning</th></tr><tr><th>MMLU</th><td>66.4</td><td>67.3</td></tr><tr><th>MMLU-Pro</th><td>39.0</td><td>39.1</td></tr><tr><th>BBH</th><td>65.3</td><td>65.9</td></tr><tr><th>ARC Challenge</th><td>82.2</td><td>82.4</td></tr><tr><th colspan="3">Math</th></tr><tr><th>GSM8K</th><td>77.6</td><td>76.4</td></tr><tr><th>MathVista</th><td>45.2</td><td>43.6</td></tr><tr><th>MGSM</th><td>48.4</td><td>47.6</td></tr><tr><th colspan="3">Code</th></tr><tr><th>HumanEval</th><td>60.4</td><td>59.1</td></tr><tr><th>EvalPlus</th><td>57.7</td><td>58.7</td></tr><tr><th>BigCodeBench</th><td>46.0</td><td>44.0</td></tr><tr><th colspan="3">Image</th></tr><tr><th>AI2D</th><td>69.3</td><td>70.4</td></tr><tr><th>ChartQA</th><td>75.3</td><td>74.9</td></tr><tr><th>MMMU</th><td>44.9</td><td>43.4</td></tr><tr><th>OCRBench v2</th><td>53.2</td><td>53.9</td></tr><tr><th colspan="3">Video</th></tr><tr><th>MLVU</th><td>42.4</td><td>43.9</td></tr><tr><th>MMVU</th><td>44.9</td><td>43.7</td></tr><tr><th>PerceptionTest</th><td>45.0</td><td>47.3</td></tr><tr><th colspan="3">Long-context retrieval</th></tr><tr><th>RULER-8K</th><td>84.1</td><td>83.0</td></tr><tr><th>RULER-32K</th><td>79.7</td><td>80.4</td></tr></tbody></table>

### C.3 Index Branch Value Head

Our preliminary experiments (Section B.2) show that providing an additional attention output through the Index Branch helps the model begin sparse training from step zero. However, this index value head introduces additional computation and complexity. Since the indexer warmup in Section B.4 already improves the initialization for sparse training, we further ablate whether the value head is still needed.

We compare the original with-value design against a no-value variant that trains the indexer only with the KL alignment signal. As shown in Table 6, removing the index value head does not lead to a systematic degradation across the evaluation suite. The no-value variant is slightly better on some general reasoning benchmarks, while the with-value variant retains small advantages on some math and code tasks. On multimodal benchmarks and long-context retrieval, the differences are also mixed.

Overall, the results indicate that the index value head is not critical once the Index Branch warmup is used. Its effect on downstream quality is small and benchmark-dependent, with neither variant consistently dominating the other. This suggests that the main role of ${\bm{O}}_{\rm idx}$ in the earlier recipe was to provide an additional early training signal, rather than to supply essential capacity at convergence. The final design, therefore, drops the index value head on efficiency grounds. At inference time, the top- $k$ indexer only needs the block-wise maximum of ${\bm{Q}}_{\rm idx}{\bm{K}}_{\rm idx}^{\top}$, avoiding the value aggregation path and exponential calculations entirely.

[^1]: GQA: training generalized multi-query transformer models from multi-head checkpoints. In Proceedings of the 2023 Conference on Empirical Methods in Natural Language Processing (EMNLP), Cited by: §2.1.

[^2]: Claude Opus 4.6 and Sonnet 4.6 model card. Note: [https://www.anthropic.com/news/claude-4-6](https://www.anthropic.com/news/claude-4-6) Cited by: §1.

[^3]: $\tau^{2}$ -bench: evaluating conversational agents in a dual-control environment. arXiv preprint arXiv:2506.07982. Cited by: §5.1.

[^4]: Longformer: the long-document transformer. arXiv preprint arXiv:2004.05150. Cited by: §6.

[^5]: TemporalBench: benchmarking fine-grained temporal understanding for multimodal video models. External Links: 2410.10818, [Link](https://arxiv.org/abs/2410.10818) Cited by: §5.1.

[^6]: MultiPL-E: a scalable and polyglot approach to benchmarking neural code generation. IEEE Transactions on Software Engineering 49 (7), pp. 3675–3691. Cited by: §5.1.

[^7]: Evaluating large language models trained on code. External Links: 2107.03374, [Link](https://arxiv.org/abs/2107.03374) Cited by: §5.1.

[^8]: Rethinking attention with performers. In International Conference on Learning Representations (ICLR), Cited by: §6.

[^9]: Think you have solved question answering? try arc, the ai2 reasoning challenge. External Links: 1803.05457, [Link](https://arxiv.org/abs/1803.05457) Cited by: §5.1.

[^10]: Training verifiers to solve math word problems. External Links: 2110.14168, [Link](https://arxiv.org/abs/2110.14168) Cited by: §5.1.

[^11]: FlashAttention: fast and memory-efficient exact attention with IO-awareness. In Advances in Neural Information Processing Systems, Cited by: §6.

[^12]: Flash-decoding for long-context inference. Note: [https://crfm.stanford.edu/2023/10/12/flashdecoding.html](https://crfm.stanford.edu/2023/10/12/flashdecoding.html) Cited by: §6.

[^13]: FlashAttention-2: faster attention with better parallelism and work partitioning. In International Conference on Learning Representations (ICLR), Cited by: §6.

[^14]: DeepSeek-v3.2: pushing the frontier of open large language models. External Links: 2512.02556, [Link](https://arxiv.org/abs/2512.02556) Cited by: §1, §6.

[^15]: DeepSeek-V4: towards highly efficient million-token context intelligence. Note: Technical report (preview). Cited by: §1, §1.

[^16]: Video-MME: the first-ever comprehensive evaluation benchmark of multi-modal LLMs in video analysis. arXiv preprint arXiv:2405.21075. Cited by: §5.1.

[^17]: OCRBench v2: an improved benchmark for evaluating large multimodal models on visual text localization and reasoning. External Links: 2501.00321, [Link](https://arxiv.org/abs/2501.00321) Cited by: §5.1.

[^18]: Gemini 3.1 pro. Note: [https://deepmind.google/technologies/gemini/](https://deepmind.google/technologies/gemini/) Cited by: §1.

[^19]: Mamba: linear-time sequence modeling with selective state spaces. arXiv preprint arXiv:2312.00752. Cited by: §1, §6.

[^20]: Measuring massive multitask language understanding. In International Conference on Learning Representations, External Links: [Link](https://openreview.net/forum?id=d7KBjmI3GmQ) Cited by: §5.1.

[^21]: RULER: what’s the real context size of your long-context language models?. In First Conference on Language Modeling, External Links: [Link](https://openreview.net/forum?id=kIoBbc76Sy) Cited by: §5.1.

[^22]: MInference 1.0: accelerating pre-filling for long-context LLMs via dynamic sparse attention. In Advances in Neural Information Processing Systems, Cited by: §6.

[^23]: SWE-bench: can language models resolve real-world GitHub issues?. In International Conference on Learning Representations (ICLR), Cited by: §5.1.

[^24]: TriviaQA: a large scale distantly supervised challenge dataset for reading comprehension. In Proceedings of the 55th Annual Meeting of the Association for Computational Linguistics (Volume 1: Long Papers), R. Barzilay and M. Kan (Eds.), Vancouver, Canada, pp. 1601–1611. External Links: [Link](https://aclanthology.org/P17-1147/), [Document](https://dx.doi.org/10.18653/v1/P17-1147) Cited by: §5.1.

[^25]: Transformers are RNNs: fast autoregressive transformers with linear attention. In International Conference on Machine Learning (ICML), Cited by: §6.

[^26]: A diagram is worth a dozen images. In European Conference on Computer Vision (ECCV), Cited by: §5.1.

[^27]: FlexPrefill: A context-aware sparse attention mechanism for efficient long-sequence inference. In The Thirteenth International Conference on Learning Representations, ICLR 2025, Singapore, April 24-28, 2025, External Links: [Link](https://openreview.net/forum?id=OfjIlbelrT) Cited by: §6.

[^28]: SnapKV: LLM knows what you are looking for before generation. In Advances in Neural Information Processing Systems, Cited by: §6.

[^29]: Is your code generated by chatgpt really correct? rigorous evaluation of large language models for code generation. In Advances in Neural Information Processing Systems, A. Oh, T. Naumann, A. Globerson, K. Saenko, M. Hardt, and S. Levine (Eds.), Vol. 36, pp. 21558–21572. External Links: [Link](https://proceedings.neurips.cc/paper_files/paper/2023/file/43e9d647ccd3e4b7b5baab53f0368686-Paper-Conference.pdf) Cited by: §5.1.

[^30]: VisualWebBench: how far have multimodal LLMs evolved in web page understanding and grounding?. In First Conference on Language Modeling, External Links: [Link](https://openreview.net/forum?id=egVSgtJJAx) Cited by: §5.1.

[^31]: MoBA: mixture of block attention for long-context llms. External Links: 2502.13189, [Link](https://arxiv.org/abs/2502.13189) Cited by: §1, §6.

[^32]: MathVista: evaluating mathematical reasoning of foundation models in visual contexts. In The Twelfth International Conference on Learning Representations, External Links: [Link](https://openreview.net/forum?id=KUNzEQMWU7) Cited by: §5.1.

[^33]: EgoSchema: a diagnostic benchmark for very long-form video language understanding. In Advances in Neural Information Processing Systems (NeurIPS) Datasets and Benchmarks Track, Cited by: §5.1.

[^34]: ChartQA: a benchmark for question answering about charts with visual and logical reasoning. In Findings of the Association for Computational Linguistics: ACL 2022, S. Muresan, P. Nakov, and A. Villavicencio (Eds.), Dublin, Ireland, pp. 2263–2279. External Links: [Link](https://aclanthology.org/2022.findings-acl.177/), [Document](https://dx.doi.org/10.18653/v1/2022.findings-acl.177) Cited by: §5.1.

[^35]: MiMo-v2-flash technical report. External Links: 2601.02780, [Link](https://arxiv.org/abs/2601.02780) Cited by: §1.

[^36]: MiniMax-01: scaling foundation models with lightning attention. arXiv preprint arXiv:2501.08313. Cited by: §6.

[^37]: MiniMax-M1: scaling test-time compute efficiently with lightning attention. arXiv preprint arXiv:2506.13585. Cited by: §1, §6.

[^38]: Kimi K2.6: open agentic foundation model. Note: [https://moonshotai.github.io/Kimi-K2/](https://moonshotai.github.io/Kimi-K2/) Cited by: §1.

[^39]: Gpt-oss-120b & gpt-oss-20b model card. External Links: 2508.10925, [Link](https://arxiv.org/abs/2508.10925) Cited by: §1.

[^40]: Introducing GPT-5. Note: [https://openai.com/gpt-5/](https://openai.com/gpt-5/) Cited by: §1.

[^41]: Humanity’s last exam. arXiv preprint arXiv:2501.14249. Cited by: §5.1.

[^42]: Qwen3.5: accelerating productivity with native multimodal agents. External Links: [Link](https://qwen.ai/blog?id=qwen3.5) Cited by: §1.

[^43]: GPQA: a graduate-level google-proof Q&A benchmark. arXiv preprint arXiv:2311.12022. Cited by: §5.1.

[^44]: WinoGrande: an adversarial winograd schema challenge at scale. Proceedings of the AAAI Conference on Artificial Intelligence 34 (05), pp. 8732–8740. External Links: ISSN 2159-5399, [Link](http://dx.doi.org/10.1609/aaai.v34i05.6399), [Document](https://dx.doi.org/10.1609/aaai.v34i05.6399) Cited by: §5.1.

[^45]: Language models are multilingual chain-of-thought reasoners. External Links: 2210.03057, [Link](https://arxiv.org/abs/2210.03057) Cited by: §5.1.

[^46]: Challenging the boundaries of reasoning: an olympiad-level math benchmark for large language models. arXiv preprint arXiv:2503.21380. Cited by: §5.1.

[^47]: Challenging big-bench tasks and whether chain-of-thought can solve them. External Links: 2210.09261, [Link](https://arxiv.org/abs/2210.09261) Cited by: §5.1.

[^48]: Quest: query-aware sparsity for efficient long-context LLM inference. In International Conference on Machine Learning (ICML), Cited by: §6.

[^49]: Kimi linear: an expressive, efficient attention architecture. External Links: 2510.26692, [Link](https://arxiv.org/abs/2510.26692) Cited by: §1.

[^50]: MiniCPM4: ultra-efficient llms on end devices. External Links: 2506.07900, [Link](https://arxiv.org/abs/2506.07900) Cited by: §1.

[^51]: Cambrian-1: a fully open, vision-centric exploration of multimodal llms. In Advances in Neural Information Processing Systems, A. Globerson, L. Mackey, D. Belgrave, A. Fan, U. Paquet, J. Tomczak, and C. Zhang (Eds.), Vol. 37, pp. 87310–87356. External Links: [Document](https://dx.doi.org/10.52202/079017-2771), [Link](https://proceedings.neurips.cc/paper_files/paper/2024/file/9ee3a664ccfeabc0da16ac6f1f1cfe59-Paper-Conference.pdf) Cited by: §5.1.

[^52]: TileLang: a composable tiled programming model for ai systems. External Links: 2504.17577, [Link](https://arxiv.org/abs/2504.17577) Cited by: §4.1.

[^53]: MMLU-pro: a more robust and challenging multi-task language understanding benchmark. In Advances in Neural Information Processing Systems, A. Globerson, L. Mackey, D. Belgrave, A. Fan, U. Paquet, J. Tomczak, and C. Zhang (Eds.), Vol. 37, pp. 95266–95290. External Links: [Document](https://dx.doi.org/10.52202/079017-3018), [Link](https://proceedings.neurips.cc/paper_files/paper/2024/file/ad236edc564f3e3156e1b2feafb99a24-Paper-Datasets_and_Benchmarks_Track.pdf) Cited by: §5.1.

[^54]: CharXiv: charting gaps in realistic chart understanding in multimodal LLMs. In Advances in Neural Information Processing Systems (NeurIPS) Datasets and Benchmarks Track, Cited by: §5.1.

[^55]: LongVideoBench: a benchmark for long-context interleaved video-language understanding. In Advances in Neural Information Processing Systems, A. Globerson, L. Mackey, D. Belgrave, A. Fan, U. Paquet, J. Tomczak, and C. Zhang (Eds.), Vol. 37, pp. 28828–28857. External Links: [Document](https://dx.doi.org/10.52202/079017-0907), [Link](https://proceedings.neurips.cc/paper_files/paper/2024/file/329ad516cf7a6ac306f29882e9c77558-Paper-Datasets_and_Benchmarks_Track.pdf) Cited by: §5.1.

[^56]: InfLLM: training-free long-context extrapolation for LLMs with an efficient context memory. arXiv preprint arXiv:2402.04617. Cited by: §6.

[^57]: Optimizing mixture of block attention. arXiv preprint arXiv:2511.11571. Cited by: §6.

[^58]: Efficient streaming language models with attention sinks. In International Conference on Learning Representations (ICLR), Cited by: §6.

[^59]: TheAgentCompany: benchmarking LLM agents on consequential real world tasks. arXiv preprint arXiv:2412.14161. Cited by: §5.1.

[^60]: Flash sparse attention: more efficient natively trainable sparse attention. arXiv preprint arXiv:2508.18224. Cited by: §6.

[^61]: Gated delta networks: improving mamba2 with delta rule. External Links: 2412.06464, [Link](https://arxiv.org/abs/2412.06464) Cited by: §1.

[^62]: HELMET: how to evaluate long-context models effectively and thoroughly. In The Thirteenth International Conference on Learning Representations, External Links: [Link](https://openreview.net/forum?id=293V3bJbmE) Cited by: §5.1.

[^63]: Native sparse attention: hardware-aligned and natively trainable sparse attention. In Proceedings of the 63rd Annual Meeting of the Association for Computational Linguistics (ACL), Note: arXiv:2502.11089 Cited by: §6.

[^64]: MMMU: a massive multi-discipline multimodal understanding and reasoning benchmark for expert AGI. In IEEE/CVF Conference on Computer Vision and Pattern Recognition (CVPR), Cited by: §5.1.

[^65]: Big bird: transformers for longer sequences. In Advances in Neural Information Processing Systems, Cited by: §6.

[^66]: H2O: heavy-hitter oracle for efficient generative inference of large language models. In Advances in Neural Information Processing Systems, Cited by: §6.

[^67]: InfLLM-v2: dense-sparse switchable attention for seamless short-to-long adaptation. CoRR abs/2509.24663. External Links: [Link](https://doi.org/10.48550/arXiv.2509.24663), [Document](https://dx.doi.org/10.48550/ARXIV.2509.24663), 2509.24663 Cited by: §6.

[^68]: MMVU: measuring expert-level multi-discipline video understanding. arXiv preprint arXiv:2501.12380. Cited by: §5.1.

[^69]: GLM-5.1: open foundation models from Zhipu AI. Note: [https://github.com/THUDM/GLM-5](https://github.com/THUDM/GLM-5) Cited by: §1.

[^70]: MLVU: benchmarking multi-task long video understanding. In Proceedings of the IEEE/CVF Conference on Computer Vision and Pattern Recognition (CVPR), pp. 13691–13701. Cited by: §5.1.

[^71]: BigCodeBench: benchmarking code generation with diverse function calls and complex instructions. In The Thirteenth International Conference on Learning Representations, External Links: [Link](https://openreview.net/forum?id=YrycTjllL0) Cited by: §5.1.
