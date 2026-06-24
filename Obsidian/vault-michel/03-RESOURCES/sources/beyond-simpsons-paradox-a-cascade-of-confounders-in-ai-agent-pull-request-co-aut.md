---
title: "Beyond Simpson’s Paradox: A Cascade of Confounders in AI Agent Pull-Request Co-Authorship"
type: source
source: "Clippings/Beyond Simpson’s Paradox A Cascade of Confounders in AI Agent Pull-Request Co-Authorship.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
---
title: "Beyond Simpson’s Paradox: A Cascade of Confounders in AI Agent Pull-Request Co-Authorship"
source: "
author:
published:
created: 2026-06-23
description:
tags:
  - "clippings"
---
Haoran Yu Independent ResearcherSeattleWAUSA [haoranyu889@gmail.com](), Xiaochong Jiang Independent ResearcherSeattleWAUSA [jiang.xiaoc@northeastern.edu](), Lifei Liu Independent ResearcherSeattleWAUSA [lliu.lifei@gmail.com](), Su Wang Carnegie Mellon UniversityPittsburghPAUSA [suwang@alumni.cmu.edu](), Pin 

## Argumentos principais
### 1\. Introduction
AI coding agents (GitHub Copilot, Devin, Cursor, Codex, and Claude Code), built on large language models trained on code [^2], can now draft, commit, and open pull requests (PRs) with minimal human direction [^12] [^4]. They are part of a broader proliferation of large-language-model-based systems across software and data-intensive applications [^3]. A central question for practitioners is: *how often do these PRs actually get merged, and does human involvement matter?*
A first-pass answer is deceptively simple to compute. Using the Co-Authored-By trailer that GitHub and many agent workflows insert into commit messages [^6], one can classify each PR as *human-agent collaborative* or *purely autonomous*. Pooling all 33,596 PRs from five agents, collaborative PRs merge at only 53.8% while autonomous PRs merge at 79.8%, a gap of $-26.0$  pp that appears to condemn human participation as counterproductive.
We show this conclusion is entirely spurious. The aggregate signal is driven by *agent composition*, not by co-authorship itself: Codex, which accounts for 64.9% of all PRs and achieves high merge rates, rarely uses Co-Authored-By (1.2% of its PRs), while Copilot and Devin, whose autonomous PRs succeed at 6.2% and 21.6% respectively, rely on co-authorship for over 89% and 95% of their submissions. Stratifying by agent, four of five agents show a positive within-agent co-authorship effect, a classic reversal that constitutes Simpson’s Paradox [^8] [^7].

### 3\. Method
#### Dataset.
We use the AIDev dataset [^6], which contains 33,596 pull requests submitted by five AI coding agents: Codex ($n=21,799$, 64.9%), Copilot ($n=4,970$, 14.8%), Devin ($n=4,827$, 14.4%), Cursor ($n=1,541$, 4.6%), and Claude Code ($n=459$, 1.4%). PRs span 2024-12 to 2025-07 (218 days), but agent observation windows differ: Devin appears earliest (2024-12), Codex latest (from 2025-05); within-agent and within-repo analyses absorb time-invariant confounding, but readers should bear this asymmetry in mind when interpreting pooled counts. Each PR is linked to its hosting repository and records the final PR state (merged, closed-unmerged, or open at collection time).
#### Co-Authored-By mining.

### 4.1. RQ1: The Simpson’s Paradox in Co-Authorship
#### Pooled analysis (misleading).
Table 1 shows the aggregate result. Co-authored PRs merge at 53.8% while purely-autonomous PRs merge at 79.8%, a difference of $-26.0$  pp ($\chi^{2}=2424$, $p{\approx}0$). A practitioner stopping here would conclude that human co-authorship *reduces* merge probability.
Table 1. Pooled merge rates by co-authorship status (all agents combined). The $-26.0$  pp gap is entirely confounded by agent composition.

### 4.2. RQ2: Author/Committer Collaboration Modes
Table 3 presents merge rates across the three collaboration modes derived from author/committer attribution.
Table 3. Merge rates by author/committer collaboration mode across all agents ($n=33{,}564$ PRs; excludes 16 human-author/bot-committer PRs and 16 PRs lacking commit metadata).
| Mode | $n$ PRs | Merge Rate |

