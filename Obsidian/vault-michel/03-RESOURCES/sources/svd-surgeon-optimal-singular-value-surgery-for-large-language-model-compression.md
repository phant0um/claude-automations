---
title: "SVD-Surgeon: Optimal Singular-Value Surgery for Large Language Model Compression"
type: source
source: "Clippings/SVD-Surgeon Optimal Singular-Value Surgery for Large Language Model Compression.md"
created: 2026-06-23
ingested: 2026-06-23
score: B
tags: [articles, source-page]
---

## Tese central
Large language models (LLMs) achieve remarkable performance across a wide range of tasks, but their deployment is constrained by substantial memory and compute requirements. Low-rank compression via singular value decomposition (SVD) is an effective remedy, but existing methods focus on how to factorize and which components to keep. We introduce SVD-Surgeon, a training-free method that brings the Optimal Brain Surgeon (OBS) framework to the singular-value basis.

## Argumentos principais
### 1 Introduction
Large language models (LLMs) have demonstrated remarkable capabilities across a wide range of natural language understanding and generation tasks. However, their deployment remains challenging due to substantial computational and memory requirements, with state-of-the-art models comprising billions of parameters that demand significant GPU resources both at inference and fine-tuning time. Reducing these costs without sacrificing quality has become a central problem for the practical use of LLMs.
Model compression has emerged as a principled approach to address these demands, with pruning being among the most widely studied techniques. Structured pruning removes entire neurons, attention heads, or layers, yielding hardware-friendly sparse models but at the cost of coarse-grained approximations that often degrade performance significantly. Unstructured pruning operates at the individual weight level, achieving fine-grained sparsity but producing irregular patterns that are difficult to accelerate on modern hardware without specialized kernels. Semi-structured pruning (e.g. $2{:}4$ sparsity) offers a compromise but remains constrained by fixed patterns that limit flexibility.
Compression using low-rank decomposition such as SVD offers a qualitatively different approach: by decomposing each weight matrix as $\theta=U\Sigma V^{\top}$ and truncating to a target rank, one obtains a low-rank approximation that is naturally deployable via two successive matrix multiplications, without requiring specialized hardware support. Naive truncation of the smallest singular values is rarely optimal, and a growing body of work improves on it through importance reweighting and activation whitening that better align the decomposition with the model’s loss landscape (Section 2).

### 2 Related Work
#### Second-order weight pruning.
Using curvature to guide pruning dates back to Optimal Brain Damage [^8], which scores weights by a diagonal Hessian approximation, and Optimal Brain Surgeon (OBS) [^5], which uses the full inverse Hessian to derive both a saliency and a closed-form update of the surviving weights. Scaling this framework to modern networks motivated a line of layer-wise approximations: the Optimal BERT Surgeon [^7] extended it to transformers, while Optimal Brain Compression [^2], GPTQ [^4], and SparseGPT [^3] apply OBS-style closed-form solutions in weight space for post-training quantization and unstructured pruning of LLMs, using the input Gram matrix as the layer-wise Hessian. LLM Surgeon [^11] instead uses a Kronecker-factored approximate curvature (K-FAC) [^10] for structured and unstructured weight pruning. All of these operate on the network weights (or their quantized values). In contrast, SVD-Surgeon applies the OBS framework in the basis of *singular values*, i.e. the parameters are the $\ell$ singular values of a layer weight matrix and the relevant Hessian is a small $\ell\times\ell$ matrix obtained by projecting the gradients onto the singular value space.
#### SVD-based LLM compression.

### 3.1 Background: Optimal Brain Surgeon
Consider a pretrained model whose parameters $\theta$ have converged near a minimum of the loss $\mathcal{L}$. Since the gradient is then negligible, the leading change in the loss under a perturbation $\delta\theta$ is second order,
$$
\delta\mathcal{L}\approx\frac{1}{2}\delta\theta H\delta\theta

### 3.2 Compression in the SVD basis
Classical OBS operates on the components, whether individual or entire rows or columns, of the matrix $\theta$. We instead apply the same framework to singular values of $\theta$. Write a general decomposition of the weight matrix $\theta\in\mathbb{R}^{m\times n}$ as
$$
\theta=\sum_{i=1}^{\ell}\sigma_{i}u_{i}v_{i}^{\top}=U\Sigma V^{\top}

### 3.3 Reduction to singular-value space
We restrict attention to changes in the singular values alone, keeping the singular directions $U,V$ fixed. This means the weight variation takes the form $\delta\theta=U\,\delta\Sigma\,V^{\top}$ with $\delta\Sigma=\operatorname{diag}(\delta\sigma)$. Substituting this into the quadratic model (1) and expanding in indices,
$$
\displaystyle 2\,\delta\mathcal{L}=\sum_{i,j,k,l}\delta\theta_{ij}\,H_{ij,kl}\,\delta\theta_{kl}

