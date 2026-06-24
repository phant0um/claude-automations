---
title: "OASIS: Observation-Aware Simulation-Based Inference via Distributional Matching"
type: source
source: "Clippings/OASIS Observation-Aware Simulation-Based Inference via Distributional Matching.md"
created: 2026-06-23
ingested: 2026-06-23
score: B
tags: [concurso, source-page]
---

## Tese central
We introduce OASIS, a simulation-based inference framework for scientific settings where observations are distorted by measurement error, selection effects, and other survey-specific transformations. In many real applications, simulators generate latent, noiseless quantities, while the data are observed only after passing through a complex observational pipeline. Standard simulation-based inference methods often ignore this distinction, comparing observations to idealized simulator outputs or re

## Argumentos principais
### 1 Introduction
Modern scientific inference is increasingly driven by complex simulators that generate high-dimensional data under richly structured physical models [^1]. In many domains, such as cosmology, particle physics, climate science, and systems biology, the data-generating process is only partially observable. Meaning latent quantities of interest are transformed by measurement noise, selection effects, censoring, and survey-specific distortions before they are recorded [^2] [^3]. As a result, inference must proceed by comparing observed data not to idealized simulator outputs, but to their *observationally transformed* counterparts. This distinction is central in practice, yet remains under-addressed in much of the simulation-based inference (SBI) literature [^4], where comparisons are often performed either on latent quantities or on low-dimensional summary statistics that do not faithfully reflect the full observational pipeline.
Approximate Bayesian computation (ABC) and related likelihood-free methods provide a flexible framework for SBI when the likelihood is intractable, but forward simulation is available [^5] [^6]. However, classical ABC relies on carefully chosen summary statistics and distance functions, which can lead to information loss and bias, particularly in high-dimensional settings or when observational distortions are complex. Recent approaches have sought to mitigate these issues using learned summaries [^7] or distributional distances such as the maximum mean discrepancy (MMD) [^8] [^9], which operate directly on empirical distributions. While these advances improve expressivity, they typically assume that simulated and observed data are directly comparable, implicitly neglecting the structured observation processes that intervene between latent states and recorded measurements.
Neural simulation-based inference methods (e.g., neural posterior, likelihood, and ratio estimation) approximate $p(\theta\!\!\mid\!\!y)$, $p(y\!\!\mid\!\!\theta)$, or density ratios using learned models trained on simulated data [^10] [^11] [^12] [^13]. These approaches scale to high-dimensional observations and enable amortized inference [^14], but require demanding computational resources, careful tuning, and large simulation budgets, and can be sensitive to architectural and optimization choices. More fundamentally, they assume that training simulations match the observed-data distribution. In many scientific settings, simulators produce latent quantities that must be transformed through complex and imperfectly characterized observational pipelines. If this mismatch is not explicitly modeled, the learned representations may be misaligned with the observed data, leading to biased or miscalibrated inference [^15]. This motivates inference procedures that operate directly on observed-data distributions while explicitly incorporating observational mechanisms, instead of relying on surrogates trained on idealized simulations.

### 2 OASIS Method
#### Context.
OASIS targets settings where inference must account for measurement error and observational distortions. In many applications, the simulator generates a latent, noiseless population, whereas the observed dataset is obtained only after noise, heteroscedastic scatter, missingness, censoring, truncation, thresholding, or survey selection have acted on that population. Consequently, the relevant comparison is not between observed data and latent simulator output, but between observed data and simulator output after the same observational mechanism has been applied.
#### Notation.

### 3 Theoretical Guarantees
This section develops the theoretical properties of the MMD-based pseudo-posterior introduced in Section 2. The central object is the population discrepancy
$$
\Delta(\theta)=\mathrm{MMD}_{k}^{2}\!\bigl(P_{\mathrm{obs}},P_{\theta}^{\mathrm{obs}}\bigr),

### 3.1 Convergence and Consistency of Pseudo-posterior
For fixed $\tau>0$, define the population pseudo-posterior
$$
\pi_{\tau}(d\theta)=\frac{p(\theta)\exp\{-\Delta(\theta)/(2\tau^{2})\}\,d\theta}{\int_{\Theta}p(\vartheta)\exp\{-\Delta(\vartheta)/(2\tau^{2})\}\,d\vartheta}.

### 3.2 Identifiability and Posterior Concentration
We now turn to the asymptotic regime in which $n\to\infty$, $M\to\infty$, and the temperature $\tau_{n,M}\downarrow 0$. The relevant target is the identified set
$$
\Theta^{\dagger}=\arg\min_{\theta\in\Theta}\Delta(\theta).

