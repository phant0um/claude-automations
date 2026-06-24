---
title: "Maximize AI Factory Energy Efficiency Through Full-Stack Inference and Training Optimizations"
type: source
source: "Clippings/Maximize AI Factory Energy Efficiency Through Full-Stack Inference and Training Optimizations.md"
created: 2026-06-23
ingested: 2026-06-23
score: B
tags: [ai-agents, source-page]
---

## Tese central
---
title: "Maximize AI Factory Energy Efficiency Through Full-Stack Inference and Training Optimizations"
source: "
author:
  - "[[Sachin Idgunji]]"
published: 2026-06-23
created: 2026-06-23
description: "Power can account for 40% of the operating expenses (OpEx) to run an AI factory. Each watt can be spent on overhead, data ingestion, training…"
tags:
  - "clippings"
---
Power can account for [40% of the operating expenses (OpEx)]() to run an [AI factory](). Each watt can be spent on overhead,

## Argumentos principais
### Why is inference optimization important for AI factories?
Inference drives revenue, so it is the key workload to optimize. When operators increase inference throughput per watt, they directly increase the number of tokens they can sell or insights they can create. This also translates to additional revenue per unit of time.
At the hundred megawatt to gigawatt scale, even a few percentage points of throughput improvement per megawatt can translate into meaningful gains in profit.
Model architecture is also important. [Mixture-of-experts (MoE)]() models are typically more energy efficient per unit of intelligence compared to dense models with similar total parameters because only a subset of experts is active per token. For example, DeepSeek-R1 has a large parameter count, a fraction of which is activated for each token. It [achieves higher task performance]() at a similar or lower per‑token compute cost than dense predecessors. In other words, the MoE design delivers more intelligence for the same or less energy spent producing each token.

### How to optimize for system-level energy use and performance per watt
NVIDIA architectures and platforms are engineered to increase the amount of intelligence produced per watt with each generation. Across six architecture generations, NVIDIA has improved inference throughput per megawatt by [1,000,000x]().
The [NVIDIA GB200 NVL72]() rack-scale system increases energy efficiency through extreme co-design, with dense, direct-to-chip liquid-cooled architecture that delivers more throughput per watt. It uses in-rack power smoothing to flatten peak current spikes, enabling operators to safely deploy more GPUs within the same power and infrastructure budget.
In addition, [NVIDIA DSX]() is an open, AI factory-scale platform that drives dynamic power allocation, real-time telemetry, and applying advanced rack-level controls that recover stranded power and increase tokens per watt.

### Optimizing energy efficiency in LLM training
Large model training requires the distribution of work across multiple GPUs using a combination of multiple parallelization methods. During training, pushing for maximum iteration speed comes at the cost of very large energy consumption.
Further, individual GPU workload allocation is not perfectly balanced, leading to several GPUs in idle state while few GPUs finish computations. Energy is wasted if all GPUs sprint to the finish to complete a task only to sit idle waiting for others to finish theirs and sync.
Researchers from the [ML.ENERGY Initiative]() at the University of Michigan have shown that tuning the processing speed for individual GPUs can [reduce energy bloat in large model training](). Those with more work are on the critical path (the slowest chain of tasks in the pipeline) and run at maximum speed, while those with less work are intentionally slowed down.

### How does NVIDIA DSX optimize AI factory performance?
The ML.ENERGY Initiative has developed a [leaderboard]() and [benchmark]() for sharing observations from their measurements and a [reasoning framework that explains why they observe certain energy behaviors]().
These benchmarks can be tied into energy aware operations- telemetry-driven systems that show how to run an AI factory under real deployment constraints, including power cost, carbon intensity, thermals, cooling capacity, and grid limits.
NVIDIA DSX provides these energy-aware operations. The platform delivers a coordinated view across compute, racks, cooling, facility power, and workload scheduling. It provides a common operational architecture that can connect design-time simulation with runtime telemetry, helping operators understand where power is being used, where it is stranded, and how much additional useful compute can fit within a fixed site envelope.

### Learn more
AI factories are fundamentally limited by power, making performance per watt a key driver of token cost and profitability. Optimizing inference is critical because it directly increases revenue through higher token output, while full-stack improvements across hardware, software, and model design boost efficiency.
Training can also be made more energy-efficient without compromising speed by reducing idle GPU time. NVIDIA DSX enables real-time, energy-aware optimization across infrastructure, maximizing tokens per watt and revenue per megawatt.
To learn more about power-constrained AI factory design, simulation, operations, and NVIDIA DSX, visit the NVIDIA booth at [ISC 2026]().

### Acknowledgments
*We’d like to thank Mosharaf Chowdhury, Jae-Won Chung, and Ruofan Wu from the ML Energy initiative at the University of Michigan for their contributions.*


## Key insights
- Idle time from GPUs finishing early is minimized
- GPUs running at lower speed use less energy
- End-to-end training time remains unchanged
- Implementing fine‑grained kernel and phase‑level energy profiling to identify compute, memory, communication, and power‑limited regions
- Analyzing how parallelism configurations, pipeline imbalance, and communication overlap impact performance‑per‑watt
- 45°C liquid cooling:** By leveraging integrated chip, thermal, and system-level innovations, operators can utilize higher 45°C inlet temperatures to improve power usage effectiveness (PUE), ensuring that a larger portion of AI factory power is redirected toward revenue-generating compute.

## Exemplos e evidências
See original source at `Clippings/Maximize AI Factory Energy Efficiency Through Full-Stack Inference and Training Optimizations.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/ai-agents/orchestrat]]
- [[03-RESOURCES/concepts/software-engineering/runtime]]
- [[03-RESOURCES/entities/NVIDIA]]
