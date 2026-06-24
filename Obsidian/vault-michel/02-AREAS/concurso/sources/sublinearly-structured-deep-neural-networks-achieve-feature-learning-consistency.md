---
title: "Sublinearly Structured Deep Neural Networks Achieve Feature Learning Consistency for Compositional Functions"
type: source
source: "Clippings/Sublinearly Structured Deep Neural Networks Achieve Feature Learning Consistency for Compositional Functions.md"
created: 2026-06-23
ingested: 2026-06-23
score: C
tags: [concurso, source-page]
---

## Tese central
Over the past decade, deep neural networks (DNNs) have achieved remarkable success on complex machine-learning tasks, yet the theoretical foundations of their performance remain incomplete. From a statistical viewpoint, a natural question is: *can DNNs attain feature-learning and prediction consistency comparable to that of classical models?* While a full characterization is open, we provide positive results for a broad subclass. We establish feature-learning consistency guarantees for *sublinea

## Argumentos principais
### 1 Introduction
Over the past decade, DNNs have made major breakthroughs in many research domains, including image generation, protein folding, and language processing. The ability of these models to automatically learn the problem-specific features hidden in the training data is considered as a major factor contributing to their success, see e.g. [^37], [^41], and [^51]. Therefore, understanding the mechanism of feature learning and, by extension, designing the network structure for ensuring the hidden features to be effectively learned has attracted much attention in recent literature.
Feature learning for linear models has been well studied in statistics, see e.g., [^48], [^11], and [^32], where one aims to identify important covariates through estimating their regression coefficients. For DNNs, we follow [^37] to define a neural feature as an eigenvector of ${\boldsymbol{w}}_{l}^{T}{\boldsymbol{w}}_{l}$, where ${\boldsymbol{w}}_{l}\in\mathbb{R}^{d_{l}\times d_{l-1}}$ denotes the weight matrix of hidden layer $l$, and $d_{l}$ denotes the width of layer $l$. It is easy to see that the regression coefficient vector of the linear model can be viewed as a special case of this general definition (with $d_{1}=1$ and $d_{0}=p$ for the number of covariates, and rescaled by ${\boldsymbol{w}}_{1}{\boldsymbol{w}}_{1}^{\top}$). From a statistical perspective, a natural question is whether a DNN can achieve feature learning consistency similar to that of linear models.
To bridge the gap between linear models and deep learning, [^45] and [^30] proposed a new type of neural network – stochastic neural network (abbreviated as StoNet). This network is formulated as a composition of many linear/logistic regressions and provides a framework for transferring theory and methods from linear models to DNNs. Additionally, the StoNet offers a convenient way for addressing many important problems encountered in modern data science, such as sufficient dimension reduction [^30], uncertainty quantification [^46], and causal effect estimation [^12] [^13]. These problems are otherwise hard to address using conventional DNNs. In this paper, based on the asymptotic equivalence between DNN and StoNet [^30], we prove that the sublinearly structured DNN achieves feature-learning consistency for hierarchically compositional functions in which each constituent depends on at most a bounded number of variables.

### 2 DNN and Its Stochastic Surrogate
Consider a DNN model with $h$ hidden layers defined as follows:
$$
\begin{split}\tilde{{\boldsymbol{Y}}}_{1}&={\boldsymbol{b}}_{1}+{\boldsymbol{w}}_{1}{\boldsymbol{X}},\\

### 3 Feature Learning Consistency in sublinear DNNs
This section first describes the imputation-regularized optimization (IRO) algorithm [^29] for training sublinear StoNets, and then establishes feature-learning consistency for them. This result, by Lemma 1, further implies feature-learning consistency for the sublinear DNNs that are trained with an optimization algorithm such as stochastic gradient descent (SGD) or Adam [^24].

