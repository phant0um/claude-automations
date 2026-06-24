---
title: "Ordering Stochastic Block Models via prior transitivity"
type: source
source: "Clippings/Ordering Stochastic Block Models via prior transitivity.md"
created: 2026-06-23
ingested: 2026-06-23
score: D
tags: [articles, source-page]
---

## Tese central
In directed networks, nodes may form groups with similar interaction patterns, while these groups may themselves follow an ordered structure. Existing methods typically treat these features separately, either clustering nodes without enforcing a coherent block order, or ranking individual nodes without allowing for structurally equivalent groups. We introduce the *Transitive Stochastic Block Model* (TSBM), a Bayesian model for directed weighted networks that uses transitivity-inducing priors to 

## Argumentos principais
### 1 Introduction
Many directed networks, including dominance encounters among animals, cross-citations between journals, and friendship choices in schools, exhibit two forms of structure at once. First, nodes may form groups whose members behave similarly, giving rise to a community or clustering structure. Second, these groups may interact in a way that is consistent with an ordering, with most edges pointing from higher-ranked nodes to lower-ranked ones. This phenomenon is well documented in sociology [^15], anthropology [^27], ecology [^63], and related disciplines.
In animal societies, repeated agonistic encounters often give rise to dominance hierarchies, also known as pecking orders <sup>1</sup>. Higher-ranked individuals are more likely to defeat, displace, or receive deference from lower-ranked ones. In this setting, groupings and rankings are not separate phenomena, but two facets of the same social structure; existing literature, however, often treats grouping and ordering as distinct tasks.
Clustering models for network data, most notably the Stochastic Block Model [^42], recover groups of nodes with similar interaction patterns, but do not ensure that these groups can be arranged in a coherent hierarchy. Conversely, ranking models [^5] [^58] and ranking algorithms [^16] [^44] [^10] order entities hierarchically, but do not identify groups of entities that play similar structural roles. They therefore risk enforcing a strict node-level ordering, even when not all nodes can be distinguished and the ordering sits at the group-level instead.

### 1.1 Related work
Our model lies at the intersection of two strands of literature that have, until recently, developed largely independently: clustering methods for network data, and preference learning models for pairwise interactions and ranking data. We review the contributions most relevant to the present work, and clarify where the proposed model departs from them.
##### Stochastic block models, with and without block order.
Our clustering backbone is the directed degree-corrected stochastic block model (DC–SBM) of [^29]. Recall that for $G=(V,E)$ a weighted directed network on $n$ nodes, the adjacency matrix $A=(A_{ij})\in\mathbb{N}^{n\times n}$ yields via $A_{ij}$ the number of directed interactions from node $i$ to node $j$. Now assign nodes to $K$ latent blocks through labels $\mathbf{z}=(z_{1},\ldots,z_{n})$, with $z_{i}\in[K]=\{1,\ldots,K\}$. Conditional on these labels, the directed degree-corrected SBM specifies

### 2 The Transitive Stochastic Block Model
In this section, we introduce a novel Bayesian model for generating and analysing networks that exhibit both grouping and ordering structures. The TSBM produces groups that can be arranged such that nodes in higher-ranked blocks tend, on average, to send edges to nodes in lower-ranked blocks more often than they receive edges from them. The order of the blocks is therefore inferred from systematic asymmetries in the direction of edges. We define this model through the following three key steps:
The full generative process is summarised in Algorithm 1.

