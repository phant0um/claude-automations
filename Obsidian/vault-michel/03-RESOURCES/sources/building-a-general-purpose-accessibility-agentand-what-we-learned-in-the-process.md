---
title: "Building a general-purpose accessibility agent—and what we learned in the process"
type: source
source: "Clippings/Building a general-purpose accessibility agent—and what we learned in the process.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
---
title: "Building a general-purpose accessibility agent—and what we learned in the process"
source: "
author:
  - "[[Eric Bailey]]"
published: 2026-05-15
created: 2026-06-23
description: "Learn about the experimental general-purpose accessibility agent that GitHub is piloting."
tags:
  - "clippings"
---
It is an understatement to say agents have become a popular way of working with code. GitHub has adopted agent-based code creation and editing for many of its initiatives, including **piloting

## Argumentos principais
### Mindset
[The social model of disability]() teaches us that access barriers—and consequently impairment—can be created because of how an environment is built. The same thinking applies to digital experiences.
With the accessibility agent, **we are not attempting to “solve” accessibility** in isolation. We are instead attempting to **augment our peers’ efforts**, to better help them remove the barriers that may be created as a result of how we construct GitHub’s user interfaces.
**The accessibility agent is not a “silver bullet”** that can automatically address every hypothetical scenario. Understanding, honoring, and socializing this better helps set the agent’s scope of responsibility. This sped up the experiment’s launch, leading to more buy-in for the effort.

### Past efforts
[The European Accessibility Act]() is now in effect. [Title II of the Americans with Disabilities Act]() is set to establish meeting WCAG 2.1 AA as the legal definition of done in April of 2027. LLM agents can read and take action on [the accessibility tree]().
To say it plainly: **Organizations will be at a disadvantage if they have not already invested in manually identifying and remediating accessibility issues**. There are many reasons for this, including building an accessibility agent.
To that point, GitHub has a mature system in place for logging accessibility issues, as well as verifying fixes to issues are working as intended. This includes:

### Old gold
Much like with any other specialized domain area, vague instructions in a skill file won’t cut it. Telling an LLM to “use accessibility best practices” with a short list of examples won’t work well.
When generating code, [**LLMs have an unfortunate bias towards producing accessibility antipatterns**]() since every major LLM currently available is trained on decades of inaccessible code.
To counteract this, the agent needs better content to draw from.

### Efficient token consumption
**Accessibility is a holistic concern**, intersecting with code, design, copywriting, and numerous other disciplines involved with creating user interfaces.
A lot of accessibility work is also **highly contextual**, meaning that someone typically needs the full working picture of a problem before they’re able to give the appropriate advice for what to do.
Because of these two factors, a general-purpose accessibility agent can consume a ton of tokens when it performs work. This has three negative outcomes:

### Use sub-agents
The accessibility agent started as a single monolithic agent, but quickly grew past the limitations of this approach. Because of this, we evolved it to use a [sub-agent architecture]().
A lot of guides recommend creating a large suite of sub-agents, each with its own specific area of responsibility. Here, the sub-agents are executed in parallel, with the main agent reconciling their output.
Surprisingly, **this approach worked against us** for the accessibility agent. Instead, we wound up using two dedicated sub-agents:

### Execute instructions in a linear order
In addition to being a holistic concern, effective digital accessibility work also demands a methodical, detail-oriented approach.
The concern of using sub-agents to increase the speed of the LLM’s reply is counterbalanced by our need for its results to be accurate. We found that **compelling the agent to execute its sub-agent instructions in a fixed order** was key.
We first establish a parent set of ordered phases. Each phase itself contains child ordered steps of instructions, which are accompanied by relevant resources and skills:

### Use a template schema pass around sub-agent content
The entire operation of the sandboxed sub-agents is built around template schema files. These files **create consistency** that is vital to keeping the agent focused and on track.
The two schema templates are:
1. **Reviewer template schema:** This focuses on what to audit, and how to find applicable information about it.

### Acknowledging limitations
Another vital aspect of creating the accessibility agent is **understanding areas where agents can fall short**.
As the agent is not a turnkey “solution” for accessibility, we want to avoid situations where the agent’s output in error may not be sufficiently interrogated by the human using it. This is especially relevant when someone is not well-versed in digital accessibility considerations and practices.
Here’s what we did to accommodate the agent’s limitations:

