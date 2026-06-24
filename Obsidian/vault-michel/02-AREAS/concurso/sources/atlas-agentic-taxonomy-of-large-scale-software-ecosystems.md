---
title: "ATLAS: Agentic Taxonomy of LArge-Scale Software Ecosystems"
type: source
source: "Clippings/ATLAS Agentic Taxonomy of LArge-Scale Software Ecosystems.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [concurso, source-page]
---

## Tese central
---
title: "ATLAS: Agentic Taxonomy of LArge-Scale Software Ecosystems"
source: "
author:
published:
created: 2026-06-23
description:
tags:
  - "clippings"
---
Junyi Lu <sup>1,2</sup>, Mengyao Lyu <sup>3,†</sup>, Jiahui Wu <sup>3</sup>, Lei Yu <sup>1,2</sup>, Chengwei Liu <sup>4</sup>, Fengjun Zhang <sup>1</sup>, Li Yang <sup>1,†</sup>, Chun Zuo <sup>5</sup>, Yang Liu <sup>3</sup> <sup>1</sup> Institute of Software, Chinese Academy of Sciences, Beijing, China <sup>2</sup> University of Chinese A

## Argumentos principais
### 1\. Introduction
When a developer searches for an alternative to Kubernetes for container orchestration, GitHub returns thousands of repositories tagged kubernetes (tools, documentation, extensions, and tutorials) but virtually no actual orchestration alternatives. The root cause is not the search algorithm but the lack of a systematic *taxonomy*. GitHub Topics, the ecosystem’s only organizational mechanism, assigns flat, user-defined tags with no hierarchy, no normalization (e.g., machine-learning vs. ml), and no coverage guarantee; in our dataset, 33% of repositories with $\geq$ 1,000 stars have no topics at all. The result is an ecosystem of over 54,000 community-adopted repositories with no systematic way to navigate, compare, or analyze them.
What the ecosystem needs is a *taxonomy*: a hierarchical system where every category has a precise definition, sibling categories are mutually exclusive, and tree depth encodes increasing specificity [^12]. A well-constructed taxonomy enables capabilities that flat tags cannot: *multi-granularity retrieval* (searching at any level of specificity), *alternative discovery* (finding functionally equivalent projects as siblings in the same category), and *ecosystem analysis* (revealing structural trends across domains and time). Crucially, these capabilities require *structured* hierarchies with explicit definitions and splitting criteria, not merely tag matching or embedding similarity, which lack hierarchical structure and cannot distinguish a project’s functional role from its topical association. The primary beneficiaries are developers who search for, compare, and retrieve repositories by what they do, with ecosystem analysts a secondary audience; we make this intended use and its scope precise in Section 2.3. Prior work has organized software domain *terms* into IS-A ontologies [^20] [^18] that link hundreds of curated labels via hypernym relations drawn from external knowledge sources (a fundamentally different structure from a classification taxonomy whose categories are defined by splitting dimensions over actual items), or classified repositories into *predefined* category schemes [^30]. No prior work has automatically constructed a data-driven classification taxonomy at scale and classified repositories into it end-to-end.
Existing approaches each address only part of this problem, leaving critical gaps. LLM-based taxonomy methods such as Chain-of-Layer [^27] build taxonomies from pure LLM knowledge without grounding in actual data, producing well-organized structures that nevertheless fail to accommodate real repositories. This is a *depth* problem: the right *splitting dimension* (the conceptual axis along which categories are defined) at each level depends on what items actually exist, not what a language model expects. Single-pass designs inevitably miss edge cases: repositories that defy clean categorization expose coverage gaps and definition ambiguities that no sample-based design can fully anticipate, a *breadth* problem. Embedding-based clustering groups repositories by pairwise similarity but lacks the top-down semantic knowledge to choose meaningful splitting criteria at each level: it can detect *that* items are similar, but not articulate *why* they should be grouped or how siblings differ, an *interpretability* problem. Beyond these per-method limitations, none of these approaches *scale*: LLM-based methods face context-window and cost limits that prevent processing tens of thousands of items, single-pass designs accumulate uncorrected errors as the collection grows, and embedding clustering produces increasingly unmanageable flat partitions. Effective taxonomy construction therefore requires two ingredients: the semantic knowledge that LLMs provide (to choose principled splitting dimensions) and grounding in actual data distributions (to ensure categories accommodate real repositories). It further requires an architecture that processes the taxonomy incrementally, node by node, so that cost and complexity grow with tree size rather than exploding with corpus size. The key insight behind our approach is that taxonomy design must be *self-corrective*: classification failures are not noise to be discarded, but diagnostic signals that reveal how the current design is deficient, and these signals must feed back into dimension revision.

