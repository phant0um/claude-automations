---
title: "Probe-and-Refine Tuning of Repository Guidance for Coding Agents"
type: source
source: "Clippings/Probe-and-Refine Tuning of Repository Guidance for Coding Agents.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [concurso, source-page]
---

## Tese central
LLM-based coding agents need higher-level operational knowledge about a repository (which files house which subsystems, how to run the test suite, which workflows have historically led to wrong fixes) that does not exist in the code itself. Engineers typically maintain AGENTS.md files to supply this context as instructions for coding agents, but whether they help is contested: recent studies disagree on whether LLM-generated guidance improves or harms agent performance. In this paper we show tha

## Argumentos principais
### 1 Introduction
LLM-based coding agents operate in a loop of reading code, running commands, and proposing edits to code. They are increasingly being deployed and used for software engineering tasks in real-world contexts. The effectiveness of the agents depends on more than just the model’s underlying capability. A code repository is a body of accumulated decisions: subsystem boundaries, naming conventions, debugging workflows that experienced contributors have internalized but that are not documented in the code itself. A model that has never worked in a particular codebase has to reconstruct this implicit knowledge on the fly, often by trial and error, and frequently lands in the wrong file or proposes a fix that breaks orthogonal subsystems.
Engineers have responded by maintaining repository-level context files (variously named AGENTS.md, CLAUDE.md, or similar) that document conventions, entry points, test-running instructions, and debugging strategies for use by coding agents. These files have proliferated rapidly: [^15] survey 2,303 such files in active use across public repositories. Whether these context files help coding agents is still debatable. [^5] find that curated AGENTS.md files reduce agent runtime by 28.6 % and output tokens by 16.6 % on focused pull requests, measuring efficiency rather than correctness. [^6] find the opposite: LLM-generated context files reduce resolve rates by $\sim$ 3 % on SWE-bench Lite [^2] and on AGENTBENCH, a benchmark they introduce of bug-fix and feature-addition tasks drawn from repositories with developer-written context files, with agents following instructions literally even when those instructions are counterproductive. The disagreement leaves practitioners with no principled basis for deciding whether to invest in such guidance, what should go in it, or how to produce it.
A natural question is whether the problem lies with guidance as a concept or with how it is produced. Single-pass LLM generation yields generic advice; perhaps iteratively refined, failure-informed guidance would behave differently. What an experienced contributor knows about a repository is operational and specific: *which* test file to run for a particular subsystem, *which* module to trace through when debugging a particular class of bug, *which* kinds of fixes to avoid because they have historically broken downstream consumers. This kind of knowledge cannot be produced by introspection alone; it has to be learned from observed failures. Yet the agent’s own instructions, the text that tells it how to approach a repository, have received surprisingly little systematic attention, with most improvement efforts focused on models, scaffolds, or context windows.

### 2 Related Work
#### AGENTS.md and context files.
The two studies closest to ours ask directly whether repository context files help, and reach opposite conclusions. [^5] find that curated AGENTS.md files improve agent efficiency on focused pull requests (28.6 % less runtime, 16.6 % fewer output tokens), measuring cost rather than correctness. [^6] instead find that LLM-generated context files *reduce* resolve rates on SWE-bench Lite and on their own AGENTBENCH (a collection of issues from repositories with developer-committed context files), with agents following the files’ instructions literally even when doing so is counterproductive (e.g., a tool named in the file was used $160\times$ more often than without it). We reconcile this disagreement by showing it turns on *how* the guidance is produced and on a variable neither study manipulates: neither varies the agent’s step budget, and [^6] report steps only as a cost metric rather than asking how a fixed budget interacts with guidance (Section 6). Two further studies characterize what such files contain rather than whether they help. [^15] survey 2,303 context files and find developers prioritize build commands, implementation details, and architecture, the same categories probe-and-refine arrives at automatically (Section 3.3, Table 2). [^16] argue that single-file manifests do not scale beyond $\sim$ 100k lines and propose a tiered architecture, a limitation our compact ($\leq$ 3000-character) single-file artifacts share and do not attempt to overcome.
#### Coding-agent scaffolds and benchmarks.

### 3 Design and Implementation
This section describes the probe-and-refine procedure and the experimental apparatus around it. We first give a system overview, then define the three context conditions we compare, detail the probe-and-refine tuning loop itself, and describe the coding agent and fallback that consume the resulting guidance. The four sections that follow (Sections 4–7) each report a separate experiment—the main four-trial comparison (Section 4), a localization analysis (Section 5), a step-budget sweep (Section 6), and a cross-model study (Section 7)—and share a common structure: what we wanted to test, how we tested it, the results, and what we learned.