### Evaluate code complexity
We want to avoid scenarios where we would need to perform costly and time-intensive work to revisit an inaccessible solution that the agent “thinks” is accessible.
To aid with this problem, the accessibility agent uses a small shell script to analyze the code it is set to work on. The script itself is simple, using a small set of basic heuristics to evaluate the relative complexity and distill it down into a score.
This score is then ingested by the agent. If the score passes a set threshold, the agent is instructed to **not** execute code changes. Instead, it will inform the person using the LLM that they should reach out to the accessibility team to consult on what they are attempting to do.

### Identify high-risk patterns
It is a subtle thing to understand, but know that **it is entirely possible to have code that passes automated accessibility checks, yet is functionally unusable**.
As a companion to code complexity, the accessibility agent is instructed to avoid attempting code generation for patterns the accessibility team has identified as high-risk. This includes, but is not limited to: drag and drop, [toasts](), rich text editors, [tree views](), and [data grids]().
These patterns require a ton of focused attention and detail and currently sit outside of an LLM’s current capabilities to produce in a way that actually works with assistive technology.

### Reduce bias to action
I am loathe to anthropomorphize LLMs, but one quality they all seem to share is **desperately wanting to produce content**. For Copilot, that often means generating code.
We had to create [anti-gaming]() instructions to prevent the LLM from creating sneaky ways to get around its instructions to not generate code when human expertise is needed. This prevented it from violating its own intervention instructions.

### Know that programmatically determinable issues don’t cover everything
Agent success metrics live within a larger context.
Of the 55 total WCAG level A and AA Success Criterion, only [35 of them can be detected via deterministic automated code checkers](). This means that **~36% of level A and AA Success Criterion cannot be discovered automatically**.
A pie chart titled, 'WCAG A and AA Success Criterion'. The first of two slices is labeled, '36% require manual evaluation'. The second of two slices is labeled, '64% can be detected automatically'.

### Manually evaluate agent output and adjust things that aren’t working as expected
We periodically perform manual review of agent output to determine its accuracy and efficacy. In addition, we have tooling in place to capture pull request reviewer sentiment. Both serve as **strong signals for areas where the agent needs better instruction**, as well as new resources and skills.

### Learning in the open
To recap, we learned that the agent is:
- Used to aid and augment existing accessibility efforts, not to replace them.
- Significantly more effective when trained on manually audited and remediated accessibility issues for your specific experience.


## Key insights
- A structured template for reporting problems
- Steps to reproduce the issue
- A rich layer of metadata about the issue’s severity level, service area, and applicable [WCAG success criterion]()
- Crosslinks to the Pull Request that addressed the issue
- Escalation checkpoints**. The reviewer checks for areas where human intervention will likely be needed. This includes multiple high-severity WCAG failures, as well as a list of patterns that are known to be difficult to make accessible.
- Complexity-based behavior**. The agent is instructed to operate in a specialized guidance-only mode if the underlying code is deemed too complicated. Here, the parent accessibility agent acts as an arbiter, while the reviewer agent is “opinionless” and just reports the findings as instructed.
- Traceability**. Direct communication between sub-agents would remove the ability to create and review an audit trail of user and agent decisions. This is important given the agent’s instruction around complex patterns, as well as the highly contextual nature of accessibility work.
- Used to aid and augment existing accessibility efforts, not to replace them.
- Significantly more effective when trained on manually audited and remediated accessibility issues for your specific experience.
- Far more efficient with token consumption when utilizing sub-agents.

## Exemplos e evidências
See original source at `Clippings/Building a general-purpose accessibility agent—and what we learned in the process.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/code-generation]]
- [[03-RESOURCES/entities/GitHub-Copilot]]
- [[03-RESOURCES/entities/AWS]]

## Minha Síntese
**O que muda:** A ser analisado em revisão manual.

**Conexão pessoal:** A ser conectado com projetos/estudo atuais.

**Próximo passo:** Nenhum próximo passo imediato.
