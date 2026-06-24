---
title: "Code Isn’t Memory: A Structural Codebase Index Inside a Coding AgentCode and data: https://github.com/TransformerOptimus/supercoder-eval"
type: source
source: "Clippings/Code Isn’t Memory A Structural Codebase Index Inside a Coding AgentCode and data httpsgithub.comTransformerOptimussupercoder-eval.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
Coding agents now interleave LLMs with retrieval over the working repository, and retrieval implementations vary widely across deployed harnesses. Inside a fixed coding-agent harness on a fixed model, does adding a structural codebase index actually change cost or resolve? We ran three arms (the harness with the index, the same harness without it, and an agentic-grep comparator) on SWE-PolyBench Verified and SWE-bench Pro with Claude Opus 4.7 [^2] held fixed throughout, across three seeds, insid

## Argumentos principais
### Code Isn’t Memory: A Structural Codebase Index Inside a Coding Agent††thanks: Code and data:
Ishaan Bhola    Adithyan Krishnan    Sravanth Kurmala    Mukunda NS
###### Abstract
Coding agents now interleave LLMs with retrieval over the working repository, and retrieval implementations vary widely across deployed harnesses. Inside a fixed coding-agent harness on a fixed model, does adding a structural codebase index actually change cost or resolve? We ran three arms (the harness with the index, the same harness without it, and an agentic-grep comparator) on SWE-PolyBench Verified and SWE-bench Pro with Claude Opus 4.7 [^2] held fixed throughout, across three seeds, inside a leak-audited per-task sandbox. The within-harness ablation produces a large localization gain and a statistically separated resolve gain, with no cost penalty per cell and lower cost per solve. The cross-harness check shows that the index does not regress against an agentic-grep baseline on resolve or localization, again at no cost penalty. We release the per-cell exclusion ledger, the leak-audit script, the localization extractor, and the results database. The deployment question for a structural codebase index is thus not whether it is too expensive to run (across seeds, the index lands at a lower $/solved than agentic grep) but whether the workload includes multi-file changes where structural ranking pays off.

### 1  Introduction
Coding agents now interleave LLMs with retrieval over the working repository, and retrieval implementations vary widely across deployed harnesses. The implementations span a spectrum: agentic grep over the working copy, file-dependency repo maps, semantic and graph search, and structural codebase indices built once per repository (§2). Inside a fixed coding-agent harness on a fixed model, does adding a structural codebase index actually change cost or resolve? We answer the question for open-source harnesses with the model held fixed (Claude Opus 4.7 [^2], §4.2); closed-source harnesses (Claude Code, Cursor, Windsurf) are out of scope by design. The experimental design isolates the index causally by toggling it on and off inside one harness while everything else stays identical, and cross-checks the result against an agentic-grep comparator (§4.1).
The field has not had a clean answer because controlled measurements are scarce. Most prior work either compares whole harnesses, where retrieval is confounded with prompt, tool surface, and control loop, or evaluates retrieval components in isolation against acc@ $k$, without the downstream agentic loop that turns ranking into a fix. The question whether “grep is all you need” has been asked recently in the agentic-search literature for memory-style document retrieval [^16], with grep favored over vector retrieval; we ask the code-task counterpart, where the candidate beyond grep is not a vector index but a structural codebase index (semantic + lexical + call-graph). A structural codebase index is also expensive to build and operate, so if the resolve gain is small and the cost premium is large, the index does not pay for itself in a deployment. The integrity bar for benchmark evaluation has risen in parallel: recent audits documented solution leakage in issue text [^1], memorization of in-benchmark repositories [^12], and substantial score inflation from formal issue text relative to realistic user phrasing [^8], so any positive result needs to survive a leak audit before it counts.
Three arms ran against the same SWE-PolyBench Verified and SWE-bench Pro public instances (91 instances; Go, Java, Python) with Claude Opus 4.7 fixed throughout, across three seeds: SC-ON (the SuperCoder [^18] harness with the index on), SC-OFF (the same harness with the two engine tools removed, every other component identical), and OpenCode [^17] (an agentic-grep comparator). Every cell ran inside a hardened per-task sandbox with a fail-closed git scrub and a post-run leak audit (§5). On the causal within-harness ablation (§6.2), the index moves View B acc@5 from 44.3% to 84.5% across seeds (paired Wilcoxon $p<0.0001$) and resolve from 41.9% to 50.4% (paired Wilcoxon $p=0.003$), and yields lower cost per solve with a statistically null per-cell cost difference. On the cross-harness validity check (§6.1), SC-ON matches or modestly favors OpenCode on resolve (50.4% vs. 45.3% mean, paired Wilcoxon $p=0.087$) and on View B acc@5 (84.5% vs. 75.3% mean, paired Wilcoxon $p=0.080$) at no cost penalty. The structural codebase index does not duplicate behavior that competent agentic grep already reaches; at minimum, it does not regress the agent.

