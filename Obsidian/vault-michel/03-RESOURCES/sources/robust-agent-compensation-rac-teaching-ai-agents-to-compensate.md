---
title: "Robust Agent Compensation (RAC): Teaching AI Agents to Compensate"
type: source
source: "Clippings/Robust Agent Compensation (RAC) Teaching AI Agents to Compensate.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
---
title: "Robust Agent Compensation (RAC): Teaching AI Agents to Compensate"
source: "
author:
published:
created: 2026-06-23
description:
tags:
  - "clippings"
---
Srinath Perera WSO2Santa ClaraUSA [srinath@wso2.com](), Kaviru Hapuarachchi WSO2Santa ClaraUSA [kaviru@wso2.com](), Frank Leymann University of StuttgartStuttgartGermany [frank.leymann@iaas.uni-stuttgart.de]() and Rania Khalaf WSO2Santa ClaraUSA [rania@wso2.com]()

(2026)

###### Abstract. We present Robust Agent Compensation (RAC)

## Argumentos principais
### 1\. Introduction
With the advent of language models [^6], developers now have access to a wide variety of powerful AI models that have unlocked use cases previously beyond reach. Many AI applications use agents as their building blocks. Russell et al. [^4] define Agents as “entities that perceive and act upon their environment”. In modern use, agents receive inputs, analyze data, and carry out actions by calling tools or other agents, where tools are external actions available to agents. Failures in agents or the tools agents use can make agents unreliable. In a study of agents in production based on inputs from 306 participants, Pan et al. [^32] highlight that “reliability is an unsolved challenge”. This paper focuses on a new technique towards achieving reliable agent execution.
In order to be more specific on what we mean by this, we first present a set of definitions and concepts that provide the relevant context for the framing and approach. We call a group of agents organized as a directed graph a graph of agents. We call supporting middleware that helps developers build, execute, and manage such a graph of agents an agent framework. Each agent may include other agents or tools. For example, you can create a graph of agents using agent frameworks like LangGraph [^1] or CrewAI [^29]. A graph of agents can be as simple as a single agent or as complex as multi-agent systems defined in Junda He et al. [^20].
AI applications, and AI agents in particular, most often have dynamic behavior where the exact execution order is determined at runtime. Consider common ways that developers define the logic that determines how the set of activities (agents or tools to call) within such applications or agents should be executed:

### 2\. Related Works
In real-world systems, failures are inevitable. When executions invariably fail, they may leave unwanted side effects, thereby leaking their abstractions. Although in theory, programmers can handle any side effects via thoughtful code, the resulting code is complex and error-prone. For example, Davis [^9] and Gray [^17] discuss a programmer keeping a “scratchpad” to track any side effects. To ease the programmer’s burden, we need higher-level abstractions.
The most widely known abstraction is the ACID paradigm (Härder et al. [^19]). Although started with databases, systems can now handle transactions involving any kind of resource (e.g., queues, services) using global transactions based on the Two-Phase-Commit protocol (e.g., based on XA or WS-AT [^30]).
However, when transactions are long-lasting or highly concurrent, this can lead to cascading rollbacks or severe performance slowdowns. As an alternative, Sagas [^13] proposed breaking the transaction into smaller transactions, where each such small transaction is an ACID transaction and provides a single compensating operation that can undo its side effects. These compensations are used to reverse any side effects of subtransactions as needed (Wächter et al. [^11]). This laid the groundwork of the compensation model(Colombo et al. [^7]) that we will also use within the RAC.

### 3.1. Proposed Design
RAC is a recovery paradigm implemented through an architectural extension that can be applied to most Agent frameworks to support robust execution by retrying, finding alternatives, and, when recovery fails, compensating tool operations that need to be undone or compensating workflow steps running in the Agent framework. Figure 1 depicts the architecture of the RAC approach.
AI application developers enable RAC by adding interceptors to the agent framework, and then they can run their existing agents in RAC. To compensate, RAC needs to know compensation pairs for tools (another tool that can reverse this tool’s side effects; e.g., “cancelFlight” for “bookFlight”) and input mappings (how to find inputs for compensation). RAC will find them from MCP ( if tool developers have added the information to MCP tool definitions), or from definitions provided via framework API, or by asking LLM to discover them, in that order.
The Tool Interceptor records all tool call events (e.g., start, completion, and error) in a persistent Transaction Log for each agent. Algorithm 1 shows the pseudocode for the tool interceptor. When an error occurs, the interceptor calls the handleFailure() method of the Recovery and Compensation Manager (RCManager). Line 8 updates the agent context with a summary of rollback actions, and as discussed in subsection “How RAC uplift ReAct Agents”, updating the agent context lets follow-up agents (e.g., ReAct) solve harder problems.

### 3.2. How RAC uplifts ReAct Agents in the graph of agents
As we will see in the evaluation section, the proposed RAC design has two interesting side effects when a user uses RAC to handle dynamic scenarios (e.g., by using a graph of agents that includes a ReAct Agent). First, the graph of agents (including the ReAct agent) within RAC can handle much more complex scenarios because RAC handles failures and adds the outcome of failure handling to the context. Second, RAC can handle unknown failures reliably because the ReAct agent(s) within the graph of agents reason at each step, as opposed to planning-based approaches, which get stuck in replanning loops.
Input: TransactionLog (completed actions)
Output: RollbackReport

