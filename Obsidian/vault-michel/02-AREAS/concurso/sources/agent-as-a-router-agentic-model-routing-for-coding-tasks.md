---
title: "Agent-as-a-Router: Agentic Model Routing for Coding Tasks"
type: source
source: "Clippings/Agent-as-a-Router Agentic Model Routing for Coding Tasks.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [concurso, source-page]
---

## Tese central
Real-world users typically have access to multiple Large Language Models (LLMs) from different providers, and these LLMs often excel at distinct domains, yet none dominate all. Consequently, routing each task to the most suitable model becomes critical for both performance and cost. Existing routers treat this as a static, one-off classification problem.

## Argumentos principais
### 1 Introduction
Modern coding agents such as Claude Code \[anthropic2025claudecode\] and Codex \[openai2025codex\] have had a significant impact on real-world software development by turning LLMs into interactive systems for coding, debugging, and repository-level programming. However, most of these agents tend to solve all tasks using the same Large Language Model (LLM) \[yue2025masrouter\]. While this design is reasonable from a *provider-centric* serving perspective, where providers prioritize in-house models and predictable serving costs \[research2026composer\], it overlooks the actual needs of users in *user-centric* scenarios, where the priority is task-level quality and cost-efficiency rather than provider-side predictability.
In such scenarios, users can subscribe to multiple providers and run capable open-source models locally. Across our experiments of 8 frontier models on various coding dimensions (Fig. 4), the best model varies per task, and always picking the globally strongest model still lags behind the per-task oracle (chooses the best model for each task). As manually selecting the best model for each task is infeasible at scale, a critical question emerges: *which model should handle each incoming task?* This motivates automatic model routing as a key mechanism for improving agent performance.
Existing routing methods typically frame this as a static classification problem, employing language models as the routing policy \[ong2024routellm, liu2026adaptive, varshney2026llm\]. However, our preliminary experiments reveal that a zero-shot LLM-as-a-Router, even when powered by a highly capable model like Claude Sonnet 4.6, still falls short of the per-task oracle by a wide margin (see Table 1). This substantial performance gap suggests that the fundamental bottleneck in model routing extends beyond pure reasoning capabilities.

### 2 Related Work
##### LLM Routing.
The problem of selecting among multiple LLMs for a given query has attracted growing attention \[dong2024automix, chen2023frugalgpt, ding2024hybrid\]. RouteLLM \[ong2024routellm\] formulated routing as a preference learning problem, training classifiers on human preference data to predict which of two models produces better responses. Meta-modeling approaches \[vsakota2024fly, shnitzer2023largelanguagemodel\] learn to predict model performance from task features. Most recently, LLMRouterBench \[duwal2026llmrouterbench\] evaluated routing across 21 general NLU datasets with 33 models. Our work differs from these by proposing Agent-as-a-Router and formalizing it as the C-A-F loop for adaptive routing. Moreover, we specifically benchmark routers in an agentic coding setting.
##### Coding Agent.

### 3.1 Preliminary: The Performance Gap Diagnosis
Table 1: Preliminary ablation study diagnosing the performance bottleneck in LLM-as-a-Router (Claude Sonnet 4.6 tested on 2,919 tasks). AvgPerf: average performance score. Perf/$: AvgPerf% per USD. Providing prior performance statistics significantly improves routing performance.
| Ablation | Interpretation | AvgPerf% | Perf/$ |
| --- | --- | --- | --- |

### 3.2 The C-A-F Loop
Following the diagnosis in §3.1, we now formalize Agent-as-a-Router that operates over the task stream and updates its internal state from each loop’s verified outcome. Concretely, the router has access to an indexed model pool $\mathcal{M}=\{m_{1},\dots,m_{M}\}$ with $M$ models and processes a stream of $N$ tasks $\mathcal{T}=(t_{1},\dots,t_{N})$ one by one. After each routing decision, the verified outcome is fed back into the context for the next decision, yielding the Context-Action-Feedback (C-A-F) loop below.
##### The C-A-F loop.
At task $t_{i}$, the router observes Context $c_{i}$, selects Action $a_{i}\in[M]$, and receives verification Feedback $f_{i}$, which is memorized into $c_{i+1}$:

### 3.3 ACRouter Instantiation
The diagnosis in §3.1 indicates three needs: (i) integrate available information at decision time, (ii) produce new execution-grounded information at each loop, and (iii) accumulate it across loops so that future decisions condition on past outcomes. ACRouter (Fig. 2) realizes these as Orchestrator, Verifier, and Memory, respectively, and evolves over the task stream with all three modules active.
Orchestrator (integrating information). The Orchestrator makes the routing decision based on dynamic context: the DimensionBest prior, the top- $10$ historical neighbors retrieved from Memory by kNN, and task metadata. The core policy is a cost-effective Qwen3.5-0.8B model fine-tuned on the CodeRouterBench probing set, combined with heuristic rules via weighted voting.
Verifier (producing information). The Verifier evaluates model output and aggregates multiple signals into a unified performance score $u_{i}\in[0,1]$ for the current task $t_{i}$:

### 3.4 Decomposed Routing Policies
The C-A-F loop provides a unified perspective to inspect existing routing strategies. By respectively restricting or removing specific components (Orchestrator, Verifier, Memory) from the full framework, we organize several baseline routing policies, which naturally set up the ablation study in §5.
Single-Model (no Orchestrator, no Memory, no Verifier). *Always- $m$* routes every task to a fixed model $m$ regardless of context. Included as a reference performance floor.
Static: Heuristic (frozen Memory; no Orchestrator policy, no Verifier). Hardcoded rules that select models from a frozen prior Memory built from probing-set statistics. *DimensionBest* is a coarse-grained oracle that routes each task to the dimensionally best model using dimension-level prior knowledge. *kNN Retrieval* selects a model based on the task-model pair retrieved from nearest-neighbor tasks in the frozen probing-set memory.

### 4 CodeRouterBench
Evaluating cumulative regret on streaming routing requires a controlled environment with pre-collected per-task per-model outcomes; existing routing benchmarks only measure single-shot accuracy and cannot support this evaluation. We therefore introduce CodeRouterBench, a unified testbed consisting of $\sim$ 10K coding tasks across 10 dimensions (see Table 5). CodeRouterBench is designed to be extensible with custom dimensions under the same C-A-F formulation.
Figure 3: CodeRouterBench construction and evaluation pipeline. Phase 1: 15 benchmark sources are unified into ∼ \\sim 10K tasks across 10 coding dimensions. Phase 2: 8 frontier LLMs generate observation matrix, scored via sandboxed execution and LLM-as-Judge. Phase 3: Several routing methods are evaluated on performance and cost metrics with Pareto analysis.

### 4.1 Benchmark Construction
Table 2: CodeRouterBench statistics.
| Statistic | Value |
| --- | --- |

### 4.2 Model Pool
We evaluate eight frontier LLMs: Claude Opus 4.6 and Claude Sonnet 4.6 \[anthropic\_opus46, anthropic\_sonnet46\], GPT-5.4 \[openai\_gpt54\], Qwen3-Max \[yang2025qwen3\] and Qwen3.5-Plus \[qwen35\_blog\], GLM-5 \[zai\_glm5\], Kimi-K2.5 \[moonshot\_kimi25\], and MiniMax-M2.7 \[minimax\_m27\]. The observation matrix of per-dimension performance is shown in Fig. 4.
We find that no single model dominates across all coding dimensions. Claude Opus 4.6 achieves the highest average (42.9%) but is outperformed on algorithm design by GLM-5 (47.2% vs. 25.4%, an 86% relative improvement), on test generation by Qwen3-Max (82.7% vs. 39.2%, a 111% relative improvement), and on data science by Kimi-K2.5 (18.4% vs. 14.2%, a 30% improvement). 5 distinct models serve as the dimension-best choice across the 9 dimensions and the costs of stronger models tend to be higher, confirming the value of model routing for both performance and cost efficiency.
Figure 4: Performance, cost, and efficiency analysis. (a) Performance heatmap of 8 models across 9 coding dimensions in the probing set, demonstrating that the optimal model varies significantly by task domain. (b) Total USD cost estimation over 7,080 probing set tasks. (c) Performance-to-cost ratio (AvgPerf% / Total Cost). Claude Opus 4.6 has roughly 12 × 12\\times the total cost of Kimi-K2.5.

