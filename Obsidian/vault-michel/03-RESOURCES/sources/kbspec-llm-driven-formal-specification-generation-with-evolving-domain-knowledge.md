---
title: "KBSpec: LLM-driven Formal Specification Generation with Evolving Domain Knowledge Base"
type: source
source: "Clippings/KBSpec LLM-driven Formal Specification Generation with Evolving Domain Knowledge Base.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
---
title: "KBSpec: LLM-driven Formal Specification Generation with Evolving Domain Knowledge Base"
source: "
author:
published: 2009-06-04
created: 2026-06-23
description:
tags:
  - "clippings"
---
Wenhan Wang [wangwenhan@isacas.ac.cn]() Institute for Software Chinese Academy of SciencesChina and Zeyu Sun [zeyu.zys@gmail.com]() Institute for Software Chinese Academy of SciencesChina

###### Abstract. Automated formal specification generation is a key step towards program understanding and forma

## Argumentos principais
### 1\. Introduction
Formal specifications serve as a key for ensuring the correctness, safety, and maintainability of software systems. They provide mathematically precise, unambiguous descriptions of system behaviour and constraints instead of relying solely on informal requirements or code comments. Despite their substantial benefits, writing formal specifications remains a labour-intensive task requiring deep expertise in formal specification languages. Usually, formal specifications contain pre/post-conditions, loop invariants and assertions, which require complex and accurate reasoning on program semantics and execution behavior. With the explosion of large language models (LLMs), researchers have leveraged the powerful reasoning abilities of LLMs in formal specification generation [^14] [^13] [^25] [^10], and outperformed traditional specification generation tools [^8] [^9].
However, some significant challenges still remain for LLM-based formal specification generation: one key challenge is the lack of domain knowledge. This is mainly because formal specifications are not widely used in most software development practices, which makes them “low-resource languages” that scarcely exist in the training corpora of LLMs. This lack of domain knowledge causes LLMs to frequently produce low-level errors, from malformed syntax to missing boundary checks. For example, previous studies [^10] have found that syntax errors are the most frequent type of error in Java Modeling Language (JML) [^2] specification generation, which takes up over 40% of the total errors of LLM-generated specifications.
To tackle the lack of domain knowledge in LLM-driven formal specification generation, a key direction is to explicitly augment LLMs with the external knowledge of formal specification languages, such as documents or tutorials written by the formal specification language developers. A similar idea has been adopted in code generation, where retrieval-augmented generation from online resources such as StackOverflow or GitHub has shown effectiveness [^19] [^28].

### 2.1. LLMs for Formal Specification Generation
With the advancement of large language models, there has been a growing interest in exploring LLMs for formal specification generation. Several early works focus on specific sub-types of specification, such as postconditions and loop invariants [^20] [^7] [^1]: Pei et al. [^20] fine-tuned open-source LLMs to generate invariants for Java code. Endres et al. [^7] proposed NL2PostCond, which generates postconditions from natural language descriptions, although the generated postconditions are only Python assertions and cannot be verified by formal verifiers.
Other works aim to generate general-purpose specifications for C [^25] [^27] [^4], Java [^14] [^10], or other programming languages. Wen et al. [^25] proposed AutoSpec, combining LLMs with static analysis and formal verification to generate complete C specifications using ACSL and Frama-C [^6], while Preguss [^24] generates ACSL specifications with LLMs by using potential runtime error locations. Another approach, ClassInvGen [^22], leverages test cases to aid LLM-driven specification generation for C++ classes. Ma et al. [^14] first introduced an LLM-based specification generation approach, SpecGen, for Java specification generation. SpecGen leverages a multi-turn conversation framework with additional mutation operators to improve the correctness of generated JML specifications. Le et al. [^10] proposed FormalBench, the so far largest benchmark for LLM-based JML specification generation. The authors conducted an empirical study of state-of-the-art LLMs and found that existing LLMs still have very low pass rates in generating formal specifications that are syntactically correct and verifiable.
While the above approaches focus on generating formal specifications from programs, some other works target specification generation from natural language descriptions. Req2LTL [^15] utilizes an intermediate structural language to map aerospace requirements to LTL using LLMs. Cao et al. [^3] conducted a large-scale empirical study on LLM in translating natural language requirements to formal specifications in five different formal languages. Li et al. [^11] evaluated LLMs on extracting formal specifications from UAC flight control software while discovering two major limitations: specification oversimplification and specification fabrication.

