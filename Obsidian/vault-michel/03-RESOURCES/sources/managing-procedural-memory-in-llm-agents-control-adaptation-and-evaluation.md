---
title: "Managing Procedural Memory in LLM Agents: Control, Adaptation, and Evaluation"
type: source
source: "Clippings/Managing Procedural Memory in LLM Agents Control, Adaptation, and Evaluation.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
Procedural memory is increasingly used to improve LLM agents on recurring workplace tasks, yet its ability to produce reusable skills remains poorly understood. We introduce AFTER, a benchmark of 382 realistic enterprise tasks spanning six professional roles and 22 procedural skills, designed to evaluate how skills transfer across tasks, roles, and model backbones. The benchmark includes controlled evaluation settings for local improvement, cross-task transfer, cross-role transfer, and cross-mod

## Argumentos principais
### 1 Introduction
Figure 1: Skill evolution landscape. Procedural memories for six skills (docx, pipelines, pptx, sql, statistics, xlsx) are evolved with a Hermes memory update operator and evaluated on AFTER. Skills evolved from narrow experience often exhibit source-context overfitting: they improve specificity while degrading generality. Skills evolved from diverse experience move toward the desired high-specificity, high-generality regime.
The main AI trend of the decade is the development of LLMs [^29] [^3]. Scaling training data and computation has driven broad improvements, but further scaling may face limits from bounded human-generated data [^11] [^30]. Meanwhile, LLM-based agents are increasingly used in practical settings [^37] [^32], where they spend substantial inference-time compute on planning, tool use, reflection, and retries [^26] [^23]. In industrial workflows, many tasks are recurring procedures rather than isolated queries: processing documents, editing spreadsheets and presentations, querying databases, configuring infrastructure, and writing tests. This creates two competing demands: cheaper and faster frameworks [^10] for frequent queries in personal and corporate settings, and agents that better interact with humans and environments [^41] [^22], personalize to context [^36], and generalize to growing task complexity [^13] [^21].
This shift motivates persistent mechanisms that improve reuse, reliability, and efficiency at inference time [^40] [^24]. Procedural memory is a promising direction [^8] [^20] [^34]: a reusable layer of instructions, procedures, and strategies distilled from prior trajectories. For workplace agents, such memory is valuable only if it captures what transfers across tasks, users, roles, and model backbones while discarding incidental source-context details. This is difficult because trajectories depend on the model, tools, task family, and workflow that produced them; skills extracted from narrow experience may work in their source setting yet fail when the context changes [^6] [^14] [^5].

### 2 AFTER: A Benchmark for Skill Transfer
| Benchmark | Tasks | Roles | Skills | Multi-step tasks | Transfer splits |
| --- | --- | --- | --- | --- | --- |
| GAIA | 466 | – | ✗ | ✓ | ✗ |

### 2.1 Benchmark Design
#### Roles.
The six roles cover common functions in technology organizations: Data Engineers (DE; data pipelines), Data Scientists (DS; statistical and ML analysis), Generative AI Engineers (GenAI; LLM applications), Infrastructure Engineers (Infra; cloud and deployment), Project Managers (PM; business documents), and Software Engineers (SWE; application code). Roles define how skills are instantiated: for example, a PDF skill may support invoice extraction for DE, document ingestion for GenAI, or executive summarization for PM. Thus, each role induces a characteristic task–skill distribution (Figure 2a).
#### Tasks.

### 2.2 Benchmark Construction
Tasks come from two high-level sources. *Adapted tasks* are drawn from SkillsBench [^16], SWE-bench Verified [^13] and Pro [^7], MLE-bench [^4], FeatureBench [^44], RE-Bench [^33], Terminal-Bench [^19], CodeScaleBench [^27], DevOps-Gym [^28], SRE-skills-bench [^25], and issues from popular open-source repositories. We preserve the core problem and success criterion, but rewrite each instruction as a self-contained workplace request and re-implement verification as a pytest suite. *Newly designed tasks* cover scenarios not available in prior benchmarks; they are either practitioner-designed or first drafted with a frontier LLM and then expert-refined into realistic workplace workflows, including longer tasks requiring multiple reasoning and tool-use steps. All tasks pass automated validation and independent expert review for verifier robustness, clarity, skill fit, realism, and oracle leakage. Appendix E details task origins, adaptation, and quality control.
In parallel, we curate 22 reusable skills from common workplace procedures in document processing, data operations, ML and AI, infrastructure, and software engineering. Each task is assigned the minimal skill set required for completion, keeping task–skill annotations fixed and separating skill quality from retrieval quality. Each skill has two prompt bodies: a handcrafted baseline (H) adapted from public skill sources and an LLM-generated body (G) drafted as a broader procedural reference (Appendix L). This enables a controlled comparison between expert-derived and automatically authored procedural knowledge.

