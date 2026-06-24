---
title: "Formally Verified Code Synthesis for Structured Data Translation in a Medical Internet of Things"
type: source
source: "Clippings/Formally Verified Code Synthesis for Structured Data Translation in a Medical Internet of Things.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
In this work we present a LLM powered, evolutionary code synthesis system for structured data translation in a Medical Internet of Things settings. A key challenge in this domain is ensuring that the synthesized code is trustworthy and reliable. To this end, we integrate a formal verification step into our code synthesis pipeline to ensure that any generated code is guaranteed to satisfy predefined requirements.

## Argumentos principais
### 1 Introduction
Large language model (LLM) powered code synthesis has become an increasingly important tool for modern software development [^5]. While these tools can enable significant gains in productivity, they also introduce significant risk and novel challenges. LLMs are well known to hallucinate and can introduce subtle vulnerabilities into the code [^6]. These problems are further compounded by the shear scale and speed of LLM code generation, making manual human verification of critical code laborious and intractable. These risks are especially acute in safety-critical domains, such as a healthcare.
In this work, we introduce a code synthesis pipeline that formally verifies synthesized code for a Medical Internet of Things (MIoT) network [^2]. This work is part of a broader project with the goal of reconfiguring a vehicle with medical devices, such that the vehicle is primed to deliver mobile care. A key challenge of this project is the integration of novel medical devices to the vehicle’s MIoT network over time, without assuming any available (human) software development expertise. Furthermore, given the safety-critical nature of the system, any automatically synthesized code must be performed in a manner that ensures reliability and trust.
To tackle this problem, we follow a neuro-symbolic architecture. We use a neural module that uses LLMs as operators within an evolutionary algorithm [^7] and a theorem prover module which we have adapted to JSON schema verification [^10]. This architecture ensures that the significant reasoning power of the LLM is grounded by the formal theorem prover. As a proof of concept, we present a case study of using our proposed system to integrate a pulse oximeter into our MIoT environment. We translate the device’s provided JSON schema to the more standard Fast Healthcare Interoperability Resources (FHIR) [^13]. We perform a set of experiments to analyze the success rate and resource cost of using our approach to generate a formally verified translation in this setting. We find that our system is able to consistently generate correct translations at low cost.

### 2.1 Evolutionary Algorithms with LLMs
Significant recent work has considered using LLMs as the primary operators inside evolutionary algorithms for code optimization and scientific discovery [^9] [^11] [^7]. In these systems, the LLM replaces traditional mutation and crossover operators by proposing semantically meaningful program edits, design variations, or hypotheses conditioned on prior search history. This approach is appealing because LLMs can exploit structure in code and scientific text, enabling searches over large, discrete spaces that would be difficult to explore with purely random or hand-designed operators. At the same time, the flexibility of LLM-generated candidates makes reliability, constraint satisfaction, and evaluation efficiency central challenges for practical deployment.

### 2.2 Formal Verification of Synthesized Code
As generative models are increasingly used to synthesize executable programs, ensuring correctness has become a central concern. Formal verification provides a principled framework for checking whether generated code satisfies specifications such as type safety, functional correctness, invariants, or resource bounds, rather than relying only on example-based testing [^3]. In synthesis pipelines, verification can be used either as a post hoc filter to reject invalid candidates or as part of the search objective itself, guiding generation toward programs that are provably correct. This is especially important in high-stakes domains, where small implementation errors can lead to unsafe or clinically unacceptable behavior.

### 2.3 Healthcare Data Interoperability
Healthcare data interoperability concerns the ability of heterogeneous systems to exchange, interpret, and use structured clinical information consistently across institutional and software boundaries [^4]. Modern interoperability efforts are shaped by standards such as HL7 FHIR [^13], standardized clinical terminologies, and structured exchange formats that aim to make patient records, observations, medications, and care plans computable across platforms. Despite this progress, real-world healthcare data remain fragmented, inconsistently coded, and deeply embedded in local workflows, creating substantial barriers to reliable automation and downstream analytics [^8]. As a result, methods that generate or transform healthcare software artifacts must account for both syntactic conformance to standards and semantic alignment with clinical intent.
Figure 1: Overview of our proposed system. A user provides an input/output schema pair and initial PVS program. The ShinkaEvolve loop elicits LLM translation code and formally verifies them. Upon successful verification the resulting theorem can be then be translated into C code for use in the MIoT environment.

