---
title: "It’s Much Easier for Neural Networks to Learn Game of Life Dynamics with the Right Activation Function: Polynomial Kolmogorov-Arnold Networks"
type: source
source: "Clippings/It’s Much Easier for Neural Networks to Learn Game of Life Dynamics with the Right Activation Function Polynomial Kolmogorov-Arnold Networks.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [concurso, source-page]
---

## Tese central
Previous work has found a gap between the scale of neural networks that reliably learn Conway’s Game of Life, and minimal networks capable of representing the classic cellular automaton with hard-coded parameter values. Viewing neural network learning as a search process suggests a dependence on networks large enough to contain sub-networks with lucky initializations (sometimes known as ‘winning tickets’) that actually learn the task. In this work, we reorient our perspective from discovering Li

## Argumentos principais
### Introduction
The capacity of artificial Neural Networks (NNs) to model and predict complex dynamical systems is a central pursuit in the field of scientific Machine Learning (ML) and Artificial Intelligence (AI). As a tool, NNs can be used as models of complex systems and for analysis of experimental data. More broadly, world models with some physical understanding of their environment may be a necessary ingredient in developing intelligent machines.
Cellular Automata (CA) share many traits with the structure and rules of our physical universe including locality, dynamics, and complexity. CA are widely used as models for a broad range of physical systems [^23], and the universe as cellular automaton has been an influential idea related to the concept of a computational universe of digital physics since the 1970s or earlier [^24]. CA are typically discrete, spatially extended dynamical systems characterized by local interactions, finite state spaces, and synchronous updates across a lattice grid. As such they can be treated as convenient ‘pocket universes’ in exploring the expressive power, algorithmic learning capabilities, and structural inductive biases of deep NN architectures.
Life-like CA as learning targets for convolutional NNs would appear to be a fitting match. Work in the 1980s exploring the functional approximation capabilities of NNs [^16] [^17] eventually culminated in the universal approximation theorem (UAT), establishing NNs with a single hidden layer and nonlinear squashing function as capable of approximating arbitrary functions [^2] [^12]. The inductive bias of 3x3 convolutional layers matches the locality defined in CA with local Moore neighborhoods, and indeed Life-like CA can be represented by and thought of as NNs with an architecture of convolutional layers followed by multilayer perceptron (MLP) layers for representing spatiality and dynamics rules, respectively [^8].

### Conway’s Game of Life
Where [^8] trained neural networks on randomly selected CA from the space of Life-like CA and [^22] attempted to train NNs to predict Life states after 1 to 5 transition steps, we focus on the single-step Life problem.
Conway’s Game of Life operates on an interval-based, strictly non-monotonic logical predicate. Let $N$ represent the total sum of living cells in the surrounding Moore neighborhood, and let $C_{t}$ represent the binary state of the center cell at the current time step. The definitive update rule for the cell’s state at the subsequent time step, $C_{t+1}$, is defined mathematically as follows [^7] [^1]:
- $C_{t+1}=1$, if $N=3$. (‘Birth’).

### The Lottery Ticket Hypothesis and Learning Life with ReLU networks
[^22] examined the efficacy of small convolutional networks trained to predict a specified number of steps, denoted as $n$, into the future of Conway’s Game of Life. The transition rules of this two- dimensional automaton can be implemented efficiently in a $2n+1$ layer convolutional network requiring a minimal allocation of exactly $23n+2$ trainable parameters.
A minimal ReLU network representing the Life transition step can be written in a few lines with parameter values given in Section A.1 by [^22]. Nonetheless, they reported just 3 out of 64 training instances of the minimal ReLU network learned the Life transition successfully, only achieving a success rate in excess of 0.50 with $m=3$ overcomplete networks (69 parameters).
A possible explanation for the failure of minimal ReLU networks can be found in the concept of the Lottery Ticket Hypothesis [^6]. This hypothesis describes deep learning as fundamentally a lucky search problem, where dense, randomly initialized neural networks initially contain much smaller, sparse sub-networks (‘winning tickets’) that are able to converge via gradient descent. These sub-networks dominate model dynamics after training, whereas ‘losing tickets’ may contribute negligibly and can be pruned away.

### The Kolmogorov-Arnold Representation Theorem
Traditional Multi-Layer Perceptrons (MLPs) and CNNs are theoretically grounded in the Universal Approximation Theorem [^2] [^11] [^12]. This theorem states that a feedforward network containing at least a single hidden layer and utilizing a fixed, non-polynomial activation function can approximate any continuous function.
KANs [^18] are directly inspired by the Kolmogorov-Arnold representation theorem [^15]. This theorem, a profound result in real analysis, posits that any multivariate continuous function defined on a bounded domain can be exactly represented as a finite composition of continuous functions of a single variable and the simple binary operation of addition. Mathematically, if $f$ is a multivariate continuous function on a bounded domain, it can be decomposed as:
$$

