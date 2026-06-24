---
title: "Beyond Scalar Rewards by Internalizing Reasoning into Score Distributions"
type: source
category: ml-research-papers
source: "https://arxiv.org/html/2606.09076v2"
created: 2026-06-16
ingested: 2026-06-16
tags: [rlhf, reward-modeling, score-distributions, arxiv]
---

# Beyond Scalar Rewards by Internalizing Reasoning into Score Distributions

## Tese Central

Beyond scalar rewards: internalizing reasoning into score distributions provides richer training signal than single-value rewards, capturing the nuance of reasoning quality.

---

## Conteudo Original

Xin Jin <sup>1,2,∗</sup>   Huanqia Cai <sup>1,∗,†</sup>   Zhen Li <sup>1</sup>   Zechao Zhan <sup>1</sup>   Dengyang Jiang <sup>1</sup>   Aiming Hao <sup>1</sup>  
Yuming Jiang <sup>1</sup>   Chunle Guo <sup>2,‡</sup>   Peng Gao <sup>1,‡</sup>   Ming-Ming Cheng <sup>2</sup>   Steven C.H. Hoi <sup>1</sup>  
<sup>1</sup> Z-Image Team, Alibaba Group      <sup>2</sup> VCIP, CS, Nankai University  
<sup>∗</sup> Equal contribution      <sup>†</sup> Project lead      <sup>‡</sup> Corresponding authors  
Project page: [https://srameo.github.io/projects/z-reward/](https://srameo.github.io/projects/z-reward/)

###### Abstract

Reward models are central to text-to-image post-training, but visual preference is subjective and better represented as a distribution over rubric scores than as a deterministic scalar. Existing scalar, score-token, and pairwise reward models over-compress uncertainty and fine-grained score differences, while reasoning-based generative rewards provide stronger judgments but are costly to deploy and difficult to use as direct optimization signals. We propose Z-Reward, a teacher-student reward modeling framework that decouples reasoning-heavy judgment from efficient reward deployment. The teacher is a large VLM that uses reasoning to infer rubric-aligned score distributions, and is trained with Group-wise Direct Score Optimization (GDSO), which combines policy-gradient rewards from distribution expectations with direct pointwise and pairwise supervision on score distributions and score gaps. The student is trained with Reasoning-Internalized Score Distillation (RISD), which transfers the teacher’s reasoning-conditioned score distribution into a compact VLM without requiring explicit reasoning chains at inference time. On our internally annotated evaluation set, the 27B GDSO teacher reaches 89.6% human preference accuracy, outperforming SFT, RewardDance, and GRPO, while the 9B RISD student reaches 88.6%, outperforming the OPD baseline and closely matching the larger teacher. We further show that Z-Reward can serve as a differentiable reward signal for text-to-image optimization, yielding a 41.3% net human-preference improvement over SFT baseline.

## 1 Introduction

![Refer to caption](https://arxiv.org/html/2606.09076v2/x1.png)

Figure 1: Human preference accuracy for teacher optimization and student distillation. Left: accuracy curves over training steps show how reward-model performance evolves against SFT and RewardDance \[ wu2025rewarddancerewardscalingvisual \] baselines. Right: final accuracy comparison shows that the 27B GDSO teacher outperforms SFT, RewardDance, and GRPO deepseek-math, while the 9B RISD student reaches comparable performance to the larger teacher.

Table 1: Comparison of reward modeling paradigms for visual generation. Scalar or pairwise reward models are efficient but compress preference uncertainty, while reasoning-based generative reward models improve judgment quality at the cost of inference efficiency and direct differentiability. Z-Reward separates these roles: the teacher uses reasoning to infer score distributions, and the student internalizes this ability for efficient direct scoring and gradient backpropagation.

| Methods | Base Model | Modeling Paradigm | Training Strategy | Scoring Based on Reasoning | Score Distribution | Support Gradient Backpropagation | Inference Efficiency |
| --- | --- | --- | --- | --- | --- | --- | --- |
| ImageReward \[xu2023imagereward\] | CLIP | Regressive | SFT | $\times$ | $\times$ | ✓ | High |
| PickScore \[kirstain2023pickapicopendatasetuser\] | CLIP | Regressive | SFT | $\times$ | $\times$ | ✓ | High |
| HPSv2 \[wu2023humanpreferencescorev2\] | CLIP | Regressive | SFT | $\times$ | $\times$ | ✓ | High |
| VisionReward \[xu2026visionrewardfinegrainedmultidimensionalhuman\] | VLM | Regressive | SFT | $\times$ | $\times$ | ✓ | High |
| VideoAlign \[liu2025improvingvideogenerationhuman\] | VLM | Regressive | SFT | $\times$ | $\times$ | ✓ | High |
| HPSv3 \[ma2025hpsv3widespectrumhumanpreference\] | VLM | Regressive | SFT | $\times$ | ✓ | ✓ | High |
| WorldPM \[wang2025worldpmscalinghumanpreference\] | VLM | Regressive | RL | $\times$ | $\times$ | ✓ | High |
| DeepSeek-GRM \[liu2025inferencetimescalinggeneralistreward\] | VLM | Generative | SFT | ✓ | ✓ | $\times$ | Low |
| Pairwise RM \[liu2025pairjudgermperformbestofn\] | VLM | Generative | RL | $\times$ | ✓ | ✓ | High |
| GenRM-CoT \[zhang2025generativeverifiersrewardmodeling\] | VLM | Generative | SFT | ✓ | ✓ | ✓ | Low |
| Edit-R1 \[guo2026leveraging\] | VLM | Generative | RL | ✓ | $\times$ | $\times$ | Low |
| UnifiedReward \[wang2026unifiedrewardmodelmultimodal\] | VLM | Generative | SFT | ✓ | $\times$ | $\times$ | Low |
| RewardDance \[wu2025rewarddancerewardscalingvisual\] | VLM | Generative | SFT | $\times$ | ✓ | ✓ | High |
| Z-Reward-Teacher | VLM | Generative | RL & SFT | ✓ | ✓ | ✓ | Low |
| Z-Reward-Student | VLM | Generative | Distillation | Internalized | ✓ | ✓ | High |

Reward models are a key component of post-training, where they provide the preference signals used for model selection, data curation, and reward-guided optimization \[Ouyang2022TrainingLM, Christiano2017DeepRL, xu2023imagereward, xu2026visionrewardfinegrainedmultidimensionalhuman, wu2025rewarddancerewardscalingvisual\]. Unlike mathematics or coding rewards, however, visual preferences are inherently subjective: the same generated image can receive different judgments from different annotators, especially for aesthetics, realism, and fine-grained prompt alignment. Thus, human evaluation for visual generation is better viewed as a distribution of judgments rather than a deterministic scalar score \[murray2012ava, talebi2018nima, wu2023qalign, you2025teachinglargelanguagemodels, ma2025hpsv3widespectrumhumanpreference, uma2021learning, davani2022dealing\].

As summarized in Table 1, existing reward modeling paradigms each miss part of this requirement. Scalar, score-token, and pairwise reward models compress preference into a single value or comparison, which is efficient but discards annotator uncertainty and fine-grained differences among plausible scores \[uma2021learning, davani2022dealing\]. For example, two images may both collapse to score 4 under a discrete scoring scheme, even though one is slightly below the 4-point boundary and the other is slightly above it. Reasoning-based generative reward models can produce higher-quality judgments by leveraging world knowledge and explicit rationales \[zheng2023judging, gu2024surveyllmasajudge, chen2024mllmjudge, chen2024mjbench\], but they are expensive at inference time and their textual reasoning or score outputs are less suitable for large-scale deployment and gradient-based optimization. Explicit distribution modeling \[talebi2018nima, diaz2019soft, wen2023ordinal, you2025teachinglargelanguagemodels\] can represent uncertainty more directly, but it typically relies on repeated annotations per sample, which is difficult to scale in production pipelines.

This creates a central tension for visual reward modeling: high-quality scoring requires reasoning and uncertainty awareness, while scalable post-training requires fast, direct, and differentiable reward signals. Building on knowledge distillation and sequence/rationale distillation \[hinton2015distilling, kim2016sequence, hsieh2023distilling, gu2024minillm\], recent on-policy distillation (OPD) methods \[lu2025onpolicy, zhao2026selfdistilledreasoneronpolicyselfdistillation, fu2026revisitingonpolicydistillationempirical, song2026surveyonpolicydistillationlarge, li2026rethinkingonpolicydistillationlarge, cui2026briefoverviewonpolicyselfdistillation\] improve compact students by applying teacher-guided dense feedback to their own sampled reasoning trajectories, making on-policy reasoning distillation an increasingly important paradigm. For reward modeling, however, the deployment target is different: a reward model is expected to provide fast, stable, calibrated, and optimization-friendly scores, rather than expose long reasoning chains at inference time. Our key insight is that reward models do not need to reproduce how a teacher reasons; they need to reproduce how a reasoning teacher judges. Therefore, Z-Reward resolves this tension by decoupling judgment quality from reward efficiency: instead of forcing the student to imitate the sequential process of reasoning, Z-Reward allows the compact model to internalize the teacher’s reasoning-conditioned judgment directly into score distributions.

We propose Z-Reward, a teacher-student framework for reasoning-internalized score distributions, as illustrated in figure 2. The teacher is a large VLM that uses reasoning and world knowledge to infer a calibrated score distribution from scalable supervision. Here, reasoning is not used merely as an explanation artifact; it helps the teacher decompose visual evidence, apply rubric criteria, and allocate probability mass across neighboring score bins. The student is a compact reward model that internalizes this reasoning-enhanced distribution and directly predicts scores without generating reasoning chains at inference time, enabling efficient deployment and gradient backpropagation.

To train the teacher, we introduce Group-wise Direct Score Optimization (GDSO), which optimizes rewards computed from predicted score distributions and applies direct distribution-level supervision. Rather than requiring repeated human annotations to observe this distribution explicitly, we learn it as a latent, reasoning-conditioned distribution from scalable rubric-based supervision. To train the student, we further introduce Reasoning-Internalized Score Distillation (RISD), which distills the teacher’s reasoning-conditioned score distribution into a small VLM without explicit reasoning tokens. Thus, the student does not imitate the teacher’s reasoning text; it internalizes the distributional effect of that reasoning into direct scoring behavior.

Empirically, this design leads to strong reward-modeling performance. As shown in Figure 1, our 27B GDSO teacher reaches 89.6% human preference accuracy, outperforming SFT, RewardDance-style supervision \[wu2025rewarddancerewardscalingvisual\], and GRPO optimization \[deepseek-math\]. More importantly, the 9B RISD student reaches 88.6%, outperforming the OPD student while closely matching the larger reasoning teacher, and remains efficient at inference time. We further validate Z-Reward as an optimizable reward signal by applying it to text-to-image post-training, where reward-guided optimization improves human preference over the SFT baseline.

\\begin{overpic}\[width=345.0pt\]{images/teaser.pdf} \\put(13.8,23.55){\\cite\[citep\]{\[\\@@bibref{Number}{you2025teachinglargelanguagemodels}{}{}\]}} \\put(50.0,23.55){\\cite\[citep\]{\[\\@@bibref{Number}{wu2025rewarddancerewardscalingvisual}{}{}\]}} \\end{overpic}

Figure 2: Overview of Z-Reward compared with existing distributional reward modeling paradigms. Left: DEQA \[you2025teachinglargelanguagemodels\] rely on dense human score distributions for direct supervision, leading to heavy annotation cost. Middle: RewardDance \[wu2025rewarddancerewardscalingvisual\] learn score distributions from direct supervision, but their scoring is not explicitly based on reasoning. Right: Our Z-Reward first trains a reasoning-based large VLM teacher to infer calibrated score distributions, then distills this reasoning-enhanced distribution into a compact student that directly outputs scores without generating reasoning chains, enabling efficient deployment and gradient-based optimization.

Our contributions are summarized as follows:

- We propose a reasoning-aware and uncertainty-aware teacher-student reward modeling framework that learns latent score distributions from scalable supervision.
- We introduce Group-wise Direct Score Optimization, which trains a reasoning-based VLM teacher by optimizing score distributions directly.
- We develop Reasoning-Internalized Score Distillation, allowing a compact student to internalize reasoning into efficient, direct, and differentiable scoring.
- Empirically, our 27B teacher substantially improves human preference accuracy over SFT, GRPO, and RewardDance, while the 9B student outperforms an OPD-based distillation baseline, nearly matches the teacher, and serves as an efficient reward signal for text-to-image optimization.

## 2 Annotation and Datasets

Annotation document. We build the annotation document around four user- and production-critical dimensions: Text–Image Alignment, Realism, Aesthetics, and Physical Plausibility, following recent fine-grained and multi-dimensional human-feedback settings for text-to-image generation \[liang2024rich, zhang2024learning\_mps\]. Each dimension is scored with a five-level rubric that specifies how different error patterns should affect the score, rather than relying only on abstract terms such as “minor” or “major.” Although the rubric is organized around five integer-level anchors, final annotations are recorded on a nine-level half-point scale, i.e., $\hat{s}\in\{1.0,1.5,\ldots,5.0\}$. This half-point annotation scheme allows annotators to capture fine-grained quality differences between samples that fall into the same coarse rubric bin. For example, a score of 4 corresponds to one or two subtle defects, while a score of 3 indicates more salient subject-level errors or clearly visible quality degradation. To make these criteria operational, each score bin in each dimension is paired with 15–20 annotated examples, allowing annotators to calibrate new samples through a nearest-neighbor-style comparison. The document is updated throughout annotation by adding newly discovered corner cases and replacing less representative examples with more typical ones.

Data for annotation and evaluation. Our annotation prompts come from three sources: 1) internal captions rewritten as generation prompts; 2) real-world prompts from users or community usage; and 3) concepts sampled from our topology, composed, and LLM-expanded into diverse prompts, covering compositional phenomena emphasized by T2I evaluation benchmarks \[hu2023tifa, ghosh2023geneval, huang2023t2icompbench, saharia2022photorealistic\]. For evaluation, we construct a held-out test set with multiple annotations per sample. To compute the ground-truth score distribution, we drop the highest and lowest scores before aggregation to reduce outliers and stabilize preference estimates \[uma2021learning, davani2022dealing\].

