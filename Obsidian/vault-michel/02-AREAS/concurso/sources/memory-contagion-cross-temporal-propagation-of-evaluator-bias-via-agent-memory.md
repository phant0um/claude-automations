---
title: "Memory Contagion: Cross-Temporal Propagation of Evaluator Bias via Agent Memory"
type: source
source: "Clippings/Memory Contagion Cross-Temporal Propagation of Evaluator Bias via Agent Memory.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [concurso, source-page]
---

## Tese central
Large Language Model (LLM) agents increasingly rely on memory systems to maintain long-term coherence. Recent work [^20] shows that agent memories degrade during continuous consolidation. However, existing research assumes memories are derived from unbiased experiences.

## Argumentos principais
### 1 Introduction
Autonomous agents built on Large Language Models (LLMs) are increasingly deployed in high-stakes domains, from scientific discovery to personalized assistance. A key capability enabling their long-term autonomy is memory—the ability to store, consolidate, and retrieve past experiences [^20] [^17] [^7].
Recent work has identified that agent memory systems suffer from memory degradation: when LLMs continuously update memory through consolidation, useful memories become faulty [^20]. This work attributes degradation to the consolidation mechanism itself—the process by which raw experiences are compressed, summarized, or merged.
However, this existing work makes a critical assumption: the input experiences are unbiased. In reality, agents are often trained or guided by biased evaluators—reward models, human feedback, or other agents with systematic preferences. When an evaluator exhibits bias (e.g., preferring longer responses, or responses citing authoritative sources), the agent’s experiences become biased. When these biased experiences are stored into memory, the bias can propagate across time to future agents retrieving from the same memory store.

### 2 Related Work
Agent Memory Systems. Recent work has extensively studied agent memory architectures [^17] [^7] [^19] [^13]. [^20] identify that LLM-based memory consolidation produces faulty memories even from useful experiences, attributing this to the consolidation mechanism. Our work complements this by showing that even with perfect consolidation, bias propagates—biased input is a sufficient primary cause, while consolidation can modulate (amplify or attenuate) the resulting contagion.
Bias in LLM Evaluation and RAG. Evaluator bias has been studied in RLHF [^2] [^12], reward model misspecification [^5], and LLM-as-judge [^23] [^16]. LLM sycophancy—where models systematically agree with user views or preferences—is a related form of evaluator-driven bias [^14] [^15]. Recent work has also studied bias in retrieval-augmented generation (RAG), where retrieved content can introduce systematic biases into generated outputs [^6] [^21]. However, these works focus on within-episode bias. We study cross-temporal bias propagation via memory, where bias persists and propagates across episodes through stored experiences.
Memory Editing and Catastrophic Forgetting. Techniques for editing factual associations stored in model parameters [^9] [^10] and methods for mitigating catastrophic forgetting in neural networks [^4] [^3] are relevant to our work. While the former targets model-internal memory, our focus is on externalized memory stores. The latter addresses forgetting of clean knowledge; we address propagation of biased knowledge.

### 3.1 Problem Formulation
We consider a scenario with two agents: a source agent $A_{s}$ and a target agent $A_{t}$. $A_{s}$ interacts with tasks $\mathcal{T}$ and is evaluated by a biased evaluator $E_{b}$. $A_{s}$ ’s experiences (trajectories) are stored in a memory store $M$. $A_{t}$ retrieves from $M$ to solve new tasks.
Trajectory. A trajectory $\tau=(s,a,r,s^{\prime})$ consists of state $s$ (task), action $a$ (agent response), reward $r$ (evaluator score), and next state $s^{\prime}$.
Biased Evaluator. An evaluator $E$ assigns scores $E(\tau)\in[0,1]$. A biased evaluator $E_{b}$ has a bias function $b:\tau\rightarrow\mathbb{R}$ such that:

### 3.2 Memory Store and Consolidation
The memory store $M$ contains $N$ entries $e_{i}=(\tau_{i},\text{emb}_{i},\text{meta}_{i})$. When new trajectories arrive, $M$ undergoes consolidation: similar entries are merged via LLM-based summarization [^20].
We compare two consolidation strategies:
- Oracle consolidation: Perfect merge without information loss (upper bound)

### 3.3 Γtemporal\\Gamma\_{\\text{temporal}}: Measuring Cross-Temporal Contagion
We define $\Gamma_{\text{temporal}}$ as the behavioral distance between a target agent retrieving from a biased memory store vs. a clean memory store:
$$
\Gamma_{\text{temporal}}=D_{\text{behavior}}(A_{t}|_{M_{b}},A_{t}|_{M_{c}})

### 3.4 Mechanism Decomposition
Memory Contagion can occur through two mechanisms:
1. Content-based: Biased memories have different content, which influences retrieval and generation
2. Retrieval-based: The retrieval mechanism itself may be biased (e.g., biased queries retrieve biased memories)

### 4.1 Experimental Design
We design a 4-phase experimental pipeline:
Phase 1: Bias Injection. Source agent $A_{s}$ solves tasks from task set $\mathcal{T}$ (20 open-ended QA tasks). Trajectories are scored by biased evaluator $E_{b}$ (strength $\alpha=1.0$) and clean evaluator $E_{c}$. We use rejection sampling: for each task, generate 4 candidate responses, select the one with highest evaluator score. This injects bias into trajectories.
Phase 2: Memory Construction. Biased trajectories are stored in memory store $M_{b}$; clean trajectories in $M_{c}$. Consolidation is applied (oracle or LLM).

