---
title: "System Design"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, dev-foundations]
status: developing
---

# System Design

The discipline of architecting distributed systems that are scalable, reliable, and maintainable — from load balancers to database sharding.

## O que é / What it is

System design is the set of decisions that determine how a software system handles growth: more users, more data, more requests. It bridges business requirements and implementation. Relevant for FIAP projects (Fintech, MVC), concurso provas de TI, and the engineering context in which AI agents operate.

## Como funciona

**Scalability:**
- **Vertical scaling** — bigger machine (CPU, RAM). Simple but has a ceiling and single point of failure.
- **Horizontal scaling** — more machines. Requires stateless services or distributed state management.

**CAP Theorem:** A distributed system can guarantee at most 2 of 3:
- **Consistency** — all nodes see the same data at the same time
- **Availability** — every request gets a response
- **Partition tolerance** — system works despite network splits

In practice: network partitions happen → choose CP (banks, transactions) or AP (social media, caches).

**Core patterns:**
| Pattern | Problem it solves |
|---------|-----------------|
| Load balancer | Distribute traffic across N servers |
| CDN | Reduce latency for static assets |
| Cache (Redis) | Avoid repeated DB reads for hot data |
| Message queue (Kafka) | Decouple producers from consumers; absorb spikes |
| Database sharding | Horizontal partition of data across DBs |
| Read replica | Scale reads separately from writes |
| Circuit breaker | Fail fast when a dependency is down |

**Microservices vs. monolith:**
- Monolith: simpler to build, deploy, and debug; good for teams <10 engineers or MVPs
- Microservices: independent scaling and deployment; justified when services have truly different scaling needs and teams own them independently

**Relevance for FIAP Fintech projects:** Payment systems = CP (consistency over availability). High-traffic endpoints → cache layer + read replicas. Event-driven (Kafka) for async transaction notifications.

## Related
- [[03-RESOURCES/concepts/dev-foundations/first-principles-design]]
- [[03-RESOURCES/concepts/dev-foundations/clean-code]]
- [[03-RESOURCES/concepts/development/legacy-systems]]
- [[03-RESOURCES/concepts/dev-foundations/_index]]

## Evidências
- **[2026-06-24]** Scaling adversarial evaluation of large language models requires two things at once: a way to genera — [[adversabench-automated-llm-red-teaming]]

- **[2026-06-24]** Most developers don't have a coding problem.They have a workflow problem.A lot of time gets wasted doing things that are — [[10-developer-tools-you-probably-aren-t-using-but-should-be]]
- **[2026-06-24]** tags: — [[accuracy-and-satisfaction-in-multi-turn-llm-dialogues-for-nfr-assessment]]