Annotation workflow. As shown in figure 3, annotators 1) assign pointwise scores to generated candidates according to the rubric and example document, 2) compare candidates under the same prompt and within the same coarse score bin to shift distinguishable samples by $\pm 0.5$, and 3) submit the results to quality-control annotators for final review. Only data from annotators whose audited accuracy exceeds a preset threshold is admitted into the training set.

The risk of context mismatch. This process exposes two context mismatches between annotators and reward models: 1) the full annotation document is too long to place into a reward model’s context, since four dimensions, five score bins, and 15 images per bin already require approximately $4\times 5\times 15\times 1024=307{,}200$ image tokens before counting textual instructions; and 2) annotators can compare same-prompt candidates during score adjustment, while a deployable pointwise reward model only observes one text–image pair at a time. These mismatches motivate direct supervision on scores and score distributions, so the model can learn human-calibrated scoring behavior without relying on the full annotation context at inference time.

\\begin{overpic}\[width=345.0pt\]{images/annotation.pdf} \\end{overpic}

Figure 3: Annotation workflow. For each prompt, annotators 1) assign pointwise scores to generated candidates according to the annotation document, 2) compare candidates under the same prompt to refine scores within the same coarse bin, and 3) send the resulting annotations to quality check before they are admitted into the training set.

## 3 Method

