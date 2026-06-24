---
title: "Gaussian Process Differential Ensembles for Joint Inference on Curves, Derivatives, and Integrals"
type: source
source: "Clippings/Gaussian Process Differential Ensembles for Joint Inference on Curves, Derivatives, and Integrals.md"
created: 2026-06-23
ingested: 2026-06-23
score: D
tags: [articles, source-page]
---

## Tese central
Functional data are often modeled through one likelihood-linked curve, while the scientific target is a larger state containing rates, accumulated quantities, boundary values, or nonlinear functionals of several linked levels. These targets require more than smoothing the observed curve: derivative uncertainty, cross-level covariance, and integration constants must be handled jointly. We introduce anchored Gaussian process differential ensembles, embedding an anchor $f_{0}$ in a joint Gaussian s

## Argumentos principais
### 1 Introduction
Functional data are often modeled through one latent curve that is linked directly to the observations. In many applications, however, that curve is only one coordinate of the scientific state. A curve may be observed because it is measured most directly, while the quantities of interest are rates, accelerations, accumulated effects, boundary states, or event probabilities defined by several different derivative and integral levels. In biomechanics, for example, the observed or modeled quantity may be acceleration while questions concern velocity, position, and turning points. More generally, the target may be a nonlinear functional of a state vector containing an anchor curve, its derivatives, and its repeated integrals. A Bayesian analysis of such targets should propagate posterior uncertainty through the differential relationships among the state components.
The statistical difficulty is not merely that derivatives and integrals can be computed after fitting a smooth curve. Post-processing a fitted curve can obscure the covariance structure needed for inference. Differentiating a posterior mean ignores posterior covariance and therefore cannot provide calibrated uncertainty for rates or accelerations. Finite differences depend on the chosen grid and become unstable when derivative order increases. Antiderivatives are not uniquely determined without integration constants, so cumulative or boundary-state inference requires boundary information in addition to the anchor-level likelihood. Standard Gaussian process derivative and linear operator constructions provide joint covariance identities for transformed processes, but positive-index boundary uncertainty is often left implicit. Finite-rank approximations add a further difficulty because a basis calibrated for the anchor curve can under-resolve derivative targets because differentiation emphasizes high-frequency components.
This paper develops anchored Gaussian process differential ensembles for this setting. The starting point is a Gaussian process $f_{0}$, called the anchor, because it is the component linked to the observation model. Negative-index components $f_{-1},\ldots,f_{-r}$ are mean-square derivatives of the anchor. Positive-index components $f_{1},\ldots,f_{r}$ are repeated definite integrals of the anchor from a reference point $t_{0}$, plus Gaussian integration constants $\kappa_{1},\ldots,\kappa_{r}$. The resulting object is one coherent joint Gaussian law for the derivative–anchor–integral state. The weak construction determines all finite-dimensional distributions and covariance blocks, and under additional regularity the same law can be represented by sample paths satisfying the corresponding differential chain.

### 1.1 Related work
Gaussian process derivatives, gradient kriging, and linear operator Gaussian processes provide the closest mathematical antecedents. The covariance identities for a process and its derivatives are standard in derivative Gaussian process modeling [^21], and more general linear transformations of Gaussian processes have been used for operator-constrained prediction and inter-domain models [^5] [^15] [^11] [^19]. Related latent force models use Gaussian process priors together with differential equation operators to construct physically motivated covariance functions [^1]. These constructions show that derivative and operator transformed quantities can be modeled jointly with an underlying Gaussian process. The distinction here is the anchor organization where the likelihood is attached to a specified state component, while derivative levels, integral levels, and boundary constants are represented in a single posterior state.
Integrated processes and latent rate models emphasize the complementary direction in which a latent rate or derivative process is integrated to obtain the observed curve. Examples include Gaussian process priors on derivatives that are integrated to recover a latent function [^8], integrated latent rate models in environmental time series [^2], and integrated Wiener or stochastic differential equation smoothing priors used for joint inference on functions and derivatives [^28] [^29]. Such models are natural when the rate process is the primitive object. The present construction instead allows the observation linked curve to be chosen as the anchor and then represents both derivatives below the anchor and repeated integrals above it with integration constants kept explicit.
Derivative estimation also has a long functional data and smoothing spline tradition. A common approach is to fit a smooth basis expansion and differentiate the fitted representation [^20] [^17], and related generalized smoothing approaches encode differential equation structure through derivative penalties or profiling [^16]. These approaches are useful for exploratory derivative summaries, but the resulting uncertainty depends on how smoothing, derivative penalties, and boundary behavior are encoded in the fitted representation. Applied and methodological Gaussian process work likewise shows that rates, stationary points, and extrema can be primary inferential targets [^24] [^27] [^12], and recent theory gives positive results for plug-in Gaussian process derivative inference [^13]. The comparison made here is not with a single estimator, but with the broader post-processing workflow. When uncertainty in derivatives, integrals, boundary states, or nonlinear functionals is central, those quantities should be part of the modeled posterior state.

