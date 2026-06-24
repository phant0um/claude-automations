---
title: "AURA: Adaptive Uncertainty-aware Refinement for LLM-as-a-Judge Auditing"
type: source
source: "Clippings/AURA Adaptive Uncertainty-aware Refinement for LLM-as-a-Judge Auditing.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
Large language models (LLMs) are increasingly used as judges for open-ended generation, as large-scale human evaluation is often expensive and difficult to scale, yet their preferences remain imperfect proxies for human judgment. Existing auditing pipelines often assume that a reliable subset of examples or clean supervision signals are available beforehand, for example from human annotation, heuristic filtering, or the outputs of strong judges. In LLM evaluation, this assumption is fragile: the

## Argumentos principais
### 1 Introduction
Evaluating language-model answers is no longer only a question of whether a benchmark has the right prompts. It is increasingly about whether the evaluator can reliably distinguish between multiple plausible answers that differ in factual accuracy, completeness, reasoning quality, safety, or usefulness (liu2023geval; kim2023prometheus). Human evaluation remains the most direct measure of these differences, but it is expensive, slow, and difficult to scale as models, prompts, and evaluation criteria evolve. As a result, this has made *LLM-as-a-judge* evaluation a practical component of modern model development, where a strong model grades or compares outputs from other models (zheng2023judging; dubois2023alpacafarm).
The practical value of LLM judges comes with a statistical problem. A judge’s preference is not the same object as a human preference. LLM judges can be sensitive to response order, verbosity, formatting, self-preference, and other superficial cues (zheng2023judging; wang2024fair; dubois2024length; zeng2023llmbar; thakur2024judging). These issues are especially consequential in pairwise evaluation, where a single incorrect comparison can reverse the winner and loser of an example. The central challenge is therefore not merely to imitate judge output, but to audit when a judge’s decision is likely to agree with human judgment and when it should be corrected or verified.
A natural starting point is to treat judge auditing as a weakly supervised learning problem. In this view, a small set of human verified comparisons provides trustworthy evidence, while the remaining examples form a large uncertainty pool. Prior positive and unlabeled learning methods offer useful tools for such settings (elkan2008learning; duplessis2014analysis; kiryo2017nonnegative; bekker2020survey). In a PU view, examples for which the LLM judge agrees with human preference form a positive group, while the remaining unverified examples form an unlabelled mixture. Standard PU methods, however, usually assume that the positive examples are already known and that the unlabelled pool is fixed. This assumption is often too strong for LLM evaluation. The initial groups may be derived from the same noisy judge under audit, from weak heuristics, or from a small and biased set of human labels. If these groups are treated as fixed, the auditing procedure may simply preserve and amplify the original bias.

### 2 Background and related work
LLM-as-a-judge evaluation has become a common approach for assessing open-ended generations, especially when task-specific reference answers are unavailable. MT-Bench and Chatbot Arena popularized pairwise LLM and human preference evaluation as a scalable framework for comparing chat assistants (zheng2023judging; chiang2024chatbot). Subsequent work has proposed stronger evaluator models, prompting schemes, and benchmark protocols (liu2023geval; wang2023pandalm; kim2023prometheus; zhu2023judgelm; dubois2024length). At the same time, LLM judges can exhibit position bias, verbosity bias, prompt sensitivity, score instability, and weaker alignment with humans on difficult examples (wang2024fair; zeng2023llmbar; thakur2024judging; tan2024judgebench; park2024offsetbias). Rather than introducing another standalone judge, AURA asks when the output of an existing judge should be trusted.
Our work is also related to preference modeling and reward-model evaluation. Pairwise comparison has a long statistical history, including the Bradley–Terry model (bradley1952rank), and modern alignment pipelines use preference data to train reward models or optimize policies through RLHF and DPO (christiano2017deep; ouyang2022training; bai2022training; rafailov2023dpo). RewardBench evaluates reward models using prompt–chosen–rejected triples across chat, reasoning, and safety settings (lambert2025rewardbench). These works primarily study how to train or benchmark models using preference data. AURA instead studies a complementary auditing problem: given an LLM judge’s pairwise preference, estimate whether it agrees with human judgment and decide whether to trust, correct, or verify it.
Methodologically, AURA connects to PU learning, weak supervision, graph-based semi-supervised learning, transport, and active verification. Standard PU learning assumes labeled positives and an unlabeled mixture (elkan2008learning; bekker2020survey), whereas our target label is LLM–human agreement rather than answer quality, and human verification can provide both positive and negative anchors. We therefore treat the problem as adaptive PU learning, where the positive and unlabeled groups are refined as evidence accumulates. The propagation step is related to graph-based label smoothing and transport methods (zhu2002labelprop; zhou2003localglobal; cuturi2013sinkhorn; peyre2019computational; chapel2020partial), but AURA uses a conservative transport-based operator for sparse, budgeted evidence propagation rather than full distribution alignment. The verification policy is related to active learning, selective prediction, and calibration (settles2009active; geifman2017selective; guo2017calibration), since it selects examples for human review when the current refinement state is uncertain or influential.

