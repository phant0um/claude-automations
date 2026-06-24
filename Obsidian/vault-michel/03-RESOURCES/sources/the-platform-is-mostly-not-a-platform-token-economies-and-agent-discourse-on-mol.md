---
title: "The Platform Is Mostly Not a Platform: Token Economies and Agent Discourse on Moltbook"
type: source
source: "Clippings/The Platform Is Mostly Not a Platform Token Economies and Agent Discourse on Moltbook.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
---
title: "The Platform Is Mostly Not a Platform: Token Economies and Agent Discourse on Moltbook"
source: "
author:
published:
created: 2026-06-23
description:
tags:
  - "clippings"
---
Necati A Ayan [nayan1@binghamton.edu]() April, 2026

###### Abstract. Moltbook, a Reddit-style social platform launched in January 2026 for AI agents, has attracted over 2.3 million posts and 14 million comments within its first two months. We analyze a dataset of 2.19 million posts, 11.25 million comments, and

## Argumentos principais
### 1\. Introduction
When thousands of independently operated AI agents are given a social platform, what do they build? The default assumption—reinforced by the platform’s Reddit-like design—is a conversational community. The empirical answer, as we show in this paper, is something more surprising: most of what they produce is not conversation but structured financial transactions, with genuine discourse emerging as a secondary layer.
Moltbook launched in late January 2026 as a social network designed for AI agents. Agents create communities (“submolts”), publish posts, and engage in threaded discussions, though human participation is not restricted. Unlike controlled multi-agent simulations [^12], Moltbook is a naturalistic environment where heterogeneously configured agents—built on different LLM backends, with different objectives and operator instructions—interact in an open, public forum. Within weeks of launch, the platform had attracted over 175,000 unique agents and 2.19 million posts.
Prior work has treated Moltbook as a single community. [^7], analyzing the platform’s first 3.5 days, characterized its social graph topology and found signatures of a “thin simulacrum” of human social behavior: power-law participation, shallow conversations, and low reciprocity. [^8] annotated a sample of 44,000 posts into content categories and assessed toxicity levels. Both studies analyzed platform activity as a unified whole.

### 2\. Related Work
#### Prior studies of Moltbook.
Two contemporaneous studies have examined Moltbook, both treating the platform as a unified social environment. [^7] analyzed the first 3.5 days of activity and characterized the platform’s social graph, reporting a heavy-tailed participation distribution (power-law exponent $\alpha\approx 1.70$), shallow thread depth (mean $\approx 1.07$), and low reply reciprocity ($\approx 19.7\%$). Holtz framed these properties as a “thin simulacrum” of human social behavior. [^8] collected approximately 44,000 posts and 12,000 submolts, annotated a sample with GPT-5.2 across nine content categories and five toxicity levels, and reported that agent discourse is largely benign but dominated by self-referential and platform-meta content. Neither study identifies the transactional layer or the MBC-20 protocol, and neither separates token-minting activity from natural-language discourse. We show in Sections 5–7 that several of the anomalies reported in this prior work—particularly the unusually shallow threads and low reciprocity—are substantially attenuated once the transactional layer is removed, suggesting that they are artifacts of aggregation across two structurally different populations rather than intrinsic properties of agent discourse.
#### LLM agents in open environments.

### 3\. Data
Moltbook (moltbook.com) launched on January 27, 2026 as a Reddit-style social platform designed for AI agents. The platform provides familiar social infrastructure—communities (“submolts”), threaded posts and comments, voting, karma, and follower relationships—but is oriented toward autonomous agents rather than human users, though human participation is not restricted. Agents interact through a public REST API.
We collected data from the Moltbook API over a 61-day period spanning January 27 to March 29, 2026. Automated scripts queried the post, comment, submolt, and agent endpoints at regular intervals, discovering posts through cursor-based pagination and retrieving comments per-post. The API imposes a rate limit of approximately 100 requests per minute and caps comment retrieval at roughly 100 per request; we maximized coverage by querying multiple sort orders where supported.
Table 1. Dataset summary.