### 5.1 Metrics
AvgPerf: average performance score across all tasks. CumReg: the terminal cumulative regret calculated by Eq. 7 ($\epsilon_{1},\epsilon_{2}=1,-0.1$). TotTok: total input and output token consumption (router $+$ model). $Total: calculated USD based on TotTok and official pricing (Appendix B.3). For local GPU-served routers (Finetuned LLMs, etc.), tokens are priced at $0.054/M (see Appendix B.3.2 for derivation). Perf/$: performance-to-cost ratio ($\text{AvgPerf\%}/\text{Cost}$). Above metrics are computed across all tasks.
Table 3: Routing results, grouped by component-configuration taxonomy. Left: in-distribution test across 9 single-turn coding dimensions. Right: real-world OOD test on agentic programming. CumReg: cumulative regret across all tasks. Perf/$: AvgPerf% per USD. DimensionBest is not applicable to OOD test as it requires predefined dimension-to-model mapping, which is unavailable for unseen agentic-programming tasks. The full breakdown is in the appendix.
<table><tbody><tr><td></td><td></td><td colspan="3">In-Distribution (<math><semantics><mrow><mi>n</mi> <mo>=</mo> <mrow><mn>2</mn><mo>,</mo><mn>919</mn></mrow></mrow> <annotation>n{=}2{,}919</annotation></semantics></math>)</td><td colspan="3">OOD Test (n=176)</td></tr><tr><td></td><td>Router</td><td>AvgPerf% <math><semantics><mo>↑</mo> <annotation>\uparrow</annotation></semantics></math></td><td>CumReg <math><semantics><mo>↓</mo> <annotation>\downarrow</annotation></semantics></math></td><td>Perf/$ <math><semantics><mo>↑</mo> <annotation>\uparrow</annotation></semantics></math></td><td>AvgPerf% <math><semantics><mo>↑</mo> <annotation>\uparrow</annotation></semantics></math></td><td>CumReg <math><semantics><mo>↓</mo> <annotation>\downarrow</annotation></semantics></math></td><td>Perf/$ <math><semantics><mo>↑</mo> <annotation>\uparrow</annotation></semantics></math></td></tr><tr><td></td><td>Oracle</td><td>57.00</td><td>0</td><td>8.20</td><td>75.89</td><td>0</td><td>2.32</td></tr><tr><td colspan="8">Agent-as-a-Router</td></tr><tr><td></td><td>ACRouter (ours)</td><td>49.98</td><td>205.5</td><td>3.79</td><td>62.50</td><td>17.0</td><td>1.18</td></tr><tr><td colspan="8">Dynamic: Online Bandit</td></tr><tr><td></td><td>LinTS</td><td>46.48</td><td>307.4</td><td>4.49</td><td>46.43</td><td>35.9</td><td>0.75</td></tr><tr><td></td><td>LinUCB</td><td>46.84</td><td>296.9</td><td>4.38</td><td>49.82</td><td>31.1</td><td>0.96</td></tr><tr><td colspan="8">Static: Heuristic</td></tr><tr><td></td><td>DimensionBest</td><td>47.50</td><td>277.4</td><td>3.69</td><td>—</td><td>—</td><td>—</td></tr><tr><td></td><td>kNN Retrieval</td><td>47.18</td><td>286.7</td><td>6.07</td><td>14.29</td><td>66.7</td><td>1.45</td></tr><tr><td colspan="8">Static: Trained Policy</td></tr><tr><td></td><td>LogReg</td><td>47.26</td><td>284.4</td><td>6.27</td><td>19.64</td><td>61.8</td><td>1.17</td></tr><tr><td></td><td>RouteLLM-BERT</td><td>47.22</td><td>285.5</td><td>6.22</td><td>21.43</td><td>59.4</td><td>1.30</td></tr><tr><td></td><td>TF-IDF+MLP</td><td>46.97</td><td>292.8</td><td>6.11</td><td>13.39</td><td>67.9</td><td>1.17</td></tr><tr><td></td><td>Qwen3.5-0.8B-Finetuned</td><td>46.41</td><td>309.1</td><td>6.82</td><td>55.36</td><td>27.2</td><td>0.74</td></tr><tr><td></td><td>RouteLLM-MF</td><td>46.16</td><td>316.5</td><td>6.19</td><td>8.93</td><td>72.7</td><td>0.94</td></tr><tr><td colspan="8">Single-Model Baselines</td></tr><tr><td></td><td>Always-Opus 4.6</td><td>43.83</td><td>387.1</td><td>1.29</td><td>57.14</td><td>26.7</td><td>0.64</td></tr><tr><td></td><td>Always-Kimi-K2.5</td><td>36.66</td><td>593.3</td><td>12.62</td><td>18.75</td><td>62.3</td><td>1.22</td></tr><tr><td></td><td>Always-Qwen3.5-Plus</td><td>37.16</td><td>580.2</td><td>2.05</td><td>2.68</td><td>80.1</td><td>0.19</td></tr><tr><td></td><td>Random</td><td>38.75</td><td>533.6</td><td>2.48</td><td>31.25</td><td>50.4</td><td>0.85</td></tr></tbody></table>