### Experiments
Figure 2: Diagram of model architecture. σ \\sigma is a sigmoid activation function, and ψ \\psi represents arbitrary activation functions (including polynomials). m, the overcompleteness factor, modifies the width or number of filter channels in the neighborhood and update learning layers. Second line is PyTorch pseudocode used for instantiating each layer. Adapted/updated from 22 Figure 2 (left).

### Model Framework and Training Data.
All experiments are based on an input grid size of 32x32 cells. Grid edges are identified to make for periodic boundary conditions, and all models use ‘circular’ padding mode to match. We matched the 8 sample batch size of [^22] and use a fast Life-like CA simulator written in PyTorch to continuously generate CA states from random binary initial grid states [^3]. An epoch is not a meaningful concept if the model is not expected to ever see the same data twice, so we track model updates instead of epochs.
Model architecture is shown in Figure 2. Most model variants differ in the choice of activation functions readily available in PyTorch, and the polynomial activation function used in PolyKAN can be written as
$$

### Minimal Networks by Activation Function
Our first experiment tested 10 different activation functions in minimal $\mathcal{L}(1,1)$ models. In addition to the custom 2nd degree polynomial used in our PolyKAN network, we tested parametric ReLU [^9], Square ($x^{2}$), SiLU, RootSquare ($\sqrt{x^{2}}$), LeakyReLU [^19], CELU, Sigmoid, hyperbolic tangent, and ReLU.
Our experiment consisted of 16 training runs and the success rates are shown in Figure 3.
Figure 3: Success rates, minimal models by activation function.

### Modifying Initial Density of Cell States
A major shortcoming of training minimal ReLU conv-nets on Life is sensitivity to initial cell state density. A maximum training efficacy at about 0.38 on-density, corresponding to the maximum probability that any given cell will be on in the next time step, was previously identified [^22].
We investigated success rates for 3 of the best-performing activation functions, and ReLU, across initial on-density from 0.05 to 0.95, for 16 training runs each. We used $\mathcal{L}(1,2)$ and minimal $\mathcal{L}(1,1)$ models.
All model variants fail entirely for initial on-state density $d_{0}=0.95$, where most, but not every, batch of size 8 contain no on-state cells at all after 1 step. The overall success rate of ReLU is too low to validate (or refute) the exact density optimum from [^22] in our relatively small number of training runs, but $\mathcal{L}(1,2)$ ReLU networks did achieve their maximum accuracy of $0.3125$ at $d_{0}=0.40$ and $d_{0}=0.60$.

### Parameter Perturbation
Even when ReLU networks are successfully trained on Life CA, small parameter perturbations significantly degrade the ability of a model to re-train on Life dynamics. The degradation applies when parameters are subjected to a number $k$ of sign flips, increasing in severity from 1 flip to 8, or the addition of uniform random noise. The degradation affects model training performance whether the perturbation is applied to final, trained parameters or to initial parameters before re-training [^22].
Following [^22], we applied parameter perturbations of 0 to 8 sign flips and uniform random noise from 0.0 to 1.0 magnitude to successfully trained model parameters and to initial parameters logged from successful training runs. Due to a low number of successful $\mathcal{L}(1,1)$ ReLU networks, we used $\mathcal{L}(1,2)$.
Results are shown in Figure 5, with all model types demonstrating some re-training degradation with parameter perturbation. SiLU $\mathcal{L}(1,1)$ networks showed the strongest degradation of re-training performance with $k$ sign flips, though ReLU $\mathcal{L}(1,2)$ networks also failed more often with increasing $k$. PolyKAN shows some degradation re-training from final weights with $k$ sign flips (though the trend is not empirically correlated with increasing flips at these sample sizes), and notable degradation at uniform random noise perturbation at magnitudes of 0.75 and above applied to final and initial parameter values.

### Synaptic and Activation Function Learning Ablation
Our PolyKAN implementation includes trainable synaptic weights as well as trainable coefficients in the polynomial activation functions applied to each channel. The KAN framework does not include trainable weights [^18]. We performed ablation studies with either synaptic or activation function learning disabled to discover whether our PolyKAN implementation could still learn Life rules without learning any neural weights in the 1x1 update layers. We also included PReLU networks; comparisons of success rates for PolyKAN and PReLU under different ablation conditions are shown in Figure Figure 6.
Notably the performance of PolyKAN with trainable neural weights and polynomial coefficients (34 trainable parameters) and only polynomial coefficients and 3x3 convolution weights for learning neighborhoods (29 trainable parameters) both trained successfully on Life rules in 128/128 training runs. With polynomial coefficients frozen throughout training the PolyKAN success rate dropped to 0.78 (25 trainable parameters).
PReLU also achieved a minimal success rate, 0.59, with synaptic weight learning only (25 parameters, equivalent to a leaky ReLU with the slope for negative inputs at $a=0.25$). Over 128 runs, PReLU was successful 124 out of 128 times with full training (28 trainable parameters) and the full 128 times with update rule synaptic weights frozen (23 trainable parameters), learning only from adjusting the leaky PReLU slope.