### 3.1 The IRO Algorithm
Notation: Let $D_{n}=\{\mathbb{Y},\mathbb{X}\}$ denote a dataset of $n$ observations, where $\mathbb{Y}\in\mathbb{R}^{n\times d_{h+1}}$ and $\mathbb{X}\in\mathbb{R}^{n\times p}$ contain the responses and covariates, respectively. Let ${\boldsymbol{\sigma}}_{n}^{2}=(\sigma_{1}^{2},\ldots,\sigma_{h+1}^{2})$, where the dependence of $\sigma_{l}$ on $n$ is implicit as implied by Assumption 1.
Algorithm 1 IRO Algorithm for StoNet
Input: Dataset $D_{n}$, total iteration number $T$, and Monte Carlo step number $t_{MC}$.

### 3.2 Feature Learning Consistency
For all theoretical results in this paper, the proofs are presented in the Appendix. Let $\lambda_{\min}(A)$ and $\lambda_{\max}(A)$ denote, respectively, the minimum and maximum eigenvalues of the matrix $A$. For the inputs and network structure, we make the following assumption:
###### Assumption 2.
(i) The network architecture satisfies the condition given in (1); (ii) ${\boldsymbol{X}}\in[0,1]^{p}$ (i.e., in a bounded space); additionally, there exists a constant $\kappa_{\min}>0$ such that $\lambda_{\min}({\boldsymbol{\Sigma}}_{0})\geq\kappa_{\min}$, where ${\boldsymbol{\Sigma}}_{0}$ denotes the covariance matrix of ${\boldsymbol{X}}$.

### 3.3 Approximation Power of Sublinear DNNs
Theorem 1 rests on the implicit assumption that the sublinear DNN can adequately approximate the target function. Given the model’s structural constraints, a natural question arises: can it still approximate common target classes, e.g., continuous functions on compact sets, arbitrarily well as the sample size $n\to\infty$? While a complete characterization remains open, we establish positive results for several important classes of functions, as detailed below.
To understand the approximation power of DNNs, a line of work has analyzed compositional functions, see, e.g., [^40] [^4] [^36], motivated by the compositional structure of DNNs. Combining the approximation theory of [^36] with Theorem 1, we obtain:
###### Theorem 3.

### 4 Numerical Experiments
We first test the performance of the IRO algorithm 1 for StoNet training; see Supplement S1.2 for details. Our numerical experiments show that the StoNet trained with IRO and the DNN trained with SGD perform similarly, which is consistent with the theory established in Lemma 1. In practice, the IRO algorithm requires solving a series of regressions on the entire dataset for each iteration, which can be slow for large datasets. Therefore, we use SGD in all subsequent experiments, while using StoNet with IRO as a bridge for transferring theory and methods from linear models to DNNs.

### 4.1 Feature Learning Consistency
To illustrate the consistency of feature learning in sublinear DNNs, we consider the following two-hidden-layer neural network model:
$$
y_{i}={\boldsymbol{w}}_{3}\tanh({\boldsymbol{w}}_{2}\tanh({\boldsymbol{w}}_{1}{\boldsymbol{x}}_{i}+{\boldsymbol{b}}_{1})+{\boldsymbol{b}}_{2})+b_{3}+\sigma\epsilon_{i},\quad i=1,2,\ldots,n,

### 4.2 Double Descent and Beyond
Double descent is a surprising phenomenon in machine learning, which describes the observation that the test error of a model drops as the model grows ever larger into the highly overparameterized regime relative to the training sample size, see e.g., [^5] [^1] [^39]. This phenomenon will be explained at the end of this subsection from a perspective of neural feature learning.
#### MNIST
As in [^5], we worked with a subset of MNIST (with $n_{train}=4000$, $p=784$, and $K=10$ classes) as training data. We trained a one-hidden-layer neural network: 784-L-10, where $L$ is the hidden layer width, and measured its prediction performance on a test dataset with $n_{test}=10,000$. Figure 1(a) shows the resulting training and test errors, where the second descent in test errors occurs with $L$ ranging 50 $\sim$ 1000. Notably, for each $L\in[50,1000]$, the resulting DNN is sublinear in width, although its total number of parameters can be much greater than $n_{train}$. Our feature-learning consistency theory provides a principled explanation for the second descent phenomenon, as detailed below.

