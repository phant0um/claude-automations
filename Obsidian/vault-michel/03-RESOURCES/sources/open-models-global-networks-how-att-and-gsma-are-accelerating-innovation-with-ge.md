---
title: "Open models, global networks: How AT&T and GSMA are accelerating innovation with Gemma"
type: source
source: "Clippings/Open models, global networks How AT&T and GSMA are accelerating innovation with Gemma.md"
created: 2026-06-23
ingested: 2026-06-23
score: B
tags: [ai-agents, source-page]
---

## Tese central
---
title: "Open models, global networks: How AT&T and GSMA are accelerating innovation with Gemma"
source: "
author:
  - "[[Sridhar Gollapudi]]"
published: 2026-06-23
created: 2026-06-23
description: "The scale, complexity, and specificity faced by telecom providers means domain-specific models remain the best way to achieve dramatic network and process automation and agentic workflows."
tags:
  - "clippings"
---
Telecommunications

## Open models, global networks: How AT&T and GSMA are acceler

## Argumentos principais
### Open models, global networks: How AT&T and GSMA are accelerating telecom innovation with Gemma
##### Sridhar Gollapudi
Telco Market Lead, Global Telcos
##### Try Gemini Enterprise Business Edition today

### Why domain-specific models matter
Generalized frontier models are incredibly capable at broad reasoning and language tasks, but they lack the foundational context required to manage critical infrastructure. General models still struggle with highly specialized vocabulary, complex network topologies, and vendor-specific telemetry data unique to the telecom sector.
Telco-specific models solve this by anchoring the AI in the actual realities of network operations. By training on domain-specific datasets, these tailored models can interpret nuanced technical logs, diagnose network performance bottlenecks, and understand standard industry protocols with the high degree of accuracy and precision required for real-time systems.

### Google’s Gemma models: Underpinning Open Telco AI
To address this challenge, the GSMA recently launched the [Open Telco AI]() platform to build accurate, efficient, and trusted telco-grade AI. As a core part of this collaborative effort, AT&T post-trained a family of open telco models, called [OTel](), on different architectures including [Google’s open-source Gemma models]().
These models were trained on a specialized telco-specific dataset curated by GSMA and its collaborators, including telecom operators, network equipment providers, and academia. The initiative successfully delivered 30 models across a range of sizes and architectures, optimizing the balance between accuracy and efficiency.
Crucially, these models are built with safety at their core, being trained for abstention using [retrieval augmented generation (RAG)]() to drastically reduce hallucinations — an absolute necessity in highly regulated telecom environments that are so central to modern life.

### Gemma emerges as a leading model
AT&T’s tests during OTel development highlight the strength of Gemma compared to other architectures, demonstrating strong performance gains across the entire OTel model family after telecom-specific fine-tuning. Notably:
- The [gemma-4-E4B-it]() model returned correct response 91.74% of the time, achieving the highest overall accuracy for all models tested.
- This baseline version of Gemma 3 with 27-billion parameters delivered the strongest performance in initial model training across the models tested by AT&T.

### Empowering the future with Google Cloud's full-stack solutions
The impact of this open collaboration has been immediate, with over 18 million downloads of the models to date. Today, OTel stands as one of the top models on the [Open Telco Benchmarks](), demonstrating that tailored, smaller models can outperform massive frontier models when optimized for specific domains.
Looking ahead, Google Cloud is committed to supporting telecom operators globally in developing and deploying their own custom telco AI models.
By providing a comprehensive, full-stack solution — including robust AI-optimized infrastructure, AI development tools, and open models like Gemma — we can help operators, vendors, and innovators fine-tune these models further with their own data. This enables telecom operators to accelerate their journey in AI adoption while deploying telco-grade AI safely using Gemma’s built-in support and guardrails.


## Key insights
- "[[Sridhar Gollapudi]]"
- The [gemma-4-E4B-it]() model returned correct response 91.74% of the time, achieving the highest overall accuracy for all models tested.
- This baseline version of Gemma 3 with 27-billion parameters delivered the strongest performance in initial model training across the models tested by AT&T.
- The Gemma 3 model with 300-million telco-related [embeddings]() saw a significant retrieval improvement.

## Exemplos e evidências
See original source at `Clippings/Open models, global networks How AT&T and GSMA are accelerating innovation with Gemma.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/fine-tun]]
- [[03-RESOURCES/entities/Gemini]]
- [[03-RESOURCES/entities/Rust]]
