---
title: "A Compositional Language for Property Graphs"
type: source
source: "Clippings/A Compositional Language for Property Graphs.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
A major shortcoming of the recently standardized graph query languages GQL and SQL/PGQ is their lack of compositionality. Given the importance of these languages in querying knowledge graphs, we address this shortcoming and propose both theoretical solutions and a path to adding them to the new standards. The highlight of the non-compositionality problem is that while both GQL and SQL/PGQ can express graph reachability and all first-order queries, they fall short of the problems in NLOGSPACE.

## Argumentos principais
### 1 Introduction
Knowledge graphs are an essential tool used by most major enterprises for organizing, integrating, and reasoning over complex data. Their widespread use led to a robust market that is expected to grow tenfold in the next decade. Most knowledge graphs utilise one of the basic underlying models: *RDF graphs* or labeled property graphs (LPG). Several recent market analyses portray the split between these two models as about equal, or perhaps with a slight 60-40 edge to LPGs.<sup>1</sup> The decision which model to use hinges upon a particular application area. If fast traversals and analytics are needed (common in, e.g., finance, supply chain, logistics, and cyber security applications), then LPGs are usually chosen. On the other hand, if reasoning and ontologies become crucial (common in healthcare, government, and linked data), the RDF model is often preferred.
##### The State of Query Languages for LPGs.
For the RDF model, we have the SPARQL query language, standardized in 2008. Its definition has been through several revisions, is well accepted by industrial stakeholders, and has been subject of a significant research effort on understanding its semantics, expressiveness, and various extensions [^32] [^35] [^33] [^20] [^34] [^3] [^21] [^23] [^5]. The academic community played a crucial role in its design, pointing out design flaws [^32] [^3] [^26] that have been fixed in the language standard.

### 2 Preliminaries
We assume that $\mathit{Lab}$, $\mathit{Key}$, $\mathit{Val}$, and $\mathit{Var}$ are infinite sets of *labels*, *property names* (or *keys*), *values*, and *variable names*, respectively. Moreover, given a set $A$, we denote by $\mathit{Fin}(A)$ the set of all finite subsets of $A$.
###### Definition 1.
A *property graph* is a tuple $G=(N,E,\mathit{src},\mathit{tgt},\mathit{lab},\mathit{prop})$ where:

### 3 Regular Path Queries with Variables
In this section, we introduce the notion of regular path query with variables (RPQV), which play a prominent role in the query language for property graphs introduced in this paper. To this end, we first need to define the conditions that can be included in such expressions. More precisely, a condition $\mathit{cond}$ is defined by the following grammar, where $x,y\in\mathit{Var}$, $c\in\mathit{Val}$, and $k,k_{1},k_{2}\in\mathit{Key}$:
$$
\begin{aligned}

### 3.1 Semantics
Let $G=(N,E,\mathit{src},\mathit{tgt},\mathit{lab},\mathit{prop})$ be a property graph and $p$ be an annotated path in $G$. For a variable $x$, we define $\mathit{last}(p,x)=o$ if either $(o,S)$ or $[o,S]$ is the last annotated graph element of $p$ such that $x\in S$. The semantics of RPQVs is mutually recursive between the semantics of conditions $\mathit{cond}$ and expressions $\mathit{rgx}$. We write $p_{1}\xrightarrow{G,\mathit{rgx}}p_{2}$ to indicate that annotated path $p_{2}$ is reachable from annotated path $p_{1}$ in $G$ through the expression $\mathit{rgx}$, and write $p\models_{G}\mathit{cond}$ to say that $p$ satisfies a condition $\mathit{cond}$ in $G$. We first define $p\models_{G}\mathit{cond}$:
- $\mathit{cond}$ is $x.k_{1}=y.k_{2}$, with $\mathit{last}(p,x)=u$, $\mathit{last}(p,y)=v$, $\mathit{prop}(u,k_{1})$ is defined, $\mathit{prop}(v,k_{2})$ is defined, and $\mathit{prop}(u,k_{1})=\mathit{prop}(v,k_{2})$;
- $\mathit{cond}$ is $x.k=c$ with $\mathit{last}(p,x)=u$, $\mathit{prop}(u,k)$ is defined, and $\mathit{prop}(u,k)=c$;

