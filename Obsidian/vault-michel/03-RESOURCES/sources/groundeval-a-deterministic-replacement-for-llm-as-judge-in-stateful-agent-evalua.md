---
title: "GroundEval: A Deterministic Replacement for LLM-as-Judge in Stateful Agent Evaluation"
type: source
source: "Clippings/GroundEval A Deterministic Replacement for LLM-as-Judge in Stateful Agent Evaluation.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
Before letting an agent operate over real context, can you prove it used the right evidence? GroundEval turns that question into a deterministic test of what the agent searched, fetched, cited, and was permitted to access. In one case study, two frontier LLM judges scored a plausible agent response above 0.85.

## Argumentos principais
### 1.1 The problem
LLM agents increasingly answer questions using retrieved documents, memory stores, tool calls, event logs, ticket histories, Slack messages, CRM records, code repositories, and role-scoped enterprise data. In these systems, correctness is not only about the final answer. The agent must also answer from the right evidence.
A model can produce the right answer while still failing the task if it used information the actor could not have known, relied on artifacts created after the relevant time, crossed role or subsystem boundaries, skipped required search steps, inferred absence without checking the expected places, reversed cause and effect, or cited plausible but invalid evidence.

### 1.2 Thesis
Each of these failures has the same shape: a model state or governance constraint was violated, not a reasoning error. A memory system may retrieve a correct fact from the wrong user. A RAG pipeline may answer correctly but cite an inaccessible document. A tool-using agent may claim no postmortem exists without searching the postmortem repository. An enterprise agent may answer using future information relative to the actor’s point in time.
Final-answer correctness is insufficient because correctness must be evaluated against the evidence path: what the agent was allowed to know, when it could know it, what it searched, what it cited, and whether absence or counterfactual claims were justified by state. A judge model reading a trace cannot deterministically verify that an artifact was outside an actor’s visibility cone at a specific timestamp unless the access policy, event log, artifact timestamps, and expected search spaces are also supplied in machine-checkable form. Once those structures are supplied, the central correctness signal is no longer the judge’s plausibility assessment; it is the state contract itself.
#### State-invalid correctness.

### 1.3 Failure classes
Table 1 summarizes the failure class targeted by GroundEval. The common pattern is that the final answer may appear correct or plausible, while the path by which the agent reached it violates the task state.
| Failure class | Example | Why final-answer scoring misses it | GroundEval signal |
| --- | --- | --- | --- |

### 1.4 Contribution
This paper introduces GroundEval, a deterministic framework for evaluating agents that reason over state. The contributions are:
1. A general evaluation contract based on an event log, artifact corpus, access policy, and evaluation configuration, from which question contracts and expected answer schemas are derived without a judge.
2. Three reusable evaluation tracks (Perspective, Counterfactual, and Silence) with a dual scoring model that distinguishes true answers from validly reached answers, including an explicit violation-adjusted compliance factor.

### 2.1 The rise of stateful agents
Agents are no longer stateless chatbots. They increasingly operate over long-running memory, external tools, private workspaces, enterprise systems, multi-user context, and time-dependent histories. This changes the evaluation problem: the agent must not only answer, but answer under constraints.
Consider: Based only on what Morgan had access to as of March 5, could Morgan have known that Acme was at churn risk? An agent may answer “yes” because Acme later appeared in a churn report on March 12. The answer may match the world state, but it violates the question’s temporal boundary. The same failure appears in any setting where state boundaries matter: a coding agent may answer a question about a repository by finding a call site in a draft branch that was never merged, or by grepping a commit outside the question’s intended scope. In both cases the answer is factually defensible under some reading of the state and still invalid under the evaluation’s constraints.

### 2.2 Final-answer and LLM-as-judge evaluation
LLM-as-judge methods, most notably MT-Bench and Chatbot Arena [^1], provide scalable approximations of human preference judgments. G-Eval [^2] extends this with chain-of-thought-style evaluation steps, showing stronger alignment with human judgments than earlier automatic metrics. However, the limitations of LLM-as-judge for state-grounded evaluation are not merely empirical: documented position bias [^3], self-preference bias [^4], and verbosity effects [^5] compound a more fundamental structural problem.
OrgForge-IT [^10], a benchmark built on the OrgForge simulation framework [^11] for insider threat detection, demonstrates a related prompt-sensitivity problem in simulator-grounded evaluation: models can preserve the apparent substance of their reasoning while changing the output form enough to break deterministic downstream interpretation. Under loosened prompting, models still identify the relevant incident, victim, and mechanism, but fail to emit the canonical fields required by the scorer. A prose judge may credit the response because the reasoning appears semantically correct; a downstream system cannot. GroundEval generalizes this concern from output form to evidence path: the question is not whether the explanation is plausible, but whether the response satisfies a machine-checkable contract over state, access, time, and evidence.

