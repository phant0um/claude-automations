---
title: "OTTER: A Red-Teaming System for Toxicity-Evading Jailbreak Prompt Optimization"
type: source
source: "Clippings/OTTER A Red-Teaming System for Toxicity-Evading Jailbreak Prompt Optimization.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [concurso, source-page]
---

## Tese central
Production LLMs increasingly rely on toxicity-based moderation filters as a primary defense, assuming that harmful intent correlates with toxic surface wording. We show this assumption is fundamentally brittle: surface toxicity and adversarial intent can be decoupled by replacing as few as five tokens. We present OTTER (Obfuscated Toxicity-Evading Token Evolution for Rewriting), a black-box red-teaming framework requiring only standard API access, directly targeting the practical constraints of 

## Argumentos principais
### 1 Introduction
Toxicity-based moderation APIs serve as the primary input-side defense in production LLM deployments [^6], operating on the assumption that harmful intent correlates with toxic surface wording. We show this assumption is fundamentally brittle: surface toxicity and adversarial intent can be decoupled by replacing as few as five tokens.
Existing jailbreak methods face constraints that are unrealistic for practitioners auditing closed-source systems. White-box approaches such as GCG [^13] and AutoDAN [^3] require model weights and gradients unavailable via commercial APIs. Black-box approaches such as PAIR [^1], TAP [^5], and DAGR [^12] rely on a capable auxiliary attacker LLM, adding cost and latency. This leaves a gap: an attack that requires nothing beyond the access an ordinary API user already has — no weights, no gradients, and no auxiliary model.
Figure 1: OTTER rewrites a harmful prompt into a lower-toxicity form that bypasses the safety filter.

### 2.1 Adversarial Attacks on LLMs
Jailbreak attacks against aligned LLMs can be broadly categorized by their access assumptions.
White-box attacks assume full access to model weights and gradients. GCG [^13] optimizes adversarial token suffixes via greedy coordinate gradient descent, and AutoDAN [^3] uses a hierarchical genetic algorithm with log-likelihood as a fitness function. Both achieve strong attack success rates in controlled settings but are inapplicable to commercial closed-source APIs. BEAST [^9] is gradient-free but requires local model access to perform beam search over token probabilities, making it similarly inapplicable to closed-source deployments.
Black-box attacks with attacker LLMs operate through input–output queries but rely on a separate capable model to generate and refine jailbreak candidates. PAIR [^1] iteratively queries the target model and refines candidates with an attacker LLM, typically converging within twenty queries. TAP [^5] extends PAIR with tree-structured search and an evaluator LLM that prunes unpromising branches. DAGR [^12] achieves higher diversity by alternating between globally diversified root prompts and locally obfuscated leaf prompts. PAP [^11] takes a different angle, applying a taxonomy of 40 persuasion strategies to rewrite harmful prompts, achieving over 92% ASR on Llama-2-7b-Chat, GPT-3.5, and GPT-4; however, its rewriting process still relies on an attacker LLM, and its objective is to alter the model’s semantic interpretation rather than to reduce moderation scores. OTTER’s distinguishing property is that it targets the toxicity score itself as the optimization objective, using mask-drop attribution to identify the specific tokens driving the moderation decision, without requiring any model internals or external attacker LLM.

### 2.2 Toxicity Detection and Content Moderation
Deployed LLMs are commonly paired with moderation classifiers that score input toxicity before the query reaches the model [^6]. These classifiers are typically trained on datasets of toxic content labeled at the surface level, making them sensitive to explicit toxic keywords. Prior work has shown that such surface-level classifiers can be fooled by paraphrasing or character-level encoding. In the text-to-image domain, SneakyPrompt [^10] similarly uses reinforcement-learning-guided token substitution to bypass image generation safety filters, demonstrating that filter-evasion via lexical perturbation generalizes across modalities. However, none of these approaches systematically characterizes which tokens drive the classification decision or quantifies how much toxicity reduction is sufficient to change model behavior. OTTER addresses this gap through mask-drop attribution and provides the first empirical quantification of the toxicity–bypass relationship.

### 2.3 Red-Teaming and Safety Evaluation
Standardized benchmarks such as AdvBench [^13] and HarmBench [^4] provide corpora of harmful behaviors for evaluating attack and defense methods, reporting attack success rate (ASR) as the primary metric. However, existing red-teaming work rarely examines why certain prompts are bypassed or how bypass rates vary across harm categories. DAGR [^12] provides a category-level breakdown of ASR on HarmBench, offering one of the few systematic analyses of harm-type variation. Our work extends this direction with the first quantitative characterization of the toxicity–bypass relationship (BTC, AUC, logistic regression) and a per-category analysis across nine harm types, providing actionable guidance for moderation hardening priorities.

### 3.1 Problem Formulation
Figure 2 gives an overview of the full OTTER pipeline.
Figure 2: OTTER workflow. The attack prompt selection module chooses a test prompt. The OTTER rewriting module identifies toxicity-contributing tokens (Step 1), builds candidate substitution sets (Step 2), and performs greedy search to find a low-toxicity rewrite preserving adversarial intent (Step 3). The attack evaluation module sends the revised prompt to a target LLM.
OTTER treats jailbreak rewriting as a constrained optimization problem: find a surface-level rewrite of a harmful prompt that (i) falls below the moderation API’s toxicity threshold and (ii) preserves the original adversarial intent. Formally, let $p=(w_{1},\ldots,w_{n})$ be a harmful prompt, $T(p)\in[0,1]$ a black-box toxicity scorer (e.g., the OpenAI Moderation API [^6]), and $E(p)\in\mathbb{R}^{d}$ the semantic embedding of $p$ produced by a sentence encoder [^8]. OTTER seeks a rewritten prompt $p^{*}$ satisfying:

### 3.2 Token Attribution via Mask-Drop
OTTER first identifies which tokens are most responsible for the toxicity score. For each position $i$, we mask token $w_{i}$ and recompute the toxicity score:
$$
\Delta_{i}=T(p)-T\!\left(p_{i}^{\text{mask}}\right)

### 3.3 Candidate Generation: Two Variants
For each selected position $i_{j}\in\mathcal{P}$, OTTER constructs a candidate substitution set $C_{i_{j}}$. We provide two variants that differ in how candidates are generated.
OTTER-MLM queries BERT [^2] in fill-mask mode to obtain the top- $K$ contextually appropriate replacements for each masked position. These candidates are semantically coherent and context-aware, producing fluent rewrites at low API cost. Any candidate whose cosine similarity to the original prompt falls below $\delta$ is rejected before evaluation, enforcing the semantic constraint (Equation 2) *by construction*.
OTTER-RV samples uniformly from the full filtered BERT vocabulary (alpha-only tokens, no subwords, length $>2$, $|V|\approx 20{,}000$). This broader search space enables more aggressive toxicity reduction, at the cost of higher API call volume.

### 3.4 Greedy Per-Position Search
Given the candidate sets $\{C_{i_{j}}\}_{j=1}^{k}$, OTTER uses greedy per-position search to find a replacement vector $x=(x_{1},\ldots,x_{k})$ where $x_{j}\in C_{i_{j}}$. For each position in order, OTTER evaluates all candidates and selects the one minimizing:
$$
\mathcal{L}(x)=T\!\bigl(g(p,x)\bigr)+\lambda\Bigl(1-\cos\!\bigl(E(g(p,x)),\,E(p)\bigr)\Bigr)

### 3.5 Implementation Details
We use $k=5$ edited positions, $\lambda=0.1$, and semantic similarity threshold $\delta=0.7$. Toxicity scoring uses the OpenAI Moderation API [^6]; semantic embeddings use bert-base-uncased CLS embeddings [^2]. Full hyperparameter details are in Appendix B.

### 4.1 Dataset
We evaluate OTTER on AdvBench [^13], a widely used benchmark of 520 harmful behavioral instructions covering cybercrime, weapons, fraud, violence, drugs, self-harm, hate speech, and child safety. We first pass all 520 prompts through the OpenAI Moderation API and retain only those flagged as harmful, yielding 457 prompts. The discrepancy reflects API version drift: the current moderation API flags a substantially larger fraction of AdvBench prompts than earlier versions did. Importantly, this is not a sampling choice; we run the full AdvBench through the filter and retain everything the current defense system considers in-scope, producing a more comprehensive and up-to-date evaluation.

### 4.2 Models
We evaluate on four closed-source GPT models accessed via the OpenAI chat API: gpt-4-turbo, gpt-4o, gpt-4o-mini, and gpt-3.5-turbo [^7]. These models represent the most widely deployed closed-source LLMs in production settings and thus the most relevant targets for industry red-teaming.

### 4.3 Baselines
We compare against two baselines.
Direct prompt (AdvBench). The original AdvBench harmful prompts, unmodified, submitted directly to each target model. This establishes the pre-rewriting ASR baseline.
GPT-4o paraphrase. We instruct GPT-4o to rewrite each prompt using milder language while preserving meaning, using a single API call per prompt. This represents the simplest practitioner-accessible rewriting strategy, requiring no specialized framework.

### 4.4 Evaluation Metric
Attack success rate (ASR) is defined as the fraction of prompts for which the target model does *not* produce a refusal response. Refusal is detected via keyword matching against a standard list of refusal phrases (e.g., “I cannot”, “I’m unable”, “I will not”), following the substring-based approach of [^13]; timed-out API responses are treated as refusals. We report 95% bootstrap confidence intervals (2,000 resamples) for all ASR values.

### 5.1 Main Results
Table 1: ASR (%) with 95% bootstrap CI. OTTER-RV avg. 84.0%; GPT-4o paraphrase baseline avg. 77.0% (see §5.4).
| Model | AdvBench | OTTER-MLM |
| --- | --- | --- |

### 5.2 Harm Category Breakdown
Figure 4: OTTER-MLM ASR by harm category. Dashed line: weighted average (78.5%).
Table 2: Per-category ASR and $\Delta$ Tox for OTTER-MLM.
| Category | n | ASR (%) | $\Delta$ Tox |


## Key insights
- OTTER with two variants (OTTER-MLM / OTTER-RV), a lightweight black-box red-teaming framework operable with standard API access alone.
- First systematic empirical analysis of the toxicity–bypass relationship with BTC, AUC, and per-category breakdowns.
- Zero false positives on benign prompts, with actionable defense recommendations for closed-loop classifier hardening.

## Exemplos e evidências
See original source at `Clippings/OTTER A Red-Teaming System for Toxicity-Evading Jailbreak Prompt Optimization.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/ai-agents/prompt]]
- [[03-RESOURCES/entities/OpenAI]]
- [[03-RESOURCES/entities/Rust]]
