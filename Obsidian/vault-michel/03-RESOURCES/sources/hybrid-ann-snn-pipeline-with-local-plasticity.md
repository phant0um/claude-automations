---
title: "Hybrid ANN-SNN Pipeline with Local Plasticity"
type: source
source: "Clippings/Hybrid ANN-SNN Pipeline with Local Plasticity.md"
created: 2026-06-23
ingested: 2026-06-23
score: C
tags: [articles, source-page]
---

## Tese central
This work proposes a hybrid ANN-SNN pipeline that effectively leverages the rich embeddings of pretrained artificial neural networks (ANNs) to enable high-performance spiking neural networks (SNNs). The architecture couples a pretrained EfficientNet encoder with a CoLaNET spiking classifier. We convert the encoder’s activations into spike trains via rate-coding and train the subsequent SNN classifier using local, biologically inspired learning rules, bypassing end-to-end gradient propagation.

## Argumentos principais
### 1 Introduction
Spiking Neural Networks (SNNs) are a class of neural networks based on temporal and event-driven signal transmission, inspired by biological neural systems [^14]. Unlike traditional Artificial Neural Networks (ANNs), which process information using continuous-valued activations, SNNs operate with discrete events (spikes), enabling more efficient and biologically plausible computation [^2].
In contrast to ANNs, which use matrix multiplications (suitable for GPUs), SNNs are fully asynchronous, use event-driven computations, and have several other features that make GPUs an inefficient hardware platform for their execution. However, when implemented on specialized neuromorphic hardware, SNNs may offer high energy efficiency and low latency [^4]. Since spikes are generated only when necessary, SNN-based hardware systems can significantly reduce computational power consumption, making them suitable for embedded systems, robotics, and edge devices with limited resources [^17].
There are several approaches to training SNNs:

### 2 Related works
Works [^8] [^7] [^9] introduce the CoLaNET (Columnar Layered Network) architecture for classification tasks. CoLaNET is a single-layer fully connected network, so we cannot directly use it for large image classification except for small-sized pictures. For instance, [^7] used the MNIST dataset, interpreting pixel intensity values as spike frequencies. To process larger images, the authors propose using dimensionality reduction methods or encoders.
Work [^13] studies the CoLaNET architecture in a continual learning protocol, again on simple datasets (MNIST, EMNIST, PermutedMNIST). This study shows that the network’s resistance to catastrophic forgetting critically depends on the generality of feature representations across tasks. To address the generality problem, the authors propose adding a hierarchically structured encoder that converts large images into semantically rich feature representations but with low generality.
This paper continues the above works by proposing to couple a spiking neural network classifier (CoLaNET) with a hierarchically structured encoder. Such encoders are widely available in convolutional neural networks (CNNs).

### 3.1 CoLaNET architecture
CoLaNET (Columnar Layered Network) architecture [^8] [^7] [^9] [^10] embodies columnar organization in SNNs with local learning, neuronal competition, modulated plasticity, and gating mechanisms. Designed for supervised classification, CoLaNET’s key feature integrates anti-Hebbian plasticity (degrading weights) with modulated plasticity (strengthening weights), counteracting degradation and enabling effective learning.
CoLaNET consists of multiple identical modules (columns), with column count matching class count. Each column has trainable fully connected input layer (many L neurons), intermediate processing layer (single BIASGATE neuron), and output layer (single OUT neuron). L neurons inside one column correspond to significantly distinctive instances (sub-classes) of one class. All neurons are described by the simplest LIF (leaky integrate-and-fire) model with slight modifications described later.
Figure 1: CoLaNET architecture, inference regime. The image is presented over 10 time steps, followed by 5 time steps of silence (empty image). The neuron L that first generates a spike suppresses other L neurons within the same column and propagates the spike to the OUT neuron. The class is determined by the column producing the highest number of spikes.

### 3.2 EfficientNet encoder
The EfficientNet family [^19] provides a principled approach to scaling CNNs. Unlike traditional CNNs that independently increase depth, width, or resolution, EfficientNet uses a compound scaling method that balances all three dimensions simultaneously.
Models range from B0 (lightest) to B7 (most accurate). This scaling strategy yields strong performance: EfficientNets consistently achieve higher accuracy with fewer parameters and FLOPs than many CNN architectures [^19].
We select EfficientNet-B3, pretrained on ImageNet [^1], as the feature extraction backbone. We use weights from the PyTorch repository (see source code for details). B3 contains approximately 10.8M parameters and requires 1.8B FLOPs per image in inference mode. ImageNet is a large‑scale visual recognition benchmark containing 1000 object classes, 1,281,167 training images, 50,000 validation images, and 100,000 test images. Due to its scale and diversity, it has become a standard foundation for training and evaluating general‑purpose visual representations.

