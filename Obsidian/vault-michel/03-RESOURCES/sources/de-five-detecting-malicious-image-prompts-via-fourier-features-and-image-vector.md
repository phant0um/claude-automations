---
title: "DE-FIVE: Detecting Malicious Image Prompts via Fourier Features and Image Vector Embeddings"
type: source
source: "Clippings/DE-FIVE Detecting Malicious Image Prompts via Fourier Features and Image Vector Embeddings.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
Vision language models (VLMs) employ both visual and textual modalities to enable advanced vision–language inference. However, incorporating visual modalities expands the attack surface of VLMs, making them more susceptible to security threats such as adversarial perturbations and indirect prompt injection, wherein crafted malicious image prompts can elicit unintended model outputs. Existing defense methods against malicious image prompts remain insufficient as they typically demand extensive da

## Argumentos principais
### I Introduction
Recent progress in large language models (LLMs) [^1] [^2] [^3] [^4] has facilitated the emergence of vision–language models (VLMs) [^5] [^6] [^7] [^8] [^9] [^10], such as LLaVA [^5] and GPT-4 [^8]. Whereas LLMs operate solely on textual inputs, VLMs extend this capability by jointly handling visual and textual information. Benefiting from both the visual and textual modalities, VLMs exhibit superior performance on diverse vision–language tasks, such as visual question answering [^11] [^12] and intelligent medical consultation [^13]. However, the added visual modality expands the attack surface of VLMs, making them especially susceptible to malicious image prompts.
Malicious image prompt attacks against VLMs can be broadly classified into two categories: jailbreak attacks [^14] [^15] [^16] [^17] and indirect prompt injection attacks [^18] [^19] [^20] [^21]. Both categories rely on embedding adversarial instructions into images through carefully crafted perturbations. The key distinction lies in the underlying threat model. In jailbreak attacks, the VLM user acts as the adversary and intentionally employs hidden prompts to circumvent the model’s safety mechanisms [^22] [^23]. Consequently, the VLM’s output follows the adversarial objective while disregarding the legitimate image-related query. In contrast, indirect prompt injection attacks target unsuspecting users: the adversarial prompt is embedded by a third party, and the VLM is induced to both answer the user’s image related question and simultaneously execute the injected adversarial instruction.
Therefore, detecting malicious image prompt attacks is essential for strengthening the security of VLMs. Existing defense mechanisms predominantly target jailbreak attacks [^24] [^25] [^26] [^27] [^28] [^29] [^30] [^31], and many rely on large amounts of annotated data [^32]. VLMGuard [^33] represents the first approach capable of handling both categories of malicious image prompt attacks. It facilitates adversarial prompt detection using only unlabeled data by introducing an automated maliciousness-estimation score derived from embeddings, followed by training a binary classifier, thereby eliminating the need for extensive manually labeled datasets. However, the method relies on a carefully tuned mixing ratio for constructing the classifier’s training set, which complicates practical deployment.

### II-A Vision Language Models (VLMs)
Unlike traditional LLMs [^1] [^2] [^3], which only process textual prompts, VLMs $F_{\theta}$ typically comprise a visual encoder $F_{e}$, a cross-modal connector $F_{c}$, and a large language model $F_{l}$ [^5] [^8] [^10]. Given a multimodal input consisting of an image $I\in\mathbb{I}$ and a textual query $T\in\mathbb{T}$, the visual encoder first maps the image to a visual embedding $h_{e}=F_{e}(I)$ [^34] [^35]. The connector $F_{c}$ then integrates the visual embedding with the textual prompt, producing the fused representation $F_{c}(h_{e},T)$, which is subsequently processed by the LLM to generate the final output [^21]. The end-to-end inference pipeline of a VLM can therefore be expressed as:
$$
y=F_{l}\!\left(F_{c}(h_{e},T)\right).

### II-B Malicious Image Prompt Attack
The malicious image prompt attacks via crafted perturbations in VLMs can generally be categorized into two groups: jailbreak attacks and indirect prompt injection attacks. We detailed each below.
#### II-B1 Jailbreak Attacks via Adversarial Images
Jailbreak attacks aim to manipulate the model into producing unsafe or policy-violating outputs by compromising its safety alignment through adversarial images. In this setting, image perturbations are often optimized iteratively using gradient-based algorithms, such as Projected Gradient Descent (PGD), to elicit harmful model responses [^14]. Prior work has shown that injecting adversarial noise into the visual input can lead VLMs to generate predetermined outputs, effectively bypassing their established safety constraints [^15]. Furthermore, jailbreak images can be constructed by maximizing the similarity between a fixed harmful text sequence and the model’s predicted output distribution [^16] [^17], thereby steering the VLM toward harmful content even when the visual perturbations remain subtle or imperceptible to human observers.

