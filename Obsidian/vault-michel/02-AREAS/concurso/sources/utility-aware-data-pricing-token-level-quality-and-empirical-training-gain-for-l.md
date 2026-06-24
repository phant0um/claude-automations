---
title: "Utility-Aware Data Pricing: Token-Level Quality and Empirical Training Gain for LLMs"
type: source
source: "Clippings/Utility-Aware Data Pricing Token-Level Quality and Empirical Training Gain for LLMs.md"
created: 2026-06-23
ingested: 2026-06-23
score: B
tags: [concurso, source-page]
---

## Tese central
Traditional data valuation methods based on “row-count $\times$ quality coefficient” paradigms fail to capture the nuanced, nonlinear contributions that data makes to Large Language Model (LLM) capabilities. This paper presents a dynamic data valuation framework that transitions from static accounting to utility-based pricing. Our approach operates on three layers: (1) token-level information density metrics using Shannon entropy and Data Quality Scores; (2) empirical training gain measurement t

## Argumentos principais
### 1.1 Background
The emergence of Large Language Models (LLMs) has fundamentally transformed the landscape of artificial intelligence, creating unprecedented demand for high-quality training data [^1] [^15]. Traditional data valuation methods, predominantly based on “row-count $\times$ quality coefficient” paradigms, have served the data economy adequately for conventional machine learning applications. However, these static accounting approaches fail to capture the nuanced, nonlinear contributions that individual data samples make to the emergent intelligence of modern foundation models.
The data marketplace has long operated under the assumption that data value scales linearly with quantity and quality scores. A dataset containing one million records is valued at approximately twice that of a dataset containing five hundred thousand records, with adjustments made for completeness, accuracy, and timeliness. This paradigm, while tractable for traditional analytics and classical machine learning, proves increasingly inadequate in the context of modern AI systems where a single high-quality reasoning chain may contribute more to model capability than millions of repetitive conversational exchanges.

### 1.2 Problem Statement
The inadequacy of traditional valuation methods manifests in three critical dimensions. First, static metrics fundamentally fail to capture the nonlinear contribution of data to model intelligence. In the context of LLM training, the marginal utility of additional data varies dramatically based on the model’s current capabilities and the novelty of the information being introduced [^10] [^8]. A mathematical proof that introduces a novel reasoning pattern may yield significant capability improvements, while thousands of similar examples provide diminishing returns.
Second, the opacity of current valuation mechanisms creates pervasive information asymmetry in data markets [^7]. Data sellers cannot substantiate their pricing claims with verifiable evidence of their data’s contribution to model performance. Data buyers, conversely, cannot verify whether the premium they pay for “high-quality” data translates into meaningful improvements in their models. This asymmetry undermines market efficiency and discourages the production of genuinely valuable training data.
Third, the lack of verifiability in data valuation creates challenges for accountability and compliance. As regulatory frameworks increasingly scrutinize AI training practices, the absence of cryptographic guarantees regarding data provenance and contribution becomes problematic. Organizations cannot demonstrate that their models were trained on appropriately licensed and compensated data, creating legal and ethical vulnerabilities.

### 1.3 Research Objective
This paper proposes a comprehensive framework for dynamic data valuation that addresses these limitations through three foundational pillars:
Our framework enables a transition from static, quantity-based pricing to dynamic, utility-based valuation that accurately reflects the true contribution of data to AI system capabilities. By providing verifiable proofs of data value, we establish the foundation for a more efficient, transparent, and fair data pricing. An open-source implementation of the complete valuation pipeline is available at [).
The remainder of this paper is organized as follows. Section 2 reviews related work and motivates our token-based approach. Section 3 presents our valuation framework, including token-level quality metrics, proxy-based empirical gain, influence functions, Shapley values, and the unified ensemble. Section 4 introduces the cryptographic verifiability layer. Section 5 defines the experimental validation protocol and reports results, and Section 6 discusses implications and future directions.

