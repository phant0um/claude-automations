---
title: "AgentMeter: Evaluating Model–CLI Matching for CLI-Based Local Task-Solving Agents"
type: source
source: "Clippings/AgentMeter Evaluating Model–CLI Matching for CLI-Based Local Task-Solving Agents.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
LLM agents increasingly solve local tasks through command-line and CLI-based harness interfaces, including code editing, repository inspection, data analysis, and file workflows. Existing evaluations often emphasize task success, but deployed local agents are not models alone: the CLI mediates prompts, context replay, tool outputs, file access, terminal observations, and stopping behavior. As a result, the same model can produce different success, token, and cost profiles under different CLIs.

## Argumentos principais
### 1 Introduction
LLM agents increasingly operate through CLI-based harnesses for local work: they edit code, inspect repositories, analyze data, process documents, and manipulate files. In these settings, the deployed unit is a model–CLI configuration. The CLI is not only a transport layer: it mediates prompt layout, context replay, tool-output serialization, file access, terminal observations, and stopping behavior, all of which shape the evidence available to the model and the point at which a trajectory ends.
Because CLI mediation interacts with model-specific context handling and tool-use behavior, the same model can show different success, token, and billable-cost profiles under different CLIs. This matters for deployment: a useful pairing should solve tasks, expose the right evidence, avoid unnecessary repeated work, and control billable cost. Two Benchmark90 trajectories illustrate the issue. On grid-dispatch-operator, Qwen3.6 $+$ with qwen-coder passes using 369K tokens, while Qwen3.6 $+$ with Claude Code fails after 4.78M tokens and 30 repeated file reads. On sqlite-query-optimizer, Qwen3.6 $+$ passes with both Codex and Claude Code, but Claude Code uses 5.1 times as many tokens. These cases are illustrative, but they show why model and CLI behavior should be measured together.
Existing evaluation practice does not fully capture this interaction. Agent benchmarks make task success and broad agent capability visible; agent harness and CLI work enables agents to act through files, tools, and terminals; and efficient-execution work studies memory compression, context management, prompt caching, routing, serving optimization, and tool-output control. These lines of work are complementary, but they do not provide a benchmark and metric whose evaluation unit is the deployed model–CLI configuration under both success and cost constraints.

### 2.1 Agent Benchmarks
Agent benchmarks make interactive work measurable by turning realistic tasks into reproducible evaluation environments. SWE-bench evaluates software-engineering issue resolution [^10], Terminal-Bench focuses on terminal-centered tasks [^26], and AgentBench, GAIA, and WebArena evaluate broader tool use, reasoning, web operation, and environment interaction [^13] [^14] [^28]. DA-Code focuses on data-analysis coding workflows [^9]. Together, these benchmarks make agent capability and task success observable across software, terminal, web, and data-analysis settings.
AgentMeter follows this benchmark tradition but changes the evaluation unit. Existing benchmarks typically ask whether a model or agent system completes a task under a chosen harness. In contrast, AgentMeter asks how a deployed model–CLI configuration behaves under both success and cost constraints. This distinction matters for CLI-mediated local agents because the interface controls how files, terminal observations, tool outputs, and history are exposed to the model. The same model can therefore obtain different success, token, and billable-cost profiles under different CLI mediation. AgentMeter is designed to make this model–CLI interaction directly measurable rather than treating the CLI as a fixed wrapper.

### 2.2 Agent Interfaces and CLI Harnesses
Agent interfaces and harnesses define how models act in environments. A broad harness may include web or GUI interaction, memory, scheduling, multi-agent control, environment setup, logging, and scoring infrastructure. Within this broader space, CLI-mediated local task solving is a controlled and widely used deployment layer: the agent operates over local files, shell commands, terminal observations, and serialized tool outputs.
Prior work on agent-computer interfaces shows that interface design can affect automated software-engineering performance [^27]. This suggests that the interface should not be treated as an implementation detail. AgentMeter extends this view from capability evaluation to cost-aware deployment evaluation. It does not propose a new CLI or optimize a particular interface. Instead, it evaluates how existing CLI interfaces interact with different model families on the same local tasks. By varying the model–CLI pairing while keeping the task environment fixed, AgentMeter makes interface-mediated differences in success, trajectory footprint, and billable cost observable at the trajectory level.

### 2.3 Efficient Agent Execution
Efficient agent execution has been studied through component-level techniques such as cost-aware routing, memory and context systems, prompt caching, serving optimization, and tool-output control. Memory and context systems compress histories or retrieved context [^7] [^20]. Tool-use work reduces or structures tool descriptions and API use [^22] [^25]. Routing systems choose among models to reduce cost while preserving quality [^17] [^6]. Serving systems and prompt caching reduce inference cost through cache reuse and prefix stability [^11] [^21] [^4].
These works optimize important execution components. AgentMeter is complementary: it evaluates the end-to-end trajectory of a deployed model–CLI configuration after interface mediation, context handling, tool interaction, raw token use, cache accounting, and model-specific pricing have all taken effect. This full-trajectory view is necessary because component-level efficiency alone does not determine deployment utility. A configuration may solve more tasks while wasting tokens, or appear cheap per successful task while failing too often. AgentMeter therefore evaluates success, raw token footprint, billable cost, and expensive failure jointly through a matching-oriented metric.

