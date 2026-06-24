---
title: "The Geometry of Refusal: Linear Instability in Safety-Aligned LLMsAccepted at TrustNLP 2026, the Sixth Workshop on Trustworthy Natural Language Processing, co-located with ACL 2026."
type: source
source: "Clippings/The Geometry of Refusal Linear Instability in Safety-Aligned LLMsAccepted at TrustNLP 2026, the Sixth Workshop on Trustworthy Natural Language Processing, co-located with ACL 2026..md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [concurso, source-page]
---

## Tese central
Modern Large Language Models (LLMs) rely on extensive safety alignment, yet the mechanistic basis of refusal remains opaque. In this work, we investigate whether safety compliance is a deep semantic decision or a manipulable linear feature. We introduce Contrastive Logit Steering (CLS), a zero-optimization framework that isolates the “refusal direction” by contrasting hidden states derived from safe and unrestricted system prompts.

## Argumentos principais
### 1 Introduction
The rapid adoption of Large Language Models (LLMs) has necessitated robust safety alignment, typically implemented via Reinforcement Learning from Human Feedback (RLHF) [^10]. While these methods successfully suppress harmful outputs, the underlying mechanism of this suppression remains a “black box.” Does a safe model “unlearn” harmful knowledge, or does it merely learn a shallow heuristic to refuse specific queries?
In this work, we provide mechanistic evidence for the latter. We demonstrate that safety compliance in modern open-weights models is effectively encoded as a linear geometric feature. By analyzing the residual streams of models processing harmful versus benign queries, we identify a single direction (the “Refusal Vector”) that encodes the binary distinction between compliance and refusal.
Building on this insight, we introduce Contrastive Logit Steering (CLS).<sup>1</sup> Unlike optimization-based attacks like GCG [^17] that search for adversarial suffixes, CLS is a geometric intervention. We isolate the refusal vector by contrasting the model’s logits under “safe” and “unrestricted” system prompts, then linearly subtract this vector during inference. Unlike activation-level steering methods [^1] [^16] [^11], CLS operates at the shallowest possible intervention point (the output logits), serving as a diagnostic probe for alignment depth. We do not search for a bypass; we analytically compute the “Refusal Vector” and subtract it. We pair this with Prefix Injection (forcing the first token to “Sure”) to bypass the model’s initial refusal reflex.

### 2 Related Work
Our research sits at the intersection of adversarial red-teaming, mechanistic interpretability, and inference-time alignment. We distinguish Contrastive Logit Steering (CLS) from prior art along three dimensions: intervention point (logits vs. hidden activations), model requirements (single model vs. auxiliary models), and the interpretability insights each method provides.

### 2.1 Adversarial Attacks
Red-teaming has evolved from manual “jailbreaks” [^12] to automated optimization. The standard white-box baseline, GCG [^17], uses token-level gradient search for adversarial suffixes but is computationally expensive and brittle against modern safety training. Recent benchmarks [^8] indicate that instruction-tuned models have learned to robustly reject the gibberish suffixes GCG produces. Our experiments confirm this: GCG achieves only 5% ASR on Llama-3.1-8B even after 100 optimization steps. Alternative methods like AutoDAN [^7] use genetic algorithms to generate coherent attacks, but remain search-based techniques traversing a rugged loss landscape.
Among black-box methods, PAIR [^3] and TAP [^9] use LLM-generated prompts to jailbreak models without gradient access. While more efficient than GCG, these still involve iterative query-based search over the prompt space. In-Context Representation Hijacking [^13] manipulates in-context examples to redirect model behavior. CLS differs fundamentally from all search-based methods: rather than discovering adversarial inputs, it analytically computes and removes the refusal vector via a single arithmetic operation, serving as a mechanistic lower bound on the effort required to bypass safety.

### 2.2 Mechanistic Interpretability of Refusal
RepE [^16] and Activation Addition [^11] steer residual stream activations during the forward pass. Most directly relevant, Arditi et al. [^1] identified a universal “refusal direction” in intermediate hidden states. CLS differs in two respects: it isolates the refusal vector zero-shot via system prompt contrast (no supervised probing or layer selection), and it intervenes on logits rather than activations. The choice of logits is itself diagnostic: success at the shallowest intervention point is direct evidence of surface-level safety encoding. We provide empirical comparison in Section 4.