### 2  Related Work
Coding-agent harnesses. SWE-agent [^22] introduced the agent-computer-interface framing on top of a single-LLM control loop; OpenHands [^20], formerly OpenDevin, generalized the platform with sandboxed execution and multi-agent coordination; Aider [^9] drives file-level edits over a local git repository with a dependency-ranked repo map; AutoCodeRover [^26] pairs LLM reasoning with AST-aware code search and spectrum-based fault localization; OpenCode [^17] is the model-agnostic open-source TUI agent we use as the cross-harness comparator (§3.3). SuperCoder, the harness this paper studies (§3.1), shares the parallel-tool-dispatch loop posture with these systems but ships a structural codebase index as a first-class tool, which prior measured harnesses do not. We exclude SWE-agent from the comparator set because its agent-computer-interface pipeline was used in SWE-bench’s construction, creating circularity for an evaluation on SWE-bench-family tasks. Closed-source harnesses (Claude Code, Cursor, Windsurf) are out of scope by design; this study fixes the model (§4.2) and varies the open-source harness configuration around it.
Retrieval approaches for code agents. Four approach types appear in the recent literature. *Agentic grep and read* drives OpenCode [^17] and similar terminal-loop agents that call ripgrep over the working copy; there is no structural codebase index. Sen et al. [^16] contrast grep with vector retrieval inside agentic loops on the LongMemEval memory-retrieval benchmark, with grep favored; their setting is non-code and the alternative they ablate against is dense retrieval, not a structural codebase index, but the question framing (does grep suffice inside an agentic harness?) is the closest prior to ours. *Repository-level retrieval and planning* approaches predate the agent-harness wave: RepoCoder [^24] iteratively retrieves over the whole repository for code completion, and CodePlan [^3] stages multi-file edits as a planned sequence of repository-wide operations — neither is built as an agent loop. *File-dependency repo maps*, exemplified by Aider’s PageRank-ranked repo map [^9], surface candidate files by import and reference structure but do not index symbol-level semantics. *Semantic and graph search* combines code-chunk embeddings with typed repository graphs: LocAgent [^5] equips an LLM agent with graph-search tools over a heterogeneous code graph, RepoGraph [^13] plugs a repository-wide code graph into SWE-agent and AutoCodeRover, and the Code Graph Model line [^19] integrates the graph directly into an LLM’s attention via an adapter; Agentless [^21] reaches comparable SWE-bench-Lite scores with a non-agentic three-phase localization-and-repair pipeline. *Structural codebase indices* have been adopted in commercial coding-agent stacks; this paper provides the first leak-audited, model-controlled causal ablation of one inside an open-source harness (§6.2).
Localization metrics for code agents. LocAgent [^5] and Agentless [^21] report file-level acc@ $k$ as the primary localization metric. The field has been moving toward stage-decomposed trajectory metrics: TRAJEVAL [^11] decomposes agent trajectories into search, read, and edit phases with per-stage precision and recall, and SWE-Explore [^25] isolates repository exploration as a sub-task with coverage and ranking metrics against trajectory-derived ground truth. Our View B (§4.7, §6.1) sits in the same field move: we strip engine-result paths from the surfaced set so that an SC-ON acc@ $k$ counts the same kind of agent-targeted surface as an OpenCode acc@ $k$. This paper does not propose a new localization metric; it adopts the field-trend rule and applies it uniformly across arms.

### 3  System
This section describes the studied subject: the SuperCoder coding-agent harness, the context engine that the ON/OFF arms ablate, and the OpenCode comparator that the cross-harness arm runs.

### 3.1  SuperCoder harness
SuperCoder [^18] is a coding agent built around a single-LLM control loop. The shipped binary supports three modes (Ask, Plan, Coding); the evaluation runs in Coding mode, the only mode that may write files or execute shell commands, so all mechanics described below refer to the Coding-mode loop. A provider gateway sits in front of the LLM client and captures token-level cost per turn uniformly across arms (§4.5).
Each turn assembles a prompt (system instructions, tool schema, message history) and issues a single LLM call. If the model emits tool calls, the harness dispatches them, awaits results, and appends them to the message history; if it emits text with no tool calls, the loop terminates. The reasoning-and-acting posture follows the ReAct [^23] pattern, and the tool-call interface follows the function-calling line introduced by Toolformer [^15]. Multiple tool calls in a single response are executed in parallel. If the rolling token count exceeds a threshold, the harness compacts the message history by summarizing older turns; the compaction step is disclosed for reproducibility but is not load-bearing for the ablation. The loop terminates when (a) the model emits no tool calls, (b) a configured per-cell turn budget is exhausted, or (c) the 30-minute per-cell wall-clock cap (§4.5) elapses.
The agent calls a fixed tool set: read, write, edit, bash, git, grep, and glob, plus task-management tools (todo\_write, apply\_patch). All of these are identical across SC-ON and SC-OFF. The two context-engine tools, codebase\_search and codebase\_graph, are available only in SC-ON; SC-OFF removes those two tools from the schema and changes nothing else (§3.2).