### 2.2. Agentic LLM Memory
Our approach is related to the area of agentic LLM memory [^30]. These approaches augment LLMs with external memory modules that support storage, read, and write operations, which allow LLMs to interact with broader contexts [^18] [^31] [^23] [^26] [^29]. For example, Memorybank [^31] maintains a memory storage from historical LLM interactions. MemGPT [^18] draws ideas from operating systems and performs memory read/write operations via LLM function calls. Xu et al. [^26] propose an agentic memory system A-Mem that creates interconnected memory “notes” with contextual tags and links. It can continuously refine itself as the agent performs update actions to notes and links between notes. Zhang et al. [^29] proposed ACE (Agentic Context Engineering), which organizes and refines a memory base using 3 types of operations: generation, reflection, and curation.

### 3\. Motivating Example
Figure 1. A motivating example demonstrates the importance of leveraging knowledge for specification generation.
Figure 1 (a) shows a motivating example for leveraging external knowledge sources. As demonstrated, SumNums is a function that performs summation on variables with int types. If we directly ask an LLM to generate its specification, as LLMs may not possess the knowledge that “when the program is possible to trigger an integer overflow, we must specify the value range of variables in the precondition to prevent overflow”, the LLMs will likely generate a specification that introduces a verification failure (on the postcondition). In contrast, if we provide the LLM with a knowledge source from the official JML tutorial that states how to prevent the overflow bug, then the LLM is able to include the value ranges in the precondition, thus allowing the specification to be successfully verified.
Figure 1 (b) further demonstrates that external knowledge alone is not sufficient for generating correct formal specifications. Consider the Java method bigDiff, which computes the difference between the maximum and minimum elements of an integer array. If we only retrieve knowledge from external sources (e.g., JML official documents), we can see that the retriever returns some JML official examples related to computing max values. However, this results in a JML error where the LLM-generated specification uses the inductive quantifier \\max and \\min. This is because the OpenJML verifier in ESC mode does not fully support some inductive quantifiers [^10], but it was not fully stated and explained, nor are substitutional approaches given. Meanwhile, in our approach, where we can retrieve internal knowledge gained from past successful generation and repair patterns, the LLM grasps the idea of how to avoid the \\max quantifier by generating a specification using \\forall, which can successfully pass the OpenJML verification.

### 4\. Approach
Figure 2. The method overview of KBSpec
Figure 2 shows the overall structure of our approach. KBSpec is an LLM-based framework that involves interacting with a dynamically updated knowledge base $M$ and a formal verifier. The whole pipeline consists of three steps:
1. Knowledge base initialization: In this step, we build an initial knowledge base for formal specification using external knowledge sources, such as official documents and example specifications. This knowledge base will further support retrieval-augmented specification generation and repair.

### 4.1. Specification Knowledge Base: Initialization
| Data Source | No. items |
| --- | --- |
| OpenJML examples | 11 |

### 4.2. Knowledge Base Evolving with Verifier Feedback
In this stage, we perform a retrieval-augmented specification generation and repair pipeline which runs for multiple epochs. The key insight is to update the knowledge base by selected specification generation/repair trajectories, and remove knowledge items that are not helpful to generate correct specifications. The detailed pipeline in one KBSpec epoch consists of the following steps:
#### 4.2.1. Epoch Initialization
At the beginning of each epoch, we first initialize a candidate new knowledge set $C_{epoch}$ that stores new knowledge items generated during this epoch. For the knowledge items already in the knowledge base, in order to determine if an item is helpful, harmful, or neutral, each knowledge item $m_{i}$ maintains a helpfulness score triplet $<s_{helpful},s_{harmful},s_{neutral}>$. At the beginning of each knowledge evolving epoch, all knowledge items’ helpfulness scores are initialized as $<s_{helpful}=0,s_{harmful}=0,s_{neutral}=0>$.

### 4.3. Knowledge-Augmented Inference
In the inference stage of KBSpec, we apply a similar retrieve-augmented generation and repair pipeline. The main difference from the training stage is that after we retrieve $N$ most relevant items, we do not perform random sampling to decide which items should be used for specification generation. Instead, we let the LLM autonomously choose the most relevant items. In this step, we provide the LLM selector with all the summaries of the $N$ items, and ask the LLM to choose at most 3 knowledge items that are most helpful to the current specification generation and repair task. Similar to the knowledge evolving stage, if the initial specification generation is unsuccessful, we perform an iterative repair with a maximum of 3 rounds.

### 5.1. Research Questions
To evaluate and understand KBSpec for JML specification generation, we aim to answer the following research questions:
- RQ1: How does KBSpec improves the effectiveness of specification generation over state-of-the-art baselines?
- RQ2: How does each component of KBSpec affect the performance of specification generation?

