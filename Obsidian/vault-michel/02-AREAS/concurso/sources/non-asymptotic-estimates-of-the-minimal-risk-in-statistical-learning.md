---
title: "Non-asymptotic estimates of the minimal risk in statistical learning"
type: source
source: "Clippings/Non-asymptotic estimates of the minimal risk in statistical learning.md"
created: 2026-06-23
ingested: 2026-06-23
score: D
tags: [concurso, source-page]
---

## Tese central
---
title: "Non-asymptotic estimates of the minimal risk in statistical learning"
source: "
author:
published:
created: 2026-06-23
description:
tags:
  - "clippings"
---
Liming Wu Liming Wu. Laboratoire de Mathématiques Blaise Pascal, CNRS-UMR 6620, Université Clermont-Auvergne (UCA), 63000 Clermont-Ferrand, France. [li-ming.wu@uca.fr]() and Sen Yang Sen Yang.

## Argumentos principais
### 1.1. Two error probabilities in Empirical Risk Principle (ERP) in statistical learning.
Learning machines (such as (deep) neural networks) are furnished with a special class of functions
$$
\mathcal{F}=\{f(z,\theta);\theta\in\Theta\}

### 1.2. Bousquet’s and Klein-Rio’s sharp versions of Talagrand’s concentration inequality
Talagrand ([^40] [^41] [^42]) investigated in depth the concentration phenomena on product measure spaces and renewed the theory of empirical processes. Ledoux [^31] (see also his lecture course [^32] for a pedagogic and systematic study) gave a much simpler proof of Talagrand’s concentration inequality by means of the log-Sobolev inequality, and the proof of Ledoux was refined considerably by Massart [^36] for finding explicit constants in Talagrand’s concentration inequality. The following versions with sharp constants of Talagrand’s concentration inequality are due to Bousquet [^11] and Klein-Rio [^26] (see also the books [^29] [^10]).
###### Theorem 1.1.
(Bousquet’s inequality) Given

### 1.3. Estimate of the bias in terms of the VC dimension
Let ${\rm vc}(\mathcal{H})$ be the VC (Vapnik-Chervonenkis) dimension $m={\rm vc}(\mathcal{H})$ of $\mathcal{H}=\{Q(z,\theta);\theta\in\Theta\}$ (see [^45] [^46] [^47] [^48]). The following concentration inequality in Vapnik [^46] is well known to specialists:
$$
\mathbb{E}\sup_{\theta\in\Theta}|R_{E,n}(\theta)-R(\theta)|\leqslant C\sqrt{\frac{m(\log\frac{n}{m}+1)}{n}}

### 1.4. Some recent progress
Recent developments in statistical learning theory indicate that a central issue is to obtain quantitative non-asymptotic bounds and to understand the localized phenomena associated with empirical minimization.
Besides the classical VC dimension, an important development in modern statistical learning theory is to complement distribution-free complexity measures by data-dependent quantities. Bartlett and Mendelson [^7] gave a systematic treatment of Rademacher and Gaussian complexities as data-dependent measures of function-class complexity, establishing risk bounds and structural results for model classes, while Bartlett, Bousquet and Mendelson [^5] showed that local Rademacher complexities, based on a subset of functions with small empirical error, may yield much sharper bounds. Those results explain why, for ERP, one should not only study the whole class $\mathcal{H}=\{Q(z,\theta);\theta\in\Theta\}$ globally, but also the localized part selected by empirical minimization.
Another line of work is devoted to a direct study of the empirical risk minimization (ERM) algorithm. Bartlett and Mendelson [^8] showed that a direct analysis of the ERM algorithm yields significantly better bounds than those obtained from global comparisons, and that these bounds are essentially sharp, while Mendelson [^37] established lower bounds showing that, without further assumptions, the uniform error rate of ERM cannot in general be faster than $1/\sqrt{n}$, where $n$ is the sample size. Bousquet–Elisseeff [^12] developed the stability approach to obtaining generalization bounds. Recently, Feldman and Vondrak [^20] [^21], Bousquet et al. [^13] obtained sharp bounds of uniformly stable algorithms, improved later by Klochkov and Zhivotovskiy [^27] when the theoretical risk $R$ is strictly convex in $\theta$. Escande [^17] studied concentration inequalities for the distance between the set of empirical minimizers and the set of theoretical minimizers, rather than only the excess risk. Related localization and oracle-inequality phenomena for empirical risk minimization were studied by Koltchinskii [^28], who derived excess-risk bounds in terms of localized empirical and Rademacher complexities. These works confirm that, beyond asymptotic limit theorems, one needs quantitative non-asymptotic estimates for the deviations of the minimal empirical risk, and, if possible, for the minimizers themselves.

### 1.5. Purposes of this work.
The lower-bound problem $p_{-}(n,\varepsilon)$ and the upper-bound problem $p_{+}(n,\varepsilon)$ are of different natures. While the former can often be reduced to a concentration estimate for a single (suitably chosen) observable, the latter requires a more delicate localized control of the empirical-risk fluctuations along suitable risk layers. The purpose of this paper is threefold:
1. to establish a dimension-free sharp Bernstein’s concentration inequality for $p_{-}(n,\varepsilon)$; and as an application we show that we can verify the non-efficiency of a learning machine with a sample size $n$ that is independent of $N$ and $d$ and need not be very large (to the best of our knowledge, this is not discussed in the current literature);
2. to remove the boundedness assumption, which is indispensable, for instance, when the noise is Gaussian;

