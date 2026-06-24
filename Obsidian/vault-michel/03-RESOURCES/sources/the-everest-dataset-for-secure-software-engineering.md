---
title: "The EVerest Dataset for Secure Software Engineering"
type: source
source: "Clippings/The EVerest Dataset for Secure Software Engineering.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [articles, source-page]
---

## Tese central
---
title: "The EVerest Dataset for Secure Software Engineering"
source: "
author:
published:
created: 2026-06-23
description:
tags:
  - "clippings"
---
LLM

Large Language Model

SE

Security-related Element

EV

Electric Vehicle

SWATTR

SoftWare Architecture Text Trace link Recovery

SecDReqAn

Security- and Design-related Requirements Analyses

ArDoCo

Architecture Documentation Consistency

ArCoTL

ARchitecture-to-COde Trace Linking

TransArC

Transitive links for Architecture and Code

SAD

## Argumentos principais
### 1\. Introduction
Ensuring software security requires holistic verification across the development chain, from natural language requirements through software architecture to implementation. This includes (i) classifying security-relevant requirements and their objectives; (ii) recognizing security-relevant named entities in requirements and tracing them to architectural elements; and (iii) checking whether the implementation satisfies the resulting constraints. Omitting any of these steps can introduce security weaknesses. Though each step is well-studied, their combination is rarely explored due to missing datasets. Existing datasets either cover only requirements (e.g., PROMISE NFR) or include code but no architecture (e.g., DiverseVul). No dataset spans requirements, architecture, *and* code, preventing research on end-to-end security verification.
We present the *EVerest dataset*, a multi-artifact resource derived from EVerest, an industry-driven open-source software stack for [Electric Vehicle](#id3.3.id3) ([EV](#id3.3.id3)) charging stations. As shown in Figure 1, it contains (1) 84 security requirementsmanually elicited from EVerest documentation and developer interviews, annotated with security objectives, 1,445 fine-grained security elements (components, entities, data, data flows, states, etc.), acceptance windows, references, and coreferences; (2) a software architecture model with requirement-to-architecture trace links; (3) the source code of EVerest; and (4) its natural language documentation. Available under the Apache License 2.0 [^4], the dataset supports research on security requirements classification, named entity recognition, architectural trace linking, and design-time or code-level security verification. We also uncovered a real security weakness: a violation of the authentication token storage requirement (CWE-1295).
Figure 1. EVerest dataset: documentation, labeled security requirements, architecture, source code, and arch. trace links.

### 2\. Related Datasets
To contextualize the EVerest dataset, we survey requirements engineering and software security datasets. We focus on datasets with textual artifacts and compare them by artifact coverage, security-label granularity, and availability. Table 1 summarizes the results.
Dalpiaz [^6] provides requirements from 22 web sources as user stories. QuRE [^7] contains Mercedes-Benz specification requirements annotated with weak words and defects. PURE [^8] collects requirements automatically extracted from 79 online documents and labels structural properties. Later studies re-labeled PURE for other tasks, such as distinguishing requirements from non-requirements [^13]. However, some variants were not published [^14] [^18] or lack sufficient description [^22]. PROMISE NFR [^3] is a classification dataset that contains requirements from 15 projects, labeled with one functional and eleven non-functional classes, two of which are security-relevant. The dataset was further relabeled and extended by Dalpiaz et al. [^5] and in NICE [^19].
Other datasets better support security requirements classification. Slankas and Williams [^23] labeled collected requirements with functional and 14 non-functional classes, including six security-related ones. Riaz et al. [^21] explicitly label requirements by security objectives. Varenov et al. [^11] similarly provide security requirements from other datasets for multi-class labeling.

### 3\. About EVerest
EVerest is an open-source, modular software stack for [EV](#id3.3.id3) charging stations, covering the full range from low-level hardware drivers to high-level charging protocols. Initiated by PIONIX GmbH and hosted by the Linux Foundation Energy, it is developed openly on GitHub [^9] with an active community that meets regularly. everest-core, containing the central charge controller logic, was first released in December 2022. By June 2024, roughly 40 contributors had grown the codebase to approximately 50 kloc across more than 500 files, written in C++, C, JavaScript, Python, and Rust. While the project ships user-facing documentation, it provides neither formal requirements documents nor architectural models.
Table 1. Related datasets by artifact type. Parentheses denote partial coverage (✓) or derivable artifacts (-).
| Artifact | Dalpiaz  [^6] | QuRE  [^7] | PURE  [^8] | PROMISE NFR  [^3] | Dalpiaz et al.  [^5] | NICE  [^19] | Slankas & Williams [^23] | Riaz et al.  [^21] | Varenov et al.  [^11] | Wang et al.  [^24] | SecReq  [^15] | BADS  [^10] | DiverseVul  [^2] |

### 4\. Dataset Construction
Since EVerest lacked both documented security requirements and a formal software architecture model, we constructed the dataset from scratch in cooperation with PIONIX in four steps: (1) We elicited coarse-grained security requirements from the EVerest community via an online questionnaire. (2) We conducted semi-structured interviews with EVerest developers to refine these requirements to the architectural level, yielding fine-grained requirements that explicitly reference specific EVerest components. (3) We derived a software architecture model from the EVerest source code. (4) Multiple annotators labeled acceptance windows, references, and coreferences of security elements in the requirements, as well as the contained trace links; disagreements were resolved through inter-annotator agreement.
To broaden the dataset’s applicability, for example, for coarse-grained requirements classification, we additionally included architecture excerpts from the EVerest project documentation.

### 4.1. Questionnaire
Employing multiple elicitation techniques has been shown to improve the completeness and quality of requirements [^25]. Thus, we designed an online questionnaire for step (1) to systematically elicit initial security requirements from the broader EVerest community. Given that participants may not have formal security expertise, we structured the questionnaire around four established security objectives (confidentiality, integrity, availability, and authentication).
The questionnaire comprises seven parts: an introduction, a demographics section, four objective-specific sections, and a closing section for uncategorized requirements. The introduction outlines the structure, defines security requirements, and provides writing guidelines. The demographics section captures participants’ professional background and their self-assessed familiarity with EVerest and software security proficiency. For each security objective, participants are provided with the corresponding ISO 27000 definition [^12], domain-specific elicitation prompts [^16], and an example to anchor their responses.
Prior to distribution, we conducted a pilot study with two doctoral researchers with a security background, leading to minor refinements of the instrument. The questionnaire was then disseminated via the EVerest developer mailing list and announced at two consecutive weekly community meetings. Seven participants responded: three from Pionix and four from other organizations.

### 4.2. Interviews
As the questionnaire requirements were high-level and did not refer to EVerest components, we conducted semi-structured interviews with four EVerest developers in step (2) to refine the coarse-grained requirements to the architectural level (as depicted in Figure 2).
Each interview consisted of three parts. First, the interviewer gave a brief introduction, shared the study goals and consent information, and collected general background information from the participant. In the main part, the interviewer presented a coarse architecture diagram of EVerest and, using two examples in a shared interview-specific document, explained how coarse-grained requirements should be refined by explicitly naming responsible EVerest components. The document also contained a selection of 30 security requirements from the questionnaire. The interviewee was then asked to think aloud and write down fine-grained specifications for the given requirements; the interviewer supported them with writing-recommendation hints and reminders to reference specific components. Finally, where time constraints led to incomplete sentences, the interviewer revised them afterward and sent the result to the interviewee for confirmation or correction.
After a pilot with four doctoral researchers introduced to EVerest, we remotely interviewed four EVerest developers: three from Pionix and one from Chargebyte. Each interview lasted about 90 minutes.

### 4.3. Architecture Modeling
EVerest is built around loosely coupled modules communicating exclusively via MQTT; the framework manages their instantiation, communication, and dependency resolution. We therefore focused on the EVerest core, which encapsulates the central application logic and orchestrates the surrounding modules.
The architecture model was constructed as a Palladio component model [^20] as part of a practical course in a computer science master’s program, in which three students developed it under weekly supervision by three doctoral researchers in software engineering from the EVerest repository as of 3rd June 2024 (commit 177a8e6).
Each module was represented as a component with interface descriptions capturing the exchanged MQTT messages, including external modules interacting with internal ones. As the documentation lacked sufficient detail, all modeling decisions were grounded in the source code. For every contained method, the students created a service effect specification. service effect specifications describe the internal behavior of a component’s service, capturing its control flow, resource demands, and interactions with other services. The resulting model comprises 29 components, 34 interfaces, and 144 service effect specifications. In the assembly model, each component is represented with its required and provided interfaces; the deployment scenario assumes a single charging station alongside external entities such as an update server and a charging station management system, though alternative deployments can be derived straightforwardly. Finally, the Palladio usage model captures 14 scenarios extracted from the existing documentation and source code, covering, among others, firmware updates, charger enable/disable operations, and limit configuration.

### 4.4. Labeling Requirements
To ensure that the elicited requirements were actually requirements, two annotators labeled the texts as requirements or not requirements. As a result, 84 security requirements remained.
The labels of the security objectives of the security requirements stem from the elicitation.
The labeling of security elements was performed by three annotators (one PhD researcher, two students). As element types, classes of SecLan [^17] are used, which model common concepts in design-level security analyses/specifications and in security checks at the implementation level. The concepts, derived from an exploratory study, encompass and generalize all security elements of interest for security analyses. These include components, entities, data, states, hardware nodes, hardware connections, control flows, data flows, and internal activities. For this, the annotators initially started with the original definitions. Due to uncertainties, they reworked the definitions and added examples to reach a shared understanding. The resulting definitions and examples are documented in the dataset.

### 5\. Summary and Outlook
This paper presented the EVerest dataset, a multi-artifact resource based on EVerest, an industry-driven open-source software stack for [EV](#id3.3.id3) charging stations, spanning natural language documentation, security requirements, software architecture, and source code. The 84 manually elicited security requirements are annotated with security objectives, 1,445 fine-grained security elements, acceptance windows, coreferences, and architectural trace links. The dataset thereby addresses a recognized gap in the field, enabling research on security requirements classification, named entity recognition, architectural trace linking, and design-time as well as code-level security verification within a single resource.
During dataset creation, a concrete security weakness was identified using xDECAF [^1]: Requirement 5 stipulates that “\[…\] tokens used for authentication should not be stored in plain text in log files or persistent storage \[…\]”. The dataset snapshot’s source code, however, violates this requirement <sup>1</sup>. The weakness (CWE-1295) was disclosed to PIONIX GmbH and remedied shortly thereafter, confirming the dataset’s real-world relevance.
Future work will explore further weaknesses or vulnerabilities in the EVerest codebase and automated end-to-end security verification approaches leveraging the dataset’s multi-artifact structure.


## Key insights
- Omitting any of these steps can introduce security weaknesses.
- (3) We derived a software architecture model from the EVerest source code.
- Questionnaire

Employing multiple elicitation techniques has been shown to improve the completeness and quality of requirements [^25].
- Finally, where time constraints led to incomplete sentences, the interviewer revised them afterward and sent the result to the interviewee for confirmation or correction.
- The resulting model comprises 29 components, 34 interfaces, and 144 service effect specifications.
- Finally, the Palladio usage model captures 14 scenarios extracted from the existing documentation and source code, covering, among others, firmware updates, charger enable/disable operations, and limit configuration.
- As a result, 84 security requirements remained.
- As element types, classes of SecLan [^17] are used, which model common concepts in design-level security analyses/specifications and in security checks at the implementation level.
- The gold standard provides model element IDs for entity-like elements (e.g., components, data, nodes, and entities) as visualized by the color-coded architecture in Figure 1.

## Exemplos e evidências
See original source at `Clippings/The EVerest Dataset for Secure Software Engineering.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/ai-agents/orchestrat]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/Rust]]
- [[03-RESOURCES/entities/Python]]

## Minha Síntese
**O que muda:** Segurança de software precisa cobrir requirements→architecture→code end-to-end; datasets que faltam esse encadeamento impedem pesquisa de verificação de segurança integrada.

**Conexão pessoal:** Reforça que segurança não é só code scanning — preciso pensar em requirements classification e trace linking ao projetar pipelines de verificação.

**Próximo passo:** Explorar o dataset EVerest para entender como structured security requirements se conectam a architecture models.
