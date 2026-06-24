---
title: "Source-Free Detection and Impact Analysis of Compiler Optimization Problems in Mobile Applications"
type: source
source: "Clippings/Source-Free Detection and Impact Analysis of Compiler Optimization Problems in Mobile Applications.md"
created: 2026-06-23
ingested: 2026-06-23
score: C
tags: [concurso, source-page]
---

## Tese central
---
title: "Source-Free Detection and Impact Analysis of Compiler Optimization Problems in Mobile Applications"
source: "
author:
published:
created: 2026-06-23
description:
tags:
  - "clippings"
---
Han Hu Independent ResearcherChina [agmaiofhuhan@gmail.com](), Xiaoheng Xie Independent ResearcherChina [xiexiemyself@gmail.com](), Bo Sun Independent ResearcherChina [361606685@qq.com](), Jian Gu Monash UniversityAustralia [jian.gu@monash.edu](), Gang Fan Independent ResearcherChina [fan.gang.cn@gm

## Argumentos principais
### 1\. Introduction
Mobile applications (apps) have become ubiquitous computing platforms, with over 7.2 billion devices worldwide [^43] executing performance-critical native code. Performance degradation in mobile apps, including frame drops, excessive energy consumption, and thermal throttling, directly impacts user experience: nearly 90% of users abandon apps due to poor performance [^1], and over 50% of apps are uninstalled within 30 days, with performance being a leading cause [^4]. While such issues are commonly attributed to inefficient code or hardware constraints, our analysis of real-world cases reveals a previously neglected factor: inappropriate compiler optimization levels applied to native libraries (.so files).
We first encountered this issue while debugging performance issues in a popular mobile game (referred to as Game A, with over one million active users). Game A comprises 106 native libraries (.so files). User feedback consistently reported that the HarmonyOS [^18] version exhibited poorer performance than the Android version, including noticeable lag and decreased responsiveness. Together with the Game A development team, we confirmed that both versions shared the same app logic and native code.
We conducted runtime profiling to investigate this discrepancy and found that the HarmonyOS version executed approximately 60 percent more CPU instructions than its Android counterpart in certain functionalities. Further analysis revealed that the primary difference came from compiler optimization settings: some native libraries in the HarmonyOS version were compiled with lower optimization levels (O0 and O1), whereas the Android version used higher levels (O2 and O3). Figure 1 illustrates how such optimization differences can arise both across app versions and across platform builds, propagating through the build pipeline to affect runtime performance.

### 2\. Background
Mobile apps rely on native libraries (.so files) for performance-critical functionality. These libraries are compiled by GCC [^12] or Clang [^39] at different optimization levels that control how aggressively the compiler transforms source code [^31]. O0 disables optimization entirely for easier debugging. O1 applies basic optimizations such as constant folding and dead code elimination. O2 enables more aggressive optimizations including loop unrolling and improved register allocation. O3 adds further techniques such as aggressive inlining and vectorization. Os optimizes for binary size rather than speed. Among these, O0 and O1 are generally considered low optimization levels, while O2 and O3 are considered high optimization levels [^31].
The optimization level choice has a direct impact on app performance. Code compiled at O0 can require substantially more CPU instructions than the same code at O3 [^31]. However, optimization settings are easily overlooked in practice. Standard profiling tools (Systrace [^14], Perfetto [^13], DevEco Profiler [^19]) can identify CPU hotspots and memory leaks, but cannot determine whether poor performance stems from algorithmic inefficiency or inappropriate compilation settings. This gap is especially problematic for precompiled third-party libraries, where developers lack access to source code or build configurations to verify optimization levels.

### 3.1. Framework Design
Since native libraries typically contain code compiled with mixed optimization levels, accurate library-level assessment requires decomposing the analysis into (1) fine-grained chunk-level classification and (2) weighted aggregation. We realize this in OptDetect through a six-stage pipeline shown in Figure 2.
Figure 2. Overview of the OptDetect detection framework. The six-stage pipeline consists of native library extraction, binary disassembly, instruction chunking and feature extraction, deep learning-based classification, prediction aggregation, and optimization level assignment.
Native Library Extraction. We unpack application packages and extract embedded native libraries (.so files) for analysis. We apply filtering criteria to exclude unsuitable binaries such as stubs, encrypted content, and heavily obfuscated binaries.

### 3.2. Validation Setup
We train and validate our framework using two publicly available datasets. The Optimization-Detector dataset [^38] contains approximately 17,000.so files compiled with five optimization levels (O0, O1, O2, O3, Os) across seven architectures using GCC and Clang. The Assemblage dataset [^26] contains real-world libraries compiled from GitHub repositories with known compiler flags, and each binary is distributed with its ground-truth optimization level label (O0, O1, O2, O3). Because Assemblage sources code from diverse real projects with varying coding styles, build systems, and complexity, it serves as a more challenging validation benchmark than synthetically compiled datasets. To prevent data leakage, we perform the 80/20 train/test split at the project level: all.so files derived from the same source project are assigned exclusively to either the training or test set, ensuring that the model cannot memorize project-specific code patterns.
The dataset spans 7 architectures (x86\_64, AArch64, RISC-V, PowerPC, SPARC, MIPS, ARM32). Among them, x86\_64 and AArch64 constitute the two largest subsets (4,071 and 3,399 samples respectively), consistent with their prevalence in mobile platforms. We use 80% for training and 20% (approximately 3,000 samples) for testing.

### 3.3. Implementation
We implement OptDetect using Python with LIEF [^40] for binary parsing and.text section extraction, Capstone [^41] for disassembly, and PyTorch [^35] for the deep learning classifier. The classifier uses a bidirectional LSTM architecture that takes raw byte sequences as input and predicts chunk-level optimization levels. For the experiments reported in this paper, we set $W=2048$ bytes and $S=2048$ bytes (non-overlapping windows). On AArch64, each 2048-byte window corresponds to 512 instructions, providing sufficient context for the model to capture local optimization patterns. Libraries with fewer than 5 valid chunks are excluded from analysis.
We train a single unified model across all seven ISAs, as optimization-level signatures are largely architecture-agnostic despite differences in specific opcodes. The training set contains 17,062 libraries across 7 ISAs, with AArch64 and ARM32 as the two largest subsets. We train using cross-entropy loss with Adam optimizer (learning rate = 0.001, batch size = 32) for 100 epochs with early stopping. We use standard classification metrics: accuracy, precision, recall, F1-score, and false positive rate.
The aggregation weights are $w_{\text{O0}}=0.0$, $w_{\text{O1}}=0.25$, $w_{\text{O2}}=0.75$, $w_{\text{O3}}=1.0$, and $w_{\text{Os}}=0.5$. Os is assigned 0.5 because it optimizes for binary size rather than speed, and empirical validation shows its runtime performance falls between O1 and O2. All weight values were determined through iterative empirical analysis on our validation set. For optimization level assignment, the dominance threshold is 90%, and the score boundaries for the four transition zones are 0.15, 0.35, and 0.65, corresponding to Near-O0 mixed $[0,0.15)$, O0/O1 mixed $[0.15,0.35)$, O1/O2 mixed $[0.35,0.65)$, and O2/O3 mixed $[0.65,1.0)$. These thresholds are calibrated to maximize separation between low-optimization (O0/O1) and high-optimization (O2/O3) libraries. The prevalence thresholds used in RQ2 and RQ3 are derived from these transition zones.

### 3.4. Validation Results
We evaluate our framework on both the Optimization-Detector dataset (artificially compiled data) and the Assemblage dataset (real-world data). Table 1 presents the comparative results.
Table 1. Performance evaluation of optimization level classification. Assemblage (Binary: Low vs High) represents binary classification accuracy for distinguishing Low-Optimization Libraries (O0/O1) from High-Optimization Libraries (O2/O3) on the Assemblage dataset.
<table><tbody><tr><td>Dataset</td><td>Level</td><td>Prec.</td><td>Rec.</td><td>Acc.</td><td>F1</td></tr><tr><td rowspan="5">Opt-Detector</td><td>O0</td><td>95.8%</td><td>94.2%</td><td>95.1%</td><td>95.0%</td></tr><tr><td>O1</td><td>89.2%</td><td>87.6%</td><td>88.8%</td><td>88.4%</td></tr><tr><td>O2</td><td>93.1%</td><td>92.8%</td><td>92.9%</td><td>93.0%</td></tr><tr><td>O3</td><td>94.6%</td><td>93.8%</td><td>94.3%</td><td>94.2%</td></tr><tr><td>Os</td><td>92.5%</td><td>91.7%</td><td>92.4%</td><td>92.1%</td></tr><tr><td rowspan="4">Assemblage</td><td>O0</td><td>85.3%</td><td>83.7%</td><td>84.9%</td><td>84.5%</td></tr><tr><td>O1</td><td>76.8%</td><td>74.4%</td><td>76.1%</td><td>75.6%</td></tr><tr><td>O2</td><td>82.1%</td><td>81.5%</td><td>81.7%</td><td>81.8%</td></tr><tr><td>O3</td><td>83.9%</td><td>82.6%</td><td>83.5%</td><td>83.2%</td></tr><tr><td colspan="2">Opt-Detector (Macro)</td><td>93.0%</td><td>92.0%</td><td>92.7%</td><td>92.5%</td></tr><tr><td colspan="2">Opt-Detector (Weighted)</td><td>93.2%</td><td>92.9%</td><td>93.0%</td><td>93.1%</td></tr><tr><td colspan="2">Assemblage (Macro)</td><td>82.0%</td><td>80.6%</td><td>81.6%</td><td>81.3%</td></tr><tr><td colspan="2">Assemblage (Weighted)</td><td>82.5%</td><td>81.1%</td><td>81.9%</td><td>81.8%</td></tr><tr><td colspan="2">Assemblage (Binary: Low vs High)</td><td>91.0%</td><td>90.5%</td><td>90.8%</td><td>90.7%</td></tr></tbody></table>

### 4\. RQ2: Prevalence of Low Optimization in Real World Apps
To investigate how widespread low compiler optimization practices are in modern mobile software, we conduct a large-scale empirical study on real-world top-ranked mobile apps. This investigation consists of data collection, prevalence analysis, analysis of reused libraries, and case study analysis.

### 4.1. Data Collection and Methodology
We collected 830 available top-ranked apps from Google Play Store (July 2025) across six categories: grossing apps, free apps, grossing games, free games, grossing wearable apps, and free wearable apps. We extracted and analyzed 21,972 native libraries from these apps. During extraction, we applied filtering criteria to exclude libraries unsuitable for optimization analysis: stub libraries (containing only symbol redirects with no executable code), encrypted or packed binaries (where the.text section is obfuscated), and heavily obfuscated binaries where Capstone failed to disassemble more than 50% of the.text section. These exclusion criteria were applied uniformly across all app categories.

### 4.2. Prevalence Analysis
Table 2 presents the distribution of optimization levels across our dataset. For all prevalence analyses in this paper (RQ2 and RQ3), we define two score-based categories derived directly from the transition zones established in Section 3.3: a library is low-optimization if its score falls below 0.50 (midpoint of the O1/O2 transition zone), and high-optimization if its score reaches 0.80 or above (upper O2/O3 zone). Our analysis reveals that low compiler optimizations are widespread in real-world mobile apps.
Table 2. Distribution of Optimization Levels Across Application Categories (Including Wearables)
| Category | .so | Avg. Opt. | Low Opt. | Low Opt. | High Opt. | High Opt. |

### 4.3. Analysis of Reused Libraries
Table 4 presents the most frequently reused native libraries that consistently exhibit low optimization scores (average score below 0.50), each appearing in at least 10 apps.
Table 4. Most Common Low-Optimization Native Libraries
| Library | Occs. | Avg. Opt. | Low Opt. | Example |

### 5\. RQ3: Multi-dimensional Impacts of Optimization Fixes
To understand the real-world impacts of addressing compiler optimization problems, we investigate RQ3: What are the multi-dimensional impacts of fixing optimization problems in production apps? This research question examines three dimensions: (1) technical performance improvements, (2) user-perceived quality improvements, and (3) the underlying sources of optimization problems. We conduct an in-depth analysis of 12 production apps: 6 top-ranked commercial apps and 6 open-source apps published on Google Play Store.

### 5.1. Research Design and Methodology
Case Selection. We select 12 production apps: 6 top-ranked commercial apps and 6 open-source apps. Selection criteria include app popularity (millions of active users), presence of native libraries with identified optimization issues, and feasibility of collaboration. Commercial apps include Payment App A (payment platform), Video App B (video streaming), Social App C (social media), Card Game X (strategy game), FPS Game B (first-person shooter), and MOBA Game C (multiplayer battle arena), anonymized per confidentiality agreements. Open-source apps additionally require accessible source code and complete build systems: VLC, Kodi, Firefox, Termux, Signal, and Telegram.
Table 5. Case Study Apps: Commercial and Open-Source
<table><tbody><tr><td colspan="2">Commercial Apps (Case Set 1)</td><td colspan="2">Open-Source Apps (Case Set 2)</td></tr><tr><td>App</td><td>Description</td><td>App</td><td>Description</td></tr><tr><td>Payment App A</td><td>Leading mobile payment platform with QR code scanning</td><td>VLC</td><td>Multimedia player with FFmpeg codecs (2.5K+ stars, 100M+ downloads)</td></tr><tr><td>Video App B</td><td>Video streaming and content creation platform</td><td>Kodi</td><td>Media center with native rendering (16K+ stars, 50M+ downloads)</td></tr><tr><td>Social App C</td><td>Social media and content sharing app</td><td>Firefox</td><td>Web browser with Gecko engine (1.2K+ stars, 500M+ downloads)</td></tr><tr><td>Card Game X</td><td>Strategy card game with complex rendering</td><td>Termux</td><td>Terminal emulator with native execution (25K+ stars, 10M+ downloads)</td></tr><tr><td>FPS Game B</td><td>First-person shooter with intensive graphics</td><td>Signal</td><td>Encrypted messaging with crypto libraries (42K+ stars, 100M+ downloads)</td></tr><tr><td>MOBA Game C</td><td>Multiplayer battle arena using Unity3D</td><td>Telegram</td><td>Messaging app with native libraries (25K+ stars, 1B+ downloads)</td></tr></tbody></table>

### 5.2. RQ3.1: Technical Performance Improvements
Methodology. For each commercial app we: (1) identify low-optimization libraries using OptDetect, (2) recompile affected libraries at O2 for general code and O3 for computationally intensive components, (3) measure retired CPU instructions via hardware Performance Monitoring Units (PMU) on a flagship Android device (Snapdragon 8 Gen 3, Android 14) using Android Studio Profiler with kernel-level PMU access for precise non-sampled counting, and (4) validate correctness with partner test suites (unit, integration, functional), with specific checks for floating-point stability, timing-sensitive code, and constant-time crypto. Both original and optimized builds are measured on the same device under identical workloads, so hardware variation cancels in the relative reduction. We report means over 5–10 runs per configuration (standard deviation, SD $<$ 1.5% across all metrics).
Metric Justification. We use CPU retired instruction count as the primary performance indicator because it directly quantifies computational work and correlates strongly with execution time and energy consumption [^16] [^32]. Retired instructions are those that complete execution and produce committed results, excluding speculative or flushed instructions, making the count a stable and reproducible measure of actual work performed. As described above, all measurements are conducted on the same device under identical workloads, so the percentage reduction reflects only the optimization-level change. This approach is widely used in compiler optimization research [^31] [^5]. CPU instruction reduction is therefore our primary cross-app comparable metric. Supplementary user-facing metrics (startup latency, frame rate, binary size, etc.) are reported as secondary evidence where partner confidentiality agreements and data access permit, and consequently vary across apps.
Results. Table 6 summarizes results for all six commercial apps. CPU instruction reductions range from 10% to 63% (median: 20.5%). The variation reflects two factors: the number of libraries successfully optimized and their execution frequency, as libraries on the critical path yield the largest gains. Payment App A contained 98 unoptimized libraries, of which 6 were successfully optimized under collaboration constraints, while other apps had more focused interventions (1–10 libraries). Payment App A achieves 22% reduction. Card Game X achieves 63% reduction with 40% power consumption reduction and 15 FPS gain. Video App B achieves 25% reduction with 15% streaming latency reduction and 30% frame-drop reduction. Social App C achieves 19% reduction across 8 of 17 libraries with improvements in feed scrolling and image loading. FPS Game B achieves 10% reduction with thermal throttling mitigation. MOBA Game C achieves 13% reduction alongside 65% binary size reduction (37MB $\to$ 13MB) and 35% load-time reduction.

### 5.3. RQ3.2: User-Perceived Quality Improvements
We analyze app store reviews to test whether technical improvements translate to user-perceived quality changes. We collect 13,156 reviews from multiple app stores across all of 2025 for the 6 commercial apps. Reviews are filtered to the five most frequent languages (English, Simplified Chinese, Traditional Chinese, Korean, Japanese), covering over 92% of all reviews. Performance-related keywords cover four categories with equivalent terms in all five languages: performance symptoms (e.g., “lag”, “freeze”), resource complaints (e.g., “battery drain”, “overheat”), loading issues (e.g., “slow startup”), and rendering issues (e.g., “frame drop”, “jank”).
We compare monthly keyword frequency and average rating for the optimization month vs. the following month. A one-tailed Wilcoxon signed-rank test across the six apps yields $p=0.031$ ($\alpha=0.05$), confirming statistically significant keyword reduction. Note that keyword reduction is associated with, but not solely caused by, the optimization fix, as concurrent app updates may also contribute. Potential confounds are discussed in Threats to Validity.
Results. Figure 3 and Table 7 show the results. Performance-related keyword frequency decreases in 5 of 6 apps (21%–76%, median: 42%) and ratings improve in 5 of 6 apps (+0.09 to +0.21 stars, median: +0.14).

### 5.4. Open-Source App Results and Root Cause Analysis
Unlike commercial apps where source code is inaccessible, open-source apps allow us to trace each low-optimization library to its origin through build script and source dependency analysis. For each of the six open-source apps, we examine whether low-optimization libraries are compiled from the project’s own source code or included as third-party pre-compiled binaries.
Across 314 native libraries in these six apps, we identify 25 low-optimization libraries (8.0%). Table 8 presents the per-app tracing results. The findings are clear: 24 out of 25 libraries (96.0%) originate from third-party pre-compiled binaries distributed by external vendors or upstream repositories. The single exception is Telegram’s libtmessages.49.so, which is traced to an app-level build configuration error. Kodi alone accounts for 15 low-optimization libraries, all from the PyCryptodome Python crypto extension shipped as pre-compiled.so modules. Using the same measurement protocol as RQ3.1, CPU instruction reductions after fixing these libraries range from 15% to 58% (median: 32%).
Table 8. Root Cause Tracing for Open-Source Apps (Case Set 2). Each low-optimization library is traced to its origin via build script and source dependency analysis.


## Key insights
- The first large-scale empirical study of compiler optimization levels in mobile apps, covering 21,972 native libraries from 830 top-ranked Google Play apps.
- The first multi-dimensional impact analysis of compiler optimization fixes, spanning technical performance (CPU instructions, binary size, power), user-perceived quality (app store ratings and feedback), and ecosystem-level root cause investigation.
- As a result, fragmented build pipelines, legacy code maintenance, unintentional misconfigurations, and poor communication can lead to mismatched optimization levels.
- Because Assemblage sources code from diverse real projects with varying coding styles, build systems, and complexity, it serves as a more challenging validation benchmark than synthetically compiled datasets.
- To prevent data leakage, we perform the 80/20 train/test split at the project level: all.so files derived from the same source project are assigned exclusively to either the training or test set, ensuring that the model cannot memorize project-specific code patterns.
- On AArch64, each 2048-byte window corresponds to 512 instructions, providing sufficient context for the model to capture local optimization patterns.
- We train a single unified model across all seven ISAs, as optimization-level signatures are largely architecture-agnostic despite differences in specific opcodes.
- The results demonstrate significant variation across application categories.
- Among regular apps, both grossing apps and free apps show similar optimization patterns, with 24.3% and 28.4% of.so files exhibiting low optimization scores and average optimization scores of 0.565 and 0.548, respectively.
- Mobile games demonstrate markedly worse optimization practices, with average optimization scores of 0.510–0.520 and 32.7%–36.5% of.so files classified as low-optimization.

## Exemplos e evidências
See original source at `Clippings/Source-Free Detection and Impact Analysis of Compiler Optimization Problems in Mobile Applications.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/ai-agents/benchmark]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/Rust]]
- [[03-RESOURCES/entities/Python]]
