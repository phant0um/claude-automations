---
title: "Is Agent Code Less Maintainable Than Human Code?"
type: source
source: "Clippings/Is Agent Code Less Maintainable Than Human Code?.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
Maintainability is a core dimension of software engineering, shaping how code is written, reviewed, and developed over time. While coding agents have demonstrated strong performance on single-issue tasks, it remains unclear how maintainable their code is when future agents build on top of it, potentially leading to compounding downstream effects. We investigate how agent code compares to human code in these maintenance settings, presenting CodeThread, a framework to construct controlled experime

## Argumentos principais
### 1 Introduction
Coding agents are increasingly integrated into software engineering workflows, with promises of “completing weeks of work in days” [^23]. However, a patch that passes tests and is functionally correct may still introduce structural complexity, unnecessary verbosity, brittle abstractions, or confusing implementation choices that only lead to failures when the code is later extended or modified in downstream tasks (Figure 1).
Figure 1: Two pieces of code both being functionally correct does not mean they are equally maintainable. An example instance where both the human and agent code pass the initial implementation task’s tests, yet when an agent makes a subsequent change to both, the version built on human code passes while the version built on agent code fails.
Code maintainability has been studied across many software development contexts, and static metrics have emerged to provide quantitative evaluations of maintainability. In particular, structural and size-based metrics, such as cyclomatic complexity [^9], Halstead volume [^11], and cognitive complexity [^3], have been used widely as proxies for the maintenance cost on a project [^27] [^2]. The adoption of coding agents raises questions about whether code authored by agents is more or less maintainable for future agents building on top of it compared to human-authored code. Recent work has measured agent code maintainability based on these static metrics [^31] [^24], but does not suggest how this code compares against human code. Static metrics can often additionally be confounded by task difficulty and codebase conventions.

### 2 Related Work
Figure 2: CodeThread framework. From the original benchmark instance, we construct a two-step task—an Implementation Task followed by a Follow-On Issue—producing three code states ( PR 0 \\text{PR}\_{0}, 1 \\text{PR}\_{1}, and 2 \\text{PR}\_{2} ) and three conditions: AA (agent performs both steps), HA (human performs the Implementation Task, agent performs the Follow-On Issue on human code), and HH (human performs both steps). Comparing AA and HA isolates the effect of agent authorship on maintainability, holding the follow-on author fixed.
#### Evaluating Agents on Sequential Tasks.
Several recent benchmarks evaluate coding agents on sequences of dependent tasks rather than individual issues. CodeFlowBench decomposes Codeforces problems along their function-level dependency tree and requires the agent to implement each subfunction by reusing those it built in earlier turns [^30]. SWE-Bench-CL orders GitHub issues chronologically within each repository to evaluate whether experience from earlier issues transfers to later ones [^16]. SlopCodeBench measures behavioral drift as agents repeatedly modify a codebase across long-horizon iterative trajectories [^24]. In contrast, our work grounds measurements in real GitHub pull requests rather than fully synthetic problems or hand-authored projects. Additionally, by varying the authorship of an intermediate patch while holding the downstream task fixed, we isolate the maintainability cost of agent-written code from the inherent difficulty of sequential development.

### 3 CodeThread
We introduce CodeThread, a framework for measuring the downstream effects of building on agent code in comparison to human code (Figure 2). CodeThread transforms standard single-issue software engineering benchmark instances into dependent two-step pull-request chains (Section 3.1), allowing for controlled comparisons of downstream outcomes across authorship conditions (Section 3.2) with evaluation built in (Section 3.3).
CodeThread starts from an existing issue-resolution coding benchmark where instances consist of a written issue, a base commit, a human-authored ground-truth patch, and a test suite to determine whether the patch resolved the task. Example benchmarks that follow this format include SWE-Bench Verified [^6], SWE-Bench Multilingual [^17], SWE-Bench Pro [^8], and FeatBench [^4].