### 5.2. Experiment Settings
#### 5.2.1. Dataset
We conduct our main experiments on the FormalBench [^10] dataset. FormalBench is a state-of-the-art benchmark for JML specification generation from Java source code. The dataset consists of two parts: the FormalBench-Base dataset, which contains 699 Java programs for evaluation, and the FormalBench-Diverse dataset, which comprises 6,219 programs that are built from applying mutations on FormalBench-Base. In this paper, we follow previous settings and use the FormalBench-Base dataset for evaluation. We use a subset of FormalBench-Diverse (containing 1,794 programs with complete metadata, following the settings of the FormalBench repository) only for knowledge base evolution prior to evaluation. In each epoch, we only randomly sample 100 programs from the diverse dataset for training, and the training stage continues for 10 epochs.
#### 5.2.2. Implementation Details

### 5.3. RQ1: Overall Performance
<table><thead><tr><th rowspan="2">Approach</th><th colspan="3">GPT-5.2</th><th></th><th colspan="3">GPT-5-mini</th><th></th><th colspan="3">DeepSeek-V3.2</th></tr><tr><th>PR</th><th>FR</th><th>C</th><th></th><th>PR</th><th>FR</th><th>C</th><th></th><th>PR</th><th>FR</th><th>C</th></tr></thead><tbody><tr><th>Base</th><td>10.73</td><td>58.37</td><td>85.73</td><td></td><td>5.59</td><td>65.47</td><td>89.11</td><td></td><td>4.43</td><td>75.82</td><td>86.99</td></tr><tr><th>Few-shot</th><td>14.88</td><td>51.07</td><td>87.65</td><td></td><td>7.58</td><td>64.94</td><td>92.55</td><td></td><td>15.31</td><td>54.65</td><td>88.62</td></tr><tr><th>LTM</th><td>14.35</td><td>55.09</td><td>90.94</td><td></td><td>9.58</td><td>60.80</td><td>88.94</td><td></td><td>14.02</td><td>57.51</td><td>88.30</td></tr><tr><th>+Repair</th><td>30.90</td><td>37.05</td><td>78.92</td><td></td><td>18.31</td><td>71.24</td><td>81.54</td><td></td><td>21.60</td><td>55.80</td><td>88.40</td></tr><tr><th>SpecGen</th><td>43.35</td><td>31.33</td><td>67.54</td><td></td><td>24.03</td><td>46.78</td><td>78.08</td><td></td><td>32.76</td><td>34.33</td><td>64.77</td></tr><tr><th>KBSpec</th><td>58.94</td><td>20.60</td><td>57.77</td><td></td><td>49.64</td><td>33.33</td><td>64.77</td><td></td><td>43.35</td><td>31.76</td><td>71.98</td></tr></tbody></table>
Table 2. Results of KBSpec compared to baseline approaches with different LLM backends. All metrics are reported in %.
Table 2 presents the overall performance of KBSpec over baseline approaches on FormalBench-Base across three LLM backends (GPT-5.2, GPT-5-mini, and DeepSeek-V3.2). In general, KBSpec consistently achieves the highest verification pass rate and the lowest fail rate across all models, substantially outperforming both advanced prompting baselines and the state-of-the-art baseline SpecGen.

### 5.4. RQ2: Ablation Study
RQ2 evaluates the contribution of five KBSpec components: 1) The initialization of the knowledge base with documents, 2) The whole knowledge base evolving stage, 3) The knowledge filtering mechanism for selecting helpful knowledge items, 4) The LLM-based knowledge retrieval module during the inference stage, and 5) the iterative repair during inference. We conduct an ablation study on the above components with all three LLM backends, and the results are shown in Table 5. From the results, we find that:
<table><thead><tr><th rowspan="2">Approach</th><th colspan="3">GPT-5.2</th><th></th><th colspan="3">GPT-5-mini</th><th></th><th colspan="3">DeepSeek-V3.2</th></tr><tr><th>PR</th><th>FR</th><th>C</th><th></th><th>PR</th><th>FR</th><th>C</th><th></th><th>PR</th><th>FR</th><th>C</th></tr></thead><tbody><tr><th>w/o initialization</th><td>46.92</td><td>26.90</td><td>63.06</td><td></td><td>44.92</td><td>29.18</td><td>69.69</td><td></td><td>36.05</td><td>36.33</td><td>75.73</td></tr><tr><th>w/o evolving</th><td>27.61</td><td>40.49</td><td>77.77</td><td></td><td>24.32</td><td>62.37</td><td>78.13</td><td></td><td>21.32</td><td>49.07</td><td>86.26</td></tr><tr><th>w/o knowledge filtering</th><td>55.65</td><td>22.60</td><td>62.69</td><td></td><td>50.78</td><td>26.47</td><td>65.88</td><td></td><td>37.48</td><td>34.48</td><td>74.90</td></tr><tr><th>w/o LLM-based retrieval</th><td>56.80</td><td>23.32</td><td>57.88</td><td></td><td>44.06</td><td>31.62</td><td>67.44</td><td></td><td>27.04</td><td>43.92</td><td>81.18</td></tr><tr><th>w/o iterative repair</th><td>28.61</td><td>38.05</td><td>66.02</td><td></td><td>17.74</td><td>55.51</td><td>73.29</td><td></td><td>24.03</td><td>45.35</td><td>79.02</td></tr><tr><th>full KBSpec</th><td>58.94</td><td>20.60</td><td>57.77</td><td></td><td>49.64</td><td>33.33</td><td>64.77</td><td></td><td>43.35</td><td>31.76</td><td>71.98</td></tr></tbody></table>
Table 5. Results of the ablation study with different LLM backends.

