---
title: "Logistic Gaussian process density regression: a generalized Bayesian approach"
type: source
source: "Clippings/Logistic Gaussian process density regression a generalized Bayesian approach.md"
created: 2026-06-23
ingested: 2026-06-23
score: D
tags: [concurso, source-page]
---

## Tese central
Density regression extends conventional parametric regression by allowing the entire distribution of the response to vary flexibly with covariates rather than just low-order moments. In the Bayesian setting, logistic Gaussian process (GP) priors have been widely used for density estimation and extend naturally to density regression. The prior can be centred on a base density model, with the nonparametric component providing an interpretable correction that is useful for model criticism.

## Argumentos principais
### 1 Introduction
Bayesian methods for density regression have developed substantially in recent years. Conventional parametric regression models, where only low-order moments are modelled as varying with covariates, may be inadequate to describe complex response-covariate relationships. Density regression overcomes this limitation by allowing the entire distribution to vary with covariates. We focus on density regression based on logistic Gaussian process (GP) priors and make three contributions.
First, logistic GP density regression methods lead to computational difficulties, since the likelihood terms contain observation-specific normalizing contants that are unknown and are typically computed using numerical integration. This makes these regression density estimation methods hard to scale to large datasets. We address this by developing a generalized Bayesian approach [^3] [^17] where the loss-likelihood is based on the Hyvärinen score. The Hyvärinen score can be computed from derivatives of the density with respect to the response, which does not require knowledge of the normalizing constant. A second contribution of our work is to develop a non-standard sparse inducing point approach for scalable variational inference within this generalized Bayesian formulation. Our third contribution is to demonstrate the scalability of our methods through several examples, including one large German weather dataset with over 150,000 observations. Our examples also demonstrate the value of the logistic GP approach for model criticism of a parametric regression model.
The logistic Gaussian process prior was first used for density estimation by [^21], and many authors have since developed it further in this setting, both technically and computationally, including [^19] [^20], [^32], [^26] and [^31] among many others. A closely related prior is the Gaussian process density sampler of [^24], with an improved MCMC implementation provided by [^7]. The work most relevant to ours is [^25]. The authors consider logistic Gaussian process density estimation where the base density is Gaussian. For the Gaussian process they use a random Fourier feature approximation, and this allows them to derive several estimates of the density in closed form. The connection with our work lies in their use of a loss function based on Fisher divergence in the estimation to avoid the computation of normalizing constants. Our approach has no restriction on the base density and considers density regression and not just density estimation.

### 2 Logistic GP density regression
We consider Gaussian process (GP) density regression in the formulation of [^30]. Let $x=(x_{1},\dots,x_{d})^{\top}$ be a $d$ -dimensional covariate and $y$ a scalar response. To define the density regression model of [^30] we begin by transforming $x$ to $w=S(x)=(S_{1}(x),\dots,S_{d}(x))$ in a compact domain. The definition of $S$ is example-dependent, and if $x_{j}$ already lies in a compact interval we may take $S_{j}(x)=x_{j}$. Specific choices of $S$ are discussed in our later examples. Next, we specify a base density model $g(y|x)$ for the response variable $y$ given $x$, with corresponding distribution function $G(y|x)$. Setting $z=G(y|x)$ maps $y$ to $z\in[0,1]$. Considering a functional parameter $f(\cdot)$ on the space of $(w^{\top},z)^{\top}$, the GP density regression model of [^30] is
$$
\displaystyle h(y|x,f)

### 3 Generalized Bayesian inference
One difficulty with working with the model (1) is the need to approximate the normalizing constant $c(x,f)=\int_{0}^{1}\exp(f(S(x),z))\,dz$ in computing the likelihood, which is a function of $x$. [^30] use MCMC for computation, and approximate the Gaussian process using a conditional expectation process given the values at a set of nodes, with normalizing constants computed using numerical integration. Using numerical integration on a grid for each observation likelihood term is slow and cumbersome, and here we suggest an alternative approach which does not require the normalizing constant, by using a generalized Bayesian approach with the Hyvärinen score [^15] as the loss function.
Suppose we have observed data $(x_{i},y_{i})$, $i=1,\dots,n$, where the $x_{i}$ are covariates and the $y_{i}$ are corresponding responses. Write $f_{z}(v)$ and $f_{zz}(v)$ for the first and second-order partial derivatives of $f(v)$ with respect to $z$. If $f(v)$ is a Gaussian process, then $(f(v),f_{z}(v),f_{zz}(v))^{\top}$ is a multivariate Gaussian process. In obvious notation we write $\Delta_{i,j}(v,v^{\prime})$, $i,j\in\{0,1,2\}$ for the covariance between the $i$ th order partial derivative of $f(\cdot)$ with respect to $z$ at $v$ and the $j$ th order partial derivative with respect to $z$ at $v^{\prime}$ (for example, $\Delta_{1,2}(v,v^{\prime})=\text{Cov}(f_{z}(v),f_{zz}(v^{\prime}))$). We will use $\Delta(v,v^{\prime})$ and $\Delta_{0,0}(v,v^{\prime})$ interchangeably. Let $w_{i}=S(x_{i})$, $z_{i}=G(y_{i}|x_{i})$ and $v_{i}=(w_{i}^{\top},z_{i})^{\top}$. We use the notation $f=(f(v_{1}),\dots,f(v_{n}))^{\top}$, $f_{z}=(f_{z}(v_{1}),\dots,f_{z}(v_{n}))^{\top}$ and $f_{zz}=(f_{zz}(v_{1}),\dots,f_{zz}(v_{n}))^{\top}$. Write $\hbar(y|x,f):=\log h(y|x,f)$ and define
$$