### 3.2  Context engine
The context engine is a separate service that the agent calls through two tools. It maintains a per-repository index that is built once on first contact and updated incrementally on subsequent runs via Merkle-tree diffs over the working copy, so a source edit invalidates and re-indexes only the affected chunks rather than the whole repository. Each cell in this study starts from a fresh sandbox, so every arm exercises the build path; the incremental-update path is part of the engine but not load-bearing in the run. The index has three components: a vector index of code-chunk embeddings for semantic similarity, a graph index of definitions and call edges for structural reachability, and a lexical (BM25) index of identifiers and tokens for exact-match recall. Index construction begins with tree-sitter parsing per source file; definitions, references, and call edges are extracted from the resulting AST and chunked for embedding.
Figure 1 sketches the indexing pipeline and the retrieval path. The components are named at the level the public eval repo can support (§5.3); the backend service that hosts the three indices is internal and not part of the released artifact.
Figure 1: Context-engine pipeline. The upper block runs once per repository on first contact and re-runs incrementally on subsequent contacts via Merkle-tree diffs over the working copy: tree-sitter produces an AST per source file, an extractor walks the ASTs to collect definitions, identifiers, and call edges, and code chunks are embedded into vectors; the result is three indices populated in parallel. The lower block runs on every agent call: codebase\_search or codebase\_graph dispatches a query to hybrid retrieval, which fuses hits across the three indices and returns a ranked result list to the agent. Per-tool input and result schemas are described in §3.2.

### 3.3  Comparator: OpenCode
OpenCode [^17] is an open-source coding agent: a single-LLM control loop with parallel tool dispatch and a fixed tool set built around rg (ripgrep), read, glob, and bash; no structural codebase index, no embedding-based search, no precomputed call-graph. In our evaluation, OpenCode runs in the same per-task container as the two SuperCoder arms, with Claude Opus 4.7 and the same 30-minute wall-clock cap (§4.5). The headline cross-harness comparison is §6.1.

### 4  Experimental Design
This section defines the arms, the model, the benchmarks, the run scope, the sandbox and cost-capture infrastructure, the metrics, the localization-view extraction rule, the statistical methods, and the narrowed pilot. §6 consumes these definitions verbatim.

### 4.1  Arms
We compare three arms on the same instance set: SC-ON (SuperCoder harness with the context engine’s tools available), SC-OFF (same harness, same prompts, with codebase\_search and codebase\_graph removed from the toolset), and OpenCode (an independent open-source harness whose retrieval is built around ripgrep and file reads, with no structural index). The only thing that changes between SC-ON and SC-OFF is the engine toolset, which gives the ablation its causal reading. The cross-harness comparison against OpenCode tests whether SC-ON’s behavior is reproducible by an alternative open-source harness running the same model.
Across all three arms we hold the model (Claude Opus 4.7), the per-task sandbox image, the scorer, and the 30-minute wall-clock cap fixed; no turn or dollar cap is enforced. Each arm runs three seeds. SC-ON exposes the two engine tools (codebase\_search, codebase\_graph); SC-OFF removes exactly those two from the toolset and leaves everything else identical; OpenCode is an independent harness with its own tool surface (§3.3).

### 4.2  Model
All three arms run Claude Opus 4.7 [^2] (claude-opus-4-7) across three seeds. Fixing the model removes capability as a moving part, so any cross-harness difference has to come from the harness or its retrieval, not from a stronger backbone. Single-model scope is a limitation we acknowledge in §5 and §7; the control trade is intentional.

### 4.3  Benchmarks
The instance set draws from two public benchmarks: SWE-PolyBench Verified [^14] contributes the multi-language coverage (Go, Java, Python), and SWE-bench-Pro [^7] contributes longer-context Python tasks. Both descend from the SWE-bench family [^6]. We do not use SWE-Agent or its trajectories as a comparator because of its role in benchmark construction; the open-source harness comparator is OpenCode [^17].