### 3 Problem formulation and notation
Let $\mathcal{D}=\{(Q_{i},R_{i}^{1},R_{i}^{2},J_{i}^{\mathrm{H}},J_{i}^{\mathrm{L}})\}_{i=1}^{n}$ be a collection of samples, where $Q_{i}$ is the question or prompt, $R_{i}^{1}$ and $R_{i}^{2}$ are two candidate responses, $J_{i}^{\mathrm{L}}$ is the initial LLM judge, and $J_{i}^{\mathrm{H}}$ is the human judge. An example of the data structure is shown in Figure 3 in Appendix A. The LLM judge assigns a strict preference $J_{i}^{\mathrm{L}}\in\{1,2\}$, where $J_{i}^{\mathrm{L}}=k$ indicates that $R_{i}^{k}$ is preferred. Human labels, when available, are denoted by $J_{i}^{\mathrm{H}}\in\{1,2\}$. We exclude tie cases. For each comparison, the LLM judge induces an initial winner–loser assignment:
$$
R_{i}^{w}=R_{i}^{J_{i}^{\mathrm{L}}},\qquad R_{i}^{\ell}=R_{i}^{3-J_{i}^{\mathrm{L}}}.

### 4 Methodology
We now present AURA, a progressive refinement framework for converting noisy LLM-judge preferences into preference signals that align with human judgments. Starting from preliminary preferences produced by an LLM judge and a small set of human-verified examples, AURA iteratively learns a task-specific representation, updates human-consistency estimates, propagates trust through a conservative transport step, and selectively queries additional human labels. Figure 1 illustrates the overall workflow, and Algorithm 1 in Appendix summarizes the full procedure.

### 4.1 Progressive representation and trust refinement
For each pairwise comparison, we first construct a fixed comparison feature
$$
x_{i}=E_{\mathrm{RM}}(Q_{i},R_{i}^{w})-E_{\mathrm{RM}}(Q_{i},R_{i}^{\ell})\in\mathbb{R}^{d_{x}},

### 4.2 Trust update, conservative transport, and verification
After encoder training, AURA refines the preliminary score $p_{i}^{(t)}$ using model, local, anchor, and transport evidence. We combine these signals through a trust logit
$$
u_{i}^{(t)}=\lambda_{p}\log\frac{p_{i}^{(t)}}{1-p_{i}^{(t)}}+\lambda_{\mathrm{loc}}\left(2r_{i}^{\mathrm{loc},(t)}-1\right)+\lambda_{\mathrm{anc}}\left(2r_{i}^{\mathrm{anc},(t)}-1\right)+\lambda_{m}\left(2m_{i}^{(t)}-1\right)+\beta_{0},

### 5 Theoretical results
In this section, we develop a theoretical analysis of AURA that proceeds from algorithmic foundations to statistical guarantees. We begin by establishing that the joint optimization converges, and then sharpen this guarantee to a linear convergence rate via a contraction argument.

### 5.1 Convergence guarantee for outer loop iteration
The outer loop in Section 4 alternates three algorithmic blocks: encoder training, trust update, and transport reassignment, with selective verification acting as a bounded perturbation that modifies the verified sets and anchor pool. We construct a surrogate Lyapunov function that aggregates progress across these three blocks and show that it decreases sufficiently along the iterates, up to summable error induced by verification. We begin by stating the regularity assumptions, which are standard in analyses of nonconvex optimization and alternating minimization methods (bertsekas1999nonlinear).
###### Assumption 1 (Encoder loss regularity).
The encoder loss $\mathcal{L}^{(t)}_{\mathrm{enc}}(\Theta)=\mathcal{L}^{(t)}_{\mathrm{ver}}+\lambda_{\mathrm{soft}}\mathcal{L}^{(t)}_{\mathrm{soft}}+\lambda_{\mathrm{geo}}\mathcal{L}^{(t)}_{\mathrm{geo}}+\lambda_{\mathrm{anchor}}\mathcal{L}^{(t)}_{\mathrm{anchor}}$ satisfies: (i) it is continuously differentiable in $\Theta$ with $L_{\Theta}$ -Lipschitz gradient; (ii) it is nonnegative, i.e., $\mathcal{L}^{(t)}_{\mathrm{enc}}(\Theta)\geq 0$; (iii) the encoder update produces an approximate minimizer with bounded suboptimality, $\mathcal{L}^{(t)}_{\mathrm{enc}}(\Theta^{(t)})\leq\min_{\Theta}\mathcal{L}^{(t)}_{\mathrm{enc}}(\Theta)+\delta_{t}$, where $\delta_{t}\geq 0$ and $\sum_{t}\delta_{t}<\infty$; (iv) the parameter space $\Theta$ is compact.