### 2.1. Taxonomy vs. Folksonomy
Section 1 defined a taxonomy as a hierarchical classification system with precise definitions and mutual exclusivity at each level, contrasting it with GitHub Topics’ flat folksonomy [^23] [^8]. The value of such hierarchies is well established in biology [^12], but software repositories pose unique challenges compared to text corpora. Items span diverse artifact types (libraries, applications, tools, frameworks), technical stacks, and functional domains. This heterogeneity demands domain-aware *dimension design* at each level rather than generic topic clustering. Existing taxonomy methods [^27] [^9] have not been applied to this setting (Section 6).

### 2.2. Motivating Scenario
Returning to the Kubernetes scenario from Section 1: GitHub Topics returns K8s *tools* (kops, minikube), K8s *documentation* (kubernetes-in-action), and K8s *extensions* (kruise), none of which are orchestration alternatives. Embedding similarity retrieves projects with similar descriptions but different purposes (e.g., kubesphere, a K8s management platform). Neither approach can distinguish a project’s *functional role* from its *topical association*.
An ATLAS-constructed taxonomy resolves this by classifying Kubernetes under Platform/Service $\to$ Container Orchestration, with true alternatives (mesos, dcos, service-fabric) as siblings in the same leaf category. This precision arises from two properties: the taxonomy defines categories with explicit *splitting dimensions* (e.g., “by deployment model”) that separate functional roles, and the iterative construction process refines categories based on actual classification outcomes. Fig. 1 illustrates how ATLAS produces such a taxonomy through its multi-agent iterative framework.

### 2.3. Intended Stakeholders and Scope
ATLAS provides a *general functional organization* of software repositories that is comparable in scope to GitHub Topics, yet hierarchical and definition-grounded. Its primary stakeholders are developers who search for, compare, and retrieve repositories by what they do, and three properties of the taxonomy address their needs. First, for *finding true substitutes*, leaf categories are defined by explicit splitting dimensions that group repositories by functional role rather than topical association, so a developer replacing one tool retrieves genuine alternatives; this yields P@1 = 85.71% on alternative discovery, above a human-curated list (Section 4.4.1). Second, for *searching at the right granularity*, the multi-rank hierarchy with per-node definitions lets a developer enter at a coarse category and drill down, giving the highest P@1 on retrieval (Section 4.4.2). Third, for *interpretable results*, every category carries a name, definition, and splitting rationale, so a developer can see *why* two projects are or are not alternatives instead of relying on an opaque similarity score. A secondary stakeholder is the ecosystem analyst, for whom the hierarchical, type-based structure (the L1 artifact-type axis) reveals structural trends—such as the library-to-AI/ML shift—that flat tags or embedding clusters do not expose (Section 5.1).
ATLAS organizes repositories by function, and other goals call for different facets. Assessing maintenance risk, license compatibility, or security posture draws on activity, license, or vulnerability axes that a functional taxonomy does not encode, and these fall outside our scope. The Dimension Stability Principle (Section 3.2) prioritizes stable, essential properties—artifact type and functional domain—that capture a repository’s enduring functional role, and because the Designer Agent’s prompt determines which dimension each node uses, the same architecture can target a different facet when one is needed.

### 3\. The ATLAS Framework
This section details each component of ATLAS: dimension design (§3.2), batch classification (§3.3), iterative refinement (§3.4), single-layer validation (§3.5), and level alignment (§3.6).

### 3.1. Overview
Constructing a taxonomy is a *schema design* problem: at each level, the system must choose the right conceptual axis, what we call a *splitting dimension*, along which to divide repositories into categories. ATLAS treats dimension design as the central challenge and classification as a subordinate execution step.
As introduced in Section 1, the framework separates taxonomy construction into a Designer Agent (dimension design) and a Classifier Agent (repository assignment), connected by a self-corrective refinement loop (Figure 1). The construction follows breadth-first, top-down traversal: at each node, ATLAS runs a *single-layer loop* (Algorithm 1) of design, classification, and refinement, followed by validation before child nodes are enqueued. Top-down construction ensures every node receives explicit names, definitions, and splitting rationale, producing an interpretable taxonomy, while BFS enables level-based checkpointing and parallelization at scale.

