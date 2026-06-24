---
title: "OptChain: Achieving Optimal Throughput of Permissionless Blockchains"
type: source
source: "Clippings/OptChain Achieving Optimal Throughput of Permissionless Blockchains.md"
created: 2026-06-23
ingested: 2026-06-23
score: B
tags: [articles, source-page]
---

## Tese central
We introduce OptChain, a permissionless blockchain state machine replication (SMR) protocol that achieves optimal throughput. We first establish a theoretical upper bound on the throughput of any SMR protocol under a fixed error probability, and OptChain is the first protocol to approach this limit. Conceptually, OptChain is a sharding protocol that optimizes both vertical and horizontal scalability.

## Argumentos principais
### I Introduction
State machine replication (SMR) protocols, including longest chain-based approaches such as Proof of Work (PoW) and Proof of Stake (PoS), as well as voting-based approaches such as Byzantine Fault Tolerance (BFT), have attracted significant attention since 2008, when Satoshi Nakamoto introduced the concept of blockchain [^21]. These protocols enable a network of nodes to reach agreement on a single, consistent state in the presence of Byzantine faults. However, existing SMR protocols, including Nakamoto consensus [^21] and Practical Byzantine Fault Tolerance (PBFT) [^6], inherently suffer from poor scalability, as their throughput is tightly constrained to ensure security. This tension is commonly referred to as the throughput-security trade-off. Numerous efforts have sought to improve this trade-off, including vertically scaling solutions (e.g., Bitcoin-NG [^12], Prism [^4], HotStuff [^25], DispersedLedger [^24]) and horizontally scaling solutions (e.g., sharding protocols [^20] [^19] [^27] [^8] [^23]). Despite these advances, existing approaches still fall short of achieving optimal throughput while maintaining strong security guarantees.

### I-A Optimal Throughput-Security trade-off
We consider a system of $n$ nodes with heterogeneous bandwidths, where a fraction $\alpha>\frac{1}{2}$ are honest. Let $\overline{C}$ and $\underline{C}$ denote the maximum and minimum node bandwidths, respectively, measured in transactions per second. We establish an upper bound on the optimal throughput-security trade-off: for any SMR protocol that ensures an error probability less than $\sigma$, the throughput cannot exceed $T=\frac{\overline{C}}{1-\sigma^{1/{\alpha n}}}$. The formal theorem is presented in Section IV-B.
This upper bound reveals two primary challenges in designing a SMR protocol to approach the theoretical optimum:
1. When $\sigma=0$, $T=\overline{C}$, indicating that the network must process transactions at the bandwidth of the fastest node.

### I-B Our Approach
We present OptChain, the first layer-1 SMR protocol that approaches the optimal throughput-security trade-off in a permissionless network. Fundamentally, OptChain is a sharding protocol that simultaneously maximizes both vertical and horizontal scalability, thereby inherently approaching the optimal throughput-security trade-off. The two challenges discussed above also represent the key barriers to maximize vertical and horizontal scalability, respectively.
Vertical scalability measures the improvement in throughput when computational and communication resources increase. When nodes in the network are configured with faster GPUs or higher bandwidths, the overall throughput should be increased. However, the throughput of most SMR protocols is limited by the slowest node with the lowest bandwidth. In a heterogeneous network with stragglers—nodes with limited bandwidth—their vertical scalability is significantly hindered. To enhance vertical scalability, we propose a novel permissionless verifiable information dispersal (PVID) protocol, shardis, enabling throughput to scale with the fastest nodes despite stragglers. Intuitively, nodes first agree on an ordered log of commitments, each serving as a compact digest (e.g., a Merkle root) of an available block. Subsequently, nodes download the full block data to update their state machines. This design ensures that state replication is driven by the fastest honest nodes, making throughput a function of the fastest rather than the slowest participants. Consequently, this approach effectively addresses Challenge-(1) and serves as a cornerstone for achieving the optimal throughput-security trade-off.
Horizontal scalability quantifies the improvement in throughput when the number of nodes increase. Sharding protocols have emerged as a promising approach to enhance horizontal scalability by dividing nodes into $S$ distinct shards, each maintaining an independent ledger. However, most existing designs [^20] [^19] [^27] require each shard to hold an honest majority—typically at least $1/2$ or $2/3$ of the shard’s nodes. By the law of large numbers, shard sizes must remain sufficiently large to keep the probability of adversarial-majority shards low. As a result, the number of shards (S) is inherently limited, which ultimately constrains horizontal scalability. We introduce the diffusion mining mechanism to ensure security as long as each shard contains at least one honest node, thereby maximizing $S$ and the horizontal scalability. Intuitively, diffusion mining allows honest nodes to diffuse their hashing power across shards by mining global availability blocks that can be appended to chains in all shards. Even if some shards exhibit adversarial majorities (referred to as corrupted shards), honest hashing power can be aggregated from other shards with honest majorities to secure them, ensuring the effective honest hashing power exceeds $50\%$. This approach effectively addresses Challenge-(2), serving as another cornerstone for approaching the optimal throughput-security trade-off.

