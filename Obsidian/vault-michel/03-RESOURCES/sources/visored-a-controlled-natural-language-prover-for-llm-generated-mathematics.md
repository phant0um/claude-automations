---
title: "Visored: A Controlled-Natural-Language Prover for LLM-Generated Mathematics"
type: source
source: "Clippings/Visored A Controlled-Natural-Language Prover for LLM-Generated Mathematics.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
We present a dependent-type-based prover designed around the way LLMs (and humans) tend to write mathematics, complementing existing systems such as Lean and Rocq. Its core design choices are a surface that imitates mathematical natural language and a rule-driven automation layer that closes the routine steps a textbook would omit, so that an accepted proof can be re-emitted as a checked Lean file. Early experiments suggest that, even without any prover-specific training data, LLMs can learn to 

## Argumentos principais
### 1 Introduction
Large language models (LLMs) have become increasingly capable mathematical reasoners, both on standard benchmarks and, more recently, at the level of competition and research-level mathematics. They nevertheless still suffer from hallucination [^17] [^15], so an AI-produced proof is only as trustworthy as the process that checks it, and the most striking recent results still relied on substantial human verification before they could be reported. As more mathematics is produced with AI assistance, the binding constraint shifts from *generating* ideas to *verifying* and *organizing* them at scale. Autoformalization, the task of mapping informal mathematical writing into machine-checkable form, is one concrete instance of that bottleneck: if AI-generated proofs are to be absorbed by the mathematical community rather than accumulating as unverified candidates, the route from informal prose to a kernel-checked proof has to become much more reliable than it currently is. This paper presents one attempt in that direction.
One line of work removes the human from the loop with a small, auditable kernel that returns a definite yes/no on a candidate proof, independent of the model that produced it (the de Bruijn criterion [^31] [^30]). Whole-proof theorem provers now drive miniF2F [^50] pass rates close to saturation (Appendix A), but they take an *already formalized* statement as input. Turning informal prose into that statement and its proof, the autoformalization step itself, lags well behind [^44] and is where most of the non-local surface-to-semantics decisions are made.
The separation is not just a user-experience (UX) issue. Informal and formal mathematics are not identical artifacts: informal prose leans on shared background, controlled abuse of notation, implicit side conditions (“for $x$ sufficiently large”, “WLOG $x\neq 0$ ”), and implicit number-system and coercion choices ($\mathbb{N}$ vs. $\mathbb{Z}$ vs. $\mathbb{R}$) that readers fill in automatically. A direct translation must therefore commit to many decisions with no surface trace in the prose: the right library lemma, subtype, edge-case convention (how a library defines $1/0$ or $0^{0}$), tactic, and integer/rational cast. Each is non-local, and getting one wrong rarely surfaces as a compiler error (those are quick to fix) but as a silent semantic drift: a statement that compiles yet no longer says what the prose claimed, or a goal that looks plausible but is unprovable for a reason several rewriting steps upstream.

### 2 Related Work
Visored draws together several earlier schools of prover design. It shares the controlled-natural-language surface of Mizar and Naproche [^38] [^24], the typecheck-time well-definedness of PVS [^28] [^33], the dependently-typed substrate of Lean and Rocq, and the cost-budgeted rule-driven solving of ProofGrader [^47], and it adopts the LLM-centric framing of the recent autoformalization literature [^46] [^18] [^48]. We do not claim any individual ingredient is novel; what is new is their integration into a single LLM-facing pipeline whose checkable intermediate representation makes failures localized rather than a single accept/reject after a Lean compilation. Appendix A gives the full discussion: the broader progress of AI for mathematics that motivates the autoformalization bottleneck, and a detailed comparison with each prior school, namely direct LLM autoformalization and whole-proof Lean models, CNL provers, natural-language tactic layers, rule-based proof checkers, and typecheck-time well-definedness.