### 2.1 Traditional Data Valuation
The data marketplace has long operated under pricing models that scale linearly with data quantity, typically expressed as “row-count $\times$ quality coefficient” [^7]. Quality coefficients capture dimensions such as completeness (missing value rates), accuracy (error rates), timeliness (recency), and consistency (format compliance). While these metrics serve conventional analytics and classical machine learning adequately, they assume that each data record contributes roughly equally to the downstream task. This assumption breaks down for large language models, where the marginal utility of additional data varies dramatically based on the model’s current capabilities and the novelty of the information being introduced [^10] [^8].
Several lines of work have attempted to move beyond simple row-based pricing. Data auctions and marketplace platforms have explored quality-weighted pricing, but the quality metrics remain largely static and exogenous to the training process. More recently, data-centric AI research has highlighted the importance of data quality over data quantity [^2], but has not yet produced pricing mechanisms that reflect this insight at market scale.

### 2.2 Data Attribution Methods
A growing body of work addresses the question of how individual training samples contribute to model behavior. Influence functions [^6] [^11] trace the effect of training points on model predictions through the geometry of the loss landscape. Related gradient-based methods, such as TracIn [^12], track gradient alignment between training and test points across training checkpoints. On the game-theoretic side, Data Shapley values [^3] [^9] provide a principled framework for fairly allocating value among data contributors, satisfying axioms of efficiency, symmetry, and additivity. These methods have been validated on moderate-scale models and classification tasks, but their scalability to billion-parameter language models and their integration into a complete pricing pipeline remain open challenges.
Shannon entropy [^14] provides a natural framework for measuring information content. In the context of language models, perplexity—the exponentiated average negative log-likelihood—serves as a standard measure of how well a model predicts a text corpus. Perplexity-based filtering has been widely adopted in data curation pipelines: documents with very low perplexity (near-duplicates, boilerplate) or very high perplexity (garbled text, code mixed with natural language) are often excluded. However, these approaches typically operate at the document level and do not provide a continuous, token-granular valuation signal suitable for differential pricing.

### 2.3 Cryptographic Verification in Machine Learning
The need for verifiable machine learning has motivated research into cryptographic proof systems. Commitment schemes and Merkle trees provide tamper-evident data binding. Zero-knowledge proofs [^4] and zk-SNARKs [^5] enable proving properties of data or computations without revealing the underlying content. Recent work has applied these tools to verifiable inference and model integrity, but their application to data valuation—proving that a specific dataset contributed a specific amount to model performance—remains largely unexplored.

### 2.4 Gap Analysis: Why Tokens Are the Currency of AI
The preceding research threads share a common limitation: they operate on data abstractions (rows, documents, samples) that do not match the granularity at which modern AI systems actually process information. Transformer-based architectures [^1] [^13] process and learn from *tokens*, not entries. A token typically represents a subword unit, enabling the tokenization of diverse data types—natural language text, programming code, mathematical notation, and structured data—into a unified representational format.
This mismatch between valuation granularity and processing granularity creates three problems. First, cross-modal comparability is lost: a thousand tokens of Python code and a thousand tokens of natural language cannot be meaningfully compared under row-based pricing, even though they are directly comparable as token sequences. Second, granular attribution is impossible: training dynamics operate at the token level, with gradient updates computed for each position, but traditional valuation assigns a single quality score to an entire document. Third, redundancy compression is ignored: tokenization naturally handles redundancy through subword encoding where frequent sequences receive shorter representations, but row-based pricing treats all rows equally regardless of information density.
These observations motivate our token-based valuation framework, which we present in the following sections. We begin with token-level quality assessment (Section 3), proceed to empirical training gain measurement, and conclude with cryptographic verifiability.

### 3 Impact-Driven Valuation: Measuring Training Dividends
This section presents our valuation framework in four parts. We begin with token-level quality assessment (information density, syntactic coherence, and semantic richness), which provides fast ex-ante estimates of data value. We then introduce a lightweight proxy model and value function, followed by three complementary approaches for quantifying the “training dividend”—the actual improvement in model capability attributable to specific data sources: leave-one-source-out proxy gain, influence function attribution, and Monte Carlo Shapley values. We conclude by combining all signals into a unified ensemble score.

### 3.1 Token-Level Quality Assessment
Before measuring empirical training dividends, we first establish ex-ante quality metrics that operate at token granularity. These metrics provide a fast, model-free estimate of data value that can be computed before any training occurs. We first describe the tokenization used throughout the framework, then present the information density metric and Data Quality Score.
#### 3.1.1 Tokenization
All text is tokenized using a regular-expression based tokenizer that extracts alphanumeric words and individual punctuation marks from the lowercased input. Specifically, the pattern matches sequences of \[A-Za-z0-9\_\] (words) and single non-whitespace, non-word characters (punctuation). This lightweight scheme handles natural language, code, and mixed-format text uniformly, producing a sequence of lowercase tokens without requiring a pretrained subword vocabulary.

