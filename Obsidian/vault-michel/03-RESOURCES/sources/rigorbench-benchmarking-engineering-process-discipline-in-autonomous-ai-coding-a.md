---
title: "RigorBench: Benchmarking Engineering Process Discipline in Autonomous AI Coding Agents"
type: source
source: "Clippings/RigorBench Benchmarking Engineering Process Discipline in Autonomous AI Coding Agents.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
Agentic coding harnesses—such as Agent-Skills, Superpowers, and Agent-Rigor—are increasingly deployed to augment underlying LLMs for real-world software engineering tasks. Existing benchmarks evaluate these agents almost exclusively on *outcome correctness*: whether generated code passes tests or resolves issues. We argue that this outcome-only lens is insufficient: an agent that arrives at a correct solution through reckless trial-and-error, without planning, verification, or graceful recovery,

## Argumentos principais
### I Introduction
The rapid maturation of large language models (LLMs) has given rise to a new class of software engineering tool: the *agentic coding harness*. Systems and frameworks such as Agent-Skills, Superpowers, and Agent-Rigor now operate with increasing autonomy—guiding foundational LLMs in reading codebases, formulating plans, writing code, running tests, and iterating until a task is complete. Their capabilities are evaluated by an expanding ecosystem of benchmarks: SWE-bench [^1] for resolving real GitHub issues, HumanEval [^4] and MBPP [^5] for function-level synthesis, BigCodeBench [^6] for complex API usage, and domain-specific suites such as Terminal-Bench [^8] and ProjDevBench [^9] for project-scale development.
These benchmarks share a common evaluation philosophy: they measure *outcomes*. Did the generated code pass the test suite? Was the GitHub issue marked resolved? Does the function return the correct output on the hidden test set? While outcome correctness is a necessary condition for useful code generation, we contend that it is not a sufficient one for *reliable* deployment of autonomous coding agents.
#### The problem with outcome-only evaluation.

### II Related Work
#### Code generation benchmarks.
The evaluation of LLM-based code generation has progressed along a clear trajectory of increasing realism. HumanEval [^4] and MBPP [^5] established function-level benchmarks with unit-test-based pass rates. BigCodeBench [^6] extended this to multi-library compositions. SWE-bench [^1] introduced real-world GitHub issue resolution, requiring agents to navigate complex codebases and produce patches that pass existing test suites. LiveCodeBench [^11] and PeerBench [^3] addressed contamination concerns by using temporally filtered competition problems and proctored execution environments. DevBench [^7], ProjDevBench [^9], and ProjectEval [^2] pushed toward full project-scale development and automated simulation of user acceptance. Terminal-Bench [^8] evaluates agents in realistic terminal environments. AgentBench [^10] provides a multi-dimensional evaluation of LLMs as agents across diverse environments.
Despite this rich landscape, every benchmark in this lineage evaluates *what* the agent produces, not *how* it produces it. RigorBench is, to our knowledge, the first benchmark explicitly designed to measure the engineering process.

### III The Process Discipline Gap
To motivate RigorBench, we conduct a systematic survey of existing AI coding benchmarks. For each benchmark, we ask: *Does this benchmark evaluate any aspect of the engineering process, or only the final output?*
TABLE I: Survey of existing AI coding benchmarks. None evaluate engineering process discipline. All rely exclusively on outcome-based metrics.
| Benchmark | Scope | Primary Metric | Plans? | Tests? | Recovery? |

### IV RigorBench Design
RigorBench is structured around three core design decisions: (1) a five-pillar scoring framework that decomposes process discipline into measurable dimensions, (2) a curated task suite that systematically exercises each dimension, and (3) a trajectory-based evaluation methodology that scores the full execution path.

### IV-A The Five Scoring Pillars
Each pillar captures a distinct dimension of engineering discipline. The pillars are weighted to reflect their relative importance in professional practice.
#### Pillar 1: Planning Fidelity (PF) — Weight 0.20.
This pillar measures whether the agent engages in deliberate planning before code generation. We assess three sub-metrics:

### IV-B Task Suite
RigorBench comprises 30 tasks distributed across five categories, each designed to stress-test specific pillars. Table˜II summarizes the categories and their pillar associations.
TABLE II: Task categories in RigorBench. Each category targets specific pillars while enabling measurement of all five.
| Category | Tasks | Description | Primary Pillars | Difficulty |

### IV-C Trajectory-Based Evaluation
Unlike outcome-based benchmarks that evaluate only the final artifact, RigorBench analyzes the *full execution trajectory*. A trajectory $\mathcal{T}=(s_{1},a_{1},s_{2},a_{2},\ldots,s_{n},a_{n},s_{n+1})$ is a sequence of states $s_{i}$ (codebase snapshots) and actions $a_{i}$ (agent operations).
#### Trajectory logging.
We instrument each agent’s execution environment to capture:

### V Experimental Setup
#### Harnesses evaluated.
We evaluate three leading agentic coding harnesses and one baseline, all operating on the same underlying foundation model (a state-of-the-art LLM) to isolate the impact of the harness:
1. Agent-Rigor — A markdown-based operating system enforcing a 6-phase discipline lifecycle.