### 5.2 Global convergence and conservation properties
###### Lemma 2 (Minimization with sufficient decrease).
Under Assumption [^1] – [^3], the encoder update satisfies $\mathcal{L}^{(t)}_{\mathrm{enc}}(\Theta^{(t+1)})\leq\mathcal{L}^{(t)}_{\mathrm{enc}}(\Theta^{(t)})-c_{\Theta}\|\nabla_{\Theta}\mathcal{L}^{(t)}_{\mathrm{enc}}(\Theta^{(t)})\|^{2}$ for some constant $c_{\Theta}=\eta(1-L_{\Theta}\eta/2)>0$. With $\eta=1/L_{\Theta}$, the inequality holds with $c_{\Theta}=1/(2L_{\Theta})$.
We now define the surrogate Lyapunov function used in the convergence analysis.

### 6 Experiments
We evaluate AURA in three parts. First, we use simulations to test whether the method can recover latent human-consistency structure under noisy judge signals and selective verification. Second, we evaluate real LLM-as-a-judge data across multiple judge models and question types. Third, we provide ablation studies to examine the contribution of each component. The evaluation metrics are provided in Appendix E.1.
Table 1: Simulation results averaged over five independent runs. Each run contains 640 examples: 160 source positive examples and 480 target/unlabeled examples, among which 168 are hidden positives and 312 are negatives. Adjusted accuracy, accuracy difference, and flip rate are reported as mean (max–min range) across runs. Bold values indicate positive improvements.
<table><tbody><tr><td colspan="6">Simulation Results for CD/DD Noise and SCAR/SAR Verification</td></tr><tr><td>Noise</td><td>Verification</td><td>Orig. Acc.</td><td>Adj. Acc.</td><td>Diff.</td><td>Flip Rate</td></tr><tr><td>CD</td><td>SCAR</td><td>73.75%</td><td>85.41% (1.33%)</td><td>+11.66% (1.33%)</td><td>39.53% (1.09%)</td></tr><tr><td>CD</td><td>SAR</td><td>73.75%</td><td>84.31% (1.22%)</td><td>+10.56% (1.22%)</td><td>41.56% (1.51%)</td></tr><tr><td>DD</td><td>SCAR</td><td>73.75%</td><td>84.19% (1.23%)</td><td>+10.44% (1.23%)</td><td>38.81% (0.95%)</td></tr><tr><td>DD</td><td>SAR</td><td>73.75%</td><td>84.88% (1.19%)</td><td>+11.13% (1.19%)</td><td>38.19% (0.66%)</td></tr></tbody></table>

### 6.1 Simulation
We first evaluate AURA in a generative simulation where two latent groups encode whether the initial judge signal is human-consistent. The simulator draws oracle latent coordinates for these groups, maps them to noisy observed comparison features, and corrupts the initial consistency signals, so AURA must recover useful latent structure using only noisy features and corrupted supervision. AURA observes only these noisy features and corrupted signals. We consider four settings: class-dependent (CD) or distribution-dependent (DD) corruption, crossed with selected-completely-at-random (SCAR) or selected-at-random (SAR) verification. CD corruption depends only on the latent consistency group, while DD corruption also depends on the feature geometry. SCAR verification samples verified examples conditionally at random, while SAR verification introduces feature-dependent selection bias. Details of the simulation design are provided in Appendix E.2.
Table 1 shows that AURA improves the initial signal across all four noise and verification settings. The original accuracy is 73.75%, while the adjusted accuracy reaches 84.19%–85.41%. The largest improvement appears in the CD+SCAR setting, where both corruption and verification are the most regular, and AURA raises accuracy from 73.75% to 85.41%. The method also remains effective in the harder DD+SAR setting, where both judge errors and human verification depend on the feature geometry. This setting is the closest synthetic analogue to selective human verification in real LLM-as-a-judge data, yet AURA still improves accuracy to 84.88%. Figure 2 visualizes this DD+SAR case. Although the verified set is incomplete and feature-biased, AURA recovers a clearer separation between human-consistent and human-inconsistent examples. The sensitivity analyses further support this interpretation: AURA benefits from clearer latent group separation, while weak separation in high-dimensional feature spaces makes local geometry and anchor evidence less reliable and therefore reduces the gain. Detailed results are provided in Appendix E.3.

