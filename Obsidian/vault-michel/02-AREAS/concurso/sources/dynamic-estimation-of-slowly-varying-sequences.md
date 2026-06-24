---
title: "Dynamic estimation of slowly varying sequences"
type: source
source: "Clippings/Dynamic estimation of slowly varying sequences.md"
created: 2026-06-23
ingested: 2026-06-23
score: D
tags: [concurso, source-page]
---

## Tese central
We consider the problem of sequentially approximating functions of each element in a slowly-varying sequence, i.e. one where the magnitude $\alpha_{i}$ of the difference between the elements at positions $i$ and $i-1$ is small. Recent work on implicit trace estimation shows that when $\alpha_{t}$ is small, reusing queries to past sequence elements can reduce the overall cost \[Dharangutte & Musco, NeurIPS 2021; Woodruff et al., NeurIPS 2022\].

## Argumentos principais
### 1 Introduction
In many areas of theory and practice, we face a slowly evolving system and wish to estimate its properties given only limited, structured access to its state. Examples of this problem include estimating evolving probability distributions given sample access [^22] [^23], tracking metrics on evolving social networks given only local subgraphs [^12] [^28] [^6] [^7] [^4], maintaining statistics of a drifting data stream [^31] [^17] [^14], or tracking the loss curvature during neural network optimization [^20] [^30] [^15].
We propose a general framework for solving such estimation problems when the underlying sequence consists of $m$ elements of a vector space and the distance between consecutive elements is bounded by $\alpha_{t}$. This setting is inspired by past work on estimating traces given only matrix-vector product queries and a bound on the maximum distance between them [^10] [^29]; our framework enables us to find direct applicability to other vector spaces (e.g. $L^{\infty}$ functions), derive results for certain nonlinear maps (e.g. eigenvalue distributions), develop a novel algorithm whose cost scales with $\sum_{i=1}^{m}\alpha_{i}$ (instead of prior works’ looser bound of $m\cdot\max_{i}\alpha_{i}$), and design a lightweight mechanism that estimates $\alpha_{i}$ on-the-fly (instead of assuming a known global bound). To achieve this, we require only a linear estimator that has sub-exponential concentration around its target property for every element of the vector space, with concentration parameters that scale with the element’s norm. Such estimators exist in multiple settings and allow us to show results for both linear and nonlinear properties, as evidenced in our contributions:
1. A general-purpose and adaptive framework: We introduce a flexible meta-algorithm for sequential stochastic approximation that accepts a well-concentrated static estimator and dynamically adjusts the number of queries based on the local change $\alpha_{i}$; we also show how the latter can sometimes be adaptively estimated. Our approach’s query complexity scales with the sum $\sum_{i=1}^{m}\alpha_{i}$ of local changes rather than with the worst-case change $m\cdot\max_{i}\alpha_{i}$, resulting in sequential trace estimation bounds that are both sharper and more adaptive than past works’ [^10].

### 2 General Adaptive Framework
We first set up the general problem, define notation used throughout the paper, and specify our assumptions regarding the static estimator.
Vector Spaces and the Linear Map. Let $V$ and $W$ be normed vector spaces equipped with norms $\|\cdot\|_{V}$ and $\|\cdot\|_{W}$, respectively. We consider a linear map $L:V\to W$, which represents the quantity of interest that we wish to estimate.
The Dynamic System. Let $v_{1},v_{2},\dots,v_{m}\in V$ be a sequence of elements representing the evolving state of the underlying system across $m$ time steps. We assume that the states are bounded such that $\|v_{t}\|_{V}\leq 1$ for all $t\in[m]$. Furthermore, we assume that the system changes relatively slowly between consecutive steps. To quantify this, we define the local step size $\alpha_{t}$ as the distance between consecutive states:

### 2.1 Known Step Sizes
We now present our main contribution: an adaptive algorithm that efficiently tracks dynamic quantities when the local step sizes are known. The main theorem is the following.
###### Theorem 1 (Dynamic Sample Complexity, known step sizes).
Assume $\|v_{t}\|_{V}\leq 1$ for all $t$. Given a well-concentrated estimator $\mathcal{E}$ (Definition 1), Algorithm 1 guarantees that with probability at least $1-\delta$, the estimates satisfy $\|\tilde{L}_{t}-L(v_{t})\|_{W}\leq\epsilon$ simultaneously for all $t\in[m]$. The total cumulative sample complexity is bounded by:

### 2.2 Unknown Step Sizes
In the preceding analysis, we assumed explicit knowledge of the local step sizes $\alpha_{t}=\|v_{t}-v_{t-1}\|_{V}$ to set our parameters. In practice, $\alpha_{t}$ is often unknown, but oftentimes can be efficiently estimated on the fly, as we will see in our applications in Sections 3 and 4. Abstractly, let us assume access to a Norm Estimation Oracle, $\mathcal{N}(v,k)$, which takes an input state $v\in V$ and a resource budget $k$, and outputs an approximation of the norm $\|v\|_{V}$. We split the computation at each time step $t$ into two phases as follows:
1. Estimating $\alpha_{t}$: We query the norm oracle $\mathcal{N}(v_{t}-v_{t-1},k_{norm})$ to estimate the change magnitude $\alpha_{t}$. We allocate a budget $k_{norm}$ to obtain an estimate $\hat{\alpha}_{t}$ such that $\hat{\alpha}_{t}\geq 0.9\alpha_{t}$ with a failure probability of at most $\delta/m$. We then construct our proxy step size by dividing this estimate by 0.9 (we use $0.9$ for illustrative purposes; any constant $c\in(0,1)$ works here), setting $\tilde{\alpha}_{t}=\hat{\alpha}_{t}/0.9$. This ensures that $\tilde{\alpha}_{t}\geq\alpha_{t}$ with failure probability $\delta/m$ and $\tilde{\alpha}_{t}=\Theta(\alpha_{t})$.
2. Estimating $L(v_{t})$: We instantiate the target budget $k_{t}$ and damping factor $\gamma_{t}$ using the proxy step size $\tilde{\alpha}_{t}$ in place of the true $\alpha_{t}$, and use the Adaptive Algorithm (Algorithm 1).

### 3 Application: Dynamic Trace Estimation
We first apply our general framework to the problem of dynamic matrix trace estimation in the matrix-vector product model, as introduced in Section 1.
###### Definition 3 (The Dynamic Trace Estimation Problem).
Given implicit matrix-vector multiplication access to a sequence of matrices $A_{1},\dots,A_{m}\in\mathbb{R}^{n\times n}$, maintain trace estimates $t_{1},\dots,t_{m}$ such that at every step $i$, $|t_{i}-\text{tr}(A_{i})|\leq\epsilon$ with high probability. We assume bounded Frobenius norms $\|A_{i}\|_{F}\leq 1$ and unknown local step sizes $\alpha_{i}=\|A_{i}-A_{i-1}\|_{F}\leq 1$.

