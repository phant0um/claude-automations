---
title: "How Netflix Simplified Batch Compute with Kueue"
type: source
source: "Clippings/How Netflix Simplified Batch Compute with Kueue.md"
created: 2026-06-23
ingested: 2026-06-23
score: C
tags: [articles, source-page]
---

## Tese central
---
title: "How Netflix Simplified Batch Compute with Kueue"
source: "
author:
  - "[[Netflix Technology Blog]]"
published: 2026-06-22
created: 2026-06-23
description: "How Netflix Simplified Batch Compute with Kueue By Alvin Bao, Alex Petrov, Jennifer Lai, Aidan Sherr, and Samartha Chandrashekar As a part of the journey to transition Netflix’s compute …"
tags:
  - "clippings"
---
As a part of the journey to transition Netflix’s compute infrastructure to be more Kubernetes-native, we have leaned

## Argumentos principais
### Brief Overview of CMB and Titus
CMB is a managed batch solution that allows users and applications to execute and manage workloads that run to completion. Using a tenant hierarchy, workloads are managed and queued with ordered execution through priorities, and capacity is managed on a per-tenant basis. Workloads that are submitted to CMB are then run on Titus. The features of Titus relevant to CMB are workload federation across multiple cells (Kubernetes clusters) and federated capacity reservations. This means CMB can talk to a single Titus endpoint to get/submit workloads and update capacity reservations without having to worry about the underlying cell/cluster topology.

### CMB Tenant Hierarchy
Tenants provide a grouping mechanism for jobs submitted on behalf of certain organizations, platforms, or applications. Users can create and organize tenants however best suits their organization or use case. For example, an organization may use a single tenant across several applications or a complex hierarchical structure that matches its team and application ownership structure.
Tenants are associated with a capacity configuration. The capacity configuration defines the amount of compute capacity available to the tenant and provides certain guarantees around isolation from other tenants. The capacity configuration contains weight (used for fair sharing) and resource dimensions.
There are two types of tenants in CMB:

### Why Kueue?
CMB was created in 2018, before or alongside many of the open-source batch compute offerings available today. Over the years, as the Kubernetes ecosystem has evolved, many of the features that CMB offered or strived to offer have been included in these open source projects e.g., fair sharing, hierarchical tenants, capacity management, priority queuing. In addition, it became increasingly cumbersome to develop new features such as preemption when CMB was so far removed from the underlying Kubernetes cluster.

### Get Netflix Technology Blog’s stories in your inbox
Join Medium for free to get updates from this writer.
The team took a look at what it would take to modernize our batch abstraction and settled on Kueue for the following reasons:
1. Unlike other options such as YuniKorn or Volcano, Kueue does not replace pod scheduling by the kube-scheduler, allowing integration with existing Titus scheduling profiles. Replacing Titus scheduler profiles can fragment job placement, potentially harming efficiency.

### Migrating to Kueue
This initiative of migrating CMB workloads to Kueue became known as Netflix Batch. The key tenets of our migration were the following:
1. Migration should require zero lift for CMB end users and be completely transparent to them
2. No regressions in container launch rate and overall max throughput

### Netflix Batch User/Application Workload Submission Flow
The key difference between the old and new flows is that we defer queuing and scheduling to Kueue, which is enabled in each Kueue-enabled Titus cell. Titus federation routes the job to Kueue cells using our custom Kueue router.

### Netflix Batch User/Application Tenant Management Flow
For us as operators, the migration was as simple as clicking a button on a tenant in our UI (as shown in the example above). This also allows us to easily rollback changes if there were issues.
Under the hood, this enrollment converts internal tenants to [Cohorts]() and leaf tenants to a [ClusterQueue]() + [LocalQueue](). The capacity configuration on a given tenant is converted into resource flavors and nominal quotas. The architecture for this looks as follows:

### Lessons Learned
1. [Maintaining API parity]() with the existing system (vs exposing a new API surface) and migrating the underlying components as a first step derisked the project by unstacking bets while also ensuring we didn’t disrupt the customer experience.
2. Don’t wait until the end to migrate the most complex use case. We decided early on to migrate our largest and most complex customer first. This allowed us to build confidence that we could later migrate other customers to Netflix Batch without issues, and resulted in the production migration lasting only 4 weeks.
3. We had to run Kueue with much higher QPS, Burst, and groupKindConcurrency than the default configuration to meet our throughput needs. This was derisked early on by running load tests in a development environment that mimics Titus.

### Current State of Kueue at Netflix
Kueue is fully rolled out in production, with it managing millions of batch workloads. In the future, we’re looking at options to enroll more of Titus batch workloads into this more managed experience. We have also productionized more fair sharing and preemptions to address better utilization of reserved capacity. In addition, our learnings are being leveraged by other internal teams, including those building Kubernetes-native training infrastructure, to inform their job scheduling and queuing configurations.

### Fair Sharing and Preemption
With Kueue, [Preemption-based Fair Sharing]() allows Netflix Batch to maintain reservation semantics while lending resources to other tenants when those reservations are not in use. In addition, preemption allows Netflix Batch to preempt lower-priority workloads for higher-priority workloads. For our customers, this means that tenants can use more idle capacity from reservations, submit more jobs without the risk of starvation, and have quicker turnaround times for business-critical workloads.
An example preemption configuration on a ClusterQueue that we would be using is as follows:
```c

### Acknowledgement
This work would not have been possible without the great work of the entire Compute team at Netflix.


## Key insights
- "[[Netflix Technology Blog]]"

## Exemplos e evidências
See original source at `Clippings/How Netflix Simplified Batch Compute with Kueue.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/concurrency]]
- [[03-RESOURCES/concepts/llm-ml-foundations/rag.md]]
- [[03-RESOURCES/entities/Netflix]]
- [[03-RESOURCES/entities/Uber]]
- [[03-RESOURCES/entities/Kubernetes]]
