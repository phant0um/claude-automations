---
title: "Stochastic Volatility in Mean Models with Heavy Tails: A Fast Approximate Bayesian Inference Using Hidden Markov Models"
type: source
source: "Clippings/Stochastic Volatility in Mean Models with Heavy Tails A Fast Approximate Bayesian Inference Using Hidden Markov Models.md"
created: 2026-06-23
ingested: 2026-06-23
score: B
tags: [concurso, source-page]
---

## Tese central
This paper extends the approximate Bayesian estimation framework for Stochastic Volatility in Mean (SVM) models to accommodate heavy-tailed distributions from the Scale Mixture of Normals (SMN) family. To overcome the computational challenges arising from these models, we propose a numerically stable estimation procedure that exploits special functions to eliminate the need for direct numerical integration. Furthermore, the implementation incorporates parallel computing strategies that substanti

## Argumentos principais
### 1 Introduction
Stochastic volatility (SV) models play a central role in the econometric analysis of financial time series, particularly in markets characterized by persistent and substantial uncertainty. Since the seminal work of [^22], these models have provided a flexible and theoretically grounded framework for describing the dynamic evolution of volatility. Such a representation is essential for effective decision-making by both policymakers and market participants. Moreover, SV models are firmly rooted in the principles of financial economics [^20] and have proved capable of reproducing important stylized features of financial return data, including volatility clustering and leptokurtosis [^4].
Volatility asymmetry is a well-documented characteristic of financial time series, whereby the impact of shocks on volatility depends on the direction of returns. In particular, negative shocks tend to generate substantially larger increases in volatility than positive shocks of the same magnitude. One of the principal theoretical explanations for this phenomenon is the volatility feedback theory proposed in [^10].
Since their original formulation, SV models have been extended in several directions to better capture the empirical dynamics of financial markets. In particular, they have been widely employed to investigate asymmetric volatility behavior and to model the dynamics of daily stock return volatility. Early implementations of SV models, however, often required extensive pre-modeling procedures in which the conditional mean and conditional variance were estimated separately. To overcome the limitations of this two-step estimation approach, [^13] introduced the stochastic volatility-in-mean (SVM) specification, in which volatility is incorporated as a regressor in the conditional mean equation for returns. This formulation was designed to capture the volatility feedback effect. Furthermore, [^2] extended the SVM framework by assuming that the observational errors follow the scale mixture of normal (SMN) family, thereby accommodating heavy-tailed distributions. Such departures from normality in financial returns are well documented in the literature [^19] [^18] [^5] [^12].

### 2 Scale Mixture of Normals Distributions
The SMN framework provides a flexible class of models for a wide range of symmetric and unimodal distributions, particularly those exhibiting heavier tails than the normal distribution. As defined in [^15] and [^6], a random variable $Y$ is said to belong to the SMN family if it admits the stochastic representation
$$
Y=\mu+\lambda^{-1/2}Z,

### 3 The Stochastic Volatility in Mean (SVM) Model
The SVM model provides a convenient framework for studying the interaction between financial returns and time-varying volatility by explicitly incorporating volatility into the conditional mean equation. The model is specified as
$$
\displaystyle y_{t}

### 3.1 Likelihood evaluation
Let $\mathbf{y}_{T}=(y_{1},\dots,y_{T})$ and $\mathbf{h}_{T}=(h_{1},\dots,h_{T})$ denote, respectively, the observed returns and the latent log-volatility process in the SVM model defined by equations (2a) and (2b). For a parameter vector $\theta$, the likelihood function is given by
$$
\displaystyle\mathcal{L}(\mbox{$\theta$})

### 3.2 Bayesian Inference for the SVM model
To complete the Bayesian specification of the model, prior distributions must be assigned to the parameters. However, some parameters of the SVM model are constrained, namely
$$
|\beta_{1}|<1,\qquad|\phi|<1,\qquad\sigma_{\eta}>0.