### 3.1 Design Goals
AgentMeter evaluates model–CLI configurations in local task-solving settings where the deployed unit is not just a model but the model plus the command-line interface that mediates tool use. The benchmark is constructed around three goals. First, tasks should require realistic local workflows, including code editing, repository inspection, shell commands, data processing, and document manipulation. Second, evaluation should record both task outcomes and the trajectory through which those outcomes are obtained. Third, the benchmark should separate calibrated task-effort tiers from final cost-aware scoring.

### 3.2 Task Sources
Benchmark90 contains 90 local task-solving tasks drawn from three sources: SkillsBench tasks [^12], Terminal-Bench tasks, and DA-Code tasks. These sources provide complementary coverage of coding, terminal, data, document, and analysis workflows. The final tier split contains 30 Easy, 30 Medium, and 30 Hard tasks. The final Benchmark90 source composition is Easy: 21 Terminal-Bench, 1 SkillsBench, and 8 DA-Code tasks; Medium: 5 Terminal-Bench, 17 SkillsBench, and 8 DA-Code tasks; Hard: 28 SkillsBench and 2 DA-Code tasks.

### 3.3 Benchmark90 and Core30
Benchmark90 is the full validation set. It is used to test whether model–CLI ranking structure remains stable over a broader 90-task sample. Core30 is derived from Benchmark90 as a lower-cost subset for evaluating more model–CLI configurations. It is not a replacement for Benchmark90: Core30 enables broader configuration coverage, while Benchmark90 validates whether the ranking structure persists on the full task set.
The Core30 comparison contains 30 tasks and 24 complete model–CLI configurations, formed by six models and four CLIs. Its task composition is 16 SkillsBench tasks, 9 Terminal-Bench tasks, and 5 DA-Code tasks. Under the final Benchmark90 task-effort calibration, Core30 contains 10 Easy, 10 Medium, and 10 Hard tasks. Because Core30 is used for expanded configuration comparison rather than as a standalone benchmark, we also report Benchmark90 validation on the overlapping complete configurations.
The reported configurations combine models from the Qwen3.6+, DeepSeek-v4-pro, GLM-5.1, MiniMax-M2.5, Claude Sonnet 4.6, and GPT-5.3-Codex families [^23] [^8] [^15] [^2] [^5] [^19] with CLI interfaces including Claude Code, Codex CLI, qwen-coder, and kimi-cli [^3] [^18] [^24] [^16]. These references identify the model and CLI families; AgentMeter evaluates the deployed pairings rather than treating either side as an isolated object. The Core30 main experiment uses the complete six-by-four grid of retained model and CLI families with executable and auditable runs.

### 3.4 Task-Effort Tiers
Task effort changes what constitutes a good model–CLI match. On Easy tasks, many configurations can solve the task, so efficient completion is more informative. On Medium tasks, the success–cost tradeoff becomes central. On Hard tasks, success remains important, but avoiding expensive failure is also part of deployed behavior. Easy, Medium, and Hard tiers are therefore an evaluation lens for matching quality under different effort regimes, not source labels.
Tiers are calibrated before deployment-utility scoring. For each task $i$, we compute an empirical effort score $E_{i}$. Let $p_{i}$ be the pass rate across observed configurations, $r_{i}$ be the mean reward, $s_{i}=0.7p_{i}+0.3r_{i}$ be completion-adjusted aggregate solvability, $\widetilde{T}_{i}$ be the median raw-token footprint, $\widetilde{U}_{i}$ be the median turn count, and $\widetilde{I}_{i}$ be the median interaction footprint. The function $q(\cdot)$ denotes percentile-rank normalization over the 90 Benchmark90 tasks. Let $\ell(x)=\log(1+x)$:
$$

### 3.5 Evaluation Protocol
Each model–CLI–task attempt runs in the matching local task environment under the same task-level wall-clock and token-budget settings. Task-level non-completion contributes zero task quality. Infrastructure-invalid attempts are audited separately and excluded from model–CLI conclusions when they are not attributable to the configuration. Attempted runs remain part of token and cost accounting because failed trajectories can still consume deployment resources.
When multiple attempts are available for the same model–CLI–task combination, a deterministic latest-completed selection rule is applied before aggregation. This avoids manual cherry-picking while keeping one selected trajectory per configuration and task. Coverage and validity filtering are audited before aggregation; cost diagnostics are reported in the main result tables.

### 4 Token-Economic Metrics
AgentMeter evaluates model–CLI configurations under two deployment requirements: the configuration should solve tasks, and it should do so within realistic resource budgets. A matching metric must therefore be anchored in task completion while remaining sensitive to trajectory cost and expensive failure.

