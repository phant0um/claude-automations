---
title: "Black-Box Forensics for Conversational LLM Agents"
type: source
source: "Clippings/Black-Box Forensics for Conversational LLM Agents.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [concurso, source-page]
---

## Tese central
As LLM-powered scams proliferate, black-box forensics for conversational LLM agents offers a path to accountability for systems hidden behind anonymous endpoints. Identifying the base model behind a chatbot endpoint (attribution), without model parameter access or knowledge of the hidden system prompt, would let investigators trace AI-enabled scams back to the providers whose models power them. Detecting when two endpoints run the exact same system prompt (fingerprinting), even one novel and uns

## Argumentos principais
### 1 Introduction
As LLM adoption grows, so does abuse. AI-assisted fraud and social-engineering campaigns now operate at scale [^16] [^17], bots spread misinformation unchecked across the internet, and the models behind API endpoints are swapped without disclosure. These agents are anonymous by construction: an investigator observes nothing but conversational behavior, with no access to model weights or hidden instructions. This paper develops black-box forensics for conversational LLM agents—techniques that recover identifying information about an agent’s base model and system prompt purely by conversing with it. We study two complementary capabilities: attribution, identifying which base model or system prompt powers an endpoint from a closed set of options, and fingerprinting, detecting whether two endpoints share the same—possibly never-before-seen—system prompt.
Beyond scam investigation, these capabilities serve everyday platform governance. API users depend on stable model behavior, yet providers may silently update backend checkpoints, safety layers, or system prompts, and such unannounced revisions can materially shift downstream behavior [^9] [^18]. Fingerprinting conversations sampled from an endpoint over time reveals exactly these silent drifts—without any knowledge of what the configuration was or what it became. Security teams face the complementary problem: jailbreaks transfer only partially across models and prompt templates [^48] [^43], so red-teaming must be tailored to a specific vulnerability profile, and attribution tells defenders which model they are actually facing.
A practical forensic tool must also be covert. Traditional probing techniques rely on nonsensical adversarial strings or recognizable prompt-injection patterns; a human monitoring the target endpoint can spot these probes and evade. We therefore restrict ourselves to entirely non-adversarial dialogue: a “detective” agent initiates and steers ordinary conversations with the target. Beyond covertness, this active elicitation paradigm offers a second advantage over auditing static text dumps—fine-grained control over topic and conversational flow, letting us isolate the target’s behavioral signature from semantic noise.

### 2 Related Work
| Method | System Prompts | Attribution | Active Querying | Conversational | Black-Box |
| --- | --- | --- | --- | --- | --- |
| LLMmap [^31] | ${\color[rgb]{0.7,0,0}\definecolor[named]{pgfstrokecolor}{rgb}{0.7,0,0}\times}$ | ✓ | ✓ | ${\color[rgb]{0.7,0,0}\definecolor[named]{pgfstrokecolor}{rgb}{0.7,0,0}\times}$ | ${\color[rgb]{0.7,0,0}\definecolor[named]{pgfstrokecolor}{rgb}{0.7,0,0}\times}$ |

### 3 Approach
This paper explores two methods for black-box forensics: (1) attribution and (2) fingerprinting. A note on terminology: prior work uses ‘fingerprinting’ to identify a base model, often via signatures injected during training [^44] [^46] or query-based probing [^31]. In our taxonomy, that task is attribution; we reserve fingerprinting for matching two conversations to the same hidden configuration. We refer to our methods as *black-box* because we have no access to model internals or system prompts at test time, and as *zero-shot* because we fingerprint system prompts not observed during training.
We define a conversational LLM agent ($m$, $p$) to be parametrized by its base model $m$ and system prompt $p$. Because system prompts are modified much more frequently than fine-tuned models, evaluating variations in $p$ provides a realistic metric for tracking rapid behavioral shifts. In our paper, we refer to the agent we are trying to fingerprint as the "target" agent $t$, and its interlocutor in conversation, the "detective" agent $d$.
Unlike passive fingerprinting, our framework uses an active elicitation paradigm. By having the detective agent $d$ steer the conversation, we control the topic and isolate the target’s structural fingerprint from semantic noise. To reflect real-world forensic auditing and honeypot scam detection, we center these controlled interactions on common customer support and negotiation scenarios.