### Discussion
Perhaps there’s no surprise in that the PolyKAN, jointly inspired by Kolmogorov-Arnold Networks and the implications of the Kolmogorov-Arnold Representation Theorem [^18], and [^14] [^5] consistently learns the rules of Life in a minimal architecture, but that several other activation function choices do as well. In particular the performance of PReLU, little more than a glorified leaky ReLU, may be worth nothing.
The universal approximation theorem, partly inspired by the KART, does not require that activation functions be monotonic (or not) [^2] [^12], though functional smoothness and smooth differentiability in the classic formulation are important [^10] [^12]. In practice ReLU NNs are capable of approximating arbitrary functions. Given the easy construction of a minimal Life NN using ReLUs, however, the smoothness and width/depth arguments [^21] are not specifically necessary here for approximation competence.
We note that there is no lack of capacity for minimal ReLU networks to represent Life rules perfectly. Hand-coded examples are readily available in [^22] and the repository for this manuscript. Instead the difficulty arises in learning, and it is there that smooth differentiability may facilitate easier success in solving Life via gradient descent.

### Conclusions
Our results are simple: that learning single-step Game of Life dynamics is hindered by ReLU activation in minimal neural networks and significantly improved by several other activation functions, and suggestive: that choosing a fitting activation function for a given problem can improve training without falling back on an idle dependence on excessive scale.
Taking the perspective of Life and similar CA as pocket universes with their own simple physics, the present work can be taken as a simplified analogy for physics-based deep learning and machine learning applications in science.
Among ‘Linear Unit’ family activation functions, smoothly differentiable SiLU outperformed both discontinuously differentiable LeakyReLU and ReLU, and CELU, for which only the first derivative is continuous. Pilot experiments with other widely available LU activations seem to follow a similar pattern.

### Acknowledgements
QTD and TA would like to express their sincere gratitude to the ALIFE 2026 Organizing Committee for their tremendous support, and also thanks the reviewers and meta-reviewers for their thoughtful evaluations, constructive feedback, and valuable suggestions that helped improve the quality and clarity of this work. QTD would like to thank the friendly support of colleagues at Cross Labs during the completion of this project.
[^1]: Winning ways for your mathematical plays volume 4. second edition. A K Peters, Wellesly, Massachusetts. Cited by: [Introduction](#Sx1.p9.1 "Introduction ‣ It’s Much Easier for Neural Networks to Learn Game of Life Dynamics with the Right Activation Function: Polynomial Kolmogorov-Arnold Networks"), [Conway’s Game of Life](#Sx2.p2.3 "Conway’s Game of Life ‣ It’s Much Easier for Neural Networks to Learn Game of Life Dynamics with the Right Activation Function: Polynomial Kolmogorov-Arnold Networks").
[^2]: Approximation by superpositions of a sigmoidal function. Mathematics of Control, Signals and Systems 2, pp. 303–314. Cited by: [Introduction](#Sx1.p3.1 "Introduction ‣ It’s Much Easier for Neural Networks to Learn Game of Life Dynamics with the Right Activation Function: Polynomial Kolmogorov-Arnold Networks"), [The Kolmogorov-Arnold Representation Theorem](#Sx3.SSx1.p1.1 "The Kolmogorov-Arnold Representation Theorem ‣ The Lottery Ticket Hypothesis and Learning Life with ReLU networks ‣ It’s Much Easier for Neural Networks to Learn Game of Life Dynamics with the Right Activation Function: Polynomial Kolmogorov-Arnold Networks"), [Discussion](#Sx5.p2.1 "Discussion ‣ It’s Much Easier for Neural Networks to Learn Game of Life Dynamics with the Right Activation Function: Polynomial Kolmogorov-Arnold Networks").


## Key insights
- $C_{t+1}=1$, if $N=3$. (‘Birth’).
- $C_{t+1}=1$, if $N=3$ or $N=2$ and $C_{t}=1$. (‘Survival’)
- $C_{t+1}=0$, in all other cases.

## Exemplos e evidências
See original source at `Clippings/It’s Much Easier for Neural Networks to Learn Game of Life Dynamics with the Right Activation Function Polynomial Kolmogorov-Arnold Networks.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/neural-network]]
- [[03-RESOURCES/concepts/ai-agents/tool]]
- [[03-RESOURCES/concepts/software-engineering/theorem]]