### 3.1 Step 1: Create a Two-Step Task
From each benchmark instance, we construct a two-step chain consisting of two dependent tasks and three code states: the Implementation Task and Follow-On Issue, and code states $\text{PR}_{0}$, $\text{PR}_{1}$, and $\text{PR}_{2}$. To create the first state, $\text{PR}_{0}$, we remove the target function bodies while preserving their signatures, leaving a skeleton version of the benchmark’s initial code state. This provides a starting point from which different authors can implement the intended functionality, similar to the use of skeleton code in prototyping, where an initial code structure is later fleshed out with implementation details [^28] [^26].
The Implementation Task (${\text{PR}_{0}}\rightarrow{\text{PR}_{1}}$) produces human and agent implementations of the same task. Using an LLM, we create an issue asking the author to restore the missing functionality in the skeletonized code. We filter out $\text{PR}_{1}$ solutions that have already solved the benchmark issue by requiring them to pass all Pass-to-Pass tests, confirming that the original functionality is restored, while still failing all Fail-to-Pass tests, confirming that the downstream issue is not yet resolved. This ensures that $\text{PR}_{1}$ reflects the benchmark’s initial code state rather than a partial or complete solution to the Follow-On Issue. Although models sometimes incidentally satisfy Fail-to-Pass tests while restoring functionality, the filter retains a large majority of instances. Appendix A shows the prompt used to generate Implementation Task statements, as well as the prompt given to models when solving it.
The Follow-On Issue ($\text{PR}_{1}\rightarrow\text{PR}_{2}$) is the original benchmark issue applied on top of the PR1 implementation. The problem statement and testing criteria for the Follow-On Issue are unchanged from the original benchmark, making it a downstream task whose difficulty may depend on the maintainability of the PR1 implementation. We evaluate whether Follow-On Issue is resolved using the original benchmark test suite: a $\text{PR}_{2}$ solution is considered correct if it passes both the Pass-to-Pass tests, confirming that existing functionality is preserved, and the Fail-to-Pass tests, confirming that the original benchmark issue has been fixed.

### 3.2 Step 2: Set-up Authorship Scenarios
Using the two-step issue resolution pipeline, we vary authorship on $\text{PR}_{1}$ and $\text{PR}_{2}$, creating a total of three comparable authorship scenarios: human $\text{PR}_{1}$ followed by human $\text{PR}_{2}$ (HH), human $\text{PR}_{1}$ followed by agent $\text{PR}_{2}$ (HA), and agent $\text{PR}_{1}$ followed by agent $\text{PR}_{2}$ (AA). The HH condition consists of the original developer’s PRs provided by each benchmark, acting as the human baseline against which the other conditions are compared. Comparing AA to HA isolates the downstream effect of $\text{PR}_{1}$ authorship on $\text{PR}_{2}$ success, allowing us to directly evaluate whether agent code imposes a maintainability burden on subsequent agent work in comparison to human code.
A growing fraction of developers use AI agents to extend existing codebases [^18], which may contain originally human-written code or earlier agent-written code. Thus, we focus on the HA versus AA comparison. Both settings fix the agent as the $\text{PR}_{2}$ author and vary only the authorship of $\text{PR}_{1}$, isolating the effect of the prior code on the agent’s downstream fix. The AH setting of a human performing the follow-on task on top of agent code would offer a complementary human-centric view (AH versus AA), but it requires recruiting a substantial number of developers and is out of scope for this study. By keeping the $\text{PR}_{2}$ author fixed, CodeThread is scalable and can be applied to many existing issue-resolution benchmarks without additional human studies.
<table><thead><tr><th>Benchmark</th><th colspan="2"># Instances</th><th colspan="2">Filtered Subset</th><th colspan="2">PR <sub>1</sub> (Avg.)</th><th colspan="2">PR <sub>2</sub> (Avg.)</th><th>Task Types</th></tr></thead><tbody><tr><td></td><th>Total</th><th>Filtered.</th><th>#Repos</th><th>#Lang</th><th>Files</th><th>Funcs</th><th>Files</th><th>Funcs</th><td></td></tr><tr><td>SWE-Bench Verified</td><td>500</td><td>441</td><td>12</td><td>1</td><td>1.12</td><td>1.60</td><td>1.18</td><td>1.71</td><td>BF</td></tr><tr><td>SWE-Bench Multilingual</td><td>300</td><td>171</td><td>34</td><td>7</td><td>1.29</td><td>1.90</td><td>1.84</td><td>3.28</td><td>BF</td></tr><tr><td>SWE-Bench Pro</td><td>731</td><td>641</td><td>11</td><td>4</td><td>2.43</td><td>5.51</td><td>5.22</td><td>10.70</td><td>BF, FI & RF</td></tr><tr><td>FeatBench</td><td>156</td><td>124</td><td>22</td><td>1</td><td>1.52</td><td>2.54</td><td>2.35</td><td>4.03</td><td>FI</td></tr><tr><td>Total</td><td>1,687</td><td>1,377</td><td>78</td><td>10</td><td>1.79</td><td>3.54</td><td>3.25</td><td>6.30</td><td></td></tr></tbody></table>

