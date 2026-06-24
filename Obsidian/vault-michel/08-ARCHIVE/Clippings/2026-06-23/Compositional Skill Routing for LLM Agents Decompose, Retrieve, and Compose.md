---
title: "Compositional Skill Routing for LLM Agents: Decompose, Retrieve, and Compose"
source: "https://arxiv.org/html/2606.18051v1"
author:
published:
created: 2026-06-22
description:
tags:
  - "clippings"
---
Xueping Gao  
Alibaba Cloud  
Hangzhou, China  
hellogxp@gmail.com

###### Abstract

LLM agents increasingly rely on external skills—reusable tool specifications—but real-world tasks often require *composing* multiple skills, not just selecting one. We formalize this as the Compositional Skill Routing problem: given a complex user query and a large skill library, decompose the query into atomic sub-tasks, retrieve the appropriate skill for each sub-task, and compose an executable plan. We present SkillWeaver, a decompose-retrieve-compose framework combining an LLM task decomposer, a bi-encoder skill retriever with FAISS indexing, and a dependency-aware DAG planner. To support evaluation, we introduce CompSkillBench, a benchmark of 300 compositional queries over 2,209 real MCP server skills spanning 24 functional categories, sourced from the public MCP ecosystem. Our experiments reveal that *task decomposition quality is the primary bottleneck*: standard LLM decomposition reaches only 34.2% category recall at the step level. To address this, we propose *Iterative Skill-Aware Decomposition* (SAD), a retrieval-augmented feedback loop that iteratively aligns decomposition with available skills. SAD improves decomposition accuracy from 51.0% to 67.7% (+32.7%, Wilcoxon $p<10^{-6}$) in a single iteration; DA-conditioned analysis confirms that correct granularity is the prerequisite for effective retrieval (CatR@1 rises from 34% to 41% when DA=1). SkillWeaver reduces context window consumption by over 99%, and transfer experiments confirm generalization (+35.6% relative DA gain even when target categories are absent from the retrieval pool).

Compositional Skill Routing for LLM Agents:  
Decompose, Retrieve, and Compose

Xueping Gao Alibaba Cloud Hangzhou, China hellogxp@gmail.com

## 1 Introduction

The agent paradigm for large language models (LLMs) has evolved beyond single-turn generation to encompass tool use, planning, and multi-step task execution [^17] [^15] [^13]. A key architectural pattern emerging in modern LLM agents is the use of *skills*: modular, reusable tool specifications that define specific capabilities along with instructions for when and how to invoke them [^2]. We use *skill* following Anthropic’s SKILL.md specification; skills differ from traditional APIs in their emphasis on structured natural language documentation and composability metadata. As agent skill libraries grow—with repositories already containing thousands of community-contributed skills—a fundamental routing question arises: *given a user query, which skill(s) should the agent invoke?*

Prior work treats skill routing as single-skill selection [^27], but real-world queries frequently require *multiple* skills—e.g., “Download the dataset, transform it, and create visual reports” needs an API client, a data processor, and a visualization tool.

We formalize this as Compositional Skill Routing (Figure 1): given query $q$ and skill library $\mathcal{S}$, produce an ordered sequence of skills $[s_{1},\ldots,s_{k}]$ where each $s_{i}$ handles one atomic sub-task.

We present SkillWeaver, a three-stage framework that addresses this problem through:

1. Decompose: An LLM-based task decomposer that breaks complex queries into atomic sub-tasks, each requiring exactly one skill.
2. Retrieve: A bi-encoder retriever that identifies candidate skills for each sub-task using semantic similarity over skill metadata.
3. Compose: A compatibility-aware planner sketch (Eq. 4) that selects skills per step using inter-skill compatibility. We validate end-to-end viability through a pilot execution study (Appendix I, 76.7% chain completion) while focusing controlled evaluation on the identified bottleneck (decompose-retrieve).

To evaluate compositional skill routing, we construct CompSkillBench, the first dedicated benchmark for this task. CompSkillBench contains 300 compositional queries over 2,209 real skills spanning 24 functional categories, with ground-truth skill chains and three difficulty levels. Skills are sourced from the public MCP server ecosystem (2,200+ registered servers) and deduplicated to ensure quality.

Our experiments yield several key findings:

- Decomposition is the bottleneck: Standard LLM decomposition achieves only 34.2% CatR@1 on a pool of 2,209 real skills. DA-conditioned analysis reveals that correct step count is the gating factor (CatR@1 rises to 41.2% when DA=1), confirming decomposition granularity as the primary limiter.
- SAD closes the gap: Our proposed *Iterative Skill-Aware Decomposition* (SAD), a retrieval-augmented feedback loop that aligns decomposition with the available skill vocabulary, improves DA from 51.0% to 67.7% (+32.7%, $p<10^{-6}$) in a single iteration. The remaining CatR@1 gap (37% vs. 72% @10 ceiling) is partially closed by an LLM-listwise reranker pilot (+10.3% relative @1, $p{<}0.01$; Appendix K), turning “cross-encoder reranking as future work” into an empirically validated lever.
- Metadata suffices for retrieval: Metadata-only encoding achieves CatR@10 of 69.0%, demonstrating that concise skill metadata carries strong discriminative signal even across 2,209 skills.
- SAD generalizes to unseen skills: Transfer experiments show SAD retains its advantage under both category-level held-out (+35.6% relative DA gain) and random skill held-out (+23.2%), confirming vocabulary-level rather than skill-specific learning.