### 3.4 Fisher approximation of the Hessian
We assume block-diagonality of the Hessian across layers, so that each layer’s projected Hessian $\bar{H}$ can be estimated independently. Near convergence the per-layer Hessian is well approximated by the empirical Fisher information, a sum of outer products of per-sample gradients $G^{n}=\partial\mathcal{L}_{n}/\partial\theta$,
$$
H_{ij,kl}\;\approx\;\frac{1}{N}\sum_{n=1}^{N}G^{n}_{ij}\,G^{n}_{kl},

### 3.5 Optimal singular-value update
In order to obtain the optimal update $\delta\sigma_{S}$ of the retained singular values after pruning, we partition $\bar{H}$ conformally with $(\sigma_{S},\sigma_{C})$ into blocks $\bar{H}_{SS}$, $\bar{H}_{CC}$ and $\bar{H}_{SC}=\bar{H}_{CS}^{\top}$, so that
$$
\delta\mathcal{L}\;=\;\tfrac{1}{2}\,\delta\sigma_{S}^{\top}\bar{H}_{SS}\,\delta\sigma_{S}\;+\;\tfrac{1}{2}\,\delta\sigma_{C}^{\top}\bar{H}_{CC}\,\delta\sigma_{C}\;+\;\delta\sigma_{S}^{\top}\bar{H}_{SC}\,\delta\sigma_{C}.

### 3.6 Saliency scores and pruning selection
Substituting the optimal update (15) back into (13) yields the loss increase induced by removing $\sigma_{C}$ and optimally compensating $\sigma_{S}$. Expanding and simplifying, we get:
$$
\displaystyle\delta\mathcal{L}

### 3.7 Application to SVD-LLM
SVD-Surgeon assumes only a factorization $\theta=U\Sigma V^{\top}$ and does not use orthonormality of $U,V$, so it can be applied on top of any method that compresses by truncating such a factorization. We instantiate it on SVD-LLM, a natural host: conceptually simple yet among the strongest SVD-based compressors, and, since its whitening makes one of the factors non-orthonormal, a non-trivial test of this generality.
SVD-LLM is built around truncation-aware data whitening. It takes the layer reconstruction error as the compression loss,
$$

### 4.1 Setup
#### Models and data.
We evaluate on the OPT family (1.3B, 2.7B, 6.7B) and LLaMA-2-7B, reporting perplexity ($\downarrow$) on WikiText-2 for all four models and on C4 for OPT-1.3B and OPT-2.7B. We sweep the compression ratio $\rho$ (the fraction of parameters removed) from $20\%$ to $80\%$, with emphasis on the high-compression regime, where truncation is most damaging. For an $m\times n$ weight, a rank- $r$ factorization stores $r(m+n)$ parameters, so $\rho=1-r(m+n)/mn$. A target ratio $\rho$ thus corresponds to rank $r=(1-\rho)\,mn/(m+n)$, rounded to the nearest integer per layer.
#### Calibration.

### 4.2 Results
#### Perplexity.
Table 1 reports WikiText-2 perplexity for SVD-Surgeon layered on SVD-LLM (whitening only), across compression ratios for OPT-1.3B, OPT-2.7B, OPT-6.7B, and LLaMA-2-7B. the corresponding perplexity curves are plotted in Appendix B. C4 results (OPT-1.3B, OPT-2.7B) are given in Table 2. We report both variants, update-only (U) and select-and-update (S). Across all four models, SVD-Surgeon improves on SVD-LLM, and the gains grow with the compression ratio. under mild compression there is little to compensate, while under aggressive compression SVD-Surgeon prevents the steep degradation that SVD-LLM suffers (e.g. WikiText-2 perplexity on OPT-6.7B, 944.57 $\to$ 46.36 at ratio $0.7$). Most of this improvement comes from the closed-form update. Re-selecting the pruned set via the saliency (S) adds a smaller, further gain in most settings.
SVD-LLM is deterministic given fixed calibration data. The Fisher estimate in SVD-Surgeon introduces small variance through CUDA non-determinism in the gradient computation; for OPT models we report the mean over 3 seeds (standard deviations are given in Appendix B), while for LLaMA-2-7B the results were identical across seeds and we report a single value.