### 3 Approach
Our approach, shown in Figure 1, is built on ShinkaEvolve [^7]. ShinkaEvolve is an open-source implementation of recent evolutionary code optimization techniques leveraging LLMs. ShinkaEvolve provides a multi-island evolutionary approach which builds an SQL database of programs and corresponding fitness scores. At each stage, a parent program is selected along with an LLM sampled from a model ensemble. Additionally, a set of $K$ inspiration programs are selected from the same island. The parent and inspiration programs, along with their fitness scores, are then provided to the LLM as a prompt. The LLM is then instructed to choose between editing, re-writing, or mutating earlier programs to generate a new solution candidate. This candidate is then scored by the provided evaluator and its results recorded into the database. This process then continues in a multi-worker asynchronous loop, working to maximize the fitness function.
In our approach, we use the Prototype Verification System (PVS) as our evaluator for determining solution fitness. PVS is a theorem prover designed to support the formal specification and verification of complex systems [^10]. PVS provides a domain-specific language (DSL) which we adapt to support the definition of transformations between valid JSON schemas. The pipeline then requires an input schema and an output schema. The input schema determines the format of the incoming data stream (e.g. from some medical device) and the output schema determines the required format of the outgoing data stream (e.g. the patient database in the larger system).
A theorem is then over a translation between inputs of the input schema type and outputs of the output schema type. The transform is correct only if this theory is proven. This is formalized as a set of constraints and core verification condition, which is shown in Listing LABEL:lst:pvs-constraints. Here we define input\_compliant?, output\_compliant?, and transform to be the JSON input schema, JSON output schema, and the synthesized theorem respectively.

### 4 Case Study: Integration of a Pulse Oximeter
In this section we provide an analysis of a concrete use case of our system for integrating a new device (a pulse oximeter) into the already existing MIoT environment. The device comes with a custom JSON schema which encodes a measurement of a patient’s pulse and oxygen saturation (shown in Appendix Listing LABEL:lst:input\_schema). To be integrated into the larger system, this data must be converted into the Fast Healthcare Interoperability Resources (FHIR) format (shown in Appendix Listing LABEL:lst:output\_schema), which is a standardized medical format schema that the system already natively understands.
As input to the ShinkaEvolve process we provide these two known schemas as well as a initial skeleton program which is shown in Listing LABEL:lst:pvs-init. This initial program simply returns an empty JSON dictionary for any input. To rigorously analyze the overall performance of ShinkaEvolve for this task, we perform 10 separate experimental runs for this task. We use two separate islands and run each trial for a total of 20 generations. A successfully verified PVS translation is shown in Appendix Listing LABEL:lst:correct\_pvs.
Listing 2: PVS theory initial program

### 4.1 Aggregate Performance
Table 1 summarizes key performance metrics averaged across all 10 experimental runs. The earliest successful theorem occurs at generation $5.0\pm 4.3$ on average with a range of 1–14. We define the success rate to be fraction of LLM-generated programs that pass verification across any generation. For this example we obverse a success rate of $37.4\pm 22.4\%$, reflecting the difficulty of synthesizing correct PVS transform functions.
The average total API cost per experiment is $\mathdollar 0.87\pm\mathdollar 0.18$, but the cost incurred before the first successful proof is only $\mathdollar 0.18\pm\mathdollar 0.19$, roughly 20% of the total budget. The remaining cost is then spent on continued exploration after a solution has already been found. The total wall-clock time per experiment averages $42.7\pm 8.1$ minutes, with the the LLM generation time taking up the majority of this time. We find that the PVS verification step is generally fast compared to the LLM generation phase. We observe that the first successful program is found in just $10.4\pm 9.9$ minutes on average.
Table 1: Aggregate experiment statistics across 10 independent runs (20 generations each).

