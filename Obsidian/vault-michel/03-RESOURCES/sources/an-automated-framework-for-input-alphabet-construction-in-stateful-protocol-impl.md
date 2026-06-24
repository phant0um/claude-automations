---
title: "An Automated Framework for Input Alphabet Construction in Stateful Protocol Implementation Learning"
type: source
source: "Clippings/An Automated Framework for Input Alphabet Construction in Stateful Protocol Implementation Learning.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [articles, source-page]
---

## Tese central
---
title: "An Automated Framework for Input Alphabet Construction in Stateful Protocol Implementation Learning"
source: "
author:
published:
created: 2026-06-23
description:
tags:
  - "clippings"
---
JiongHan Wang [wangjh1@mail.ustc.edu.cn]() University of Science and Technology of ChinaHe FeiChina and WenChao Huang [huangwc@mail.ustc.edu.cn]() University of Science and Technology of ChinaHe FeiChina

(2018)

###### Abstract. As a prevalent analytical technique for stateful protocol implementat

## Argumentos principais
### 1\. Introduction
Stateful protocol implementations are an important component of computer systems, and the correctness of their execution semantics is critical for the stable operation of real-world systems. For many important protocols, the behavior of protocol deployments is specified by protocol specification documents, and their semantic correctness means that the externally observable behavior at runtime is fully consistent with the request-response semantics defined by the protocol specification (RFC documents). If a protocol implementation contains semantic bugs, it can severely impact their functionality and security. For example, the TLS protocol and its deployment guarantee information security in most network communications [^16]. Vulnerabilities such as EarlyCCS [^7] found in TLS deployments can severely compromise its security.
Semantic bugs in stateful protocol implementations continue to emerge as protocols and their deployments grow in scale [^19]. Existing approaches for detecting such bugs include formal verification, model checking, fuzzing, and state machine learning. Formal verification can validate protocol specifications but typically only scales to relatively simple protocols and requires substantial expert effort [^3] [^4], while model checking similarly involves significant manual intervention [^9]. Fuzzing has been widely applied to protocol testing (e.g., AFLNet [^20]), but most approaches primarily target memory corruption vulnerabilities rather than semantic bugs, and recent tools such as DYFuzzing [^1] still require complex instrumentation and expert-defined properties. By comparison, state machine learning provides a relatively convenient way to analyze protocol behaviors and has been applied to many critical protocols [^16] [^28] [^10].
Despite its advantages in ease of deployment and its natural suitability for semantic bug analysis, state machine learning suffers from a major limitation: existing algorithms operate only on a manually defined input alphabet. The input alphabet is a collection of input symbols, where each input symbol serves as an abstraction of concrete messages transmitted to the system under test. As a result, if the messages corresponding to the defined alphabet cannot cover those required to trigger vulnerabilities, any learning strategy will inevitably fail to expose such bugs. From a technical perspective, this gap introduces two key challenges.

### 2\. Background
State Machine Learning: Active automata learning has been widely used to infer behavioral models of protocol implementations. This line of work is rooted in Angluin’s $L^{*}$ algorithm [^2], which learns automata through membership and equivalence queries. In this work, we adopt state machine learning techniques to synthesize the input–output behavior of a protocol implementation into a Mealy machine. A Mealy machine models the protocol as a tuple $SM=(Q,q_{0},\Sigma,O,\delta,\lambda)$, where $Q$ denotes the set of states, $q_{0}$ is the initial state, $\Sigma$ is the input alphabet, $O$ is the output alphabet, and $\delta$ and $\lambda$ represent the transition and output functions, respectively [^2]. An alphabet is a set of symbols, where each symbol represents an abstraction of a specific sent or received message.
From Learned State Machines to Semantic Bug Detection: The learned state machine provides an abstract representation of the protocol implementation’s behavior and can reveal deviations from the intended protocol logic. However, identifying implementation flaws from the learned model remains a challenging task. While formal verification techniques can in principle analyze properties of finite-state models, exhaustive verification often suffers from the state explosion problem, making fully automated analysis computationally expensive in practice.
Consequently, prior work on protocol state machine learning has typically relied on manual inspection of the inferred models to identify unexpected transitions or states [^22] [^17] [^8]. Other approaches design protocol-specific analysis techniques that detect particular classes of implementation flaws based on domain knowledge [^9] [^27]. While effective in certain scenarios, these approaches often require significant expert effort and are difficult to generalize across different protocols.