### 4.3 More Examples: Sublinear or Wide?
In this subsection, we delve deeper into the choice of hidden layer widths from the perspective of feature learning. Theoretically, as shown in a series of papers (e.g., [^16], [^43], [^22]), the gradient descent method provides implicit regularization during model training. Specifically, for high-dimensional linear regression models initialized at the origin, gradient descent converges to the solution with the minimum Euclidean norm. By applying this result to the StoNet model (3), we arrive at the following solution for ${\boldsymbol{w}}_{i}$ at each hidden layer:
$$
\hat{{\boldsymbol{w}}}_{i}=\mathbb{Y}_{i}^{\top}\Psi(\mathbb{Y}_{i-1})(\Psi(\mathbb{Y}_{i-1})^{\top}\Psi(\mathbb{Y}_{i-1})+\tilde{\sigma}^{2}I)^{-1},

### 4.4 CelebA
As another application of the sublinear DNN, we consider an example of feature extraction in classifying images from the CelebA dataset [^31]. As in [^37], we employed a fully connected ReLU DNN for the task. The DNN we used has a structure of $3\times 64\times 64-L-L-L-L-2$ with $L=1024$. Therefore, the DNN is still of sublinear width when applied to the CelebA data with a training sample size $n_{train}=14,000$. We trained the fully connected DNN using SGD with a momentum parameter of 0.9, a learning rate of 0.05, a mini-batch size of 64, and 100 epochs. Figure 4 shows four features extracted in training, which indicate the success of feature learning by the sublinear DNN.
Figure 4: Four features extracted from the first hidden layer, as described in 37, in training a fully connected ReLU DNN with structure 3 × 64 3\\times 64\\times 64 -L-L-L-L-2 for the CelebA data: glass, smile, hat, and arched eyebrow, from left to right.

### 5 Structure Analysis for Large-Scale DNNs
It is worth noting that many large-scale DNNs, such as AlexNet [^26], VGGNet [^42], ResNet [^18], and GoogLeNet [^47], belong to the class of sublinear DNNs in their benchmark studies, despite containing a huge number of parameters. For any deep CNN, we can still randomize the feeding value of each node with incoming trainable connections as in (3), thereby enabling the construction of an asymptotically equivalent StoNet for it. For each node, the number of incoming connections, i.e., the dimension of explanatory variables of the corresponding regression, is calculated as $(s_{l}^{(1)}*s_{l}^{(2)}*d_{l-1}+1)$, where $s_{l}^{(1)}*s_{l}^{(2)}$ denotes the filter size and corresponds to the fixed $s$ value in the constituent map of the compositional function (see Theorem 3), and $d_{l-1}$ denotes the number of filters in the previous layer, and ‘1’ represents the bias term. For a deep CNN belonging to the class of sublinear DNNs, the following two conditions need to be satisfied: $\max_{l}(s_{l}^{(1)}*s_{l}^{(2)}*d_{l-1}+1)\prec n$ and $\sum_{l}d_{l}\prec n$. The latter condition can also be interpreted as the total number of regressions formed in the stochastic deep CNN. The structures of the deep CNNs are analyzed in the following, based on the summary provided by Aqeel Anwar at [).
AlexNet is one of the earliest deep CNNs, which won the 2012 ImageNet LSVRC-2012 challenge. It comprises a total of 62.4 million trainable parameters, including 5 convolutional layers and 3 fully connected (FC) layers. In this network, the maximum number of incoming connections to a single node is 9,217, achieved at the first FC layer, and the total number of nodes with incoming trainable connections is 10,568. VGG16 has approximately 138.4 million parameters. In VGG16, the maximum number of incoming connections to a single node is 25,089, achieved at the first FC layer, and the total number of nodes with incoming trainable connections is 13,544. ResNets have many variants, e.g., ResNet18, ResNet50, and ResNet101. Let’s consider ResNet18 as an example. It comprises approximately 11.5 million trainable parameters, its maximum number of incoming connections to a single node is 4,609, achieved at layers 15, 16 and 17, and its total number of nodes with incoming trainable connections is 4,904. GoogLeNet has about 6.4 million trainable parameters, in which the maximum number of incoming connections to a single node is 1,729, achieved in Inception 5b, and the total number of nodes with incoming trainable connections is 8,280.
In summary, all these networks are sublinear when trained on large-scale datasets such as ImageNet, CIFAR10, CIFAR100, and MNIST, each with $n\geq 50,000$ training samples. Moreover, because images exhibit an inherent hierarchical, compositional structure, Theorems 1 and 3 apply to these sublinear networks. Taken together, these theoretical insights and the preceding analysis help explain why such large-scale networks achieve exceptional predictive performance after sufficient training on large-scale datasets.

