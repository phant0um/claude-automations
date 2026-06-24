---
title: "Robust Auto-associative Memory via Convolutional Restricted Hopfield Networks"
type: source
source: "Clippings/Robust Auto-associative Memory via Convolutional Restricted Hopfield Networks.md"
created: 2026-06-23
ingested: 2026-06-23
score: C
tags: [articles, source-page]
---

## Tese central
Associative memory models play a fundamental role in pattern retrieval, but their performance often degrades under adversarial perturbations and severe input corruptions. Existing approaches, including Modern Hopfield Networks (MHNs), and Predictive Coding Networks (PCNs), exhibit limitations in balancing storage capacity, computational efficiency, and robustness. In this paper, we propose a Convolutional Restricted Hopfield Networks (CRHNs), which integrates convolutional feature extraction wit

## Argumentos principais
### I Introduction
In recent years, several associative memory models have been proposed to address the capability limitations of classical Hopfield Neural Networks (HNNs) [^11] [^12]. Dense Associative Memories (DAMs) introduces stronger nonlinearities in the energy function, aiming to improve the storage capacity and at the same to enhance the robustness [^14] [^16]. Modern Hopfield Networks (MHNs) further extend this framework by establishing a connection to the attention mechanism in Transformers, enabling seamless integration into deep learning architectures [^29]. Meanwhile, Predictive Coding Networks (PCNs), inspired by theories of cortical inference, perform memory retrieval through hierarchical error minimization and demonstrate robustness to noise and partial observations [^36] [^39] [^42]. However, although these alternative models achieve significant improvements over the original HNNs, they still struggle to maintain strong robustness against adversarial attacks and severe input corruption.
Figure 1: Iterative retrieval dynamics of Convolutional Restricted Hopfield Networks. Given corrupted and noisy inputs, the network progressively refines the patterns over iterations and converges to stored memories.
In biological systems, associative memory is a fundamental capability associated with the hippocampus, where recurrent neural dynamics support pattern completion from noisy sensory cues [^44] [^25] [^33]. In particular, the CA3 subregion, characterized by dense recurrent connectivity, has long been hypothesized to implement an auto-associative memory system with attractor dynamics [^11] [^32]. Combining both the mechanism of biological system and well-developed deep learning theory, Restricted Hopfield Networks (RHNs) were introduced as an extension incorporating hidden units and dynamic training mechanisms to enhance storage capacity and retrieval performance [^47] [^19] [^20] [^21]. It is observed that RHNs demonstrates strong resistance to adversarial attack and can easy retrieved the complete patterns from highly corrupted and noisy patterns [^9] [^24] [^19]. While MHNs and PCNs exhibit certain degrees of robustness, their underlying mechanisms limit their effectiveness under strong or targeted attacks. This highlights the potential of RHNs as a foundation for designing adversarially resilient memory systems [^19].

### I-A Motivation and Contribution
The study of adversarial robustness is critical for ensuring the reliability and security of deep learning systems in real-world applications [^30]. Vulnerabilities to adversarial perturbations pose significant risks in domains such as healthcare, autonomous systems, and cybersecurity, where errors can have severe consequences [^28] [^1] [^2]. Improving robustness not only enhances model reliability but also provides insights into the fundamental limitations of current architectures.
In this work, we propose a novel extension of RHNs, termed the CRHNs, designed to incorporate structured representations for high-dimensional data. The main contributions of this paper are summarized as follows:
- A novel CRHNs framework is proposed to integrate convolutional feature extraction with RHNs dynamics. The proposed architecture enables the network to store and retrieve complex image patterns in a compact latent space while preserving spatial structures and semantic information.

### I-B Organization
The remainder of this paper is organized as follows. Section II reviews related work on associative memory models and adversarial robustness. Section III introduces the background of MHNs and PCNs. Section IV describes the proposed CRHNs and the corresponding architecture. Meanwhile, it presents the formulation of RHNs, including their dynamical behavior and training via the Subspace Rotation Algorithm (SRA). Section V provides experimental results, including evaluations under adversarial attacks and input degradations. Finally, Section VI concludes the paper and discusses future research directions.

