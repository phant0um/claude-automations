---
title: "Fine-Tuning"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, llm-ml-foundations]
status: developing
---

# Fine-Tuning

Adaptar um modelo pré-treinado para tarefa, domínio ou estilo específico continuando o treinamento com dados supervisionados menores.

## O que é

Fine-tuning ajusta os pesos de um modelo já pré-treinado usando um dataset focado. Existe em duas famílias: **full fine-tuning** (todos os pesos atualizados) e **PEFT** — Parameter-Efficient Fine-Tuning, que treina apenas um subconjunto pequeno de parâmetros, mantendo o modelo base congelado.

## Como funciona

- **Full fine-tuning**: backpropagation em todos os pesos; máxima flexibilidade, alto custo de compute e memória.
- **LoRA** (Low-Rank Adaptation): injeta matrizes de baixo rank nas camadas de atenção; treina só ~0,1% dos parâmetros.
- **QLoRA**: LoRA com modelo base quantizado em 4-bit; viabiliza fine-tuning em GPUs consumer (16GB VRAM).
- **Prefix / Prompt tuning**: adiciona tokens "soft" treináveis ao início da sequência; pesos do modelo intocados.
- **Instruction tuning**: treinamento em pares (instrução → resposta) para seguir comandos; base dos modelos "chat".
- **Catastrophic forgetting**: risco de sobrescrever capacidades gerais ao treinar em domínio estreito; mitigado com data mixing e regularização (EWC).

## Por que importa

Quando prompt engineering não é suficiente — estilo muito específico, formato rígido, domínio de nicho, ou custo exigindo modelo menor — fine-tuning é a alavanca certa. PEFT democratizou o processo: LoRA em Llama 3 8B cabe em menos de 16GB de VRAM e produz especialistas de qualidade comparável ao GPT-4 em nichos.

**Quando fine-tunar vs. prompting:**

| Critério | Prompt Engineering | Fine-Tuning |
|---|---|---|
| Dataset disponível | Desnecessário | Mínimo ~500–1k exemplos |
| Consistência de formato | Moderada | Alta |
| Custo de inferência | Modelo base | Pode usar modelo menor |
| Velocidade de iteração | Rápida (horas) | Lenta (horas/dias) |

## Related
- [[03-RESOURCES/concepts/llm-ml-foundations/_index]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-pretraining]]
- [[03-RESOURCES/concepts/model-compression]]
- [[03-RESOURCES/sources/articles/research-papers-llm-engineer-must-read]] — 12 foundational papers (LoRA, DPO, InstructGPT)