### 2 Methods
##### Notation.
All processes are indexed by a fixed interval $[t_{0},t_{1}]\subset\mathbb{R}$. When an ensemble order is fixed, $r\in\mathbb{N}$ denotes that order and signed level indices $p,q$ range over $\{-r,\ldots,r\}$, with $f_{0}$ the anchor, negative levels denoting derivatives, and positive levels denoting integrals. We write $\mathbf{1}_{\{\cdot\}}$ for indicators, $\mathbb{N}_{0}=\{0,1,\ldots\}$, and $\|\cdot\|_{\infty}$ for the supremum norm. For an integer $q\geq 0$, write $D_{t}^{q}$ for the $q$ th derivative, with $D_{t}^{0}=\mathrm{Id}$, and define the repeated integral operator by
$$

### 2.1 Anchored Differential Ensembles
We begin with recalling the standard Gaussian process regression model for observed data $(Y_{i},t_{i})_{i=1}^{n}$,
$$
\displaystyle Y_{i}\mid f,\sigma^{2}\overset{\perp\!\!\!\perp}{\sim}N(f(t_{i}),\sigma^{2}),\qquad f\mid\theta\sim\mathcal{GP}(0,C_{\theta}),

### 2.2 Spectral Approximation via Laplacian Eigenfunctions
The construction in Theorems 1 and 1 expresses each kernel-driven covariance entry in terms of the operators $\mathcal{A}_{1,t_{0}}^{[p]}\mathcal{A}_{2,t_{0}}^{[q]}$ applied to the anchor covariance function $C_{\theta}$. For standard covariance functions such as the exponential quadratic or Matérn families, the transforms can in principle be written in closed form, but the resulting expressions become cumbersome as the ensemble order $r$ increases and need not be available in a form useful for implementation. Our proposal for a general construction is to replace these covariance operators by the Hilbert space Gaussian process (HSGP) approximation of [^22], which depends on $C_{\theta}$ only through its spectral density and represents all required transformations through precomputable Laplacian basis functions. For any fixed finite order supported by the regularity assumptions, increasing the derivative–integral ladder changes the transformed basis, but it does not require new covariance-specific derivative or integral calculus.
Assume from here on that $[t_{0},t_{1}]\subseteq[-L,L]$ where we refer to $[-L,L]$ as the computational domain. Let $C_{\theta}(s,t)=C_{\theta}(\tau)$ with $\tau=s-t$ be a stationary covariance function with spectral density
$$

### 2.3 Target-aware calibration of the Differential Ensemble
TARTARE (Target-Aware Range and Truncation for Approximate Representations of Ensembles) is the corresponding extension of the calibration strategy of [^18] from a single Gaussian process to a differential ensemble. Rather than calibrating $L$ and $K$ only for the anchor covariance, TARTARE calibrates the finite-rank approximation against a user-specified set of monitored ensemble levels. Let $\mathcal{M}\subseteq\{-r,\ldots,r\}$ be this monitoring set, where $p\in\mathcal{M}$ denotes the ensemble element $f_{p}$. For example, $\mathcal{M}=\{0\}$ monitors the anchor, $\mathcal{M}=\{-2\}$ monitors the second derivative, and $\mathcal{M}=\{-2,-1,0,1,2\}$ monitors a full second-order ensemble.
TARTARE sets $L$ and $K$ through the normalized length-scale $u=\rho/W$ (the covariance length-scale $\rho$ relative to the half-width $W$ of the observation window) and two calibration constants: a spectral constant $m$, which fixes the retained frequency range and hence $K$; and a range coefficient $c_{\mathcal{M}}$, which fixes the distance to the artificial Dirichlet boundary and hence $L$. These constants are chosen by comparing exact and HSGP covariance matrices on fixed calibration grids for the monitored levels. The exact Gaussian ensemble remains the target object. The polynomial covariance from integration constants is retained exactly and is not part of the offline covariance approximation. Offline calibration builds reusable entries indexed by kernel family, smoothness, ensemble order, and monitored set. Online use applies one such entry to a dataset, fits the model, and enlarges the finite representation until the reported posterior summaries are stable.
##### Offline calibration.