### 4 Variational approximation for scalable computation
To perform computations in a scalable way, we consider inducing variable methods (e.g. [^28]). [^6] consider inducing variable approaches to computation in latent Gaussian process models which do not require any special structure for the likelihood i.e. “black box” likelihoods. This is ideal for applications of Gaussian process models in generalized Bayesian inference. Inducing point approaches augment the observed inputs $v_{1},\dots,v_{n}$, with additional inducing inputs $\widetilde{v}_{1},\dots,\widetilde{v}_{m}$, and typically consider inducing values for $f$ at the inducing inputs. Here we consider inducing values for the derivative $f_{z}$ rather than $f$. We write $\widetilde{f}_{z}=(f_{z}(\widetilde{v}_{1}),\dots,f_{z}(\widetilde{v}_{m}))^{\top}$. In explaining the algorithm below the following notation will be used. Let $V$ be a matrix with $k$ th row $v_{k}$, $k=1,\dots,n$, and $\widetilde{V}$ be a matrix with $k$ th row $\widetilde{v}_{k}$, $k=1,\dots,m$. Write $\Delta_{i,j}(V,\widetilde{V})$ $i,j\in\{0,1,2\}$ for the $n\times m$ matrix with $(k,l)$ th entry $\Delta_{i,j}(v_{k},\widetilde{v}_{l})$. This notation is extended to other pairs of matrix inputs with rows in the space of $v$ by constructing matrices with $(k,l)$ th element evaluating $\Delta_{i,j}(\cdot,\cdot)$ at the $k$ th row of the first matrix argument and $l$ th element of the second matrix argument.
To allow scalable computation we will replace the inducing values $f_{zz}$ with an imputation of them, $\widehat{f}_{zz}=(\widehat{f}_{zz}(v_{1}),\dots,\widehat{f}_{zz}(v_{n}))^{\top}$, that solely depends on the variational approximation to $f_{z}$, and this is explained further below. Then we infer about $f_{z}$ using the augmented generalized posterior density including the inducing values,
$$

### 4.1 Computation of predictive densities
For predictive inference, suppose we want to plot an estimate of the predictive density of the response given $x=\breve{x}$ for some $\breve{x}$. Write $\breve{w}=S(\breve{x})$. We consider an equally spaced grid of points with grid spacing $\epsilon$ for $y$, $\breve{y}_{1}<\dots<\breve{y}_{M}$. Corresponding $z$ values $\breve{z}_{j}$ are defined as $G(\breve{y}_{j}|\breve{x})$, $j=1,\dots,M$, and we write $\breve{v}_{j}=(\breve{w}^{\top},\breve{z}_{j})^{\top}$. Write $\breve{V}$ for the matrix with $j$ th row $\breve{v}_{j}$, and $\breve{f}=(f(\breve{v}_{1}),\dots,f(\breve{v}_{M}))^{\top}$. Then an estimate $\overline{f}$ of $\breve{f}$ can be obtained by the conditional prior mean of $\breve{f}$ given $\widetilde{f}_{z}=E_{q}(\widetilde{f}_{z})$,
$$
\overline{f}\approx\Delta_{0,1}(\breve{V},\widetilde{V})\Delta_{1,1}(\widetilde{V},\widetilde{V})^{-1}\left(\sum_{k=1}^{C}\omega_{k}\mu_{k}\right).

