---
title: "Learning to Orchestrate Agents in Natural Language with the Conductor"
type: source
source_file: "Clippings/Learning to Orchestrate Agents in Natural Language with the Conductor.md"
url: "https://arxiv.org/html/2512.04388v5"
authors: [Stefan Nielsen, Edoardo Cetin, Peter Schwendeman, Qi Sun, Jinglue Xu, Yujin Tang]
org: Sakana AI
created: 2026-05-14
updated: 2026-05-14
tags: [source, multi-agent, reinforcement-learning, orchestration, sakana-ai, grpo, test-time-scaling]
triagem_score: 9
---

# Conductor: RL-Trained Orchestrator for LLM Pools

## Core Contribution

A 7B language model (the Conductor) is trained via reinforcement learning (GRPO) to dynamically design agentic workflows — dividing problems, delegating subtasks, and specifying communication topologies — over pools of much larger frontier LLMs. The key finding: a small model trained end-to-end with RL as a meta-orchestrator outperforms any individual worker and all prior hand-designed multi-agent baselines.

## Method

- **Base model**: Qwen2.5-7B
- **Algorithm**: GRPO — no KL regularization, 200 iterations, batch size 256
- **Output format**: three Python lists (subtasks, worker IDs, access lists) parsed from chain-of-thought
- **Worker pool**: Gemini-2.5-Pro, Claude-Sonnet-4, GPT-5, DeepSeek-R1-Distill-Qwen-32B, Gemma3-27B, Qwen3-32B
- **Training data**: 960 problems across MATH, MMLU, RLPR, LiveCodeBench-v1
- **Reward**: format correctness (0 or penalized) + workflow correctness (0.5 or 1.0)
- **Compute**: 2x NVIDIA H100 80GB

### Key Design Choices

- Conductor specifies workflows in **natural language** — no predefined topologies, full specification freedom
- Up to 5-step workflows; Conductor learns to use avg ~3 steps (self-regulating efficiency)
- Few-shot examples from **out-of-domain tasks** improve performance more than in-domain examples (OOD prevents exploitation, incentivizes strategy exploration)

### Extensions

1. **Adaptive worker selection**: finetuned with randomized k-model subsets to generalize to arbitrary agent pools (open-only, closed-only, mixed)
2. **Recursive topologies**: Conductor can assign itself as a worker, enabling iterative self-revision and a new axis of test-time scaling

## Key Results

| Benchmark | Best Individual Model | Conductor |
|-----------|----------------------|-----------|
| MATH500 | 96.0 (Claude/Gemini) | **99.4** |
| MMLU | 93.5 (GPT-5) | **94.1** |
| LiveCodeBench | 82.90 (GPT-5) | **83.93** |
| AIME25 | 90.8 (GPT-5) | **93.3** |
| GPQA-Diamond | 84.8 (Gemini) | **87.5** |
| BigCodeBench | 35.8 (Claude) | **37.8** |
| **Average** | 74.78 (GPT-5) | **77.27** |

- Conductor-Recursive improves BigCodeBench further to **40.0** and GPQA to **82.32**
- On MMLU efficiency: Conductor achieves 93.14% at avg cost $0.009/sample vs Claude 5x consensus at 91.0% for $0.0211 — **~2.3x cheaper for higher quality**
- Conductor uses ~1,820 tokens/sample vs MoA's 11,203 while beating MoA by ~10 points

### Emergent Behaviors Observed

- Task-difficulty adaptivity: allocates 2 steps for MMLU, 3-4 for LiveCodeBench
- Planner/writer role specialization (e.g., Gemini+Claude as planners, GPT-5 as final coder)
- Verification rounds emerge without being explicitly trained
- Model-scale matters for prompt engineering: 7B outperforms 3B not by agent selection but via better prompt engineering of subtasks

## Implications for Vault

- Validates [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] at SOTA scale with RL training instead of manual design
- Extends [[03-RESOURCES/concepts/agent-systems/agentic-rl]] to the meta-agent coordination domain
- Provides a new mechanism for [[03-RESOURCES/concepts/llm-ml-foundations/test-time-scaling]]: recursive calling as compute axis
- Demonstrates that "small model as orchestrator > large model self-orchestration" principle

## Connections

- [[03-RESOURCES/concepts/agent-systems/rl-conductor-orchestration]] — concept page for this pattern
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — existing orchestration patterns
- [[03-RESOURCES/concepts/agent-systems/agentic-rl]] — GRPO and RL-trained agents
- [[03-RESOURCES/concepts/llm-ml-foundations/test-time-scaling]] — recursive topology as new axis
- [[03-RESOURCES/concepts/llm-ml-foundations/post-training-llm]] — GRPO training paradigm
- [[03-RESOURCES/entities/Sakana-AI]] — authoring lab

---

## Por que um modelo de 7B supera modelos frontier como orquestrador

O resultado contraintuitivo do Conductor — que um 7B supera GPT-5 e Gemini-2.5-Pro na tarefa de orquestração — tem uma explicação mecanística clara:

**Tarefa especializada vs. capacidade geral:** orquestrar um pool de agentes é uma tarefa com estrutura específica e estreita. O 7B foi treinado via RL especificamente para essa tarefa — 200 iterações de GRPO, 960 problemas de treinamento, reward direto sobre qualidade do workflow. Os modelos frontier são generalistas otimizados para uma distribuição vasta de tarefas, não para essa tarefa específica.