### 3.2. Dimension Design
The central challenge in taxonomy construction is choosing the right splitting dimension at each node. The Designer Agent must make this decision based on a *local* view (a sample of the node’s repositories) while maintaining *global* coherence with the rest of the tree. Two mechanisms address this tension.
##### Path Context.
The complete taxonomy tree cannot fit in a single LLM context window, so we provide the Designer Agent with a *path context*: the full chain of ancestor node names, definitions, and splitting dimensions from root to current node. This compressed representation of the tree-so-far serves two purposes. First, it prevents redundant dimensions: the Designer Agent can see that “functional domain” was already used at depth 1 and will not repeat it at depth 3. Second, it enforces a coarse-to-fine progression: the Designer Agent is instructed to choose dimensions that are *more specific* than those of its ancestors, ensuring granularity increases monotonically down the tree.

### 3.3. Batch Classification
The Classifier Agent assigns repositories to the categories defined by the Designer Agent, processing them in batches to amortize the cost of including the full dimension design in each prompt. For each repository, it produces an assigned category (or null if none fits), a confidence score, and a brief reasoning.
The distinction between null and low-confidence assignments enables targeted refinement. A null assignment indicates a *coverage gap*: the taxonomy is missing an appropriate category for the repository. A low-confidence assignment indicates *definition ambiguity*: category boundaries overlap, making the correct placement uncertain. This diagnostic signal lets the refinement loop (§3.4) target specific structural weaknesses rather than operating blindly.

### 3.4. Iterative Refinement
A single round of dimension design rarely produces a perfect category set, because the Designer Agent works from a sample rather than the full repository set. Classification failures (repositories that receive null assignments) reveal how the current design is deficient. The key insight is that *the pattern of failures contains diagnostic information*. Given a batch $B$ classified under dimension design $D$, let $f(x,D)$ denote the category assigned to repository $x$ under $D$ ($\bot$ if no category fits). We define the *null rate*:
$$
r_{\bot}(B,D)=\frac{|\{x\in B\mid f(x,D)=\bot\}|}{|B|}

### 3.5. Single-Layer Validation
While iterative refinement (§3.4) addresses *classification failures* (repositories that no category fits), validation addresses *structural defects* in the resulting categories before they propagate deeper.
The Designer Agent examines the child categories along with a sample of classified repositories and checks whether they satisfy the *MECE principle* (Mutually Exclusive, Collectively Exhaustive) [^13]: category definitions must not overlap, and must collectively cover the repository set without systematic gaps. Beyond MECE, the validator also checks *distinguishability*: category names and definitions must be sufficiently distinct to avoid confusion. Notably, the validator does *not* enforce balance; categories may naturally differ greatly in size, and forcing balance would distort the taxonomy’s fidelity to the data. When violations are detected, the validator suggests Merge, Split, or Rename operations, which are applied automatically with affected repositories reassigned.

### 3.6. Level Alignment
Because the Designer Agent makes locally optimal choices at each node, different branches independently select dimensions that serve the same semantic role. For instance, “UI Functional Role” in one branch and “Primary Media Type” in another both carve out a technical concern domain (R2 in Figure 1). Level alignment is a post-construction phase that discovers this implicit structure and establishes a global *dimension rank system*, grouping semantically equivalent dimensions into unified ranks and correcting any depth inconsistencies across branches.
##### Alignment Unit.
The unit of alignment is the *splitting dimension*, not the node or category. Semantic granularity is determined by the sequence of splitting dimensions along a root-to-leaf path: earlier dimensions make coarser distinctions, later ones make finer ones. Two branches at different depths have equivalent granularity if their dimension sequences cover the same conceptual scope. Aligning dimension paths is thus more fundamental than aligning node depths.

### 4.1. Research Questions
We evaluate ATLAS through three research questions:
- RQ1 (Taxonomy Quality): How does ATLAS compare to baselines in taxonomy quality?
- RQ2 (Downstream Utility): How useful is the ATLAS taxonomy for downstream software engineering tasks?

### 4.2. Experimental Setup
#### 4.2.1. Dataset
ATLAS requires repositories with sufficient textual metadata for meaningful classification. We start from all 55,083 GitHub repositories with $\geq$ 1,000 stars as of February 20, 2026, which we term *community-adopted projects*, repositories that have attracted significant developer attention [^3]. While star-based filtering has been critiqued for selection bias in code analysis studies [^11], our contribution is a taxonomy construction methodology independent of the specific population; the threshold defines the ecosystem we organize, not the validity of our method.
Repository Summaries. Raw GitHub descriptions are often too brief for reliable classification (median $\approx$ 60 characters). We construct richer representations through a two-stage pipeline. First, we extract the overview page from each repository’s DeepWiki [^5] wiki (median 9,135 characters), which provides AI-generated documentation covering architecture, functionality, and technical stack. At crawl time, DeepWiki had indexed 46,786 repositories (84.9%); we manually triggered indexing for the remaining 8,297 through DeepWiki’s web interface. After manual indexing, 696 repositories still could not be indexed (primarily non-code projects such as resource collections), leaving 54,387 repositories with successful overviews. Second, we compress each overview into a concise summary (median 982 characters) using Claude Sonnet, retaining key information about functionality, technical stack, and use cases. Generating all 54,387 summaries required 54,387 Sonnet calls ($\approx$ 148M input tokens, $\approx$ 13M output tokens), a one-time preprocessing cost shared across all methods.