### I-C Main Contribution
We highlight our contributions as follows:
1. We establish an upper bound on throughput that constrains any permissionless SMR protocol.
2. We propose shardis, a novel PVID scheme that outperforms existing solutions, providing a pathway to optimal vertical scalability in permissionless systems.

### II Related Work
Many works have sought to enhance blockchain scalability, either vertically or horizontally, yet none have achieved optimality in both dimensions.
Vertically Scaling Solutions. Among existing solutions [^12] [^4] [^25] [^24], Prism stands out as the most vertically scalable permissionless protocol. Its throughput approaches the physical limit, the network’s communication capacity, scaling linearly with the bandwidth of the slowest node. Prism decomposes the blockchain into three fundamental functionalities: leader election, transaction proposal, and ancestor voting. Accordingly, a full block is divided into three distinct components, proposer blocks, transaction blocks, and voter blocks, each corresponding to one of these functions. This decoupling enables fast consensus on lightweight proposer blocks and allows each to reference arbitrary number of transaction blocks, scaling throughput toward the network’s communication capacity. However, a significant gap remains between Prism’s throughput and the optimal, as it is limited by the slowest node’s bandwidth, not to mention its zero horizontal scalability.
Horizontally Scaling Solutions. Sharding protocols are a fundamental approach to achieving horizontal scalability. Most existing sharding protocols [^20] [^19] [^27] require each shard to maintain an honest majority, limiting the number of shards and hindering horizontal scalability. Manifoldchain [^8] addresses this limitation by tolerating corrupted shards, ensuring cross-shard security as long as each shard contains at least one honest node. It introduces two block types: exclusive blocks, which function like regular blocks, and inclusive blocks, which can be appended to all shard chains. Inclusive blocks allow honest nodes to distribute their hashing power across shards, reinforcing the security of those shards with weaker honest hashing power. However, while Manifoldchain maximizes horizontal scalability, its throughput within each shard remains comparable to Bitcoin, reflecting poor vertical scalability. Motivated by this limitation, we leverage a similar methodology to design diffusion mining, distinguishing our approach by allowing shard throughput to approach the bandwidth of the fastest node.

### III-A Scalable SMR via Sharding
An SMR protocol, as its name suggests, enables multiple machines to agree on the same state despite Byzantine behavior. In this context, a client–server model is typically assumed: We consider a system of $n$ servers, each maintaining a replica of the state machine, where up to a fraction $\beta=1-\alpha$ of them are malicious. Clients submit transactions to all servers to update or read the machine state. The servers then execute an SMR protocol to agree on a consistent, totally ordered log of transactions, which they subsequently execute to maintain the replicated state. For simplicity, we use the term node instead of server, as both share the same meaning but node is more common in the blockchain context.
Traditional SMR protocols suffer from poor scalability in large-scale networks, as every node must replicate the entire machine state, resulting in significant overlap in communication and computation overhead. The blockchain sharding protocol is proposed to address this problem. It partitions the nodes into multiple shards, each responsible for executing a distinct subset of transactions. Specifically, both transactions and nodes are assigned shard identifiers (IDs), and a node only executes transactions that share its shard ID. This design enables different nodes to work in parallel, allowing the overall system throughput to scale proportionally with the number of shards—and inherently, with the number of nodes. Formally, a sharding protocol provides the following properties, which can be categorized as intra-shard and cross-shard security properties:
###### Definition 1 (Intra-shard Security Property).

### III-B Verifiable Information Dispersal
Verifiable Information Dispersal (VID) is an effective approach for reducing communication overhead in blockchains, and has been adopted by many permissioned protocols [^24] [^7]. Specifically, it allows a node to run a dispersal protocol to distribute blocks across various nodes, and later execute a retrieval protocol to reconstruct the original block. Through this process, honest nodes can agree on a block’s availability by downloading only a block fragment. We present the formal definition of VID below, consistent with prior works [^24] [^5].
###### Definition 3.
A Verifiable Information Dispersal scheme consists of three core procedures:

