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
triagem_score: 9
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

This paper is a direct example of **θ-engineering** that operationalizes the consolidation channel described in [[03-RESOURCES/sources/memory-context-rag/contextual-agentic-memory-is-a-memo]]. The post-trained model acts as the "neocortical teacher" that informs weight updates during pretraining — exactly the direction the memory paper calls for.

## Relations

- [[03-RESOURCES/entities/Meta-AI]] — institution
- [[03-RESOURCES/concepts/llm-ml-foundations/post-training-llm]] — the technique being moved upstream
- [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]] — related θ-loop pattern
- [[03-RESOURCES/concepts/llm-ml-foundations/weak-to-strong-generalization]] — using a stronger model to supervise a weaker one
- [[03-RESOURCES/concepts/llm-ml-foundations/reward-hacking]] — online DPO avoids collapse via judge-selected pairs
- [[03-RESOURCES/sources/memory-context-rag/contextual-agentic-memory-is-a-memo]] — companion paper on θ vs. C distinction

---

## O problema de stage separation: por que isso importa

O treinamento padrão de LLMs tem um problema de sequenciamento: pretrainamento maximiza predição de próximo token sobre texto bruto, depois post-treinamento adiciona segurança, facticidade e raciocínio via RLHF/DPO. Mas os padrões aprendidos no pretrainamento já definiram as "correntes fundamentais" do modelo — post-treinamento apenas restringe ou direciona o que já está lá.

**A consequência prática:** um modelo que aprendeu padrões de texto inseguro ou factualmente incorreto durante pretrainamento pode "escapar" desses padrões via jailbreaks ou em distribuições out-of-domain onde o post-treinamento não cobre adequadamente. O post-treinamento é um supressor, não uma correção na origem.

**A solução do paper:** se você pode melhorar a qualidade, facticidade e segurança dos próprios dados de pretrainamento usando um modelo post-treinado forte, o problema se torna menor na raiz. O modelo aprende de dados que já incorporam as propriedades desejadas, em vez de aprender os dados brutos e depois tentar suprimir os problemas.

---

## Online DPO vs. offline DPO: a distinção crítica

DPO (Direct Preference Optimization) padrão usa pares estáticos (chosen, rejected) coletados antecipadamente. Online DPO gera novos rollouts a cada step de treinamento e seleciona pares dinamicamente:

**Offline DPO:**
- Dados coletados uma vez, antes do treinamento
- O modelo treina nos mesmos pares independente de quanto melhorou
- Risco: conforme o modelo melhora, os pares ficam desalinhados com sua distribuição atual

**Online DPO:**
- A cada step, o modelo gera rollouts, o judge avalia, pares são selecionados
- O modelo sempre treina em pares relevantes para sua capacidade atual
- Custo: gerar rollouts a cada step é computacionalmente caro

Para Self-Improving Pretraining, Online DPO é necessário porque a qualidade dos rollouts muda drasticamente durante o treinamento — no início são ruins (relies on suffix and rewrite), no final são bons (judge selects them as chosen). Usar pares estáticos descartaria essa evolução.

---

## Thinking Mid-Training: como raciocínio é inserido antes do post-training

A fase de "Thinking Mid-Training" é a mais original do paper. Em vez de esperar pelo post-training para ensinar raciocínio encadeado, o paper propõe inserir traces de raciocínio diretamente nos dados de pretraining:

1. Dados de pretraining são aumentados com "pensamentos" intercalados — raciocínio intermediário gerado por um modelo forte
2. SFT inicial treina o modelo base a produzir esses pensamentos
3. RL com judge otimiza a utilidade dos pensamentos inseridos — descartando pensamentos que não melhoram o output e reforçando os que melhoram

O resultado é um modelo que chega ao post-training já com habilidades de raciocínio encadeado, em vez de aprender reasoning do zero na fase de post-training. Isso potencialmente reduz o custo de post-training e melhora a qualidade do raciocínio resultante.

---

## Resultados e o que eles implicam

Os números são expressivos, mas o mais importante é o que eles implicam sobre o ceiling de qualidade de modelos pequenos:

**1.4B supera 8B em safety+quality:** isso significa que o tamanho do modelo não é o determinante principal de qualidade — a qualidade dos dados de pretraining é. Um modelo 5x menor treinado com dados melhores supera um modelo maior treinado com dados brutos.

**86.3% de win rate em quality:** isso significa que em 86 de 100 comparações diretas, o output do modelo Self-Improving é preferido ao baseline. Para facticidade, o ganho relativo de +36.2% (57.6 vs 42.3 FActScore) é especialmente relevante para casos de uso onde alucinação é o maior risco.

**Safety 97.5 from scratch vs 85.2 baseline:** a margem mais dramática. Um modelo treinado from scratch com Self-Improving Pretraining tem taxa de resposta segura de 97.5% comparado a 85.2% do baseline — uma diferença de 12+ pontos em valor absoluto.

---

## Conexão com θ-engineering

O paper usa o termo "θ-engineering" para descrever o loop de usar um modelo post-treinado para melhorar os parâmetros θ de um modelo em pretraining. Isso conecta com a distinção C/θ da literatura de memória de agentes:

- **C (context):** o que está na janela de contexto do agente — memória de curto prazo, informação retrievada, instruções do sistema
- **θ (parâmetros):** os pesos do modelo — o que foi consolidado durante o treinamento

Self-Improving Pretraining é a demonstração de que o canal C→θ funciona: o comportamento de um modelo post-treinado (que opera via C bem calibrado) pode ser consolidado nos parâmetros θ de um modelo mais fraco via o loop de treinamento. Isso não é distilação simples — é transferência seletiva das propriedades mais importantes (safety, quality, factuality) via um sinal de reward que as mede diretamente.
