---
title: "Reimagining LinkedIn’s search tech stack"
type: source
source: "Clippings/Reimagining LinkedIn’s search tech stack.md"
created: 2026-06-23
ingested: 2026-06-23
score: D
tags: [articles, source-page]
---

## Tese central
---
title: "Reimagining LinkedIn’s search tech stack"
source: "
author:
published: 2026-01-20
created: 2026-06-23
description:
tags:
  - "clippings"
---
*Co-authors: [Jiahao Xu](invalid://), [Xiaojing Ma](), [Sriram Vasudevan](), [Muchen Wu](), [Rachel Zheng](), [Benjamin Le](), [Shaobo Zhang](), [Sarang Metkar](), [Rupesh Gupta](), [Qianqi Kay Shen](), [Ali Hooshmand](), [David Nicolás Racca](), [Vivek Katarya](), [Kayhan Behdin](), [Igor Lapchuk](), [Xueying Lu](), [Lingyu(Claire) Zhang](), [G

## Argumentos principais
### Semantic search’s high level infrastructure
When a member submits a query in the search bar, a query understanding module processes the input text, creates a query embedding, and performs embedding-based retrieval (EBR) on CUDA-enabled GPUs using exhaustive vector search ([paper on GPU CUDA-based Search](), [paper on GPU PyTorch-based Search]()) to assemble a broad set of candidate documents. The ranking stage then refines these candidates through a Cross-Encoder Small Language Model (SLM) deployed on SGLang, which combines the query, job, and member features to generate relevance and engagement scores for final ranking.
To maintain scalability and efficiency, the ranking pipeline integrates several optimization techniques ([paper on efficient LLM inference infrastructure](), [context compression paper]()): score caching, a ranking-depth controller to manage how many candidates progress to deeper ranking, and traffic shaping to balance load during peak times—all designed to enhance latency and result quality. The features and concise job representations consumed by the SLM are produced through a hybrid inference pipeline: a large-scale offline workflow using Spark and Flyte, and a low-latency nearline system using Flink. These embeddings and summaries are stored in distributed storage and retrieved on demand with minimal latency.
In the final stage, the auction layer applies budget and pacing strategies to balance user relevance, engagement, and business metrics, ensuring a healthy equilibrium between recall and precision while maximizing member satisfaction. Figure 1 below provides an overview of the system architecture.

### Product policy relevance measurement
Measuring relevance quality is essential to delivering a great search experience on LinkedIn. We define product policies that specify how to rate each query–document pair on a five-point scale and use LLM judges to apply these ratings at a massive scale, far beyond what manual evaluation can achieve. These judges are tightly aligned with product managers and engineers through iterative feedback to ensure high agreement. They not only grade tens of millions of query–document pairs daily for relevance measurement but also generate labeled data for training our retrieval and ranking systems, ensuring we optimize search quality according to product policy.

### Defining product policy and golden product manager grades
A strong LLM judge begins with a clear product policy and high-quality product manager “golden” grades that demonstrate how that policy should be applied. Product managers act as a “Supreme Court,” regularly calibrating to resolve judgment differences and maintain a shared definition of what constitutes a good query–document match. These discussions refine the policy, making it clearer and less subjective. Once product managers reach high agreement (weighted Cohen’s Kappa ≥ 0.8), their labels are considered reliable ground truth.
To build a comprehensive golden dataset across diverse user queries, we first categorize queries by attributes (e.g., title–company, name–company, title–skill). Each category is then split into existing user queries and aspirational queries that represent strategic areas we want to excel in. We stratify-sample query–document pairs from each bucket to ensure broad coverage before sending them to product managers for grading.

### Training the LLM judge
Our LLM judge must meet two requirements: high agreement with product managers and the ability to grade tens of millions of query–document pairs daily. To maximize agreement, we collaborate with product managers to prompt-engineer state-of-the-art LLMs, optimizing the weighted Cohen’s Kappa Score on golden data. The prompt encodes product-policy guidelines and few-shot examples to drive consistency. While these large models produce high-quality judgments, they cannot meet our throughput needs. To scale, we distill them into a smaller 8B-parameter evaluator LLM. Through supervised fine-tuning on a diverse dataset spanning all query categories and grades, we maintain only small drops in agreement—verified via the Kappa Score on the golden set—while achieving massive efficiency gains.

### Continuously measuring quality of search system
Once we have our scalable LLM judge, we can finally build continuous relevance measurement of our system. On a regular basis, we build workflows that perform the following steps:
1. Stratify sample or synthesize a diverse set of queries based on the query categories defined earlier
2. Retrieve the documents returned from executing those queries

### Search quality modeling
Search quality is a fundamental requirement for any search product, and achieving it depends on building the core components of a modern search engine. Below, we describe how we leveraged LLMs to enable query understanding, semantic embedding–based retrieval, and cross-encoder ranking.

### Embedding-based retrieval
Retrieval is the stage of a search system that identifies a broad set of potentially relevant results from a large corpus. Because no search engine can score every document for every query in real time, we need an efficient retrieval layer to narrow the search space before ranking. Our retrieval sits on top of our GPU-enabled embedding-based retrieval (EBR) system. We built the EBR model by fine-tuning an open-source LLM embedding model to encode queries and jobs into dense vectors. We train on millions of real query–job pairs sampled from production logs, with relevance labels provided by an LLM-based judge. Each query includes its natural language text and query-understanding tags (e.g. workplace type or company), and each job is represented by structured metadata (title, company) plus its description. Importantly, this work also demonstrates a practical path for deploying LLM-based components in real production search systems. The semantic search can directly understand human language as queries, enabling much more intuitive search experiences. This has been a particularly inspiring aspect of the project: bringing modern LLM capabilities into a high-scale, real-time application that serves millions of users.
#### EBR relevance modeling
To ensure consistency between training and serving, every query is formatted using a lightweight prompt template:

### Query understanding
At the moment a member enters a query into the search bar—the entry point of semantic search—we apply a unified LLM-based understanding layer that interprets intent and converts free text into structured signals. For both AI Job Search and AI-powered People Search, this layer uses fine-tuned 1.5–4B parameter models that meet LinkedIn’s latency requirements while delivering high-precision structured outputs ([paper]()). A single model handles intent classification, facet extraction, and profile-aware rewriting, replacing multiple brittle NER and heuristic components. The resulting attributes (e.g., title, company, school, location) feed directly into retrieval and ranking.
An intelligent routing layer works alongside this. A lightweight encoder classifies query types at high QPS and performs policy-based safety checks before sending the query down the appropriate path—LLM-powered semantic interpretation for ambiguous inputs or efficient keyword retrieval for precise name and entity lookups.
Together, these components provide a consistent, centrally governed semantic interface for People and Job Search, boosting relevance, simplifying the system, and enabling Semantic Search to scale across LinkedIn’s global traffic.

### Small language model ranking
The ranking module of semantic search utilizes a Small Language Model (SLM) to estimate how relevant a user’s search query q is to each retrieved job\_i. The SLM follows a decoder-only architecture. For example, for job search we represent the structured attributes of a job — including its title, company, location, employment type, and remote-work status. Meanwhile people search uses information from the member’s profile including their name, company information, position information, educational information and location. For each query–job pair (q,i), we build a structured prompt defined as
Here, the *system prefix* and *suffix* contain chat-template tags and explicit instructions guiding the model to determine whether the given job matches the query. When this prompt is passed through the decoder, it produces logits corresponding to the next token. Let *logit* <sub><em>yes</em></sub> and *logit* <sub><em>no</em></sub> represent the logits for the tokens “yes” and “no,” respectively. Following prior studies, we compute:
which yields probabilities used to rank job items by their relevance to the user’s query.

### SLM training pipeline for relevance quality
Training of the SLM follows a multi-stage process. First, we distill the 7B-parameter teacher model into a compact 0.6B model that can generate graded relevance labels along with rationales. Next, the teacher’s ordinal grades are converted into “soft labels” (*p* <sub><em>yes</em></sub>*,p* <sub><em>no</em></sub>), representing probabilistic supervision.
We then perform supervised fine-tuning (SFT) to minimize the Kullback–Leibler (KL) divergence between the teacher’s soft targets and the SLM’s predicted probabilities—effectively converting the reasoning-oriented model into a binary relevance classifier:
We construct training labels by sampling real query–item pairs from user interaction logs and annotating them using a full-scale Large Language Model (LLM). Each pair is evaluated through a structured prompt of the following format:

### Training for multiple objectives
We extend the training paradigm to predict both relevance and engagement within the model, we train a smaller cross-encoder language model (the SLM) using multi-teacher, multi-task distillation. The teachers include:
- The product policy LLM for relevance scoring.
- Other large models that predict member actions—such as job views, applies, recruiter accepts, or (in people search) view profile, connecting, messaging, or following.

### Explainability in search
To make LinkedIn’s AI-powered People Search more transparent, we introduced semantic, context-aware snippets that show *why* a result matches a member’s query. Snippets highlight the most relevant terms and maintain low latency through lazy loading, caching. The approach uses semantic similarity between the query embedding and precomputed phrase embeddings (unigrams/bigrams) from profile text, surfacing the highest-scoring phrases as natural, human-readable snippets. In the offline pipeline, we extract phrases from each profile section (e.g., summary, experience, education), encode them into embeddings in a [Venice key-value store](). This index is refreshed periodically to capture profile updates, with evaluation workflows ensuring quality and readability. At search time, the snippetting midtier receives the query embedding and candidate profiles, fetches stored phrase embeddings, computes cosine similarity, selects top phrases, and expands them into readable snippets using simple heuristics. The final output is a ranked list of profiles paired with snippets and highlighting metadata.

### Reasoning
To improve transparency in search results, we introduced a lightweight reasoning module that explains how LinkedIn interprets a member’s query. When a query is submitted, the LLM-based understanding model extracts facets, classifies intent, and—using predefined guidelines—produces a concise “thinking state” describing how the query is parsed, along with a brief summary of the types of profiles retrieved. For unsupported or negatively intended queries, the module instead provides a clear explanation of why results may be limited. For example, “berkeley community development specialist msa professional services” becomes “Searching for community development specialist at MSA Professional Services affiliated with Berkeley.” To keep latency low, reasoning outputs are cached in Couchbase and reused for repeated or semantically similar queries.

### SLM ranking model inference efficiency
We employed multiple techniques to improve efficiency of the inference system at LinkedIn including:
- Model pruning, where we remove Fully Connected Layers and remove whole transformer layers.
- Context pruning, by summarization or embedding compression ([paper on AI modeling techniques for efficiency of SLM inference]()).

### Model pruning
To boost inference throughput, we apply model compression via structured pruning—a technique that removes redundant components to reduce model size and computation with minimal quality loss. Because our models run on GPU infrastructure, we focus on structured pruning, which removes entire neurons, attention heads, or transformer layers so the resulting model can run efficiently on standard GPU kernels. This yields real throughput and latency gains, unlike unstructured pruning, which drops individual weights but often provides no meaningful speedup without specialized hardware.
We prune hidden neurons in Multi-layer Perceptron (MLP) blocks and attention heads in self-attention modules, and we remove full transformer layers to study trade-offs between size, efficiency, and performance ([paper]()). Pruning MLP neurons shrinks intermediate activations, while pruning layers reduces network depth—both producing lighter, faster models. After pruning, we fine-tune the model to recover any accuracy loss, ensuring efficiency improvements do not compromise quality.


## Key insights
- Continuously monitoring the relevance of the overall system
- Evaluating experiments involving underlying ranking and retrieval subsystems
- Distilling student ranking and retrieval models by leveraging evaluation results
- The product policy LLM for relevance scoring.
- Other large models that predict member actions—such as job views, applies, recruiter accepts, or (in people search) view profile, connecting, messaging, or following.
- Model pruning, where we remove Fully Connected Layers and remove whole transformer layers.
- Context pruning, by summarization or embedding compression ([paper on AI modeling techniques for efficiency of SLM inference]()).
- a semantic consistency term, measured via KL divergence between the SLM’s output distributions on summarized vs. raw text, and
- a length penalty that discourages overly long summaries.

## Exemplos e evidências
See original source at `Clippings/Reimagining LinkedIn’s search tech stack.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/ai-agents/prompt]]
- [[03-RESOURCES/concepts/software-engineering/runtime]]
- [[03-RESOURCES/entities/LinkedIn]]
- [[03-RESOURCES/entities/CUDA]]