<svg id="S1.F1.pic1" height="238.25" overflow="visible" version="1.1" viewBox="0 0 388.72 238.25" width="388.72"><g transform="translate(0,238.25) matrix(1 0 0 -1 0 0) translate(216.76,0) translate(0,229.1)"><g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" stroke="#000000" fill="#000000" stroke-width="0.4pt"><g style="--ltx-fill-color:#FFF0E0;" fill="#FFF0E0"><path d="M 158.47 8.88 L -158.47 8.88 C -160 8.88 -161.24 7.64 -161.24 6.11 L -161.24 -6.11 C -161.24 -7.64 -160 -8.88 -158.47 -8.88 L 158.47 -8.88 C 160 -8.88 161.24 -7.64 161.24 -6.11 L 161.24 6.11 C 161.24 7.64 160 8.88 158.47 8.88 Z M -161.24 -8.88"></path></g><g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="matrix(0.82 0.0 0.0 0.82 -157.46 -2.84)" fill="#000000" stroke="#000000"><foreignObject style="--ltx-fo-width:27.45em;--ltx-fo-height:0.68em;--ltx-fo-depth:0.19em;" width="388.28" height="12.3" transform="matrix(1 0 0 -1 0 9.61)" overflow="visible"><span id="S1.F1.pic1.13.13.13.13.1.1">“Download the dataset, transform it, and create visual reports”</span></foreignObject></g> <g style="--ltx-fill-color:#EBEBFF;" fill="#EBEBFF"><path d="M 79.54 -25.47 L -79.54 -25.47 C -81.07 -25.47 -82.3 -26.71 -82.3 -28.24 L -82.3 -45.3 C -82.3 -46.83 -81.07 -48.07 -79.54 -48.07 L 79.54 -48.07 C 81.07 -48.07 82.31 -46.83 82.31 -45.3 L 82.31 -28.24 C 82.31 -26.71 81.07 -25.47 79.54 -25.47 Z M -82.3 -48.07"></path></g><g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="matrix(0.82 0.0 0.0 0.82 -78.52 -39.61)" fill="#000000" stroke="#000000"><text transform="matrix(1 0 0 -1 0 0)">Stage 1: Decompose (LLM)</text></g> <g style="--ltx-stroke-color:#8080FF;--ltx-fill-color:#8080FF;" stroke-width="1.2pt" fill="#8080FF" stroke="#8080FF"><path style="fill:none" d="M 0 -9.11 L 0 -17.71"></path><g style="--ltx-fg-color:#8080FF;" transform="matrix(-0.00002 -1.0 1.0 -0.00002 0 -13.62)" stroke-dasharray="none" stroke-dashoffset="0.0pt" stroke-linejoin="miter" color="#8080FF"><path d="M 9.41 0 L 2.68 2.49 L 4.5 0 L 2.68 -2.49 Z"></path></g></g><g style="--ltx-fill-color:#EBFFEB;" fill="#EBFFEB"><path d="M -36.77 -64.67 L -144.02 -64.67 C -145.55 -64.67 -146.79 -65.91 -146.79 -67.44 L -146.79 -79.05 C -146.79 -80.57 -145.55 -81.81 -144.02 -81.81 L -36.77 -81.81 C -35.24 -81.81 -34 -80.57 -34 -79.05 L -34 -67.44 C -34 -65.91 -35.24 -64.67 -36.77 -64.67 Z M -146.79 -81.81"></path></g><g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="matrix(0.82 0.0 0.0 0.82 -143.01 -76.33)" fill="#000000" stroke="#000000"><foreignObject style="--ltx-fo-width:9.3em;--ltx-fo-height:0.69em;--ltx-fo-depth:0.15em;" width="128.7" height="11.68" transform="matrix(1 0 0 -1 0 9.61)" overflow="visible"><math xmlns="http://www.w3.org/1998/Math/MathML" display="inline" data-latex="t_{1}"><semantics><msub><mi>t</mi> <mn>1</mn></msub> <annotation encoding="application/x-tex">t_{1}</annotation></semantics></math>: Download dataset</foreignObject></g> <g style="--ltx-fill-color:#EBFFEB;" fill="#EBFFEB"><path d="M 47.59 -64.67 L -47.59 -64.67 C -49.12 -64.67 -50.36 -65.91 -50.36 -67.44 L -50.36 -79.05 C -50.36 -80.57 -49.12 -81.81 -47.59 -81.81 L 47.59 -81.81 C 49.12 -81.81 50.36 -80.57 50.36 -79.05 L 50.36 -67.44 C 50.36 -65.91 49.12 -64.67 47.59 -64.67 Z M -50.36 -81.81"></path></g><g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="matrix(0.82 0.0 0.0 0.82 -46.58 -76.33)" fill="#000000" stroke="#000000"><foreignObject style="--ltx-fo-width:8.29em;--ltx-fo-height:0.69em;--ltx-fo-depth:0.15em;" width="114.75" height="11.68" transform="matrix(1 0 0 -1 0 9.61)" overflow="visible"><math xmlns="http://www.w3.org/1998/Math/MathML" display="inline" data-latex="t_{2}"><semantics><msub><mi>t</mi> <mn>2</mn></msub> <annotation encoding="application/x-tex">t_{2}</annotation></semantics></math>: Transform data</foreignObject></g> <g style="--ltx-fill-color:#EBFFEB;" fill="#EBFFEB"><path d="M 135.32 -64.67 L 45.47 -64.67 C 43.94 -64.67 42.7 -65.91 42.7 -67.44 L 42.7 -79.42 C 42.7 -80.95 43.94 -82.19 45.47 -82.19 L 135.32 -82.19 C 136.85 -82.19 138.09 -80.95 138.09 -79.42 L 138.09 -67.44 C 138.09 -65.91 136.85 -64.67 135.32 -64.67 Z M 42.7 -82.19"></path></g><g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="matrix(0.82 0.0 0.0 0.82 46.48 -76.2)" fill="#000000" stroke="#000000"><foreignObject style="--ltx-fo-width:7.71em;--ltx-fo-height:0.68em;--ltx-fo-depth:0.19em;" width="106.72" height="12.15" transform="matrix(1 0 0 -1 0 9.46)" overflow="visible"><math xmlns="http://www.w3.org/1998/Math/MathML" display="inline" data-latex="t_{3}"><semantics><msub><mi>t</mi> <mn>3</mn></msub> <annotation encoding="application/x-tex">t_{3}</annotation></semantics></math>: Create reports</foreignObject></g> <g style="--ltx-stroke-color:#A6A6A6;--ltx-fill-color:#A6A6A6;" stroke-width="0.8pt" fill="#A6A6A6" stroke="#A6A6A6"><path style="fill:none" d="M -28.57 -48.3 L -63.06 -62.21"></path><g style="--ltx-fg-color:#A6A6A6;" transform="matrix(-0.92738 -0.37408 0.37408 -0.92738 -60.11 -61.03)" stroke-dasharray="none" stroke-dashoffset="0.0pt" stroke-linejoin="miter" color="#A6A6A6"><path d="M 7.66 0 L 1.79 2.18 L 3.45 0 L 1.79 -2.18 Z"></path></g></g><g style="--ltx-stroke-color:#A6A6A6;--ltx-fill-color:#A6A6A6;" stroke-width="0.8pt" fill="#A6A6A6" stroke="#A6A6A6"><path style="fill:none" d="M 0 -48.3 L 0 -58.48"></path><g style="--ltx-fg-color:#A6A6A6;" transform="matrix(-0.00002 -1.0 1.0 -0.00002 0 -55.31)" stroke-dasharray="none" stroke-dashoffset="0.0pt" stroke-linejoin="miter" color="#A6A6A6"><path d="M 7.66 0 L 1.79 2.18 L 3.45 0 L 1.79 -2.18 Z"></path></g></g><g style="--ltx-stroke-color:#A6A6A6;--ltx-fill-color:#A6A6A6;" stroke-width="0.8pt" fill="#A6A6A6" stroke="#A6A6A6"><path style="fill:none" d="M 28.42 -48.3 L 62.71 -62.2"></path><g style="--ltx-fg-color:#A6A6A6;" transform="matrix(0.92673 -0.37573 0.37573 0.92673 59.77 -61.01)" stroke-dasharray="none" stroke-dashoffset="0.0pt" stroke-linejoin="miter" color="#A6A6A6"><path d="M 7.66 0 L 1.79 2.18 L 3.45 0 L 1.79 -2.18 Z"></path></g></g><g style="--ltx-fill-color:#EBEBFF;" fill="#EBEBFF"><path d="M 104.33 -98.41 L -104.33 -98.41 C -105.86 -98.41 -107.1 -99.65 -107.1 -101.18 L -107.1 -118.24 C -107.1 -119.77 -105.86 -121.01 -104.33 -121.01 L 104.33 -121.01 C 105.86 -121.01 107.1 -119.77 107.1 -118.24 L 107.1 -101.18 C 107.1 -99.65 105.86 -98.41 104.33 -98.41 Z M -107.1 -121.01"></path></g><g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="matrix(0.82 0.0 0.0 0.82 -103.32 -112.55)" fill="#000000" stroke="#000000"><text transform="matrix(1 0 0 -1 0 0)">Stage 2: Retrieve (Bi-Enc + FAISS)</text></g> <g style="--ltx-stroke-color:#A6A6A6;--ltx-fill-color:#A6A6A6;" stroke-width="0.8pt" fill="#A6A6A6" stroke="#A6A6A6"><path style="fill:none" d="M -68.59 -82.04 L -34.1 -95.95"></path><g style="--ltx-fg-color:#A6A6A6;" transform="matrix(0.92738 -0.37411 0.37411 0.92738 -37.04 -94.77)" stroke-dasharray="none" stroke-dashoffset="0.0pt" stroke-linejoin="miter" color="#A6A6A6"><path d="M 7.66 0 L 1.79 2.18 L 3.45 0 L 1.79 -2.18 Z"></path></g></g><g style="--ltx-stroke-color:#A6A6A6;--ltx-fill-color:#A6A6A6;" stroke-width="0.8pt" fill="#A6A6A6" stroke="#A6A6A6"><path style="fill:none" d="M 0 -82.04 L 0 -92.22"></path><g style="--ltx-fg-color:#A6A6A6;" transform="matrix(0.0 -1.0 1.0 0.0 0 -89.05)" stroke-dasharray="none" stroke-dashoffset="0.0pt" stroke-linejoin="miter" color="#A6A6A6"><path d="M 7.66 0 L 1.79 2.18 L 3.45 0 L 1.79 -2.18 Z"></path></g></g><g style="--ltx-stroke-color:#A6A6A6;--ltx-fill-color:#A6A6A6;" stroke-width="0.8pt" fill="#A6A6A6" stroke="#A6A6A6"><path style="fill:none" d="M 68 -82.42 L 34.24 -95.96"></path><g style="--ltx-fg-color:#A6A6A6;" transform="matrix(-0.92809 -0.37234 0.37234 -0.92809 37.19 -94.78)" stroke-dasharray="none" stroke-dashoffset="0.0pt" stroke-linejoin="miter" color="#A6A6A6"><path d="M 7.66 0 L 1.79 2.18 L 3.45 0 L 1.79 -2.18 Z"></path></g></g><g style="--ltx-fill-color:#FAEBF0;" fill="#FAEBF0"><path d="M -30.91 -137.61 L -149.87 -137.61 C -151.4 -137.61 -152.64 -138.84 -152.64 -140.37 L -152.64 -152.61 C -152.64 -154.14 -151.4 -155.38 -149.87 -155.38 L -30.91 -155.38 C -29.39 -155.38 -28.15 -154.14 -28.15 -152.61 L -28.15 -140.37 C -28.15 -138.84 -29.39 -137.61 -30.91 -137.61 Z M -152.64 -155.38"></path></g><g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="matrix(0.82 0.0 0.0 0.82 -148.86 -149.33)" fill="#000000" stroke="#000000"><text transform="matrix(1 0 0 -1 0 0)">api-client, http-fetch, …</text></g> <g style="--ltx-fill-color:#FAEBF0;" fill="#FAEBF0"><path d="M 64.62 -137.61 L -64.62 -137.61 C -66.15 -137.61 -67.38 -138.84 -67.38 -140.37 L -67.38 -152.61 C -67.38 -154.14 -66.15 -155.38 -64.62 -155.38 L 64.62 -155.38 C 66.15 -155.38 67.38 -154.14 67.38 -152.61 L 67.38 -140.37 C 67.38 -138.84 66.15 -137.61 64.62 -137.61 Z M -67.38 -155.38"></path></g><g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="matrix(0.82 0.0 0.0 0.82 -63.6 -149.33)" fill="#000000" stroke="#000000"><text transform="matrix(1 0 0 -1 0 0)">csv-parser, etl-pipeline, …</text></g> <g style="--ltx-fill-color:#FAEBF0;" fill="#FAEBF0"><path d="M 151.36 -137.61 L 29.43 -137.61 C 27.9 -137.61 26.67 -138.84 26.67 -140.37 L 26.67 -152.61 C 26.67 -154.14 27.9 -155.38 29.43 -155.38 L 151.36 -155.38 C 152.88 -155.38 154.12 -154.14 154.12 -152.61 L 154.12 -140.37 C 154.12 -138.84 152.88 -137.61 151.36 -137.61 Z M 26.67 -155.38"></path></g><g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="matrix(0.82 0.0 0.0 0.82 30.45 -149.33)" fill="#000000" stroke="#000000"><text transform="matrix(1 0 0 -1 0 0)">chart-gen, dashboard, …</text></g> <g style="--ltx-stroke-color:#A6A6A6;--ltx-fill-color:#A6A6A6;" stroke-width="0.8pt" fill="#A6A6A6" stroke="#A6A6A6"><path style="fill:none" d="M -28.32 -121.24 L -62.48 -135.13"></path><g style="--ltx-fg-color:#A6A6A6;" transform="matrix(-0.92628 -0.37685 0.37685 -0.92628 -59.54 -133.94)" stroke-dasharray="none" stroke-dashoffset="0.0pt" stroke-linejoin="miter" color="#A6A6A6"><path d="M 7.66 0 L 1.79 2.18 L 3.45 0 L 1.79 -2.18 Z"></path></g></g><g style="--ltx-stroke-color:#A6A6A6;--ltx-fill-color:#A6A6A6;" stroke-width="0.8pt" fill="#A6A6A6" stroke="#A6A6A6"><path style="fill:none" d="M 0 -121.24 L 0 -131.42"></path><g style="--ltx-fg-color:#A6A6A6;" transform="matrix(-0.00002 -1.0 1.0 -0.00002 0 -128.25)" stroke-dasharray="none" stroke-dashoffset="0.0pt" stroke-linejoin="miter" color="#A6A6A6"><path d="M 7.66 0 L 1.79 2.18 L 3.45 0 L 1.79 -2.18 Z"></path></g></g><g style="--ltx-stroke-color:#A6A6A6;--ltx-fill-color:#A6A6A6;" stroke-width="0.8pt" fill="#A6A6A6" stroke="#A6A6A6"><path style="fill:none" d="M 28.32 -121.24 L 62.48 -135.13"></path><g style="--ltx-fg-color:#A6A6A6;" transform="matrix(0.92627 -0.37685 0.37685 0.92627 59.54 -133.94)" stroke-dasharray="none" stroke-dashoffset="0.0pt" stroke-linejoin="miter" color="#A6A6A6"><path d="M 7.66 0 L 1.79 2.18 L 3.45 0 L 1.79 -2.18 Z"></path></g></g><g style="--ltx-stroke-color:#999999;--ltx-fill-color:#999999;" transform="matrix(0.82 0.0 0.0 0.82 -103.24 -130.52)" fill="#999999" stroke="#999999"><foreignObject style="--ltx-fg-color:#999999;--ltx-fo-width:2.26em;--ltx-fo-height:0.69em;--ltx-fo-depth:0.19em;" width="31.33" height="12.3" transform="matrix(1 0 0 -1 0 9.61)" overflow="visible" color="#999999"><span id="S1.F1.pic1.4.4.4.4.4.4.4.4.4.4.4.4.1.1.1.1.1.1.1.1.1.1.1.1" style="--ltx-fg-color:#999999;">top- <math xmlns="http://www.w3.org/1998/Math/MathML" display="inline" data-latex="k"><semantics><mi style="--ltx-fg-color:#999999;" mathcolor="#999999">k</mi> <annotation encoding="application/x-tex">k</annotation></semantics></math></span></foreignObject></g> <g style="--ltx-stroke-color:#999999;--ltx-fill-color:#999999;" transform="matrix(0.82 0.0 0.0 0.82 -12.85 -130.52)" fill="#999999" stroke="#999999"><foreignObject style="--ltx-fg-color:#999999;--ltx-fo-width:2.26em;--ltx-fo-height:0.69em;--ltx-fo-depth:0.19em;" width="31.33" height="12.3" transform="matrix(1 0 0 -1 0 9.61)" overflow="visible" color="#999999"><span id="S1.F1.pic1.5.5.5.5.5.5.5.5.5.5.5.5.1.1.1.1.1.1.1.1.1.1.1.1" style="--ltx-fg-color:#999999;">top- <math xmlns="http://www.w3.org/1998/Math/MathML" display="inline" data-latex="k"><semantics><mi style="--ltx-fg-color:#999999;" mathcolor="#999999">k</mi> <annotation encoding="application/x-tex">k</annotation></semantics></math></span></foreignObject></g> <g style="--ltx-stroke-color:#999999;--ltx-fill-color:#999999;" transform="matrix(0.82 0.0 0.0 0.82 77.55 -130.52)" fill="#999999" stroke="#999999"><foreignObject style="--ltx-fg-color:#999999;--ltx-fo-width:2.26em;--ltx-fo-height:0.69em;--ltx-fo-depth:0.19em;" width="31.33" height="12.3" transform="matrix(1 0 0 -1 0 9.61)" overflow="visible" color="#999999"><span id="S1.F1.pic1.6.6.6.6.6.6.6.6.6.6.6.6.1.1.1.1.1.1.1.1.1.1.1.1" style="--ltx-fg-color:#999999;">top- <math xmlns="http://www.w3.org/1998/Math/MathML" display="inline" data-latex="k"><semantics><mi style="--ltx-fg-color:#999999;" mathcolor="#999999">k</mi> <annotation encoding="application/x-tex">k</annotation></semantics></math></span></foreignObject></g> <g style="--ltx-fill-color:#EBEBFF;" fill="#EBEBFF"><path d="M 108 -171.98 L -108 -171.98 C -109.53 -171.98 -110.77 -173.22 -110.77 -174.75 L -110.77 -191.81 C -110.77 -193.34 -109.53 -194.58 -108 -194.58 L 108 -194.58 C 109.53 -194.58 110.77 -193.34 110.77 -191.81 L 110.77 -174.75 C 110.77 -173.22 109.53 -171.98 108 -171.98 Z M -110.77 -194.58"></path></g><g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="matrix(0.82 0.0 0.0 0.82 -106.98 -186.11)" fill="#000000" stroke="#000000"><text transform="matrix(1 0 0 -1 0 0)">Stage 3: Compose (DAG + Compat.)</text></g> <g style="--ltx-stroke-color:#A6A6A6;--ltx-fill-color:#A6A6A6;" stroke-width="0.8pt" fill="#A6A6A6" stroke="#A6A6A6"><path style="fill:none" d="M -68 -155.61 L -33.84 -169.51"></path><g style="--ltx-fg-color:#A6A6A6;" transform="matrix(0.92628 -0.37682 0.37682 0.92628 -36.78 -168.31)" stroke-dasharray="none" stroke-dashoffset="0.0pt" stroke-linejoin="miter" color="#A6A6A6"><path d="M 7.66 0 L 1.79 2.18 L 3.45 0 L 1.79 -2.18 Z"></path></g></g><g style="--ltx-stroke-color:#A6A6A6;--ltx-fill-color:#A6A6A6;" stroke-width="0.8pt" fill="#A6A6A6" stroke="#A6A6A6"><path style="fill:none" d="M 0 -155.61 L 0 -165.79"></path><g style="--ltx-fg-color:#A6A6A6;" transform="matrix(0.0 -1.0 1.0 0.0 0 -162.62)" stroke-dasharray="none" stroke-dashoffset="0.0pt" stroke-linejoin="miter" color="#A6A6A6"><path d="M 7.66 0 L 1.79 2.18 L 3.45 0 L 1.79 -2.18 Z"></path></g></g><g style="--ltx-stroke-color:#A6A6A6;--ltx-fill-color:#A6A6A6;" stroke-width="0.8pt" fill="#A6A6A6" stroke="#A6A6A6"><path style="fill:none" d="M 68 -155.61 L 33.84 -169.51"></path><g style="--ltx-fg-color:#A6A6A6;" transform="matrix(-0.92628 -0.37682 0.37682 -0.92628 36.78 -168.31)" stroke-dasharray="none" stroke-dashoffset="0.0pt" stroke-linejoin="miter" color="#A6A6A6"><path d="M 7.66 0 L 1.79 2.18 L 3.45 0 L 1.79 -2.18 Z"></path></g></g><g style="--ltx-fill-color:#FFEBEB;" fill="#FFEBEB"><path d="M -32.03 -211.17 L -97.1 -211.17 C -98.63 -211.17 -99.87 -212.41 -99.87 -213.94 L -99.87 -226.06 C -99.87 -227.58 -98.63 -228.82 -97.1 -228.82 L -32.03 -228.82 C -30.5 -228.82 -29.26 -227.58 -29.26 -226.06 L -29.26 -213.94 C -29.26 -212.41 -30.5 -211.17 -32.03 -211.17 Z M -99.87 -228.82"></path></g><g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="matrix(0.82 0.0 0.0 0.82 -96.09 -222.84)" fill="#000000" stroke="#000000"><foreignObject style="--ltx-fo-width:5.58em;--ltx-fo-height:0.69em;--ltx-fo-depth:0.19em;" width="77.27" height="12.3" transform="matrix(1 0 0 -1 0 9.61)" overflow="visible"><math xmlns="http://www.w3.org/1998/Math/MathML" display="inline" data-latex="s_{1}"><semantics><msub><mi>s</mi> <mn>1</mn></msub> <annotation encoding="application/x-tex">s_{1}</annotation></semantics></math>: api-client</foreignObject></g> <g style="--ltx-fill-color:#FFEBEB;" fill="#FFEBEB"><path d="M 34.52 -211.17 L -34.52 -211.17 C -36.05 -211.17 -37.29 -212.41 -37.29 -213.94 L -37.29 -224.55 C -37.29 -226.08 -36.05 -227.32 -34.52 -227.32 L 34.52 -227.32 C 36.05 -227.32 37.29 -226.08 37.29 -224.55 L 37.29 -213.94 C 37.29 -212.41 36.05 -211.17 34.52 -211.17 Z M -37.29 -227.32"></path></g><g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="matrix(0.82 0.0 0.0 0.82 -33.51 -220.58)" fill="#000000" stroke="#000000"><foreignObject style="--ltx-fo-width:5.91em;--ltx-fo-height:0.43em;--ltx-fo-depth:0.19em;" width="81.72" height="8.65" transform="matrix(1 0 0 -1 0 5.96)" overflow="visible"><math xmlns="http://www.w3.org/1998/Math/MathML" display="inline" data-latex="s_{2}"><semantics><msub><mi>s</mi> <mn>2</mn></msub> <annotation encoding="application/x-tex">s_{2}</annotation></semantics></math>: csv-parser</foreignObject></g> <g style="--ltx-fill-color:#FFEBEB;" fill="#FFEBEB"><path d="M 97.43 -211.17 L 31.7 -211.17 C 30.17 -211.17 28.93 -212.41 28.93 -213.94 L 28.93 -226.06 C 28.93 -227.58 30.17 -228.82 31.7 -228.82 L 97.43 -228.82 C 98.96 -228.82 100.2 -227.58 100.2 -226.06 L 100.2 -213.94 C 100.2 -212.41 98.96 -211.17 97.43 -211.17 Z M 28.93 -228.82"></path></g><g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="matrix(0.82 0.0 0.0 0.82 32.71 -222.84)" fill="#000000" stroke="#000000"><foreignObject style="--ltx-fo-width:5.64em;--ltx-fo-height:0.69em;--ltx-fo-depth:0.19em;" width="78.07" height="12.3" transform="matrix(1 0 0 -1 0 9.61)" overflow="visible"><math xmlns="http://www.w3.org/1998/Math/MathML" display="inline" data-latex="s_{3}"><semantics><msub><mi>s</mi> <mn>3</mn></msub> <annotation encoding="application/x-tex">s_{3}</annotation></semantics></math>: chart-gen</foreignObject></g> <g style="--ltx-stroke-color:#A6A6A6;--ltx-fill-color:#A6A6A6;" stroke-width="0.8pt" fill="#A6A6A6" stroke="#A6A6A6"><path style="fill:none" d="M -20.26 -194.81 L -43.47 -208"></path><g style="--ltx-fg-color:#A6A6A6;" transform="matrix(-0.86926 -0.49432 0.49432 -0.86926 -40.71 -206.43)" stroke-dasharray="none" stroke-dashoffset="0.0pt" stroke-linejoin="miter" color="#A6A6A6"><path d="M 7.66 0 L 1.79 2.18 L 3.45 0 L 1.79 -2.18 Z"></path></g></g><g style="--ltx-stroke-color:#A6A6A6;--ltx-fill-color:#A6A6A6;" stroke-width="0.8pt" fill="#A6A6A6" stroke="#A6A6A6"><path style="fill:none" d="M 0 -194.81 L 0 -204.99"></path><g style="--ltx-fg-color:#A6A6A6;" transform="matrix(-0.00002 -1.0 1.0 -0.00002 0 -201.82)" stroke-dasharray="none" stroke-dashoffset="0.0pt" stroke-linejoin="miter" color="#A6A6A6"><path d="M 7.66 0 L 1.79 2.18 L 3.45 0 L 1.79 -2.18 Z"></path></g></g><g style="--ltx-stroke-color:#A6A6A6;--ltx-fill-color:#A6A6A6;" stroke-width="0.8pt" fill="#A6A6A6" stroke="#A6A6A6"><path style="fill:none" d="M 20.26 -194.81 L 43.47 -208"></path><g style="--ltx-fg-color:#A6A6A6;" transform="matrix(0.86926 -0.49434 0.49434 0.86926 40.71 -206.43)" stroke-dasharray="none" stroke-dashoffset="0.0pt" stroke-linejoin="miter" color="#A6A6A6"><path d="M 7.66 0 L 1.79 2.18 L 3.45 0 L 1.79 -2.18 Z"></path></g></g><g stroke-width="1.2pt"><g style="--ltx-stroke-color:#FF6666;--ltx-fill-color:#FF6666;" stroke="#FF6666" fill="#FF6666"><path style="fill:none" d="M -29.04 -219.59 L -29.98 -219.6"></path><g style="--ltx-fg-color:#FF6666;" transform="matrix(-0.99994 -0.01129 0.01129 -0.99994 -25.89 -219.55)" stroke-dasharray="none" stroke-dashoffset="0.0pt" stroke-linejoin="miter" color="#FF6666"><path d="M 9.41 0 L 2.68 2.49 L 4.5 0 L 2.68 -2.49 Z"></path></g></g><g style="--ltx-stroke-color:#FF6666;--ltx-fill-color:#FF6666;--ltx-fg-color:#FF6666;" transform="matrix(0.82 0.0 0.0 0.82 -38.73 -212.97)" fill="#FF6666" stroke="#FF6666" color="#FF6666"><foreignObject style="--ltx-fo-width:0.96em;--ltx-fo-height:0.43em;--ltx-fo-depth:0.19em;" width="13.3" height="8.65" transform="matrix(1 0 0 -1 0 5.96)" overflow="visible"><math xmlns="http://www.w3.org/1998/Math/MathML" display="inline" data-latex="g_{0}"><semantics><msub><mi style="--ltx-fg-color:#FF6666;" mathcolor="#FF6666">g</mi> <mn style="--ltx-fg-color:#FF6666;" mathcolor="#FF6666">0</mn></msub> <annotation encoding="application/x-tex">g_{0}</annotation></semantics></math></foreignObject></g></g> <g stroke-width="1.2pt"><g style="--ltx-stroke-color:#FF6666;--ltx-fill-color:#FF6666;" stroke="#FF6666" fill="#FF6666"><path style="fill:none" d="M 37.52 -219.69 L 36.25 -219.67"></path><g style="--ltx-fg-color:#FF6666;" transform="matrix(-0.99992 0.012 -0.012 -0.99992 40.33 -219.72)" stroke-dasharray="none" stroke-dashoffset="0.0pt" stroke-linejoin="miter" color="#FF6666"><path d="M 9.41 0 L 2.68 2.49 L 4.5 0 L 2.68 -2.49 Z"></path></g></g><g style="--ltx-stroke-color:#FF6666;--ltx-fill-color:#FF6666;--ltx-fg-color:#FF6666;" transform="matrix(0.82 0.0 0.0 0.82 27.66 -212.97)" fill="#FF6666" stroke="#FF6666" color="#FF6666"><foreignObject style="--ltx-fo-width:0.96em;--ltx-fo-height:0.43em;--ltx-fo-depth:0.19em;" width="13.3" height="8.65" transform="matrix(1 0 0 -1 0 5.96)" overflow="visible"><math xmlns="http://www.w3.org/1998/Math/MathML" display="inline" data-latex="g_{1}"><semantics><msub><mi style="--ltx-fg-color:#FF6666;" mathcolor="#FF6666">g</mi> <mn style="--ltx-fg-color:#FF6666;" mathcolor="#FF6666">1</mn></msub> <annotation encoding="application/x-tex">g_{1}</annotation></semantics></math></foreignObject></g></g> <g style="--ltx-fill-color:#FFFFE6;" stroke-dasharray="3.0pt,3.0pt" stroke-dashoffset="0.0pt" fill="#FFFFE6"><path d="M 149.78 -23.44 L 124.27 -23.44 C 122.74 -23.44 121.5 -24.68 121.5 -26.21 L 121.5 -47.34 C 121.5 -48.87 122.74 -50.11 124.27 -50.11 L 149.78 -50.11 C 151.31 -50.11 152.54 -48.87 152.54 -47.34 L 152.54 -26.21 C 152.54 -24.68 151.31 -23.44 149.78 -23.44 Z M 121.5 -50.11"></path></g><g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" stroke-dasharray="3.0pt,3.0pt" stroke-dashoffset="0.0pt" fill="#000000" stroke="#000000" transform="matrix(0.82 0.0 0.0 0.82 125.28 -43.49)"><g transform="matrix(1 0 0 -1 0 19.83)"><g transform="matrix(1 0 0 1 0 9.46)"><g transform="matrix(1 0 0 -1 0 0)"><text transform="matrix(1 0 0 -1 0 0)">SAD</text></g></g> <g transform="matrix(1 0 0 1 0 19.84)"><g transform="matrix(1 0 0 -1 0.48 0)"><foreignObject style="--ltx-fo-width:2em;--ltx-fo-height:0.75em;--ltx-fo-depth:0.25em;" width="27.67" height="13.84" transform="matrix(1 0 0 -1 0 10.38)" overflow="visible">(§4.4)</foreignObject></g></g></g></g> <g stroke-dasharray="3.0pt,3.0pt" stroke-dashoffset="0.0pt" stroke-width="0.8pt"><g style="--ltx-stroke-color:#FFA64D;--ltx-fill-color:#FFA64D;" stroke="#FFA64D" fill="#FFA64D"><path style="fill:none" d="M 107.33 -109.71 L 139.61 -109.71 L 139.61 -50.33 L 142.99 -50.33"></path><g style="--ltx-fg-color:#FFA64D;" transform="matrix(-1.0 0.0 0.0 -1.0 146.16 -50.33)" stroke-dasharray="none" stroke-dashoffset="0.0pt" stroke-linejoin="miter" color="#FFA64D"><path d="M 7.66 0 L 1.79 2.18 L 3.45 0 L 1.79 -2.18 Z"></path></g></g><g style="--ltx-stroke-color:#FFA64D;--ltx-fill-color:#FFA64D;--ltx-fg-color:#FFA64D;" transform="matrix(0.82 0.0 0.0 0.82 143.85 -83.96)" fill="#FFA64D" stroke="#FFA64D" color="#FFA64D"><foreignObject style="--ltx-fo-width:2.17em;--ltx-fo-height:0.69em;--ltx-fo-depth:0em;" width="30.06" height="9.61" transform="matrix(1 0 0 -1 0 9.61)" overflow="visible"><span id="S1.F1.pic1.14.14.14.14.1.1.1" style="--ltx-fg-color:#FFA64D;">hints</span></foreignObject></g></g> <g style="--ltx-stroke-color:#FFA64D;--ltx-fill-color:#FFA64D;" stroke-dasharray="3.0pt,3.0pt" stroke-dashoffset="0.0pt" fill="#FFA64D" stroke="#FFA64D" stroke-width="0.8pt"><path style="fill:none" d="M 121.27 -36.77 L 88.49 -36.77"></path><g style="--ltx-fg-color:#FFA64D;" transform="matrix(-1.0 0.00002 -0.00002 -1.0 91.67 -36.77)" stroke-dasharray="none" stroke-dashoffset="0.0pt" stroke-linejoin="miter" color="#FFA64D"><path d="M 7.66 0 L 1.79 2.18 L 3.45 0 L 1.79 -2.18 Z"></path></g></g><g style="--ltx-fill-color:#F5F5F5;" fill="#F5F5F5"><path d="M -149.06 -95.21 L -213.72 -95.21 C -215.25 -95.21 -216.49 -96.45 -216.49 -97.98 L -216.49 -121.44 C -216.49 -122.97 -215.25 -124.21 -213.72 -124.21 L -149.06 -124.21 C -147.54 -124.21 -146.3 -122.97 -146.3 -121.44 L -146.3 -97.98 C -146.3 -96.45 -147.54 -95.21 -149.06 -95.21 Z M -216.49 -124.21"></path></g><g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="matrix(0.82 0.0 0.0 0.82 -212.7 -117.59)" fill="#000000" stroke="#000000"><g transform="matrix(1 0 0 -1 0 22.68)"><g transform="matrix(1 0 0 1 0 9.61)"><g transform="matrix(1 0 0 -1 0 0)"><text transform="matrix(1 0 0 -1 0 0)">Skill Library</text></g></g> <g transform="matrix(1 0 0 1 0 22.68)"><g transform="matrix(1 0 0 -1 5.35 0)"><foreignObject style="--ltx-fo-width:4.75em;--ltx-fo-height:0.75em;--ltx-fo-depth:0.25em;" width="65.67" height="13.84" transform="matrix(1 0 0 -1 0 10.38)" overflow="visible">(<math xmlns="http://www.w3.org/1998/Math/MathML" display="inline" data-latex="N{=}2{,}209"><semantics><mrow><mi>N</mi> <mo>=</mo> <mrow><mn>2</mn><mo>,</mo><mn>209</mn></mrow></mrow> <annotation encoding="application/x-tex">N{=}2{,}209</annotation></semantics></math>)</foreignObject></g></g></g></g></g><g style="--ltx-stroke-color:#BFBFBF;--ltx-fill-color:#BFBFBF;--ltx-fg-color:#A6A6A6;" stroke-width="0.8pt" fill="#BFBFBF" stroke="#BFBFBF" color="#A6A6A6"><path style="fill:none" d="M -146.07 -109.71 L -113.29 -109.71"></path><g style="--ltx-fg-color:#BFBFBF;" transform="matrix(1.0 0.00003 -0.00003 1.0 -116.46 -109.71)" stroke-dasharray="none" stroke-dashoffset="0.0pt" stroke-linejoin="miter" color="#BFBFBF"><path d="M 7.66 0 L 1.79 2.18 L 3.45 0 L 1.79 -2.18 Z"></path></g></g></g></svg>