### 4 Simulation Study
We now illustrate the methodology described in Sections 3.1 and 3.2. The objectives of this simulation study are twofold. First, we investigate the finite-sample performance of the proposed approximate Bayesian procedure in terms of parameter recovery and uncertainty quantification. Second, we assess the numerical stability of the HMM approximation by examining the effect of the number of discretization points, $m$, on the resulting posterior summaries and computational cost. In particular, we seek to identify values of $m$ for which the approximation becomes sufficiently stable while maintaining the computational advantages of the proposed methodology.
The computational implementation was developed using the Rcpp and RcppArmadillo packages, which provide an efficient interface between R and C++. From equation (2a), the conditional densities
$$

### 5 Real Data Application
In this section, we analyze the daily returns of four of the world’s main indices: S&P 500 (EUA), NIKKEI 225 (Japan), DAX 30 (Germany) and IBOVESPA (Brazil). Data were obtained from Yahoo Finance ([)) considering the period from January 1, 2002, until April 6, 2022. Returns are computed as compounded percentage returns, defined as $y_{t}=100\times(\log P_{t}-\log P_{t-1})$, where $P_{t}$ denotes the (adjusted) closing price on day $t$, for $t=1,\dots,T$. Table 7 shows the statistics of the observations considered for adjustment.
Table 7: Summary statistics of the return indexes.
| Index | T | Mean | SD | Min. | Max. | Skewness | Kurtosis |

### 5.1 Out-of-sample Analysis
Finally, we conduct an out-of-sample analysis to evaluate the forecasting performance of the SVM models considered, following the procedure described in the Supplementary Material. The validation period spans from April 7, 2022, to January 1, 2025. The Jarque–Bera (JB) and Ljung–Box (LB) tests were applied to the one-step-ahead forecast pseudo-residuals obtained for the different indices and SVM specifications, in order to assess, respectively, the assumptions of normality and serial independence. The corresponding p-values are reported in Table 12.
Table 12: The p-values of Jarque-Bera (JB) and Ljung-Box (LB) tests applied to one-step ahead forecast pseudo-residuals (LB test with 10 lags). Bold numbers indicate p-values $<0.05$.
<table><thead><tr><th></th><th colspan="2">SVM-N</th><th colspan="2">SVM-t</th><th colspan="2">SVM-S</th><th colspan="2">SVM-VG</th></tr><tr><th>Index</th><th>JB</th><th>LB</th><th>JB</th><th>LB</th><th>JB</th><th>LB</th><th>JB</th><th>LB</th></tr></thead><tbody><tr><th>S&P 500</th><td>0.10</td><td>0.48</td><td>0.08</td><td>0.44</td><td>0.09</td><td>0.44</td><td>0.07</td><td>0.43</td></tr><tr><th>NIKKEI 225</th><td>0.02</td><td>0.96</td><td>0.04</td><td>0.96</td><td>0.06</td><td>0.97</td><td>0.04</td><td>0.96</td></tr><tr><th>DAX 30</th><td>0.07</td><td>0.85</td><td>0.11</td><td>0.83</td><td>0.12</td><td>0.83</td><td>0.09</td><td>0.83</td></tr><tr><th>IBOVESPA</th><td>0.69</td><td>0.35</td><td>0.44</td><td>0.35</td><td>0.60</td><td>0.34</td><td>0.44</td><td>0.34</td></tr></tbody></table>

