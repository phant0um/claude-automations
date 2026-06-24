---
title: "N-Version Programming with Coding Agents"
type: source
source: "Clippings/N-Version Programming with Coding Agents.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
This paper revisits the classical concept on N-version programming in the setting of contemporary AI coding agents. Revisiting the seminal Knight–Leveson experiment, we study whether diversity across agent systems, models, and implementation languages creates diverse failure modes. Using the Knight–Leveson’s, Launch Interceptor Program Specification, we evaluate 48 agent-generated implementations on a shared oracle and a campaign of 1,000,000 randomized test inputs.

## Argumentos principais
### I Introduction
N-version programming (NVP) promises reliability through diversity: multiple independently produced implementations of the same specification are executed in parallel, and a voting rule masks individual faults. Its classical reliability argument, however, depends on a strong condition: the versions must fail independently, or at least be diverse enough that coincident failures remain rare. That assumption was challenged in the human-programmer era: the seminal Knight–Leveson experiment showed that independently developed human implementations of the same specification still exhibited substantial common-mode failure [^15].
AI coding agents make this question relevant again [^11] [^25]. Compared with recruiting independent human teams, it is now straightforward to generate many implementations of the same task while varying three key components: the coding agent, the underlying foundation model, and the target programming language. With agentic coding, the central question of N-Version Programming remains unchanged: do the generated variants behave like independent versions, or do they converge to the same latent defects?
This paper revisits the classical N-Version Programming literature in the modern agentic setting. We design and perform a reproduction of the original Knight–Leveson experiment with AI coding agents. We also revisit the broader questions about N-version software: whether the considered diversity mechanisms reduce fault correlation, which shared fault families dominate, and whether redundancy helps even if fault independence fails.

### II Background
Figure 2: Experimental workflow for revisiting Knight–Leveson with agentic coding: (1) version generation by each agent against the LIP specification, (2) oracle-based acceptance screening on 200 independently drawn random cases (all must pass), (3) shared one-million test campaign across admitted versions, and (4) statistical analysis (Knight–Leveson z -statistics, pairwise correlation analysis). Versions that fail acceptance are excluded from the campaign and from all downstream analyses.

### II-A N-Version Programming
N-version programming was proposed by Chen and Avizienis [^6] as a software analog of hardware N-modular redundancy. The design calls for $N$ independent teams to implement the same specification from a common requirements document, then execute all versions in parallel on each input and determine the output by majority vote or other consensus mechanism. Avizienis [^3] formalized the reliability model: provided that the failure events of distinct versions on any given input are mutually independent and that individual failure probabilities are small, the probability of majority failure decreases exponentially with $N$.

### II-B N-Version and Fault Independence
The idealized reliability benefit of NVP is entirely contingent on fault independence. Eckhardt and Lee [^9] provided a theoretical treatment showing that independence cannot be assumed as a matter of principle. Because all versions are developed from the same specification, and because specifications are finite and sometimes ambiguous, there exists a nonzero set of inputs for which the specification is underspecified or misinterpreted in a common way. Programmers who share a training background, a programming language, or exposure to the same reference materials will tend to make the same misinterpretation, creating systematic coincident failure modes. Littlewood and Miller [^18] extended this analysis, arguing that the very process of translating a specification into code creates correlations among any set of implementations derived from it.
#### The Knight–Leveson Experiment (1986)
The Knight–Leveson experiment [^15] was an empirical test of fault independence in NVP. Twenty-seven programmers from two universities independently implemented the ”Launch Interceptor Program” specification, working without mutual communication. Their implementations were evaluated against a reference implementation on one million randomly drawn test cases. Of the 24 versions with nonzero failure rates, failures were strongly correlated: the observed count of simultaneous failures exceeded the expectation under independence by a statistically significant margin. Subsequent work by the same team [^5] examined the coincidental faults, finding that a small number of fault categories accounted for the majority of coincident events. These faults were most prominently related to implementations of specific geometric computations required by the specification. Hatton [^12] conducted a partial replication with a different benchmark and similarly found that independence was not achieved.

