---
title: "Ensuring Open Source Integrity: The Intersection of Copy-Based Reuse and License Compliance Replication package available at: https://zenodo.org/records/14061115"
type: source
source: "Clippings/Ensuring Open Source Integrity The Intersection of Copy-Based Reuse and License Compliance Replication package available at httpszenodo.orgrecords14061115.md"
created: 2026-06-23
ingested: 2026-06-23
score: B
tags: [concurso, source-page]
---

## Tese central
As other creative work, source code is protected by copyright. The owner can license the work, e.g., to permit copy and other kinds of use, and even start legal proceeding against license violators. However, source code can be reused in subtle ways, e.g., via copying without explicit package manager dependencies, making it hard to reason about potential license noncompliance.

## Argumentos principais
### Ensuring Open Source Integrity: The Intersection of Copy-Based Reuse and License Compliance ††thanks: Replication package available at:
1 <sup>st</sup> Mahmoud Jahanshahi    2 <sup>nd</sup> Bogdan Vasilescu    3 <sup>rd</sup> Audris Mockus
###### Abstract
As other creative work, source code is protected by copyright. The owner can license the work, e.g., to permit copy and other kinds of use, and even start legal proceeding against license violators. However, source code can be reused in subtle ways, e.g., via copying without explicit package manager dependencies, making it hard to reason about potential license noncompliance. Using the World of Code infrastructure approximating the entirely of open source software, in this paper we create a copy-based code reuse network mapping direct copying across projects, and use it to quantify the extent of potential license noncompliance across the entire open source ecosystem. In addition, we estimate regression models to understand whether code copying is affected by the origin project’s license, and, if so, how it varies with other project characteristics.

### I Introduction
Open Source Software (OSS) plays a critical role in software development and distribution across various industries. A fundamental aspect of OSS is its licensing, which dictates how software can be reused, modified, and redistributed.
However, not all OSS participants are aware of or follow the ramifications of licensing [^3]. For example, their code is under exclusive copyright by default if no license is specified. The lack of knowledge, and/or, possibly, the lack of enforcement, results in reuse of unlicensed code in contexts where license incompatibilities are likely. For example, with the rise of large language models (LLMs), a significant portion of the massive source code used for training consists of code without any license [^56] [^54] [^18].
OSS licenses are typically categorized into permissive licenses (e.g., MIT, Apache), copyleft licenses (e.g., GPL), weak copyleft licenses (e.g., LGPL), public domain licenses, and others with specific conditions (e.g., Creative Commons). Each type of license imposes distinct obligations on developers and users, making the choice of license a pivotal factor in determining the extent and manner in which a project’s code can be reused. Moreover, creative works, such as code, are protected by copyright by default if no license is specified. Despite these legal restrictions, code without a license is often copied in practice [^49] and even used to train Large Language Models [^54].

### II-A Software Reuse
In open source software, the reuse within supply chains can be categorized based on how open source components are integrated and used in software projects [^31] [^32] [^33].
#### II-A1 Dependency-Based Reuse
This category involves incorporating open source libraries and packages as dependencies in a project. Package managers like NPM for JavaScript, pip for Python, or Maven for Java are typically used to manage these dependencies. If not properly overseen, reliance on these dependencies can introduce vulnerabilities and risks [^55].

### II-B Open Source Licenses
There are many licenses for open source code, each with its own requirements and restrictions.
Permissive licenses, such as MIT and Apache-2.0, typically allow for extensive reuse with few restrictions. They usually require only attribution and permit integration with other license types, offering significant flexibility [^24]. In contrast, copyleft licenses, such as the GPL, require that any derivative work be distributed under the same license. Noncompliance can occur if copyleft-licensed code is combined with code under a non-copyleft license without adhering to the copyleft terms. For example, incorporating GPL-licensed code into proprietary software without releasing the combined code under the GPL would violate the license [^43]. This principle ensures that all modifications and derivative works remain free, preserving software freedom [^25]. Weak copyleft licenses, such as the LGPL, are less restrictive than full copyleft licenses. They permit linking with proprietary software without requiring the entire work to be open sourced, as long as the LGPL-covered components remain modifiable and separable. However, it’s important to carefully consider the terms to avoid violations, particularly regarding modification and distribution [^40]. Conditional open licenses, including many Creative Commons licenses, offer specific conditions for use. For example, CC-BY licenses require attribution, while CC-BY-SA licenses require derivative works to be licensed under the same terms. These licenses can include share-alike clauses, which impact how code can be distributed, especially if combined with other licenses with different terms. While these licenses are more commonly used for creative works than software, they can still impact code distribution. Public domain and license-free software code generally impose no restrictions on reuse, as they are not protected by copyright. Works in the public domain can be freely used, modified, and distributed. Finally, projects with no explicit license (not to be confused with license-free) present significant legal risks. By default, all rights are reserved under copyright law, meaning that reuse, modification, or distribution may be restricted without the author’s explicit permission [^47]. This lack of clarity can lead to potential legal issues, as the permissions for using the software are not clearly defined.