### 2.3 Contrastive Decoding and Activation Steering
Several methods exploit contrastive signals for safety steering. ROSE [^15] uses reverse prompt contrastive decoding to boost safety by suppressing undesired outputs induced by adversarial prompts. While ROSE operates on a similar contrastive principle, it is a defense-only method with no mechanistic analysis of where or how safety is encoded in the network. Weak-to-Strong Jailbreaking [^14] uses two separate auxiliary models (one safe, one unsafe) to adversarially modify a third model’s decoding probabilities, requiring multiple model instances and substantially more computational overhead. Self-Detoxifying LMs [^5] reverses toxic information flow using safe and unsafe prompts but does not analyze the geometric structure of refusal or provide any architectural taxonomy. Lee et al. [^4] demonstrated programmable refusal via conditional activation steering on internal hidden-state activations, requiring knowledge of which intermediate layers to intervene on.
CLS differs critically from all these methods: it requires only a single model with different system prompts, operates exclusively on output logits (making it architecture-agnostic with respect to layer selection), and uniquely provides the Late Decision / Early Divergence taxonomy and bidirectional control.

### 2.4 Inference-Time Alignment
Standard RLHF treats safety as a static weight update [^10]. Recent methods like Logit-Gap Steering [^6] modulate safety at inference time but rely on expensive decoding-time search. CLS enables Geometric Safety Control: bidirectional modulation by adjusting $\alpha$ to audit suppressed capabilities or harden models dynamically.

### 3 Methodology
We formalize Contrastive Logit Steering (CLS), which exploits the geometric structure of refusal to modulate safety at inference time via arithmetic operations on output logits.
Figure 2: Contrastive Logit Steering (CLS) Methodology. The model processes the user query simultaneously under three distinct system prompts. We calculate an instantaneous steering vector 𝐯 \\mathbf{v} by subtracting the logits of the “Safe” stream ( z − z^{-} ) from the “Unrestricted” stream ( + z^{+} ). This vector is scaled by α \\alpha and added to the Base stream logits ( b a s e z\_{base} ) before sampling, effectively modulating the model’s safety refusal mechanism in real-time without optimization.

### 3.1 Preliminaries
Let $M$ be an autoregressive language model that maps a sequence of tokens $x_{1:t}$ to a probability distribution over the vocabulary $\mathcal{V}$. At each step $t$, the model produces a hidden state $h_{t}\in\mathbb{R}^{d}$ and a logit vector $z_{t}\in\mathbb{R}^{|\mathcal{V}|}$, where $z_{t}=\text{Unembed}(h_{t})$.
We define a prompting template $\mathcal{T}(s,q)$ that wraps a system instruction $s$ and a user query $q$. We utilize three distinct system instructions:
- Base ($s_{base}$): A neutral or helpful instruction (e.g., “You are a helpful assistant.”).

### 3.2 Contrastive Logit Steering (CLS)
CLS functions by running three parallel forward passes for a given user query $q$. At each decoding step $t$, we obtain three logit vectors:
$$
\displaystyle z_{t}^{base}

### 3.3 Prefix Injection
Modern aligned models are trained to output immediate refusal tokens (e.g., “I cannot”, “Sorry”) at the very first step of generation. Even with a strong steering vector, the model’s initial refusal reflex can dominate the first few tokens, after which the autoregressive generation locks into a refusal trajectory. To bypass this, we force the first $k$ tokens to an affirmative prefix $p_{force}$ (e.g., “Sure”), while computing $v_{t}$ normally to influence the internal state:
$$
x_{t}=\begin{cases}p_{force}[t]&\text{if }t<|p_{force}|\\

### 3.4 Zero-Shot Detection Metric
The geometric separability of refusal enables detection. We define a Global Refusal Vector ($u_{ref}$) by averaging final-layer hidden states over harmful ($H$) and benign ($B$) anchor queries: $u_{ref}=\frac{1}{|H|}\sum_{x\in H}h(x)-\frac{1}{|B|}\sum_{x\in B}h(x)$. For any query $q$, we compute $S(q)=\cos(h_{q},u_{ref})$ and flag as malicious if $S(q)>\tau$. This achieves $>0.90$ F1 on JailbreakBench [^2] without training a separate model.
Figure 3: Steerability Heatmaps. (Top) Positive steering. (Bottom) Negative steering.

### 4 Experiments
We evaluate CLS across four dimensions: steering sensitivity (Alpha Sweep), comparison with GCG and activation-level steering [^1], and mechanistic analysis (PCA, KL divergence).