### 5 Conclusion
We introduced SVD-Surgeon, a method that brings the Optimal Brain Surgeon framework to the singular-value basis. By treating singular values as first-class parameters and building a compact, Fisher-estimated Hessian in that coordinate system, SVD-Surgeon derives a closed-form update of the retained singular values that compensates for those removed by truncation, as well as a compensation-aware saliency that can replace magnitude-based selection. The entire procedure is training-free, requires no iterative optimization, and, because it assumes no orthonormality of the factors, composes directly on top of existing SVD compressors. Applied to SVD-LLM, SVD-Surgeon improves the perplexity-compression trade-off across models and compression ratios, with the largest gains in the aggressive regime where standard truncation is most damaging.
#### Limitations.
The current evaluation measures perplexity on two benchmarks (WikiText-2 and C4); validating on additional hosts, model families, and downstream tasks would strengthen the generality claim. By design, the method updates only the singular values while holding the directions $U,V$ fixed. This is a deliberate simplification. The $\ell$ -dimensional $\sigma$ -space is far smaller than the full parameter space, keeping both the derivation and the computation tractable, and the experiments show it can have a substantial effect, particularly under aggressive compression. Whether additionally varying $U$ and $V$ within the same second-order framework yields further gains that justify the added computational cost is an open question. Estimating the Fisher information requires a forward and backward pass over a calibration set for each layer, which can be expensive for large models, although in practice this is a one-time, offline computation that parallelises across both layers and samples. Finally, SVD-Surgeon introduces several hyperparameters (Appendix A). Default values proved robust across most configurations, but the interaction between these settings and factors such as model scale or Fisher accuracy is not yet fully understood. A principled selection scheme would make the method more plug-and-play.

### Acknowledgements
This research was funded by the Deutsche Forschungsgemeinschaft (DFG, German Research Foundation) under grant number 539134284, through EFRE (FEIH\_2698644) and the state of Baden-Württemberg.
Frank Hutter acknowledges the financial support of the Hector Foundation.

### Appendix A Hyperparameter Settings
Tables 3 and 4 list, respectively, the hyperparameters introduced in Section 4.1. The compensation scaling $\lambda$, the damping coefficients $d_{S}$ and $d$ (expressed as fractions of the mean diagonal of $\bar{H}_{SS}$ and $\bar{H}$, respectively), the block-truncation fraction $\alpha$, and the number of Fisher samples $N$. For each model the same settings are used across all compression ratios, and only across models do they differ. The three hyperparameters $\lambda,d_{S},d$ were chosen via light manual exploration starting from natural defaults (e.g. $\lambda=1$) rather than aggressive tuning. The final values were held fixed across all compression ratios, which preserves the single-shot character of the method. Notice that the compensation scaling $\lambda$ has been set to $1$ for all OPT models and to $0.1$ for Llama 2-7B.
The block-truncation fraction $\alpha$ controls a trade-off between accuracy and cost: larger values retain a greater portion of $\bar{H}$, improving the fidelity of the compensation update at the expense of higher computational overhead for Fisher collection and the inversion and matrix operations that follow. We fix $\alpha=0.3$ across all models and compression ratios, which we found to offer a good balance. The number of Fisher samples $N$ was chosen large enough for the projected Hessian $\bar{H}$ to be well converged but was not tuned as a hyperparameter. The hyperparameters of SVD-LLM itself, including the number of whitening calibration samples ($N_{\mathrm{cal}}=256$), are kept identical across both methods to ensure a fair comparison.
Table 3: Hyperparameter settings for SVD-Surgeon on WikiText-2. Settings are fixed across all compression ratios for a given model.

### Appendix B Extended WikiText-2 Results
Figure 3 plots WikiText-2 perplexity as a function of compression ratio for all four models. We restrict the range to $0.3$ – $0.7$ for visual clarity. The improvements are most apparent at aggressive compression, where the curves separate. Only the update-only variant (U) is shown. The variant (S) tracks it too closely to be distinguishable at this scale. Precise per-ratio values are given in Table 1. Table 5 additionally reports standard deviations over three seeds for the OPT family.
(a) OPT-1.3B
Table 5: WikiText-2 perplexity ($\downarrow$) vs. compression ratio (mean $\pm$ std over 3 seeds). Bold: best; underline: second best.


## Key insights
- Since the derivation makes no orthonormality assumption, SVD-Surgeon applies on top of a broad class of SVD-based methods. Layered on SVD-LLM, a leading SVD-based method, it reduces perplexity across models and compression ratios, with the largest gains under aggressive compression.
- Update-only (U). $C$ is inherited from the host’s criterion (e.g. the smallest $\sigma_{i}$), and we apply the compensation on top of it.
- Select-and-update (S). We rank triplets by the saliency (20), take the lowest-scoring as $C$, and then apply the compensation.

## Exemplos e evidências
See original source at `Clippings/SVD-Surgeon Optimal Singular-Value Surgery for Large Language Model Compression.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/ai-agents/benchmark]]
- [[03-RESOURCES/entities/NVIDIA]]
- [[03-RESOURCES/entities/CUDA]]
