---
title: "How we built an internal data analytics agent"
type: source
source: "Clippings/How we built an internal data analytics agent.md"
created: 2026-06-23
ingested: 2026-06-23
score: B
tags: [concurso, source-page]
---

## Tese central
---
title: "How we built an internal data analytics agent"
source: "
author:
  - "[[Matteo Vasirani]]"
  - "[[Cynthia Joseph]]"
published: 2026-06-19
created: 2026-06-23
description: "Learn how GitHub built Qubot, our internal Copilot-powered analytics agent, to allow any GitHub employee to ask questions about our data in plain language."
tags:
  - "clippings"
---
Large data and analytics organizations often struggle to make access to data and insights truly self-serve. The industry tried to sol

## Argumentos principais
### How Qubot works
The architecture has three main components: user interface, context layer, and query engine.
Diagram showing the architecture of the Qubot analytics agent. Context and users feed into Qubot, which references Trino and Kusto for answers.

### User interface
Qubot is accessible through Slack, VS Code, and the Copilot CLI. The Slack interface doesn’t require any configuration, and it is the preferred collaboration tool of Hubbers. When someone posts a question in the Qubot Slack channel, a Qubot instance is spawned as a Copilot Cloud Agent running on github.com. The answer is provided directly in Slack, allowing the user to share the result with others, but also iterate in the thread to evolve or refine the question. All the results are also stored as a markdown report in a pull request that the user can reference to fine tune the query or use it in a dashboard.
Qubot is also available in VS Code and the Copilot CLI, for users that want an experience more integrated with their workflows. Qubot can be installed with one command as a plugin, and it becomes available in any agent session in VS Code or Copilot CLI alongside any other custom agents, skills, and tools configured by the user.

### Context layer
Our data warehouse contains data at different stages of curation: raw events (bronze), conformed facts and dimensions (silver), and curated datasets designed for specific business use cases (gold). The context layer is built in a federated way, with knowledge that is tailored to the type of data.
- For bronze data, we have telemetry context contributed by product teams, with schema information and metadata.
- For silver data, we have examples of queries, usage guidance, mandatory filters etc, maintained by the data and analytics team.

### Context agent
The context layer is constantly enriched with new knowledge persisted across multiple repositories. At GitHub, we primarily use markdown for documentation, so we don’t need to interface with multiple different tools.
We’ve streamlined federated context contribution through a context agent. Teams can contribute via a standardized template or by referencing a repository containing relevant context. The agent then ingests, organizes, and normalizes this information into a structured format that has proven effective for Qubot based on our evaluations.

### Evaluation framework
Every change to the context layer or agent configuration gets evaluated before it ships. When someone wants to enrich the context layer with new knowledge, they can open a pull request. The new context goes through an offline eval framework that measures accuracy of the response, latency in finding the right answer, and catches regressions before they reach users.
The benchmarking framework for evaluating Qubot across structured test cases has three components:
- **Test cases**: A curated dataset of prompts with known correct answers, ground-truth SQL, and metadata (domain, difficulty).

### Query engine
Qubot connects to both Kusto and Trino, the two query engines that power most of GitHub’s analytics workloads, via a MCP server. We developed a custom implementation of the Trino MCP server, while for Kusto we deployed a local version of the Fabric RTI [MCP Server](). Kusto is fast and well-suited to exploratory questions over recent event data. Trino handles complex joins and deeper historical analysis.
Rather than forcing users to know which to use, Qubot defaults to Kusto and switches to Trino automatically when the question requires it.

### What changed, and what we learned
Qubot has been widely adopted at GitHub, with hundreds of enthusiastic users running thousands of queries. The number of questions that Hubbers ask in the data and analytics Slack channels has reduced dramatically, because now they can explore the data with greater autonomy and reach out only for complicated questions. It also allows Hubbers that never dared to dip into the data warehouse to access the data they need to drive their decision making. That is one of the reasons for offering multiple interfaces like Slack, Copilot CLI, and VS Code; Hubbers are very technical, but we wanted to offer an option with no barrier to entry and zero configuration.
We quickly discovered that the context layer is key to enriching the reasoning capabilities of Copilot and to create an expert analytics agent. In our experiments we found that structured and well curated context not only makes Qubot more accurate, but also three times faster at returning the right answer. This has profound implications on the analytics engineering discipline, because it makes this type of artifact a first class citizen in how data is modeled, rather than an afterthought.
Qubot has been a rare example of successful hub-and-spoke execution. It removes strain from the data and analytics team, as product teams own the telemetry for their surfaces and business teams own the definition of their gold data. Qubot acted as a gravitational force to centralize all this distributed knowledge into a single tool that can benefit all GitHub, providing incentives to partner teams to contribute to Qubot, instead of creating multiple tools limited to their own domains.


## Key insights
- "[[Matteo Vasirani]]"
- For bronze data, we have telemetry context contributed by product teams, with schema information and metadata.
- For silver data, we have examples of queries, usage guidance, mandatory filters etc, maintained by the data and analytics team.
- For gold data, we have business rules and metric definitions, contributed by teams owning those datasets.
- Test cases**: A curated dataset of prompts with known correct answers, ground-truth SQL, and metadata (domain, difficulty).
- Automated run orchestration**: A script that automates launching each test case as an agent task with the GitHub CLI `gh agent-task create`, runs multiple parallel trials, polls for completion, and saves detailed JSON results.
- Stats aggregation**: A reporting script that reads the saved results and computes per-test-case metrics: completion rate, accuracy, and duration (avg/min/max).

## Exemplos e evidências
See original source at `Clippings/How we built an internal data analytics agent.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/software-engineering/runtime]]
- [[03-RESOURCES/concepts/llm-ml-foundations/lora]]
- [[03-RESOURCES/entities/GitHub-Copilot]]