### 3 Architecture
Figure 2: The Visored pipeline. Each stage lowers the previous stage’s output into a more constrained form or refuses with a localized diagnostic that points at the offending source span (dashed; any stage can refuse, not only the two drawn). Visored’s verdict, accept or diagnostic, is produced by the solver and does not pass through Lean. Once a proof is accepted, the dotted branch optionally transcribes it, together with the recorded derivation steps, to UVL MIR and then to a Lean file for external kernel re-checking.
Visored is itself a prover. Given a LaTeX document (proof content lives inside example environments) plus a small set of config and spec files, it returns its own verdict — accepted, or a structured diagnostic pointing at the specific source location where elaboration or the solver failed. The Lean emitter is an optional downstream stage that re-expresses an accepted proof as a Lean file for users who need external verification or interoperability with the Lean ecosystem; Visored’s correctness does not pass through Lean.
The pipeline (Figure 2) is a sequence of stages where each stage either lowers the previous stage’s output into a more constrained form or refuses with a diagnostic. We describe each stage by what data it produces and what an LLM gains from being able to inspect that data.

### 4 Worked Example
To make the value proposition concrete, the three examples below show the same kind of object written two ways: a Visored CNL input (left column) and the kind of Lean source an existing LLM autoformalization pipeline would have to produce directly (right column). The CNL stays close to what an LLM is already fluent at producing; the Lean additionally requires the LLM to pick the right Mathlib lemmas and tactics, which is the part of the pipeline where current direct-autoformalization systems report the largest pass-rate gap. All three pairs are checked automatically by the artifact Makefile: the CNL passes Visored and the Lean compiles against Mathlib.
Visored CNL input (typeset)
###### Example 1.

### 5 Intended Usage
Visored is designed to be useful in four modes inside an LLM workflow. Each addresses a different point at which an LLM workflow currently lacks reliable mathematical feedback. The four are design intent rather than measured outcomes in this first paper: Section 6 reports a coverage study closest to the autoformalizer mode, and Section 7 lists exercising the modes as future work. Throughout this section we use *low-level prover* to mean a kernel-checked theorem prover with a code-like surface, such as Lean, Rocq, or Isabelle.
#### Inference-time verifier.
At deployment, Visored sits alongside the LLM as a real-time mathematical checker: the LLM emits a CNL draft, Visored either accepts it or returns a localized diagnostic, and the user sees only formally-checked output while the interaction surface stays in natural language. This is the deployment shape an end product would want — a math chatbot, tutoring system, or research assistant that does not silently emit a hallucinated proof, without forcing the user to read formal-prover syntax to know whether the answer is correct.

### 6 Experiments
We report a single, deliberately narrow result and do not oversell it. This first version of Visored is meant as a prototype: its purpose is to work out the fundamental design issues across the four layers it is built from — the CNL *syntax*, its *semantics*, the *solver*, and *Lean transpilation* — not to be a finished, competitive prover. It is consequently an older system that has accumulated substantial technical debt, and what follows is not an independent benchmark but a coverage study on one split of miniF2F [^50], conducted while the system was still being built. The number should be read as a lower bound on what the design can already express, not as a tuned, competitive pass rate.
#### Setup.
We work on miniF2F-valid (244 problems). A single LLM coding agent (Claude, driving Visored through a documented skill that describes the CNL surface language and how to write and verify proofs in it) is handed each problem’s formal statement as a CNL prefix and asked to finish the proof. The loop is the ordinary agentic one: the agent drafts proof steps, runs the Visored CLI, reads the diagnostic on failure, and revises. When a step exposed a gap — a deduction a mathematician would consider routine but that Visored could not close — we recorded it and, where feasible, added the corresponding rule to the library before continuing. The valid split therefore served as *both* our development set and our evaluation set, and no bounded retry or sampling budget was imposed. This is exactly the kind of co-development that makes the result a statement about expressivity, not about held-out generalisation.

### 7 Limitations and Future Work
We state current limitations honestly because they are concrete and addressable, not foundational.
#### Math scope.
The current rule databases and prelude cover arithmetic, basic algebra, set theory, elementary number theory, and parts of real analysis. Categories of miniF2F that require, e.g., heavy combinatorial enumeration or sophisticated inequality manipulation are currently out of scope; supporting them is a matter of adding rules, not changing the foundation.