### 3.3. Design Time: Specifying Compensation Pairs
While running the compensation logic, the recovery manager (RCManager) needs to take a compensation action for all or a subset of each executed action. To do that, RCManager needs to find compensations (algorithm 3, line 7) and then find the inputs for the compensation operations using the inputs and outputs from earlier operations (defined as ExtractParams in pseudo code, algorithm 3, line 8).
For example, the “book flight” action can have a compensation action pair called “cancel flight,” and as the input to the cancel flight action, we need to pass the Confirmation reference from the book flight response.
RAC looks for compensation actions and input mappings in the following order:

### 4.1. RAC Implementation
The Recovery and Compensation Manager (RCManager) is agent-agnostic and contains the bulk of the logic. We implemented the language-agnostic part of RAC (Recovery and Compensation Manager) in Python 3, and you can find the Implementation at [^37]. A framework that uses RAC only needs to implement a Tool Interceptor and an Error Interceptor. Once those are implemented, RAC algorithms 1,2,3 will handle recovery.
#### 4.1.1. LangGraph-based Implementation
We implemented RAC with LangGraph, and we implemented a Tool Interceptor and an Error Interceptor using extension points in LangGraph architecture that let us intercept the pre- and post-tool invocation lifecycle and errors that occur within LangGraph.

### 5\. Evaluation
In the evaluation, as an RAC-based implementation, we ran benchmark prompts in a vanilla LangGraph ReAct Agent with RAC enabled via extension points. We evaluated RAC against the following approaches:
1. SagaLLM - state-of-the-art solution as discussed in [^5]
2. LG - Vanilla ReAct Agent (LangGraph) - ReAct pattern

### 5.1. SagaLLM Implementation
We encounter failures when running SagaLLM code referenced in Longling et al.[^15]. We wrote to the authors, but received no response. We have made the following modifications, using prompts given the papers and doing our best to follow what is described in the SagaLLM papers. The modifications are implementing phase 2 initiation per Algorithm 1 in Longling et al., improving prompts to support new LangGraph V1, and fixing generated code errors in LLM-based LangGraph generation. The modified implementation is available at [^37]. We also provide the changed SagaLLM code as open source via [^37], enabling interested practitioners to verify.

### 5.2. Benchmark Selection
As discussed in the related work section, the scenarios in both Wang et al. [^35] and Appworld [^34] do not have side effects. Hence, we can’t use them for evaluating RAC. We used the following two benchmarks for evaluation.
$\tau$ ²-bench [^3] is a benchmark for evaluating conversational AI agents in realistic customer service scenarios across three domains: Airline (e.g., handling flight cancellations, booking modifications, cabin upgrades, baggage inquiries), retail (e.g., product exchanges, order modifications, returns), and telecom (e.g, mobile data troubleshooting scenarios). The benchmark includes disruptions and allows the agent framework to abstain from some problems (as described in the prompt), and the framework may achieve success either by completing the task or abstaining without leaving side effects. Some problems have additional criteria (e.g., verify the order ID), and the frameworks must adhere to these criteria to be successful.
The REALM-bench [^14] is designed to test agents in real-world planning scenarios, spanning five categories. Scheduling, routing, logistics, disaster relief, and supply chain, each incorporating domain-specific constraints, resource dependencies, and configurable disruption scenarios. It includes 11 tasks that progress from basic to highly advanced.

### 5.3. Part 1: Task with Predictable Failures
In the first part of our implementation, we focus on “Task with Predictable Failures.”
For this part, we use all scenarios from the $\tau$ ²-bench, which involve disruptions that can cause side effects. From REALM-Bench we selected scenarios 5,6,8,9, and 11 from REALM-Bench, considering Disruption Density (ability to inject failures), adaptation requirements ( how hard to recover), and state complexity. The selected scenarios are the same as those used by SagaLLM in its evaluation.
All the above scenarios have well-defined (predictable) failures because their problem descriptions explicitly mention each failure scenario; hence, the LLM knows about them and can incorporate them into planning.

### 5.4. Part 2: Tasks with Dynamic Failures
The second part of the evaluation focuses on scenarios with Dynamic Failures. We consider a scenario to have dynamic failure when the problem description does not explicitly list all possible failure scenarios (e.g., a machine temporarily breaking down or a payment being rejected). It is worth noting that, because listing all failure cases is tedious, real-world prompts often exhibit dynamic failures.
We extended $\tau$ ²-bench and REALM-bench with the following new scenarios that introduce dynamic failures, extending the benchmark implementation to inject disruptions.
1. P12: Extends P11, which asks to schedule jobs on three machines. Each machine can have temporary disruptions, and this scenario tests whether the task can recover from failure by retrying. This problem can be solved by retrying.

