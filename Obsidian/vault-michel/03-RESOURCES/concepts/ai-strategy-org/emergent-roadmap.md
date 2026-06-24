---
title: Emergent Roadmap
type: concept
status: developing
created: 2026-05-14
updated: 2026-05-14
tags: [org-design, roadmap, product-management, ai-org-design, jack-dorsey, composition, emergent]
---

# Emergent Roadmap

A product development model in which the roadmap is not planned in advance but emerges automatically from gaps in the AI system's ability to compose existing capabilities in real time.

## The Traditional Model (and its failure)

Traditional roadmaps are guesses — derived from customer interviews, support tickets, and stakeholder priorities. They represent a team's best prediction of what to build, filtered through organizational layers.

## The Emergent Model

> "Customers request features that don't exist and the system composes them in real time from existing capabilities. If the system cannot compose, that gap is your roadmap — it emerges automatically from the conversation, not inferred from interviews and support tickets." — [[03-RESOURCES/entities/Jack-Dorsey]]

### How it works

1. Customer makes a request for a feature that doesn't yet exist
2. AI system attempts to compose the feature from existing capabilities
3. **Composition succeeds** → feature delivered immediately
4. **Composition fails** → the gap is logged automatically as a roadmap item
5. Humans apply judgment: is this gap consistent with what the company wants to be?

### Key properties

- **Zero-lag signal:** Gaps surface from actual usage, not filtered through support queues
- **Prioritized by default:** Only gaps that real customers hit appear as roadmap items
- **Judgment remains human:** Whether to fill a gap is a strategic choice, not a discovery problem

## Relationship to AI Org Design

The emergent roadmap is only possible when the product layer is built as an AI composition system rather than a feature-flag switch. It requires [[03-RESOURCES/concepts/ai-strategy-org/ai-org-design]] — intelligence at the core, not bolted on.

## Sources

- [[03-RESOURCES/sources/ai-agents-harness/jack-dorsey-company-as-mini-agi]] — origin of concept
- [[03-RESOURCES/entities/Jack-Dorsey]] — Block's implementation context