### 4.2 Results: Phase 2.5 (Oracle Consolidation Ablation)
Figure 1 shows the core result: Memory Contagion occurs even with perfect (oracle) consolidation.
Table 1: Phase 2.5 Results: $\Gamma_{\text{temporal}}$ for oracle vs. LLM consolidation. Length values are mean $\Gamma$ with 95% bootstrap CI from 3 independent seeds. Authority values are from an exploratory fact-centric V4 run only; multi-seed replication on standard synthetic tasks yields $\Gamma_{A}\approx 0$ (see Appendix A.6), indicating domain-dependent propagation. $\Gamma_{A}$ is significantly greater than 0 for length bias ($p<0.01$, permutation test).
| Bias Type | $\Gamma_{A}$ (Oracle) | $\Gamma_{B}$ (LLM) |

### 4.3 Results: Phase 3 (Mechanism Decomposition)
We decompose $\Gamma_{\text{total}}$ into three source components (E1–E3) via controlled manipulation of the memory store and retrieval mechanism, then separately evaluate debiasing effectiveness (E4). The experimental protocol proceeds as follows:
Step 1 — $\Gamma_{\text{total}}$ (E1 + E2 + E3). Target agent $A_{t}$ retrieves from biased memory $M_{\text{bias}}$ using standard embedding-based retrieval ($k=5$). The resulting trajectories are compared against $A_{t}$ on clean memory $M_{\text{clean}}$.
Step 2 — $\Gamma_{\text{content}}$ (E1). $A_{t}$ retrieves from $M_{\text{bias}}$ using random retrieval (shuffled indices, ignoring embedding similarity). Since retrieval is orthogonal to content, any remaining contagion is attributed to the content of stored memories influencing generation.

### 4.4 Results: Phase 4 (Dose-Response Analysis)
Figure 3 shows $\Gamma(p)$ as a function of contamination rate $p$.
Figure 3: Phase 4: Dose-response analysis. Memory Contagion is detected at contamination rates as low as p = 0.2 p=0.2 (20% of memories biased). No observed safe threshold exists. Authority bias shows a peak-and-decline pattern (peak at 0.8 p=0.8, Γ 23.03 \\Gamma=23.03 ).
Findings:

### 5 Discussion
Comparison with Prior Work on Memory Consolidation. A key distinction between our work and [^20] is the assumption about input quality. [^20] show that perfect experiences become faulty after LLM-based consolidation, attributing memory degradation to the consolidation mechanism. Our work shows a complementary phenomenon: biased experiences propagate bias even with perfect (oracle) consolidation. Together, these results imply that memory system designers must address both consolidation quality and input bias. Claims that "fixing consolidation fixes memory problems" [^20] are incomplete when agents operate in biased environments.
Why Does E4 (Debiased Memory) Fail? Our E4 sanity check (Table 2) shows that behavior with debiased memories is still distant from behavior with clean memories ($E4=0.70$ for length, $4.20$ for authority). We identify two reasons: (1) Incomplete debiasing: LLM-based rewriting (our debiasing method) preserves semantic content but may not fully remove bias signals. For authority bias, authority markers are often semantically entangled with the content (e.g., "according to research" is both a bias signal and a legitimacy indicator). (2) Residual bias in retrieval: even after debiasing content, the embedding of a debiased memory may still be closer to biased queries than to clean queries, causing biased retrieval patterns. We believe memory debiasing is an important open problem requiring dedicated future work.
Why Does Consolidation Have Opposite Effects on Different Bias Types?

### 6 Conclusion
We introduced Memory Contagion—the cross-temporal propagation of evaluator bias via agent memory systems. Through a 4-phase experimental study with two bias types, we demonstrated that:
1. Memory Contagion occurs even with perfect (oracle) consolidation, proving that biased input is a sufficient cause; consolidation can subsequently amplify or attenuate the resulting contagion depending on bias type (Section 4.2).
2. Consolidation has bias-type-dependent effects: it attenuates length bias (robustly validated, 3 seeds) while preliminary evidence suggests it may amplify authority bias (single-run estimate)—a directional pattern warranting multi-seed validation (Section 4.2).

### Reproducibility Statement
We provide:
- Complete LaTeX source of this paper
- Python code for all experiments

### A.1 Phase 1: Bias Injection Validation
We verify that bias injection succeeds by measuring $\beta$, the bias strength in generated trajectories:
$$
\beta=\frac{1}{N}\sum_{\tau\in\mathcal{D}_{b}}b(\tau)-\frac{1}{N}\sum_{\tau\in\mathcal{D}_{c}}b(\tau)

### A.2 Full Dose-Response Curves
Table 4 shows complete dose-response results.
Table 4: Complete dose-response results: $\Gamma(p)$ for $p\in\{0.2,0.4,0.6,0.8,1.0\}$.
| Bias Type | $p=0.2$ | $p=0.4$ | $p=0.6$ | $p=0.8$ | $p=1.0$ |


## Key insights
- Oracle consolidation: Perfect merge without information loss (upper bound)
- LLM consolidation: Merge via LLM summarization (realistic)
- Length bias: Bias signal is global (total word count). LLM-based summarization compresses long texts, reducing total length. Thus consolidation attenuates length bias.
- Complete LaTeX source of this paper
- Python code for all experiments
- Configuration files with all hyperparameters
- Generated trajectory data (JSON format) for both bias types

## Exemplos e evidências
See original source at `Clippings/Memory Contagion Cross-Temporal Propagation of Evaluator Bias via Agent Memory.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/Python]]
