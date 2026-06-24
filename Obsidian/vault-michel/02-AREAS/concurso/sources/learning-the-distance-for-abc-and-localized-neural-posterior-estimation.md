---
title: "Learning the distance for ABC and localized neural posterior estimation"
type: source
source: "Clippings/Learning the distance for ABC and localized neural posterior estimation.md"
created: 2026-06-23
ingested: 2026-06-23
score: B
tags: [concurso, source-page]
---

## Tese central
Likelihood-free inference methods can perform Bayesian inference when evaluating the likelihood is impractical but simulating synthetic data from the model is feasible. Approximate Bayesian computation (ABC) is a well-established likelihood-free approach that constructs particle posterior approximations by evaluating the similarity between simulated and observed data using a distance function, which is used in rejection or weighting steps. Here we extend previous work on adaptive distance learni

## Argumentos principais
### 1 Introduction
Likelihood-free inference (LFI), also called simulation-based inference (SBI), uses model simulation to perform Bayesian inference in models where likelihood computation is impractical, but it is possible to simulate synthetic data from the model. A well-established likelihood-free approach is approximate Bayesian computation (ABC), which requires specification of a distance function, with distances between synthetic and observed data being used in rejection and weighting steps for constructing particle posterior approximations. Here we consider misspecified time series models, and attempt to learn an ABC distance using Bayesian optimization to improve forecasting performance for predictive distributions constructed from the ABC posterior. We target good forecasting performance out-of-sample, with this being assessed using a scoring rule appropriate for the problem. In addition to learning the distance in standard ABC, we also consider learning a distance to improve forecasting performance for neural posterior estimation with prior-fitted networks (NPE-PFN) [^61] with an ABC-like localization step. Related preconditioned neural posterior estimation approaches have been considered for misspecified simulators by [^35], but not in the context of time series forecasting.
In this work we consider methods based on summary statistics for the data, where the full data is projected into a lower-dimensional space before further analysis. The ABC distance is then defined in summary statistic space, and is often a weighted Euclidean distance, where the weights on different summaries need to be specified. We make two main contributions. First, we demonstrate that optimizing distance weights in ABC using a chosen scoring rule can improve the quality of forecasts when evaluated in terms of the same scoring rule. Learning the weights enables downweighting irrelevant summaries and reducing the influence of summaries that are difficult to match due to misspecification. We further establish a connection between linear pooling for forecast combination and ABC with randomized distances, showing that empirical pooling weight estimation is a form of adaptive distance learning. Second, we extend these ABC methods to SBI methods based on tabular foundation models and prior-data fitted networks [^61]. Here, an ABC-type step provides a context set for in-context learning, and we demonstrate that learning distance weights in these algorithms similarly improves forecasting performance.
There is substantial previous work on distance learning in ABC. To the best of our knowledge, none of the existing work is in the context of forecasting misspecified time series. Simple methods for summary statistic scaling for ABC can be thought of as implementing distance learning, for which the summary statistic weights are often based on features of the summary statistic prior predictive distribution. These scaling methods have been enhanced in many directions. [^34] employ a genetic algorithm to estimate summary statistic weights using a fitness function that incorporates ABC point estimation quality. [^51] explored adjusting summary statistic scaling within iterative ABC algorithms such as population Monte Carlo. [^28] develop a learned ABC discrepancy based on classification accuracy, while [^29] propose selecting summary statistic weights to maximize posterior information gain. [^52] modify Prangle’s approach to incorporate outlier-robust distances, and [^53] simultaneously learn regression-based summary statistics and distances, considering weights on data points informed by the regression-based summaries. [^59] describe an innovative generalized Bayesian approach that addresses model misspecification issues. Building on earlier Bayesian optimization-based LFI methods inspired by ABC [^27], they consider additive discrepancies with terms for summary statistic blocks, scaling terms by minimum observed discrepancy values.

### 2 ABC and NPE-PFN
Before we discuss approximate Bayesian forecasting and adaptive distance learning, we introduce briefly the two LFI methods used in this work, ABC [^56] and the NPE-PFN method of [^61].

