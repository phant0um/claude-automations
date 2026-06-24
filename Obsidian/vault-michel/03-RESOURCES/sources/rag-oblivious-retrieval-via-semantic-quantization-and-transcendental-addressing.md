---
title: "𝜋-RAG: Oblivious Retrieval via Semantic Quantization and Transcendental Addressing for Large Language Models"
type: source
source: "Clippings/𝜋-RAG Oblivious Retrieval via Semantic Quantization and Transcendental Addressing for Large Language Models.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [articles, source-page]
---

## Tese central
This paper introduces $\pi$ -RAG, a novel architecture for oblivious retrieval that decouples Large Language Models (LLMs) from sensitive data storage without sacrificing semantic understanding. Traditional Retrieval-Augmented Generation (RAG) architectures expose raw vector embeddings to potential inversion attacks and nondeterministic retrieval failures. To address this, we utilize the digits of $\pi$ as a source of transcendental entropy, creating an immutable indirection layer between the LL

## Argumentos principais
### π\\pi-RAG: Oblivious Retrieval via Semantic Quantization and Transcendental Addressing for Large Language Models
Aniket Wattamwar
aniket.wattamwar17@gmail.com
&Mrunal Kakirwar

### 1 Introduction
With the advancement of Large Language Models (LLMs), enterprises have increasingly integrated these systems with proprietary data to maximize utility. However, as the volume of private data grows, LLMs often fail to retrieve accurate information solely from their training weights. Retrieval-Augmented Generation (RAG) was introduced (Lewis et al. (2020)) to mitigate this by fetching relevant, up-to-date information to ground the LLM’s responses, thereby reducing hallucinations and saving compute time compared to fine-tuning. While efficient, traditional RAG architectures introduce significant risk. The architecture typically allows the LLM to communicate directly with the data store. In sectors handling highly sensitive information such as healthcare (HIPAA) or finance (GDPR) this creates a vulnerability where a compromised LLM or vector database can expose PII, transaction histories, or passwords. In industries like Banking or healthcare, achieving true RAG doesn’t guarantee the same output always, since the data changes with time, the LLM used is updated with new data. We need to constantly check the authenticity of the response. To address this bottleneck, this paper introduces $\pi$ -RAG, a retrieval method that establishes an indirection layer between the LLM and sensitive data. By mapping user query embeddings to canonical pre-defined intents and converting them into offsets within the transcendental number sequence of $\pi$, we create a $\pi$ -key. This key acts as an abstract index, ensuring the retrieval process is deterministic, auditable, and verifiable. $\pi$ acts as the universal public ledger, its transcendental defined by mathematics and there is no control over it. We accept it as it is. Its next to impossible to edit the digits of $\pi$. This approach creates a trustful and auditable environment. The standard RAG process with embeddings in the vector database, in any case embeddings could be manipulated, hacked, and redirect queries maliciously (Song and Raghunathan, 2020; Carlini et al., 2021). This approach curbs this risk and makes it extremely difficult to rig the system. The architecture can be useful in highly sensitive domains.
Section 2 discusses work done in privacy and LLMs and various techniques adopted. Section 3 follows the proposed architecture, and working of $\pi$ -RAG. Section 4 is the Threat Model discussed continued by the Experimental Results in Section 5. Discussions in Section 7 answers the questions that would help understand the approach better.

### 2 Related Work
Recent research has focused heavily on mitigating risks in language models. In recent years, Kandpal et al. have proposed several techniques have come up to mitigate this risk for language models attack. talks about how the deduplication method of training data has considerably reduced the risk of an attack. Carlini et al. describes the way an attack is possible by generating a large sequence of text out of which some might be part of the training data. Dingfan Yu et al. show the differential privacy fine tuning techniques where the data is trained and noise is added to secure the training from potential leaks of sensitive information. The privacy budget controls the noise in a calculated manner. Based on the experimental results LORA outperformed with an accuracy of 90.3% with 0.94% trainable parameters using epsilon on 6.7. Scaling LLM applications and also preserving privacy is a challenge. Yaman Jandali et al. show work in optimizing the privacy-preserving primitives using Multi-Party Computation (MPC), Zero-Knowledge Proofs(ZKPs) and fully homomorphic encryption(FHE) with hybrid protocols.
Congzheng Song et al. talk about information leakage in the embedding models itself. There are techniques like whitebox and blackbox inversion where the sequences are generated and predicted later to come up with probabilities that would be highest indicating its strong presence in the input data. There is an adversarial training approach to prevent the sensitive attributes being trained in the embedding models. Experimental results conducted on LSTM, Transformer, BERT and ALBERT with ALBERT showing the F1 score of 74.33. Security Frameworks involving sensitive data anonymisation, real-time privacy policy enforcement developed by Yu Wang et al. protects data while maintaining integrity. Introduced LLM Access Shield for domain specific interactions with LLMs.
Fangzhou Wu et al. show ways to bypass few GPT4 security protocols by asking it questions in a strategic way. A secrets file in the sandbox environment is available to another session as well indicating sensitive information can be leaked. Web tools used by OpenAI GPT4 to search the web and analyze it for information bypasses confirmation to tools like Doc maker and malicious instructions can be passed as successfully shown in the results. GPT4 restricts rendering external image markdown links if asked directly, but by framing the questions in a different way shown in the study GPT4 was able to render the image successfully showing its vulnerability to attacks via links.

