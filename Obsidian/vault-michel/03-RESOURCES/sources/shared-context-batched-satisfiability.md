---
title: "Shared-Context Batched Satisfiability"
type: source
source: "Clippings/Shared-Context Batched Satisfiability.md"
created: 2026-06-23
ingested: 2026-06-23
score: B
tags: [articles, source-page]
---

## Tese central
Program analyzers often issue batches of SMT queries that share a large symbolic context and differ only in a small predicate. We formalize this recurring pattern as *Shared-Context Batched Satisfiability*: given a formula $\varphi$ and predicates $P$, determine whether $\varphi\land p$ is satisfiable for each $p\in P$. We study three theory-agnostic strategies for this problem: predicate-by- predicate checking, disjunctive over-approximation, and Core-Literal Filter (CLF), a new algorithm that 

## Argumentos principais
### 1 Introduction
Modern *Satisfiability Modulo Theories* (SMT) solvers are the workhorses behind a wide range of automated reasoning tasks, e.g., deciding the satisfiability for rich theories. They have become the de-facto backend for symbolic execution [^38] [^14], software model checking [^2] [^28] [^22], program synthesis [^41] [^9], automated repair [^33] [^35], and refinement types [^43] [^15]. In the industry, they defend cloud infrastructures and even validate radiation-therapy machines [^36] [^17], with companies like Amazon reportedly issuing *tens of millions* of SMT queries each day.
When analyzing real-world programs, modern program analyzers issue tens of thousands of satisfiability queries, many of which are highly correlated, such as queries that share a path condition. In this work, we focus on a recurring computational pattern: Given a fixed symbolic context $\varphi$ and a finite set of predicates, determine the satisfiability of $\varphi$ conjoined with each predicate. This arises, for instance, when verifying multiple properties under a shared path condition, or when checking a family of assertions along a symbolic execution path:
- *Active Property Checking*: In symbolic execution, a fixed path condition is conjoined with different property predicates (e.g., division-by-zero, null dereference, buffer overflow) that are checked on the same path. This yields a large number of satisfiability queries sharing a common context.

### 2 Motivating Examples
In this section, we illustrate the presence of shared-context batched satisfiability in representative tasks in program analysis.

### 2.1 Active Property Checking
In symbolic bug finding, active property checking [^19] generalizes runtime verification by checking whether a property holds for all executions that follow a given program path, rather than for a single concrete execution. This is achieved by symbolically executing the path and querying a constraint solver. If the property fails, the solver produces an input that exercises the same path while violating the property.
Concretely, given a symbolic path constraint $pc$, active checkers inject additional constraints encoding potential property violations. For example, a division-by-zero checker introduces the constraint $\phi_{\text{Div}}=(\sigma(d)\neq 0)$, where $\sigma(d)$ denotes the symbolic value of the denominator. The analysis then checks whether $pc\land\neg\phi_{\text{Div}}$ is satisfiable. If so, the resulting model yields a concrete input that triggers a division-by-zero error along the same path.
When multiple properties are checked simultaneously—e.g., buffer overflows, NULL dereferences, integer overflows, and uninitialized variables—each property $P_{j}$ contributes a constraint $\phi_{j}$. The analyzer must determine whether $pc\land\neg\phi_{j}$ is satisfiable for each $j\in{1,\dots,n}$: $\text{Check satisfiability of }pc\wedge\neg\phi_{j}\text{ for each }j\in\{1,\ldots,n\}.$ This is a direct instance of shared-context batched satisfiability, with $\varphi=pc$ and $P={\neg\phi_{1},\dots,\neg\phi_{n}}$.

### 2.2 Symbolic Abstraction
Abstract interpretation provides a general framework for sound program analysis by “executing” programs over abstract domains that over-approximate concrete program states. The connection between concrete and abstract semantics is formalized through a *Galois connection* $(\alpha,\gamma)$ between a concrete domain $(\mathcal{C},\leq_{\mathcal{C}})$ and an abstract domain $(\mathcal{A},\leq_{\mathcal{A}})$, where the abstraction function $\alpha:\mathcal{C}\to\mathcal{A}$ maps sets of concrete states to their best abstract representation, and the concretization function $\gamma:\mathcal{A}\to\mathcal{C}$ maps an abstract element back to the set of concrete states it represents.
A central challenge in abstract interpretation is the design of *abstract transformers* —abstract counterparts of concrete operations that soundly propagate abstract states through program statements. Given a concrete transformer $f:\mathcal{C}\to\mathcal{C}$, any abstract function $f^{\sharp}:\mathcal{A}\to\mathcal{A}$ satisfying $\alpha\circ f\circ\gamma\leq_{\mathcal{A}}f^{\sharp}$ is a sound abstract transformer. Among all sound choices, the *best abstract transformer* $f^{\alpha}=\alpha\circ f\circ\gamma$ is the most precise. However, this definition is non-constructive—it characterizes the desired result but provides neither a method for computing a representation of $f^{\alpha}$ nor an algorithm for applying it.
Symbolic abstraction [^46] [^30] [^37] [^12] addresses this by encoding program semantics as a formula $\varphi$ and computing the least abstract element $a\in A$ such that $[\![\varphi]\!]\subseteq\gamma(a)$. In template linear domains, abstract elements are conjunctions of inequalities with fixed linear forms and variable parameters. The abstraction problem reduces to solving optimization modulo theories (OMT) queries: $\text{max }{g_{1},\ldots,g_{n}}\text{ s.t. }\varphi$, where each objective $g_{i}$ is maximized independently.

