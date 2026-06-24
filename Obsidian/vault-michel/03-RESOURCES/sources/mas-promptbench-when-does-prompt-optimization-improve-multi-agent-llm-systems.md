---
title: "MAS-PromptBench: When Does Prompt Optimization Improve Multi-Agent LLM Systems?"
type: source
source: "Clippings/MAS-PromptBench When Does Prompt Optimization Improve Multi-Agent LLM Systems?.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
Multi-agent systems (MAS) offer a scalable path forward for agentic AI, comprising multiple LLM-based agents, each assigned a system prompt and a position within a workflow that governs inter-agent coordination and output aggregation. System prompts thus form a critical and accessible optimization surface: they specify agents’ roles and behaviors, enabling system-level improvements without model finetuning. Although prompt optimization has shown substantial potential for single LLMs, extending i

## Argumentos principais
### 1 Introduction
Agentic AI, as foundation-model-based systems that autonomously plan, use tools, and interact with the real world, is rapidly transforming daily life, industry, and scientific discovery [^32] [^40] [^2]. As tasks evolve from human-scale problems to organization-scale challenges that are increasingly complex, open-ended, and time-sensitive, single-agent architectures face fundamental bottlenecks in expertise breadth, context length, and sequential execution [^7]. In contrast, multi-agent systems (MAS) have emerged as a highly promising paradigm for next-generation agentic AI and general superintelligence (ASI) [^2] [^15], offering scalability, timeliness, and reliability through specialization and multimodality, task decomposition and parallelism, and independent cross-checks that strengthen reasoning and factual accuracy [^12]. Concretely, a MAS typically comprises multiple LLM-based agents coordinated by a harness that manages communication, task delegation, and output aggregation, with each agent assigned an instruction set and a position in a coordination workflow [^2]. Throughout this paper, we refer to an LLM’s instruction set as its system prompt, which may be a assembled collection comprising not only the system prompt itself but also other levels of instructions.
Within this MAS design space, system prompts provide a critical and accessible optimization surface: they specify each agent’s role and behavior [^3] [^36] [^16] [^34], enabling system-level improvement without model fine-tuning. System prompts are among the most accessible levers available to practitioners, who often inherit a fixed configuration and seek improvements without redesigning the underlying architecture; many real-world deployments further preclude topology changes due to safety, compliance, or auditability constraints [^21]. Given the important role of system prompts, automatic prompt optimization has been studied extensively in the single-agent regime, with strong demonstrated benefits [^67] [^58] [^52] [^25] [^1].
Whether such gains transfer to the multi-agent setting remains underexplored. Extending prompt optimization to MAS introduces qualitatively new challenges: inter-agent prompt dependencies, compounded by coordination dynamics across multi-turn interactions, induce a combinatorial search space that grows exponentially with the number of agents. As illustrated in Figure 1, the current effect of prompt optimization on MAS varies dramatically across tasks and topologies—ranging from substantial gains to equally severe performance drops. Meanwhile, most influential MAS frameworks—including AutoGen, CrewAI, CAMEL, MetaGPT, ChatDev, and AgentVerse [^55] [^9] [^28] [^20] [^43] [^8], as well as collaboration workflows such as debate [^12] [^31] —still rely on manually crafted system prompts. Recent works have begun to address this gap, either by developing dedicated MAS prompt optimization algorithms [^56] [^47] [^64] [^21] or by jointly optimizing prompts alongside orchestration components such as workflow topology [^65] [^66] [^22]. Yet these works evaluate on different tasks (e.g., math, coding, stock trading), configurations, and baselines, making cross-comparison difficult and leaving a fundamental question open:

### 2 Related Work
##### Prompt Optimization for Single LLM.
Prompt optimization improves LLM performance without updating model weights; see [^45] [^5] for detailed reviews. Prompts are typically categorized into system (hard) prompts as discrete text instructions and soft prompts as continuous embeddings [^5]. While both have shown effectiveness in single-agent settings, we focus on system prompts—the discrete instructions that specify each agent’s role—due to their interpretability and direct role in specifying agent behavior in MAS.
Most system prompt optimization methods can be viewed as searching over a discrete instruction space [^5]. Existing approaches fall into three categories: (1) sampling-based methods that generate and select candidate prompts using task feedback, including self-generated methods [^53], LLM-as-optimizer approaches such as APE [^67] and OPRO [^58], planning-based methods such as PromptAgent [^52], and evolutionary methods such as EvoPrompt [^17] and PromptBreeder [^14]; (2) feedback-based methods that leverage directional signals such as reinforcement-learning rewards [^10], textual gradients [^42] [^62], or self-reflection [^33] [^49]; and (3) editing-based methods that refine prompts through local operations such as insertion, deletion, or paraphrasing [^41]. These techniques are also integrated into broader frameworks such as DSPy [^25], which optimizes instructions within multi-stage LLM programs via algorithms such as MIPROv2 [^38]. In this work, instead of single-agent, we focus on prompt optimization for multi-agent LLM systems, where it remains unclear whether single-agent gains transfer. To investigate, we evaluate when and how much prompt optimization improves MAS performance across a broad range of setups varying in task, workflow, communication protocol, team size, and different prompt optimizers.

