---
title: "1 Introduction"
type: source
source: "Clippings/1 Introduction.md"
created: 2026-06-23
ingested: 2026-06-23
score: D
tags: [articles, source-page]
---

## Tese central
In this paper we investigate the efficacy of the score-based martingale posteriors (SMP) [^3] [^5] in the context of modern and large-scale machine learning problems and its potential for meaningful uncertainty quantification. SMPs work with a stochastic gradient ascent-type recursion on the parameter space of stochastic models and construct a martingale on the parameter space. Under simple mathematical assumptions, the recursion can be built so that the parameters form a martingale sequence whi

## Argumentos principais
### 2.1 Model
We consider random variables of the form $\left((X_{1},Y_{1}),(X_{2},Y_{2}),\dots\right)$, where, for $i\in\mathbb{N}$, $X_{i}\in\mathsf{X}\subseteq\mathbb{R}^{n}$ denotes a covariate and $Y_{i}\in\mathsf{Y}$ denotes a response. The objective is to infer a predictive model for the conditional distribution of $Y_{i}$ given $X_{i}$. We write this conditional model as
$$
f_{\phi}(y\mid x),

### 2.2 Method
#### 2.2.1 Underlying Recursion
We will be using the methodology that is described in [^3]. The ideas are now given in the notation that has been established in the previous section. For $\theta\in\Theta$, let $F_{\theta}$ be the distribution on $(\mathsf{X}\times\mathsf{Y},\mathscr{B}(\mathsf{X}\times\mathsf{Y}))$ associated with the density or probability mass function $f_{\theta}(z)$ with respect to the dominating measure $\mu(dz)$. We assume that $f_{\theta}(z)$ is differentiable in $\theta$ for $\mu$ -almost every $z\in\mathsf{X}\times\mathsf{Y}$. Let $\theta_{0}\in\Theta$ be given and define the recursion for $k\in\mathbb{N}$
$$

### 3 Numerical Results
We now assess the behaviour of SMP for neural-network classifiers in two regimes. The first is a low-dimensional synthetic binary classification problem, where NUTS (No-U-Turn Sampler, an adaptive implementation of HMC, [^10]) provides a feasible Bayesian reference. The second is MNIST, where full Bayesian sampling is computationally prohibitive and SMP is compared against a strong MAP baseline. The experiments are intended to evaluate both predictive performance and the quality of uncertainty quantification.

### 3.1 Experimental setting
All numerical experiments use the empirical-design version of the framework in Section 2. Since no marginal covariate parameter is used in these experiments, the full parameter vector coincides with the neural-network parameter vector. Thus, throughout Section 3, we write $\theta=\phi$ and use $f_{\theta}(y\mid x)$, $g(x,\theta)$, $p_{\theta}(x)$ and $\pi_{\theta,j}(x)$ for the corresponding conditional likelihood, logits, binary success probability and multiclass probabilities.
During the SMP predictive-resampling phase, covariates are sampled with replacement from $N=N_{\mathrm{train}}$ observed training inputs. Equivalently, with respect to counting measure on the observed training covariates, we use
$$

### 3.2 Toy example: 2D binary classification
#### 3.2.1 Data generation and network architecture
We generate $N_{\mathrm{train}}=500$ training points by drawing covariates $X_{i}$ uniformly from $[-1,1]^{2}$. The corresponding binary labels $Y_{i}$ are generated as
$$

### 3.3 MNIST example
#### 3.3.1 Data and network architecture
The MNIST dataset consists of $28\times 28$ grayscale images of handwritten digits $0$ - $9$, split into $N_{\mathrm{train}}=54{,}000$ training, $N_{\mathrm{val}}=6{,}000$ validation, and $N_{\mathrm{test}}=10{,}000$ test samples. Inputs are scaled to $[0,1]$ and treated as vectors in $\mathsf{X}=\mathbb{R}^{784}$. The output space is $\mathsf{Y}=\{0,\dots,9\}$, corresponding to digit labels.
We adopt a convolutional architecture similar to LeNet-5 [^11]. The network consists of two convolutional layers (each with $5\times 5$ kernels, ReLU activation, and $2\times 2$ max-pooling) which output a flattened vector of size $256$, followed by two fully connected layers of sizes $128$ and $84$ with ReLU activations, and a final linear layer to $10$ logits. The total number of parameters is $d_{\theta}=47{,}154$, with most of the parameters in later layers. The conditional likelihood is categorical:

### 4 Discussion
In this paper, we investigated the score-based martingale posterior (SMP) for deep neural networks, comparing its performance to Bayesian MCMC (NUTS) and point estimates (NUTS mean and MAP) on a toy binary classification problem and the MNIST dataset. The two experiments reveal distinct regimes where SMP can succeed or struggle, and highlight practical guidelines for its application to deep neural networks.

### 4.1 Preconditioner choice
In the small toy example (20 parameters), the block-diagonal preconditioner with an EMA estimate of the Fisher produced meaningful epistemic uncertainty and accuracy nearly matching NUTS. The dense preconditioner was unstable, while the diagonal variant collapsed to a point estimate. For MNIST ($47{,}154$ parameters), block and dense preconditioners are infeasible; diagonal variants (fixed, EMA, periodic) all led to severe over-dispersion and miscalibration, whereas unpreconditioned SMP reproduced the MAP point estimate accurately but offered no uncertainty quantification. This suggests that a crude diagonal Fisher approximation is insufficient for deep convolutional architectures; layer-wise block approximations (e.g., KFAC) may be necessary for stable uncertainty quantification.

