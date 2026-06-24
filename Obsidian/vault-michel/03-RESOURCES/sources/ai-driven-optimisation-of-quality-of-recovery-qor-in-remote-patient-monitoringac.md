---
title: "AI-driven Optimisation of Quality of Recovery (QoR) in Remote Patient MonitoringAccepted as a poster at AI in Medicine 2026 (Polish Institute for Evidence Based Medicine), a non-archival venue; the accepted abstract is available online [13]. This is the authors’ preprint version."
type: source
source: "Clippings/AI-driven Optimisation of Quality of Recovery (QoR) in Remote Patient MonitoringAccepted as a poster at AI in Medicine 2026 (Polish Institute for Evidence Based Medicine), a non-archival venue; the accepted abstract is available online 13. This.md"
created: 2026-06-23
ingested: 2026-06-23
score: B
tags: [articles, source-page]
---

## Tese central
Remote patient monitoring depends on patient-reported data to capture the subjective dimension of recovery that devices cannot measure. The Quality of Recovery (QoR-15) survey is the gold-standard instrument for this purpose. It was designed and validated for occasional in-hospital assessment, yet remote monitoring now administers it to patients daily.

## Argumentos principais
### AI-driven Optimisation of Quality of Recovery (QoR) in Remote Patient Monitoring
Yansong Liu <sup><math xmlns=" display="inline" data-latex="\dagger"><semantics><mo>†</mo> <annotation>\dagger</annotation></semantics></math></sup> University College London, London, United Kingdom Li-Hsi (Sonny) Lin <sup><math xmlns=" display="inline" data-latex="\dagger"><semantics><mo>†</mo> <annotation>\dagger</annotation></semantics></math></sup> University College London, London, United Kingdom Pramit Khetrapal University College London, London, United Kingdom Ethera Health Ltd, London, United Kingdom Ronnie Stafford University College London, London, United Kingdom Ethera Health Ltd, London, United Kingdom John Kelly University College London, London, United Kingdom Ethera Health Ltd, London, United Kingdom Ivana Drobnjak <sup><math xmlns=" display="inline" data-latex="\ddagger"><semantics><mo>‡</mo> <annotation>\ddagger</annotation></semantics></math></sup> University College London, London, United Kingdom
###### Abstract
Remote patient monitoring depends on patient-reported data to capture the subjective dimension of recovery that devices cannot measure. The Quality of Recovery (QoR-15) survey is the gold-standard instrument for this purpose. It was designed and validated for occasional in-hospital assessment, yet remote monitoring now administers it to patients daily. In our own post-surgical deployment, only 55% of patients submitted the survey more than 14 days of 30 monitoring days [^9]. We developed QoR-compact, a five-item daily input for the RPM prediction pathway. Setting a deployment-driven target of one-third of the daily items, we exhaustively evaluated all 3,003 five-question subsets of the QoR-15 and tested whether the best of them matches the full instrument in predicting near-term postoperative recovery severity. QoR-compact achieves a mean AUC-ROC of 0.968 (95% CI 0.915–0.988), statistically comparable to the 0.964 baseline obtained with one-third of the items. Patient-level backtesting indicates that it tracks readmission events as faithfully as the full form. Its five items span the physical and psychological axes of recovery: Q3 (feeling rested), Q9 (feeling comfortable and in control), Q10 (general well-being), Q12 (severe pain), and Q14 (feeling worried or anxious). The QoR-15 remains the gold-standard measure of recovery; QoR-compact complements it as a shorter daily input designed for prediction. This parity provides the basis for a prospective study of whether a lighter daily input is, in turn, completed more consistently. External validation on larger cohorts is required before clinical use.

### 1 Introduction
Artificial intelligence remote patient monitoring (AI-RPM) facilitates the ongoing transition towards patient-centred healthcare by extending elements of hospital care into patients’ homes [^1]. AI-RPM combines wearable sensors, patient-reported outcome measures (PROMs), and machine-learning models to enable continuous, data-driven recovery assessment outside the clinical setting [^8]. Its promise is substantial: earlier detection of clinical deterioration, reduced readmission burden, and greater patient engagement in their own recovery.
Among the PROMs used in postoperative care, the Quality of Recovery (QoR-15) is a 15-item survey that has become the gold-standard instrument for assessing postoperative recovery [^3]. Developed and psychometrically evaluated by Stark and Myles, it spans both the physical and psychological dimensions of recovery, and a subsequent systematic review and meta-analysis confirmed its reliability and responsiveness across diverse surgical populations [^4]. These properties have led to its adoption in several RPM systems, where it captures the subjective recovery signal that wearables alone cannot provide.
The QoR-15 was, however, designed for episodic in-hospital use, typically administered once on the day of or after surgery [^3]. Remote monitoring inverts this assumption: patients are asked to complete the full 15-item survey daily, often for weeks after discharge. This daily repetition imposes a substantial response burden that erodes compliance over time: feasibility studies of app-based home QoR-15 monitoring have reported such attrition [^5], and randomised trials of smartphone-based postoperative monitoring have likewise identified engagement as the limiting factor [^6]. In our own post-surgical deployment, only 55% of patients submitted the survey more than 14 days of 30 monitoring days [^9]. The resulting missingness degrades the predictive models that depend on it. To our knowledge, no study has optimised the QoR-15 specifically for the demands of AI-RPM.