### 3 Prompt Optimization for Multi-Agent LLM Systems
Figure 2: Overview of benchmark MAS-PromptBench. Given an input task, a multi-agent system produces a final solution through interactions among LLM-based agents. MAS-PromptBench measures prompt-optimization gains across four axes: task distribution, workflow topology, communication protocol, and team size.
##### Prompt optimization for multi-agent systems (MAS).
We consider an LLM-based multi-agent system (MAS) [^25] [^38] [^1], illustrated in Figure 2, represented as the tuple

### 4 MAS-PromptBench: Prompt Optimization for MAS Benchmark
While benchmarks and evaluation protocols exist for single-agent prompt optimization, comparable resources for multi-agent systems remain underdeveloped. We fill this gap by introducing a benchmark designed to support extensive and controlled investigation for prompt optimization across diverse MAS configurations, summarized in Table 1 and Figure 2.
Table 1: Overview of the modular configuration of MAS-PromptBench.
| Factor | # | Details |

### 5 Empirical Study of Prompt Optimization in MAS
Armed with the MAS-PromptBench benchmark, in this section we conduct a systematic study to answer: *How much can prompt optimization help in MAS, and how does its effect vary across configurations?* We subsequently investigate the four critical MAS configuration factors: task (Sec. 5.1), workflow topology (Sec. 5.2), communication protocol (Sec. 5.3), and team size (Sec. 5.4). We mainly use the natural multi-agent extension of GEPA (named MAS-GEPA) as the prompt optimizer for Sec. 5.1-Sec. 5.4, with an ablation study of another prompt optimizer adapted from MIPRO (named MAS-MIPRO) in Sec. 5.5. Both MAS-GEPA and MAS-MIPRO optimize each agent’s system prompt separately and sequentially, using feedback from the overall MAS execution evaluation and the agent’s own experience traces. Details are provided in Appendix A.4.

### 5.1 Task
We first study how prompt-optimization gains vary across task domains that spans nine tasks across three domains: reasoning, coding, and tool-calling. In this subsection on tasks, we evaluate a range of popular existing MAS frameworks with naturally differing topologies, shown in Table 2; in all remaining studies on MAS configurations, we instead use the LangGraph framework to construct the different configurations, for flexibility and fairness. Table 2 shows that system-prompt optimization is broadly promising across diverse tasks: averaged over topologies, it improves performance on seven out of nine tasks, with the largest average gain of $+10.0\%$ points on APPS. Individual MAS configurations show even larger gains: Sequential in BFCL improves by $+24.0$ points, and Sequential in APPS improves by $+18.0$ points.
The gains are larger and more consistent for coding and tool-calling tasks than for reasoning tasks. At the task level, the maximum average gains for coding and tool-calling are $+10.0$ points on APPS and $+6.4$ points on BFCL, respectively, whereas the largest average gain among reasoning tasks is only $+3.2$ points on HotpotQA. At the topology-configuration level, coding and tool-calling tasks achieve maximum gains of $+18.0$ points on Sequential APPS and $+24.0$ points on Sequential BFCL, whereas reasoning tasks reach only $+8.0$ points on Sequential MATH. The same trend holds at the domain level in average: coding benchmarks improve by $+3.7$ points on average and tool-calling benchmarks by $+4.3$ points, compared with only $+1.3$ points for reasoning benchmarks.
We hypothesize that the difference arises from the extent to which each task can be decomposed into an explicit routine with controllable local behaviors. Coding tasks expose verifiable artifacts—small program steps can be checked by compilation and tests, while tool-calling tasks offer structured and clear interfaces through explicit function names and outcome formats that system prompts can directly shape. Such behaviors propagate through the MAS workflow with little ambiguity, allowing local prompt improvements to survive downstream coordination. Reasoning tasks, in contrast, rely on correlated logical steps with implicit intermediate feedback, so local improvements or errors are often discarded, overwritten, or amplified before reaching the final answer. Prompt optimization is thus most effective when tasks provide structured interfaces through which agent-level changes can be clearly controlled, preserved, and transferred across agents.

### 5.2 Workflow Topology
Figure 3: The five coordination structures evaluated by our protocol. Single is the single-agent baseline. Independent uses n parallel agents whose outputs are aggregated without inter-agent messaging. Sequential forms a directed chain A 1 → 2 ⋯ A\_{1}\\to A\_{2}\\to\\cdots\\to A\_{n} with no backward edges. Centralized uses a coordinator to route subtasks to workers that do not communicate with one another. Decentralized allows all agents to exchange messages over a fully connected graph for a fixed number of rounds. Arrows indicate message flow; nodes indicate agents.
A workflow topology refers to the inter-agent coordination graph $G$, which determines how agent outputs (messages) are routed, combined, and exposed to other agents en route to the final outcome. We again use the natural multi-agent extension of GEPA as the prompt optimizer. To study the room for improvement and the level of difficulty across diverse MAS topologies, we evaluate prompt-optimization gains under the following four multi-agent topologies along with a single-agent baseline, as illustrated in Figure 3.
- Single: A single LLM serves as the baseline.

