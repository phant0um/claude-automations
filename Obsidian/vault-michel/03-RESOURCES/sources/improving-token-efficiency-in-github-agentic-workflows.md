---
title: "Improving token efficiency in GitHub Agentic Workflows"
type: source
source: "Clippings/Improving token efficiency in GitHub Agentic Workflows.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
---
title: "Improving token efficiency in GitHub Agentic Workflows"
source: "
author:
  - "[[Landon Cox]]"
  - "[[Mara Kiefer]]"
published: 2026-05-07
created: 2026-06-23
description: "Agentic workflows that run on every pull request can quietly accumulate large API bills. Here's how we found inefficiencies and built agents to fix them."
tags:
  - "clippings"
---
GitHub Agentic Workflows is like a team of street sweepers that clean up little messes in your repo. These teams significantly improve

## Argumentos principais
### Logging token usage
We rely on hundreds of agentic workflows in our repos for maintenance and CI. All workflows run as GitHub Actions against real API rate limits. We are building the plane as we fly it and burning jet fuel as we go.
Before we could optimize our token consumption, we needed to know how tokens were consumed. The first challenge we faced was that each agent framework (Claude CLI, Copilot CLI, Codex CLI) emitted logs in a different format, and usage data could be incomplete for historical runs. Thankfully, the agentic-workflows security architecture uses an API proxy to prevent agents from directly accessing authentication credentials. This proxy gave us a way to capture token usage across all runs in a single normalized format, regardless of agent framework.
Every workflow now outputs a `token-usage.jsonl` artifact with one record per API call that contains input tokens, output tokens, cache-read tokens, cache-write tokens, model, provider, and timestamps. Combining this data with the rest of the workflow’s logs gave a historical view of how tokens were typically spent and allowed us to optimize for future runs.

### Workflows optimizing workflows
With token data in hand, we built two daily optimization workflows.
A **Daily Token Usage Auditor** reads token usage artifacts from recent workflow runs, aggregates consumption by workflow, and posts a structured report. Its job is to flag any workflow that has significantly increased its recent usage, surface the most expensive workflows, and take note of anomalous runs (e.g., a workflow that normally completes in four LLM turns taking 18).
When an Auditor flags a workflow, a Daily Token Optimizer looks at the workflow’s source and recent logs to create a GitHub Issue describing concrete inefficiencies and proposing specific optimization. The Optimizer has found many inefficiencies that we would have otherwise missed.

### Eliminating unused MCP tools
Based on our initial Auditor and Optimizer results, the most common inefficiency is unused MCP tool registrations.
Because LLM APIs are stateless, agent runtimes typically include the MCP tool function names and JSON schemas with each request. In practice, this means the full set of tools can become part of every call’s context. For a GitHub MCP server with 40 tools, this can add 10–15 KB of schema per turn. If the agent only uses two tools, the remaining 38 are pure overhead added to every request.
Workflow authors naturally start with a full tool-set since it is the path of least resistance, and the agent can figure out which tools it needs. But as time goes on, most workflows rely on a narrow, stable set of tools. The Optimizer identifies this pattern by cross-referencing tool manifests against actual tool calls and recommends pruning unused tools from the configuration.

### Replacing GitHub MCP with GitHub CLI
Removing unused MCP tools is a relatively simple win. A larger structural opportunity was replacing GitHub MCP calls for data-fetching operations like retrieving pull request diffs, file contents, and review comments with calls to the GitHub CLI.
This change did more than reduce the overhead of unused tools because an MCP tool call is a reasoning step in addition to data retrieval. The agent must decide to call the tool, formulate its arguments, and receive its output as part of the context. That’s a full round-trip LLM API call, consuming tokens for the tool-use JSON schema, the argument block, and the response. Calling `gh pr diff`, by contrast, is a deterministic HTTP request to GitHub’s REST API with no LLM involvement.
We used two strategies for this migration:

### Measuring efficiency gains is not easy
Once we began to optimize our workflows, we ran into a more nuanced problem: how do you know whether a change made things more efficient, or just made the workflow do less (and perhaps worse) work?
There are three confounding factors.
**Not all tokens are created equal**. Running the same workflow on Claude Haiku versus Claude Sonnet produces similar token counts but cost very differently. Haiku costs roughly 4× less per token than Sonnet, so a workflow that switches models appears unchanged in raw token count but represents a significant cost reduction. To account for this, we use an Effective Tokens (ET) metric that applies model multipliers to each token type:

### Initial results
After deploying the auditor and optimizer across a dozen production workflows in the `gh-aw` and `gh-aw-firewall` repos, we downloaded token-usage artifacts for runs before and after each was optimized and computed ET for each run. Nine of the 12 workflows received optimizer-recommended changes. We include results only for workflows with at least eight runs in both the pre- and post-optimization periods. These are: Auto-Triage Issues, Daily Compiler Quality, Community Attribution, Security Guard, and Smoke Claude.
Graph showing token savings across Auto-Triage Issues, Daily Compiler Quality, Community Attribution, Security Guard, adn Smoke Claude.
Auto-Triage Issues shows a clear, sustained reduction of 62% across 109 post-fix runs. Daily Compiler Quality shows 19% improvement over 12 post-fix runs, and Daily Community Attribution shows 37% improvement over eight post-fix runs. In the `gh-aw-firewall` repo, Security Guard, which audits every pull request for security-sensitive changes, and Smoke Claude an integration test that exercises the firewall’s Claude CLI path, had the most post-fix runs and show improvements of 43% and 59%, respectively.

### Take aways
Based on these results, we highlight three patterns.
**Many agent turns are deterministic data-gathering**. Auto-Triage Issues shows the strongest sustained improvement in `gh-aw` (−62% across 109 post-fix runs) because the optimization eliminated structural inefficiency: many agent turns were spent on reads that required no inference, such as fetching issue metadata and scanning labels. Moving those reads into pre-agentic CLI steps before the agent starts removed them from the LLM reasoning loop entirely. The same pattern drove Security Guard’s −43% reduction in `gh-aw-firewall`: a relevance gate now skips the LLM entirely for pull requests that don’t touch security-sensitive files. The cheapest LLM call is the one you don’t make.
Contribution Check illustrates a confounding factor: 82–83% of input tokens were cache reads (data-gathering), but average ET increased 5%. This is due to a workload shift rather than optimization failure: in the pre-optimization period 41% of runs processed small pull requests (ET < 100K) and 39% processed large pull requests (ET > 300K). The post-optimization period coincided with a burst of development activity, and the workflow processed 9% small pull requests and 65% large pull requests. Output tokens, which carry a 4× weight in the ET formula, rose 14% as the agent reviewed bigger diffs. The optimization likely improved per-turn efficiency, but the shift toward heavier workloads masks that gain in the aggregate numbers.

### What’s next?
The tools we use to optimize our workflows including API-level observability, automated auditing workflows, MCP tool pruning, and CLI substitution are all available today in the GitHub Agentic Workflows framework. Another upcoming optimization is refactoring monolithic agents into teams of subagents using smaller and cheaper models.
The next step is to move from workflow-level optimization to system-level optimization. A workflow run is not really one flat sequence of API calls. It is a chain of episodes: short phases of work like gathering context, reading artifacts, retrying after a failure, or synthesizing a final answer. Once you can see those episodes clearly, you can ask much better questions. Which episode actually caused a costly run? Which episodes are mostly repeated work, blocked work, or failed work? Which ones should stop being agentic entirely and become deterministic pre-steps?
That same logic applies at the portfolio level. Repositories do not run one workflow in isolation. They run a fleet of agentic automations that often trigger on the same events, inspect the same diffs and logs, and produce adjacent judgments. That means cost is not just a property of a single workflow, but also of overlap across the portfolio. The next analyses we want are portfolio-level ones: where workflows are duplicating reads, where several workflows should be consolidated, and where shared intermediate artifacts should be cached instead of rediscovered by each run.


## Key insights
- These teams significantly improve repo hygiene and quality, but as with all agentic work, cost is a growing concern for developers.
- The first challenge we faced was that each agent framework (Claude CLI, Copilot CLI, Codex CLI) emitted logs in a different format, and usage data could be incomplete for historical runs.
- This proxy gave us a way to capture token usage across all runs in a single normalized format, regardless of agent framework.
- Every workflow now outputs a `token-usage.jsonl` artifact with one record per API call that contains input tokens, output tokens, cache-read tokens, cache-write tokens, model, provider, and timestamps.
- Its job is to flag any workflow that has significantly increased its recent usage, surface the most expensive workflows, and take note of anomalous runs (e.g., a workflow that normally completes in four LLM turns taking 18).
- Because LLM APIs are stateless, agent runtimes typically include the MCP tool function names and JSON schemas with each request.
- If the agent only uses two tools, the remaining 38 are pure overhead added to every request.
- Workflow authors naturally start with a full tool-set since it is the path of least resistance, and the agent can figure out which tools it needs.
- The agent must decide to call the tool, formulate its arguments, and receive its output as part of the context.
- That’s a full round-trip LLM API call, consuming tokens for the tool-use JSON schema, the argument block, and the response.

## Exemplos e evidências
See original source at `Clippings/Improving token efficiency in GitHub Agentic Workflows.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/compiler]]
- [[03-RESOURCES/entities/Claude]]
- [[03-RESOURCES/entities/GitHub-Copilot]]
- [[03-RESOURCES/entities/Codex]]

## Minha Síntese
**O que muda:** A ser analisado em revisão manual.

**Conexão pessoal:** A ser conectado com projetos/estudo atuais.

**Próximo passo:** Nenhum próximo passo imediato.
