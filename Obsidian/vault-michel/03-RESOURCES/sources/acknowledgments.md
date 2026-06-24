---
title: "Acknowledgments"
type: source
source: "Clippings/Acknowledgments.md"
created: 2026-06-23
ingested: 2026-06-23
score: D
tags: [ai-agents, source-page]
---

## Tese central
The widespread deployment of Deep Neural Networks and Large Language Models (LLMs) relies on a foundational assumption of isolation that this dissertation challenges. This work systematically deconstructs security assumptions around AI and modern cloud Infrastructure through a taxonomy of interaction levels that ranges from physical memory co-location to remote service interfaces. While significant research has addressed individual attack surfaces in isolation, the security community lacks a uni

## Argumentos principais
### Chapter 1 Introduction
Motivated by the rapid accelerating growth in the AI industry, this dissertation explores the security assumptions around a hierarchy of interaction levels an attacker can have with a victim on modern cloud infrastructure. These interaction levels are mainly driven by cost and speed, as hyperscalers attempt to build complex cloud systems rapidly and cheaply for the accelerated adoption of AI systems. While the need to build systems competitively and cheaply is important, it is also important to build these systems safely, analyzing systems holistically about a range of threat models.
The first threat model investigated within this taxonomy involves an adversary who possesses read access to shared data files mapped into their own memory space, as seen by the first threat model in Figure 1.1. Modern operating systems frequently employ memory deduplication and file-backed mappings via system calls such as mmap to optimize resource usage between users. While these mechanisms typically enforce write protection to prevent direct tampering, this dissertation demonstrates that read access provides a sufficient foothold for both model corruption and granular information extraction.
The analysis next restricts the threat model to scenarios where the attacker and victim share physical hardware but lack shared memory access (no mmap) as seen by the second threat model in Figure 1.1. In this environment, vulnerabilities arise from the shared microarchitectural resources of the Central Processing Unit (CPU) and the necessity of spilling internal state to main memory.

### 2.1 Rowhammer Attacks
DRAM Architecture DRAM is structured as a grid of memory cells, with each cell consisting of a capacitor and an access transistor. The capacitor stores a bit value (either 1 or 0) while the transistor controls access to this stored charge. These cells are organized in arrays, where word lines control rows of cells and bit lines connect to columns. When accessing memory, the word line activates, connecting the capacitors to their respective bit lines. Sense amplifiers detect the small voltage differences and amplify them to recognizable logic levels. This architecture efficiently stores data but creates inherent vulnerabilities due to the physical proximity of cells and their electrical characteristics.
Rowhammer Attack Mechanics The Rowhammer vulnerability exploits the physical limitations of DRAM by repeatedly activating (hammering) specific memory rows to induce bit flips in adjacent rows. This occurs because each activation introduces electrical disturbance that marginally depletes charge from nearby cells. While individual activations cause minimal disturbance, repeated activations within the refresh interval can accumulate sufficient disturbance to flip bits in victim rows.
In the traditional double-sided Rowhammer attack, an attacker activates two rows (hammer rows) that flank a target victim row. This configuration maximizes the disturbance effect on the victim row, as it receives interference from both sides. Seaborn and Dullien [^114] demonstrated that such attacks could achieve privilege escalation on real systems by deliberately inducing bit flips in page tables.

### 2.2 Cache And LLM Side Channel Attacks
LLM Rowhammer Vulnerabilities LLMs are vulnerable to Rowhammer attacks due to their large memory footprint during inference, static memory allocation patterns, and architectural vulnerabilities. Recent research demonstrates the severity of these threats: [^31] showed that fewer than 25 targeted bit-flips can jailbreak commercial-scale models to bypass safety measures without modifying input prompts, while [^38] revealed that just three strategic bit-flips in critical parameters can cause catastrophic model failure, reducing task accuracy from 67.3% to 0% in billion-parameter LLMs like LLaMA3-8B. These attacks highlight how minimal memory corruptions can have devastating consequences for model security and performance, even in systems designed to resist Rowhammer attacks.
###### Memory Hierarchy in Modern Processors.
Contemporary CPUs are designed with a multi-level cache hierarchy to improve computational efficiency. This hierarchy typically includes small, fast Level 1 (L1) caches closest to the CPU cores, larger Level 2 (L2) caches, and even larger shared Level 3 (L3) caches [^68]. The cache hierarchy serves to reduce the latency of memory accesses by storing frequently accessed data closer to the processor.