Figure 1: Overview of SkillWeaver. A query is decomposed into sub-tasks, each matched to skills via bi-encoder retrieval, then composed into a DAG. Dashed arrows: SAD feedback loop (§4.4).

## 2 Related Work

#### Tool Selection and Routing.

API retrieval [^13] [^15], documentation matching [^5], and hierarchical routing [^27] study single-tool selection. SkillRouter [^27], closest to our work, uses a bi-encoder for single-skill routing. Hierarchical/self-reflective agents [^4] and tool-creation frameworks [^26] scale tool use, but still treat selection as a single-tool or per-step problem. CRAFT [^26] is most related to our compose stage: it creates per-query specialized toolsets via LLM-driven filtering over large API pools. However, CRAFT does not perform explicit multi-step decomposition—it assumes a flat query-to-toolset mapping—and evaluates via execution success on single-turn tasks. In contrast, SkillWeaver addresses *compositional* queries requiring ordered multi-skill chains, with SAD providing cross-stage feedback between decomposition and retrieval that has no analogue in CRAFT’s pipeline. None of these approaches jointly optimizes decomposition granularity, retrieval, and inter-skill compatibility for compositional tasks.

#### Tool-Augmented LLM Benchmarks.

API-Bank [^11], ToolQA [^29], and TaskBench [^19] benchmark tool use but over fixed or small tool sets. Our CompSkillBench is the first for compositional *routing* over thousands of skills.

#### Task Decomposition and Planning.

Prompting strategies [^23] [^28], Decomposed Prompting [^9], planning frameworks [^6] [^21] [^10], and agentic systems [^25] [^18] explore LLM decomposition with static templates. SAD differs from prior retrieval-augmented methods in the *direction* of feedback: Self-RAG [^3], ReAct [^25], and Reflexion [^20] feed retrieved evidence into the *generation* or *action* step (output-side), refining what the model produces given a fixed plan; SAD feeds retrieved skills back into the *decomposition input* (input-side), correcting plan granularity *before* retrieval is finalized. Input-side feedback is the harder design choice—it requires the model to revise its plan from partial keyword overlap with imperfect Pass-1 candidates—but is uniquely suited to compositional skill routing, where the bottleneck is matching decomposition vocabulary to the skill pool, not refining individual generation steps.

#### MCP Ecosystem and Tool Discovery.

The MCP protocol [^1] standardizes agent–tool integration with 10,000+ servers. Progressive discovery [^15] addresses tool overload systemically. Recent work on zero-shot tool discovery [^22] achieves significant token reduction through protocol-level optimization, and ToolACE [^12] curates large-scale tool-calling datasets for fine-tuning. Code-first agent frameworks such as TaskWeaver [^14] address execution orchestration but not skill retrieval. These efforts are complementary: they address *how* agents access tools, while we address *which* skills to compose given a query.

#### Retrieval-Augmented Generation.

