---
title: "From Fragments to Paths: Task-Level Context Recovery for Large Industrial Codebases"
type: source
source: "Clippings/From Fragments to Paths Task-Level Context Recovery for Large Industrial Codebases.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
Large language models have shown strong performance on software engineering (SE) tasks, yet understanding large industrial repositories remains challenging. Existing methods often retrieve only local fragments and fail to recover the broader task-relevant context needed for complex repository-level tasks. We present DeepDiscovery, a task-level repository-understanding method for large industrial codebases.

## Argumentos principais
### I Introduction
Large language models (LLMs) have shown strong performance on a wide range of software engineering (SE) tasks, including code summarization [^27], code generation [^2], program repair [^37], repository-level question answering [^35], and end-to-end task solving [^38]. However, strong performance on such tasks does not necessarily imply that current models can reliably understand large industrial code repositories [^1] [^24]. In realistic SE settings, successful task completion often requires reasoning not over a few isolated code fragments, but over a broader and more complete task-relevant context spanning interfaces [^26], business logic [^10], configuration [^9], tests [^19], and cross-module dependencies [^13]. Bridging this gap remains a fundamental challenge [^6].
The challenge becomes more pronounced in large industrial repositories, which typically contain massive numbers of files, complex dependencies, mixed artifact types, and continuously evolving organization [^29]. In such settings, existing methods often recover only limited local context. Semantic retrieval can return textually similar code fragments, but it may miss entities that are structurally important yet lexically less salient [^31]. Static dependency expansion can recover part of the explicit structure, but it still struggles with many task-relevant links that are only implicitly expressed, such as configuration registration, dependency injection, event propagation, and cross-module constraints [^20]. As a result, LLMs often see useful fragments without recovering the broader implementation context required by the task.
In practice, repository understanding also faces an important systems challenge beyond retrieval quality: repository freshness. Many repository-understanding methods rely on pre-built vector indexes [^3], static graphs [^22], or other offline artifacts [^15]. While effective in relatively stable settings, such artifacts can be costly to maintain in industrial environments with frequent commits, branch switching, module evolution, and configuration changes. When synchronization lags behind repository evolution, retrieval quality and practical timeliness can both degrade. This makes repository understanding not only a question of what context is recovered, but also whether it can be recovered effectively under realistic freshness, budget, and deployment constraints.

### II-A Code Repository Understanding
Recent work on LLM-based software engineering (SE) has moved beyond standalone code completion toward tool-integrated and agentic systems that support repository exploration, iterative reasoning, and multi-step task execution [^25] [^4] [^33] [^28]. These systems have achieved strong performance on public benchmarks [^14] [^23] [^12], suggesting substantial promise for real-world SE tasks. At the same time, strong benchmark performance does not imply robust repository-scale understanding in realistic development settings, where tasks often involve extensive cross-file dependencies, inter-module relationships, and long implementation paths [^1] [^24] [^36]. These limitations motivate methods that can provide higher-quality repository-level context for downstream reasoning.
Retrieval-augmented generation (RAG) is a widely used paradigm for repository-level code understanding [^32]. Typical methods partition repositories into file-level or chunk-level units, retrieve task-relevant content through semantic similarity, and provide the selected context to an LLM for downstream reasoning [^7] [^11]. To improve on purely semantic retrieval, subsequent work incorporates static program structures such as call graphs, import graphs, and symbol reference graphs, yielding structure-augmented retrieval or GraphRAG-style pipelines [^11] [^8] [^5]. These approaches generally improve cross-file coverage by exploiting explicit dependencies more effectively than pure vector retrieval [^16].
However, most existing methods still frame repository understanding primarily as locating relevant fragments. This is often insufficient for tasks that require recovering a broader implementation chain across files, modules, abstraction layers, configuration artifacts, and tests. The limitation is especially pronounced in industrial repositories, where many critical task-relevant links are only implicitly expressed. In addition, many retrieval-based pipelines depend on offline indexes or structural artifacts whose refresh cost may become significant in fast-changing repositories [^32] [^11] [^8] [^5]. These observations suggest the need for methods that move beyond fragment retrieval toward task-level context recovery under practical freshness and budget constraints.