### 6.2 Real-Data evaluation
We next evaluate AURA on real LLM-as-a-judge data constructed from MT-Bench (zheng2023judging) and Chatbot Arena (chiang2024chatbot). We use three question types, coding, math reasoning, and structured factual questions, and include one mixed question type MT-Bench setting. We evaluate five judge models: GPT-5.4, GPT-5.4-mini (openai\_gpt54\_blog), Gemini-2.5-Flash (gemini25flash), Qwen2.5-7B-Instruct (qwen25\_technical\_report), and Mistral-7B-Instruct-v0.3 (jiang2023mistral7b). The full setup is described in Appendix E.4.
Table 2: Coding results for GPT-5.4 and Qwen with 20% verified baseline data. Accuracy and gain are reported as mean (max–min range). Human Verif. Req. denotes the number of human-verified examples required by each method. Baselines use 20% verified data, while AURA uses a substantially smaller adaptive verification budget.
<table><tbody><tr><td colspan="6">Coding Results with 20% Verified Baseline Data</td></tr><tr><td>Metric</td><td>Logistic Reg.</td><td>MLP</td><td>Random Forest</td><td>Label Prop.</td><td>AURA</td></tr><tr><td colspan="6">Model: GPT-5.4 (n = 2949, Orig. Acc = 63.92%)</td></tr><tr><td>Adj. Acc.</td><td>59.54% (3.56)</td><td>60.83% (2.80)</td><td>63.23% (1.87)</td><td>60.50% (9.92)</td><td>67.20% (2.00)</td></tr><tr><td>Gain</td><td>-4.38% (3.56)</td><td>-3.09% (2.80)</td><td>-0.69% (1.87)</td><td>-3.42% (9.92)</td><td>+3.28% (2.00)</td></tr><tr><td>Human Verif. Req.</td><td>590</td><td>590</td><td>590</td><td>590</td><td>100.6</td></tr><tr><td colspan="6">Model: Qwen (n = 8884, Orig. Acc = 53.73%)</td></tr><tr><td>Adj. Acc.</td><td>58.47% (1.59)</td><td>57.44% (1.83)</td><td>59.20% (0.96)</td><td>53.77% (2.11)</td><td>77.74% (9.78)</td></tr><tr><td>Gain</td><td>+4.75% (1.59)</td><td>+3.72% (1.83)</td><td>+5.47% (0.96)</td><td>+0.04% (2.11)</td><td>+24.02% (9.78)</td></tr><tr><td>Human Verif. Req.</td><td>1777</td><td>1777</td><td>1777</td><td>1777</td><td>278.8</td></tr></tbody></table>

