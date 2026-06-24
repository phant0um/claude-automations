---
title: "Claude"
type: entity
category: model
tags: [entity, ai-model, anthropic]
created: 2026-05-31
updated: 2026-06-01
status: developing
---

# Claude

Família de modelos de IA da Anthropic, construída com Constitutional AI para ser segura e útil.

## O que é / What it is

Claude é desenvolvido pela Anthropic usando Constitutional AI (CAI) — técnica que alinha o modelo via princípios explícitos em vez de depender só de feedback humano. A linha cobre três tiers: Haiku (rápido/barato), Sonnet (balanceado, padrão), e Opus (mais capaz, alto custo). Disponível via API, Claude.ai web/mobile, e Claude Code (CLI para tarefas de desenvolvimento).

## Relevância para o vault

Claude Code é a ferramenta principal de Michel para operar, manter e expandir o vault. A API Claude é usada diretamente pelos agentes em `04-SYSTEM/agents/`. Entender os tiers de modelo é crítico para decisões de custo e qualidade em pipelines de agentes.

## Sources

- [[03-RESOURCES/entities/claude-models]]
- [[03-RESOURCES/entities/Claude-Sonnet-4.6]]
- [[03-RESOURCES/entities/Claude-Opus-4.7]]
- [[03-RESOURCES/entities/Claude-Haiku-4.5]]
- [[04-SYSTEM/agents/core/guard]]
- [[03-RESOURCES/entities/MCP]]

## Evidências
- **[2026-06-23]** Coding agents now interleave LLMs with retrieval over the working repository, and retrieval implementations vary widely across deployed harnesses. Ins — [[code-isnt-memory-a-structural-codebase-index-inside-a-coding-agentcode-and-data]]
- **[2026-06-23]** Computer use agents (CUAs) have advanced rapidly in desktop automation, and a growing number of users deploy CUAs such as OpenClaw on Mac Mini for alw — [[macagentbench-benchmarking-ai-agents-on-real-world-macos-desktop]]
- **[2026-06-23]** Agentic coding harnesses—such as Agent-Skills, Superpowers, and Agent-Rigor—are increasingly deployed to augment underlying LLMs for real-world softwa — [[rigorbench-benchmarking-engineering-process-discipline-in-autonomous-ai-coding-a]]
- **[2026-06-23]** Real-world users typically have access to multiple Large Language Models (LLMs) from different providers, and these LLMs often excel at distinct domai — [[agent-as-a-router-agentic-model-routing-for-coding-tasks]]
- **[2026-06-23]** --- title: "Beyond Mainframe Modernization: Reimagining Enterprise Applications for an Agentic World" source: " author: published: 2026-06-23 created: — [[beyond-mainframe-modernization-reimagining-enterprise-applications-for-an-agenti]]
- **[2026-06-23]** 本次更新为 GitHub Copilot for JetBrains IDEs 带来了对来自 GitHub 的组织和企业级 agent 的支持，让你可以在 Copilot CLI 会话中排队和引导消息，引入了全新的 agent 调试日志摘要视图，并将 Claude 作为 agent 提供方带入公开预 — [[copilot-jetbrains-ide-claude-agent]]
- **[2026-06-23]** The increasing deployment of large language model (LLM) agents in collaborative workflows demands robust multi-user, multi-principal interaction mecha — [[harness-mu-a-safe-governed-and-effective-harness-for-multi-user-llm-agents]]
- **[2026-06-23]** Translating sequential programming priors into the parallel temporal logic of hardware design remains a crucial bottleneck for large language models ( — [[how-llms-fail-and-generalize-in-rtl-coding-for-hardware-design]]
- **[2026-06-23]** GitHub Agentic Workflows is like a team of street sweepers that clean up little messes in your repo. These teams significantly improve — [[improving-token-efficiency-in-github-agentic-workflows]]
- **[2026-06-23]** Multi-agent systems (MAS) offer a scalable path forward for agentic AI, comprising multiple LLM-based agents, each assigned a system prompt and a posi — [[mas-promptbench-when-does-prompt-optimization-improve-multi-agent-llm-systems]]
- **[2026-06-23]** You open a fresh chat, type “What framework should I use for a web app?”, and the model says “React.” You screenshot it, share it, and write “Claude p — [[models-dont-have-preferences-they-have-context]]
- **[2026-06-23]** LLM-based coding agents need higher-level operational knowledge about a repository (which files house which subsystems, how to run the test suite, whi — [[probe-and-refine-tuning-of-repository-guidance-for-coding-agents]]
- **[2026-06-23]** We present RLM-Cascade, a proxy-layer system that applies speculative decoding at the response level to reduce LLM API costs without requiring model a — [[rlm-cascade-response-level-speculative-decoding-for-cost-efficient-llm-api-servi]]
- **[2026-06-23]** Most developers begin with the same rush of excitement: the agent writes code, fixes bugs, explains unfamiliar systems, generates tests, and turns vag — [[the-agent-coding-maturity-curve-9-stages-to-trusted-automation]]
- **[2026-06-23]** Large model inference optimization serves as a key foundation for supporting the scalable, low-cost, and highly stable operation of large model servic — [[token-operations-oriented-inference-optimization-techniques-for-large-models]]
- **[2026-06-23]** This blog outlines five essential concepts that explain how [large language models]() process input within a co — [[top-five-essential-context-window-concepts-in-large-language-models]]
- **[2026-06-23]** We present a dependent-type-based prover designed around the way LLMs (and humans) tend to write mathematics, complementing existing systems such as L — [[visored-a-controlled-natural-language-prover-for-llm-generated-mathematics]]
- **[2026-06-23]** We present HAAS Studio, a simulation and decision-support tool implementing the HAAS framework for policy-aware adaptive task allocation between human — [[haas-studio-a-tool-for-simulating-benchmarking-and-governing-human-ai-work-alloc]]
