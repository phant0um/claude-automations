---
title: "A New Algorithm for Totally Positive Approximations"
type: source
source: "Clippings/A New Algorithm for Totally Positive Approximations.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [concurso, source-page]
---

## Tese central
---
title: "A New Algorithm for Totally Positive Approximations"
source: "
author:
published:
created: 2026-06-23
description:
tags:
  - "clippings"
---
Philip A. Stange and Lutz Dümbgen  
University of Bern

### Abstract. We revisit the problem of approximating a bivariate distribution with finite support by another such distribution which is totally positive or order two (TP2).

## Argumentos principais
### Abstract.
We revisit the problem of approximating a bivariate distribution with finite support by another such distribution which is totally positive or order two (TP2). Approximation is meant in a maximum likelihood sense.

### AMS subject classification:
62G05, 62G08, 62-08

### Key words:
pool adjacent violators, Sinkhorn, total positivity of order two

### 1 Introduction
Starting from a data set with observations $(X_{\ell},Y_{\ell})\in\mathbb{R}\times\mathbb{R}$, $\ell\in[N]:=\{1,2,\ldots,N\}$, we want to approximate their empirical distribution by a distribution $\hat{R}$ on the grid
$$
\{X_{1},\ldots,X_{n}\}\times\{Y_{1},\ldots,Y_{n}\}

### Calibration.
If $\boldsymbol{f}\in\mathcal{F}$ is a candidate for $\hat{\boldsymbol{f}}$, it can be improved by row-wise and column-wise calibration. Precisely,
$$
L\bigl((f_{ij}w_{i+}/f_{i+})_{i,j}\bigr)\ \leq\ L(\boldsymbol{f})

### The special case of n=2n=2 or m=2m=2.
It is instructive to look at the special case $n=2$ first. If $\boldsymbol{f}\in\mathcal{F}$ is row-wise calibrated, it may be written as
$$
f_{ij}\ =\ w_{i+}(1_{[j=1]}(1-\lambda_{i})+1_{[j=2]}\lambda_{i})

### The support of 𝒇^\\hat{\\boldsymbol{f}}.
From now on let us focus on the situation in which $m$ and $n$ are at least $3$. With $[m\times n]:=[m]\times[n]$, let $\mathcal{P}$ consist of all index pairs $(i,j)\in[m\times n]$ such that there exist indices $i_{1}\leq i\leq i_{2}$ in $[m]$ and $j_{1}\leq j\leq j_{2}$ in $[n]$ with $w_{i_{1}j_{2}}>0$ and $w_{i_{2}j_{1}}>0$. When miminimizing $L(\boldsymbol{f})$ over all $\boldsymbol{f}\in\mathcal{F}$, it suffices to consider matrices $\boldsymbol{f}$ such that
$$
\{(i,j)\in[m\times n]:f_{ij}>0\}\ =\ \mathcal{P},

### A particular update step.
Suppose that $\boldsymbol{f}\in\mathcal{F}_{\mathcal{P}}$ is a candidate for $\hat{\boldsymbol{f}}$ which is row-wise calibrated. For a fixed index $k\in[m-1]$, let
$$
I(k)\ :=\ \bigl\{i\in[m]:(i,k),(i,k+1)\in\mathcal{P}\bigr\}.

### Combining n−1n-1 updates as one iteration.
Our goal is to perform the previous updates for $k=1,2,\ldots,n-1$ such that these $n-1$ updates require $O(mn)$ steps and memory in total. Starting from a row-wise calibrated candidate $\boldsymbol{f}=\boldsymbol{f}^{(1)}$, let $\boldsymbol{f}^{(k+1)}$ be its updated version after performing the $k$ -th update, so $\boldsymbol{f}^{(n)}$ is the final new candidate. The main ingredients for the $k$ -th update are the vectors
$$
\boldsymbol{p}^{(k)}\ =\ \Bigl(w_{i+}^{-1}\sum_{j>k}w_{ij}\Bigr)_{i=1}^{m},\quad\bar{\boldsymbol{p}}^{(k)}\ =\ \Bigl(w_{i+}^{-1}\sum_{j\leq k}w_{ij}\Bigr)_{i=1}^{m},

### The complete algorithm.
The complete algorithm repeats the previous iteration until the decrease in the target function $L$ is no larger than a given small constant $\delta>0$, e.g. $\delta=10^{-3}$. Numerical experiments also revealed that “rotating” the triplets $(\boldsymbol{w},\boldsymbol{f},\boldsymbol{p})$ with $\boldsymbol{p}=(1_{\mathcal{P}}(i,j))_{i,j}$ is beneficial. That is, before iteration $r$, we replace $(\boldsymbol{w},\boldsymbol{f},\boldsymbol{p})$ with the triplet
$$
\bigl(T_{v(r)}(\boldsymbol{w}),T_{v(r)}(\boldsymbol{f}),T_{v(r)}(\boldsymbol{p})\bigr),

### 3 A numerical example
To illustrate the algorithm, we simulated a data set with $N=100$ independent identically distributed observations $(X_{\ell},Y_{\ell})$, $\ell\in[100]$; see the left panel of Figure 1. The right panel depicts the corresponding weight matrix $\boldsymbol{w}\in\mathbb{R}^{42\times 33}$. The area of a circle at $(i,j)$ is proportional to $w_{ij}$.
Figure 1: Simulated data (left) and corresponding weight matrix (right).
Starting with $\boldsymbol{f}=\bigl(1_{[(i,j)\in\mathcal{P}]}\bigr)_{i,j}$, as a first pre-iteration, we applied a row-wise calibration and a column-wise calibration of $\boldsymbol{f}$. This pre-iteration was repeated until the decrease of $L(\boldsymbol{f})$ was less than $10^{-4}$, which happened after seven pre-iterations. Figure 2 shows that candidate $\boldsymbol{f}$ after the first and after the last pre-iteration. Note that $\boldsymbol{f}$ still satisfies the condition that $f_{ij}f_{i+1,j+1}=f_{i,j+1}f_{i+1,j}$ whenever $(i,j+1),(i+1,j)\in\mathcal{P}$.

### Acknowledgement.
This work was supported by the Swiss National Science Foundation.
[^1]: Mösching, A. and Dümbgen, L. (2024). Estimation of a likelihood ratio ordered family of distributions. Stat. Comput. 34 Paper No. 58.
[^2]: Owen, A. B. (2001). Empirical Likelihood. Chapman and Hall/CRC, New York.


## Key insights
- Thus we introduce a step size correction.
- Figure 3 shows the resulting candidate $\boldsymbol{f}$ after one, two and three iterations and the final result.

## Exemplos e evidências
See original source at `Clippings/A New Algorithm for Totally Positive Approximations.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/memory]]
- [[03-RESOURCES/concepts/llm-ml-foundations/inference]]
