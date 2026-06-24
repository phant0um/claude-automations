---
title: Agentic RL
type: concept
status: developing
created: 2026-05-05
updated: 2026-06-09
tags: [concept, reinforcement-learning, ai-agents, tool-use, grpo, long-horizon, post-training]
---

# Agentic RL

Reinforcement learning applied to long-horizon, multi-step, tool-using behaviors in language model agents. Extends classical RL (PPO, GRPO) to explicitly model natural-language reasoning, environment interaction, and tool execution as part of the decision process.

## How It Differs from Reasoning RL

| Dimension | Reasoning RL | Agentic RL |
|-----------|-------------|------------|
| Task type | Math, search, verifiable Q&A | Real-world workflows (booking, data analysis) |
| Environment | Static (one correct answer) | Dynamic (state changes with each tool call) |
| Reward signal | Binary (final answer correct?) | 0–1 rubric over decomposed subgoals |
| Context length | Shorter | Long-horizon (5–20 turns typical) |
| User interaction | None | Multi-turn user + tool simulator |

## Training Setup (AgenticQwen)

From [[03-RESOURCES/sources/ml-research-papers/clipping-agenticqwen-small-agentic-llm-dual-flywheels]]:

- **Environment:** fully simulated (mock user + mock tools, both LLM-based) — no proprietary APIs required
- **Reward:** rubric evaluator (also an LLM) decomposes each task into verifiable subgoals; reward ∈ [0, 1]
- **Optimizer:** GRPO (Group Relative Policy Optimization) — see [[03-RESOURCES/concepts/llm-ml-foundations/post-training-llm]] for GRPO mechanics
- **Data curriculum:** [[03-RESOURCES/concepts/ai-strategy-org/dual-data-flywheel]] continuously generates harder tasks

Example subgoal check (flight booking):
```
Subgoal: "Did the agent correctly call update_order_status with the right parameters?"
→ Qwen3-235B evaluates trajectory → assigns partial reward
```

## Key Challenges

1. **Environment diversity:** agentic RL needs diverse *environments*, not just diverse prompts — these are scarce and expensive to build
2. **Reward sparsity:** in long-horizon tasks, the final outcome may not reflect which intermediate steps were good
3. **Saturation:** static synthetic environments lead to rapid homogenization of learning signal → solved by [[03-RESOURCES/concepts/ai-strategy-org/dual-data-flywheel]]
4. **Adversarial robustness:** agents must handle misleading users and unexpected state transitions — addressed by adversarial mock-user intervention in [[03-RESOURCES/concepts/agent-systems/behavior-tree-expansion]]
5. **Horizon length as independent bottleneck:** Kim et al. (2026) show that increasing action sequence length *alone* causes RL collapse even when reasoning complexity is held constant. Root causes: exponential exploration difficulty + [[03-RESOURCES/concepts/llm-ml-foundations/credit-assignment]] noise from negative advantage diffusion. Fix: [[03-RESOURCES/concepts/llm-ml-foundations/horizon-reduction]] (macro actions / subgoal decomposition). See [[03-RESOURCES/sources/ml-research-papers/training-llms-long-horizon-tasks-empirical-study]].

## Relation to Broader RL Landscape

- **PPO** (Proximal Policy Optimization): foundational RL algorithm; provides conceptual basis
- **GRPO** (Group Relative Policy Optimization): more memory-efficient variant; no separate reward model needed; used by AgenticQwen and DeepSeek-R1 family
- **ReAct / CoT:** prompt-level frameworks that laid the foundation for integrating reasoning with tool use; agentic RL trains this behavior rather than eliciting it via prompting
- **Verifiable reward optimization:** reward based on objectively checkable outcomes — key enabling technique for agentic RL at scale

## Post-Training Context

Agentic RL is a [[03-RESOURCES/concepts/llm-ml-foundations/post-training-llm]] technique applied after supervised fine-tuning (SFT). It produces agents that:
- Invoke tools only when necessary
- Follow state-dependent conditional plans
- Recover from user misleads and error states
- Generalize across domains not seen in training (solid generalization from AgenticQwen results)

## Prior Work Referenced

- **ReAct** (Yao et al.) — reasoning + acting framework
- **SynthAgent** — synthetic agentic data framework used as base for AgenticQwen agentic RL data
- **GRPO** (Shao et al.) — optimizer

## Synthetic Environments at Scale

A diversidade de ambientes é o gargalo principal do agentic RL. [[03-RESOURCES/concepts/llm-ml-foundations/synthetic-data-for-agents]] consolida as abordagens; o estado da arte para produtividade de longa duração é [[03-RESOURCES/sources/ml-research-papers/synthetic-computers-at-scale-microsoft]] (Microsoft, 2026): 1.000 computadores sintéticos gerados via persona → perfil → filesystem → artefatos; cada simulação >8h runtime, >2.000 turnos. Occupation skills extraídas de 900 simulações melhoram o agente de 61.6% para 68.6% em 100 computadores held-out (ganha em 83/100). Isso endereça diretamente o problema de "environment diversity" documentado nesta página.

