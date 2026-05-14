---
title: "Contextual Agentic Memory is a Memo, Not True Memory"
type: source
source_url: "https://arxiv.org/html/2604.27707v1"
authors: ["Binyan Xu", "Xilin Dai", "Kehuan Zhang"]
affiliation: "CUHK + Zhejiang University"
created: 2026-05-13
tags: [agentic-memory, rag, weight-based-memory, continual-learning, memory-taxonomy, generalization, security]
---

# Contextual Agentic Memory is a Memo, Not True Memory

**Thesis:** All current agentic memory systems (vector stores, RAG, scratchpads, context-window management) implement *lookup*, not *memory*. Treating lookup as memory is a category error with provable consequences for capability, learning, and security.

## The Core Distinction

| Path | Mechanism | Generalization |
|------|-----------|----------------|
| Change θ (weights) | Pre-training, fine-tuning, RL, gradient updates | Rule-based — applies abstract principles to never-seen inputs |
| Change C (context) | Prompting, RAG, MCP, skill files, scratchpads | Exemplar-based — retrieves similar stored cases only |

**All deployed agentic memory is C-engineering.** Every system in the "Episodic" row (MemGPT, RAG, Reflexion, Voyager) changes C, not θ.

## Memory Taxonomy (Table 1)

| Type | Substrate | Persists | Updated by | Generalizes |
|------|-----------|----------|-----------|-------------|
| Working | Context window | Session only | Token generation | Limited by L |
| Episodic | External store | Cross-session | Read/write ops | Exemplar-based |
| Semantic | Model weights | Permanent | Pre-training | Rule-based |
| Experiential | Model weights | Permanent | Fine-tuning/CL | Rule-based |

The **Experiential row is systemically absent** from all deployed systems. This is the gap.

## Experience Compression Spectrum

Raw traces (low compression) → natural-language skills (medium compression) → parameterized rules (high compression, generalizable). The appropriate substrate depends on compression level:
- Episodic traces → external store
- Skills → context or weights (bridge)
- Rules → **must be in weights**

Current systems implement the entire spectrum as C-engineering — this is the root error.

## Four Structural Limitations

### 1. Definitional — Exemplar Lookup Cannot Extrapolate
Retrieval generalizes by similarity. A lookup table maps seen inputs to stored outputs. A function maps *any* input to a principled output. Human experts are functions; novices with textbooks are lookup tables.

### 2. Structural — Generalization Gap Theorem (Theorem 1)
Under compositional sample complexity analysis:
- Retrieval lower bound: needs Ω(k²) stored examples to achieve 1-δ accuracy on k concepts
- Parametric upper bound: O((d + log(1/δ))/δ) examples suffice, independent of k
- Separation ratio: n_R/n_P = Ω(k²/d) — quadratic in concept count

**This gap is independent of context window size.** Growing the window enlarges the filing cabinet, not the mind.

### 3. Dynamic — Frozen Novice Problem
Each session begins from the same frozen weights. No matter how many experiences are logged, the weights encoding composition rules remain those of the original pre-trained model. The agent is "permanently doing .predict(C), never .train()."

### 4. Security — Persistent Compromise
Without persistent memory: injection is transient (one session). With agentic memory: injected content writes to store and propagates across all future sessions. MINJA achieved 98.2% injection success rate persisting across sessions. P(compromised by t) → 1 as N(t) → ∞.

## Call to Action

**System builders:** Build the consolidation channel — a pathway from episodic store to parametric memory. Architecture: fast episodic lookup + offline consolidation pipeline (AI analog of biological sleep). Building blocks already exist: LoRA, MEMIT, TTT layers, SSR, Skill-SD.

**Benchmark designers:** Adopt Compositional Generalization over Time (CGT): does accuracy on novel concept combinations improve with experience? Current benchmarks measure recall (lookup quality), not learning quality.

**Continual learning community:** The agentic setting is your deployment target. Experience stream + reward labels + compositional novelty criterion = everything CL methods need.

## Neuroscience Grounding

Complementary Learning Systems (CLS) theory: hippocampus provides fast episodic storage; neocortex encodes slow, distributed rule-based representations consolidated during sleep. AI agents implement only the hippocampal half.

## Relationships

- [[03-RESOURCES/concepts/agentic-memory-taxonomy]] — formalizes the 4-type taxonomy introduced here
- [[03-RESOURCES/concepts/agent-memory-architecture]] — existing wiki page on memory architecture (extends)
- [[03-RESOURCES/concepts/agent-memory-four-layers]] — existing four-layer model (related)
- [[03-RESOURCES/concepts/frozen-novice-problem]] — new concept coined here
- [[03-RESOURCES/concepts/experience-compression-spectrum]] — spectrum concept referenced
- [[03-RESOURCES/sources/heavyskill-heavy-thinking-agentic-harness]] — HeavySkill uses skills as C-compression (medium level)