### 3\. Motivating Example
Figure 1. CVE-2022-25638, Vulnerable State Machine
We adopt CVE-2022-25638 [^22], a critical semantic bug in the TLS 1.3 stack of WolfSSL, as our motivating example throughout this work. As shown in Figure 1, an attacker can first send an empty certificate message when a certificate and verification message are expected, and then follow it with an invalid certificate verification message (containing an unknown signature algorithm and arbitrary payload), thereby bypassing server authentication. The core condition for triggering this vulnerability is to introduce an Empty Certificate message (EmptyCert) into the message flow together with a carefully crafted invalid CertificateVerify message (CV\_invalid).
However, acquiring the two key messages to trigger the vulnerability is non-trivial. The EmptyCert message does not exist in the standard message specification of TLS 1.3 servers [^23]. Injecting such a message into a state machine learning or testing workflow therefore requires additional expert knowledge. Constructing the invalid CertificateVerify message is even more challenging for general testers. This message contains eight subfields in total. To trigger the vulnerability, the signature algorithm field must contain a value that violates the specification, while all other fields must remain valid. Meanwhile, the constraints of both the record layer and the handshake layer headers must still be satisfied. Such a process demands deep protocol expertise and careful manual crafting. Consequently, vulnerability discovery methods that rely heavily on expert knowledge are difficult to generalize across different protocols or even across different implementations of the same protocol. This observation motivates us to explore methods that can automatically construct non-compliant messages for state machine learning and testing.

### 4.1. Overview
Our method aims to automatically construct input alphabets for state machine learning of the system under test, thereby achieving efficient semantic vulnerability detection. As shown in Figure 2, this method involves two key steps: obtaining the extended input symbol set and performing mini-batch learning. The first step involves acquiring the extended input symbol set, which requires using a large language model to extract protocol message format configurations. Based on mutation rules, new mutated input symbols are then generated to form the extended input symbol set. The second step is to perform mini-batch learning on the extended input symbol set to obtain a state machine that describes the system’s input-output behavior. This process requires organizing the extended input symbol set into a collection of extended alphabets, which is then used with the newly designed state machine learning method.

### 4.2. Automated Construction of the Extended Input Symbol Set
We first need to construct abstract symbols and define how they can be translated into concrete messages for transmission. Traditionally, defining a finite input alphabet for state machine learning relies heavily on expert knowledge, where protocol-specific alphabets are manually constructed based on a deep understanding of the target protocol [^16]. This process is labor-intensive and lacks generalizability across different protocols. To address this limitation, we propose an LLM-augmented approach inspired by fuzzing strategies, which constructs the input space through finite mutations of valid messages derived from protocol specifications.
Specifically, we decompose the alphabet construction problem into three steps: (1) extracting structural information of protocol messages; (2) generating an extended set of symbols by mutating messages based on their structural properties; and (3) constructing a message suite that maps abstract symbols to the concrete messages sent during protocol interactions.
#### 4.2.1. LLM-assisted protocol message configuration acquisition:

### 4.3. Mini-Batch Learning
We propose a mini-batch learning strategy as shown in Figure 3 to address the issue that the mutation-based approach may produce an excessively large input symbol set that exceeds the practical capability of state machine learning algorithms. Starting from a basic alphabet, we incrementally construct a sequence of extended alphabets. Instead of learning over the entire input symbol set at once, we perform learning on each of these extended alphabets in sequence, thereby reducing the complexity of the learning process. According to the complexity theory of state machine learning, the theoretical lower bound on the number of membership queries for any active learning algorithm is $\Theta(k^{2})$, where $k$ denotes the size of the alphabet [^12].This bound is established with respect to the alphabet size, and does not account for other influencing factors in overall query complexity. With our mini-batch learning approach, this complexity is reduced to $\Theta(\sum k_{i}^{2})$, where $\sum k_{i}\approx k$. This formulation provides an advantage when $k$ is large. Furthermore, based on this learning strategy, we design a method that incorporates the basic state machine directly into the learning process, which further reduces the overall time overhead.
#### 4.3.1. Construction of the Set of Extended Alphabets
We transform the large input symbol set into a collection of extended alphabets suitable for state machine learning by defining the basic alphabet and designing two methods for addition.

### 5\. Experimental Design
To thoroughly evaluate the effectiveness of our method, we conducted a series of experiments to address the following research questions:
RQ1: With the guidance of large language models, can our method automatically generate and generalize protocol-specific input symbols with high coverage across diverse real-world protocols?
RQ2: Can our designed mini-batch learning strategy significantly reduce time overhead and query complexity while maintaining inference accuracy during state machine learning on real-world protocol implementations, compared with conventional learning paradigms?

### 5.1. Benchmark
Table 2 presents the subject programs used in our experiments. Our benchmark contains 9 network protocol implementations, covering 5 widely used network protocols, namely RTSP, FTP, SMTP, and the server and client implementations of TLS 1.3. These subject programs cover both cryptographic and non-cryptographic protocols, in the PROFUZZBENCH benchmark [^19] which is a popular benchmark for evaluating stateful protocol fuzzers. The above protocols cover a variety of application scenarios, including streaming media, messaging, file transfer, and encrypted communication. Their implementations are mature and widely adopted by both enterprises and individual users. Semantic bugs in these projects can have far-reaching impacts.

### 5.2. Test Experiment
All experiments were conducted on a server equipped with an Intel Xeon Platinum 8468V CPU. The machine is configured with 12 logical cores clocked at 2.50 GHz, 16 GB of main memory, and runs on the Windows 10 operating system. In addition, Docker 28.1.1 is deployed to achieve environment isolation and containerized execution of the subject under test.