### 6.3 Ablation study
Table 3: Full factorial ablation on the Coding setting with Gemini-2.5-Flash. The original judge accuracy is 63.55%. We vary four components: encoder training, full trust-state update, transport update, and human query selection.
<table><thead><tr><th>Full Trust</th><th>Transport</th><th>Human Query</th><th colspan="3">Trained Encoder</th><th colspan="3">Untrained Encoder</th></tr><tr><th></th><th></th><th></th><th>Adj. Acc.</th><th>Gain</th><th>Flips</th><th>Adj. Acc.</th><th>Gain</th><th>Flips</th></tr></thead><tbody><tr><td>✓</td><td>✓</td><td>✓</td><td>66.88%</td><td>+3.33%</td><td>164</td><td>64.72%</td><td>+1.17%</td><td>183</td></tr><tr><td>✓</td><td>✓</td><td>✗</td><td>66.35%</td><td>+2.80%</td><td>153</td><td>66.13%</td><td>+2.59%</td><td>213</td></tr><tr><td>✗</td><td>✓</td><td>✓</td><td>66.81%</td><td>+3.26%</td><td>168</td><td>64.50%</td><td>+0.96%</td><td>179</td></tr><tr><td>✗</td><td>✓</td><td>✗</td><td>66.67%</td><td>+3.12%</td><td>168</td><td>66.03%</td><td>+2.48%</td><td>220</td></tr><tr><td>✓</td><td>✗</td><td>✓</td><td>53.40%</td><td>-10.14%</td><td>2250</td><td>40.78%</td><td>-22.77%</td><td>2576</td></tr><tr><td>✓</td><td>✗</td><td>✗</td><td>53.16%</td><td>-10.39%</td><td>2257</td><td>40.71%</td><td>-22.84%</td><td>2574</td></tr><tr><td>✗</td><td>✗</td><td>✓</td><td>39.72%</td><td>-23.83%</td><td>2720</td><td>41.67%</td><td>-21.88%</td><td>2547</td></tr><tr><td>✗</td><td>✗</td><td>✗</td><td>39.72%</td><td>-23.83%</td><td>2720</td><td>41.03%</td><td>-22.52%</td><td>2581</td></tr></tbody></table>
We ablate the main components of AURA on the Coding setting with Gemini-2.5-Flash. We vary four components: whether the encoder is trained, whether the trust update uses the full confidence state or only the model probability $p_{i}$, whether the transport update is enabled, and whether human queries are selected by the proposed query score or uniformly at random. Implementation details for these four components are provided in Appendices B.1, B.2, B.3, and B.4, respectively.

### 7 Discussion and future work
Overall, these findings show that AURA is a useful method to improve LLM-as-a-judge evaluation when human labels are limited. Rather than assuming that reliable positive and unlabelled groups are available before auditing, AURA learns these groups progressively from judge signals, learned representations, transport-based evidence, and selective verification. This design improves adjusted accuracy in both simulations and real pairwise LLM-answer evaluation while using substantially fewer human verified examples than standard supervised baselines. More broadly, our results suggest that weakly supervised judge auditing should treat trust in the judge as a dynamic quantity: it should be refined and selectively verified as evidence accumulates. This perspective provides a practical path toward more label-efficient and reliable evaluation pipelines for LLM outputs.
One promising direction is to further improve the representation used for refinement. In real LLM evaluation data, human preference labels can vary substantially, because annotators may weigh reasoning, factuality, completeness, style, and usefulness differently. This makes the boundary between human-consistent and human-inconsistent judge decisions less clear than in controlled synthetic settings, and the current representation may not always capture these fine-grained distinctions cleanly. This observation suggests an opportunity for stronger task-adaptive encoders, richer comparison features, and uncertainty-aware treatment of human labels. We expect these extensions to further improve the robustness of adaptive PU auditing, especially in settings where human judgments are nuanced rather than purely deterministic.

### Appendix A Notation and figures
Table 4: Summary of main notation. Detailed quantities used only locally are defined near their corresponding equations.
| Symbol | Meaning |
| --- | --- |


## Key insights
- We formulate LLM–as–a–judge auditing as adaptive human–consistency refinement under limited human verification, where trustworthy and uncertain groups are progressively updated, and informative comparisons are selected for human verification.
- We organize the method around a compact set of interpretable state variables, including soft human–consistency responsibility, anchor confidence, and carried evidence inflow.
- We provide a stability analysis for the alternating update procedure and an evaluation protocol covering synthetic recovery, real pairwise LLM evaluation, robustness to noisy initialization, and annotation efficiency.
- sensitivity analysis with respect to noisy initial PU memberships,
- convergence properties of the iterative membership refinement,
- error decomposition for fixed-group versus learned-group auditing.

## Exemplos e evidências
See original source at `Clippings/AURA Adaptive Uncertainty-aware Refinement for LLM-as-a-Judge Auditing.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/ai-agents/prompt]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/OpenAI]]
- [[03-RESOURCES/entities/Gemini]]
- [[03-RESOURCES/entities/AWS]]
- [[03-RESOURCES/entities/Rust]]

## Minha Síntese
**O que muda:** Este estudo reforça que large language models (llms) are increasingly used as judges for open-ended generation, as large-scale human evaluation  — impacta diretamente como projetar e avaliar agentes.

**Conexão pessoal:** Conecto isso ao meu trabalho com Hermes Agent e o vault-michel: preciso aplicar este padrão nos meus fluxos de ingestão e consolidação.

**Próximo passo:** Implementar um experimento prático com este conceito nos próximos ciclos de desenvolvimento do vault.