### 3.3 Step 3: Evaluate agent vs human code
We assess the final code outputs, $\text{PR}_{2}$, from HA and AA in terms of resolve rate, which refers to whether the code, after both editing steps, successfully resolves the original benchmark issue. Differences in resolve rate indicate whether the authorship of $\text{PR}_{1}$ affects downstream issue-resolution success, providing a task-based measure of maintainability. The resulting code samples can also be compared along other dimensions of code quality since the task setup is controlled and the downstream issue is held fixed across authorship conditions. We show this in Section 5.

### 4.1 Experimental Set-up
#### Task Types.
We source a total of 1,377 instances from SWE-Bench Verified [^6], SWE-Bench Multilingual [^17], SWE-Bench Pro [^8], and FeatBench [^4]. The four benchmarks cover a range of software engineering tasks: bug fixing (BF), feature implementation (FI), and refactoring (RF), as shown in Table 1. Following [^32], we treat SWE-Bench Verified and SWE-Bench Multilingual as bug fix benchmarks. For SWE-Bench Pro, we use its native labels. We use FeatBench as a feature-implementation benchmark.
#### Models and Agent Configuration.

### 4.2 Results
Overall findings. Table 2 shows the $\text{PR}_{2}$ resolve rates under HA and AA conditions. The number of instances that pass the $\text{PR}_{1}$ filtering differs by model, so we compare models using the subset of instances shared across all models within each benchmark. Across these instances, we find that agents more often perform worse when building on agent code than on human code: AA generally underperforms HA, with drops in downstream resolve rate of up to 13.1%. Full scores for each model and benchmark are provided in Appendix B; we observe similar pattern in both the shared-instance analysis and the full per-model benchmark results. The largest drops occur for GLM 4.7 on SWE-Bench Pro, which contains longer, multi-file edits drawn from professional codebases, and with GPT-5 on FeatBench, a set of feature implementation tasks. We also observe four cases where AA matches or exceeds HA performance. We trace the source of this gap in Section 5.
#### Per-model patterns.
Table 2 shows the HA-vs-AA gap across models. GLM shows the largest and most consistent effect of $\text{PR}_{1}$ authorship, with AA underperforming HA on all benchmarks and dropping by 13.1% on SWE-Bench Pro. Claude and MiniMax also drop by around $3$ - $8$ % across SWE-Bench variants, though FeatBench shows more mixed results. GPT-5 has the smallest gaps on SWE-Bench variants that may also partly reflect its lower HA baseline rather than greater robustness to agent code. GPT-5 drops by 12.5% on FeatBench, however, suggesting that maintainability costs may be more visible on feature implementation tasks.

### 5 Why does AA underperform HA?
We observe that agents building on agent code generally perform worse than on human code. To isolate the drivers of that gap, we focus on the discordant cohort, in which HA and AA produce different outcomes on the same task. Across all four models and benchmarks, there are 454 discordant instances, where HA wins 64.3% of the time and AA wins only 35.7%. After dropping instances with incomplete features, our analysis set is 405 instances (HA 64.7%, AA 35.3%). For each of these instances, we first extract a set of features from $\text{PR}_{1}$ and $\text{PR}_{2}$, detailed in Section 5.1, and fit a logistic regression model on these features to identify which push the outcome towards HA or AA.

