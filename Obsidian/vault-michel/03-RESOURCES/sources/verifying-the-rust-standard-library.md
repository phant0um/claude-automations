---
title: "Verifying the Rust Standard Library"
type: source
source: "Clippings/Verifying the Rust Standard Library.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
Rust’s type system prevents many classes of memory errors, yet its standard library relies heavily on unsafe code whose correctness is validated through testing, including dynamic checks under Miri, but lacks static verification. We present what is, to the best of our knowledge, the largest verification campaign reported for a software library: an open, crowdsourced effort that integrates complementary verification tools into the continuous integration of a verification repository forked from th

## Argumentos principais
### 1 Introduction
Rust’s ownership-based type system statically prevents data races and many classes of memory errors, a guarantee that has driven adoption in operating system kernels [^9], browser engines [^1], cryptographic libraries [^7], and safety-critical embedded systems [^34]. Yet the guarantee has a gap. The Rust standard library is widely regarded as battle-tested software <sup>1</sup>, but it contains approximately 7,500 unsafe functions and 3,000 additional safe functions that internally use unsafe code. Inside these unsafe regions, correctness relies on careful manual reasoning and testing rather than on machine-checked proof [^3] [^15]. Testing, including dynamic analysis under Miri [^29], has been effective at catching many issues, but it can only exercise a finite set of executions. Verification offers a qualitatively different assurance: a machine-checked proof that a given property holds for *all* inputs, providing a permanent, auditable guarantee.
Landmark projects and industrial efforts have demonstrated that verification can scale to compilers, microkernels, cryptographic stacks, and continuous-integration workflows [^33] [^30] [^5] [^27] [^12] [^11]. However, a recent survey of 32 deployed verified systems [^23] finds that even the largest efforts verified codebases of at most hundreds of thousands of lines, required dedicated teams of verification experts, and spanned multiple person-years of effort. The Rust standard library presents a qualitatively different challenge: approximately 34,000 functions across the core, alloc, and std crates, a codebase that ships a new release every six weeks, and a contributor base that spans industry, academia, and the open-source community. Verifying it demands not only advances in verification technology but also a new model for organizing proof work at scale.
This paper reports on the first large-scale effort to prove the absence of undefined behavior in the Rust standard library. The project is organized as an open challenge program that invites contributions from any individual or team. Since its launch in November 2024, the effort has integrated four verification tools (i.e., Kani [^36], ESBMC [^18], VeriFast [^25], and Flux [^32]) into continuous integration, with four additional tools under review. An independent study of the project’s early phase is reported by Le Blanc and Lam [^8]. To the best of our knowledge, and based on the most comprehensive survey of deployed verified systems to date [^23], this is the largest verification campaign reported for a software library, both by number of functions mechanically proved free of classes of undefined behavior and by number of independent contributors.

### 2 How is Rust unsafe?
Rust’s ownership-based type system statically prevents data races and many classes of memory errors [^27], but the standard library supplements these guarantees with unsafe code that accesses five additional operations the compiler does not check for memory safety: dereferencing raw pointers, calling unsafe functions, accessing mutable statics, implementing unsafe traits, and accessing fields of unions [^28]. Importantly, unsafe Rust is still Rust, not C: the code is written in the same language and compiled by the same compiler, but the programmer takes responsibility for a small set of properties the compiler cannot verify. The borrow checker, type checking, and lifetime analysis still apply inside unsafe regions, but the soundness of these additional operations rests on the developer’s reasoning, typically recorded only in natural-language comments [^3] [^15]. Over the last three years, developers have reported over 74 soundness bugs <sup>3</sup>; 18 CVEs have been filed historically.<sup>4</sup>
Throughout this paper, *absence of undefined behavior (UB)* refers to the property that a function, when executed on any valid input, does not trigger any of the behaviors that the Rust Reference classifies as undefined [^35]. Absence of undefined behavior is a sufficient condition for memory safety, but not for full *correctness*, which additionally requires functional correctness, liveness, and security properties. The current verification tooling does not check for all classes of undefined behavior: Kani does not detect violations of the pointer aliasing rules (as formalized by Stacked Borrows [^26] and Tree Borrows [^37]), data races, invalid uses of inline assembly, or all forms of provenance-related undefined behavior. Section 4 details the precise scope of each tool, and Section 7 discusses the implications of this incomplete coverage.