### 3.1 System Overview
At a high level, the goal of our work is to compare how a coding agent performs on SWE-bench Verified under three different repository-context conditions: with no guidance, with a two-layer static knowledge base comprising tree-sitter-assisted parsing (tree-sitter is a source-code parser) of the repository structure and one-shot LLM-generated generic guidance, and with guidance produced by our probe-and-refine procedure. The procedure itself is the only novel system component; everything else (the agent scaffold, the evaluation harness) is held fixed across conditions in the main experiment so that any performance difference is attributable to the guidance. The four pipeline stages we describe in this section are: building the repository context, running probe-and-refine tuning to produce the refined-guidance condition, generating patches with an interactive coding agent, and evaluating those patches with the official SWE-bench Verified harness.
Most of our analysis uses Qwen/Qwen3.5-35B-A3B [^4]; the cross-model experiment in Section 7 substitutes NVIDIA-Nemotron-3-Nano-30B-A3B but is otherwise identical in design. We use an effective 16k-token context window (a hard truncation we impose to keep prompt costs uniform across conditions; the model natively supports longer contexts), 2048 max output tokens per turn, and 512 max tokens for fallback generation. Command outputs are truncated to $\sim$ 3000 characters. These constraints result in absolute resolve rates well below what larger-context configurations achieve. Thus the main contribution of our work in this space is the relative comparison across conditions, not the absolute numbers.
#### Model selection.

### 3.2 Context Conditions
Next, we describe the three context conditions that define our independent variable. They differ only in the repository-specific guidance the agent receives; the scaffold, model, and harness are held fixed across all three, so any performance difference is attributable to the guidance alone. no\_context measures the agent alone, static\_kb adds generic guidance, and probe\_refined adds iterative refinement on top.
#### no\_context.
The bare agent prompt with no repository-specific guidance.

### 3.3 The Probe-and-Refine Procedure
Figure 1: Probe-and-refine tuning pipeline. The static\_kb artifact feeds both the condition directly and the refinement loop, which transforms it into the refined guidance using synthetic probes and single-shot diagnosis. No SWE-bench evaluation instances are used during refinement. All three conditions feed the same fixed coding agent.
The probe-and-refine procedure (Figure 1) transforms generic structural knowledge into repo-specific operational guidance through iterative failure feedback. Every step in the procedure is a single-shot call to the same model (Qwen3.5-35B-A3B) that will later be used by the coding agent during patch generation. Using the same model keeps the experiment controlled: the guidance is written at the level the consuming model can understand, and any improvement must come from the content of the guidance rather than from a capability mismatch between a stronger tuning model and a weaker execution model.
Each of 3–5 iterations proceeds through four types of single-shot LLM call, with steps 2 and 3 repeated per probe (10 probes per iteration, $\sim$ 22 total calls):

### 3.4 Coding Agent and Fallback
The coding agent operates in a ReAct-style loop [^9]: at each step it emits a bash command, observes the (truncated) output, and decides the next action, alternating between acting and observing until it produces a patch or exhausts its step budget. This is the only multi-step process in the entire system; the probe-and-refine procedure described above does not use it. If the agent fails to produce a patch within the step budget, a single-shot fallback generates a patch from the issue description and any context accumulated during exploration. The fallback uses the same temperature (0.0) and context window as the agent’s regular inference calls. Patches from both sources are sanitized (removing test-file modifications, enforcing diff format) before evaluation. Mean fallback rates across the four trials differ substantially across conditions (14.8 % for probe-and-refine vs. 30.8 % for static-KB and 25.6 % for no-context at 200 steps), so the fallback pathway is not a uniform noise source; the guided agent more often succeeds within its main loop.

### 4.1 Motivation
We wanted to know whether an agent produces more solves on SWE-bench Verified with probe-refined guidance versus our static-KB guidance and an unguided baseline.

### 4.2 Methodology
We evaluate all three conditions, no\_context, static\_kb, and probe\_refined, at 200 agent steps on 500 SWE-bench Verified instances across four independent trials.
All guidance artifacts are generated from a single pinned commit per repository (Table 3). The same guidance is then applied to all SWE-bench instances from that repository, regardless of which commit the instance originally targets. The temperature is 0.0 for all inference calls (including the single-shot fallback) except probe generation (0.9). The temperature of 0.0 makes the model as reproducible as possible between runs, while the probe generation temperature of 0.9 ensures that the model still has the variance necessary to avoid generating the same probes repeatedly. The four trials at 200 steps were run on the same hardware under identical settings, independently, allowing us to estimate run-to-run variance and report effect sizes with appropriate uncertainty rather than relying on single-run point estimates.
| Repository | Pinned SHA (first 8) | Instances |

