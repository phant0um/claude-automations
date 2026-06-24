---
title: "Scheduling Thoughts: Learning the Order of Thought in Diffusion Language Models"
type: source
source: "Clippings/Scheduling Thoughts Learning the Order of Thought in Diffusion Language Models.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [concurso, source-page]
---

## Tese central
Masked diffusion language models decode by iteratively unmasking tokens, where the unmasking order defines an “order of thought” that strongly influences generation quality yet is typically chosen heuristically. We derive a tractable upper bound on the sequential decoding mismatch, measured by the Kullback–Leibler divergence and expressed in terms of the model’s pathwise log-likelihood, with tightness under sufficient model expressivity. This bound induces a dense self-aware reward over ordered 

## Argumentos principais
### 1 Introduction
Diffusion decoding has a hidden degree of freedom: *the order of thought*. Masked diffusion language models [^2] [^22] [^13] [^31] generate discrete sequences by iteratively unmasking tokens, offering a flexible alternative to the fixed left-to-right factorization of autoregressive language models [^27]. Crucially, diffusion decoding is not tied to a single generation order: inference depends on an *unmasking schedule* that decides which positions are revealed at each step. This schedule is more than an implementation detail: it is an implicit “order of thought”, and it determines which commitments the model makes early, which constraints it propagates, and which ambiguities it strategically postpones. Because different schedules trace different conditional trajectories, they induce different output distributions, and the schedule choice can substantially affect generation quality [^18] [^49].
Heuristic schedules are fast, but they can think myopically. Most existing schedules are fixed greedy heuristics based on per-position uncertainty (e.g., confidence, margin, entropy) [^49] [^18] [^4]. While efficient, such rules optimize the *next* step rather than the *whole* decoding trajectory: they often pick “easy” tokens that become locally certain under the current partial context, even when a different reveal would better shape future conditionals. Empirically, we find that these myopic choices underperform on complex reasoning tasks (see Table 1 and Figure 2 in Section 6.1). Even worse, expert-designed logical orders can be suboptimal for an *imperfect* pretrained diffusion model: what is logically natural for humans is not necessarily the path along which the model’s conditional predictions are most reliable (see Section 6.1). These observations motivate a principled approach that *learns* the order, instead of hard-coding it.
Key idea and theory: learn the schedule by optimizing the model’s *trajectory likelihood*. We treat diffusion decoding as a latent-order generative process [^15] [^39] and ask a direct question: *which reveal order makes the model most faithful to the data distribution?* Concretely, we formalize scheduling as minimizing the KL divergence between the data distribution and the distribution induced by a given decoding procedure. Our main theoretical contribution is to show that this intractable objective admits a tractable bound expressed in terms of the denoiser’s *pathwise* (trajectory) log-likelihood under teacher forcing. This yields a dense, model-self-aware reward that assigns credit to *each* reveal decision, rather than only the final sample. Under this reward, a good schedule reveals the token maximizing the expected *future* log-likelihood of the remaining trajectory, i.e., it chooses the next “thought” to make downstream reasoning easiest for the model, aligning the decoding path with the model’s predictive strengths rather than with local uncertainty alone.

### 2.1 Masked Diffusion Models
Masked diffusion models generate discrete sequences by iteratively demasking tokens, analogous to the denoising process in continuous diffusion models [^33] [^10]. Let $\mathcal{X}$ denote a finite vocabulary and $n$ the sequence length. A sequence is $x=(x_{1},\ldots,x_{n})\in\mathcal{X}^{n}$. For a mask pattern $M\subseteq[n]:=\{1,\ldots,n\}$, define the masked sequence $x^{M}\in(\mathcal{X}\cup\{\texttt{[MASK]}\})^{n}$ by
$$
(x^{M})_{i}:=\begin{cases}\texttt{[MASK]}&\text{if }i\in M,\\