### 3 Scaling the verification effort
The scale of the Rust standard library makes verification difficult to centralize within a single team or institution. To address this, we designed a community-oriented verification program, run by the Rust Foundation <sup>5</sup>, that treats the verification of the standard library as an open contest.

### 3.1 Crowd-sourcing the verification effort
Verification tasks are organized into *challenges*. Each challenge specifies a concrete verification target, a list of assumptions, explicit success criteria, and a financial reward disbursed upon completion. The status of all challenges is maintained in the project website <sup>6</sup>. Participants fork the repository, implement a candidate solution, and submit it as a pull request reviewed by a technical review committee. Accepted solutions are merged into a dedicated fork <sup>7</sup> of the Rust repository that serves as the verification target. The repository has received more than 450 pull requests from at least 21 unique external contributors affiliated with four distinct institutions. As of March 2026, the project has published 29 challenges.
Contributors specify contracts and loop invariants using the contract systems provided by the participating tools. For Kani-based Autoharness, these contracts express safety-related preconditions, postconditions, type invariants, and loop conditions targeting absence of undefined behavior. The contest welcomes any verification tool for Rust programs, and some tools go beyond safety properties: for example, the VeriFast proofs in Section 4.3 establish functional correctness of linked-list operations.

### 3.2 Tool Integration and Continuous Verification
The contest is designed to be tool-agnostic. Any verification tool is eligible, provided it can operate on the Rust standard library, can be integrated into continuous integration (CI), and provides clear soundness guarantees, typically supported by peer-reviewed publications. The project currently supports Kani <sup>8</sup>, ESBMC [^18], Flux [^32], and VeriFast [^25]. Four additional tools are under review: Verus [^31], Creusot [^17], KRust [^38], and RAPx <sup>9</sup>. This diversity is essential because no single tool can discharge all verification conditions; architecture-specific intrinsics, pointer-heavy code, concurrency primitives, and loops with complex invariants require complementary reasoning techniques. Each tool targets a different set of properties: Kani and ESBMC perform bounded model checking for memory safety violations (e.g., out-of-bounds access, null and dangling pointer dereferences, use of uninitialized memory, and arithmetic overflow), and support unbounded analysis when loops and recursive functions are annotated with loop contracts and function contracts, respectively; Flux checks refinement types that encode numeric bounds and safety preconditions; and VeriFast uses separation logic to verify absence of all undefined behavior, including pointer aliasing violations, for the functions it covers.
All verification is performed automatically through CI. The verification repository is a maintained fork of upstream rust-lang/rust, periodically synchronized so that proofs remain current. Each pull request triggers the full suite of verification tools on all active proofs; any violation is detected immediately (cf. Section 4.4). This continuous verification model, inspired by prior industrial efforts [^13] [^12] [^11], ensures that proofs remain valid across revisions and guards against regressions.

### 4 Verification progress
We automated the collection of both code and proof coverage metrics to track the state of the verification effort over time. Each CI run produces a JSON report that records, for every function in the standard library, whether a proof harness exists, whether the harness succeeded, and which tool was responsible for the proof. As of the nightly-2025-10-08 toolchain snapshot, the core, alloc, and std crates together contain 33,955 functions. The verification repository pins this toolchain version; all results below reflect verification runs against this snapshot. The metrics below cover all three crates.
Over the first sixteen months of the project, contributors manually wrote 725 proof harnesses using Kani (694 with function contracts), plus more than 50 proofs constructed with VeriFast. Because the project began with manual proof engineering, these early harnesses span a wide range of complexity, from straightforward type conversions to intricate pointer manipulations, loop-heavy algorithms, and linked data structures requiring carefully crafted preconditions and loop invariants. Figure 1 shows the growth of manually written function contracts (i.e., precondition/postcondition annotations) and their verified subset over time, broken down by function category. After an initial ramp-up driven by the first wave of challenge solutions, the rate of new contracts plateaued around October 2025. At that point, manual harnesses covered only a small fraction of the standard library’s functions, leaving the vast majority unverified. This plateau illustrates a fundamental scalability limitation: manual proof engineering alone cannot reach the tens of thousands of functions in the standard library.
Figure 1: Growth of manually written function contracts over time ( core + std ), broken down by function category: unsafe functions (marked unsafe fn ), safe abstractions (safe functions that internally use blocks), and safe (all other functions). The dashed line shows the subset of contracts whose proofs pass verification (always ≤ \\leq the total). The plateau after October 2025 motivated the development of automatic harness generation.