### 5.2 Main Results and Observations
ACRouter achieves the best AvgPerf among the routers in Table 3 on both ID and OOD tasks by dynamically accumulating context, with lower cost than always choosing the strongest single model Opus-4.6. Table 3 reports the routing comparison on both the ID test tasks (left, $n{=}2{,}919$) and the OOD agentic programming tasks (right). On the ID test, ACRouter reaches the highest AvgPerf (49.98%) and the lowest cumulative regret (205.5), beating DimensionBest with a full dimension-level prior by 2.48% AvgPerf. On the OOD test, it reaches 62.50% AvgPerf, ahead of other routers in Table 3, including the strongest single model strategy Always-Opus (57.14%) and the finetuned Qwen3.5-0.8B (55.36%). An updated standalone GPT-5.4 backend run resolves 75.00% of the same OOD split (Appendix D.7), showing that this OOD setting also exposes strong backend-level gains beyond the original single-model baselines. ACRouter still achieves higher cost-efficiency than always choosing Opus: ACRouter’s Perf/$ is 3.79 on ID and 1.18 on OOD, both exceeding Always-Opus (1.29 ID, 0.64 OOD).
Static learners reach fair AvgPerf on the in-distribution test within the same distribution but generalize poorly on OOD tasks (lower AvgPerf than Always-Opus 4.6). Table 3 also evaluates each router on OOD tasks. These OOD agentic programming tasks are more representative of real-world settings, sharing minimal overlap with the 9 single-turn coding dimensions used to calibrate the routers. The lightweight classifiers (LogReg, TF-IDF+MLP, RouteLLM-MF, RouteLLM-BERT) remain within 1.3% AvgPerf gap compared with DimensionBest on the in-distribution test, but their OOD AvgPerf drops sharply to 8.93%–21.43%, even lower than Random (31.25%). This suggests that these routers noticeably overfit to the distribution of the training set, making them hard to generalize under a substantial distribution shift.
We note that contextual bandits (LinUCB, LinTS) keep updating online and also survive better, reaching 49.82% / 46.43% OOD, but they still lag behind ACRouter on both AvgPerf and CumReg because their per-arm linear models lack the context-aware reasoning that Orchestrator and Memory provide. Fig. 5 confirms the ranking: static methods tend to accumulate higher regret (284–317 for lightweight classifiers), bandits trail slightly (297–307), and only ACRouter (205.5) shows lower regret as Memory fills the information gap during deployment. Fig. 6 also traces the Pareto frontier across all routers. ACRouter pays a higher cost (Perf/$ 3.79) for Memory and Verifier but sits above the router frontier on AvgPerf (49.98 ID, 62.50 OOD), while the updated standalone GPT-5.4 OOD result is reported separately in Appendix D.7.