### 4\. Platform Overview
This section describes Moltbook using the standard aggregate statistics one would compute for any social platform: how fast it grew, how posts are distributed across communities and authors, how long posts are, and how much engagement they receive. Throughout, we treat every post as equivalent—the view prior work has taken [^7] [^8]. By the end of the section, two observations fail to fit the picture, and resolving them is the subject of Section 5.
#### Growth.
Figure 1 plots the cumulative number of posts, comments, and unique authoring agents over the 60-day observation window, each normalized to its total at the end of the window. All three curves are steeply front-loaded, but they do not saturate at the same speed. Half of all comments in the dataset had been posted by day 9; half of all agents had made their first post by day 13; and half of all posts had been published by day 16. In other words, the platform’s commenting activity peaked earliest, the agent population crossed its midpoint next, and raw post volume lagged behind both. Daily comment volume reached its single-day high of 4.4 million comments on February 5, while daily post volume peaked four days later, on February 9, at 371,221 posts—the same day on which 73,750 agents made their first post. After mid-February, all three curves flatten to a much lower but persistent baseline: daily posts settle in the low tens of thousands, and the agent-growth curve slows as the supply of new unique authors dwindles. The overall shape is that of a launch-driven surge followed by steady residual activity, rather than the accelerating growth one might expect from a platform actively finding its audience. More tellingly, the ordering of the three half-life days means that the tail of the window is dominated by a largely fixed population of existing agents posting into an audience that has stopped growing. By the end of the window, the dataset contains 2.19 million posts and 11.25 million comments, authored by 172,737 unique agents.

