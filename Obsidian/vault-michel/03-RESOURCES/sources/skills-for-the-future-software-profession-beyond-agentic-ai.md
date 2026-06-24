---
title: "Skills for the future software profession: beyond agentic AI!"
type: source
source: "Clippings/Skills for the future software profession beyond agentic AI!.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
---
title: "Skills for the future software profession: beyond agentic AI!"
source: "
author:
published:
created: 2026-06-23
description:
tags:
  - "clippings"
---
Sungmin Kang [sungmin@nus.edu.sg]() [0000-0002-0298-5320]( "ORCID identifier") National University of SingaporeSingaporeSingapore, Baishakhi Ray [rayb@cs.columbia.edu]() [0000-0003-3406-5235]( "ORCID identifier") Columbia UniversityNew York CityUSA and Abhik Roychoudhury [0000-0002-7127-1137]( "ORCID identifier") National University of

## Argumentos principais
### 1\. Introduction
Agentic artificial intelligence (AI) has changed the software engineering profession, along with the skills and aptitude needed for software developers. Organizations are deploying agents in all parts of the software development lifecycle (SDLC), including writing code, reviewing commits, producing tests from issues, and even providing advice in software design. This means the role of human developers in the SDLC must change, as agents automate many tasks. Nonetheless, there is no clear consensus on what the future role of human developers will be – thus, even as developers are seeing opportunities to improve their productivity, they feel disquiet over their long-term prospects. Does the future of software engineering involve fully autonomous agents with no human in the loop? If humans are needed, what skills would they need to work with agents?
To understand what would be important for future software engineers, we conducted two roundtables on the topic of Trustworthy AI for Code, inviting experts from academia and industry. The roundtables were held in January and June 2026 respectively, in Singapore and New York, each with roughly 30-40 attendees from MIT, CMU, NUS, Imperial, Columbia, Harvard, Google, Meta, Amazon, IBM, and many others. Through surveys and group discussions, we sought to aggregate the participants’ thoughts on where the profession is headed: specifically, to distill what research will be needed and what practical skills developers will need going forward. Based on roundtable discussions, we propose a workflow for software engineers as depicted in Figure 1. It highlights the following roles for developers:
- From requirements to executable specifications. Future engineers must be educated to translate user intent into machine-checkable verification and validation artifacts that guide and evaluate AI-generated implementations. Equally important, they must learn to reason about the quality of executable specifications. As AI increasingly automates specification generation, the defining human skill will be evaluating whether those specifications faithfully capture intent, are sufficiently complete, and provide the appropriate level of assurance for trustworthy software development.

### 2\. Verification and Validation
As coding agents become increasingly capable, software verification and validation (V&V) will play a central role in software engineering. Traditionally, writing code was the most time-consuming aspect of development. As AI makes code generation inexpensive, the bottleneck shifts from software production to software assurance. Moreover, our roundtable participants observed that developers increasingly accept AI-generated code with limited scrutiny, making manual review an unreliable safeguard. Consequently, machine-checkable specifications and V&V artifacts will become the primary basis for trust, with specification and verification preceding implementation in the future software development lifecycle (Figure 1A).
This vision depends on the availability of high-quality specifications. Since formal specifications rarely exist at the start of a project, *specification inference* becomes a critical capability. AI agents can infer executable tests and formal specifications from documentation, code, and issue reports, leaving developers to assess whether these artifacts faithfully capture user intent. Although specification inference predates agentic AI [^5] [^3], it is becoming essential for trustworthy software development. For example, AutoCodeRover [^10] uses inferred specifications extracted through code search to improve coding performance, an approach later commercialized in the SonarQube Remediation Agent <sup>1</sup>. Likewise, developers increasingly rely on AI to recover code and design intent [^4], underscoring the growing importance of executable specifications.
Significant research opportunities remain. Advances in LLMs have made formal verification more accessible by largely automating proof search [^7], shifting the bottleneck from proving correctness to generating the right specifications. Verifying high-level properties often requires helper lemmas – localized specifications discovered through program analysis and invoked by agentic verifiers [^9]. While existing work focuses primarily on proof search [^8], we believe specification inference will become the more fundamental challenge for both research and practice. Moreover, inferred specifications may drift from evolving implementations, requiring future development environments to continuously validate consistency between code and specifications.

### 3\. Agentic Architecture
Once executable specifications and V&V artifacts are in place, the next challenge is designing systems of collaborating AI agents to produce trustworthy software (Figure 1B). Rather than implementing every component themselves, future engineers will increasingly architect ecosystems of specialized agents that generate, review, verify, and refine one another’s outputs. Their role will resemble that of a software architect defining the structure and interactions of distributed components, but with autonomous agents as the primary building blocks.
This shift gives rise to a new architectural discipline – *agentic architecture*. Just as an software architect decomposes systems into components and their interactions, agentic architecture concerns the organization of specialized agents, the protocols governing their collaboration, and the placement of human oversight to maximize trustworthiness. Important research questions include how agents should communicate, how workflows should be decomposed across agents, and how failures can be localized, diagnosed, and recovered. Likewise, existing natural-language interfaces may evolve toward richer specification-driven interfaces that provide greater precision and control.
These changes have important implications for software engineering education. Future engineers must understand not only how individual AI agents operate, but also how collections of agents interact to achieve system-level objectives. They should learn the principles of agentic architecture, including task decomposition, coordination protocols, human-agent interaction, and trust-aware workflow design. Beyond software construction, engineers will increasingly need to “agentify” organizational processes while reasoning about the associated security, compliance, and governance implications.

