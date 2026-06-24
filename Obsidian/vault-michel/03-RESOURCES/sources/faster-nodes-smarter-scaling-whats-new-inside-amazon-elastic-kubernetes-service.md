---
title: "Faster nodes, smarter scaling: What’s new inside Amazon Elastic Kubernetes Service (Amazon EKS) Auto Mode"
type: source
source: "Clippings/Faster nodes, smarter scaling What’s new inside Amazon Elastic Kubernetes Service (Amazon EKS) Auto Mode.md"
created: 2026-06-23
ingested: 2026-06-23
score: C
tags: [articles, source-page]
---

## Tese central
---
title: "Faster nodes, smarter scaling: What’s new inside Amazon Elastic Kubernetes Service (Amazon EKS) Auto Mode"
source: "
author:
published: 2026-06-23
created: 2026-06-23
description: "In this post, we walk through the performance and scalability improvements we shipped across the four pillars of EKS Auto Mode: runtime, compute, storage, and networking."
tags:
  - "clippings"
---
When you’re running production Kubernetes workloads, every second matters. The time a node takes to become re

## Argumentos principais
### Runtime: Faster nodes, fewer surprises
EKS Auto Mode manages the node operating system, bootstrap process, and system daemons on your behalf. The improvements in this section reduce startup latency, improve memory resilience, and accelerate container image pulls.

### 39 percent faster node startup
When you scale up in EKS Auto Mode, new [Amazon Elastic Compute Cloud (Amazon EC2)]() instances must bootstrap Kubernetes components before they can accept workloads. We profiled the boot sequence and identified that our service-readiness detection was adding unnecessary latency. The system was designed to poll services at conservative intervals appropriate for steady-state health monitoring, but these same intervals were being used during startup. This caused systemd to wait several seconds after a service was actually ready before starting dependent services.
**The fix:** a fast-path startup detection mode that checks readiness at sub-second intervals during boot, then transitions to standard health-check intervals for ongoing monitoring. The result: mean Node Ready latency dropped by 39 percent (13 seconds). For clusters scaling dozens or hundreds of nodes simultaneously, this compounds into significantly faster time-to-workload.

### Memory stability with zram
On smaller instance types, EKS Auto Mode’s system components (kubelet, containerd, the Amazon Virtual Private Cloud (Amazon VPC) CNI agent, CoreDNS, and kube-proxy) share memory with your workload pods. Under normal operation this is fine, but transient spikes can temporarily push the node past its memory limit. For example, kubelet performing garbage collection, a large pod listing, or a burst of DNS queries can cause pressure. Without intervention, the Linux out-of-memory (OOM) killer terminates a process, often one of the system components themselves, causing the node to transition to NotReady and triggering unnecessary pod rescheduling.
The key insight is that zram protects the infrastructure layer without affecting workload performance. Pods with properly configured resource limits and requests behave identically: their memory accounting doesn’t change. The system daemons keeping the node healthy now have a safety buffer against brief memory contention. They no longer become the first casualty of an OOM event.
Auto Mode nodes now run zram to absorb these transient spikes. zram creates a compressed swap device backed entirely by memory: no disk I/O, no EBS volumes, no added latency. When memory pressure rises, the kernel identifies pages that haven’t been accessed recently and compresses them in-place using LZ4 (typically achieving 2–4x compression). A page occupying 4 KB compresses down to approximately 1–2 KB, and the freed space becomes immediately available to whichever process needs it. If the compressed page is accessed again later, decompression takes microseconds, effectively invisible to the application.

### Faster container image pulls
Three improvements speed up how quickly containers start on Auto Mode nodes. First, we increased kubelet’s `registryPullQPS` from 5 to 25 and `registryBurst` from 10 to 50. This removes an artificial throttle that prevented nodes from pulling images in parallel at full network speed.
Second, for instance types with local NVMe storage (common for GPU and machine learning (ML) workloads), we optimized image decompression to take advantage of the faster local disk. Container layers are decompressed directly onto NVMe rather than network-attached EBS, significantly reducing image pull time for large ML framework images that can exceed 20 GB.
Third, we turned on Seekable OCI (SOCI) parallel pull and unpack for G, P, and Trn family instances with local NVMe storage. SOCI allows containers to start before the full image is downloaded. Only the layers needed for initial execution are pulled first, with the rest streaming in the background. SOCI runs by default for these instance families in EKS Auto Mode. No configuration is required.

### Automatic security hardening
When you configure a custom AWS Key Management Service (AWS KMS) key on your NodeClass, EKS Auto Mode encrypts the entire disk surface, covering both the read-only root volume and the read/write data volume. This provides full encryption coverage with no additional configuration.

