---
title: "ScratchLens: Lens-Parametric Behavioral Equivalence for Scratch Programs"
type: source
source: "Clippings/ScratchLens Lens-Parametric Behavioral Equivalence for Scratch Programs.md"
created: 2026-06-23
ingested: 2026-06-23
score: B
tags: [concurso, source-page]
---

## Tese central
Two Scratch programs can be syntactically far apart through renamed variables, split scripts, extracted custom blocks, and reordered initialization, while preserving the same behavior. A one-block edit, such as replacing a blocking broadcast with an asynchronous one, can create divergences that surface only under specific schedules. Behavioral equivalence for such programs is central to automated feedback, grading support, and repair validation.

## Argumentos principais
### I Introduction
Scratch is a large, real software ecosystem for introductory programming. More than 140 million children have created over a billion projects in it [^33]. At this scale, automated feedback, grading support, repair validation, and hint generation all face the same question: when should two student programs be treated as behaviorally equivalent? The question is hard because Scratch programs are small event-driven systems: sprites, clones, variables, lists, monitors, broadcasts, ask queues, pen and sound effects, and renderer-visible state run on a cooperative green-thread VM [^34]. The same behavior admits many syntactic realizations (renames, script splitting, procedures, additive-update rewrites), while a one-block edit can change behavior through scheduling, random tokens, or frame timing; dropping broadcast and wait, for example, removes a join edge whose absence may appear only when a receiver is slow.
This setting makes Scratch a compact stress test for software engineering methods. The language and environment were designed for broad creative programming [^30] [^21], and repository studies show that learners solve similar tasks through diverse block structures, sprites, and control decompositions [^1]. An equivalence checker used by graders, feedback systems, or repair validators needs to preserve that diversity. It should accept correct refactorings across solution styles and reject causal changes that alter what a learner, tutor, or grader can observe.
Program comparison tools need to control false alarms on refactorings and false equivalence claims on real bugs. Tree differencing [^9] [^45] over-approximates syntax because script boundaries and block order are not semantic; single-run dynamic comparison under-approximates behavior because it samples one schedule, random stream, and input trace [^40]. In the debugging tutor that motivates ScratchLens, false equivalence is especially costly: it ends a learner’s debugging episode with the defect still present.

### II Running Example
Figure 1 distills the comparison problem that recurs throughout the paper. Program A is a reference game fragment: a bowl initializes score and lives, asks the apple to reset, and increments score when the bowl touches the apple. The apple reset handler hides the sprite, moves it to a random top-row position, and shows it again.
Figure 1: Running example. A distant refactoring (A/B) is equivalent, while a one-block change (B/C) removes the broadcast join edge and becomes visible under event-causal and frame-observing lenses.
Program B looks very different from Program A: it renames variables, sprites, and messages; splits initialization into two green-flag scripts; extracts the reset logic into a custom block; and rewrites change score by 1 as an assignment. A tree differencer sees many edits. The programs are behaviorally equivalent: resources admit a bijection, the initialization scripts write disjoint variables and commute, the custom block has the same canonical body as the original receiver, and the additive update normalizes to the same transaction.

### III A Taxonomy of Behavioral Divergence
The taxonomy asks, for each behavioral divergence, what mechanism causes it, which lenses observe it, and which typed root cause a checker should report. We derived it from the VM’s semantic carriers (Section IV) and cross-checked it against LitterBox bug patterns [^13] [^12].

### III-A Axis 1: Observation Lenses
A lens is a projection from concrete traces to observations. Table I lists the lenses ScratchLens supports. $L_{\mathit{default}}$ is the union of frame-visible, stage-visible, monitor, and event-causal observations; it corresponds to what an attentive user of the running project can perceive. Lenses form a partial order when one projection includes another’s observations. We use “stronger” only for comparable lenses; for incomparable projections, ScratchLens reports a verdict vector indexed by lens.
TABLE I: Observation lenses. Each preserves a subset of trace information; $L_{\mathit{default}}$ combines the middle four.
| Lens | Preserved observations |

### III-B Axis 2: Causal Phenomena
We organize supported Scratch divergences into eight carrier families. Each row of Table II names the phenomenon, the weakest lens family under which it becomes observable, the typed root causes ScratchLens reports for it, and the semantic carrier that CSIR must preserve. Operator manifests in the artifact map these rows to generated mutations (Section VIII-A).
TABLE II: Taxonomy of behavioral divergence. “Lens floor” is the weakest lens family that observes the phenomenon; comparable stronger lenses inherit the difference.
| Phenomenon | Carrier | Lens floor | Typed root causes |

### IV-A Concrete Configurations
We model a Scratch project as a transition system over configurations
$$
C=(\Sigma,\Theta,H,A,K,E,F,O),

