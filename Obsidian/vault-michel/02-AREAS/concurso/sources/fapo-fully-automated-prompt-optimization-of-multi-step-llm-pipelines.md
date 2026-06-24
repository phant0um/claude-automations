---
title: "FAPO: Fully Automated Prompt Optimization of Multi-Step LLM Pipelines"
type: source
source: "Clippings/FAPO Fully Automated Prompt Optimization of Multi-Step LLM Pipelines.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [concurso, source-page]
---

## Tese central
Multi-step LLM pipelines fail through interactions among retrieval, reasoning, and formatting steps, so prompt-only optimization can miss bottlenecks in the chain. We present Fully Automated Prompt Optimization (FAPO), a framework that lets Claude Code optimize an LLM pipeline inside a standardized codebase. FAPO evaluates a pipeline, inspects intermediate steps, diagnoses failures, proposes scoped changes, and validates variants repeatedly to optimize against a score function.

## Argumentos principais
### 1 Introduction
Multi-step LLM pipelines are now common in security, enterprise analytics, and knowledge work. They combine LLM-based calls with code-based steps to produce reliable workflows. As workflow complexity and the number of LLM calls increase, traditional prompt optimization is not enough. Failures can occur at any step and propagate through to downstream components. Optimizing these systems requires more than single-turn prompt tuning.
Prompt-space search and optimization have already been extensively explored in the jailbreaking literature. In red-teaming, the target is often adversarial and Best-of- $N$: under a fixed query budget, generate or refine candidates until at least one prompt elicits a jailbreak. Search strategies include simple parallel search \[pair\], tree-based search \[tap\], repeated sampling \[bonjailbreak\], and heuristic search \[advreasoning\], all aimed at finding at least one jailbreak prompt. We use this closed-loop search pattern, but change the objective from finding one successful failure case to improving the mean score of one pipeline variant across $N$ evaluation cases. This objective shift makes attribution necessary: the optimizer must explain recurring failures rather than exploit a rare successful sample.
Existing tools leave a gap. Evaluation suites such as HELM \[helm\], BIG-bench \[bigbench\], and AgentBench \[agentbench\] measure model capabilities. However, they primarily evaluate model behavior over benchmark tasks rather than optimize the design of a fixed, inspectable pipeline. Prompt-programming systems such as DSPy \[dspy\] optimize LLM-based modules; GEPA \[gepa\] optimizes prompts inside pipelines. Neither is designed to inspect step-level failures and then change either prompts or pipeline structure inside a standard code workspace.

### 2 System Overview
Figure 1: FAPO as a reviewed improvement loop. The system tests the current workflow, records evidence from each step, proposes one allowed improvement, checks the proposal, and repeats only when the change passes review.

### 2.1 What FAPO Does
FAPO treats an LLM pipeline as an inspectable workflow. FAPO records the inputs, outputs, and logs of each step in the pipeline. The optimizer can then localize a failure to the prompt, an upstream evidence source, or the chain itself.
1. Start with one task workspace. The workspace contains the task instructions, examples, scoring rule, current prompts, and allowed changes.
2. Run the current workflow. A shared runner evaluates the pipeline on the training cases and records the final answer, score, and intermediate step outputs.

### 2.2 Tenant Organization
FAPO organizes optimization around a tenant, the unit used throughout the paper to represent a task with an evaluation criteria and workflows. The core engine is the shared runtime under src/hephaestus/: it loads cases, renders prompts, calls provider adapters, runs LangGraph chains, validates scorer outputs, writes run artifacts, and supports failure attribution. A tenant workspace under tenants/<tenant\_id>/ contains the task-local material: chain code, prompt and chain variants, dataset conversion code and JSONL caches, scorers, eval configs, tests, storage configuration, operating documents, and optimization history. The tenant playbook describes the tenant on a high-level, describes the layout of the tenant code and data, and specifies the constraints of the optimization. The tenant playbook is treated as the most important policy document during optimization and it can override FAPO capabilities. An eval config defines a reproducible chain configuration by specifying parameters as well as selecting variants (versions of prompts and chains that are generated during optimization).
We introduce this organizational structure to ensure reproducibility, isolation, and extensibility. All variants and scores are recorded in the tenant-level directories for full visibility into prior runs and optimization attempts. Tenants are isolated from each other to make sure that assumptions and invariants from one tenant do not affect any code or optimization in other tenants. This model also allows each tenant to define their own pipelines, own scoring methods, own deployment methods, and more.<sup>1</sup>

### 2.3 Design Principles
The architecture follows four principles.
- Separate the shared tester from the task. The same runner can evaluate many tasks, while each task keeps its own prompts, examples, scoring rules, and change rules in its own workspace.
- Ground decisions in recorded evidence. FAPO records intermediate steps so the optimizer can see whether a wrong answer came from retrieval, reasoning, formatting, or the final response step.

