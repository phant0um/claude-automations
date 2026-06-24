---
title: "Solve for the Hyperparameter, Skip the Search: Kolmogorov-Optimal Scaling Laws for Spline Regression"
type: source
source: "Clippings/Solve for the Hyperparameter, Skip the Search Kolmogorov-Optimal Scaling Laws for Spline Regression.md"
created: 2026-06-23
ingested: 2026-06-23
score: C
tags: [concurso, source-page]
---

## Tese central
Hyperparameter tuning almost always means search: fit the model at every value on a grid, score each by cross-validation, and keep the winner. For spline regression that search is unnecessary. The optimal resolution can be *solved for* in closed form, to the accuracy an exhaustive search would reach and at a fraction of the compute.

## Argumentos principais
### 1 Introduction
Hyperparameter selection is usually done by search: a model is trained at every candidate setting, validation error is recorded, and the best score wins. Cross-validation, the canonical realization of that workflow, is reliable but uninformative; it treats every hyperparameter as an opaque knob and offers no closed-form guidance for which values are worth trying or why one value beats its neighbors. The compute cost scales with the size of the grid multiplied by the number of folds and grows with every new model family. An attractive alternative is to *solve* for the optimal hyperparameter directly, in the same sense that the minimum of a known function is found by calculus rather than by tabulation.
#### Why spline regression.
Solving rather than searching requires a model class where prediction error has an analytically tractable dependence on the hyperparameter of interest. Three ingredients are needed: (i) an approximation theory that specifies how bias scales with the hyperparameter, (ii) an explicit formula for the number of free parameters, which controls variance, and (iii) a closed-form estimate of prediction error, so the bias-variance curve can be pinned down from a small number of fits rather than from an exhaustive grid. Spline regression is the natural home for this program. Classical B-spline approximation theory gives precise bias rates as a power of the knot resolution $G$ [^2] [^40]; these rates are exactly the Kolmogorov $n$ -widths of the smoothness class, so among all linear methods of the same size the spline family is approximation-optimal [^43] [^31] [^18]. The basis dimension is an explicit, countable polynomial in $G$. Because a spline fit is a linear smoother, exact leave-one-out error is available at $O(1)$ per point through the PRESS identity [^11] with no refitting. Together, these three properties express the entire bias-variance curve as a closed-form function of a single integer, and they make solving for the minimum a calculus problem rather than a search problem.

### 2 From bias-variance to search-free resolution laws
The title of the paper asks for more than a faster heuristic. It asks when a hyperparameter can be treated as a *statistical estimand*: a quantity determined by the training distribution, the model family, and the sample size, rather than by a blind validation sweep. For spline regression, the estimand is the resolution
$$
G_{f}^{\bullet}\;:=\;\operatorname*{arg\,min}_{G\in\mathcal{G}_{f}^{\mathrm{stab}}}\Bigl\{\mathrm{Err}_{f}(G)-\sigma^{2}\Bigr\},

### 2.1 Structured spline families
The data are independent training samples $(x_{i},y_{i})$ with $x_{i}\in[0,1]^{d}$ and
$$
y_{i}=f(x_{i})+\varepsilon_{i},\qquad\mathbb{E}[\varepsilon_{i}\mid x_{i}]=0,\qquad\mathbb{E}[\varepsilon_{i}^{2}\mid x_{i}]=\sigma^{2}.

### 2.2 The risk curve
Let $\mathcal{S}_{r}(G)$ be the structured spline space with dimension $p_{r}(G)$, and let $\hat{f}_{G}$ be the ridge-stabilized least-squares fit in that space, with ridge small enough that it only regularizes the linear solve. The expected test MSE is
$$
\mathrm{Err}(G)=\mathbb{E}_{(X,Y),\mathcal{D}}\!\left[(Y-\hat{f}_{G}(X))^{2}\right].

