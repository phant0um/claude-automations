---
title: "Agent Behavior Mining: Generative AI Agent Governance in Business Processes"
type: source
source: "Clippings/Agent Behavior Mining Generative AI Agent Governance in Business Processes.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
As organizations increasingly deploy generative AI agents to automate business processes, they face a governance dilemma: although these agents can increase operational flexibility, their non-deterministic nature challenges the control and standardization that Business Process Management seeks to enforce. This paper addresses this *invisible autonomy risk* by introducing *Agent Behavior Mining*, a governance capability that enables the application of process mining techniques to render generativ

## Argumentos principais
### 1 Introduction
As organizations increasingly deploy generative AI (GenAI) agents in business processes, they face an *autonomy-control paradox* [^16]: granting agents autonomy can increase operational flexibility, yet Business Process Management (BPM) governance depends on control, standardization, and auditable compliance [^22]. This paradox exposes organizations to an *invisible autonomy risk*: unlike deterministic, rule-based task automation, GenAI agents driven by large language models (LLMs) operate through opaque, non-deterministic reasoning. This opacity creates risks, including undetected policy violations and compliance failures, as well as unmanaged resource consumption [^28].
Process owners face a *black box challenge*: they observe outputs but lack visibility into why decisions were made and how resources were used. Existing BPM governance mechanisms, built for repeatable execution, lack constructs to analyze probabilistic behavior of GenAI agents, rendering governance difficult.
To address these challenges, we propose Agent Behavior Mining (ABM) as a technology-enabled BPM governance capability that operationalizes visibility for organizational control. ABM establishes (1) *observability* of agent decisions, (2) *accountability* for agent outcomes, and (3) *controllability* by enabling targeted interventions such as policy guardrails and prompt updates. This supports the detection of compliance drift, containment of variable costs, and the development of empirical trust needed to scale agent adoption. We make three contributions:

### 2 Background
Our work relates to governance in BPM, algorithmic accountability and transparency, process mining, and tracing GenAI agents.
Governance in BPM. Governance in BPM provides the structural mechanisms, decision rights, accountability frameworks, and performance metrics necessary to align process execution with organizational strategy. This aligns with the six core elements of BPM, which position governance as a distinct capability alongside strategic alignment and people [^22]. Seminal work by Weill and Ross [^27] defines IT governance as the specification of decision rights to encourage desirable behavior. In traditional BPM, this governance relies on bounded, deterministic workflows where deviations are treated as manageable exceptions. However, the deployment of GenAI agents creates an autonomy-control paradox [^16]: organizations want agents to be flexible, yet this flexibility undermines the standardization that governance requires. Unlike earlier forms of task automation, such as Robotic Process Automation [^2] or classical MAS [^14], which followed strict rules and protocols, GenAI agents operate through probabilistic reasoning. This introduces risks of unobservable compliance drift that traditional governance mechanisms struggle to detect.
Algorithmic Accountability and Transparency. As algorithms take over operational tasks, they create what Kellogg et al. call a new *contested terrain of control* [^15], widening an *accountability gap* [^20] where the inability to monitor run-time execution prevents responsible AI operationalization. In the context of business processes, algorithmic accountability requires that an automated system provides a justifiable, auditable record of its decision-making—not just of *what* it decided, but of *why*. As AI systems become embedded in core business operations, this form of transparency becomes a prerequisite for effective governance. Prior work on human trust in AI shows that opaque decision logic can undermine trust, as process owners cannot readily understand why a system acted as it did [^11]. Recent regulatory frameworks, such as the EU AI Act or the NIST AI Risk Management Framework, codify the need for explainability and auditability in high-risk AI systems. However, these frameworks often remain high-level principles without specifying operational mechanisms for business processes. We argue that ABM addresses this gap by repositioning agent governance from a strategic liability into an organizational capability, enabling the behavioral transparency necessary for accountable GenAI agent deployment.

### 3 The Invisible Autonomy Risk
Figure 1: Order-to-Cash multi-agent system with four GenAI agents.
Consider a MAS that manages an O2C process for a coffee shop (Figure 1). Four autonomous GenAI agents coordinate the work: the *Order Agent* interprets customer intent, the *Inventory Agent* manages stock, the *Barista Agent* executes production, and the *Customer Service Agent* adjudicates refunds.
Traditional workflows embed business logic explicitly in process models, making decisions traceable to their triggering rules. GenAI agents internalize logic probabilistically, creating a governance blind spot: when the *Order Agent* handles “large caramel latte, oat milk, refund if delayed,” it interprets ambiguous terms without exposing its reasoning—leaving managers unable to verify whether a policy was applied or a new rule was hallucinated. This opacity compounds into systemic risk: unnecessary restocking by the *Inventory Agent* becomes an unmonitored financial leak, and adversarial prompts can silently induce the *Customer Service Agent* to grant undeserved refunds—both undetectable without access to reasoning chains.

