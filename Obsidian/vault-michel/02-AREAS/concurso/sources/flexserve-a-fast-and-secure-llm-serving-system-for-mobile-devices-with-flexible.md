---
title: "FlexServe: A Fast and Secure LLM Serving System for Mobile Devices with Flexible Resource Isolation"
type: source
source: "Clippings/FlexServe A Fast and Secure LLM Serving System for Mobile Devices with Flexible Resource Isolation.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [concurso, source-page]
---

## Tese central
---
title: "FlexServe: A Fast and Secure LLM Serving System for Mobile Devices with Flexible Resource Isolation"
source: "
author:
published:
created: 2026-06-23
description:
tags:
  - "clippings"
---
Yinpeng Wu Yitong Chen Lixiang Wang Jinyu Gu Zhichao Hua <sup>🖂</sup> Yubin Xia  
Institute of Parallel and Distributed Systems, Shanghai Jiao Tong University  
{wyp1536481268,yitongcheng,2042567212,gujinyu,xiayubin,zchua}@sjtu.edu.cn

###### Abstract. Device-side Large Language Models (LLMs) have 

## Argumentos principais
### 1\. Introduction
Device-side Large Language Models (LLMs) have grown explosively in recent years [^14] [^10] [^1] [^60] [^72] [^38], offering stronger privacy and higher availability than their cloud-side counterparts. Moreover, device-side LLMs can be trained or fine-tuned on domain-specific datasets, making them well suited to specialized tasks [^17] [^40] [^73] [^77] [^70] [^71], and mobile AI applications can achieve higher intelligence by orchestrating multiple LLMs [^78] [^9] [^76] [^34] [^39] [^79]. Model vendors have released small-scale models tailored for mobile devices [^14] [^10] [^1] [^60], and developers are increasingly integrating device-side LLMs into their applications [^78] [^8] [^34] [^22] [^54] [^49] [^20].
Deploying LLMs on mobile devices introduces new security challenges. The LLM model itself is highly valuable, often costing millions of dollars to train [^31] [^12]. The LLM service may process a wide range of sensitive data on mobile devices, including chat history, screen content, and more. These factors make LLM inference an attractive target for attackers. Since the existing OS kernel is large and prone to bugs [^62] [^42], attackers may compromise the kernel to steal model weights or user data during LLM inference.
ARM TrustZone [^3] is a hardware isolation technology that protects sensitive applications from a compromised OS on mobile devices [^55] [^24] [^37] [^36] [^43]. It provides a Trusted Execution Environment (TEE) called the secure world. A strawman approach is to run LLM inference directly in the secure world. However, this approach degrades the performance of both the LLM inference and the normal-world applications, because of the following two challenges:

### 2.1. LLMs on Mobile Device
Device-side LLMs [^14] [^10] [^1] [^60] [^72] [^38] are deployed directly on mobile devices, so that users no longer need to upload their data to the cloud, which reduces the risk of data leakage and removes the dependency on network connectivity. Model vendors have released small-scale models suitable for mobile deployment, such as Llama [^14], Phi-4 [^1], Qwen3 [^10] and Gemma [^60], and developers are increasingly integrating device-side LLMs into their applications [^78] [^8] [^34] [^22] [^54] [^49] [^20].
Multiple Models in One Device: Unlike cloud-side LLMs, which are large in size and provide general intelligence, device-side LLMs are small-scale models that can be trained or fine-tuned on specific datasets, making them well suited to specific tasks such as financial analysis, UI navigation, and more [^17] [^40] [^73] [^77] [^70] [^71]. State-of-the-art mobile agent applications also employ multiple LLMs to achieve high intelligence [^78] [^9] [^76] [^34] [^39] [^79].
Security Challenges of Device-side LLMs: First, the LLM model weights are valuable assets, as they are trained with a large amount of data and computational resources [^31] [^12]. Second, AI applications feed various types of data, including chat history and screen content, as input to the LLM. Compromising the LLM inference system can therefore leak a significant amount of sensitive user information. Unfortunately, existing mobile OS kernels have a large code base and are prone to bugs, which makes them vulnerable to attacks. For example, Android relies on the Linux kernel, which comprises 40 million lines of code [^62] and has 9,756 reported CVEs [^42]. Attackers can compromise the kernel to steal the model weights and user data during the LLM inference procedure.