### 4.1 Autoharness: Design and Workflow
Autoharness <sup>12</sup> is implemented as a compiler pass inside Kani. Given a crate, it enumerates every function definition, determines which functions are eligible for automatic harness generation, and for each eligible function synthesizes a proof harness that calls the function on fully nondeterministic inputs. The generated harness is then verified by Kani’s back-end (e.g., CBMC), which checks for the absence of its supported classes of undefined behavior (UB) along all reachable execution paths.
##### Eligibility filtering.
A function is eligible if it satisfies three conditions: (i) it is *monomorphic*, i.e., it has no unresolved generic type parameters; (ii) every argument type either implements or can automatically derive the kani::Arbitrary trait, which generates a fully symbolic value covering all bit-valid representations of that type; and (iii) it is not a Kani-internal implementation function. Functions that fail any condition are recorded with a skip reason (e.g., generic, missing Arbitrary, no body, or internal) and excluded from harness generation. User-supplied include and exclude patterns can further restrict the set.

### 4.2 Manual vs. Automatic Harness Generation
Figure 2: Number of proof harnesses produced (not necessarily verified) by Autoharness vs. manual effort, across function categories ( alloc + core std, March 2026). Of the 16,748 automatically produced harnesses, 11,970 were successfully verified (Table 1 ).
Autoharness produced 16,748 proof harnesses (Figure 2), including 4,645 for unsafe functions and 1,126 for safe abstractions, an order-of-magnitude increase over the 725 manual harnesses accumulated over sixteen months. Not all produced harnesses pass verification: of the 16,748, 11,970 were successfully verified against Kani’s supported classes of UB <sup>14</sup>; the remaining 4,778 failed due to missing models, timeouts, or unsupported features.
Table 1: Autoharness verification results by function category and contract status (alloc + core + std).

### 4.3 Case Study: Verifying LinkedList with VeriFast
The results presented so far are dominated by model checking via Autoharness. The challenge system, however, also produced proofs whose guarantees are qualitatively different: they reason about unbounded inputs and establish that verified functions cannot cause UB for any well-typed caller. We describe one such proof to make this contrast concrete.
The VeriFast proof of LinkedList <sup>15</sup> targets one of the most pointer-intensive modules in the standard library: every public operation manipulates raw NonNull pointers, manually manages heap allocations, and must preserve a cycle-free invariant across insertions, removals, splits, and cursor traversals. The proof directly verifies 19 functions (e.g., push\_front, split\_off, remove\_current) and implies the soundness of 5 additional non-unsafe functions (e.g., contains, remove, drop) that call only the verified functions. For each function, the proof establishes *soundness*: the function will not exhibit UB when called by a well-typed caller.
Listing 2: Separation-logic predicate Nodes and contract for push\_front\_node. The predicate recursively asserts exclusive ownership of each heap-allocated node. The contract transfers ownership of the new node into the list.

### 4.4 Bugs Found and Fixed
The verification effort has not uncovered any previously unknown memory safety vulnerabilities in the standard library. This null result is itself informative: it speaks to the effectiveness of Rust’s existing testing infrastructure and Miri-based dynamic analysis [^29] at catching memory safety bugs before they reach production. The primary value of the verification campaign is therefore not bug-finding but the guarantee it provides: a machine-checked proof, for each verified function, that the targeted classes of undefined behavior cannot occur. Testing can demonstrate the absence of bugs on exercised inputs; verification certifies their absence on all inputs within scope.
The effort has, however, revealed concrete specification and documentation issues, summarized in Table 2: missing safety annotations, incorrect SAFETY comments, and documentation errors that misrepresented function behavior. These findings illustrate a secondary benefit: the process of writing formal specifications forces a precise articulation of safety requirements that natural-language comments alone do not provide.
Table 2: Issues found through the verification effort.

### 5 Lessons learned
We reflect on three retrospective insights from the project: the cost of community coordination, specification design for unsafe code, and the need for tool diversity.

### 5.1 Planning for Consensus and Community
Our initial planning focused on technical milestones, but we significantly under-budgeted time for activities that depended on community consensus and institutional coordination. Integrating function contracts into the Rust compiler required broad support from the language team, library maintainers, and tool authors; even technically straightforward changes stalled when stakeholders had not been engaged early. Attracting external contributors required not only financially rewarded challenges but also a spectrum of task difficulty, clear documentation, and worked examples. Coordinating with external institutions required formal legal agreements that took months to finalize. The lesson is that upstream language changes, contributor onboarding, and institutional agreements should be treated as first-class milestones with explicit timelines, not as incidental tasks.

