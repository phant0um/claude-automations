---
title: "First Principles Design"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, dev-foundations]
status: developing
---

# First Principles Design

Deriving architecture from fundamental constraints rather than borrowing patterns from analogous systems.

## O que é / What it is

First-principles thinking (Aristotle → Descartes → Feynman → Musk) applied to software: break a problem down to its irreducible truths, then build up from there. The alternative — "how do similar systems do this?" — copies the constraints and assumptions of other systems, many of which may not apply.

## Como funciona

**The Feynman technique for software:**
1. State the problem in one sentence without jargon
2. Identify the actual constraints (data size, latency budget, team skill, change frequency)
3. Derive the simplest structure that satisfies the constraints
4. Name the patterns you arrived at (they'll often match known patterns — that's fine; arriving independently confirms they fit)

**When patterns hurt:**
- Applying microservices because "Netflix uses microservices" — ignoring that Netflix has 1000 engineers and 200M users
- Adding a message queue because "decoupling is good" — when the two services are always deployed together
- Layered MVC for a 3-endpoint CRUD — where all layers add indirection with zero benefit

**When patterns help:**
- You've derived the same structure independently → the pattern gives you a name, documentation, and community knowledge
- The pattern was designed for your exact constraint set (CQRS for high-read/low-write, event sourcing for audit requirements)

**Derivation example:**
> Problem: Students submit assignments; instructors grade them.
> Constraints: small team, simple CRUD, single deployment.
> First principle: data flows in one direction (submit → grade → feedback).
> Derived: simple REST API with 3 resources. Not event-driven, not microservices.

## Por que importa

Relevant for FIAP system design assignments and concurso questions. The examiner rewards showing *why* an architecture was chosen, not just naming it. First-principles answers score higher than pattern recitation.

## Related
- [[03-RESOURCES/concepts/dev-foundations/clean-code]]
- [[03-RESOURCES/concepts/dev-foundations/system-design]]
- [[03-RESOURCES/concepts/dev-foundations/_index]]
