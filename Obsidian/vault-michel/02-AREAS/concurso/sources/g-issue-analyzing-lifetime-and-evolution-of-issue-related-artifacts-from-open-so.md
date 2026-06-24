---
title: "G-Issue: Analyzing Lifetime and Evolution of Issue-related Artifacts from Open Source Repositories"
type: source
source: "Clippings/G-Issue Analyzing Lifetime and Evolution of Issue-related Artifacts from Open Source Repositories.md"
created: 2026-06-23
ingested: 2026-06-23
score: B
tags: [concurso, source-page]
---

## Tese central
---
title: "G-Issue: Analyzing Lifetime and Evolution of Issue-related Artifacts from Open Source Repositories"
source: "
author:
published:
created: 2026-06-23
description:
tags:
  - "clippings"
---
Sayed Mohsin Reza [0000-0003-3379-6319]( "ORCID identifier") University of Texas at El PasoEl PasoTexas79902USA [sreza3@miners.utep.edu](), Saif Uddin Mahmud University of Texas at El PasoEl PasoTexas79902USA [smahmud4@miners.utep.edu]() and Omar Badreddin University of Texas at El PasoEl PasoTexas7

## Argumentos principais
### 1\. Introduction
Software development becomes distributed nowadays, and developers from anywhere can contribute towards the software development [^1]. Towards this development, some software manages technical artifacts like commits, issues, and milestones which enables a social community that attracts many developers to work on and deliver projects within timeline [^30] [^2]. BitBucket [^11], GitHub [^5], GitLab [^24] is the leader in distributed version control and source code management (SCM), which combines the ability to develop, secure, and operate software in a single application.
Source code management software is growing in features that allow faster development through bug identification, error reporting, or other issues. One of the features is an issue tracking system, often used to get user feedback related to proposed features, bugs, errors, and problems. Also, the service allows the developers to assign an issue to a developer [^20] and automatic labeling issues to prioritize it better [^18]. In summary, this tracking system enhances the code quality and increases the software lifetime.
Software maintenance is a costly and largely unpredictable human-intensive activity in the software development life cycle. High maintenance efforts and expertise often eclipse the cost and sometimes become the reason for unsustainable software [^16]. Moreover, if issues are not well managed during this maintenance, the software becomes smelly and may introduce bugs, and obsolete in the long run [^25]. To solve such issues, developers worldwide may provide feedback on an issue and can contribute to fixing that. Therefore, source code management with issue tracking can provide collaborative pathways to manage software, reduce software failures and improve software quality.

### 2\. Related Work
Software development through source code management and its associated artifacts are available on an open-source platform. Several studies have been conducted research on such artifacts from different perspective such as sentiment analysis [^17], label prediction [^19], issue management [^4] & mining [^34].

### 2.1. Issue-related Artifact Mining
Software artifact mining has improved software quality, bug identification, and network analysis. Several studies have uncovered interesting and actionable artifacts from software data. Several mining tools have emerged to enable such research, and discovery [^28] [^22] [^26]. For example, PyDriller, a python framework for mining software repositories, can extract recent information from open source repositories such as commits, developer information, modifications, differences, and source codes [^28]. However, the tool has no feature to extract issues. MetricMiner is another application suitable for mining software repositories for metrics calculation, data extraction, and statistical inference [^27]. These tools focus on extracting data primarily from either code or commit history, with limited support for mining issue-related artifacts.

### 3\. Study Design
The study aims to analyze issue-related artifacts from open source repositories with the purpose of mining, pre-processing, and visualizing the issues which can be effectively used in practice. The perspective is of both researchers and practitioners who are interested in analyzing the issues in terms of issue expectancy and evolution of issues. Specifically, we aim to address the following research question:
Figure 1. Architecture of G-Issue Tool

### 3.1. Research Questions
This section discusses the research questions we used and how we plan to answer these research questions. We are motivated to find the answer to the following research questions:
RQ1. What is the performance of the G-Issue tool compared to the state-of-the-art tools in mining issue-related artifacts?
The RQ focuses on the performance evaluation of G-Issue and is motivated by the fact that issue-related artifacts are crucial in repositories compared to code itself and tend to be significantly larger in terms of text size and issue comments. This often translates to complexity in identifying and extracting issue-related artifacts. For reference, we compare ModelMine with state of the art tools Python API [^17], GHTorrent [^13] [^14], PyDriller [^28], G-Repo [^26] for mining issues from GitHub. To answer this research question, we choose three individual tasks that are common for the majority of mining research with available support in mining tools. The tasks are as follows:

### 3.2. G-Issue Architecture
In this section, we discuss the architecture of the issue mining tool G-Issue that we built in-house lab setup and hosted on the online platform. The tool adopts several approaches (indexing, paging, query reduction, querying, data representation, and results ranking) to mine issue-related artifacts of repositories from open source repositories. The overall architecture of the G-Issue tool is visualized in Figure 1.
In G-Issue, we provide a user interface with the mining capability to request GitHub for issue-related artifacts and process that data. This service is under the parent tool called ModelMine [^22]. This tool provides a simple, extensible user interface to mine issue-related artifacts of repositories. It has a different way of searching to ensure the possibility of different mining types of datasets for MSR research.
Figure 2. Search & result screenshot of G-Issue Tool

### 3.3. Data Collection
Table 1. Selected repositories with metadata information
| Serial | Repository name | Commits | Contr. | Stars | Forks | Time Selection | No. Open Issues | No. Closed Issues | Total Issues |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |

### 3.4. Terminology
The software issues have some particular terminology we need to discuss to understand the results. Occasionally, issue-related artifacts include reporting bugs, requesting new features, refactoring code, and enhancement ideas. Also, the artifacts are typically created by anyone with title & details and consist of the person’s information, created time, and labels associated with the issues. If the issue is closed or modified, that record is also documented in the specific issue.
Here are the details of some terminologies used in this study.
- Issue lifetime - Time from the first opening of the issue to the first closing of the issue.

### 4\. Results & Discussion
In this section, we report the results and analysis of the research questions mentioned in Section 3.1.

### 4.1. Performance Evaluation
This section discusses the results of the performance of G-Issues compared to other state-of-art-tools. The performance evaluation results among the tools are visualized in Table 2. Such a result provides an idea of which tool performs better during mining issue-related artifacts and how much fast and memory the tool takes to mine selected repositories. All these results are produced with the setup to mine 1000 issues from repositories.
Table 2. Performance evaluation results
<table><tbody><tr><td>Tasks</td><td>Metrics</td><td>G-Issue</td><td>Python API</td><td>GHTorrent</td><td>PyDriller</td><td>G-Repo</td></tr><tr><td>Task <math><semantics><msup><mn>1</mn> <mo>∗</mo></msup> <annotation>1^{*}</annotation></semantics></math></td><td><math><semantics><mrow><mi>E</mi> <mo></mo><msup><mi>T</mi> <mrow><mo>∗</mo> <mo>∗</mo></mrow></msup></mrow> <annotation>ET^{**}</annotation></semantics></math></td><td>12.1s</td><td>18.2s</td><td>46.2s</td><td>Not</td><td>Not</td></tr><tr><td>(Size)</td><td><math><semantics><mrow><mi>M</mi> <mo></mo><msup><mi>M</mi> <mrow><mo>∗</mo> <mo>⁣</mo> <mrow><mo>∗</mo> <mo>∗</mo></mrow></mrow></msup></mrow> <annotation>MM^{***}</annotation></semantics></math></td><td>18223KB</td><td>10211KB</td><td>67033KB</td><td>supported</td><td>supported</td></tr><tr><td>Task 2</td><td>ET</td><td>30.22s</td><td>41.7s</td><td>88.3s</td><td>Not</td><td>Not</td></tr><tr><td>(Time)</td><td>MM</td><td>20340KB</td><td>16547KB</td><td>74031KB</td><td>supported</td><td>supported</td></tr><tr><td>Task 3</td><td>ET</td><td>11.8s</td><td>15.5s</td><td>102.3</td><td>Not</td><td>Not</td></tr><tr><td>(Issue-related)</td><td>MM</td><td>19967KB</td><td>14566KB</td><td>63654KB</td><td>supported</td><td>supported</td></tr><tr><td colspan="7">* Task details are listed in Section 3.1</td></tr><tr><td colspan="7">** ET - Execution Time</td></tr><tr><td colspan="7">*** MM - Max Memory</td></tr></tbody></table>

### 4.2. Analysis of Issue Lifetime
In this section, the results of issue lifetime among repositories are discussed and portrayed in Table 3. The table shows the average days it takes to solve an issue among repositories. Here ”Average days to solve” means how many days it takes to close the issue by developers since the issue creation date.
Table 3. Statistics on days it takes to solve an issue
| Project Name | Mean (days) | Minimum (days) | Maximum (days) |

### 4.3. Evolution of Issues
In this section, we discuss the evolution of issues among repositories. The results of the evolution of issues are visualized in Figure 4 showing a histogram of issue count per year in terms of open or closed state among repositories.
In every case, the graph implies that new issues are increasing in number during the software evolution. This number increases and becomes higher when the close-state issue rate declines. *spring-framework*, *junit-5*, *checkstyle* and *signal-android* shows a recent decline in the rate of closed-state issues and an upward trend of new issues. The KDE density value represents an increasing number of issues reported by developers or contributors.
Also, we have seen a pattern of the zigzag move of issues over the years among the repositories. It implies that when new issues are introduced within that year, it tries to be solved and closed the issue. Hence, the continuous maintenance through issue-related artifact analysis prepares software for the subsequent releases with improved software quality and minimized bugs in reporting.

### 5\. Conclusion
Software maintenance is crucial during software development. If the maintenance efforts are not made correctly, the software quality degrades over time and is hard to fix at one point. To do software maintenance, developers need feedback in the form of issues. Most source code management software nowadays provides issues to report bugs and share ideas for new features.
In this study, we investigated the process of mining, analyzing, and visualizing issue-related artifacts through a developed tool called G-Issue. The study primarily compares the performance of the G-Issue tool with state-of-the-art tools. Moreover, we investigate the lifetime and evolution of issues in well-known open source projects.
The results show that the G-Issue tool performs a minimum of 33% faster than other state-of-the-art tools. However, in memory management, G-Issue is higher than the Python API but lower than other tools. Besides, the results show that highly popular & forked repositories have more issues; on average, it takes more days to solve an issue. In terms of evolution, if the rate of the closed issue is declining, there is a high chance of introducing new issues. Such results may provide new knowledge about issues-related artifacts and help team leaders with issue assignments for better software development.


## Key insights
- Issue lifetime - Time from the first opening of the issue to the first closing of the issue.
- Opened issue - Newly created issue. Each issue is opened only once during its lifetime.
- Closed issue - issue that is marked closed in the issue tracking system. In practice, an issue might be reopened and closed again, but here we use only the last closing event.

## Exemplos e evidências
See original source at `Clippings/G-Issue Analyzing Lifetime and Evolution of Issue-related Artifacts from Open Source Repositories.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/memory]]
- [[03-RESOURCES/concepts/llm-ml-foundations/inference]]
- [[03-RESOURCES/entities/Python]]