### 2.1 Decomposing the DC–SBM likelihood
We begin by noting that the ordering of the blocks should not be imposed on the total volume of edges between two blocks. In the animal dominance setting of Example 1, an animal at the top of the hierarchy need not fight every low-ranking animal often; some individuals may rarely meet, or may avoid one another altogether. What makes the relationship hierarchical is that, conditional on an encounter being observed, the higher-ranked animal is more likely to win, displace, or receive deference. Therefore, what matters for the order is the *net directional imbalance*: conditional on interaction occurring between blocks $k$ and $\ell$, do edges tend to point from the higher-ranked block to the lower-ranked one?
To disentangle the direction of the interaction from its occurrence, we express the directed Poisson DC–SBM in (1) using the standard Poisson–multinomial conditioning identity: independent Poisson counts, conditional on their sum, are multinomial, and hence binomial in the two-direction case. Hence, we parametrise the directed DC–SBM intensity matrix $\lambda=(\lambda_{k\ell})$ in terms of
$$

### 2.2 Transitive-inducing priors on the directional log-odds
We now formalise what it means for the directional probabilities $\rho_{k\ell}$ introduced in Section 2.1 to induce an order among the blocks. Recall that $\rho_{k\ell}$ is the probability that, given an interaction between blocks $k$ and $\ell$, it flows from $k$ to $\ell$, with $\rho_{k\ell}+\rho_{\ell k}=1$. When $\rho_{k\ell}>1/2$, we say informally that block $k$ probabilistically “beats” block $\ell$, and define the *stochastic preference relation* [^53] [^18] [^43] as
$$
k\succ_{\rho}\ell\quad\Longleftrightarrow\quad\rho_{k\ell}>\tfrac{1}{2}.

### 2.3 A prior on ordered partitions
The number of blocks $K$ in the TSBM (3) is a key quantity that determines the dimension of block parameters $\kappa$ and $\rho$. We want to be agnostic and estimate $K$ together with the allocation of nodes into ordered blocks, as driven by the latent allocation vector $\mathbf{z}=(z_{1},\ldots,z_{n})$. Here $z_{i}=k$, with $k\in[K]$, assigns node $i$ to block $k$, and records its position in the hierarchy $1\succ 2\succ\cdots\succ K$. It is important to distinguish the number of blocks, $K$, from the number of *occupied blocks*, henceforth denoted by $K_{n}$, that is the number of blocks of the partition of $[n]$ induced by $\mathbf{z}$. This distinction is important when $K$ is set to a sufficiently large value, deemed larger than the true number of blocks: this is called the *overfitted* case when one estimates the number of blocks through $K_{n}$.
An alternative way of handling an unknown number of blocks is to compare the fit of models with different values of $K$, for instance using marginal likelihoods or information criteria such as BIC or ICL [^6] [^4]. A third alternative consists in putting a prior on the number of components in a finite mixture model [^41], and use trans-dimensional algorithms such as reversible-jump MCMC [^24], that update the number of components and the allocation jointly. Recently, more efficient sampling schemes of conditional Gibbs type have been introduced in [^19] [^12].
A different route, common in Bayesian nonparametrics, is to put a prior directly on the partition $\Pi_{n}$ of $[n]$ and use $\mathbf{z}$ only as a convenient encoder, the labelling being immaterial. In the usual setting the random partition is exchangeable in that its distribution is invariant under permutations of node indexes. Equivalently, for $\{A_{1},\ldots,A_{K}\}$ a partition of $[n]$, then

### 2.4 Generative process and posterior
The full TSBM generative process is collected in Algorithm 1. This summary comes after the three ingredients have been introduced, so that the ordered allocation, the volume–direction factorisation, and the two priors on directional parameters are all defined before they are used. We use the shape–rate parametrisation, with Gamma prior $\eta_{i}\overset{\mathrm{iid}}{\sim}\mathrm{Gamma}(a_{\eta},b_{\eta})$ and $\kappa_{k\ell}\overset{\mathrm{ind}}{\sim}\mathrm{Gamma}(a_{\kappa},b_{\kappa})$ for $k\leq\ell$.
Input: $n$, $\varphi$, and model WST/SST
1exDraw $\mathbf{z}\sim p(\mathbf{z}),\eta_{i}\sim\mathrm{Gamma}(a_{\eta},b_{\eta})$ and set $K_{n}=\#\mathrm{unique}(\mathbf{z}).$