### 3.2 Notation and Examples
In an expression of the form $\mathit{rgx}(x,y)$, we refer to $x$ and $y$ as *boundary variables*. We will use GQL-style infix notation and write $\mathit{rgx}(x,y)$ as $(x)\ \mathit{rgx}\ (y)$, or $[x]\ \mathit{rgx}\ (y)$, etc., depending on whether the boundary variables are nodes or edges. This notation cannot express all RPQVs because, in general, it can happen that $x$ binds to a node for some answers and to an edge for other answers, but it is sufficient for all our examples. Furthermore, we omit the explicit concatenation operator / to improve readability. This is standard in formal languages and is also done in GQL and SQL/PGQ.
###### Example 4.
The RPQV

### 3.3 Number of Output Paths and Complexity
We note that $\llbracket{\mathit{rgx}(x,y)}\rrbracket_{G}$ can be infinite if the graph $G$ has cycles. Practical languages solve this issue by imposing that the paths $p$ should be *shortest*, *simple* (no repeating nodes) or *trails* (no repeating edges) [^9] [^13] [^12] [^14]. The same restrictions can be applied to RPQVs and are independent of the design of RPQVs themselves. In fact, it makes much sense to study RPQVs *without* these restrictions, because evaluation problems for RPQs without list variables are typically in NLOGSPACE [^8] [^30]. These problems become NP-complete if constraints such as simple paths [^30] [^4] and trails [^28] are added, even on undirected graphs [^29].
Ideally, we would therefore have RPQVs that can be evaluated in NLOGSPACE, even if the mechanism for forcing them to match a finite number of results may render evaluation NP-complete. An additional argument for our approach is that it is well-known that compact representations of the infinitely many paths that match RPQs can be computed in linear time [^27] [^11]. This means that a query engine could internally use this representation (similar to how we implement factorized databases [^31]) and we do not need to force their result set to be finite.
Regarding complexity, for each fixed RPQV $\mathit{expr}$, consider the following problem $\mathsf{Eval}(\mathit{expr})$: Given a graph $G$ and binding $f$, is $f\in\llbracket{\mathit{expr}}\rrbracket$?

### 4 The Query Language #Datalog
$\#\textsc{Datalog}$ (pronounced *hash-Datalog*) is a simple graph transformation language that uses Datalog with safe negation and with RPQVs in the bodies. A *$\#\textsc{Datalog}$ program* is a sequence of *computation* and *update* programs. The role of computation programs is to compute the necessary information for defining a new graph, including the IDs of new nodes and edges to be generated. Update programs specify the concrete relations $\mathit{node}$, $\mathit{edge}$, $\mathit{src}$, $\mathit{tgt}$, $\mathit{lab}$, and $\mathit{prop}$ that constitute the new graph. In order to create new node IDs and edge IDs, rules
$$
\displaystyle A(\bar{x})\ \leftarrow\ B_{1}(\bar{y}_{1}),\ldots,B_{n}(\bar{y}_{n}),\lnot C_{1}(\bar{z}_{1}),\ldots,\lnot C_{m}(\bar{z}_{m})

### 4.1 A Guided Tour of #Datalog
We now look at a few examples that illustrate the capabilities of $\#\textsc{Datalog}$. For space reasons, we provide its fully formal definition in Appendix 4.2.
##### A Simple Graph Transformation.
Assume that $G_{1}$ is the property graph