### 2.3 Process supervision and reasoning-path evaluation
Let’s Verify Step by Step [^6] demonstrates that outcome-only supervision can reward incorrect reasoning that reaches a correct final answer, motivating process-level supervision. However, chain-of-thought explanations are not always faithful representations of a model’s true reasoning process [^7] [^8]. GroundEval is closer to process supervision than outcome supervision in spirit, but it evaluates externally observable traces rather than private reasoning traces, avoiding dependence on chain-of-thought faithfulness entirely.

### 2.4 Agent trajectory and tool-use benchmarks
Recent agent benchmarks increasingly evaluate intermediate behavior rather than final answers alone. TRAJECT-Bench [^9] introduces trajectory-level diagnostics for tool selection, argument correctness, and dependency ordering, explicitly arguing that final-answer evaluation overlooks these mechanics. AgentBoard [^13] argues that final success rate reveals little about agent process and introduces fine-grained progress metrics across multi-turn environments. AgentRewardBench [^14] studies whether LLM judges can reliably evaluate web-agent trajectories. These works establish that trajectories warrant evaluation, but they focus on tool-use mechanics and progress rather than state validity. GroundEval extends trajectory evaluation to access control, temporal horizon, evidence visibility, causal grounding, and verified absence, and constructs deterministic ground-truth contracts so these failures can be scored without a judge model.

### 2.5 RAG, attribution, and evidence-grounded generation
RAGAS [^15] and ARES [^16] evaluate retrieval-augmented generation pipelines along dimensions such as faithfulness, context precision, and context recall. RAGTruth [^17] shows that unsupported or contradictory claims remain common even when systems retrieve context. The Attributable to Identified Sources (AIS) framework [^18] asks whether generated claims are attributable to identified sources, and WebGPT [^19] establishes early precedent for evidence collection as a first-class model behavior. These frameworks evaluate whether retrieved or cited evidence supports an answer. GroundEval asks a stricter question: whether the evidence path was valid under the evaluation state, including whether sources were reachable from the actor’s perspective at the relevant time and whether the agent searched the required evidence space before answering.

### 2.6 Long-term memory benchmarks
LoCoMo [^20] evaluates long-term conversational memory across temporal and causal dynamics, finding that long-context and RAG approaches still lag human performance. LongMemEval [^21] evaluates information extraction, multi-session reasoning, temporal reasoning, knowledge updates, and abstention, reporting large performance drops under sustained interaction. LongMemEval-V2 [^22] extends this toward agentic, environment-specific memory use.
These benchmarks evaluate whether systems answer correctly using long-term memory. PrecisionMemBench [^12] addresses a distinct gap at the retrieval layer: whether memory systems retrieve the right beliefs independently of the generative model, finding that comparison systems achieve mean retrieval precision of 0.05 to 0.08 on active-assertion cases while achieving recall of 1.0, the indiscriminable full-corpus retrieval pattern. GroundEval is complementary at a different layer: it evaluates whether the agent used retrieved evidence according to valid state constraints, whether sources were accessible, time-bounded, and sufficient.

### 3.1 Core evaluation contract
GroundEval represents an evaluation run as a pipeline:
Figure 1: GroundEval pipeline. A machine-readable contract over the event log, artifact corpus, access policy, and evaluation configuration generates question contracts and expected answer schemas. Context mode observes evidence through structured artifact citations, while tool mode observes evidence through a gated fetch/search trace. Both modes terminate in the same deterministic scorer, which produces answer, trajectory, and compliance-adjusted scores without an LLM judge.
The four inputs are an event log (a timestamped stream of actor, artifact, and event-type records), an artifact corpus (the documents or records the agent can fetch or search), an access policy (subsystem visibility and time boundaries per actor or role), and an evaluation config (causal link specs, silence pair specs, perspective balance, and corpus locations). Together these form a machine-readable ground-truth contract from which question contracts and expected answer schemas are derived.

