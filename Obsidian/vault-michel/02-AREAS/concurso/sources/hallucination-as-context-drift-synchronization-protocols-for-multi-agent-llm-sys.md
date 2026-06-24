---
title: "Hallucination as Context Drift: Synchronization Protocols for Multi-Agent LLM Systems"
type: source
source: "Clippings/Hallucination as Context Drift Synchronization Protocols for Multi-Agent LLM Systems.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [concurso, source-page]
---

## Tese central
Multi-agent LLM systems routinely produce hallucinated outputs that cannot be explained by model deficiencies alone. We argue that a significant class of these failures arises not from model incapacity but from *context drift*: the divergence of internal knowledge states between concurrently operating agents. When agents enter a collaborative task with mismatched or stale representations of shared world state (different environmental assumptions, asynchronous information updates, or inconsistent

## Argumentos principais
### 1 Introduction
As LLMs are deployed in multi-agent configurations, where specialized agents collaborate toward a shared goal, they increasingly exhibit communication failures analogous to two people reasoning clearly from different information: each agent is correct in isolation, yet together they contradict. The literature labels this *hallucination*, and the dominant response has been to improve the language models themselves: better training data, reinforcement learning from human feedback, chain-of-thought prompting [^1] [^2] [^3]. Yet model-level improvements have not eliminated the problem in multi-agent deployments [^4] [^5]. We propose that a significant fraction of multi-agent hallucinations have a different root cause, one no amount of per-agent fine-tuning can address. When agents hold divergent internal representations of shared state, correct individual reasoning produces collectively incorrect outputs. The failure is in the *interface*, not the model.
We formalize this as context drift: the progressive divergence of agent knowledge states during asynchronous collaboration. Context drift occurs across three primary dimensions:
- Spatial context: agents hold different beliefs about the same environment (e.g., different location data, different world states).

### 2.1 Multi-Agent LLM Systems
The deployment of LLMs in multi-agent configurations has accelerated significantly. AutoGen [^5] provides a framework for orchestrating conversations between multiple LLM-backed agents, demonstrating that agent specialization improves task performance on complex benchmarks. MetaGPT [^6] assigns software engineering roles to agents, enabling division of labor over extended coding tasks. LangGraph [^7] formalizes agent interaction as a stateful directed graph. CrewAI [^8] emphasizes role-based agent hierarchies for autonomous task decomposition. AgentVerse [^9] introduces dynamic team composition for collaborative problem-solving tasks.
A consistent finding across these frameworks is that coordination quality degrades with task complexity and agent count [^4] [^10]. Cemri et al. [^11] provide a systematic empirical taxonomy of these failures (MAST), cataloguing 14 failure modes across 1,600+ annotated traces from seven agent frameworks; they find that inter-agent misalignment constitutes a distinct and pervasive failure category, separate from individual model errors. We argue this attribution is incomplete and that a dedicated synchronization protocol addresses the underlying cause.

### 2.2 Hallucination in LLMs
Hallucination mitigation strategies include retrieval augmentation [^12], self-consistency [^13], and calibration [^14]. In multi-agent settings, multi-agent debate [^15] has agents challenge each other’s responses. However, when inconsistency arises from agents with *genuinely different context histories*, neither self-consistency nor debate will surface the underlying cross-agent state mismatch. AgentHallu [^16] demonstrates that hallucinations propagate along multi-agent trajectories, and a recent taxonomy [^17] explicitly identifies *communication hallucinations* from inter-agent inconsistency as a distinct category requiring dedicated mitigation.

### 2.3 Distributed State and Drift Formalization
The problem of shared state consistency in distributed systems is well-studied via Lamport clocks [^18], vector clocks [^19], and the CAP theorem [^20]. These ideas have been applied to robotic multi-agent systems [^21] but their application to LLM agents, where “state” is unstructured natural language, has received limited attention. Concurrent work introduces the Agent Stability Index (ASI) [^22], a 12-dimensional post-hoc metric for behavioral drift. Our CDS differs: it is a lightweight pairwise scalar computed online from cosine distance between context embeddings, designed to trigger proactive synchronization with $O(n\lambda)$ overhead. A related approach [^23] models drift as KL divergence, showing that context drift converges to stable equilibria; SSVP’s interventions can be understood as perturbations resetting the system toward a lower-divergence equilibrium before it settles. MemoryBank [^24] and Generative Agents [^4] address within-agent context management; our work targets cross-agent alignment as a distinct failure mode [^25].

### 3.1 Agent Context Model
We model each agent $i$ at time $t$ as maintaining a context vector $\mathbf{c}_{i}^{t}\in\mathbb{R}^{d}$, a compressed semantic embedding of the agent’s current internal state:
$$
\mathbf{c}_{i}^{t}=f_{\theta}\left(\mathbf{s}_{i}^{t}\,\|\,\mathbf{h}_{i}^{t}\,\|\,\mathbf{g}_{i}^{t}\right)

### 3.2 Context Divergence Score
###### Definition 1 (Context Divergence Score).
Given two agents $i$ and $j$ with context vectors $\mathbf{c}_{i}^{t}$ and $\mathbf{c}_{j}^{t}$ at time $t$, the Context Divergence Score (CDS) is:
$$

### 3.3 Shared State Verification Protocol
The Shared State Verification Protocol (SSVP) operates as a thin coordination layer between agents. Algorithm 1 describes the core procedure.
Algorithm 1 Shared State Verification Protocol (SSVP)
Agents $\mathcal{A}=\{a_{1},\ldots,a_{n}\}$, threshold $\tau$, sync interval $\Delta t$

### 4.1 Task and Agents
We evaluate SSVP on a multi-agent travel planning task. Three agents collaborate to produce a complete, internally consistent travel itinerary:
- Planner: responsible for overall itinerary structure, day-by-day schedule, and activity sequencing.
- Booking: responsible for flight, hotel, and transport logistics.

### 4.2 Implementation
All agents are implemented using the Anthropic Claude Haiku API (claude-haiku-4-5-20251001). Inter-agent communication is implemented as a Python message-passing layer with explicit message headers (sender, timestamp, message type). Context embeddings use sentence-transformers (all-MiniLM-L6-v2) to produce 384-dimensional vectors. CDS is computed as cosine distance per Eq. (2). The full implementation (code, prompts, scenario definitions, and evaluation rubrics) will be released upon publication.

### 4.3 Baselines
- No-Sync: agents communicate only through task-directed messages; no context synchronization.
- Full-Broadcast: agents broadcast their complete context at every reasoning step (upper bound on synchronization, lower bound on efficiency).

### 4.4 Evaluation Metrics
Hallucination Rate (HR): the fraction of agent assertions that are factually inconsistent with ground truth information provided at initialization. Per trial, we sample up to 8 agent outputs and evaluate each independently. Structured facts account for 78% of evaluated assertions; an independent LLM judge handles the remaining 22% of free-text claims. Inter-rater agreement between two independent judge calls on 20 sampled outputs yielded $\kappa=0.79$ (“substantial” agreement per Landis & Koch, 1977), validating judge consistency.
Task Coherence Score (TCS): a 0–1 score measuring internal consistency of the final produced itinerary on five dimensions (date, location, budget, schedule, and recommendation accuracy), assigned by an independent LLM judge (Claude Haiku).
Recovery Steps: the number of additional agent exchanges required after a contradiction is detected (lower is better).

### 4.5 Threshold Calibration
We set $\tau=0.25$ based on a calibration analysis of the unmodified (no-sync) CDS distribution. Across 30 no-sync trials $\times$ 6 steps = 180 observations, only 2 steps (1.1%) naturally exceed $\tau=0.25$, confirming a low false-positive rate. At $\tau=0.22$ the false-positive rate rises to 5.6%; at $\tau=0.28$ it drops to 0%. We select $\tau=0.25$ as the lowest value that keeps false positives below 2%. All 30 SSVP trials trigger exactly 2 synchronization events per trial (at steps 2 and 4), confirming that injected mismatches consistently push system CDS above this threshold.

### 5.1 Hallucination Rate
Table 1 reports hallucination rates across 30 trials per main condition ($n=75$ total, travel domain). No-Sync agents produce factual contradictions in 49.2% of sampled assertions. SSVP reduces this to 46.3%, a 5.9% directional reduction ($d=0.30$, not statistically significant at $n=30$). Strikingly, Full-Broadcast *increases* hallucination to 65.8%, which is 34% above the no-sync baseline ($p=0.0022$, $d=1.18$). This contamination effect arises because indiscriminate context broadcast propagates the Booking agent’s injected erroneous destination to all agents, causing all three to simultaneously assert the wrong city.
Table 1: Hallucination rate and task coherence by condition (95% CI; travel domain). Full-broadcast significantly increases HR (the contamination effect), while SSVP avoids it.
<table><tbody><tr><td>Condition</td><td>HR (95%CI)</td><td>TCS (95%CI)</td><td>Calls</td><td>Sig.</td></tr><tr><td>No-Sync</td><td>0.492 <math><semantics><mo>±</mo> <annotation>\pm</annotation></semantics></math> 0.039</td><td>0.342 <math><semantics><mo>±</mo> <annotation>\pm</annotation></semantics></math> 0.043</td><td>18</td><td>ref</td></tr><tr><td>SSVP (ours)</td><td>0.463 <math><semantics><mo>±</mo> <annotation>\pm</annotation></semantics></math> 0.031</td><td>0.350 <math><semantics><mo>±</mo> <annotation>\pm</annotation></semantics></math> 0.047</td><td>53</td><td>ns</td></tr><tr><td>Full-BC</td><td>0.658 <math><semantics><mo>±</mo> <annotation>\pm</annotation></semantics></math> 0.084</td><td>0.229 <math><semantics><mo>±</mo> <annotation>\pm</annotation></semantics></math> 0.051</td><td>126</td><td>***</td></tr><tr><td colspan="5">No-Sync/SSVP: <math><semantics><mrow><mi>n</mi> <mo>=</mo> <mn>30</mn></mrow> <annotation>n=30</annotation></semantics></math>; Full-BC: <math><semantics><mrow><mi>n</mi> <mo>=</mo> <mn>15</mn></mrow> <annotation>n=15</annotation></semantics></math>, reduced due to <math><semantics><mrow><mo>∼</mo> <mn>7</mn> <mo>×</mo></mrow> <annotation>\sim 7\times</annotation></semantics></math> API cost per trial. *** <math><semantics><mrow><mi>p</mi> <mo><</mo> <mn>0.01</mn></mrow> <annotation>p<0.01</annotation></semantics></math> vs. both baselines; ns = not significant.</td></tr></tbody></table>

### 5.2 Task Coherence Score
No-Sync achieves a mean TCS of 0.342 and SSVP achieves 0.350, a negligible, non-significant difference ($p=0.80$, $d=0.06$). Full-Broadcast degrades TCS to 0.229, a 33% drop below no-sync ($p=0.0024$, $d=1.02$). This degradation is consistent with the HR contamination effect: agents that have incorporated the injected erroneous destination into their context produce itineraries with systematic location inconsistencies.

### 5.3 CDS Dynamics
Figure 1 shows mean $\mathrm{CDS}_{\mathrm{sys}}(t)$ across reasoning steps. No-Sync CDS stabilizes around 0.18–0.19, reflecting persistent bounded divergence. Full-Broadcast achieves the lowest CDS (0.097–0.107 from step 2), yet this low-CDS state corresponds to the *highest* hallucination rate, confirming that converging on an erroneous shared state reduces CDS while worsening outputs. The Pearson correlation between $\mathrm{CDS}_{\mathrm{sys}}$ (max) and HR in no-sync is $r=-0.03$: CDS is not predictive of HR without an intervention. Its value is *prescriptive*: it identifies *when* to synchronize, not whether hallucination has occurred.
Figure 1: System-level CDS sys {}\_{\\text{sys}} over reasoning steps. SSVP synchronization events (triangles) mark interventions at τ = 0.25 \\tau=0.25. Low Full-BC CDS coexists with high HR, reflecting convergence on an erroneous shared state.


## Key insights
- Spatial context: agents hold different beliefs about the same environment (e.g., different location data, different world states).
- Temporal context: agents operate with information from different timestamps; one agent’s “current” state is another’s stale cache.
- Task context: agents accumulate different task histories, leading to divergent assumptions about what has been decided, attempted, or ruled out.
- Planner: responsible for overall itinerary structure, day-by-day schedule, and activity sequencing.
- Booking: responsible for flight, hotel, and transport logistics.
- Advisor: responsible for destination-specific recommendations: weather, local conditions, dining, cultural considerations.
- No-Sync: agents communicate only through task-directed messages; no context synchronization.
- Full-Broadcast: agents broadcast their complete context at every reasoning step (upper bound on synchronization, lower bound on efficiency).

## Exemplos e evidências
See original source at `Clippings/Hallucination as Context Drift Synchronization Protocols for Multi-Agent LLM Systems.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/Claude]]
- [[03-RESOURCES/entities/Uber]]
- [[03-RESOURCES/entities/Rust]]
- [[03-RESOURCES/entities/Python]]