### 4.2 The Formal Definition of #Datalog
To define $\#\textsc{Datalog}$ programs, we first need to define the notions of *computation* and *update programs*. A computation program is a set of Datalog rules defined over a property graph that produces a set of intensional predicates. An update program is a set of rules defined over those intensional predicates that produces a property graph. In this way, a sequence of computation/update programs produces a sequence of property graphs.
#### 4.2.1 Computation Programs.
Formally, a *computation program* $\Pi_{\textit{comp}}$ is a non-recursive Datalog program whose rules are of the form († ‣ 4), where (i) each extensional atom $B_{i}(\bar{y}_{i})$ and each extensional atom $C_{j}(\bar{z}_{j})$ is either an RPQV expression or one of the relational atoms $\mathit{node}(x)$, $\mathit{edge}(x)$, $\mathit{src}(x,y)$, $\mathit{tgt}(x,y)$, $\mathit{lab}(x,y)$, $\mathit{prop}(x,y,z)$ that define the components of a property graph; (ii) $\bar{x}$, $\bar{y}_{1}$, $\ldots$, $\bar{y}_{n}$, $\bar{z}_{1}$, $\ldots$, $\bar{z}_{m}$ are tuples of variables such that $\bar{x}\subseteq\bar{y}_{1}\cup\cdots\cup\bar{y}_{n}$ and $\bar{z}_{1}\cup\cdots\cup\bar{z}_{m}\subseteq\bar{y}_{1}\cup\cdots\cup\bar{y}_{n}$;<sup>2</sup> and (iii) no list variable occurs in two of more of the sequences $\bar{y}_{1}$, $\ldots$, $\bar{y}_{n}$, $\bar{z}_{1}$, $\ldots$, $\bar{z}_{m}$. Notice that the second condition only allows rules with safe negation, while the third condition enforces joins of predicates in the body of a rule to be performed on boundary variables (cf. Section 3.2), not on list variables.

### 4.3 No expressiveness holes
We conclude this section by showing that the unusual expressiveness gaps described in the introduction do not arise in $\#\textsc{Datalog}$.
###### Proposition 8.
$\#\textsc{Datalog}$ can express every query in NLOGSPACE.

### 4.4 Extension: Aggregation
It is easy to extend the formal semantics of $\#\textsc{Datalog}$ with aggregation functions. The most straightforward extension is aggregation on lists, allowing atomic statements such as length $(z)=x$ for a list variable $z$. In this case, the variable $z$ should be guarded, i.e., provided to us by an RPQV. Other standard list aggregates available in GQL and SQL/PGQ can be added analogously. Using this addition, it becomes possible to write more interesting transformations. The following example (similar to the one in the body of the paper) transforms every path from Megan to Mike in the original graph into a single edge and adds a property “length” to it, in which it puts the length of the respective path.
$$
\begin{array}[]{rl}\mathit{Megan}(x)&\leftarrow(x)\;(y)\langle y.\mathit{owner}=``\text{Megan}"\rangle\;(x)\\

### 5 A Syntax Proposal for GQL and SQL
We describe the key ingredients of the proposal that will be communicated to the ISO working groups for GQL and SQL. We propose two separate additions that are backward compatible: we thus do not propose to change the existing behavior, *which is a must for the ISO committee*. The first change concerns the behavior of *patterns*, by incorporating different behaviors of RPQs and different treatment of variables that can be bound to single elements and/or lists. The second change incorporates some of the features provided by $\#\textsc{Datalog}$.

### 5.1 Additional Pattern Flexibility
In terms of the language design, we start with the following basic principles:
1. more symmetry: paths need not start and end with a node;
2. all variables in a pattern can be list variables, except *boundary variables*;

### 5.2 Achieving Compositionality in GQL
Our proposal for language enhancement is based on GQL’s idea — borrowed from Cypher — of linear of pipelined evaluation, see [^9] [^12] and a theoretical model in [^15]. We outline its key ideas next. A GQL query is a sequence of *clauses*, and the mechanism of passing information between them is called a *binding table*. That is, a clause $C$ takes two inputs: a graph and a table. The graph, however, *is always the input graph $G$* and it is only the table that evolves. Thus, a GQL sequence of clauses $C_{1}\ C_{2}\ \cdots\ C_{n}$ produces
$$
C_{n}\Big(\ G,\ \cdots\ C_{2}\big(\ G,C_{1}(G,T_{()})\ \big)\cdots\Big)\;,