### 3.1 Dynamic Trace of Matrix Powers
We now show that our framework naturally extends to tracking the trace of matrix powers. Note that while this is a non-linear function, we can still essentially reduce it to trace estimation. The main idea is that one can show (by standard telescoping) that powers of slowly changing matrices also evolve slowly, which allows us to apply our framework. As before, we assume MVP access to a sequence of matrices and we wish to maintain an $\epsilon$ approximation of $\text{tr}(A_{t}^{k})$ at all steps $t$.
Our starting point is that for consecutive matrices, the change in the $k$ -th power can be written as $A_{t}^{k}-A_{t-1}^{k}=\sum_{j=0}^{k-1}A_{t}^{j}(A_{t}-A_{t-1})A_{t-1}^{k-1-j}$. Taking the Frobenius norm and using sub-multiplicativity of the Frobenius norm ($\|XY\|_{F}\leq\|X\|_{2}\|Y\|_{F}$), we obtain $\|A_{t}^{k}-A_{t-1}^{k}\|_{F}\leq\sum_{j=0}^{k-1}\|A_{t}\|_{2}^{j}\|A_{t}-A_{t-1}\|_{F}\|A_{t-1}\|_{2}^{k-1-j}\leq k\alpha_{t}$. Thus, the local step size for the $k$ -th matrix power sequence is bounded by $k\alpha_{t}$. Because we only assume MVP access to the sequence $A_{t}$, evaluating Hutchinson’s estimator on the $k$ -th matrix power requires computing products of the form $A_{t}^{k}v$. We simulate this by applying the matrix sequentially, $A_{t}(A_{t}(\dots A_{t}(v)\dots))$, which incurs a multiplicative overhead of $k$ per sample. When the step sizes $\alpha_{t}$ are unknown, we estimate them dynamically. Since $\|A_{t}^{k}-A_{t-1}^{k}\|_{F}^{2}=\text{tr}((A_{t}^{k}-A_{t-1}^{k})^{T}(A_{t}^{k}-A_{t-1}^{k}))$, we can approximate the step size of the $k$ -th powers via Hutchinson’s estimator as in Section 3.0.1. Again, computing the matrix-vector product $(A_{t}^{k}-A_{t-1}^{k})v$ involves applying $A_{t}$ and $A_{t-1}$ sequentially $k$ times, which is also a $k$ multiplicative overhead. Applying the Adaptive Algorithm with unknown step sizes requires $\mathcal{O}\left(\frac{\log(m/\delta)}{\epsilon^{2}}(1+\sum_{t=2}^{m}k\alpha_{t})\right)$ total samples, which we multiply by a $k$ for the sample complexity.
###### Corollary 4 (Dynamic Trace of Matrix Powers).

### 3.2 Application: Dynamic Spectral Density Estimation
As a direct application of tracking the trace of matrix powers, we consider the problem of estimating a matrix’s spectral density. For an $n\times n$ matrix, the *spectrum* is the vector of its sorted eigenvalues, $\lambda=(\lambda_{1},\dots,\lambda_{n})$ where $\lambda_{1}\geq\dots\geq\lambda_{n}$. We consider an $\epsilon$ -approximate spectrum defined as $\frac{1}{n}\|\tilde{\lambda}-\lambda\|_{1}\leq\epsilon$. This is also the *Wasserstein distance* between the discrete distribution of eigenvalue approximations to the true eigenvalues. Applications include estimating the spectrum of the (changing) Hessian, which is useful to study the dynamics of training [^15] and the spectral density of a graph Laplacian, which reveals the presence of communities at multiple scales [^8]. It is known that in the static case, roughly $e^{\mathcal{O}(1/\epsilon)}$ MVPs suffice to obtain this estimation [^8] (see Theorem 8). In the following theorem, we run $K$ independent instances of our Adaptive Algorithm, where the $k$ -th stream tracks the $k$ -th spectral moment $\text{tr}(A_{t}^{k})$. To guarantee uniform success across all $K$ streams and $m$ steps with probability $1-\delta$, we set the failure probability for each instance to $\delta/K$. The proof of the theorem is deferred to Appendix B.2.
###### Theorem 5 (Dynamic Spectral Estimation).
Let $\epsilon,\delta\in(0,1)$. Given implicit matrix-vector multiplication access to a sequence of symmetric matrices $A_{1},\dots,A_{m}$ with eigenvalues bounded in $[-1,1]$, bounded Frobenius norms $\|A_{t}\|_{F}\leq 1$, and unknown local step sizes $\alpha_{t}=\|A_{t}-A_{t-1}\|_{F}$, the dynamic estimation procedure outlined above guarantees that with probability at least $1-\delta$, the maintained eigenvalue estimates form an $\epsilon$ -approximate spectrum in Wasserstein distance simultaneously for all $t\in[m]$. The cumulative MVPs is bounded by $e^{\mathcal{O}(1/\epsilon)}\log(m/\delta)\left(1+\frac{1}{\epsilon}\sum_{t=2}^{m}\alpha_{t}\right).$