### 3 Algorithms for Shared-Context Batched Satisfiability
In shared-context batched satisfiability, a fixed formula $\varphi$ is evaluated repeatedly under varying sets of predicates. Moreover, analyzing a single program typically involves solving many such queries. This recurring structure lends itself to various optimizations. In this section, we first review two existing strategies (§ 3.1), then present our Core-Literal Filter (CLF) algorithm (§ 3.2), and finally analyze the performance trade-offs of these strategies (§ 3.3).

### 3.1 Existing Algorithms
The Linear Scan Algorithm. A straightforward, and the most commonly used, approach is to check whether each predicate $p\in P$ is satisfiable with $\varphi$. Despite its simplicity, the number of solver calls grows proportionally with the number of predicates. In § 3.3, we will discuss the optimization of the algorithm, such as solution caching and incremental solving.
Input: An SMT formula $\varphi$ and a set of predicates $P=\{p_{1},\ldots,p_{n}\}$
Output: Whether $\varphi\land p_{i}$ is satisfiable for each $p_{i}\in P$

### 3.2 The Core-Literal Filter Algorithm
Both the linear scan and the over-approximation algorithm treat each unsatisfiable result as an isolated event. We propose a new algorithm, *Core-Literal Filter* (CLF), which extracts reusable information from every unsatisfiable result and propagates it forward to avoid redundant solver calls.
Key insight. When $\varphi\land p_{i}$ is unsatisfiable, some top-level literal $\ell$ inside $p_{i}$ may itself be inconsistent with $\varphi$, i.e., $\varphi\models\neg\ell$. If so, any future predicate $p_{j}$ that contains $\ell$ as a top-level conjunct is immediately unsatisfiable without any additional solver call involving $p_{j}$. The algorithm maintains a *forbidden literal set* $\mathcal{F}$: a set of literals $\ell$ for which $\varphi\models\neg\ell$ has been confirmed. Membership in $\mathcal{F}$ is verified by checking $\varphi\land\ell$ under the precondition alone, which is a once-per-literal cost that can then amortize over arbitrarily many future predicates.
Input: An SMT formula $\varphi$ and a set of predicates $P=\{p_{1},\ldots,p_{n}\}$

### 3.3 Algorithm Comparison
This subsection contrasts the three shared-context batched satisfiability algorithms discussed so far. Let $n=|P|$ be the number of predicates and $k\,(0\leq k\leq n)$ the number of *satisfiable* conjunctions $\varphi\land p_{i}$. All complexity figures count *solver invocations*.
Optimization Heuristics. The algorithms can benefit from standard SMT optimizations that are orthogonal and can be combined.
- *Incremental Solving (Inc)*: Use push/pop commands to avoid reasserting $\varphi$ and to trigger the internal incremental solving capability of SMT solvers. All three algorithms can benefit from Inc; the advantage is most pronounced for Linear Scan and CLF, where each query adds only a single predicate (or literal), making the delta small relative to the shared context $\varphi$.

### 4 Evaluation
We evaluate the algorithms on two real-world clients that generate SCBS queries: *symbolic abstraction* and *active property checking*. Our evaluation addresses three research questions:
- RQ1: How do the (relatively) best variants of the three algorithms compare in terms of performance? (§ 4.1)
- RQ2: What are the benefits of incremental solving and model reuse? (§ 4.2)

### 4.1 Comparison of the Best Algorithmic Variants (RQ1)
We compare the strongest representative of each algorithm family: LS-IncReuse for literal search, OA-Inc for over-approximation, and CLF for conflict-literal filtering. These three variants consistently outperform their simpler counterparts; § 4.2 analyzes the contribution of the underlying optimizations. We first present per-client results and then summarize the overall tradeoff.
Table 4: Symbolic Abstraction: Average runtime and solver invocations are computed over the 1,656 queries where all algorithms complete within the timeout; timeout rate is computed over all 3,400 queries and reports the fraction in which at least one solver call exceeds the 30-second limit.
| Algorithm | Runtime (s) | Time $\downarrow$ (%) | #Calls | #Call $\downarrow$ (%) | Timeout (%) |