### 4 Event Data Model for Agent Behavior
In this section, we present an event data model for GenAI agent behavior by operationalizing the ASED meta-model [^24] and extending XES [^12] with agent-specific attributes (Contribution 1). While XES provides the foundation for event representation, it lacks constructs for the specific characteristics of GenAI agents. We therefore derive requirements from operational goals and industry standards (Section 4.1) to instantiate our model (Section 4.2).

### 4.1 Model Requirements
We derive requirements from two perspectives: *goal-oriented*, addressing the operational objectives of GenAI agent deployment, and *system-driven*, stemming from agent architectures and observability standards like OpenTelemetry [^18].
Goal-Oriented Requirements. Adopting the *Devil’s Quadrangle* [^8], we view GenAI agent deployment as process redesign targeting four performance dimensions: cost, time, quality, and flexibility.
R1 (Cost). Unlike traditional software, GenAI agents incur direct per-action costs via token usage. The model must correlate individual steps with their exact financial impact.

### 4.2 Event Data Model
Based on the above requirements, we propose the event data model visualized in Figure 2. The model extends XES and can complement previous event data models—specifically ASED [^24] and OCED [^9] —by adding GenAI-specific event types and attributes that are absent from existing event data models (Section 2).
Figure 2: Agent Event Concept Hierarchy
The event data model is organized as a shallow hierarchy where all events inherit standard attributes from the XES concept, org, and time extensions. The prompt event type captures user inputs within single or multi-turn conversations, establishing the context for subsequent system actions. In multi-turn settings, a case corresponds to a complete conversation session: each user turn is recorded as a prompt event sharing the same case\_id, so the full dialogue context is preserved as a single traceable unit. All remaining event types are agent-centric, derived from an abstract AgentEvent type that factors out common attributes. Specific event types include agent\_start and agent\_finish, which track the overall execution time of agent tasks (R2). Agent operations are captured through call\_llm and execute\_tool, while transfer\_to\_agent represents delegation, a fundamental interaction pattern in MAS (R5). Standard attributes are adapted to support business-oriented analysis. concept:name and concept:instance capture the technical event type and a human-readable activity name, respectively (R4); grouping events by these names enhances understandability in process visualizations (e.g., DFGs). To assess costs (R1), various \*\_tokens attributes track LLM consumption. For long-running tasks, we introduce a duration attribute to complement the standard time:timestamp (R2). To ensure quality and transparency (R3), internal reasoning is tracked via ai:response\_thought, while ai:error\* attributes detail execution failures. Table 1 provides a traceability matrix summarizing how each requirement is satisfied by the attributes in the event data model. Crucially, most ai:\* attributes align with OpenTelemetry GenAI semantic conventions (R6), ensuring broad compatibility and semantic coverage. Although not formally defined as an XES extension, the model builds upon the XES standard [^12] and corresponding event logs are readily usable by process mining tools supporting the standard (R7). By satisfying these requirements (R1–R7), our model provides a practical foundation for capturing the nuances of GenAI agent behavior, enabling the practical application of existing process mining techniques, as demonstrated in the following section.

### 5 Agent Behavior Mining in Practice
This section demonstrates how ABM can address governance challenges in GenAI agents. We implemented the multi-agent O2C scenario <sup>1</sup> to generate event data based on our proposed event data model; the repository includes the implementation, generated event logs, survey instruments, and evaluation dashboards to support conceptual reproducibility. Subsequently, we conducted a two-phase study where we first applied ABM to surface governance-supporting insights (Contribution 2). We then validated the perceived utility of these insights in a study with 18 industry practitioners (Contribution 3).