### 3 Inference
We fit the posterior in (14) with a partially collapsed Gibbs sampler. The sampler returns draws of the ordered allocation $\mathbf{z}$, the volume parameters $(\bm{\eta},\kappa)$, and the directional hierarchy parameter $\psi$. The number of occupied blocks $K_{n}$ is then recovered from $\mathbf{z}$. The Gaussian prior on $\psi$ is non-conjugate to the directional component of the likelihood, preventing a direct Gibbs update. Following [^48], we therefore use Pólya–Gamma augmentation, as detailed in the next section.

### 3.1 Pólya–Gamma data augmentation
For an unordered dyad $(i,j)$, the directional likelihood $p(A_{ij}\mid N_{ij},\psi,\mathbf{z})$ in (14) features the ratio $\exp\{A_{ij}\phi_{ij}\}/(1+\exp\{\phi_{ij}\})^{N_{ij}}$ where $\phi_{ij}$ is the directional log-odds with different formulation in terms of the directional parameter $\psi$ depending on the transitivity models in use, see (13). This term is not conjugate to the Gaussian priors on $\psi$, therefore we introduce one Pólya–Gamma distributed auxiliary variable per unordered dyad,
$$
\omega_{ij}\mid N_{ij},\phi_{ij}\sim\mathrm{PG}(N_{ij},\phi_{ij}),

### 3.2 One Gibbs sweep
A sweep of the sampler updates the volume parameters $\kappa$, the directional parameters $\psi$, the Pólya–Gamma variables $\omega_{ij}$, the degree corrections $\eta_{i}$, and the allocation variables $z_{i}$. Algorithm 2 presents the overview of the Gibbs sampler, while below we inspect each single update.
Input: Initial state $(\mathbf{z}^{(0)},\bm{\eta}^{(0)},\kappa^{(0)},\psi^{(0)})$; number of iterations $T$.
Output: Posterior draws $\{(\mathbf{z}^{(t)},\bm{\eta}^{(t)},\kappa^{(t)},\psi^{(t)})\}_{t=1}^{T}$.

### 4 Model choice, point estimates and uncertainty quantification
The sampler produces posterior draws $\{(\psi^{(t)},\bm{\eta}^{(t)},\mathbf{z}^{(t)},\kappa^{(t)})\}_{t=1}^{T}$. After discarding the first $B$ samples as burn-in, we summarise the posterior distribution and perform model-choice comparisons. We compare our TSBM with the DC–SBM introduced in (1). Its full specification is relegated to Appendix B.

### 4.1 Model choice via leave-one-out cross-validation
We use leave-one-out predictive accuracy for model choice. For each unordered dyad $(i,j)\in\mathcal{I}$, let $y_{ij}=(A_{ij},N_{ij})$ and $y_{-(ij)}=(A_{i^{\prime}j^{\prime}},N_{i^{\prime}j^{\prime}})_{(i^{\prime}j^{\prime})\neq(ij)}.$ For model $\mathcal{M}$, the leave-one-out expected log predictive density is
$$
\mathrm{ELPD}_{\mathcal{M}}=\sum_{(i,j)\in\mathcal{I}}\log\int p_{\mathcal{M}}(y_{ij}\mid\theta_{\mathcal{M}})\,p_{\mathcal{M}}(\theta_{\mathcal{M}}\mid y_{-(ij)})\,d\theta_{\mathcal{M}},

