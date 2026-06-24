---
title: "Spectral Gap for the Binary Fixed-Margin Swap Chain"
type: source
source: "Clippings/Spectral Gap for the Binary Fixed-Margin Swap Chain.md"
created: 2026-06-23
ingested: 2026-06-23
score: C
tags: [articles, source-page]
---

## Tese central
We prove an inverse-polynomial spectral-gap bound for the lazy swap chain on binary matrices with prescribed row and column sums. This chain is a standard sampler for fixed-margin null models in ecology, statistics, and network analysis, and its rapid mixing for arbitrary feasible margins was conjectured by [^16]. We show that for every feasible set of margins on an $m\times n$ binary matrix, the lazy swap chain has spectral gap at least

$$
\binom{m}{2}^{-1}\binom{n}{2}^{-1},
$$

which is tight

## Argumentos principais
### 1 Introduction
Binary matrices are a natural way to encode binary relations between two sets of objects. For example, in ecology, one may record which bird species are observed on which islands by an $m\times n$ binary matrix $A$, where $A_{ij}=1$ if species $i$ is present on island $j$, and $A_{ij}=0$ otherwise.
A basic task is to generate uniformly random binary matrices with prescribed row and column sums. This problem arises naturally in ecological null models. Given an observed species–island matrix, ecologists ask whether its pattern reflects real ecological structure, such as competition between species, or can be explained by random chance after controlling for species prevalence and island richness. This leads to the fixed-margin null model, in which one samples uniformly from all binary matrices with the same row and column sums as the observed matrix. The same sampling problem also appears in testing the Rasch model for binary response data, where conditioning on the row and column sums makes all feasible matrices equally likely [^21] [^3]. Related fixed-margin sampling problems arise in network reconstruction, economics, and the social sciences; see [^19] for a survey.
The swap algorithm is the most basic Markov chain for this sampling problem. Starting from a binary matrix with the prescribed row and column sums, the algorithm repeatedly chooses two rows and two columns uniformly at random. If the resulting $2\times 2$ submatrix is of the form

### 2 Main result
Let
$$
\Omega(r,c)=\left\{X\in\{0,1\}^{m\times n}:\ \sum_{j=1}^{n}X_{ij}=r_{i}\ \forall i,\quad\sum_{i=1}^{m}X_{ij}=c_{j}\ \forall j\right\}.

### 3.1 The two-row heat-bath chain
We compare $\gamma_{\rm sw}$ to the spectral gap of the following two-row heat-bath chain targeting the uniform distribution on $\Omega(r,c)$. Given the current binary matrix $X\in\Omega(r,c)$, choose an unordered pair $\{a,b\}\subset[m]$ uniformly, where $a\neq b$; freeze all rows except rows $a,b$; then resample rows $a,b$ uniformly among all completions satisfying $\sum_{j=1}^{n}X_{aj}=r_{a}$, $\sum_{j=1}^{n}X_{bj}=r_{b}$, and $X_{aj}+X_{bj}=c_{j}-\sum_{i\not\in\{a,b\}}X_{ij}$ for $j\in\{1,\dots,n\}$.
Let $P_{H}$ be its transition matrix and let
$$

### 3.2 Spectral gap comparison
For a matrix $X\in\Omega(r,c)$ and $\{a,b\}\subset[m]$, let $X_{-\{a,b\}}$ be $X$ excluding rows $a,b$. The transition matrix $P_{H}$ may be written as
$$
P_{H}(X,X^{\prime})={m\choose 2}^{-1}\sum_{\begin{subarray}{c}\{a,b\}\subset[m]\\

### 4 Reduction to Three Rows
The following reduction is a special case of the projection argument of [^5]. We give a self-contained proof for the row-pair heat-bath chain on binary matrices with fixed row and column sums.
Recall $\Omega=\Omega(r,c)$ is the set of $m\times n$ binary matrices with prescribed row sums $r$ and column sums $c$, and let $\pi$ be the uniform measure on $\Omega$. For a pair of row indices $\theta=\{a,b\}\subset[m]$ where $a\neq b$, let $E_{\theta}$ denote conditional expectation given all rows outside $\theta$. In other words,
$$

### 5.1 Overview
In this section, we study the three-row heat-bath chain. Since the analysis is quite involved, it helps to introduce a new set of notations.
Consider a conditional three-row state space obtained after fixing all rows outside a chosen triple. Columns whose residual column sum is $0$ or $3$ are forced and may be deleted. Let $P$ be the set of remaining columns with residual column sum $1$, and let $Q$ be the set of remaining columns with residual column sum $2$. Put $p=|P|$ and $q=|Q|$.
A state is encoded by two ordered partitions

### 5.2 The scalar count sector
First consider test functions depending only on the row-count vector. We use the vector
$$
(|B_{1}|,|B_{2}|,|B_{3}|),

### 5.3 Johnson harmonics and non-scalar sectors
#### 5.3.1 Johnson harmonic preliminaries
Let $E$ be a finite set with $|E|=N$. For $\ell\geq 0$, let $H_{E}^{\ell}$ be the space of functions $h$ on $\ell$ -subsets of $E$ whose lower shadows vanish:
$$

### 5.4 Proof of the three-row inequality
###### Proof of Theorem.
The operator $S=P_{1}+P_{2}+P_{3}$ is self-adjoint. Since
$$

### 6 Completion of the Proof of the Main Theorem
###### Proof of Theorem.
First assume $m\geq 3$. Fix any triple of rows and condition on all rows outside this triple. The remaining configurations form a feasible $3\times n$ fixed-margin state space. Applying Theorem 5.1 with $m=3$, the corresponding row-pair heat-bath chain has spectral gap at least $1/3$. Proposition 2.1 implies that the two-row heat-bath chain is irreducible, because every single swap is contained in the support of the corresponding two-row heat-bath update. Lemma 4.1, applied with $M=m$, gives
$$


## Key insights
- We show that for every feasible set of margins on an $m\times n$ binary matrix, the lazy swap chain has spectral gap at least

$$
\binom{m}{2}^{-1}\binom{n}{2}^{-1},
$$

which is tight in the worst case.
- The author’s role was to pose the problem, guide the search direction, evaluate the AI-generated arguments, rewrite the proof, and take responsibility for the final form and validity of the result.
- This leads to the fixed-margin null model, in which one samples uniformly from all binary matrices with the same row and column sums as the observed matrix.
- The same sampling problem also appears in testing the Rasch model for binary response data, where conditioning on the row and column sums makes all feasible matrices equally likely [^21] [^3].
- In fact, it proves a result stronger than the conjecture itself.
- While the result here resolves the bipartite case, the analogous rapid-mixing problem for simple undirected graphs with arbitrary degree sequences remains open.
- The model first reviewed the known literature and focused on P-stable degree sequences, but this direction got stuck.
- ## 2 Main result

Let

$$
\Omega(r,c)=\left\{X\in\{0,1\}^{m\times n}:\ \sum_{j=1}^{n}X_{ij}=r_{i}\ \forall i,\quad\sum_{i=1}^{m}X_{ij}=c_{j}\ \forall j\right\}.
- $$

The following result shows that the lazy chain is irreducible and aperiodic.
- Our main result is the following spectral-gap bound for the lazy swap chain.

## Exemplos e evidências
See original source at `Clippings/Spectral Gap for the Binary Fixed-Margin Swap Chain.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/prompt]]
- [[03-RESOURCES/concepts/software-engineering/proof]]
- [[03-RESOURCES/concepts/llm-ml-foundations/stochastic]]
- [[03-RESOURCES/entities/AWS]]