### 3.2 Context mode and tool mode
As shown in Figure 1, the framework supports two agent architectures. In context mode, the agent receives a pre-filtered context window constructed from artifacts that satisfy the applicable access and temporal constraints, and submits a structured answer with an explicit evidence\_artifacts field. Citation discipline is scored by checking submitted artifact IDs against the injected context, the actor’s visibility cone, and the temporal horizon; no judge is needed to interpret prose. In tool mode, the agent receives gated fetch\_artifact and search\_artifacts calls mediated by a runtime that enforces constraints at the point of the call and records a full trace. Search results are stripped to metadata fields so the agent must call fetch\_artifact for full content, encouraging deliberate retrieval rather than passive corpus absorption. Tool mode provides direct observability of retrieval behavior; context mode observes the evidence path only through the citations the agent submits.
In addition to structured tool and citation events, GroundEval emits a per-question diagnostic trace containing tool calls, tool results, submitted answers, errors, and optional agent messages emitted during the run. These diagnostics are not used for scoring, but rather they provide an inspection layer for developers: the deterministic scorer records whether the path was valid, while the diagnostic trace helps explain how the agent constructed that path and where the failure occurred.
The framework supports multiple model providers through a thin interface requiring single-turn completion and agent loop execution, separating model-specific tool-calling formats from the provider-agnostic evaluation contract. Each question includes an expected answer schema, and the agent must submit a final answer matching that schema, eliminating ambiguity in scoring and avoiding brittle post-hoc parsing of free-text responses.

### 4 Formal Properties
The following properties make the determinism claim falsifiable and bound the scope of the evaluation. They also underpin GroundEval’s value as a regression gate: because scores are deterministic given the same contract and trace, any change in score across model versions is attributable to a change in agent behavior rather than to evaluator variance.
Property 1 (Judge-independence of answer scores). Answer scores are a function of ground truth derived from the event log, artifact corpus, and access policy, not of another model’s judgment.
Property 2 (Determinism of trajectory scores). Trajectory scores are deterministic given the same event log and the same recorded tool trace. Re-scoring an identical trace under an identical configuration always yields an identical trajectory score.

### 5 Evaluation Tracks
All three tracks share the same scoring structure: an answer score checking whether the structured final answer matched ground truth, and a trajectory score checking whether the agent’s evidence path was valid under the evaluation state. Ground truth in each track is derived from a configured spec that declares event types, join conditions, and expected outcomes. Track-specific weights are given in Table 2.

### 5.1 Perspective
The Perspective track tests whether an agent respects what an actor could have known at a specific time. A representative question: Based only on what Morgan had access to as of March 5, could Morgan have known that Acme was at churn risk? Ground truth includes the actor’s role and subsystem access, the as-of timestamp, the set of visible artifacts, blocked subsystems, and whether the actor could have known the answer. Question generation balances positive cases (actor could have known), negative permission cases (actor lacked access), and negative temporal cases (the relevant artifact existed only after the as-of time). The track is designed to catch future-context leakage, cross-user leakage, subsystem access violations, role-boundary violations, and correct answers reached from invalid evidence. Perspective weights trajectory heavily because the central question is epistemic: not whether a fact is true, but whether this actor could have known it then.
Figure 2: The Visibility Cone in the Perspective Track. GroundEval verifies that the agent’s trajectory only ingests evidence inside the actor’s valid temporal horizon ($T\leq T_{query}$) and role-based permissions boundary.


## Key insights
- Gated tool mode. The agent answers using fetch\_artifact and search\_artifacts calls mediated by the gated runtime described in Section 3.2. All retrieval is recorded, and actor-gate, subsystem, and horizon violations are detected at the point of the call.
- Zero-shot, no-artifact mode. The agent receives the question alone, with no corpus access and no tool calls. This condition establishes what the model can answer from parametric knowledge and surface-level question phrasing, with no opportunity to retrieve evidence.
- GroundEval turns that question into a deterministic test of what the agent searched, fetched, cited, and was permitted to access.
- In one case study, two frontier LLM judges scored a plausible agent response above 0.85.
- But the trace told a different story: the agent had never retrieved the artifact its answer depended on, yielding a GroundEval score of 0.000.
- We introduce GroundEval, a judge-free framework for evaluating agents against grounded, time-bounded, and access-controlled evidence.
- GroundEval uses a domain configuration to generate questions, lets the agent choose how to answer, and then scores both the final answer and the recorded trajectory that produced it.
- The benchmark targets three failures that LLM-as-judge evaluation struggles to detect: whether an agent checked before claiming absence, reasoned only from evidence available to the actor at the relevant time, and used the correct causal mechanism rather than a plausible one.
- GroundEval exposes when plausible answers rest on invalid evidence paths, and produces structured per-question diagnostics that pair tool activity with the agent’s turn-level narration, making each score inspectable rather than merely reported.
- ## 1 Introduction

### 1.1 The problem

LLM agents increasingly answer questions using retrieved documents, memory stores, tool calls, event logs, ticket histories, Slack messages, CRM records, code repositories, and role-scoped enterprise data.

## Exemplos e evidências
See original source at `Clippings/GroundEval A Deterministic Replacement for LLM-as-Judge in Stateful Agent Evaluation.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/Rust]]

## Minha Síntese
**O que muda:** A ser analisado em revisão manual.

**Conexão pessoal:** A ser conectado com projetos/estudo atuais.

**Próximo passo:** Nenhum próximo passo imediato.