### 2.2 Unmasking Schedules: the Order of Thought
Generation proceeds by iteratively unmasking positions, a process known as *decoding*. The unmasking schedule can be interpreted as an “order of thought” for generation. The flexibility of the masked diffusion model is that it allows any-order decoding in principle, and thus the unmasking order, or schedule, matters. The goal of our paper is to introduce a methodology to learn the unmasking order. We define the schedule $v_{\phi}$, parameterized by $\phi$, as the “order policy”, which takes a partial sequence as input and outputs a distribution over which position(s) to unmask next.
We denote by $\tilde{x}^{(t)}$ the partial sequence at decoding step $t$, where some positions contain tokens from $\mathcal{X}$ (revealed) and others contain \[MASK\] (not yet revealed). Starting from the fully masked sequence, at each step the algorithm selects which position(s) to unmask and samples their values from the model. We distinguish between two decoding regimes: sequential decoding, which unmasks a single position per step, and parallel decoding, which unmasks multiple positions simultaneously. In this work, we focus on the sequential setting to isolate the effects of ordering, while the parallel regime is detailed in Appendix A.1.
Unmasking procedure. Let $S_{t}\subseteq[n]$ denote the set of revealed positions at step $t$, and $M_{t}=[n]\backslash S_{t}$ denote the set of masked positions. Starting from $\tilde{x}^{(0)}=x^{[n]}$ (fully masked) with $S_{0}=\emptyset$, at each step $t=1,\ldots,n$: (1) Select next position: $i_{t}\sim v_{\phi}(\cdot\mid\tilde{x}^{(t-1)})$ where $v_{\phi}(\cdot\mid\tilde{x}^{(t-1)})$ outputs a distribution over $[n]\setminus S_{t-1}$. (2) Sample token: $\tilde{x}^{(t)}_{i_{t}}\sim p_{\theta}^{i_{t}}(\cdot\mid\tilde{x}^{(t-1)})$. (3) Update: $S_{t}\leftarrow S_{t-1}\cup\{i_{t}\}$; set $\tilde{x}^{(t)}_{j}=\tilde{x}^{(t-1)}_{j}$ for all $j\neq i_{t}$. The complete run produces an *unmasking order* $\sigma=(i_{1},\ldots,i_{n})$ and final sequence $\tilde{x}^{(n)}\in\mathcal{X}^{n}$.

### 3 Unmasking Order Optimization: From Error Bounds to Reward Design
Figure 1: High-level overview of Section 3: We overcome the intractability of latent ordering by deriving a theoretical framework that allows us to optimize a tractable, self-aware reward.
This section formalizes how the unmasking order affects the induced decoding distribution. Our primary goal is to derive a principled objective for optimizing the unmasking policy in *sequential* decoding. We also characterize the additional discrepancy introduced by *parallel* decoding via an information-theoretic quantity (Section B.1).
Let $\pi(x)$ be the target distribution on $\mathcal{X}^{N}$ and let $P_{\theta,\phi}^{\mathrm{seq}}(x)$ be the output law induced by *sequential* decoding (Section 2.1). We aim to fit the induced decoder distribution to the data by maximizing its expected log-likelihood,

### 3.1 Self-aware Reward as Pathwise Likelihood
For a data sample $x$ and an unmasking order $\sigma=(i_{1},\ldots,i_{n})$, let $p_{\theta}(x\mid\sigma)$ denote the pathwise likelihood assigned by the diffusion model when the tokens of $x$ are revealed according to $\sigma$ under teacher forcing. We define the *self-aware reward* as
$$
R_{\theta}(x,\sigma)\;:=\;\log p_{\theta}(x\mid\sigma).

### 3.2 KL Interpretation for Sequential Decoding
We also relate the self-aware loss to the marginal mismatch $\operatorname{KL}(\pi\|P_{\theta,\phi}^{\mathrm{seq}})$. This gives a compact interpretation of the pathwise objective as a joint distribution matching objective over data and orders.
###### Theorem 3.2 (Joint KL identity and marginal bound).
Let $Q_{\phi}(x,\sigma)\coloneqq\pi(x)v_{\phi}(\sigma|x)$ and $P_{\theta,\phi}(x,\sigma)\coloneqq p_{\theta}(x|\sigma)v_{\phi}(\sigma|x)$ be the data-policy and model-policy joint distributions, respectively. The self-aware loss $\mathcal{L}_{\mathrm{SAS}}$ satisfies

### 4 Methodology and Policy Optimization
We focus on *sequential* (one-by-one) unmasking, in which the decoding procedure reveals exactly one position per step. Concretely, we freeze the diffusion model parameters $\theta$ (and its denoising head) and optimize only the order-policy parameters $\phi$ using reinforcement learning.

### 4.1 Learning with Self-aware Reward
Monte Carlo approximation of the objective. For a target sequence $x\sim\pi$ and order $\sigma$, we define the return as the pathwise log-likelihood of the target tokens under the frozen denoiser:
$$
R_{\theta}(x,\sigma)=\sum_{t=1}^{N}\log p_{\theta}^{i_{t}}(x_{i_{t}}\mid\tilde{x}^{(t-1)}(\sigma)).