### 2 Materials and Methods
We derived QoR-compact from the HALO-Surgery monitoring data and validated it against patient-level recovery outcomes.

### Data collection.
QoR-15 records were drawn from the prospective HALO-Surgery study (IRAS 284073). Patients discharged after abdominal or thoracic cancer surgery completed the survey daily through a remote-monitoring platform (Figure 1). This is the same deployment whose completion pattern motivated this work, as reported in the Introduction.
Figure 1: Clinical data-collection workflow of the HALO-Surgery study. Eligible patients undergoing abdominal or thoracic cancer surgery were enrolled, discharged with a remote-monitoring device, and asked to complete the QoR-15 survey daily; the submissions were streamed to the HALO platform for analysis.

### Preprocessing.
Each patient’s longitudinal record was processed with a sliding window that advances one day at a time. At each position, the preceding 14 days form an *input window*. The feature vector is the mean score of each question over the input window (Figure 2, Panel 1), preserving the instrument’s native 0–10 scale while summarising the patient’s recent recovery trajectory.

### Exploratory collinearity analysis.
Before any modelling, we ran a pre-specified collinearity analysis across the 15 items to assess whether a smaller, well-chosen subset could plausibly retain the predictive signal of the full survey. Running this analysis before training keeps the motivation for compaction independent of the modelling outcome. Pairwise Spearman rank correlations $\rho$ and variance-inflation factors were computed across all patient-day observations. The Spearman correlations were summarised as a lower-triangle heatmap (Figure S1, Supplementary Material) and converted into a hierarchical clustering dendrogram using the distance $d=1-|\rho|$ with average linkage, so that redundant items group into visible branches (Figure 3). Findings are reported in Results.

### Label construction.
The prediction target is the patient’s near-future recovery state (Figure 2, Panel 2). The 14 days following each input window form an *output window*. The aggregate QoR score over the output window (range 0–150) is mapped to one of four ordinal recovery classes using clinically established QoR-15 thresholds [^7]: Excellent, Good, Moderate, and Poor. Each valid window position yields one input–output pair. Cohort sizes and class counts are reported in Results.

### Exhaustive evaluation and selection.
Under the five-question budget fixed above, every one of the $\binom{15}{5}=3{,}003$ possible 5-question subsets was evaluated, together with the full 15-question baseline. For each subset, an XGBoost multiclass classifier was trained to predict the four-class recovery label (Figure 2, Panel 3). All models were trained and evaluated under identical conditions across 10 stratified bootstrap resamples, so that any performance difference is attributable solely to question choice. Models were ranked by one-vs-rest weighted Area Under the Receiver Operating Characteristic curve (AUC-ROC), with 95% confidence intervals taken from the bootstrap percentiles. We did not adopt the single best-ranked subset, which may reflect idiosyncrasies of one dataset. Instead, we identified questions by their consistency across the top-100 subsets (Figure 2, Panel 4). Each subset draws 5 of 15 questions, so any question would appear $5\times 100/15\approx 33.3$ times by chance. Within the five-question budget, the five questions most consistently over-represented among the top-100 subsets were taken to constitute the final QoR-compact.

### Analysis and visualisation.
All analyses were performed in Python with scikit-learn [^10] for metric computation and data splitting. For the exhaustive evaluation (Figure 4(a)), each model’s bootstrap mean AUC-ROC is shown as a horizontal bar, with asymmetric 95% CI error bars taken from the empirical 2.5th and 97.5th percentiles of the per-split AUC values; this preserves the skewed bootstrap distribution, unlike a $\pm$ standard error. The baseline 15-item model is shown as a separate reference bar. The frequency with which each item appears among the top-100 subsets is plotted as a horizontal bar chart (Figure 4(b)), against a by-chance expectation of $5\times 100/15\approx 33.3$ occurrences. For qualitative patient-level validation (Figure 5), per-patient dual-axis trajectories plot the daily full QoR-15 total (0–150, left axis) against the QoR-compact total (0–50, right axis) over postoperative days 0–30, with hospital readmission and complication events superimposed as vertical markers.
Figure 2: Overview of the analysis. (1) The 15 QoR-15 items generate all ( 15 5 ) = 3, 003 \\binom{15}{5}=3{,}003 five-question input subsets. (2) The prediction target is the patient’s recovery class over the 14 days following the input window, mapped to four ordinal categories. (3) Each subset is benchmarked with an XGBoost multiclass classifier under 10 stratified bootstrap resamples. (4) Subsets are ranked by AUC-ROC; the five items most consistently appearing among the top-100 subsets constitute QoR-compact.