### 5 Examples
This section illustrates our Gaussian process density regression (GPDR) approach on one simulated and two real datasets. Before presenting these examples, we discuss the choice of base measure $g(y|x)$ and how to interpret the nonparametric correction $f(\cdot)$ that GPDR provides. As noted in Section 2, when $f(\cdot)$ is identically zero, $h(y|x,f)=g(y|x)$, so $f(\cdot)$ represents the correction that the nonparametric model applies to the base measure. Specifically, rearranging (1), we have
$$
\displaystyle\log h(y|x,f)=\log g(y|x)+f(S(x),G(y|x))+C(x,f),

### 5.1 Simulations
As a first example, we consider a deliberately misspecified regression model. Data $(y_{i},x_{i})$, $i=1,\dots,n$, is generated as
$$
\displaystyle x

### 5.2 Spatio-temporal weather dynamics
The German Weather Service (Deutscher Wetterdienst; DWD) provides meteorological measurements from a large number of weather stations across Germany. Here, we analyze the daily maximum temperature observed at a total of 463 stations in 2020 constituting a large data set with a total of $n=167,762$ observations of which we use a random subset of $n_{\text{train}}=150,985$ observations for training and the remaining $n_{\text{test}}=16,777$ observations for model evaluation. Training a Gaussian process on a dataset of this size is challenging, and this example illustrates how the inducing point approach allows for scalability of GPDR.
For observation $i=1,\dots,n$, let $y_{i}$ denote the maximum temperature, $\texttt{day}_{i}$ the day of the year, and $(\texttt{longitude}_{i},\texttt{latitude}_{i})$ the coordinates of the corresponding weather station, so that $x_{i}=(\texttt{day}_{i},\texttt{longitude}_{i},\texttt{latitude}_{i})^{\top}$ denotes the covariate vector. To understand the spatio-temporal dynamics, we consider an additive model
$$

### 5.3 Gini data
Finally, we illustrate GPDR for correcting a non-Gaussian parametric model. The Gini index is a widely used economic measure of income inequality within a country [^11]. It takes values in $[0,1]$, where 0 indicates perfect equality and 1 indicates maximal inequality. We analyze a country-year panel constructed from the World Bank’s *World Development Indicators*, accessed via the R package WDI [^2]. The dataset covers 152 countries over the period 1991–2024. Some countries do not have records for the full 34-year span resulting in $n=2,093$ observations with training data $n_{train}=1883$ and test data $n_{test}=210$.
To understand how other socioeconomic indicators are related to the Gini index, we consider a total of 5 covariates including the log gross domestic product per capita log\_gdp, the proportion of urban population urban, the unemployment rate unemp, the trade openness (in %) trade and year of recording year. Estimating non-parametric conditional densities is challenging here due to the relatively small sample size compared with the number of covariates and the bounded, non-Gaussian nature of the response.
We use a beta regression model [^10] [^4] as a parametric regression model for the data. In particular $y_{i}|x_{i}\sim\operatorname{Beta}(\mu_{i}\phi,(1-\mu_{i})\phi)$, where the mean is linked to a linear predictor via a logit transformation, $\operatorname{logit}(\mu_{i})=\beta_{0}+x_{i}^{\top}\beta$, and $\phi>0$ is a precision parameter, so that $g_{0}(y|x)$ is a beta distribution. The parametric model is trained via maximum likelihood estimation. As a more diffuse version of the parametric density $g_{0}(y|x)$ to use as the base model density $g(y|x)$ for GPDR we consider $\operatorname{Beta}(\mu_{i}\phi/2,(1-\mu_{i})\phi/2)$.

### 6 Discussion
This paper introduced a generalized Bayesian formulation for logistic Gaussian process density regression that replaces the intractable likelihood with a loss likelihood based on the Hyvärinen score. This loss likelihood uses only derivatives of the log-density with respect to the response, eliminating observation-specific normalizing constants that make conventional Bayesian inference for logistic GP density regression difficult. We further developed a scalable inference scheme that combines sparse inducing points with a structured variational approximation, enabling practical application on large datasets. We demonstrated improved predictive fit and calibration across three examples: a misspecified Gaussian regression model, a large spatio-temporal German weather dataset, and a bounded-response Gini index dataset with a beta regression base model. In each case, the GP correction provided interpretable model criticism, revealing how a parametric regression used to determine the base model was misspecified.
Our GPDR approach can model complex response-covariate relationships as it is not restricted by a parametric form while retaining interpretability through centering the GP prior on a parametric regression model. The GP correction acts as a transparent, data-driven adjustment revealing how an initial parametric regression is misspecified, which can be used to guide model improvement. As illustrated by the Gini data example, our approach can be used with non-Gaussian base models. Together, the inducing-point variational approach and the generalized Bayes formulation with the Hyvärinen score scaled successfully to a dataset with over 150,000 observations.
While GPDR performed well across all examples considered, establishing theoretical guarantees for Hyvärinen score generalized posteriors in logistic GP density regression would be valuable. Extensions to high-dimensional covariates via subspace projections as in [^30], and to multivariate responses, are promising directions for future work.