### 2.2. Challenges of Protecting LLM with TrustZone
ARM TrustZone: ARM TrustZone [^3] is a hardware security extension that divides the processor into a normal world and a secure world. All hardware resources, including memory and devices, can be partitioned into normal and secure modes. The normal world cannot access secure resources, whereas the secure world can access all resources. The commodity OS and normal applications run in the normal world. The secure world is a Trusted Execution Environment (TEE), which hosts secure applications. Even a malicious OS kernel cannot compromise the confidentiality or integrity of secure-world applications. TrustZone has been widely used to protect various applications [^55] [^24] [^37] [^36] [^43].
To protect LLM inference from an untrusted OS, a strawman approach is to run it in the secure world of TrustZone. However, this approach faces two main challenges that significantly degrade inference performance.
Challenge-1: Inflexible Secure Resource Isolation. Switching resources between the normal and secure worlds is inflexible. For physical memory, TrustZone can configure only a limited number (e.g., 8) of physically contiguous regions as secure. Allocating a secure memory region therefore requires merging fragmented free pages into a contiguous region, which is slow. For devices, although they can be dynamically configured as normal or secure, the driver manages the status of each device, and switching the driver status is complex. As a result, existing mobile devices choose to statically partition the hardware resources, configuring only a limited amount of physical memory and security-related devices as secure during system boot. This suffices for traditional secure applications, such as key management and kernel integrity protection [^55] [^24] [^37] [^36] [^43].

### 2.3. ARM Virtualization
The ARM virtualization extension supports running Virtual Machines (VMs) on the ARM platform. It introduces a hypervisor mode (EL2) for the hypervisor, which manages resources and traps critical operations from VMs. A two-stage address translation mechanism is introduced to support memory virtualization. The Stage-1 Page Table (S1PT), controlled by the OS kernel, translates the virtual address (VA) to the intermediate physical address (IPA) for each VM. The Stage-2 Page Table (S2PT), controlled by the hypervisor, then translates the IPA to the physical address (PA) for each VM. The System MMU (SMMU) is introduced to enforce access control for DMA operations. FlexServe leverages the virtualization extension to implement Recallable Resource Isolation.

### 3\. Overview
Figure 3. System overview of FlexServe: The Flex-Monitor constructs the Flex-Mem and Flex-NPU, and the FlexServe Framework provides a fast and secure LLM inference framework.

### 3.1. Design Goals
FlexServe aims to provide a fast and secure LLM inference system for mobile devices. The detailed goals are:
- Security: The confidentiality and integrity of model weights and input/output are protected during LLM inference against a compromised OS kernel.
- High Inference Performance: Both the Time to First Token (TTFT) and the Time Between Tokens (TBT) should be minimized. High performance is maintained when different models are invoked, especially for multi-model agent workflows.

### 3.2. Threat Model
FlexServe aims to protect LLM inference from attackers with kernel privileges. Both the confidentiality and the integrity of the model weights and the input/output are protected. All normal-world applications are considered untrusted. FlexServe assumes that the initial kernel code is benign and that secure boot protects its integrity. However, the kernel may contain bugs and could be compromised after system boot. Consequently, with kernel privileges an attacker could access or modify arbitrary memory pages or peripherals to compromise the LLM inference system. The secure-world components and the lightweight Flex-Monitor are trusted.
FlexServe handles requests from both normal-world and secure-world clients. As with existing TrustZone-based systems, FlexServe cannot prevent attackers from directly stealing or tampering with the input/output of normal-world clients. Nevertheless, the model weights remain protected. Side-channel attacks, physical attacks, and DoS attacks are out of scope. Section 8.1 presents a detailed security analysis.