The annotation process described above provides calibrated human scores, but the calibration context available to annotators cannot be directly supplied to a deployable reward model. Annotators can consult a long, evolving document and compare candidates under the same prompt, whereas a pointwise reward model must usually judge one text–image pair at a time. We therefore decouple reward-model training into a reasoning-intensive teacher stage and an efficient student stage. The teacher learns a reliable reasoning-augmented score distribution, while the student internalizes this distribution into a compact model for direct scoring and gradient backpropagation.

Given a prompt $p$, an image $I$, and a reward dimension $d\in\mathcal{D}$, the teacher first generates a reasoning trace $\rho$ and then predicts a distribution over rubric-aligned score bins $s\in\mathcal{S}$:

$$
q_{\theta}(s\mid p,I,d,\rho),\quad s\in\mathcal{S}.
$$

We treat $q_{\theta}$ as a predictive distribution over rubric-aligned score bins, rather than as a directly observed empirical annotator distribution for each training sample. Since scalable annotation usually provides one rubric-calibrated score per text–image pair, the distribution is learned implicitly from large-scale score supervision, same-prompt score-gap constraints, and the teacher’s reasoning-conditioned score-token probabilities. This follows the ordinal and soft-label view that neighboring score bins should carry structured uncertainty rather than being treated as unrelated classes \[diaz2019soft, wen2023ordinal\]. Thus, $q_{\theta}$ captures the model’s uncertainty over plausible neighboring bins while its expectation is calibrated to human rubric scores.

We decode this distribution from the teacher’s score tokens using a Q-Align-style \[wu2023qalign\] score decoder. The expected scalar score is then obtained from the decoded distribution:

$$
\mu_{\theta}(p,I,d,\rho)=\sum_{s\in\mathcal{S}}s\,q_{\theta}(s\mid p,I,d,\rho).
$$

These reasoning traces help decompose visual evidence, apply fine-grained rubric rules, and handle corner cases that would otherwise be compressed into one-hot labels. However, explicit reasoning is expensive and unsuitable for deployment. We therefore train a compact student to predict the teacher’s reasoning-conditioned distribution directly as $q_{\phi}(s\mid p,I,d)$, without producing reasoning chains at inference time. The following subsections describe teacher optimization and student distillation separately.

### 3.1 Training Teacher Model via Group-wise Direct Score Optimization

Algorithm 1 Iterative Group-wise Direct Score Optimization (GDSO)

Input initial teacher policy $\pi_{\theta_{\mathrm{init}}}$; annotated preference data $\mathcal{D}_{\mathrm{ann}}$

   score bins $\mathcal{S}$; score range $[S_{\min},S_{\max}]$; group size $G$

   hyperparameters $\beta,\epsilon,\lambda_{\mathrm{pt}},\lambda_{\mathrm{pw}},\alpha_{\mathrm{pt}},\alpha_{\mathrm{pw}}$

policy model $\pi_{\theta}\leftarrow\pi_{\theta_{\mathrm{init}}}$

for iteration $=1,\ldots,N$ do

  reference model $\pi_{\mathrm{ref}}\leftarrow\pi_{\theta}$

  for step $=1,\ldots,M$ do

   Sample a batch $\mathcal{B}$ from $\mathcal{D}_{\mathrm{ann}}$

   Update the old policy model $\pi_{\theta_{\mathrm{old}}}\leftarrow\pi_{\theta}$

   for all $(p,I_{w},I_{l},\hat{s}_{w},\hat{s}_{l},d)\in\mathcal{B}$ do

     Set $x_{w}=(p,I_{w},d)$ and $x_{l}=(p,I_{l},d)$

     for $j\in\{w,l\}$ do

      Sample $G$ outputs $\{o_{j,i}\}_{i=1}^{G}\sim\pi_{\theta_{\mathrm{old}}}(\cdot\mid x_{j})$

      Decode $\rho_{j,i}$, $q_{j,i}(s)$, and $\mu_{j,i}$ from each $o_{j,i}$

     end for

     Compute rewards $r^{\mathrm{pt}}_{j,i}$, $r^{\mathrm{pw}}_{j,i}$, and $r_{j,i}$ using Eqs. (7), (10), and (13)

     Compute group-relative advantages $A_{j,i}$ using Eq. (3)

     Compute direct losses $\mathcal{L}^{\mathrm{pt}}_{\mathrm{CE}}$ and $\mathcal{L}^{\mathrm{pw}}$ using Eqs. (8) and (11)

   end for

   for GDSO update $=1,\ldots,K_{\mathrm{gdso}}$ do

     Update $\pi_{\theta}$ by minimizing $\mathcal{L}_{\mathrm{GDSO}}$ in Eq. (14)

   end for

  end for

end for

Output optimized teacher policy $\pi_{\theta}$

We begin from Group Relative Policy Optimization (GRPO) \[deepseek-math\], which samples a group of responses for the same input and optimizes the policy using group-normalized advantages. Given an input $x$, sampled responses $\{o_{i}\}_{i=1}^{G}$, and rewards $\{r_{i}\}_{i=1}^{G}$, the advantage of each response is normalized within the group:

$$
A_{i}=\frac{r_{i}-\operatorname{mean}(\{r_{k}\}_{k=1}^{G})}{\operatorname{std}(\{r_{k}\}_{k=1}^{G})+\epsilon}.
$$

The GRPO objective combines a policy-gradient term with KL regularization to a reference policy:

$$
\mathcal{L}_{\mathrm{GRPO}}=-\mathbb{E}_{o_{i}\sim\pi_{\theta}(\cdot\mid x)}\left[A_{i}\sum_{t}\log\pi_{\theta}(o_{i,t}\mid o_{i,<t},x)-\beta D_{\mathrm{KL}}\!\left(\pi_{\theta}(\cdot\mid x)\,\|\,\pi_{\mathrm{ref}}(\cdot\mid x)\right)\right].
$$

