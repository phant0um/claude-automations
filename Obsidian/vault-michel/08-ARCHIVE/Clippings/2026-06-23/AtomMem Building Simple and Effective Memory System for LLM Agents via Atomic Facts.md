---
title: "AtomMem: Building Simple and Effective Memory System for LLM Agents via Atomic Facts"
source: "https://arxiv.org/html/2606.19847v1"
author:
published:
created: 2026-06-22
description:
tags:
  - "clippings"
---
Yanyu Yao <sup>1</sup>, Shangze Li <sup>1</sup>, Zhi Zheng <sup>1</sup>, Hui Zheng <sup>2</sup>, Qi Liu <sup>1</sup>, Tong Xu <sup>1</sup>, Enhong Chen <sup>1</sup>  
<sup>1</sup> State Key Laboratory of Cognitive Intelligence,  
University of Science and Technology of China, Hefei, China  
<sup>2</sup> Anhui University, Hefei, China  
[{yyyao, lishangze, liuqilq}@mail.ustc.edu.cn](https://arxiv.org/html/2606.19847v1/mailto:yyyao@mail.ustc.edu.cn,lishangze@mail.ustc.edu.cn,%20liuqilq@mail.ustc.edu.cn), [{zhengzhi97, tongxu, cheneh}@ustc.edu.cn](https://arxiv.org/html/2606.19847v1/mailto:zhengzhi97@ustc.edu.cn,tongxu@ustc.edu.cn,%20cheneh@ustc.edu.cn), [huizheng@ahu.edu.cn](https://arxiv.org/html/2606.19847v1/mailto:huizheng@ahu.edu.cn)

###### Abstract

Large language models (LLMs) demonstrate strong reasoning and generation abilities, but their fixed context windows limit long-term information accumulation and reuse across multi-session interactions. Existing memory-augmented systems often construct memory in a coarse and unstable manner, relying on inefficient memory representations or unstable unconstrained updates. To address these challenges, we propose AtomMem, a long-term memory system designed for value-dense storage and stable memory evolution. AtomMem introduces a Fact Executor, which selectively extracts high value atomic facts from long form interactions to serve as highly efficient memory representations. Subsequently, AtomMem organizes these facts into hierarchical event structures and temporal profiles, capturing coherent episodic contexts and tracking dynamically evolving user attributes over time. During retrieval, the system activates an associative memory graph to connect fragmented memories. Experiments on the LoCoMo benchmark confirm that AtomMem achieves state-of-the-art performance across various reasoning tasks, offering a scalable and economically viable solution for deploying intelligent personalized agents. The implementation code is publicly available at [https://github.com/MINE-USTC/AtomMem](https://github.com/MINE-USTC/AtomMem).

AtomMem: Building Simple and Effective Memory System  
for LLM Agents via Atomic Facts

Yanyu Yao <sup>1</sup>, Shangze Li <sup>1</sup>, Zhi Zheng <sup>1</sup>, Hui Zheng <sup>2</sup>, Qi Liu <sup>1</sup>, Tong Xu <sup>1</sup>, Enhong Chen <sup>1</sup> <sup>1</sup> State Key Laboratory of Cognitive Intelligence, University of Science and Technology of China, Hefei, China <sup>2</sup> Anhui University, Hefei, China [{yyyao, lishangze, liuqilq}@mail.ustc.edu.cn](https://arxiv.org/html/2606.19847v1/mailto:yyyao@mail.ustc.edu.cn,lishangze@mail.ustc.edu.cn,%20liuqilq@mail.ustc.edu.cn), [{zhengzhi97, tongxu, cheneh}@ustc.edu.cn](https://arxiv.org/html/2606.19847v1/mailto:zhengzhi97@ustc.edu.cn,tongxu@ustc.edu.cn,%20cheneh@ustc.edu.cn), [huizheng@ahu.edu.cn](https://arxiv.org/html/2606.19847v1/mailto:huizheng@ahu.edu.cn),

## 1 Introduction

Large language models (LLMs) have demonstrated remarkable capabilities in language understanding, reasoning, and generation [^16] [^2] [^20]. Recent advances have extended these models into interactive agents capable of engaging in multi turn conversations spanning days or even months, requiring these agents to accumulate and organize useful memories. However, as these LLM-based systems are deployed in increasingly complex and long-horizon tasks, they face significant challenges regarding degrading reliability [^11] [^23]. Constrained by fixed-length context windows, existing models often struggle to maintain coherence and accurate retrieval over extended contexts. This often results in practical failures such as forgetting user preferences, repeating previously resolved questions, or contradicting established facts.

To address this limitation, an increasing body of work has explored augmenting LLMs with external memory modules. These memory-augmented agents aim to improve long-term performance by optimizing memory management and utilization, primarily through the design of effective mechanisms for memory storage, update, and retrieval. Advanced systems like Mem0 [^3] incorporate graph databases to enhance relational organization, and AMem [^24] enables dynamic memory evolution without predefined rules.

![Refer to caption](https://arxiv.org/html/2606.19847v1/figure/intro.png)

Figure 1: Architecture comparison. AtomMem overcomes the bloated storage and isolated matching of previous methods by organizing atomic facts into associative graphs for precise hierarchical retrieval.

Despite these advances, existing memory-augmented systems still face fundamental challenges in constructing reliable long-term memory due to a fundamental dilemma. Storing raw conversations maximizes information retention but overwhelms retrieval augmented generation paradigms [^9] with redundant noise. This bloat forces models to process irrelevant contexts. Conversely, condensed representations achieve compact formats but inevitably discard fine-grained details and accumulate noise generated by LLMs over time. Therefore, achieving a balance between high information density and contextual fidelity is crucial. A precise and reliable underlying memory representation is the fundamental prerequisite for any effective memory system.

Beyond basic representation, user memory is inherently dynamic. Preferences, experiences, and goals naturally evolve over time, requiring systems to effectively accumulate and maintain a consistent user state. Recent work has explored dynamic memory evolution, but these methods typically rely on frequent LLM-driven rewrites to update existing entries. While this design enables flexible knowledge organization and continuous adaptation, unconstrained updates introduce severe instability. Hallucinations or erroneous edits can repeatedly modify the same memory entry, leading to uncontrolled expansion and the destruction of original facts. Therefore, designing stable and controllable memory update mechanisms remains another key challenge for long-term memory systems. Furthermore, useful memories are often distributed across multiple sessions. Current memory systems often rely on flat retrieval over isolated items. This flat approach struggles to capture complex associations across sessions, failing to recover associative evidence required for personalized assistance.

In this paper, we propose AtomMem, a long-term memory system centered on atomic facts that organizes user interactions into a hierarchical memory structure and activates relevant memories through graph-based associative recall. At its core, an SFT-tuned Fact Executor extract self-contained atomic facts from raw conversations by selecting high value information and performing lightweight reasoning such as coreference resolution and temporal anchoring. Serving as the basic semantic units of memory, these atomic facts allow AtomMem to construct event memory by associating new information with existing events or creating new ones via semantic and temporal reasoning, thereby transforming isolated facts into episodic memory. To maintain long-term user states, AtomMem builds temporal profile memory from accumulated factual evidence to incrementally track stable attributes and adapt to preference shifts while preserving historical information. During retrieval, AtomMem activates a memory graph, which connects facts through entity overlap, shared events, and dialogue continuity, facilitating the recall of associated memories. Together, these coordinated components enable rich yet stable memory representations, allowing LLM agents to maintain a consistent and reliable understanding of users over long-term interactions.

Our main contributions are summarized as follows:

- We propose AtomMem, a long-term memory framework centered on atomic facts that generates memory-aware responses through graph-based associative recall. This framework provides a stable and scalable long-term storage solution for LLM agents.
- We introduce an atomic fact extraction module that converts noisy raw dialogues into self-contained storage units with structured metadata. This module provides a compact and faithful base representation for long-term memory. Additionally, we release a high-quality dataset to facilitate the fine-tuning of robust conversational fact extraction.
- Comprehensive evaluations on long-term benchmarks demonstrate that AtomMem consistently outperforms state-of-the-art baselines. Notably, our simplified fact-level variant achieves competitive performance at minimal computational cost, while the full modular design yields further significant gains.

## 2 Realted Work

### 2.1 Retrieval-Augmented Generation

Retrieval-Augmented Generation (RAG) augments language models with external non-parametric knowledge, enabling generated outputs to be grounded in retrieved evidence rather than relying solely on parametric knowledge [^9]. Early frameworks like REALM [^6] proved that explicit retrieval can improve open-domain question answering while offering benefits in interpretability. Subsequent work has refined the RAG pipeline beyond simple retrieve-and-read designs. Advanced systems evolved to optimize retrieval quality through query processing and neural reranking [^15] [^5]. Adaptive variants like ActiveRAG and Self-RAG [^7] [^1] further introduced dynamic retrieval timing and output critiquing. In LLM agents, retrieval-based access has become an important mechanism for exposing external knowledge and long-term memory to the agent [^18] [^22].

### 2.2 Memory for LLM Agents

The architectural design of memory-augmented LLM agents is fundamentally defined by their primary memory abstraction. Some systems represent memory as textual experiences or higher-level reflections. For example, Think-in-Memory [^10] stores evolving historical thoughts, and RMM [^19] dynamically summarizes dialogue history across granularities. A second category focuses on symbolic or relational memory. This approach anchors information on structured objects, such as triplets in RET-LLM [^14], and knowledge graphs in Mem0 [^3]. Furthermore, frameworks like MemGPT [^17] and MemoryOS [^8] manage memory through explicit hierarchical interfaces. Recent studies such as A-Mem [^24] and MEM1 [^26] also explore self-organizing or learned memory strategies. For comprehensive evaluation, datasets like LoCoMo [^13] and LongMemEval [^21] assess ultra-long conversational memory, while personalization-oriented benchmarks such as PERMA [^12] specifically test dynamic user profiling and preference evolution.

## 3 Methods

![Refer to caption](https://arxiv.org/html/2606.19847v1/figure/main-method.png)

Figure 2: The overall architecture of AtomMem. It is designed to support high-density memory storage, stable user-state evolution, and efficient retrieval for long-term personalized agents.

AtomMem is designed to transform unstructured dialogue streams into a structured and retrieval-friendly memory representations. It first extracts self-contained atomic facts and consolidates related facts into contextual event memory while dynamically modeling user states with temporal profiles. During retrieval, AtomMem activates related memories through a memory graph and integrates the activated memories to generate the final response.

### 3.1 Base Representation: Atomic Fact Extraction

As interactions lengthen, useful information is sparsely distributed across noisy dialogue turns. Moreover, these raw dialogues frequently rely on implicit context such as unresolved pronouns (e.g., "he", "it") and relative temporal references (e.g., "last Friday"), which become ambiguous when retrieved in isolation. Therefore, our goal is to transform raw dialogue sessions into a set of structured, self-contained atomic facts $F$, thereby providing a superior memory representation.

#### 3.1.1 Atomic Fact Extractor

To address redundancy and noise, we introduce an Atomic Fact Extractor trained via supervised fine-tuning (SFT) that performs essential denoising and lightweight reasoning such as coreference resolution. Since generating high-quality atomic facts requires complex reasoning, relying solely on heuristic rules or zero-shot prompting often yields suboptimal results. To overcome this, we construct a high-quality dataset $\mathcal{D}$ (see Appendix A.1 for data Construction details) through a two-stage data construction pipeline.

We train a lightweight LLM using the constructed dataset. Formally, given the instruction $I$ and the dialogue context $C$, we optimize the model parameters $\theta$ to maximize the likelihood of the target atomic facts $F$:

$$
\max_{\theta}\sum_{(I,C,F)\in\mathcal{D}}\log P_{\theta}(F\mid I,C)
$$

By fine-tuning on this specialized distribution, the model acts as an efficient information filter. It compresses raw interactions into a dense representation before they enter the memory system, while ensuring that each generated fact is independent and comprehensible without external context.

#### 3.1.2 Structured Fact Construction

While the Atomic Fact Extractor provides clean textual content, efficient retrieval and memory management require structured metadata. We therefore encapsulate the extracted text into a Structured Atomic Fact, serving as the minimum semantic unit of the memory system. Formally, we define an atomic fact $F$ as:

$$
F=\{id,c,\mathbf{v},\mathcal{P},\mathcal{K},\mathcal{T},\mathcal{E}\}
$$

where $id$ is the fact identifier, $c$ is the self-contained text generated by the extractor, and $\mathbf{v}$ denotes its dense semantic embedding. To obtain precise symbolic metadata, we leverage the LLM to parse the conversation and extract the following key attributes. Specifically, $\mathcal{P}$ denotes the participants involved in the interaction, $\mathcal{K}$ represents the topical keywords, and $\mathcal{T}$ captures the temporal information that anchors each fact to a specific timestamp or interval. Additionally, $\mathcal{E}$ is a list of associated Event $id$ s, which is initialized as empty and links the fact to higher-level event blocks.

#### 3.1.3 Fact Verification

Before fact storage, AtomMem verifies whether the newly generated fact $F_{new}$ duplicates or conflicts with existing records. To narrow the search space and ensure contextual relevance, we first construct a candidate set by filtering the global memory based on shared metadata such as participants and temporal contexts. This symbolic filtering effectively eliminates irrelevant facts before expensive vector computations. To retrieve the top- $k$ items from this candidate set, we define a universal hybrid similarity metric combining semantic embedding and keyword Jaccard similarities for any two inputs $x$ and $y$:

$$
S_{h}(x,y)=\alpha\ \cdot\operatorname{sim}_{e}(\mathbf{v}_{x},\mathbf{v}_{y})+\beta\ \cdot\operatorname{Jac}(\mathcal{K}_{x},\mathcal{K}_{y})
$$

where $\mathbf{v}$ and $\mathcal{K}$ denote vector embeddings and keyword sets while $\alpha$ and $\beta$ balance semantic density and keyword overlap. AtomMem then ranks the candidates using $S_{h}(F_{new},F_{i})$ (Eq. 2) and selects the top $k$ facts $\mathcal{C}_{ret}=\{F_{1},...,F_{k}\}$ with the highest scores as the relevant context.

Based on the retrieved candidates, the LLM analyzes the relationship between the new input $c_{new}$ and the retrieved context $\mathcal{C}_{ret}$ to generate precise content for storage or update. We formalize the verification as a function mapping the new input and context to a residual content and a set of updates:

$$
(c^{\prime}_{new},\mathcal{U})\leftarrow\text{LLM}(c_{new}\parallel\mathcal{C}_{ret})
$$

where $c^{\prime}_{new}$ represents the residual novel information not entailed by the existing context. The system stores this non-redundant content as a new atomic fact. Additionally, $\mathcal{U}$ denotes a set of update tuples for existing facts, generated only when logical conflicts are detected. This joint mechanism effectively prevents memory redundancy and dynamically maintains global consistency.

### 3.2 Episodic Consolidation: Event Memory Construction

While atomic facts provide precise details, they lack the contextual continuity of broader experiences. Therefore, we structure memory into Events, which aggregate related facts into coherent narrative blocks. Formally, an Event $E$ is defined as:

$$
E=\{id,\mathcal{S},\mathcal{F}_{ids},\mathcal{P}_{e},\mathcal{K}_{e},\mathcal{T}_{e}\}
$$

where $\mathcal{S}$ is the concise summary, $\mathcal{F}_{ids}$ is the set of constituent Fact $id$ s, and $\mathcal{P}_{e}$, $\mathcal{K}_{e}$, and $\mathcal{T}_{e}$ describe the participants, keywords, and temporal span of the event. To maintain this structure, AtomMem dynamically absorbs new logically aligned facts into existing events or triggers the creation of new ones. The complete event construction and update algorithm is detailed in Appendix A.2.

### 3.3 State Evolution: Temporal Profile Modeling

Beyond episodic events, understanding users requires modeling stable long-term attributes such as preferences, habits, and background information. Therefore, we introduce a profile layer to capture these persistent yet dynamic user states. Formally, a profile entry $P$ is structured as follows:

$$
P=\{id,u,c,v_{p},\mathcal{K}_{p},\mathcal{E}_{evi},t_{from},\mathcal{H}\}
$$

where $u$ denotes the user, $c$ describes the stable attribute of user, $v_{p}$ represents the vector embedding of the content, $\mathcal{K}_{p}$ is the keyword set, $t_{from}$ is the effective timestamp, $\mathcal{H}$ stores historical versions, and $\mathcal{E}_{evi}$ tracks supporting fact $id$ s for traceability.

Unlike the real-time updates for facts and events, profile construction employs a session-based batch mechanism. During atomic fact extraction, the LLM identifies facts implying potential long-term characteristics and temporarily adds them to a waiting queue. At the end of a dialogue session, the system processes these queued candidate facts in a batch to generate structured profiles.

For each queued candidate, AtomMem retrieves the top- $k_{p}$ most relevant existing profiles for the same user $u$ using $S_{h}(P_{new},P_{i})$ (Eq. 2). An LLM-driven updater then decides whether to mark the candidate as redundant, update the current profile, modify a historical version, or create an entirely new entry. When the current profile changes, AtomMem copies the previous state into the history $\mathcal{H}$ and records its valid time interval or updates the corresponding historical version. This mechanism allows the system to accumulate stable preferences while preserving past user states.

### 3.4 Associative Recall: Memory Graph Activation

Long-term memory often relies on associative recall. These useful memories naturally connect through past events, shared topics, or adjacent dialogue contexts. Therefore, AtomMem activates a memory graph over the atomic facts. This graph uses atomic facts as nodes and encodes three distinct types of associations as edges.

##### Entity Edge

Two facts connect if they share keywords. To mitigate the noisy connections introduced by frequent keywords, AtomMem calculates a local edge weight between two facts $F_{i}$ and $F_{j}$ using an IDF-weighted overlap:

$$
w_{\mathrm{kw}}(F_{i},F_{j})=\frac{\sum_{k\in\mathcal{K}_{i}\cap\mathcal{K}_{j}}\omega(k)}{\sqrt{\sum_{k\in\mathcal{K}_{i}}\omega(k)\sum_{k\in\mathcal{K}_{j}}\omega(k)+\epsilon}}
$$

where $\mathcal{K}_{i}$ and $\mathcal{K}_{j}$ are the respective keyword sets. The query-aware weight $\omega(k)$ boosts query-relevant keywords and penalizes frequent non-informative terms, while $\epsilon$ is a small constant added to prevent division by zero and ensure numerical stability.

##### Event Edge

Two facts connect when they belong to the same event. This edge allows the system to recall facts based on a coherent episodic background even if they lack keyword similarity. To reduce noise from overly broad events, the edge weight incorporates a penalty based on event size:

$$
w_{\mathrm{event}}(F_{i},F_{j})=\sum_{e\in\mathcal{E}_{i}\cap\mathcal{E}_{j}}\frac{1}{\left(|\mathcal{F}_{e}|-1\right)^{\gamma_{e}}}
$$

where $\mathcal{E}_{i}$ and $\mathcal{E}_{j}$ denote the event sets for the two facts, and $\mathcal{F}_{e}$ is the set of member facts within event $e$. The penalty coefficient $\gamma_{e}$ controls the edge weight decay rate for large events.

##### Temporal Edge

Two facts connect when they appear in adjacent dialogue turns within the same session. The edge weight decays according to the turn distance:

$$
w_{\mathrm{turn}}(F_{i},F_{j})=\exp\left(-\frac{|\mathrm{pos}_{i}-\mathrm{pos}_{j}|}{\tau}\right)
$$

where $\mathrm{pos}_{i}$ and $\mathrm{pos}_{j}$ denote dialogue positions, and the decay coefficient $\tau$ controls the impact of turn distance. AtomMem restricts turn edges to intra-dialogue facts within a maximum window $W$.

### 3.5 Response Generation: Hierarchical Memory Integration

To ensure that the agent responds with accurate and contextually complete information, we design a hierarchical retrieval mechanism. This process transforms a user’s natural language query into a structured search command, executes a multi-strategy recall, and synthesizes the final response.

#### 3.5.1 Query Intent Analysis

The retrieval process begins by analyzing the user’s input query $q$ to determine the specific information needs. We employ an LLM to parse $q$ and extract a structured query object $Q_{parsed}$, defined as:

$$
Q_{parsed}=\{\mathrm{I}_{prof},\mathcal{P}_{q},\mathcal{K}_{q},\mathcal{T}_{q}\}
$$

where $\mathrm{I}_{prof}\in\{0,1\}$ indicates whether user profiles are required, $\mathcal{P}_{q}$ denotes the involved participants, $\mathcal{K}_{q}$ captures the core intent via extracted keywords, and $\mathcal{T}_{q}$ specifies the relevant time range.

#### 3.5.2 Hierarchical Hybrid Retrieval

To balance precision and contextual breadth, we implement a hierarchical retrieval strategy consisting of three stages.

(1) Primary Recall: AtomMem first filters global facts using participant ($\mathcal{P}_{q}$) and temporal ($\mathcal{T}_{q}$) constraints. We evaluate the remaining candidates against the query $Q$ using the predefined metric $S_{h}(F,Q)$ (Eq. 2). The top $\frac{k_{s}}{2}$ facts form the primary set $\mathcal{R}_{pri}$.

(2) Compensatory Recall: Direct retrieval often misses implicit yet relevant context. Therefore, AtomMem evaluates the event layer. After applying metadata filters, the system ranks events using $S_{h}(E,Q)$ (Eq. 2) to identify the top events. We extract all constituent facts from these events into a candidate pool. We exclude items already in $\mathcal{R}_{pri}$ to avoid redundancy. AtomMem then ranks these candidates using a fusion score:

$$
S_{f}(F)=w_{e}\cdot S_{h}(E,Q)+(1-w_{e})\cdot S_{h}(F,Q)
$$

where $w_{e}$ and $w_{f}$ balance global event relevance and local fact precision. The top $\frac{k_{s}}{2}$ facts from this pool form the compensatory set $\mathcal{R}_{comp}$. The combined set $\mathcal{R}_{seed}=\mathcal{R}_{pri}\cup\mathcal{R}_{comp}$ ensures both direct precision and contextual completeness.

(3) Associative Recall: We use $\mathcal{R}_{seed}$ as seeds to activate the memory graph. AtomMem constructs a localized graph around these seeds by expanding limited hops and retaining only top neighbors that satisfy participant and temporal constraints. AtomMem then applies Random Walk with Restart (RWR) to propagate activations across entity, event and temporal edges. Finally, the system selects the top $k_{f}$ facts with the highest activation scores across all nodes to output the final retrieved context $\mathcal{R}_{fact}$.

#### 3.5.3 Profile Augmentation and Response Generation

If the intent analysis sets the flag $\mathrm{I}_{prof}=1$, AtomMem executes profile recall to retrieve stable user attributes. The system first filters the global repository to retain profiles matching the query participants $\mathcal{P}_{q}$ and then ranks these candidates using the hybrid similarity metric $S_{h}(\mathcal{P}_{q},Q)$ (Eq. 2). The top $k_{p}$ items form the profile context set $\mathcal{R}_{prof}$. If the input contains temporal constraints, the system selects profile versions valid during that specific time. This ensures the response reflects both current user preferences and historical user states.

Finally, AtomMem constructs a comprehensive context $\mathcal{C}$ by concatenating the retrieved episodic fact set $\mathcal{R}_{fact}$ and the semantic profile set $\mathcal{R}_{prof}$. This context $C$, along with the original query $q$, is fed into the LLM to generate the final response. This multi-source injection mechanism ensures that the agent’s answer is grounded in specific atomic details, enriched by event-level context, and personalized by long-term user attributes.

## 4 Experiments

<table><tbody><tr><th rowspan="2">Method</th><td colspan="3">Single Hop</td><td colspan="3">Multi-Hop</td><td colspan="3">Temporal</td><td>Open Domain</td><td rowspan="2">Tokens(K)</td></tr><tr><td><math><semantics><mrow><msub><mi>F</mi> <mn>1</mn></msub> <mo>↑</mo></mrow> <annotation>F_{1}\uparrow</annotation></semantics></math></td><td>BLEU-1 <math><semantics><mo>↑</mo> <annotation>\uparrow</annotation></semantics></math></td><td><math><semantics><mrow><mi>J</mi> <mo>↑</mo></mrow> <annotation>J\uparrow</annotation></semantics></math></td><td><math><semantics><mrow><msub><mi>F</mi> <mn>1</mn></msub> <mo>↑</mo></mrow> <annotation>F_{1}\uparrow</annotation></semantics></math></td><td>BLEU-1 <math><semantics><mo>↑</mo> <annotation>\uparrow</annotation></semantics></math></td><td><math><semantics><mrow><mi>J</mi> <mo>↑</mo></mrow> <annotation>J\uparrow</annotation></semantics></math></td><td><math><semantics><mrow><msub><mi>F</mi> <mn>1</mn></msub> <mo>↑</mo></mrow> <annotation>F_{1}\uparrow</annotation></semantics></math></td><td>BLEU-1 <math><semantics><mo>↑</mo> <annotation>\uparrow</annotation></semantics></math></td><td><math><semantics><mrow><mi>J</mi> <mo>↑</mo></mrow> <annotation>J\uparrow</annotation></semantics></math></td><td><math><semantics><mrow><mi>J</mi> <mo>↑</mo></mrow> <annotation>J\uparrow</annotation></semantics></math></td></tr><tr><th>LoCoMo</th><td>37.81</td><td>26.23</td><td>57.07</td><td>20.97</td><td>11.09</td><td>48.58</td><td>34.79</td><td>15.46</td><td>38.01</td><td>41.67</td><td>827.20</td></tr><tr><th>MemoryBank</th><td>17.85</td><td>12.13</td><td>46.61</td><td>11.25</td><td>8.20</td><td>28.01</td><td>14.26</td><td>9.60</td><td>34.27</td><td>23.96</td><td>926.98</td></tr><tr><th>A-Mem</th><td>33.87</td><td>27.64</td><td>54.10</td><td>21.17</td><td>15.40</td><td>43.26</td><td>34.13</td><td>29.98</td><td>34.89</td><td>32.29</td><td>11687.58</td></tr><tr><th>MEM0</th><td>54.95</td><td>44.71</td><td>78.00</td><td>36.02</td><td>25.25</td><td>62.41</td><td>30.36</td><td>29.69</td><td>30.53</td><td>54.17</td><td>55300.30</td></tr><tr><th>MemoryOS</th><td>49.72</td><td>43.58</td><td>66.47</td><td>37.15</td><td>26.87</td><td>60.99</td><td>41.99</td><td>36.32</td><td>34.58</td><td>51.04</td><td>19207.67</td></tr><tr><th>LightMem</th><td>49.30</td><td>42.45</td><td>68.97</td><td>36.59</td><td>27.27</td><td>64.89</td><td>47.41</td><td>41.29</td><td>51.09</td><td>43.75</td><td>5021.56</td></tr><tr><th>AtomMem-Flat</th><td>47.08</td><td>40.40</td><td>67.66</td><td>37.03</td><td>29.50</td><td>55.67</td><td>56.45</td><td>48.98</td><td>59.50</td><td>52.08</td><td>722.75</td></tr><tr><th>AtomMem</th><td>56.66</td><td>49.56</td><td>78.48</td><td>42.50</td><td>33.26</td><td>68.44</td><td>62.78</td><td>57.64</td><td>66.98</td><td>64.58</td><td>21357.06</td></tr></tbody></table>

Table 1: Performance comparison of various memory methods on the LoCoMo benchmark. The best and second best results are bolded and underlined.

### 4.1 Experimental Settings

##### Datasets

We evaluate AtomMem on the LoCoMo [^13] and LongMemEval [^21] benchmarks. LoCoMo is a challenging dataset widely adopted for assessing long-context capabilities in memory-augmented LLMs. Designed to test the management of remote dependencies and consistency, LoCoMo consists of long-term interactions that average over 600 turns across 35 sessions, paired with comprehensive question sets. Additionally, LongMemEval specifically targets the interactive memory capabilities of chat assistants by using 500 curated questions to evaluate diverse functions. The experimental results on LongMemEval are detailed in Appendix 3.

##### Baselines and Metrics

To validate the effectiveness of our approach, we benchmark AtomMem against representative memory modeling systems, including LoCoMo [^13], MemoryBank [^25], A-MEM [^24], MEM0 [^3], MemoryOS [^8] and LightMem [^4]. For fair comparison, we re-implemented all baselines using GPT-4o-mini as the uniform backbone model. Performance is measured using three complementary metrics: Token-level F1 Score (F1), BLEU-1, and LLM-as-a-Judge (J). The LLM-as-a-Judge metric employs deepseek-v4-pro with a rigorous evaluation prompt to assess semantic correctness, providing a closer approximation to human judgment. Additionally, we track the total API token consumption across the entire pipeline to evaluate cost efficiency.

##### Experimental Details

We fine-tuned a Qwen3-14B model as our fact extractor using SFT LoRA on a single NVIDIA A100 GPU. The training configuration included a learning rate of 5e-5, a LoRA rank of 128, and an effective global batch size of 8 over 3 epochs. To ensure consistent experimental conditions, we employed all-minilm-L6-v2 as the unified text embedding model for both our approach and all baseline systems. Furthermore, we standardized the retrieval capacity by setting the top- $k$ to 10 for all comparative baselines and our method. Detailed hyperparameter configurations for AtomMem’s hierarchical retrieval and fusion mechanisms are provided in Appendix A.7.

### 4.2 Main Results

<table><thead><tr><th rowspan="2">Method</th><th colspan="4">Single Hop</th><th colspan="4">Multi-Hop</th><th colspan="4">Temporal</th><th colspan="2">Open Domain</th></tr><tr><th><math><semantics><msub><mi>F</mi> <mn>1</mn></msub> <annotation>F_{1}</annotation></semantics></math></th><th>BLEU-1</th><th>R@10</th><th><math><semantics><mi>J</mi> <annotation>J</annotation></semantics></math></th><th><math><semantics><msub><mi>F</mi> <mn>1</mn></msub> <annotation>F_{1}</annotation></semantics></math></th><th>BLEU-1</th><th>R@10</th><th><math><semantics><mi>J</mi> <annotation>J</annotation></semantics></math></th><th><math><semantics><msub><mi>F</mi> <mn>1</mn></msub> <annotation>F_{1}</annotation></semantics></math></th><th>BLEU-1</th><th>R@10</th><th><math><semantics><mi>J</mi> <annotation>J</annotation></semantics></math></th><th>R@10</th><th><math><semantics><mi>J</mi> <annotation>J</annotation></semantics></math></th></tr><tr><th>LoCoMo</th><th>37.81</th><th>26.23</th><th>56.98</th><th>57.07</th><th>20.97</th><th>11.09</th><th>32.91</th><th>48.58</th><th>34.79</th><th>15.46</th><th>56.10</th><th>38.01</th><th>33.55</th><th>41.67</th></tr></thead><tbody><tr><th>AtomMem-FLAT</th><td>47.08</td><td>40.40</td><td>72.18</td><td>67.66</td><td>37.03</td><td>29.50</td><td>41.75</td><td>55.67</td><td>56.45</td><td>48.98</td><td>79.89</td><td>59.50</td><td>42.46</td><td>52.08</td></tr><tr><th>w/o Profile</th><td>50.91</td><td>44.59</td><td>75.21</td><td>68.73</td><td>38.33</td><td>30.29</td><td>44.56</td><td>59.22</td><td>57.77</td><td>51.44</td><td>79.00</td><td>62.93</td><td>44.96</td><td>54.17</td></tr><tr><th>w/o Graph</th><td>50.55</td><td>44.14</td><td>74.08</td><td>71.82</td><td>39.76</td><td>30.91</td><td>46.72</td><td>62.76</td><td>60.90</td><td>54.74</td><td>80.33</td><td>62.93</td><td>47.73</td><td>60.42</td></tr><tr><th>AtomMem</th><td>56.66</td><td>49.56</td><td>76.30</td><td>78.48</td><td>42.50</td><td>33.26</td><td>48.15</td><td>68.44</td><td>62.78</td><td>57.64</td><td>81.10</td><td>66.98</td><td>48.98</td><td>64.58</td></tr></tbody></table>

Table 2: Ablation study of AtomMem on LoCoMo using GPT-4o-mini. R@10 denotes Recall@10. The best results are highlighted in bold, and the second-best results are underlined. “AtomMem-FLAT” removes the hierarchical memory structure; “w/o Profile” removes profile memory; and “w/o Graph” removes graph-based associative recall.

##### Superior Performance

As presented in Table 1, AtomMem achieves state-of-the-art results across all evaluated metrics. While maintaining a steady lead in Single Hop tasks, our system demonstrates its distinct advantage in scenarios requiring long-context integration and complex reasoning. Specifically, in Multi-Hop and Temporal tasks, AtomMem achieves substantial improvements over the strongest baseline, LightMem, increasing the J-score by 5.5% and 31.1%, respectively. AtomMem also dominates the Open Domain task by raising the J-score to 64.58 compared to 54.17 for MEM0. This consistent enhancement confirms that our hierarchical memory architecture successfully bridges the semantic gap between queries and distant historical context. AtomMem traces implicit narrative connections beyond surface similarity to ensure accurate retrieval of subtle information.

##### Computational Efficiency

AtomMem demonstrates competitive cost efficiency alongside its robust reasoning capabilities. Despite the overhead associated with memory construction, our system significantly reduces total token consumption by approximately 61.4% compared to the highly performant Mem0. This efficiency stems from our strategy of compressing redundant conversational streams into compact, high-value atomic units, which prevents the context window from being flooded by low-utility tokens during retrieval. AtomMem strikes an optimal balance between resource consumption and advanced reasoning to offer a scalable solution for practical deployment.

##### Validation of Atomic Fact Extraction

We validate the effectiveness of our core extraction mechanism using the AtomMem-Flat variant. This simplified version lacks hierarchical event structures and relies solely on retrieving atomic facts. Despite this simplicity, AtomMem-Flat significantly outperforms the standard LoCoMo baseline operating on raw dialogue history. For instance, on the challenging Multi-Hop reasoning tasks, it raises the F1 score from 20.97 to 37.03, yielding a 76.6% relative improvement. Critically, AtomMem-Flat achieves this performance while using the absolute lowest number of tokens (722k) among all methods, comparable to LoCoMo yet delivering performance competitive with the strongest existing baseline. This result provides compelling evidence that memory storage quality is paramount. Sophisticated system orchestration cannot compensate for flawed memory representations or information loss.

### 4.3 Ablation Study

To verify the contribution of each component, we benchmarked the full AtomMem against three variants, as shown in Table 2. The AtomMem FLAT variant uses simple flat retrieval without hierarchical structures but significantly outperforms the standard LoCoMo baseline. This proves that structured atomic facts provide a highly superior memory representation. The results also validate our temporal profile memory. Without this profile, the Single Hop $F_{1}$ score drops from 56.66 to 50.91. This demonstrates that tracking stable user attributes is crucial. Furthermore, removing the graph recall impairs complex reasoning. The notable drop in Multi Hop performance serves as a prime example. This highlights that isolated atomic facts cannot resolve remote dependencies without relational chaining to connect distant clues.

### 4.4 Hyperparameter Analysis

We evaluate the retrieval capacity $k_{f}$ below. Additional analyses are detailed in Appendix A.6.

##### Impact of Retrieval Capacity kfk\_{f}

We evaluated performance by varying the number of retrieved atomic facts from 5 to 40. As shown in Figure 3, increasing $k$ initially yields significant gains for all tasks, particularly in reasoning-intensive tasks. This confirms that a broader context provides necessary evidence for complex deduction. Despite continuous increases in Recall, system performance drops when $k$ is greater than 20. This indicates that excessive irrelevant noise degrades the reasoning quality of the LLM. Consequently, we selected a moderate setting ($k_{f}=10$) for our main experiments to strike an optimal balance between retrieval accuracy, token consumption, and response latency.

![Refer to caption](https://arxiv.org/html/2606.19847v1/figure/table_metrics.png)

Figure 3: Performance sensitivity analysis under varying the memory retrieval parameter k.

## 5 Conclusion

We introduced AtomMem as a robust long-term memory framework. It distills raw dialogues into precise atomic facts to serve as a highly efficient memory representation. The system organizes these facts into hierarchical event structures and temporal profiles. This design captures coherent episodic contexts and tracks dynamically evolving user attributes. AtomMem then activates an associative memory graph to connect scattered facts during retrieval. Experiments on the LoCoMo benchmark confirm that AtomMem achieves state-of-the-art performance. The superior results of our simplified flat variant further validate that memory storage quality is paramount. This proves that structured facts provide a fundamentally better retrieval basis than unstructured history. Ultimately, AtomMem offers a scalable and economically viable solution to deploy intelligent agents capable of sustaining personalized long term interactions.

## Limitations

We acknowledge a few limitations of the current AtomMem framework. First, multiple stages rely on the capabilities of the underlying LLM, making performance sensitive to the generation stability of the base model. Second, the current framework processes only textual interactions. Real world conversations often involve multimodal inputs like images and audio, making system extension a natural progression for future research. Lastly, although our system achieves a favorable balance between token efficiency and system performance, token efficiency can be further optimized.

## References

## Appendix A Appendix

### A.1 Details of Dataset Construction

In this section, we provide a detailed description of the data construction process for our instruction-tuning dataset $\mathcal{D}$. This includes the source of the raw dialogues, the specific guidelines used for fact extraction, and the final dataset statistics.

#### A.1.1 Data Source and Diversity

We utilized the generation pipeline of the LOCOMO project to obtain high quality raw dialogues. This pipeline utilizes LLM-based agents driven by specific character profiles and temporal event graphs, ensuring that conversations are grounded in consistent long-term contexts.

We meticulously designed 10 distinct character groups to cover a wide range of demographics, including varying ages, occupations, personalities, cultural backgrounds, and life stages. Specifically, our SFT training set employs custom characters like Elena the Chef and Kenji the Novelist, keeping them entirely independent of the LOCOMO evaluation set characters such as Caroline and Melanie. This configuration ensures zero overlap between our SFT dataset and the LOCOMO test set. Therefore, all training entities and events and themes remain strictly distinct from the evaluation set. Our SFT dataset covers extensive conversational topics grounded in realistic life scenarios across specific themes, including but not limited to:

- Professional & Academic Dynamics: Ranging from technical discussions on frontend engineering and performance optimization, to the daily routines of hospital nursing, travel blogging, and the academic pressure of college majors (e.g., Psychology, Mechanical Engineering).
- Family & Lifestyle: Covering complex domestic challenges such as managing multi-child households, stay-at-home parenting, housing renovation investments, and balancing urban versus rural living.
- Interests & Culture: Spanning diverse hobbies like K-pop music, traditional Italian cuisine (e.g., ossobuco, risotto), organic gardening, handmade crafts, and historical novel reading.
- Values & Emotional Depth: Exploring deep personal issues such as career burnout, homesickness in new environments, animal rights advocacy, and discussions on minimalism versus consumerism.

These scenarios range from mundane daily trivia to significant life decisions, providing a rich and authentic foundation for testing long-term memory capabilities.

#### A.1.2 Extraction Pipeline and Prompt Guidelines

We employed a two-stage pipeline to construct the dataset: Teacher-Model Preliminary Extraction followed by Human-Guided Refinement.

(1) Stage 1: Teacher-Model Extraction

We utilized GPT-4o as the teacher model to perform the initial extraction. The model was provided with specific guidelines to filter noise and resolve contextual dependencies. The exact system prompt used is presented in Figure 4.

(2) Stage 2: Human-Guided Refinement

Human annotators reviewed all samples generated by the teacher model to guarantee high data quality. Rigorous manual verification confirmed comprehensive denoising, unambiguous coreference resolution, the decomposition of long sentences, and the elimination of hallucinations. Their primary responsibilities were:

- Verification: Checking whether the extracted facts accurately reflected the original dialogue without hallucination.
- Refinement: Correcting any unresolved pronouns or vague temporal references that the teacher model missed.
- Filtering: Removing any residual conversational noise or redundant information.
- Decomposition: Splitting lengthy dialogue segments into semantically independent atomic facts.

#### A.1.3 Dataset Statistics and Examples

The final constructed dataset $\mathcal{D}$ consists of 4,352 high-quality samples. Each sample contains a structured instruction, the dialogue context with metadata, and the target output. Figure 5 presents a representative training instance that illustrates the model’s capability to resolve context-dependent references. Specifically, the example demonstrates how the model simultaneously disambiguates pronouns (e.g., resolving "I" and "my" to "Emma") and grounds relative timestamps (e.g., converting "last Friday" into an absolute date) to produce a standalone, objective fact.

` <svg id="A1.F4.1.1.pic1" height="257.02" overflow="visible" version="1.1" viewBox="0 0 600 257.02" width="600"><g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="translate(0,257.02) matrix(1 0 0 -1 0 0)" fill="#000000" stroke="#000000" stroke-width="0.4pt"><g style="--ltx-fill-color:#B3B3B3;" fill="#B3B3B3" fill-opacity="1.0"><path style="stroke:none" d="M 0 0 L 0 246.29 L 600 246.29 L 600 0 Z"></path></g><g style="--ltx-fill-color:#F9F9F9;" fill="#F9F9F9" fill-opacity="1.0"><path style="stroke:none" d="M 1.97 1.97 L 1.97 244.32 L 598.03 244.32 L 598.03 1.97 Z"></path></g><g transform="matrix(1.0 0.0 0.0 1.0 11.81 234.48)"><g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="matrix(1 0 0 1 0 0)" fill="#000000" stroke="#000000" stroke-width="0.4pt"><g style="--ltx-fill-color:#B3B3B3;" fill="#B3B3B3" fill-opacity="1.0"><path style="stroke:none" d="M 0 3.15 L 0 19.39 C 0 21.13 1.41 22.54 3.15 22.54 L 403.5 22.54 C 405.24 22.54 406.65 21.13 406.65 19.39 L 406.65 3.15 C 406.65 1.41 405.24 0 403.5 0 L 3.15 0 C 1.41 0 0 1.41 0 3.15 Z"></path></g><g style="--ltx-fill-color:#D9D9D9;" fill="#D9D9D9" fill-opacity="1.0"><path style="stroke:none" d="M 1.18 3.15 L 1.18 19.39 C 1.18 20.47 2.06 21.35 3.15 21.35 L 403.5 21.35 C 404.59 21.35 405.47 20.47 405.47 19.39 L 405.47 3.15 C 405.47 2.06 404.59 1.18 403.5 1.18 L 3.15 1.18 C 2.06 1.18 1.18 2.06 1.18 3.15 Z"></path></g><g fill-opacity="1.0" transform="matrix(1.0 0.0 0.0 1.0 9.06 7.81)"><foreignObject style="--ltx-fg-color:#000000;--ltx-fo-width:24.51em;--ltx-fo-height:0.6em;--ltx-fo-depth:0.17em;" width="390.08" height="12.3" transform="matrix(1 0 0 -1 0 9.61)" overflow="visible" color="#000000"><span id="A1.F4.1.1.pic1.2.2.2.1.1.1.1">Figure A.1: System Prompt for Atomic Fact Extraction</span></foreignObject></g></g></g><g fill-opacity="1.0" transform="matrix(1.0 0.0 0.0 1.0 13.78 215.72)"></g></g></svg>`

Figure 4: System prompt for atomic fact extraction. The prompt instructs the fact executor to filter low-value content, resolve references, rewrite extracted information as standalone third-person facts, integrate multimodal evidence, and output the extracted facts in JSON format.

` <svg id="A1.F5.1.1.pic1" height="257.02" overflow="visible" version="1.1" viewBox="0 0 600 257.02" width="600"><g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="translate(0,257.02) matrix(1 0 0 -1 0 0)" fill="#000000" stroke="#000000" stroke-width="0.4pt"><g style="--ltx-fill-color:#B3B3B3;" fill="#B3B3B3" fill-opacity="1.0"><path style="stroke:none" d="M 0 0 L 0 246.29 L 600 246.29 L 600 0 Z"></path></g><g style="--ltx-fill-color:#F9F9F9;" fill="#F9F9F9" fill-opacity="1.0"><path style="stroke:none" d="M 1.97 1.97 L 1.97 244.32 L 598.03 244.32 L 598.03 1.97 Z"></path></g><g transform="matrix(1.0 0.0 0.0 1.0 11.81 234.48)"><g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="matrix(1 0 0 1 0 0)" fill="#000000" stroke="#000000" stroke-width="0.4pt"><g style="--ltx-fill-color:#B3B3B3;" fill="#B3B3B3" fill-opacity="1.0"><path style="stroke:none" d="M 0 3.15 L 0 19.39 C 0 21.13 1.41 22.54 3.15 22.54 L 326.58 22.54 C 328.32 22.54 329.73 21.13 329.73 19.39 L 329.73 3.15 C 329.73 1.41 328.32 0 326.58 0 L 3.15 0 C 1.41 0 0 1.41 0 3.15 Z"></path></g><g style="--ltx-fill-color:#D9D9D9;" fill="#D9D9D9" fill-opacity="1.0"><path style="stroke:none" d="M 1.18 3.15 L 1.18 19.39 C 1.18 20.47 2.06 21.35 3.15 21.35 L 326.58 21.35 C 327.67 21.35 328.55 20.47 328.55 19.39 L 328.55 3.15 C 328.55 2.06 327.67 1.18 326.58 1.18 L 3.15 1.18 C 2.06 1.18 1.18 2.06 1.18 3.15 Z"></path></g><g fill-opacity="1.0" transform="matrix(1.0 0.0 0.0 1.0 9.06 7.81)"><foreignObject style="--ltx-fg-color:#000000;--ltx-fo-width:22.6em;--ltx-fo-height:0.69em;--ltx-fo-depth:0.19em;" width="312.77" height="12.3" transform="matrix(1 0 0 -1 0 9.61)" overflow="visible" color="#000000"><span id="A1.F5.1.1.pic1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1">Figure A.2: Training Sample from Dataset <math xmlns="http://www.w3.org/1998/Math/MathML" display="inline" data-latex="\mathcal{D}"><semantics><mi>𝒟</mi><annotation encoding="application/x-tex">\mathcal{D}</annotation></semantics></math></span></foreignObject></g></g></g><g fill-opacity="1.0" transform="matrix(1.0 0.0 0.0 1.0 13.78 215.72)"></g></g></svg>`

Figure 5: Training sample from dataset $\mathcal{D}$. The example shows an instruction-output pair used for training the fact executor to extract standalone, high-value third-person facts from dialogue.

### A.2 Details of Event Memory Construction

This section details the complete algorithmic workflow for constructing and updating event memory in AtomMem as outlined in Algorithm 1. Upon receiving a verified new atomic fact $F_{new}$, the system aims to integrate it into the broader episodic context. To achieve this, AtomMem leverages the retrieved relevant facts $\mathcal{C}_{ret}$ to track potential event associations.

Candidate Generation. The system forms a candidate set $\mathcal{E}_{cand}$ based on these retrieved facts. If a retrieved fact belongs to existing events, those events are added to the candidate set. If a retrieved fact is not yet linked to any event, the system includes it as a standalone candidate.

Semantic Routing. AtomMem prompts the LLM to verify whether $F_{new}$ logically aligns with any items in this candidate set. Based on this analysis, the LLM makes routing decisions. It can select existing events to absorb $F_{new}$ or select standalone facts to trigger the creation of new events. The model possesses the flexibility to select multiple candidates if $F_{new}$ provides different episodic contexts. Alternatively, it can choose none, opting to store the new fact independently without event affiliation.

State Execution. AtomMem applies these selections to update the memory state. For absorption, it appends $F_{new}$ to the member facts of all affected events. The system then prompts the LLM to regenerate the summary $\mathcal{S}$ and keywords $\mathcal{K}_{e}$ based on the newly added information. Concurrently, set union operations expand the participant set $\mathcal{P}_{e}$ and the temporal span $\mathcal{T}_{e}$. For new event triggers, AtomMem iterates through each matched standalone fact and instantiates a separate new event pairing it with $F_{new}$ while initializing all required event attributes.

Algorithm 1 Event Memory Construction and Update

 Input: Verified new fact $F_{\mathrm{new}}$, retrieved context facts $\mathcal{C}_{\mathrm{ret}}$ with top- $k$ facts

 Output: Updated memory system state

 Initialize event candidate set $\mathcal{E}_{\mathrm{cand}}\leftarrow\emptyset$

 Initialize standalone fact set $\mathcal{F}_{\mathrm{alone}}\leftarrow\emptyset$

 for all $F\in\mathcal{C}_{\mathrm{ret}}$ do

  if $F$ is linked to existing events then

    $\mathcal{E}_{\mathrm{cand}}\leftarrow\mathcal{E}_{\mathrm{cand}}\cup\operatorname{GetEvents}(F)$

  else

    $\mathcal{F}_{\mathrm{alone}}\leftarrow\mathcal{F}_{\mathrm{alone}}\cup\{F\}$

  end if

 end for

  $\mathcal{C}_{\mathrm{target}}\leftarrow\mathcal{E}_{\mathrm{cand}}\cup\mathcal{F}_{\mathrm{alone}}$   $\mathcal{E}_{\mathrm{match}},\mathcal{F}_{\mathrm{match}}\leftarrow\operatorname{LLM}_{\mathrm{verify}}(F_{\mathrm{new}},\mathcal{C}_{\mathrm{target}})$

 if $\mathcal{E}_{\mathrm{match}}\neq\emptyset$ then

  for all $E\in\mathcal{E}_{\mathrm{match}}$ do

    $E.\mathcal{F}_{\mathrm{ids}}\leftarrow E.\mathcal{F}_{\mathrm{ids}}\cup\{F_{\mathrm{new}}.\mathrm{id}\}$     $E.\mathcal{P}_{e}\leftarrow E.\mathcal{P}_{e}\cup F_{\mathrm{new}}.\mathcal{P}$     $E.\mathcal{T}_{e}\leftarrow\operatorname{TimeUnion}(E.\mathcal{T}_{e},F_{\mathrm{new}}.\mathcal{T})$     $E.\mathcal{S},E.\mathcal{K}_{e}\leftarrow\operatorname{LLM}_{\mathrm{summarize}}(E.\mathcal{F}_{\mathrm{ids}})$

  end for

 end if

 if $\mathcal{F}_{match}\neq\emptyset$ then

  for all $F_{alone}\in\mathcal{F}_{match}$ do

    $\text{CreateNewEvent}(\{F_{new},F_{alone}\})$

  end for

 end if

 if $\mathcal{E}_{\mathrm{match}}=\emptyset\land\mathcal{F}_{\mathrm{match}}=\emptyset$ then

   $\operatorname{StoreIndependently}(F_{\mathrm{new}})$

 end if

### A.3 Details of Associative Graph Retrieval

Building upon the memory graph concepts introduced in Section section˜3.4, this section details the ranking of candidate facts through a multi-channel fact graph and Personalized PageRank (PPR). To execute this, AtomMem constructs a localized, query-specific subgraph anchored by the initial seed facts $\mathcal{R}_{seed}$. From these seeds, the graph expands by retrieving candidate neighbors across three relational channels: Keyword, Event, and Dialogue Turn. These channels respectively capture topical similarity, event co-occurrence, and local temporal proximity.

#### A.3.1 Query-Aware Keyword Weighting

As defined in Section section˜3.4, the entity edge weight relies on a query-aware function $\omega(k)$ to balance term specificity and relevance. Simply using Term Frequency-Inverse Document Frequency (TF-IDF) can inadvertently bridge unrelated facts through high-frequency conversational stop-words. Therefore, $\omega(k)$ is implemented as a composite function:

$$
\omega(k)=\mathrm{IDF}(k)\cdot\beta_{q}(k)\cdot\pi(k)
$$

where $\mathrm{IDF}(k)$ represents the global inverse document frequency of the keyword. $\beta_{q}(k)$ is a boosting multiplier that amplifies the weight if $k$ is present in the keyword set of the user query, otherwise $\beta_{q}(k)=1$. Furthermore, $\pi(k)$ applies a nonlinear frequency penalty that aggressively decays the weight of keywords whose occurrence frequency exceeds a certain threshold across the memory bank. This ensures that entity edges reflect genuine semantic overlap.

#### A.3.2 Multi-Channel Transition Matrix

The memory graph contains three distinct topological channels: Entity, Event, and Temporal edges. Simply adding the edge weights together would cause dense channels to overwhelm sparse ones. To address this issue, AtomMem treats them as parallel transition matrices.

For each channel $c\in\{\mathrm{kw},\mathrm{event},\mathrm{turn}\}$, we first independently normalize the edge weights into a channel-specific transition matrix $\mathbf{P}_{c}$, where each row sums to 1. The overall transition matrix $\mathbf{P}$ is then computed as a weighted fusion of the available channels:

$$
\mathbf{P}_{i,j}=\sum_{c\in\mathcal{C}_{i}}\bar{\rho}_{i,c}(\mathbf{P}_{c})_{i,j}
$$

where $\mathcal{C}_{i}$ denotes the specific set of channels containing at least one outgoing neighbor for node $F_{i}$. To compute the dynamic channel prior $\bar{\rho}_{i,c}$, the static prior $\rho_{c}$ is adaptively renormalized over these valid channels:

$$
\bar{\rho}_{i,c}=\frac{\rho_{c}}{\sum_{c^{\prime}\in\mathcal{C}_{i}}\rho_{c^{\prime}}}.
$$

This node-wise normalization ensures that transition probabilities are properly normalized over the available outgoing channels, even when a fact does not possess all edge types.

#### A.3.3 Execution of Personalized PageRank

To initialize the PPR process, the retrieval scores of the seed facts in $\mathcal{R}_{seed}$ (obtained from the Primary and Compensatory recall stages) are transformed into a personalized restart probability distribution $\mathbf{p}$. Specifically, the system applies a power transformation to the raw seed score $\tilde{s}_{i}$:

$$
p_{i}=\frac{\tilde{s}_{i}^{\gamma_{s}}}{\sum_{F_{j}\in\mathcal{R}_{seed}}\tilde{s}_{j}^{\gamma_{s}}}
$$

where the scaling exponent $\gamma_{s}$ dictates the sharpness of the distribution. This design ensures that high-confidence seeds exert a stronger restart attraction during the random walk, while still allowing the graph structure to propagate probability mass to non-seed facts that are semantically, event-wise, or temporally related.

Let $\mathbf{r}^{(t)}$ denote the vector of activation scores for all nodes in the localized graph at iteration $t$. The PageRank iteration takes the form of a Random Walk with Restart (RWR), updating the activation scores iteratively:

$$
\mathbf{r}^{(t+1)}=\eta\mathbf{p}+(1-\eta)\mathbf{P}^{T}\mathbf{r}^{(t)}
$$

where $\eta\in(0,1)$ is the restart probability. A higher $\eta$ forces the walk to stay close to the seed facts, preventing the context from drifting too far from the original query intent. For dangling nodes without valid outgoing edges, their probability mass is redistributed according to the restart distribution $\mathbf{p}$, which prevents probability mass leakage during the random walk.

The iteration proceeds until it reaches a maximum number of steps or satisfies the convergence criterion:

$$
\|\mathbf{r}^{(t+1)}-\mathbf{r}^{(t)}\|_{1}<\epsilon_{c}
$$

where $\epsilon_{c}$ is a predefined convergence threshold. Upon convergence, the stationary distribution $\mathbf{r}^{(\infty)}$ assigns a final activation score to each fact in the local graph. AtomMem subsequently ranks all nodes according to $\mathbf{r}^{(\infty)}$ and extracts the top $k_{f}$ facts to construct the final retrieved context $\mathcal{R}_{fact}$. Ultimately, this framework ensures that the retrieval process remains tightly anchored to the query intent via the personalized restart distribution. Within the graph, Entity Edges drive topic-level propagation, Event Edges facilitate cross-turn episodic aggregation, and Temporal Edges preserve short-range contextual continuity. Consequently, AtomMem effectively surfaces indirectly related facts in long conversational scenarios that isolated similarity retrieval typically misses, while mitigating semantic drift through localized subgraph constraints and nonlinear frequency penalties.

### A.4 Details of Experimental Results on LongMemEval

| Stage | Avg (ms) | P95 (ms) | Max (ms) |
| --- | --- | --- | --- |
| Total online latency | 3585.11 | 4559.80 | 9596.74 |
| Query intent | 2079.86 | 2690.29 | 5399.86 |
| Answer generation | 1346.14 | 1970.20 | 7678.18 |
| Retrieval pipeline only | 145.80 | 235.87 | 3107.25 |
| Query embedding | 13.23 | 20.71 | 1018.54 |
| Base retrieval | 35.29 | 89.54 | 2933.75 |
| Graph rerank | 109.90 | 184.16 | 2002.02 |

Table 3: End-to-end latency breakdown of the AtomMem system across different processing stages.

To rigorously demonstrate that our system does not suffer from data bias toward the LoCoMo benchmark, we conduct supplementary evaluations on the completely independent LongMemEval dataset. For these evaluations, we employ GPT-4o-mini as the backbone model and utilize DeepSeek-v4-Pro as the judge model to ensure objective scoring.

Table 4 presents the detailed performance of AtomMem across the six distinct question categories defined in the LongMemEval framework. Notably, the SSP category evaluates subjective and personalized generation quality rather than exact factual retrieval. Because this assessment relies on whether the model satisfies a specific grading rubric instead of matching precise short answers, traditional token matching metrics such as the $F_{1}$ score and BLEU-1 are inherently inapplicable. Consequently, we report only the comprehensive judge score $J$ for this specific category.

| Category | $\boldsymbol{F_{1}}$ | BLEU-1 | $\boldsymbol{J}$ |
| --- | --- | --- | --- |
| SSU | 80.70 | 75.84 | 90.00 |
| MS | 57.50 | 54.85 | 67.67 |
| TR | 42.10 | 33.16 | 52.63 |
| KU | 66.35 | 62.27 | 79.49 |
| SSA | 61.09 | 52.17 | 76.79 |
| SSP | — | — | 80.00 |

Table 4: Performance of AtomMem on the LongMemEval benchmark across various task categories. The abbreviations correspond to Single-Session-User (SSU), Single-Session-Assistant (SSA), Single-Session-Preference (SSP), Multi-Session (MS), Knowledge-Update (KU), and Temporal-Reasoning (TR).

### A.5 Details of End-to-End Efficiency Analysis

To evaluate the practical deployment viability of AtomMem, we conduct a comprehensive latency analysis across all processing stages using 1540 questions from the LoCoMo dataset. The experiments are executed locally on an Intel Core i7-10750H CPU (6 physical cores, 12 logical threads) to accurately evaluate the computational overhead.

As detailed in Table 3, the total online processing latency averages approximately 3.6 seconds. The vast majority of this execution time is consumed by the fundamental LLM inference calls. In stark contrast, our core memory retrieval pipeline introduces negligible computational overhead. The entire retrieval process averages only 145.80 milliseconds. Furthermore, our proposed graph-based reranking mechanism operates with extreme efficiency, completing in just 109.90 milliseconds on average. These results clearly demonstrate that the structural complexity of AtomMem does not compromise its speed, rendering the system highly responsive and perfectly suited for real-time interactive chat applications.

### A.6 Details of Hyperparameter Analysis

Complementing the hyperparameter analysis provided in the main text, this section presents supplementary evaluations to determine the optimal configurations for other critical components within the AtomMem retrieval pipeline. Specifically, we investigate the sensitivity of the overall system performance to the initial seed count for local graph construction and the compensatory fusion weight. All experiments are evaluated on the LoCoMo benchmark.

#### A.6.1 Impact of Graph Retrieval Initial Seed Count ksk\_{s}

To investigate the impact of the initial seed count on local graph construction, we conduct a detailed parametric sweep over the total seed capacity $k_{s}$. This hyperparameter directly controls the number of entry points injected into the personalized PageRank algorithm.

As illustrated in Figure 6, the system performance varies systematically with respect to the seed density. When $k_{s}$ is set to a conservative value of 5, the initial memory activation remains insufficient, leading to sub-optimal recall metrics. Conversely, expanding the seed count beyond 10 introduces a performance degradation across all evaluation dimensions, where the aggregate semantic accuracy metrics such as average F1 and BLEU-1 experience notable declines. This trend demonstrates that excessive initial seeds inevitably pollute the local graph structure with irrelevant conversational contexts and redundant relational edges. This semantic noise degrades the random walk propagation, allowing unrelated facts to accumulate high stationary probabilities. Consequently, optimizing the configuration at $k_{s}=10$, where the main seed and compensation seed are both set to 5, provides the ideal trade-off between informational coverage and noise suppression. We therefore freeze $k_{s}=10$ as the default setting for all primary experiments.

![Refer to caption](https://arxiv.org/html/2606.19847v1/figure/seed_k_metrics.png)

Figure 6: Hyperparameter analysis of the graph retrieval initial seed count k s k\_{s}. The performance curves indicate that = 10 k\_{s}=10 achieves the optimal trade-off between informational coverage and noise suppression.

#### A.6.2 Impact of Compensatory Fusion Weight wew\_{e}

To systematically determine the optimal balance between global event relevance and local fact precision during the compensatory recall phase, we analyze the sensitivity of the retrieval performance to the fusion weight $w_{e}$. This hyperparameter controls the proportional contribution of the event-level hybrid score and the fact-level hybrid score when ranking candidate facts extracted from matched events.

As illustrated in Figure 7, the system performance varies systematically across different $w_{e}$ configurations. The metrics reveal a steady improvement as $w_{e}$ increases from 0.5 to 0.7, reaching a distinct optimal peak at $w_{e}=0.7$ across all core evaluation dimensions, including average F1, BLEU-1, and Recall@10. Conversely, elevating the weight beyond 0.7 introduces a noticeable performance degradation. This trend effectively validates our hierarchical retrieval design. Specifically, when $w_{e}$ is set too low, the system underutilizes the broader episodic context provided by the event layer, causing the compensatory recall to regress toward a standard fact-level semantic search. When $w_{e}$ exceeds 0.7, the fusion score becomes overly dominated by global event relevance, forcing the system to retrieve constituent facts that belong to highly relevant events but lack direct semantic alignment with the specific user query. Consequently, optimizing the configuration at $w_{e}=0.7$ provides the ideal trade-off, ensuring that the retrieved facts are both contextually grounded in the correct episode and individually precise.

![Refer to caption](https://arxiv.org/html/2606.19847v1/figure/fusion_weight_metrics.png)

Figure 7: Hyperparameter analysis of the compensatory fusion weight w e w\_{e}. The performance curves indicate that = 0.7 w\_{e}=0.7 achieves the optimal balance between global event relevance and local fact precision.

### A.7 Hyperparameter Settings

This section details the comprehensive hyperparameter configurations used for the AtomMem system. As discussed in Section section˜4.4, while the final fact retrieval count is standardized at $k_{f}=10$, our hierarchical architecture requires additional parameters to govern event retrieval, profile matching, and graph-based score fusion. These specific values were empirically determined through extensive hyperparameter analysis to optimize the overall performance of the memory retrieval pipeline. To ensure full reproducibility, all configurations governing the local graph construction and random walk mechanics are explicitly detailed in Table 5.

| Module Component | Hyperparameter | Value |
| --- | --- | --- |
| Base Capacities | Initial Graph Seed Count ($k_{s}$) | 10 |
|  | Final Retrieved Fact Count ($k_{f}$) | 10 |
|  | Profile Item Retrieval Count ($k_{p}$) | 5 |
| Similarity Weighting | Embedding Similarity Weight ($\alpha$) | 0.7 |
|  | Keyword Jaccard Weight ($\beta$) | 0.3 |
| Compensatory Fusion | Event Relevance Weight ($w_{e}$) | 0.7 |
|  | Fact Self-Relevance Weight ($w_{f}$) | 0.3 |
| Graph Channel Mixture | Entity Edge Weight ($\rho_{ent}$) | 0.45 |
|  | Event Edge Weight ($\rho_{event}$) | 0.40 |
|  | Temporal Edge Weight ($\rho_{turn}$) | 0.15 |
| Random Walk Restart | Restart Probability ($\eta$) | 0.34 |
|  | Maximum Iterations | 20 |
|  | Convergence Tolerance ($\epsilon_{c}$) | $10^{-6}$ |
|  | Seed Score Sharpening Power ($\gamma_{s}$) | 5.0 |
| Graph Construction | Maximum Seed Facts | 10 |
|  | Maximum Expansion Hops | 2 |
|  | Maximum Local Graph Nodes | 180 |
|  | Maximum Neighbors per Fact | 30 |
|  | Edge Weight Epsilon | $10^{-8}$ |
| Entity Edge Weighting | Query Keyword Boost | 2.5 |
|  | Query Keyword Penalty Floor | 0.45 |
|  | Query Keyword Penalty Threshold $\tau_{q}$ | 0.05 |
|  | Query Keyword Penalty Exponent $\gamma_{q}$ | 0.7 |
|  | Non-query Keyword Penalty Threshold $\tau_{nq}$ | 0.10 |
|  | Non-query Keyword Penalty Exponent $\gamma_{nq}$ | 1.0 |
| Event Edge Constraints | Event Size Penalty Exponent ($\lambda$) | 1.25 |
|  | Maximum Event Size | 60 |
|  | Maximum Event-edge Expansion Hops | 2 |
| Temporal Constraints | Turn Window Size | 2 |
|  | Turn Distance Decay Temperature ($\tau$) | 2.0 |
|  | Maximum Turn-edge Expansion Hops | 1 |

Table 5: Comprehensive empirical hyperparameter configurations optimized for the AtomMem retrieval pipeline.

### A.8 Prompts

This section details the system prompts utilized throughout our experiments, covering both the response generation phase and the LLM judgment phase.

Figure 8 presents the generation prompt applied to exact extraction tasks including single-hop, multi-hop, and temporal reasoning. For open-domain queries that necessitate broader reasoning and integration with external world knowledge, we utilize the prompt detailed in Figure 9. Additionally, Figure 10 outlines the evaluation prompt used for the LLM judge to score the generated responses against the ground-truth answers.

` <svg id="A1.F8.1.1.pic1" height="258.56" overflow="visible" version="1.1" viewBox="0 0 600 258.56" width="600"><g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="translate(0,258.56) matrix(1 0 0 -1 0 0)" fill="#000000" stroke="#000000" stroke-width="0.4pt"><g style="--ltx-fill-color:#B3B3B3;" fill="#B3B3B3" fill-opacity="1.0"><path style="stroke:none" d="M 0 0 L 0 246.29 L 600 246.29 L 600 0 Z"></path></g><g style="--ltx-fill-color:#F9F9F9;" fill="#F9F9F9" fill-opacity="1.0"><path style="stroke:none" d="M 1.97 1.97 L 1.97 244.32 L 598.03 244.32 L 598.03 1.97 Z"></path></g><g transform="matrix(1.0 0.0 0.0 1.0 11.81 234.48)"><g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="matrix(1 0 0 1 0 0)" fill="#000000" stroke="#000000" stroke-width="0.4pt"><g style="--ltx-fill-color:#B3B3B3;" fill="#B3B3B3" fill-opacity="1.0"><path style="stroke:none" d="M 0 3.15 L 0 20.92 C 0 22.66 1.41 24.07 3.15 24.07 L 732.53 24.07 C 734.27 24.07 735.68 22.66 735.68 20.92 L 735.68 3.15 C 735.68 1.41 734.27 0 732.53 0 L 3.15 0 C 1.41 0 0 1.41 0 3.15 Z"></path></g><g style="--ltx-fill-color:#D9D9D9;" fill="#D9D9D9" fill-opacity="1.0"><path style="stroke:none" d="M 1.18 3.15 L 1.18 20.92 C 1.18 22.01 2.06 22.89 3.15 22.89 L 732.53 22.89 C 733.62 22.89 734.5 22.01 734.5 20.92 L 734.5 3.15 C 734.5 2.06 733.62 1.18 732.53 1.18 L 3.15 1.18 C 2.06 1.18 1.18 2.06 1.18 3.15 Z"></path></g><g fill-opacity="1.0" transform="matrix(1.0 0.0 0.0 1.0 9.06 8.58)"><foreignObject style="--ltx-fg-color:#000000;--ltx-fo-width:45.12em;--ltx-fo-height:0.65em;--ltx-fo-depth:0.22em;" width="717.95" height="13.84" transform="matrix(1 0 0 -1 0 10.38)" overflow="visible" color="#000000"><span id="A1.F8.1.1.pic1.2.2.2.1.1.1.1">Figure A.3: System Prompt for Response Generation - Single-Hop / Multi-Hop / Temporal Reasoning</span></foreignObject></g></g></g><g fill-opacity="1.0" transform="matrix(1.0 0.0 0.0 1.0 13.78 215.72)"></g></g></svg>`

Figure 8: System Prompt for Response Generation. This prompt is utilized for single-hop, multi-hop, and temporal reasoning tasks where precise extraction is required.

` <svg id="A1.F9.1.1.pic1" height="257.02" overflow="visible" version="1.1" viewBox="0 0 600 257.02" width="600"><g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="translate(0,257.02) matrix(1 0 0 -1 0 0)" fill="#000000" stroke="#000000" stroke-width="0.4pt"><g style="--ltx-fill-color:#B3B3B3;" fill="#B3B3B3" fill-opacity="1.0"><path style="stroke:none" d="M 0 0 L 0 246.29 L 600 246.29 L 600 0 Z"></path></g><g style="--ltx-fill-color:#F9F9F9;" fill="#F9F9F9" fill-opacity="1.0"><path style="stroke:none" d="M 1.97 1.97 L 1.97 244.32 L 598.03 244.32 L 598.03 1.97 Z"></path></g><g transform="matrix(1.0 0.0 0.0 1.0 11.81 234.48)"><g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="matrix(1 0 0 1 0 0)" fill="#000000" stroke="#000000" stroke-width="0.4pt"><g style="--ltx-fill-color:#B3B3B3;" fill="#B3B3B3" fill-opacity="1.0"><path style="stroke:none" d="M 0 3.15 L 0 19.39 C 0 21.13 1.41 22.54 3.15 22.54 L 499.66 22.54 C 501.4 22.54 502.81 21.13 502.81 19.39 L 502.81 3.15 C 502.81 1.41 501.4 0 499.66 0 L 3.15 0 C 1.41 0 0 1.41 0 3.15 Z"></path></g><g style="--ltx-fill-color:#D9D9D9;" fill="#D9D9D9" fill-opacity="1.0"><path style="stroke:none" d="M 1.18 3.15 L 1.18 19.39 C 1.18 20.47 2.06 21.35 3.15 21.35 L 499.66 21.35 C 500.75 21.35 501.63 20.47 501.63 19.39 L 501.63 3.15 C 501.63 2.06 500.75 1.18 499.66 1.18 L 3.15 1.18 C 2.06 1.18 1.18 2.06 1.18 3.15 Z"></path></g><g fill-opacity="1.0" transform="matrix(1.0 0.0 0.0 1.0 9.06 7.81)"><foreignObject style="--ltx-fg-color:#000000;--ltx-fo-width:30.41em;--ltx-fo-height:0.6em;--ltx-fo-depth:0.17em;" width="483.93" height="12.3" transform="matrix(1 0 0 -1 0 9.61)" overflow="visible" color="#000000"><span id="A1.F9.1.1.pic1.2.2.2.1.1.1.1">Figure A.4: System Prompt for Response Generation - Open Domain</span></foreignObject></g></g></g><g fill-opacity="1.0" transform="matrix(1.0 0.0 0.0 1.0 13.78 215.72)"></g></g></svg>`

Figure 9: System Prompt for Response Generation (Open Domain). This prompt guides the model to integrate retrieved memory with external knowledge for comprehensive reasoning.

` <svg id="A1.F10.1.1.pic1" height="257.02" overflow="visible" version="1.1" viewBox="0 0 600 257.02" width="600"><g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="translate(0,257.02) matrix(1 0 0 -1 0 0)" fill="#000000" stroke="#000000" stroke-width="0.4pt"><g style="--ltx-fill-color:#B3B3B3;" fill="#B3B3B3" fill-opacity="1.0"><path style="stroke:none" d="M 0 0 L 0 246.29 L 600 246.29 L 600 0 Z"></path></g><g style="--ltx-fill-color:#F9F9F9;" fill="#F9F9F9" fill-opacity="1.0"><path style="stroke:none" d="M 1.97 1.97 L 1.97 244.32 L 598.03 244.32 L 598.03 1.97 Z"></path></g><g transform="matrix(1.0 0.0 0.0 1.0 11.81 234.48)"><g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="matrix(1 0 0 1 0 0)" fill="#000000" stroke="#000000" stroke-width="0.4pt"><g style="--ltx-fill-color:#B3B3B3;" fill="#B3B3B3" fill-opacity="1.0"><path style="stroke:none" d="M 0 3.15 L 0 19.39 C 0 21.13 1.41 22.54 3.15 22.54 L 365.15 22.54 C 366.89 22.54 368.3 21.13 368.3 19.39 L 368.3 3.15 C 368.3 1.41 366.89 0 365.15 0 L 3.15 0 C 1.41 0 0 1.41 0 3.15 Z"></path></g><g style="--ltx-fill-color:#D9D9D9;" fill="#D9D9D9" fill-opacity="1.0"><path style="stroke:none" d="M 1.18 3.15 L 1.18 19.39 C 1.18 20.47 2.06 21.35 3.15 21.35 L 365.15 21.35 C 366.24 21.35 367.12 20.47 367.12 19.39 L 367.12 3.15 C 367.12 2.06 366.24 1.18 365.15 1.18 L 3.15 1.18 C 2.06 1.18 1.18 2.06 1.18 3.15 Z"></path></g><g fill-opacity="1.0" transform="matrix(1.0 0.0 0.0 1.0 9.06 7.81)"><foreignObject style="--ltx-fg-color:#000000;--ltx-fo-width:22.06em;--ltx-fo-height:0.6em;--ltx-fo-depth:0.17em;" width="350.96" height="12.3" transform="matrix(1 0 0 -1 0 9.61)" overflow="visible" color="#000000"><span id="A1.F10.1.1.pic1.2.2.2.1.1.1.1">Figure A.5: System Prompt for Answer Judgment</span></foreignObject></g></g></g><g fill-opacity="1.0" transform="matrix(1.0 0.0 0.0 1.0 13.78 215.72)"></g></g></svg>`

Figure 10: System Prompt for Answer Judgment. This prompt configures the LLM judge to evaluate generated answers against ground-truth references.

[^1]: Akari Asai, Zeqiu Wu, Yizhong Wang, Avirup Sil, and Hannaneh Hajishirzi. 2024. [Self-RAG: Learning to retrieve, generate, and critique through self-reflection](https://openreview.net/forum?id=hSyW5go0v8). In *The Twelfth International Conference on Learning Representations*.

[^2]: Sébastien Bubeck, Varun Chandrasekaran, Ronen Eldan, Johannes Gehrke, Eric Horvitz, Ece Kamar, Peter Lee, Yin Tat Lee, Yuanzhi Li, Scott Lundberg, and 1 others. 2023. [Sparks of artificial general intelligence: Early experiments with GPT-4](https://doi.org/10.48550/arXiv.2303.12712). *Preprint*, arXiv:2303.12712.

[^3]: Prateek Chhikara, Dev Khant, Saket Aryan, Taranjeet Singh, and Deshraj Yadav. 2025. [Mem0: Building production-ready AI agents with scalable long-term memory](https://doi.org/10.48550/arXiv.2504.19413). *Preprint*, arXiv:2504.19413.

[^4]: Jizhan Fang, Xinle Deng, Haoming Xu, Ziyan Jiang, Yuqi Tang, Ziwen Xu, Shumin Deng, Yunzhi Yao, Mengru Wang, Shuofei Qiao, Huajun Chen, and Ningyu Zhang. 2026. [LightMem: Lightweight and efficient memory-augmented generation](https://openreview.net/forum?id=dyJ0GWpjJB). In *The Fourteenth International Conference on Learning Representations*.

[^5]: Yunfan Gao, Yun Xiong, Xinyu Gao, Kangxiang Jia, Jinliu Pan, Yuxi Bi, Yi Dai, Jiawei Sun, Meng Wang, and Haofen Wang. 2023. [Retrieval-augmented generation for large language models: A survey](https://doi.org/10.48550/arXiv.2312.10997). *Preprint*, arXiv:2312.10997.

[^6]: Kelvin Guu, Kenton Lee, Zora Tung, Panupong Pasupat, and Mingwei Chang. 2020. [Retrieval augmented language model pre-training](https://proceedings.mlr.press/v119/guu20a.html). In *Proceedings of the 37th International Conference on Machine Learning*, volume 119 of *Proceedings of Machine Learning Research*, pages 3929–3938. PMLR.

[^7]: Zhengbao Jiang, Frank Xu, Luyu Gao, Zhiqing Sun, Qian Liu, Jane Dwivedi-Yu, Yiming Yang, Jamie Callan, and Graham Neubig. 2023. [Active retrieval augmented generation](https://doi.org/10.18653/v1/2023.emnlp-main.495). In *Proceedings of the 2023 Conference on Empirical Methods in Natural Language Processing*, pages 7969–7992, Singapore. Association for Computational Linguistics.

[^8]: Jiazheng Kang, Mingming Ji, Zhe Zhao, and Ting Bai. 2025. [Memory OS of AI agent](https://doi.org/10.18653/v1/2025.emnlp-main.1318). In *Proceedings of the 2025 Conference on Empirical Methods in Natural Language Processing*, pages 25961–25970, Suzhou, China. Association for Computational Linguistics.

[^9]: Patrick Lewis, Ethan Perez, Aleksandra Piktus, Fabio Petroni, Vladimir Karpukhin, Naman Goyal, Heinrich Küttler, Mike Lewis, Wen-tau Yih, Tim Rocktäschel, Sebastian Riedel, and Douwe Kiela. 2020. [Retrieval-augmented generation for knowledge-intensive NLP tasks](https://proceedings.neurips.cc/paper/2020/hash/6b493230205f780e1bc26945df7481e5-Abstract.html). In *Advances in Neural Information Processing Systems*, volume 33, pages 9459–9474.

[^10]: Lei Liu, Xiaoyan Yang, Yue Shen, Binbin Hu, Zhiqiang Zhang, Jinjie Gu, and Guannan Zhang. 2023. [Think-in-memory: Recalling and post-thinking enable LLMs with long-term memory](https://doi.org/10.48550/arXiv.2311.08719). *Preprint*, arXiv:2311.08719.

[^11]: Nelson F. Liu, Kevin Lin, John Hewitt, Ashwin Paranjape, Michele Bevilacqua, Fabio Petroni, and Percy Liang. 2024. [Lost in the middle: How language models use long contexts](https://doi.org/10.1162/tacl_a_00638). *Transactions of the Association for Computational Linguistics*, 12:157–173.

[^12]: Shuochen Liu, Junyi Zhu, Long Shu, Junda Lin, Yuhao Chen, Haotian Zhang, Chao Zhang, Derong Xu, Jia Li, Bo Tang, Zhiyu Li, Feiyu Xiong, Enhong Chen, and Tong Xu. 2026. [PERMA: Benchmarking personalized memory agents via event-driven preference and realistic task environments](https://doi.org/10.48550/arXiv.2603.23231). *Preprint*, arXiv:2603.23231.

[^13]: Adyasha Maharana, Dong-Ho Lee, Sergey Tulyakov, Mohit Bansal, Francesco Barbieri, and Yuwei Fang. 2024. [Evaluating very long-term conversational memory of LLM agents](https://doi.org/10.18653/v1/2024.acl-long.747). In *Proceedings of the 62nd Annual Meeting of the Association for Computational Linguistics (Volume 1: Long Papers)*, pages 13851–13870, Bangkok, Thailand. Association for Computational Linguistics.

[^14]: Ali Modarressi, Ayyoob Imani, Mohsen Fayyaz, and Hinrich Schütze. 2023. [RET-LLM: Towards a general read-write memory for large language models](https://doi.org/10.48550/arXiv.2305.14322). *Preprint*, arXiv:2305.14322.

[^15]: Rodrigo Nogueira and Kyunghyun Cho. 2019. [Passage re-ranking with BERT](https://doi.org/10.48550/arXiv.1901.04085). *Preprint*, arXiv:1901.04085.

[^16]: OpenAI. 2023. [GPT-4 technical report](https://doi.org/10.48550/arXiv.2303.08774). *Preprint*, arXiv:2303.08774.

[^17]: Charles Packer, Sarah Wooders, Kevin Lin, Vivian Fang, Shishir G. Patil, Ion Stoica, and Joseph E. Gonzalez. 2023. [MemGPT: Towards LLMs as operating systems](https://doi.org/10.48550/arXiv.2310.08560). *Preprint*, arXiv:2310.08560.

[^18]: Joon Sung Park, Joseph C. O’Brien, Carrie J. Cai, Meredith Ringel Morris, Percy Liang, and Michael S. Bernstein. 2023. [Generative agents: Interactive simulacra of human behavior](https://doi.org/10.1145/3586183.3606763). In *Proceedings of the 36th Annual ACM Symposium on User Interface Software and Technology*, pages 1–22. Association for Computing Machinery.

[^19]: Zhen Tan, Jun Yan, I-Hung Hsu, Rujun Han, Zifeng Wang, Long Le, Yiwen Song, Yanfei Chen, Hamid Palangi, George Lee, Anand Rajan Iyer, Tianlong Chen, Huan Liu, Chen-Yu Lee, and Tomas Pfister. 2025. [In prospect and retrospect: Reflective memory management for long-term personalized dialogue agents](https://doi.org/10.18653/v1/2025.acl-long.413). In *Proceedings of the 63rd Annual Meeting of the Association for Computational Linguistics (Volume 1: Long Papers)*, pages 8416–8439, Vienna, Austria. Association for Computational Linguistics.

[^20]: Hugo Touvron, Louis Martin, Kevin Stone, Peter Albert, Amjad Almahairi, Yasmine Babaei, Nikolay Bashlykov, Soumya Batra, Prajjwal Bhargava, Shruti Bhosale, and 1 others. 2023. [Llama 2: Open foundation and fine-tuned chat models](https://doi.org/10.48550/arXiv.2307.09288). *Preprint*, arXiv:2307.09288.

[^21]: Di Wu, Hongwei Wang, Wenhao Yu, Yuwei Zhang, Kai-Wei Chang, and Dong Yu. 2025. [LongMemEval: Benchmarking chat assistants on long-term interactive memory](https://doi.org/10.48550/arXiv.2410.10813). In *The Thirteenth International Conference on Learning Representations*.

[^22]: Zhiheng Xi, Wenxiang Chen, Xin Guo, Wei He, Yiwen Ding, Boyang Hong, Ming Zhang, Junzhe Wang, Senjie Jin, and 1 others. 2023. [The rise and potential of large language model based agents: A survey](https://doi.org/10.48550/arXiv.2309.07864). *Preprint*, arXiv:2309.07864.

[^23]: Guangxuan Xiao, Yuandong Tian, Beidi Chen, Song Han, and Mike Lewis. 2024. [Efficient streaming language models with attention sinks](https://doi.org/10.48550/arXiv.2309.17453). In *The Twelfth International Conference on Learning Representations*.

[^24]: Wujiang Xu, Zujie Liang, Kai Mei, Hang Gao, Juntao Tan, and Yongfeng Zhang. 2025. [A-MEM: Agentic memory for LLM agents](https://doi.org/10.48550/arXiv.2502.12110). In *Advances in Neural Information Processing Systems*.

[^25]: Wanjun Zhong, Lianghong Guo, Qiqi Gao, He Ye, and Yanlin Wang. 2023. [MemoryBank: Enhancing large language models with long-term memory](https://doi.org/10.48550/arXiv.2305.10250). *Preprint*, arXiv:2305.10250.

[^26]: Zijian Zhou, Ao Qu, Zhaoxuan Wu, Sunghwan Kim, Alok Prakash, Daniela Rus, Jinhua Zhao, Bryan Kian Hsiang Low, and Paul Pu Liang. 2025. [MEM1: Learning to synergize memory and reasoning for efficient long-horizon agents](https://doi.org/10.48550/arXiv.2506.15841). *Preprint*, arXiv:2506.15841.