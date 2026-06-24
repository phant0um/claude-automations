---
title: "Synthetic Training Data"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, llm-ml-foundations]
status: developing
---

# Synthetic Training Data

Dados gerados por LLMs para treinar ou fine-tunar outros modelos — escalando sem depender exclusivamente de dados humanos.

## O que é

Synthetic training data são exemplos de treinamento criados artificialmente, tipicamente por um LLM forte (teacher), para treinar modelos menores ou mais especializados. Resolve o gargalo de escassez de dados humanos rotulados para domínios específicos.

## Como funciona

**Pipeline típico:**
1. **Geração:** LLM teacher produz exemplos (perguntas, respostas, pares instruction/completion)
2. **Filtro de qualidade:** model-as-judge — outro LLM avalia e descarta exemplos ruins
3. **Deduplicação:** remoção de repetições e near-duplicatas
4. **Injeção de diversidade:** variação de persona, estilo, domínio para cobrir distribuição ampla

**Synthetic Computers at Scale (Anthropic/outros):** geração de dados com personas sintéticas diversas — simula humanos de diferentes backgrounds, expertise, estilos de escrita.

**Self-play / iterativo:** modelo gera dados → treina versão melhorada → versão melhorada gera dados melhores (loop STaR, ReST, Alphacode).

## Variantes

| Abordagem | Exemplo | Uso |
|-----------|---------|-----|
| Distillation data | GPT-4 → LLaMA | Transferência de capacidade |
| Instruction tuning sintético | Alpaca, WizardLM | Fine-tuning instruction-following |
| Chain-of-thought sintético | STaR, ReST | Treinar raciocínio |
| Persona-based | Synthetic Computers | Diversidade de estilo |

## Por que importa

Riscos: **model collapse** — se o ciclo de geração/treino fecha sem dados reais suficientes, o modelo converge para uma distribuição cada vez mais estreita e degenerada. Mitigação: manter fração de dados reais (âncora), filtros agressivos de qualidade. Benefício: viabiliza fine-tuning em domínios onde dados humanos são raros ou caros (medicina, jurídico, código especializado).

## Related
- [[03-RESOURCES/concepts/llm-ml-foundations/_index]]
- [[03-RESOURCES/concepts/llm-ml-foundations/fine-tuning]]
- [[03-RESOURCES/concepts/continual-learning-v2]]
- [[03-RESOURCES/concepts/reinforcement-learning-from-human-feedback]]