### 4.3 Results
Across four independent trials, probe-and-refine guidance achieves a mean resolve rate of 33.0 % (SD 1.8 pp), compared with 28.3 % (SD 1.4 pp) for static-KB and 25.5 % (SD 2.2 pp) for no context (Table 4, Figure 3). The ordering probe-refined $>$ static $>$ no-context holds in 4/4 trials with no exceptions, for both resolve rate and coverage. Per-trial Wilson 95 % CIs on the resolve rates do not overlap between probe-refined and no-context in three of the four trials (T1, T3, T4); in T2 the CIs overlap by a small margin, though the within-trial McNemar test remains significant ($p<0.001$) due to the paired structure.
<table><thead><tr><th>Trial</th><th>Condition</th><th>Resolve</th><th>Coverage</th><th>Precision</th></tr></thead><tbody><tr><th rowspan="3">T1</th><td>no_context</td><td>22.8 %</td><td>37.4 %</td><td>61.0 %</td></tr><tr><td>static_kb</td><td>27.4 %</td><td>47.2 %</td><td>58.1 %</td></tr><tr><td>probe_refined</td><td>34.2 %</td><td>57.4 %</td><td>59.6 %</td></tr><tr><th rowspan="3">T2</th><td>no_context</td><td>27.8 %</td><td>43.6 %</td><td>63.8 %</td></tr><tr><td>static_kb</td><td>30.2 %</td><td>52.2 %</td><td>57.9 %</td></tr><tr><td>probe_refined</td><td>30.6 %</td><td>54.4 %</td><td>56.2 %</td></tr><tr><th rowspan="3">T3</th><td>no_context</td><td>24.8 %</td><td>43.2 %</td><td>57.4 %</td></tr><tr><td>static_kb</td><td>27.0 %</td><td>51.0 %</td><td>52.9 %</td></tr><tr><td>probe_refined</td><td>32.4 %</td><td>55.0 %</td><td>58.9 %</td></tr><tr><th rowspan="3">T4</th><td>no_context</td><td>26.4 %</td><td>42.8 %</td><td>61.7 %</td></tr><tr><td>static_kb</td><td>28.6 %</td><td>52.0 %</td><td>55.0 %</td></tr><tr><td>probe_refined</td><td>34.6 %</td><td>58.0 %</td><td>59.7 %</td></tr><tr><th rowspan="3">Mean <math><semantics><mo>±</mo> <annotation>\pm</annotation></semantics></math> SD</th><td>no_context</td><td>25.5 <math><semantics><mo>±</mo> <annotation>\pm</annotation></semantics></math> 2.2 %</td><td>41.7 <math><semantics><mo>±</mo> <annotation>\pm</annotation></semantics></math> 2.9 %</td><td>61.0 <math><semantics><mo>±</mo> <annotation>\pm</annotation></semantics></math> 2.6 %</td></tr><tr><td>static_kb</td><td>28.3 <math><semantics><mo>±</mo> <annotation>\pm</annotation></semantics></math> 1.4 %</td><td>50.6 <math><semantics><mo>±</mo> <annotation>\pm</annotation></semantics></math> 2.3 %</td><td>56.0 <math><semantics><mo>±</mo> <annotation>\pm</annotation></semantics></math> 2.5 %</td></tr><tr><td>probe_refined</td><td>33.0 <math><semantics><mo>±</mo> <annotation>\pm</annotation></semantics></math> 1.8 %</td><td>56.2 <math><semantics><mo>±</mo> <annotation>\pm</annotation></semantics></math> 1.8 %</td><td>58.6 <math><semantics><mo>±</mo> <annotation>\pm</annotation></semantics></math> 1.6 %</td></tr></tbody></table>
Table 4: Per-trial resolve rate, coverage, and precision by condition. The ordering probe-refined $>$ static $>$ no-context holds in 4/4 trials for both resolve rate and coverage. Precision is approximately constant across conditions in every trial.

### 4.4 Analysis
Figure 4: Mean evaluation coverage across four trials at 200 steps. Probe-and-refine produces evaluable patches for 56.2 % of instances on average (SD 1.8 pp) vs. 41.7 % (SD 2.9 pp) for no context. Precision ( ∼ \\sim 59 %) is similar across conditions and not statistically distinguishable in a hierarchical model on the evaluated subset.
The resolve-rate differences are driven entirely by evaluation coverage: the fraction of instances for which the agent produces a patch that can be evaluated by the SWE-bench harness. A mixed-effects logistic regression on the evaluated subset only (i.e., $\text{resolved}\sim\text{condition}+(1\mid\text{instance})+(1\mid\text{trial})$ restricted to evaluable patches, $n{=}2971$) finds no significant effect of condition on precision: likelihood-ratio test $\chi^{2}(2)=4.26$, $p=0.119$. Pairwise contrasts on the evaluated subset are also non-significant (probe-refined vs. no-context: $p=0.47$; static vs. no-context: $p=0.078$). Conditional on producing a patch the harness can evaluate, the three conditions resolve issues at approximately the same rate.
Table 8: Mean precision (resolved / evaluated) across four trials at 200 steps. Differences across conditions are not statistically significant in a hierarchical model on the evaluated subset ($p=0.119$).