### 5.1 Features
We use four feature categories to identify the root causes of the gap: static maintainability metrics to test traditional code-quality signals, patch localization features to compare files and functions edited under HA versus AA, $\text{PR}_{1}$ behavioral drift labels to capture differences in agent $\text{PR}_{1}$ missed by static metrics, and an instance difficulty score to control for task-level variation. We describe each below and provide implementation details in Appendix D.
#### PR1\\text{PR}\_{1} and PR2\\text{PR}\_{2} static metrics.
Our first feature set comprises four static proxies for maintenance cost based on software engineering literature, previously discussed in Section 2 [^27] [^2], spanning two dimensions of code quality. The first dimension is structural complexity, where we use Cyclomatic Complexity (CC) [^9], which counts linearly independent paths through a function, and Cognitive Complexity (CogC) [^3], which penalizes nested control structures. The second dimension is verbosity, where we use Halstead Volume (HV) [^11], based on operator and operand counts, and Logical Lines of Code (LLOC), which counts executable statements. For each metric, we compute two features per discordant instance: the difference between AA and HA at $\text{PR}_{1}$ and $\text{PR}_{2}$.

### 5.2 Modeling
Given these twelve features, together with benchmark and model fixed effects, we fit a logistic regression (LR) to identify which features push the outcome toward HA or AA. Let $Y_{i}=1$ when HA resolves and AA fails on instance $i$ and $Y_{i}=0$ otherwise. The model is defined as:
$$
\displaystyle\operatorname{logit}\,\Pr(Y_{i}=1\mid X_{i})

### 5.3 Findings
#### Which features predict HA and AA disagreement?
Table 4 reports the fitted logistic regression on the discordant instances. Three features emerge as statistically significant predictors of the discordance direction, with all three tilting the outcome toward HA resolved while AA unresolved: IEC, $\Delta\text{LLOC}_{\text{PR}_{2}}$, and Instance resolve rate. When agent $\text{PR}_{1}$ alters input-validation or error-handling behavior, the odds of HA winning are $1.83\times$ that of AA, and when AA’s $\text{PR}_{2}$ adds more lines than HA’s, HA is $1.88\times$ more likely to win over AA. The difficulty control feature signifies that instances where HA wins tend to be easier. The model recovers a modest but reliable signal (McFadden $R^{2}=0.069$, LR $\chi^{2}(18)=36.1$, $p=0.007$). Figure 3 corroborates these results as static maintainability metrics show near-identical distributions across HA-wins and AA-wins, while IEC drift, $\Delta\text{LLOC}_{\text{PR}_{2}}$, and instance resolve rate show the clearest visual separation between the two groups.
#### Does PR1\\text{PR}\_{1} drift cause the unresolved outcome in PR2\\text{PR}\_{2}?

### 6 Discussion & Limitations
We present limitations of our study. First, we consider only two-step pull request chains (PR <sub>1</sub> $\rightarrow$ PR <sub>2</sub>). Although this setup is sufficient to study whether the quality of an intermediate patch affects a downstream modification, it does not capture longer-horizon development trajectories, where technical debt may compound over multiple successive edits. Future work should explore constructing longer PR chains with function-level overlap across successive tasks.
Second, we filter $\text{PR}_{1}$ by instances where the agent $\text{PR}_{1}$ did not already address the Follow-On Issue. This filtering is necessary for the two-step chain to be well-defined, maintaining the separation between the two tasks so that the effect of authorship can be evaluated in isolation from functionality. This may introduce a selection bias, where restricting the analyzed instances to where the agent did not solve the Follow-On Issue at $\text{PR}_{1}$ does not represent the agent’s natural behavior across the benchmark. The filter retains a large majority of instances, however, and we verify that cases where the model satisfies Fail-to-Pass tests in the Implementation Task are often incidental.
Third, our work does not study the effect of human-authored $\text{PR}_{2}$ on top of agent-authored $\text{PR}_{1}$ (AH) setting. Doing so would allow for a comparison of how difficult it is for human developers to build on agent code versus human code. Constructing this condition at scale would require recruiting developers to author $\text{PR}_{2}$ across 1,409 instances, which is infeasible in our current setting and difficult to control due to factors such as familiarity with the codebase. Future work could examine the AH setting on a smaller curated subset.