### 5.5. RQ3: Analysis on Knowledge Learning
To analyze the knowledge learned during the knowledge base evolving process, we aim to investigate:
- What types of knowledge items exist in the final knowledge base, and what types of them are retrieved?
- What kinds of knowledge patterns (e.g., specification bug and repair patterns) are learned?

### 6\. Threats to Validity
Internal validity. A potential threat is the non-determinism in specification generation, as LLMs may introduce randomness. We follow prior work [^10] and use the default value 0.7 for LLMs that support temperature setting. Another threat relates to the design of prompt templates. As the performance of LLMs may be sensitive to prompt design, we use similar templates as previous specification generation approaches [^14] [^10] for specification generation and repair.
External validity. Our evaluation is conducted exclusively on JML specifications using the OpenJML verifier and the FormalBench benchmark. While the findings may not directly generalize to other specification languages (e.g., ACSL for C, or Dafny), the design of KBSpec is language-agnostic in principle: the knowledge base initialization and verifier-driven knowledge evolving can be adapted to any specification language with an automated verifier. Evaluating KBSpec on additional languages and verifiers can be addressed in future work. Another external threat is the scale and the complexity of the FormalBench dataset. Although the FormalBench dataset only contains standalone Java functions, it is still the largest available JML specification generation benchmark, with complexity higher than previous benchmarks such as SpeGen [^14]. In the future, we aim to further extend our specification approaches to real-world software projects.

### 7\. Conclusion
In this paper, we propose KBSpec, an approach that augments LLMs with a dynamically evolving knowledge base for formal specification generation. KBSpec integrates two complementary knowledge sources: external knowledge from official documentation and tutorials, and internal knowledge distilled from successful generation and repair trajectories via verifier feedback. The knowledge base training mechanism of KBSpec is parameter-free, making it agnostic to the choice of LLM and lightweight to deploy. Experiments on the FormalBench benchmark with three LLM backends demonstrate that our approach substantially improves verification pass rates over prior state-of-the-art approaches while preserving specification completeness.
In the future, we plan to extend KBSpec to other formal specification languages, and support formal verification for real-world software systems. We also aim to explore more sophisticated knowledge organization strategies, such as hierarchical or graph-structured memory, to improve the efficiency of the training process and the knowledge density of the learned knowledge base.
[^1]: LLM for loop invariant generation and fixing: how far are we?. arXiv preprint arXiv:2511.06552. Cited by: §2.1.


## Key insights
- RQ1: How does KBSpec improves the effectiveness of specification generation over state-of-the-art baselines?
- RQ2: How does each component of KBSpec affect the performance of specification generation?
- RQ3: What kinds of knowledge are acquired during knowledge base evolution, and which of them are the most useful?
- Pass rate (PR): the rate of generated specifications that can be successfully verified by the verifier.
- Few-shot in-context-learning: The LLM is prompted by two expert-written examples on how to generate JML specifications from Java code.
- What types of knowledge items exist in the final knowledge base, and what types of them are retrieved?
- What kinds of knowledge patterns (e.g., specification bug and repair patterns) are learned?

## Exemplos e evidências
See original source at `Clippings/KBSpec LLM-driven Formal Specification Generation with Evolving Domain Knowledge Base.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/OpenAI]]
- [[03-RESOURCES/entities/AWS]]
- [[03-RESOURCES/entities/Python]]

## Minha Síntese
**O que muda:** A ser analisado em revisão manual.

**Conexão pessoal:** A ser conectado com projetos/estudo atuais.

**Próximo passo:** Nenhum próximo passo imediato.