### 3 Simulation study
The simulation study evaluates whether TARTARE’s target-aware ensemble calibration improves finite-rank HSGP approximations for differential ensemble inference. The comparison is against anchor-level calibration in the spirit of [^18], which chooses the HSGP basis for the observed anchor process $f_{0}$ alone. The central question is whether calibrating the basis to derivative or full-ensemble targets improves posterior recovery of the monitored ensemble levels, especially the second derivative $f_{-2}$, without sacrificing anchor or integral summaries.
We simulate data from a second-order differential ensemble $(f_{-2},f_{-1},f_{0},f_{1},f_{2})$ and observe only the noisy anchor $f_{0}$. The simulation uses $1000$ replicated datasets for each configuration and evaluates posterior summaries on a $101$ -point prediction grid. Within each replicate, data were generated on $[-1,1]$ from $y_{i}=f_{0}(t_{i})+\epsilon_{i}$, $\epsilon_{i}\sim N(0,0.10^{2})$, at $n\in\{25,50\}$ equally spaced design points. The design crossed squared exponential (SE) and Matérn $7/2$ (Mat7/2) anchor kernels with normalized length-scales $\rho\in\{0.35,0.65\}$. The positive-index constants were fixed at their generating values, $\kappa_{1}=0.60$ and $\kappa_{2}=-0.40$, to isolate the kernel-driven HSGP approximation. Boundary-constant sensitivity is reported in Section S.6.2.
Table 1 summarizes the simulation results. Exact is the analytic exact-covariance reference at the generating hyperparameters. HSGP denotes an anchor-level practical Hilbert space Gaussian process rule in the style of [^18]. The TARTARE rules are T-f monitoring $\mathcal{M}=\{0\}$, T-D2 monitoring $\mathcal{M}=\{-2\}$, and T-all monitoring $\mathcal{M}=\{-2,-1,0,1,2\}$. Spline is a smoothing spline point estimate comparator. The table reports failures from the online phase of the TARTARE calibration procedure, selected basis size $K$, range factor $c$, integrated root mean squared error (IRMSE), pointwise $95\%$ coverage, and the geometric-mean IRMSE ratio relative to Exact within each configuration. Coverage is the percentage, over prediction-grid locations and available replicated fits, for which the simulated latent value $f_{p}(t)$ lies inside the pointwise central $95\%$ posterior interval for the corresponding ensemble level $p$.

### 4 Application – Motorcycle crash data
We apply the method to motorcycle crash data to infer a coherent kinematic state from noisy head-acceleration measurements, using short-horizon turning-point behavior as a focused example of a joint ensemble functional.
The mcycle data comprise $133$ measurements of head acceleration from a simulated $60\,\mathrm{ms}$ motorcycle crash experiment and are a well-known example in nonparametric regression [^20] [^4]. For each observation, times gives elapsed time in milliseconds after impact and accel gives the corresponding head acceleration in units of $g$. We use acceleration as the anchor of a differential ensemble and ask whether the inferred kinematic state predicts a near-future reversal of velocity during impact. This target is not a feature of a smoothed acceleration curve alone but depends jointly on acceleration, jerk, snap, velocity, and position.
The mean structure is a second-order differential ensemble with acceleration as the anchor $f_{0}$. The negative levels are thus jerk $f_{-1}$ and snap $f_{-2}$, while the positive levels are velocity and position,

### 5 Discussion
Observed functional data often enter a model through one anchor curve, but the scientific target is rarely limited to that curve. Rates, accelerations, accumulated exposure, boundary states, and turning-point or threshold functionals all depend on several linked levels of a differential state. The contribution is not the observation that Gaussian processes can be differentiated or integrated. It is the organization of these operations around a chosen anchor, with covariance propagated across all levels and with positive-index boundary information represented explicitly. TARTARE is the necessary calibration procedure that makes the finite-rank implementation target-aware when derivative or ensemble summaries are reported. This organization keeps the inferential target visible from model specification to posterior reporting.
The exact construction separates two sources of uncertainty. The anchor covariance induces the derivative, anchor, integral, and cross-level covariance blocks through linear operators. The integration constants contribute a finite-dimensional polynomial covariance above the anchor. This distinction is statistically important.
The weak Gaussian construction is the inferential foundation of the paper. It gives the finite-dimensional Gaussian laws and covariance blocks needed for posterior computation. The pathwise differential chain is a stronger representation that requires additional regularity and version conditions.

### S.1 Proofs for main text results
###### Proof of.
Write
$$