### 3 Claude-Driven Optimization
FAPO uses Claude Code \[claudecode\] as its orchestrator optimization layer, separate from the task model being evaluated. It edits the workspace, runs evaluations, dispatches subagents, and records variants via custom skills and prompts in the FAPO codebase. This optimization mechanism can optimize pipelines that use a variety of closed or open-source task models.

### 3.1 Implementation Components
The optimization loop uses three core agents. The optimization agent reads the tenant playbook and scope contract then drives the optimization loop. The step-attribution subagent analyzes failures after each evaluation. It uses rule-based checks and LLM analysis to classify failures as prompt-addressable or structural. The variant-reviewer subagent checks each proposal for scope compliance, placeholder integrity, data leakage, and scorer compatibility.
FAPO also provides Claude Code with commands and repository instructions around the optimization loop (see Table 1). These agents, commands, and skills provide guidance to Claude Code on how to efficiently optimize without violating tenant constraints and guidance.
| Artifact | Type | Role |

### 3.2 The Optimization Loop
The optimizer first reads the tenant playbook. It then writes a scope contract. The contract states which optimization levels are allowed depending on the tenant instructions. Currently three levels are possible: prompt text, chain parameters, or chain structure.
The loop then proceeds through six stages (Figure 2). First, FAPO evaluates the current variant by running the pipeline on the training split and collecting final outputs together with intermediate-step evidence. It then attributes failures by classifying them according to pipeline step and fix type. Next, it proposes a scoped variant for the dominant failure cluster, and the reviewer checks the proposal for scope compliance, placeholder integrity, leakage, and scorer compatibility. If the proposal passes review, FAPO evaluates the proposed variant and compares it to the prior best variant. Finally, it iterates or escalates: improved variants are kept, and when prompt-level search plateaus, the optimizer records the reason and explores a permitted non-prompt change only if failure analysis supports that escalation.
Figure 2: The FAPO optimization loop. The optimizer evaluates the current variant, attributes failures using step-level artifacts, proposes one scoped change, sends it to the independent reviewer, compares accepted candidates on aggregate validation scores, and then either continues prompt optimization or escalates within the scope contract when prompt edits appear insufficient.

### 3.3 Guardrails and Data Hygiene
Automated optimization without constraints tends to overfit to examples. FAPO uses four guardrails:
- Split access controls: The optimizer agent sees individual training cases. Validation and test expose aggregate scores only.
- Scope constraints: Tenant playbooks define allowed and forbidden changes. The optimizer and reviewer enforce them independently.

### 4 Evaluation
We evaluate FAPO against GEPA \[gepa\] across six benchmarks and three task models.

### 4.1 Tasks
#### Multi-hop QA.
We replicate the GEPA HotpotQA \[hotpotqa\] pipeline as a six-node LangGraph chain: two BM25 retrieval nodes ($k\!=\!7$) and four LLM nodes. The optimization metric is exact match (EM), following GEPA’s protocol; F1 is retained only as an auxiliary diagnostic. Dataset splits follow GEPA: 150 development, 300 validation, and 300 test cases. Baseline prompts use minimal DSPy-style instructions.
#### CTIBench Root Cause Mapping (RCM).

### 4.2 Experimental Protocol
#### Models and optimization budget.
For each benchmark in Table 2, FAPO starts optimization from the corresponding baseline GEPA pipeline. Both systems start from identical baseline conditions: the same chain architecture, baseline prompts, task model, sampling parameters, metric, and splits. After the baseline run, the optimization scopes differ. GEPA searches instruction strings in the reproduced DSPy program, while the FAPO scope contracts for these non-CTIBench-RCM tasks allowed prompt, chain-parameter, and chain-architecture variants under a prompt-first escalation policy. Sampling uses temperature 1.0, top- $p$ 0.95, and a nominal 16,000-token generation limit. Three task models are evaluated: GPT-4.1-mini \[openai\_gpt41\], GPT-5.4-mini \[openai\_gpt5\], and Gemma 3-12B \[gemma3\]. For GPT-5.4-mini, which the provider offers as a reasoning model, the token limit corresponds to a shared max\_completion\_tokens budget covering both hidden reasoning and visible output; for the remaining two, it applies to visible output only, as these models do not perform reasoning. The FAPO budget is limited to 50 variants or 10 optimization rounds per trial, whichever comes first. No early stopping is applied within these bounds.
#### GEPA reproduction.

