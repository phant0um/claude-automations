---
title: "LLM"
type: entity
category: model
tags: [entity, ai-model]
created: 2026-05-31
updated: 2026-06-01
status: developing
---

# LLM

Large Language Model — modelo baseado em transformer, bloco fundamental de toda a infraestrutura de agentes IA.

## O que é / What it is

LLMs são pré-treinados em corpora massivos de texto e realizam aprendizado few-shot diretamente do contexto (sem fine-tuning). Em 2026, principais players: Anthropic (Claude), OpenAI (GPT), Google (Gemini) e Meta (Llama). Estado da arte: context windows de 100k–1M+ tokens, capacidades multimodais, e tool use como primitiva padrão.

## Relevância para o vault

LLM é o conceito central por trás de todo o sistema de agentes de Michel — vault SO, Nexus e skills são camadas de abstração acima de LLMs. Entender trade-offs entre modelos (custo, contexto, raciocínio) é habilidade crítica para o vault.

## Sources

- [[03-RESOURCES/entities/Claude]]
- [[03-RESOURCES/entities/gpt]]
- [[03-RESOURCES/entities/gemini]]
- [[03-RESOURCES/entities/Llama]]

## Evidências
- **[2026-06-23]** As LLM-driven autonomous agents gradually acquire capabilities for autonomous planning, tool invocation, network access, code execution, and cross-app — [[agenticos-an-intent-oriented-secure-operating-system-architecture-for-autonomous]]
- **[2026-06-23]** JiongHan Wang [wangjh1@mail.ustc.edu.cn]() University of Science and Technology of ChinaHe FeiChina and WenChao Huang [huangwc@mail.ustc.edu.cn]() Uni — [[an-automated-framework-for-input-alphabet-construction-in-stateful-protocol-impl]]
- **[2026-06-23]** Coding agents now interleave LLMs with retrieval over the working repository, and retrieval implementations vary widely across deployed harnesses. Ins — [[code-isnt-memory-a-structural-codebase-index-inside-a-coding-agentcode-and-data]]
- **[2026-06-23]** Computer use agents (CUAs) have advanced rapidly in desktop automation, and a growing number of users deploy CUAs such as OpenClaw on Mac Mini for alw — [[macagentbench-benchmarking-ai-agents-on-real-world-macos-desktop]]
- **[2026-06-23]** --- title: "Movez on X: \"A senior Google engineer just dropped a 19-page PDF on \"Loop Engineering\" for LLM and agentic systems.Act → Observe → Lear — [[movez-on-x-a-senior-google-engineer-just-dropped-a-19-page-pdf-on-loop-engineeri]]
- **[2026-06-23]** Agentic coding harnesses—such as Agent-Skills, Superpowers, and Agent-Rigor—are increasingly deployed to augment underlying LLMs for real-world softwa — [[rigorbench-benchmarking-engineering-process-discipline-in-autonomous-ai-coding-a]]
- **[2026-06-23]** Large language models (LLMs) are increasingly used as judges for open-ended generation, as large-scale human evaluation is often expensive and difficu — [[aura-adaptive-uncertainty-aware-refinement-for-llm-as-a-judge-auditing]]
- **[2026-06-23]** Real-world users typically have access to multiple Large Language Models (LLMs) from different providers, and these LLMs often excel at distinct domai — [[agent-as-a-router-agentic-model-routing-for-coding-tasks]]
- **[2026-06-23]** Modern web applications increasingly combine three ingredients that are hard to test: output from large language models, multi-market internationaliza — [[all-green-still-broken-real-flow-verification-lessons-from-an-llm-integrated-mul]]
- **[2026-06-23]** As LLM-powered scams proliferate, black-box forensics for conversational LLM agents offers a path to accountability for systems hidden behind anonymou — [[black-box-forensics-for-conversational-llm-agents]]
- **[2026-06-23]** As AI systems move from single-turn interactions to coordinated multiagent workflows, low-latency [inference]() becomes increasing — [[boost-inference-performance-up-to-15x-on-nvidia-blackwell-using-dflash-speculati]]
- **[2026-06-23]** In open-ended generation, LLMs frequently fall into the “likelihood trap”, marked by repetitive degeneration and vocabulary dullness, creating a discr — [[breaking-the-likelihood-trap-variance-calibrated-modulation-for-large-language-m]]
- **[2026-06-23]** While large language models (LLMs) have greatly advanced the functional correctness of automated code translation systems, the runtime efficiency of t — [[bridging-functional-correctness-and-runtime-efficiency-gaps-in-llm-based-code-tr]]
- **[2026-06-23]** ``` Then open `apps/ibm_cloud_advisor/main.py` and read it end to end — it's the clearest example of the inline-tool-plus-MCP pattern. Change the syst — [[build-real-agentic-apps-using-cuga-two-dozen-working-examples-on-a-lightweight-h]]
- **[2026-06-23]** It is an understatement to say agents have become a popular way of working with code. GitHub has adopted agent-based code creation and editing for man — [[building-a-general-purpose-accessibility-agentand-what-we-learned-in-the-process]]
- **[2026-06-23]** Vision language models (VLMs) employ both visual and textual modalities to enable advanced vision–language inference. However, incorporating visual mo — [[de-five-detecting-malicious-image-prompts-via-fourier-features-and-image-vector]]
- **[2026-06-23]** Time series forecasting is a fundamental machine learning task. Recent work has explored Large Language Models (LLMs) for this purpose due to their st — [[distribution-aware-diffusion-llm-for-robust-ultra-long-term-time-series-forecast]]
- **[2026-06-23]** In this work we present a LLM powered, evolutionary code synthesis system for structured data translation in a Medical Internet of Things settings. A — [[formally-verified-code-synthesis-for-structured-data-translation-in-a-medical-in]]
- **[2026-06-23]** --- title: "From Models to Systems: Enabling Heterogeneous AI Inference with Open Orchestration" source: " author:   - "[[KiranAtmakuri]]"   - "[[Tom_ — [[from-models-to-systems-enabling-heterogeneous-ai-inference-with-open-orchestrati]]
- **[2026-06-23]** GitHub issue trackers contain millions of developer-written quality concerns, including performance bottlenecks and security vulnerabilities, yet no p — [[gitreq-a-gold-standard-dataset-for-software-quality-requirements]]
- **[2026-06-23]** The increasing deployment of large language model (LLM) agents in collaborative workflows demands robust multi-user, multi-principal interaction mecha — [[harness-mu-a-safe-governed-and-effective-harness-for-multi-user-llm-agents]]
- **[2026-06-23]** In our Engineering Energizers Q&A series, we highlight the engineering minds driving innovation across Salesforce. Today, we spotlight Ishween Kaur, S — [[how-agentforce-prevents-language-drift-in-600k-daily-multilingual-ai-workflows]]
- **[2026-06-23]** Translating sequential programming priors into the parallel temporal logic of hardware design remains a crucial bottleneck for large language models ( — [[how-llms-fail-and-generalize-in-rtl-coding-for-hardware-design]]
- **[2026-06-23]** [Deep Agents]() is an agent harness built on [LangGraph](), for agents that need to work through a task over many steps instead of a single LL — [[how-to-use-deep-agents-with-azure-cosmos-db-plan-act-and-verify-against-operatio]]
- **[2026-06-23]** External skills can improve action-oriented LLM agents without changing model weights, but persistent skill updates are risky when they are distilled — [[hypothesis-driven-skill-optimization-for-llm-agents]]
- **[2026-06-23]** GitHub Agentic Workflows is like a team of street sweepers that clean up little messes in your repo. These teams significantly improve — [[improving-token-efficiency-in-github-agentic-workflows]]
- **[2026-06-23]** Multi-agent systems (MAS) offer a scalable path forward for agentic AI, comprising multiple LLM-based agents, each assigned a system prompt and a posi — [[mas-promptbench-when-does-prompt-optimization-improve-multi-agent-llm-systems]]
- **[2026-06-23]** You open a fresh chat, type “What framework should I use for a web app?”, and the model says “React.” You screenshot it, share it, and write “Claude p — [[models-dont-have-preferences-they-have-context]]
- **[2026-06-23]** Production LLMs increasingly rely on toxicity-based moderation filters as a primary defense, assuming that harmful intent correlates with toxic surfac — [[otter-a-red-teaming-system-for-toxicity-evading-jailbreak-prompt-optimization]]
- **[2026-06-23]** LLM-based coding agents need higher-level operational knowledge about a repository (which files house which subsystems, how to run the test suite, whi — [[probe-and-refine-tuning-of-repository-guidance-for-coding-agents]]
- **[2026-06-23]** Large Language Models (LLMs) are increasingly used as judges for scalable evaluation, yet such LLM-as-a-Judge systems exhibit systematic biases that a — [[quantifying-and-auditing-llm-evaluation-via-positiveunlabeled-learning]]
- **[2026-06-23]** We present RLM-Cascade, a proxy-layer system that applies speculative decoding at the response level to reduce LLM API costs without requiring model a — [[rlm-cascade-response-level-speculative-decoding-for-cost-efficient-llm-api-servi]]
- **[2026-06-23]** Modern Large Language Models (LLMs) rely on extensive safety alignment, yet the mechanistic basis of refusal remains opaque. In this work, we investig — [[the-geometry-of-refusal-linear-instability-in-safety-aligned-llmsaccepted-at-tru]]
- **[2026-06-23]** Large model inference optimization serves as a key foundation for supporting the scalable, low-cost, and highly stable operation of large model servic — [[token-operations-oriented-inference-optimization-techniques-for-large-models]]
- **[2026-06-23]** This blog outlines five essential concepts that explain how [large language models]() process input within a co — [[top-five-essential-context-window-concepts-in-large-language-models]]
- **[2026-06-23]** Open-weight Large Language Models (LLMs) enable scientific progress and broad deployment. However, they make it difficult to control access to sensiti — [[toward-open-weight-models-without-risks-separating-public-and-private-capabiliti]]
- **[2026-06-23]** Pre-trained language models (PTLMs) hosted on platforms such as Hugging Face form complex lineage structures similar to software dependency graphs. Ho — [[towards-imputation-of-pre-trained-language-model-metadata-using-semantic-fingerp]]
- **[2026-06-23]** Large language model (LLM) interaction records are increasingly vital in digital forensics and compliance auditing. However, traditional linear tamper — [[vct-a-verifiable-transcript-system-for-llm-conversations]]
- **[2026-06-23]** We present a dependent-type-based prover designed around the way LLMs (and humans) tend to write mathematics, complementing existing systems such as L — [[visored-a-controlled-natural-language-prover-for-llm-generated-mathematics]]
- **[2026-06-23]** Training a model to predict the next step in a concurrent program is harder than it looks: two runs of the same program from the same trace prefix can — [[when-the-next-step-is-not-one-step-distribution-aware-execution-modeling-for-con]]
- **[2026-06-23]** As AI agents become long lived and concurrent, memory capacity, not just compute, has emerged as the deciding factor in real world AI workstation perf — [[why-memory-capacity-is-the-real-performance-bottleneck-in-agentic-ai-workstation]]
- **[2026-06-23]** Ruixiao Lin[1,2,][†] , Xinhao Deng[2,3,][†] , Qingming Li[1] , Jianan Ma[4,2] , Yunhao Feng[2] , Yuqi Qing[2,3] , Zhenyuan Li[1] , Yechao Zhang[5] , S — [[260623075v1]]
- **[2026-06-23]** Model-Based Systems Engineering (MBSE) methods that support formally defined modeling languages can provide feedback when models violate syntactic rul — [[automated-semantic-fault-localization-in-sysml-v2-a-human-in-the-loop-framework]]
- **[2026-06-23]** Yifei Wang [0000-0003-0100-6896]( "ORCID identifier") [whiten@whu.edu.cn]() School of Computer Science, Wuhan UniversityWuhanChina, Ruiyin Li [0000-00 — [[codeteam-an-llm-powered-multi-agent-framework-for-repository-level-code-generati]]
