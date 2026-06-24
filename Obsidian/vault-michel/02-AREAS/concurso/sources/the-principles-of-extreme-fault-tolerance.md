---
title: "The principles of extreme fault tolerance"
type: source
source: "Clippings/The principles of extreme fault tolerance.md"
created: 2026-06-23
ingested: 2026-06-23
score: B
tags: [concurso, source-page]
---

## Tese central
---
title: "The principles of extreme fault tolerance"
source: "
author:
  - "[[Max Englander]]"
published: 2025-07-03
created: 2026-06-23
description: "The principles and processes we follow for fault tolerance."
tags:
  - "clippings"
---
[Max Englander](/blog/author/max) | July 3, 2025

PlanetScale is [fast](/blog/benchmarking-postgres) and reliable. Our speed is the best in the cloud due to our shared nothing architecture that enables us to utilize local storage instead of network-attached st

## Argumentos principais
### [Principles](#principles)
Our principles are neither new nor radical. You may find them obvious. Even so, they are foundational for our fault tolerance. Every capability we add, and every optimization we make, is either bound by or born from these principles.
**Isolation**
- Systems are made from parts that are as physically and logically independent as possible.

### [Architecture](#architecture)
Our architecture emerges from the principles above.
**Control plane**
- Provides database management functionality. Database creation, billing, etc.

### [Processes](#processes)
Within this architecture, we apply processes that reinforce our systems' overall fault tolerance.
**Always be Failing Over**
- Very mature ability to fail over from a failing database primary to a healthy replica.

### [Failure modes](#failure-modes)
How adherence to the principles, architecture, and processes above enable us to tolerate a variety of failure modes.

### [Non-query-path failures](#non-query-path-failures)
- Because our query path has extremely few dependencies, failures outside of the query path do not impact our customers' application queries.
- As an example, a hypothetical failure in one of our cloud providers' Docker registry services might impact our ability to create new database instances, but will not impact existing instances' ability to serve queries or store data.
- Likewise, failures, even total failure, of our control plane would impact our customer's ability to change their database cluster's settings, but would *not* impact that cluster's query service.

### [Cloud provider failures](#cloud-provider-failures)
We run on AWS and GCP, which can and do fail in many different ways.
#### [Instance](#instance)
- If a failure impacts a primary database instance, we immediately fail over to a replica.

### [PlanetScale-induced failures](#planetscale-induced-failures)
- A bug in Vitess or the PlanetScale Kubernetes operator rarely impacts more than 1-2 customers, thanks to our extensive use of feature flags to roll out changes.
- A failure resulting from an infrastructure change, like a Kubernetes upgrade, can have a bigger impact, but very rarely does because of how rigorously we test and gradually we roll out.


## Key insights
- Systems are made from parts that are as physically and logically independent as possible.
- Failures in one part do not cascade into failures in an independent part.
- Parts in the critical path have as few dependencies as possible.
- Each part is copied multiple times, so if one part fails, its copies continue doing its work.
- Copies of each part are themselves isolated from each other.
- When something fails, continue operating with the last known good state.
- Overprovision so a failing part's work can be absorbed by its copies.
- Provides database management functionality. Database creation, billing, etc.
- Composed of parts which are redundant, spread across multiple cloud availability zones.
- Less critical than the data plane, and so has more dependencies.

## Exemplos e evidências
See original source at `Clippings/The principles of extreme fault tolerance.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/benchmark]]
- [[03-RESOURCES/concepts/llm-ml-foundations/optimization]]
- [[03-RESOURCES/entities/AWS]]
- [[03-RESOURCES/entities/Uber]]
- [[03-RESOURCES/entities/Kubernetes]]