### 4.3 Results
Table 2 reports the results. FAPO-optimized pipelines typically outperform GEPA-optimized chains, except for the AIME benchmark; see the subsequent discussion. On two benchmarks – HoVer and IFBench – FAPO had to escalate to pipeline optimization. On HoVer, attribution identified insufficient retrieval coverage. FAPO extended the baseline 3-hop retrieval chain to 4–5 hops, with multi-query BM25 search and entity-aware rescue. On IFBench, attribution identified format failures. FAPO added deterministic post-processing nodes that enforce instruction constraints. These changes produce gains of +24.78 to +48.56 pp on HoVer and +19.84 to +38.95 pp on IFBench.
On the remaining benchmarks, optimization stayed at the prompt level. FAPO wins 9 of 12 prompt-only comparisons, six of which have non-overlapping mean $\pm$ trial-standard-deviation ranges, suggesting statistically significant improvements. AIME is the only benchmark where GEPA leads FAPO across all three model comparisons; relative to the baselines, FAPO yields mixed results ($-2.22$, $+3.78$, and $+1.55$  pp across the three task models) that fall within the noise range, so we treat the AIME result as inconclusive rather than a consistent prompt-optimization gain. We speculate that the inconsistent AIME results may stem from overfitting to small sample sizes relative to the problem space.

### 4.4 Case Studies
#### HotpotQA.
Figure 3 shows GPT-4.1-mini validation trajectories for HotpotQA, Papillon, and LiveBench-Math. The HotpotQA trajectory reports exact match (EM), the optimization metric used for GEPA compatibility. For HotpotQA, the refreshed pristine baseline scored $39.22\pm 1.17$ % validation EM and $37.11\pm 1.07$ % test EM. The attribution subagent identified three failure categories on the dev set: near-miss (verbose answers, 13 cases), abstention (model declined to answer, 8 cases), and wrong-answer (17 cases). Variant-002 addressed near-miss failures with answer brevity constraints, raising validation EM to 65.7%; variant-003 addressed abstention failures with a must-always-answer rule, raising validation EM to 70.3%. After two iterations the attribution system flagged remaining failures as retrieval-limited (structural), indicating that further prompt-only iteration was unlikely to help. The validation-selected HotpotQA variant in Table 2 remained prompt-only.
Figure 3: Evolution of FAPO variants over time across HotpotQA, Papillon, and LiveBench-Math, using GPT-4.1-mini as the evaluated task model. Solid lines show validation performance on the benchmark optimization metric (EM for HotpotQA); dashed lines show the running-best validation score. Horizontal reference lines mark the baseline test score and final FAPO test score measured with the same benchmark metric; orange markers identify peak validation scores.

### 4.5 Discussion
#### Experimental design.
The comparison in Table 2 gives FAPO a broader optimization scope than GEPA’s prompt optimizer, which searches over instruction strings within a fixed DSPy program. For the GEPA-comparison tasks other than CTIBench-RCM, FAPO was permitted to modify chain parameters and structure (by its nature), starting from the same baseline pipeline but only after first attempting prompt optimization. Rows where FAPO modified the chain architecture are marked in the table. These results suggest that pipeline modifications can yield improvements beyond the reach of prompt-only search. The prompt-only subset still favors FAPO – 9 of 12 wins, 6 with non-overlapping mean $\pm$ trial-standard-deviation ranges – an advantage we attribute to the deep, iterative reasoning of the Claude Code orchestrator.
#### Trial variance.


## Key insights
- A Claude Code-based pipeline optimization technique. FAPO starts with prompt edits and, when permitted, resorts to pipeline-structure edits only when recorded failure evidence indicates that prompt optimization is insufficient.
- A reproducible workspace procedure for pipeline optimization. FAPO records final outputs, intermediate step outputs, configurations, and variant history.
- Experiments demonstrating the technique’s performance advantages. The evaluation spans QA, fact verification, instruction following, math, and security classification.
- Separate the shared tester from the task. The same runner can evaluate many tasks, while each task keeps its own prompts, examples, scoring rules, and change rules in its own workspace.
- Ground decisions in recorded evidence. FAPO records intermediate steps so the optimizer can see whether a wrong answer came from retrieval, reasoning, formatting, or the final response step.
- Prefer the smallest useful change. FAPO starts with prompt edits. It moves to settings or chain changes only when the recorded failures show that prompt optimization is no longer enough.
- Keep optimization bounded. The task workspace states what can and cannot be changed. The reviewer checks every proposed variant before it is evaluated.
- Split access controls: The optimizer agent sees individual training cases. Validation and test expose aggregate scores only.
- Scope constraints: Tenant playbooks define allowed and forbidden changes. The optimizer and reviewer enforce them independently.
- Iteration memory: A structured log records variants, scores, and exhaustion reasons.

## Exemplos e evidências
See original source at `Clippings/FAPO Fully Automated Prompt Optimization of Multi-Step LLM Pipelines.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/Claude]]
- [[03-RESOURCES/entities/OpenAI]]
- [[03-RESOURCES/entities/Python]]
