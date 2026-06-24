---
title: "HAAS Studio: A Tool for Simulating, Benchmarking, and Governing Human-AI Work Allocation"
type: source
source: "Clippings/HAAS Studio A Tool for Simulating, Benchmarking, and Governing Human-AI Work Allocation.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
We present HAAS Studio, a simulation and decision-support tool implementing the HAAS framework for policy-aware adaptive task allocation between humans and AI systems [^13]. HAAS Studio operationalises that framework as an interactive tool for examining how work can be allocated between humans and AI systems. The tool targets a practical question that is still poorly supported by current software: before deploying AI in a real workflow, how can a team compare candidate allocation strategies, ins

## Argumentos principais
### 1 Introduction
Organizations are no longer asking whether AI should be used at work, but *where*, *how much*, and *under which constraints*. Those choices are not binary. A team may want AI autonomy for repetitive tasks, human control for ambiguous tasks, and shared execution for safety-critical tasks. The main problem is that such decisions are often made with fragmented evidence: one dashboard for productivity, another for quality, and no integrated view of human sustainability, governance risk, or deployment transitions.
Classic work on human-automation interaction already showed that automation is a spectrum rather than a switch [^12], and situation-awareness research demonstrated that inappropriate automation degrades operator competence over time [^4]. Later human-centered AI frameworks emphasized transparency, oversight, and responsibility as first-class design goals [^14], and the human-machine teaming literature has repeatedly shown that the best allocation is neither full-human nor full-AI but context-dependent [^3]. In parallel, adaptive allocation methods based on bandit learning provide an attractive mechanism for sequential decision-making under uncertainty [^8]. Regulatory frameworks such as ISO/IEC 42001 [^7] and the NIST AI Risk Management Framework [^10] further require that AI deployments remain governed and auditable. What is still missing in many environments is a usable tool that brings these ideas together in one artifact: not only a simulator, but also a workflow for configuration, comparison, recommendation, and governance review.
HAAS Studio was built to address that gap. It is a Python and Streamlit application that implements the HAAS policy-aware framework [^13] for simulating Human-AI work allocation at the level of subtasks, comparing strategies under configurable business contracts, and translating benchmark traces into deployment-oriented recommendations. The broader project documentation currently includes a detailed system report and a manual with step-by-step study protocols; this paper condenses those materials into a tool-focused description of the artifact and its guided use.

### 2 Quick Start
For a first contact with HAAS Studio, the fastest useful path is:
1. open the setup wizard and select Simulation + Benchmark;
2. choose Software / Maintenance or Software / Standard Sprint as the scenario;

### 3 Core Concepts
The interface and the analytical views repeatedly use a stable vocabulary. Reading the rest of the document is much easier if these concepts are fixed early:
- Subtask: the atomic decision unit used by the simulator. Work is not assigned monolithically; each scenario is decomposed into subtasks with a cognitive profile.
- Collaboration mode: the operational relationship between human and AI for a subtask. HAAS Studio uses five modes: HUMAN\_ONLY, COPILOT, PEER, SUPERVISED, AUTONOMOUS.

### 4.1 Subtasks as the unit of decision
HAAS Studio does not allocate entire jobs monolithically. Its basic decision unit is the subtask. This is important because the same workflow may contain highly automatable activities and strongly human-centered activities. For example, in software engineering, documentation or regression testing may be good candidates for AI-led execution, while architecture design or incident triage may require stronger human control. The same principle appears in manufacturing and healthcare.
Each subtask is represented by five normalized cognitive dimensions repeatedly used throughout the tool:
1. Repetitiveness

### 4.2 A five-mode collaboration spectrum
The tool also avoids a binary *human vs. AI* view. It models five operational collaboration modes, summarized in Table 2.
Table 2: Canonical collaboration modes used by HAAS Studio.
| Mode | Human share | AI share | Execution pattern |

### 4.3 Governed adaptation instead of unconstrained optimization
When HAAS Studio allocates a subtask, the decision is adaptive but not fully free. Four learning algorithms are available in the current version: UCB1 [^1], Discounted-UCB [^5], LinUCB [^9], and Thompson Sampling [^15]. They learn from accumulated outcomes, but their choices are constrained by a governance layer that operates through four independent guards:
- Fatigue guard: caps delegation when projected fatigue exceeds the configured threshold, preventing unsustainable workloads [^16].
- Deskilling guard: limits AI share when recent exposure is too high, protecting human skill maintenance over time.

### 4.4 Oracle counterfactual and regret
A distinctive analytical component of HAAS Studio is the oracle counterfactual. Before each real allocation decision, the engine silently simulates two mirror executions without committing agent state: one with the human agent and one with the AI. This produces a theoretical upper bound for each subtask decision. The regret of the actual choice is then:
$$
\text{regret}_{s}=\max\bigl(r_{s}^{H},\,r_{s}^{A}\bigr)-r_{s}^{\text{real}}

### 5 System Overview
HAAS Studio is a web application implemented in Streamlit over a layered Python engine.

### 5.1 Governed allocation loop
The allocation loop is the operational core of HAAS Studio. Instead of making one coarse decision for an entire scenario, the system breaks each cycle into concrete subtasks and decides, for each one, how much work should be handled by the human and how much by the AI. The same simple sequence is repeated for every subtask:
1. the scenario selects the next subtask and describes its cognitive dimensions: repetitiveness, technical depth, creativity, ambiguity, and human interaction;
2. the policy layer first applies non-negotiable rules, for example tasks that must remain human-only or tasks whose criticality limits AI autonomy;