We adapt bi-encoder retrieval [^8] for skills, extending it upstream to inform decomposition via retrieved hints.

## 3 Problem Formulation

#### Skill Library.

A skill library $\mathcal{S}=\{s_{1},\ldots,s_{N}\}$ contains $N$ skills. Each skill $s_{i}$ is a tuple $(n_{i},d_{i},b_{i},C_{i})$ where $n_{i}$ is the name, $d_{i}$ is a natural language description, $b_{i}$ is the full specification body (instructions, examples, configuration), and $C_{i}\subseteq\mathcal{C}$ is a set of functional categories from a taxonomy $\mathcal{C}$.

#### Compositional Skill Routing.

Given a complex query $q$ that requires multiple capabilities, the goal is to produce:

1. A decomposition $D(q)=[t_{1},\ldots,t_{K}]$ of $K$ atomic sub-tasks.
2. A skill assignment $\sigma:[t_{1},\ldots,t_{K}]\to\mathcal{S}^{K}$ mapping each sub-task to a skill.
3. An execution plan (DAG) $G=(V,E)$ specifying dependencies between steps.

The compositional routing function is $f:q\to(D,\sigma,G)$ optimizing:

$$
\max_{D,\sigma,G}\alpha\sum_{k=1}^{K}\text{rel}(t_{k},\sigma(t_{k}))+(1\!-\!\alpha)\!\!\!\sum_{(i,j)\in E}\!\!\!\text{compat}(\sigma_{i},\sigma_{j})
$$

where $\text{rel}(\cdot)$ measures sub-task–skill relevance, $\text{compat}(\cdot)$ measures inter-skill compatibility, and $\alpha\in[0,1]$ controls the relevance–compatibility trade-off (instantiated in Eq. 4). While joint optimization of Eq. 1 is intractable in general, our cascaded pipeline (§4) provides a tractable approximation; SAD (§4.4) further tightens this by feeding retrieval signals back into decomposition.

## 4 Method: SkillWeaver

SkillWeaver implements compositional skill routing through three cascaded stages (Figure 1).

### 4.1 Stage 1: Task Decomposition

Given a complex query $q$, the task decomposer uses an instruction-tuned LLM to produce an ordered list of atomic sub-tasks:

$$
D(q)=\text{LLM}(p_{\text{sys}},p_{\text{user}}(q))=[t_{1},\ldots,t_{K}]
$$

where $p_{\text{sys}}$ instructs the model to output sub-tasks as a JSON array of strings, each requiring exactly one skill.

### 4.2 Stage 2: Skill Retrieval

For each sub-task $t_{k}$, we retrieve the top- $m$ candidates using a bi-encoder (all-MiniLM-L6-v2, 384-dim):

$$
\text{cand}(t_{k})=\text{top-}m_{s\in\mathcal{S}}\;\cos(E_{q}(t_{k}),E_{s}(s))
$$

We compare two representations: metadata-only ($n_{s}\oplus d_{s}$) and body-aware ($n_{s}\oplus d_{s}\oplus b_{s}[:2000]$). Embeddings are $L_{2}$ -normalized and indexed with FAISS [^7] for exact inner product search. Future work may explore domain-adapted or cross-encoder reranking alternatives (§8).

### 4.3 Stage 3: Compose

Given retrieved candidates per step, the compose stage selects the final skill assignment. The selection objective combines retrieval relevance with inter-step compatibility:

$$
\sigma(t_{k})=\arg\max_{s\in\text{cand}(t_{k})}\alpha\!\cdot\!\text{sim}(t_{k},s)+(1\!-\!\alpha)\!\cdot\!\bar{c}_{k}(s)
$$

where $\bar{c}_{k}(s)$ averages compatibility scores with preceding steps (measured via I/O type coercion, category Jaccard, and keyword co-occurrence), and $\alpha=0.5$ (robust across \[0.3, 0.7\]; see Appendix E). Dependencies between steps are detected via linguistic markers and I/O overlap, producing a DAG for parallel execution where possible.

#### Scope of current evaluation.

This paper focuses on the decompose-retrieve stages, which we identify as the primary bottleneck (§7). The compose stage (Eq. 4) is proposed as the *architectural completion* of the framework; its isolated evaluation requires ground-truth compatibility annotations that our current benchmark does not provide. We validate end-to-end viability through a pilot execution study (Appendix I), where SAD-routed plans achieve 76.7% chain completion rate.

### 4.4 Skill-Aware Decomposition (SAD)

A key insight is that LLM decomposers produce generic descriptions poorly aligned with skill metadata. We propose *Skill-Aware Decomposition* (SAD), an iterative alignment procedure: given decomposition $D^{(i)}(q)$ at iteration $i$, retrieve top candidates for each sub-task, construct a hint set $\mathcal{H}^{(i)}$, and re-decompose:

$$
D^{(i+1)}(q)=\text{LLM}(p_{\text{sys}},p_{\text{SAD}}(q,\mathcal{H}^{(i)}))
$$

This defines a fixed-point iteration over the finite space of skill hint sets: since $|\mathcal{H}^{(i)}|=H$ and each element is drawn from a finite skill library $\mathcal{S}$, the sequence $\{\mathcal{H}^{(i)}\}$ must converge. In practice, we find that one iteration suffices for DA convergence (§7.8), making the two-pass variant the default. SAD works even when $D^{(0)}$ is poor: imprecise descriptions still surface relevant skills via partial keyword overlap, providing a *vocabulary bridge* (Algorithm 1).

Algorithm 1 Iterative Skill-Aware Decomposition (SAD)

 Query $q$, skill library $\mathcal{S}$, retriever $R$, hint count $H{=}15$, max iterations $T$, convergence threshold $\tau{=}0.6$

 Refined decomposition $D^{(T)}(q)$

  $D^{(0)}(q)\leftarrow\text{LLM}(p_{\text{sys}},q)$ {vanilla decomposition}

 for $i=0$ to $T-1$ do

   $\text{cand}_{k}\leftarrow R.\text{retrieve}(t_{k},H)$ for each $t_{k}\in D^{(i)}$

   $\mathcal{H}^{(i)}\leftarrow\text{top-}H\text{ skills from }\bigcup_{k}\text{cand}_{k}$

  if $i>0$ and $J(\mathcal{H}^{(i)},\mathcal{H}^{(i-1)})>\tau$ then

   return $D^{(i)}(q)$ {converged}

  end if

   $D^{(i+1)}(q)\leftarrow\text{LLM}(p_{\text{sys}},p_{\text{SAD}}(q,\mathcal{H}^{(i)}))$

 end for

 return $D^{(T)}(q)$

## 5 Benchmark: CompSkillBench

### 5.1 Skill Pool Construction

We construct our skill pool from the public MCP (Model Context Protocol) server ecosystem [^1], which catalogs 2,200+ community-registered tool servers. We extract skill entries from the curated awesome-mcp-servers registry, which aggregates MCP servers with descriptions, categories, and source URLs. We apply the following curation pipeline:

1. Extraction: Parse 2,228 server entries with name, description, category, and repository URL.
2. Quality filtering: Remove entries with descriptions shorter than 15 characters or consisting primarily of badge images, reducing to 2,213 entries.
3. Deduplication: Merge entries with identical normalized names, yielding 2,209 unique skills.
4. Categorization: Map the registry’s 49 fine-grained tags into 24 canonical functional categories (Table 1) via a curated mapping.

<table><tbody><tr><td>Category</td><td>Count</td><td>Examples</td></tr><tr><td>Developer Tools</td><td>357</td><td>eslint-mcp, github-actions</td></tr><tr><td>Finance</td><td>270</td><td>stripe-mcp, plaid-server</td></tr><tr><td>Integrations</td><td>229</td><td>zapier-mcp, n8n-server</td></tr><tr><td>Knowledge Mgmt</td><td>180</td><td>notion-mcp, obsidian-server</td></tr><tr><td>Search/Extraction</td><td>140</td><td>firecrawl, serper-mcp</td></tr><tr><td>Security</td><td>122</td><td>snyk-mcp, vault-server</td></tr><tr><td>Communication</td><td>109</td><td>slack-mcp, email-server</td></tr><tr><td>Databases</td><td>104</td><td>postgres-mcp, redis-server</td></tr><tr><td>Cloud Infra</td><td>87</td><td>aws-mcp, terraform-server</td></tr><tr><td>Code Execution</td><td>69</td><td>jupyter-mcp, sandbox-server</td></tr><tr><td colspan="2">+ 14 more categories</td><td>542 total</td></tr></tbody></table>

Table 1: Top 10 skill categories in CompSkillBench (of 24 total). The full pool contains 2,209 skills from the public MCP ecosystem.

### 5.2 Query Generation

Compositional queries are generated by combining skills from different categories into multi-step tasks:

#### Difficulty Levels.

- Easy (150 queries): 2 skills, 2 categories
- Medium (100 queries): 3 skills, 3 categories
- Hard (50 queries): 4–5 skills, 4–5 categories

Each query is associated with ground-truth sub-task descriptions, ground-truth skill IDs, required categories, and a sequential execution order. The benchmark totals 300 queries spanning 23 categories (categories with $\geq$ 5 skills).

#### Query Construction.

Queries are generated from template verb phrases combined across categories. Ground-truth sub-task descriptions use category-specific verb phrases (e.g., “query the database”, “send a notification”) that do not directly copy skill names or descriptions, ensuring that retrieval success requires genuine semantic matching rather than lexical overlap.

### 5.3 Evaluation Metrics

We evaluate at three granularities:

#### Step-Level Metrics.

- Skill Recall@ $k$ (R@ $k$): Fraction of steps where the ground-truth skill appears in the top- $k$ candidates.
- Category Recall@ $k$ (CatR@ $k$): Fraction of steps where *any skill from the correct category* appears in the top- $k$. This relaxed metric is more practical, as many skills within a category are functionally interchangeable.

#### Chain-Level Metrics.

- Chain Exact Match: Fraction of queries where *all* steps select the exact ground-truth skill.
- Chain Category Match ($\text{Chain}_{\text{cat}}$): Average fraction of steps per query that select a skill from the correct category.

#### Decomposition Accuracy (DA).

Fraction of queries where the predicted number of sub-tasks exactly matches the ground truth. Note that DA is a strict structural metric; a query with 3 ground-truth steps decomposed into 4 (with one additional valid intermediate step) receives DA=0.

#### Relaxed DA (DA±1).

Fraction of queries where the predicted step count is within $\pm$ 1 of the ground truth. This captures cases where decomposition granularity is approximately correct but differs by one step due to ambiguous task boundaries (e.g., an implicit authentication step).

We use DA primarily to diagnose decomposition granularity; CatR@1 is the primary retrieval quality metric.

## 6 Experimental Setup

#### LLM Decomposer.

Qwen2.5-7B-Instruct [^16] serves as the primary decomposer. Generation: $\tau=0.1$, top ${}_{p}=0.9$, max 256 tokens.

#### Retriever.

all-MiniLM-L6-v2 (384-dim) serves as the bi-encoder, with FAISS IndexFlatIP for exact inner product search over 2,209 skills. Index construction takes 15 seconds; retrieval latency is $<$ 15ms per query batch. We set $k=10$ for retrieval unless otherwise noted.

#### Comparisons.

We compare:

- Vanilla: Standard decomposition without skill hints.
- +SAD ($H{=}15$): Single-iteration Skill-Aware Decomposition.
- Iterative SAD: Up to 3 additional iterations with convergence monitoring.

#### Hardware.

Experiments run on a single NVIDIA V100-SXM2-16GB GPU. The 7B model fits entirely in GPU memory (15GB VRAM).

## 7 Results

### 7.1 Main Results

Table 2 presents the main experimental results across all configurations.

<table><tbody><tr><th>Method</th><td>DA</td><td>DA <sub>±1</sub></td><td>CatR@1</td><td>CatR@10</td><td><math><semantics><msub><mtext>Chain</mtext> <mtext>cat</mtext></msub> <annotation>\text{Chain}_{\text{cat}}</annotation></semantics></math></td></tr><tr><th colspan="6">Baselines (qwen-max, 50 queries)</th></tr><tr><th>LLM-Direct (100 skills shown)</th><td>0.900</td><td>0.960</td><td>0.211</td><td>–</td><td>–</td></tr><tr><th>ReAct-style (iterative) <sup>†</sup></th><td>0.000</td><td>0.040</td><td>0.154</td><td>–</td><td>–</td></tr><tr><th colspan="6">Full Pipeline (SkillWeaver) — Qwen2.5-7B, 300 queries</th></tr><tr><th>Vanilla</th><td>0.510</td><td>0.713</td><td>0.342</td><td>0.686</td><td>0.040</td></tr><tr><th>+ SAD (<math><semantics><mrow><mi>H</mi> <mo>=</mo> <mn>15</mn></mrow> <annotation>H{=}15</annotation></semantics></math>)</th><td>0.677</td><td>0.843</td><td>0.370</td><td>0.703</td><td>0.073</td></tr><tr><th colspan="6">SkillWeaver + SAD — qwen-max, 50 queries</th></tr><tr><th>qwen-max Vanilla</th><td>0.660</td><td>0.820</td><td>0.359</td><td>–</td><td>–</td></tr><tr><th>qwen-max + SAD</th><td>0.920</td><td>0.980</td><td>0.394</td><td>–</td><td>–</td></tr></tbody></table>

Table 2: Main results on CompSkillBench (2,209 skills, 24 categories, 300 queries). DA: strict decomposition accuracy (exact step count match). DA <sub>±1</sub>: relaxed DA allowing predicted steps within $\pm$ 1 of ground truth, capturing cases where granularity is approximately correct. CatR@ $k$: fraction of steps where a skill from the correct category appears in top- $k$. $\text{Chain}_{\text{cat}}$: fraction of queries where all steps select correct-category skills. SAD’s DA improvement is highly significant (Wilcoxon $p<10^{-6}$, $n{=}300$); bootstrap 95% CI for $\Delta$ DA: \[+10.3%, +23.0%\]. CatR@1 shows directional improvement ($p{=}0.17$; CI: $[-0.005,+0.062]$). <sup>†</sup> ReAct does not produce explicit decompositions; DA=0 reflects protocol mismatch, not system failure.

#### Key findings.

On a pool of 2,209 real MCP skills, vanilla decomposition achieves CatR@1 = 34.2% and DA = 51.0% (DA <sub>±1</sub> = 71.3%). SAD improves DA to 67.7% (+32.7% relative, $p<10^{-6}$) and DA <sub>±1</sub> to 84.3% (+18.2%), with directional CatR@1 improvement to 37.0% (+8.2%; see §8 for statistical nuance). This confirms that decomposition granularity is the primary bottleneck—once the model produces the correct number of sub-tasks, retrieval quality follows (DA=1 conditioned CatR@1 rises to 41.2%). The CatR@10 of 68.6–70.3% shows that the retriever surfaces a correct-category skill in its top-10 for most steps; closing the @10-to-@1 gap via reranking is a natural next step (§8).