### 3.3. System Overview
This paper presents FlexServe, a fast and secure LLM inference system for mobile devices. FlexServe runs LLM inference in the secure world of TrustZone, and solves the challenges of inflexible resource isolation and inefficient resource management (Section 2.2). The main idea is to decouple the access permission from the management permission, which prevents the normal-world OS from accessing the secure resources while still allowing it to manage them as usual. To achieve this, FlexServe first introduces a new Recallable Resource Isolation mechanism to construct Recallable Secure Memory (Flex-Mem) and Recallable Secure NPU (Flex-NPU). They cannot be accessed by the normal-world OS, yet can be efficiently allocated and reclaimed by it, which solves the first challenge of inflexible secure resource isolation. Building on Flex-Mem and Flex-NPU, FlexServe further introduces the FlexServe Framework to run the secure LLM inference in TrustZone’s secure world. It cooperates with the normal-world OS to perform the LLM-aware secure memory management and accelerate the inference, which solves the second challenge of inefficient secure resource management. Based on them, FlexServe can protect both the privacy and integrity of the LLM inference, while achieving high inference performance and low overhead to normal-world applications.
Figure 3 shows the detailed design of FlexServe. It uses a Flex-Monitor, running across normal EL2 (hypervisor mode) and secure EL3 (monitor mode), to provide the Recallable Resource Isolation. Flex-Monitor first constructs the Flex-Mem, a page-granular secure memory abstraction, which can be allocated and recalled efficiently (Section 4.1). It introduces a cooperative secure memory management to allow existing normal-world memory management service to manage both the normal memory and the Flex-Mem (Section 4.2). The Flex-Monitor then constructs the Flex-NPU, a secure NPU abstraction (Section 4.3). Instead of using two NPU drivers and switching status between them, FlexServe reuses the normal-world NPU driver to control the Flex-NPU, thereby minimizing the Trusted Computing Base (TCB). The Flex-Monitor leverages two-stage address translation to protect both the Flex-Mem and the Flex-NPU. An on-demand protection mechanism is introduced to eliminate this virtualization overhead when no secure inference tasks are active (Section 4.4).
Based on Flex-Mem and Flex-NPU, FlexServe further constructs the FlexServe Framework within TrustZone’s secure world. It reuses the existing secure-world software stack to execute the inference framework, and leverages Flex-Mem and Flex-NPU to protect runtime data and accelerate inference. A secure inference pipeline is introduced to hide the latency overhead of secure loading and cryptographic operations (Section 5.1). Benefiting from the page-granular and flexible protection of Flex-Mem, a dynamic caching strategy is introduced to cache the model weights and KV cache in the Flex-Mem (Section 5.2). Then, the LLM-aware memory reclamation is introduced to decide which pages to reclaim when normal-world OS requests memory reclamation (Section 5.3). It also re-schedules the cache to the optimal distribution after the reclamation. The FlexServe Framework can handle requests from both normal-world and secure-world applications. The lifecycle of FlexServe is detailed in Section 5.4.

### 4.1. Recallable Secure Memory
Figure 4. Memory Protection of FlexServe.
FlexServe divides all memory resources into three types: unprotected memory, Flex-Mem, and TrustZone’s secure memory (Figure 4). Both unprotected memory and Flex-Mem are the normal memory of TrustZone. Unprotected memory is used by the untrusted OS and applications. The Flex-Mem is a recallable, page-granular secure-memory abstraction designed for secure LLM inference. Any unprotected memory page can be switched to a Flex-Mem page, which can later be returned to unprotected memory when memory pressure rises or the Flex-Mem is unused.
As shown in Figure 4, the Flex-Monitor, running at EL2, isolates all Flex-Mem from the untrusted OS kernel by leveraging the Stage-2 Page Table (S2PT). For each Flex-Mem page, the Flex-Monitor removes the IPA-to-PA mapping of that page from the normal-world S2PT. Therefore, neither the untrusted OS nor its applications can access it. After allocation, the secure-world Trusted OS maps the Flex-Mem pages into the FlexServe Framework’s address space. Details about the FlexServe Framework are provided in Section 5. If a Flex-Mem page is reclaimed, the Flex-Monitor remaps it in the normal-world S2PT and returns ownership to the normal-world OS.