### Compute: Scaling faster and smarter with Karpenter
EKS Auto Mode uses Karpenter to manage node lifecycle: provisioning right-sized instances for pending pods and consolidating underutilized nodes to reduce cost. In 2025 and 2026, we shipped dozens of optimizations that make Karpenter faster at both scaling out and scaling in. The benchmark results in the following section quantify the gains.

### What changed
The improvements span five areas:
1. **Scheduling simulation:** We cache pod resource requests and requirements in memory, eliminating recomputations during scheduling loops. Hostname topology operations went from O(n) to O(1), and instance types are pre-filtered based on NodePool requirements before simulation begins.
2. **Memory efficiency:** Removed unnecessary object copies in hot paths, reducing garbage collection pressure that was causing latency spikes in large clusters.

### Results
**The benchmark:** a workload scaling from 0 to 1,000 pods across 250 nodes (m5.xlarge instances in us-east-1, running a CPU-bound scheduling simulation workload), then consolidating down:
| **Metric** | **Before** | **After** | **Improvement** |
| --- | --- | --- | --- |

### Customer impact
One enterprise customer with over 10,000 pending pods was seeing 23-minute provisioning delays. The scheduling simulation was exceeding the expiration window for capacity-error instance types, causing repeated retries against unavailable capacity. After these optimizations, their scale-out improved significantly.

### Storage: Smoother EBS integration
Many teams adopt EKS Auto Mode incrementally, running Auto Mode nodes alongside existing managed node groups or self-managed nodes during migration. The following improvements help Amazon Elastic Block Store (Amazon EBS) volumes work without disruption in these mixed environments.

### Topology-aware volume scheduling
If you’re running EKS Auto Mode alongside traditional managed node groups during migration, you might need to restrict EBS volumes so they only attach to Auto Mode nodes. We added support for `allowedTopologies` on StorageClasses:
```yaml
kind: StorageClass

### Migration tooling
For clusters transitioning to Auto Mode, we released a migration tool that converts existing `ebs.csi.aws.com` StorageClass volumes to the Auto Mode EBS StorageClass. The migration runs with no data loss and no workload disruption.

### Networking: Local-first, zero-configuration
EKS Auto Mode runs core networking components (CoreDNS, VPC CNI, and kube-proxy) as systemd services on each node rather than as cluster pods. This removes circular dependencies during startup, scales networking with node count automatically, and improves reliability through OS-level process management.

### Node-local DNS
In traditional EKS clusters, pod DNS queries traverse the cluster network to reach CoreDNS pods. In Auto Mode, every node runs its own CoreDNS instance. DNS queries always resolve locally, and don’t leave the node. Because CoreDNS runs as a systemd process rather than a pod, it doesn’t consume a pod IP address from your VPC subnet. At scale, this saves one IP per node that would otherwise be allocated to a CoreDNS pod.
Earlier this year, we fixed two DNS issues on EKS Auto Mode nodes. First, a CoreDNS pod scheduled on the same Auto Mode node as a querying pod could hijack queries from that pod. Those queries now always go through the node-local DNS, giving consistent low-latency resolution. Second, Auto Mode nodes can now resolve `kube-dns.kube-system.svc.cluster.local` correctly even when no `kube-dns` Service is installed in the cluster.

### Separate pod subnets and security groups
You can now specify `podSubnetSelectorTerms` and `podSecurityGroupSelectorTerms` on your Auto Mode NodeClass. The two fields must be set together, and they’re additive to `subnetSelectorTerms` / `securityGroupSelectorTerms` (which still apply to the node’s primary Elastic Network Interface (ENI)).
```yaml
apiVersion: eks.amazonaws.com/v1


## Key insights
- Node boot time reduced 39 percent (13 seconds faster) through startup detection optimization.
- Karpenter, the node lifecycle manager in EKS Auto Mode, delivers 43 percent faster scale-out. Consolidation is up to 69 percent faster, with 30 percent more cluster capacity.
- Node-local DNS delivers sub-millisecond resolution without cluster-wide bottlenecks.
- Separate pod subnets and security groups bring enterprise networking to Auto Mode.
- All improvements ship automatically. No configuration changes are required for clusters already running EKS Auto Mode.
- matchLabelExpressions:
- key: eks.amazonaws.com/compute-type
- [Amazon EKS Auto Mode documentation](): Learn how Auto Mode works and how to turn it on.
- [EKS Auto Mode public change log](): Track ongoing improvements.
- [Karpenter documentation](): Deep dive into compute lifecycle management.

## Exemplos e evidências
See original source at `Clippings/Faster nodes, smarter scaling What’s new inside Amazon Elastic Kubernetes Service (Amazon EKS) Auto Mode.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/software-engineering/runtime]]
- [[03-RESOURCES/concepts/llm-ml-foundations/kernel]]
- [[03-RESOURCES/entities/AWS]]
- [[03-RESOURCES/entities/Uber]]
- [[03-RESOURCES/entities/Kubernetes]]