### Acknowledgements
David Nott’s research was supported by the Ministry of Education, Singapore, under the Academic Research Fund Tier 2 (MOE-T2EP20123-0009).

### Appendix A Expression for terms in ℋ(yi,xi,f.i)\\mathcal{H}(y\_{i},x\_{i},f\_{.i})
Since $\hbar(y|x,f)=\log g(y|x)+f(S(x),G(y|x))-c(x,f)$, where $c(x,f)=\int_{0}^{1}\exp(f(S(x),z))\,dz$, we have
$$
\displaystyle\hbar_{y}(y|x,f)

### Appendix B Upper Bound of the KL Divergence Term
In the optimization objective defined in (8), the KL-divergence term involves a Gaussian mixture variational posterior. In our implementation, this term is evaluated using an upper bound in an analytically tractable expression that facilitates efficient optimization.
Let the variational posterior be given by
$$

### Appendix C Hyperparameter selection
The implementation of GPDR requires the choice of several hyperparameters, including the covariance scale and lengthscale parameters in the Gaussian process prior, the learning weight $\beta$ in the generalized Bayesian update, the number of inducing points, and the number of Gaussian mixture components in the variational approximation. Recall from Section 2 that the Gaussian process covariance is written as
$$
\Delta(v,v^{\prime})=\sigma_{f}^{2}\exp\left(-\sum_{j=1}^{d}\theta_{cj}^{2}(w_{j}-w_{j}^{\prime})^{2}-\theta_{r}(z-z^{\prime})^{2}\right),

### Appendix D Additional results for the spatial-temporal weather dynamics
Figure 8 presents the estimated spatio-temporal effects from the fitted base model in the weather data example described in Section 5.2. The base model is an overdispersed and heavy-tailed variant of a generalized additive model (GAM) that decomposes temperature predictions into additive components: an intercept, a temporal effect $\mathfrak{f}_{\text{temp}}(\texttt{day})$, and a spatial effect $\mathfrak{f}_{\text{spat}}(\texttt{longitude},\texttt{latitude})$. The plots in the figure visualize the corresponding partial dependence functions for the GAM. Panel 8(a) shows how the model’s temperature predictions vary over time (dates), averaged across all spatial locations. It is obtained from the GAM partial dependence function for the temporal covariate and reflects systematic temporal variation such as seasonal cycles over the observation period. Panel 8(b) displays the spatial temperature effect across Germany after standardization. This is computed from the tensor product smooth $te(lon,lat)$ in the GAM, evaluated on a grid and masked to the country’s boundaries. The diverging color map (blue–red, centered at zero) highlights regions that are systematically cooler (blue) or warmer (red) than average, independently of temporal effects, capturing geographic patterns such as elevation, proximity to water bodies, and urban heat islands.
Both plots use standardized temperature values (scaled to $[0,1]$) to improve numerical stability during model fitting.
(a) Temporal effect


## Key insights
- The prior can be centred on a base density model, with the nonparametric component providing an interpretable correction that is useful for model criticism.
- We demonstrate the method on one simulated and two real datasets, including a German weather dataset with more than 150,000 observations.
- Our third contribution is to demonstrate the scalability of our methods through several examples, including one large German weather dataset with over 150,000 observations.
- Our examples also demonstrate the value of the logistic GP approach for model criticism of a parametric regression model.
- The logistic Gaussian process density regression model used here builds on the approach of [^30].
- They considered subspace projection in conjunction with their density regression model to handle high-dimensional covariates.
- The model of [^30] develops further earlier work in [^31] on density estimation: both papers use a similar compactification of the Gaussian process domain via transformation and a low-rank approximation of the Gaussian process for computational tractability.
- An alternative approach to density regression with GPs is given by [^18], where the model transforms latent uniform variables and the covariates while incorporating an additive error term to define a flexible distribution for the response.
- The prior can be centred on a parametric base model, similar to the logistic GP approach of [^30].
- With high-dimensional covariates, their model can be used in a latent factor formulation to achieve dimension reduction.

## Exemplos e evidências
See original source at `Clippings/Logistic Gaussian process density regression a generalized Bayesian approach.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/inference]]
- [[03-RESOURCES/concepts/software-engineering/specification]]
- [[03-RESOURCES/concepts/llm-ml-foundations/rag.md]]
- [[03-RESOURCES/entities/Python]]