### IV-B Lens-Parametric Equivalence
A lens $L$ projects concrete traces to observations (Table I). Two projects are equivalent under $L$ when every admissible environment, random, time, and input stream produces equal $L$ -projected traces, modulo alpha-renaming, stuttering of $L$ -unobservable transactions, reordering of independent same-trigger transactions, and permutation of indistinguishable clone families. The schedule quotient treats the relative order of distinct same-trigger scripts as nondeterministic and reports dependence on it as a race (Section VI).
The quotient preserves each lens-visible cut. Stuttering erases only $L$ -unobservable transactions; broadcast joins remain visible under $L_{\mathit{event}}$, redraw boundaries under $L_{\mathit{frame}}$, and monitor toggles under $L_{\mathit{monitor}}$. The alpha-renaming component is typed as well: a stage variable, a sprite-local variable, a list region, and a broadcast message live in different resource spaces with separate maps. The restrictions let the implementation use compact canonical products while retaining a direct connection to VM behavior.

### V-A Typed Resources and Footprints
CSIR types every semantic carrier: Var, List, TargetProp, Monitor, AskQueue, Answer, RandomStream, Timer, BroadcastMessage, CloneFamily, ThreadSet, FrameBoundary, PenBuffer, SoundChannel, EnvToken, External. Resources carry scope (global, sprite-local, clone-local) and, for lists, a region (whole, length, index, suffix). A footprint records reads, writes, creates, deletes, ordered-token consumes, observes, spawns, joins, kills, frame barriers, and commutative effects such as additive variable updates.

### V-B Transactions and Compilation
A transaction is a maximal effect sequence between scheduler- or lens-visible cuts: hats, waits, ask-and-wait, broadcasts and joins, clone birth and death, stops, loop back-edges, promise waits, frame boundaries, and monitor updates. The compiler enforces the invariant that every behaviorally relevant input is compiled: guards and reporter arguments carry read/token footprints; menus resolve to selections; inline variable references become reads; bounded literal loops unroll with one synthetic frame barrier per iteration; statically false branches are pruned; sound procedures are inlined and the rest compared by canonical content digest. Unsupported extensions compile to opaque external resources; they reduce decisiveness and produce unknowns when their effects matter.
Each compiled transaction records its trigger, target family, lexical provenance, normalized primitive sequence, control-region path, footprint, and $L$ -visible observations. The product compared by the algorithm is the multiset of these facts after alpha canonicalization and trace normalization. Facts are intentionally redundant: a broadcast contributes a message resource, a spawn edge, a receiver set, and optionally a join edge. The redundancy makes root-cause classification local. Removing broadcast and wait, for instance, changes a join fact without requiring the classifier to reconstruct a dynamic happens-before graph from raw blocks.

### VI Comparison Algorithm
Algorithm 1 summarizes the comparison kernel. Every accepting path carries a witness: equality of canonical products, an explicit alpha bijection, or equality of the $L_{\mathit{final}}$ abstract transfer. Mismatches become typed root causes plus obligations; targeted VM scenarios exercise only residual frontiers, and unproved cases remain explicit unknowns. Obligations are closed side conditions with a status in { *proved*, *refuted* }. Open predicates are recorded as frontiers.
Algorithm 1 ScratchLens lens-parametric product comparison
projects $P_{r},P_{s}$; lens $L$; optional VM budget $B$

### VI-A Canonicalization
ScratchLenscanonicalizes both projects independently, then compares canonical feature multisets. Expression trees fold constants, orient comparisons, sort commutative operands, simplify negations, and normalize change v by c with set v to v + c. Every primitive also carries a *control-region path*: enclosing control opcodes, branch indices, and guard expressions. Thus if c {set a; set b} and if c {set a}; set b no longer flatten to the same product; the former tags both writes with if#b0\[c\], the latter only the write to a. Statically decided guards contribute no path element.
Resources receive canonical indices per kind and scope, ordered by a rename-invariant usage profile refined by one Weisfeiler–Leman round over co-footprint neighborhoods [^42]. If the base comparison fails, ScratchLens searches remaining bijections over profile-tied resources by coordinate descent and a bounded small-space sweep. An equalizing bijection is a sound equivalence witness; otherwise the best bijection only minimizes the explanation delta.
Usage profiles use semantic roles. A variable written by a green-flag initialization, read by a guard, and shown as a monitor has a different profile from a variable written only inside a clone-start script. The WL refinement adds neighborhood context: two variables that both appear in arithmetic updates can still separate if one co-occurs with a broadcast join and the other with a renderer-visible motion effect. Remaining ties are common in small projects with symmetric sprites or duplicate counters; the bounded search closes those cases inside proof construction.

### VI-B Trace Normal Forms with Race Structure
Within each trigger cluster, ScratchLens proves pairwise independence from typed footprints. Transactions are independent only when read/write conflicts are absent (modulo declared commutative effects), neither consumes ordered tokens, $L$ -visible observations commute, and no spawn, join, kill, or frame barrier fixes order. Unproved pairs are dependent. Within one script, dependence becomes program order; across scripts it becomes a race fact. Each cluster maps to the lexicographically least linearization of this partial order, a Mazurkiewicz trace normal form [^22] [^14]: interleavings of the same trace match, ordered scripts never match races, and fully independent transactions compare as a multiset.
For example, two green-flag scripts that both write score emit an unordered race fact. Merging them into one ordered script changes the product; renaming the variable preserves the race fact under the alpha map. Equivalence preserves scheduler commitments as well as effects.
Algorithm 3 Trace normal form for one trigger cluster