### 5.2 Specification Design for Unsafe Code
One of the more subtle lessons concerns the design of specifications in the presence of immediate undefined behavior. Rust defines <sup>16</sup> certain violations as triggering undefined behavior at the point where an invalid value or reference is created, not when it is first used. This has implications for where and how safety properties can be expressed. Le Blanc and Lam [^8] independently identified this challenge; our experience confirms and extends their observation.
Consider slice::from\_raw\_parts, which takes a pointer and a length and returns a slice reference. If the function constructs a misaligned reference, undefined behavior occurs immediately, before any postcondition can be checked. In simple cases one can move the property into a precondition on the inputs, but for functions where the source of undefined behavior arises deeper in the call stack or depends on intermediate computations, expressing the right property as a precondition becomes much harder. We encountered this pattern in pointer-arithmetic functions, slice constructors, and transmute wrappers throughout core. The lesson is that specification languages aimed at safety verification need a principled way to express *internal* safety properties that must hold at particular program points, not only at function boundaries.

### 5.3 Tool Diversity in Practice
The initial plan relied almost exclusively on Kani, but the project evolved to include ESBMC, VeriFast, and Flux, driven by concrete technical needs. As discussed in Section 3.2, no single tool suffices: linked data structures require unbounded separation-logic reasoning, while model checking is more convenient for non-heap-intensive code. Beyond technical complementarity, the multi-tool design gives the Rust community comparative evidence on which tools and proof strategies justify their maintenance cost in a continuously evolving codebase.
This diversity has implications for the Rust contract language initiative. The experimental contract syntax adopted by the Rust language provides a shared baseline for expressing preconditions and postconditions as boolean expressions, and tools such as Kani and ESBMC can consume these directly. However, richer verification approaches require specification constructs that fall outside this baseline: VeriFast relies on separation-logic predicates and ghost state to reason about heap ownership, while Flux uses refinement types to track value-level invariants. Our experience suggests that the Rust ecosystem will need to accommodate tool-specific annotation layers alongside the common contract syntax, rather than converging on a single specification language.

### 6 Open technical challenges
Despite verifying over 10,000 functions, the Rust standard library remains far from fully verified. Many high-impact APIs, including BTreeMap internals, atomic types, String, iterators, vectors, deques, and reference-counted types, are only partially covered or not yet addressed.


## Key insights
- Verifying it demands not only advances in verification technology but also a new model for organizing proof work at scale.
- This continuous verification model, inspired by prior industrial efforts [^13] [^12] [^11], ensures that proofs remain valid across revisions and guards against regressions.
- A model checker then exhaustively explores all reachable execution paths, turning the harness into a formal verification problem rather than a test.
- To complement Autoharness, we experimented with LLM-based contract synthesis, translating natural-language SAFETY comments into function contracts.
- ### 4.3 Case Study: Verifying LinkedList with VeriFast

The results presented so far are dominated by model checking via Autoharness.
- This three-stage pipeline illustrates the engineering overhead that deductive verification tools impose relative to model checking, but also the deeper guarantees they provide.
- This null result is itself informative: it speaks to the effectiveness of Rust’s existing testing infrastructure and Miri-based dynamic analysis [^29] at catching memory safety bugs before they reach production.
- Testing can demonstrate the absence of bugs on exercised inputs; verification certifies their absence on all inputs within scope.
- As discussed in Section 3.2, no single tool suffices: linked data structures require unbounded separation-logic reasoning, while model checking is more convenient for non-heap-intensive code.
- ### 6.1 Intrinsics and Model Coverage

Of the 4,778 harnesses that fail under the standard CI settings with Autoharness, a significant subset traces back to missing models: 71 unsupported Rust intrinsics and 813 unmodeled library functions, 721 of which are LLVM-internal SIMD intrinsics.

## Exemplos e evidências
See original source at `Clippings/Verifying the Rust Standard Library.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/ai-agents/harness]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/AWS]]
- [[03-RESOURCES/entities/Rust]]

## Minha Síntese
**O que muda:** A ser analisado em revisão manual.

**Conexão pessoal:** A ser conectado com projetos/estudo atuais.

**Próximo passo:** Nenhum próximo passo imediato.