GRPO alone treats the parsed score as a scalar reward, which can be slow to calibrate under the context mismatch discussed above. We therefore introduce Group-wise Direct Score Optimization (GDSO), which augments policy-gradient optimization with direct supervised gradients on score distributions and score gaps. Each training instance contains a winning sample $x_{w}=(p,I_{w},d)$ and a losing sample $x_{l}=(p,I_{l},d)$ with ground-truth rubric scores $\hat{s}_{w}$ and $\hat{s}_{l}$. For each side $j\in\{w,l\}$, the teacher samples $G$ reasoning-and-score outputs $o_{j,i}=(\rho_{j,i},a_{j,i})$:

$$
o_{j,i}\sim\pi_{\theta}(\cdot\mid x_{j}),\quad i=1,\ldots,G.
$$

Following the Q-Align-style score decoder introduced above, each output is converted into a predicted score distribution $q_{j,i}(s)=q_{\theta}(s\mid x_{j},\rho_{j,i})$ and an expected score:

$$
\mu_{j,i}=\sum_{s\in\mathcal{S}}s\,q_{j,i}(s).
$$

Unlike most generative reward methods that parse a single textual score from the model response and then treat the parsed value as the reward, GDSO treats the decoded score distribution as the optimization target. Rewards are computed from the expectation of $q_{j,i}$, while direct losses supervise the score-bin distribution and its induced score gaps.

Importantly, GDSO is group-wise not only in the GRPO-style advantage normalization, but also in its direct score supervision. For each candidate, pointwise supervision is applied to all $G$ sampled score distributions in its group. For each same-prompt candidate pair, pairwise supervision is applied across all $G\times G$ cross-side sampled output pairs. Thus, the sampled group provides multiple reasoning-conditioned distributional views for both policy optimization and direct score calibration.

Pointwise score supervision. For each sampled output, the pointwise reward measures how close its decoded expected score is to the annotated score:

$$
r^{\mathrm{pt}}_{j,i}=1-\frac{\left|\mu_{j,i}-\hat{s}_{j}\right|}{S_{\max}-S_{\min}}.
$$

As a policy reward, this term favors outputs whose decoded scores stay close to the rubric-calibrated human score, encouraging the teacher to learn an absolute score scale rather than only a relative preference direction. In addition to using this value as a policy-gradient reward, we directly supervise the decoded score distribution with a cross-entropy loss:

$$
\mathcal{L}^{\mathrm{pt}}_{\mathrm{CE}}=-\frac{1}{2G}\sum_{j\in\{w,l\}}\sum_{i=1}^{G}\log q_{j,i}(\hat{s}_{j}).
$$

This supervised loss anchors the score-bin probability to the annotated bin, boosting score-scale convergence so the policy does not need to discover the scoring convention only through sampled rewards. The soft distribution around ordinal score bins also provides a more informative target than a one-hot nominal label \[diaz2019soft, wen2023ordinal\].

Pairwise score-gap supervision. Pointwise supervision calibrates absolute scores, while pairwise supervision preserves the relative score gap between samples under the same prompt. Let $\bar{w}=l$, $\bar{l}=w$, and

$$
\Delta\hat{s}_{j,\bar{j}}=\hat{s}_{j}-\hat{s}_{\bar{j}}.
$$

For a sampled output $o_{j,i}$, the pairwise reward compares its score gap to every sampled output from the opposite side:

$$
r^{\mathrm{pw}}_{j,i}=1-\frac{1}{G(S_{\max}-S_{\min})}\sum_{k=1}^{G}\left|(\mu_{j,i}-\mu_{\bar{j},k})-\Delta\hat{s}_{j,\bar{j}}\right|.
$$

As a policy reward, this term favors outputs whose score differences match the annotated gap across same-prompt candidates, encouraging the teacher to learn both the preference direction and the magnitude of visual quality differences. The corresponding direct pairwise loss is

$$
\mathcal{L}^{\mathrm{pw}}=\frac{1}{2G^{2}(S_{\max}-S_{\min})}\sum_{j\in\{w,l\}}\sum_{i=1}^{G}\sum_{k=1}^{G}\left|(\mu_{j,i}-\mu_{\bar{j},k})-\Delta\hat{s}_{j,\bar{j}}\right|.
$$

This supervised gap loss boosts within-prompt discrimination while keeping score margins calibrated to the annotation scale, rather than allowing the policy to separate pairs with arbitrary large margins.

We use score-gap supervision instead of a Bradley–Terry objective \[Bradley1952RANKAO\] or a binary preference-optimization objective such as DPO \[rafailov2023direct\]. A Bradley–Terry model estimates the preference probability as

$$
P(x_{w}\succ x_{l})=\sigma(\mu_{w}-\mu_{l}),\quad\mathcal{L}_{\mathrm{BT}}=-\log\sigma(\mu_{w}-\mu_{l}).
$$

This objective only requires the winner score to exceed the loser score and can keep enlarging the margin, even when both absolute scores should stay close to the annotation rubric. In contrast, our pairwise term matches the annotated score gap, making it consistent with pointwise calibration.

The final GDSO reward combines pointwise and pairwise rewards:

$$
r_{j,i}=\lambda_{\mathrm{pt}}r^{\mathrm{pt}}_{j,i}+\lambda_{\mathrm{pw}}r^{\mathrm{pw}}_{j,i}.
$$

The overall teacher-training objective is

$$
\mathcal{L}_{\mathrm{GDSO}}=\mathcal{L}_{\mathrm{GRPO}}(\{r_{j,i}\})+\alpha_{\mathrm{pt}}\mathcal{L}^{\mathrm{pt}}_{\mathrm{CE}}+\alpha_{\mathrm{pw}}\mathcal{L}^{\mathrm{pw}}.
$$

Thus, GDSO does not rely on policy-gradient reward alone: the score distribution and score gap both receive supervised gradients, which accelerates score-scale calibration and score-distribution convergence. Algorithm 1 summarizes GDSO in a GRPO-style iterative procedure.

### 3.2 Teaching Student Model via Reasoning-Internalized Score Distillation

After teacher training, the large reasoning model generates a reasoning trace $\rho_{T}$ and produces a calibrated distribution $q_{T}(s\mid p,I,d,\rho_{T})$ for each text–image pair and reward dimension. The student model $q_{\phi}(s\mid p,I,d)$ is trained to predict this distribution directly, without generating the teacher’s reasoning chain. Unlike sequence-level or rationale distillation, which transfers generated trajectories or explanatory traces \[kim2016sequence, hsieh2023distilling\], RISD uses the teacher’s reasoning-conditioned score distribution as a soft target in the spirit of knowledge distillation \[hinton2015distilling\]. We distill the teacher distribution with a KL loss:

$$
\mathcal{L}_{\mathrm{RISD}}=\mathbb{E}_{(p,I,d)}\left[D_{\mathrm{KL}}\!\left(q_{T}(s\mid p,I,d,\rho_{T})\,\|\,q_{\phi}(s\mid p,I,d)\right)\right].
$$

