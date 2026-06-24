---
title: "AI-Assisted Completion of CertiGC Proofs: An Experience Report"
type: source
source: "Clippings/AI-Assisted Completion of CertiGC Proofs An Experience Report.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
---
title: "AI-Assisted Completion of CertiGC Proofs: An Experience Report"
source: "
author:
published:
created: 2026-06-23
description:
tags:
  - "clippings"
---
Shengyi Wang Shanghai Qi Zhi InstituteShanghaiChina [wangshengyi@sqz.ac.cn]()

###### Abstract. This experience report describes the Codex-assisted completion and stabilization of a substantial Rocq (formerly Coq) proof development for CertiGC, the verified generational garbage collector in the CertiGraph project. The development exte

## Argumentos principais
### 1\. Introduction
Large language models are now routinely used as programming assistants, and proof engineering is beginning to adopt the same style of assistance. In ordinary software development, compilation is only a weak check on behavior. In formal verification, by contrast, a proof script accepted by the kernel establishes its stated theorem. The central risk is therefore not that one must trust the generated proof script, but that the definitions, theorem statement, or specification boundary may no longer express the intended result. A silently weakened theorem, an inappropriate new precondition, or a specification change can make a checked proof certify the wrong property. This does not make review automatic, but it changes its scale: the theorem statements, together with the definitions and specification boundaries they mention, are far more concise than the proof scripts themselves.
This paper reports on a concrete proof-engineering experience in that setting: using OpenAI Codex [^5] [^6] to help complete the mutable-garbage-collector branch of CertiGC. CertiGC is part of the CertiGraph development [^9], which uses the Verified Software Toolchain (VST) [^1] and Rocq to verify C programs manipulating heap-represented graphs. Rocq is the proof assistant formerly named Coq. The collector is a generational copying collector. The original CertiGC proof did not cover mutable references or updatable arrays, whose updates can create pointers from older objects to younger ones after allocation. The mutable extension adds a write barrier and remembered sets, giving the collector the extra information needed to handle such updates.
Figure 1. Mutable-collector proof map.

### 2\. Background: CertiGC, VST, and Remembered Sets
CertiGraph [^9] provides a framework for verifying graph-manipulating C programs: abstract graphs are represented in Rocq, while separation-logic predicates connect those graphs to concrete heap layouts. CertiGC is the generational garbage collector in that development. Its proof uses VST’s Verifiable C program logic [^1], whose soundness theorem connects the logic to CompCert’s C semantics [^3]. A companion manuscript gives a fuller account of the CertiGC C collector, its specification, and the underlying Rocq proofs [^10].
The rest of this section supplies the background needed to read Figure 1: how the original collection path differs from the mutable path, and why that difference forced an invariant change.
Generational collection relies on the observation that most objects die young [^2]. The heap is divided into generations ordered by age; collecting a younger generation copies its live objects to an older target generation and redirects later uses to the copies. In CertiGC, garbage\_collect invokes do\_generation for the generation currently being collected. In the original collection path, do\_generation called forward\_roots and do\_scan, but not forward\_remset. forward\_roots follows ordinary program roots, while do\_scan follows fields of already copied objects. Both ultimately use forward, which copies a referenced live object to the target generation.

### 3\. The Proof Task
The proof task spans two layers of the CertiGC development. The VST layer reasons about concrete C states through separation-logic resources and proves that functions such as do\_generation and garbage\_collect implement abstract graph relations in GCGraph.v. The mathematical layer, especially gc\_correct.v, reasons about those abstract graphs and proves that collection preserves the live, roots-reachable part of the graph up to isomorphism. The repair had to keep C specifications, abstract relations, and the graph-isomorphism theorem in sync.
In the remembered-set development, rh denotes the abstract remembered-set heap threaded through the graph relations. The variable rmst denotes remembered-set state used by compatibility predicates that connect this heap to the graph and to the VST-facing representation invariants. This bridge explains why both remembered-set components appear in the theorem below even though neither appears in its observable conclusion.
The central proof target was the following theorem. Its hypotheses expose the new remembered-set assumptions, while its conclusion retains the original roots-level graph-isomorphism property:

### 4\. Workflow with Codex
The Codex-assisted workflow was closer to supervised proof maintenance than to one-shot proof generation. The assistant was given access to the repository and was allowed to edit files and run targeted builds. We supplied the proof goal, design constraints, and course corrections.

### Proof-component ordering.
The order of repair followed the proof architecture. The VST files first had to establish that the changed C collector still satisfied the abstract relations used by the mathematical proof. Only after verif\_do\_generation.v and verif\_garbage\_collect.v compiled, establishing that the C program correctly implements the functional model of the algorithm, was it productive to repair gc\_correct.v, whose proof shows that the abstract algorithm preserves roots-level graph isomorphism. This avoided treating the final graph-isomorphism theorem as an isolated Rocq problem disconnected from the verified C program.

### Development loop.
Most iterations followed a simple pattern. Codex inspected the current proof failure, searched for nearby lemmas, edited a focused region, and ran a targeted build such as:
[⬇]()
\# rebuild definitions and proofs about the graph functional model

### Proof-state access.
In addition to shell builds, the session used a locally configured rocq-mcp Model Context Protocol server [^4]. The server exposes Rocq compilation, environment queries, proof-state startup, tactic checking, multi-tactic probing, file outlines, and assumption queries as tools for LLM agents. In this project it was configured as a repository-local Codex MCP server using the same coqc binary as the VST build. Codex could therefore call tools such as rocq\_start, rocq\_check, rocq\_step\_multi, and rocq\_query from the conversation: start a proof state at a theorem or error position, inspect the current goals, query the environment, try small tactic sequences, and then edit the tracked proof file or run a targeted build.
This made proof-state feedback cheaper and more direct than reading compiler errors alone. The development did not include a controlled timing comparison, so this report does not claim a measured speedup. Qualitatively, however, MCP shortened local feedback loops by avoiding many edit-compile-read-error cycles for exploratory proof-state inspection. The workflow did not depend logically on MCP support: similar information can be recovered by compiling focused temporary files that replay a proof prefix while inserting Show commands, or by running targeted.vo builds and reading Rocq’s error messages. MCP was therefore an efficiency and ergonomics tool, not an assumption behind the proof result.

### Invariant proposal and adjudication.
The recorded-backward-edge invariant was not fixed before the Codex session. In the interaction, Codex first formulated the need for a condition informally phrased as “no unrecorded backward edge” and later wrote the first Rocq definition of that predicate. We then recognized that the old no\_backward\_edge premise was semantically invalid for mutable GC and directed the repair to replace the old invariant rather than keep it as a convenient hidden assumption. This episode is representative of the collaboration: the assistant could propose a useful invariant, but we had to decide whether accepting it preserved the intended collector specification rather than merely making the scripts compile.

### Human constraints.
Our guidance was deliberately conservative. New or changed lemmas were acceptable, but new or changed Definitions required discussion. Preconditions were not to be added to VST specs unless there was concrete evidence that the source program required them.
This constraint appeared early in the scanner proof, where the question was whether the scanner specification really needed a positive available-space precondition after remembered-set forwarding. The accepted direction removed an overly strong condition; proposed additions such as extra pointer or heap predicates were rejected unless existing specifications justified them.

### Effective uses of Codex.
Codex was effective at local proof repair and repeated invariant propagation. Once the recorded-backward-edge invariant and bridge shape were clear, many subgoals amounted to proving that a property was preserved by a fold over forward\_remset\_item, by heap updates, or by adding/resetting one generation. These tasks are tedious for a human but well suited to an agent that can search the development, try variants, and run the checker repeatedly.
Codex also helped with cleanup after the theorem was restored. The branch contains several later commits whose purpose was not to change the theorem but to remove stale proof artifacts, factor repeated preservation arguments, audit the theorem’s assumptions against VST specifications, update deprecated names, and simplify helper lemmas. In a large proof development, this maintenance is not cosmetic: stale helper lemmas and stale assumptions obscure which invariants are actually needed and make future repair harder.

