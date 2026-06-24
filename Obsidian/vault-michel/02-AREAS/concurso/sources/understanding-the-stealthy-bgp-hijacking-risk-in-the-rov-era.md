---
title: "Understanding the Stealthy BGP Hijacking Risk in the ROV Era"
type: source
source: "Clippings/Understanding the Stealthy BGP Hijacking Risk in the ROV Era.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [concurso, source-page]
---

## Tese central
The partial deployment of Route Origin Validation (ROV) poses an unexpected security threat known as stealthy BGP hijacking, *i.e.,* a particularly elusive form of BGP hijacking where malicious routes divert traffic without reaching (and thus alerting) the victims. This risk remains largely unexplored, with neither documented real-world incidents nor systematic characterization available. To bridge this gap, we formalize stealthy BGP hijacking and propose heuristics to discover potential instanc

## Argumentos principais
### I Introduction
The Border Gateway Protocol (BGP) has been known for its security vulnerabilities, with the infamous BGP hijacking being a major threat. To counter this threat, the community has proposed various security enhancements [^33] [^47] [^60] [^31] [^44] [^32] [^4], among which the Resource Public Key Infrastructure (RPKI) and Route Origin Validation (ROV) show the promise in real-world deployment. ROV-enabled Autonomous Systems (ASes) can retrieve authorized registries managed by RPKI, known as Route Origin Authorizations (ROAs), based on which they can verify the correctness of prefix-origin associations contained in received BGP announcements. As of March 2025, ROAs have covered 57.1% of globally routable IPv4 prefixes [^46], yet the deployment of ROV is relatively limited, with only hundreds to thousands of ASes identified as ROV-enabled [^34] [^10] [^30].
Presumably, ROV will remain in partial deployment for a relatively long time, which, in addition to offering incomplete protection as a consequence, results in an unexpected security threat, *i.e.,* *highly stealthy BGP hijacking that is effectively invisible from the victim on the control plane*. This new threat, which we refer to as ROV-related stealthy BGP hijacking, or for short, *stealthy hijacking*, occurs when an AS, despite being nominally protected by ROV-enabled ASes from receiving malicious routes, has its traffic silently diverted to a hijacker through legacy ASes along the data plane path. It is particularly insidious because the affected AS remains unaware of malicious routes throughout the hijacking, rendering common control-plane based protections ineffective in practice.
This highlights the unexpected downside of partial ROV deployment, yet the issue remains largely unexplored. No real-world stealthy hijacking incidents have been documented, and a systematic investigation into its prevalence and impacts is still missing. A recent study [^45] takes a pioneering step towards mitigating stealthy hijacking via proactive rerouting and blackholing. Yet, its mitigation-oriented focus provides limited real-world evidence or heuristics for tracking and profiling the threat (see further discussions in §IX).

### II Background
Interdomain Routing and BGP Hijacking. As of March 2025, the Internet comprises over 77,600 Autonomous Systems (ASes) in interdomain routing [^20], each identified by a unique AS Number (ASN). These ASes interconnect via the Border Gateway Protocol (BGP), where each AS announces its IP prefixes to neighbors through route announcements. Upon receiving an announcement, an AS extracts the AS-level path destined for a specified prefix, updates its Routing Information Base (RIB), and performs best-route selection. The chosen route is then appended with the AS’s own ASN and further propagated to selected neighbors. Both best-route selection and propagation are influenced by the AS’s routing policies, *e.g.,* predefined route preferences based on business relationships.
BGP lacks native security mechanisms and is vulnerable to misinformation injected by malicious actors. A consequent threat is BGP hijacking, where a malicious AS falsely claims to originate a prefix it does not own. If other ASes accept the forged announcement, they reroute traffic accordingly and divert it to the hijacker. BGP hijacking takes two forms: *exact-prefix hijacking*, where the hijacker announces the exact prefix owned by the legitimate origin, and *sub-prefix hijacking*, where a more specific sub-prefix is announced. The latter is typically more damaging, since BGP routers prioritize the longest-prefix match when forwarding traffic. Real-world BGP hijacking incidents have reported serious consequences, *e.g.,* redirecting cryptocurrency funds to attacker-controlled accounts [^14].
RPKI and ROV for BGP Security. To counter BGP hijacking, the community proposed various security extensions [^33] [^47] [^31]. Among them, Resource Public Key Infrastructure (RPKI) [^32] and Route Origin Validation (ROV) [^4] have gained significant real-world adoption. RPKI provides a cryptographic framework for prefix holders to publish Route Origin Authorizations (ROAs), which specify valid origin ASes and maximum allowable prefix lengths. Meanwhile, ROV refers to the operational practice by which ASes retrieve and verify these ROAs to validate BGP announcements, thereby ensuring that the announcing AS is authorized to advertise a specific prefix. Invalid BGP announcements are typically discarded.