### II-B Code Feature Localization
Code feature localization concerns identifying the code entities most likely to implement or constrain a target functionality or change request. In repository-scale SE tasks, localization is a critical first step because downstream reasoning depends heavily on whether the system can identify reliable entry points before broader exploration begins. Existing retrieval-based methods typically localize candidates through lexical matching, embedding similarity, or query-conditioned ranking over files and code chunks [^32] [^7]. Structure-augmented methods further improve localization by incorporating explicit dependency signals such as call, import, inheritance, and reference relations [^11] [^8] [^5].
However, accurate localization in large industrial repositories remains difficult when treated purely as a similarity-ranking problem. Many important entry points are only weakly expressed in local text and instead depend on naming conventions, framework idioms, configuration bindings, registration mechanisms, artifact roles, and directory organization. As a result, methods optimized for local relevance may still miss the high-confidence anchors needed for broader task resolution [^1] [^24]. Our *Location* stage is closely related to this line of work, but differs by performing environment-aware narrowing before candidate scoring and combining semantic evidence, structural summaries, rule-template matches, and task-conditioned artifact priors. This design aims to identify anchors that better support subsequent implementation-path recovery, rather than only ranking locally relevant files.

### III Overview of DeepDiscovery
Figure 1: Overview of DeepDiscovery. Given a task description and a large industrial repository, first performs a Location stage to narrow the search space through environment-aware analysis, adaptive repository compression, and rule-guided anchor localization. It then performs an Inference stage to expand from these anchors over a multi-relational repository graph, recover a broader implementation path, and construct a metadata-first structured context. The recovered evidence is further compressed into a structured task-level context package for downstream reasoning, rather than being passed to the downstream model as a flat list of retrieved files.
Figure 1 illustrates the overview of our DeepDiscovery. It takes as input a natural-language SE task and a large evolving repository, and produces a structured task-level context for downstream reasoning. DeepDiscovery uses a two-stage Location–Inference workflow to identify task anchors and recover broader task-relevant context. It outputs a structured context package with selected entities, metadata or text views, structural relations, and inclusion rationales.

### III-A Problem Formulation
Given a repository:
$$
\small\mathcal{R}=\{f_{1},f_{2},\dots,f_{N}\},

### III-B Repository Representation and Overall Framework
DeepDiscovery represents the repository as a multi-relational graph
$$
\small\mathcal{G}=(\mathcal{V},\mathcal{A}),

### III-C Location: Task Anchor Localization
The purpose of the Location stage is to identify a small set of high-confidence entry points for subsequent reasoning. As shown in Figure 1, this stage consists of three steps: environment-aware analysis, adaptive repository compression, and rule-guided anchor localization.
Environment-Aware Analysis. DeepDiscovery first infers task-relevant contextual factors such as the likely technology stack, module scope, artifact-role priors, and explicit task constraints. This step helps narrow the repository region that should be searched and suppresses obviously unrelated areas before deeper exploration begins.
Adaptive Repository Compression. DeepDiscovery constructs a compressed repository view under the available budget. Rather than using a fixed summary format, DeepDiscovery adjusts the granularity of the repository view according to repository scale, structural complexity, and context budget. Under larger budgets, it preserves richer module and interface cues; under tighter budgets, it prioritizes compact structural summaries and representative entities.

### III-D Inference: Multi-Relational Implementation-Path Recovery
Given the task anchors produced by Location, the Inference stage incrementally recovers a broader task-relevant implementation path. As shown in Figure 1, this stage operates over a multi-relational repository graph and consists of implementation-path recovery, candidate construction, re-ranking, and structured context construction.
At each step, DeepDiscovery considers candidate expansion actions from the current context. An action may follow explicit dependencies, implicit task-relevant links, organizational proximity, or local-search results. Rather than expanding all reachable neighbors uniformly, the system prioritizes expansion actions using a budget-aware score:
$$

### III-E Metadata-First Context Construction
The final part of the Inference stage constructs the task context in a metadata-first manner, as illustrated by the metadata-card and text-card views in Figure 1. The key idea is to preserve structural coverage while loading full text only when necessary. For each selected entity $e$, DeepDiscovery chooses between a metadata view $\mathbf{m}(e)$ and full-text content $\operatorname{FullText}(e)$:
$$
\small z_{e}=\begin{cases}\mathbf{m}(e),&\text{if }u(e\mid q,\mathcal{C}_{t})<\kappa,\\

### IV Experiments
We evaluate DeepDiscovery from three perspectives: controlled method-level comparison, system-level repository-understanding evaluation in real AI coding systems, and end-to-end impact on SWE-bench Verified. We further include ablation, efficiency, and error analysis.