### 5.3 Communication Protocol
Figure 4: Prompt-optimization gains of MAS-GEPA across diverse communication protocols: Freeform, Semi-structured, and Structured, on HotpotQA and LiveCodeBench. More structured protocols give MAS prompt optimization more room to improve.
A communication protocol specifies the format of inter-agent messages. Since downstream agents observe only the information explicitly written by upstream agents, an underspecified or overly redundant protocol may obscure salient information or direct attention to irrelevant details. To study how communication structure affects prompt optimization, we consider three protocols with increasing levels of structure;concrete examples of each protocol are provided in Appendix A.3:
- Freeform: Agents exchange unrestricted natural-language messages with no required fields or templates. This protocol gives agents maximum flexibility, but downstream agents must infer which information is most relevant.

### 5.4 Team Size
In this section, we study whether prompt-optimization gains increase with team size due to improved scalability, or decrease as coordination overhead grows. We vary the number of agents $n\in\{2,4,8,10\}$. Figure 5 and Table 5.4 show that as team size increases, prompt-optimization gains generally decrease, indicating more challenging for prompt optimization to translate into system-level gains, as agent-local improvements may be diluted or lost through increased coordination complexity. Average gains fall from $+2.4$ points at $n{=}2$ to $+0.6$ at $n{=}4$, and become negative at $n{=}8$ ($-0.9$) and $n{=}10$ ($-2.1$). This pattern suggests that adding more agents does not necessarily create more opportunities for prompt optimization, at least for current optimizers. While larger teams may enable scalable ability, finer-grained specialization, they also introduce more handoffs and intermediate states, making local improvements harder to preserve throughout the workflow. This effect is especially clear in Centralized HotpotQA, where gains fall from $+5.0$ at two agents to $-9.0$ at four and eight agents, and $-12.0$ at ten agents. In contrast, Decentralized HotpotQA remains nonnegative across all team sizes ($+6.0$, $+12.0$, $0.0$, and $+3.0$), indicating that the effect of team size also heavily depends on workflow toplogy.
Table 4: Prompt-optimization gains of MAS-GEPA across diverse team sizes on HotpotQA and LiveCodeBench. Each cell shows baseline / optimized values, followed by the signed change Δ \\Delta in percentage points. Blue indicates improvement, orange indicates regression, and gray indicates no change.
[^1]: Gepa: reflective prompt evolution can outperform reinforcement learning. arXiv preprint arXiv:2507.19457. Cited by: §A.4, 2nd item, §1, §2, §3, §3, Table 1, §4.


## Key insights
- Single: A single LLM serves as the baseline.
- Independent: $n$ agents solve the task in parallel without inter-agent communication, and their outputs are aggregated by majority vote.
- Sequential: Agents form a directed chain $A_{1}\to A_{2}\to\cdots\to A_{n}$ with no backward edges; each agent receives the previous agent’s output as input toward the final answer.
- Centralized: A coordinator dispatches subtasks to sub-agents $A_{1},\dots,A_{n}$, collects their outputs, and aggregates them into the final answer; sub-agents do not communicate with one another throughout the process.
- Decentralized: All $n$ agents communicate over a fully connected graph and exchange messages once, after which their final-round outputs are aggregated by majority vote for question-answering tasks or best-of- $N$ test-pass for coding tasks.
- Freeform: Agents exchange unrestricted natural-language messages with no required fields or templates. This protocol gives agents maximum flexibility, but downstream agents must infer which information is most relevant.
- Semi-structured: Agents communicate through a small set of prescribed slots that summarize the sender’s status, evidence, confidence, and intended next step. Each slot is still filled in natural language, making the message easier to scan while preserving flexibility for task-specific details.

## Exemplos e evidências
See original source at `Clippings/MAS-PromptBench When Does Prompt Optimization Improve Multi-Agent LLM Systems?.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/proof]]
- [[03-RESOURCES/entities/Claude]]
- [[03-RESOURCES/entities/OpenAI]]
- [[03-RESOURCES/entities/Gemini]]

## Minha Síntese
**O que muda:** Este estudo reforça que multi-agent systems (mas) offer a scalable path forward for agentic ai, comprising multiple llm-based agents, each assig — impacta diretamente como projetar e avaliar agentes.

**Conexão pessoal:** Conecto isso ao meu trabalho com Hermes Agent e o vault-michel: preciso aplicar este padrão nos meus fluxos de ingestão e consolidação.

**Próximo passo:** Implementar um experimento prático com este conceito nos próximos ciclos de desenvolvimento do vault.