### II-C The Launch Interceptor Specification
The specification for a ‘Launch Interceptor Program’ (LIP) was defined by NASA [^8] and used in the original Knight–Leveson study. The implementation task is to implement a DECIDE function that computes a missile launch authorization decision, given $n$ planar radar data points with Cartesian coordinates and a set of parameters representing incoming threats. The implementation is not trivial because several functions involve non-trivial geometric computations that are known fault attractors [^5].
The computation is specified with four stages: (1) the *Conditions Met Vector* (cmv), a vector of 15 Boolean Launch Interceptor Conditions (LICs), each encoding a geometric predicate on subsets of the input points; (2) the *Preliminary Unlocking Matrix* (pum), a $15{\times}15$ Boolean matrix derived from the cmv and a programmer-supplied Logical Connector Matrix (lcm) whose entries are ANDD, ORR, or NOTUSED; (3) the *Final Unlocking Vector* (fuv), a 15-element Boolean vector derived from pum column-wise conjunctions; and (4) the scalar launch decision, which is true iff all fuv entries are true.
The Launch Interceptor Program is well suited to randomized testing: its input domain is (1) large, (2) the input types are simple (floating-point and enumeration parameters), and (3) random sampling covers the full condition space.

### II-D Coding Agents as N-Version Generators
Contemporary AI coding agents represent a qualitatively new kind of software developer. Chen et al. [^7] demonstrated that LLMs trained on code can solve a substantial fraction of programming challenges; and modern coding agents can use tools, and perform iterative self-correction, and long-horizon planning [^13]. Unlike earlier program synthesis systems, these agents are able to operate from general-purpose, natural language specifications. Recent work such as Galapagos [^22] has begun to exploit LLMs to construct functionally equivalent variants for N-version deployments.
Our present paper asks whether AI coding agents can generate diverse program versions whose failures behave like the independent faults assumed by classical N-version programming studies, or whether they reproduce the same kinds of correlated failure modes those studies repeatedly found in practice.

### III Experimental Methodology
We design and perform an original experimental plan, that both replicates and extends the Knight–Leveson experiment.

### III-A Research Questions
The core idea is to ask distinct coding agents to implement the same specification: LIP. From there, we answer five research questions:
RQ1. (Generation Capabilities) To what extent are AI coding agents able to implement the LIP specification?
We first ask whether modern coding agents can serve as generators of complete program versions from the seminal LIP specification. This inquiry is a necessary condition for collecting a sufficiently large and varied set of working implementations for comparative analysis in the subsequent questions.

### III-B Methodology Overview
At a high level, we answer the research questions by reproducing the Knight–Leveson experimental structure faithfully. Table I summarizes which elements are carried over directly and the extent of which the experimental design has been adapted for AI coding agents. As summarized in Table I, we preserve the original acceptance filter, campaign size, failure definition, and primary Knight–Leveson hypothesis test.
| Dimension | Knight–Leveson (1986) | This Study |
| --- | --- | --- |

### III-C Version Generation with LLMs
Five AI coding agent systems serve as the “programmers” in our study: Cursor [^2], Claude Code [^1], OpenAI Codex [^7], Gemini [^10], and OpenCode [^21]. Each agent is configured with a list of underlying models spanning, where applicable, multiple vendors and generations as described in Table II. We configure Cursor with the Composer models; Claude Code with Anthropic’s Haiku, Sonnet, and Opus variants; Codex with multiple GPT-5.x revisions; Gemini with its 2.5 and 3.x preview variants; and OpenCode with Qwen and Gemma models.
The functional specification given to every agent is the original Knight–Leveson specification document, preserved verbatim as the authoritative source of truth for all conditions, LICs, and realcompare semantics. Agents are additionally given: a file with 15 input/output examples, and a reference realcompare implementation. The agents also receive a short directive that describes the provided information, input and output formats, and the expected deliverable ([Python](), [Rust](), or [Pascal]()). No algorithm is suggested in the prompt, no code skeletons are provided.
| Harness | Models |

### III-D Oracle and Acceptance Testing
This part of the methodology defines the reference implementation and the admission filter that determines which generated versions are eligible for the main campaign.
We develop a reference implementation of DECIDE in Python, validated by an automated test suite of 82 unit tests covering all known boundary conditions for the 15 LICs. This reference implementation serves as the oracle for differential testing: on every campaign input, each admitted version and the oracle implementation are both evaluated, and the version is recorded as failing on that case if any of its 241 output bits differs from the oracle’s. This matches the failure definition used by Knight–Leveson.
Before entering the main test campaign (see III-E), each generated version undergoes an acceptance screening, using the terminology of the original Knight–Leveson protocol.