### IV-A Research Questions
RQ1: How does DeepDiscovery compare with representative repository-understanding baselines in recovery quality and practical cost on medium-scale benchmarks?
RQ2: Can DeepDiscovery improve repository-understanding quality in real AI coding systems, especially in terms of fully recovering task-relevant files?
RQ3: When integrated into an end-to-end software engineering system, can DeepDiscovery improve task Solve Rate on realistic software engineering tasks?

### IV-B Experimental Setup
#### Benchmarks and evaluation scenarios.
The medium-scale and large benchmarks are drawn from a production-scale integrated codebase ecosystem that contains multiple large subprojects, sub-repository-like components, and heterogeneous business modules. This ecosystem contains 2.67 million lines of code and more than 25,000 files, spanning structurally distinct subprojects with different scopes, dependency patterns, and organizational boundaries. The medium-scale benchmark contains smaller and structurally simpler subprojects for rapid validation, while the large benchmark consists of larger and more structurally complex subprojects and business scenarios drawn from the same integrated repository ecosystem.
For the method-level comparison in RQ1, we use the 27 medium-scale tasks with 135 manually annotated gold relevant files in total. For the system-level repository-understanding evaluation, we use both the 27 medium-scale tasks and the 40 large-subproject tasks, following the same annotation protocol. For the end-to-end evaluation, we use SWE-bench Verified under a controlled comparison protocol.

### IV-C Evaluation Protocol
#### Repository-understanding metrics.
For repository-understanding quality, we use Full Recall Rate (FRR) as the primary metric. Let $\mathcal{Q}$ denote the task set, and let $\mathcal{Y}(q)$ and $\hat{\mathcal{Y}}(q)$ denote the gold and predicted relevant-file sets for task $q$, respectively. A task $q\in\mathcal{Q}$ is considered fully recalled if:
$$

### IV-D RQ1: Method-Level Comparison on Medium-Scale Tasks
TABLE I: Method-level comparison on the 27 medium-scale benchmarks. All methods are run on top of Claude Code with Claude Opus 4.6 and executed three times. FRR is reported as mean (min–max) across runs; MR and MP are reported as ranges across runs. Preprocessing and execution metrics refer only to repository-understanding cost rather than full-task cost.
| Method | FRR | MR | MP | Avg. Preprocess Time (h) | Avg. Execution Time (s) | Avg. Preprocess Tokens (Billion) | Avg. Execution Tokens |
| --- | --- | --- | --- | --- | --- | --- | --- |