### 5.1 Study Design
We followed Design Science Research [^13] and conducted an exploratory study to assess artifact utility in a realistic organizational context. We pursued *analytical generalization* [^30], using the findings to refine theoretical propositions about GenAI agent governance rather than to estimate population-level effects. We recruited 18 practitioners via purposive sampling to ensure adequate diversity of roles: strategic (4 Enterprise Architects, 1 Product Owner, 1 IT Manager), operational (6 Consultants, 2 Process Managers, 1 Business Analyst), and control (1 Security Expert, 1 Data Scientist, 1 Developer). Participants’ AI experience ranged from none (2) to beginners (9), intermediate (6) and expert (1), supporting assessment across skill levels.
Data Collection Protocol. We used a four-phase protocol to reduce common method bias [^19]: (1) Context setting (30 min) with a standardized briefing on invisible autonomy risks and the O2C architecture; (2) Simulation (60 min) in which participants interacted with four GenAI agents (Order, Inventory, Barista, Service), generating 371 execution traces, including induced failures (e.g., hallucinations, loop errors), which we converted to our event data model via a framework-agnostic, extensible approach compatible with major agent frameworks; (3) Insight elicitation (30 min) where participants explored four dashboard views—process discovery, conformance checking, performance analysis, and variant analysis—and were asked to identify governance-relevant observations, including compliance violations, cost anomalies, and behavioral variants; and (4) a Feedback phase (20 min) comprising a structured survey [^10] covering *Perceived Usefulness* (TAM-based [^5]), *Transparency*, and *Adoption Barriers*, with Likert items and open-ended responses analyzed through thematic analysis [^4]: responses were inductively coded by one researcher, grouped into recurring themes, and reviewed by a second researcher to ensure consistency. Validity was strengthened through anonymized responses, pilot-tested instruments, and immediate post-exercise administration. All agents utilized the gpt-4.1 model; implications of this choice are discussed in Section 6.3.

### 5.2 Operational Risk Detection
Leveraging the 371 execution cases of the O2C coffee shop example, we instantiate our event data model to validate its utility for real-world governance.
Process Discovery. The directly-follows graph (Figure 4) captures agent behavior and interactions (R5). The *Order Agent* orchestrates 1.2k instances via process order (348) and delegates to *Inventory Agent* (191) or *Customer Service Agent* (66); *Inventory Agent* executes check inventory (249) before handing off to *Barista Agent* (180). For process owners, this transforms the *black box* of agents’ thought processes into a tangible process map.
Figure 4: Process Discovery: Visibility of Execution Patterns.

### 5.3 Practical Utility Assessment
We complemented the quantitative log analysis with practitioner feedback to assess the artifact’s perceived value for decision-making (Figure 8). Note that this phase measures TAM-based perceived usefulness rather than demonstrated governance outcomes: no objective measures of task accuracy or decision quality were collected, and participants reviewed dashboards under laboratory conditions without making real governance decisions.
(a) Most valuable insight
(b) Transparency improvement

### 6 Discussion
As organizations move from GenAI agent pilots to productive deployments in their business processes, governance shifts from technical feasibility to operational control. This section examines the implications of ABM, outlines considerations for BPM research, and discusses validity threats and limitations.

### 6.1 Implications for AI Governance
Based on the observability and transparency gains evidenced above, we identify the following areas where ABM could support the governance of GenAI agents as an organizational capability, though empirical validation in production settings remains a direction for future work.
Operationalized Compliance. Conformance checking detected non-deterministic failures, such as the *Order Agent* omitting calculate\_total (Figure 5). This suggests ABM can facilitate the verification of rules and regulations through traceable events, potentially enabling compliance officers to pinpoint specific execution traces where policy guardrails were breached.
Strategic Resource Allocation. Performance analysis revealed token consumption disparities—a *Barista Agent* consuming nearly 1M tokens versus a *Customer Service Agent* ’s 604k (Figure 6). This granular attribution may enable targeted placement of *human-in-the-loop* controls at high-cost or high-risk points while leaving routine cases automated.

### 6.2 Implications for the BPM Discipline
Building on Dumas et al.’s agenda for explainable and adaptable AI-augmented process management [^7], we argue that ABM suggests several disciplinary adaptations for extending process mining to autonomous agents.
Resources as Probabilistic Agents. Traditional BPM treats resources as executors of control flows [^8]. GenAI agents embed decision logic within resources, blurring the model-executor distinction. Building on the agenda outlined above [^7], this suggests BPM should complement control-flow modeling with explicit agent goals and constraints.
Prompts as Process Artifacts. Process logic has traditionally resided in BPMN models and business rules [^8]. In agentic processes, prompts increasingly function as de-facto process definitions, shifting the focus of behavioral governance away from explicit models. This motivates treating prompts as governed artifacts—specified, versioned, and managed with rigor comparable to process models—while ABM links prompt configurations to execution outcomes.