### III-E Main Test Campaign
At this stage, versions that crash immediately or fail any acceptance test have been filtered out. Therefore, the main campaign will only analyze implementation-level disagreements among the admitted versions. We draw uniformly $T=1{,}000{,}000$ test cases at random from the input domain using a fixed seed to ensure reproducibility. All admitted versions are evaluated on exactly the same set $T$ against the oracle. For all test runs, we record metadata: coding agent, model, language, and a binary pass/fail outcome. The resulting failure data is the common measurement for the rest of the paper: (1) aggregate coincident failures are used for the statistical analysis in RQ2; (2) stratified pairwise overlaps are used for the cross-language and cross-agent analysis in RQ3; and (3) majority-vote simulations are used for RQ5.
For failed test runs, we also record the input that caused the failure, as well as the specific CMV, PUM, FUV, or LAUNCH oracle mismatches. These fault records are later aggregated at LIC level and linked back to representative implementations and triggering inputs for RQ4.

### III-F Failure Correlation Statistical Analysis
We implement an exact replicate of the Knight–Leveson statistical framework [^15] to answer RQ2. Let $N$ be the number of admitted versions, $T$ the number of campaign test cases, $f_{i}$ the failure count for version $i$, and $p_{i}=f_{i}/T$ the empirical failure rate. Let $K$ denote the number of test cases on which *two or more* versions fail simultaneously. $K$ is the aggregate measure of failure overlap: it counts how often the test campaign encounters an input on which independent implementations break at the same time.
We use the $z$ -statistic to test the observed distribution of failures against an approximate normal distribution of failures. Specifically, under the null hypothesis H <sub>0</sub> that failures are mutually independent Bernoulli events:
$$

### III-G Cross-Language and Cross-Agent Failure Analysis
RQ3 asks whether implementation language and coding agent behave as meaningful axes of diversity, rather than as wrappers around the same failure mode. We answer that question by reusing the full pairwise failure data from RQ2 and stratifying it along the diversity dimensions directly available in the experiment.
To study language diversity, we partition the full pairwise set into cross-language pairs and inspect their $\phi$ distribution. This asks whether changing implementation language tends to decorrelate failure behavior in the observed population.
Third, to study agent diversity, we partition the same pairwise set into same-agent and cross-agent subsets and compare their $\phi$ distributions. This asks whether crossing an agent boundary decorrelates failures, or whether similar failure profiles remain common even across different tools.

### III-H Root Cause Analysis
We identify the sources of correlated faults by manually analyzing failures patterns. Because the 15 LIC predicates form the main functional decomposition inside DECIDE, they provide a natural first unit for fault localization. First, we count how many distinct \[harness, model, language\] triples fail on each LIC, and we stratify those LIC-level counts by target language and by coding agent. Then, we trace those failures back to implementation choices in the generated source code, and compare against the oracle and the specification.


## Key insights
- First, it provides a systematic experimental framework for studying fault independence and reliability in agent-generated software, faithful to Knight–Leveson.
- Second, it shows that modern coding agents can feasibly generate enough versions to cheaply perform N-Version programming at scale.
- Third, it measures and demonstrates failure overlap across \[harness, model, language\] diversity axes. Most of the errors can be traced back to weaknesses in the specification.
- Fourth, it shows that majority voting N-version units do provide practical reliability gains, despite fault correlation.

## Exemplos e evidências
See original source at `Clippings/N-Version Programming with Coding Agents.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/Claude]]
- [[03-RESOURCES/entities/OpenAI]]
- [[03-RESOURCES/entities/Codex]]
- [[03-RESOURCES/entities/Gemini]]
- [[03-RESOURCES/entities/Rust]]
- [[03-RESOURCES/entities/Python]]

## Minha Síntese
**O que muda:** A ser analisado em revisão manual.

**Conexão pessoal:** A ser conectado com projetos/estudo atuais.

**Próximo passo:** Nenhum próximo passo imediato.