### 4.4  Run scope
The study runs on 91 instances across three languages: 34 Go, 20 Java, 37 Python. JavaScript and TypeScript are not covered (limitation logged in §5). The run uses three seeds, pass@1 per seed; statistics are reported as the mean of seed means with across-seed standard deviation as a variance estimate, and seed-variance context follows [^4].
#### Paired-nn denominators.
§6 uses three paired- $n$ values, and each one carries a specific meaning. The *triple-intersection* set is the subset of instances on which all three arms produced a legit cell ($n=75$); this set is used for descriptive cross-arm context where all three rows of a table need to refer to the same instances. Pairwise significance tests use the *pairwise* denominator instead, because dropping instances that are legit in two arms simply because the third arm failed wastes paired signal. The pairwise denominators are 80 (SC-ON vs. SC-OFF) and 78 (SC-ON vs. OpenCode). Every paired test in §6 cites the $n$ that applies to it.

### 4.5  Sandbox and cost capture
Each cell ran inside a per-task isolated container with a uniform image across arms, on an internal sandbox backend. The backend’s configs and image spec are not part of the public release. A unified provider gateway captured token-level cost on every LLM call, which means $/cell and $/solved are computed against the same accounting for all three arms. Per-cell cost\_usd, total\_cost\_usd, tokens\_total, and wall\_clock\_secs are released in the public DB. The 30-minute wall-clock cap fired on two cells in the released set (one SC-OFF and one OpenCode); SC-ON’s longest legit cell ran 19 minutes. The released reproducibility kit lives under data/; per-cell patches, per-trace JSON, prompts, and sandbox image references are held back because they include licensed repository source and internal harness configuration. Resolve is the public DB’s resolved column, sourced from the upstream benchmark scorers; $/cell, $/solved, turns, tokens, and wall-clock are released per-cell.

### 4.6  Metrics
The primary outcome is resolve; supporting outcomes are localization, effort, and cost. Table I states the formal definitions. Localization is reported under View B by default (§4.7); effort and cost metrics are per-cell means on legit cells from the unified provider gateway (§4.5).
TABLE I: Metric definitions. Resolve is the public DB’s resolved column, sourced from the upstream benchmark scorers (F2P denotes fail-to-pass tests; P2P denotes pass-to-pass tests). Localization is computed under View B (§4.7); effort and cost are per-cell means on legit cells.
| Metric | Definition |

### 4.7  Localization views
Algorithm 1 Localization extraction. The trace is a sequence of message events; each event carries a tool name, a *role* (Args for tool-call arguments or Result for tool-result content), and the path tokens extracted from that channel. View A is the legacy rule: every path the agent saw counts as surfaced. View B drops only paths whose provenance is a *result* of an engine call (codebase\_search or codebase\_graph); the engine’s natural-language query arguments are kept in both views, because the agent did produce those tokens. The difference between the two views is the highlighted line.
trace $T$ as a sequence of events $(\textit{tid},\textit{tool},\textit{role},\textit{paths})$ where $\textit{role}\in\{\textsc{Args},\textsc{Result}\}$
$\mathit{surfaced}\subseteq\mathit{files}$


## Key insights
- Inside a fixed coding-agent harness on a fixed model, does adding a structural codebase index actually change cost or resolve?
- Inside a fixed coding-agent harness on a fixed model, does adding a structural codebase index actually change cost or resolve?
- We answer the question for open-source harnesses with the model held fixed (Claude Opus 4.7 [^2], §4.2); closed-source harnesses (Claude Code, Cursor, Windsurf) are out of scope by design.
- The experimental design isolates the index causally by toggling it on and off inside one harness while everything else stays identical, and cross-checks the result against an agentic-grep comparator (§4.1).
- The structural codebase index does not duplicate behavior that competent agentic grep already reaches; at minimum, it does not regress the agent.
- We report the first leak-audited, model-controlled, causal ablation of a shipped structural codebase index inside a coding-agent harness, paired with a cross-harness validity check against an agentic-grep comparator.
- ## 2  Related Work

Coding-agent harnesses.
- We exclude SWE-agent from the comparator set because its agent-computer-interface pipeline was used in SWE-bench’s construction, creating circularity for an evaluation on SWE-bench-family tasks.
- Closed-source harnesses (Claude Code, Cursor, Windsurf) are out of scope by design; this study fixes the model (§4.2) and varies the open-source harness configuration around it.
- *Structural codebase indices* have been adopted in commercial coding-agent stacks; this paper provides the first leak-audited, model-controlled causal ablation of one inside an open-source harness (§6.2).

## Exemplos e evidências
See original source at `Clippings/Code Isn’t Memory A Structural Codebase Index Inside a Coding AgentCode and data httpsgithub.comTransformerOptimussupercoder-eval.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/Claude]]
- [[03-RESOURCES/entities/OpenAI]]
- [[03-RESOURCES/entities/AWS]]
- [[03-RESOURCES/entities/Python]]

## Minha Síntese
**O que muda:** A ser analisado em revisão manual.

**Conexão pessoal:** A ser conectado com projetos/estudo atuais.

**Próximo passo:** Nenhum próximo passo imediato.