### II-C Malicious Image Prompt Detection
Effective detection of malicious image prompts plays a critical role in safeguarding the overall safety of VLMs. Existing detection approaches predominantly focus on jailbreak attacks and commonly rely on analyzing the textual outputs of the language model (LM). For instance, uncertainty-based scoring functions, such as perplexity [^24] and gradient-based scores [^25], have been applied to identify anomalous responses. LM-judge strategies [^27] further enable detection by directly querying the model to assess potential harmfulness.
Figure 3: Overview of the proposed Black-box detector based on Fourier-domain features.
In the multimodal setting, embedding-based methods [^28] [^29] evaluate the distance between the embeddings of an original image and its denoised counterpart to detect adversarial manipulations. Augmentation-based approaches [^21] [^31] similarly leverage image transformations to reveal inconsistencies indicative of malicious prompts. In addition, large-scale annotated datasets have been employed to train supervised harm detectors [^32].

### III-A Proposed Black-box Detector Based on Fourier-domain Features
To characterize the frequency-domain differences between clean and malicious images, we employ the two-dimensional Discrete Fourier Transform (DFT) [^36]. Given an input image $I$ of size $H\times W$, its DFT is computed as
$$
\mathcal{F}(u,v)=\sum_{x=0}^{H-1}\sum_{y=0}^{W-1}I\,e^{-j2\pi\left(\frac{ux}{H}+\frac{vy}{W}\right)}.

### III-B Proposed White-box Detector Based on image vector embeddings
As discussed in Section II-A, for a given visual input $I$, the visual encoder produces an embedding denoted by $h_{e}=F_{e}(I)$. This visual embedding strategy was previously introduced as a mechanism for steering the latent space to mitigate hallucination [^39]. We adopt this approach based on the observation that both hallucination and adversarial manipulation are closely related to instability in the model’s internal representations under input perturbations. In particular, hallucination arises when the model’s representations are overly sensitive to spurious or non-robust visual features, while malicious image prompt attacks deliberately exploit such sensitivities to inject adversarial signals.
To obtain a more robust representation of the visual input, we follow [^39] and compute the average embedding over a set of randomly masked variants of $I$.
$$

### III-C Hybrid Detection Strategy
While the proposed black-box Fourier-domain detector and white-box embedding-based detector each exhibit the capability to detect malicious image prompts, their detection signals stem from fundamentally different perspectives: the former exploits input-level spectral characteristics, whereas the latter captures latent-space deviations revealed through the behavior of the visual encoder. To harness the complementary strengths of these two modalities, we introduce a hybrid detection mechanism that integrates their respective scores. Specifically, the two detectors are combined to produce a unified malicious detection score for DE-FIVE:
$$
S_{\text{VG}}=\alpha S_{\text{DFT}}+(1-\alpha)S_{\text{RVE}},

### IV Experiments
This section presents an evaluation of the proposed method for the task of malicious image prompt detection. We first detail the experimental setup in Section IV-A, and then report the main results along with a comprehensive analysis in Sections IV-B–IV-C.

### IV-A Experiment Setup
#### IV-A1 Datasets and Models
We evaluate the proposed approach under two representative categories of malicious image prompt attacks: meta-instruction prompts for indirect prompt injection attacks [^21] and jailbreak prompts for jailbreak attacks [^17]. These two categories are selected as they capture fundamentally different attack mechanisms, hidden instruction injection versus safety alignment bypass, thereby enabling a comprehensive evaluation of detection robustness.
Meta-instruction prompts: We adopt the dataset introduced in [^33], which comprises 25 benign images from ImageNet, each paired with 60 questions. This dataset is chosen because it provides a controlled and diverse benchmark for evaluating indirect prompt injection, where malicious intent is embedded within the visual modality rather than explicitly expressed in text. Following [^21], a total of 300 malicious meta-instruction images are generated using 40 training question–answer pairs. These meta-instruction pairs target five distinct meta-objectives: LANGUAGE, POLITICS, FORMALITY, SPAM, and SENTIMENT [^21], ensuring coverage of diverse behavioral manipulations. Consequently, the test dataset consists of 25 benign and 300 malicious images as visual prompts, each paired with 20 textual questions, following the evaluation protocol in [^33].

