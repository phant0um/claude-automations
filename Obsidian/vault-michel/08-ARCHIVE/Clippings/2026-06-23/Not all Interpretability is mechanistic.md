---
title: "Not all Interpretability is mechanistic"
source: "https://x.com/giangnguyen2412/status/2068743875527844200"
author:
  - "[[@giangnguyen2412]]"
published: 2026-06-21
created: 2026-06-22
description: "A short history for people who arrived at interpretability through mech interpretability, and why the conflation is risky. I will use interp..."
tags:
  - "clippings"
---
![Image](https://pbs.twimg.com/media/HLWlYXrbgAAFWlQ?format=jpg&name=large)

A short history for people who arrived at interpretability through mech interpretability, and why the conflation is risky. I will use interpretability vs. explainability interchangeably in this post.

**Context**: I talked with researchers. When I mention that [@guidelabsai](https://x.com/guidelabsai) works on interpretability, the first thing they ask is almost always, "Are you using SAEs?".

The same week, someone replied to a thread of mine asking whether my integrated-gradients work counts as "mechanistic interpretability." It does not. I kept turning both over while wandering the city 🌉 this weekend, and i think they point to a real gap.

![Image](https://pbs.twimg.com/media/HLWa_BybEAAOuho?format=jpg&name=large)

Currently a growing number of people enter interpretability through mech interp and assume the two words are largely the same. They are not.

**Mechanistic interpretability** is one branch of a field that is years older than the branch itself. Treating the branch as the whole tree costs you, concretely. This post may give the history and explains the cost.

## What mech interp actually is

Mechanistic interpretability means reverse-engineering a model's internal computation into a human-readable algorithm. You look at weights, activations, and the connections between them, and you try to recover the circuit that implements a behavior.

The term is slippery. Saphra and Wiegreffe (2024) catalog four uses of it, ranging from a narrow technical one (a causal claim about how internal components produce an output) to a purely cultural one (a community and its norms). The **cultural** meaning is the one doing the damage. When **"mechanistic" stops naming a method and starts naming a vibe**, every interpretability result gets relabeled as mech interp, and the distinctions that matter disappear.

## Interpretability did not start with circuits or neurons

**Feature attribution** came first in the modern deep-learning era. Attribution assigns credit (attribution) for a prediction back to input features. Saliency maps (Simonyan et al., 2013) used raw gradients. Layer-wise relevance propagation (Bach et al., 2015), DeepLIFT (Shrikumar et al., 2017), and integrated gradients (Sundararajan et al., 2017) refined the attribution assignment. LIME (Ribeiro et al., 2016) and SHAP (Lundberg and Lee, 2017) did it model-agnostically by perturbing inputs. Grad-CAM (Selvaraju et al., 2017) localized it for vision.

This is the where [my integrated-gradients work](https://x.com/giangnguyen2412/status/2068123013703467469?s=20) sits in. None of it is mechanistic. It explains input-to-output behavior without claiming to recover the internal algorithm.

**The crisis of feature attribution: whether an explanation actually reflects what the model computes. Faithfulness** asks whether an explanation actually reflects what the model computes. Adebayo et al. (2018), "Sanity Checks for Saliency Maps," showed that several popular attribution methods produce the same plausible-looking heatmap even after you randomize the model's weights or the labels. An explanation that does not depend on the model is not explaining the model. Kindermans et al. (2019) showed attributions can shift under input changes that leave the prediction unchanged. In NLP, Jain and Wallace (2019) argued attention weights are not faithful explanations, and Wiegreffe and Pinter (2019) pushed back. **The field spent years learning that a method can look interpretable and still be useless.**

Attribution was not the only non-mechanistic direction. In 2018, **Prototype networks were very popular by** making a model interpretable by design instead of explaining it after the fact. ProtoPNet (Chen et al.) classifies an input by matching its parts against learned prototypes drawn from training data, so the explanation reads "this part looks like that prototype." The reasoning is the model itself, not a post-hoc story about it. This is the inherently-interpretable agenda (Rudin, 2019) put into practice. FWIW, Cynthia Rudin is one of the greatest interpretability researchers in the deep learning era.

**Concept bottleneck models** carry the inherently-interpretable-by-design idea into concepts. The model first predicts a set of human-named concepts, then predicts the label from those concepts alone. You can read the reasoning, and you can intervene: change a concept and the prediction changes with it. Koh et al. (2020) formalized this. Its post-hoc cousin is TCAV (Kim et al., 2018), which measures how much a chosen concept drives a prediction without redesigning the model. Both explain in human concepts rather than pixels or neurons.

**Probing** developed in parallel. A probe trains a simple classifier on a model's internal representations to test what information they encode. Alain and Bengio (2016) introduced linear probes. Hewitt and Manning (2019) found syntax trees embedded in representation geometry. This is internal analysis, closer in spirit to mech interp, but it predates the term and uses different tools.

**Counterfactual explanations** take a different angle again. Instead of scoring features, they find the smallest change to an input that would flip the output. Wachter et al. (2017) framed this for black-box models: "if your income were higher by this amount, the loan would be approved." Ustun et al. (2019) turned it into actionable recourse, and DiCE (Mothilal et al., 2020) generates diverse counterfactuals. The explanation is contrastive, and it makes no claim about internal mechanism either.

The conceptual work framed all of it. Lipton (2016) asked what "interpretability" even means and showed the word hides several incompatible goals. Doshi-Velez and Kim (2017) proposed how to evaluate it rigorously. Rudin (2019) argued for inherently interpretable models over post-hoc explanations in high-stakes settings. And many other works have tried to unified interpretability.

**Mech interp is the most recent branch**. The circuits thread (Olah et al., 2020) reframed the goal as reverse-engineering networks neuron by neuron. Superposition (Elhage et al., 2022) and sparse autoencoders (Bricken et al., 2023) gave it traction on language models. The work is genuinely new.

## Why the conflation is dangerous

**You rediscover known failures.** The sanity-check problem is the clearest case. If you have not read Adebayo et al., you will build an attribution method, get convincing pictures, and never test whether the pictures depend on the model. The attribution tradition already paid for that lesson. Skipping the history means paying again. For SAEs, there are existing works showing it failed the easy tests \[[1](https://arxiv.org/pdf/2501.17148),[2](https://arxiv.org/abs/2501.16615)\].

**You import the wrong validation, or none.** Mech interp validates with causal interventions: activation patching, ablations. Attribution has its own criteria, like the completeness, sensitivity, and implementation-invariance axioms. If you believe all interp is mech interp, you reach for the wrong validation tool, or you skip validation because the picture looks right.

**You shrink the toolbox.** Attribution, probing, concept-based methods (TCAV, concept bottlenecks), and example-based methods (influence functions, training-data attribution) each answer questions circuits cannot.

## A rough taxonomy

Use this rough taxonomy. The methods overlap sometimes.

- **Attribution**: credit a prediction to inputs. Integrated gradients, SHAP, LIME.
- **Probing**: test what representations encode. Linear probes, structural probes.
- **Concept-based**: explain in terms of human concepts. TCAV, concept bottlenecks.
- **Example-based**: explain by training examples. Influence functions, training-data attribution, prototype networks.
- **Counterfactual**: explain by what would flip the output. Actionable recourse, contrastive explanations.
- **Mechanistic**: recover the internal algorithm. Circuits, superposition, sparse autoencoders.

## The takeaway

Mech interp is a branch. If you arrived through it, read the older work. Start with Saphra and Wiegreffe (2024) for the history, Adebayo et al. (2018) for why faithfulness is not optional, and Lipton (2016) for what interpretability even means.

The field is larger than one method, and the good work uses whichever method fits the question.

## References

- Bach et al. (2015). On Pixel-Wise Explanations for Non-Linear Classifier Decisions by Layer-Wise Relevance Propagation. PLOS ONE.
- Simonyan, Vedaldi, Zisserman (2013). Deep Inside Convolutional Networks: Visualising Image Classification Models and Saliency Maps.
- Ribeiro, Singh, Guestrin (2016). "Why Should I Trust You?": Explaining the Predictions of Any Classifier (LIME). KDD.
- Lipton (2016). The Mythos of Model Interpretability.
- Alain, Bengio (2016). Understanding Intermediate Layers Using Linear Classifier Probes.
- Doshi-Velez, Kim (2017). Towards A Rigorous Science of Interpretable Machine Learning.
- Sundararajan, Taly, Yan (2017). Axiomatic Attribution for Deep Networks (Integrated Gradients). ICML.
- Shrikumar, Greenside, Kundaje (2017). Learning Important Features Through Propagating Activation Differences (DeepLIFT). ICML.
- Lundberg, Lee (2017). A Unified Approach to Interpreting Model Predictions (SHAP). NeurIPS.
- Selvaraju et al. (2017). Grad-CAM: Visual Explanations from Deep Networks via Gradient-Based Localization. ICCV.
- Wachter, Mittelstadt, Russell (2017). Counterfactual Explanations Without Opening the Black Box. Harvard Journal of Law & Technology.
- Adebayo et al. (2018). Sanity Checks for Saliency Maps. NeurIPS.
- Jain, Wallace (2019). Attention is not Explanation. NAACL.
- Wiegreffe, Pinter (2019). Attention is not not Explanation. EMNLP.
- Kindermans et al. (2019). The (Un)reliability of Saliency Methods.
- Hewitt, Manning (2019). A Structural Probe for Finding Syntax in Word Representations. NAACL.
- Chen et al. (2019). This Looks Like That: Deep Learning for Interpretable Image Recognition (ProtoPNet). NeurIPS.
- Ustun, Spangher, Liu (2019). Actionable Recourse in Linear Classification. FAT\*.
- Rudin (2019). Stop Explaining Black Box Machine Learning Models for High Stakes Decisions and Use Interpretable Models Instead. Nature Machine Intelligence.
- Olah et al. (2020). Zoom In: An Introduction to Circuits. Distill.
- Mothilal, Sharma, Tan (2020). Explaining Machine Learning Classifiers through Diverse Counterfactual Explanations (DiCE). FAT\*.
- Elhage et al. (2022). Toy Models of Superposition. Anthropic.
- Bricken et al. (2023). Towards Monosemanticity: Decomposing Language Models With Dictionary Learning. Anthropic.
- Saphra, Wiegreffe (2024). Mechanistic? BlackboxNLP, arXiv:2410.09087.