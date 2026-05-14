---
title: "Contextual Agentic Memory is a Memo, Not True Memory"
type: source
source_file: "Clippings/Contextual Agentic Memory is a Memo, Not True Memory.md"
source_url: "https://arxiv.org/html/2604.27707v1"
authors: ["Binyan Xu", "Xilin Dai", "Kehuan Zhang"]
institutions: ["Chinese University of Hong Kong", "Zhejiang University"]
created: 2026-05-14
updated: 2026-05-14
tags: [source, agent-memory, c-engineering, theta-engineering, rag, retrieval, continual-learning, security]
---

# Contextual Agentic Memory is a Memo, Not True Memory

## Core Claim

All deployed agentic memory (RAG, vector stores, scratchpads, MemGPT, Reflexion, Voyager, Generative Agents) is **C-engineering** — context manipulation — not **θ-engineering** (weight updates). This is a category error with provable consequences.

The central distinction:
- **C-engineering**: inject content into context window → conditions on `P(X|θ, C)`. Bounded by context window L. Exemplar-based lookup.
- **θ-engineering**: update model weights via fine-tuning / RL → changes `P(X|θ)`. Bounded by parameter count. Rule-based generalization.

## Memory Taxonomy (Table 1)

| Type | Substrate | Persists | Generalizes |
|------|-----------|----------|-------------|
| Working | Context window | Session only | Limited by L |
| Episodic | External store | Cross-session | Exemplar-based |
| Semantic | Model weights | Permanent | Rule-based |
| Experiential | Model weights | Permanent | Rule-based (fine-tuning/CL) |

**Key gap**: the "Experiential" row is absent from every deployed system. All current systems occupy only the "Episodic" row.

## Four Structural Limitations

### 1. Definitional: Exemplar-Based Lookup Cannot Extrapolate
Retrieval generalizes by similarity to stored cases. Rule-based cognition applies abstract principles to inputs never seen. Human experts are functions; novices with textbooks are lookup tables (Chi et al., 1981).

### 2. Structural: The Generalization Gap (Theorem 1)
Formal proof that C-engineering has a quadratic sample-complexity disadvantage vs. θ-engineering on compositionally novel tasks:
- Retrieval needs **Ω(k²)** stored examples to generalize over k concepts
- Fine-tuning needs only **O(d/δ)** examples (d = VC dim of composition operator)
- **Separation ratio: n_R/n_P = Ω(k²/d)**, independent of context window size
- Proven via Fano's inequality; confirmed empirically by ParamMem, SCAN, COGS benchmarks

### 3. Dynamic: The Frozen Novice Problem
Agents operating exclusively via C-engineering begin every session with the same frozen weights. Expertise requires structural weight reorganization (neocortical consolidation), not just more stored examples. MemGPT's "sleep-time compute" compresses text, not weights — still a well-organized novice.

### 4. Security: Persistent Compromise (evil²)
- Stateless agent: injection risk = p₀ per session
- Memory-augmented agent: P(compromised by t) = 1-(1-p₀)^N(t) → 1 as interactions grow
- MINJA: 98.2% injection success rate with persistence across sessions
- PoisonedRAG: 5 adversarial texts → 90% attack success on million-entry KB

## Co-existence Architecture (Call to Action)

**System builders**: add a consolidation channel — episodic store → weight updates (LoRA, MEMIT, TTT layers, Skill-SD). Asynchronous, like biological sleep. Requires: trace provenance, versioned checkpoints, regression guards.

**Benchmark designers**: adopt Compositional Generalization over Time (CGT) metric. Stop measuring recall quality; measure whether performance on novel concept combinations improves with experience.

**Continual learning community**: re-engage the agentic setting. Experience stream + success criterion are ready; CL methods (EWC, SSR, coreset selection) directly applicable.

## Neuroscience Grounding

Complementary Learning Systems (McClelland et al., 1995): hippocampus = fast episodic storage; neocortex = slow, distributed, rule-based representations consolidated during sleep. Current AI agents implement only the hippocampal half.

## Key Evidence

- ParamMem: parametric reflective memory outperforms retrieval-based; gap grows on novel compositional transfers
- ROME / MEMIT: facts localized to MLP weight layers — weight-based storage is structurally compact and generalizable
- SFT modifies attention routers (how to access knowledge), not fact memory units — 90% of SFT parameter updates add zero knowledge

## Relations

- [[03-RESOURCES/concepts/agent-memory-architecture]] — extends existing taxonomy with C/θ distinction
- [[03-RESOURCES/concepts/context-engineering]] — what all deployed memory actually is
- [[03-RESOURCES/concepts/dream-cycle-self-consolidation]] — the consolidation pattern this paper calls for
- [[03-RESOURCES/concepts/continual-learning-v2]] — CL community is the missing piece
- [[03-RESOURCES/concepts/self-evolving-agents]] — closest deployed systems to θ-engineering agents