### 4.1 Dataset subsets
In experiments, researchers often use subsets of the original ImageNet instead of the full dataset. These subsets not only contain fewer images per class but also have all images resized to a consistent dimension. The original dataset requires approximately 150 GB of storage and is not publicly accessible, so this work utilizes one of the popular subsets available on the Kaggle platform (see source code for details), where all images are resized to 256×256×3 and centered.
Moreover, training large SNNs poses considerable challenges due to hardware resource constraints; therefore, we additionally restrict the number of classes. We construct two balanced subsets that focus on experimental evaluation while preserving the generality of the original categories. Each subset is built from visually distinct object classes, ensuring a wide range of semantic concepts and appearance variations (illumination, background, scale, viewpoint).
The first subset comprises 26 categories, with approximately 80 images per class, totaling 15,691 images. The second subset contains 64 categories, with roughly 90 images per class, totaling 35,179 images. In both subsets, the data are split into non‑overlapping training and testing sets using an 80/20 ratio and are shuffled.

### 4.2 Hybrid architecture
Figure 3 presents the proposed hybrid ANN-SNN architecture. It combines convolutional feature extraction via EfficientNet-B3 with spike-based processing in CoLaNET.
Figure 3: The architecture consists of an EfficientNet‑B3 encoder followed by a CoLaNET classifier. The input 256×256×3 image first passes through a stem 3×3 stride‑2 convolution, yielding 128×128×40 feature maps, which are then processed by a series of MBConv layers, progressively reducing spatial size to 8×8 with 384 channels. A head 1×1 convolution expands the depth to 1536 channels, followed by global average pooling to produce a 1536‑dimensional vector. This vector is rate‑coded by CoLaNET over 10 presentation steps with a subsequent 5‑step silence period, and finally classified via argmax (e.g., into classes like "bee eater")
The conversion from activation vectors to spike trains proceeds in three steps. First, we suppress all negative activation values to zero—conceptually equivalent to ReLU. Second, we use an expertly chosen threshold. Activations at or above this threshold produce spikes at every timestep. Third, we linearly scale sub-threshold activations to a spike count between 0 and 10. Higher activations yield more spikes.

### 5 Experiments
We implemented all training and evaluation experiments using the ArNI-X framework [^5]. Since CoLaNET was originally designed in ArNI-X, the framework includes all necessary mechanics.
Each training sample is presented to the network exactly once — no epoch-based repetition is employed. Learning is thus online and single-pass: the network adapts its synaptic weights continuously as new examples arrive, without revisiting previously seen data.
First, we evaluated the hybrid architecture on the 26-class subset. The model achieved stable learning and high classification performance, exceeding 99% test accuracy. Encouraged by this result, we next tested the larger 64-class subset. This setting introduces greater semantic diversity and classification complexity, allowing us to assess scalability and robustness under more challenging conditions. This work omits the details of the 26-class experiment, but they are available in the source code.

### 5.1 Network optimization
Training SNNs introduces additional complexity in hyperparameter tuning, as the optimization landscape is highly non-uniform and generally non-smooth. A common approach under such conditions is to apply a genetic algorithm (GA) followed by gradient-based or stochastic descent from the best configuration [^3].
In this work, we adopted the optimization scheme and baseline configuration from [^7], where CoLaNET was optimized for MNIST handwritten digit recognition. We used a similar hyperparameter set, adjusted for the architectural evolution of CoLaNET, for the 64-column version of the network. We also fixed the number of CoLaNETs in the ensemble at 15.
We optimized the hyperparameters using a genetic algorithm. The accuracy metric reached 99.09% at the 11th generation and remained unchanged after the 12th generation. Each generation comprised 300 candidates, with each candidate encoding 9 parameters that controlled synaptic plasticity, weight dynamics, stochastic stimulation, and network structure. At each generation, we evaluated all candidates on the classification task and ranked them by test accuracy (fitness). We preserved the best individuals via elitism and generated the remaining population through crossover between selected parents.

### 5.2 Results
The best classification accuracy optimization reached is 99.09%. Table 1 lists the optimal parameter values found.
Table 1: Best hyperparameter configuration obtained by optimization
| Parameter | Optimized value |