### 4.2 LLM Selection
In our experiments, ShinkaEvolve is configured to use an ensemble of GPT LLMs: o4-mini, gpt-5, gpt-5-mini, gpt-5-nano. At each generation, a member from the ensemble is randomly selected to generate a new solution candidate. The weights of this sampling process are set dynamically using a Thompson sampling bandit approach [^1] based on observed success from prior generations. Figure 2 compares each model’s selection frequency against its share of successful programs across all experiments. gpt-5 accounts for 33.7% of all model selections but is responsible for 53.5% of successful programs. Conversely, o4-mini (25.3% selected, 14.1% of successes) and gpt-5-nano (14.7% selected, 4.2% of successes) underperform relative to their selection frequency. gpt-5-mini performs roughly in proportion (26.3% selected, 28.2% of successes).
This demonstrates that the larger and more expensive LLMs, such as gpt-5, are in general more accurate and therefore favored in the sampling process. We note that this sampling algorithm in ShinkaEvolve considers only an LLMs success rate and not its resource cost.

### 4.3 Solution Convergence
A notable finding is that all 10 experiments converge to essentially the same solution despite following different LLM selection paths and encountering different intermediate failures. Every best-of-run program produces the same FHIR Observation resource structure. Syntactic variations exist across runs, but the semantic content is identical. This convergence suggests that the PVS verification constraint is highly prescriptive: the output schema, combined with the proof obligations, admits essentially one valid mapping from the input. The evolutionary process thus functions less as an open-ended search and more as an oracle-guided synthesis procedure.

### 5 Conclusion
We have built a fully integrated neuro-symbolic pipeline to generate formally verified data translation code for a MIoT use case. Specifically, we combined the ShinkaEvolve’s open-source LLM-based evolutionary algorithm framework with a PVS verification module. Our system uses LLMs to generate translations between JSON schemas using the domain-specific language of PVS. These translations can be formally verified to ensure that the output schema is always followed. We have demonstrated our pipeline via a case study of integrating a pulse oximeter device into our MIoT environment. We are able to consistently generate formally verified translations at low cost.
This works is a first step toward trustworthy automatic integration of novel devices into a existing healthcare infrastructure. In future work we plan to explore integration of a boarder set of devices, formal verification of the networking component of the system, and integrating the formal verification stage into a fully agentic pipeline.

### Acknowledgements
This research was, in part, funded by the Advanced Research Projects Agency for Health (ARPA-H). The views and conclusions contained in this document are those of the authors and should not be interpreted as representing the official policies, either expressed or implied, of the United States Government.

### Impact Statement
This paper presents work whose goal is formally validate LLM generated code for a medical Internet of Things environment. This has the potential impact of making AI-powered medical systems more trustworthy and reliable.

### Appendix A Code Listings
In Listing LABEL:lst:input\_schema we display the input schema from the pulse oximeter. In Listing LABEL:lst:output\_schema we display the output schema. In Listing LABEL:lst:correct\_pvs we display an example of a correctly verified PVS theory that translates the input schema to the output schema.
Listing 3: Input schema
[⬇]()


## Key insights
- Cobb

###### Abstract

In this work we present a LLM powered, evolutionary code synthesis system for structured data translation in a Medical Internet of Things settings.
- We provide a set of experimental results which demonstrate that our system is able to consistently generate correct translation at low cost.
- Machine Learning, ICML

## 1 Introduction

Large language model (LLM) powered code synthesis has become an increasingly important tool for modern software development [^5].
- While these tools can enable significant gains in productivity, they also introduce significant risk and novel challenges.
- LLMs are well known to hallucinate and can introduce subtle vulnerabilities into the code [^6].
- These problems are further compounded by the shear scale and speed of LLM code generation, making manual human verification of critical code laborious and intractable.
- In this work, we introduce a code synthesis pipeline that formally verifies synthesized code for a Medical Internet of Things (MIoT) network [^2].
- This architecture ensures that the significant reasoning power of the LLM is grounded by the formal theorem prover.
- Then we introduce our approach and summarize its constituent parts in Section 3.
- In these systems, the LLM replaces traditional mutation and crossover operators by proposing semantically meaningful program edits, design variations, or hypotheses conditioned on prior search history.

## Exemplos e evidências
See original source at `Clippings/Formally Verified Code Synthesis for Structured Data Translation in a Medical Internet of Things.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/OpenAI]]
- [[03-RESOURCES/entities/AWS]]
- [[03-RESOURCES/entities/Rust]]

## Minha Síntese
**O que muda:** A ser analisado em revisão manual.

**Conexão pessoal:** A ser conectado com projetos/estudo atuais.

**Próximo passo:** Nenhum próximo passo imediato.