### 2.1 Approximate Bayesian computation
Suppose that there is a model with parameter $\theta$, data to be observed $y$ with a density $p(y|\theta)$, and observed data $y_{\text{obs}}$. We consider Bayesian inference with a prior density $\pi(\theta)$ for $\theta$. Let $S=S(y)$ be a mapping of $y$ into a lower-dimensional space of summary statistic values. The summary statistic is chosen to be informative about $\theta$, and ABC methods approximate the posterior density of $\theta$ given the observed summary statistic value, which is denoted $S_{\text{obs}}=S(y_{\text{obs}})$.
A widely-used rejection ABC method is given in Algorithm 1. It repeatedly generates synthetic summary statistic values from the Bayesian model, until one of these is within a tolerance distance $h$ of the observed summary, upon which the corresponding parameter value is returned as an approximate posterior draw. A variant on this, given in Algorithm 2, draws $N$ parameter and summary statistic pairs from the Bayesian model in a batch, and then chooses a quantile of distances from the synthetic summaries to the observed value as the tolerance, to ensure a certain acceptance rate in the algorithm.
Algorithm 1 Rejection ABC algorithm

### 2.2 Neural posterior estimation with prior-data fitted networks
[^61] consider neural posterior density estimation with prior-data fitted networks (NPE-PFN) for performing SBI, which is implemented using the tabular foundation model TabPFNv2 [^30]. Hereafter references to TabPFN mean TabPFNv2. TabPFN allows estimation of a predictive distribution in problems of the following kind. Suppose there is a tabular dataset consisting of response and feature vector pairs ${\cal D}=\{(y_{i},x_{i});i=1,\dots,n\}$, where the responses can be real-valued (in regression problems) or class labels (for classification problems). We are interested in generating a predictive density for a target feature vector $x_{0}$ (or a set of such target feature vectors) given the training data. TabPFN approximates the predictive distribution for the response at the test feature vectors directly. We pass the pair $({\cal D},x_{0})$ (the context) to TabPFN, which returns a predictive distribution for $y_{0}$. TabPFN is an acronym for “tabular prior-data fitted network” and here prior-data fitted means that no training is done involving the context data. Similar in-context learning (ICL) methods are used widely in modern machine learning, with large language models (LLMs) a common example. TabPFN can be thought of as doing approximate Bayesian inference based on a very flexible class of models. It is pre-trained using a large number of synthetic datasets (over 100 million). The synthetic data are generated using structural causal models (see, for example, [^49]), which are specified through a graph and possibly nonlinear functions defined at the nodes specifying dependence on parents in the graph and noise. The synthetic datasets have different numbers of data points and features. A transformer model [^60] is used to define a mapping of a particular dataset and set of test feature vectors to predictive distributions for the label at the test features, with a cross-validatory criterion using a logarithmic scoring rule optimized in training. The standard approach also considers transformations of the features as well as various post-processing adjustments, and has the capacity to deal with missing features and outliers in the features and labels. For a good high-level overview of the basic ideas for statisticians see [^68]; these authors also document the impressive performance of the approach as an off-the-shelf predictive tool in several applications. Further technical details can be found in [^30], where it is claimed that the method “yields dominant performance for datasets with up to 10,000 samples and 500 features”. A recent development is the release of TabPFN-2.5 [^26], the successor of TabPFNv2, where it is claimed that the superior performance of TabPFNv2 compared to other benchmarks extends to datasets with up to 50,000 samples and 2,000 features. In this work we focus on adaptive distance learning for the neural posterior estimation (NPE) approach of [^61], which is implemented using TabPFNv2.
The NPE-PFN approach of [^61] starts with a training set of prior parameter and data set pairs. Here we consider the use of summary statistics, so we have prior parameter and summary statistic pairs. So
$$