### III-C Coded Merkle Tree
As previously mentioned, our protocol ensures security even if each shard contains only a single honest node. The Coded Merkle Tree (CMT) [^26] is a crucial building block for this, because it provides constant-cost protection against data availability attacks, even when the majority of nodes are malicious. Specifically, CMT employs an $(vd,d)$ erasure code to introduce redundancy: a block $B$ of $b$ bytes is evenly divided into $d$ data symbols, $B=[m_{1},\dots,m_{d}]$, each of size $\frac{b}{d}$ bytes. These symbols are linearly combined to produce a coded block $CB=[c_{1},\dots,c_{vd}]$, where $v$ denotes the coding rate. The original block $B$ can be reconstructed from any $d$ of the $vd$ coded symbols. When constructing the Merkle tree, the second layer is built on the coded block’s symbols and re-encoded with the same erasure code to form the third layer. This process repeats iteratively until the final root is obtained.
Any honest node can verify full data availability by downloading only a block commitment of size $O(1)$ bytes and randomly sampling $O(\log b)$ bytes. Specifically, given a block $B$, CMT encodes the block and computes its commitment. If every honest node requests $O(\log b)$ bytes upon receiving the commitment, the following properties hold:
- Soundness: If an honest node determines that a block is available, then at least one honest node will be able to recover the block within a constant delay.

### IV Throughput-Security Trade-off
In this section, we introduce a formal model for analyzing security and throughput, and establish a fundamental upper bound on the throughput of any permissionless SMR protocol.

### IV-A Security Model
We summarize our assumptions below, which are consistent with those commonly adopted in permissionless blockchain protocols [^21] [^4] [^23] [^8].
- The system comprises $n$ nodes, denoted by $\{P_{1},\dots,P_{n}\}$, operating in a synchronous and permissionless network.
- A weakly adaptive adversary controls a fraction $\beta<1/2$ of the nodes, while the remaining fraction $\alpha=1-\beta$ are honest. Corruption is dynamic but requires a delay to effectuate.

### IV-B Optimal Throughput
We derive the optimal throughput under these assumptions above. We also provide the intuition behind this upper bound, while the formal proof is deferred to Appendix B.
###### Theorem 1.
If an SMR protocol guarantees that the probability of any confirmed transaction violating at least one of the security properties is bounded by $\sigma$, then the upper bound on throughput is $T^{*}=\frac{\overline{C}}{1-{\sigma}^{\frac{1}{\alpha n}}}$.

### V OptChain
OptChain approaches the optimal throughput by simultaneously maximizing vertical and horizontal scalability. To better illustrate this, we start by showing how to maximize vertical scalability, i.e., optimizing the performance of a single chain, then extend the design to multiple shard chains to demonstrate how optimal horizontal scalability can be achieved. Intuitively, OptChain maximizes vertical scalability by implementing a permissionless VID protocol. Nodes first agree on an ordered log of block commitments, and then independently download the corresponding transactions to update their state machines at their own pace. Once each shard’s throughput is optimized, OptChain employs diffusion mining to design a multi-chain structure, supporting an optimal number of shards, thereby maximizing horizontal scalability.
The full structure of OptChain is shown in Fig. 1. OptChain consists of three distinct chains, each serving a specific function. First, nodes mine a proposer chain, where each proposer block contains commitments of multiple transaction blocks. Second, nodes verify the availability of these commitments by mining $S$ availability chains. Each availability block in the $i$ -th chain includes references to commitments that (1) are confirmed in the proposer chain, and (2) correspond to transaction blocks belonging to shard $i$. Finally, nodes mine an ordering chain that references confirmed availability blocks across shards, establishing a global order for the availability blocks across shards.
Figure 1: The structure of OptChain, which comprises five block types. Proposer blocks form a global beacon chain (left) that references multiple transaction blocks by including their commitments. Availability chains (middle) span S shards, where availability blocks reference transaction blocks to vote on their availability. While local availability blocks extend a single chain, global availability blocks extend all availability chains simultaneously. Finally, the ordering chain (right) consists of ordering blocks that sequence the availability blocks to impose a global order.

### V-A Block and Chain Structures
In OptChain, blocks are classified as proposer, transaction, availability, and ordering blocks. Each transaction block $B_{t}$ is assigned a shard ID. It contains $t$ transactions in the corresponding shard and a root computed by CMT, which serves as its commitment $\mathtt{com}$.
- Transaction block $B_{t}$:
1. $\mathtt{shard\_ID}$: an index denoting the specific shard to which the block is affiliated.

