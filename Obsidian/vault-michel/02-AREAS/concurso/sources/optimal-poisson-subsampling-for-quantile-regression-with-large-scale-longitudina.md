---
title: "Optimal Poisson subsampling for quantile regression with large-scale longitudinal data"
type: source
source: "Clippings/Optimal Poisson subsampling for quantile regression with large-scale longitudinal data.md"
created: 2026-06-23
ingested: 2026-06-23
score: C
tags: [concurso, source-page]
---

## Tese central
To address the computational challenges arising from large-scale longitudinal data, an optimal Poisson subsampling algorithm is proposed for quantile regression. The proposed method can substantially alleviate computational burden. Under some regularity conditions, we derive the asymptotic properties of the estimators from weighted quantile generalized estimating equations.

## Argumentos principais
### 1 Introduction
The study of longitudinal data is of great significance in biomedicine, economics, social sciences and other fields. Longitudinal data integrate cross-sectional and time series characteristics, where repeated observations on the same subject are inherently correlated. Quantile regression serves as a powerful tool for longitudinal data analysis, partly due to its flexibility and ability to describe the entire conditional distribution of the response variable. Numerous researchers have carried out extensive research on longitudinal quantile modeling in the last several decades. [^9] proposed a linear quantile regression method for longitudinal data, in which an induced smoothing method was utilized to estimate the parameters and covariance matrix. [^8] proposed a Gaussian pseudo-likelihood method to estimate correlation parameters by modeling the bivariate correlation structure of the error terms under quantile regression for longitudinal data. [^32] proposed a novel weighted quantile regression model for longitudinal data, in which weights were chosen by empirical likelihood. [^15] proposed a weighting method to improve the estimation efficiency of varying-coefficient quantile regression for longitudinal data. [^26] used copula functions to measure within-group correlation of composite quantile regression for longitudinal data. High-dimensional longitudinal data have become increasingly prevalent. [^22] proposed a penalized weighted convolution-type smoothing method under quantile regression to perform variable selection and robust parameter estimation. [^35] developed a novel quantile-based penalized GEE approach and applied it to blood pressure analysis.
However, the scale of collected longitudinal data has become increasingly large nowadays, and relatively limited computational power makes analyzing these datasets extremely challenging. Directly applying the above methods to the full longitudinal dataset turns out to be both impractical and computationally costly. Therefore, how to analyze large-scale longitudinal data under limited computational resources has gradually attracted increasing attention. It is noted that subsampling has become a widely adopted strategy to ease the computing burden caused by massive data. This method aims to draw a representative subset from massive datasets and to conduct parameter estimation based on the selected subsamples.
Subsampling methods for massive data have been extensively studied. [^19] proposed the uniform random subsampling method. [^7] introduced the Poisson subsampling method and applied it to logistic regression. To improve the information content of subsampled data, many scholars have conducted research on non-uniform sampling probabilities. The core of optimal subsampling is to select subsamples according to optimal subsampling probabilities. For example, under the A-optimality criterion, such probabilities can be derived via minimizing the trace of the asymptotic covariance matrix of parameter estimators.

### 2 Poisson subsampling algorithm for quantile regression
In this section, we first introduce the weighted quantile generalized estimating equations and then derive the asymptotic properties of the resulting estimators.

### 2.1 Quantile generalized estimating equations
Let $\boldsymbol{Y}_{i}=(y_{i1},\cdots,y_{im_{i}})^{\top}$ and $\boldsymbol{X}_{i}=(\boldsymbol{x}_{i1},\cdots,\boldsymbol{x}_{im_{i}})^{\top}$ denote the response and covariate vectors for the $i$ -th subject, respectively, where $i=1,\cdots,n$ and $j=1,\cdots,m_{i}$, with $\boldsymbol{x}_{ij}$ being a $p$ -dimensional vector. Assume $m_{1},m_{2},\cdots,m_{n}$ all equal $m$, with no loss of generality. Consider the following conditional quantile model for the response $y_{ij}$:
$$
Q_{\tau}(y_{ij}\mid\boldsymbol{x}_{ij})=\boldsymbol{x}_{ij}^{\top}\boldsymbol{\beta}_{0},

### 2.2 General Poisson subsampling algorithm
Let $\pi_{i}$ denote the sampling probability for the $i$ -th subject, where $i=1,\cdots,n$. Based on the definition in (1), the weighted quantile generalized estimating equations are further defined as
$$
\boldsymbol{S}_{r}(\boldsymbol{\beta})=\frac{1}{n}\sum_{i=1}^{n}\frac{\delta_{i}}{\pi_{i}}\boldsymbol{X}_{i}^{\top}\boldsymbol{\Gamma}_{i}\boldsymbol{R}_{i}^{-1}(\tau-I\{\boldsymbol{Y}_{i}\leq\boldsymbol{X}_{i}\boldsymbol{\beta}\}).