### S.2 Equivalent constructions above the anchor
Fix $r\in\mathbb{N}$ and let $f_{0}$ be an anchor process satisfying the regularity assumptions of the main construction. This subsection compares three equivalent ways to define the positive-index components $f_{1},\ldots,f_{r}$: the $t_{0}$ -based definite-integral construction used in the main text, a recursive construction through initial values, and a formulation based on indefinite antiderivatives.
The main-text construction defines the positive-index components by
$$

### S.3 Dependent integration constants and coupled differential ensembles
Use the notation and operator conventions of Section 2. Let $\mathfrak{f}:=(f_{-r},\ldots,f_{r})$ be defined from the anchor process $f_{0}$ as in Theorem 1, except that $\bm{\kappa}:=(\kappa_{1},\ldots,\kappa_{r})^{\top}$ may depend on $f_{0}$. We first derive covariance blocks for a valid jointly Gaussian pair $(f_{0},\bm{\kappa})$, then characterize admissibility, and finally give constructions that realize such pairs.
Write
$$

### S.4 Laplacian–Dirichlet eigenbasis implementation for the differential ensemble
This subsection records the Stan implementation used for the single-curve differential ensemble. The notation follows the main text. The non-marginalized model samples the finite-rank coefficients directly. The marginalized model integrates out those coefficients and reconstructs them in generated quantities.
Let $Y=(Y_{1},\ldots,Y_{n})^{\top}$ denote the anchor observations at times $t_{1},\ldots,t_{n}$, and let $y$ be the observed realization. Let $\tau_{1},\ldots,\tau_{G}$ be prediction locations. The computational domain is $[-L,L]$, with $t_{i},\tau_{g},t_{0}\in[-L,L]$. The retained eigensystem is the one used in Section 2.2,
$$

### S.5 TARTARE calibration procedure
Table S.1: Completed TARTARE calibration constants for the active default entries.
| Kernel | $r$ | $\mathcal{M}$ | $m$ | $c_{\mathcal{M}}$ |
| --- | --- | --- | --- | --- |

### S.6 Additional TARTARE simulation results
#### S.6.1 Posterior covariance diagnostics
Table S.2 compares posterior covariance errors for T-D2, with $\mathcal{M}=\{-2\}$, and T-all, with $\mathcal{M}=\{-2,-1,0,1,2\}$, using the same replicated datasets as Table 1. The diagnostics are whitened relative Frobenius errors against the exact-covariance posterior: $E_{\mathrm{joint}}$ for the stacked covariance, $E_{\mathrm{pair,max}}$ for the worst pairwise block, and $E_{\mathrm{var,max}}$ for marginal variances. Positive changes favor full-ensemble calibration.
Table S.2: Posterior covariance diagnostics comparing TARTARE calibration targeted at the second derivative (D2) with calibration targeted at the full second-order ensemble (Full). Completed columns give the number of accepted simulation replicates contributing to each diagnostic.


## Key insights
- We introduce anchored Gaussian process differential ensembles, embedding an anchor $f_{0}$ in a joint Gaussian state with its mean-square derivatives and repeated integrals.
- We introduce TARTARE, a target-aware calibration procedure for finite-rank differential ensemble approximations, to address derivative under-resolution by anchor-calibrated bases.
- The starting point is a Gaussian process $f_{0}$, called the anchor, because it is the component linked to the observation model.
- The integration constants are part of the statistical model.
- We therefore introduce TARTARE, Target-Aware Range and Truncation for Approximate Representations of Ensembles, as a practical calibration procedure for finite-rank implementations.
- We make positive-index integration constants explicit as finite-dimensional boundary information, separate their covariance from the anchor-induced kernel part, and show why anchor-only observations do not identify independent boundary constants.
- These constructions show that derivative and operator transformed quantities can be modeled jointly with an underlying Gaussian process.
- Section 2.2 develops the transformed HSGP approximation, approximation bounds, and finite-grid posterior convergence result.
- This decomposition is central throughout the paper, and it separates the kernel-driven functional part of the model from the statistically distinct uncertainty carried by the integration constants.
- The idea is to introduce a second Gaussian process $u_{0}$, coupled jointly with $f_{0}$, and use the boundary derivative values of $u_{0}$ as the integration constants for the ensemble built from $f_{0}$, $\kappa_{m}=D_{t}^{m-1}u_{0}(t_{0})$, $m=1,\ldots,r$.

## Exemplos e evidências
See original source at `Clippings/Gaussian Process Differential Ensembles for Joint Inference on Curves, Derivatives, and Integrals.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/neural-network]]
- [[03-RESOURCES/concepts/ai-agents/memory]]
- [[03-RESOURCES/concepts/software-engineering/specification]]
- [[03-RESOURCES/entities/AWS]]
