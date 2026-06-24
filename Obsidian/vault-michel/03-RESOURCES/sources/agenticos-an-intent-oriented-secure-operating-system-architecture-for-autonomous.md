---
title: "AgenticOS: An Intent-Oriented Secure Operating System Architecture for Autonomous AI Agents"
type: source
source: "Clippings/AgenticOS An Intent-Oriented Secure Operating System Architecture for Autonomous AI Agents.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
As LLM-driven autonomous agents gradually acquire capabilities for autonomous planning, tool invocation, network access, code execution, and cross-application collaboration, traditional operating-system security models based on “resource exposure plus permission checks” are facing structural challenges. Existing POSIX-style system-call interfaces expose general-purpose resource primitives – such as files, networks, processes, memory mappings, and dynamic execution – to processes. Once an agent r

## Argumentos principais
### 1.1 System Security Problems Introduced by Autonomous Agents
AI is undergoing a transition from text-generation models to autonomous agents capable of autonomous planning, tool invocation, and network interaction. Traditional applications are usually operated explicitly by users through graphical interfaces or command lines, and their behavioral boundaries are jointly determined by user actions, application logic, and operating-system permissions. By contrast, autonomous agents typically operate in the following mode: a user provides a high-level task, and the agent decomposes the task into steps, selects tools, reads context, accesses external services, and produces external effects on its own.
This shift creates a fundamental security tension: users authorize “task intent,” while operating systems expose “resource primitives.” For example, a user may only authorize an agent to “organize the experimental results of a project and generate a summary.” Yet in a traditional system, the agent process often simultaneously obtains general capabilities such as file reading, network access, subprocess execution, dynamic loading, and temporary-directory writes. If the agent is compromised by prompt injection, malicious dependencies, or poisoned tool outputs, an attacker can combine these general capabilities into lateral movement, sensitive-data exfiltration, persistence, or covert communication paths.
Therefore, the operating-system security problem in the agent era is not simply “how to grant an agent fewer permissions.” The deeper question is how the system can understand and constrain the forms of tasks that an agent is allowed to complete. This paper refers to this problem as the mismatch between resource-permission models and task intent.

### 1.2 From Resource Manager to Intent Filter
The POSIX system-call interface of current operating systems, such as Linux, is a set of general computational primitives. Interfaces such as $open$, $read$, $write$, $socket$, $connect$, $mmap$, $execve$, and $fork$ are neutral in isolation, but their compositional closure is extremely powerful: once a process obtains sufficient resource access, it can express behaviors far beyond the original task objective.
The central observation of AgenticOS is that, for highly autonomous agents, the security boundary should not be built around the low-level question of “whether a process is allowed to access a resource.” Instead, it should be built around the semantic question of “whether this external effect conforms to the declared task intent.” AgenticOS therefore aims to remove the agent runtime’s direct dependence on general system-call semantics and replace it with one-shot capability synthesis based on intent declarations. We position AgenticOS as an “agent-native operating system”: a secure computing substrate designed for highly autonomous AI systems, centered on intent constraints and least capability.
It should be noted that AgenticOS does not deprive the system of general computational capability. Instead, it encapsulates such capability on the system side as structured, auditable, and policy-mediated semantic capabilities, rather than handing it to agents in the form of raw system calls or general resource handles.

### 1.3 Theoretical Foundations and Limitations of Existing Approaches
AgenticOS is not a security model invented from scratch; rather, it recombines and lifts several existing lines of work.
First, capability security emphasizes least authority and unforgeable capability handles. Traditional capability-based systems, the object-capability model, KeyKOS, EROS, Capsicum, and CHERI all attempt to replace global permission checks with capability objects [^9] [^7] [^5] [^11] [^13] [^14]. AgenticOS inherits this idea, but further elevates capability objects from “resource handles” to “task-intent handles”: a capability constrains not only which resource can be accessed, but also under what semantics and in which task context an external effect may be produced.
Second, microkernels and formal verification emphasize a minimal trusted computing base (TCB) and provable isolation. Systems such as seL4 demonstrate that kernel-level isolation and access control can be rigorously proven on a relatively small code base [^6]. The Ghost Kernel in AgenticOS follows this direction, but it does not attempt to become a complete general-purpose kernel. Instead, as the minimal trusted kernel, the Ghost Kernel provides only isolation, scheduling, measurement, and the root of attestation.

