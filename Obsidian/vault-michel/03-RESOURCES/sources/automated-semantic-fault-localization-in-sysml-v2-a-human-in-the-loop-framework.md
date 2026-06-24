---
title: "Automated Semantic Fault Localization in SysML v2: A Human-in-the-Loop Framework Using Knowledge-Graph Augmented LLMs"
type: source
source: "Clippings/Automated Semantic Fault Localization in SysML v2 A Human-in-the-Loop Framework Using Knowledge-Graph Augmented LLMs.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
Model-Based Systems Engineering (MBSE) methods that support formally defined modeling languages can provide feedback when models violate syntactic rules. However, semantic faults that preserve syntactic validity while violating domain-specific engineering constraints often remain undetected. SysML v2 introduces a textual syntax for MBSE models in addition to its graphical notation, and this enables compiler-like validation of model structure and language conformance.

## Argumentos principais
### Introduction
Model Based Systems Engineering (MBSE) is the practice of maintaining a formal, single, authoritative digital model of the system, from which all other views (documents, simulations) are derived. This model-centered approach supports early validation, traceability, and communication between different engineering disciplines. As systems grow in scale, explicitly modeling components, interfaces, requirements, and constraints helps engineers manage dependencies and maintain consistency more effectively than traditional document-based approaches.
SysML v2 allows defining system structure, behavior, requirements, and constraints through formally specified textual notation alongside a graphical notation. This standardized textual syntax makes system models directly accessible to methods such as parsing, version comparison, automated analysis, and language model based repair. To this end, Large Language Models (LLMs) have been applied to SysML v2 in three ways: as interactive assistants that integrate models from different organizations ([^7]), as reviewers that analyze models for potential issues ([^1]), and as autonomous agents that generate model fragments from natural language requirements ([^6] [^9]).
Despite these advances, SysML v2 remains a modeling language in which the engineer’s intent plays a central role in shaping the model. Such intent is often implicit and difficult to capture within current LLM frameworks, which can limit their practical effectiveness. In addition, existing work highlights that domain-specific fine-tuning is constrained by the scarcity of high-quality SysML v2 training data ([^6]). Consequently, general-purpose LLMs have limited exposure to valid SysML v2 syntax and frequently produce syntactic errors or invalid constructs. Even when syntactically correct, models can create semantic hallucinations by generating elements that satisfy language rules and tool-level checks but violate engineering constraints. For example, a model may connect incompatible physical interfaces or assign units that are inconsistent with the represented quantities. Furthermore, context window limitations restrict an LLM’s ability to reason over large systems, where relevant constraints may span thousands of lines.

### Related Work
This section reviews literature that integrates LLMs with SysML v2 for model generation, evaluation metrics, data preparation, and model validation. [^2] examined the use of general-purpose LLMs for generating SysML v2 models and report that direct prompting often produces outputs that appear structurally plausible but fail syntactic validation. Common failure modes include hallucinated SysML v1 syntax and nonexistent SysML v2 keywords. To address these issues, the authors propose SysMLAgent, an autonomous agent-based framework that decomposes model generation into iterative planning, code generation, validation, and repair steps. The framework uses a Belief-Desire-Intention architecture to maintain the current model state, pursue the goal of producing a valid SysML v2 model, and update its actions based on validation feedback. They integrate Retrieval-Augmented Generation (RAG), ANTLR validation, and a generation loop to limit issues of hallucinations and improve the generated model quality. Their agentic architecture achieved a score of 2.5 on their evaluation benchmark, whereas baseline LLMs achieved 1.0.
[^2] primarily addressed syntactic validity rather than domain-level semantic correctness. Parser-based validation can identify grammar violations, but cannot determine whether a generated model satisfies physical compatibility constraints or reflects valid engineering intent. In addition, the framework relies on retrieval from a limited example database, which may reduce robustness when user requests fall outside the covered modeling patterns. These limitations motivate approaches that combine language models with explicit domain knowledge.
[^3] presented an LLM-driven approach for interacting with SysML v2 models through the standard SysML v2 API using natural language input. In this workflow, the LLM is given access to an existing ground-truth model and is tasked with performing both simple and complex model-editing operations. When the generated code is not compiler-ready, the system uses the resulting runtime exception or syntax error as feedback in a regeneration loop, allowing the LLM to iteratively revise its output through in-context learning. The study identifies several limitations of LLM-driven system design approaches. First, natural-language requests can be ambiguous, leading the LLM to misinterpret the engineer’s intent. Second, direct modification of SysML v2 code may fail to preserve the syntactic and semantic precision required by the language. Third, generated code and model edits require robust error handling, rollback, and validation to avoid corrupting the model or producing technically unreliable results. Fourth, output quality depends strongly on the quality, currency, and completeness of the contextual model information provided to the LLM. The paper also notes security and privacy concerns, workflow-integration costs, and the risk of automation bias or overreliance on generated outputs. These findings highlight the need for explicit, well-structured domain knowledge and independent validation when applying LLMs to SysML v2 modeling tasks.