The student score used for deployment is the expectation of the distilled distribution:

$$
\mu_{\phi}(p,I,d)=\sum_{s\in\mathcal{S}}s\,q_{\phi}(s\mid p,I,d).
$$

Algorithm 2 summarizes the RISD distillation procedure. By internalizing the teacher’s reasoning-conditioned distribution, the student preserves much of the teacher’s reward-modeling ability while avoiding explicit reasoning at inference time. This yields a compact reward model that supports efficient pointwise scoring and differentiable reward-guided optimization.

Algorithm 2 Reasoning-Internalized Score Distillation (RISD)

Input trained teacher policy $\pi_{\theta_{T}}$; distillation data $\mathcal{D}_{\mathrm{dist}}=\{(p,I,d)\}$; initial student $q_{\phi_{\mathrm{init}}}$

   score bins $\mathcal{S}$; hyperparameters for student optimization

student reward model $q_{\phi}\leftarrow q_{\phi_{\mathrm{init}}}$

Freeze the teacher policy $\pi_{\theta_{T}}$

for step $=1,\ldots,M_{\mathrm{dist}}$ do

  Sample a batch $\mathcal{B}$ from $\mathcal{D}_{\mathrm{dist}}$

  for all $(p,I,d)\in\mathcal{B}$ do

   Query $\pi_{\theta_{T}}$ to generate reasoning $\rho_{T}$ and decode $q_{T}(s\mid p,I,d,\rho_{T})$

   Predict student distribution $q_{\phi}(s\mid p,I,d)$ without reasoning tokens

  end for

  Update $q_{\phi}$ by minimizing $\mathcal{L}_{\mathrm{RISD}}$ in Eq. (15)

end for

Output deployable student $q_{\phi}(s\mid p,I,d)$ and score $\mu_{\phi}(p,I,d)$ in Eq. (16)

## 4 Experiment

### 4.1 Experimental Setup

Model choices. We instantiate the teacher with Qwen3.5-27B \[qwen3.5\] and the student with Qwen3.5-9B \[qwen3.5\]. This setting follows the design goal of Z-Reward: the larger teacher provides stronger reasoning and score-distribution estimation, while the smaller student is used to test whether the reasoning-conditioned distribution can be internalized into an efficient reward model.

Evaluation data and metrics. We evaluate all reward models on the held-out test set from section 2. We report PLCC and SRCC for score calibration, and human preference accuracy (HPA) and margin HPA for preference ranking. Margin HPA uses only pairs with a human score gap above 0.5.

For preference-ranking evaluation, we compute HPA over same-prompt candidate pairs with non-tied human scores. Given a pair $(I_{a},I_{b})$, HPA is defined as

$$
\mathrm{HPA}=\frac{1}{|\mathcal{P}|}\sum_{(a,b)\in\mathcal{P}}\mathbbm{1}\left[(\mu_{a}-\mu_{b})(\hat{s}_{a}-\hat{s}_{b})>0\right],
$$

where $\mathcal{P}$ denotes all evaluated pairs with $\hat{s}_{a}\neq\hat{s}_{b}$, $\hat{s}$ is the aggregated human score, and $\mu$ is the reward model’s predicted expected score. Margin HPA is computed on the subset satisfying $|\hat{s}_{a}-\hat{s}_{b}|>0.5$.

Compared methods. We first include a zero-shot baseline, which evaluates the base model before SFT using only the scoring system prompt. We then compare against standard SFT, which fine-tunes the same backbone on annotated score outputs without reasoning chains and serves as the no-reasoning baseline for teacher-side comparison; RewardDance \[wu2025rewarddancerewardscalingvisual\], which uses post-hoc pseudo reasoning chains distilled from Qwen-3.6-Max; and GRPO, which computes rewards from the mean of the predicted score distribution as the final output score. We also evaluate our GDSO, which directly optimizes score distributions with pointwise and pairwise supervision. For a clean comparison of reinforcement learning strategies, all GRPO and GDSO runs start from the base model; their reasoning and scoring behaviors are driven only by the system prompt and learned through pure self-exploration. These comparisons are conducted for both 27B and 9B models. For the 9B setting, we additionally evaluate RISD, which distills the 27B reasoning-based score distribution into the smaller student model.

Table 2: Reward-model evaluation on the internally annotated test set. We compare score calibration and preference-ranking quality using PLCC, SRCC, human preference accuracy, and margin human preference accuracy. Values in parentheses report absolute gains over the zero-shot baseline within the same model size. The best and second-best results within each model size are highlighted. Margin human preference accuracy is computed only on pairs whose human score gap is larger than 0.5.

<table><tbody><tr><th>Method</th><th>Scoring Basedon Reasoning</th><td>PLCC</td><td>SRCC</td><td>Human PreferenceAccuracy</td><td>Margin HumanPreference Accuracy</td></tr><tr><th colspan="6"><em>Qwen3.5-27B</em></th></tr><tr><th>Zero-shot</th><th><math><semantics><mo>×</mo> <annotation>\times</annotation></semantics></math></th><td>0.6301 (+.0000)</td><td>0.5816 (+.0000)</td><td>0.7438 (+.0000)</td><td>0.9538 (+.0000)</td></tr><tr><th>SFT</th><th><math><semantics><mo>×</mo> <annotation>\times</annotation></semantics></math></th><td>0.6458 (+.0157)</td><td>0.5914 (+.0098)</td><td>0.8135 (+.0697)</td><td>0.9644 (+.0106)</td></tr><tr><th>RewardDance</th><th><math><semantics><mo>×</mo> <annotation>\times</annotation></semantics></math></th><td>0.6667 (+.0366)</td><td>0.6207 (+.0391)</td><td>0.8425 (+.0987)</td><td>0.9706 (+.0168)</td></tr><tr><th>GRPO</th><th>✓</th><td>0.7200 (+.0899)</td><td>0.6832 (+.1016)</td><td>0.8604 (+.1166)</td><td>0.9827 (+.0289)</td></tr><tr><th>GDSO</th><th>✓</th><td>0.7620 (+.1319)</td><td>0.7132 (+.1316)</td><td>0.8956 (+.1518)</td><td>0.9885 (+.0347)</td></tr><tr><th colspan="6"><em>Qwen3.5-9B</em></th></tr><tr><th>Zero-shot</th><th><math><semantics><mo>×</mo> <annotation>\times</annotation></semantics></math></th><td>0.3411 (+.0000)</td><td>0.3167 (+.0000)</td><td>0.6563 (+.0000)</td><td>0.7501 (+.0000)</td></tr><tr><th>SFT</th><th><math><semantics><mo>×</mo> <annotation>\times</annotation></semantics></math></th><td>0.5296 (+.1885)</td><td>0.4942 (+.1775)</td><td>0.7459 (+.0896)</td><td>0.8401 (+.0900)</td></tr><tr><th>RewardDance</th><th><math><semantics><mo>×</mo> <annotation>\times</annotation></semantics></math></th><td>0.5182 (+.1771)</td><td>0.4338 (+.1171)</td><td>0.7817 (+.1254)</td><td>0.8972 (+.1471)</td></tr><tr><th>GRPO</th><th>✓</th><td>0.5340 (+.1929)</td><td>0.5072 (+.1905)</td><td>0.7703 (+.1140)</td><td>0.9076 (+.1575)</td></tr><tr><th>GDSO</th><th>✓</th><td>0.6341 (+.2930)</td><td>0.5665 (+.2498)</td><td>0.8395 (+.1832)</td><td>0.9599 (+.2098)</td></tr><tr><th>RISD</th><th>Internalized</th><td>0.7391 (+.3980)</td><td>0.6882 (+.3715)</td><td>0.8864 (+.2301)</td><td>0.9801 (+.2300)</td></tr></tbody></table>