### 2.3 Service Level Attacks
###### Security Implications.
While page deduplication offers memory efficiency benefits, it introduces security vulnerabilities that can be exploited by side-channel attacks [^52]. The shared nature of deduplicated pages enables attackers to perform high-resolution cache side-channel attacks like Flush+Reload [^143]. Since the attacker and victim processes share physical memory pages, the attacker can monitor cache access patterns to infer sensitive information from the victim.
Moreover, page deduplication can be abused to circumvent Address Space Layout Randomization (ASLR), a security mechanism that randomizes memory addresses to prevent exploitation [^43]. By detecting whether a page has been merged, attackers can gain insights into the memory layout of the victim process.

### 3.1 Introduction
The widespread deployment of Large Language Models (LLMs) has revolutionized natural language processing tasks, enabling applications in various domains such as finance, healthcare, and customer service. However, the increasing reliance on these models raises significant concerns about privacy and security, especially in multi-user environments where shared hardware resources can be exploited.
###### Hardware Cache vs. KV Cache Leakage.
Despite these efforts to secure software-level KV caches, no prior work (to our knowledge) focuses on microarchitectural caches in the LLM inference pipeline. Existing KV cache defenses do not address an attack that occurs below the software layer, specifically targeting the CPU’s cache hierarchy where embedding matrices and other model parameters reside. In contrast to KV caches—which are generally managed in user-space and can be directly patched or permuted—hardware caches are governed by the CPU microarchitecture, making them substantially harder to protect through conventional software approaches.

### 3.2 Leaking API Keys
In modern development workflows, it is not uncommon for end-users to embed API keys or other credentials directly into their LLM prompts, trusting the model to produce corresponding code snippets or instructions for integration into their applications. Unfortunately, this practice presents a critical vulnerability. Even under strict software isolation, a side-channel adversary leveraging Spill The Beans can recover such sensitive tokens as they appear in shared hardware memory during generation. Our demonstration, as outlined in Figure 3.7, shows that Spill The Beanscan reveal the full API key embedded in the LLM-generated code snippet, making it trivial for an attacker to assume the victim’s identity in downstream services.
</span><span id="Ch3.F7.pic1.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.p2"></span></span></span></foreignObject></g></g></svg>
Figure 3.7: Example of a chat interaction showing potentially sensitive information being shared in a prompt.

### 3.3 Leaking Plain English
While our initial experiments focused on leaking high-entropy tokens such as API keys, we next examined a setting where only plain English text was exchanged with the LLM. The underlying premise is that, despite lacking prior knowledge of the user’s query or response content, an attacker can still infer a significant fraction of the generated English tokens by selectively monitoring the most frequently used words.
###### Building the Monitor Set.
To construct a representative set of tokens, we utilized the Cornell Movie Dialogs corpus and extracted raw script lines for frequency analysis. By sorting words according to how often they appeared across the dataset, we identified the 1,000 most frequent tokens, which primarily consisted of articles, conjunctions, prepositions, and other common English words (e.g., and, the, it, to). Importantly, LLM tokenization often splits words into subword units, so we aligned each high-level word from our analysis with its corresponding GGUF token IDs to ensure the monitor set was accurate for our target model. This reliance on high-frequency English tokens is directly tied to the well-known Zipf’s law, which describes the inverse power-law distribution of word frequencies in natural languages. Specifically, Zipf’s law posits that the frequency of the $n$ -th most common word is roughly proportional to $1/n$. Interestingly, even random text generation can exhibit a similar rank-frequency relationship [^84], where the transformation from a word’s length to its rank effectively stretches an exponential distribution into a power law. This phenomenon implies that a handful of words often constitute a large proportion of written material. Thus, focusing on the 1,000 most frequent tokens captures a substantial fraction of likely English text, enhancing the feasibility of monitoring these tokens via Flush+Reload in a practical side-channel attack scenario.

### 3.4 Further Improvements
The methodology outlined in this dissertation, while successful at leaking a considerable fraction of tokens through Flush+Reload, can be extended in several ways to further optimize leakage coverage and detection reliability. We briefly highlight three promising directions below.
###### Alternate Cache Side-Channels.
Although Flush+Reload has proven to be effective and straightforward under shared-memory conditions, other microarchitectural attacks like Prime+Probe and Prime+Scope [^72] [^109] may enhance long-term visibility into victim accesses. In Prime+Probe, for instance, the attacker primes a cache set with its own data and later measures the time to probe that set, detecting evictions by the victim’s accesses without requiring shared pages. Prime+Scope narrows the granularity of probing to individual ways or slices, further improving signal quality. Both methods can potentially provide more stable observations and allow monitoring of a larger set of target tokens without risking frequent eviction misses. However, these strategies demand a deeper understanding of cache indexing and associativity parameters, adding complexity to the attack. Additionally, implementing Prime+Probe or Prime+Scope at scale can be intricate given hardware variations across CPU models.