### 5.5. Part 3: Ablation with High Reason Model
To understand how RAC behaves with higher reasoning, we have selected subset problems where frameworks ran into problems, and ran them three times with GPT-5.4, the most advanced model with full reasoning. We only selected problems that failed for this experiment to save costs. Table 4 shows the results. In the table, H means GPT-5 results, and L means Gemini-flash results.
<table><thead><tr><th rowspan="2">Task ID</th><th colspan="2">LG</th><th colspan="2">LG(PE)</th><th colspan="2">Saga</th><th colspan="2">RAC</th></tr><tr><th>H</th><th>L</th><th>H</th><th>L</th><th>H</th><th>L</th><th>H</th><th>L</th></tr></thead><tbody><tr><th>P6</th><td>2/3</td><td>3/3</td><td>2/3</td><td>3/3</td><td>3/3</td><td>2/3</td><td>3/3</td><td>1/3</td></tr><tr><th>P8</th><td>2/3</td><td>3/3</td><td>2/3</td><td>3/3</td><td>3/3</td><td>3/3</td><td>3/3</td><td>3/3</td></tr><tr><th>P11</th><td>3/3</td><td>3/3</td><td>3/3</td><td>3/3</td><td>3/3</td><td>2/3</td><td>3/3</td><td>3/3</td></tr><tr><th>P12</th><td>0/3</td><td>0/3</td><td>3/3</td><td>3/3</td><td>1/3</td><td>1/3</td><td>3/3</td><td>3/3</td></tr><tr><th>P13</th><td>3/3</td><td>0/3</td><td>3/3</td><td>0/3</td><td>0/3</td><td>2/3</td><td>3/3</td><td>3/3</td></tr><tr><th>P14</th><td>0/3</td><td>0/3</td><td>0/3</td><td>0/3</td><td>0/3</td><td>1/3</td><td>0/3</td><td>2/3</td></tr></tbody></table>
Table 4. Ablation with High Reason Model

### 6\. Discussion
Comparing and contrasting LG, LG(PE), SagaLLM, and RAC: LG depends on ReAct loop for recovering from failures. While sometimes it can recover from failures and compensate to avoid leaving side effects, its behavior is highly dependent on the problem, the nature of disruptions, and the prompt. For example, with the $\tau$ ²-bench where the prompt explicitly asks the framework to abstain if not sure and only leave a clean state, even LG does well (¿80% scenarios).
LG(PE) added instructions on recovery and compensation to the prompt, and this improved results in several cases. (e.g., P12).
SagaLLM depends on upfront planning. Replanning may happen due to problems with the plan, unexpected disruptions, or problems while converting the plan to LangGraph. Hence, even scenarios without disruptions can trigger replanning.

### 7\. Conclusion
When implementing AI applications that involve a set of actions, we need to handle failures and ensure they do not cause lingering side effects. Even though there are higher-level abstractions such as ACID and SAGA, they are challenging to use with dynamic agents like the React agent. Asking AI developers to handle failure scenarios through first principles is complex and error-prone. On the other hand, LLM-based planning approaches have been shown to be expensive and susceptible to hallucinations.
To solve the agent execution side effects problem, we present Robust Agent Compensation (RAC), a recovery paradigm implemented through an architectural extension.
RAC’s core contribution is a post-hoc guarantee layer that can be integrated into existing agent frameworks (like LangGraph or CrewAI) via their existing extension points. Unlike previous systems that rely on the LLM to ”reason” its way out of a failure, RAC records key events in a transaction log and uses them to compensate for any unintended side effects by rebuilding execution history from the log to perform a precise LIFO (Last-In-First-Out) rollback when a task becomes unrecoverable. Evaluation based on $\tau$ ²-bench and the RELAM-Bench shows that, for complex problems, RAC has about 1.5-8X better token Efficiency and lower latency. Furthermore, by reducing the dependency on LLMs, RAC reduces the potential for hallucination.


## Key insights
- We propose RAC, a log-based recovery paradigm (providing a safety net) implemented through an architectural extension that can be applied to most Agent frameworks ( as described below) to support reliable executions ( avoiding unintended side effects).
- Identify and extend benchmarks for testing the agent for unintended execution side effects when faced with disruptions that are not mentioned in the problem description.
- Use the Model Context Protocol (MCP) Specification’s extension points to describe compensation pairs, creating an interoperable way for agent frameworks to discover those pairs.
- We present evidence that decoupling recovery from the ReAct Agents can enable them to solve harder problems, uncovering strong directions for the design of a robust agent execution framework (see subsection 3.2 for details).
- We provide an open-source reference implementation of RAC [^37].
- Generate code for executing the plan.
- Find the compensation operation for each tool operation.
- Find inputs that need to be passed to the compensating tool calls.

## Exemplos e evidências
See original source at `Clippings/Robust Agent Compensation (RAC) Teaching AI Agents to Compensate.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/OpenAI]]
- [[03-RESOURCES/entities/Gemini]]
- [[03-RESOURCES/entities/Python]]

## Minha Síntese
**O que muda:** A ser analisado em revisão manual.

**Conexão pessoal:** A ser conectado com projetos/estudo atuais.

**Próximo passo:** Nenhum próximo passo imediato.