### 4.2 Main Results

Table 2 summarizes reward-model performance. On the 27B teacher, GDSO achieves the best results on all metrics, improving over GRPO in both score calibration (PLCC/SRCC) and pairwise preference accuracy. On the 9B model, RISD is also consistently best and reaches 0.8864 HPA and 0.9801 margin HPA, close to the 27B GDSO teacher. This suggests that the teacher’s reasoning-conditioned score distribution can be effectively internalized into a smaller direct-scoring model.

RewardDance shows a useful contrast on 9B: compared with SFT, it improves HPA from 0.7459 to 0.7817, but decreases PLCC from 0.5296 to 0.5182 and SRCC from 0.4942 to 0.4338. This suggests that post-hoc pseudo reasoning helps the small model recognize coarse pairwise preference directions, but does not guarantee calibrated rubric scores. GRPO also trails RewardDance on 9B HPA, likely because pure self-exploration is bounded by the weaker reasoning ability of the 9B model. In contrast, GDSO provides direct distribution and score-gap supervision during exploration, giving the policy clearer optimization directions, while RISD further uses KL supervision from the 27B teacher distribution to internalize fine-grained reasoning-based scoring behavior.

### 4.3 Ablation Studies

Effect of decoding from score distribution instead of parsing text to compute rewards. We compare two ways of extracting rewards from a generative reward model. The first follows common generative reward modeling practice: parse the final textual score from the model response and use it to compute the RL reward. The second uses our score decoder to obtain the full score distribution and computes the reward from its expectation. All other training settings are kept the same for GRPO and GDSO.

As shown in figure 4, using the distribution expectation consistently improves both HPA and margin HPA for GRPO and GDSO. Parsing text scores effectively quantizes the reward signal: predictions such as 3.8 and 4.2 may both be emitted as the score token 4, so they receive the same reward and the same normalized advantage in GRPO. This removes fine-grained scoring signals and slows reward-model learning. In contrast, the expectation over the score distribution preserves uncertainty across neighboring bins, providing denser supervision and better teaching the model how to score.