### 4.2 Parameterization of the Order Policy
State-dependent categorical policy over remaining indices. At step $t$, the policy observes the current partial state $s_{t-1}:=\tilde{x}^{(t-1)}$ and chooses the next index $i_{t}$ from the masked set $M_{t-1}$. We parameterize the order policy as a categorical distribution over indices:
$$
\begin{split}&v_{\phi}(\sigma\mid x)\;=\;\prod_{t=1}^{N}v_{\phi}\!\big(i_{t}\mid s_{t-1}\big),\qquad\\

### 4.3 GRPO training
MDP formulation. Order learning can be cast as a finite-horizon Markov Decision Process (MDP):
- State $s_{t-1}$: the partially revealed sequence $\tilde{x}^{(t-1)}$
- Action $a_{t}\in M_{t-1}$: choose the next index $i_{t}$ to unmask.

### 5 Related Work
Heuristic schedules for diffusion LLMs. The unmasking schedule critically determines information accrual in masked diffusion models [^24] [^44] [^31]. Prior work predominantly uses training-free heuristics that prioritize tokens by confidence or local certainty [^4] [^40] [^11] [^18] [^20] [^45], with variants incorporating spatial-temporal structure [^14] [^37] or token dependencies [^3]. We instead learn a sequential policy via RL to optimize for global trajectory coherence.
Learning orders. Finding effective decoding orders has been explored in non-autoregressive generation [^43] [^51] [^8] [^41] [^34]. For diffusion LMs, recent work optimizes schedules using task-specific verifiable rewards: [^15] [^46] jointly train the policy and MDM, while [^11] [^16] learn policies for frozen models using sparse terminal rewards. We propose minimizing KL divergence—a general objective that yields dense rewards and applies even when verifiable rewards are unavailable. Since discrete diffusion equivalently represents any-order autoregressive models [^12] [^25], related approaches derive similar ELBO-based objectives for diffusion molecular generation [^39], though requiring two additional networks and more complex formulation. We also note related work on optimizing orders for efficient parallel decoding to accelerate generation [^5] [^32] [^26], complementary to the statistical efficiency we pursue. Our theoretical bounds extend to parallel decoding (Appendix B.1).
Diffusion LLMs post-training. Recent RL-based post-training focuses on refining the diffusion backbone itself. For instance, D1 [^47] introduces a GRPO variant tailored for discrete diffusion, while other works concentrate on improving policy gradient estimation [^35] [^38] [^21] [^52] [^36] to enhance reasoning capabilities. These approaches typically use fixed confidence-based schedules during optimization. In contrast, we propose a two-stage framework prioritizing generation order: first optimizing the unmasking policy with a frozen diffusion head, then fine-tuning the head along learned trajectories. This approach is computationally efficient without expensive RL updates on the full model.

### 6 Experiments
In this section, we empirically validate that our self-aware reward formulation is both effective and scalable. Our experiments span diverse reasoning benchmarks—including logic puzzles, mathematical reasoning, and code generation—and cover model scales ranging from 1B to 8B parameters.
Experimental Objectives. Our evaluation is guided by three primary research questions:(i) Performance: Can optimizing the unmasking order alone yield consistent improvements in reasoning tasks? (ii) Emergent Strategy: What decoding strategies emerge from the learned policy, and how do they correlate with the underlying task structure? (iii) Generalization: Does the learned order policy generalize across varying sequence lengths and decoding modalities (e.g., full diffusion vs. semi-autoregression)?
We investigate (i) across all benchmarks, restrict our structural analysis (ii) to the interpretable domain of Sudoku, and assess (iii) using mathematical and code generation tasks.

### 6.1 Sudoku: Controlled Study of Unmasking Order
Setup. We construct a large-scale Sudoku corpus from [^28]. From the provided training split, we subsample $1$ M puzzles for training. Each Sudoku board is represented as a length- $81$ discrete sequence where each token corresponds to one cell value and $0$ denotes the blank cell. We treat $0$ as the \[MASK\] token and model the completion of masked cells as conditional generation.
We instantiate with a 1B-scale masked diffusion model: SMDM-1B [^23]. We first fine-tune the diffusion model on the $1$ M training puzzles for one epoch; we then train a lightweight MLP policy on $1{,}000$ puzzles (sampled from the training dataset) and report results on the remaining test split.
Baselines. At inference time, we compare the learned policy against heuristic decoding orders: (i) Random [^48]; (ii) Confidence [^49]; (iii) Margin [^18]; (iv) Entropy [^49]; and (v) a human Expert order [^29] based on Sudoku solving logic.

