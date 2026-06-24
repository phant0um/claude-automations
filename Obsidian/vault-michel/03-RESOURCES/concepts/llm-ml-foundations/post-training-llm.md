---
title: "Post-Training LLM"
type: concept
status: developing
created: 2026-05-01
updated: 2026-05-01
tags: [concept, llm, training, rlhf, sft, grpo]
---

# Post-Training LLM

**Definição:** Etapa de treinamento que ocorre após o pre-training (next-token prediction em trilhões de tokens) e transforma um modelo base em um assistente útil, honesto e seguro. Inclui SFT, RLHF/GRPO e variantes.

## Estágios do Post-Training

```
Pre-training    →  base model (próximo token)
     ↓
SFT             →  instrução-seguimento básico
     ↓
RLHF / GRPO     →  alinhamento com preferências humanas + objetivo específico
     ↓
Quantization    →  model deployável (FP8, INT4, NVFP4)
```

## GRPO (Group Relative Policy Optimization)

Variante de RLHF que evita o modelo de reward separado. Compara grupos de saídas e otimiza relativamente:

```python
# Pseudocódigo GRPO
samples = model.generate(prompt, n=8)
rewards = reward_fn(samples)
baseline = mean(rewards)
policy_loss = -mean((rewards - baseline) * log_probs)
```

**Vantagem:** sem reward model separado → menos instabilidade de treinamento, menor custo.

## Gated Reward (Perplexity)

[[03-RESOURCES/entities/Perplexity-AI]] introduziu reward function multiplicativa para post-training em factualidade:

```
R(τ) = r_base · s − pen_eff
```

- `s` é um **gate**: se factualidade baixa, multiplica por quase zero → zera reward
- Previne que o modelo aprenda a ser eficiente mas impreciso ([[03-RESOURCES/concepts/llm-ml-foundations/reward-hacking]])
- Resultado: Qwen3.5-397B em 73.9% FRAMES, superando GPT-5.4 (67.8%) com 4x menos custo

## Post-Training para Agentic Capabilities

[[03-RESOURCES/entities/NVIDIA]] (Nemotron 3 Super) usou RL em ambientes agenticos:
- OpenHands (software engineering)
- Terminal use (bash, filesystem)
- General tool use (web, API calls)

Resultado: 120B model com capacidades agenticas nativas — não precisam de prompting extensivo para multi-step tool use.

[[03-RESOURCES/entities/AgenticQwen]] (Alibaba) aplica multi-round GRPO em modelos pequenos (8B e 30B-A3B MoE):
- Dois tracks: reasoning RL + [[03-RESOURCES/concepts/agent-systems/agentic-rl]]
- [[03-RESOURCES/concepts/ai-strategy-org/dual-data-flywheel]] como curriculum automático de dificuldade crescente
- Resultado: AgenticQwen-8B mais que dobra Qwen3-8B vanilla; aproxima desempenho do modelo 235B com fração do custo

## Distilação e Transfer

[[03-RESOURCES/concepts/llm-ml-foundations/memory-transfer-learning]] mostrou que **insight memories** (meta-conhecimento task-agnostic) transferem cross-model. Implicação: post-training em tarefas específicas pode ser parcialmente substituído por injeção de memories de modelos mais fortes.

## IMAD: SFT + GRPO para Internalizar Debate Multi-Agente

Yi, Mueller e Lee (2026) aplicaram SFT+GRPO para destillar multi-agent debate em um único LLM — [[03-RESOURCES/concepts/agent-systems/internalized-multi-agent-debate]]. O reward schedule combina:

- **Format reward** decrescente (remove incentivo de verbalizar debate)
- **Correctness + length-clipping reward** com annealing 2000→500 tokens

Resultado: modelo conduz debate na latent space, usa 6–21% dos tokens do debate explícito. Cria **agent subspaces** identificáveis via [[03-RESOURCES/concepts/llm-ml-foundations/activation-steering]] — aplicação direta de GRPO para interpretabilidade e safety.

## Self-Improving Pretraining (Meta AI, 2026)

Meta propõe mover post-training techniques para **dentro do pretraining** — um θ-loop mais cedo no pipeline.

Usa um modelo post-trained forte como:
1. **Suffix Rewriter**: melhora qualidade/safety dos suffixes no streaming data
2. **Suffix Judge**: avalia rollouts, original suffix e rewrite via Online DPO

Resultados (Llama2 1.4B continued pretraining):
- Quality: 86.3% win rate vs. standard pretraining
- Factuality: +36.2% relativo
- Safety: +18.5% relativo
- 1.4B com Self-Improving Pretraining supera Llama-3.1 8B base em safety+quality

Conexão com [[03-RESOURCES/concepts/ai-strategy-org/c-theta-engineering]]: é um exemplo de θ-engineering aplicado mais cedo, usando conhecimento do modelo post-trained para informar weight updates do pretraining.

Ver [[03-RESOURCES/sources/ml-research-papers/self-improving-pretraining-meta]].

## Post-Training Attribution Framework (Primer 2026)

Peking University/Tsinghua/Qiyuan Tech sintetizaram 150+ estudos e propõem organizar o campo em 4 perguntas: que objetos de dados existem, o que os torna úteis, como são construídos, e como seus ganhos escalam.

A **unidade reutilizável não é um par prompt–resposta** mas uma interface de feedback portando verificador. Implicação: ganhos de post-training só são atribuíveis quando suporte de prompt, teacher de trace, substrato de busca, âncora de self-play, verificador, scaffold e orçamento de inferência são declarados. O otimizador visível (GRPO, RLVR, DAPO) é a camada errada de comparação.

Decomposição de scaling: A (ceiling alcançável) vs. B/k (eficiência de aproximação). Debate RLVR: Yue et al. (2025) leem RLVR como aguçamento de trajetórias já suportadas pela base; contra-literatura (ProRL, RL-PLUS) relaxa diferentes fechamentos.

Ver [[03-RESOURCES/sources/primer-post-training-reasoning-data]].

## Relacionado

- [[03-RESOURCES/concepts/llm-ml-foundations/reward-hacking]] — gated reward como defesa
- [[03-RESOURCES/concepts/llm-ml-foundations/weak-to-strong-generalization]] — usar modelos fracos para supervisionar fortes
- [[03-RESOURCES/concepts/llm-ml-foundations/model-quantization]] — etapa após post-training para deploy eficiente
- [[03-RESOURCES/concepts/ai-strategy-org/c-theta-engineering]] — distinção C vs θ; self-improving pretraining é θ-loop
- [[03-RESOURCES/entities/Perplexity-AI]] — gated GRPO para factualidade
- [[03-RESOURCES/entities/NVIDIA]] — RL agentico para Nemotron 3 Super
- [[03-RESOURCES/entities/Meta-AI]] — Self-Improving Pretraining