### 4.1 Conventional Diagnostics
Let run $i$ have scalar task quality $R_{i}$, pass indicator $y_{i}$, raw token consumption $T_{i}$, and cache-adjusted billable USD cost $C_{i}$. For binary task evaluators, $R_{i}=y_{i}\in\{0,1\}$; for evaluators that return scalar task quality, $R_{i}$ denotes the normalized task-level quality used for aggregation, while $y_{i}$ records whether the task is counted as passed.
We retain three conventional diagnostics because each captures an interpretable part of deployed behavior. Success counts solved tasks under the relevant benchmark denominator, such as Pass/30 for Core30 or Pass/90 for Benchmark90. Tok./Pass divides total raw token consumption by the number of successful tasks, measuring trajectory footprint per obtained success. The billable USD/Pass diagnostic divides total cache-adjusted USD cost by the number of successful tasks, measuring deployment-facing cost under the pricing snapshot used in this study [^1].
Each diagnostic is useful, but none is sufficient for model–CLI matching. Success ignores the resources consumed to obtain completion. Tok./Pass ignores model-specific pricing and cache accounting. USD/Pass reflects deployment-facing price, but can still make a low-coverage configuration look attractive when failures are cheap or short. A direct success/cost ratio is also unstable when cost is small and can over-reward cheap non-completion. The final metric therefore uses these diagnostics as interpretable views rather than as the sole selection rule.

### 4.2 Budgeted Quality and Expensive Failure
Table 1: Tier-specific USD budget grids and expensive-failure thresholds.
| Tier | $\mathcal{B}_{g}$ | $\tau_{g}$ |
| --- | --- | --- |

### 4.3 AgentMeter Score
AgentMeter Score is the primary metric in this paper. It is success-anchored, cost-aware, tier-calibrated, and explicitly penalizes expensive failure. For each tier, the success anchor is
$$
\displaystyle\mathrm{SR}_{g}(c)={}

### 5.1 Core30 Main Comparison
Rows are model–CLI configurations rather than tasks; each row is evaluated on the same 30 Core30 tasks. Table 2 shows that common deployment criteria select different model–CLI configurations. Highest Pass/30 selects GLM-5.1 with qwen-coder (18/30), lowest Tok./Pass selects GPT-5.3-Codex with kimi-cli (0.42M tokens/pass), lowest USD/Pass selects Qwen3.6 $+$ with Codex (0.047 USD/Pass), and highest AMS selects Qwen3.6 $+$ with kimi-cli (0.529). Thus, task success, raw token footprint, billable cost, and the final matching score do not collapse to a single model-only ranking.
Figure 1(b) summarizes how Pass/30, USD/Pass, and AMS select different pairings. Qwen3.6 $+$ with kimi-cli has the highest AMS, GLM-5.1 with qwen-coder has the highest pass count, and Qwen3.6 $+$ with Codex has the lowest USD/Pass. Table 2 reports the Tok./Pass winner, GPT-5.3-Codex with kimi-cli. AMS favors Qwen3.6 $+$ with kimi-cli because it better matches the deployment utility encoded by AgentMeter: Easy tasks should be solved with little waste, while Medium and Hard tasks should reward success within tier-specific budgets and penalize costly failures.

### 5.2 Same-Model Cross-CLI Matching
Holding the model fixed isolates the CLI side of the match. As Figure 1(a), Figure 2, and Table 3 show, the best CLI depends on the model: Qwen3.6 $+$ is strongest with kimi-cli, GLM-5.1 with qwen-coder, MiniMax-M2.5 with Codex, Claude Sonnet 4.6 with Codex, and GPT-5.3-Codex with Codex. This means that the CLI is not a neutral transport layer for a model.
Table 3: Best and worst CLI per model on Core30 among the 24 complete configurations. The AMS spread isolates same-model CLI sensitivity.
| Model | Best CLI | Best AMS | Worst CLI | $\Delta$ AMS |


## Key insights
- We formulate model–CLI matching as an evaluation problem for CLI-mediated local task-solving agents.
- We construct AgentMeter Benchmark90 and Core30 to evaluate model–CLI configurations across terminal, local workflow, and data-analysis tasks.
- We propose AgentMeter Score, a success-anchored and cost-aware metric over calibrated task-effort tiers, and show that success, token footprint, billable cost, and AMS can rank configurations differently.

## Exemplos e evidências
See original source at `Clippings/AgentMeter Evaluating Model–CLI Matching for CLI-Based Local Task-Solving Agents.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/code-generation]]
- [[03-RESOURCES/entities/Claude]]
- [[03-RESOURCES/entities/OpenAI]]
- [[03-RESOURCES/entities/Codex]]

## Minha Síntese
**O que muda:** A unidade de avaliação para agentes CLI é a config model-CLI, não o modelo isolado — mesmo modelo com CLIs diferentes produz diferentes success, token e cost profiles, e o melhor CLI depende do modelo.

**Conexão pessoal:** Ao escolher entre Claude Code, Codex CLI e outros para tarefas do vault, preciso avaliar a combinação model+CLI, não apenas o modelo — não existe CLI neutro.

**Próximo passo:** Benchmarkar Claude Code vs Codex CLI com o mesmo modelo em tarefas reais do vault para identificar a melhor combinação.