### 4.2. Cooperative Secure Memory Management
The Flex-Monitor provides allocation and reclamation interfaces for Flex-Mem, and leverages a kernel-level Flex-Mem manager to manage it.
Flex-Mem Allocation: The Flex-Monitor provides the *rsmem\_alloc(size)* interface to allocate Flex-Mem pages. The FlexServe Framework invokes this interface to request additional Flex-Mem pages. The Flex-Monitor then asks the Flex-Mem manager to allocate physical pages from the normal-world OS. These pages are unmapped from the normal-world S2PT and marked as Flex-Mem pages. Finally, the Flex-Monitor returns the allocated Flex-Mem pages to the Trusted OS, which maps them into the FlexServe Framework’s address space.
Flex-Mem Reclamation: The Flex-Monitor provides the *rsmem\_reclaim(size)* interface to reclaim Flex-Mem pages. The normal-world OS invokes this interface to request reclamation of Flex-Mem. The Flex-Monitor then asks the FlexServe Framework to select Flex-Mem pages for reclamation. The framework provides LLM-aware memory reclamation; details are given in Section 5.3. Flex-Mem pages containing model weights only need to be zeroed. Pages containing KV caches must be encrypted and written back to storage before being zeroed. After these steps, the Flex-Monitor remaps the pages in the normal-world S2PT. Finally, these pages are marked as normal memory and returned to the normal-world OS.

### 4.3. Recallable NPU Protection
FlexServe introduces the Recallable Secure NPU (Flex-NPU) to efficiently enable the NPU for secure LLM inference. Flex-NPU operates on a time-multiplexing model: the NPU is either in unprotected mode, accessible by the normal world, or switched into Flex-NPU mode, where it is exclusively available to the secure world.
When the NPU is in Flex-NPU mode, the Flex-Monitor prevents the normal-world OS from accessing it. The ARM architecture uses Memory-Mapped I/O (MMIO) to access devices, including the NPU. Therefore, the Flex-Monitor removes the NPU’s MMIO region from the normal-world’s S2PT, effectively blocking kernel access.
Subsequently, FlexServe reuses the normal-world NPU driver to control the Flex-NPU. The Flex-Monitor constructs an isolated Flex-NPU sandbox to protect the NPU driver when the NPU is in Flex-NPU mode. Specifically, the Flex-Monitor maintains an additional S2PT for this sandbox. When the secure world invokes the protected NPU driver, the Flex-Monitor switches to the sandbox’s S2PT. The NPU’s MMIO region is mapped within the sandbox’s S2PT, allowing the driver to access the NPU. Both the driver’s code and data are mapped in the sandbox’s S2PT but unmapped from the normal-world OS’s S2PT. This prevents the OS from tampering with the protected NPU driver’s code and data. Although the driver retains residual state from unprotected mode, NPU task launching is a stateless operation. Thus, the remaining state does not influence Flex-NPU task execution.

### 4.4. On-demand Protection
The Flex-Monitor leverages the S2PT to protect Flex-Mem and Flex-NPU, which may introduce performance overhead for normal-world applications. On-demand protection is introduced to minimize this overhead. This mechanism disables the protection when no secure inference task has been active for a specified time window, and re-enables it when a new task arrives. The key challenge lies in preserving the integrity of the Flex-Monitor itself, as its code and data reside in normal memory. Once the S2PT is disabled, the normal-world OS could potentially modify the Flex-Monitor and compromise the protection.
To address this, the Flex-Monitor is divided into an EL2 component and an EL3 component. The EL2 component implements the main protection mechanisms, including Recallable Secure Memory and Recallable NPU Protection. The EL3 component freezes the EL2 component to eliminate the virtualization overhead and to protect its integrity. The EL3 component executes within TrustZone’s secure memory. It calculates and stores a hash of the EL2 component, covering both its code and data. Subsequently, it disables the S2PT. To re-enable the protection, the EL3 component restores the S2PT and verifies the integrity of the EL2 component against the stored hash. The S2PT is also verified as part of the EL2 component’s data. The entire EL2 component is placed in a contiguous memory region to simplify hash calculation. Note that the EL2 component does not contain any private data (e.g., model weights), so FlexServe only protects its integrity.