### A.1 Progress of AI for Mathematics
LLMs built on the Transformer [^39] have become capable mathematical reasoners, with steady progress on benchmarks such as GSM8K [^7], MATH [^13], and miniF2F [^50], and further gains from math-specialized pretraining as in Minerva [^20] and Llemma [^3]. At the top of competition mathematics, two results from the same lab one year apart are telling: AlphaProof reached IMO 2024 silver by writing *formal* (Lean) proofs via reinforcement learning (RL) [^11], while a Gemini Deep Think configuration reached IMO 2025 gold writing proofs in *natural language*, graded like human contestants [^12]. That the higher medal went to the informal-reasoning system is part of why we keep a prover’s surface close to natural language.
Beyond competition mathematics, AI has begun to contribute to research-level open problems. AlphaEvolve improved or matched the state of the art on dozens of them, including Erdős’s minimum-overlap conjecture and kissing-number bounds in dimension 11 [^26]; three Erdős problems fell to AI-assisted constructions in one week of late 2025, each verified by Terence Tao [^36]; and an OpenAI reasoning model beat the long-conjectured grid optimum for the 1946 Erdős planar unit-distance problem [^14]. Smaller academic efforts follow the same pattern: ThetaEvolve improves best-known bounds on circle packing and an auto-correlation inequality with an 8B open model [^42], a follow-on autonomous-agent scaffold tightens the Ramsey number $R(3,17)$ for the first time in decades and lifts $R(4,15)$ past the AlphaEvolve record [^41], and LLM-generated geometric lemmas raise the certified lower bound for the Steiner ratio, the Gilbert-Pollak conjecture [^19]. Tao [^10] [^35] [^37] reads this shift as moving the binding constraint from generating mathematical ideas to verifying and organizing them at scale. That is exactly what Visored targets: not another proof-search engine, but infrastructure for checking and organizing AI-produced informal mathematics.

### A.2 Prover Designs
We position Visored against four families of work an AI audience is likely to know: (i) direct LLM-based autoformalization, (ii) controlled-natural-language (CNL) provers, (iii) human-friendly natural-language tactic layers on top of existing provers, and (iv) rule-based proof checkers for structured natural-language proofs.
#### Direct LLM autoformalization and whole-proof Lean models.
The natural baseline is to fine-tune or prompt an LLM to map an informal statement and/or proof directly to Lean or Isabelle source. Wu et al. [^46] establish the basic setup for Isabelle/HOL and report state-of-the-art on miniF2F at the time. Draft, Sketch, and Prove [^18] extends this by first drafting an informal proof, sketching a formal skeleton, and letting an automated theorem prover fill the gaps. A fast-moving line of whole-proof Lean models has since pushed pass rates much higher: DeepSeek-Prover and its V2 [^48] [^32] scale synthetic data and reinforcement learning targeting Lean 4; STP [^9] trains a conjecturer and a prover against each other to escape the limited supply of formal data; Goedel-Prover and its V2 [^21] [^22] add scaffolded data synthesis and verifier-guided self-correction; Kimina-Prover [^40] trains a large formal reasoning model with long-form reasoning; and Seed-Prover [^6] adopts lemma-style proving, reporting that it saturates miniF2F while solving most recent IMO problems. Two things separate this line from Visored. First, these systems take an *already formalized* statement as input and produce a proof, whereas Visored’s input is the informal LaTeX surface; the hard surface-to-semantics decisions sit upstream of where these provers begin. Second, the natural checkpoint of an end-to-end pipeline is the final Lean file as a whole, so per-attempt feedback to the LLM is typically a single accept/reject after compilation. Visored instead keeps a checkable IR at every stage, so failures are localized to a specific sub-expression and the per-stage diagnostic is itself usable as a denser reward signal. This is a design difference, not a critique: end-to-end translation and stage-by-stage elaboration are complementary points in the design space.

### Appendix B Syntax
This appendix describes the surface language and the parser that turns it into a Visored syntax tree. The vocabulary — both the sentence templates and the LaTeX commands they wrap — lives in external.lpcsv (lisp-csv) spec files. Extending Visored to recognize a new sentence form or a new LaTeX command is a matter of adding entries to those files; the parser is not touched.