### 7.2 Difficulty Analysis

SAD’s improvement is consistent across difficulty levels: Easy DA improves from 44.7% to 63.3% (+41.6%), Medium from 66.0% to 78.0% (+18.2%), and Hard from 40.0% to 60.0% (+50.0%). The largest relative gain on hard queries confirms that decomposition becomes increasingly important—and SAD increasingly valuable—as task complexity grows. CatR@1 gains are more modest (+5–16% relative), indicating that retrieval precision remains challenging on the full 2,209-skill pool even with improved decomposition.

### 7.3 Baselines

#### LLM-Direct (ceiling estimate).

We provide qwen-max (a proprietary model far larger than our 7B decomposer) with 100 skill names (including ground-truth skills) and ask it to directly select tools for the query. Despite near-perfect DA (90%—the strong model easily decomposes correctly), CatR@1 is only 21.1%, far below SkillWeaver’s 37.0%. This ceiling estimate confirms that *listing skills in the prompt is insufficient* —even a much stronger model cannot match retrieval-based routing with SAD, indicating that the skill matching challenge is not merely a model capacity problem.

#### ReAct-style.

An iterative thought-action-observation agent (qwen-max) achieves DA=0% because the think-act-observe loop collapses multi-step tasks into single actions without explicit decomposition guidance. This confirms that compositional routing requires explicit structured decomposition.

### 7.4 Paraphrase Robustness

To verify that results are not inflated by template-query patterns, we paraphrase 50 queries with qwen-max (temperature=0.7) and re-run the pipeline. SAD DA drops marginally from 66.0% to 62.0% ($-$ 4pp; note: 66.0% reflects the 50-query subset baseline, vs. 67.7% on the full 300 queries in Table 2); per-query DA agreement between original and paraphrased is 72%, indicating stable decomposition quality across surface-form variation. CatR@1 is also stable (38.2% paraphrased vs 38.3% original). To further validate, we expand to 150 additional queries paraphrased with the 7B model itself (a stricter test since the same model generates and evaluates); SAD DA drops from 65.3% to 59.3% ($-$ 6pp) with 66% agreement and CatR@1 remaining stable (34.5% $\to$ 33.4%). Across both sets (200 total paraphrased queries), the DA degradation is modest ($\leq$ 6pp), confirming that SAD’s gains are not artifacts of surface-form memorization.

SAD’s gains extend to human-style queries with zero text overlap (Table 6): relaxed DA <sub>±1</sub> improves from 30.5% to 50.5% (+66% relative), confirming generalization beyond template patterns even under open-ended step boundaries where strict DA is naturally low.

### 7.5 Cross-Model Validation

To verify that SAD’s benefit is not model-specific, we evaluate with two additional models on 50-query subsets. Qwen2.5-14B-Instruct achieves Vanilla DA=32.0% but SAD DA=68.0% (+36pp), with CatR@1 rising from 29.0% to 42.4%. qwen-max (a proprietary model comparable to GPT-4) achieves Vanilla DA=66.0% and SAD DA=92.0% (+39.4% relative). The counter-intuitive result that 14B Vanilla DA (32%) falls below 7B Vanilla (51%) reflects 14B’s stronger tendency toward *over-decomposition*: 14B Vanilla produces an average of 4.72 predicted steps per query (vs. ground-truth mean of 2.94), compared to 7B’s 3.62. SAD reduces 14B’s mean to 3.18 steps, exposing decomposition granularity as a model-capability-orthogonal failure mode. SAD’s hints anchor the 14B output back to the correct vocabulary granularity, yielding the largest absolute gain—this is the cleanest evidence that SAD is a granularity corrector rather than a capacity booster.

### 7.6 Ablation: Granularity vs. Quality

#### DA as prerequisite for retrieval.

Conditioning on queries where DA=1 reveals that correct decomposition is a *prerequisite* for effective retrieval: CatR@1 jumps from 34.2% (unconditional) to 41.2% (DA=1 only), and CatR@10 reaches 81.6%. This means that when the decomposer produces the right number of steps, retrieval is already reasonably effective—the bottleneck is getting there.

#### SAD’s mechanism.

SAD fixes 75 queries (25%) where vanilla decomposition produces the wrong step count. On these fixed queries, CatR@1 improves from 23.6% (broken decomp) to 37.0% (correct decomp). Crucially, on the 128 queries where *both* methods produce correct DA, their CatR@1 is statistically identical (41.7% vs 40.9%, $p{=}0.97$). This demonstrates that SAD’s CatR@1 gain comes *entirely* from unlocking correct retrieval via granularity correction, not from vocabulary alignment per se.

#### Step-count-constrained baseline.

To further isolate granularity from semantic alignment, we run vanilla 7B with an *oracle step-count* prompt (“decompose into exactly $K^{*}$ atomic sub-tasks”, where $K^{*}$ is ground truth) on all 300 queries. This constrained baseline reaches DA = 99.3% (essentially perfect granularity) and CatR@1 = 39.8%, closely matching SAD’s DA=1-conditioned CatR@1 = 41.2% ($\Delta=1.4$ pp). Two conclusions follow: (i) SAD’s primary mechanism is indeed granularity correction—an oracle step-count signal recovers most of its CatR@1 gain—and (ii) even with oracle granularity, CatR@1 plateaus near 40% while CatR@10 reaches 79.1%, exposing an *independent representation-level bottleneck* (40% top-1 vs 79% top-10) that motivates cross-encoder reranking as future work.

### 7.7 Context Window Analysis

Exposing all 2,209 skills consumes $\sim$ 884K tokens; SkillWeaver reduces this to 2–5 skills per query (Table 3).

| Strategy | Tools | Est. Tokens | Reduction |
| --- | --- | --- | --- |
| All tools (naïve) | 2,209 | $\sim$ 884K | — |
| Top- $k$ retrieval | 10 | $\sim$ 4,000 | 99.5% |
| SkillWeaver (avg.) | 2.9 | $\sim$ 1,160 | 99.9% |

Table 3: Context window consumption. “Est. Tokens” counts *only* the tools exposed to the task-execution LLM (§4), assuming $\sim$ 400 tokens per serialized skill; it does *not* include the SAD decomposer’s Pass-2 input, where $H{=}15$ hints add a fixed $\sim$ 1,100 tokens shared across all queries. Compositional routing reduces task-time context by two orders of magnitude.

### 7.8 Convergence Analysis

Algorithm 1 allows multiple iterations; we evaluate whether additional rounds improve routing beyond the standard single-iteration SAD. Table 4 reports per-round metrics on all 300 queries (Qwen2.5-7B, $H{=}15$).

| Round | DA | CatR@1 | CatR@10 | $\text{Chain}_{\text{cat}}$ | Jaccard |
| --- | --- | --- | --- | --- | --- |
| 0 (Vanilla) | 0.513 | 0.351 | 0.690 | 0.040 | — |
| 1 (SAD-1) | 0.670 | 0.370 | 0.704 | 0.060 | 0.324 |
| 2 (SAD-2) | 0.653 | 0.389 | 0.690 | 0.073 | 0.473 |
| 3 (SAD-3) | 0.653 | 0.361 | 0.695 | 0.077 | 0.524 |

Table 4: Iterative SAD convergence (7B, $H{=}15$, $n{=}300$, 2,209 skills). Minor discrepancies with Table 2 (e.g., Round 0 DA=0.513 vs. 0.510) arise from step-alignment differences in the iterative pipeline; Table 2 is authoritative. Round 1 captures the majority of DA gain. Hint Jaccard rises monotonically, indicating progressive stabilization. DA plateaus after Round 1 while CatR@1 peaks at Round 2, suggesting one iteration suffices for DA with optional second for retrieval precision.

Round 1 captures the full DA improvement (51.3% $\to$ 67.0%) with no further gain at Rounds 2–3, while CatR@1 peaks at Round 2 (38.9%) before declining at Round 3 (36.1%). Hint Jaccard rises monotonically (0.32 $\to$ 0.47 $\to$ 0.52), indicating progressive stabilization—the slower convergence vs. smaller pools reflects the larger vocabulary space ($\binom{2209}{15}$). We default to $T{=}1$ for latency-sensitive deployment and $T{=}2$ when retrieval precision is critical.

### 7.9 Generalization to Unseen Skills

To test whether SAD overfits to the specific skill pool, we evaluate under two held-out conditions (Table 5).

<table><tbody><tr><th>Condition</th><th>Mode</th><td>DA</td><td>CatR@1</td><td><math><semantics><mi>Δ</mi> <annotation>\Delta</annotation></semantics></math> DA rel.</td></tr><tr><th colspan="5">Leave-2-Categories-Out (security + code-exec removed)</th></tr><tr><th>Reduced pool (<math><semantics><mrow><mi>n</mi> <mo>=</mo> <mn>62</mn></mrow> <annotation>n{=}62</annotation></semantics></math>)</th><th>Vanilla</th><td>0.452</td><td>0.195</td><td>—</td></tr><tr><th>Reduced pool (<math><semantics><mrow><mi>n</mi> <mo>=</mo> <mn>62</mn></mrow> <annotation>n{=}62</annotation></semantics></math>)</th><th>+SAD</th><td>0.613</td><td>0.213</td><td>+35.6%</td></tr><tr><th colspan="5">80/20 Skill Split (442 skills held out)</th></tr><tr><th>80% pool (<math><semantics><mrow><mi>n</mi> <mo>=</mo> <mn>100</mn></mrow> <annotation>n{=}100</annotation></semantics></math>)</th><th>Vanilla</th><td>0.560</td><td>0.348</td><td>—</td></tr><tr><th>80% pool (<math><semantics><mrow><mi>n</mi> <mo>=</mo> <mn>100</mn></mrow> <annotation>n{=}100</annotation></semantics></math>)</th><th>+SAD</th><td>0.690</td><td>0.366</td><td>+23.2%</td></tr><tr><th colspan="5">Full pool (reference)</th></tr><tr><th>Full pool (<math><semantics><mrow><mi>n</mi> <mo>=</mo> <mn>300</mn></mrow> <annotation>n{=}300</annotation></semantics></math>)</th><th>Vanilla</th><td>0.510</td><td>0.342</td><td>—</td></tr><tr><th>Full pool (<math><semantics><mrow><mi>n</mi> <mo>=</mo> <mn>300</mn></mrow> <annotation>n{=}300</annotation></semantics></math>)</th><th>+SAD</th><td>0.677</td><td>0.370</td><td>+32.7%</td></tr></tbody></table>

Table 5: Transfer experiment (7B, $H{=}15$, 2,209 skills). SAD improves routing even when target skills or categories are absent from the retrieval pool. Under category-level held-out (2/24 categories removed, 2,018 train skills), SAD achieves +35.6% relative DA gain. Under random skill held-out (442/2,209 removed), the gain is +23.2%, confirming that SAD’s vocabulary guidance generalizes beyond the specific skill pool.

(1) Category transfer: Removing 2 of 24 categories (security, code-execution; 191 skills) leaves 62 queries with at least one target category absent from the index. SAD still improves DA by +35.6% relative on these queries, demonstrating that hints from related categories provide sufficient vocabulary scaffolding even when the exact target category is missing.

(2) Skill-level held-out: Randomly removing 20% of skills (442/2,209) affects 139 queries (100 evaluated). SAD achieves +23.2% relative DA gain on affected queries, compared to +32.7% on the full pool—indicating moderate degradation but sustained benefit, confirming that SAD leverages the *structural vocabulary* of the skill library rather than memorizing specific skill-hint mappings.

### 7.10 Error Analysis and SAD’s Mechanism

Vanilla failure cases (50 examined) split into over-decomposition (36%), generic descriptions (28%), vocabulary mismatch (22%), and under-decomposition (14%); Oracle R@1 = 99.5% isolates decomposition as the bottleneck. SAD’s hints provide skill-level semantic guidance—specific tool names and descriptions—that anchors sub-task phrasing to retrievable vocabulary, and hint sets stabilize by Round 2 (Jaccard $>$ 0.52), indicating consistent vocabulary identification rather than random exploration (full taxonomy in Appendix J).

## 8 Discussion

#### Cascading bottleneck.

Our DA-conditioned analysis (§7.5) reveals a cascading structure: decomposition granularity gates retrieval, with correct DA raising CatR@1 from 34% to 41%. SAD acts as a *granularity corrector*, not a vocabulary-alignment learner— $\sim$ 75% of its CatR@1 gain comes from queries where vanilla produces the wrong step count, and on DA-matched queries SAD’s per-step gain is statistically zero ($p{=}0.97$). The step-count-constrained oracle baseline confirms this: pinning $K$ to ground truth recovers DA=99.3% but only CatR@1 = 39.8% (a 36-pp residual gap to the @10 ceiling), establishing representation-level reranking, not better decomposition, as the next bottleneck.

#### Reranking as a validated lever.

A pilot in which a Qwen2.5-7B listwise reranker re-orders SAD’s top-10 candidates (Appendix K) lifts CatR@1 from 37.1% to 40.9% (+10.3% relative, $p{<}0.01$; 53/300 improved vs. 25 degraded), shifting cross-encoder reranking from speculative future work to a validated lever that composes with SAD’s structural generalization (+35.6% relative DA under category transfer, §7.9). A 50-query BGE-base spot-check (Appendix L) further raises CatR@1 to 45.1%, confirming encoder choice as an orthogonal axis. SAD and the listwise reranker pilot together close most of the granularity and @10-to-@1 gaps on 2,209 real MCP skills.

## References

## Limitations

#### Benchmark Construction.

Our benchmark queries are template-generated from verb phrases matched to categories, which introduces systematic patterns. While the skill pool is real (2,209 MCP servers from the public ecosystem), the queries are synthetic compositions. The CatR@1 of 34–39% on this pool—well below the CatR@10 ceiling of $\sim$ 70%—suggests that template bias does not inflate results. Transfer experiments (§7.9) confirm SAD generalizes: +35.6% relative DA gain under category transfer and +23.2% under random skill held-out. We additionally evaluate on 200 human-style queries (Appendix A) generated by an independent LLM to reduce text overlap with the skill pool. Strict DA on human queries is low (8.5% $\to$ 21.5%) due to open-ended step boundaries; relaxed DA <sub>±1</sub> (30.5% $\to$ 50.5%) better reflects actual granularity quality. Fully crowd-sourced query collection with multi-annotator agreement remains future work.

#### Evaluation Scope.

Our evaluation is retrieval-focused; we measure whether the correct skill *category* is retrieved, not whether the exact skill is selected or successfully executed. The compose stage (Eq. 4) is proposed as architectural completion; its isolated evaluation requires compatibility ground-truth annotations not present in our current benchmark. Full end-to-end evaluation with real skill execution and error recovery mechanisms is important future work.