### 1.6. Organization.
The paper is organized as follows. In Section 2, we develop non-asymptotic dimension-free estimates for $p_{-}(n,\varepsilon)$, which yield lower bounds for the theoretical minimal risk via Bernstein concentration inequalities for the empirical risk: the main new contribution here is a Bernstein’s concentration inequality with sharp constant without boundedness. Section 3 is devoted to upper bounds in terms of the $d_{\psi_{1}}$ -metric entropy and risk-level localization, yielding non-asymptotic estimates of $p_{+}(n,\varepsilon)$ under suitable entropy assumptions. In Sections 4 and 5, we present the proofs of several main theorems. Several technical lemmas are collected in the Appendix.
Notations.
- For $x,y\in\mathbb{R}^{d}$, $|x|$ is the Euclidean norm, $x\cdot y=\langle x,y\rangle$ is the Euclidean inner product.

### 2.1. Framework
We will work in the mathematical framework of the theory of empirical processes, but motivated by the problems of statistical learning. The following assumption will be imposed throughout the paper.
(H1)
1. $(Z_{1},\cdots,Z_{n})$ is a sample of i.i.d. random variables valued in some Polish space $S$ equipped with the Borel $\sigma$ -field $\mathcal{B}$, of distribution $\mu$ of some $S$ -valued random variable $Z$, defined on some complete probability space $(\Omega,\mathcal{F},\mathbb{P})$; and the empirical distribution of the sample is L\_n=1n ∑\_k=1^n δ\_Z\_k; ($L_{n}$ is a random element of the space $M_{1}(S)$ of probability measures on $(S,\mathcal{B})$.)

### 2.2. Some known results about Bernstein’s concentration inequality
We begin with the well-known Bernstein inequalities. Let
$$
H(\nu|\mu)=\begin{cases}\int_{S}h\log hd\mu;&\text{ if }\nu=h\mu\\

### 2.3. Bernstein’s concentration inequality under Gaussian or exponential integrability.
Our first result refines the estimate of Bernstein’s constant $c_{B}$ in Theorem 2.3.
###### Theorem 2.7.
1. If $f$ is Gaussian integrable: ∃δ¿0: Ee^δf(Z)^2=∫\_S e^δf^2(z)μ(dz)¡+∞ then for any $\varepsilon\in(0,\delta)$, (2.6) holds with

### 2.4. Dimension-free lower bound of the minimal risk: sharp Bernstein’s inequalities
We now apply the previous Bernstein’s concentration inequalities to dimension-free estimates of $p_{-}(n,\varepsilon)$, i.e. an estimate for the lower bound of the theoretical minimal risk $\inf_{\theta\in\Theta}R(\theta)$. We begin with the upper boundedness or the uniform Gaussian integrability case.
###### Theorem 2.9.
Assume (H1) and

### 2.5. We can quickly verify the non-efficiency of a learning machine
To verify if a learning machine does not work efficiently for approximating a given function $y=f(x)$, fix the risk function $Q(z,\theta)=|y-f(x,\theta)|^{2}$ or $Q(z,\theta)=|y-f(x,\theta)|$. Usually $Q(z,\theta)=|y-f(x,\theta)|$ satisfies the Gaussian integrability condition, $Q(z,\theta)=|y-f(x,\theta)|^{2}$ satisfies the exponential integrability condition. Assume one of them.
Given a small error probability level $\alpha\in(0,0.5)$ and a tolerance error $\varepsilon_{0}>0$, we take a sample of
$$

### 3\. Upper bound of the minimal risk in terms of dψ1d\_{\\psi\_{1}}-metric entropies
As recalled in the Introduction, if $\mathcal{H}=\{Q(z,\theta);\theta\in\Theta\}$ is bounded in $L^{\infty}(\mu)$, one should work with a sample size
$$
n\succeq\frac{1}{\varepsilon_{0}^{2}}{\rm vc}(\mathcal{H})

### 3.1. Packing number and metric entropy
For the reader’s convenience (also for stating our results), we recall the following notions.
###### Definition 3.1.
(covering number, packing number and metric entropy) Fix a semi-metric $d$ on $\Theta$ (i.e. ”semi” means that $d(\theta_{1},\theta_{2})=0$ may hold for two different points of $\Theta$), $\varepsilon>0$.

### 3.2. Lψ1L\_{\\psi\_{1}}-estimates of empirical risk in terms of metric entropy
We will directly study the concentration of the normalized empirical process
$$
W_{n}(\theta)=\frac{1}{\sqrt{n}}\sum_{k=1}^{n}(Q(Z_{k},\theta)-R(\theta))=\sqrt{n}(R_{E,n}(\theta)-R(\theta))

### 3.3. Estimates of empirical risk in terms of the box-dimension
Recall the Minkowski or box dimension of $(\Theta,d)$ ([^18]):
$$
\dim_{B}(\Theta,d)=\limsup_{\varepsilon\to 0+}\frac{\log(1+N(\Theta,d,\varepsilon))}{-\log\varepsilon}=\limsup_{\varepsilon\to 0+}\frac{\log(1+{\mathcal{P}}(\Theta,d,\varepsilon))}{-\log\varepsilon}.


## Key insights
- For $x,y\in\mathbb{R}^{d}$, $|x|$ is the Euclidean norm, $x\cdot y=\langle x,y\rangle$ is the Euclidean inner product.
- $I_{d}$ is the identity matrix of size $d\times d$.
- $\mu(f)=\int fd\mu$ for a function $f$ and a measure $\mu$ on the same measurable space.
- for two sequences of positive numbers $a_{n},b_{n}$,
- the constant $C$ may change from one line to another, only used in Corollaries or Remarks for explaining the main results.

## Exemplos e evidências
See original source at `Clippings/Non-asymptotic estimates of the minimal risk in statistical learning.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/diffusion]]
- [[03-RESOURCES/concepts/ai-agents/tool]]
- [[03-RESOURCES/concepts/software-engineering/proof]]