### 6 Conclusion
We study sublinear DNNs and prove that, in the large-sample limit, they achieve universal approximation and feature-learning consistency for hierarchically compositional functions. We also analyze AlexNet, VGGNet, and ResNet, showing that these deep CNNs are sublinear on their image-classification benchmarks. Because natural images are hierarchically compositional, our results offer a statistical explanation for the strong performance of large-scale deep learning models in image processing. Our theory identifies a regime in which consistent prediction is guaranteed for large-scale deep learning models despite possible over-parameterization. Empirically, sublinear DNNs match or outperform wide DNNs in prediction accuracy and are more robust to training hyperparameter settings.
The theoretical proof of this paper leverages StoNet as a surrogate for the DNN, creating a bridge between linear models and DNNs. Beyond sublinear DNNs, this approach can be applied to sparse deep learning by extending the sparse learning theory from linear models to DNNs. Additionally, we conjecture that the StoNet could enable the extension of benign overfitting theory from linear models to super-wide DNNs, leveraging its capability in sufficient dimension reduction [^30].
In summary, this work validates the effectiveness of sublinear DNNs for learning features from hierarchically compositional functions and provides theoretical guidance for designing appropriate network architectures for tasks such as image processing, where hierarchical composition is intrinsic. The main takeaways are: (i) sublinear DNNs achieve feature-learning consistency for hierarchically compositional functions, even when the total number of parameters exceeds the sample size; (ii) although wide DNNs can drive training error near zero, their predictive performance can be sensitive to the optimization algorithms and hyperparameter settings, whereas sublinear DNNs are notably more robust; and (iii) sublinear DNNs comply with neural scaling laws, achieve universal approximation for hierarchically compositional functions in the large-sample limit, and may extend to other classes of functions, a direction that merits further study.

### Availability
The code used to run the experiments is available at [).

### Acknowledgments
Liang’s research is supported in part by the NSF grant DMS-2210819 and the NIH grant R01-GM152717. Kim’s research is supported by the Global-Learning & Academic Research Institution for Master’s and PhD Students, and Postdocs (G-LAMP) Program of the National Research Foundation of Korea (NRF), funded by the Ministry of Education (No. RS-2025-25442252).


## Key insights
- The network training errors are fairly robust to learning rates (see red curves): When $L$ is reasonably large, say $L\geq 100$ (equivalently, $\log_{10}L\geq 2$), the training errors consistently converge to 0.
- For sublinear-width networks, the test errors (blue curves) are fairly robust to learning rates: In the sublinear regime (with $L<500$ or, equivalently, $\log_{10}(L)\leq 2.7$), the network test-error curves are nearly unchanged as $\alpha$ varies.
- For wide networks, the test errors are sensitive to the learning rate: In the wide regime (with $L\geq 500$ or, equivalently, $\log_{10}(L)\geq 2.7$), the network test-error trajectories differ noticeably when $\alpha$ is large.

## Exemplos e evidências
See original source at `Clippings/Sublinearly Structured Deep Neural Networks Achieve Feature Learning Consistency for Compositional Functions.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/ai-agents/benchmark]]
- [[03-RESOURCES/concepts/software-engineering/proof]]
- [[03-RESOURCES/entities/NVIDIA]]
- [[03-RESOURCES/entities/AWS]]