### 3 Optimal Poisson subsampling
In this section, the optimal Poisson subsampling probability is derived and a computationally implementable algorithm is proposed.

### 3.1 Optimal Poisson subsampling strategy
The results of Theorem 2.2 and 2.4 can be used to derive the optimal Poisson subsampling probability, which minimizes the asymptotic mean squared error (MSE) of the subsample estimator for approximating $\boldsymbol{\beta}_{0}$. This is equivalent to minimizing $\operatorname{tr}(\boldsymbol{V})$, namely the A-optimality criterion. The optimal Poisson subsampling probability can then be derived according to the following theorem.
###### Theorem 3.1.
For $i=1,2,\cdots,n$, define $z_{i}=\left\|\boldsymbol{H}_{n}^{-1}\boldsymbol{X}_{i}^{\top}\boldsymbol{\Gamma}_{i}\boldsymbol{R}_{i}^{-1}\right\|$, and let $z_{(1)}\leq z_{(2)}\leq\cdots\leq z_{(n)}$ denote the order statistics of $\{z_{i}\}_{i=1}^{n}$. If the subsampling probability is given by

### 3.2 Practical implementation of the algorithm
Rewriting (4) yields
$$
\pi_{i}=r\frac{z_{i}\wedge T}{\sum_{j=1}^{n}(z_{j}\wedge T)}=r\frac{z_{i}\wedge T}{n\gamma},

### 4 Regularized estimation of the optimal subsample
In this section, we introduce the penalized weighted smoothed quantile generalized estimating equations and develop an implementation algorithm within the optimal Poisson subsampling framework.

### 4.1 Penalized weighted smoothed quantile generalized estimating equations
Regularization-based parameter estimation is essential in high-dimensional data analysis. Under the assumptions of non-massive data and sparsity, numerous results have been established, such as [^5] [^34] [^11] [^33]. However, relatively little work has been devoted to regularized parameter estimation for large-scale longitudinal data. Therefore, we introduce a regularization method within the optimal Poisson subsampling framework. Following [^35], the penalized weighted smoothed quantile generalized estimating equations with the adaptive LASSO (ALASSO) penalty is adopted:
$$
\boldsymbol{S}_{r}^{P}(\boldsymbol{\beta})=\boldsymbol{S}_{r}^{\Phi}(\boldsymbol{\beta})-\lambda\tilde{\boldsymbol{w}}\boldsymbol{\mathrm{sgn}}(\boldsymbol{\beta}),

### 4.2 Algorithm for implementing regularized estimation
The minorization-maximization algorithm is utilized to address the nonsmoothness induced by the ALASSO penalty. Under the proposed framework, the penalized weighted smoothed quantile generalized estimating equations are approximated as
$$
\boldsymbol{S}_{r}^{P}(\boldsymbol{\beta})=\boldsymbol{S}_{r}^{\Phi}(\boldsymbol{\beta})-\lambda\tilde{\boldsymbol{w}}\boldsymbol{\mathrm{sgn}}(\boldsymbol{\beta})\frac{|\boldsymbol{\beta}|}{\epsilon+|\boldsymbol{\beta}|}=\boldsymbol{0},

### 5 Numerical simulations
Simulation studies are performed to assess the performance of the proposed optimal Poisson subsampling algorithm and the regularized parameter estimation. We conducted 500 independent replications to obtain all simulation results.

### 5.1 Parameter estimation
In the numerical simulation studies, the response variable is generated according to the following linear model
$$
y_{ij}=\boldsymbol{x}^{\top}_{ij}\boldsymbol{\beta}_{0}+\varepsilon_{ij}+q_{\tau},\quad i=1,\cdots,n,j=1,\cdots,m.