### II-A Auto-Associative Memory
One of the earliest and most influential models in auto-associative memory is the HNNs, introduced by Hopfield in 1982 [^11]. The HNNs formulate memory storage as an energy minimization process, where stored patterns correspond to attractors of the energy landscape. Despite its theoretical elegance and biological inspiration, the classical HNNs suffer from limited storage capacity, which scales as approximately $0.15N$ for $N$ neurons, as well as the presence of spurious attractors [^27] [^26]. To address these limitations, early efforts explored alternative learning rules and capacity-enhancing techniques, such as the perceptron-based training approach proposed by Gardner [^8] [^7], as well as Hebbian learning variants and basin optimization strategies [^40]. However, only limited progress was achieved.
More recently, DAMs have significantly advanced the field by introducing higher-order interaction functions. Krotov et al. proposed exponential energy functions that reshape the energy landscape, enabling substantially increased storage capacity and improved pattern separation [^14] [^15]. These models theoretically achieve super-linear or even exponential memory capacity, marking a substantial departure from classical Hopfield networks. However, despite their theoretical advantages, DAMs are often difficult to train efficiently in practice and may not fully realize their capacity limits in real-world applications [^3]. Inspired by DAMs, MHNs were introduced, extending classical formulations to continuous state spaces and establishing a direct connection to attention mechanisms in Transformer architectures [^29]. In these models, memory retrieval can be performed in a single step through a softmax-based update rule, enabling efficient and differentiable associative recall. Nevertheless, in practice, they still exhibit limited robustness to noise and corrupted samples.
To improve retrieval selectivity and interpretability, recent studies have explored sparse and structured associative memory formulations. Sparse Hopfield networks introduce sparsity-inducing transformations to enforce more selective retrieval behavior [^13]. Furthermore, the Hopfield-Fenchel-Young framework provides a unified perspective that generalizes classical HNNs, DAMs, and MHNs through convex analysis and energy-based formulations [^37]. This framework enables the design of new associative memory models with desirable properties such as sparsity, structured retrieval, and exact recovery guarantees.

### III Preliminaries
In this section, we introduce the fundamental concepts and training methodologies of MHNs and PCNs to facilitate subsequent discussions.

### III-A Modern Hopfield Networks
MHNs extend the classical HNNs by introducing a continuous-state formulation with significantly enhanced storage capacity and retrieval performance. Unlike traditional HNNs that rely on quadratic energy functions, MHNs employ a softmax-based association mechanism, which is mathematically equivalent to the attention mechanism widely used in deep learning architectures [^29].
MHNs store a set of patterns $\{\xi^{\mu}\}_{\mu=1}^{N}$ and retrieves relevant memories through a similarity-based matching process. Given a query vector $\mathbf{x}\in\mathbb{R}^{d}$ and a memory matrix $\mathbf{M}\in\mathbb{R}^{N\times d}$, the retrieval operation is defined as:
$$

### III-B Predictive Coding Networks
PCNs are inspired by information processing in the neocortex, where hierarchical structures are used to generate predictions and correct sensory inputs. This framework has been shown to be effective for representation learning and associative memory (AM) tasks [^36] [^48] [^41].
A multi-layer PCN consists of $L$ layers. The first layer corresponds to sensory inputs, the intermediate layers represent latent features extracted from the data, and the topmost layer provides top-down predictions to lower layers. Each layer contains value nodes, which represent neural activities, error nodes, which encode prediction discrepancies, and synaptic weights connecting adjacent layers.
The network minimizes the total prediction error across all layers, defined as

### IV Convolutional Restricted Hopfield Networks
Figure 2: Architecture of Convolutional Restricted Hopfield Networks
As shown in Figure 2, the CRHNs are formulated as a recurrent dynamical system that integrates convolutional feature extraction into the associative memory. Given an input image, a convolutional encoder maps it into a latent representation, which is then projected onto a discrete interface via a binary activation function to emulate the all-or-none firing behavior of neurons [^31]. The convolutional decoder maps the evolving state back to the image space at each iteration, producing progressively refined reconstructions. This recurrent formulation allows the CRHNs to jointly perform feature extraction, memory retrieval, and reconstruction within a unified iterative framework.

### IV-A Convolutional Encoder and Deconder
The convolutional and deconvolutional operations in CRHNs form a weight-sharing encoder–decoder architecture that enables structured feature extraction and reconstruction.
The convolutional encoder maps an input image $x\in\mathbb{R}^{C\times H\times W}$ into a latent representation through a sequence of convolutional layers. For a single convolutional layer, the feature map is computed as
$$

