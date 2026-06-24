---
title: "Training Agents Class 1: SFT, run by an agent"
type: source
created: 2026-06-23
updated: 2026-06-23
tags:
  - ai-agents
  - sft
  - model-training
  - lora
  - gemma
  - huggingface
  - source
---

# Training Agents Class 1: SFT, run by an agent

**Source:** [X post by @SergioPaniego](https://x.com/SergioPaniego/status/2069369115630870771) · Published 2026-06-23
**Live stream:** [YouTube](https://www.youtube.com/watch?v=rNgUoH7Wbv8)

## Central Thesis

An AI agent can run the entire supervised fine-tuning (SFT) workflow from a single prompt — resolving the model, preparing data, running training, tracking it, running evals, and writing the model card. The goal is to teach a small open model to act like a coding agent by training it on the traces of a real coding agent's work sessions.

## The Three Agents in This Story

1. **The builder**: the agent that does the ML work (they used Codex, but any capable agent works). Given one prompt, it resolved the model, prepared data, ran training, tracked it, ran evals, wrote the model card.
2. **The student** (the one being trained): a small open Gemma model (Gemma 4 2B) that learns to act like a coding agent.
3. **pi** (the data source): a real coding agent. Its actual work sessions — the traces — are what the student imitates.

> One agent builds, one is being built, and a third gave the lessons.

## Why This Makes Sense

**Why train a model to become a coding agent?** Capable coding agents today run on large, expensive, often closed models. Teach a small open model to act like one and you get something cheap, private, and yours. Because you train on your own traces, you can specialize for a specific use case: your codebase, your tools, your workflow.

**Why Gemma 4, and why 2B?** Recent, open, well-supported instruct model. Small enough to train fast, run on a modest GPU, and iterate on live. The goal is to see the mechanics and workflow, not top a benchmark. A small model also keeps the limits visible.

**What to expect as output?** A LoRA adapter and a final model repo that imitate the agent's format: tool calls and multi-turn loop. It learns the **shape and language** of the agent, not strong problem-solving. A 2B after one SFT pass is not going to be a great coder. You get a model that acts like the agent and a pipeline that is reproducible and auditable.

## Open Artifacts

Every artifact is open:

- **Full stream:** [YouTube](https://www.youtube.com/watch?v=rNgUoH7Wbv8)
- **Slides:** [Google Slides](https://docs.google.com/presentation/d/1hcGZ4U9TjZZzcGNbH2K6wYD45qwZTyo_gosCQsnHlnc)
- **SFT from scratch (by Ben):** [X thread](https://x.com/ben_burtenshaw/status/2067615361428545566)
- **Full agent session trace:** [HuggingFace](https://huggingface.co/buckets/burtenshaw/sft-on-traces/tree/example.jsonl)
- **Trackio dashboard:** [HuggingFace Space](https://huggingface.co/spaces/burtenshaw/youtube-livestream-1-trackio)
- **Final model:** [HuggingFace](https://huggingface.co/burtenshaw/gemma-4-E2B-it-pi-mono-lora-youtube-livestream-1)
- **Winner adapter:** [HuggingFace](https://huggingface.co/burtenshaw/gemma-4-E2B-it-pi-mono-lora-youtube-livestream-1-lr2e4-r16-len4k)
- **Dataset (pi-mono traces):** [HuggingFace](https://huggingface.co/datasets/badlogicgames/pi-mono)
- **Code and context repo:** [GitHub](https://github.com/burtenshaw/training-agents)

## Tools Used

Mostly Hugging Face 🤗: TRL, Hugging Face Jobs, Trackio, and the Hub. Plus Inspect AI and vLLM for evals.

## Key Insight

> "The agent did the build, but the judgment stayed ours: the goal, the constraints, the selection rule we fixed before any scores, and checking every artifact is real."

This directly mirrors the thesis from [[03-RESOURCES/sources/ai-agents/loop-engineering-delegating-judgment-not-code]] — you can delegate execution to an agent, but judgment (goal-setting, constraint definition, evaluation criteria) must remain with the human.

## Minha Síntese

Demonstração prática de agent-driven ML engineering — um agente (Codex) executando todo o pipeline de SFT a partir de um único prompt. O insight mais interessante é a estrutura de três agentes: builder (executa), student (é treinado), pi (fornece os dados/traces). Isso é meta-agentic: um agente construindo outro agente. A escolha de Gemma 4 2B é deliberadamente modesta — o objetivo é visibilidade dos mecânicos, não benchmark. Conecta diretamente com [[03-RESOURCES/sources/ai-agents/loop-engineering-delegating-judgment-not-code]] na frase final: "The agent did the build, but the judgment stayed ours" — a mesma tese de que julgamento não é delegável. Para o vault, também conecta com [[03-RESOURCES/sources/ai-agents/glm-52-open-source-ai-setup]] que discute GLM 5.2 como modelo open-source para agentes. O conceito de treinar em traces (sessões reais de um agente) é uma abordagem de data generation que vale acompanhar.