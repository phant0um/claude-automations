---
title: "First analytical coverage bounds of a fully specified nested sampling algorithm"
type: source
source: "Clippings/First analytical coverage bounds of a fully specified nested sampling algorithm.md"
created: 2026-06-23
ingested: 2026-06-23
score: B
tags: [concurso, source-page]
---

## Tese central
Nested sampling is a Monte Carlo algorithm for posterior estimation and Bayesian model comparison. It maintains a population of $K$ live points sampled from the prior, and at each iteration discards the lowest-likelihood point and replaces it with a new sample drawn from the prior restricted to exceed the discarded likelihood. Achieving this likelihood-restricted prior sampling efficiently and reliably is the central computational challenge.

## Argumentos principais
### 1 Introduction
In the physical sciences, Skilling’s nested sampling \[Skilling2004, skilling2006nested\] is a popular Monte Carlo algorithm to achieve Bayesian model comparison and posterior distributions in practice. Sophisticated physical models can induce posteriors that are complicated and multi-modal. Nested sampling can successfully reconstruct these thanks to making only a few assumptions.
Nested sampling integrates a posterior over an arbitrary prior space $\Omega$ by a one-dimensional integral transform: $\int_{\Omega}{\cal L}(\theta)\,d\pi(\theta)=\int_{0}^{1}{\cal L}(X)\,dX,$ where ${\cal L}(X)$ is the inverse of $X(L_{\mathrm{min}})$, the survival function of the likelihood-restricted prior: $X(L_{\mathrm{min}})=\Pr\{{\cal L}(\theta)>L_{\mathrm{min}}\}=\int_{\{\theta:\,{\cal L}(\theta)>L_{\mathrm{min}}\}}d\pi(\theta).$
Suppose $\theta_{1},\ldots,\theta_{K}$ are i.i.d. samples from the prior $\pi$, with likelihoods ${\cal L}_{1},\ldots,{\cal L}_{K}$. Then $X({\cal L}_{1}),\ldots,X({\cal L}_{K})$ are uniformly distributed. Discarding the lowest-likelihood point, $L_{\mathrm{min}}=\min_{i}\{{\cal L}_{i}\}$, removes a fraction $1-X(L_{\mathrm{min}})$ of the prior mass, where $1-X(L_{\mathrm{min}})\sim\mathrm{Beta}(1,K)$ with mean $1/(K+1)$. Equivalently, the remaining prior mass is $X(L_{\mathrm{min}})\sim\mathrm{Beta}(K,1)$. Nested sampling iteratively applies this idea. At each iteration, the point discarded from the live points is replaced with a new sample from the prior restricted to ${\cal L}>L_{\mathrm{min}}$. The prior mass $X$ shrinks in each iteration by an estimated fraction $\frac{K-1}{K}$. Finally, upon reaching some convergence criterion \[see e.g., 2014arXiv1412.6368W, Salomone2018\], the discarded points $\theta_{i}$ are assigned the unnormalised weights $w_{i}={\cal L}_{i}\times V_{i}$, where $V_{i}=\frac{1}{K}\times\left(\frac{K-1}{K}\right)^{i-1}$ is the estimated prior mass discarded. The posterior is approximated by these posterior samples with normalised weights $w_{i}/\sum w_{i}$, and the marginal likelihood by $Z=\sum w_{i}$. The convergence of the posterior distribution and the marginal likelihood estimator to the truth has been established under various assumptions in \[Chopin2010, Schittenhelm2020, evans2007discussion, skilling2009nested\].

### 2.1 Assumptions
For the analysis presented in this work, we make several assumptions. We assume the prior probability density $\pi$ is defined over a continuous parameter space $\Omega_{\pi}\subseteq\mathbb{R}^{d}$. Furthermore, we assume the likelihood is free of plateaus: formally, the pushforward of $\pi$ under ${\cal L}$ is a continuous distribution, so that for every $L_{\mathrm{min}}$ in the range $(0,\max_{\theta}{\cal L}(\theta))$ we have $\Pr\{{\cal L}(\theta)=L_{\mathrm{min}}\}=0$ \[see Schittenhelm2020, Fowlie2021, for the general case\].
To simplify our analysis, we assume the space is parameterized such that the prior is a standard uniform distribution. This also follows many (but not all) current implementations of nested sampling. To achieve this, the cumulative distribution function gives the needed reparameterization to natural probability units. For factorized priors $\pi(\theta)=\prod_{i=1}^{d}\pi_{i}(\theta_{i})$, each marginal CDF provides the transformation independently:
$$

### 2.2 Rejection sampling
The goal of any LRPS algorithm is to simulate new live points. In the region-based class of LRPS algorithms \[see Buchner2021c, for a review\], new points are proposed from the prior within a region $\Omega_{P}\subseteq\Omega_{\pi}$:
$$
\theta^{*}\sim\mathrm{Uniform}(\Omega_{P}).

