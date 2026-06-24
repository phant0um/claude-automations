---
title: "MBRarefy: data-adaptive multi-bin rarefying for alpha diversity association analysis"
type: source
source: "Clippings/MBRarefy data-adaptive multi-bin rarefying for alpha diversity association analysis.md"
created: 2026-06-23
ingested: 2026-06-23
score: B
tags: [articles, source-page]
---

## Tese central
Summary: This paper presents MBRarefy, an R package that provides a reproducible workflow for alpha diversity analysis under confounding from heterogeneous library sizes. Building on the multi-bin rarefying approach in [^11], MBRarefy supports alpha diversity association analysis with repeated rarefying, bin-wise testing, and cross-bin meta-analysis. A key new feature is automated, data-adaptive selection of library size bin thresholds via a genetic algorithm (GA), which replaces ad hoc cutpoint

## Argumentos principais
### 1 Introduction
Alpha diversity is widely used to summarize within-sample richness and evenness in ecology, microbiome sequencing, T-cell/B-cell receptor repertoire sequencing, and other high-throughput count-profile studies. These summaries are often tested for association with clinical, host, or environmental covariates [^19] [^8] [^16]. However, estimated alpha diversity is sensitive to sampling effort: samples with more collected counts, reads, or sequences can appear more diverse even when underlying diversity is unchanged [^17]. In sequencing studies, per-sample total counts, often referred to as sequencing depth or library size, can vary substantially because of technical and experimental factors. As a result, alpha diversity association analyses may reflect residual depth-driven artifacts rather than biological signal, reducing interpretability and reproducibility [^19].
A wide range of library size normalization strategies has therefore been proposed. Scaling and compositional approaches are commonly discussed for relative abundance analyses [^5] [^18] [^14], while rarefying, subsampling without replacement to equal library size, remains widely used for alpha diversity estimation because it produces diversity summaries on a comparable sampling scale and aligns with classical ecological sampling theory [^7] [^19]. Rarefying normalizes uneven sampling effort but does not correct feature-specific amplification or sequencing biases, including sequence-composition or GC-content effects [^1] [^15].
In practice, alpha diversity association analyses often rely on rarefying all samples to a single global depth, which forces a trade-off between retaining low depth samples and preserving information in higher depth samples. The chosen depth is typically selected heuristically, and different choices can yield different conclusions. Moreover, even after rarefying, alpha diversity estimates can remain correlated with the samples’ original library sizes, with multiple studies reporting positive associations between total reads and alpha diversity computed from rarefied data, indicating that single-depth rarefying may not fully eliminate depth dependence [^10] [^19] [^3] [^11].

### 2 Methods
Consider $N$ quality-controlled samples with per-sample feature-count profiles $\mathbf{X}_{i}=(X_{i1},\ldots,X_{ip})$, $i=1,\ldots,N$, where $X_{ij}$ is the count assigned to feature $j=1,\ldots,p$. The corresponding library size is $L_{i}=\sum_{j=1}^{p}X_{ij}$. Let $A_{i}$ be an alpha diversity metric computed from the original or rarefied counts (e.g., observed richness, Shannon, Simpson). Each sample has associated metadata, including an outcome of interest $y_{i}$ and covariates $\mathbf{z}_{i}$. The goal is to assess associations between $A_{i}$ and $y_{i}$ while reducing confounding from heterogeneous library sizes.
Figure 1 summarizes the MBRarefy workflow. MBRarefy (A) ingests per-sample count profiles, aligned metadata, and a rarefying-depth grid, (B) computes grid-based rarefying alpha diversity profiles by rarefying each sample over a user-specified depth grid, (C) selects data-adaptive library size cutpoints on the grid via a GA-based optimization criterion and assigns samples to bins, and (D) performs multi-bin inference by extracting bin-anchored diversity, conducting within-bin association tests, and combining evidence via meta-analysis, and reporting residual library-size diagnostics.
Figure 1: Overview of the MBRarefy workflow (A–D). (A) Per-sample TCR, microbiome, or other count profiles are aligned with sample metadata and a rarefying-depth grid. (B) Repeated rarefying over candidate depths produces a sample-by-depth alpha-diversity matrix. (C) GA-based fixed- K or varying- cutpoint selection defines data-adaptive library-size bins. (D) Bin-anchored alpha diversity values are used for bin-wise association testing, cross-bin meta-analysis, and residual library-size diagnostics.