### 4 Application: Dynamic Monte Carlo Integration
We now apply our framework to efficiently maintain estimates of slowly changing integrals.
###### Definition 4 (The Dynamic Monte Carlo Integration Problem).
Given sampling access to a fixed probability density function $p(x)$ over a domain $\Omega$, and oracle access to evaluate a sequence of evolving functions $f_{1},\dots,f_{m}:\Omega\rightarrow\mathbb{R}$, maintain running integral estimates $\tilde{I}_{1},\dots,\tilde{I}_{m}$ such that at every step $t$, $|\tilde{I}_{t}-\int_{\Omega}f_{t}(x)p(x)dx|\leq\epsilon$ with probability $1-\delta$. We assume a global bound on the supremum norm $\|f_{t}\|_{\infty}\leq 1$. The local known step sizes are $\alpha_{t}=\|f_{t}-f_{t-1}\|_{2,p}=\sqrt{\mathbb{E}_{x\sim p}[(f_{t}(x)-f_{t-1}(x))^{2}]}$.

### 4.1 Application: Dynamic Dirichlet Problem
A classical problem in mathematical physics is the Dirichlet problem for Laplace’s equation [^1] [^9] [^19]. Given a domain $\Omega\subset\mathbb{R}^{d}$ and a continuous boundary function $g:\partial\Omega\to\mathbb{R}$, the goal is to find a smooth interpolation $u(x)$ into the interior such that $\Delta u=0$ on $\Omega$ and $u=g$ on $\partial\Omega$. Here, $\Delta$ is the standard Laplacian operator, that is $\Delta u=\nabla\cdot\nabla u$.
By Kakutani’s theorem [^18], the smooth interpolation solution $u(x)$ evaluated at a specific interior point $x$ can be expressed as an integral of the boundary values $g$ with respect to the harmonic measure $P(x,\cdot)$: $u(x)=\int_{\partial\Omega}g(y)P(x,dy).$ This harmonic measure represents the probability distribution of the location where a random Brownian motion, originating at $x$, first intersects the boundary $\partial\Omega$. Because $u(x)$ is formulated as an integral over a probability measure, we can estimate it using Monte Carlo integration. Specifically, we can obtain an unbiased estimate of $u(x)$ by simulating multiple random walks starting from $x$ and averaging the values of $g$ at their respective boundary exit points. In practice, the sampling step can be implemented via the *Walk on Spheres* (WoS) method [^24]. Although that algorithm’s cost is usually dominated by the walk itself, our result may be useful in settings where evaluating the boundary function is the true bottleneck, such as when querying it involves inference of a neural network or solving a different PDE.
We consider the following dynamic setting. Suppose the boundary condition is changing slowly over time, yielding a sequence of boundary functions $g_{1},g_{2},\dots,g_{m}$. This corresponds to a dynamic Dirichlet problem where we wish to track the evolving solution $u_{t}(x)$ at a fixed evaluation point. As a direct application of Theorem 6, we get Corollary 7.

### 5 Experiments
We empirically evaluate our proposed adaptive algorithm. We compare it against the parameter-free DeltaShift baseline [^10], the current state-of-the-art for dynamic trace estimation for Frobenius norms.
Comparing Cost across a sequence and Ablations. In our first experiment, we generate a synthetic sequence of $2000\times 2000$ matrices over $m=200$ timesteps. We introduce rare, large perturbations to simulate a stable sequence punctuated by bursts. As shown in Figure 1, the baseline method decides its (fixed) query budget based on the worst-case step size ($\alpha_{\max}$). On the other hand, our adaptive algorithm scales down its query budget during stable periods, resulting in a significantly lower total matrix-vector product (MVP) cost. Furthermore, Figure 4 confirms that this cost reduction holds across a wide range of target error tolerances ($\epsilon$) and failure probabilities ($\delta$).
Cost vs. Empirical Error Pareto Frontier. In our second experiment, we evaluate the trade-off between total computational cost (MVPs) and empirical error. To generate a single point on the trade-off graph, we first run our adaptive method for a specific target error tolerance, record its total budget, and then evaluate the baseline by dividing that exact budget evenly across all timesteps (as the baseline cannot adjust adaptively). We repeat this procedure across varying error tolerances to construct the Pareto plots. Figure 2 shows the results for three metrics: Maximum Absolute Error, Mean Absolute Error, and Weighted Mean Error (which penalizes errors heavily during large matrix jumps). Across all three metrics, our method performs better.