### 5.1 Motivation
We wanted to understand what kind of instances refined guidance helps with. If refined guidance helps with a specific kind of instance, such as in a particular type of repository or of a particular difficulty, that would have implications for the generalization of probe-and-refine tuning. The localization hypothesis is that probe-refined guidance increases solves primarily by helping the agent find the right file locations for a given fix.

### 5.2 Methodology
To understand what kind of instances refined guidance helps with, we examined the 31 instances that probe\_refined resolves consistently ($\geq 3$ of 4 trials) and that neither no\_context nor static\_kb resolves consistently, the cleanest available signal of what probe-refined guidance uniquely contributes.

### 5.3 Results
#### The unique solves are not the hard instances.
Contrary to the natural prediction that additional guidance would help on harder bugs, the 31 probe-refined-only consistent solves are easier than the benchmark average. Median patch size is 5 added lines (vs. 4 across the full benchmark); 13 % are multi-file (vs. 14 %); 13 % include a traceback in the problem statement (vs. 14 %); 45 % are SWE-bench-rated as $<\!15$ minute fixes (vs. 39 %) and only one exceeds one hour. Roughly a third are small additive feature requests (e.g., “expose warm\_start”, “add fill\_value”, “make element\_id optional in json\_script”) where the task is not writing a complex fix but locating the correct plumbing point for a small change.
#### The unique solves share a localization mismatch.

### 5.4 Analysis
#### The repository distribution supports the localization hypothesis.
If probe-refined guidance functions primarily as a localization aid, repositories with more predictable layouts, where symbol names map cleanly to file locations from pretraining, should benefit less than repositories with idiosyncratic internal organization. This is what we observe (Figure 6). Django, with its standardized MVC layout (django/db/models/, django/views/, django/template/), is underrepresented among probe-refined-only consistent solves (9 observed vs. 14.3 expected from base rate, ratio 0.63). Scientific and numerical libraries with flatter or more idiosyncratic layouts (scikit-learn 2.02 $\times$, xarray 2.20 $\times$, matplotlib 1.42 $\times$, sympy 1.29 $\times$) are over-represented. Pytest, which has a flat and consistent module structure, contributes zero of 1.2 expected probe-refined-only consistent solves.
#### Synthesis with the coverage finding.


## Key insights
- Engineers typically maintain AGENTS.md files to supply this context as instructions for coding agents, but whether they help is contested: recent studies disagree on whether LLM-generated guidance improves or harms agent performance.
- ## 1 Introduction

LLM-based coding agents operate in a loop of reading code, running commands, and proposing edits to code.
- The effectiveness of the agents depends on more than just the model’s underlying capability.
- A model that has never worked in a particular codebase has to reconstruct this implicit knowledge on the fly, often by trial and error, and frequently lands in the wrong file or proposes a fix that breaks orthogonal subsystems.
- [^5] find that curated AGENTS.md files reduce agent runtime by 28.6 % and output tokens by 16.6 % on focused pull requests, measuring efficiency rather than correctness.
- Single-pass LLM generation yields generic advice; perhaps iteratively refined, failure-informed guidance would behave differently.
- Yet the agent’s own instructions, the text that tells it how to approach a repository, have received surprisingly little systematic attention, with most improvement efforts focused on models, scaffolds, or context windows.
- [^19] show that fine-tuning a model on a single (narrow) bad behavior, writing insecure code, causes it to behave maliciously on unrelated tasks, such as giving harmful advice.
- [^20] show the effect does not even require a harmful training signal: fine-tuning a model only to emit archaic names for bird species makes it answer unrelated questions as though it were living in the 19th century, e.g.
- That is, whether iterative refinement against a small set of synthetic probes, or self-generated bug-fix tasks, can shape an agent’s behavior across a much larger and unrelated set of issues.

## Exemplos e evidências
See original source at `Clippings/Probe-and-Refine Tuning of Repository Guidance for Coding Agents.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/runtime]]
- [[03-RESOURCES/entities/Claude]]
- [[03-RESOURCES/entities/NVIDIA]]
- [[03-RESOURCES/entities/AWS]]
- [[03-RESOURCES/entities/Python]]