### 6.3 Threats to Evaluation Validity
While the preceding implications highlight ABM’s broad potential, our empirical findings must be interpreted with caution due to the exploratory nature and specific setup of our case study.
Construct Validity. We measured utility through perceived helpfulness. While perception precedes adoption [^5], it does not equate to objective outcomes; participants may have rated potential value rather than immediate efficacy. The insight elicitation used guided dashboard exploration rather than structured tasks with measurable outcomes, and no objective measures of decision accuracy or response quality were collected, which limits the strength of this assessment.
Internal Validity. The workshop setting may have introduced novelty or desirability bias. We mitigated this through realistic scenarios, genuine failure modes, and anonymized responses; however, the short duration of the study limited the assessment of long-term learning curves.

### 6.4 Limitations of the Proposed Framework
The proposed framework and its data model present several inherent limitations that point toward future research directions.
Reasoning Availability. ABM’s failure analysis capability (R3) depends on the availability of ai:response\_thought. However, some LLMs do not perform internal reasoning, and for models that do generate chain-of-thought content, such as OpenAI o-series or Anthropic Claude, availability may further depend on invocation parameters. Where reasoning summaries are absent, analysts can detect *that* an agent deviated but not *why*, as the agent’s internal rationale remains hidden. In these cases, fields such as ai:error\_message, ai:tool\_arguments, and ai:response\_message may help infer the underlying causes.
Event Granularity. The model captures events at the framework interaction level (call\_llm, execute\_tool, transfer\_to\_agent) but treats intra-LLM processing as atomic. Potential sub-steps, such as multi-step reasoning, within a single call\_llm invocation remain unobservable as discrete events. Extracting finer-grained events from ai:response\_thought content is a promising direction but requires NLP techniques and risks noise from non-deterministic generation.


## Key insights
- This paper addresses this *invisible autonomy risk* by introducing *Agent Behavior Mining*, a governance capability that enables the application of process mining techniques to render generative AI agent decision-making observable and traceable.
- The results indicate that practitioners view behavioral transparency as a prerequisite for trust and consider the ability to examine agent reasoning as an important governance requirement for the next generation of AI-driven business processes.
- To address these challenges, we propose Agent Behavior Mining (ABM) as a technology-enabled BPM governance capability that operationalizes visibility for organizational control.
- ABM establishes (1) *observability* of agent decisions, (2) *accountability* for agent outcomes, and (3) *controllability* by enabling targeted interventions such as policy guardrails and prompt updates.
- This supports the detection of compliance drift, containment of variable costs, and the development of empirical trust needed to scale agent adoption.
- Event Data Model for Agent Behavior: We introduce an event data model that provides the basis for turning agent activities—including reasoning traces and token costs—into standardized event logs, extending *eXtensible Event Stream* (XES) standards for GenAI agent governance.
- Operational Risk Detection: We instantiate the data model by implementing a multi-agent Order-to-Cash (O2C) scenario, demonstrating how process mining methods (discovery, conformance, variant analysis) quantify compliance deviations, cost anomalies, and behavioral variability.
- Overall, we argue that ABM can provide a practical foundation for moving from pilots to managed, accountable agent deployments.
- Section 3 introduces a multi-agent system (MAS) scenario to illustrate the invisible autonomy risk.
- Section 4 derives requirements and introduces the ABM event data model.

## Exemplos e evidências
See original source at `Clippings/Agent Behavior Mining Generative AI Agent Governance in Business Processes.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/Claude]]
- [[03-RESOURCES/entities/OpenAI]]
- [[03-RESOURCES/entities/Uber]]
- [[03-RESOURCES/entities/Rust]]

## Minha Síntese
**O que muda:** Agent Behavior Mining transforma o black box de decisões de agentes GenAI em process mining observável — event data model estende XES com tokens, reasoning traces e transfer_to_agent para governance BPM.

**Conexão pessoal:** O padrão de tornar prompts em process artifacts versionados e gerenciados é aplicável ao vault — tratar CLAUDE.md e skills como artefatos governados, não apenas arquivos de configuração.

**Próximo passo:** Versionar e auditar prompts/skills do vault como artefatos governados, não apenas arquivos de config.
