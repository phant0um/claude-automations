---
title: RL Training for LLMs
type: concept
created: 2026-05-19
updated: 2026-05-19
tags: [ai-agents, rl, training, llm, cluster]
aliases: [rlvr, llm-rl, post-pretraining-rl]
status: aggregator
---

# RL Training for LLMs

Cluster sobre **RL pós-pretraining** em LLMs. Foco: scaling laws, continual learning, rubric rewards.

## Tese central

Pretraining cobre conhecimento; RL pós-treina alinhamento, preferência e comportamento multi-step. Mas RL em LLM tem **scaling distinto** do supervised: rewards esparsas, exploração custosa, e drift de capacidade (catastrophic forgetting).

## Três frentes ativas

### 1. RL Scaling Laws
- Compute → reward curve não-linear; **plateaus** existem
- **RLVR** (Verifiable Rewards): math, code, lógica — reward = correctness
- **STaR**, **InstructZero**: bootstrap de rationales para domínios sem ground truth
- Sample efficiency cai com tamanho do modelo (vs SFT scaling)
- Ver: [[03-RESOURCES/sources/ml-research-papers/rl-scaling-laws-for-llms]]

### 2. Continual Learning + RL
- Sequência de RL stages causa **catastrophic forgetting** de capacidades antigas
- **Replay buffers** + **compartmentalization** (LoRA isolado, MoE experts) mitigam
- Trade-off plasticidade vs estabilidade central
- Ver: [[03-RESOURCES/sources/ml-research-papers/continual-learning-with-rl-for-llms]]

### 3. Rubric-Based Rewards (não-verificáveis)
- Domínios sem ground truth (writing, dialogue, design): rubric LLM-judge como oracle
- Rubric estruturada > preferência binária (DPO falha em nuance)
- Risco: rubric herda bias do judge model
- Conexão com [[03-RESOURCES/concepts/agent-systems/agent-eval-framework]] (mesmo conceito de LLM-as-judge)
- Ver: [[03-RESOURCES/sources/ml-research-papers/rubric-based-rewards-for-rl]]

## Fontes agregadas

- [[03-RESOURCES/sources/ml-research-papers/rl-scaling-laws-for-llms]] (9) — scaling
- [[03-RESOURCES/sources/ml-research-papers/continual-learning-with-rl-for-llms]] (9) — forgetting
- [[03-RESOURCES/sources/ml-research-papers/rubric-based-rewards-for-rl]] (8) — non-verifiable

## Conceitos relacionados

- [[03-RESOURCES/concepts/agent-systems/agentic-rl]] — RL aplicado em loop de agente
- [[03-RESOURCES/concepts/agent-systems/agent-eval-framework]] — eval compartilha rubric pattern
- [[03-RESOURCES/concepts/llm-ml-foundations/activation-steering]] — alt ao RL para alignment fino

## Debate RLVR — Frontier vs. Base Support (Primer 2026)

Peking University/Tsinghua/Qiyuan Tech (2606.02113) formalizam o debate:

- **Posição conservadora** (Yue et al. 2025, Wu et al. 2026): RLVR atual aguça trajetórias já acessíveis à política base — não expande a fronteira.
- **Contra-literatura:** ProRL (Liu et al. 2025) estende comprimento de horizonte; RL-PLUS (Dong et al. 2026) injeta rollouts externos; CoT-Pass@K (Wen et al. 2025) muda a métrica; PASS@(k,T) (Zhai et al. 2026) adiciona profundidade de interação.

"RL expande capacidade" não é claim escalar — especifica qual fechamento foi quebrado.

**Decomposição scaling (Tan et al. 2026):** D_total = D_unique × τ. O que importa é se exemplos caem dentro da banda produtora de gradients para um dado modelo base.

Ver [[03-RESOURCES/sources/primer-post-training-reasoning-data]].

## Open questions

- Quando RLVR satura? Existe um ponto onde mais compute em RL deixa de pagar?
- Continual RL escalável? Métodos atuais funcionam até ~3 stages, depois colapsam
- Rubric judge consistency entre rodadas (test-retest reliability)