### II-C Open Source License Compliance
License compatibility is a critical concern in OSS development. Projects often encounter significant difficulties when integrating components with conflicting licenses [^9]. Ensuring compliance with open source licenses is also a major concern for companies incorporating OSS into their products. [^16] emphasized the need for auditing OSS distributions to ensure adherence to license terms, especially in scenarios where components with varying licenses are integrated. [^51] conducted a large-scale empirical analysis on the usage of open source licenses, highlighting the practices and challenges developers face. Their findings revealed frequent misunderstandings and misapplications of licenses, especially in large-scale projects. [^8] created a tool called DIKE to detect license conflicts in over 16,000 popular free and OSS software, finding that over 25% had conflicts. In addition, their study suggests that these conflicts often arise from misinterpretations of license terms and the challenges of handling multi-license environments. Finally, [^28] conducted an empirical study on license violations resulting from code reuse across 1,423 projects, uncovering numerous instances of license incompatibilities.
In addition, many developers involved in OSS projects do not fully understand the implications of the licenses they use. [^2] [^3] revealed gaps in developers’ knowledge of licensing issues, which can result in non-compliance, particularly in complex projects that integrate multiple OSS components. Moraes et al. [^35] and Qiu et al. [^38] focused on the JavaScript ecosystem, investigating the effects of multi-licensing and license violations related to dependencies. Their findings show that the complex network of dependencies in JavaScript projects frequently results in unintentional license violations, highlighting the need for improved dependency management practices. Feng et al. [^12] investigated license violations in large-scale binary software, revealing that many projects unintentionally breach license terms due to the complexities involved in binary distribution. Finally, [^36] examined licensing questions on Stack Exchange sites, their results showing that many developers find it challenging to grasp licensing terms, leading to frequent inquiries about compliance and compatibility issues.
Studies have also demonstrated that a project’s declared license is not always reliable [^16] [^39] [^50]. For example, in a study of OSS projects on GitHub, [^50]

### II-D Our Study vs Prior Work
Our work offers a comprehensive and practical approach to identifying and addressing potential licensing issues arising from copy-based reuse in open source software, and it distinguishes itself from prior research in several ways:
#### II-D1 Comprehensive Identification of Licenses
Most studies, including those by Wu et al. [^51] and Xu et al. [^53], rely heavily on explicit license declarations in metadata files. Others, like Feng et al. [^12], use static analysis of binaries to detect embedded license texts. However, these approaches can miss licenses that are not explicitly declared or are located in less conventional directories. In contrast, our work analyzes a comprehensive dataset [^19] created by exhaustively scanning the entire OSS landscape (as reflected in the World of Code [^26]) for files containing the word “license” in their filepath. This includes not only standard license files but also any file that may contain licensing information, ensuring no (obvious) potential license data is overlooked.

### III-A World of Code Infrastructure
World of Code (WoC) <sup>1</sup> [^26] is an infrastructure developed to cross-reference source code change data across the entire OSS community, enabling sampling, measurement, and analysis both within and across software ecosystems [^26] [^27]. Essentially, WoC functions as a software analysis pipeline, handling data discovery and retrieval, storage and updates, as well as the transformations and augmentations required for subsequent analytical tasks [^27].
WoC provides various maps that link git objects and metadata (e.g., commits, blobs, authors) to each other. It also offers more advanced maps, such as project-to-data connections (e.g., project-to-author), author aliasing [^14], and project deforking maps [^29]. In our study, we use WoC’s project-to-license (P2L) map [^19], which shows the licenses committed to each project in its most recent state (Version V of WoC, updated in March 2024). <sup>2</sup> Additionally, we apply the concept of deforked projects, as introduced by [^29], to minimize potential biases caused by forks and duplicates of the same project. Throughout this paper, the term “project” refers to these deforked projects unless stated otherwise.