### 4.2 Impact of the Optimizations (RQ2)
We examine how incremental solving and model reuse affect the algorithm’s efficiency. Figure 2 compares optimized variants against their corresponding baselines. Table 6 summarizes the speedup from each optimization.
Table 6: Summary of optimization benefits (runtime speedup). All runtimes are averaged over solved queries.
| Optimization | Symbolic Abstraction | Property Checking |

### 4.3 Impact of Problem Characteristics (RQ3)
We evaluate how two key problem characteristics—satisfiability ratio and predicate count—affect solver performance. Figure 3(a) shows runtime as a function of SAT ratio for both clients. Figure 3(b) shows runtime as a function of predicate count. All algorithms exhibit sublinear scaling, though with varying sensitivity. Table 7 summarizes the performance characteristics of each client and recommended algorithm selection.
Satisfiability Ratio. As analyzed in § 4.2, the SAT ratio affects both runtime growth and algorithm competitiveness. The implication for algorithm selection is that SAT ratio alone is insufficient to determine the best choice: both clients have similar average ratios (0.88 and 0.89), yet CLF dominates on active property checking (19 of 27 datasets) but wins only 6 of 21 solved SA cases with ratio $>$ 0.85. The decisive factor is whether CLF’s pre-screening overhead is amortized by the predicate set—smaller sets (13–27, APC) allow efficient filtering, while larger sets (20–58, SA) incur verification costs that often exceed the savings.
((a)) SAT ratio

### 5 Discussions
Applicability of SCBS. Although our focus is on formulas of the form $\varphi\land p_{i}$, the shared-context batched satisfiability (SCBS) problem generalizes to a broader class of program analysis tasks that share a common computational structure. For example, $k$ -induction [^11] [^8] [^26] [^1] extends classical mathematical induction to verify temporal properties of transition systems by considering execution traces of bounded length $k$. When verifying multiple safety properties simultaneously, both the base and inductive steps share a common formula representing the system’s transition semantics. Similarly, in invariant inference, modern guess-and-check techniques routinely generate dozens of candidates. SCBS enables efficient evaluation by batching these candidates.
CLF Budget Parameter. The forbidden-literal budget $B$ in CLF controls a trade-off between filtering power and verification overhead. A larger $B$ allows more literals to be added to the forbidden set $\mathcal{F}$, enabling more aggressive pre-screening but incurring additional solver calls for verification (Step 4 of Algorithm 3). On the valid SA queries, increasing $B$ improves CLF’s head-to-head win rate against OA-Inc from 36.3% ($B=16$) to 42.1% ($B=64$). However, a larger $B$ also increases the risk of case-level timeouts: with $B=32$, 320 SA queries return no results for *all* algorithms because CLF’s verification calls exhaust the per-case time budget. We use $B=32$ for symbolic abstraction (which has larger predicate sets, 20–58, that benefit from more aggressive filtering) and $B=16$ for active property checking (smaller predicate sets, 13–27, where a smaller $B$ suffices). $B=16$ is a safe default when the predicate set size is unknown; $B=32$ or larger may be beneficial when predicate sets are large, and the timeout risk is acceptable.
Future Work. The shared-context batched satisfiability problem raises several directions for future work. On the theory side, tighter complexity bounds remain open, potentially obtainable by exploiting structural properties of the target theory or of the predicate families. On the algorithmic side, theory-specific optimizations (e.g., theory-aware lemma caching) may reduce solver interaction and improve throughput. More robust performance may also require adaptive algorithm selection, for instance via portfolio-style combinations that hedge against solver- and instance-specific variability. Finally, integrating SCBS more deeply with domain-specific contexts (e.g., symbolic execution) may enable further optimization opportunities and scalability gains in practical applications.