### 2.1 Inputs and preprocessing
MBRarefy is designed for file-based, per-sample count inputs to reduce cohort-level computational memory requirements. It processes one sample file at a time, although memory usage during rarefying still scales with the library size of the current sample. The main entry point for grid-based rarefying profiling is multibin.rarefy.diversity() in step (B), which takes InputDataDir, a directory containing one plain-text file per sample. Each file contains a required count column specified by CountVar (e.g., count) and, when applicable, a feature identifier column specified by SeqVar (e.g., seq). For sample $i$, MBRarefy reads the count profile $\mathbf{X}_{i}$ from disk and computes the library size $L_{i}=\sum_{j}X_{ij}$. Users specify the target rarefying depth grid and diversity metrics, the number of repeated rarefying replicates nRep, and optional parallel execution through parallel and nCore. The function returns replicate-resolved per-sample results, and sample metadata are aligned separately for downstream association testing.

### 2.2 Grid-based rarefying profiling
Given a user-specified rarefying depth grid $\{m_{1}<\cdots<m_{M}\}$, MBRarefy constructs grid-based rarefying profiles by rarefying each eligible sample $i$ to each candidate depth $m_{j}$ (only when $L_{i}\geq m_{j}$, $j=1,\ldots,M$) via subsampling without replacement and computing the requested alpha diversity metrics at that depth. When nRep $>1$, this procedure is repeated across replicates, producing the replicate-resolved output, a nested list indexed as x\[\[rep\]\]\[\[sample\]\]\[\[depth\]\]\[\[metric\]\].
For downstream data-adaptive binning (Step (C)) and multibin inference (Step (D)), get\_alpha\_metric\_matrix() summarizes the replicate-resolved object by averaging over replicates. For each metric, it returns a samples $\times$ depths data frame whose $(i,m)$ entry equals the mean alpha diversity estimate for sample $i$ at depth $m$ (with NA if a value is unavailable), yielding a per-sample rarefying profile over the depth grid.

### 2.3 GA for optimal bin cutpoints selection
Using the depth grid $\{m_{1}<\cdots<m_{M}\}$, MBRarefy precomputes an alpha-diversity matrix $\alpha_{i}(m_{j})$, where $\alpha_{i}(m_{j})$ is the diversity estimate for sample $i$ at depth $m_{j}$. Cutpoint selection then seeks ordered interior grid indices $2\leq\tau_{1}<\cdots<\tau_{K}\leq M-1$, shared across samples, that partition the library-size range into $K+1$ bins and minimize residual within-bin dependence between alpha diversity and library size.
Let $\tau_{0}=1$ and $\tau_{K+1}=M$. The bins are
$$

### 2.4 Multibin rarefying association analysis
Following Step (D) in Figure 1, selected cutpoints are used to assign samples to bins and extract bin-anchored alpha diversity. MBRarefy performs within-bin association testing with optional covariate adjustment and combines bin-specific estimates by meta-analysis using equal, sample-size, or inverse-variance weighting [^11]. As a residual diagnostic, users can test the association between bin-anchored alpha diversity and original library size; a non-significant result provides evidence of reduced detectable residual library-size dependence under the specified diagnostic model.