### 3 Proposed Architecture and Methodology
The $\pi$ -RAG architecture operates in two distinct phases, designed to ensure zero-knowledge retrieval. Table 1 shows the mapping of few real examples of user query variations to canonical intents and IDs
Figure 1: The π \\pi -RAG Split-Brain Architecture. The system is architecturally divided into two isolated zones. Zone A (Untrusted) handles semantic reasoning and intent classification using the LLM, but possesses zero access to the data. Zone B (Trusted) handles data retrieval and execution but possesses no semantic intelligence. The only communication between zones is the transmission of an opaque, immutable -Key.

### 3.1 Phase 1: Zero-Knowledge Intent Registration
Unlike traditional RAG, $\pi$ -RAG does not index the underlying sensitive data (e.g., user balances or medical history), thereby eliminating the risk of data leakage through embedding inversion (Song and Raghunathan, 2020). Instead, we perform a one-time Capability Registration.
- Definition: We define Canonical Intents (e.g., BK-01 for checking a balance).
- Key Generation: We generate corresponding salted $\pi$ -Keys for these intents.

### 3.2 Phase 2: Querying and Retrieval
The querying process utilizes a Semantic Quantization Layer via an LLM Semantic Router.
1. Classification: The user’s "fuzzy" natural language query is classified into a fixed Canonical Intent ID (e.g., BK-01).
2. Offset Calculation: To prevent replication attacks, the system combines the ID with a Server-Side Secret Salt.

### 4.1 Traditional RAG under Attack
In standard architectures, the application server holds both the retrieval logic (Vector Database).
- Attack Vector: A compromised server intercepts the query "What is the current balance for account 1234-5678?" (Wang et al., 2025a; Wu et al., 2024).
- Escalation: The server queries the Vector DB, retrieves chunk-id-balance-1234, and uses stored credentials to query the Secure Customer Vault.

### 4.2 π\\pi-RAG Under Attack
The revised architecture uses an LLM Semantic Router.
- Attack Vector: A compromised server intercepts the same query.
- Mitigation 1 (Replication Failure): The attacker sees the intent BK-01 but cannot generate the valid retrieval key because they lack the Server-Side Secret Salt.

### 5 Experimental Results
For this architecture, we have tried and tested 6 different canonical intents from multiple user queries getting mapped to the ID. For this purpose, two models are used to test and categorize the fuzzy input from user queries to the canonical intents. Figure 2 and Figure 3 shows the categorization. It can be observed that even with a low pricing and weak model it can give great results in categorizing. In a real scenario, the intents to ID mapping can be in a database and a strong model will give better results.
The approach has been tested with 33 queries with 2 models Gemma3:1b (Figure 1) and Gemma 3n:e4b (Figure 2) (Team et al., 2024). It can be observed that changing the model can easily increase the accuracy. In a real scenario, strong models can be used and the accuracy would be really high. The misclassified 5 and 6 queries in both scenarios is because of lower reasoning capabilities of the Gemma Models where intent overlapped between categories. A larger and high reasoning model was able to correctly identify the intent and map it to the correct intent ID. This suggests that while the semantic quantization layer is effective, a model with sufficient reasoning depth is required to categorize.
Figure 2: using Gemma 3:1b

### 6 Conclusion
In this work, the experiment and demonstration of $\pi$ -RAG shifts the paradigm from the probabilistic vector similarity to deterministic intent. For high compliance domains, dependency on private vector embeddings for RAG is architecturally insecure. The experiment shows the semantic quantization layer added with the $\pi$ -key creates a firewall against the threat of training data extraction and inference attacks. This architecture eliminates the process of embedding all the private data for using traditional RAG, since the index doesn’t contain any semantic information itself. The digits of $\pi$ ensures that the addressing schema is audit proof and tamper resistant. This architecture in regulated industries like government, finance or healthcare is beneficial to not leak customer information like SSN and more. $\pi$ -RAG serves as robust blueprint for secure deployment in zero-trust environment.