### 2.3 Evaluation Protocol
We evaluate skills through *specificity* (source-context improvement) and *generality* (transfer under distribution shift) and report two accuracy metrics. Let $\text{passed}*{k,t}$ denote the number of tests passed on attempt $k$ of task $t$, and $\text{total}*{t}$ the total number of tests.
$$
\text{M1}=\frac{1}{N_{\text{tasks}}}\sum_{t}\frac{1}{N_{\text{att}}}\sum_{k}\frac{\text{passed}_{k,t}}{\text{total}_{t}}

### 3 Methods
<table><tbody><tr><td></td><td></td><td colspan="4">DS</td><td colspan="4">GenAI</td><td colspan="4">PM</td><td colspan="4">Infra</td><td colspan="3">Aggregate</td></tr><tr><td>Model</td><td>Size</td><td><math><semantics><mi>∅</mi> <annotation>\varnothing</annotation></semantics></math></td><td>H</td><td>G</td><td><math><semantics><mi>Δ</mi> <annotation>\Delta</annotation></semantics></math></td><td><math><semantics><mi>∅</mi> <annotation>\varnothing</annotation></semantics></math></td><td>H</td><td>G</td><td><math><semantics><mi>Δ</mi> <annotation>\Delta</annotation></semantics></math></td><td><math><semantics><mi>∅</mi> <annotation>\varnothing</annotation></semantics></math></td><td>H</td><td>G</td><td><math><semantics><mi>Δ</mi> <annotation>\Delta</annotation></semantics></math></td><td><math><semantics><mi>∅</mi> <annotation>\varnothing</annotation></semantics></math></td><td>H</td><td>G</td><td><math><semantics><mi>Δ</mi> <annotation>\Delta</annotation></semantics></math></td><td><math><semantics><mi>∅</mi> <annotation>\varnothing</annotation></semantics></math></td><td>Best</td><td><math><semantics><mi>Δ</mi> <annotation>\Delta</annotation></semantics></math></td></tr><tr><td>GPT 5.4</td><td>L</td><td>42.0</td><td>47.0</td><td>55.0</td><td>+13.0</td><td>40.0</td><td>43.1</td><td>40.0</td><td>+3.1</td><td>38.5</td><td>44.6</td><td>33.8</td><td>+6.1</td><td>50.0</td><td>48.7</td><td>56.3</td><td>+6.3</td><td>47.6</td><td>50.1</td><td>+2.5</td></tr><tr><td>GPT 5.4 Mini 4</td><td>M</td><td>43.0</td><td>33.0</td><td>48.0</td><td>+5.0</td><td>35.8</td><td>31.6</td><td>45.3</td><td>+9.5</td><td>27.7</td><td>24.6</td><td>30.8</td><td>+3.1</td><td>60.0</td><td>43.7</td><td>48.7</td><td>-11.3</td><td>44.0</td><td>44.9</td><td>+0.9</td></tr><tr><td>DeepSeek V4 Flash</td><td>L</td><td>28.7</td><td>29.6</td><td>33.9</td><td>+5.2</td><td>31.6</td><td>30.5</td><td>35.8</td><td>+4.2</td><td>11.4</td><td>17.1</td><td>18.1</td><td>+6.7</td><td>48.8</td><td>46.3</td><td>41.2</td><td>-7.6</td><td>34.6</td><td>37.1</td><td>+2.5</td></tr><tr><td>Nemotron 3 120B</td><td>M</td><td>29.6</td><td>31.3</td><td>28.7</td><td>+1.7</td><td>42.1</td><td>36.8</td><td>35.8</td><td>-6.3</td><td>14.3</td><td>21.9</td><td>24.8</td><td>+10.5</td><td>37.5</td><td>31.2</td><td>41.3</td><td>+3.8</td><td>31.9</td><td>33.0</td><td>+1.1</td></tr><tr><td>Gemma 4 31B</td><td>M</td><td>45.5</td><td>45.0</td><td>49.5</td><td>+4.0</td><td>35.3</td><td>35.3</td><td>33.7</td><td>-1.6</td><td>10.0</td><td>13.9</td><td>23.9</td><td>+13.9</td><td>43.1</td><td>45.6</td><td>44.4</td><td>+2.5</td><td>38.5</td><td>41.3</td><td>+2.8</td></tr><tr><td>Gemma 4 26B A4B</td><td>M</td><td>37.5</td><td>42.0</td><td>48.0</td><td>+10.5</td><td>37.4</td><td>40.0</td><td>40.0</td><td>+2.6</td><td>16.9</td><td>24.6</td><td>20.0</td><td>+7.7</td><td>34.4</td><td>28.1</td><td>40.0</td><td>+5.6</td><td>36.2</td><td>39.7</td><td>+3.5</td></tr><tr><td>Gemma 4 E4B</td><td>S</td><td>20.5</td><td>18.5</td><td>24.5</td><td>+4.0</td><td>15.3</td><td>23.7</td><td>29.5</td><td>+14.2</td><td>8.5</td><td>11.5</td><td>13.1</td><td>+4.6</td><td>13.8</td><td>14.4</td><td>21.2</td><td>+7.4</td><td>19.4</td><td>24.0</td><td>+4.6</td></tr><tr><td>Qwen 3.5-397B-FP8</td><td>L</td><td>36.0</td><td>35.2</td><td>40.2</td><td>+4.2</td><td>35.3</td><td>35.5</td><td>38.7</td><td>+3.4</td><td>12.3</td><td>13.5</td><td>16.9</td><td>+4.6</td><td>48.1</td><td>46.9</td><td>45.0</td><td>-3.1</td><td>37.8</td><td>41.3</td><td>+3.5</td></tr><tr><td>Qwen 3.5-122B-A10B</td><td>L</td><td>36.0</td><td>33.5</td><td>41.0</td><td>+5.0</td><td>30.0</td><td>34.2</td><td>35.3</td><td>+5.3</td><td>12.3</td><td>19.2</td><td>20.8</td><td>+8.5</td><td>44.4</td><td>45.0</td><td>42.5</td><td>+0.6</td><td>36.5</td><td>39.7</td><td>+3.2</td></tr><tr><td>Qwen 3.5-35B-A3B</td><td>M</td><td>21.5</td><td>25.5</td><td>30.5</td><td>+9.0</td><td>27.9</td><td>31.6</td><td>36.9</td><td>+9.0</td><td>13.1</td><td>13.1</td><td>14.6</td><td>+1.5</td><td>28.1</td><td>23.7</td><td>35.0</td><td>+6.9</td><td>26.9</td><td>32.2</td><td>+5.3</td></tr><tr><td>Qwen 3.5-9B</td><td>S</td><td>12.5</td><td>11.5</td><td>17.0</td><td>+4.5</td><td>17.9</td><td>15.3</td><td>18.9</td><td>+1.0</td><td>6.2</td><td>10.8</td><td>14.6</td><td>+8.4</td><td>11.3</td><td>13.8</td><td>20.6</td><td>+9.3</td><td>15.7</td><td>18.7</td><td>+3.0</td></tr><tr><td>GPT-oss-120B</td><td>L</td><td>44.5</td><td>47.0</td><td>49.0</td><td>+4.5</td><td>38.3</td><td>42.6</td><td>41.6</td><td>+4.3</td><td>32.3</td><td>30.8</td><td>33.1</td><td>+0.8</td><td>57.5</td><td>51.3</td><td>58.7</td><td>+1.2</td><td>43.2</td><td>45.6</td><td>+2.4</td></tr><tr><td>GPT-oss-20B</td><td>M</td><td>30.0</td><td>32.0</td><td>29.0</td><td>+2.0</td><td>32.6</td><td>32.6</td><td>32.6</td><td>+0.0</td><td>16.1</td><td>22.3</td><td>16.9</td><td>+6.2</td><td>30.6</td><td>25.6</td><td>30.0</td><td>-0.6</td><td>30.9</td><td>31.3</td><td>+0.4</td></tr></tbody></table>
Table 2: Static M2 (%) on AFTER under no-skill ($\varnothing$), handcrafted (H), and generated (G) skills. $\Delta$ denotes the best gain over no-skill. Colors indicate: $\geq$ +10, +4..+10, +2..+4, 0..+2, $<$ 0.