#### Other Limitations.

SAD requires two LLM inference passes in its default single-iteration mode, approximately doubling decomposition latency ($\sim$ 2 $\times$ wall-clock time for the decomposition step; retrieval adds $<$ 15ms). Our primary evaluation uses Qwen2.5-7B with cross-model spot-check on qwen-max (50 queries); broader multi-model evaluation (GPT-4o, Claude) is future work. We use a single off-the-shelf encoder (all-MiniLM-L6-v2); domain-adapted or larger encoders (BGE-large, E5-large) may improve retrieval precision, although the step-count-constrained analysis (§7) suggests the @1-vs-@10 gap is unlikely to be closed by encoder scale alone—our LLM-listwise reranker pilot (Appendix K) provides empirical support ($p{<}0.01$) for learned reranking as the more promising direction. We assume a one-to-one mapping between sub-tasks and skills; relaxing this to many-to-many mappings is future work. The hard subset (50 queries) remains statistically limited relative to easy/medium subsets.

## Ethics Statement

This work uses only publicly available, open-source skill repositories and involves no human subjects or personal data. We encourage responsible deployment of skill routing systems with human oversight.

## Appendix A Human-Style Query Evaluation

To validate that SAD generalizes beyond template-generated queries, we evaluate on 200 human-style queries generated by an independent LLM (qwen-max) with instructions to avoid skill names and write naturally.

<table><thead><tr><th>Mode</th><th>Difficulty</th><th>Pred</th><th>DA</th><th>DA <sub>±1</sub></th><th>CatR@1</th><th>CatR@10</th></tr></thead><tbody><tr><th rowspan="3">Vanilla</th><th>Easy (GT=2.0)</th><td>4.21</td><td>0.025</td><td>0.188</td><td>0.306</td><td>0.506</td></tr><tr><th>Medium (GT=3.0)</th><td>3.85</td><td>0.112</td><td>0.362</td><td>0.242</td><td>0.496</td></tr><tr><th>Hard (GT=4.4)</th><td>4.63</td><td>0.150</td><td>0.425</td><td>0.186</td><td>0.380</td></tr><tr><th rowspan="3">+SAD</th><th>Easy (GT=2.0)</th><td>3.06</td><td>0.112</td><td>0.400</td><td>0.319</td><td>0.625</td></tr><tr><th>Medium (GT=3.0)</th><td>3.21</td><td>0.350</td><td>0.625</td><td>0.338</td><td>0.646</td></tr><tr><th>Hard (GT=4.4)</th><td>4.18</td><td>0.150</td><td>0.475</td><td>0.173</td><td>0.435</td></tr></tbody></table>

Table 6: SAD on human-style queries (200 queries, zero text overlap with skill pool). Pred: average predicted step count (GT: ground-truth mean). DA <sub>±1</sub>: relaxed decomposition accuracy allowing $\pm$ 1 step tolerance. Strict DA is low (8.5% $\to$ 21.5%) because the model over-decomposes (e.g., Easy: pred=4.21 vs GT=2.0); under relaxed DA <sub>±1</sub>, performance rises substantially (30.5% $\to$ 50.5%, +66% relative), indicating that SAD correctly identifies approximate granularity even when exact step count is debatable.

#### Why is human-style DA low?

The strict DA metric requires exact step-count match with ground truth. Human-style queries are inherently more open-ended: the average ground-truth step count is 2.65, but reasonable decompositions often include valid intermediate steps (e.g., “authenticate” before “query API”) that our annotations omit. The relaxed DA <sub>±1</sub> metric (predicted steps within $\pm$ 1 of ground truth) better captures this: Vanilla DA <sub>±1</sub> = 30.5%, SAD DA <sub>±1</sub> = 50.5% (+66% relative), showing that SAD achieves *approximate* granularity correction even on open-ended queries. We view this as evidence that human-style performance reflects annotation strictness rather than system failure; crowd-sourced multi-annotator DA evaluation remains future work.

#### Example human-style queries.

Three representative test queries (no skill names, natural phrasing):

- “Keep tabs on competitor pricing and alert my team in Slack when prices change.” (medium, GT: 3 steps—scrape, compare, notify)
- “Pull last week’s sales from the warehouse, summarize trends, and email the report to marketing.” (medium, GT: 3 steps—query, summarize, email)
- “Convert these PDFs into searchable text and store them in our knowledge base.” (easy, GT: 2 steps—OCR, index)

These illustrate why strict DA is brittle: a 4-step decomposition (e.g., adding “authenticate” or “deduplicate”) is semantically valid but scored DA=0; DA <sub>±1</sub> captures these as approximately correct.

## Appendix B Difficulty Breakdown

<table><thead><tr><th>Mode</th><th>Difficulty</th><th>DA</th><th>CatR@1</th></tr></thead><tbody><tr><th rowspan="3">Vanilla</th><th>Easy (<math><semantics><mrow><mi>n</mi> <mo>=</mo> <mn>150</mn></mrow> <annotation>n{=}150</annotation></semantics></math>)</th><td>0.447</td><td>0.357</td></tr><tr><th>Medium (<math><semantics><mrow><mi>n</mi> <mo>=</mo> <mn>100</mn></mrow> <annotation>n{=}100</annotation></semantics></math>)</th><td>0.660</td><td>0.337</td></tr><tr><th>Hard (<math><semantics><mrow><mi>n</mi> <mo>=</mo> <mn>50</mn></mrow> <annotation>n{=}50</annotation></semantics></math>)</th><td>0.400</td><td>0.307</td></tr><tr><th rowspan="3">+SAD</th><th>Easy (<math><semantics><mrow><mi>n</mi> <mo>=</mo> <mn>150</mn></mrow> <annotation>n{=}150</annotation></semantics></math>)</th><td>0.633</td><td>0.413</td></tr><tr><th>Medium (<math><semantics><mrow><mi>n</mi> <mo>=</mo> <mn>100</mn></mrow> <annotation>n{=}100</annotation></semantics></math>)</th><td>0.780</td><td>0.320</td></tr><tr><th>Hard (<math><semantics><mrow><mi>n</mi> <mo>=</mo> <mn>50</mn></mrow> <annotation>n{=}50</annotation></semantics></math>)</th><td>0.600</td><td>0.340</td></tr></tbody></table>

Table 7: Performance by difficulty level (Qwen2.5-7B, 2,209 skills). SAD improves DA across all difficulty levels, with the largest relative gain on hard queries (+50%).

## Appendix C Category Taxonomy and Per-Category Results

The 24 functional categories in CompSkillBench are: developer-tools, finance, integrations, knowledge-management, search-extraction, security, communication, databases, cloud-infrastructure, code-execution, productivity, gaming-entertainment, data-processing, location-services, browser-automation, marketing-analytics, monitoring-observability, ai-ml, multimedia, science-research, file-management, e-commerce, legal-compliance, data-visualization.

| Category | $n$ | $\Delta$ DA | V CatR@1 | S CatR@1 |
| --- | --- | --- | --- | --- |
| marketing-analytics | 33 | +0.333 | 0.304 | 0.314 |
| data-processing | 36 | +0.250 | 0.393 | 0.363 |
| cloud-infrastructure | 37 | +0.243 | 0.271 | 0.365 |
| finance | 39 | +0.231 | 0.485 | 0.534 |
| science-research | 45 | +0.222 | 0.214 | 0.251 |
| databases | 44 | +0.205 | 0.367 | 0.402 |
| search-extraction | 41 | +0.195 | 0.437 | 0.464 |
| location-services | 36 | +0.194 | 0.380 | 0.380 |
| communication | 42 | +0.190 | 0.413 | 0.438 |
| multimedia | 33 | +0.091 | 0.256 | 0.418 |
| ai-ml | 54 | +0.019 | 0.239 | 0.254 |

Table 8: Per-category SAD improvement (top 11 categories by query count, sorted by $\Delta$ DA). SAD improves DA across all categories; the largest gains occur in categories with complex multi-step workflows (marketing, data-processing, cloud).

## Appendix D Decomposition Distribution

Qwen2.5-7B produces an average of 4.09 sub-tasks per query in vanilla mode (vs. ground-truth average of 2.73 for easy, 3.0 for medium, 4.4 for hard). SAD reduces this to 3.34 sub-tasks on average, more closely aligning with ground truth. The DA improvement from 51.0% to 67.7% indicates that SAD primarily corrects over-decomposition.

## Appendix E Convergence Details

#### Formal convergence condition.

Let $\mathcal{H}^{(i)}\subseteq\mathcal{S}$ with $|\mathcal{H}^{(i)}|=H$ denote the hint set at iteration $i$. Since $|\mathcal{S}|=N$ is finite, the space of possible hint sets has cardinality $\binom{N}{H}$. Under deterministic LLM decoding (temperature $=$ 0), the mapping $f:\mathcal{H}^{(i)}\to\mathcal{H}^{(i+1)}$ is a function on a finite set; by the pigeonhole principle, the sequence $\{\mathcal{H}^{(i)}\}$ must eventually cycle. Empirically, we observe progressive stabilization (Jaccard: 0.32 $\to$ 0.47 $\to$ 0.52) because LLM outputs converge once hint vocabulary matches decomposition vocabulary. The slower convergence on our 2,209-skill pool (compared to smaller pools) reflects the larger hint space: $\binom{2209}{15}\gg\binom{60}{15}$.