### 3.1 Tasks
#### Attribution of Base Models
Suppose you encounter a scam bot and want to know the underlying base model, irrespective of the prompt. To solve this problem, we introduce our attribution techniques. Black-box attribution identifies the base model $m\in M$ (and system prompt $p\in P$ when it comes from a known set) of a target agent from fixed candidate sets, given a conversation $c$ with a detective agent. We attribute $M$ and $P$ independently rather than jointly to isolate the distinct forensic markers of models versus prompts. For prompt attribution, we perform both multi-class and pairwise detection; distinguishing a specific pair $p_{a},p_{b}\in P$ allows us to systematically trace how isolated prompt modifications manifest as detectable behaviors in conversations $c$.
#### Fingerprinting of System Prompts

### 3.2 Datasets
Training and evaluating a robust attribution and fingerprinting system require a large-scale dataset, where the base model and system prompt of every conversation are precisely known. Obtaining real-world labeled data of a sufficient scale is infeasible because the extraction of system prompts from API providers breaches a gray area in copyright law, and malicious actors do not disclose their backend architectures or operational system prompts. Relying on scraped data introduces confounding variables, as the exact prompt, model version, and generation hyperparameters remain hidden. Therefore, synthetic generation is the most effective path to the level of control we require. Leveraging our detective LLM agent (powered by Qwen-4B-Instruct) to conduct standardized interactions with target agents, we can produce a supervised corpus of 240k labeled transcripts from six base models and 40 system prompts over 70 customer support and negotiation topics. This synthetic data provides the foundation for training the forensic methods described in the sections below. As real-world system prompts may be more diverse in their behaviors than those studied in this paper, it is possible that our reported metrics on our synthetic system prompts are a lower bound on true in-the-wild performance.
#### Curating base system prompts.
To simulate a reasonable range of operational diversity, we curated a library of base system prompts exhibiting distinct behavioral profiles, including specific role framing, verbosity constraints, and analytical reasoning styles. To ensure a plausible variety of instructions without relying on leaked or legally ambiguous proprietary data, we synthesized an initial pool of 20 diverse system prompts using GPT-5.2 [^36] found in Appendix C.

### 4 Experiments
Below, we articulate our experimental setup and evaluation splits for both black-box attribution and zero-shot black-box fingerprinting. For all of these experiments, we train our methods only on target agent utterances to amplify the signal from target agent stylistic and semantic signatures.

### 4.1 Attribution Techniques
Taking inspiration from established authorship attribution methodologies [^38] [^41] [^22], we apply these to our multi-turn conversational paradigm. We implement two standard classifier families—previously validated primarily on static text generations—and evaluate their performance within our active elicitation framework.
The first approach is a sparse baseline that mirrors traditional stylometric methodologies commonly deployed in LLM provenance studies [^38] [^41]. Specifically, we utilize unigram and character-level TF–IDF alongside stylometric features (e.g., punctuation frequencies and utterance lengths) paired with a multinomial logistic regression classifier [^35] trained with scikit-learn [^32]. See Appendix˜F for details regarding our stylometric feature extraction. While works like GPT-Who [^41] leverage similar statistical and stylometric markers to attribute isolated text snippets, our evaluation tests whether these features remain robust discriminative signals across continuous, multi-turn dialogue. The second approach evaluates the modern paradigm of utilizing language models as dense classifiers [^22]. We implement an LLM-based classifier by fine-tuning Qwen-4B-Instruct with LoRA adapters (rank 64) [^24], utilizing Unsloth for optimized training efficiency [^39].
We deploy these two baseline techniques across two primary tasks: (1) multi-way black-box attribution of base models, (2) two-class differentiation to detect variations between underlying system prompts differentiating $(m,p_{1})$ from $(m,p_{2})$, and (3) multi-way black-box attribution of system prompts. To ensure a rigorous evaluation, we perform a 5-fold cross-validation across our dataset of elicited conversations. Furthermore, for the multi-way base model attribution, we conduct experiments conditioning the classifiers on either a single system prompt or the complete set of system prompts.

