---
title: "Beyond Mainframe Modernization: Reimagining Enterprise Applications for an Agentic World"
type: source
source: "Clippings/Beyond Mainframe Modernization Reimagining Enterprise Applications for an Agentic World.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
---
title: "Beyond Mainframe Modernization: Reimagining Enterprise Applications for an Agentic World"
source: "
author:
published: 2026-06-23
created: 2026-06-23
description: "The term ‘mainframe modernization’ is itself out of date. Modernization used to mean upgrading the technology. AI has made it about reimagining the business.

## Argumentos principais
### Introduction
The term “mainframe modernization” has been associated with infrastructure and technology modernization projects rather than business transformation. This covers a wide range of projects with very different objectives: application and data migrations, exposing mainframe data, building DevOps and CI/CD pipelines, and optimizing applications in place.
An estimated 70% of Fortune 500 business processes still run on mainframe applications. These systems hold decades of accumulated business logic across millions of lines of COBOL, PL/I, and Assembler, locked inside monolithic architectures with tightly coupled data stores, batch schedulers, and terminal interfaces. That design can’t deliver the real-time data access end users now expect, and it can’t deliver the speed to market a business needs to stay competitive.
AI has changed how we approach these projects. Modernizing mainframe applications is no longer mainly about solving a technology problem. It’s about getting core systems ready for what the business now demands: shipping faster, adapting to change in real time, and becoming the platform the enterprise’s AI strategy is built on.

### Higher-Order Objectives: Beyond Cost, Talent, and Agility
If you’ve attended a mainframe migration presentation in the last few years, you’ve heard the usual list of customer challenges: talent risk, inefficient cost models, and limited operational agility. These are real pain points, but business outcomes drive much stronger momentum.
The approaches we historically recommended for these problems all addressed the technology layer. We’ve been able to convert legacy code and data to modern technologies for years. AI now adds a new dimension on top of these. Increasingly, customers tell us they want more than a change of technology layer. They want their core applications to help them ship faster, deliver better customer experiences, and power AI-native business processing. That’s what the reimagine pattern is built to deliver.
AI shifts the focus above the technology layer and transforms legacy applications and data with what the business needs today. Those same core systems are the foundation of any enterprise AI strategy, so modernizing them is what positions customers to capitalize on AI.

### Business Transformation in Practice
Business transformation usually starts from a constraint. A regulation it can’t meet in time, or a customer experience the current system was never built to support. The enterprises getting the most out of modernization started from that constraint and worked backward into the architecture.
These targets usually fall into three areas: customer experience (batch to real-time, single-channel to omni-channel), business agility (hardcoded rules to dynamic configuration, quarterly releases to continuous delivery), and data intelligence (siloed reports to AI/ML-driven insights).

### What does this look like in practice?
[ADP]() processes one in six US payrolls and manages $1.6 trillion in deposits across 8,000 tax jurisdictions. Their main challenge was adaptive compliance: responding to regulatory changes that often arrive with little notice. Using [Amazon Web Services (AWS) Transform](), ADP extracted thousands of embedded business rules and externalized them as configurable logic, so a regulatory update no longer requires deep code changes. The [result]() is a tax engine that scales with the season and adapts to regulatory changes in near real time.
[Itaú Unibanco](), the largest bank in Latin America with 70 million customers, set a goal of running 100 percent in the cloud by 2028. The driver was becoming a digital-first organization, one where the product is the customer relationship itself. Engineers were spending half their time just figuring out what decades of legacy code actually did. By pairing AWS Transform for reverse engineering with Kiro for forward engineering, Itaú cut reverse-engineering time by more than 90% and forward-engineering time by more than 80%, freeing teams to build the digital experiences their customers expect.
[Western Union]() modernized its money order systems, where more than 15 back-office teams were stuck working through dated terminal interfaces. The goal was to redesign the product, not just convert the code: customer self-service, simpler tools for retail agents, and a better experience on both sides. Working with Accenture, Western Union cut its discovery and testing timelines in half.

### The Agentic AI Paradigm: Three Layers
Customers are bringing AI agents into three layers of their core applications. How an organization handles each layer determines how much value it gets from the move to agentic systems.

### The Development and Transformation Layer
AI agents now handle much of the coding and maintenance work. For customers with tightly coupled monoliths, that raises a real concern: when something goes wrong, the blast radius is large. If accounts, deposits, and withdrawals are all bound together in one monolithic application, an error in one of them can cascade into the others.
Breaking monoliths apart along business domains, whether through microservices, a modular monolith, or another design, shrinks that blast radius. For efficiency customers can also have the applications written in languages that have Language Server Protocols (LSPs) available, so agents can parse the codebase and follow development best practices.
Agentic coding tools like Kiro, Claude Code, and Codex are being adopted quickly. Developers describe what they need in plain language. Kiro turns that into structured specifications and then executes on its own: reading the codebase, making edits across multiple files, running tests, and iterating. This is spec-driven development. People define the what and the guardrails, and the agent works out the how.

### The Operational Layer
A production failure in the middle of the night is unavoidable. What’s changing is how that failure gets triaged, responded to, and resolved, along with how it’s monitored and prevented in the first place. With AWS frontier agents such as the AWS DevOps Agent, customers are deploying autonomous agents that react to events in real time and resolve failures before a human needs to step in. The AWS DevOps Agent acts as an always-on SRE (Site Reliability Engineer) on your team.
Day-to-day operational work will increasingly be handled by agents, but you need a modern infrastructure and application layer to get the full benefit.