### III-B Copy-based Reuse Network
In the context of OSS development, analyzing code reuse is essential for understanding the propagation of software components and the associated licensing implications. Traditionally, the literature has primarily focused on dependency-based reuse, where the relationships between projects are analyzed based on declared package-manager dependencies, such as libraries or frameworks included in a project. While dependency-based analysis provides valuable insights into how projects rely on external components, it often overlooks the more granular aspect of direct code copying, which can occur independently of formal dependencies. Such practices are common in OSS projects but often remain undetected in dependency-based analyses, as shown by [^20]. By mapping these direct copies, a copy-based reuse network provides a comprehensive view of code propagation, highlighting the actual flow of code between projects.
In the realm of license compliance, dependency-based analysis often focuses on the licenses of declared dependencies. However, license obligations are not limited to these formal dependencies. Copy-based reuse, particularly when undetected, can lead to unintentional license violations. By mapping direct code copying, a copy-based reuse network allows for the identification of potential licensing conflicts that may arise from incorporating code with incompatible license terms, when the code wasn’t part of a declared dependency.
To track this kind of reuse, WoC offers the Ptb2Pt map, which lists reused blobs (i.e., file versions) along with the creator, reuser, and the time each project first committed that blob [^17]. This map is created by sorting the timestamps of all commits creating a blob, with the project associated with the earliest commit identified as the creator. Projects with any subsequent commits are then identified as reusers of that blob.

### III-C Potential License Noncompliance
Noncompliance can manifest in various ways, often resulting in substantial legal and operational risks. For example, it can occur when there are conflicts or misunderstandings regarding the terms and conditions of these licenses. To better understand the associated risks, we categorize the outcomes of license combinations into three levels: No Issues, Potential Issue - Low Risk, and Potential Issue - High Risk.
##### No Issues
This category covers situations where combining different licenses does not create legal or practical issues. Projects under these licenses can be freely integrated, modified, and redistributed without concern for restrictive terms. For instance, public domain and permissive licenses, such as the MIT or Apache 2.0 licenses, generally impose minimal restrictions. These licenses are designed to encourage widespread use and modification, making them highly compatible with other licenses. Their permissive nature ensures that they do not impose additional restrictions on combined works, allowing for seamless integration with other projects [^24] [^40].

### III-D Copy-based vs. Dependency-based Reuse
To test our hypothesis H2b, we compare the reuse instances captured via copy-based network with dependency-based network. For this analysis, we focus on high-risk categories in low-sensitivity mode with 10 or more reused blobs—our least conservative scenario—to quantify how often noncompliance is detectable through conventional methods (package manager analysis) versus cases that require copy-based detection. To keep the analysis tractable we selected a sample of 50,000 unique upstream-downstream project pairs from our dataset. Using a stratified sampling, we proportionally selected from each of the 16 high-risk categories, which together represent a total of 82 million projects. To ensure adequate representation of smaller categories, a minimum sample size of 1,000 was enforced, even when the proportional size was smaller. This approach ensures sufficient representation from smaller categories while maintaining overall proportionality. Our final sample included a total of 57,341 project combinations.
Next, we used the maps provided in WoC, which detail all import and export statements in every blob for each commit. By analyzing these maps, we identified all import/export statements within the projects in our sample <sup>3</sup>. We then matched these statements between upstream and downstream projects to determine if they share any declared dependencies (i.e., the downstream project imports a package that the upstream project exports).