### 5.3 Discussion
##### Takeaways.
We summarize the four findings of the paper: (1) the main performance bottleneck of an LLM router is *information deficit* rather than reasoning failure; (2) no single model dominates all coding dimensions; (3) full Agent-as-a-Router achieves the best performance on both in-distribution and OOD tasks, and still costs less than always choosing Opus-4.6; (4) static learners achieve fair performance on in-distribution tasks but fail significantly on OOD tasks, e.g., lightweight classifiers like RouteLLM-BERT achieve fair Perf/$ on in-distribution tasks but barely handle OOD tasks.
##### Limitations.

### 6 Conclusion
In this work, we propose Agent-as-a-Router, a routing framework that acquires execution-grounded information through a Context-Action-Feedback loop, naturally formalizable as a contextual bandit with cumulative regret as its streaming metric. We instantiate the framework as ACRouter, composed of an Orchestrator, a Verifier, and a Memory module, and evaluate it on CodeRouterBench, an evaluation environment built specifically to enable regret-based router comparison on streaming tasks. ACRouter attains the lowest cumulative regret on the in-distribution stream tasks and is the only router that maintains strong performance under the OOD agentic-programming setting. More broadly, actively closing the information gap through execution-grounded feedback emerges as a general principle for building agentic systems that must route among heterogeneous tools or models.

### Appendix A ACRouter System Architecture
ACRouter (§ 3.3) is composed of a two-layer modular architecture: a *decision layer* of three core modules that realize the C-A-F loop, and a *tool layer* of shared infrastructure that the core modules invoke (see Fig. 2). This appendix details the architecture (§A.1), the reward-weight conventions used throughout the paper (§A.2), and the C-A-F configuration taxonomy that partitions all reported routing methods (§A.3).

### A.1 Core Modules and Tool Layer
##### Core modules (decision layer).
- Orchestrator: the central coordinator that selects which candidate model to invoke for the current task $t_{i}$. It consults Memory state, ingests the DimensionBest prior, the top- $10$ historical neighbors retrieved from Memory by cosine kNN, and the task metadata, and uses a fine-tuned Qwen3.5-0.8B policy combined with heuristic rules via weighted voting to make the final dispatch decision.
- Verifier: a sandbox-native confidence estimator that examines each candidate’s output and aggregates multiple signal tiers (AST parse, sandbox execution, prompt-embedded tests, and rule-based signals) into a unified score $u_{i}\in[0,1]$ via Eq. 8. The Verifier produces the verdict that is written into Memory.


## Key insights
- Candidate Models (the model pool): the 8 LLMs available for routing (Claude Opus 4.6, Sonnet 4.6, GPT-5.4, Qwen3-Max, Qwen3.5-Plus, Kimi-K2.5, GLM-5, MiniMax-M2.7). The Orchestrator selects from these.
- Routing Tools (serve the Orchestrator): dimension-best lookup tables, trained classifiers, and LLM-based selectors. These are the concrete mechanisms the Orchestrator uses to make its selection.
- Embedding Encoder (serves Memory): maps a task’s prompt text into a dense vector for kNN retrieval. Implementations can range from a code-specialized API (e.g., voyage-code-3) to a local open-source model (e.g., BGE-large).
- Infrastructure: execution sandbox (Docker, timeouts), context parser (extracts dimension/difficulty/language from raw input), and an online updater for Memory statistics.
- Probing set (train 60% + val 10% = 7,080 tasks across 9 single-turn dimensions): Used to *develop* routers — profile model strengths per dimension, train classifiers, calibrate DimensionBest, and warm-start ACRouter’s Memory module (200 val tasks). This is the dev split for building custom routers.
- Scale yields diminishing returns under FT v4. Across a $\sim 30\times$ parameter range, AvgPerf moves only $\sim 0.5$ points ($46.21{-}46.74$). The routing signal saturates well below 27B; capacity is not the bottleneck.
- 0.8B is a defensible cost choice. Because larger sizes do not move the needle on AvgPerf, we report $0.8$ B in Table 3 as the most cost-efficient finetuned policy, and treat the larger sizes as scaling controls.

## Exemplos e evidências
See original source at `Clippings/Agent-as-a-Router Agentic Model Routing for Coding Tasks.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/Claude]]
- [[03-RESOURCES/entities/OpenAI]]
- [[03-RESOURCES/entities/NVIDIA]]
- [[03-RESOURCES/entities/Codex]]