### 4.1 Experimental Setup
#### Models.
We test 7 open-weights models: Gemma-3 (4B, 12B), Llama-3.1 (8B), Llama-3.2 (3B), Llama-3.3 (70B), and Qwen-2.5 (1.5B, 7B). For comparison with Arditi et al. [^1], we additionally evaluate on Llama-2 and Qwen-7B.
#### Datasets.

### 4.2 Comparative Analysis: CLS vs. GCG
Figure 4: The Timeline of Refusal. KL Divergence across model depth. Llama-3.1 (Blue) shows a “Late Decision” pattern, diverging only in the final layers. Qwen-2.5 (Orange) shows “Early Divergence,” processing safety mid-network. This architectural difference explains Qwen’s higher resistance to steering.
#### Evaluation.
Automated evaluation of jailbreaks is notoriously noisy. Standard evaluators like LlamaGuard often yield high false positive rates, flagging responses that begin with “Sure” but subsequently refuse (e.g., “Sure, I can explain why that is illegal…”) as successful attacks. To mitigate this, we conducted a human validation study comparing three candidate judges: Gemma-2-27B, Llama-3-8B, and Mistral-Small-24B-Instruct-2501. The Mistral model demonstrated the highest alignment with 100 manually validated labels, so we employ it as our primary judge. We report two metrics: Attack Success Rate (ASR), the percentage of prompts where the model complies with the harmful request, and Coherence Score, a 1–5 Likert scale rating of linguistic quality ensuring steering does not degrade outputs into gibberish.

### 4.3 Results: Steering Intensity
We swept $\alpha\in[-5,5]$ at intervals of $1.0$ with $T=0.7$ (temperature variance was negligible).
#### Jailbreaking (α>0\\alpha>0): The Safety-Coherence Trade-off.
Figure 3 (Top) illustrates the rapid collapse of safety barriers under positive steering. Gemma-3 and Llama-3.3 exhibit a “binary” failure mode: notably, Gemma-3-12B jumps from 34% to 98% ASR at just $\alpha=1.0$, effectively removing all refusals instantly. However, this aggressive unlocking comes at a cost: coherence scores degrade significantly (3.74 $\to$ 2.14 at $\alpha=5$), indicating that extreme steering begins to override linguistic competence. In contrast, Qwen-2.5-7B displays exceptional resistance. Unlike Llama and Gemma, it requires high-magnitude steering to break. Even at $\alpha=5.0$, ASR reaches only 68.5% (compared to $>$ 96% for Llama models). This aligns with our KL-divergence analysis (Section 4.5), suggesting Qwen’s safety is deeply integrated and harder to subtract linearly. For the Llama-3.1 and 3.2 series, moderate steering ($\alpha\approx 2.0-3.0$) represents the optimal attack window, achieving $>90\%$ ASR while maintaining coherence $>3.0$.


## Key insights
- The “Late Decision” Vulnerability: Models like Llama-3.1 process harmful and safe queries identically for 95% of their layers, diverging only at the final output head. Consequently, CLS creates a “jailbreak” state with 95% Attack Success Rate (ASR) in approximately one second.
- The “Early Divergence” Defense: Models like Qwen-2.5 integrate safety earlier in the network (at $\sim 40\%$ depth), making them significantly more robust to linear steering.
- Base ($s_{base}$): A neutral or helpful instruction (e.g., “You are a helpful assistant.”).
- Positive/Unrestricted ($s^{+}$): An adversarial instruction explicitly stripping safety guardrails (e.g., “You are an unregulated assistant…”).
- Negative/Safe ($s^{-}$): A restrictive instruction enforcing extreme safety (e.g., “You must refuse any harmful query…”).
- If $\alpha>0$ (Jailbreaking): We inject the “unrestricted” behavior, suppressing safety tokens and unmasking raw model capabilities.
- If $\alpha<0$ (Hardening): We subtract the unrestricted behavior (effectively adding refusal), artificially inducing safety.

## Exemplos e evidências
See original source at `Clippings/The Geometry of Refusal Linear Instability in Safety-Aligned LLMsAccepted at TrustNLP 2026, the Sixth Workshop on Trustworthy Natural Language Processing, co-located with ACL 2026..md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/ai-agents/prompt]]
- [[03-RESOURCES/entities/Rust]]