### III Problem Statement
In this section, we articulate the unintended security risk of partial ROV deployment and define the relevant concepts.

### III-A The Unexpected Downside of ROV
ROV is proposed to prevent BGP hijacking. However, in case of partial deployment, its effectiveness can be undermined. Figure 1 illustrates a scenario where BGP hijacking succeeds despite ROV deployment. We abstract the Internet topology as a graph, where vertices represent ASes and edges represent interdomain links. In this scenario, the *hijacker* (AS G) launches an attack by announcing (sub-)prefixes owned by the *target* (AS E). The ROV-enabled ASes block propagation of malicious announcements, so only AS C and F may accept the bogus route to the hijacker <sup>1</sup> depending on routing policies.
We take AS A as an example to explain BGP hijacking in this scenario. As shown in Figure 1(a), AS A only receives routes to the target since ROV-enabled AS B correctly drops the hijacker’s malicious announcement. Consequently, AS A lacks a route to the hijacker in its routing table, limiting its control-plane visibility (see Figure 1(b)). AS A, unaware of the hijacker’s presence, expects its traffic to reach the target correctly (green arrow). However, from a global perspective (see Figure 1(c) and 1(d)), AS A’s traffic traverses legacy AS C en route to the target. If AS C accepts the hijacker’s route (*e.g.,* when the bogus route is preferred over the legitimate one or targets a sub-prefix), the traffic from AS A is actually forwarded to the hijacker. Note that AS A cannot observe the actual traffic forwarding unless it performs active data-plane probing or gains a broader view from external vantage points.
The above example showcases the unexpected downside of partial ROV deployment: *it prevents certain ASes from observing bogus routes, contributing to the stealthiness of BGP hijacking attacks.* We refer to such BGP hijacking, which is invisible to certain victims on the control plane, as stealthy hijacking. In general, an AS is at risk of stealthy hijacking when it has no route to the hijacker, but at least one legacy AS along the legitimate path accepts the bogus route; this applies to both exact-prefix and sub-prefix hijacking. Based on this principle, we formally define the risk in the next section.

### III-B Problem Formulation
Now, we formalize stealthy hijacking risk introduced by partial ROV deployment, starting from the Internet topology:
###### Definition 1 (Internet Topology).
An Internet topology is a tuple $G=(V,E,V_{rov})$ where $V$ is the set of all ASes in the Internet, $E$ is the set of links between ASes in $V$, and $V_{rov}\subseteq V$ is the set of ASes that adopt ROV.

### IV Uncovering Stealthy Hijacking in the Wild
In this section, we develop heuristics for stealthy hijacking discovery, and empirically investigate the threat in the wild.