### Methodology
This section presents the workflow in the order of its construction and use. The [Domain Knowledge-Graph](#Sx3.SSx1 "In Methodology ‣ Automated Semantic Fault Localization in SysML v2: A Human-in-the-Loop Framework Using Knowledge-Graph Augmented LLMs") subsection introduces a knowledge graph (KG) formalizing physical compatibility constraints which are used for both dataset generation and prompt augmentation. The [Dataset Synthesis](#Sx3.SSx2 "In Methodology ‣ Automated Semantic Fault Localization in SysML v2: A Human-in-the-Loop Framework Using Knowledge-Graph Augmented LLMs") subsection then describes how a small corpus of valid SysML v2 models is expanded into a labeled dataset through [Synthetic Syntax Fault Generation](#Sx3.SSx2.SSSx1 "In Dataset Synthesis ‣ Methodology ‣ Automated Semantic Fault Localization in SysML v2: A Human-in-the-Loop Framework Using Knowledge-Graph Augmented LLMs"), [KG Guided Semantic Fault Generation](#Sx3.SSx2.SSSx2 "In Synthetic Syntax Fault Generation ‣ Dataset Synthesis ‣ Methodology ‣ Automated Semantic Fault Localization in SysML v2: A Human-in-the-Loop Framework Using Knowledge-Graph Augmented LLMs"), and inclusion of correct examples for error classification ([Correct Examples](#Sx3.SSx2.SSSx3 "In KG Guided Semantic Fault Generation ‣ Synthetic Syntax Fault Generation ‣ Dataset Synthesis ‣ Methodology ‣ Automated Semantic Fault Localization in SysML v2: A Human-in-the-Loop Framework Using Knowledge-Graph Augmented LLMs")).
The [Patch-based outputs](#Sx3.SSx3 "In Correct Examples ‣ KG Guided Semantic Fault Generation ‣ Synthetic Syntax Fault Generation ‣ Dataset Synthesis ‣ Methodology ‣ Automated Semantic Fault Localization in SysML v2: A Human-in-the-Loop Framework Using Knowledge-Graph Augmented LLMs") subsection motivates the use of unified diff patches as the model output format. Finally, [Supervised Fine-tuning](#Sx3.SSx4 "In Patch-based outputs ‣ Correct Examples ‣ KG Guided Semantic Fault Generation ‣ Synthetic Syntax Fault Generation ‣ Dataset Synthesis ‣ Methodology ‣ Automated Semantic Fault Localization in SysML v2: A Human-in-the-Loop Framework Using Knowledge-Graph Augmented LLMs") subsection outlines the fine-tuning procedure, including data-leak-proof split ([Dataset Split](#Sx3.SSx4.SSSx1 "In Supervised Fine-tuning ‣ Patch-based outputs ‣ Correct Examples ‣ KG Guided Semantic Fault Generation ‣ Synthetic Syntax Fault Generation ‣ Dataset Synthesis ‣ Methodology ‣ Automated Semantic Fault Localization in SysML v2: A Human-in-the-Loop Framework Using Knowledge-Graph Augmented LLMs")), the evaluation methods ([Evaluation](#Sx3.SSx4.SSSx2 "In Supervised Fine-tuning ‣ Patch-based outputs ‣ Correct Examples ‣ KG Guided Semantic Fault Generation ‣ Synthetic Syntax Fault Generation ‣ Dataset Synthesis ‣ Methodology ‣ Automated Semantic Fault Localization in SysML v2: A Human-in-the-Loop Framework Using Knowledge-Graph Augmented LLMs")), and the selection of base models ([Model Selection](#Sx3.SSx4.SSSx3 "In Supervised Fine-tuning ‣ Patch-based outputs ‣ Correct Examples ‣ KG Guided Semantic Fault Generation ‣ Synthetic Syntax Fault Generation ‣ Dataset Synthesis ‣ Methodology ‣ Automated Semantic Fault Localization in SysML v2: A Human-in-the-Loop Framework Using Knowledge-Graph Augmented LLMs")).

### Domain Knowledge-Graph
The knowledge graph (KG) encodes the physical and engineering constraints used to evaluate SysML v2 models in the target domain and accomplishes two roles in the proposed framework.
1. Supporting the mutation engine by providing domain rules which are violated to generate semantically faulty training examples.
2. Augmenting the prompts with rules relevant to the code being analyzed, providing domain context for semantic fault detection and repair.

### Dataset Synthesis
The baseline dataset was constructed using the official SysML v2 Pilot Implementation repository ([^10]) to address the scarcity of high-quality SysML v2 corpora. This repository provides examples of syntactically and semantically valid models.
The dataset contains 256 unique SysML v2 files, organized into domains such as vehicle systems, geometry, mass roll-ups, and state-space representations. Static analysis shows a distribution bias toward structural modeling elements. As shown in Figure 2, part usage and attribute usage account for nearly 39% of all identified constructs, reflecting the language’s primary use in defining system architectures. Behavioral constructs (e.g., state def) and requirements appear less frequently, which poses a challenge for training LLMs to learn dynamic system behaviors.
#### Synthetic Syntax Fault Generation


## Key insights
- A dataset of correct, syntactically, and semantically faulty SysML v2 models, and its synthesis methodology.
- A domain-aware fault localization pipeline guided by a knowledge graph of physical interface and quantity constraints.
- Evaluation of two fine-tuned SLMs for identifying and repairing syntactic and semantic SysML v2 faults through unified diff outputs.
- Physical Quantity KG: This graph maps International System of Quantities (ISQ) types to valid units. It is used to identify dimensional inconsistencies, such as assigning voltage units, \[V\], to a mass quantity.
- The valid SysML v2 source file is loaded.
- A specific mutation operator is applied to create a potentially corrupted candidate.
- The candidate is executed against a SysML v2 Jupyter kernel (via Jupyter client).
- If the kernel returns a compilation error, the pair (Broken Code, Error Message) is saved. If the mutation accidentally results in valid code (e.g., renaming an unused variable), the sample is discarded.

## Exemplos e evidências
See original source at `Clippings/Automated Semantic Fault Localization in SysML v2 A Human-in-the-Loop Framework Using Knowledge-Graph Augmented LLMs.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/verification]]

## Minha Síntese
**O que muda:** A ser analisado em revisão manual.

**Conexão pessoal:** A ser conectado com projetos/estudo atuais.

**Próximo passo:** Nenhum próximo passo imediato.
