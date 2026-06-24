---
title: "On Training Large Language Models for Long-Horizon Tasks: An Empirical Study of Horizon Length"
type: source
source_file: "clippings/On Training Large Language Models for Long-Horizon Tasks An Empirical Study of Horizon Length.md"
source_url: "https://arxiv.org/html/2605.02572v1"
author: "Sunghwan Kim, Junhee Cho, Beong-woo Kwak, Taeyoon Kwon, Liang Wang, Nan Yang, Xingxing Zhang, Furu Wei, Jinyoung Yeo"
ingested: 2026-05-09
tags: [source, long-horizon, RL, agent-training, horizon-length, post-training, reinforce, grpo, llm-agents]
triagem_score: 10
---

# On Training LLMs for Long-Horizon Tasks: An Empirical Study of Horizon Length

**Authors:** Sunghwan Kim, Junhee Cho, Beong-woo Kwak, Taeyoon Kwon, Liang Wang, Nan Yang, Xingxing Zhang, Furu Wei, Jinyoung Yeo
**Affiliation:** Supported by [[03-RESOURCES/entities/Microsoft-Research-Asia]] + Korea MSIT/IITP
**ArXiv:** https://arxiv.org/html/2605.02572v1

## Abstract

LLMs deployed as interactive agents face a poorly understood bottleneck: **horizon length itself** — independent of reasoning complexity — destabilizes RL training. Through controlled experiments on Sudoku and Rush Hour (text-based games), the authors isolate goal distance from solving difficulty, demonstrating that increasing action-sequence length alone causes catastrophic collapse. They identify **horizon reduction** (via macro actions or subgoal decomposition) as the key mitigation, and discover **horizon generalization**: models trained on shorter horizons transfer effectively to unseen longer horizons at inference time.

## Key Findings

### 1. Horizon Length is an Independent Training Bottleneck
Training on tasks with goal distance L3–L4 (21–30 atomic actions) causes severe instability and policy collapse even when the underlying reasoning complexity is held constant. The collapse manifests as a spike in maximum-length response ratio — the policy degenerates into incoherent or runaway generations. This bottleneck persists across model scales (1.7B and 4B) and optimizers (REINFORCE and GRPO), showing it is structural, not incidental. See [[03-RESOURCES/concepts/llm-ml-foundations/horizon-length]].

### 2. Two Root Causes: Exploration Difficulty + Credit Assignment Noise
- **Exploration:** state-action space grows exponentially with horizon; probability of stumbling onto an optimal trajectory decays exponentially.
- **Credit assignment:** under sparse rewards, failed trajectories assign negative advantage to all steps — including individually correct ones. Negative advantage diffuses probability mass across the entire vocabulary (~10^5 tokens), injecting noise into every gradient update. See [[03-RESOURCES/concepts/llm-ml-foundations/credit-assignment]].

### 3. Horizon Reduction Stabilizes Training
[[03-RESOURCES/concepts/llm-ml-foundations/horizon-reduction]] addresses the root cause rather than patching symptoms. Two mechanisms:
- **Macro actions:** compose multiple atomic actions into one step (e.g., fill multiple Sudoku cells per turn, move a Rush Hour car N cells at once). Reduces effective horizon $h_\pi(s_0, g)$ into the stable regime.
- **Subgoal decomposition:** segment the global goal into verifiable intermediate goals; compute return $G_t$ independently per segment. Equivalent to dense reward / process reward models.
Flexible macro actions (dynamic length bounded by $k$) outperform fixed-length macros because rigidity causes overshooting.

### 4. Horizon Generalization
Models trained on moderate goal distances (L1–L4) generalize to unseen longer horizons (L5–L7) at inference time. Performance gap over baselines grows with horizon length — not shrinks. Mechanism: horizon reduction improves per-step accuracy, and higher step accuracy compounds multiplicatively over long rollouts, enabling out-of-distribution horizon success.

### 5. Curriculum via Horizon Generalization
Training directly on goal distance 10–12 yields near-zero improvement (no positive learning signal to bootstrap). But first training on d=4–9, then fine-tuning on d=10–12 yields strong performance. Horizon generalization enables curriculum: short-horizon competence is a prerequisite for long-horizon capability.

## Methodology

- **Base model:** Qwen3-1.7B (SFT then RL)
- **SFT:** expert trajectories from GPT-5-mini / Qwen3-32B; conservative lr 5e-6 to preserve exploration capacity
- **RL:** REINFORCE with off-policy correction (masked IS + truncated IS); no KL penalty; discount γ=0.995
- **Reward:** trajectory-level sparse reward + step-level format/validity penalty (α=0.2)
- **Environments:** Sudoku (horizon = empty cells), Rush Hour (horizon = min moves), WebShop (web interaction)
- **Infrastructure:** rllm v0.2 + verl v0.5.0; 4×A100 + 4×A6000; 1–3 days per run
- **Key fix:** strict Tokens-In/Tokens-Out pipeline to avoid retokenization mismatch → prevents policy collapse in multi-turn RL

## Takeaways for Practitioners

1. **Design action spaces before tuning RL algorithms.** Horizon-aware action abstraction (code generation, API calls, macro moves) is the cheapest fix for training instability.
2. **SFT initialization is required.** From-scratch RL leads to reward hacking (e.g., generating candidate sets instead of filling cells). SFT provides behavioral priors.
3. **Process rewards / subgoal decomposition are horizon reduction in disguise.** The benefit is not richer feedback per se — it is shorter effective horizon per credit assignment window.
4. **Retokenization is a silent killer.** Token-level consistency between inference (vLLM) and training (FSDP) is non-negotiable for multi-turn RL stability.

## Connections

- [[03-RESOURCES/concepts/agent-systems/agentic-rl]] — this paper adds horizon-length analysis; update with instability findings
- [[03-RESOURCES/concepts/llm-ml-foundations/horizon-length]] — new concept extracted from this paper
- [[03-RESOURCES/concepts/llm-ml-foundations/horizon-reduction]] — new concept: macro actions + subgoal decomposition
- [[03-RESOURCES/concepts/llm-ml-foundations/credit-assignment]] — new concept: sparse reward + negative advantage dynamics
- [[03-RESOURCES/concepts/llm-ml-foundations/post-training-llm]] — SFT → RL pipeline described here
- [[03-RESOURCES/entities/Microsoft-Research-Asia]] — funding/affiliation