### 2.3 The closed-form optimizer
For the moment, treat $G$ as a positive real number. The continuous excess-risk proxy from Proposition 1 is
$$
R_{r}(G;A,B)=A\,G^{-2\beta}+B\,\frac{1+\sum_{t=1}^{r}s_{t}\,m(G)^{t}}{n}.

### 3 The KORE algorithm
Section 2 turns resolution selection into a two-constant estimation problem. For a fixed family $f$, the excess-risk curve has the form
$$
R_{f}(G)=A_{f}G^{-2\beta}+B_{f}\,\nu_{f}(G),\qquad\nu_{f}(G):=\frac{p_{f}(G)}{n},

### 4 Experiments
The experimental program tests six empirical claims, each addressing a question a rigorous reader would ask. (i) Section 4.2 verifies the effective-density collapse on controlled additive and sparse pairwise families across four dimensions and a factor-of-twenty-four sweep in $\rho$. (ii) Section 4.4 compares KORE against the full classical selection ladder of $3$ -fold CV, GCV, Mallows’ $C_{p}$, AIC, and BIC on a six-task frontier. (iii) Section 4.5 runs the same ladder on nine named benchmark equations drawn from the nonparametric-regression literature. (iv) Section 4.6 reports the three boundary benchmarks where a single global resolution stops being a faithful inductive bias. (v) Section 4.7 validates a run-time diagnostic that separates the signal-rich regime from the noise-dominated regime on an independent noise sweep. (vi) Section 4.3 checks the search-free plug-in guarantee of Theorem 2 numerically across a geometric sample-size ladder.
Section 4.1 fixes the estimands and baselines that every experiment shares. The complete reproduction recipe, including the master seed, fold recursion, exact target equations, benchmark suite, and every fixed numerical constant, is collected in Appendix B; nothing beyond that appendix is required to reproduce any number reported here.

### 4.1 Estimands, baselines, and the quantities every experiment measures
All experiments use the same cubic B-spline families ($k=3$), the same additive candidate grid $\mathcal{G}_{\mathrm{add}}=\{1,\dots,20\}$, the same sparse pairwise grid $\mathcal{G}_{\mathrm{pair}}=\{1,\dots,10\}$, and a ridge of $10^{-8}$ on every normal equation. Methods differ only in how they select the resolution.
#### Basis dimensions.
The additive basis is built from one cubic B-spline block per coordinate with bias retained and $d-1$ redundant constants dropped, giving

### 4.2 Selected resolution and test error collapse by effective density
Figure 2: Effective-density collapse. The horizontal axis is ρ \\rho; the vertical axis is test RMSE at the KORE -selected G ⋆ G^{\\star}. Panel (a) shows additive targets with = n / d \\rho=n/d and reference slope − 4 9 \\rho^{-4/9}. Panel (b) shows sparse pairwise targets with s \\rho=n/s 10 \\rho^{-4/10}. The four dimensions ∈ {, 20 40 80 } d\\in\\{10,20,40,80\\} collapse onto a single curve.
#### Setup.
Corollary 1 predicts that once $\rho$ is fixed, the input dimension $d$ carries no extra information about the optimal resolution or the resulting test error. The collapse experiment tests that prediction directly on the exact additive and sparse pairwise target families $f_{\mathrm{add}}$ and $f_{\mathrm{pair}}$ defined in Appendix B. Additive targets sweep $\rho=n/d$ over $\{30,45,60,90,120,180,240,360,480,720\}$ at each of $d\in\{10,20,40,80\}$, subject to $n=\rho d\leq 60{,}000$. Sparse pairwise targets sweep $\rho=n/s$ over $\{60,90,120,180,240,360,480,720\}$ at the same four dimensions with $s=d/2$ active pairs, subject to $n=\rho s\leq 60{,}000$. Every cell uses the seed rule of Table 5, $3\%$ training noise, and a $2{,}000$ -point noise-free test set. In each cell, KORE selects $G^{\star}$, the structured spline is fit once at that resolution, and the resulting test RMSE is plotted against $\rho$.