### 3.3 Joint Asymptotics with the Monte Carlo Approximation
The final result combines the two sources of approximation: finite parameter sampling and finite data or simulation sample sizes.
###### Corollary 3.6.
Let $h:\Theta\to\mathbb{R}$ be bounded and continuous, and let $n_{\theta}\to\infty$. First, fix $\tau>0$. Under the assumptions of Theorems 3.1 and 3.2,

### 4 Benchmarking
#### Linear Regression.
We evaluate the proposed method under a controlled simulation setting with heteroscedastic measurement error in both covariates and responses, where latent covariates are drawn from a Gaussian mixture distribution, intrinsic scatter is Gaussian, and measurement error with heteroscedastic Gaussian, Laplace, and Iniform noises. A detailed description of the data-generating process, observation model, and inference procedures is provided in Appendix G. We compare against a range of standard errors-in-variables baselines, including LinMix [^47], Deming regression [^48], BCES [^49], ODR [^50], SIMEX [^51], and ordinary least squares (OLS), covering both hierarchical Bayesian, likelihood-based, and classical correction methods.
Figure 1: Performance comparison under Gaussian intrinsic noise. Top row: distribution of estimation error (posterior or estimator mean minus ground truth) for α \\alpha, β \\beta, and σ 2 \\sigma^{2} across 500 independent realizations. Bottom row: empirical coverage of nominal 90% uncertainty intervals. The proposed method ( OASIS ) achieves low bias and near-nominal coverage across parameters, while classical errors-in-variables methods exhibit increased bias and miscalibration under heteroscedastic measurement noise. Full experimental details are provided in Appendix G.

### 5 Conclusion
OASIS provides an observation-aware framework for simulation-based inference in scientific problems where the relevant comparison is between observed data and forward-simulated observations, rather than between data and idealized latent simulator outputs. By embedding measurement error, selection effects, and survey-specific transformations directly into the simulation loop, and by replacing handcrafted summaries with an MMD-based distributional discrepancy, OASIS offers a flexible pseudo-posterior construction with theoretical consistency guarantees and empirically well-calibrated uncertainty. The experiments show that this approach is robust in controlled errors-in-variables settings and remains competitive in a realistic multi-wavelength cluster-cosmology benchmark involving correlated observables, incomplete coverage, and selection effects. More broadly, the results suggest that distributional matching with explicit observational modeling can serve as a practical alternative to summary-based or neural SBI methods when likelihoods are unavailable, observational pipelines are complex, and calibrated uncertainty is more important than aggressive compression or amortized inference. Future work should focus on principled temperature calibration, scalable kernel approximations, and extensions that incorporate count or abundance information directly into the discrepancy, thereby improving efficiency while preserving the observation-aware structure of the method.
#### Limitations.
The proposed framework relies on the availability of a known or accurately quantifiable observation model, which may be restrictive in settings where measurement processes are poorly understood or only partially specified. While the method avoids explicit likelihood evaluation, it incurs nontrivial computational cost due to repeated forward simulations and pairwise kernel evaluations, which can scale quadratically with sample size and simulation budget. The theoretical guarantees rely on correct specification and identifiability of the observed-data mapping; under model misspecification or observational non-identifiability, the method may concentrate on a set of observationally equivalent parameters rather than a unique ground truth. Performance is also sensitive to the choice of kernel and its hyperparameters, which govern the geometry of distributional comparison and may affect identifiability in practice. Although MMD provides a powerful distributional metric, it may have reduced sensitivity to certain high-frequency discrepancies or structured differences in high-dimensional settings without careful kernel design. The generalization to multinomial data requires careful consideration and is an interesting avenue for further investigation [^61].

### Acknowledgment
This work was supported by the NSF under Cooperative Agreement 2421782, and the Simons Foundation grant MPS-AI-00010515 awarded to the NSF-Simons AI Institute for Cosmic Origins (CosmicAI, [)).

### Appendix A Assumptions
Here, we state all the regularity conditions used throughout this work.
###### Assumption A.1 (Parameter space and prior).
The parameter space $\Theta\subset\mathbb{R}^{p}$ is compact. The prior density $p(\theta)$ is continuous on $\Theta$ and strictly positive on $\Theta$.

### Appendix B Justification of the Rate Assumption for Empirical MMD
Here, we provide a justification for Assumption A.6, namely that the empirical MMD discrepancy converges uniformly to its population counterpart at a rate sufficient to ensure
$$
\sup_{\theta\in\Theta}\bigl|\Delta_{n,M}(\theta)-\Delta(\theta)\bigr|=o_{P}(\tau_{n,M}^{2}).