### 6 Conclusions
This paper makes three complementary contributions to the modeling of financial time series using stochastic volatility models. First, by allowing the observation distribution to belong to the Scale Mixture of Normals (SMN) family, we extend the HMM-based methodology proposed by [^3] to a broad class of heavy-tailed stochastic volatility-in-mean models. Second, we embed the resulting HMM approximation within an approximate Bayesian inference framework based on importance sampling, providing a computationally efficient alternative to conventional MCMC-based methods. Third, by combining parallel computing techniques with analytical representations based on special functions, we obtain substantial improvements in numerical stability and computational efficiency, leading to more reliable estimation and significantly reduced computing times.
The empirical evidence presented in this paper indicates that the proposed HMM approximation yields posterior summaries that closely agree with those obtained using exact MCMC methods, while requiring only a fraction of the computational effort—approximately one-tenth of the execution time in the applications considered. Moreover, the simulation experiments suggest that the approximate likelihood stabilizes rapidly as the discretization grid is refined. From a theoretical perspective, the HMM likelihood can be interpreted as a quadrature approximation to the exact likelihood, and a heuristic justification of its convergence properties is provided in the Supplementary Material. Taken together, these findings suggest that the proposed methodology offers an attractive compromise between computational efficiency and inferential accuracy for the Bayesian analysis of SVM models.
To facilitate reproducibility and encourage further methodological developments, all computational routines developed in this study have been made publicly available through the development version of the R package svHMM, which can be accessed from the GitHub repository: [). We believe that the availability of efficient and user-friendly software is particularly valuable for practitioners and applied researchers, who are often interested in obtaining reliable results within a reasonable computational time.

### Acknowledgments
The authors would like to thank the EULER cluster team of the CeMEAI project (FAPESP grant 2013/07375-0) for their support, which enabled part of the computational simulations conducted in this study.

### Funding Statement
The research of Bruno E. Holtz was financed by the Coordenação de Aperfeiçoamento de Pessoal de Nível Superior - Brasil (CAPES) - Finance Code 001. The second author acknowledges partial ﬁnancial support from Fundação Carlos Chagas Filho de Amparo à Pesquisa do Estado do Rio de Janeiro (FAPERJ). Ricardo Ehlers acknowledges financial support from the São Paulo Research Foundation (FAPESP), under grant 2025/06569-2 and from the National Council for Scientific and Technological Development (CNPq), under grant 409630/2024-1.
[^1]: Maximum likelihood estimation for stochastic volatility in mean models with heavy-tailed distributions. Applied Stochastic Models in Business and Industry 33, pp. 394–408. Note: doi: [) Cited by: §1, §3.1.
[^2]: Stochastic volatility in mean models with heavy-tailed distributions. Brazilian Journal of Probability and Statistics 26, pp. 402–422. Note: doi: [) Cited by: §1.


## Key insights
- To overcome the computational challenges arising from these models, we propose a numerically stable estimation procedure that exploits special functions to eliminate the need for direct numerical integration.
- Simulation studies and empirical applications demonstrate that the proposed approach delivers accurate inference while achieving computational times that are approximately an order of magnitude smaller than those required by conventional Markov chain Monte Carlo (MCMC) methods.
- In particular, they have been widely employed to investigate asymmetric volatility behavior and to model the dynamics of daily stock return volatility.
- It is worth noting that, in any SV model, the likelihood function involves high-dimensional integration over the latent volatility process.
- MCMC methods circumvent the direct evaluation of these integrals by jointly sampling the latent volatilities and model parameters.
- In that work, the likelihood function of the SVM model under the assumption of Gaussian returns is numerically approximated by discretizing the continuous latent volatility process and subsequently evaluated using the hidden Markov model (HMM) machinery.
- Section 3 outlines the proposed SVM model and the corresponding Bayesian estimation procedure, while the results of the simulation studies are presented in Section 4.
- ## 3 The Stochastic Volatility in Mean (SVM) Model

The SVM model provides a convenient framework for studying the interaction between financial returns and time-varying volatility by explicitly incorporating volatility into the conditional mean equation.
- This extension substantially increases the flexibility of the model by allowing for heavier tails and greater robustness against extreme observations.
- These formulations generalize the classical Gaussian SVM model, hereafter denoted by SVM-N, introduced by [^13].

## Exemplos e evidências
See original source at `Clippings/Stochastic Volatility in Mean Models with Heavy Tails A Fast Approximate Bayesian Inference Using Hidden Markov Models.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/tool]]
- [[03-RESOURCES/concepts/llm-ml-foundations/inference]]
- [[03-RESOURCES/concepts/software-engineering/specification]]
- [[03-RESOURCES/entities/AWS]]