### 4.2 Step-size tuning
The step-size $\tau$ critically controls the variance of the limiting martingale posterior. For the toy example, $\tau=0.3$ (diagonal/block) and $\tau=0.1$ (dense) balanced stability and exploration. For MNIST, unpreconditioned SMP tolerated $\tau=1$, where diagonal preconditioners required much smaller values ($0.05$ – $0.08$) to avoid blow-up. A grid search over $\tau$ is recommended for new architectures. While it is possible for the toy model, for MNIST a full grid is prohibitive (we used a coarse manual sweep guided by stability).

### 4.3 Activation functions
The toy example used GELU, which breaks scaling symmetries and improved Fisher conditioning. MNIST used ReLU (standard for convnets). The poor performance of diagonal preconditioners on MNIST may be partly due to ReLU’s scaling symmetries exacerbating ill-conditioning. A closer look at values on the diagonal of the estimated Fisher revealed that more than half of them were actual zeros. For preconditioned SMP, we would recommend smooth, non-scale-invariant activations (GELU, Swish) that do not easily saturate, but more future work is needed to give a definitive answer.

### 4.4 Computational cost and practical trade-offs
SMP samples are embarrassingly parallel. In the toy example, SMP-ema-block was $2.5\times$ faster than a single-chain NUTS run (163 vs 405 seconds, six vs one thread). Unpreconditioned MNIST SMP required 1.15 hours for 100 samples (six threads) – still potentially faster than a full Bayesian treatment. However, several challenges arise:
- GELU is more expensive than ReLU (Gaussian CDF evaluation), though acceptable for small nets.
- Memory constraints: a full Fisher matrix for MNIST would require $\approx 9$ GB; even diagonal preconditioners need careful memory management for gradient storage over the validation set.

### 4.5 Limitations
We conclude the discussion by acknowledging two limitations of our study.
First, our comparison focused on exact Bayesian inference (NUTS) where feasible, and on a strong point estimate (MAP) otherwise. We did not benchmark SMP against other popular approximate uncertainty methods for deep neural networks, such as Monte Carlo Dropout, deep ensembles, or Laplace approximations. These methods are computationally lighter than MCMC and are known to provide practical uncertainty estimates. A systematic comparison between SMP and such baselines would be valuable to position SMP within the broader landscape of scalable uncertainty quantification, but it is beyond the scope of this work.
Second, unlike the Bayesian posterior obtained via NUTS, the SMP does not incorporate an explicit prior distribution. The limiting distribution of the martingale recursion is determined solely by the likelihood and the step-size schedule, which can be viewed as an implicit prior induced by the algorithm. Consequently, our comparison between SMP and the Bayesian posterior is not perfectly aligned: differences in uncertainty estimates (e.g., overdispersion or collapse) could partly arise from the absence of prior regularization rather than from the SMP recursion itself. For applications where prior information is available, extending SMP to incorporate a prior is an interesting direction for future research.

### 5 Conclusion
SMP can be a fast, parallelisable alternative to MCMC for Bayesian uncertainty quantification in neural networks, but its success is highly sensitive to the preconditioner. For large convolutional networks, unpreconditioned SMP is safe but yields no epistemic uncertainty; obtaining meaningful uncertainty likely requires more sophisticated curvature approximations (e.g., KFAC) or a different architecture (e.g., using normalisation layers, smooth activations, or smaller layer sizes). Our results provide practical guidance for practitioners and highlight open challenges for future research.

### Appendix A Predictive metrics
- Accuracy (higher is better):
$$
\mathrm{Acc}=\frac{1}{N_{\mathrm{test}}}\sum_{i=1}^{N_{\mathrm{test}}}\mathbbm{1}\Bigl(\arg\max_{j\in\mathsf{Y}}\widehat{f}_{\theta}(j\mid x_{i})=y_{i}\Bigr).


## Key insights
- $\sup_{k\geq 0}\mathbb{E}[|\theta_{k}|]<+\infty$;
- $\mathbb{E}[(\theta_{0}^{(j)})^{2}]<+\infty$;
- $\mathbb{E}\left[\sup_{\theta\in\Theta}\left(\bigl[\nabla\log f_{\theta}(Z_{k})\bigr]^{(j)}\right)^{2}\right]<C$ for some $C<+\infty$.
- None: $P_{k}=I$ (unpreconditioned).
- Diagonal: $P_{k}=\operatorname{diag}(\widehat{\mathcal{I}}_{k})$, where $\widehat{\mathcal{I}}_{k}$ is some approximation of the Fisher information matrix at iteration $k$.
- Block-diagonal: $P_{k}=\operatorname{blockdiag}(\widehat{\mathcal{I}}_{k})$, with blocks corresponding to either weight or bias parameters of each layer.
- Dense: $P_{k}=\widehat{\mathcal{I}}_{k}$ (full matrix).
- Fixed: compute $\widehat{\mathcal{I}}_{k}=\widehat{\mathcal{I}}(\theta_{0})$ once using the full training set and keep it constant for all $k>1$.
- EMA (exponential moving average): update online as $\widehat{\mathcal{I}}_{k}=\beta\,\widehat{\mathcal{I}}_{k-1}+(1-\beta)\Delta_{k}$, where $\Delta_{k}=s_{k-1}s_{k-1}^{\top}$ is the Fisher contribution from $(X_{k-1},Y_{k-1})$, and $\beta=0.98$.
- Periodic: recompute $\widehat{\mathcal{I}}_{k}$ from scratch every $T$ iterations using the current parameter value $\theta_{k-1}$ and the full training set.

## Exemplos e evidências
See original source at `Clippings/1 Introduction.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/diffusion]]
- [[03-RESOURCES/concepts/ai-agents/benchmark]]
- [[03-RESOURCES/concepts/software-engineering/runtime]]