RL Conductor (Sakana AI, 2026): extend agentic RL ao nível de meta-coordenação — treina um 7B para orquestrar workers maiores via GRPO, descobrindo topologias de coordenação end-to-end. Ver [[03-RESOURCES/concepts/agent-systems/rl-conductor-orchestration]].

## Harness-1: RL sobre Estado Explícito (UIUC, 2026)

[[03-RESOURCES/sources/ml-research-papers/harness-1-rl-search-agents]] (arXiv:2606.02373) introduz uma distinção crítica para agentic RL: **o que o RL deve aprender vs. o que o ambiente deve manter**.

**Problema identificado:** treinar search agents como policies sobre transcripts crescentes força o RL a otimizar bookkeeping recuperável junto com raciocínio semântico. Hard queries produzem rollouts com rewards quase idênticos (curated set vazio); reward terminal não revela se a falha foi bad search, forgotten evidence, missing verification, ou poor curation.

**Solução (stateful cognitive offloading):**
- Policy aprende: o que buscar, quais documentos promover, o que verificar, quando parar
- Harness mantém: candidate pool, importance-tagged curated set, evidence graph, verification records, compression/dedup, budget markers

**Resultado empírico (8 benchmarks de retrieval):**
- 20B model + stateful harness = 0.730 avg curated recall
- Supera Context-1 (20B) por +11.4 pts; supera GPT-5.4, Sonnet-4.6, Kimi-K2.5
- Usa apenas 4.352 itens de treino únicos (vs. 221K do Search-R1)

**Transferência:** ganhos são 2.2× maiores nos benchmarks *held-out* (+17.0 pts) do que nos source-family (+7.9 pts). A policy aprende operações domain-general sobre estado explícito.

**Requisito crítico para RL:** sem diversity-preserving reward, a policy colapsa para search-only em poucos steps. Confirma o challenge #4 documentado nesta página: reward design deve incluir incentivos explícitos para o ritmo search → curate → verify.

**Warm-started curation como curriculum implícito:** auto-seed do curated set com top-8 documentos do primeiro search muda a task de "construção do zero" para "refinamento" — resolve o problema de sparse rewards em early rollouts (relacionado ao challenge #2).

## Related: AEvo (Inference-Time Mechanism Evolution)

[[03-RESOURCES/concepts/pkm-obsidian/aevo-meta-editing-evolution]] (arXiv:2605.13821) is often conflated with agentic RL but is distinct: AEvo operates at inference time, editing evolution procedures and agent contexts through a meta-agent + harness loop. It does not update model weights. The relation: agentic RL trains a model to behave better; AEvo evolves the *environment* in which a model operates. Both improve long-horizon agent performance but at different levels.

## Vault Connections

- [[03-RESOURCES/concepts/ai-strategy-org/dual-data-flywheel]] — curriculum that makes agentic RL scale
- [[03-RESOURCES/concepts/agent-systems/behavior-tree-expansion]] — task generation mechanism for agentic RL
- [[03-RESOURCES/concepts/llm-ml-foundations/post-training-llm]] — broader post-training landscape
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — what well-trained agentic models enable
- [[03-RESOURCES/concepts/llm-ml-foundations/horizon-length]] — independent training bottleneck from action sequence length
- [[03-RESOURCES/concepts/llm-ml-foundations/horizon-reduction]] — macro actions + subgoal decomposition to stabilize RL
- [[03-RESOURCES/concepts/llm-ml-foundations/credit-assignment]] — why negative advantage degrades at long horizons
- [[03-RESOURCES/entities/AgenticQwen]] — reference implementation
- [[03-RESOURCES/entities/NVIDIA]] — also uses agentic RL (Nemotron 3 Super on OpenHands + terminal)
- [[03-RESOURCES/entities/Microsoft-Research-Asia]] — funded horizon-length empirical study
- [[03-RESOURCES/sources/ml-research-papers/clipping-agenticqwen-small-agentic-llm-dual-flywheels]] — AgenticQwen paper
- [[03-RESOURCES/sources/ml-research-papers/training-llms-long-horizon-tasks-empirical-study]] — horizon-length study (Kim et al. 2026)
- [[03-RESOURCES/sources/ml-research-papers/harness-1-rl-search-agents]] — Harness-1: state-externalizing harness + RL (UIUC 2026)

## Evidências

- **[2026-06-21]** Tratar uma trajetória agêntica como um único token sequence crescente (visão padrão em RL) é inadequado — torna a evolução de contexto rígida e cria mismatch de representação entre rollout e treino. Agent-R1 propõe representação step-lev... — [[agent-r1-a-unified-and-modular-framework-for-agentic-reinforcement-learning]]
- **[2026-06-24]** Today we're open-sourcing `renderers`, a standalone Python library that gives developers full contro — [[renderers-token-level-templating-for-agentic-rl]]
- **[2026-06-24]** Today we are releasing prime-rl version 0. — [[rl-at-1t-scale-prime-rl-performance-deep-dive]]

## Perspectivas

- **[2026-06-21]** Tabela comparativa de 6 frameworks de RL agêntico (veRL, slime, Agent Lightning, AReaL, rLLM, Agent-R1) funciona como mapa de estado-da-arte para escolha de infraestrutura. — [[agent-r1-a-unified-and-modular-framework-for-agentic-reinforcement-learning]]