### 5.3. Runtime Configuration
We standardize key runtime parameters for state machine learning and mutation across all experiments. During the symbol construction phase, we use ChatGPT 5.3 model to generate message format configuration files. Since no existing work has studied the problem of state machine learning over the set of extended alphabets and existing work [^17] [^1] [^27] cannot automatically switch among the protocols under test, we compare our approach with the basic state machine learning algorithm to demonstrate the effectiveness of our mini-batch learning strategy.

### 6\. Evaluation
Table 2. Comprehensive Statistics of Tested Protocols
| Proto. | Msg# | Cfg-Spec Msg# | Sym# | AlphSz |
| --- | --- | --- | --- | --- |

### 6.1. RQ1: Automated Symbol Construction
Table 2 summarizes the basic characteristics of the LLM-generated configuration files and the constructed input symbol sets. To evaluate the usability of the generated message configuration files, we adopt manual inspection to verify whether the description of each message type in the files conforms to the protocol specifications. As shown in Table 2, all generated configuration files for evaluated protocols comply with the official protocol standards after manual verification, which guarantees the correctness of protocol message processing in the subsequent workflow of our framework.
Based on these configurations, we construct the extended input alphabet by applying the mutation rules described in Section 4.2.2. Table 2 presents the final number of symbols obtained for each protocol.
Regarding the selection of the basic alphabet, all protocols except FTP use the complete set of non-mutated symbols as the basic alphabet. For FTP, however, preliminary experiments and analysis of the specification indicate that fewer than 20% of message types are relevant to state machine construction. Therefore, we manually select six representative symbols based on the protocol documentation to form the basic alphabet, improving the overall efficiency of the learning process.

### 6.2. RQ2: Effectiveness of Mini-Batch Learning
Table 3 demonstrates the efficiency of our approach compared to performing state machine learning over the full input symbol set. In experiments on protocols such as LightFTP, directly applying state machine learning to the full input symbol set fails to terminate within 12 hours; for other protocols, the learning process still requires several hours to complete. This high computational cost makes the naive approach impractical for semantic vulnerability detection when the alphabet size is large. In contrast, both learning strategies based on extended alphabet sets are able to derive meaningful state machines within a bounded time, making them suitable for semantic vulnerability detection. Furthermore, the built-in basic state machine designed in our approach can further improve learning efficiency.
#### 6.2.1. Single-Symbol Mutation Priority Strategy
As shown in Table 3, the proposed single-symbol mutation–bounded strategy is able to complete state machine learning within hours—or even minutes in some cases. Compared to learning over the full input symbol set, the computational overhead is significantly reduced. Although this approach may theoretically lose the ability to detect bugs that require the interaction of multiple message types, its low cost makes it well-suited for preliminary analysis of mutated symbols.

### 6.3. RQ3: Semantic bug detection
#### 6.3.1. Authentication Bypass
Our method successfully detects multiple authentication bypass vulnerabilities present in wolfSSL.
CVE-2021-3336: Our method reproduces a critical authentication bypass vulnerability (CVE-2021-3336) in the wolfSSL client. As shown in Figure 6, an attacker can bypass server authentication and impersonate a server by sending an Empty Certificate message followed by a CertificateVerify message signed with an arbitrary RSA key. In our approach, this vulnerability is triggered by mutating a Certificate message using the Payload Nullification rule to generate an empty certificate, which is then added to the alphabet for state machine learning.

### 7\. Limition and Future work
Although automated mutation is adopted, hand-crafted mutation strategies exhibit inherent limitations: they fail to adequately cover bug-relevant input spaces and introduce redundant runtime overhead. Future work may integrate fuzzing techniques to generate more diversified and targeted mutation primitives.
Direct client-server interaction in our experiments incurs significant network I/O overhead and synchronous waiting, slowing the learning process. Future work should minimize this overhead or use multi-threading to mitigate synchronous waiting latency.


## Key insights
- 1, Payload Nullification: delete the payload portion of the message; this mutation rule is not applicable to messages that originally have an empty payload.
- 2, Payload Error Content Replacement: replace payload fields with error content or non-message-based configurations.
- 3, Header Error Content Replacement: replace header fields with error content.

## Exemplos e evidências
See original source at `Clippings/An Automated Framework for Input Alphabet Construction in Stateful Protocol Implementation Learning.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/ai-agents/harness]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/AWS]]

## Minha Síntese
**O que muda:** Este estudo reforça que jionghan wang [wangjh1@mail.ustc.edu.cn]() university of science and technology of chinahe feichina and wenchao huang [h — impacta diretamente como projetar e avaliar agentes.

**Conexão pessoal:** Conecto isso ao meu trabalho com Hermes Agent e o vault-michel: preciso aplicar este padrão nos meus fluxos de ingestão e consolidação.

**Próximo passo:** Implementar um experimento prático com este conceito nos próximos ciclos de desenvolvimento do vault.