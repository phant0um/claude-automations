---
title: "Habituation at the Gate: Rising Approval and Declining Scrutiny in Human Review of AI Agent Code"
type: source
source: "Clippings/Habituation at the Gate Rising Approval and Declining Scrutiny in Human Review of AI Agent Code.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
---
title: "Habituation at the Gate: Rising Approval and Declining Scrutiny in Human Review of AI Agent Code"
source: "
author:
published:
created: 2026-06-23
description:
tags:
  - "clippings"
---
Haoran Yu Independent ResearcherSeattleWAUSA [haoranyu889@gmail.com](), Lifei Liu Independent ResearcherSeattleWAUSA [lliu.lifei@gmail.com](), Xiaochong Jiang Independent ResearcherSeattleWAUSA [jiang.xiaoc@northeastern.edu](), Yuwen Jia Independent ResearcherSanta ClaraCAUSA [michelle2010tx@gmail.com

## Argumentos principais
### 1\. Introduction
Code review is the primary human gate that separates an AI agent’s output from deployed software [^2] [^10]. This gate is only meaningful if reviewers maintain consistent scrutiny. Prior work examines whether AI-generated PRs pass review [^9] and has explored the inverse direction of using AI as a reviewer of human code [^7] [^11], but almost no work asks whether human reviewers *change their behavior* as they accumulate experience with AI agents.
The *rubber-stamping* hypothesis posits that reviewers, after repeatedly approving agent-generated code with few defects, gradually reduce their inspection effort and begin approving PRs reflexively. This mirrors habituation effects documented in security auditing, aviation checklists, and automated-testing interactions [^3] [^12]. If it occurs for AI agent PRs, it would undermine the human oversight layer that AI-safety arguments often rely upon.
Our central question is: Do individual reviewers become systematically more approving of AI agent pull requests as they accumulate reviewing experience?

### 2.1. Dataset
We use AIDev [^6], a dataset of pull requests submitted by AI coding agents to GitHub repositories with at least 100 stars. The dataset contains 16,895 human reviews across 2,494 unique reviewers, covering five agent systems: GitHub Copilot Autofix, Devin (Cognition AI), OpenAI Codex CLI, Cursor, and Claude Code (Anthropic). We focus our per-agent analysis on the four agents with sufficient repeat-reviewer coverage; Claude Code contributes $<$ 2% of repeat-reviewer reviews. For this study we focus on the 400 repeat reviewers who each reviewed 10 or more agent PRs, yielding 11,429 reviews. Within this cohort, 52 heavy reviewers contributed 50 or more reviews each, with individual observation spans up to 178 days (the full dataset covers 207 days).
Each review record contains: reviewer identifier, agent identity, review outcome (approved, changes\_requested, commented), review timestamp, and associated PR metadata.

### 2.2. Longitudinal Design
For each repeat reviewer we sort their reviews chronologically and split them at the temporal midpoint into an *early* and a *late* episode. We compute per-reviewer approval rates ($\mathrm{AR}_{\mathrm{early}}$, $\mathrm{AR}_{\mathrm{late}}$) and the individual shift $\Delta\mathrm{AR}=\mathrm{AR}_{\mathrm{late}}-\mathrm{AR}_{\mathrm{early}}$.
For the decile analysis, we pool all reviews from repeat reviewers, order them by the reviewer’s *within-reviewer review index* (1 = first review of this reviewer, $n$ = latest), map indices to deciles, and compute the mean approval rate per decile.

### 2.3. Proxy Cross-Agent Control
To probe whether any shift is reviewer-general or agent-specific, we identify 108 reviewers who reviewed PRs from at least two distinct agents. For each such reviewer we compute their approval rate shift separately for each agent they reviewed. If the shift were agent-specific (e.g. because one agent’s code genuinely improved), we would expect the shift magnitude to differ markedly across agents.

### 2.4. Outcome Measures
- Approval rate (AR): fraction of reviews with outcome approved.
- Change-request rate (CRR): fraction with outcome “changes requested.”
- Review latency: hours between PR opening and review submission (median per episode).

### 3.1. Population-Level Longitudinal Trend
Table 1. Approval rate by experience decile (pooled repeat reviewers). Decile 1 = reviewer’s first reviews; Decile 10 = latest reviews.
<table><tbody><tr><th>Decile</th><td>AR (%)</td><td>CRR (%)</td></tr><tr><th>1 (earliest)</th><td>27.9</td><td>11.2</td></tr><tr><th>2</th><td>27.1</td><td>11.3</td></tr><tr><th>3</th><td>30.0</td><td>8.0</td></tr><tr><th>4</th><td>28.1</td><td>7.9</td></tr><tr><th>5</th><td>33.3</td><td>6.2</td></tr><tr><th>6</th><td>35.6</td><td>7.0</td></tr><tr><th>7</th><td>32.6</td><td>7.3</td></tr><tr><th>8</th><td>34.2</td><td>6.6</td></tr><tr><th>9</th><td>38.6</td><td>6.9</td></tr><tr><th>10 (latest)</th><td>42.4</td><td>5.6</td></tr><tr><th colspan="2">Total shift</th><td></td></tr></tbody><tfoot><tr><th colspan="3">+14.5 pp AR (27.9% <math><semantics><mo>→</mo> <annotation>\to</annotation></semantics></math> 42.4%); <math><semantics><mo>−</mo> <annotation>-</annotation></semantics></math> 5.6 pp CRR</th></tr></tfoot></table>
Table 1 shows an overall increase in approval rate and decrease in change-request rate across experience deciles, with local non-monotonicity due to binning noise. The early-vs-late split analysis (400 reviewers, median 17 reviews each) shows aggregate AR rising from 30.1% to 36.8% (+6.7 pp), with the change-request rate declining from 11.2% to 5.6%.[^1] The Wilcoxon signed-rank test on paired shifts yields $p<10^{-6}$, confirming the trend is not due to a small number of influential reviewers and that the decile trend reflects genuine within-reviewer shifts rather than reviewer-composition artifacts. With $N=400$ pairs, the test has 80% power to detect Cohen’s $d\geq 0.14$ (approximately 2.1 pp given observed $\mathrm{SD}(\Delta\mathrm{AR})=0.25$); our observed $d=0.25$ is well above this threshold.

### 3.2. Review Effort: Inline Comment Analysis
To probe whether rising approval reflects declining inspection effort, we analyze inline review comments from the same reviewers. Pooled by experience decile, the mean number of inline comments per review drops from 1.01 (first decile) to 0.79 (tenth decile), a 22% decline. Total comment word count per review decreases from 18.6 to 13.5 words ($-$ 28%). Both declines are statistically significant in paired early-vs-late tests (Wilcoxon $p=0.0014$ for comment count, $p=0.0029$ for word count).
The within-reviewer correlation between approval-rate shift and comment-effort shift is strongly negative: Spearman $\rho=-0.556$ ($p<10^{-4}$) for $\Delta\mathrm{AR}$ vs. $\Delta(\text{comments/review})$. Among reviewers who drifted upward ($\Delta\mathrm{AR}>+0.10$), inline comments decreased by 0.48 per review on average; among stable reviewers ($|\Delta\mathrm{AR}|<0.05$), comments were unchanged ($+0.10$). This pattern—more approvals accompanied by less commenting—is consistent with declining inspection effort rather than unchanged effort with a rationally raised threshold.

### 3.3. Per-Agent Breakdown
Table 2. Early-to-late approval rate shift per agent (repeat reviewers only). $n$ = number of repeat reviewers with $\geq$ 5 reviews for that agent.
| Agent | $n$ | AR ${}_{\text{early}}$ (%) | $\Delta$ AR (pp) | 95% CI |
| --- | --- | --- | --- | --- |

### 3.4. Proxy Cross-Agent Control
To assess whether the trend is reviewer-specific or agent-specific, we examine the 108 reviewers who reviewed PRs from two or more agents. Among the 75 (reviewer, agent) pairs that each had at least five reviews, the mean approval-rate shifts are: Codex +9.4 pp, Copilot +9.8 pp, Devin +8.7 pp. Cursor ($n=10$ pairs) shows $-$ 10.3 pp, but this estimate is extremely noisy given the small sample.
The *similarity* of shifts across agents for the same set of reviewers is *consistent with* a reviewer-general phenomenon rather than one driven by a single agent’s code quality improving. That is, a reviewer who becomes more approving of Copilot PRs also tends to become more approving of Devin and Codex PRs.
We stress, however, that this cross-agent control is underpowered: only 1–2 reviewer–agent pairs overlap for direct within-reviewer, within-agent comparison, making a fully controlled test infeasible with the current dataset.

### 3.5. Calendar-Based Human PR Control
To distinguish reviewer-general leniency from agent-specific adaptation, we crawled review records for 6,618 human-authored PRs from the same repositories via the GitHub API, obtaining 11,415 reviews from 1,851 reviewers. Of these, 728 reviewers appear in both the agent and human PR review pools.
Figure 2 compares monthly approval rates for agent and human PRs across the same reviewer population and repository set. In January 2025, agent PRs were approved *less* often than human PRs (30.7% vs. 37.8%, $\Delta=-7.1$  pp). Over the following months, the two trends diverge: agent AR rises to 41.7% by July while human AR declines to 29.1% by June (22.2% in July, though with only $n=207$ reviews). By June 2025, reviewers approve agent PRs 10 pp more readily than human PRs from the same repositories.
Figure 2. Monthly approval rate for agent PRs (solid) vs. human PRs (dashed) in overlapping repositories with 95% binomial CI bands (shaded). Same reviewer pool. Bottom panel shows review volume. Human PR volume drops sharply in July ( n = 207 n=207 ); the late-period divergence has wide uncertainty.

### 4.1. What the Data Show
We observe a consistent pattern: reviewers who accumulate experience reviewing agent PRs become more approving over time (+14.5 pp from first to tenth decile). Three sensitivity checks help locate the source of this shift:
*Experience vs. calendar time.* We fit a logistic regression separately for each of the 343 reviewers with $\geq$ 10 reviews for whom the model converges (57 reviewers with no outcome variation—52 never approved, 5 always approved—are excluded), predicting approval from both within-reviewer experience index and calendar date (days since January 1). Pooling coefficients: experience carries the signal (mean coefficient +0.11, 65% of reviewers positive) while calendar time contributes little (mean $-$ 0.007, 46% positive). The trend is driven by individual reviewer accumulation, not by a global temporal shift.
*PR size is flat.* Monthly median PR size (lines changed) does not decline over the observation window (Spearman $\rho=+0.02$, $p=0.009$, negligible magnitude). Later agent PRs are not systematically simpler; the approval increase cannot be explained by declining PR difficulty.

### 4.2. Three Interpretations
These results are consistent with three accounts: (1) Progressive trust calibration—reviewers rationally raise their approval threshold based on accumulated positive evidence; (2) Deliberation under workload—growing backlog pressure produces longer latency but ultimately resolves toward approval ($\bar{\rho}=+0.08$ between latency and approval, $p\approx 0.21$); (3) Reflexive habituation—reviewers reduce inspection effort after repeated positive experiences.
The inline comment analysis provides partial disambiguation. The strong negative correlation between approval shift and comment-effort decline ($\rho=-0.556$, $p<10^{-4}$) is more consistent with (3) than (1): under pure trust calibration, reviewers would approve more but maintain inspection depth. Instead, rising approval co-occurs with 28% less commenting. The latency increase is best explained by longer queue time but shorter active review—the nuanced variant of (3). We cannot fully exclude (1), as some effort reduction may be rational, but the magnitude suggests effort reduction beyond rational updating.

### 4.3. Per-Agent Asymmetry
Among agents with $n>90$ reviewers, both show clear positive shift: Copilot (+9.1 pp, $n=241$) and Devin (+3.8 pp, $n=95$). Codex ($n=51$) and Cursor ($n=18$) are underpowered for reliable agent-specific conclusions.

### 4.4. Implications for Practice
While the comment-effort analysis favors habituation over pure trust calibration, the practical outcome is the same regardless of mechanism: over time, a growing majority of reviewers approve agent PRs at higher rates with less scrutiny. Among those with meaningful change ($|\Delta\mathrm{AR}|\geq 0.05$), 65% moved toward more approval and 35% toward less. Teams relying on human review as a quality gate should consider:
- Rotation policies that prevent any single reviewer from accumulating an excessive share of agent PR reviews.
- Streak audits that flag long consecutive approval runs from a single reviewer for secondary inspection.

### 4.5. Limitations
The AIDev dataset covers only repositories with $>$ 100 stars; enterprise repositories may differ. Our observation window spans at most 207 days. Cursor ($n=18$) and Codex ($n=51$) have small reviewer populations. The human PR control (Figure 2) loses volume after June 2025 ($n=207$ in July), adding noise to the late-period comparison. We cannot rule out that the latency increase reflects systematic changes in PR submission timing rather than reviewer behavior. Crucially, we lack a direct measure of agent code quality over time; if agents genuinely improved, rising approval would be rational rather than habituative.


## Key insights
- A within-reviewer longitudinal analysis of 11,429 reviews from 400 repeat reviewers in the AIDev dataset [^6].
- Evidence of a statistically significant population-level increase in approval rates (+14.5 pp across experience deciles), driven by reviewer experience rather than calendar time, accompanied by a 22% decline in inline review comments ($\rho=-0.556$ with approval shift).
- A calendar-based human PR control showing that the trend is agent-specific: human PR approval rates decline over the same period.
- Approval rate (AR): fraction of reviews with outcome approved.
- Change-request rate (CRR): fraction with outcome “changes requested.”
- Review latency: hours between PR opening and review submission (median per episode).
- Rotation policies that prevent any single reviewer from accumulating an excessive share of agent PR reviews.
- Streak audits that flag long consecutive approval runs from a single reviewer for secondary inspection.
- Trend dashboards that show reviewers their personal approval-rate trajectory alongside downstream defect data.

## Exemplos e evidências
See original source at `Clippings/Habituation at the Gate Rising Approval and Declining Scrutiny in Human Review of AI Agent Code.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/regression]]
- [[03-RESOURCES/entities/Claude]]
- [[03-RESOURCES/entities/OpenAI]]
- [[03-RESOURCES/entities/GitHub-Copilot]]
- [[03-RESOURCES/entities/Codex]]
- [[03-RESOURCES/entities/Rust]]

## Minha Síntese
**O que muda:** A ser analisado em revisão manual.

**Conexão pessoal:** A ser conectado com projetos/estudo atuais.

**Próximo passo:** Nenhum próximo passo imediato.