### 4\. Managing Cognitive Debt
As agents maintain a greater proportion of software artifacts, it becomes increasingly important to manage developers’ *cognitive debt* [^6]. Technical debt is a well-known concept in software engineering, arising from design and implementation compromises made to accelerate delivery. In contrast, cognitive debt emerges when developers gradually lose understanding of the intent, architecture, and rationale behind software components generated or maintained by AI agents. In the agentic era, the primary debt shifts from within the software itself (technical debt) to deficiencies in human and organizational understanding (cognitive debt).
The next generation of engineers will need to actively combat this tendency. Organizations can adopt authorship policies that assign responsibility to human custodians regardless of the actual author of the code, ensuring accountability for AI-generated artifacts. At a minimum, engineers must continue to own architectural decisions so that they can quickly localize and reason about failures as implementations become increasingly automated. More broadly, the industry is already moving toward full life-cycle engineers, extending the notion of full-stack development to encompass long-term stewardship of AI-assisted software systems [^10].
Another way to combat cognitive debt is to carefully manage artifacts beyond code. Roundtable participants emphasized maintaining repositories of requirements, executable specifications, agent instructions, tool policies, and design rationale alongside implementations. Preserving these artifacts in a structured and accessible form will be essential for maintaining organizational knowledge and reducing cognitive debt. Thus, future engineers must learn how to leverage internal codebases and semantic representations [^2] to build AI systems that better preserve consistency and institutional knowledge over time.

### 5\. Perspectives
The shift to agentic software engineering is causing an increased shift from writing code to writing specifications and managing V&V artifacts. This is leading to non-trivial changes to the software development life cycle (SDLC), such as depositing specification in a repository (e.g. markdown files, as one roundtable participant described), discussions on whether a new specification language is needed, and how specification could be made executable to prevent specification drift. All of these changes necessitate changes in future computing and software engineering curricula. Future engineers need a lot of practice in converting business requirements into checkable (executable) specifications, albeit with the assistance of AI agents. Developers will also need to compose agents and sub-agents to construct an agentic pipeline to achieve their goals. This requires a level of abstraction enhancement in the developer mind-space, since currently they are used to composing software components to construct a software system at scale. Thus, the current developer concerns about managing software scale while composing software components - may shift to future developer concerns on managing trust in agents as agentic pipelines are composed together.
Future engineers must also acquire domain expertise in areas such as finance, healthcare, and science, where correctness depends as much on domain knowledge as on software engineering. This evolution can naturally build upon the growing “Computing + X” paradigm [^1], extending interdisciplinary programs to prepare students for AI-assisted, domain-aware software development. Ultimately, these changes redefine the role of the software engineer. Just as curricula evolved to embrace object-oriented programming, distributed systems, and cloud computing, they must now prepare students for a world in which AI agents are the primary producers of software and humans are its architects, governors, and stewards.

### Acknowledgments
We would like to thank the participants of the AI for Code Roundtables in Singapore (held on 19th January 2026) and New York (held on 3rd June 2026). This research is supported by the National Research Foundation, Singapore, under NRF Investigatorship Program, ”Agentic AI based Software of the Future: from Scale to Trust”, Award ID: NRF-NRFI11-2026-0001, and National Science Foundation, USA, Award ID: NSF-CCF-2313055: ”Learning Semantics of Code To Automate Software Assurance Tasks”.
[^1]: ACM 2023: CS + X—challenges and opportunities in developing interdisciplinary-computing curricula. ACM Inroads 15 (3). Cited by: §5.
[^2]: Semcoder: training code language models with comprehensive semantics reasoning. Advances in Neural Information Processing Systems 37, pp. 60275–60308. Cited by: §4.


## Key insights
- Nonetheless, there is no clear consensus on what the future role of human developers will be – thus, even as developers are seeing opportunities to improve their productivity, they feel disquiet over their long-term prospects.
- Based on roundtable discussions, we propose a workflow for software engineers as depicted in Figure 1.
- For example, AutoCodeRover [^10] uses inferred specifications extracted through code search to improve coding performance, an approach later commercialized in the SonarQube Remediation Agent <sup>1</sup>.
- Future engineers must understand not only how individual AI agents operate, but also how collections of agents interact to achieve system-level objectives.
- They should learn the principles of agentic architecture, including task decomposition, coordination protocols, human-agent interaction, and trust-aware workflow design.
- Roundtable participants emphasized maintaining repositories of requirements, executable specifications, agent instructions, tool policies, and design rationale alongside implementations.
- Developers will also need to compose agents and sub-agents to construct an agentic pipeline to achieve their goals.

## Exemplos e evidências
See original source at `Clippings/Skills for the future software profession beyond agentic AI!.md` for detailed examples, data, and benchmarks.

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