### IV-B Restricted Hopfield Networks
Once the Convolutional Encoder encode the input images into a latent vector, the latent vector will be fed into the RHNs with $K$ hidden layers. Without losing generality, let the first layer connected to the Convolutional module be considered as hidden layer 0, so the hidden layers can be indexed as $h_{0},h_{1},\cdots,h_{K}$.
The weight matrix between any two interrelated layers is indexed as $W_{1},W_{2},\cdots,W_{K}$, and the bias terms related to the layers are indexed by $\theta_{0},\theta_{1},\cdots,\theta_{K}$. In the forward path, the signal before activation is represented by $U$, which is indexed as $U_{1},U_{2},\cdots,U_{K}$, and after the activation function is represented by $H$, which is indexed as $H_{0},H_{1},H_{2},\cdots,H_{K}$. Please note that $H_{0}$ is actually the input signal. In the backward path, the reconstructed signal before activation is represented by $R$, which is indexed as $R_{K-1},\cdots,R_{0}$, and after the activation function is represented by $V$, which is indexed as $V_{K},V_{K-1},\cdots,V_{1},V_{0}$. Please note that $V_{K}$ is actually $H_{K}$.
Then, the dynamical behavior of the RHNs can be described as follows.

### IV-C Stability Analysis
###### Proposition 1 (Lyapunov stability of RHN dynamics).
Consider Restricted Hopfield Networks (RHNs) with forward and backward dynamics defined in Equations 9 and 10. Define the energy function
$$

### IV-D Mathematical Formulation for Subspace Rotation Algorithm
###### Proposition 2 (Subspace Rotation for Optimal Weight Alignment in RHNs).
Let a RHN store $p$ patterns of dimension $m$, represented by $Y\in\mathbb{R}^{m\times p}$. Assume the weight matrix $W\in\mathbb{R}^{m\times p}$ is orthogonal, and the RHNs output are given by
$$

### IV-E Robustness Analysis of Convolutional Restricted Hopfield Network
###### Proposition 3 (Robustness of semi-orthogonal weights to adversarial perturbations).
Let $W\in\mathbb{R}^{d\times m}$ be a semi-orthogonal matrix such that $W^{\top}W=I_{m}$. Consider the RHN retrieval operator $F(x):=\phi(WW^{\top}x)$, where $\phi(\cdot)$ is applied component-wise and is assumed to be $1$ -Lipschitz with respect to the $\ell_{2}$ norm.
Then, for any input vector $x\in\mathbb{R}^{d}$ and any perturbation $\delta\in\mathbb{R}^{d}$, we have

### V-A Sample Preparation and Training Configuration
All experiments are conducted on the Self-Taught Learning (STL) dataset [^4], where images are resized to $96\times 96$ and normalized to the range $[-1,1]$. From the dataset, we construct memory sets of varying sizes, including 50, 100, 250, and 500 images, to evaluate the scalability of different associative memory models. For each setting, the same subset of images is used across all models to ensure a fair comparison.
All models, including CRHNs, MHNs, and PCNs, are trained to memorize the selected samples using identical input representations. PCNs and MHNs follow their standard formulations. The MHNs are trained using the Adam optimizer with a learning rate of $1\times 10^{-4}$. For PCNs, following [^36], we adopt the SGD optimizer with a learning rate of $1\times 10^{-4}$ due to the use of estimated gradients. The training of CRHNs is divided into two stages. First, the encoder–decoder is trained to learn a compact representation of the input data, with shared weights to enforce structural consistency. Second, the latent representations are stored in the RHNs using the SRA, including LSRA and RSRA, which promotes semi-orthogonal weight structures. Each experiment is repeated five times with different random initializations to ensure statistical reliability.
For PCNs, we follow [^36] and adopt an implementation adapted from a publicly available repository <sup>1</sup>. For MHNs, we follow [^29] and use the Hopfield layers framework <sup>2</sup>.

### V-B Evaluation Metrics
(a) 10 Columns are Corrupted
(a) Δ = − 0.7 \\Delta=-0.7
We evaluate the auto-associative memory models under multiple input degradations to assess both reconstruction accuracy and robustness. The perturbations include photometric transformations, structural corruptions, and gradient-based adversarial variations.


## Key insights
- A novel CRHNs framework is proposed to integrate convolutional feature extraction with RHNs dynamics. The proposed architecture enables the network to store and retrieve complex image patterns in a compact latent space while preserving spatial structures and semantic information.
- Adversarial samples are generated using a surrogate convolutional autoencoder trained on STL images. Perturbations are computed with $\epsilon=0.6$ and evaluated consistently across all models.
- Both models share the same convolutional encoder–decoder. The ablated model removes the RHN module, isolating the contribution of attractor-based retrieval dynamics.

## Exemplos e evidências
See original source at `Clippings/Robust Auto-associative Memory via Convolutional Restricted Hopfield Networks.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/harness]]
- [[03-RESOURCES/concepts/llm-ml-foundations/transformer]]
- [[03-RESOURCES/concepts/software-engineering/proof]]
- [[03-RESOURCES/entities/Uber]]
- [[03-RESOURCES/entities/Rust]]