### 2.3 The MLFriends algorithm
The MLFriends algorithm constructs $\Omega_{P}$ from the current live points. Let ${\cal I}=\{1,\ldots,K\}$ index the live points $\{\theta^{1},\ldots,\theta^{K}\}$. After fixing a distance metric $d(\cdot,\cdot)$, the neighbourhood of live point $j$ at radius $r$ is:
$$
\Omega^{j}(r)=\{x\in\Omega_{\pi}:d(x,\theta^{j})<r\}.

### 2.4 Binomial point process
We model the $K$ live points as distributed uniformly, independently, and homogeneously (i.e., with equal density throughout) within $\Omega_{r\pi}$ with volume $V$. Under this model, the probability that none of the $K$ points falls within Euclidean distance $r$ of a fixed point $x\in\Omega_{r\pi}$ is exactly:
$$
\Pr(\text{no point within }r)=\left(1-\frac{V_{d}r^{d}}{V}\right)^{K},

### 3 Sampling correctly
In this section, we analyse the reliability of the MLFriends proposal region. We begin with a few clarifications.
###### Remark 1 (Interior-ball analysis).
For all radii $r$ relevant to the analysis (i.e. $r\leq r_{\mathrm{max}}$), we treat every ball of radius $r$ centred at a point in the likelihood-restricted prior region set $\Omega_{r\pi}$ as lying entirely within $\Omega_{r\pi}$. Boundary effects—where a ball of radius $r$ extends outside $\Omega_{r\pi}$ —reduce the effective number of live points within the ball, which tends to *increase* $r_{\mathrm{max}}$ and hence enlarge $\Omega_{P}$. The interior-ball analysis therefore gives a conservative bound on $P^{\mathrm{missed}}$ (an overestimate of the uncovered fraction) and an optimistic bound on the acceptance rate (an underestimate of the true rate); these directions are consistent throughout and stated without repetition hereafter.

### 4 Sampling efficiently
In this section, we comment on the sampling efficiency of MLFriends. Implementation details and the correctness of sampling from the restricted prior $\Omega_{P}$ are given in Appendix A. For region-based samplers, the acceptance rate is:
$$
A=\frac{|\Omega_{r\pi}|}{|\Omega_{P}|},

### Connection to snowballing nested sampling
Buchner2023 proposed *snowballing nested sampling*, in which nested sampling is run repeatedly with increasing numbers of live points $K$, while reusing previously computed likelihood evaluations. This avoids the typical problem of having to test and choose a sufficiently number of MCMC steps $M$ in some likelihood-restricted prior sampling algorithms (see \[Buchner2021c\] for a review). Increasing $K$ improves the quality of the likelihood-restricted prior sampling (LRPS) without requiring the user to know a sufficient number of MCMC steps $M$ in advance. While the convergence argument presented in that paper is informal and the stated equivalence between $K$ and $M$ is not derived rigorously, the underlying insight has merit and can be stated precisely in the present framework.
The key observation is that the quality of the LRPS at each iteration depends not on $M$ alone but on the product $K\times M$. At each nested sampling iteration with $K$ live points, the likelihood threshold advances by a fractional prior volume of approximately $1/K$ (the mean of a $\mathrm{Beta}(1,K)$ distribution). The MCMC chain of $M$ steps must produce a new point approximately distributed according to the new constrained prior $\eta(\,\cdot\,;L_{\min})$, starting from a seed that is distributed according to the previous constrained prior. As $K$ increases, the constrained region changes more slowly between consecutive iterations, so the seed is closer in distribution to the target, and a shorter chain suffices for a given mixing quality. For a fixed ergodic proposal kernel, the mixing requirement is approximately $M\times K\gg 1$, and the LRPS quality is approximately invariant under the rescaling $K\to cK$, $M\to M/c$ for fixed $c>0$, provided both remain large. This is consistent with the empirical observation of Buchner2023 that nested sampling convergence depends on $K\times M$ rather than on $K$ or $M$ individually.
Now let’s consider the application of snowballing nested sampling to region-based LRPS. Heuristic [^4] shows that the MLFriends proposal region covers the constrained prior with missed fraction bounded above by $(\frac{1}{3}Km)^{-3/2}$, where $m$ is the number of bootstrap rounds. As $K$ increases in snowballing nested sampling, this bound decreases as $K^{-3/2}$, so the region-based LRPS becomes more faithful automatically, without any change to $m$. Although the number of iterations also grows as $N_{K}\approx KH$, the net effect is that the cumulative bias bound of Corollary 3.1 decays as $N_{K}\cdot(\frac{1}{3}Km)^{-3/2}\propto K^{-1/2}\to 0$ as $K\to\infty$, with $m$ and $H$ fixed. Snowballing nested sampling with MLFriends therefore achieves vanishing bias in the evidence estimate as $K\to\infty$, under the heuristic approximations of Corollary 3.1. A rigorous convergence proof in the sense of Salomone2018 remains an open problem.