### 3 Case Studies
We evaluated MBRarefy in two applications: a TCR immune repertoire dataset with known CMV serostatus and a wild baboon gut microbiome dataset. In each application, observed richness was used as the representative alpha diversity metric, and overall rarefying at several depths was compared with varying- $K$ and fixed- $K$ multi-bin rarefying. The comparison focused on residual association with original library size, retained sample size, and preservation of biologically or ecologically relevant covariate associations. Results are summarized in Table 1; reported cutpoints and $P$ -values correspond to fixed-seed runs.
For the TCR application, we analyzed 663 eligible Cohort 1 profiles from the TCR immunosequencing dataset [^4], with known CMV serostatus. Richness was computed over a rarefying-depth grid from $10^{5}$ to $10^{7}$ reads with 10 repeated rarefaction replicates. Using overall rarefying, library-size association remained significant at $10^{5}$ and $10^{6}$ reads and became non-significant only at $1.8\times 10^{6}$ reads, where fewer samples were retained. In contrast, both varying- $K$ and fixed- $K$ multi-bin rarefying retained all 663 eligible samples, produced non-significant residual library-size diagnostics, and retained associations with age, sex, and CMV serostatus. For fixed- $K$ multi-bin rarefying, the selected interior cutpoints were $1.0\times 10^{6}$, $1.9\times 10^{6}$, $2.6\times 10^{6}$, $5.0\times 10^{6}$, and $7.1\times 10^{6}$ reads; for varying- $K$, they were $1.0\times 10^{6}$, $1.9\times 10^{6}$, $2.7\times 10^{6}$, and $3.8\times 10^{6}$ reads.
For the microbiome application, we analyzed the wild baboon gut microbiome dataset available through microbiomeDataSets [^9]. The full dataset contains 16,234 16S rRNA gut microbiome profiles from 585 wild baboons sampled over 14 years. To construct an independent subject-level example, we retained one profile per baboon by selecting the sample with the largest library size, yielding 585 independent samples. Overall rarefying showed a depth-dependent tradeoff: residual association between observed richness and original library size remained significant at 50k, 69k, and 82k reads, whereas the diagnostic became non-significant at 91k reads only after retaining 236 samples. Covariate associations also varied with rarefying depth; for example, sex was significant at lower depths but not at higher depths, while group size became significant only at the deepest depth. In contrast, both multi-bin rarefying modes retained all 585 samples and yielded non-significant residual library-size diagnostics. Age and group size remained associated with multi-bin-rarefied richness, while sex showed a weaker or borderline association. For fixed- $K$, the selected cutpoints were 40k, 54k, 61k, 99k, and 118k reads; for varying- $K$, they were 40k, 48k, 58k, 95k, and 113k reads.

### 4 Conclusion
MBRarefy provides a practical R workflow for alpha diversity association analysis that reduces residual library size confounding without erasing biologically meaningful phenotype associations. Building on the multi-bin rarefying framework of [^11], MBRarefy adds automated, data-adaptive library-size cutpoint selection and integrates repeated rarefying, bin-wise testing, cross-bin meta-analysis, and residual library-size diagnostics. In both applications, the overall rarefying produced depth-dependent diagnostics and sample retention, whereas the multi-bin rarefying workflow reduced detectable residual library-size dependence while retaining the full eligible sample set. Interpretable associations were retained, including CMV serostatus and sex in the TCR example and age and group size in the microbiome example. Users should report the rarefying grid, selected cutpoints, bin-size constraints, fixed random seeds, and post-MBRarefy library-size diagnostic.

### 5 Funding
This work is supported by the Louisiana Board of Regents Support Fund (BoRSF) Research Competitiveness Subprogram, LEQSF(2025-28)-RD-A-18.

### 6 Data availability
The TCR immune repertoire data are available from [^4]. The wild baboon gut microbiome data are available through the microbiomeDataSets package [^9]. The MBRarefy source code, package vignettes, example workflows, and reproducibility scripts are available at [).
[^1]: Summarizing and correcting the GC content bias in high-throughput sequencing. Nucleic acids research 40 (10), pp. e72–e72. Cited by: §1.
[^2]: Enhancing diversity analysis by repeatedly rarefying next generation sequencing data describing microbial communities. Scientific reports 11 (1), pp. 22302. Cited by: §1.


## Key insights
- As a result, alpha diversity association analyses may reflect residual depth-driven artifacts rather than biological signal, reducing interpretability and reproducibility [^19].
- As a residual diagnostic, users can test the association between bin-anchored alpha diversity and original library size; a non-significant result provides evidence of reduced detectable residual library-size dependence under the specified diagnostic model.
- Together, the two applications show MBRarefy reduces detectable residual library size dependence while retaining more samples and preserving interpretable biological or ecological signals.

## Exemplos e evidências
See original source at `Clippings/MBRarefy data-adaptive multi-bin rarefying for alpha diversity association analysis.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/memory]]
- [[03-RESOURCES/concepts/llm-ml-foundations/inference]]
- [[03-RESOURCES/concepts/software-engineering/proof]]