### 4.3 Plug-in consistency of the closed-form selector
Figure 3: Bias-scale recovery as predicted by Theorem 2: median and interquartile band of the ratio A ^ f / \\widehat{A}\_{f}/A\_{f} versus sample size n along a geometric ladder, with the population value 1 marked.
Figure 4: Noise-scale recovery as predicted by Theorem 2: median and interquartile band of τ ^ f / \\widehat{\\tau}\_{f}/\\tau\_{f} versus sample size n along the same geometric ladder, with the population value 1 marked.
Figure 5: Plug-in continuous optimizer G ^ f † \\widehat{G}\_{f}^{\\dagger} versus the anchored population target ∙ G\_{f}^{\\bullet} along the sample-size ladder. Shaded band: ± 1 σ \\pm 1\\sigma across 20 seeds; the diamond marker is the anchored target at the largest n.

### 4.4 Closed-form selection on the accuracy-compute frontier
Figure 6: Selection cost across six controlled tasks (three additive, three sparse pairwise). Markers report the number of model fits used by KORE, the four full-grid criteria (GCV, C p C\_{p}, AIC, BIC), and exhaustive 3 -fold cross-validation.
Figure 7: Per-task accuracy parity on the same six tasks: ratio of KORE test RMSE to exhaustive 3 -fold cross-validation, sorted by family. Bars at or below 1.0 favor the closed-form selector.
Figure 8: Geometric-mean RMSE ratio versus exhaustive cross-validation, aggregated across all six controlled tasks, for the five selectors compared in this section. Bars to the left of 1.0 match or beat exhaustive search.

### 4.5 Law-aligned benchmark equations
Figure 9: Nine law-aligned benchmark equations. Panel (a) gives the per-task RMSE ratio of KORE against 3 -fold CV. Panel (b) gives the corresponding fit-count reduction (CV fits divided by fits). Panel (c) gives the geometric-mean RMSE ratio against CV across the nine tasks for the five selectors.
#### Setup.
The frontier tasks were constructed to satisfy the law tightly. The benchmark suite asks the more demanding question of whether the same advantage holds on named equations from the nonparametric-regression literature. Appendix Table 7 lists the full twelve-equation suite. This subsection isolates the nine equations whose dominant structure is smooth and low-order, the regime the theory claims to cover: Nguyen-1, Nguyen-4, Nguyen-5, Nguyen-7, Nguyen-9 (2D add), Nguyen-10 (2D int), Friedman-1 (5D), SparseAdd-20D, and SparsePair-10D. All nine are run with $1\%$ training noise and $3{,}000$ test points using the protocol of Table 5.

### 4.6 Boundary cases and scope of the single-resolution law
Figure 10: Forest plot of mean test RMSE per benchmark across the full 12 -equation suite, ranked by KORE / CV ratio. Markers compare KORE (closed-form), exhaustive 3 -fold cross-validation, and GCV. Raw RMSE ratios are tabulated in Table 2.
#### Setup.
The full benchmark suite is reported in the main text rather than partitioned across the paper and the appendix. The three additional tasks are Franke (localized two-dimensional surface structure), Friedman-2 (strongly coupled rational dependence), and the Oscillator (rapidly oscillating one-dimensional signal). These are not random hard cases chosen after the fact. They are precisely the kinds of functions one would expect to challenge a selector built around a single global resolution and low-order smooth structure.