### 6.2 Order Analysis of Sudoku and Kendall’s τ\\tau
To analyze how different schedules align with human expert ordering—while accounting for the fact that many Sudoku moves are interchangeable—we introduce an equivalence-class variant of Kendall’s $\tau$ [^17] which is agnostic to the relative ordering of moves that are strategy-equivalent. We provide details in Appendix D.1.
Table 2: Comparison with human expert order on Sudoku via equivalence-class Kendall’s $\tau$ (2000 puzzles).
| Order Strategy | Mean $\tau_{\mathrm{eq}}$ | Frac. $\tau_{\mathrm{eq}}>0$ | Frac. $\tau_{\mathrm{eq}}>0.5$ |

### 6.3 Generalization to Math and Code Reasoning
Setup. We then move to study whether an order policy learned with the self-aware objective transfers to larger-scale reasoning tasks beyond Sudoku. We use LLaDA-8B-Instruct [^24] as the frozen base masked diffusion model and parameterize the order policy as a lightweight one-layer Transformer. We train the policy under the full diffusion (any-order) sequential decoding paradigm from the training splits of GSM8K [^7] and MBPP [^2]. The policy is trained with teacher-forced trajectories at a maximum generation length of 512. Training details and inference costs are provided in Appendix D.2.
Evaluation protocol. We evaluate (i) generalization across generation lengths and (ii) transfer to semi-autoregressive (block) inference. For length generalization, we report results for target lengths in $\{128,256,512\}$. For semi-autoregressive decoding, we vary the number of decoding blocks $K\in\{1,4,8\}$ and apply the same learned policy to schedule these blocks at inference time. We denote each setting as promptlen/total–block, e.g., 256--64 indicates total length 256 with block size 64 (semi-autoregressive), while 256--256 corresponds to full diffusion decoding. We evaluate the results using lm-eval-harness.
Results. In Figure 4, it demonstrates the robust generalization of our approach on GSM8K and MBPP. While distinct heuristic baselines exhibit inconsistent performance across different settings, our learned order policy uniquely achieves superior or competitive performance across the entire spectrum of decoding regimes. Notably, we show while Left-to-Right scheduled decoding is competitive at shorter lengths ($L=128$), our order policy achieves superior performance even in full diffusion generation at longer lengths. This confirms that our scheduling strategy captures fundamental reasoning structures and is highly robust to shifts in generation horizon, effectively transferring well beyond its training configuration.


## Key insights
- Algorithm (SAS): We introduce Self-Aware Scheduling, a plug-and-play framework that learns an unmasking-order policy for a *frozen* diffusion LM via GRPO, applicable to both any-order and semi-autoregressive decoding.
- Empirical validation (reasoning gains + second stage): We demonstrate large, consistent improvements over heuristic and expert schedules on Sudoku, math and coding reasoning, and show additional gains from second-stage fine-tuning along learned trajectories under the same self-aware objective.
- State $s_{t-1}$: the partially revealed sequence $\tilde{x}^{(t-1)}$
- Action $a_{t}\in M_{t-1}$: choose the next index $i_{t}$ to unmask.
- Transition: deterministic teacher-forced reveal, $s_{t}=\mathcal{T}(s_{t-1},a_{t})$ obtained by setting position $i_{t}$ to $x_{i_{t}}$.
- Reward: $r_{t}=\log p_{\theta}^{i_{t}}(x_{i_{t}}\mid s_{t-1})$.
- Backbone-agnostic: the policy operates on model outputs and auxiliary statistics without modifying or backpropagating through the diffusion language model.
- Lightweight: the policy introduces minimal additional parameters and computational overhead relative to the frozen diffusion backbone.
- Position-selective: at each diffusion step, the policy selects exactly one token position to reveal, subject to validity constraints.
- Mask-aware: the policy must never select padding positions, prompt tokens, or already revealed tokens.

## Exemplos e evidências
See original source at `Clippings/Scheduling Thoughts Learning the Order of Thought in Diffusion Language Models.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/ai-agents/harness]]
- [[03-RESOURCES/concepts/software-engineering/code-generation]]
- [[03-RESOURCES/entities/NVIDIA]]
- [[03-RESOURCES/entities/Apple]]
- [[03-RESOURCES/entities/AWS]]