### 3 Approximate Bayesian forecasting
Our work builds on the approximate Bayesian forecasting (ABF) framework of [^18] and [^64], and we explain this next. Let $Y=\{Y_{t};t=1,2,\dots,\}$ be a time series. We write $Y_{\leq n}=(Y_{1},\dots,Y_{n})^{\top}$ for the first $n$ observations of $Y$. There is a model for $Y_{\leq n}$ with parameters $\theta$ and density $p(y_{\leq n}|\theta)$. The posterior density given $y_{\leq n}$ is
$$
\pi(\theta|y_{\leq n})\propto\pi(\theta)p(y_{\leq n}|\theta),

### Summary statistic choice for ABF and misspecified SSMs
A central idea of the loss-based approximate Bayesian forecasting approach of [^64] is to choose summary statistics with a particular measure of forecasting accuracy in mind. The measure of forecasting accuracy will be defined through a scoring rule, and we explain this first. Let $\mathcal{P}$ be a set of distributions, and $\mathcal{Y}$ a set of possible values for an observation. A scoring rule is a function $Q:\mathcal{P}\times\mathcal{Y}\rightarrow\mathbb{R}\cup\{-\infty,\infty\}$, where $Q(F,y)$ is the reward for forecasting the observation $y\in\mathcal{Y}$ by the distribution $F\in\mathcal{P}$. We follow the convention that a larger value is desirable (a positively-oriented scoring rule). [^23] give an extensive summary of the literature on scoring rules.
Consider a random observation $Y\sim P\in\mathcal{P}$, and write the expected score (which is assumed to be well-defined) by
$$

### 4 Adaptive distance learning
The approach of [^64] attempts to mitigate misspecification by considering a scoring rule relevant to the problem at hand, and then choosing summary statistics that are adapted to that rule. Here we instead suggest to learn an adaptive distance in ABC (or in NPE-PFN with localization) where distance weights are chosen to optimize forecasting performance.
In a correctly specified model, it is optimal to implement ABC algorithms to approximate the true posterior as closely as possible given the available computational resources. However, under misspecification, improved forecasting performance may result from choosing the weights in an ABC distance to discard information. ABC distance learning enables discarding irrelevant summaries, as well as discarding summaries that are hard to match.
We parametrize the ABC distance used in terms of weights $\omega=(\omega_{1},\dots,\omega_{J})^{\top}$, where $J$ is the summary statistic dimension. Write $\Omega$ for the diagonal matrix with diagonal elements $\omega$. Let $\Sigma$ be the covariance matrix of summary statistics $S$ drawn from the prior. For summary statistics $S$ and $S^{\prime}$, we consider a Mahalanobis distance,

### 4.1 Linear pooling as adaptive learning of a randomized distance
We now describe an interesting connection between adaptive learning of a (randomized) ABC distance, and combining predictive densities by linear opinion pooling [^58], so that learning weights in the opinion pool can be thought of as adaptive distance learning. Suppose that we have $K$ different possible choices of the summary statistics, $S^{(j)}$, $j=1,\dots,K$. The corresponding observed values are $S_{\text{obs}}^{(j)}=S^{(j)}(y_{\text{obs}})$. We use a distance $d^{(j)}(\cdot,\cdot)$ for the summary statistic $S^{(j)}$, and this distance is not learnt adaptively. For example, the distance might take the form of the Mahalanobis distance in (14) with $\Omega$ fixed at the identity matrix. For the $j$ th summary statistic vector we can construct a $1$ -step ahead predictive distribution $p^{(j)}(y_{n+1}\mid y_{\leq n})$:
$$
p^{(j)}(y_{n+1}\mid y_{\leq n})=\int p(y_{n+1}|y_{\leq n},\theta)\pi_{h_{j}}(\theta|S_{obs}^{(j)})\,d\theta,

### 5 Examples
We now examine the empirical performance of our approaches for simulated and real examples considered in [^64].

### 5.1 A stochastic volatility model
Our first example considers a stochastic volatility model of the form
$$
\displaystyle y_{t}

### 5.2 Real data example: stochastic volatility model with an intractable transition density
Next, we consider another example from [^64]. It considers forecasting for a real data set using a stochastic volatility model with an intractable transition density involving increments from a heavy-tailed $\alpha$ -stable distribution. Although computation of the $\alpha$ -stable distribution is intractable, it is possible to simulate from the model, so that likelihood-free methods are attractive for models involving the $\alpha$ -stable distribution [^48]. The model is defined as follows:
$$
\displaystyle y_{t}