### 4.3. RQ1: Taxonomy Quality
Motivation. We assess whether ATLAS’s multi-agent iterative approach produces higher-quality taxonomies than methods based on pure LLM knowledge, tag-seeded generation, embedding clustering, or one-shot generation.
Method. We run all five methods on the stratified 2k dataset and evaluate using the full metric suite (Section 4.2.4). Table 2 reports the results.
Table 2. Taxonomy quality comparison on stratified 2k dataset. Best values in bold, second-best underlined. LITE metrics are scored 0–10; TaxoAdapt, NCP, and composite metrics are percentages. Parenthesized values in NCP/TQ/TQF are from independent GPT-5.4 re-evaluation (Pearson $r=0.995$ across all 42 method–metric pairs); rankings are identical under both judges.

### 4.4. RQ2: Downstream Utility
Motivation. Beyond intrinsic quality, a taxonomy must demonstrate practical value. These two tasks instantiate the primary-stakeholder needs of Section 2.3: locating functionally equivalent projects and navigating to a category of interest. We evaluate ATLAS’s 54k taxonomy on two downstream tasks that represent complementary search scenarios: *alternative discovery* (given a known repository, find functionally similar projects) and *repository retrieval* (given a topic query, find relevant repositories). These tasks compare three fundamentally different information organization paradigms: taxonomy-based (ATLAS), tag-based (GitHub Topics), and similarity-based (embedding cosine distance).
#### 4.4.1. Alternative Discovery
Setup. Given a seed repository, each method returns a ranked list of alternatives. ATLAS retrieves repositories from the same leaf category, ranked primarily by tree distance (closer branches first) and secondarily by embedding similarity within the same distance; GitHub Topics ranks by Jaccard similarity over shared topics; Embedding ranks by cosine similarity of mpnet vectors. We use two complementary seed sets. Our primary, human-curated ground truth is *awesome-oss-alternatives* [^17] (154 seeds from RunaCapital’s curated open-source alternative directory, where categories group projects by domain rather than strict functional equivalence). To extend coverage to niche or recently created projects that curated lists may omit, we add an *LLM-generated* set (200 seeds with candidate alternatives produced by Claude Opus); because these seeds share a model family with the Designer Agent and the judge, we treat them as a secondary coverage extension rather than primary evidence. Following standard pooling methodology [^24], for each seed we merge the top-10 results from all methods, deduplicate, and assess relevance via an LLM judge (Claude Opus) in a blind setting with repository summaries only.


## Key insights
- We formulate the problem of end-to-end taxonomy construction and classification for software repositories and, to the best of our knowledge, present the first framework addressing this task at scale.
- We propose ATLAS, a multi-agent architecture that combines data-driven dimension design, batch classification with diagnostic feedback, iterative self-corrective refinement, MECE (mutually exclusive, collectively exhaustive) validation, and dimension-based level alignment.
- We introduce TQF, a composite metric that balances structural quality with practical applicability, addressing the need for holistic taxonomy evaluation.
- We evaluate ATLAS on 54,387 repositories against six baselines and two downstream tasks, with ablation and cross-model studies spanning three model families.
- RQ1 (Taxonomy Quality): How does ATLAS compare to baselines in taxonomy quality?
- RQ2 (Downstream Utility): How useful is the ATLAS taxonomy for downstream software engineering tasks?
- RQ3 (Design Decisions): What is the contribution of each design decision to the overall quality?
- Full 54k (54,387 repos): Used for RQ2 (downstream tasks) and ecosystem analysis (Section 5.1). Downstream tasks require comprehensive coverage to avoid missing relevant repositories.

## Exemplos e evidências
See original source at `Clippings/ATLAS Agentic Taxonomy of LArge-Scale Software Ecosystems.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/code-generation]]
- [[03-RESOURCES/entities/Claude]]
- [[03-RESOURCES/entities/AWS]]
- [[03-RESOURCES/entities/Uber]]
- [[03-RESOURCES/entities/Kubernetes]]