### VI-A Overall RigorScore
TABLE III: Overall RigorScore (process quality, $\uparrow$) and Outcome Score ($\uparrow$) across all 30 tasks. Bold: best in column.
| Harness | RigorScore | Outcome Score |
| --- | --- | --- |

### VI-B Per-Pillar Analysis
TABLE IV: Per-pillar scores under Baseline ($\mathcal{B}$) and Disciplined ($\mathcal{D}$) conditions, averaged across all agents. Each pillar is scored on $[0,1]$.
| Pillar | Weight | $\mathcal{B}$ (Mean) | $\mathcal{D}$ (Mean) | $\Delta$ |
| --- | --- | --- | --- | --- |

### VI-C Per-Category Results
TABLE V: Mean RigorScore by task category and condition. Best per-category score is bolded.
| Task Category | $\mathcal{B}$ | $\mathcal{D}$ | $\Delta$ | Most Improved Pillar |
| --- | --- | --- | --- | --- |

### VI-D Per-Harness Detailed Results
TABLE VI: Per-harness, per-pillar RigorScore. Each cell shows the pillar score on $[0,1]$. Composite RigorScore in the rightmost column.
| Harness | PF | VC | RE | AQ | ATI | RigorScore |
| --- | --- | --- | --- | --- | --- | --- |

### VI-E Process–Outcome Correlation
Process–Outcome Correlation Scatter plot: RigorScore (x-axis) vs. Outcome Score (y-axis) $r=0.87,\;p<0.001$ Each point = one (harness, task) execution ($n=120$) Linear fit: $\text{Outcome}=0.41+0.54\times\text{RigorScore}$
Figure 1: Correlation between RigorScore and Outcome Score across all 120 task executions. The strong positive correlation ($r=0.87$) demonstrates that process discipline is a reliable predictor of outcome quality.
Figure˜1 shows a strong positive correlation ($r=0.87$, $p<0.001$) between RigorScore and outcome quality across all 120 task executions. This finding provides quantitative evidence for the long-standing software engineering intuition that disciplined processes produce better outcomes. Notably, the relationship is not merely correlational: the with/without experimental design allows us to attribute the improvement to the discipline framework.

### VII Analysis and Discussion
#### Planning is the largest gap.
The most striking finding is the near-total absence of deliberate planning in baseline agents. Despite extensive chain-of-thought capabilities [^27] [^30], agents rarely produce explicit plan artifacts before coding. Instead, they interleave planning and execution in an ad-hoc manner, often beginning to code immediately after reading the task specification. Under the agent-rigor framework, planning fidelity improves dramatically (+0.47 on average), suggesting that agents are *capable* of planning but do not do so without explicit prompting.
#### Abstention is nearly absent at baseline.

### VIII Limitations
#### Scale.
Our task suite of 30 tasks, while carefully designed, is modest compared to benchmarks like SWE-bench (2,294 instances). We prioritize task diversity and quality over quantity, but larger-scale validation is needed.
#### Framework coupling.


## Key insights
- Fragile fixes: Patches that pass tests but introduce latent bugs because the agent never verified edge cases.
- Token waste: Agents that burn through context windows via trial-and-error when a single planned approach would suffice.
- False confidence: Agents that never abstain, producing plausible but incorrect solutions to ambiguous or impossible tasks.
- Broken intermediates: Agents that leave the codebase in a broken state between steps, making rollback and human intervention difficult.
- Plan Artifact Creation (PAC): Does the agent produce an explicit plan document (e.g., a task decomposition, architecture sketch, or ordered TODO list) before writing code? Binary score with partial credit for inline reasoning.
- Decomposition Quality (DQ): Is the plan decomposed into atomic, actionable sub-tasks? Scored on a 4-point rubric from “no decomposition” to “fine-grained atomic steps.”
- Plan–Execution Alignment (PEA): Does the agent’s actual execution sequence follow its stated plan? Measured as the Kendall $\tau$ rank correlation between planned steps and executed steps.
- Test Creation Rate (TCR): The proportion of implemented functions or features for which the agent creates at least one test.
- Coverage Delta ($\Delta C$): The change in code coverage (line or branch) attributable to agent-created tests, measured via instrumentation.
- Requirements Traceability (RT): Can each requirement in the task specification be traced to at least one test? Scored as recall over requirements.

## Exemplos e evidências
See original source at `Clippings/RigorBench Benchmarking Engineering Process Discipline in Autonomous AI Coding Agents.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/Claude]]
- [[03-RESOURCES/entities/OpenAI]]
- [[03-RESOURCES/entities/GitHub-Copilot]]
- [[03-RESOURCES/entities/Codex]]
- [[03-RESOURCES/entities/Gemini]]
- [[03-RESOURCES/entities/Microsoft]]
- [[03-RESOURCES/entities/Python]]

## Minha Síntese
**O que muda:** A ser analisado em revisão manual.

**Conexão pessoal:** A ser conectado com projetos/estudo atuais.

**Próximo passo:** Nenhum próximo passo imediato.
