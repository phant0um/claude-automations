---
title: "Analyzing the Analyzers: Model Counting Meets Abstract Interpretation"
type: source
source: "Clippings/Analyzing the Analyzers Model Counting Meets Abstract Interpretation.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [articles, source-page]
---

## Tese central
Abstract interpretation offers a principled foundation for static analysis by approximating concrete program semantics via abstract domains. However, quantitatively comparing the precision of different domains remains a longstanding challenge. We present MCAI (Model Counting meets Abstract Interpretation), a new methodology that employs model counting to measure the precision of abstract domains.

## Argumentos principais
### 1 Introduction
Abstract interpretation [^12] [^15] is a foundational framework that enables sound reasoning over potentially infinite sets of concrete program states by mapping them into abstract values in an abstract domain. An abstract domain encodes approximations of concrete states, enabling tractable static analyses. Given a Galois connection between a concrete domain $C$ and an abstract domain $A$, the best abstract transformer $f^{\#}:A\to A$ is $f^{\#}=\alpha\circ f\circ\gamma$, where $f$ is the concrete transformer, and $\alpha$ and $\gamma$ are the abstraction and concretization functions, respectively. This definition establishes the theoretical upper bound on the precision achievable within a given abstract domain.
Despite significant advancements in abstract interpretation, a critical challenge remains: How can we objectively evaluate and compare the precision of abstract transformers? Consider a program fragment with constraints $x\geq 0\land y\geq 0\land x+y\leq 10$, where $x$ is an integer variable. The interval domain approximates this as $x\in[0,10]\land y\in[0,10]$. The octagon domain can express $x\geq 0\land y\geq 0\land x+y\leq 10$ precisely. While the octagon domain is more precise in this case, we lack systematic methods to quantify how much more accurate it is, especially when dealing with complex bit-precise semantics.
Quantitative evaluation of abstract domains is essential for tracking scientific progress and guiding the development of practical tools. Benchmarking enables comparative analysis across domains and supports informed engineering decisions. Existing benchmark suites have been widely adopted for evaluating static analysis tools, such as DaCapo [^6] and OWASP [^18]. Prior work has also explored domain-specific metrics for assessing the precision of abstract transformers [^26] [^16] [^32]. However, these efforts suffer from two key limitations:

### 2 Preliminaries
Abstract Interpretation. Our work is based on the Galois connection framework within the context of abstract interpretation. Given two complete lattices $(C,\leq_{C})$ and $(A,\leq_{A})$, a pair of functions—an abstraction function $\alpha:C\to A$ and a concretization function $\gamma:A\to C$ —forms a Galois connection if, for any element $c\in C$ and $a\in A$, $\alpha(c)\leq_{A}a\Leftrightarrow c\leq_{C}\gamma(a)$. This relationship between the concrete domain $C$ and the abstract domain $A$ ensures that reasoning in the abstract domain safely over-approximates behaviors in the concrete domain.
Best Abstract Transformer. Given a concrete transformer $f:C\to C$, the *best abstract transformer* $f^{\alpha}:A\to A$ that over-approximates $f$ is defined as: $f^{\alpha}=\alpha\circ f\circ\gamma:A\to A.$ This is the most precise sound abstraction of $f$ in the abstract domain $A$ since, for any other sound abstraction $f^{\#}$, it holds that $f^{\alpha}(a)\leq_{A}f^{\#}(a)$ for all $a\in A$. <sup>1</sup> Despite its theoretical significance, this definition is non-constructive, meaning it does not necessarily provide an algorithm to compute the most precise transfer function $f^{\alpha}$. Furthermore, the composition of the best abstractions of two functions $f$ and $g$ does not always yield the best abstraction of their composition $f\circ g$.
Computing the Best Abstraction. A practical method to compute the best abstraction is symbolic abstraction [^30], which finds the strongest consequence of a formula $\varphi\in\mathcal{L}$ that is expressible within an abstract domain $A$. Specifically, given a formula $\varphi$ representing the concrete semantics and an abstract domain $A$, symbolic abstraction computes the best approximation of $\varphi$ in $A$. Depending on the clients, the formula $\varphi\in\mathcal{L}$ may encode different language constructs, such as the concrete transformer for an instruction, a basic block, or a loop-free program fragment. Symbolic abstraction is beneficial in two key ways: it facilitates the automatic synthesis of optimal transformers and mitigates precision loss when composing multiple transformers.

### 3 Problem Statement
Abstract domains provide sound over-approximations of program behavior, but this soundness comes at the cost of precision. Quantifying the precision of abstract transformers is therefore essential for evaluating and improving static analyses grounded in abstract interpretation. A key challenge is measuring the loss of precision and comparing domains in a principled, domain-agnostic manner [^32] [^26]. Existing precision metrics have two key limitations. First, they are often client-specific, entangling domain precision with analysis behavior. Second, they typically assess abstract elements in isolation or rely on dynamic traces, which offer limited semantic coverage.
This paper proposes Model Counting Meets Abstract Interpretation (MCAI), a methodology that enables such an evaluation by combining logical encoding with model counting. MCAI has two primary objectives:
- Client-Independent Quantification: a general-purpose metric for abstraction loss that does not rely on specific analysis goals or client heuristics;

### 4 Model Counting Meets Abstract Interpretation
This section introduces the MCAI framework, which leverages symbolic characterizations of both concrete and abstract semantics, along with model counting, to assess and quantify the precision of abstract domains. We first define the semantics of programs and abstract elements, then introduce model counting as a mechanism for precision measurement, and finally show how these notions provide a new lens on completeness in abstract interpretation.
Figure 1: Illustration of an example of a concrete semantics formula and its best abstraction in the interval and octagon domain. With 3-bit unsigned bit-vector arithmetic, an unexpected false positive area in the octagon domain is caused by addition overflow. The underflow of subtraction also influences $x-y$.

### 4.1 Formalizing and Measuring Abstraction Precision
To measure abstraction precision, we begin by representing both concrete program semantics and abstract elements as logical formulas. This standard representation allows us to analyze their relationships using model-theoretic tools.
###### Definition 1
Let $\varphi$ be a formula representing the concrete semantics of a program. The set of concrete states satisfying $\varphi$ is denoted by $\llbracket\varphi\rrbracket=\{M\mid M\models\varphi\}$, where $M$ is a truth assignment over the variables in $\varphi$.

### 4.2 Comparative Precision Between Abstract Domains
After quantifying the imprecision of individual abstractions, we now explore how different abstract domains compare in their over-approximation behavior.
###### Definition 6(Abstract Domain-Specific False Positives)
Let $A$ and $B$ represent two abstract domains. For a given formula $\varphi$, the false positives can be categorized as:

### 5 Implementations and Applications
Implementations. We have implemented MCAI as a modular analysis framework comprising nearly 5,000 lines of Python code. MCAI operates by encoding the concrete semantics and abstracting them as logical formulas.
Figure 2 illustrates MCAI’s architecture, consisting of two main components:
Figure 2: Illustration of the architecture and overall workflow of MCAI.

### 6 Evaluation
This section presents our evaluation by studying the following research questions:
- RQ1: What is the precision of best abstractions with respect to concrete semantics across different domains (§ 6.1)?
- RQ2: How do different abstract domains compare quantitatively in terms of precision and false positive rates (§ 6.2)?

### 6.1 Precision of Best Abstraction (RQ1)
To evaluate precision, we measure two complementary metrics for each formula $\varphi$ and abstract domain $A$:
- *False positive rate* (FPR): The proportion of spurious models among all models captured by the abstraction.
- *Precision*: Defined as $1-\text{FPR}$, indicating how closely the abstract semantics approximates the concrete semantics.

### 6.2 Comparing Different Abstract Domains (RQ2)
This section presents a comparative analysis of pairs of domains to identify which domains perform better overall and which provide complementary or redundant information.
To begin, we generate scatter plots where each point represents a benchmark formula. The coordinates on the plot correspond to the precision values of two domains for that formula. Figure 5 displays three such comparisons: (a) Interval vs. Zone, (b) Interval vs. Octagon, and (c) Interval vs. KnownBit. The $x=y$ diagonal line denotes equal precision for both domains on a given formula. From these plots, several trends emerge:
- Most formulas lie close to the diagonal in the Figures 5(a)-(b), indicating that these domains tend to produce very similar levels of precision;

### 6.3 Constraint Redundancy within the Octagon Domain (RQ3)
The Octagon abstract domain is known for its ability to express linear constraints involving sums and differences of variables. While it is more expressive than simpler domains, such as Interval or Zone, this increased expressiveness comes at a computational cost. Thus, a natural question arises: do all categories of constraints within the Octagon domain contribute meaningfully to its precision, or are some types effectively redundant in practice?
To investigate this, we decomposed the Octagon domain into three constraint categories based on their structural form:
- *Interval*: Constraints of the form $\pm x\leq c$;

### 6.4 Performance Analysis of MCAI (RQ4)
In this subsection, we evaluate the computational cost of MCAI across different abstract domains. We measured two key performance metrics:
- *Abstraction Time*: The time required to compute the best abstraction via symbolic abstraction.
- *Counting Time*: The time required to perform model counting.

### 7 Discussions
Several directions remain for applying and extending MCAI, both to analyze abstract interpreters and to improve their design.
Evaluating Non-optimal Transformers. We focus on the best abstractions, which represent the ideal precision achievable in a domain. In practice, transfer functions are often approximate due to performance trade-offs, heuristics, or solver limitations. MCAI can quantify the precision gap between an implemented transformer and the domain’s best abstraction for the same concrete semantics. Given a concrete formula $\varphi$ and an analyzer-produced abstract element $a$ (or its symbolic concretization $\varphi_{a}$), MCAI can compute (i) the false positive rate of $\varphi_{a}$ with respect to $\varphi$, and (ii) the additional imprecision relative to $\alpha_{A}(\varphi)$.These metrics support fine-grained diagnosis of precision bottlenecks. For instance, MCAI enables differential testing across analyzer versions or configurations; it can flag regressions and help localize precision loss.
Evaluating Redundancies in Fixpoint Iteration. Prior work [^22] has shown that fixpoint iteration often introduces constraints that are not necessary for proving the final invariant, especially when joins and widenings accumulate redundant information. MCAI can be adapted to quantify such redundancies by measuring the marginal contribution of constraints to the overall reduction in false positives. For example, for a sequence of iterates $a_{0}\sqsubseteq a_{1}\sqsubseteq\cdots\sqsubseteq a_{k}$ (or the constraints constituting a single iterate), MCAI can measure how much each step reduces the spurious-model set relative to the concrete semantics. This yields an empirical basis for simplifying invariants, compressing intermediate states, or designing more effective join/widening strategies that preserve “useful” constraints while discarding those with negligible semantic impact.

### 8 Related Work
Evaluating Abstract Domains. Several researchers have addressed the challenge of quantifying precision loss in abstract interpretation. [^26] evaluated numerical domains by comparing the minimal set of linear constraints that encode their abstract values; smaller sets indicate greater precision. [^16] compared various relational domains using specific benchmark programs, measuring their ability to verify array-bound checks and related properties. Similarly, [^31] quantitatively compared static analyses for specific client applications. [^32] proposed a framework that measures interval domain precision by comparing the volume of the abstract element with the volume of the concrete set it represents. However, none of these approaches leverage model counting to directly measure the semantic gap between abstract elements and concrete semantics as MCAI does.
Completeness in Abstract Interpretation. The concept of completeness in abstract interpretation was first explored by [^13], who distinguished between sound approximations and complete ones. [^21] provided a constructive characterization of complete abstract interpretations and introduced property-specific notions of completeness. [^20] further developed techniques to systematically refine abstract domains to achieve completeness with respect to specific properties. More recently, [^8] explored completeness for specific logical fragments, showing how to design domains that precisely capture certain classes of properties. Our work contributes to this line of research by quantifying incompleteness via model counting. Rather than a binary notion of completeness, MCAI offers a spectrum that quantifies the degree of incompleteness.
Model Counting in Program Analysis. Model counting solvers [^33] [^10] [^34] [^17] [^19] have emerged as valuable tools in program analysis [^19] [^17] [^27], enabling quantitative reasoning about program behaviors. These solvers have been applied to a range of domains, including probabilistic symbolic execution [^7] [^1] [^2], quantitative information flow [^3] [^4], and automated attack synthesis [^5]. For example, we can quantify the probability of satisfying a path condition or measure information leakage under a given observation model. A recent survey by [^9] provides a comprehensive overview of these applications. MCAI extends this line of work by introducing a quantitative notion of semantic precision for abstract domains. It evaluates and compares abstractions by measuring their divergence from the concrete semantics.

### 9 Conclusion
Rigorous evaluation is essential for advancing static analysis. We have presented MCAI, a quantitative approach for evaluating the precision of abstract domains with respect to the concrete semantics. We have applied MCAI to four abstract domains, demonstrating its utility for systematically comparing domain precision and providing insights into designing new abstract domains.
[^1]: A. Aydin, L. Bang, and T. Bultan (2015) Automata-based model counting for string constraints. In International Conference on Computer Aided Verification, pp. 255–272. Cited by: §8.
[^2]: A. Aydin, W. Eiers, L. Bang, T. Brennan, M. Gavrilov, T. Bultan, and F. Yu (2018) Parameterized model counting for string and numeric constraints. In Proceedings of the 2018 26th ACM Joint Meeting on European Software Engineering Conference and Symposium on the Foundations of Software Engineering, pp. 400–410. Cited by: §8.


## Key insights
- A common belief is that more expressive domains, such as Octagons, inherently offer superior precision. We find that the Interval domain often achieves precision comparable to that of the Octagon domain, with average precision scores of 76.1% versus 77.2%, respectively.
- Many constraints within the Octagon domain are redundant, particularly the “plus” constraints, which contribute negligibly to precision improvement while significantly increasing computational overhead.
- The KnownBit domain consistently outperforms word-level domains, achieving a mean precision of 85.7% compared to 76-77% for numerical domains, suggesting that bit-level reasoning captures structural properties that numerical abstractions miss.
- Model counting over bit-vector formulas proves tractable for practical analysis, with median analysis times ranging from 0.48 seconds for Interval to 4.65 seconds for Octagon on our benchmark suite of 2,006 formulas.
- We develop a model-counting-based methodology to quantitatively evaluate the precision of abstract domains and their semantic differences relative to concrete semantics.
- We systematically compare four abstract domains, revealing new insights into their relative precision and computational trade-offs.
- We make our tool publicly available at [).
- Client-Independent Quantification: a general-purpose metric for abstraction loss that does not rely on specific analysis goals or client heuristics;
- Concrete-Semantics Alignment: evaluating how closely an abstract transformer approximates the behavior of its corresponding concrete transformer.
- Common false positives*: States that are false positives in both domains:

## Exemplos e evidências
See original source at `Clippings/Analyzing the Analyzers Model Counting Meets Abstract Interpretation.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/transformer]]
- [[03-RESOURCES/concepts/ai-agents/benchmark]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/Python]]

## Minha Síntese
**O que muda:** A ser analisado em revisão manual.

**Conexão pessoal:** A ser conectado com projetos/estudo atuais.

**Próximo passo:** Nenhum próximo passo imediato.