### 5\. FlexServe Framework
The FlexServe Framework is implemented as a secure-world Trusted Application (TA). It uses secure memory for its code and private runtime state, including global variables and the stack. Inference data, including the model weights and the KV cache, is placed in Flex-Mem, while Flex-NPU accelerates computation.

### 5.1. Secure Inference Pipeline
Due to memory limitations, mobile devices cannot always keep the model weights resident in memory and must load them for each inference, causing the *cold start* problem. This issue is amplified in confidential inference, because the encrypted weights must also be decrypted.
FlexServe leverages pipeline parallelism to reduce the cold-start overhead by overlapping resource-disjoint steps in the prefill stage, which is partitioned into four steps: 1) Memory allocation: allocating memory for the model weights and the KV cache; 2) Model loading: loading the encrypted weights from storage; 3) Model decryption: decrypting the weights; 4) Forward computation: executing the prefill with Flex-NPU and CPU. The decode stage can reuse the in-memory weights and KV cache.
The prefill stage processes a sequence of layers, where each layer depends only on the outputs of previous layers. Within a layer, the steps are constrained only by their *in-layer* dependency (allocate $\rightarrow$ load $\rightarrow$ decrypt $\rightarrow$ compute) and do not depend on the corresponding steps of earlier layers. FlexServe therefore overlaps the allocation, loading, and decryption of layer $i{+}1$ with the computation of layer $i$.

### 5.2. Dynamic Caching Strategy
The FlexServe Framework handles requests for different models, and both the model weights and the history KV caches can be cached. The dynamic caching strategy traces all history requests to the FlexServe Framework and decides which model weights and KV caches to cache, based on the current Flex-Mem budget.
First, the FlexServe Framework decides which models to cache and assigns a cache budget to each of them. The framework logs the invocation history of all models and uses the recent invocation rate (e.g., over the past hour) to decide which models to cache. Only models whose invocation rate exceeds a user-defined threshold (e.g., 25%) are selected. If no model reaches this threshold, the top 3 models with the highest invocation rate are selected. For each selected model, the per-model cache budget is determined by its 1) recent invocation rate, 2) recent invocation frequency, and 3) history prompt length. A model with a higher invocation rate and frequency receives a larger cache budget. In FlexServe’s secure pipeline, a long prompt length indicates that the computation step will be the bottleneck, and the I/O can be easily overlapped, so the model will receive a smaller cache budget.
Next, the framework decides how to cache the model weights and KV caches for each selected model. The invocation rate is also used to select the history KV caches. Due to the limited memory, each model’s cache budget may be insufficient to cache even its model weights. Therefore, FlexServe caches the earlier portion of the model weights together with the selected KV caches.


## Key insights
- The Recallable Resource Isolation mechanism, which constructs Flex-Mem and Flex-NPU that can only be accessed by the secure world but can be allocated and reclaimed by the normal-world OS efficiently.
- The FlexServe Framework, which runs in the secure world and leverages Flex-Mem and Flex-NPU to perform secure LLM inference. It provides LLM-aware memory reclamation and dynamic caching, cooperating with the normal-world OS to perform efficient memory management.
- Security: The confidentiality and integrity of model weights and input/output are protected during LLM inference against a compromised OS kernel.
- High Inference Performance: Both the Time to First Token (TTFT) and the Time Between Tokens (TBT) should be minimized. High performance is maintained when different models are invoked, especially for multi-model agent workflows.
- Low Impact to Unprotected Applications: The performance overhead to normal-world applications should be minimized.

## Exemplos e evidências
See original source at `Clippings/FlexServe A Fast and Secure LLM Serving System for Mobile Devices with Flexible Resource Isolation.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/Apple]]
- [[03-RESOURCES/entities/Rust]]