### 4.2 Posterior summary of the partition and number of blocks
Let $\{\mathbf{z}_{\mathcal{M}}^{(t)}\}_{t=1}^{T}$ be the posterior draws under model $\mathcal{M}$. Let also $\hat{\mathbf{z}}_{\mathcal{M}}$ be the VI point estimate, that is the partition minimising posterior expected Variation of Information loss [^62] [^38] [^52]. For WST and SST, the VI optimisation is restricted to the sampled ordered partitions. The selected estimate is therefore one of the posterior draws and inherits the block ordering encoded by the model labels.<sup>4</sup> Instead, for the DC–SBM, the VI point estimate is obtained using the standard unconstrained VI optimization. We therefore relabel the estimated partition ex post, with labels in the order of the mean empirical out-degree relative to their in-degree, so that smaller labels correspond to higher-ranked blocks and the resulting partition is comparable to the TSBM estimates. In simulation studies, where the true partition is known, the VI distance is used to measure the agreement between the point estimate and the true partition, with lower VI values indicating better recovery.
Finally, we summarise the posterior distribution of the number of occupied blocks,
$$

### 4.3 Order posterior summaries
The VI point estimate $\hat{\mathbf{z}}$ also lets us measure how well the observed edge directions agree with its order. In the TSBM, since smaller labels correspond to stronger blocks, edges with $k<\ell$ run forward, while edges with $k>\ell$ run backwards. The *violation* rate is
$$
\zeta^{\mathrm{viol}}_{\hat{\bm{z}}}=1-\frac{\sum_{k<\ell}C_{k\ell}(\hat{\mathbf{z}})}{\sum_{k\neq\ell}C_{k\ell}(\hat{\mathbf{z}})},\qquad C_{k\ell}(\hat{\mathbf{z}})=\sum_{i:\hat{z}_{i}=k}\sum_{j:\hat{z}_{j}=\ell}A_{ij}

### 5 Simulation study
The simulation study has three aims. First, it assesses whether and under which conditions the sampler presented above in Alg. 2 recovers the relevant model quantities when data are generated from the TSBM. Second, it compares the TSBM models with the directed degree-corrected SBM (DC–SBM), which is the natural unconstrained baseline: it is equivalent from a likelihood standpoint, but does not impose an ordering on the directional probabilities via the prior. Third, it performs some various checks that are reported in Appendix C. Finally, the code to reproduce the simulation study, the analyses, and the application section that follows is available at [GitHub Reproducibility Support]().


## Key insights
- We introduce the *Transitive Stochastic Block Model* (TSBM), a Bayesian model for directed weighted networks that uses transitivity-inducing priors to infer ordered blocks.
- The model separates the total volume of interaction between two nodes from the direction of interaction conditional on interaction occurring, so that hierarchy is imposed on directional imbalance rather than interaction frequency.
- Since ordered block labels are not exchangeable, we introduce an *age-ordered* partition prior to infer the number of blocks jointly with node allocation.
- Simulation studies show that order-constrained priors improve prediction and partition recovery, especially in sparse networks.
- Keywords: Stochastic block model; Bayesian inference; Bayesian nonparametric partition prior; Pólya–Gamma data augmentation; directed networks; ranking data; stochastic transitivity; Gibbs sampling.
- Clustering models for network data, most notably the Stochastic Block Model [^42], recover groups of nodes with similar interaction patterns, but do not ensure that these groups can be arranged in a coherent hierarchy.
- To address this question, we introduce the *Transitive Stochastic Block Model* (TSBM), a Bayesian model for directed weighted networks in which groups are not only *stochastically equivalent*, as in standard SBMs, but also *stochastically ordered* through *transitivity relations*.
- The model is built around the following methodological contributions.
- Fifth, we show that in simulated networks, ordered prior information improves both prediction and partition recovery relative to the standard degree-corrected SBM (DC–SBM), especially when a directional signal is present but statistically weak and the network is sparse.
- Across the empirical applications, the two TSBM specifications improve predictive performance over the DC–SBM in four of the six datasets considered.

## Exemplos e evidências
See original source at `Clippings/Ordering Stochastic Block Models via prior transitivity.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/benchmark]]
- [[03-RESOURCES/concepts/llm-ml-foundations/inference]]
- [[03-RESOURCES/concepts/software-engineering/specification]]
- [[03-RESOURCES/entities/AWS]]
- [[03-RESOURCES/entities/Python]]