### The Business Layer
This layer has the widest scope. Businesses need to design their systems with AI agent integration in mind from the start. Workflows are being broken down into agents that handle complex, judgment-based tasks: assessing an insurance claim, reviewing a loan application, routing a customer inquiry, or flagging fraud.
For 60 years, software followed one model: a human defines the rules, the rules are coded, the code runs deterministically, and a human steps in when needed. Every business rule was written as if-else logic, hardcoded by developers, and shipped as compiled instructions. But some decisions don’t fit fixed logic because they’re inherently judgment calls: dispute resolution, fraud management, claims approval, customer service routing.
The agentic model changes that: a human defines the intent and the goals, the agent reasons over the data, and the agent acts on the human’s behalf. AI agents can now handle these judgment-based tasks. Given a goal, a set of tools, and guardrails defined by people, the agent decides how to reach the goal based on context rather than pre-coded rules. A deterministic backend still handles governance, audit, and regulatory calculations such as the general ledger, interest accrual, and regulatory reporting. Deterministic logic stays as code. The judgment-based decisions that used to take a lot of human effort move to agents that weigh context, handle situations they haven’t seen before, and explain their reasoning with full traceability.

### AI as Technology Abstracter: Why Execution Is No Longer the Bottleneck
In the past, any conversation about software modernization leaned heavily on the underlying technology stack, and for good reason. A strategy could fall apart if the system was written in an obscure language and sat on a pre-relational datastore.
Today we spend far less time on the underlying technology, because AI does the heavy lifting of reverse and forward engineering. The traditional bottlenecks, like analysis, decomposition, business rule extraction, and code generation, are now among the fastest parts of the work. Whether a customer has a million lines of COBOL or 20 million lines of PL/I matters less than it ever has.
AWS Transform for mainframe is built to accelerate the reimagine pattern. It helps organizations understand their current systems in depth and rebuild them as modern, cloud-native applications. The approach has three phases: reverse engineering with AWS Transform, forward engineering with Kiro or Claude Code, and testing and deployment.

### Rearchitecting for the Agentic Future
The reimagine pattern means rebuilding and rearchitecting legacy applications. Rather than a like-for-like move, we take a hard look at the technology stack, the architecture, and the business processes the current system supports before we begin, then design a target state around new patterns.
Common reimagine patterns include:
**Monolith to microservices or modular monoliths:** Decompose monolithic COBOL programs into independently deployable services. Replace terminal-based CICS (Customer Information Control System) transactions with RESTful API endpoints, and swap green-screen interfaces for modern web applications.

### A Practical Path Forward: The 3-3-3 Model with AWS Transform
With execution no longer the constraint, the hard part shifts to deciding what to build and how to shape the end state. The work now centers on two new bottlenecks:
**Defining objectives:** When we tell a customer we can address their talent risk and cost savings and, on top of that, turn a nightly batch process into a real-time transaction and open up a new product line, the conversation changes. What might have started as an IT project grows into a cross-organizational effort. If a new product is on the table, a review with marketing leads to a review with legal, which leads to a C-level decision. As the range of possible objectives grows, the risk moves from execution to analysis paralysis.
**Designing the end state:** More possibilities mean more feasible ways to implement. Older modernization approaches were opinionated about the target technology stack and usually supported only specific frameworks and runtimes. Today we can target almost anything, so the architecture and technology choices are wide open.

### Conclusion
Your core applications and data will be either the foundation or the bottleneck for AI adoption across the enterprise. The next generation of enterprise software is agent-native: deterministic logic handles what’s known, and cognitive agents handle what takes judgment. Together they make a system that’s more capable than either one alone.
Don’t wait for the perfect approach. The tools available now for modernizing core applications with agentic AI will only get better. Start now and write the blueprint for your organization. You can plan an assessment in hours with AWS Transform for mainframe and finish a POC in weeks, not months. To get started, visit [AWS Transform for mainframe]() console.
**Related resources:**


## Key insights
- The [result]() is a tax engine that scales with the season and adapts to regulatory changes in near real time.
- People define the what and the guardrails, and the agent works out the how.
- With AWS frontier agents such as the AWS DevOps Agent, customers are deploying autonomous agents that react to events in real time and resolve failures before a human needs to step in.
- The AWS DevOps Agent acts as an always-on SRE (Site Reliability Engineer) on your team.
- Businesses need to design their systems with AI agent integration in mind from the start.
- For 60 years, software followed one model: a human defines the rules, the rules are coded, the code runs deterministically, and a human steps in when needed.
- The agentic model changes that: a human defines the intent and the goals, the agent reasons over the data, and the agent acts on the human’s behalf.
- Given a goal, a set of tools, and guardrails defined by people, the agent decides how to reach the goal based on context rather than pre-coded rules.
- *Figure 5: Data Lake and Cloud analytics architecture*

The result is a cloud-native architecture, with services that scale independently, processing that runs in near real time, and data that feeds AI/ML insights instead of static reports.
- ## A Practical Path Forward: The 3-3-3 Model with AWS Transform

With execution no longer the constraint, the hard part shifts to deciding what to build and how to shape the end state.

## Exemplos e evidências
See original source at `Clippings/Beyond Mainframe Modernization Reimagining Enterprise Applications for an Agentic World.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/software-engineering/runtime]]
- [[03-RESOURCES/entities/Claude]]
- [[03-RESOURCES/entities/Codex]]
- [[03-RESOURCES/entities/AWS]]

## Minha Síntese
**O que muda:** A ser analisado em revisão manual.

**Conexão pessoal:** A ser conectado com projetos/estudo atuais.

**Próximo passo:** Nenhum próximo passo imediato.