### 7.1 Why π\\pi?
One of the critical questions to clarify would be why do we need to use $\pi$, why can’t we just use a random number generator itself. The reason is $\pi$ is public reference ledger, it cannot be changed. The problem with Random number generator is it can be tampered with internally if wanted to and $\pi$ is a universal constant. It would provide Auditability and anyone can verify that Index X will always contain Digits Y and there is no manipulation.

### 7.2 What if the attacker guesses the π\\pi-key?
Lets go through a scenario, where an attacker can guess a number from $\pi$ and with all permutations and combinations is also able to figure out that this $\pi$ number indexes to a function within the systems that checks balances like BK-01. The attacker is guessing but still it won’t be able to access the system without the secret salt. The $\pi$ -key is an intent pointer not a authorization token.

### 7.3 Needle in the Haystack
Consider a scenario where authorization is ignored, but still guessing a valid key is still very low. This is because of the search space considering the length is 8 there are 100,000,000 possible combinations. But the capability registration performed in phase 1, the canonical intents are mapped to few functions and would not reach a higher number, lets say 500. With this possibility, the probability is 500/100,000,000 which is 0.000005%. An attacker won’t be able to continue keep guessing the $\pi$ -key and trying to break in the system, since after few wrong attempts it will block the request.

### 7.4 Latency tradeoff
The Semantic Quantization adds an additional overhead of categorizing the intent to ID. The inference time for a single query was under 1 sec with Gemma models. Adding the semantic quantization layer might add latency in the response, but the underlying fact that the LLM has no knowledge of the private data makes it worthwhile. Although we cannot ignore the fact that to perform traditional RAG across lots of data, the latency could match that of $\pi$ -RAG.

### 8 Limitations
While $\pi$ -RAG offers decoupling of the Trusted and Untrusted layers for privacy, we acknowledge few limitations. First, Latency Overhead of the Semantic Quantization layer is higher than the traditional vector search. For applications where priority for response in within sub-milliseconds might impact real-time responses in latency. Second, collision risk of the $\pi$ -keys is negligible with large and complex SALTs, theoretically remains non-zero in the address space of $\pi$ defined. The current prototype and approach works on Canonical Intents which are fixed, but scaling the systems to new domains require re-registering the new intents to new offsets, which is less flexible. Finally, the experiment is conducted on synthetic banking data, and large-scale deployment in production require further stress-testing on attacks.


## Key insights
- Definition: We define Canonical Intents (e.g., BK-01 for checking a balance).
- Key Generation: We generate corresponding salted $\pi$ -Keys for these intents.
- Mapping: These keys are mapped to specific templates(like SQL) or data retrieval functions in a secure vault.
- Attack Vector: A compromised server intercepts the query "What is the current balance for account 1234-5678?" (Wang et al., 2025a; Wu et al., 2024).
- Escalation: The server queries the Vector DB, retrieves chunk-id-balance-1234, and uses stored credentials to query the Secure Customer Vault.
- Data Exposure: The Vault returns the full JSON record (Name, Address, SSN, Balance).
- Result: The attacker intercepts the full memory object before filtering, leading to a catastrophic breach of PII.
- Attack Vector: A compromised server intercepts the same query.
- Mitigation 1 (Replication Failure): The attacker sees the intent BK-01 but cannot generate the valid retrieval key because they lack the Server-Side Secret Salt.
- Mitigation 2 (Isolation): The server can only send an opaque pointer to the Authorized Retrieval Subsystem.

## Exemplos e evidências
See original source at `Clippings/𝜋-RAG Oblivious Retrieval via Semantic Quantization and Transcendental Addressing for Large Language Models.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/proof]]
- [[03-RESOURCES/entities/OpenAI]]
- [[03-RESOURCES/entities/Netflix]]
- [[03-RESOURCES/entities/Rust]]

## Minha Síntese
**O que muda:** π-RAG separa zona untrusted (LLM + semantic router) de zona trusted (data vault) via π-keys — eliminando embedding inversion attacks ao não indexar dados sensíveis, apenas canonical intents.

**Conexão pessoal:** Para o vault que pode conter dados financeiros sensíveis, o padrão split-brain com indirection layer é relevante — nunca expor embeddings de dados privados ao LLM.

**Próximo passo:** Avaliar se dados financeiros no vault precisam de camada de indirection antes de alimentar qualquer RAG pipeline.