### VI-C Verdicts, Classification, and Obligations
Equal canonical products prove equivalence only when their side conditions are closed. Under $L_{\mathit{final}}$, an abstract transfer over the numeric, string, list, clone, and monitor domains provides a second sound acceptance path when products differ only by final-state-invisible structure and the transfer obligation is proved. Unequal products enter the typed classifier, which recovers the taxonomy’s root causes from canonical fact deltas: join and spawn facts for P2, trigger sets for trigger changes, dangling send sets for broken broadcast wiring, read-before-write summaries for uninitialized reads, clone-trigger feature isolation for clone initialization, pen and observation totals for P8, and masked feature comparison for guard and literal changes (a pair whose features equalize when guards are masked differs exactly in its guards). Classified items carry confidence. Footprint-backed kinds are sound: a missing join fact is a fact about compiled structure, and no execution can retract it. Masked-comparison kinds are conditional: guard-masked equality isolates the change to guard text, and semantic equivalence of those guards is a satisfiability question. The item becomes an obligation and, when the solver fragment leaves it open, a CEGAR frontier with a synthesized scenario. Supported obligations, including guard feasibility, list abstraction equality, clone partition equality, and broadcast join equivalence, discharge through Z3 when available and through an exact finite fallback otherwise [^4]. Discharged obligations become certificates; open obligations stay in the frontier and are excluded from equivalence and static Different certificates.

### VI-D CEGAR with the Instrumented VM
Conditional frontiers become targeted scenarios: a random-stream frontier yields a scenario with two distinguishable token prefixes whose constraints ($r_{i}\neq r_{j}$, range bounds) the solver instantiates; an ask-order frontier yields distinguishable answers; a join frontier yields a receiver-stress run. The runner executes both projects under identical deterministic oracles, records primitive, event, clone, monitor, and renderer signals, aligns trace segments back to CSIR transactions, and confirms or refutes the frontier. Spurious evidence mutates an explicit refinement state (random taint to indexed tokens, clone families to partitions, final summaries to frame snapshots, renderer hashes to pixel regions) and re-enters comparison, in the counterexample-guided tradition [^3].
Frontiers are structured records. Each record names the carrier, lens, trigger path, unresolved predicate, candidate scenario generator, and the observations that would close the case. A random frontier records token indices and value constraints; an ask frontier records question order and answer substitutions; a renderer frontier records the region or target property that must diverge. The record structure lets the implementation cache negative runs, refine only the affected abstraction, and report Unknown with enough context for a stronger scenario or human review.

### VI-E Soundness Boundary
ScratchLensis intentionally asymmetric: finite VM runs prove difference, while equivalence requires an accepting static path. Table III summarizes the contract. The theorem scope is the supported Scratch-VM subset compiled to CSIR: core variables/lists, target properties, broadcasts and joins, green-thread yields, clones, ask queues, monitors, renderer-facing state, and the reporters covered by the expression normalizer. Opaque extensions, unsupported reporters, solver timeouts, and open frontiers yield Unknown unless a concrete witness is found.
TABLE III: Verdict paths and guarantees.
| Path | Guarantee | Known exclusions |


## Key insights
- The language and environment were designed for broad creative programming [^30] [^21], and repository studies show that learners solve similar tasks through diverse block structures, sprites, and control decompositions [^1].
- Baselines span structural, opcode-abstraction, dynamic-only, and LLM judges.
- The model follows the VM implementation [^34].
- The review artifact releases a runnable core subset: CSIR compilation, normalizers, canonical product comparison, trace normal forms, the static verdict driver for the controlled suite and non-LLM baselines, the VM trace harness, and aggregation scripts.
- RQ3

How does ScratchLens compare with structural, abstraction, dynamic-only, and LLM baselines, in accuracy and in false-equivalence count?
- The LLM tier evaluates GLM-5.1, Qwen3.6-plus, and Kimi K2.6 through one OpenAI-compatible gateway, with served model identifiers, prompts, raw responses, and parsed JSON pinned in the artifact.
- Each model sees scratchblocks text, the $L_{\mathit{default}}$ definition, and the closed taxonomy, then returns strict JSON with verdict, optional root cause, and confidence; Unknown is available, and persistent malformation counts as abstention.
- The models do not see labels, VM witnesses, ScratchLens verdicts, or another model’s output.
- The VM stages perform about $19{,}000$ deterministic scratch-vm executions; the LLM tier issues about $1{,}900$ checkpointed gateway requests, under $10 total.
- The artifact records raw per-pair outputs, seeds, scenarios, and model responses before aggregation.

## Exemplos e evidências
See original source at `Clippings/ScratchLens Lens-Parametric Behavioral Equivalence for Scratch Programs.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/ai-agents/harness]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/OpenAI]]
- [[03-RESOURCES/entities/Apple]]
- [[03-RESOURCES/entities/Python]]
