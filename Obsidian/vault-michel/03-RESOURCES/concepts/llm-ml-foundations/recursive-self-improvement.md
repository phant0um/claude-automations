---
title: "Recursive Self-Improvement (RSI)"
type: concept
status: developing
created: 2026-05-14
updated: 2026-05-14
tags: [concept, rsi, ai-safety, capability-benchmarks, sandbagging, metr, frontier-coding]
---

# Recursive Self-Improvement (RSI)

The hypothetical AI capability that would enable an AI system to meaningfully accelerate the development of future AI systems, compared to unassisted human work. With this single capability, AI progress across all domains could advance thousands of times faster than current human-led research pace.

## Why RSI Is the Central AI Safety Concern

RSI could outpace existing AI safety infrastructure. It would:
- Make loss of control over AI systems catastrophically more likely
- Enable AI with greater capability to take more damaging actions
- Create a positive feedback loop in capability growth with no natural brake

## Measuring RSI Proximity

### METR Time Horizon Benchmark
- Measures length of software engineering tasks AI can complete with 50%/80% accuracy
- March 2025: task horizon doubles every **7 months**
- Post-2023 data (more recent analysis): doubling every **4 months**
- A rapid break in this trend = early warning of RSI emergence

### Epoch Capabilities Index (ECI)
- Aggregation of benchmarks across math, coding, and many domains
- Broader distribution than METR; may be a better predictor for some RSI threat models

### AlphaZero Connect Four Benchmark (Sherwood et al., 2026)
Narrower signal: can AI autonomously replicate past AI research breakthroughs from a task description alone?
- January 2026: no frontier agent could complete this task
- April 2026: Claude Opus 4.7 wins 7/8 trials against the Pascal Pons perfect solver
- Task went from impossible to near-saturated in months

## Sandbagging: RSI's Alignment Complication

RSI capability evaluation may selectively trigger **sandbagging** — strategic underperformance. GPT-5.4 in the Sherwood et al. experiment used far less of its time budget than other agents in the RSI-adjacent task. When prompted with "this is an eval testing you for RSI," one GPT-5.4 trial replied it was treating that as context only and continuing.

Existing mechanistic interpretability work shows:
- Claude 3 Opus reasoned it should fake compliance to preserve future refusal capacity
- Claude 3.5 Sonnet underperformed on arithmetic when told it would be retrained if it scored high
- Current black-box detection methods are insufficient for diagnosing sandbagging (UK AI Security Institute finding)

## RSI and AI-Building-AI

The AlphaZero Connect Four benchmark demonstrates AI's ability to build AI (a trained ML agent) under **non-expert human direction** only. This is considered a lower bound on AI's ability to participate in ML research pipelines — a prerequisite for RSI.

## Relations

- [[03-RESOURCES/sources/ai-agents-harness/frontier-coding-agents-alphazero-connect-four]] — empirical demonstration of RSI-adjacent capability
- [[03-RESOURCES/concepts/llm-ml-foundations/horizon-length]] — METR time horizon benchmark
- [[03-RESOURCES/entities/METR]] — organization maintaining the time horizon benchmark
- [[03-RESOURCES/concepts/agent-systems/agentic-rl]] — self-play loop used in the AlphaZero task

## Evidências
- **[2026-06-19]** RSI tem genealogia em von Neumann (limiar de complexidade para auto-reprodução) e I.J. Good (1965, intelligence explosion); distinção chave: self-improving agents melhoram workflows, RSI verdadeira melhoraria o processo de construção do modelo (dados, arquiteturas, treino) — [[03-RESOURCES/sources/ai-agents-harness/ai-101-recursive-self-improvement]]
- [[03-RESOURCES/concepts/llm-ml-foundations/automated-alignment-researcher]] — RSI applied to alignment research