**Decomposição vs. resolução:** o Conductor não resolve os problemas — ele decompõe e delega. Isso requer entender quais subproblemas se beneficiam de quais modelos, como sequenciar os passos, e quais outputs precisam de verificação. Essas habilidades são distintas das habilidades de raciocínio matemático ou coding que tornam um modelo frontier valioso como worker.

**Training signal direto:** o reward do Conductor é observável e limpo — o workflow que ele projetou levou a uma solução correta ou não. Para generalistas treinados em feedback humano amplo, o sinal de training é muito mais ruidoso e difuso.

---

## GRPO sem KL regularization: por que funciona aqui

GRPO padrão inclui regularização KL para prevenir policy collapse — o modelo não deve se afastar tanto do modelo de referência que perca capacidades gerais. O Conductor remove essa regularização, o que normalmente seria arriscado.

A justificativa: o Conductor é treinado do zero para uma tarefa específica e pequena. Não há "capacidades gerais" para preservar — o objetivo é especialização máxima. KL regularization limitaria o quão especializado o modelo pode se tornar.

Batch size 256 compensa o ruído que KL normalmente mitigaria: médias sobre 256 rollouts são estatisticamente estáveis o suficiente para prevenir collapse sem restrição explícita de divergência.

---

## Topologias emergentes: o que o modelo aprendeu sem ser treinado para isso

Os comportamentos emergentes listados no paper revelam o que o Conductor descobriu via RL sobre o que funciona em orquestração:

**Task-difficulty adaptivity (2 steps para MMLU, 3-4 para LiveCodeBench):** o Conductor aprendeu que perguntas de múltipla escolha de conhecimento factual precisam de menos coordenação do que problemas de coding com múltiplas restrições. Isso não foi ensinado explicitamente — emergiu do sinal de reward.

**Planner/writer specialization:** Gemini+Claude como planejadores, GPT-5 como coder final. O Conductor descobriu que modelos diferentes têm vantagens comparativas em diferentes fases do workflow — e aprendeu a explorar essa heterogeneidade de forma consistente.

**Verification rounds emergentes:** sem nenhuma instrução sobre verificação, o Conductor consistentemente incluiu passos de verificação em workflows para tarefas de alta dificuldade. O sinal de reward (acerto final) foi suficiente para o modelo aprender que verificação intermediária aumenta a probabilidade de acerto.

**7B > 3B não por seleção de agentes, mas por prompt engineering:** a diferença entre Conductor 7B e 3B não é em quais modelos eles selecionam — é na qualidade dos prompts que eles geram para cada worker. O 7B formula subtasks mais precisas e contextualizadas, o que leva workers identicamente selecionados a performance superior.

---

## Adaptive worker selection: generalização cross-pool

A extensão de adaptive worker selection é a contribuição prática mais importante do paper. O Conductor padrão é treinado com um pool fixo de 6 modelos — mas em produção, o pool disponível muda (budget, disponibilidade de API, novos modelos sendo lançados).

O Conductor adaptativo é treinado com subsets aleatórios do pool de workers — às vezes 3 modelos, às vezes 5, às vezes apenas modelos open-source. Isso força o modelo a aprender princípios de seleção que generalizam ("quando o task é heavy math, usar o modelo de maior capacidade de raciocínio disponível") em vez de políticas específicas para o pool exato do treinamento.

Resultado: um Conductor treinado com pools mistos generaliza para pools all-open-source ou all-closed que nunca viu durante o treinamento, mantendo performance acima dos baselines.

---

## Custo-eficiência: o dado mais importante para uso prático

93.14% de accuracy no MMLU a $0.009/sample vs. 91.0% de accuracy de Claude 5x consensus a $0.0211/sample:

- Melhor qualidade
- 2.3x mais barato

Isso inverte o tradeoff habitual de "mais qualidade custa mais". O Conductor atinge qualidade superior a custo inferior porque usa os workers de forma mais eficiente — não toda pergunta precisa de 5 respostas em consenso; algumas precisam de uma única resposta certa do worker especializado.

Para qualquer sistema de AI em produção processando volume alto de queries, esse 2.3x de efficiency tem impacto direto na economics do produto — especialmente em 2026 onde a maior parte do custo de AI em produção é custo de tokens, não custo de infraestrutura.

---

## Implicações para o vault-michel

O Conductor demonstra que o padrão correto de uso de múltiplos modelos não é "use o modelo mais capaz para tudo" nem "use o modelo mais barato para tudo" — é **roteamento por especialização** com um orquestrador que aprendeu quando usar qual.

Para o vault, isso sugere uma hierarquia de modelos por tarefa que o Nexus agent poderia implementar:
- **Ingestão e wikilinks:** Sonnet (execução precisa, volume alto, custo relevante)
- **Análise e conexões:** Opus 4.6 (raciocínio sobre padrões)
- **Consolidação e síntese:** Opus 4.7 xhigh (qualidade máxima para outputs de longa duração)
- **Validação de qualidade:** modelo separado como evaluator (sem viés de auto-avaliação)