### 6 Conclusion
With RPQVs and $\#\textsc{Datalog}$ we have designed two independent mechanisms that, if adopted by the GQL and SQL/PGQ standards, will fill their known expressivity gaps. Either one separately solves the gap known as the “increasing values on edges” query. This is not a randomly chosen query: it is of such importance to the standards committee that an entirely new mechanism of post-processing paths with a sliding window was proposed to express it [^25] [^40].
RPQVs and $\#\textsc{Datalog}$, however, both show how the problem can be addressed using mechanisms that are close to those that already exist in the standards. RPQVs can express the query by adopting a fully symmetric treatment of nodes and edges in the design of path pattern expressions. The rule-based system of $\#\textsc{Datalog}$ can express it since it can transform a graph to its dual, on which the existing GQL mechanism for path matching can express the query.
Combining RPQVs and $\#\textsc{Datalog}$ allows for complete compositionality: a free flow of information back and forth between graph querying and relational processing in GQL. This is in particular manifested by the capture of all NLOGSPACE queries, which is currently only possible with a significant complexity cost. Our concrete proposal to ISO includes several fallback options to help our main ideas get across and improve this situation for the standards.


## Key insights
- Every pattern language expresses the graph reachability problem;
- GQL and SQL/PGQ can express all first-order queries; and
- graph reachability is NLOGSPACE-complete under first-order reductions.
- If $g_{1}=(u,S_{1})$ and $g_{2}=(u,S_{2})$, then $g_{1}\bowtie g_{2}=(u,S_{1}\cup S_{2})$.
- If $g_{1}=[v,S_{1}]$ and $g_{2}=[v,S_{2}]$, then $g_{1}\bowtie g_{2}=[v,S_{1}\cup S_{2}]$.
- If $g_{1}=(u,S_{1})$ and $g_{2}=[v,S_{2}]$ with $\mathit{src}(v)=u$, then $g_{1}\bowtie g_{2}=(u,S_{1})[v,S_{2}]$.
- If $g_{1}=[v,S_{1}]$ and $g_{2}=(u,S_{2})$ with $\mathit{tgt}(v)=u$, then $g_{2}\bowtie g_{2}=[v,S_{1}](u,S_{2})$.
- If $p_{1}=\varepsilon$, then $\mathit{concat}(p_{1},p_{2})=p_{2}$.
- If $p_{2}=\varepsilon$, then $\mathit{concat}(p_{1},p_{2})=p_{1}$.
- If $p_{1}=g_{1}\cdots g_{n}$ and $p_{2}=g_{1}^{\prime}\cdots g_{m}^{\prime}$, with $n\geq 1$ and $m\geq 1$, and $g_{n}$ and $g_{1}^{\prime}$ are joinable, then $\mathit{concat}(p_{1},p_{2})=g_{1}\cdots g_{n-1}(g_{n}\bowtie g_{1}^{\prime})g_{2}^{\prime}\cdots g_{m}^{\prime}$.

## Exemplos e evidências
See original source at `Clippings/A Compositional Language for Property Graphs.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/security]]
- [[03-RESOURCES/concepts/llm-ml-foundations/inference]]
- [[03-RESOURCES/concepts/software-engineering/proof]]
- [[03-RESOURCES/entities/AWS]]

## Minha Síntese
**O que muda:** GQL e SQL/PGQ têm gaps de composicionalidade — #Datalog com RPQVs preenche esses gaps capturando todas as queries em NLOGSPACE, propondo mudanças backward-compatible ao ISO.

**Conexão pessoal:** A composicionalidade é um princípio que se aplica ao vault — queries Obsidian (Dataview, links) precisam ser composicionais para que resultados intermédios possam ser reusados.

**Próximo passo:** Avaliar se #Datalog pode inspirar patterns de query composicional no vault para cross-referencing entre concepts.