### 3.5 Countermeasures
Mitigating cache side-channel attacks on LLMs requires a combination of hardware, system, and application level strategies. These strategies aim to reduce shared-resource contention, mask memory access patterns, and limit the attacker’s ability to correlate cache hits with token generation events.
###### Temporal and Spatial Randomization.
Introducing noise and unpredictability into the LLM’s memory access patterns can substantially raise the bar for attackers. For instance, randomly accessing unused segments of the embedding layer during inference breaks the correlation between observed cache hits and actual token usage. By periodically injecting random read operations for tokens that are not currently generated by the model, the LLM can effectively drown out the signal the attacker relies on. Another approach would be to implement a “constant-time” strategy for LLM vector accesses, similar to those used in cryptographic libraries, where uniform access patterns thwart timing analysis. More research is needed to determine if this would be a practical approach, as additional accesses would cause latency to the inferencing. Insuring that the attacker and victim processes do not share memory pages containing model parameters is another robust defense, however, it could be detrimental to performance. Enforcing process isolation at the hypervisor or container level, and avoiding shared libraries and models between untrusted tenants, can prevent cross-process Flush+Reload attacks [^149].

### 3.6 Discussion
With Spill The Beans, we have demonstrated that state-of-the-art Large Language Models are not immune to hardware-level side-channel attacks. Using cache timing variations in the embedding layer, we show that attackers can recover tokens used by the LLM, including sensitive keys and high-entropy credentials. Our experiments highlight how careful monitoring and strategic selection of tokens allow an adversary to overcome cache eviction and timing constraints, ultimately enabling the extraction of private data, such as API keys, from live inference sessions. Through extensive trials, we validated the feasibility of this approach on LLMs and explored how adjusting the number of monitored tokens influences both the breadth of data leaked and the reliability of detection. Beyond simply exposing the vulnerability, our study contributes an improved understanding of the fundamental tension between model complexity, timing granularity, and cache resource sharing. We bring attention to the need for stronger defenses against microarchitectural threats and underscore that commonly suggested mitigations—such as disabling page deduplication or performing random unused token accesses—are likely necessary to preserve user privacy in multi-tenant environments. Spill The Beans serves as a reminder that the intersection of modern hardware design and AI models introduces new and subtle risks. To safeguard confidential interactions and private intellectual property, the community must pursue comprehensive hardware-software co-design solutions, isolation techniques, and adaptive obfuscation strategies that can effectively counter the evolving landscape of microarchitectural side-channels.

### Chapter 4 Shared Memory Access: RubberMallet
While previous studies have primarily focused on single-bit flips and their exploitation, the phenomenon of adjacent bit flips—where two physically adjacent bits are corrupted simultaneously—remains underexplored. The probability, patterns, and security implications of such correlated flips demand thorough investigation, particularly as DRAM densities increase and cell-to-cell interference becomes more pronounced. Adjacent bit flips are especially concerning as they can potentially bypass error correction codes (ECC) designed to detect and correct single-bit errors, thereby undermining a common defense mechanism.
Our research addresses this gap by systematically analyzing adjacent bit flip occurrences using TRRespass and BlackSmith techniques. We investigate the physical mechanisms that increase the likelihood of correlated flips and quantify their probability distributions, demonstrating that there are likely underlying physical effects that cause bit flips to be clustered at the row level. Furthermore, we explore the security implications of adjacent and high frequency bit flips in two critical domains: cryptographic implementations and machine learning systems.

### 4.1 Localized Bit Flips
We define adjacent bit flips as bit flips occurring at consecutive bit positions within the logical address space of a byte (e.g., bits at positions i and i+1). While we acknowledge that logical adjacency may not correspond to physical adjacency in DRAM due to data swizzling [^100], our analysis focuses on the software-visible effects that are relevant to exploitation.
Figure 4.1 shows the absolute number of adjacent bit flips recorded after profiling $\sim$ 100Mb of memory using BlackSmith fuzzing. The vertical axis is presented on a logarithmic scale. The results show that single-bit flips were more frequent, occurring 174k times. Two adjacent bit flips were observed 3k times, three adjacent bit flips appeared only 62 times, and four adjacent bit flips occurred twice, demonstrating that adjacent bit flipping is a real phenomenon, and even 4 adjacent bit flips can be seen after minimal fuzzing.
Figure 4.1: Absolute number of adjacent bit flips seen after profiling for 100MB of memory on A3 (see Section 4.2 ) DDR4 memory with BlackSmith 66 )