### 6 Discussion
Adaptive distance learning in ABC has received considerable attention, but not in the context of optimizing forecasting performance for misspecified time series. Our work addresses this, showing that adaptive distance learning can improve forecasting performance under a chosen scoring rule, both for ABC and for TabPFN with localization. We have also framed the use of linear opinion pools as corresponding to a randomized choice of distance, connecting them to the pooled LFI posteriors of [^15]. The summary statistics of [^64], which are based on diverse scoring rules, provide an effective and natural way to specify the pool members combined for forecasting.
Interest in learning posterior distributions that maximize predictive performance in Bayesian models has increased recently, extending well beyond time series. Notable examples include predictive variational inference (PVI) and predictively-oriented (PrO) posteriors [^38] [^43], with [^38] extending the PVI approach to SBI applications. The PVI and PrO posterior distributions need not concentrate to a single point asymptotically under misspecification, and our adaptive distance posteriors share this property when the distance is optimized for forecasting. This is different to other generalized Bayesian approaches, and can be beneficial for prediction under misspecification, since concentration of the posterior to a point results in plug-in prediction using the wrong model, which could be undesirable. [^55] is a pioneering work on predictively-oriented Kalman filtering for non-linear time series, and further development of PVI posteriors for SBI, building on [^38], is an attractive direction for future work. While the posteriors obtained through distance learning alone have limited expressiveness, we believe distance learning can contribute to the development of more flexible Bayesian approaches for forecasting in misspecified time series.

### Acknowledgements
David Nott’s research was supported by the Ministry of Education, Singapore, under the Academic Research Fund Tier 2 (MOE-T2EP20123-0009). The authors thank Chaya Weerasinghe for sharing her code.
[^1]: Stochastic Gradient MCMC for Nonlinear State Space Models. Bayesian Analysis 20 (1), pp. 83 – 105. Cited by: §5.1.1.
[^2]: Particle Markov chain Monte Carlo methods. Journal of the Royal Statistical Society: Series B (Statistical Methodology) 72 (3), pp. 269–342. Cited by: §3.


## Key insights
- ###### Abstract

Likelihood-free inference methods can perform Bayesian inference when evaluating the likelihood is impractical but simulating synthetic data from the model is feasible.
- Keywords: Bayesian inference; forecasting; model misspecification; simulation-based inference.
- ## 1 Introduction

Likelihood-free inference (LFI), also called simulation-based inference (SBI), uses model simulation to perform Bayesian inference in models where likelihood computation is impractical, but it is possible to simulate synthetic data from the model.
- Here we consider misspecified time series models, and attempt to learn an ABC distance using Bayesian optimization to improve forecasting performance for predictive distributions constructed from the ABC posterior.
- In addition to learning the distance in standard ABC, we also consider learning a distance to improve forecasting performance for neural posterior estimation with prior-fitted networks (NPE-PFN) [^61] with an ABC-like localization step.
- First, we demonstrate that optimizing distance weights in ABC using a chosen scoring rule can improve the quality of forecasts when evaluated in terms of the same scoring rule.
- Here, an ABC-type step provides a context set for in-context learning, and we demonstrate that learning distance weights in these algorithms similarly improves forecasting performance.
- [^28] develop a learned ABC discrepancy based on classification accuracy, while [^29] propose selecting summary statistic weights to maximize posterior information gain.
- [^59] describe an innovative generalized Bayesian approach that addresses model misspecification issues.
- Since we consider learning the distance to improve forecasting for misspecified time series, our work is also related to a large and recently active literature on LFI methods under misspecification.

## Exemplos e evidências
See original source at `Clippings/Learning the distance for ABC and localized neural posterior estimation.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/ai-agents/benchmark]]
- [[03-RESOURCES/concepts/software-engineering/specification]]
- [[03-RESOURCES/entities/AWS]]