### V-B Shardis
Our permissionless VID scheme is designed based on the following intuition: The block producer broadcasts $\mathtt{com}$ when it initiates Disperse($B$) $\rightarrow$ $\mathtt{com}$. Nodes randomly request symbols upon receiving $\mathtt{com}$ and verify availability once all requested symbols are received. Nodes then run a longest chain-based protocol to agree on an ordered list of available $\mathtt{com}$. By the protocol’s safety, every honest node will have the requested symbols for any confirmed $\mathtt{com}$. With an estimated $\alpha n$ honest nodes and a properly chosen symbol threshold per node, the full block can be reconstructed except with a negligible probability.
A naive implementation of this high-level idea can be achieved by slightly modifying an existing protocol, such as Prism. Unlike the nodes in the original Prism protocol, who accept a block only after receiving it in full, the nodes in our initial protocol accept a block upon receiving all the requested symbols of that block. However, this initial protocol faces a significant challenge. The adversary can propose an unavailable block, releasing only partial symbols, and respond solely to nodes requesting them. This can deceive a portion of honest nodes who request the released symbols, leading them to accept the block, while others reject it, causing a split view. Furthermore, the adversary can conceal any number of unavailable blocks and propose them simultaneously, causing an arbitrary number of honest nodes to split their views.
To resolve the above challenges, we consolidate our permissionless VID scheme by applying the following high-level insights:

### V-C Diffusion Mining
Our initial idea for extending the above design into a sharding protocol is to have all nodes collectively mine a single proposer chain, while nodes within each shard mine their respective availability chains. Specifically, the proposer chain references transaction blocks across all shards, whereas the $S$ availability chains operate in parallel, with each node producing availability blocks exclusively for its assigned shard. However, each shard must have sufficient nodes to ensure an honest majority. To overcome this limitation, we introduce a diffusion mining that secures each shard even when only one honest node is present.
Diffusion mining classifies availability blocks into two types: local availability blocks and global availability blocks. While a local availability block operates within a single shard, a global availability block can extend all chains across shards. In a longest chain-based protocol, the number of valid blocks reflects hashing power, and security is maintained as long as honest blocks outnumber adversarial ones. Diffusion mining allows honest nodes to distribute their hashing power across shards, thereby securing those with weaker honest hashing power. We adopt this mechanism to strengthen our design:
Availability chains (Verify). Each $\mathtt{com}$ inherits a shard ID $i$ from its corresponding transaction block. Nodes within shard $i$ mine an availability chain, where each availability block references only the $\mathtt{com}$ (s) associated with shard $i$.


## Key insights
- Safety: If two honest nodes in the same shard execute sequences of transactions $\{\mathtt{tx}_{1},\ldots,\mathtt{tx}_{j}\}$ and $\{\mathtt{tx}^{\prime}_{1},\ldots,\mathtt{tx}^{\prime}_{j^{\prime}}\}$, then $\mathtt{tx}_{i}=\mathtt{tx}^{\prime}_{i}$ for all $i\leq\min\{j,j^{\prime}\}$.
- Liveness: If an honest client sends a transaction $\mathtt{tx}$ to all nodes at time $t$, then $\mathtt{tx}$ will eventually be executed by all honest nodes in a specific shard by time $t+u$.
- Disperse($B$) $\rightarrow$ $\mathtt{com}$: A deterministic algorithm executed by the proposer of a block $B\in\{0,1\}^{*}$ to initiate the dispersal process and returns a block commitment $\mathtt{com}$.
- Verify($\mathtt{com}$) $\rightarrow$ $\{0,1\}$: A randomized interactive protocol invoked by validators to determine whether the dispersal of the block associated with commitment $\mathtt{com}$ has completed. It outputs $1$ if the dispersal is complete, and $0$ otherwise.
- Retrieve($\mathtt{com}$) $\rightarrow B$: An interactive protocol invoked by a node to recover a data block $B\in\{0,1\}^{*}$.
- Termination: If an honest node invokes Disperse($B$), it eventually gets an output $\mathtt{com}$, and all honest nodes eventually output Verify($\mathtt{com}$) $=1$.
- Agreement: If any honest node outputs Verify($\mathtt{com}$) $=1$, then every honest node will do the same within a network delay of $\Delta$.
- Retrievability: If an honest node outputs Verify($\mathtt{com}$) $=1$, then any honest node that invokes Retrieve($\mathtt{com}$) eventually reconstructs some block $B^{\prime}$.
- Correctness: For any two successful Retrieve($\mathtt{com}$) calls that yield $B_{1}$ and $B_{2}$, where Verify($\mathtt{com}$) $=1$, it holds that $B_{1}=B_{2}$. Furthermore, if $\mathtt{com}$ was generated by an honest node via Disperse($B$), then $B_{1}=B$.
- Soundness: If an honest node determines that a block is available, then at least one honest node will be able to recover the block within a constant delay.

## Exemplos e evidências
See original source at `Clippings/OptChain Achieving Optimal Throughput of Permissionless Blockchains.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/orchestrat]]
- [[03-RESOURCES/concepts/llm-ml-foundations/diffusion]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/AWS]]
- [[03-RESOURCES/entities/Rust]]
- [[03-RESOURCES/entities/Python]]
