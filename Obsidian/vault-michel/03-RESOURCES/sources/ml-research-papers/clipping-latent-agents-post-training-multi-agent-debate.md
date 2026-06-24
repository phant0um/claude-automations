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
triagem_score: 9
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

- [[03-RESOURCES/concepts/agent-systems/internalized-multi-agent-debate]] — conceito IMAD
- [[03-RESOURCES/concepts/llm-ml-foundations/activation-steering]] — steering vectors / CAA
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — contexto de multi-agent systems
- [[03-RESOURCES/concepts/llm-ml-foundations/post-training-llm]] — SFT + GRPO pipeline
- [[03-RESOURCES/entities/qwen]] — Qwen 2.5 7B testado como base model

## Por que a internalização cria subspaces interpretáveis

O achado mais surpreendente do paper não é a eficiência de tokens — é a estrutura interna que emerge. Após IMAD, o modelo desenvolve direções linearmente separáveis no espaço de ativação correspondendo a diferentes personas de agente. Isso sugere que o fine-tuning com estrutura de debate força o modelo a organizar seu espaço de representação de forma mais modular do que o treinamento convencional.

A separabilidade linear das personas tem implicações para interpretabilidade: é possível extrair vetores de direção para cada "agente interno" e manipulá-los diretamente via steering. O Agente 3 (Program-of-Thought) mostra a maior separação — raciocínio estilo código cria representações mais distintas do que raciocínio em linguagem natural, provavelmente porque código tem estrutura sintática mais rígida que o modelo aprende a sinalizar.

## O trade-off SFT→RL e a annealing strategy

A estratégia de annealing duplo (format reward decaindo + token limit diminuindo) é o mecanismo central que força a internalização. Sem ele, o modelo aprenderia a produzir debates verbosos com tags estruturadas — útil, mas não eficiente. Com o annealing:

1. O format reward começa alto → o modelo aprende a usar as tags (`<|Agent 1|>`, etc.)
2. O format reward decai → as tags se tornam menos necessárias para o reward
3. O token limit diminui → a única estratégia viável é comprimir o debate para representação latente

A sequência força uma transição de "expressar o debate" para "pensar o debate" — análogo à diferença entre escrever os passos de uma divisão longa em papel e fazer mentalmente. O modelo que completou o treinamento IMAD ainda "sabe" como estruturar um debate (como demonstrado pelo steering), mas não precisa mais explicitá-lo para produzir outputs corretos.

## Limitações de escala e generalização

A avaliação usa apenas problemas aritméticos (GSM8K) com 3 agentes e 2 rounds. Debates mais complexos — com mais agentes, mais rounds, ou sobre tarefas não-matemáticas — podem requerer datasets de SFT maiores para aprender a estrutura correta. A generalização para MMLU-Pro e BBH (tarefas de raciocínio geral) é encorajadora, mas a generalização para tarefas muito diferentes do domínio de treino não está estabelecida.
