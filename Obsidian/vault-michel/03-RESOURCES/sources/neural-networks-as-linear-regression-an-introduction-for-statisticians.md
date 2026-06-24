---
title: "Neural Networks as Linear Regression: An Introduction for Statisticians"
type: source
source: "Clippings/Neural Networks as Linear Regression An Introduction for Statisticians.md"
created: 2026-06-23
ingested: 2026-06-23
score: B
tags: [ai-agents, source-page]
---

## Tese central
Neural networks are a commonly used prediction tool in computer science and statistics. However, the barrier to entry of this interesting field remains high, particularly for classical statisticians trained in a frequentist perspective. In this letter, we demystify neural networks by describing networks that approximate a linear regression and describe common customizations that provide a foundation for further study.

## Argumentos principais
### 1 Statistical Review of Neural Networks
Neural networks are a popular way to model potentially complex functions with many variations and adaptations (see, for example LSTMlanguage; LSTMsleep; LSTMfuelcells). Although many features of neural networks have a clear statistical basis, jargon for describing these features are often quite different for computer science and statistical researchers, causing much unnecessary confusion. To familiarize statistical audiences with the neural network algorithm used in our research, we first introduce a neural network algorithm that corresponds to linear regression in Section 1.1. Then in Section LABEL:s:nnet:lstmDesc we describe a neural network algorithm appropriate for use with the longitudinal data. Additional practical considerations of applying this neural network algorithm in our setting are given in Section 1.2.

### 1.1 Linear Regression as a Neural Network
In the language of computer scientists, neural networks are a user-specified architecture (model) with hidden layers of nodes, consisting of weights on the edges and biases (similar to intercept; different from the bias typically used in statistics) applied to model inputs for the purpose of predicting an outcome. Consider the regression model $g(E[\bm{Y}|\bm{Z}_{1},\ldots,\bm{Z}_{p}])=\mathbf{Z}^{\top}\beta$, where $\bm{Y},\bm{Z}_{j},j=1\ldots p$ are $n$ -dimensional vectors, $\beta$ is of dimension $p\times 1$, and $\mathbf{Z}$ is the $(p+1)\times n$ -dimensional design matrix, which includes the intercept term. Here and throughout this manuscript, we use bold face type to denote matrices or vectors. The $g(\cdot)$ function, or link function in statistical language, is typically the identity function for linear regression settings. Generally, we will use the term $g^{-1}(\mathbf{\eta})$ to denote the term that is used to minimize squared-error loss, i.e. $\{\mathbf{Y}-g^{-1}(\mathbf{\eta})\}^{\top}\{\mathbf{Y}-g^{-1}(\mathbf{\eta})\}$, where $\eta=\mathbf{Z}^{\top}\beta$ and $\eta$ is of dimension $n\times 1$.
Translating neural network to statistical terminology: (1) model inputs are covariates, $\bm{Z}_{j}$, $j=1,\ldots,p$; (2) weights are linear regression slope parameters $\beta_{j},j=1,\ldots,p$; (3) bias corresponds to the linear regression model intercept, $\beta_{0}$; (4) a node is the functional $g^{-1}(\mathbf{Z}^{\top}\beta)$, which reduces to $\mathbf{Z}^{\top}\beta$ in the setting mirroring linear regression with an identity link. Individual nodes make up the hidden layers of the neural network, termed hidden because neural network algorithms do not report estimates, $\widehat{\mathbf{\beta}},$ just the vector of outcome predictions, $\widehat{\bm{Y}}=g^{-1}(\mathbf{Z}^{\top}\mathbf{\widehat{\beta}})$. Computer scientists refer to $g^{-1}(\cdot)$ as an activation function that estimates the desired outcome, often in several different layers within the algorithm. Hereafter, we use the terms “slope” to refer to a weight, “intercept” to refer to bias, and “parameter estimates” to refer collectively to weights and biases used in the neural net contexts.
Figure 1 displays three increasingly more sophisticated neural networks in Panels (A), (B) and (C), where we include an additional subscript on $\eta$ to reflect changes across panels. Panel (A) displays a linear regression model in a manner familiar to neural network researchers with a single hidden layer composed of one node; the corresponding statistical optimization function is displayed below the network. Covariates are represented by circles on the left of the diagram, while the linear predictor is displayed in the rectangular box.

### 1.2 Useful Extensions to Bare-bones Networks
Neural networks have many proposed extensions. In this section, we selectively describe (1) common parameters available from the off-the-shelf Python module torch.nn, and (2) a few additional neural network design choices in common use for tailoring analyses. Options in torch.nn include: $\eta$ (computer scientists call this hidden state), parameter pruning (computer scientists call this the drop-out proportion), number of network layers, and the encoding of similarities within individuals via embeddings.
A hyperparameter favored by computer scientists is allowing $\eta_{t}$ to be extended from a scalar to a matrix in $\mathbb{R}^{n(t)\times h}$, with columns $\eta_{t}^{(1)},\eta_{t}^{(2)},\ldots\eta_{t}^{(h)}$, and similarly $\bm{Z}_{i}(t)$ to be extended from a vector in $p\times 1$ to a matrix of dimension $\mathbb{R}^{p\times n(t)}$. Computer scientists call $h$ the hidden dimension. For dimensions $h>1$, the inverse link is applied to a linear combination of the $h$ columns of $\eta_{t}$, i.e. $g^{-1}(\gamma_{0}+\gamma_{1}\mathbf{\eta}_{t}^{(1)}+\ldots\mathbf{\eta}_{t}^{(h)})$.
Beyond increasing $h$, computer scientists have also found that vertically stacking additional architecture at time $t$ increases prediction performance (graves2014generatingsequencesrecurrentneural). General recommendations are for at most 4 layers of architecture to be “stacked” on top of each other (as used in sutskever2014sequencesequencelearningneural). For instance, the entire architecture at time $t$ seen in Figure 1C might be stacked on top of a similar architecture, where the $\eta_{C}$ elements taken from the right side of the top stacked architecture play the role of the covariate inputs ($Z_{p}$ terms) on the left of the bottom stacked architecture. Additional subscripts on parameters and link functions in the bottom stacked architecture would complete this version of stacking architecture.


## Key insights
- ## 1 Statistical Review of Neural Networks

Neural networks are a popular way to model potentially complex functions with many variations and adaptations (see, for example LSTMlanguage; LSTMsleep; LSTMfuelcells).
- To familiarize statistical audiences with the neural network algorithm used in our research, we first introduce a neural network algorithm that corresponds to linear regression in Section 1.1.
- Panel (A) displays a linear regression model in a manner familiar to neural network researchers with a single hidden layer composed of one node; the corresponding statistical optimization function is displayed below the network.
- Researchers have found that an increase in the number of nodes in the hidden layer may improve prediction, particularly in the case where the relationship between covariates and outcome is more complex than a linear model.
- A popular method used by both statisticians and computer scientists to prevent predictions being overfit to the data is to use different data cohorts for model training, validating, and testing.
- First, data are split into model building and model testing cohorts.
- The model building cohort determines the final architecture of the neural network using a $k$ -fold cross-validation algorithm to evaluate architecture hyperparameters including, for instance, the number of hidden layers and the number of iterations used in the optimization algorithm.
- Once the architecture hyperparameters are determined via $k$ -fold cross-validation, the full model building cohort is used to rebuild the neural network (via re-minimizing the loss function in this cohort).

## Exemplos e evidências
See original source at `Clippings/Neural Networks as Linear Regression An Introduction for Statisticians.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/neural-network]]
- [[03-RESOURCES/concepts/ai-agents/tool]]
- [[03-RESOURCES/entities/Python]]