### IV-A Heuristics for Stealthy Hijacking Discovery
From Definition 3, we derive practical heuristics to discover stealthy hijacking instances based on routing table discrepancies. For clarity, we denote $p:V\dotsm(M)\dotsm O$ a route to prefix $p$, where $V$ is the vantage point, $O$ is the origin AS, and $M$ (if present) represents an intermediate AS along the path. Given two routes $p_{1}:V_{1}\dotsm(M_{1})\dotsm O_{1}$ and $p_{2}:V_{2}\dotsm(M_{2})\dotsm O_{2}$, we examine the following conditions:
1. Conflict: $p_{2}$ equals or is a sub-prefix of $p_{1}$, and $O_{2}\neq O_{1}$.
2. Unauthorized: $p_{2}/O_{2}$ is RPKI-invalid while $p_{1}/O_{1}$ is valid.

### IV-B Real-World Observations and Insights
We now present our empirical study to track stealthy hijacking in the wild. Specifically, we analyze daily RIB snapshots taken at 12:00 UTC by the RouteViews [^58] collectors *route-views2*, *amsix*, and *wide*, starting from January 1, 2025. These collectors are based in North America, Europe, and Asia, respectively. Each daily archive contains about 50 million BGP routes from over 370 vantage points. For each day’s snapshot, we apply the loose heuristics to discover potential stealthy hijacking instances. To ensure prefix-origin legitimacy, we cross-check RIPE NCC’s RPKI database [^52], the RADb IRR database [^50], and the five RIRs’ WHOIS databases [^39], retaining only instances where the misbehaving origin is simultaneously RPKI-invalid, IRR-conflicting, and WHOIS-mismatching. To group related instances, we aggregate those affecting the same prefix into a single alarm, then merge alarms with the same misbehaving origin into a single incident.
To profile discovered incidents, we assign each incident with tags corresponding to predefined behaviors that either indicate route engineering or provide additional context. Table I details the tag definitions and data sources used. Incidents without any tags indicative of route engineering are considered particularly risky, while those linked to route engineering still exhibit stealthy hijacking but are more likely due to misconfigurations, such as improper route aggregation or private IP leasing without updating registries. Notably, incidents tagged *Direct View* follow the strict heuristics and are more reliable.
Findings. Over a two-month window starting January 1, 2025, we capture 1,394 potential stealthy hijacking incidents in the wild. Deduplicating them over the timeline yields 110 unique incidents. Figure 2 provides a detailed breakdown of them: 43 cases, with no signs of route engineering, are particularly risky, while the rest are attributed to bad operational practices. Among them, 91 involve sub-prefix hijacking, which tends to have more serious impacts, and 22 are directly observed from vantage points, thus of the highest confidence. In total, these incidents involve 4,278 routes observed by 50 vantage points, affecting 156 prefixes and 73 origins across 31 countries, as summarized in Table II. Over time, we observe 18-29 incidents per day, with 0-5 newly discovered daily (except on Day 1), as shown in Figure 3 (left). In terms of duration, 76 incidents (69.1%) persist for 7 days or fewer, while 17 (12.7%) last over 30 days, including 14 deemed bad operational practices, as shown in Figure 3 (right). Moreover, Figure 4 (left) shows that most incidents are seen by three or fewer vantage points, with over 40% visible to only one. This indicates a strong dependence of stealthy hijacking visibility on vantage point selection. Figure 4 (right) further confirms this: randomly removing just 20 vantage points leads to a 22% average drop in observable incidents, and up to 55% in the worst case.

### V The Shaman Framework
Figure 6: Workflow of the Shaman framework.
*“In ancient times, a shaman guided through unseen perils.”*