### B.1 Sentence templates
Proof content lives inside example environments and is structured into sentences. The sentence-template vocabulary maps natural-language patterns to abstract syntactic constructors. Representative entries:
> ```
> ‘Let {formula}‘                                       => let

### B.2 Notional propositions
“ $X$ is $P$ ” constructions are recognized as predicate applications, with positive and negated natural-language forms declared together so that *“ $X$ is non-empty”*, *“ $X$ is not empty”*, and *“ $X$ is nonempty”* all parse to $\neg\mathrm{empty}(X)$. The current vocabulary covers
> prime, even, odd, empty, finite, infinite, injective, surjective, bijective,
each in several surface variants (“is finite”, “is a finite set”, “is an injection”, “is an injective function”, “is not an injection”, …).

### B.3 Existential introductions
Existential introduction is one of the constructs where natural mathematical prose is the most varied. The same constructor is reached by all of the following surface forms (and more):
> ```
> ‘There exists {x} such that {p}‘           => let_such

### B.4 LaTeX math vocabulary
Inside the formula slot of any template, the user writes ordinary LaTeX math. Each LaTeX command is matched against an entry in the math-vocabulary spec files, which pin down its arity, fixity, and meaning. The base vocabulary covers:
- Number systems and propositional types: $\mathbb{N},\mathbb{Z},\mathbb{Q},\mathbb{R},\mathbb{C}$, $\mathsf{Prop}$, $\mathsf{True}$, $\mathsf{False}$.
- Constants: $e$, $\pi$, $i$.

### B.5 Environments
Document-structure environments are recognized but mostly transparent: example, proof, theorem, lemma, corollary, proposition, equation, align, matrix, pmatrix, cases, itemize, enumerate, figure, table. Proof content must live inside a proof-bearing environment such as example; structural environments outside that scope are ignored.


## Key insights
- Foundation. Naproche translates ForTheL into first-order logic. Visored is dependently typed, which is what lets the same proof be re-expressed in a dependently typed target like Lean 4.
- Number systems and propositional types: $\mathbb{N},\mathbb{Z},\mathbb{Q},\mathbb{R},\mathbb{C}$, $\mathsf{Prop}$, $\mathsf{True}$, $\mathsf{False}$.
- Constants: $e$, $\pi$, $i$.
- Comparison and equivalence: $=,\neq,<,\leq,>,\geq,\equiv,\approx$.
- Set relations and operations: $\in,\notin,\subseteq,\supseteq,\subsetneq,\cup,\cap,\setminus$, $\bigcup,\bigcap$.
- Logical connectives and quantifiers: $\land,\lor,\neg,\to,\leftrightarrow,\forall,\exists$.
- Arithmetic: $+,-,\cdot,\times,/,\frac{}{}$, $\pm$, $\bmod$, $\pmod{}$.
- Number theory: $\mid,\nmid$, $\gcd$, $\mathrm{lcm}$, $\binom{}{}$.
- Big operators: $\sum,\prod,\int$, $\lim,\sup,\inf,\max,\min$.
- Common functions: $\sin,\cos,\tan,\log,\ln,\exp,\sqrt{\,}$.

## Exemplos e evidências
See original source at `Clippings/Visored A Controlled-Natural-Language Prover for LLM-Generated Mathematics.md` for detailed examples, data, and benchmarks.

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
- [[03-RESOURCES/entities/AWS]]
- [[03-RESOURCES/entities/Rust]]

## Minha Síntese
**O que muda:** Este estudo reforça que we present a dependent-type-based prover designed around the way llms (and humans) tend to write mathematics, complement — impacta diretamente como projetar e avaliar agentes.

**Conexão pessoal:** Conecto isso ao meu trabalho com Hermes Agent e o vault-michel: preciso aplicar este padrão nos meus fluxos de ingestão e consolidação.

**Próximo passo:** Implementar um experimento prático com este conceito nos próximos ciclos de desenvolvimento do vault.