### 6 Related Work
Constraint Caching for SMT. SMT solvers are integral to modern verification and synthesis tools, enabling reasoning about theories such as bit vectors, arrays, and linear arithmetic. They are widely used in various applications, such as symbolic execution [^38] [^14], software model checking [^22] [^28] [^24] [^2], program synthesis [^41] [^9], automated repair [^33] [^35], and refinement type systems [^43] [^15]. To reduce solver overhead, prior work has explored caching mechanisms to avoid redundant queries [^31] [^23] [^3] [^44] [^23]. KLEE [^13] caches path conditions and counterexamples in symbolic execution. Green [^44] caches and simplifies queries over linear arithmetic. For example, GreenTrie [^23] extends this by identifying logical implications to increase cache reuse. Utopia [^3] introduces heuristics such as Sat-delta and Unsat-footprint to distinguish satisfiable and unsatisfiable queries for more effective reuse. These systems are designed for general-purpose reuse across diverse queries that often arise from different paths or time frames. In contrast, our setting is more structured: we evaluate satisfiability over a fixed formula $\varphi$ conjoined with varying predicates $p_{i}$. We hypothesize that combining client-side optimizations can yield additional performance improvements.
Consequence Finding. Consequence finding aims to compute the logical entailments of a formula and is widely studied in deduction, such as the computation of prime implicants [^18]. In the context of circuit verification, equality inference for Boolean functions [^7] is a well-established technique; identifying equivalent sub-circuits can significantly reduce the complexity of equivalence checking. In SMT, congruence closure is a standard method for inferring equalities from conjunctions involving uninterpreted functions [^10]. In program analysis, consequence finding manifests in various forms, including quantifier elimination [^4] [^27] [^4] [^25], interpolation [^40] [^39] [^32], and implied equalities [^6]. Shared-Context Batched Satisfiability can be applied to identify consequences of a fixed formula $\varphi$ with respect to a set of candidate predicates. This restricted form of consequence finding enables localized reasoning within a fixed context.
Predicate Abstraction. Introduced by Graf and Saïdi [^20], predicate abstraction is a foundational technique in program verification [^5] [^29] [^21], which constructs abstractions of infinite-state systems by tracking the truth values of a selected set of predicates. Although early tools implemented predicate abstraction directly, modern verification frameworks typically employ refined variants, including lazy abstraction with interpolants [^32] and implicit predicate abstraction [^16] A related body of work investigates symbolic abstraction [^37], which seeks the best over-approximation of a formula within a given abstract domain, such as finite-height domains [^37], template linear domains [^34] [^12] [^46], polyhedral domains [^42], In contrast, shared-context batched satisfiability focuses on determining the satisfiability of a predicate in conjunction with a fixed formula, which can serve as a low-level primitive for designing and implementing other algorithms.

### 7 Conclusion
Shared-Context Batched Satisfiability is a recurring computational pattern that arises in various applications, yet it has remained hidden in plain sight—buried in implementation details rather than celebrated as the fundamental primitive it truly is. This paper formalizes the problem, introduces the CLF algorithm, and empirically compares three strategies. We advocate a more systematic exploration of the algorithmic design space to uncover structure-aware optimizations.
[^1]: O. M. Alhawi, H. Rocha, M. R. Gadelha, L. C. Cordeiro, and E. Batista Verification and refutation of c programs based on k-induction and invariant inference. International Journal on Software Tools for Technology Transfer (STTT’21). Cited by: §5.
[^2]: L. Alt, S. Asadi, H. Chockler, K. E. Mendoza, G. Fedyukovich, A. E. Hyvärinen, and N. Sharygina (2017) HiFrog: smt-based function summarization for software verification. In International Conference on Tools and Algorithms for the Construction and Analysis of Systems, pp. 207–213. Cited by: §1, §6.


## Key insights
- Active Property Checking*: In symbolic execution, a fixed path condition is conjoined with different property predicates (e.g., division-by-zero, null dereference, buffer overflow) that are checked on the same path. This yields a large number of satisfiability queries sharing a common context.
- A precise formalization of the shared-context batched satisfiability problem.
- A new forbidden-literal–driven algorithm (CLF), which extracts forbidden literals from unsatisfiable checks to pre-screen subsequent predicates.
- A systematic analysis and evaluation of three algorithmic approaches with respect to their theoretical properties and practical performance. The implementation is available at [).
- Division-by-zero: $\phi_{1}=(x-6\neq 0)$, i.e., $x\neq 6$.
- NULL pointer: $\phi_{2}=(p\neq\text{NULL})$.
- Array bounds: $\phi_{3}=(0\leq x<10)$.
- If $\varphi\land\Psi$ is satisfiable, the SMT solver returns a model $M$. The algorithm iterates through each predicate $p_{i}\in P$ and evaluates whether $M\models p_{i}$. If a predicate $p_{i}$ is satisfied by $M$, then $\varphi\land p_{i}$ is marked as satisfiable and removed from $P$ (Line 2).
- First, with $P=\{p_{1},p_{2},p_{3},p_{4},p_{5}\}$, the algorithm constructs disjunction $\Psi=(x=2)\lor(x>3)\lor(x<0)\lor(x=4)\lor(x\leq 5)$. The solver returns model $M_{1}=\{x=2\}$ for $\varphi\land\Psi$, which satisfies $p_{1}$ and $p_{5}$. These predicates are marked as satisfiable.
- Second, with $P=\{p_{2},p_{3},p_{4}\}$, the new disjunction yields model $M_{2}=\{x=4\}$, which satisfies $p_{2}$ and $p_{4}$. These are marked satisfiable and removed.

## Exemplos e evidências
See original source at `Clippings/Shared-Context Batched Satisfiability.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/transformer]]
- [[03-RESOURCES/concepts/ai-agents/benchmark]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/Microsoft]]
- [[03-RESOURCES/entities/Azure]]
