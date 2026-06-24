---
title: Company Brain
type: concept
status: developing
created: 2026-05-05
updated: 2026-05-05
tags:
  - ai-agents
  - enterprise-ai
  - knowledge-management
  - memory
---

# Company Brain

A Company Brain is a shared intelligence/memory layer that sits across all communication channels, knowledge bases, and agent traces to understand how an organization actually works and how work actually gets done — constructing a living world model of the entire company in near real time.

Coined/developed by [[03-RESOURCES/entities/Ashwin-Gopinath]] (@ashwingop), built at [[03-RESOURCES/entities/Sentra-AI]].

## Three-Layer Architecture

| Layer | What it preserves | Status |
|-------|-------------------|--------|
| **Factual memory** | What exists, what happened, provenance, ownership, freshness | [[03-RESOURCES/concepts/llm-ml-foundations/factual-memory]] |
| **Interaction memory** | Why decisions were made — meetings, messages, tradeoffs, judgment | Part 3 |
| **Action memory** | What actions were taken and with what effect | Part 1 |

## Core Design Principles

**1. Emergence over imposition**
Top-down central repositories die because people don't work in them. Memory must grow from individual workspaces outward — personal notes become team docs, team docs become roadmap decisions, roadmap decisions become customer commitments.

**2. Individual brain ≠ company brain**
They overlap but are not the same. The Company Brain must respect the boundary between private working context and institutional memory, while allowing useful memory to emerge across that boundary.

**3. Proactive, not reactive**
> "A knowledge base waits. Memory participates."
A Company Brain surfaces the right facts before you ask — before a customer call, when a ticket is assigned, when a new employee joins.

**4. Personalized answers**
Same question → different answers by role (IC, manager, CEO). Personalization is structural, not decorative.

**5. Provenance and permissions as first-class citizens**
Attribution (who created it, who owns it, is it still current?) and permissions (can this person see the source?) are non-negotiable layers, not add-ons.

## Why It's Not RAG

RAG retrieves plausible fragments. A Company Brain requires durable structure: provenance, permissions, ownership, freshness, source-of-truth boundaries, and relationships between artifacts. The storage model required is a [[03-RESOURCES/concepts/pkm-obsidian/semantic-file-system]].

## Related Concepts

- [[03-RESOURCES/concepts/llm-ml-foundations/factual-memory]] — Layer 1 detail
- [[03-RESOURCES/concepts/pkm-obsidian/semantic-file-system]] — required storage model
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — individual-agent memory (analog at smaller scale)
- [[03-RESOURCES/concepts/pkm-obsidian/knowledge-compounding]] — why connected memory increases in value non-linearly
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — related challenge of curating what goes into context

## Entities

- [[03-RESOURCES/entities/Ashwin-Gopinath]] — author
- [[03-RESOURCES/entities/Sentra-AI]] — building this
- [[03-RESOURCES/entities/Glean]] — enterprise search predecessor; Company Brain goes further

## Relationship to System of Intelligence

[[03-RESOURCES/concepts/ai-strategy-org/system-of-intelligence]] (a16z / Steph Zhang, 2026) addresses the same pattern scoped to GTM software markets. Both concepts share:
- An intelligence layer that sits above and orchestrates databases/SoRs
- Proactive context delivery before the user asks
- Institutional memory that survives employee turnover
- Switching costs migrating from data storage to the orchestration layer

The SoI can be understood as a Company Brain applied specifically to sales and marketing teams.

## Single Grain Implementation — 5-Layer System (Ericosiu, 2026-05-29)

@ericosiu (Eric Siu, Single Grain) documents a production implementation with a different framing: **memory is raw material, retrieval is the operating layer**. The 5-layer architecture:

```
┌──────────────┐
│  Execution   │ agents, workflows
├──────────────┤
│  Feedback    │ corrections → rules
├──────────────┤
│  Permission  │ who can use what
├──────────────┤
│ Source Truth │ what to trust
├──────────────┤
│  Retrieval   │ right context now
├──────────────┤
│   Capture    │ calls, CRM, SOPs
└──────────────┘
```

**Production scale:** 500K+ tokens persistent memory, 90+ daily crons, 2,862 Gong call transcripts → operational playbooks. One daily ingestion: 15 calls → 390 insights + 470 facts + 125 frameworks.

**Key divergence from naive memory approach:** persistent memory files consuming 40% of context window → agents had more information but pulled the wrong information at the wrong time. Fix: retrieval layer that delivers the 6 relevant context pieces per task, not the entire history.

**Source truth as operating design problem:** without explicit source hierarchy, agents become "confident liars with better formatting." Some sources are live truth, some historical context, some inspiration, some off-limits for public content.

**Feedback loop as compounding mechanism:** every human correction → future rule update (phrase → voice rule; unsafe example → source rule; missed CRM signal → pipeline scan rule). Without feedback loops: babysitting software. With them: company learning.

> [!note] Complementary to Ashwin Gopinath / Sentra AI framing
> The Gopinath (Sentra AI) framing emphasizes emergence, proactive surfacing, and the semantic file system model. Ericosiu (Single Grain) provides the operational playbook: 5 explicit layers, production evidence, and the retrieval-over-context-size lesson. Both address the same problem from architecture (Gopinath) vs. implementation (Ericosiu) angles.

## Sources

- [[03-RESOURCES/sources/memory-context-rag/clipping-company-brain-part-2-factual-memory]] — Part 2: Factual Memory (2026-04-30)
- [[03-RESOURCES/sources/ai-agents-harness/system-of-record-to-system-of-intelligence-a16z]] — a16z market thesis; SoI as GTM-scoped Company Brain (2026-04-26)
- [[03-RESOURCES/sources/memory-context-rag/how-we-built-single-company-brain]] — Ericosiu / Single Grain; 5-layer production system, retrieval-over-context-size, 2026-05-29

## Evidências
- **[2026-06-19]** Markdown resolve a camada de intenção (plano/estratégia) mas é substrato terrível para o registro factual do negócio; o context graph (com provenance e permissions) é a peça que falta e ainda quase nenhum fornecedor entregou — [[gtm-engineering-chapter-two]]
- **[2026-06-22]** STATE.md como arquivo que todo sistema lê no início e escreve no fim (verified facts, lessons learned, last session) — sem ele todo sistema reinicia do zero; com ele, lição de março é consultada automaticamente em junho — [[03-RESOURCES/sources/how-to-build-a-solo-company-with-claude-code-9-systems-that-run-it]]
- **[2026-06-22]** Estrutura de pastas frameworks/examples/reference/intake/clients/outputs como variante individual (não-corporativa) do company brain, aplicada a expertise pessoal produtizada — [[03-RESOURCES/sources/how-to-productize-your-expertise-into-a-hermes-and-obsidian-system-clients-pay-to-access]]