### 4.2 Fingerprinting Techniques
In this section, we illustrate the experimental details of our fingerprinting techniques, from baselines to our cross-encoder and bi-encoder methods.
#### Model Equality Testing Baseline
We adapt [^18] to our problem by framing conversation-origin detection as a per-pair two-sample test on the dataset described in Table˜2, calibrating on the train set and reporting on the test set. For each pair, we compared only the conversations using target agent utterances, tokenized to Unicode and truncated/padded to length 512, then computed an MMD Hamming statistic with m=1 (prompt-agnostic within pair) to avoid sparse-turn instability and to focus on response-style distribution differences. Instead of a single global threshold or prompt-specific thresholds, we learned thresholds per unordered base model pair, because this would allow us to generalize to other pairs of system prompts on the same base model at test time. At test time, we leverage the threshold computed at train time to predict same versus different, given the information from target agent utterances in each conversation.

### 4.3 Evaluation
#### Evaluation Splits
Using the conversations generated in section˜3.2, we match the conversations based on topic and create an even number of pairs with the same agent and with a different agent in both splits. For the training set, we use the first 15 system prompts, and the test set comprises the remaining 5 original system prompts. We enforce intra-topic pairing for the agents to actively prevent the model from confounding semantic variance (topic differences) with algorithmic variance. We split on the system prompts to demonstrate generalization to new system prompts not seen during training. All of the ‘different’ pairs in our primary evaluation set share the exact same base model and differ exclusively by their system prompt. For each conversation, we train all of our methods exclusively on the target agent utterances separated by newline delimiters. Dataset statistics can be found in Table˜2.
| Metric | Train | Test |

### 5 Results
#### Attribution.
Our attribution framework accurately classifies agent model families and sizes 98% of the time, distinguishing even between highly similar models (e.g., GPT-OSS-20B and GPT-OSS-120B) with 95% accuracy. Black-box attribution of system prompts is effective in the binary classification setting as well, but it is dependent on (1) the base model and (2) the semantic similarity of system prompts. In Table˜3, we evaluate both binary and multi-way prompt attribution. While sparse features (TF–IDF) achieve a strong 0.914 average accuracy in pairwise settings, multi-way classification proves significantly more challenging, with our Qwen-4B-Instruct SFT classifier struggling to exceed 63% accuracy. To understand what factors drive these attribution rates, we analyzed performance across different base models and prompt variations. First, we find that accuracy is heavily gated by the base model’s inherent responsiveness to instructions. Models like Qwen-4B-Instruct, GPT-4o-Mini, and GPT-4.1-Nano are highly sensitive to prompt constraints, yielding pairwise accuracies above 90%. Conversely, GPT-OSS-20B and GPT-OSS-120B exhibit much lower attribution accuracies and a negligible correlation ($r<0.2$) between prompt semantic similarity and detectability. Confusion matrices detailing these model-specific distributions can be found in Appendix˜H.
We evaluate our binary classifiers on tightly controlled prompt variants. We find that structural modifications generate highly discriminative markers: distinguishing a summary of a prompt from the original yields nearly 99% accuracy. However, when the semantic intent is preserved (e.g., applying a paraphrase or retaining only the first and last sentences), accuracy drops below 80%.

### 6 Conclusion
This work introduces techniques for black-box forensics. Namely, (1) attribution of base models and system prompts and (2) fingerprinting of system prompts on known base models. Previous works such as DetectGPT [^30] require access to model internals, while other works, such as [^31], leverage prompt injections and out-of-distribution inputs. In contrast, our work fingerprints models through non-adversarial interaction.
Future work should include integrating this system into real-world workflows, such as a honeypot LLM system, designed to entrap scammers and use this information to trace cyber criminals defrauding the globe. For the deployment of our methods, we recommend using attribution in conjunction with fingerprinting. Fingerprinting can be used to group conversations together, and multiple conversations from different endpoints can be used to decrease uncertainty. Once a specific suspicious set of outputs is linked to one another, our attribution techniques can be leveraged to trace these outputs to the specific model provider.