### IV-E RQ2: Repository Understanding in AI Coding Systems
TABLE II: Repository-understanding results of AI coding systems on large and medium-scale subprojects. For large subprojects, results are derived from $T{=}40$ tasks and $F{=}240$ gold relevant files; for medium-scale subprojects, from $T{=}27$ tasks and $F{=}135$ gold relevant files. Full Recall is reported as mean (min–max) across three runs, while Micro Recall and Micro Precision are reported as min–max across runs. Arrows indicate changes relative to the native setting, and +DD denotes the DeepDiscovery-enhanced setting.
<table><thead><tr><th rowspan="2">System</th><th rowspan="2">Setting</th><th colspan="3">Large</th><th colspan="3">Medium</th></tr><tr><th>Full Rec.</th><th>Mic. Rec.</th><th>Mic. Prec.</th><th>Full Rec.</th><th>Mic. Rec.</th><th>Mic. Prec.</th></tr></thead><tbody><tr><th>Cline</th><th>Native</th><td>72.5% (67.5%–77.5%)</td><td>75.0%–82.5%</td><td>8.9%–9.5%</td><td>79.0% (74.1%–85.2%)</td><td>82.2%–90.4%</td><td>9.6%–11.2%</td></tr><tr><th>Cline</th><th>+ DD</th><td>81.7% (77.5%–85.0%) <math><semantics><mo>↑</mo> <annotation>\uparrow</annotation></semantics></math></td><td>82.1%–88.3% <math><semantics><mo>↑</mo> <annotation>\uparrow</annotation></semantics></math></td><td>9.4%–10.2% <math><semantics><mo>↑</mo> <annotation>\uparrow</annotation></semantics></math></td><td>86.4% (81.5%–92.6%) <math><semantics><mo>↑</mo> <annotation>\uparrow</annotation></semantics></math></td><td>89.6%–96.3% <math><semantics><mo>↑</mo> <annotation>\uparrow</annotation></semantics></math></td><td>10.3%–11.9% <math><semantics><mo>↑</mo> <annotation>\uparrow</annotation></semantics></math></td></tr><tr><th>Cursor</th><th>Native</th><td>82.5% (77.5%–87.5%)</td><td>83.8%–89.2%</td><td>8.9%–9.5%</td><td>85.2% (81.5%–88.9%)</td><td>87.4%–93.3%</td><td>10.0%–10.5%</td></tr><tr><th>Cursor</th><th>+ DD</th><td>85.0% (80.0%–90.0%) <math><semantics><mo>↑</mo> <annotation>\uparrow</annotation></semantics></math></td><td>87.5%–92.1% <math><semantics><mo>↑</mo> <annotation>\uparrow</annotation></semantics></math></td><td>9.1%–9.6% <math><semantics><mo>↑</mo> <annotation>\uparrow</annotation></semantics></math></td><td>88.9% (85.2%–92.6%) <math><semantics><mo>↑</mo> <annotation>\uparrow</annotation></semantics></math></td><td>91.9%–96.3% <math><semantics><mo>↑</mo> <annotation>\uparrow</annotation></semantics></math></td><td>10.2%–10.4% <math><semantics><mo>↓</mo> <annotation>\downarrow</annotation></semantics></math></td></tr><tr><th>Claude Code</th><th>Native</th><td>85.0% (80.0%–90.0%)</td><td>86.7%–92.1%</td><td>9.2%–9.7%</td><td>88.2% (86.4%–92.2%)</td><td>90.4%–95.6%</td><td>10.2%–10.9%</td></tr><tr><th>Claude Code</th><th>+ DD</th><td>87.5% (82.5%–92.5%) <math><semantics><mo>↑</mo> <annotation>\uparrow</annotation></semantics></math></td><td>88.3%–93.3% <math><semantics><mo>↑</mo> <annotation>\uparrow</annotation></semantics></math></td><td>9.1%–9.3% <math><semantics><mo>↓</mo> <annotation>\downarrow</annotation></semantics></math></td><td>91.4% (86.6%–94.0%) <math><semantics><mo>↑</mo> <annotation>\uparrow</annotation></semantics></math></td><td>90.4%–96.3% <math><semantics><mo>↑</mo> <annotation>\uparrow</annotation></semantics></math></td><td>10.8%–11.1% <math><semantics><mo>↑</mo> <annotation>\uparrow</annotation></semantics></math></td></tr><tr><th>Codex</th><th>Native</th><td>84.2% (77.5%–90.0%)</td><td>85.8%–91.2%</td><td>9.0%–9.6%</td><td>88.9% (85.2%–92.6%)</td><td>89.6%–94.8%</td><td>10.0%–10.8%</td></tr><tr><th>Codex</th><th>+ DD</th><td>85.8% (80.0%–90.0%) <math><semantics><mo>↑</mo> <annotation>\uparrow</annotation></semantics></math></td><td>85.4%–90.8% <math><semantics><mo>↓</mo> <annotation>\downarrow</annotation></semantics></math></td><td>9.1%–9.6% <math><semantics><mo>↑</mo> <annotation>\uparrow</annotation></semantics></math></td><td>92.6% (88.9%–96.3%) <math><semantics><mo>↑</mo> <annotation>\uparrow</annotation></semantics></math></td><td>91.9%–96.3% <math><semantics><mo>↑</mo> <annotation>\uparrow</annotation></semantics></math></td><td>10.2%–11.0% <math><semantics><mo>↑</mo> <annotation>\uparrow</annotation></semantics></math></td></tr><tr><th>OpenCode</th><th>Native</th><td>82.5% (77.5%–87.5%)</td><td>85.0%–90.4%</td><td>9.0%–9.5%</td><td>87.7% (81.5%–92.6%)</td><td>88.9%–94.8%</td><td>10.0%–10.8%</td></tr><tr><th>OpenCode</th><th>+ DD</th><td>87.5% (82.5%–92.5%) <math><semantics><mo>↑</mo> <annotation>\uparrow</annotation></semantics></math></td><td>89.6%–94.6% <math><semantics><mo>↑</mo> <annotation>\uparrow</annotation></semantics></math></td><td>9.1%–9.4% <math><semantics><mo>↓</mo> <annotation>\downarrow</annotation></semantics></math></td><td>90.2% (82.6%–91.2%) <math><semantics><mo>↑</mo> <annotation>\uparrow</annotation></semantics></math></td><td>94.1%–97.8% <math><semantics><mo>↑</mo> <annotation>\uparrow</annotation></semantics></math></td><td>10.5%–11.0% <math><semantics><mo>↑</mo> <annotation>\uparrow</annotation></semantics></math></td></tr><tr><th>Qoder</th><th>Native</th><td>82.5% (77.5%–87.5%)</td><td>84.2%–89.6%</td><td>8.9%–9.4%</td><td>85.2% (81.5%–88.9%)</td><td>88.1%–94.1%</td><td>9.9%–10.7%</td></tr><tr><th>Qoder</th><th>+ DD</th><td>84.2% (80.0%–87.5%) <math><semantics><mo>↑</mo> <annotation>\uparrow</annotation></semantics></math></td><td>86.7%–91.2% <math><semantics><mo>↑</mo> <annotation>\uparrow</annotation></semantics></math></td><td>9.0%–9.5% <math><semantics><mo>↑</mo> <annotation>\uparrow</annotation></semantics></math></td><td>88.9% (85.2%–92.6%) <math><semantics><mo>↑</mo> <annotation>\uparrow</annotation></semantics></math></td><td>91.1%–95.6% <math><semantics><mo>↑</mo> <annotation>\uparrow</annotation></semantics></math></td><td>10.0%–10.7% <math><semantics><mo>↑</mo> <annotation>\uparrow</annotation></semantics></math></td></tr></tbody></table>
Across all evaluated systems, the most consistent improvement appears on FRR. Table II summarizes the aggregate results, show run stability and metric-wise gains. On large subprojects, FRR improves for all six systems, with the largest gains for Cline and OpenCode. The same pattern holds on medium-scale subprojects, with smaller margins. These gains reflect improved recovery of complete task-relevant file sets. Figure 2 shows that the improvement is stable across runs and generally larger on large subprojects.


