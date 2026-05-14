---
title: "Self-Improving Pretraining: Using Post-Trained Models to Pretrain Better Models"
type: source
source_file: "Clippings/Self-Improving Pretraining using post-trained models to pretrain better models.md"
source_url: "https://arxiv.org/html/2601.21343v3"
authors: ["Ellen Xiaoqing Tan", "Jack Lanchantin", "Shehzaad Dhuliawala", "Danwei Li", "Thao Nguyen", "Jing Xu", "Ping Yu", "Ilia Kulikov", "Sainbayar Sukhbaatar", "Jason Weston", "Xian Li", "Olga Golovneva"]
institutions: ["Meta AI"]
created: 2026-05-14
updated: 2026-05-14
tags: [source, pretraining, self-improvement, meta-ai, rl, post-training, safety, factuality, theta-engineering]
---

# Self-Improving Pretraining (Meta AI)

## Core Idea

Standard LLM training has a **stage separation problem**: safety, factuality, and reasoning are added at post-training, but pretraining patterns already deeply shape capabilities. This paper introduces **Self-Improving Pretraining** — using a strong post-trained model to improve the pretraining stage itself.

This is a **θ-engineering loop**: a post-trained model rewrites pretraining data and judges policy rollouts, so the θ-update (pretraining) incorporates behaviors normally only added at post-training time.

## Two Components

### 1. RL-Based Pretraining (Section 1)
Replace next-token prediction with a sequence generation + RL loop:
- Stream pretraining data; split into prefix + suffix (N=128 tokens)
- A strong post-trained model serves as **rewriter** (improves suffix quality/safety) and **judge** (scores rollouts, original suffix, and rewrite)
- Early training: relies on suffix and rewrite (policy rollouts are low quality)
- Later training: RL rewards high-quality policy rollouts → judge selects them as DPO "chosen"
- Training algorithm: **Online DPO** (chosen = highest-scoring completion, rejected = lowest)

### 2. Thinking Mid-Training (Section 2)
Intermediate stage between pretraining and post-training:
- Augments pretraining data with interleaved reasoning traces
- Uses SFT + RL with a judge to optimize the usefulness of inserted thoughts
- Teaches the model to reason earlier in its development

## Key Results (Continued Pretraining, Llama2 1.4B)

| Objective | Win Rate vs. Baseline | Improvement |
|-----------|----------------------|-------------|
| Quality | 86.3% | +37.3 pts |
| Factuality (FActScore avg) | 57.6 vs. 42.3 | +36.2% relative |
| Safety (avg) | 91.1 vs. 76.9 | +18.5% relative |

From-scratch pretraining: quality win rate 32.4% vs. baseline 1.3%; safety 97.5 vs. 85.2.

Self-Improving Pretraining 1.4B model **outperforms Llama-3.1 8B base** on safety+quality — not a distillation effect.

## Technical Setup

- **Policy model**: Llama2 1.4B (continual pretraining from checkpoint)
- **Judge models**: Fine-tuned Llama3.1-8B-Instruct (trained with GRPO) or GPT-OSS-120B (prompted)
- **Datasets**: SlimPajama (quality/factuality), RedPajama filtered for unsafe (safety)
- **Training**: Online DPO, 64 GPUs, 2000 steps continual / 21,000 from scratch

## Key Ablations

- 16 rollouts >> 1 rollout (consistently across quality, factuality, safety)
- Online DPO >> RF-NLL >> SFT on rewrites >> SFT on single rollout (collapses)
- GPT-OSS-120B judge >> fine-tuned Llama judge, but gap is small (fine-tuned Llama is viable)
- Rewriter necessary only for safety (model refuses to rewrite unsafe prompts without fine-tuning)

## Connection to C/θ Distinction

This paper is a direct example of **θ-engineering** that operationalizes the consolidation channel described in [[03-RESOURCES/sources/contextual-agentic-memory-is-a-memo]]. The post-trained model acts as the "neocortical teacher" that informs weight updates during pretraining — exactly the direction the memory paper calls for.

## Relations

- [[03-RESOURCES/entities/Meta-AI]] — institution
- [[03-RESOURCES/concepts/post-training-llm]] — the technique being moved upstream
- [[03-RESOURCES/concepts/self-evolving-agents]] — related θ-loop pattern
- [[03-RESOURCES/concepts/weak-to-strong-generalization]] — using a stronger model to supervise a weaker one
- [[03-RESOURCES/concepts/reward-hacking]] — online DPO avoids collapse via judge-selected pairs
- [[03-RESOURCES/sources/contextual-agentic-memory-is-a-memo]] — companion paper on θ vs. C distinction