### IV-B Main Result
Detection performance against meta-instruction prompts. The experimental results reported in Table I demonstrate that the proposed training-free DE-FIVE consistently achieves robust performance in detecting meta-instruction prompts across diverse meta-objectives. Moreover, the proposed approach achieves the highest average AUROC scores on both the LLaVA-1.6 and Phi-3 models when compared with all baseline methods.
Among the baseline approaches, GradSafe [^25] is the only training-free method; however, it achieves the lowest detection performance. The remaining four baseline methods [^31] [^29] [^24] [^33] demonstrate improved detection performance relative to GradSafe, but all rely on a training stage. In contrast, compared with the state-of-the-art VLMGuard [^33], which requires substantial amounts of unlabeled data for training, the proposed training-free DE-FIVE achieves average AUROC improvements of 2.6% and 2.9% on the LLaVA-1.6 and Phi-3 models, respectively.
Detection performance against jailbreak prompts. Beyond meta-instruction prompts, the experimental results reported in Table II indicate that the proposed training-free DE-FIVE also achieves the highest detection performance against jailbreak prompts on both the LLaVA-1.6 and Phi-3 models. The consistently strong performance across different VLM backbones suggests that DE-FIVE operates effectively without any training stage, making it a practical and easily deployable solution for real-world VLM safety applications.

### IV-C Analysis
In this section, we present additional analyses and ablation studies to evaluate the effectiveness of the proposed DE-FIVE. All experiments are conducted on the LLaVA-1.6 model.
Ablation on the proposed black-box detector: To investigate the effectiveness of the proposed black-box detector when operating on different Fourier-domain features, we compare three configurations: (1) the High-to-Low Frequency Energy Ratio described in Section III-A1, (2) the Spectral Entropy Surrogate described in Section III-A2, and (3) the proposed DFT-based malicious scores described in Section III-A3. We further compare these configurations with existing jailbreak defense baselines, including Perplexity [^24], GradSafe [^25], MirrorCheck [^29], and JailGuard [^31].
As shown in Table III, Perplexity [^24] achieves the highest AUROC against meta-instruction prompts but exhibits the lowest AUROC against jailbreak prompts. This observation indicates that existing jailbreak defense baselines struggle to maintain robust performance across both meta-instruction and jailbreak prompt settings. In contrast, the proposed DFT-based malicious scores achieve consistently strong performance on both types of prompts.

### V Conclusions
Existing approaches for detecting malicious prompts primarily focus on text-based jailbreak attacks or rely on training-heavy pipelines, making them less effective or inefficient when extended to multimodal settings. In particular, they often struggle to generalize across different types of malicious image prompts, such as meta-instruction and jailbreak prompts, or require substantial labeled data and retraining to adapt to new attack patterns.
To address these limitations, we introduce a novel training-free framework, termed DE-FIVE, for detecting malicious image prompts, including both meta-instruction and jailbreak prompts in this paper. Specifically, we first propose a black-box detector based on two complementary Fourier-domain features. We then develop a white-box detector leveraging image vector embeddings. By assigning adaptive weights to these two detectors, we further construct a hybrid detection strategy that integrates their respective strengths.
Experimental results demonstrate that DE-FIVE achieves superior detection performance without incurring any additional training cost when identifying malicious image prompts. Furthermore, comprehensive analyses and ablation studies provide deeper insights into the effectiveness and robustness of the proposed DE-FIVE framework.


## Key insights
- However, incorporating visual modalities expands the attack surface of VLMs, making them more susceptible to security threats such as adversarial perturbations and indirect prompt injection, wherein crafted malicious image prompts can elicit unintended model outputs.
- To address these limitations, we introduce DE-FIVE, a novel training-free framework for detecting malicious image prompts by leveraging Fourier features and the hidden state representations of the visual encoder (image vector embeddings) across perturbations.
- Extensive experiments demonstrate that the proposed framework consistently outperforms state-of-the-art baselines against malicious image prompts.
- The key distinction lies in the underlying threat model.
- In jailbreak attacks, the VLM user acts as the adversary and intentionally employs hidden prompts to circumvent the model’s safety mechanisms [^22] [^23].
- To address these issues, we introduce DE-FIVE, a framework designed to detect malicious image-prompt attacks without incurring additional training costs.
- First, we propose a black-box detector that operates directly on the input image by exploiting Fourier-domain features.
- Finally, we demonstrate that the combination of the black-box and white-box detectors leads to significant improvements in detection accuracy.
- The key contributions of this work are summarized as follows:

$\bullet$ We propose DE-FIVE, a novel training-free framework for detecting malicious image prompts.
- ## II Related Work

### II-A Vision Language Models (VLMs)

Unlike traditional LLMs [^1] [^2] [^3], which only process textual prompts, VLMs $F_{\theta}$ typically comprise a visual encoder $F_{e}$, a cross-modal connector $F_{c}$, and a large language model $F_{l}$ [^5] [^8] [^10].

## Exemplos e evidências
See original source at `Clippings/DE-FIVE Detecting Malicious Image Prompts via Fourier Features and Image Vector Embeddings.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/runtime]]
- [[03-RESOURCES/entities/OpenAI]]

## Minha Síntese
**O que muda:** A ser analisado em revisão manual.

**Conexão pessoal:** A ser conectado com projetos/estudo atuais.

**Próximo passo:** Nenhum próximo passo imediato.