## Key insights
- We conduct a systematic evaluation of DeepDiscovery on a production-scale integrated repository ecosystem and in multiple real AI coding systems. The results show that DeepDiscovery substantially improves task-relevant file recovery in realistic industrial settings.
- We further show, under a controlled end-to-end comparison, that improving repository understanding is associated with stronger SE performance. A system equipped with DeepDiscovery achieves a 78.6% Solve Rate on SWE-bench Verified, improving over the corresponding baseline by 8.2 percentage points.
- These results suggest that stronger task-level repository understanding can improve coding-agent performance on complex SE tasks.
- As a result, LLMs often see useful fragments without recovering the broader implementation context required by the task.
- To address these challenges, we propose DeepDiscovery, which treats repository understanding as task-relevant context recovery rather than fragment retrieval.
- The main contributions of this paper are as follows:

- We propose DeepDiscovery, a task-level repository-understanding method for large industrial codebases.
- The results show that DeepDiscovery achieves strong task-relevant file recovery quality while avoiding offline preprocessing and reducing task-time latency relative to RAG-style alternatives.
- The results show that DeepDiscovery substantially improves task-relevant file recovery in realistic industrial settings.
- - We further show, under a controlled end-to-end comparison, that improving repository understanding is associated with stronger SE performance.
- At the same time, strong benchmark performance does not imply robust repository-scale understanding in realistic development settings, where tasks often involve extensive cross-file dependencies, inter-module relationships, and long implementation paths [^1] [^24] [^36].

## Exemplos e evidências
See original source at `Clippings/From Fragments to Paths Task-Level Context Recovery for Large Industrial Codebases.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/Claude]]
- [[03-RESOURCES/entities/Codex]]

## Minha Síntese
**O que muda:** DeepDiscovery trata repository understanding como task-level context recovery, não fragment retrieval — Location (anchor identification) + Inference (multi-relational path recovery) melhora SWE-bench em 8.2pp via metadata-first context.

**Conexão pessoal:** O padrão de metadata-first context (carregar texto completo só quando necessário) é aplicável ao vault — preferir metadata views de concepts antes de carregar conteúdo completo no contexto.

**Próximo passo:** Implementar metadata-first retrieval no pipeline de ingestão do vault — carregar títulos/tags/resumos antes de conteúdo completo.