### 1.4 Contributions
The main contributions of this paper are as follows:
- It proposes an intent-oriented operating-system security paradigm for autonomous agents, reconstructing the OS from a “resource manager” into an “intent filter.”
- It designs a four-layer AgenticOS architecture consisting of the Ghost Kernel, Logic Shutter, Agent Capsule, and Semantic Boundary Gateway.

### 2.1 Threat Model
This paper focuses on the following in-scope threats:
- Fully compromised agent process: an attacker obtains arbitrary code execution inside an Agent Capsule and attempts lateral movement, escape from the isolation boundary, or kernel-level operations.
- Supply-chain poisoning: agent dependencies, Skills, model configurations, or toolchain components are implanted with malicious logic that attempts to leak sensitive data through legitimate ABIs.

### 2.2 Security Assumptions
The security analysis of AgenticOS relies on the following assumptions:
- Effective isolation primitives: hardware-level memory isolation, virtualization isolation, or trusted execution environments are logically reliable, such as VT-x, AMD-V, Intel TDX, AMD SEV, or equivalent mechanisms.
- Trusted Ghost Kernel: the minimal trusted kernel, the Ghost Kernel, has a sufficiently small code base, and its key isolation, scheduling, and measurement logic can be formally verified or intensively audited.

### 2.3 Design Goals
AgenticOS has the following design goals:
- Intent first: the system authorizes by task intent and external effect, rather than by raw files, raw ports, or raw processes.
- Least capability: before an agent starts, it must submit a Manifest, and the system generates only the minimum capability set required to complete the declared task.

### 3.1 From Resource Manager to Intent Filter
The core responsibility of a traditional OS is to manage hardware resources and check permissions when processes access those resources. AgenticOS shifts this responsibility toward intent filtering: the system first determines whether the external effect requested by an agent conforms to the task intent declared in the Manifest, and only then maps it to controlled low-level operations.( Fig 1 and Fig 2 illustrate the differences in security paradigms between traditional operating systems and AgenticOS.)
Figure 1: Traditional OS: Permission Based
Under this model, the attack surface shifts from “finding exploitable system-call entries” to “attempting to abuse restricted semantic interfaces.” This does not mean that attacks become impossible; rather, it means that attackers must operate within a narrower, more auditable, and more policy-constrained abstraction layer.

### 3.2 Four-Layer Architecture Overview
AgenticOS adopts a four-layer vertical design, with strict one-way dependencies between layers to provide defense in depth.
The four layers have distinct responsibilities. The Ghost Kernel provides the minimal trusted isolation substrate. The Logic Shutter performs intent recognition, policy mediation, capability-token management, and auditing. The Agent Capsule hosts the restricted agent runtime. The Semantic Boundary Gateway handles external protocols, credentials, content filtering, and output normalization.

### 3.3 Ghost Kernel: The Minimal Trusted Kernel
The Ghost Kernel is the trust root of the entire system and runs at the highest privilege level, such as VMM Root, a hardware TEE secure domain, or an equivalent isolation domain. The term “Ghost Kernel” does not imply mystery; it emphasizes that the kernel is not directly reachable at runtime. It does not accept general system calls from Agent Capsules, expose device files, provide debugging interfaces, or host complex protocol stacks.
The Ghost Kernel is responsible for only three classes of primitives:
- Encrypted memory allocation: based on hardware memory encryption or page-table isolation mechanisms, it allocates isolated physical pages for each Agent Capsule and enforces isolation between capsules through EPT/NPT or equivalent mechanisms.

### 3.4 Logic Shutter
The Logic Shutter is the semantic translation layer and policy enforcement point of AgenticOS. It runs at a trust level above Agent Capsules and below the Ghost Kernel. It is responsible for intent recognition, capability validation, policy mediation, information-flow labeling, and audit logging.
The main functions of the Logic Shutter include:
- Intent parsing and validation: it receives semantic requests from Agent Capsules and determines whether they match the capability list, data-flow constraints, and output targets declared in the Manifest.

