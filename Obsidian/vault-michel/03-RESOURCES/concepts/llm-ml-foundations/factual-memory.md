---
title: Factual Memory
type: concept
status: developing
created: 2026-05-05
updated: 2026-05-05
tags:
  - ai-agents
  - enterprise-ai
  - memory
  - knowledge-management
  - company-brain
---

# Factual Memory

Factual memory is Layer 1 of a [[03-RESOURCES/concepts/pkm-obsidian/company-brain]]. It is the organizational ability to answer: **what is this, what happened, where is the source, who owns it, when did it change, and how does this thing work?** — across all places where work leaves a trace.

Source: [[03-RESOURCES/entities/Ashwin-Gopinath]], [[03-RESOURCES/sources/memory-context-rag/clipping-company-brain-part-2-factual-memory]]

## What It Is Not

- Not a shared drive
- Not a wiki
- Not enterprise search with a chat box attached
- Not RAG across enterprise data

## What It Must Preserve

| Attribute | Description |
|-----------|-------------|
| **Provenance** | Who created it, who modified it, who owns it now |
| **Permissions** | Can this person see the underlying source? |
| **Ownership** | Which person/team made it official? |
| **Freshness** | Is this still current or contradicted by something newer? |
| **Source-of-truth boundaries** | Can this answer be trusted for a customer conversation? |
| **Relationships** | How this artifact connects to others in the company |

## Why RAG Fails for Factual Memory

RAG can retrieve fragments. Plausible snippets feel magical in demos. But:

> "A company does not only need plausible snippets. It needs durable structure: provenance, permissions, ownership, freshness, source-of-truth boundaries, and relationships between artifacts."

Retrieval alone fails when **meaning has to persist**. Factual memory requires something closer to a [[03-RESOURCES/concepts/pkm-obsidian/semantic-file-system]].

## The Semantic File System Requirement

Artifacts must not be just blobs of text. The relationships around each artifact matter as much as the artifact itself:

```
customer call → account → open issues → tickets → product areas → owners → decisions
```

This is more than a knowledge graph pasted on top of documents, and more than markdown with metadata.

## Personalization as Part of Memory

The same factual question produces different answers for different roles:

- **IC asking about a billing integration** → relevant specs, prior tickets, known risks, owners, customer commitments, recent incidents, open decisions
- **Manager asking what's blocking onboarding** → tickets, status updates, ownership, customer escalations, unresolved dependencies
- **CEO asking about enterprise churn** → CRM data, support tickets, renewal notes, call summaries, account history, product issues, dashboard metrics

The system must understand the person asking, what they are allowed to know, and what they are trying to do.

## Proactive Memory

Factual memory cannot sit in a search box waiting for a query. Proactive triggers:

- Before a customer call → surface open commitments, recent issues, prior conversations
- When a roadmap doc is edited → surface related customer asks and duplicate work
- When a ticket is assigned → show prior incidents and owners
- When a pricing exception is requested → surface precedent
- When a new employee joins → build a personalized map of what they need to know

## What Factual Memory Cannot Do Alone

Factual memory can tell you **what** exists, what happened, where sources are, who was involved, when something changed, how a workflow works. It cannot fully preserve **why** a decision was made. That lives in **interaction memory** (Layer 2): meetings, messages, disagreement, judgment, escalation, tradeoff.

## Relation to Agent Memory Concepts

[[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] describes memory layers for individual coding agents (episodic, semantic, procedural). Factual memory in the Company Brain context is the **organizational-scale semantic layer** — but with additional requirements around provenance, permissions, and cross-tool relationships that individual-agent memory models do not address.

## Related

- [[03-RESOURCES/concepts/pkm-obsidian/company-brain]] — parent concept
- [[03-RESOURCES/concepts/pkm-obsidian/semantic-file-system]] — required storage model
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — individual-agent analog
- [[03-RESOURCES/concepts/pkm-obsidian/knowledge-compounding]] — connected memory compounds in value
- [[03-RESOURCES/entities/Sentra-AI]] — company building factual memory for enterprise