### Appendix A Additional Preliminaries
###### Definition 6 (Sub-exponential scalar variables and norm-concentrated vector errors).
A scalar random variable $X$ with mean $\mu$ is sub-exponential with variance parameter $\nu^{2}\geq 0$ and scale parameter $\beta\geq 0$ if
$$

### B.1 Proof of Theorem
###### Proof of Theorem.
By a union bound over the oracle queries, with probability at least $1-\delta$, the condition $\tilde{\alpha}_{t}\geq\alpha_{t}$ holds simultaneously for all $t\in[m]$. Conditioned on this, the sample budget allocated in the second phase satisfies $k_{t}(\tilde{\alpha}_{t})\geq k_{t}(\alpha_{t})$. Since the budget monotonically increases with step size, drawing $k_{t}(\tilde{\alpha}_{t})$ samples is sufficient to ensure the sub-exponential parameters satisfy $\nu_{t}^{2}\leq N$ and $\beta_{t}\leq B$, and thus the inductive proof. Applying Theorem 1 with proxy step sizes $\tilde{\alpha}_{t}$ adds a failure probability of at most $\delta$, thus the total failure probability is at most $2\delta$. Adding the Phase 1 additive sample overhead of $\sum k_{norm}$ yields the final bound. ∎

### B.2 Proof of Theorem
###### Proof of Theorem.
We apply the bound from Corollary 4 (Dynamic Trace of Matrix Powers). Summing the required MVPs across all $K$ instances, we obtain:
$$


## Key insights
- We introduce a framework generalizing this to a variety of linear and nonlinear functions on diverse vector spaces, obtaining novel sequential estimation results for matrix powers, spectral densities, Monte Carlo integration, and a boundary value problem from partial differential equations (PDEs).
- Lastly, while all past work assumes a known bound on $\alpha_{i}$, we show in certain cases how the changes can be estimated on-the-fly with (nearly) no added cost.
- We propose a general framework for solving such estimation problems when the underlying sequence consists of $m$ elements of a vector space and the distance between consecutive elements is bounded by $\alpha_{t}$.
- To achieve this, we require only a linear estimator that has sub-exponential concentration around its target property for every element of the vector space, with concentration parameters that scale with the element’s norm.
- Such estimators exist in multiple settings and allow us to show results for both linear and nonlinear properties, as evidenced in our contributions:

1.
- Diverse applications: A strength of our framework is its broad applicability, which we demonstrate via novel theoretical results for sequential estimation of matrix powers, spectral densities, function integrals, and solutions to boundary value problems (see Table 1).
- We demonstrate this with experiments on synthetic matrix sequences and Hessians from neural network optimization trajectories.
- A representative problem in this setting is trace estimation in the implicit matrix model.
- Recent work has shown how to dramatically improve on this [^10] [^29], obtaining query complexity that scales with the maximum of the largest local change $m\cdot\max_{i}\alpha_{i}$ for $\alpha_{i}:=\|A_{i}-A_{i-1}\|$.
- We obtain query complexity scaling with $\sum\alpha_{i}$, a natural measure of how ‘varying’ the sequence is similar to path-length-style bounds in online learning [^2] [^32], and show how their approach can be broadly generalized to other sequential estimation problems.

## Exemplos e evidências
See original source at `Clippings/Dynamic estimation of slowly varying sequences.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/ai-agents/tool]]
- [[03-RESOURCES/concepts/software-engineering/proof]]