### 3 Results
After cleaning, 1,035 daily QoR-15 submissions from the eligible cohort were retained for analysis. Applying the sliding-window procedure of Section 2 yielded 144 input–output pairs. These fell into the four recovery classes as 5 Excellent, 35 Good, 86 Moderate, and 18 Poor.
Before searching for a shorter form, we asked whether the 15 items of the QoR-15 carry independent information. Pairwise Spearman correlations and variance-inflation factors revealed several tight item clusters whose information was largely recoverable from neighbouring items (Figure 3). The tightest pairs, such as Q9–Q10, Q3–Q4, and Q14–Q15, group semantically related questions, indicating that the redundancy is structured rather than random.
Figure 3: Hierarchical clustering of the 15 QoR-15 items. The dendrogram uses distance = 1 − | ρ =1-|\\rho| with average linkage on the pairwise Spearman correlations. Tight item clusters pair questions that probe the same domain: Q3 (feeling rested) with Q4 (good sleep), Q11 (moderate pain) with Q12 (severe pain), Q9 (feeling comfortable and in control) with Q10 (general well-being), and Q14 (feeling worried or anxious) with Q15 (feeling sad or depressed). This structured redundancy motivates the search for a compact form. The underlying correlation matrix is shown in Figure S1 (Supplementary Material).

### 4 Discussion and Limitations
Using one-third of the QoR-15 items, QoR-compact reached predictive performance comparable with the full 15-item instrument. Its point estimate was marginally higher (0.968 vs. 0.964), with narrower bootstrap intervals.
This performance is consistent with the pre-specified collinearity analysis. The 15 QoR-15 items form tight semantic clusters (pain, rest, affect, wellbeing) whose information is largely redundant, so pruning within clusters need not sacrifice signal. The exhaustive search confirmed that the remaining signal is not evenly distributed: whether a five-item form matches the full instrument depends on which items are retained. This distinguishes the present predictive-compaction approach from traditional psychometric short-form development [^11], which selects items to preserve latent construct coverage rather than predictive performance against an external criterion.
The selected items are clinically coherent. Q12 (severe pain) and Q3 (feeling rested) track the physical trajectory of recovery; uncontrolled pain and disrupted rest are well-established antecedents of postoperative deterioration [^12]. Q14 (anxiety), Q9 (sense of control), and Q10 (general wellbeing) capture the psychological dimension. Post-surgical anxiety and a perceived loss of control are recognised correlates of poor recovery outcomes [^4]. These are also the items the backtests show to be most reactive at points of acute deterioration, consistent with their role in an early-warning context.

### 5 Conclusion and Future Work
Future work will test QoR-compact on larger, multi-centre prospective cohorts spanning additional cancer types and surgical modalities, with a formal assessment against the full QoR-15. It will explore sequence models that operate on raw daily trajectories and integrate survey responses with continuous wearable-derived signals within a broader multimodal remote-monitoring framework [^8]. A prospective engagement study is needed to determine whether the two-thirds reduction in daily items translates into measurably higher compliance; the parity reported here removes the predictive objection to asking that question. In summary, a five-item subset of the QoR-15 can match the full instrument’s near-term predictive performance, providing a practical basis for lighter daily inputs in AI-RPM.

### Disclosures
Pramit Khetrapal, Ronnie Stafford, and John Kelly are co-founders and/or directors of Ethera Health Ltd, UK, which developed the remote patient monitoring platform used in this work. All study design, data collection, analysis, and interpretation were conducted independently of company management.

### Supplementary Material
Figure S1: Lower-triangle Spearman correlation matrix of the 15 QoR-15 items in the HALO-Surgery cohort. Pairwise rank correlations ρ \\rho were computed across all patient-day observations. Strong positive correlations (dark red) between items such as Q9–Q10, Q3–Q4, Q14–Q15, and Q11–Q12 reflect the redundancy that the dendrogram in Figure 3 summarises as tight clusters.
[^1]: Shaik T, Tao X, Higgins N, et al. Remote patient monitoring using artificial intelligence: Current state, applications, and challenges. *WIREs Data Mining and Knowledge Discovery*. 2023;13(2):e1485. doi:[)
[^2]: Churruca K, Pomare C, Ellis LA, et al. Patient-reported outcome measures (PROMs): A review of generic and condition-specific measures and a discussion of trends and issues. *Health Expectations*. 2021;24(4):1015–1024. doi:[)


## Key insights
- The baseline 15-item model is shown as a separate reference bar.
- These are also the items the backtests show to be most reactive at points of acute deterioration, consistent with their role in an early-warning context.
- The two are complementary: the full form could anchor periodic clinical assessment, while the short form serves as the daily model input, reducing the response burden that drives the non-compliance observed in our own deployment [^9].
- Multimodal strategies to improve surgical outcome.

## Exemplos e evidências
See original source at `Clippings/AI-driven Optimisation of Quality of Recovery (QoR) in Remote Patient MonitoringAccepted as a poster at AI in Medicine 2026 (Polish Institute for Evidence Based Medicine), a non-archival venue; the accepted abstract is available online 13. This.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/benchmark]]
- [[03-RESOURCES/concepts/llm-ml-foundations/lora]]
- [[03-RESOURCES/entities/AWS]]
- [[03-RESOURCES/entities/Python]]