### B.1 Setup and decomposition
Recall that for each $\theta\in\Theta$,
$$
\Delta(\theta)=\mathrm{MMD}_{k}^{2}\!\bigl(P_{\mathrm{obs}},P_{\theta}^{\mathrm{obs}}\bigr),\qquad\Delta_{n,M}(\theta)=\mathrm{MMD}_{k}^{2}\!\bigl(\widehat{P}_{\mathrm{obs}},\widehat{P}_{\theta,M}^{\mathrm{obs}}\bigr),

### Appendix C OASIS Algorithm
Algorithm 1 implements a likelihood-free inference procedure based on distributional comparison between observed data and forward simulations. The key feature is the explicit two-stage simulation: latent samples are first drawn from the mechanistic simulator and are subsequently propagated through the observation model. This produces synthetic datasets that are directly comparable to the observed data at the level of the observed-data law.
The discrepancy between observed and simulated datasets is quantified using MMD, which operates on empirical measures and avoids the need for handcrafted summary statistics. The resulting loss $\Delta_{n,M}(\theta)$ is stochastic due to the finite simulation budget $M$, inducing a pseudo-posterior indexed by both $M$ and the temperature parameter $\tau$. Larger values of $M$ reduce Monte Carlo variability in the loss, while $\tau$ controls the concentration of the posterior around minimizers of the population discrepancy.
The algorithm can be interpreted as a particle-based approximation to a Gibbs-type posterior defined through a distributional loss. It is straightforward to parallelize across particles and simulation draws, and can be combined with adaptive proposals or sequential schemes to improve efficiency. In practice, the computational cost is dominated by simulator evaluations and scales as $\mathcal{O}(n_{\theta}M)$.

### Appendix D Temperature Selection
The temperature parameter $\tau$ controls the concentration of the pseudo-posterior
$$
\pi_{\tau}(d\theta)\propto p(\theta)\exp\{-\Delta(\theta)/(2\tau^{2})\}d\theta,

### Appendix E Problem Setup
We consider an observed dataset
$$
\mathcal{D}_{\mathrm{obs}}=\{y_{i}^{\mathrm{obs}}\}_{i=1}^{n},\qquad y_{i}^{\mathrm{obs}}\in\mathbb{R}^{d},


## Key insights
- OASIS addresses this mismatch by explicitly embedding the observation model into the simulator and performing inference directly at the level of observed-data distributions.
- As a result, inference must proceed by comparing observed data not to idealized simulator outputs, but to their *observationally transformed* counterparts.
- While these advances improve expressivity, they typically assume that simulated and observed data are directly comparable, implicitly neglecting the structured observation processes that intervene between latent states and recorded measurements.
- We introduce OASIS <sup>1</sup>, an SBI framework that incorporates observational mechanisms and operates directly on observed-data distributions.
- We benchmark against error-in-variables methods in linear regression and evaluate on an astrophysical inference problem involving galaxy clusters [^22], where nonlinear relations, heteroscedastic noise, selection effects, and partial coverage challenge standard approaches.
- $$

Second, each latent realization is mapped through the observation model by sampling

$$
y_{\theta,m}^{\mathrm{sim,obs}}\sim P^{\rm Err}_{\theta}(\cdot\mid u_{\theta,m}^{\mathrm{true}}).
- [^17] provide identifiability conditions for the observation model under which equality of observed-data laws implies $P_{\mathrm{true}}=P_{\theta}^{\mathrm{true}}$.
- It is itself induced by Monte Carlo draws from the simulator, which is composed of the observation model.
- Classical ABC accepts or reweights parameter draws according to the proximity of simulated and observed data, typically through low-dimensional summaries, while semi-automatic ABC and related variants learn or construct summaries designed to improve efficiency.
- Synthetic-likelihood methods replace the intractable likelihood by a parametric model, often Gaussian, for summary statistics, thereby reducing dimensionality at the cost of an additional approximation [^35] [^36].

## Exemplos e evidências
See original source at `Clippings/OASIS Observation-Aware Simulation-Based Inference via Distributional Matching.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/benchmark]]
- [[03-RESOURCES/concepts/llm-ml-foundations/inference]]
- [[03-RESOURCES/concepts/software-engineering/specification]]
- [[03-RESOURCES/entities/AWS]]
- [[03-RESOURCES/entities/Uber]]
- [[03-RESOURCES/entities/Python]]