### 7 Conclusion
Across four benchmarks and four frontier models, building on agent code more often lowers downstream resolve rates than building on human code, with effects varying by model and task type. These differences are not well explained by static maintainability metrics alone; the clearest code-level signal is subtle behavioral drift in agent code, while larger downstream edits and task difficulty also indicate where the conditions diverge. Thus, building on agent code often introduces maintainability costs, which appear even on two-step chains and are likely to compound over many edits of a software project. As agent contributions become a larger share of working codebases, evaluation must shift from isolated task completion toward long-term maintainability.

### Acknowledgments
We thank Carlos Jimenez, Nicholas Lourie, Varun Yerram, Shashwat Singh, Rico Angell, and Yueh-Han Chen for insightful feedback and discussion. This work was supported in part through the NYU IT High Performance Computing resources, services, and staff expertise.


## Key insights
- We investigate how agent code compares to human code in these maintenance settings, presenting CodeThread, a framework to construct controlled experiments from repository-level coding benchmarks.
- Applying CodeThread to four frontier coding agents and four benchmarks, we find that agents are less effective at resolving tasks when building on agent code compared to human code, with task resolve rate drops of up to 13.1%.
- Instead, the clearest signals are subtler behavioral differences in agent code, such as changes to input validation and error handling, along with differences in downstream code size and task difficulty.
- These findings highlight the need to evaluate these systems not only by immediate task resolution but also by code maintainability, and point to potential sources of downstream errors introduced by agent code.
- However, a patch that passes tests and is functionally correct may still introduce structural complexity, unnecessary verbosity, brittle abstractions, or confusing implementation choices that only lead to failures when the code is later extended or modified in downstream tasks (Figure 1).
- An example instance where both the human and agent code pass the initial implementation task’s tests, yet when an agent makes a subsequent change to both, the version built on human code passes while the version built on agent code fails.
- Recent work has measured agent code maintainability based on these static metrics [^31] [^24], but does not suggest how this code compares against human code.
- To this end, we present CodeThread, a framework to conduct controlled experiments comparing how well agents can build on and maintain agent versus human code.
- It then creates comparable agent and human code on the initial task while holding the downstream task author and test-based evaluation fixed, allowing us to isolate how authorship of the initial task affects downstream agent performance.
- We demonstrate CodeThread on four frontier models—Claude 4.5 Sonnet [^1], GPT-5 [^22], GLM 4.7 [^35], and MiniMax 2.5 [^21] —and on four software engineering benchmarks spanning a range of programming languages and task types.

## Exemplos e evidências
See original source at `Clippings/Is Agent Code Less Maintainable Than Human Code?.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/code-generation]]
- [[03-RESOURCES/entities/Claude]]
- [[03-RESOURCES/entities/OpenAI]]
- [[03-RESOURCES/entities/GitHub-Copilot]]
- [[03-RESOURCES/entities/Codex]]
- [[03-RESOURCES/entities/Rust]]
- [[03-RESOURCES/entities/Python]]

## Minha Síntese
**O que muda:** Código gerado por agentes introduz um custo de manutenção cumulativo — agentes que constroem sobre código de agentes performam pior (até -13.1%), e o sinal mais claro não é complexidade estática mas drift comportamental sutil.

**Conexão pessoal:** No vault, cada ingestão automatizada pode introduzir drift em arquivos .md; preciso avaliar manutenibilidade das notas geradas por agentes, não apenas acerto da tarefa.

**Próximo passo:** Adicionar um check de drift comportamental no pipeline de ingestão — comparar estrutura semântica antes/depois de edições agent-generated.