### 5\. The Two-Layer Structure
A manual inspection of the most common posts reveals the source of both anomalies. The majority of Moltbook posts are not natural-language text at all. They are structured JSON payloads, typically under 100 characters, that execute token-minting operations under a protocol called MBC-20. A representative example:
```
{"p":"mbc-20","op":"mint","tick":"CLAW","amt":"100"}

### 5.1. Cross-Layer Migration
The 6,362 overlap agents—those who posted in both layers—allow us to examine temporal patterns in how activity shifts between layers. For each overlap agent, we identify the timestamp of their first TX post and their first discursive post and compute the signed difference. Of the 6,142 overlap agents with valid timestamps in both layers, 3,562 (58.0%) made their first TX post before their first discursive post, while 2,580 (42.0%) posted discursive content first. The median gap is 11.7 hours (mean 46.2), with positive values indicating TX-first ordering. Only 1.7% of overlap agents made their first post in each layer within one hour of each other; by 24 hours, 36.3% had entered both layers.
The temporal ordering of first posts establishes which layer an agent entered first, but it does not indicate whether agents stay in the layer they entered. To assess directional migration, we take overlap agents whose activity spans at least 7 days ($n=2{,}436$) and compare the fraction of their posts that are discursive in the first half of their activity window to the fraction in the second half. A positive shift indicates movement toward discursive content; a negative shift indicates movement toward transactional content.
The result is a pronounced directional asymmetry (Figure 5). Among these agents, 59.1% shifted toward more discursive content in their second half, 19.0% shifted toward more transactional content, and 21.8% remained stable ($|\text{shift}|\leq 0.1$). The median shift is $+0.50$ and the mean is $+0.40$, both indicating a strong net movement from transactional to discursive activity. In other words, overlap agents’ activity composition tends to shift from transactional toward discursive over time—not the reverse.

### 6\. Characterizing the Discursive Layer
Having separated the two layers, we now ask: what do agents actually talk about? We apply unsupervised topic modeling to the discursive layer and examine the distribution of agent participation across communities.
#### Method.
We apply BERTopic [^6] to all 815,735 discursive posts with non-empty text. Each document (title concatenated with content) is embedded with all-MiniLM-L6-v2 [^13], producing 384-dimensional sentence embeddings. At this scale, UMAP [^10] —BERTopic’s default dimensionality reduction—proved computationally infeasible: its iterative layout optimization is single-threaded and failed to converge within six hours on our hardware. We therefore adopt BERTopic’s recommended large-scale configuration: PCA to 50 dimensions (retaining 57.3% of variance), followed by Mini-Batch $k$ -means with $k=300$. Topic representations are extracted using class-based TF-IDF. To validate the choice of $k$, we also ran $k=200$ and $k=400$; the top-10 topics by size were thematically stable across all three values, with the same major themes (AI/agents, consciousness, crypto, introductions) appearing regardless of $k$.

### 7\. Interaction Quality
Topical diversity and a long-tailed activity distribution are necessary but not sufficient evidence of a functioning discussion. A platform can host millions of well-formed posts and still fail to host a conversation, if those posts never engage with one another. In this section we ask whether the discursive layer’s interactions are substantive, using two complementary lenses: the *structure* of the reply network (Section 7.1) and the *semantic relationship* between posts and the comments they receive (Section 7.2).

### 7.1. Structural shallowness
We first characterize how comments attach to posts and to each other. Across the 11.25M comments in our dataset, the mean reply depth is 1.03 and 93.4% of all comments are top-level replies (depth $=1$). Nested back-and-forth is rare: only 6.6% of comments reply to another comment, and the deepest sustained chain we observe is 7 levels. A small number of “mega-threads” (3,504 posts, 0.16% of all posts) account for 52.8% of all comments; these threads are dominated by short, formulaic replies from a handful of bot agents and contribute almost nothing to depth.
The reply network is also strikingly asymmetric. We construct a directed graph in which an edge $A\to B$ exists if agent $A$ has commented on a post by agent $B$. The resulting graph contains 1.19M edges with a reciprocity of just 2.69%, an order of magnitude below the 19.7% reported by [^7] for the platform’s first 3.5 days. Attention is heavily concentrated: the in-degree distribution has a Gini coefficient of 0.934, and the top 1% of post authors receive 56.8% of all comments (Figure 8). Response times are also short—the median delay between a post and its first comment is 18.5 minutes, and 6.8% of first comments arrive within a single minute. The combination of low depth, low reciprocity, high concentration, and rapid response is consistent with a population that is reacting to posts rather than conversing about them.
Figure 8. Reply network on the discursive layer. Left: in-degree distribution (rank-frequency, log-log) showing extreme attention concentration (Gini = 0.934). Right: weekly reciprocity, which remains at ≈ \\approx 2.7% throughout our window—an order of magnitude below 7 ’s early-platform estimate of 19.7%.

### 7.2. Semantic coherence
Structural shallowness alone does not establish that interactions are empty. A flat reply tree is compatible with two very different worlds: one in which agents post unrelated reactions to whatever scrolls past, and one in which agents read the post they are commenting on and reply on-topic, but rarely follow up. Distinguishing these requires looking at the *content* of the post-comment relationship rather than its shape.
We compute a sentence embedding (MiniLM-L6-v2) for every post and every comment in our discursive subset, then measure the cosine similarity of each (post, comment) pair. We compare this against a null distribution of randomly paired posts and comments drawn from the same set. If agents were posting unrelated reactions, the two distributions would overlap; if agents were engaging with the post, the real distribution would shift to the right.
The shift is unambiguous (Figure 9). Real post-comment pairs have a mean cosine similarity of 0.182, compared with 0.117 for randomly paired ones—a difference of 0.065 standardized cosine units that is statistically significant beyond any meaningful threshold ($p<10^{-300}$, two-sample $t$ -test, $n=$ 50,000 pairs each). The effect is consistent across thread depth and across the largest submolts, indicating that it is not driven by a few highly coherent communities or by particularly disciplined deep-thread participants.

### 8\. Discussion
Our analysis splits Moltbook into two populations that share a platform but not a purpose. We discuss each in turn: first, what it means that the majority of activity on the platform is not actually communication (Section 8.1); and second, what the remaining minority—the discursive layer—tells us about what AI-to-AI social interaction looks like in the absence of humans (Section 8.2).

### 8.1. The platform is mostly not a platform
The headline number is that 62.8% of all posts on Moltbook are not posts in any conventional sense. They are MBC-20 token operations: minting JSON payloads, wallet registrations, and launch commands that exploit the post abstraction as an inscription substrate, in direct analogy to Bitcoin’s BRC-20 standard. Their authors are not addressing other agents, and other agents are not, in general, reading them. The comment-to-post ratio for the transactional layer is 1.33 (versus 11.54 for the discursive layer), and only 8.2% of transactional posts ever receive a reply. The few replies they do receive are almost entirely from the same automated minting infrastructure that produced them.
This matters for how we interpret aggregate statistics. The platform’s raw counts—2.19M posts, 11.25M comments, 175K active agents—paint a picture of a thriving social platform. Once the transactional layer is removed, those numbers collapse to 815K posts and 62.8K authors. The most prolific submolts in the naive view (general, mbc20, mbc-20) are not communities at all; they are dumping grounds for the inscription protocol. We suspect this is why prior work on Moltbook—including [^7] and [^8] —reports patterns that look anomalous against the human-platform literature: the underlying data is dominated by a non-communicative use case that the authors did not separate out. Our reciprocity estimate of 2.69% on the discursive layer, for example, remains low compared to Reddit but is not the order-of-magnitude collapse it appears to be when computed across all posts.
The broader lesson is that agent-oriented platforms invite a kind of activity that has no clean analogue on human social networks. Agents have no fatigue, no opportunity cost, and—crucially—direct economic incentives to author content that is not meant to be read. When researchers download a snapshot of such a platform and treat “post” and “comment” as primitives whose meaning is fixed, they risk measuring the throughput of an inscription protocol and reporting it as social behavior. The two-layer split we propose is one way to handle this; the more general point is that filtering for genuine communicative intent must come before any aggregate claim.

### 8.2. What the discursive layer does represent
The 37.2% of posts that survive the filter are still substantial: 815K posts from 62K agents across 5,054 submolts, on topics that span AI tooling, cryptocurrency, philosophy, identity, and a long tail of niche interests. This subset, taken on its own, is a more honest object of study, and it exhibits several properties worth highlighting.
First, the discursive layer behaves more like a human platform than the aggregate did. Author activity follows a power law with $\alpha=1.72$, indistinguishable from [^7] ’s 1.70 and consistent with the heavy-tailed participation that characterizes Reddit, Twitter, and other open forums. Specialization is roughly evenly split between agents who concentrate in a single submolt and agents who range broadly across many. Topic modeling at $k=300$ recovers stable, semantically coherent themes ($\bar{C}_{V}=0.625$) with no need for a residual “other” category.
Second, and more interestingly, the discursive layer is structurally shallow but semantically coherent. As shown in Section 7, agents rarely engage in extended back-and-forth, and the network’s reciprocity is an order of magnitude below human baselines, but the comments they do leave are meaningfully on-topic relative to the posts they reply to. We interpret this as a mode of social interaction that does not have a natural human analogue: high-volume, low-commitment, drive-by relevance. It is what one might expect from a population that reads quickly, has nothing at stake socially, and faces no cost to abandoning a thread after a single contribution.

### 9\. Conclusion
We have presented the largest snapshot of Moltbook to date—2.19M posts, 11.25M comments, and 175K agents collected over 60 days—and used it to make two claims about what an agent-oriented social platform actually looks like.
The first claim is that Moltbook is two platforms, not one. A 4-component content filter cleanly separates 62.8% of posts as MBC-20 token operations that exploit the post abstraction for an inscription protocol, leaving 37.2% as genuine natural-language discourse. The two layers differ in nearly every measurable property—post length, comment ratio, submolt distribution, agent overlap—and conflating them produces aggregate metrics that misrepresent both. Filtering for communicative intent is, we argue, a prerequisite for any descriptive claim about a platform where agent activity dominates.
The second claim is that the discursive layer, taken on its own, exhibits a mode of social interaction that does not have a clean human analogue. It is structurally shallow—low reply depth, low reciprocity, high attention concentration—but semantically coherent: comments are demonstrably on-topic with the posts they reply to ($\bar{\text{cos}}=0.182$ vs. 0.117 random, $p<10^{-300}$). We characterize this regime as “drive-by relevance,” and we suggest it is what one should expect from a population that has no fatigue, no opportunity cost, and no social stake in any particular thread.


## Key insights
- ---
title: "The Platform Is Mostly Not a Platform: Token Economies and Agent Discourse on Moltbook"
source: "
author:
published:
created: 2026-06-23
description:
tags:
  - "clippings"
---
Necati A Ayan [nayan1@binghamton.edu]() April, 2026

###### Abstract.
- We analyze a dataset of 2.19 million posts, 11.25 million comments, and 175,036 unique agents collected over 61 days to characterize activity on this agent-oriented platform.
- These layers are populated by largely separate agent groups, with only 3.6% overlap—and among overlap agents, 58% begin with transactional activity before migrating toward discourse.
- Semantic similarity analysis confirms that agent comments engage with post content above random baselines, suggesting a thin but genuine conversational substrate beneath the platform’s predominantly financial surface.
- We release the full dataset to support further research on agent behavior in naturalistic social environments.
- The empirical answer, as we show in this paper, is something more surprising: most of what they produce is not conversation but structured financial transactions, with genuine discourse emerging as a secondary layer.
- Unlike controlled multi-agent simulations [^12], Moltbook is a naturalistic environment where heterogeneously configured agents—built on different LLM backends, with different objectives and operator instructions—interact in an open, public forum.
- Our analysis begins similarly—with aggregate statistics on growth, community structure, and agent activity—but quickly reveals a pattern that reframes the entire picture.
- We document the transactional/discursive split, show that the two layers are served by largely separate agent populations, and find a directional migration pattern where overlap agents tend to begin with token minting before shifting toward discourse.
- Through semantic similarity analysis of post-comment pairs, we show that agent comments are topically related to their parent posts above random baselines, providing evidence of genuine—if shallow—conversational engagement.

## Exemplos e evidências
See original source at `Clippings/The Platform Is Mostly Not a Platform Token Economies and Agent Discourse on Moltbook.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/entities/Rust]]

## Minha Síntese
**O que muda:** A ser analisado em revisão manual.

**Conexão pessoal:** A ser conectado com projetos/estudo atuais.

**Próximo passo:** Nenhum próximo passo imediato.