### 4.7 Practical guidance: an empirical safety check
#### Setup.
KORE is designed for problems whose response is a smooth function of its inputs and depends on them through low-order structure, either additively or through a sparse set of pairwise interactions. A practitioner needs a cheap check that the current dataset lies in that regime. The procedure already computes such a check during refinement and this subsection validates it. The first component is a local shape check: does the leave-one-out curve rise on both sides of the selected resolution, confirming the expected U-shape? The second is a signal score, defined as the leave-one-out improvement of the structured fit over an intercept-only model divided by the standard error of that difference. This is a practical guardrail, not a second theorem layered on top of the scaling law. Both quantities are tested on an additive target in $d=10$ with $n=200$, sweeping the noise level over $\{5\%,\,10\%,\,25\%,\,50\%,\,100\%,\,200\%\}$ of the signal standard deviation, averaged over five seeds. Table 3 reports the signal score, that is, how many standard errors the structured fit improves over the predict-the-mean baseline, alongside the test RMSE ratio of KORE to that baseline.
#### Theory prediction.

### 4.8 Real-world validation against a twenty-one-method baseline roster
#### Setup.
The synthetic experiments answer questions about the scaling law and the closed-form selector. The remaining question is whether KORE survives the kind of tuned-baseline comparison introduced by [^42] on real tabular regression data. The benchmark suite is the OpenML-CTR23 curated tabular regression collection [^32], all $35$ datasets, augmented with the Combined Cycle Power Plant dataset [^34] which is a long-standing GAM-literature classic that does not appear in CTR23. The other UCI classics that the GAM literature has used since the 1990s (Concrete, Airfoil, Wine quality red and white, California Housing, Energy Efficiency, Forest Fires, Naval Propulsion) are already in CTR23, so deduplication leaves $36$ unique datasets. The pre-registered *smooth-low-d subset* restricts to entries with at most $30$ features after one-hot encoding, the regime the bias-variance theory of Section 2 is calibrated for.
The method roster is twenty-one baselines, organized by family. The linear family contains ordinary least squares, ridge, lasso, and elastic-net, each with its standard cross-validated penalty grid. The spline family contains KORE, exhaustive cross-validation over the resolution grid, the four classical information criteria (GCV, Mallows $C_{p}$, AIC, BIC), and the third-party pyGAM implementation [^22] run with its own internal generalized-cross-validation lambda search. The tree-based family contains random forests, extra-trees, sklearn HistGradientBoosting, XGBoost, LightGBM, and CatBoost. The kernel family contains support-vector regression and kernel ridge, both with the radial basis function. Nearest neighbours and a small multilayer perceptron round out the comparison. Hyperparameter ranges for the tree-based, kernel, neighbour, and neural baselines are taken verbatim from [^42] Appendix B. All tunable methods use $20$ Bayesian-optimization trials with $3$ -fold internal cross-validation per trial, executed by the Optuna sampler. Each cell is capped at four minutes of wall time; cells that exceed the cap are recorded as missing and excluded from the corresponding aggregate. The outer evaluation is five $80/20$ train-test splits with seeds fixed across methods so every comparison sees identical data.


## Key insights
- $\sigma^{2}$ is the irreducible noise in the data, which no model can remove;
- $G$ is the resolution, the number of knot intervals per coordinate;
- $\beta$ is the smoothness exponent of the target function, set by the spline degree $k$;
- $p(G)$ is the basis size, the number of spline basis functions at resolution $G$;
- $n$ is the sample size;
- $A>0$ is the bias scale and $\tau>0$ is the noise/variance scale.
- Law collapse: (1, family flag, $d$, $\rho$, $s$), with family flag = 0 for additive and 1 for sparse pairwise.
- Frontier: (2, family flag, $d$, $\rho$, $s$), with the same family-flag convention.
- Benchmarks: (3, benchmark id, $s$), where benchmark id is the deterministic DJB2-style integer derived from the benchmark name in the code.
- Discovery: $(4,\ d,\ n_{\text{per-pair}},\ s)$.

## Exemplos e evidências
See original source at `Clippings/Solve for the Hyperparameter, Skip the Search Kolmogorov-Optimal Scaling Laws for Spline Regression.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/benchmark]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/concepts/llm-ml-foundations/inference]]
- [[03-RESOURCES/entities/AWS]]
- [[03-RESOURCES/entities/Rust]]
- [[03-RESOURCES/entities/Python]]