### 4.2 Testing Different Rowhammer Tools
We tested both TRRespass [^47] and BlackSmith [^66] and compared bit flip adjacency across multiple different DRAMs. The results of this study can be seen in Table 4.2. Note that this study was to demonstrate that the bit adjacency affect was present on multiple DIMMs; $\sim$ 1000 fault attempts generally represents $\sim$ 20Mb of scanned memory which is why the number of faults is less than in Table 4.1.

### 4.3 Test Setup
In this study, a variety of DDR4 DRAM modules from different manufacturers were used to ensure a diverse experiment. Table 4.1 shows that we used Corsair Vengeance LED (model CMU64GX4M4C3200C16), Corsair Vengeance LPX (model CMK32GX4M2B3200C16), and a G.SKILL Ripjaws V module (model F4-3200C16D-16GVKB). Each memory stick was labeled individually to enable precise tracking during experiments.
Table 4.1: List of DRAM modules used in the experiments.
| DRAM # | Brand | Model Number | Size |

### 4.4 Impact of Many Bit Flips
This section examines the security implications of adjacent bit flips in two critical application domains: cryptographic implementations and machine learning systems. Our experiments reveal instances where as many as 4 adjacent bits flip simultaneously, creating powerful attack vectors that differ significantly from traditional single-bit flip scenarios.
#### 4.4.1 ECDSA Fault Injection
Elliptic Curve Digital Signature Algorithm (ECDSA) is widely deployed in secure communications protocols, including TLS. The security of ECDSA relies on the computational difficulty of the elliptic curve discrete logarithm problem and the unpredictability of the secret nonce used during signature generation. However, fault attacks targeting implementation vulnerabilities can bypass these mathematical security guarantees.


## Key insights
- (Chapter 3) Adiletta, Andrew, and Berk Sunar. "Spill The Beans: Exploiting CPU Cache Side-Channels to Leak Tokens from Large Language Models." arXiv preprint arXiv:2505.00817 (2025).
- (Chapter 4) Adiletta, Andrew, Zane Weissman, Fatemeh Khojasteh Dana, Berk Sunar, and Shahin Tajik. "Rubber Mallet: A Study of High Frequency Localized Bit Flips and Their Impact on Security." arXiv preprint arXiv:2505.01518 (2025).
- (Chapter 5) Adiletta, Andrew, M. Caner Tol, Yarkın Doröz, and Berk Sunar. "Mayhem: Targeted corruption of register and stack variables." In Proceedings of the 19th ACM Asia Conference on Computer and Communications Security, pp. 467-482. 2024.
- (Chapter 6) Adiletta, Andrew, M. Caner Tol, Kemal Derya, Berk Sunar, and Saad Islam. "Leapfrog: The rowhammer instruction skip attack." In 2025 IEEE 10th European Symposium on Security and Privacy (EuroS&P), pp. 1067-1081. IEEE, 2025.
- (Chapter 7) Adiletta, Andrew, Kathryn Adiletta, Kemal Derya, and Berk Sunar. "Super Suffixes: Bypassing Text Generation Alignment and Guard Models Simultaneously." arXiv preprint arXiv:2512.11783 (2025).
- steer the model’s behavior by removing the refusal component from the residual activations: $\bm{x}_{i}^{\prime}=\bm{x}_{i}-\hat{\bm{r}}\hat{\bm{r}}^{t}\bm{x}_{i}$ or
- ablate the model entirely by removing the refusal component from its parameters: $\textbf{W'}=\textbf{W}-\hat{\bm{r}}\hat{\bm{r}}^{t}\textbf{W}$, thereby bypassing refusal altogether.
- Introduce a new attack vector targeting LLM outputs on co-located servers via cache accesses exploiting data coherency in unified CPU/GPU memory;
- Unlike earlier side-channel attacks, our approach recovers tokens precisely even with a single measurement; repeated runs with the same prompt permit full recovery of the LLM output.
- Explain how the LLM embedding layer’s access patterns can be exploited with CPU cache monitoring to infer the tokens being processed by the model;

## Exemplos e evidências
See original source at `Clippings/Acknowledgments.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/Claude]]
- [[03-RESOURCES/entities/OpenAI]]
- [[03-RESOURCES/entities/NVIDIA]]
- [[03-RESOURCES/entities/Microsoft]]
- [[03-RESOURCES/entities/AWS]]
- [[03-RESOURCES/entities/LinkedIn]]
- [[03-RESOURCES/entities/Rust]]
- [[03-RESOURCES/entities/Python]]
- [[03-RESOURCES/entities/CUDA]]