### 7 Limitations
While evaluating black-box fingerprinting on live, wild-caught scam deployments remains an ultimate objective for industry deployment, utilizing a meticulously controlled synthetic corpus is a deliberate and vital methodological choice. This approach bypasses significant ethical and legal gray areas regarding prompt extraction from proprietary systems. Instead, we curate a set of system prompts from a critical deployment sector: customer support and negotiation. Using our active elicitation paradigm with the detective agent interlocutor, we can control the flow of conversations to similar directions, mitigating the risk of topic drift. By enforcing strict intra-topic pairing across 70 distinct negotiation and support environments, we actively isolate semantic topic variables from structural stylistic footprints. This evaluation design ensures that when our cross-encoder models successfully evaluate conversational pairs under entirely unseen system prompts, they are mapping prompt-driven behavioral blueprints rather than topic-driven semantic shifts.

### 8 Ethical Considerations
Idiosyncratic system prompts in personalized LLMs could inadvertently serve as proxies for deanonymization. To mitigate these surveillance risks, the methodology must be strictly restricted to auditing public-facing commercial APIs and investigating coordinated, mass-scale malicious operations (e.g., automated social engineering, scam infrastructure, or API abuse).
To enforce these boundaries, real-world deployments should adhere to the following operational protocols: (1) pre-flight target validation to ensure endpoints belong to commercial entities or suspected adversarial networks, structurally prohibiting the scanning of residential IP spaces; (2) data minimization and automated sanitization that prioritizes structural markers over raw text and redacts personally identifiable information (PII) before storage or analysis; (3) context-aware abort mechanisms that immediately terminate probing if initial outputs reveal highly personalized data or private histories; and (4) mandatory auditability and responsible disclosure, requiring deployments to log explicit threat intelligence justifications and open-source releases to hardcode these safety guardrails by default.

### Appendix A Proxy Prompting Details
We use the following prompt to rewrite the utterances using GPT-4o-Mini.
[⬇]()
{

### Appendix B Recommended Decision Thresholds
We report recommended decision thresholds for different values of $k$ under two false-positive-rate constraints, illustrating the trade-off between conservative and more permissive attribution decisions.
Table 7: Recommended decision thresholds by $k$ under an $FPR<0.10$ constraint (maximize TPR). There is no feasible threshold for $k=3$ where the FPR is less than $0.10$ so it is listed as N/A.
| $k$ | Threshold | FPR | TPR |


## Key insights
- Fingerprinting of unseen system prompts. Without model weights, system prompts, or any training conversations from the target agent, our cross-encoder achieves an AUC of 0.768 and an F1 of 0.703 on entirely unseen system prompts.
- Fingerprinting scales with evidence. Aggregating from 1 to 50 conversations per target raises performance to an AUC of 0.943 and an F1 of 0.77.
- Variant 1 (First/Last): “You are a friendly, conversational assistant. Make the interaction feel easy and comfortable.”
- Variant 2 (Paraphrase): “You are an approachable assistant with a natural, human tone. Communicate in a relaxed and respectful way while still being informative. Do not sound overly rigid or formal unless the user wants that style. Help the conversation feel smooth and comfortable.”
- Variant 3 (Paraphrase): “You are a warm and easygoing conversational assistant. Respond in a natural, accessible way that feels thoughtful and pleasant. Stay helpful and respectful without sounding stiff. Shift into a more formal style only when the user prefers it.”
- Variant 4 (Summary): “Be friendly, natural, and easy to talk to. Keep the tone relaxed, respectful, and informative.”
- Variant 1 (First/Last): “You are an educational assistant with the style of a clear, organized teacher. Keep your tone encouraging and precise.”
- Variant 4 (Summary): “Explain like a clear and organized teacher. Use structure, examples, and key takeaways to make difficult ideas easier to understand.”
- Variant 1 (First/Last): “You are a cheerful and upbeat assistant. Match the user’s tone when they prefer something calmer.”
- Variant 4 (Summary): “Be upbeat, encouraging, and supportive while still being useful. Keep the energy positive, but adapt to the user’s preferred tone.”

## Exemplos e evidências
See original source at `Clippings/Black-Box Forensics for Conversational LLM Agents.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/entities/OpenAI]]
- [[03-RESOURCES/entities/Rust]]
- [[03-RESOURCES/entities/Python]]