### 5 Discussion
Today, overwhelming dataset sizes can prohibit visual inspection of Bayesian inference results on a case-by-case basis. Robust algorithms with analytical reliability estimates are therefore valuable, even at some computational cost. This paper has presented an analytical characterisation of MLFriends and argued heuristically that its proposal region covers the likelihood-restricted prior with high probability, making it practically reliable for low-to-moderate dimensional inference.
MLFriends takes ideas from agglomerative clustering, graph theory, bootstrapping, bagging and cross-validation. Its principles can be combined with other region-based algorithms. For example, a robust enlargement factor for ellipsoidal or multi-ellipsoidal nested sampling could be determined with the bootstrapping method. Based on this idea, the efficiency of ellipsoidal nested sampling was numerically studied in Buchner2021c as a function of dimensionality and live points.
MLFriends has also been compared to obtaining the support of a kernel density estimate with a top-hat kernel. The basic algorithm was presented with $\ell^{1}$ and $\ell^{2}$ norms in Buchner2014stats. Subsequently, Buchner2019c adopted the Mahalanobis metric and proposed iterative metric learning by cluster co-centering. This leads to an acceptably efficient algorithm that is robust across a wide class of Bayesian inference problems with 1–10 parameters. For these settings, MLFriends is perhaps the simplest algorithm to implement from scratch. It has been adopted into the general-purpose nested sampling packages dynesty \[Speagle2020\] and UltraNest \[UltraNest\].

### Appendix A Implementation details for efficient sampling
The following sections present implementation details and efficiency improvements for handling complicated geometries. The metric learning described in Section A.2 determines the distance metric used in the analysis of Sections 3 and 4: after the affine transformation to Mahalanobis coordinates, the analysis applies with the Euclidean metric.

### A.1 Friends and clusters
The proposal region $\Omega_{P}$ need not be convex or connected: multiple ‘clusters’ or ‘modes’ are possible. To characterise this structure, define the set of live points directly connected to live point $i$ (its ‘friends’):
$$
F_{1}^{i}=\left\{j\in{\cal I}:d(\theta^{i},\theta^{j})<r_{\mathrm{max}}\right\}.

### A.2 Metric learning
MLFriends uses the Mahalanobis distance:
$$
d_{M}(a,b\mid S)=\sqrt{(a-b)^{\top}S^{-1}(a-b)},

### A.3 Sampling new live points in practice
Sampling uniformly from $\Omega_{P}$ can be achieved by either of two strategies; both produce exact uniform samples by the arguments given in the Appendix A.4.
#### Strategy 1: bounding box rejection sampling.
Sample $\theta^{*}$ uniformly from a bounding hyper-box $\Omega_{\mathrm{box}}$ and accept if $\theta^{*}\in\Omega_{P}$:

### A.4 Correctness of sampling from ΩP\\Omega\_{P}
The rejection sampling step requires drawing $\theta^{*}\sim\mathrm{Uniform}(\Omega_{P})$. We verify that both strategies above achieve this exactly.
#### Strategy 1.
Since $\Omega_{P}\subseteq\Omega_{\mathrm{box}}$, sampling uniformly from $\Omega_{\mathrm{box}}$ and accepting points in $\Omega_{P}$ is a standard rejection sampler. The accepted points are exactly uniform over $\Omega_{P}$.


## Key insights
- We present a self-contained mathematical formulation of MLFriends and derive, under a homogeneous Binomial point process model for the live points, heuristic bounds on the expected fraction of the likelihood-restricted prior not covered by the proposal region.
- We show heuristically that the resulting bias in the marginal likelihood estimate is negligible compared to the inherent statistical variance of a nested sampling run.
- ###### keywords:

Nested sampling, Monte Carlo algorithms

## 1 Introduction

In the physical sciences, Skilling’s nested sampling \[Skilling2004, skilling2006nested\] is a popular Monte Carlo algorithm to achieve Bayesian model comparison and posterior distributions in practice.
- In high-dimensional settings, ‘step sampling’ LRPS methods achieve acceptable sampling efficiencies with random walks (such as Markov Chain Monte Carlo; MCMC) started at a randomly selected live point \[see e.g.
- We first introduce notation and the MLFriends algorithm in Section 2.
- To achieve this, the cumulative distribution function gives the needed reparameterization to natural probability units.
- $$

### 2.4 Binomial point process

We model the $K$ live points as distributed uniformly, independently, and homogeneously (i.e., with equal density throughout) within $\Omega_{r\pi}$ with volume $V$.
- The plug-in step therefore strengthens rather than weakens the result: the true uncovered fraction is at most the quantity we compute.
- $$

This result is derived under Assumptions [^1] and [^2], and inherits the approximate independence of bootstrap rounds from Heuristic [^3].
- After an initial write-up, OpenAI ChatGPT and Anthropic Claude Sonnet 4.6 have been used to vet the arguments and improve the writing.

## Exemplos e evidências
See original source at `Clippings/First analytical coverage bounds of a fully specified nested sampling algorithm.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/skill]]
- [[03-RESOURCES/concepts/llm-ml-foundations/inference]]
- [[03-RESOURCES/concepts/software-engineering/proof]]
- [[03-RESOURCES/entities/Claude]]
- [[03-RESOURCES/entities/OpenAI]]
- [[03-RESOURCES/entities/AWS]]