### 3.2 Proxy Model and Empirical Value Function
#### 3.2.1 The Proxy Model
Directly measuring data value on a full-scale LLM is prohibitively expensive. Instead, we employ a lightweight proxy model that preserves the essential structure of the valuation problem while remaining computationally tractable. Our proxy model is a logistic regression classifier with hash-based text featurization. Given a training set $\mathcal{D}=\{(x_{1},y_{1}),\ldots,(x_{n},y_{n})\}$ where $x_{i}$ is the featurized text and $y_{i}\in\{0,1\}$ is the label, the model minimizes the regularized log-loss:
$$

### 3.3 Influence-Based Attribution
While leave-one-source-out ablation directly measures empirical impact, it requires retraining the proxy model for each source. Influence functions offer a gradient-based alternative that approximates the effect of data points without retraining, making them useful for fine-grained attribution within sources.
#### 3.3.1 The Influence Function
The influence of a training point $z$ on a validation set $\mathcal{V}$ quantifies how much the model’s validation loss would change if $z$ were upweighted during training:

### 3.4 Data Shapley Values
For scenarios requiring fair allocation of value among multiple data contributors, we turn to cooperative game theory. Shapley values [^3] [^9] provide the unique value allocation satisfying four desirable axioms: efficiency (total value is fully distributed), symmetry (equivalent contributors receive equal value), dummy player (non-contributors receive nothing), and additivity (values are additive across tasks).
#### 3.4.1 Definition
For a collection of $n$ data sources $\mathcal{D}=\{D_{1},\ldots,D_{n}\}$ and value function $V(\cdot)$, the Shapley value of source $i$ averages its marginal contribution over all possible orderings in which sources could be added:

### 3.5 Unified Valuation Framework
#### 3.5.1 Ensemble Scoring
The three methods above capture complementary aspects of data value: proxy gain directly measures empirical impact, influence functions provide efficient gradient-based attribution, and Shapley values ensure fair allocation. Together with the ex-ante Data Quality Score described above, we combine all four signals into a unified score using a weighted ensemble:
$$

### 4 The Verifiability Layer: Establishing Trust in Value
The valuation methods described in previous sections provide mechanisms for estimating data value, but they do not inherently provide assurance that these estimates are accurate or that they have not been manipulated. This section introduces a cryptographic verifiability layer that establishes trust in the valuation process. Our prototype implementation focuses on hash-based commitments, Merkle trees for data integrity, and a hash-chained training ledger—providing tamper-evident auditing without requiring the full complexity of zero-knowledge proof systems. We describe the implemented components first, then discuss how they extend to more advanced cryptographic mechanisms.

### 4.1 Cryptographic Primitives
We employ two fundamental cryptographic building blocks that underlie the entire verifiability layer.
#### 4.1.1 Hash-Based Commitment
A commitment scheme allows a party to publish a cryptographic digest of a value without revealing the value itself, with the guarantee that the digest cannot later be “opened” to a different value. We use a hash-based commitment with a random nonce:


## Key insights
- RQ1 (Predictive alignment). Does the unified valuation score correlate more strongly with realized model improvement than traditional entry-based or token-count based pricing rules?
- RQ2 (Component utility). Which components of the framework—information density, DQS, proxy training gain, influence approximation, and Data Shapley—contribute most to predictive performance?
- RQ3 (Ranking fidelity). Can the proposed method correctly identify the top-value data sources before full-scale training is performed?
- RQ4 (Robustness). Is the method resistant to adversarial padding, duplicated low-value content, and syntactically plausible but semantically weak data?
- RQ5 (Verifiability overhead). What computational and storage overhead is introduced by the commitment, ledger, and proof-of-training machinery?

## Exemplos e evidências
See original source at `Clippings/Utility-Aware Data Pricing Token-Level Quality and Empirical Training Gain for LLMs.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/ai-agents/benchmark]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/Codex]]
- [[03-RESOURCES/entities/AWS]]
- [[03-RESOURCES/entities/Rust]]
- [[03-RESOURCES/entities/Python]]