### V-A Overview
We present Shaman, a BGP route inference framework dedicated to analytical assessment of stealthy hijacking risk. As shown in Figure 6, Shaman takes AS relationships and ROV measurements from multiple sources as input. It then (i) reconstructs the Internet topology, (ii) performs matrix-based BGP route inference, and (iii) applies the strict heuristics to assess stealthy hijacking risk across the inferred routes.
The core rationale is to determine whether any AS along legitimate routes can forward traffic to potential hijackers. Achieving comprehensive risk assessment thus requires knowledge of both *all* routes to benign ASes and *all* routes to potential hijackers, posing a primary challenge given the Internet scale. To address this, Shaman compresses the Internet topology during reconstruction and extracts the benign reach and malicious reach, *i.e.,* the respective sub-topologies traversable by benign and malicious announcements ([see](#S5.F6 "Figure 6 ‣ V The Shaman Framework ‣ Understanding the Stealthy BGP Hijacking Risk in the ROV Era") ). By converting them into matrices, where each cell encodes compact routing information, Shaman iteratively updates these matrices through highly optimized matrix operations to infer Internet-wide routes ([see](#S5.F6 "Figure 6 ‣ V The Shaman Framework ‣ Understanding the Stealthy BGP Hijacking Risk in the ROV Era") ). It then identifies risk-critical ASes by checking each benign route with the malicious route set ([see](#S5.F6 "Figure 6 ‣ V The Shaman Framework ‣ Understanding the Stealthy BGP Hijacking Risk in the ROV Era") ). We elaborate on each step below.

### V-B Internet Topology Reconstruction
To reconstruct the Internet topology $G=(V,E,V_{rov})$, we use the CAIDA AS relationship dataset [^7] to obtain the set of ASes ($V$) and AS-to-AS links ($E$). Each link $(a_{i},a_{j},r)\in E$, where $a_{i},a_{j}\in V$, is associated with a relationship type $r\in\{\text{C2P},\text{P2P},\text{P2C}\}$. To determine the set of ROV-enabled ASes ($V_{rov}$), we consolidate measurements from three sources: APNIC [^30], RoVista [^34], and Cloudflare [^10]. APNIC and RoVista report ROV-filtering rates per covered AS, and we consider an AS to be ROV-enabled if its filtering rate is at least 80%, a confidence threshold adopted in prior work [^8] and also proved practical in our own experiments. Cloudflare, meanwhile, directly provides a list of ROV-enabled ASes. To maximize coverage, we include in $V_{rov}$ any AS identified as ROV-enabled by at least one of these sources.
We next compress the resulting topology. We notice that, under certain conditions, the routing table of a single-homed AS can be directly derived from its upstream transit AS, which exchanges all routes with it. As such, there is no need to include these single-homed ASes in the computationally intensive route inference process; instead, we remove them to form a *core topology* for route inference, and later recover their routing tables from their respective upstreams. This preserves the integrity of inferred routes while reducing the number of vertices by 36.3%, greatly improving inference efficiency. We defer details of the compression method in Appendix B.
From the core topology, we further derive the benign reach and the malicious reach. The benign reach, where benign announcements can propagate freely, is identical to the core topology, while the malicious reach, denoting the restricted area where malicious announcements can propagate as ROV-enabled ASes block them, is obtained by removing all ROV-enabled ASes from the core topology. Route inference is later performed on these reaches to obtain legitimate AS-level routes and potential AS-to-hijacker routes, respectively.

### V-C Matrix-Based BGP Route Inference
We leverage highly optimized matrix operations for efficient BGP route inference, addressing the limitations of existing methods [^3] [^17] [^36], which incur prohibitive overhead in generating complete BGP routes at the Internet scale.
Inference Criteria. We follow the same criteria commonly used in prior works [^45] [^22] [^41], which are derived from the Gao-Rexford model [^18] and capture typical BGP control-plane behaviors. Specifically, the best-route selection follows a three-step process: (i) prefer routes with the highest local preference, (ii) select routes with the shortest AS\_path, and (iii) break ties randomly. By default, local preference is set to reflect business incentives, *i.e.,* a route received from a customer is preferred over one from a peer, which is preferred over one from a provider. Additionally, the valley-free constraint [^18] is enforced in route propagation, *i.e.,* routes learned from a peer or provider are only forwarded to customers.
One-Byte Route Priority Encoding. Best-route selection is computationally intensive. To boost the process, we propose a one-byte route priority encoding that enables fast comparison and efficient update. Specifically, the priority of a route during selection is determined by two key properties, *i.e.,* local preference and path length. We use one byte to represent both:

### V-D Analytical Risk Assessment
Given the benign and malicious route sets, we systematically discover all potential stealthy hijacking instances. According to our strict heuristics, stealthy hijacking becomes possible only if the victim does not receive any malicious route to the hijacker (otherwise it is direct hijacking), while at least one intermediate AS on the benign victim-to-target route accepts a malicious route to the hijacker. Therefore, we iterate through all benign routes, treating the vantage point AS as the victim and the origin AS as the target. We then check all ASes to identify potential hijackers that satisfy these conditions:
- The hijacker is neither the victim nor the target.
- No victim-to-hijacker route exists in the malicious set.

### VI Assessing the Stealthy Hijacking Risk
In this section, we assess the stealthy hijacking risk posed by the current ROV deployment through Shaman.

### VI-A Framework Setup
Figure 7: The three ROV measurements and the consolidated results.
We implement Shaman in Python 3.10 and use Numba to compile matrix operations to low-level C code with GPU acceleration. It performs on a Linux platform with an Intel Xeon E5-2650 CPU and an NVIDIA GeForce RTX 2080Ti GPU. For Internet topology reconstruction, we use the CAIDA AS relationship dataset [^7] released on March 1, 2025, which contains 77,600 ASes and 709,737 AS relationships. The three ROV measurements are collected on the same date. APNIC [^30] reports 43,042 ASes, of which 2,575 exhibit an ROV filtering ratio of at least 80%. RoVista [^34] covers 32,486 ASes, with 6,655 meeting the same threshold. In addition, Cloudlare lists 165 ASes with full ROV filtering. Figure 7 summarizes their statistics. Collectively, we identify 7,275 ASes recognized as ROV-enabled by at least one source. This set forms our final input of ROV-enabled ASes to Shaman.
Using the AS relationship data and ROV measurements, we reconstruct the Internet topology. After compression, the resulting core topology contains 49,403 ASes (a 36.3% reduction) and 681,540 AS relationships (a 3.97% reduction). From this core topology, we derive both the benign reach and the malicious reach, and perform matrix-based BGP route inference on each. We run the inference for up to 20 iterations to ensure convergence. This generates the benign route set with 5,963,253,322 routes and the malicious route set with 2,399,622,350 routes. Based on these inferred routes, we discover the complete set of potential stealthy hijacking instances and conduct further assessment.


## Key insights
- We develop effective heuristics to discover stealthy BGP hijacking instances based on routing table discrepancies.
- We conduct the first empirical study to track stealthy BGP hijacking in the wild, establishing a curated real-world incident dataset and a long-term monitoring service.
- Motivated by empirical insights, we design Shaman, a framework dedicated to systematic assessment of stealthy BGP hijacking risk, and evaluate it extensively.
- Through Shaman, we assess stealthy BGP hijacking risk in the current Internet thoroughly, deriving seven key insights while achieving 95.9% incident-level accuracy.
- Tags in indicate route engineering practices, while tags in are informational.
- The notations are the same as in §IV-A.
- Two strings are deemed similar if their fuzz partial ratio score is greater than 90.
- The hijacker is neither the victim nor the target.
- No victim-to-hijacker route exists in the malicious set.
- There is an AS on the victim-to-target route for which the route to the hijacker exists in the malicious route set.

## Exemplos e evidências
See original source at `Clippings/Understanding the Stealthy BGP Hijacking Risk in the ROV Era.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/benchmark]]
- [[03-RESOURCES/concepts/software-engineering/runtime]]
- [[03-RESOURCES/concepts/llm-ml-foundations/inference]]
- [[03-RESOURCES/entities/NVIDIA]]
- [[03-RESOURCES/entities/Cloudflare]]
- [[03-RESOURCES/entities/Python]]
- [[03-RESOURCES/entities/CUDA]]