![Refer to caption](https://arxiv.org/html/2606.09076v2/x3.png)

(a) GRPO HPA

Distill Reasoning Chains from Teacher to Student via On-Policy Distillation. We compare RISD with a direct on-policy distillation (OPD) \[lu2025onpolicy\] baseline, following the per-token reverse-KL formulation used by Thinking Machines Lab and related reverse-KL distillation objectives for generative LMs \[gu2024minillm\]. In OPD, the 9B student first samples its own reasoning-and-score trajectory $y=(y_{1},\ldots,y_{T})\sim\pi_{\phi_{\mathrm{old}}}(\cdot\mid x)$ for an input $x=(p,I,d)$, and the 27B GDSO teacher only provides token log-probabilities on the student’s visited prefixes. The per-token reverse-KL term is used as an on-policy advantage:

$$
A^{\mathrm{OPD}}_{t}=\log\pi_{\theta_{T}}(y_{t}\mid y_{<t},x)-\log\pi_{\phi_{\mathrm{old}}}(y_{t}\mid y_{<t},x).
$$

The student is then updated by an on-policy policy-gradient objective, with $A^{\mathrm{OPD}}_{t}$ treated as a stop-gradient advantage:

$$
\mathcal{L}_{\mathrm{OPD}}=-\mathbb{E}_{x,\;y\sim\pi_{\phi_{\mathrm{old}}}(\cdot\mid x)}\left[\frac{1}{T}\sum_{t=1}^{T}\operatorname{sg}\!\left(A^{\mathrm{OPD}}_{t}\right)\log\pi_{\phi}(y_{t}\mid y_{<t},x)\right].
$$

Table 3: Trajectory- vs. outcome-level distillation. HPA denotes human preference accuracy, and output tokens denote generated output length. Best and second-best results are highlighted.

<table><thead><tr><th rowspan="2">Method</th><th rowspan="2">HPA</th><th>Margin</th><th>Output</th></tr><tr><th>HPA</th><th>Tokens</th></tr><tr><th>9B OPD</th><th>0.8311</th><th>0.9643</th><th>~750</th></tr></thead><tbody><tr><th>9B SFT</th><td>0.7459</td><td>0.8401</td><td>1</td></tr><tr><th>9B GDSO</th><td>0.8395</td><td>0.9599</td><td>~750</td></tr><tr><th>[0pt][0pt] 9B RISD</th><td>0.8864</td><td>0.9801</td><td>1</td></tr></tbody></table>

Table 3 shows that OPD improves over SFT and reaches a similar level to the 9B GDSO model, but it still does not approach the 27B teacher or the 9B RISD student. The output-token column further reveals an efficiency gap: OPD and GDSO require long autoregressive reasoning traces, averaging about 750 output tokens, while RISD returns the score in a single output token, matching SFT’s decoding cost. Since reward inference is repeatedly called during candidate filtering or optimization, this reduction directly lowers latency and serving cost. Thus, RISD does not merely improve HPA; it transfers the teacher’s reasoning benefit into a deployment-efficient outcome-level scorer. The remaining accuracy gap suggests that teacher-derived token advantages are not sufficient when the 9B student cannot explore strong reasoning trajectories by itself: OPD can reinforce better tokens on the student’s on-policy prefixes, but its learning signal is still bounded by the states the student visits. OPD and GDSO almost reach a similar 9B ceiling by giving direct score-distribution and score-gap guidance during exploration. In contrast, RISD provides a finer-grained supervision signal by directly matching the teacher’s reasoning-conditioned score distribution over the score vocabulary. This allows the student to internalize the teacher’s scoring behavior without having to reproduce the full reasoning trajectory through on-policy exploration.

## 5 Validating Z-Reward as an Optimizable Reward Signal

To demonstrate the practical utility of Z-Reward, we apply it to the Reinforcement Learning (RL) stage of text-to-image generation, a setting where prior work has explored policy-gradient fine-tuning, direct preference optimization, and differentiable reward backpropagation \[fan2023dpok, wallace2024diffusion, prabhudesai2024alignprop, clark2024directlyfinetuningdiffusionmodels\]. Unlike traditional discrete scalar rewards that provide sparse guidance, the score distributions predicted by Z-Reward offer dense and informative gradient signals. We leverage these gradients to directly optimize the baseline SFT model \[Team2025ZImageAE\], steering the generation toward human preferences.

### 5.1 Multi-Dimensional Reward Gradient Backpropagation

![Refer to caption](https://arxiv.org/html/2606.09076v2/x7.png)

(a) Text–Image Alignment

We adopt a ReFL-style \[xu2023imagereward\] direct reward backpropagation scheme, extended to earlier denoising steps and multi-dimensional reward optimization, which is closely related to differentiable reward fine-tuning and dense reward views of the diffusion trajectory \[clark2024directlyfinetuningdiffusionmodels, prabhudesai2024alignprop, yang2024adensereward\]. Given a prompt $p$ and a generated image $I=G_{\psi}(p)$, the deployed student reward model predicts $q_{\phi}(s\mid p,I,d)$ for each reward dimension $d\in\mathcal{D}$, where $\mathcal{D}$ includes text–image alignment, realism, aesthetics, and physical plausibility. We use the expected score $\mu_{\phi}(p,I,d)$ defined in Eq. 16 as the reward for dimension $d$, and aggregate the multi-dimensional rewards as:

$$
R(p,I)=\mathcal{A}\big(\{\mu_{\phi}(p,I,d)\}_{d\in\mathcal{D}}\big),
$$

where $\mathcal{A}(\cdot)$ denotes a task-dependent aggregation function. We then backpropagate $\nabla_{\psi}R(p,G_{\psi}(p))$ through the denoising process to update the generator.

![Refer to caption](https://arxiv.org/html/2606.09076v2/x11.png)

Figure 6: Qualitative comparisons between the SFT baseline and Z-Reward-guided optimization. Each row shows one held-out prompt and compares the baseline generation with the optimized model.

### 5.2 Reward Curve Analysis

Figure 5 shows that reward-guided optimization steadily improves validation rewards across text–image alignment, realism, aesthetics, and physical plausibility. Realism and aesthetics improve faster in the early stage, while text–image alignment and physical plausibility increase more gradually due to their stronger dependence on semantic and structural correctness. These trends suggest that Z-Reward provides stable and fine-grained optimization signals across multiple aspects of visual generation.

### 5.3 Human Evaluation

To examine whether the reward improvements translate into human-perceived quality gains, we conduct blind human evaluation on the same held-out prompt set used in the validation reward analysis, following the broader emphasis on reproducible human evaluation for text-to-image generation \[otani2023toward\]. The set contains 400 prompts covering compositional descriptions, attribute binding, spatial relations, and physically challenging scenes, matching the compositional coverage studied in recent T2I and text-to-visual evaluation benchmarks \[hu2023tifa, ghosh2023geneval, huang2023t2icompbench, lin2024evaluating, li2024evaluating\]. Professional annotators perform pairwise comparisons between images generated by the SFT baseline and those generated by the model optimized with Z-Reward.

We report results using the human-preference-based Good-Same-Bad (GSB) metric. For each prompt, annotators judge whether the optimized image is better than, comparable to, or worse than the baseline image, corresponding to Good, Same, and Bad, respectively. Let $G$, $S$, and $B$ denote the counts of these three outcomes. The final GSB score is defined as

$$
GSB=\frac{G-B}{G+S+B}.
$$

where a higher value indicates stronger net human preference for the optimized model.

Compared with the strong SFT baseline, the model optimized using Z-Reward achieves a net GSB improvement of 41.3%. This result confirms that the improvements measured by our reward model are reflected in human judgments, which is important because reward-guided optimization can otherwise overfit proxy rewards \[gao2023scaling, rafailov2024scaling\]. Qualitative comparisons in Figure 6 further illustrate that Z-Reward-guided optimization improves text-image alignment, visual realism, aesthetics, and physical plausibility across diverse prompts.

## 6 Discussions and Future Works

Reasoning-score coupling. One limitation of the current teacher training objective is that it combines policy-gradient rewards with direct SFT-style losses, $\alpha_{\mathrm{pt}}\mathcal{L}^{\mathrm{pt}}_{\mathrm{CE}}+\alpha_{\mathrm{pw}}\mathcal{L}^{\mathrm{pw}}$ in Eq. (14). These supervised terms substantially improve score calibration and preference metrics, but they may occasionally make the final score depend more on direct score supervision than on the generated reasoning trace itself. In our experiments, such weak coupling between reasoning and the final score appears to be a minority case, while the metric gains from these losses are clear. Future work could add explicit reasoning-score consistency checks or contrastive supervision so that the teacher preserves the calibration benefits of direct losses while keeping the score more tightly grounded in its rationale.

Potential Generalization to All Sequence-to-Score Tasks. Although this paper focuses on reward modeling for image generation, the proposed formulation is not tied to a specific visual domain. As VLMs continue to improve, a VLM-to-score model can naturally take image, video, or text-centered inputs and convert arbitrary model outputs into rubric-aligned score distributions. In our framework, the score can be decoded during the reasoning process or from any scoring-oriented output of the VLM, and the distribution expectation remains directly supervised and differentiable. This makes the reward useful not only as an evaluator, but also as a continuous optimization signal that can be backpropagated to generated images or videos through a differentiable generator. Beyond visual generation, the same decoupled teacher-student design can serve as a reward model for LLMs and VLMs, or as a general sequence-to-score evaluator for tasks such as image/video quality assessment and caption evaluation, connecting to broader evaluation lines such as reference-free caption metrics and fine-grained video-generation benchmarks \[hessel2021clipscore, huang2024vbench\]. Our experiments instantiate this idea on text-to-image generation, while broader modalities and downstream reward-modeling settings remain promising future directions.

Possible Extension to Unified Reward Modeling. The same formulation also points toward unified reward modeling. Our annotation pipeline already provides more than isolated pointwise labels: when annotators score multiple candidates under the same prompt, their adjustments implicitly encode comparison signals among candidates. This enables comparison training, but with richer supervision than binary preferences. Because each candidate has a calibrated rubric score, the model can learn not only whether one sample is better than another, but also by how many score levels they differ. Such score-gap supervision is naturally compatible with our pointwise distribution objective and can be extended across dimensions, modalities, and task types. A future unified reward model could therefore combine pointwise score distributions, pairwise preferences, and calibrated score gaps within one teacher-student system, using the teacher for reasoning-heavy judgment and the student for efficient direct scoring.

## 7 Related Work

### 7.1 Reward Models

Reward models are widely used to align generative models with human preferences. Early visual reward models, such as ImageReward \[xu2023imagereward\], PickScore \[kirstain2023pickapicopendatasetuser\], and HPSv2 \[wu2023humanpreferencescorev2\], are mostly built on CLIP-style encoders and trained to output scalar preference scores. Recent VLM-based reward models further improve visual understanding and task coverage by replacing CLIP encoders with stronger multimodal backbones and attaching regressive reward heads, including VisionReward \[xu2026visionrewardfinegrainedmultidimensionalhuman\], VideoAlign \[liu2025improvingvideogenerationhuman\], HPSv3 \[ma2025hpsv3widespectrumhumanpreference\], and WorldPM \[wang2025worldpmscalinghumanpreference\]. Scalar or regressive reward models are efficient and convenient for deployment, but they can over-compress subjective preferences and may be vulnerable to reward hacking or reward overoptimization \[you2025teachinglargelanguagemodels, wu2025rewarddancerewardscalingvisual, gao2023scaling, rafailov2024scaling\]. This motivates reward modeling paradigms that preserve richer judgment information while remaining usable for optimization.

Generative reward models aim to better exploit the native next-token prediction and reasoning capabilities of VLMs, following the broader trend of LLM/VLM-as-a-judge systems \[zheng2023judging, gu2024surveyllmasajudge, chen2024mllmjudge, chen2024mjbench\]. Representative works include DeepSeek-GRM \[liu2025inferencetimescalinggeneralistreward\], GenRM-CoT \[zhang2025generativeverifiersrewardmodeling\], UnifiedReward \[wang2026unifiedrewardmodelmultimodal\], RewardDance \[wu2025rewarddancerewardscalingvisual\], and Edit-R1 \[guo2026leveraging\]. RewardDance formulates reward prediction as a generative comparison task and studies scaling along model and context dimensions. Edit-R1 further shows that verifier-style reasoning, which decomposes editing instructions into explicit principles and verifies outputs with CoT, can provide stronger feedback for image editing. Orthogonally, score-distribution modeling has been explored in quality assessment and ordinal label learning \[murray2012ava, talebi2018nima, diaz2019soft, wen2023ordinal\]. Q-Align \[wu2023qalign\] discretizes continuous scores into level tokens, while DeQA \[you2025teachinglargelanguagemodels\] shows that distribution-based soft labels better preserve uncertainty and inter-image relationships than one-hot labels. Different from these works, Z-Reward uses a reasoning VLM to infer rubric-aligned score distributions and further distills them into an efficient direct-scoring student, thereby combining reasoning-aware judgment with deployable distributional rewards.

### 7.2 Reinforcement Learning for Visual Generation

Reinforcement learning from human feedback has been increasingly used to align visual generators with human preferences. Existing methods either adapt policy-gradient algorithms to diffusion or flow-based generators, such as DDPO \[black2024trainingdiffusionmodelsreinforcement\], DPOK \[fan2023dpok\], and recent GRPO-style visual RL methods \[deepseek-math, liu2025improvingvideogenerationhuman, wu2025rewarddancerewardscalingvisual, guo2026leveraging\], optimize diffusion models from pairwise preferences \[rafailov2023direct, wallace2024diffusion\], or directly backpropagate reward gradients through the sampling process, like ReFL \[xu2023imagereward\], DRaFT \[clark2024directlyfinetuningdiffusionmodels\], AlignProp \[prabhudesai2024alignprop\], and dense reward formulations \[yang2024adensereward\]. Related preference-optimization and online RL methods have further been explored for text-to-image generation, video generation, and image editing \[liu2025improvingvideogenerationhuman, wu2025rewarddancerewardscalingvisual, guo2026leveraging\]. These works show that reward-guided optimization can substantially improve visual generation quality, but its effectiveness depends heavily on the reward signal. Scalar or regressive rewards are efficient and convenient for optimization, but they can over-compress subjective preferences and may be vulnerable to reward hacking \[you2025teachinglargelanguagemodels, guo2026leveraging, gao2023scaling, rafailov2024scaling\]. Reasoning-based rewards provide richer semantic verification, but explicit reasoning traces can introduce additional inference overhead or become incompatible with direct reward backpropagation \[yang2026joint, guo2026leveraging\]. In contrast, Z-Reward distills reasoning-enhanced judgments into score distributions whose expectations provide dense and differentiable rewards, enabling efficient reward-guided optimization of text-to-image generators.

### 7.3 On-policy Distillation

A practical reward model should be efficient enough for large-scale scoring and sufficiently stable for reward-guided optimization, since visual reward models are commonly used as automatic evaluators or optimization signals for improving generated samples \[xu2023imagereward, wu2025rewarddancerewardscalingvisual, yang2026joint\]. On-policy distillation (OPD) has recently emerged as a relevant paradigm for transferring reasoning behaviors from stronger models to weaker ones. Instead of relying only on fixed offline trajectories, OPD trains the student on its own sampled trajectories and uses a teacher to provide dense supervision on the states visited by the student \[Agarwal2023OnPolicyDO, lu2025onpolicy\]. This makes the learning signal better matched to the student’s inference-time distribution and is particularly relevant for long-horizon reasoning, where deviations from offline traces can accumulate over multiple steps. Recent studies have extended this idea to self-distillation, privileged-information distillation, reasoning compression, continual learning, and reward-to-supervision conversion \[zhao2026selfdistilledreasoneronpolicyselfdistillation, penaloza2026privileged, shenfeld2026selfdistillationenablescontinuallearning, Sang2026CRISPCR, he2026selfdistillationzeroselfrevisionturns\]. Follow-up work further analyzes the failure modes, stability issues, and practical design choices of OPD in reasoning distillation \[song2026surveyonpolicydistillationlarge, fu2026revisitingonpolicydistillationempirical, li2026rethinkingonpolicydistillationlarge, jang2026stableonpolicydistillationadaptive, zhu2026facesonpolicydistillationpitfalls\].

While OPD provides a natural reference for transferring a large reasoning teacher into a compact student, its trajectory-centric objective differs from the deployment goal of visual reward modeling: in reward-guided generation, the reward model is commonly used as an efficient scorer or a differentiable optimization signal for selecting or directly improving generated samples \[xu2023imagereward, clark2024directlyfinetuningdiffusionmodels, yang2026joint\], whereas reasoning-based reward models that generate discrete multi-step traces can be costly or incompatible with direct reward backpropagation \[guo2026leveraging\]. These observations suggest that directly applying OPD to distill reasoning trajectories is not the most natural objective for visual reward modeling: it teaches the student how the teacher reasons, while deployment only requires how the teacher judges. In contrast, Z-Reward distills the outcome of reasoning. The teacher first uses reasoning to produce a calibrated score distribution, and the student learns to predict this distribution directly. This reasoning-internalized distillation transfers the teacher’s judgment behavior while avoiding explicit reasoning at inference time.

## 8 Conclusion

We presented Z-Reward, a teacher-student framework for visual reward modeling that represents human preference as a reasoning-conditioned score distribution rather than a single deterministic scalar. By training a large VLM teacher with Group-wise Direct Score Optimization, Z-Reward combines policy-gradient learning with direct supervision on score distributions and score gaps, improving both calibrated scoring and pairwise preference ranking. Through Reasoning-Internalized Score Distillation, a compact student internalizes the teacher’s reasoning-based distribution and provides efficient, direct, and differentiable scoring without generating explicit reasoning chains.

Experiments on our internally annotated benchmark show that the 27B GDSO teacher outperforms SFT, RewardDance, and GRPO, while the 9B RISD student closely matches the larger teacher and serves as an effective reward signal for text-to-image optimization. Beyond the current image-generation setting, we view Z-Reward as a general sequence-to-score modeling paradigm: future work can extend the same decoupled teacher-student design to unified reward modeling across image, video, text, and multimodal generation tasks, combining pointwise score distributions, pairwise comparisons, and calibrated score-gap supervision in a single reward model.