### 3.5 Agent Capsule
An Agent Capsule is the actual runtime environment for agent code. Unlike a traditional container or virtual machine, a capsule follows the Manifest-Only Runtime principle: before startup, the agent must submit a structured intent declaration that specifies required network domains, file scopes, tool-call types, model sessions, output targets, and human-confirmation points. Capabilities outside the Manifest have no corresponding interfaces in the capsule address space.
The key constraints of a capsule include:
- Intent manifest discipline: all capabilities originate from the Manifest and are explicitly bound to the call chain through $cap\_id$.

### 3.6 Semantic Boundary Gateway
The Semantic Boundary Gateway is the only controlled boundary between Agent Capsules and the external world. Its role is not to infer an agent’s true intent, but to transform structured intents into controlled external effects after the Logic Shutter has authorized them.
The Semantic Boundary Gateway includes the following functions:
- Protocol proxying: complex protocols such as SSH, TLS, HTTP, message queues, and object storage are implemented on the gateway side, while Agent Capsules do not access protocol-stack details.

### 4.1 Manifest-Only Runtime
The success of AgenticOS depends on whether its semantic interfaces can remain “non-generalizable,” meaning that the compositional closure of the interface set must not degenerate into a general system-call table. The Manifest-Only Runtime is the core mechanism for achieving this goal.
A Manifest contains at least the following information:
- Agent identity and version: agent name, model or code version, build hash, and signature information.

### 4.2 Design Principles of the Intent ABI
The Intent ABI is an application binary interface oriented toward task intent. It differs from a traditional syscall ABI: the latter provides general resource operations, whereas the former provides structured semantic operations.
Its design principles are as follows:
- Non-generalizability: interface composition must not express arbitrary I/O, arbitrary process creation, or arbitrary network protocols.


## Key insights
- It proposes an intent-oriented operating-system security paradigm for autonomous agents, reconstructing the OS from a “resource manager” into an “intent filter.”
- It designs a four-layer AgenticOS architecture consisting of the Ghost Kernel, Logic Shutter, Agent Capsule, and Semantic Boundary Gateway.
- It introduces the Intent ABI and Manifest-Only Runtime, enabling the agent runtime to access only semantic capabilities generated from task declarations.
- It presents a Weaver-based dynamic capability generation mechanism, as well as generation, registration, and admission principles for AgentOS-native Skills.
- It analyzes the architecture’s impact on system-call attack surfaces, supply-chain poisoning, capability-composition attacks, intent drift, and covert channels.
- It discusses the ecological boundary of migrating from applications to application capabilities, and explains how AgentOS-native Skills can host delegable software capabilities.
- Fully compromised agent process: an attacker obtains arbitrary code execution inside an Agent Capsule and attempts lateral movement, escape from the isolation boundary, or kernel-level operations.
- Supply-chain poisoning: agent dependencies, Skills, model configurations, or toolchain components are implanted with malicious logic that attempts to leak sensitive data through legitimate ABIs.
- Tool-output poisoning: external services return malicious instructions or structured inducements that cause the agent to perform unauthorized behavior.
- Capability-composition attacks: the attacker does not violate any single interface policy, but combines multiple legitimate interfaces into unintended external effects.

## Exemplos e evidências
See original source at `Clippings/AgenticOS An Intent-Oriented Secure Operating System Architecture for Autonomous AI Agents.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/AWS]]
- [[03-RESOURCES/entities/Rust]]
- [[03-RESOURCES/entities/Python]]

## Minha Síntese
**O que muda:** Este estudo reforça que as llm-driven autonomous agents gradually acquire capabilities for autonomous planning, tool invocation, network access, — impacta diretamente como projetar e avaliar agentes.

**Conexão pessoal:** Conecto isso ao meu trabalho com Hermes Agent e o vault-michel: preciso aplicar este padrão nos meus fluxos de ingestão e consolidação.

**Próximo passo:** Implementar um experimento prático com este conceito nos próximos ciclos de desenvolvimento do vault.