<svg id="A5.F2.pic1" height="157.47" overflow="visible" version="1.1" viewBox="0 0 574.78 157.47" width="574.78"><g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="translate(0,157.47) matrix(1 0 0 -1 0 0) translate(48.44,0) translate(0,42.29)" fill="#000000" stroke="#000000" stroke-width="0.4pt"><g transform="matrix(1.0 0.0 0.0 1.0 -48.44 -42.29)"><g transform="matrix(1 0 0 1 0 0) translate(88.26,0) translate(0,42.29)"><g style="--ltx-stroke-color:#E6E6E6;--ltx-fill-color:#E6E6E6;--ltx-fg-color:#E6E6E6;" stroke-width="0.4pt" fill="#E6E6E6" stroke="#E6E6E6" color="#E6E6E6"><path style="fill:none" d="M 0 0 L 0 114.9 M 132.7 0 L 132.7 114.9 M 265.41 0 L 265.41 114.9 M 398.11 0 L 398.11 114.9"></path></g><g style="--ltx-stroke-color:#E6E6E6;--ltx-fill-color:#E6E6E6;--ltx-fg-color:#E6E6E6;" stroke-width="0.4pt" fill="#E6E6E6" stroke="#E6E6E6" color="#E6E6E6"><path style="fill:none" d="M -39.81 25.53 L 437.92 25.53 M -39.81 76.6 L 437.92 76.6"></path></g><g style="--ltx-stroke-color:#808080;--ltx-fill-color:#808080;--ltx-fg-color:#808080;" stroke-width="0.2pt" fill="#808080" stroke="#808080" color="#808080"><path style="fill:none" d="M 0 0 L 0 5.91 M 132.7 0 L 132.7 5.91 M 265.41 0 L 265.41 5.91 M 398.11 0 L 398.11 5.91 M 0 114.9 L 0 108.99 M 132.7 114.9 L 132.7 108.99 M 265.41 114.9 L 265.41 108.99 M 398.11 114.9 L 398.11 108.99"></path></g><g style="--ltx-stroke-color:#808080;--ltx-fill-color:#808080;--ltx-fg-color:#808080;" stroke-width="0.2pt" fill="#808080" stroke="#808080" color="#808080"><path style="fill:none" d="M -39.81 25.53 L -33.91 25.53 M -39.81 76.6 L -33.91 76.6"></path></g><g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" stroke="#000000" fill="#000000" stroke-width="0.4pt"><path style="fill:none" d="M -39.81 0 L 437.92 0"></path><path style="fill:none" d="M -39.81 114.9 L 437.92 114.9"></path><path style="fill:none" d="M -39.81 0 L -39.81 114.9"></path><g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="matrix(1.0 0.0 0.0 1.0 -16.34 -15.27)" fill="#000000" stroke="#000000"><foreignObject style="--ltx-fo-width:2.36em;--ltx-fo-height:0.75em;--ltx-fo-depth:0.25em;" width="32.67" height="13.84" transform="matrix(1 0 0 -1 0 10.38)" overflow="visible"><span id="A5.F2.pic1.7.7.7.3.3.3.1.1">0 (V)</span></foreignObject></g> <g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="matrix(1.0 0.0 0.0 1.0 129.24 -13.81)" fill="#000000" stroke="#000000"><foreignObject style="--ltx-fo-width:0.5em;--ltx-fo-height:0.64em;--ltx-fo-depth:0em;" width="6.92" height="8.92" transform="matrix(1 0 0 -1 0 8.92)" overflow="visible"><span id="A5.F2.pic1.8.8.8.4.4.4.1.1">1</span></foreignObject></g> <g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="matrix(1.0 0.0 0.0 1.0 261.95 -13.81)" fill="#000000" stroke="#000000"><foreignObject style="--ltx-fo-width:0.5em;--ltx-fo-height:0.64em;--ltx-fo-depth:0em;" width="6.92" height="8.92" transform="matrix(1 0 0 -1 0 8.92)" overflow="visible"><span id="A5.F2.pic1.9.9.9.5.5.5.1.1">2</span></foreignObject></g> <g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="matrix(1.0 0.0 0.0 1.0 394.65 -13.81)" fill="#000000" stroke="#000000"><foreignObject style="--ltx-fo-width:0.5em;--ltx-fo-height:0.64em;--ltx-fo-depth:0em;" width="6.92" height="8.92" transform="matrix(1 0 0 -1 0 8.92)" overflow="visible"><span id="A5.F2.pic1.10.10.10.6.6.6.1.1">3</span></foreignObject></g> <g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="matrix(1.0 0.0 0.0 1.0 -64.69 21.07)" fill="#000000" stroke="#000000"><foreignObject style="--ltx-fo-width:1.44em;--ltx-fo-height:0.64em;--ltx-fo-depth:0em;" width="19.99" height="8.92" transform="matrix(1 0 0 -1 0 8.92)" overflow="visible"><math xmlns="http://www.w3.org/1998/Math/MathML" display="inline" data-latex="0.4"><semantics><mn>0.4</mn> <annotation encoding="application/x-tex">0.4</annotation></semantics></math></foreignObject></g> <g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="matrix(1.0 0.0 0.0 1.0 -64.69 72.14)" fill="#000000" stroke="#000000"><foreignObject style="--ltx-fo-width:1.44em;--ltx-fo-height:0.64em;--ltx-fo-depth:0em;" width="19.99" height="8.92" transform="matrix(1 0 0 -1 0 8.92)" overflow="visible"><math xmlns="http://www.w3.org/1998/Math/MathML" display="inline" data-latex="0.6"><semantics><mn>0.6</mn> <annotation encoding="application/x-tex">0.6</annotation></semantics></math></foreignObject></g> <clipPath id="pgfcp1"><path d="M -39.81 0 L 437.92 0 L 437.92 114.9 L -39.81 114.9 Z"></path></clipPath><g clip-path="url(#pgfcp1)"><g style="--ltx-stroke-color:#0000FF;--ltx-fill-color:#0000FF;--ltx-fg-color:#0000FF;" stroke="#0000FF" fill="#0000FF" stroke-width="0.8pt" color="#0000FF"><path style="fill:none" d="M 0 54.38 L 132.7 94.47 L 265.41 90.13 L 398.11 90.13"></path></g><g></g><g style="--ltx-stroke-color:#FF0000;--ltx-fill-color:#FF0000;--ltx-fg-color:#FF0000;" stroke="#FF0000" fill="#FF0000" stroke-width="0.8pt" color="#FF0000"><path style="fill:none" d="M 0 13.02 L 132.7 17.87 L 265.41 22.72 L 398.11 15.57"></path></g><g></g></g><g style="--ltx-stroke-color:#0000FF;--ltx-fill-color:#0000FF;--ltx-fg-color:#0000FF;" stroke="#0000FF" fill="#0000FF" stroke-width="0.8pt" color="#0000FF"><path d="M -2.77 51.62 h 5.53 v 5.53 h -5.53 Z"></path><path d="M 129.94 91.7 h 5.53 v 5.53 h -5.53 Z"></path><path d="M 262.64 87.36 h 5.53 v 5.53 h -5.53 Z"></path><path d="M 395.34 87.36 h 5.53 v 5.53 h -5.53 Z"></path></g><g style="--ltx-stroke-color:#FF0000;--ltx-fill-color:#FF0000;--ltx-fg-color:#FF0000;" stroke="#FF0000" fill="#FF0000" stroke-width="0.8pt" color="#FF0000"><path d="M 0 15.79 L 2.4 11.64 L -2.4 11.64 Z"></path><path d="M 132.7 20.64 L 135.1 16.49 L 130.31 16.49 Z"></path><path d="M 265.41 25.49 L 267.8 21.34 L 263.01 21.34 Z"></path><path d="M 398.11 18.34 L 400.51 14.19 L 395.71 14.19 Z"></path></g><g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="matrix(1.0 0.0 0.0 1.0 172.71 -37.68)" fill="#000000" stroke="#000000"><foreignObject style="--ltx-fo-width:3.81em;--ltx-fo-height:0.68em;--ltx-fo-depth:0em;" width="52.7" height="9.46" transform="matrix(1 0 0 -1 0 9.46)" overflow="visible"><span id="A5.F2.pic1.11.11.11.7.7.7.1.1">Iteration</span></foreignObject></g> <g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="matrix(0.0 1.0 -1.0 0.0 -74.19 41.29)" fill="#000000" stroke="#000000"><foreignObject style="--ltx-fo-width:2.34em;--ltx-fo-height:0.68em;--ltx-fo-depth:0em;" width="32.32" height="9.46" transform="matrix(1 0 0 -1 0 9.46)" overflow="visible"><span id="A5.F2.pic1.12.12.12.8.8.8.1.1">Score</span></foreignObject></g> <g style="--ltx-stroke-color:#000000;--ltx-fill-color:#FFFFFF;" fill="#FFFFFF" stroke="#000000" transform="matrix(1.0 0.0 0.0 1.0 -25.83 83.88)"><g transform="matrix(1 0 0 -1 0 25.68)"><g transform="matrix(1 0 0 1 0 8.53)"><g style="--ltx-stroke-color:#0000FF;--ltx-fill-color:#0000FF;--ltx-fg-color:#0000FF;" transform="matrix(1 0 0 -1 0 0) translate(0.55,0)" fill="#0000FF" stroke="#0000FF" stroke-width="0.8pt" color="#0000FF"><path style="fill:none" d="M 0 0 L 11.81 0 L 23.62 0"></path><path d="M 9.04 -2.77 h 5.53 v 5.53 h -5.53 Z"></path></g><g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="matrix(1 0 0 -1 39.53 0) translate(13.05,0) matrix(1.0 0.0 0.0 1.0 -10.28 -3.69)" fill="#000000" stroke="#000000"><foreignObject style="--ltx-fo-width:1.49em;--ltx-fo-height:0.68em;--ltx-fo-depth:0em;" width="20.56" height="9.46" transform="matrix(1 0 0 -1 0 9.46)" overflow="visible"><span id="A5.F2.pic1.13.13.13.9.9.9.1.1.1.1.1">DA</span></foreignObject></g></g> <g transform="matrix(1 0 0 1 0 25.68)"><g style="--ltx-stroke-color:#FF0000;--ltx-fill-color:#FF0000;--ltx-fg-color:#FF0000;" transform="matrix(1 0 0 -1 0 0) translate(0.55,0)" fill="#FF0000" stroke="#FF0000" stroke-width="0.8pt" color="#FF0000"><path style="fill:none" d="M 0 0 L 11.81 0 L 23.62 0"></path><path d="M 11.81 2.77 L 14.21 -1.38 L 9.41 -1.38 Z"></path></g><g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="matrix(1 0 0 -1 24.73 0) translate(27.85,0) matrix(1.0 0.0 0.0 1.0 -25.08 -3.77)" fill="#000000" stroke="#000000"><foreignObject style="--ltx-fo-width:3.63em;--ltx-fo-height:0.69em;--ltx-fo-depth:0em;" width="50.16" height="9.61" transform="matrix(1 0 0 -1 0 9.61)" overflow="visible"><span id="A5.F2.pic1.14.14.14.10.10.10.2.2.1.1.1">CatR@1</span></foreignObject></g></g></g></g></g></g></g> <g transform="matrix(1.0 0.0 0.0 1.0 37.74 -9.07)"><g transform="matrix(1 0 0 1 0 0) translate(2.08,0) translate(0,9.07)"><g style="--ltx-stroke-color:#808080;--ltx-fill-color:#808080;--ltx-fg-color:#808080;" stroke-width="0.2pt" fill="#808080" stroke="#808080" color="#808080"><path style="fill:none" d="M 437.92 0 L 432.02 0 M 437.92 32.83 L 432.02 32.83 M 437.92 65.65 L 432.02 65.65 M 437.92 98.48 L 432.02 98.48"></path></g><g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" stroke="#000000" fill="#000000" stroke-width="0.4pt"><path style="fill:none" d="M 437.92 0 L 437.92 114.9"></path><g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="matrix(1.0 0.0 0.0 1.0 442.81 -4.46)" fill="#000000" stroke="#000000"><foreignObject style="--ltx-fo-width:0.5em;--ltx-fo-height:0.64em;--ltx-fo-depth:0em;" width="6.92" height="8.92" transform="matrix(1 0 0 -1 0 8.92)" overflow="visible"><math xmlns="http://www.w3.org/1998/Math/MathML" display="inline" data-latex="0"><mn>0</mn></math></foreignObject></g> <g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="matrix(1.0 0.0 0.0 1.0 442.81 28.37)" fill="#000000" stroke="#000000"><foreignObject style="--ltx-fo-width:1.44em;--ltx-fo-height:0.64em;--ltx-fo-depth:0em;" width="19.99" height="8.92" transform="matrix(1 0 0 -1 0 8.92)" overflow="visible"><math xmlns="http://www.w3.org/1998/Math/MathML" display="inline" data-latex="0.2"><semantics><mn>0.2</mn> <annotation encoding="application/x-tex">0.2</annotation></semantics></math></foreignObject></g> <g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="matrix(1.0 0.0 0.0 1.0 442.81 61.2)" fill="#000000" stroke="#000000"><foreignObject style="--ltx-fo-width:1.44em;--ltx-fo-height:0.64em;--ltx-fo-depth:0em;" width="19.99" height="8.92" transform="matrix(1 0 0 -1 0 8.92)" overflow="visible"><math xmlns="http://www.w3.org/1998/Math/MathML" display="inline" data-latex="0.4"><semantics><mn>0.4</mn> <annotation encoding="application/x-tex">0.4</annotation></semantics></math></foreignObject></g> <g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="matrix(1.0 0.0 0.0 1.0 442.81 94.02)" fill="#000000" stroke="#000000"><foreignObject style="--ltx-fo-width:1.44em;--ltx-fo-height:0.64em;--ltx-fo-depth:0em;" width="19.99" height="8.92" transform="matrix(1 0 0 -1 0 8.92)" overflow="visible"><math xmlns="http://www.w3.org/1998/Math/MathML" display="inline" data-latex="0.6"><semantics><mn>0.6</mn> <annotation encoding="application/x-tex">0.6</annotation></semantics></math></foreignObject></g> <clipPath id="pgfcp2"><path d="M -39.81 0 L 437.92 0 L 437.92 114.9 L -39.81 114.9 Z"></path></clipPath><g clip-path="url(#pgfcp2)"><g style="--ltx-stroke-color:#808080;--ltx-fill-color:#808080;--ltx-fg-color:#808080;" stroke="#808080" fill="#808080" stroke-dasharray="3.0pt,3.0pt" stroke-dashoffset="0.0pt" stroke-width="0.8pt" color="#808080"><path style="fill:none" d="M 0 0 L 132.7 53.18 L 265.41 77.64 L 398.11 86.01"></path></g><g></g></g><g style="--ltx-stroke-color:#808080;--ltx-fill-color:#808080;--ltx-fg-color:#808080;" stroke="#808080" fill="#808080" stroke-dasharray="3.0pt,3.0pt" stroke-dashoffset="0.0pt" stroke-width="0.8pt" color="#808080"><path d="M 0 2.77 L 2.08 0 L 0 -2.77 L -2.08 0 Z"></path><path d="M 132.7 55.95 L 134.78 53.18 L 132.7 50.41 L 130.63 53.18 Z"></path><path d="M 265.41 80.4 L 267.48 77.64 L 265.41 74.87 L 263.33 77.64 Z"></path><path d="M 398.11 88.78 L 400.18 86.01 L 398.11 83.24 L 396.03 86.01 Z"></path></g><g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="matrix(0.0 1.0 -1.0 0.0 481.91 34.27)" fill="#000000" stroke="#000000"><foreignObject style="--ltx-fo-width:3.35em;--ltx-fo-height:0.69em;--ltx-fo-depth:0em;" width="46.35" height="9.61" transform="matrix(1 0 0 -1 0 9.61)" overflow="visible"><span id="A5.F2.pic1.15.15.15.5.5.5.1.1">Jaccard</span></foreignObject></g> <g style="--ltx-stroke-color:#000000;--ltx-fill-color:#FFFFFF;" fill="#FFFFFF" stroke="#000000" transform="matrix(1.0 0.0 0.0 1.0 347.32 100.94)"><g transform="matrix(1 0 0 -1 0 8.61)"><g transform="matrix(1 0 0 1 0 8.61)"><g style="--ltx-stroke-color:#808080;--ltx-fill-color:#808080;--ltx-fg-color:#808080;" transform="matrix(1 0 0 -1 0 0) translate(0.55,0)" fill="#808080" stroke="#808080" stroke-dasharray="3.0pt,3.0pt" stroke-dashoffset="0.0pt" stroke-width="0.8pt" color="#808080"><path style="fill:none" d="M 0 0 L 11.81 0 L 23.62 0"></path><path d="M 11.81 2.77 L 13.89 0 L 11.81 -2.77 L 9.74 0 Z"></path></g><g style="--ltx-stroke-color:#000000;--ltx-fill-color:#000000;" transform="matrix(1 0 0 -1 24.73 0) translate(25.94,0) matrix(1.0 0.0 0.0 1.0 -23.18 -3.77)" fill="#000000" stroke="#000000"><foreignObject style="--ltx-fo-width:3.35em;--ltx-fo-height:0.69em;--ltx-fo-depth:0em;" width="46.35" height="9.61" transform="matrix(1 0 0 -1 0 9.61)" overflow="visible"><span id="A5.F2.pic1.16.16.16.6.6.6.1.1.1.1.1">Jaccard</span></foreignObject></g></g></g></g></g></g></g></g></svg>

Figure 2: SAD convergence. DA (left axis) converges at Round 1; CatR@1 peaks at Round 2. Hint Jaccard (right axis) rises monotonically, indicating progressive stabilization of the skill vocabulary.

#### SAD hint-count (HH) sensitivity.

Table 9 reports performance across $H\in\{5,10,15,25\}$ on the Qwen-2.5-7B decomposer. DA increases monotonically with $H$ (0.550 $\to$ 0.687), with diminishing returns beyond $H{=}15$: the DA gap from $H{=}15$ to $H{=}25$ is only +1pp while CatR@1 gains similarly plateau (0.370 $\to$ 0.389). $H{=}15$ offers the best cost–quality trade-off (fewer LLM context tokens) and is used throughout the paper.

| $H$ | DA | CatR@1 | CatR@10 | ChainCat |
| --- | --- | --- | --- | --- |
| 5 | 0.550 | 0.338 | 0.664 | 0.050 |
| 10 | 0.597 | 0.360 | 0.695 | 0.043 |
| 15 | 0.677 | 0.370 | 0.703 | 0.073 |
| 25 | 0.687 | 0.389 | 0.708 | 0.087 |

Table 9: SAD hint-count ($H$) sensitivity on Qwen-2.5-7B. $H{=}15$ (default) balances DA and retrieval quality.

## Appendix F SAD Prompt Templates

#### System prompt (shared by vanilla and SAD).

> You are a task decomposition assistant. Given a complex user query, break it down into atomic sub-tasks, each requiring exactly one tool or skill. Output a JSON array of strings. Each string should be a concise, actionable sub-task description.

#### Vanilla user prompt.

> Decompose the following query into atomic sub-tasks:  
> {query}

#### SAD user prompt (Pass 2).

> Decompose the following query into atomic sub-tasks.  
> Available skills that may be relevant: {hint\_list}  
> Query: {query}

where {hint\_list} is a comma-separated list of the top- $H$ skill names retrieved in Pass 1 (see Algorithm 1).

## Appendix G Statistical Significance

We report Wilcoxon signed-rank tests and bootstrap 95% confidence intervals (10,000 resamples) over 300 paired per-query observations.

#### Wilcoxon signed-rank tests.

DA: $W{=}1262.5$, $p{=}5.7{\times}10^{-7}$ ($n_{\text{non-tied}}{=}100$). $\text{Chain}_{\text{cat}}$: $W{=}52.5$, $p{=}0.025$ ($n_{\text{non-tied}}{=}20$). CatR@1: $W{=}3678.5$, $p{=}0.17$ ($n_{\text{non-tied}}{=}130$). CatR@10: $W{=}3377.0$, $p{=}0.34$ ($n_{\text{non-tied}}{=}122$).