### Where human judgment remained central.
The critical invariant choice was a proof-engineering decision rather than a tactic choice. The old proof failed because its semantic assumption was no longer true. Although Codex proposed the recorded-backward-edge formulation, accepting it as the replacement invariant required understanding the collector algorithm, the write barrier, and the desired external theorem. Codex could help explore consequences and fill in preservation lemmas, but the proof had to avoid shortcuts that would change the result. Two tempting shortcuts were to strengthen mathematical specifications with extra heap or remembered-set preconditions, or to expose remembered-set internals in the main theorem. Both changes would have altered the result being verified. The remembered set is private collector state; making it part of the theorem would change the public correctness claim.

### 5\. Results
The branch reached a compiling state and was merged into the upstream live branch as pull request 30 with the merge message “Replace invalid no\_backward\_edge invariant for mutable GC” on May 3, 2026. The source repository is [); the proof artifact discussed here is [pull request 30](), whose merge commit is 85da48e4.
Table 2 summarizes repository evidence extracted from the git history. These numbers should be read as artifact statistics, not as a precise measure of human or AI labor. The git author field does not distinguish manual edits from Codex-assisted edits; the phase boundary below comes from the transcript-confirmed start of the Codex-assisted work and the corresponding commit dates.
Table 2. Repository evidence for the mutable-GC proof effort.

### The theorem statement is the artifact to defend.
In a large formal development, a compiling proof is necessary but not sufficient. In this case, that defense meant guarding against specification drift: strengthening preconditions until the proof became easier, or letting remembered-set details leak into a theorem whose purpose was to state graph preservation for ordinary roots. Definitions and preconditions are part of the scientific claim, not local proof conveniences; changing them required evidence that the collector semantics needed the change. Human review therefore focused on definitions, assumptions, and theorem statements.

### LLMs are useful for local invariant propagation.
Once a good invariant is chosen, a large amount of proof work is mechanical but not trivial. The proof assistant requires exact lemmas about folds, list updates, graph validity, generation bounds, heap sizes, and compatibility predicates. Codex was useful because it could navigate the existing library and produce these bridge lemmas incrementally. The resulting proof still benefited from cleanup: some helper lemmas were introduced only to cross a local gap and became unnecessary after the proof architecture stabilized.

### Existing libraries are both leverage and constraint.
VST and CertiGraph made the result possible because they already provided the semantic model, spatial graph representation, and verification discipline. They also constrained the shape of the repair. A small change to a definition could ripple through many files, and automation failures were often symptoms of larger mismatches between mathematical and spatial invariants. Codex was more effective when the development stayed within existing patterns than when it required new proof architecture.


## Key insights
- We document an invariant-repair case in which the central problem was not to adapt a related proof architecture, but to replace a semantic assumption made false by mutation while preserving the final roots-level graph-isomorphism theorem.
- We describe a concrete division of labor: Codex proposed the recorded-backward-edge invariant and helped implement its preservation, while we judged that invariant to be the right specification for the mutable collector.
- We report transcript-derived interaction statistics and explain how those statistics should be interpreted as evidence of supervised, checker-driven proof maintenance rather than autonomous proof generation.
- We compare this experience with a recent LLM-assisted compiler-proof experience report and identify lessons specific to maintaining large VST/CertiGraph proofs.
- remove the invalid global no\_backward\_edge condition;
- introduce and preserve no\_unrecorded\_backward\_edge;
- make remembered-set entries act as temporary roots during generation copying;
- keep the top-level theorem framed as graph isomorphism over ordinary roots;
- repair the VST verification files so that the C code and mathematical relation agree.

## Exemplos e evidências
See original source at `Clippings/AI-Assisted Completion of CertiGC Proofs An Experience Report.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/Claude]]
- [[03-RESOURCES/entities/OpenAI]]
- [[03-RESOURCES/entities/Codex]]
- [[03-RESOURCES/entities/Rust]]

## Minha Síntese
**O que muda:** A ser analisado em revisão manual.

**Conexão pessoal:** A ser conectado com projetos/estudo atuais.

**Próximo passo:** Nenhum próximo passo imediato.