### 6 Discussion
EfficientNet-B3 encoder was pretrained on the full ImageNet-1K dataset, from which our 64-class subset was drawn. The encoder was therefore exposed to the test images during its original training, and the reported accuracy may partly reflect retrieval of previously learned representations rather than learning of entirely novel categories. We acknowledge this openly while emphasizing that our primary objective here is different: we aim to demonstrate that a frozen ANN encoder can be effectively coupled with a spiking classifier initialized with zero weights and trained exclusively with local plasticity rules. Whether the encoder generalizes to genuinely unseen distributions is a separate question. A rigorous test would require a dataset with classes absent from the encoder’s pretraining — a direction we consider important for future work.
Notably, the reported accuracy is achieved in a single-pass, online learning regime: each training example is presented only once, and the network never revisits previously seen data. This is a non-trivial property that distinguishes local plasticity approaches from gradient-based methods, which typically require multiple epochs of shuffled replay.
Using an ensemble rather than a single CoLaNET classifier increases the parameter count, but the cost is minimal. All instances share one frozen encoder, so expensive feature extraction runs once per image. Prior works [^8] [^7] [^3] show that CoLaNET ensembles yield the largest gain in accuracy precisely when individual classifiers are weak. One costly encoder, many cheap spiking decoders — this asymmetric architecture prioritizes accuracy while keeping the decision stage efficient and biologically plausible.

### 7 Conclusion
We proposed a hybrid ANN-SNN architecture that couples a frozen EfficientNet-B3 encoder with a CoLaNET spiking classifier, trained exclusively with local, biologically inspired plasticity rules. On a 64-class ImageNet subset, this pipeline achieved 99.09% classification accuracy, matching the performance of conventional deep networks.
This design embodies a pragmatic and powerful paradigm: decouple feature extraction from decision-making to let each paradigm (ANN and SNN) operate where it excels. The ANN encoder efficiently distills high-dimensional images from the real world into compact, semantically rich feature vectors — a task that remains very difficult for end-to-end SNN training. The SNN classifier then processes these representations using event-driven computation and local learning, opening a direct path to ultra-low-power neuromorphic hardware without sacrificing accuracy.
Even in its current hybrid form, implementing this architecture on neuromorphic hardware is justifiable for on-device continual learning — following the blueprint established by projects like Akida [^4], where a frozen convolutional encoder feeds a plastic on-chip spiking classifier. However, from an energy-efficiency standpoint, the heavy ANN encoder remains a bottleneck, consuming the bulk of computational resources. The most promising direction for future work, therefore, is converting the ANN encoder into a fully spiking model that operates on event-based principles and continues to be frozen. Such a conversion would eliminate the activation-to-spike encoding step entirely and unlock the full potential of neuromorphic processors, delivering end-to-end event-driven computations with dramatically lower power consumption and latency.


## Key insights
- This approach achieves 99.09% accuracy on a 64-class ImageNet benchmark, demonstrating performance on par with conventional deep networks.
- There are several approaches to training SNNs:

Although gradient-based or conversion approaches often achieve better accuracy, local plasticity rules are the primary candidates for building energy-efficient, low-latency systems capable of continuous learning [^12].
- This approach achieves 99.09% accuracy on a 64-class ImageNet benchmark, demonstrating performance on par with conventional deep networks.
- The source code and experimental results are open-source and available at: 

## 2 Related works

Works [^8] [^7] [^9] introduce the CoLaNET (Columnar Layered Network) architecture for classification tasks.
- To process larger images, the authors propose using dimensionality reduction methods or encoders.
- To address the generality problem, the authors propose adding a hierarchically structured encoder that converts large images into semantically rich feature representations but with low generality.
- All neurons are described by the simplest LIF (leaky integrate-and-fire) model with slight modifications described later.
- This scaling strategy yields strong performance: EfficientNets consistently achieve higher accuracy with fewer parameters and FLOPs than many CNN architectures [^19].
- ImageNet is a large‑scale visual recognition benchmark containing 1000 object classes, 1,281,167 training images, 50,000 validation images, and 100,000 test images.
- The model achieved stable learning and high classification performance, exceeding 99% test accuracy.

## Exemplos e evidências
See original source at `Clippings/Hybrid ANN-SNN Pipeline with Local Plasticity.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/neural-network]]
- [[03-RESOURCES/concepts/ai-agents/benchmark]]
- [[03-RESOURCES/concepts/software-engineering/runtime]]
- [[03-RESOURCES/entities/NVIDIA]]
- [[03-RESOURCES/entities/Apple]]
- [[03-RESOURCES/entities/CUDA]]
