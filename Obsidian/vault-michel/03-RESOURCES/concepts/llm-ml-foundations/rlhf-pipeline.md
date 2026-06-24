---
title: "RLHF Pipeline"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, llm-ml-foundations]
status: developing
---

# RLHF Pipeline

Implementação passo a passo do alinhamento por feedback humano — da coleta de dados ao loop PPO.

## O que é

O pipeline RLHF é a sequência de engenharia concreta que implementa o RLHF teórico. Cada etapa tem suas próprias escolhas de design com impacto direto na qualidade do alinhamento.

## Como funciona

**1. Coleta de pares de preferência**
- Humanos (ou modelos) recebem prompt + 2 respostas candidatas
- Escolhem qual é melhor (ou empate)
- Resultado: dataset de tuplas `(prompt, chosen, rejected)`

**2. Treino do Reward Model**
- Arquitetura: LLM com cabeça de classificação (scalar output)
- Loss: Bradley-Terry pairwise ranking loss
- Validação: accuracy em held-out preferences

**3. PPO Loop**
```
for each batch:
  sample prompt → generate response (policy)
  score with RM → reward signal
  compute KL(policy || ref_policy) → penalty
  PPO update: maximize (reward - β·KL)
```
- **β (KL coeficiente):** controla quanto o modelo pode se afastar do SFT. Alto β = mais conservador.

## Variantes

| Método | RM explícito | Complexidade | Nota |
|--------|-------------|--------------|------|
| PPO-RLHF | Sim | Alta | Padrão histórico |
| DPO | Não | Média | Treina direto nas preferências |
| GRPO | Sim (implícito) | Baixa | Sem critic, usa ranking de grupo |
| Constitutional AI | Auto-gerado | Média | RLAIF com princípios escritos |

**GRPO (DeepSeek-R1):** gera N respostas por prompt, rankeia por resultado correto, usa diferença relativa como vantagem. Elimina o value network do PPO — 2× mais eficiente em memória.

## Por que importa

Entender o pipeline explica comportamentos observáveis: por que modelos são às vezes sycophantic (reward hacking de aprovação humana), por que Constitutional AI gera respostas mais consistentes com princípios explícitos, e por que DPO está substituindo PPO em muitos labs por ser mais estável de treinar.

## Related
- [[03-RESOURCES/concepts/reinforcement-learning-from-human-feedback]]
- [[03-RESOURCES/concepts/reinforcement-learning]]
- [[03-RESOURCES/concepts/reasoning-models]]
- [[03-RESOURCES/concepts/llm-ml-foundations/_index]]