### 4.3. RQ3: Multi-Agent Adoption Patterns
We briefly examined whether adopting a second agent changes existing merge rates (233 multi-agent repos). A difference-in-differences regression on weekly merge rates, controlling for repository fixed effects and a linear time trend, estimates a treatment effect of $-12.1$  pp (SE ${}=3.6$, $p{<}0.001$, 95% CI $[-19.2,-5.0]$  pp). This suggests that introducing a second agent is associated with a meaningful decline in merge rates, though the effect may reflect compositional changes (the second agent contributing lower-quality PRs) rather than disruption to the first agent’s workflow.

### 5\. Discussion and Limitations
#### Direction of causality.
Our data are purely observational. The positive within-agent association between co-authorship and merge rate does *not* imply that adding a human co-author to a PR *causes* it to be merged. An equally plausible interpretation is *selection*: developers may invest effort in co-authoring only those agent PRs they already believe are worthwhile, so Co-Authored-By marks quality rather than creating it. The cascade of confounders documented in §4.1 is consistent with this: pure-autonomous Copilot PRs are mostly single-commit drafts (54.5% \[WIP\]), so the cross-sectional gap captures PR maturation, repository selection, and curation as much as co-authorship *per se*. Full causal identification would require a randomised experiment.
#### Agent composition dominance.

### 6\. Conclusion
We documented a textbook Simpson’s Paradox in AI agent pull-request data: pooled across five agents, co-authorship appears to *hurt* merge rates ($-26.0$  pp), yet within-agent analysis reveals positive gaps for four of five agents, with Copilot and Devin showing $+41.2$ and $+33.5$  pp cross-sectionally. This reversal, however, is only the first layer of a *cascade of confounders*: within-repo controls collapse Devin’s gap to $+1.6$  pp, and a commit-count control reduces Copilot’s within-repo gap from $+36.2$ to $+24.4$  pp; restricted to multi-commit PRs the Copilot effect is $+4.8$  pp ($p{=}0.59$). A complementary author/committer analysis confirms a graded pattern (47.6% $\to$ 64.3% $\to$ 82.0%).
These findings argue for agent-stratified analyses in SE empirical studies and demonstrate that cross-sectional co-authorship associations can be misleading without within-repo *and* within-PR-structure controls: what appears as a universal or even agent-specific human-involvement benefit is, once both confounders are controlled, more cautiously characterised as a structural correlate (single-commit drafts vs. multi-commit submissions) than evidence of a causal benefit of co-authorship per se. Analysis scripts are available for replication at [).
###### Acknowledgements.


## Key insights
- Stratifying 33,596 PRs from the AIDev dataset by agent identity reverses the conclusion: Copilot and Devin show large positive within-agent gaps ($+41.2$ and $+33.5$  pp, both $p{<}0.001$), while Cursor, Claude Code, and Codex show small effects whose cross-sectional 95% CIs span zero.
- The paradox is driven entirely by agent composition: Codex, which dominates 64.9% of the dataset, achieves high merge rates while rarely using co-authorship.
- No agent retains a clear co-authorship effect once both repository selection and PR structure are controlled.
- Our findings caution against reporting agent-pooled statistics without stratification and demonstrate that cross-sectional co-authorship associations are largely selection and PR-structure artefacts rather than evidence of a causal benefit.
- They are part of a broader proliferation of large-language-model-based systems across software and data-intensive applications [^3].
- Using the Co-Authored-By trailer that GitHub and many agent workflows insert into commit messages [^6], one can classify each PR as *human-agent collaborative* or *purely autonomous*.
- We show this conclusion is entirely spurious.
- Stratifying by agent, four of five agents show a positive within-agent co-authorship effect, a classic reversal that constitutes Simpson’s Paradox [^8] [^7].
- However, the within-agent reversal is itself the start of a longer story.
- No agent retains a clear within-stratum co-authorship effect once both repository selection and PR structure are controlled.

## Exemplos e evidências
See original source at `Clippings/Beyond Simpson’s Paradox A Cascade of Confounders in AI Agent Pull-Request Co-Authorship.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/entities/Claude]]
- [[03-RESOURCES/entities/GitHub-Copilot]]
- [[03-RESOURCES/entities/Codex]]
- [[03-RESOURCES/entities/Microsoft]]

## Minha Síntese
**O que muda:** A ser analisado em revisão manual.

**Conexão pessoal:** A ser conectado com projetos/estudo atuais.

**Próximo passo:** Nenhum próximo passo imediato.