### 3.1 Procedural-Memory Optimization
Let $\Sigma\subset\mathcal{S}$ be a procedural-memory configuration (a single skill or a skill library) and $\mathcal{D}=\{\tau_{i}\}_{i=1}^{N}$ a pool of $N$ traces collected under $\Sigma$ or its earlier versions. An update operator $U$ maps experience to a new configuration, $\Sigma^{\prime}=U(\Sigma,\mathcal{D})$, and may be instantiated as reflection, distillation, or a learned memory-writing policy [^9]. Given an initial $\Sigma_{0}$, source and target distributions $p_{\mathrm{src}},p_{\mathrm{tgt}}$, and a trace budget $N$, we seek the update rule maximizing expected value on target contexts:
$$
\displaystyle U^{*}=\arg\max_{U\in\mathcal{U}}\;\mathbb{E}_{\begin{subarray}{c}\mathcal{D}_{\mathrm{src}}\sim p_{\mathrm{src}}\\

### 3.2 Evolution: Benchmark Evaluation Interface
To compare procedural-memory systems on AFTER, we use Evolution, a lightweight harness that standardizes trace collection, skill versioning, update execution, and transfer measurement. Skills are stored as versioned SKILL.md artifacts with YAML metadata and markdown bodies; each execution emits a trace linked to the active skill version, making updates and evaluations reproducible. Evolution supports full-skill updates through a Collect–Diagnose–Revise–Promote cycle. We denote by $\rho$ the *reflector*: the model or procedure that inspects traces, summarizes failure modes, and proposes a revised skill body. For current skill version $s^{(v)}$ and source trace pool $\mathcal{D}_{\mathrm{src}}$, the update is $s^{(v+1)}=U_{\rho}(s^{(v)},\mathcal{D}_{\mathrm{src}})$. Thus, Evolution fixes trace collection, validation, promotion, rollback, and lineage tracking, while the reflector $\rho$ may vary across experiments or external systems. We evaluate four external procedural-memory systems through this interface; their update mechanisms are summarized in Appendix C. Full harness details are in Appendix B.

### 4 Experiments and Results
We evaluate procedural memory on AFTER in four stages. First, we measure the value of static skill content without adaptation. Second, we test whether a single refinement pass can improve existing skills. Third, we compare trace-based skill evolution under narrow and diverse experience. Finally, we analyze transfer across models and roles, together with inference efficiency. Full experimental details are provided in Appendix F.

### 4.1 Static Skill Valuation
In the static setting, each LLM is invoked once per task with the task instruction and, optionally, a skill in the prompt; there is no agent orchestration, retrying, tool use, or evolution. Skill content takes one of three forms: none ($\varnothing$), handcrafted (H), or LLM-generated (G). We report M2 as the primary metric, M1 results are provided in Appendix Table I.1.
Table 2 reports results for the four roles most affected by skill availability (DS, GenAI, PM, Infra), along with aggregate statistics. Full per-role results are provided in Appendix Table I.2. Skills benefit weaker models more consistently than frontier models: for example, Gemma 4 E4B gains +14.2 points on GenAI, while GPT 5.4 gains +3.1. LLM-generated skills (G) often outperform handcrafted skills (H), suggesting that automated skill authoring can match expert-derived procedural knowledge. Gains vary by role: DS and GenAI benefit most, whereas DE and SWE show smaller improvements, likely because coding-heavy roles already perform well without explicit procedural guidance.

### 4.2 LLM-Guided Skill Improvement
Figure 3: Single-round refinement impact: M2 accuracy before ( H p r e H\_{pre} ) and after ( o s t H\_{post} ) for top-4 roles by gain.
The static setup isolates the value of skill *content* but says nothing about how procedural memory should be *produced* or *adapted*. Before exploring multi-round evolution, we test whether a single refinement pass can improve existing skills. We apply one round of LLM-guided refinement (using Evolution with Codex as reflector) to the handcrafted skill catalogue, producing H ${}_{\text{post}}$ from H ${}_{\text{pre}}$.
Figure 3 shows that even a single refinement round yields consistent improvements: +3.7 to +6.7 aggregate points across model scales. Larger models benefit more consistently, with Infra and SWE showing the strongest gains. Full results are in Appendix Table K.1.

### 4.3 Framework-Guided Skill Improvement
<table><tbody><tr><td>Framework</td><td>Seed</td><td colspan="2">Narrow</td><td colspan="2">Diverse</td></tr><tr><td></td><td></td><td><math><semantics><msub><mi>Δ</mi> <mi>tr</mi></msub> <annotation>\Delta_{\rm tr}</annotation></semantics></math></td><td><math><semantics><msub><mi>Δ</mi> <mi>te</mi></msub> <annotation>\Delta_{\rm te}</annotation></semantics></math></td><td><math><semantics><msub><mi>Δ</mi> <mi>tr</mi></msub> <annotation>\Delta_{\rm tr}</annotation></semantics></math></td><td><math><semantics><msub><mi>Δ</mi> <mi>te</mi></msub> <annotation>\Delta_{\rm te}</annotation></semantics></math></td></tr><tr><td>Codex GPT-5.5</td><td>57.1</td><td>-1.7</td><td>+0.4</td><td>-2.5</td><td>+8.3</td></tr><tr><td>Hermes</td><td>58.4</td><td>+3.6</td><td>-1.4</td><td>+3.7</td><td>+18.0</td></tr><tr><td>Memento</td><td>52.4</td><td>-12.7</td><td>+0.1</td><td>+3.8</td><td>+2.0</td></tr><tr><td>MemP</td><td>56.6</td><td>+13.9</td><td>+2.5</td><td>+7.3</td><td>+0.0</td></tr><tr><td>EvoSkill</td><td>52.5</td><td>+14.9</td><td>-2.7</td><td>-5.7</td><td>-3.9</td></tr></tbody></table>
Table 3: Train and test M1 gains over handcrafted skills on pdf, xlsx, and pptx tasks using a shared Qwen3.5-35B-A3B solver, averaged over pdf, xlsx, and pptx. Seed = handcraft test M1; $\Delta_{\text{tr}}$ / $\Delta_{\text{te}}$ = evolved $-$ seed on train / test (same task set per condition). Trace and skill management are framework-specific. Narrow: $n=1$; Diverse: $n=5$. Colors denote test gains.
We evaluate procedural memory frameworks on skill evolution from execution traces. Table 3 compares five approaches under narrow ($n=1$) and diverse ($n=5$) evolution. We run frameworks through the same Evolution harness under identical conditions with shared Qwen3.5-35B-A3B solver, task pool, and train/test splits. Results reveal a clear gap between specialization and transfer: all frameworks struggle with the proper generalization, large training gains do not necessarily translate into improvements on held-out tasks.

### 4.4 Skill Transfer Analysis
We analyze skill transfer along three practically important dimensions: cross-model generalization, cross-role transfer, and inference efficiency.
Figure 4: Cross-model transfer: test accuracy when skills are evolved from traces of different source models versus diverse traces from all models.
#### Cross-model transfer.

### 5 Conclusion
We introduced AFTER, a benchmark for evaluating procedural memory through transfer across tasks, roles, and model backbones. Across 382 workplace tasks, we find that procedural skills improve full-pass accuracy by +2.8 points on average, while a single round of skill evolution yields an additional +5.2-point gain. Skills evolved from diverse multi-model traces achieve 73.1% cross-model test accuracy, outperforming the best single-model trace source by at least +13.7 points. At the same time, cross-role studies reveal an important limitation: skills naturally specialize to local workflows and may lose effectiveness when transferred across contexts. Taken together, these results suggest that the central challenge of procedural memory is not storing more experience, but extracting procedural structure that remains useful beyond the environment in which it was learned.

### Limitations
Benchmark coverage. AFTER targets technology-sector roles and workplace tasks drawn partly from authors’ practice, which may underrepresent domains such as healthcare, legal, or scientific research. The 22 skills span five capability areas but intentionally exclude open-ended creative or conversational tasks, limiting conclusions to procedural, tool-use-oriented workflows.
Evaluation scope. Our experiments fix the trace budget per evolution run to enable controlled comparison; real deployments may accumulate far larger trace pools, and the relationship between trace volume and transfer quality remains an open question. Evaluation uses automated pytest verification, which measures functional correctness but does not capture qualities such as code readability, robustness to edge cases beyond the test suite, or user preference.
Model and framework selection. We evaluate a representative but non-exhaustive set of LLMs and procedural-memory frameworks. Several recently released frontier models and memory systems could not be included due to API access constraints or release timing relative to benchmark finalization.


## Key insights
- Metadata (task.toml): task name, role, required skills, difficulty, and data source attribution.
- Instructions (instruction.md): realistic request mimicking how a colleague might describe the work.
- Input files (inputs/): authentic data in workplace formats (Excel, PDF, CSV, JSON).
- Verification (tests/test\_outputs.py): pytest assertions for automated correctness checking.

## Exemplos e evidências
See original source at `Clippings/Managing Procedural Memory in LLM Agents Control, Adaptation, and Evaluation.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/Claude]]
- [[03-RESOURCES/entities/Hermes]]
- [[03-RESOURCES/entities/OpenAI]]
- [[03-RESOURCES/entities/Codex]]
- [[03-RESOURCES/entities/AWS]]
- [[03-RESOURCES/entities/Python]]

## Minha Síntese
**O que muda:** Procedural memory (skills) evolve via Collect-Diagnose-Revise-Promote — skills evolved from diverse traces transfer across models (+13.7pp), mas skills from narrow experience overfit e degradam generality.

**Conexão pessoal:** O AFTER benchmark com Evolution harness é exatamente o padrão de skill evolution que o Hermes Agent implementa — trace collection, versioning, e promote/rollback.

**Próximo passo:** Garantir que as skills do vault evoluem a partir de traces diversas (múltiplos modelos/tarefas), não de experiência narrow de uma só sessão.
