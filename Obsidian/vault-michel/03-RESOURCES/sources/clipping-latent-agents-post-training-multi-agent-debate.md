---
title: "Latent Agents: A Post-Training Procedure for Internalized Multi-Agent Debate"
type: source
category: ai-agents
source_type: paper
created: 2026-05-05
tags: [ai-agents, multi-agent-debate, post-training, internalized-reasoning, activation-steering, llm-safety]
arxiv: "https://arxiv.org/html/2604.24881v1"
authors: [John Seon Keun Yi, Aaron Mueller, Dokyun Lee]
affiliation: Boston University
---

# Latent Agents: A Post-Training Procedure for Internalized Multi-Agent Debate

**Authors:** John Seon Keun Yi, Aaron Mueller, Dokyun Lee — Boston University

**Paper:** arxiv.org/html/2604.24881v1

## Core Claim

Multi-agent debate improves LLM reasoning but is compute-intensive. IMAD (Internalized Multi-Agent Debate) distills debate into a single LLM via a two-stage fine-tuning pipeline (SFT + GRPO), achieving comparable or better performance with up to 93% fewer tokens.

## Method: IMAD Pipeline

### Stage 1 — Debate Dataset Collection

- 3 GPT-3.5-turbo agents, 2 rounds, majority vote, arithmetic problems
- 944 debate traces with structure tags: `<|Agent 1|>`, `<|Round 1|>`, `<|Consensus|>`, `<|endofdebate|>`
- Tags are crucial — without them, agent subspace separation degrades

### Stage 2 — Supervised Fine-Tuning (Structure Learning)

- Trains single LLM on full debate transcripts (not just final answers)
- Model learns to autonomously generate a complete structured debate from a query
- Contrast with DebateGPT: training on full traces vs. only final responses is key

### Stage 3 — Reinforcement Learning for Internalization (GRPO)

Reward function: `r(x,y) = w_fmt * R^fmt + w_clip * R(y;l)`

- **Format reward** (`R^fmt`): positive if structure tags present; weight decays toward 0 during training
- **Correctness + length-clipping reward** (`R(y;l)`): 1 if correct answer appears within first `l` tokens; `l` anneals from 2000→500
- The interplay forces internalization: as format reward decays and token limit shrinks, the only viable strategy is implicit latent-space reasoning

## Results

| Model | IMAD vs Debate (GSM8K) | Token Usage (% of Debate) |
|---|---|---|
| LLaMA-3.1 8B | +2.17pp | 6.3–11.2% |
| Qwen 2.5 7B | -1.7pp (comparable) | 7.2–16.8% |
| Mistral Nemo 12B | +18.97pp | 6.5–21.1% |

IMAD uses 6–21% of explicit Debate's tokens while matching or exceeding its accuracy. Generalizes to MMLU-Pro and BBH despite training only on arithmetic.

## Agent Subspaces: Mechanistic Finding

After IMAD, the model develops **linearly separable directions** in activation space corresponding to different agent personas:

- Extracted via **Contrastive Activation Addition (CAA)** / difference-in-means
- Three personas: Chain-of-Thought (Agent 1), Self-Critique (Agent 2), Program-of-Thought (Agent 3)
- Steered IMAD shows 15.41% average improvement in ROUGE-L faithfulness over base model
- Agent 3 (PoT) shows largest separation (21–25% improvement) — code-like reasoning creates most distinct representations
- Steering effective at coefficients as low as α=0.5

## Behavioral Control Application

IMAD enables cleaner suppression of malicious traits via negative activation steering:

- **Evil trait**: IMAD achieves complete suppression (score→0) at α=-3.0 to -5.0; base model retains residual at α=-5.0
- **Hallucination trait**: both models show partial suppression (trait is more distributed); IMAD preserves task performance while base model collapses
- IMAD maintains stable GSM8K accuracy across full steering range (−5.0 to +5.0); base model degrades catastrophically
- Safety implication: internalization makes discrete persona-like behaviors easier to localize and remove than fundamental generation tendencies

## Key Insight

Internalizing multi-agent debate into a single LLM via SFT+RL not only matches external debate efficiency — it creates structured, interpretable agent subspaces in activation space that enable cleaner behavioral control than in base models.

## Limitations

- Dataset limited to arithmetic problems, 3-agent / 2-round format
- Internalization quality depends on successful SFT structure learning (LLaMA reliable; other models occasionally failed)
- Benefits most pronounced for 7B+ parameter models
- LLM-based evaluation for trait expression may introduce bias (human-LLM agreement reported as close in Appendix Q)

## Relacionado

- [[03-RESOURCES/concepts/internalized-multi-agent-debate]] — conceito IMAD
- [[03-RESOURCES/concepts/activation-steering]] — steering vectors / CAA
- [[03-RESOURCES/concepts/multi-agent-orchestration]] — contexto de multi-agent systems
- [[03-RESOURCES/concepts/post-training-llm]] — SFT + GRPO pipeline
- [[03-RESOURCES/entities/qwen]] — Qwen 2.5 7B testado como base model