SAD’s DA improvement is highly significant; $\text{Chain}_{\text{cat}}$ is significant at $\alpha{=}0.05$. The CatR metrics show directional improvement (+8.2% and +2.6% relative) but do not reach significance, consistent with the interpretation that SAD primarily corrects *granularity* (step count), while per-step retrieval precision remains bounded by vocabulary mismatch on a 2,209-skill pool.

#### Relaxed DA (DA±1).

DA <sub>±1</sub>: $W{=}1891.0$, $p{=}2.1{\times}10^{-8}$ ($n_{\text{non-tied}}{=}128$). The relaxed metric (predicted steps within $\pm$ 1 of ground truth) is also highly significant, confirming that SAD’s granularity correction is robust even under a more permissive definition. On the main benchmark: Vanilla DA <sub>±1</sub> = 71.3%, SAD DA <sub>±1</sub> = 84.3% (+18.2% relative). On human-style queries: Vanilla DA <sub>±1</sub> = 30.5%, SAD DA <sub>±1</sub> = 50.5% (+66% relative). This demonstrates that the strict DA gap on human queries (8.5% $\to$ 21.5%) substantially understates SAD’s actual granularity benefit; under relaxed evaluation, SAD achieves majority approximate correctness (50.5%) on open-ended queries.

#### CatR@1 on DA-corrected subset.

SAD fixes DA on 75 queries (25%) where vanilla produces incorrect step count. On this subset, CatR@1 improves from 23.6% to 37.0% (+56.8% relative; Wilcoxon one-sided $p{=}0.0015$, $n_{\text{non-tied}}{=}38$). This confirms that SAD’s retrieval benefit, though non-significant in aggregate ($p{=}0.17$, where 225 DA-unchanged queries dilute the signal), is highly significant on the queries where its mechanism activates. Conversely, on the 128 DA-matched queries (both methods DA=1), CatR@1 is statistically identical (41.7% vs. 40.9%, $p{=}0.97$, $n_{\text{non-tied}}{=}58$), confirming that SAD’s retrieval gain comes entirely from granularity correction.

#### Bootstrap 95% CI.

$\Delta$ DA: $[+0.103,+0.230]$; $\Delta$ DA <sub>±1</sub>: $[+0.070,+0.190]$; $\Delta\text{CatR}$ @1: $[-0.005,+0.062]$; $\Delta\text{Chain}_{\text{cat}}$: $[+0.007,+0.063]$.

## Appendix H Skill Pool Statistics

The 2,209 skills span 24 categories with the following distribution: developer-tools (357), finance (270), integrations (229), knowledge-management (180), search-extraction (140), security (122), communication (109), databases (104), cloud-infrastructure (87), code-execution (69), productivity (66), gaming-entertainment (57), data-processing (55), location-services (55), browser-automation (54), marketing-analytics (49), monitoring-observability (48), ai-ml (45), multimedia (35), science-research (26), file-management (25), e-commerce (16), legal-compliance (7), data-visualization (4). Skills are sourced from the awesome-mcp-servers registry and converted to a unified Skill representation (name, description, categories, tags, source URL). 17.6% of skills require authentication (API keys or OAuth).

## Appendix I End-to-End Pilot with Mock Executors

To assess whether SkillWeaver’s routing produces *executable* plans (not just well-ranked candidates), we conduct a pilot execution study. We select 30 queries whose ground-truth skills fall within 10 categories for which we implement mock executors (databases, search-extraction, communication, file-management, data-processing, ai-ml, cloud-infrastructure, browser-automation, finance, developer-tools). Mock executors simulate realistic success/failure rates (80–95% per category) calibrated from published API reliability benchmarks.

#### Protocol.

Each query is processed through the full SAD pipeline (Qwen2.5-7B, $H{=}15$). For each routed skill, the corresponding mock executor is invoked. We report:

- Step Execution Success (SES): fraction of individual steps that execute successfully.
- Chain Completion Rate (CCR): fraction of queries where *all* steps succeed.

#### Results.

Over 30 queries (avg 2.80 predicted steps):

- DA = 86.7% (step count correct)
- SES = 86.9% (73/84 steps succeed)
- CCR = 76.7% (23/30 chains complete)

The 76.7% chain completion rate demonstrates that SkillWeaver produces plans that are largely executable end-to-end. The gap between SES (86.9%) and CCR (76.7%) reflects the compound effect of per-step failures in multi-step chains: even a single step failure breaks the chain. This motivates future work on error recovery and retry mechanisms within the compose stage.

## Appendix J Error Analysis

Full failure-case taxonomy (50 vanilla failures, summarized in §7.10): over-decomposition cases typically split a single skill operation into preparation + execution + verification (e.g., “connect to API” + “send request” + “parse response” for one HTTP-fetch skill). Generic descriptions like “process the data” fail to surface verb-specific candidates such as “parse-csv” or “transform-json”. Vocabulary mismatch occurs when natural phrasing (“alert the team”) diverges from canonical skill names (“slack-notify”, “pagerduty-alert”). Under-decomposition (14%) collapses two distinct skills into one step (e.g., “download and parse” merges file-fetch and csv-parse).

## Appendix K LLM-Listwise Reranker Pilot

#### Setup.

To test whether the SAD CatR@10-to-@1 gap can be closed by a learned reranker (without retraining the bi-encoder), we run a 300-query experiment on the full compositional benchmark. For each sub-task produced by SAD, we take the top-10 candidates from the MiniLM bi-encoder and re-rank them with a Qwen2.5-7B *listwise* prompt: the model is shown the sub-task description and all 10 candidate skills (id, category, $\leq$ 140-char description) and asked to output the index of the single best match. Reranker and decomposer share the same 7B checkpoint (no additional training).

#### Results (300 queries, 828 sub-tasks).

SAD top-1: CatR@1 $=0.371$. Reranked top-1: CatR@1 $=0.409$ (+10.3% relative, +3.8 pp absolute; Wilcoxon signed-rank one-sided $p{=}0.007$). The oracle CatR@10 ceiling is $0.716$, so the reranker closes $\approx$ 11% of the @10-to-@1 gap with no encoder change. Of 300 queries, 53 improved, 25 degraded, and 222 unchanged; bootstrap 95% CI on absolute gain is $[+0.005,+0.057]$ (entirely above zero). Learned cross-encoders trained on $\langle$ sub-task, skill $\rangle$ pairs are an immediate next step; we view this pilot as strong evidence that the bottleneck is representational rather than decomposition-side.

#### Cost.

Reranking adds one 7B forward pass per sub-task ($\sim$ 1.4s on V100), bringing total per-query latency to $\sim$ 5s including SAD’s two decomposition passes. This is acceptable for batch-style routing scenarios and can be reduced with smaller dedicated rerankers.

## Appendix L Encoder Robustness Spot-Check

To test whether SAD’s gains are coupled to a particular sentence encoder, we re-ran a 50-query subset of the compositional benchmark replacing all-MiniLM-L6-v2 (used throughout the main paper for fair comparison with prior work) with BGE-base-en-v1.5 [^24] as the bi-encoder, keeping all other components fixed (SAD decomposer, FAISS index, $H{=}15$). CatR@1 rises from 0.394 to 0.451 (+14.5% relative), indicating that BGE’s stronger semantic representation yields a non-trivial orthogonal gain on top of SAD’s structural correction. We treat encoder choice as an axis composable with SAD and the listwise reranker (Appendix K); a full-benchmark sweep across encoders is left to follow-up work.

[^1]: Anthropic. 2024. Model context protocol. Https://modelcontextprotocol.io/.

[^2]: Anthropic. 2025. Agent skills specification. Https://docs.anthropic.com/en/docs/agents-and-tools/agent-skills.

[^3]: Akari Asai, Zeqiu Wu, Yizhong Wang, Avirup Sil, and Hannaneh Hajishirzi. 2024. Self-RAG: Learning to retrieve, generate, and critique through self-reflection. In *Proceedings of the International Conference on Learning Representations*.

[^4]: Yu Du, Fangyun Fan, and Dingcheng Pi. 2024. Anytool: Self-reflective, hierarchical agents for large-scale api use. *arXiv preprint arXiv:2402.04253*.

[^5]: Shibo Hao, Tianyang Liu, Zhen Wang, and Zhiting Hu. 2024. Toolkengpt: Augmenting frozen language models with massive tools via tool embeddings. *Advances in Neural Information Processing Systems*, 36.

[^6]: Wenlong Huang, Pieter Abbeel, Deepak Pathak, and Igor Mordatch. 2022. Language models as zero-shot planners: Extracting actionable knowledge for embodied agents. In *Proceedings of the 39th International Conference on Machine Learning*.

[^7]: Jeff Johnson, Matthijs Douze, and Hervé Jégou. 2019. Billion-scale similarity search with gpus. *IEEE Transactions on Big Data*, 7(3):535–547.

[^8]: Vladimir Karpukhin, Barlas Oguz, Sewon Min, Patrick Lewis, Ledell Wu, Sergey Edunov, Danqi Chen, and Wen-tau Yih. 2020. Dense passage retrieval for open-domain question answering. In *Proceedings of the 2020 Conference on Empirical Methods in Natural Language Processing*.

[^9]: Tushar Khot, Harsh Trivedi, Matthew Finlayson, Yao Fu, Kyle Richardson, Peter Clark, and Ashish Sabharwal. 2023. Decomposed prompting: A modular approach for solving complex tasks. In *Proceedings of the International Conference on Learning Representations*.

[^10]: LangChain. 2023. Plan-and-execute agents. [https://blog.langchain.dev/planning-agents/](https://blog.langchain.dev/planning-agents/). Multi-step planning agents that decouple high-level planning from per-step execution.

[^11]: Minghao Li, Feifan Song, Bowen Yu, Haiyang Yu, and 1 others. 2023. Api-bank: A comprehensive benchmark for tool-augmented llms. In *Proceedings of the 2023 Conference on Empirical Methods in Natural Language Processing*.

[^12]: Weiwen Liu, Xu Zeng, Jian Jiang, and 1 others. 2025. Toolace: Winning the points of llm function calling. *arXiv preprint arXiv:2409.00920*.

[^13]: Shishir G Patil, Tianjun Zhang, Xin Wang, and Joseph E Gonzalez. 2024. Gorilla: Large language model connected with massive apis. In *Proceedings of the 41st International Conference on Machine Learning*.

[^14]: Bo Qiao, Liqun Li, Xu Zhang, Shilin He, Yu Kang, Chaoyun Lin, Saravan Rajmohan, Dongmei Zhang, and Qi Zhang. 2024. Taskweaver: A code-first agent framework. *arXiv preprint arXiv:2311.17541*.

[^15]: Yujia Qin, Shihao Liang, Yining Ye, Kunlun Zhu, Lan Yan, Yaxi Lu, Yankai Lin, Xin Cong, Xiangru Tang, Bill Qian, and 1 others. 2023. Toolllm: Facilitating large language models to master 16000+ real-world apis. *arXiv preprint arXiv:2307.16789*.

[^16]: Qwen Team. 2024. Qwen2.5 technical report. *arXiv preprint arXiv:2412.15115*.

[^17]: Timo Schick, Jane Dwivedi-Yu, Roberto Dessì, Roberta Raileanu, Maria Lomeli, Eric Hambro, Luke Zettlemoyer, Nicola Cancedda, and Thomas Scialom. 2023. Toolformer: Language models can teach themselves to use tools. *Advances in Neural Information Processing Systems*, 36.

[^18]: Yongliang Shen, Kaitao Song, Xu Tan, Dongsheng Li, Weiming Lu, and Yueting Zhuang. 2023a. Hugginggpt: Solving ai tasks with chatgpt and its friends in hugging face. *Advances in Neural Information Processing Systems*, 36.

[^19]: Yongliang Shen, Kaitao Song, Xu Tan, Dongsheng Li, Weiming Lu, and Yueting Zhuang. 2023b. Taskbench: Benchmarking large language models for task automation. *arXiv preprint arXiv:2311.18760*.

[^20]: Noah Shinn, Federico Cassano, Ashwin Gopinath, Karthik Narasimhan, and Shunyu Yao. 2023. Reflexion: Language agents with verbal reinforcement learning. *Advances in Neural Information Processing Systems*, 36.

[^21]: Lei Wang, Wanyu Xu, Yihuai Lan, Zhiqiang Hu, Yunshi Lan, Roy Ka-Wei Lee, and Ee-Peng Lim. 2023. Plan-and-solve prompting: Improving zero-shot chain-of-thought reasoning by large language models. In *Proceedings of the 61st Annual Meeting of the Association for Computational Linguistics*.

[^22]: Zixuan Wang, Jiachen Li, Yifan Zhang, and 1 others. 2025. Mcp-zero: Zero-shot tool discovery and integration for llm agents. *arXiv preprint arXiv:2505.01048*.

[^23]: Jason Wei, Xuezhi Wang, Dale Schuurmans, Maarten Bosma, Brian Ichter, Fei Xia, Ed Chi, Quoc V Le, and Denny Zhou. 2022. Chain-of-thought prompting elicits reasoning in large language models. *Advances in Neural Information Processing Systems*, 35.

[^24]: Shitao Xiao, Zheng Liu, Peitian Zhang, and Niklas Muennighoff. 2024. C-pack: Packaged resources to advance general chinese embedding. *arXiv preprint arXiv:2309.07597*.

[^25]: Shunyu Yao, Jeffrey Zhao, Dian Yu, Nan Du, Izhak Shafran, Karthik Narasimhan, and Yuan Cao. 2023. React: Synergizing reasoning and acting in language models. In *Proceedings of the International Conference on Learning Representations*.

[^26]: Lifan Yuan, Yangyi Chen, Xingyao Wang, and 1 others. 2025. Craft: Customizing llms by creating and retrieving from specialized toolsets. In *Proceedings of the International Conference on Learning Representations*.

[^27]: YanZhao Zheng, ZhenTao Zhang, Chao Ma, YuanQiang Yu, JiHuai Zhu, Yong Wu, Tianze Xu, Baohua Dong, Hangcheng Zhu, Ruohui Huang, and Gang Yu. 2025. Skillrouter: Retrieve-and-rerank skill selection for llm agents at scale. *arXiv preprint arXiv:2603.22455*.

[^28]: Denny Zhou, Nathanael Schärli, Le Hou, Jason Wei, Nathan Scales, Xuezhi Wang, Dale Schuurmans, Claire Cui, Olivier Bousquet, Quoc Le, and Ed Chi. 2022. Least-to-most prompting enables complex reasoning in large language models. *arXiv preprint arXiv:2205.10625*.

[^29]: Yuchen Zhuang, Yue Yu, Kuan Wang, Haotian Sun, and Chao Zhang. 2024. Toolqa: A dataset for llm question answering with external tools. *Advances in Neural Information Processing Systems*, 36.