### III-E Regression Model
In RQ1, we investigate whether the upstream project’s license type affects the likelihood of its artifacts getting reused, testing hypotheses H1a and H1b. Since the response variable is binary (1 if the project has introduced at least one reused blob, 0 otherwise), a logistic regression model is used. It is the standard approach for binary outcomes and enables us to estimate the probability of reuse from various predictors [^1].
#### III-E1 Stratified Sampling
Given the scale and diversity of OSS projects, we employed a stratified sampling approach to ensure that our regression model accurately represents the OSS landscape [^44]. Projects were divided into strata based on six key variables: number of commits, blobs, authors, forks, active months, and earliest commit time. These variables reflect project size, activity, and history, all of which are likely to influence our outcome variables, as discussed in Sec. II above. The strata were defined as follows: number of commits (fewer than 500, 500–2000, and more than 2000), number of blobs (fewer than 10,000 and more than 10,000), number of authors (one author, 2–10 authors, and more than 10 authors), number of forks (no forks and at least one fork), and active months (fewer than three months and more than three months). Additionally, we categorized projects into four historical eras based on their earliest commit time: the Foundational Era (before 1998), the Dot-com Boom and OSS Expansion (1998–2010), the Maturation and Mainstream Adoption phase (2010–2018), and the Modern Era with a Community Focus (2019–present). This stratification resulted in 288 unique bins. We sampled projects from each bin, yielding a final dataset of approximately half a million projects. While some bins contained fewer projects than anticipated due to uneven distribution, this approach ensures that our sample is representative of the broader OSS ecosystem, allowing for robust and generalizable conclusions from our analyses.

### IV-A RQ1 - Regression Model
#### IV-A1 Our Findings
To establish a baseline, we first modeled the probability of reuse based solely on the project’s license type, without considering other potential factors. This initial model showed a significant relationship between license type and reuse likelihood. Specifically, projects with permissive, copyleft, or weak copyleft licenses were more likely to have their artifacts reused, while those with public domain licenses were less likely to be reused.
To assess the impact of the variables with significant coefficients, we examine the odds ratios derived from the logistic regression coefficients. An odds ratio greater than 1 signifies a positive impact, whereas an odds ratio less than 1 indicates a negative impact. Figure 1 presents the odds ratios along with their corresponding 95% confidence intervals.

### IV-B RQ2 - Noncompliance
#### IV-B1 Our Findings
As discussed above, we report only the results of our low-sensitivity aggregation here (i.e., considering the lowest-risk pairs of licenses for a given upstream–downstream pair of projects). Figures 4 and 6 summarize our findings for the two flavors of reuse we consider (complete reuse, with at least one shared blob, and substantial reuse, with 10 or more blobs).
##### At least 1 Reused blob

### V-A Internal Validity
#### V-A1 Project to License Map
The project to license map (P2L) in WoC relies on detecting license files in repositories, assuming licenses are always recorded in dedicated files. Nevertheless, licenses might appear in README or source files, leading to underreporting or misclassification. This suggests that results should be interpreted cautiously, and additional manual verification may be needed for a more accurate understanding of license noncompliance.
#### V-A2 License Scope

### V-B External Validity
#### V-B1 Copy-Based Reuse
While emphasizing copy-based reuse offers valuable insights into license compliance, we recognize the significant role of dependency-based reuse within the broader reuse network. Focusing solely on copy-based reuse may overlook certain aspects of how dependencies are integrated into a project. Conversely, dependency-based reuse can miss critical instances where code is directly copied between projects, which is equally crucial in identifying potential noncompliance. Thus, while this work prioritizes copy-based reuse, it serves to complement—rather than replace—the understanding gained from analyzing dependency-based reuse, together providing a more comprehensive view of compliance.


## Key insights
- RQ1: How does the license type of the upstream project affect the probability of its artifacts getting copied?
- RQ2: How widespread is potential license noncompliance in copy-based reuse network?
- Hypothesis (H1a): Projects using permissive licenses, when controlling for other context factors, have a higher likelihood of their artifacts being reused via copying.
- Hypothesis (H1b): Projects using restrictive licenses, when controlling for other context factors, have a lower likelihood of their artifacts being reused via copying.
- Hypothesis (H2a): Copy-based reuse carries a high risk of license noncompliance due to compounded complexities in tracking artifact origins.
- Hypothesis (H2b): By overlooking copy-based code reuse, we are missing a significant portion of license noncompliance issues in open source software.
- $L_{A_{i}}$: Each license of Project A,
- $L_{B_{j}}$: Each license of Project B,
- $\text{risk}(L_{A_{i}},L_{B_{j}})$: Incompatibility risk level between license $L_{A_{i}}$ and license $L_{B_{j}}$.

## Exemplos e evidências
See original source at `Clippings/Ensuring Open Source Integrity The Intersection of Copy-Based Reuse and License Compliance Replication package available at httpszenodo.orgrecords14061115.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/ai-agents/prompt]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/AWS]]
- [[03-RESOURCES/entities/Uber]]
- [[03-RESOURCES/entities/Rust]]
- [[03-RESOURCES/entities/Python]]