### 5.2 Regularized estimation
This subsection conducts simulation analyses to evaluate the performance of the proposed method for regularized parameter estimation. Under the four Scenarios, the variable dimension is set to $p=10$. The true coefficient vector is set as $\boldsymbol{\beta}_{0}=(1,1.5,1,1.5,1,0,\cdots,0)^{\top}$, that is, the first 5 components of $\boldsymbol{\beta}_{0}$ are 1, 1.5, 1, 1.5, 1, and the remaining 5 components are all 0. All other simulation settings remain identical to those in section 5.1.
The metrics of MSE, Sensitivity, Specificity, and Correct Classification Rate (CCR) are adopted to evaluate the performance of the regularized parameter estimation. Sensitivity refers to the proportion of true non-zero coefficients that are correctly identified as non-zero, while Specificity refers to the proportion of true zero coefficients that are correctly identified as zero. In particular, CCR stands for the overall proportion that both important and unimportant variables are correctly identified. The closer the values of Sensitivity, Specificity, and CCR are to 1, the better the variable selection performance.
Table 4 presents the regularized parameter estimation results under Scenario I where the error term follows a multivariate normal distribution and Scenario II where the error term follows a $t_{3}$ distribution, with the true correlation matrix following an AR(1) structure. The simulation results show that as the optimal Poisson subsample size increases, the MSE decreases gradually, the sensitivity is consistently 1, the specificity approaches 1, and the CCR also achieves satisfactory performance. Table 5 reports the regularized parameter estimation results under Scenario III and IV, which are similar to those in Table 4. Therefore, it can be concluded that the proposed regularized parameter estimation method under the optimal Poisson subsampling framework performs favorably.

### 6 Real Data Application
The China Health and Retirement Longitudinal Study (CHARLS) dataset is utilized for empirical validation of the proposed method and is available at  CHARLS aims to collect representative microdata on individuals aged 45 and above in China, together with their household information, in order to analyze population aging in the country. Specifically, the 2015, 2018, and 2020 waves of CHARLS data are adopted in this study to analyze depression scores.
Depression\_score is used as the dependent variable, and the independent variables include age, gender, edu, and other covariates. Detailed descriptions of these variables are provided in Table 6. Subjects with missing values are directly excluded from the analysis, with the analysis sample consisting of 8582 subjects, where each subject has three observations. The regression model constructed is as follows:
$$

### Conclusion
The optimal Poisson subsampling algorithm is first developed for quantile regression with longitudinal data, and the asymptotic properties of the subsample-based estimator are established. Furthermore, variable selection is conducted within the optimal Poisson subsampling framework. As distributed algorithms provide an important means of reducing computational cost for massive data, future work will focus on investigating distributed statistical algorithms for large-scale longitudinal data.


## Key insights
- The true regression coefficient $\boldsymbol{\beta}_{0}$ lies in a compact set $\Lambda=\{\boldsymbol{\beta}\in\mathbb{R}^{p}:\|\boldsymbol{\beta}\|\leq B\}$ for some large constant $B$.
- For each $i=1,2,\cdots,n$, the random error has an absolutely continuous distribution function $F_{i}(\cdot)$ with continuous density $f_{i}(\cdot)$. The derivative $f_{i}^{\prime}(\cdot)$ exists in an open set around zero, and is uniformly bounded away from $0$ and $\infty$ near zero.
- The eigenvalues of both the working correlation matrix $\boldsymbol{R}_{i}$ and true correlation matrix $\boldsymbol{R}_{0}$ are uniformly bounded away from $0$ and $\infty$, with no constraints placed on whether $\boldsymbol{R}_{i}=\boldsymbol{R}_{0}$.
- $\max\limits_{1\leq i\leq n}\frac{r}{n\pi_{i}}\|\boldsymbol{X}_{i}^{\top}\boldsymbol{\Gamma}_{i}\boldsymbol{R}_{i}^{-1}\|=o(\sqrt{r/\log\log r})$.
- $\limsup\limits_{n\to\infty}n^{-1}\sum_{i=1}^{n}\|\boldsymbol{X}_{i}\|^{4}<\infty$.
- $\max\limits_{1\leq i\leq n}\frac{r}{n\pi_{i}}=O(1)$.
- Let $\check{\boldsymbol{\beta}}=(\check{\beta}_{1},\ldots,\check{\beta}_{p})^{\top}$ be a $\sqrt{r}$ -consistent solution of $\boldsymbol{S}_{r}^{P}(\boldsymbol{\beta})=\boldsymbol{0}$, it holds that
- The true correlation matrix follows the AR(1) structure, with the error term $\boldsymbol{\varepsilon}_{i}\sim N(\boldsymbol{0},\boldsymbol{R}_{true})$. Three typical quantile levels $\tau=0.25,0.5,0.75$ are considered.
- The true correlation matrix also follows the AR(1) structure, while the error term $\boldsymbol{\varepsilon}_{i}\sim t_{3}(\boldsymbol{0},\boldsymbol{R}_{true})$, with the same quantile levels as in (I).
- The true correlation matrix adopts the EX structure. The error term $\boldsymbol{\varepsilon}_{i}$ follows the same distribution as that in (I), and the same quantile levels are adopted.

## Exemplos e evidências
See original source at `Clippings/Optimal Poisson subsampling for quantile regression with large-scale longitudinal data.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/tool]]
- [[03-RESOURCES/concepts/llm-ml-foundations/inference]]
- [[03-RESOURCES/concepts/software-engineering/specification]]