### 5.2 Domains and scenarios
The current documentation describes three implemented domains, each with its own task catalog, worker profiles, scenarios, and KPI vocabulary. Table 3 summarizes them.
Table 3: Domain packs currently documented in HAAS Studio.
| Domain | Example scenarios | Representative KPIs |

### 5.3 Human-AI co-evolution (layers L1–L6)
Sustained collaboration between a human and an AI system is not a static process: both parties change. Humans learn, fatigue, and gain or lose trust; the AI accumulates quality signal and adjusts its allocation posture. HAAS Studio models this joint dynamic through a six-layer co-evolution system [^3] [^4]:
- L1 – Observability and attribution. After each subtask the engine computes an attribution confidence $\chi_{t}\in[0,1]$ (how much the outcome can be credited to the assigned agent) and a synergy score $\kappa_{t}$ (whether the joint result exceeded each agent’s individual prediction).
- L2 – Synergy metrics. The $\kappa_{t}$ history builds a collaborative-effectiveness indicator per task type, identifying human-AI pairs that generate value beyond their individual contributions.

### 5.4 Deskilling and human sustainability
Deskilling—the progressive loss of human skills caused by excessive delegation to AI—is one of the most documented sociotechnical risks of automation [^12]. HAAS Studio models and monitors it at three levels of granularity.
#### Exposure metric.
For each worker and cycle the engine computes deskilling\_exposure\_recent: the fraction of recent cycles (default window: five sprints) in which the AI received a high share of work. Crucially, this is disaggregated by cognitive dimension. A worker may be well-protected in creativity but overexposed in repetitiveness if the AI systematically absorbs routine tasks.

### 6 User Workflow
One of the strengths of HAAS Studio is that it does not expose the simulator as raw parameters only. It organizes interaction as a workflow from configuration to interpretation. The landing view organises the tool’s interaction model around a single starting surface: Figure 5 shows the workspace entry point with its recommended workflow navigation, routing users to the setup wizard and the analysis screens.
Refer to caption

### 6.1 Setup wizard
Configuration is performed in a five-step wizard. The steps reflect the main questions a user must answer before running a scenario. Figure 6 shows the wizard with its five-step progression visible in the top navigation bar, illustrating how the tool structures configuration as an ordered evidence protocol rather than a flat parameter form.
Refer to caption
Table 4: Main steps of the setup workflow.

### 6.2 Recommended defaults for new users
Users who are learning the tool for the first time should avoid configuring the full space from scratch. A reliable starting configuration is:
- Execution mode: Simulation + Benchmark
- Domain: Software


## Key insights
- it presents the conceptual foundations of the tool: the stable vocabulary of eleven operational terms, the five-dimensional cognitive subtask representation, the five-mode collaboration spectrum, the governed adaptation loop, and the oracle counterfactual regret analysis;
- it describes the system architecture, including the governed allocation loop, three domain packs (software, manufacturing, healthcare), the six-layer Human-AI co-evolution model, and the deskilling and worker sustainability monitoring mechanisms;
- it documents the user-facing interaction model, from the setup wizard and company profiles through benchmark interpretation, Live Twin, and Planning, including four task-oriented operational recipes;
- it provides a decision framework for converting tool outputs into deployment decisions, covering five recurring user intents, a five-step signal-to-action filter, common interpretation errors, and a decision matrix;
- it presents the built-in evidence assets: five representative case-study protocols and six governance benchmark suites that support reproducible use across domains and allocators; and
- it covers the operational and scope information needed to use the tool correctly: installation, layered architecture, a pre- and post-run checklist, and an explicit statement of scope limitations.
- Subtask: the atomic decision unit used by the simulator. Work is not assigned monolithically; each scenario is decomposed into subtasks with a cognitive profile.
- Collaboration mode: the operational relationship between human and AI for a subtask. HAAS Studio uses five modes: HUMAN\_ONLY, COPILOT, PEER, SUPERVISED, AUTONOMOUS.
- Allocator: the adaptive decision policy that proposes collaboration modes from observed outcomes. The current tool exposes UCB1, Discounted-UCB, LinUCB, and Thompson Sampling.
- Contract: the active operational constraints configured by the user, typically including quality floor, cost target, time or fatigue bounds, and any hard restrictions on task ownership.

## Exemplos e evidências
See original source at `Clippings/HAAS Studio A Tool for Simulating, Benchmarking, and Governing Human-AI Work Allocation.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/reinforcement-learning]]
- [[03-RESOURCES/concepts/software-engineering/code-generation]]
- [[03-RESOURCES/entities/Claude]]
- [[03-RESOURCES/entities/GitHub-Copilot]]
- [[03-RESOURCES/entities/Codex]]
- [[03-RESOURCES/entities/Gemini]]
- [[03-RESOURCES/entities/Rust]]
- [[03-RESOURCES/entities/Python]]

## Minha Síntese
**O que muda:** A ser analisado em revisão manual.

**Conexão pessoal:** A ser conectado com projetos/estudo atuais.

**Próximo passo:** Nenhum próximo passo imediato.
