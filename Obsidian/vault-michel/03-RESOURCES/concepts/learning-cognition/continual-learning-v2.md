---
title: "Continual Learning"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, llm-ml-foundations]
status: developing
---

# Continual Learning

Treinar modelos incrementalmente em novos dados sem esquecer o que já aprenderam — o problema do esquecimento catastrófico.

## O que é

Continual learning (também chamado lifelong learning ou incremental learning) é o conjunto de técnicas que permite a um modelo neural aprender tarefas novas sequencialmente sem degradar performance nas tarefas antigas.

O problema central é o **catastrophic forgetting**: redes neurais treinadas em tarefa B sobrescrevem os pesos que codificavam tarefa A, esquecendo-a completamente.

## Como funciona

**Principais abordagens:**

1. **Replay buffers:** armazenar amostras representativas das tarefas antigas e re-treinar em conjunto com dados novos. Simples e eficaz. Variante: **generative replay** (usar modelo generativo para re-criar exemplos antigos).

2. **Elastic Weight Consolidation (EWC):** penaliza mudanças em pesos que eram "importantes" para tarefas anteriores (medido pela matriz de Fisher information). Mantém plasticidade para pesos novos e rigidez para pesos críticos.

3. **Progressive Neural Networks:** adiciona novas "colunas" de rede para cada tarefa nova, com conexões laterais — nunca modifica pesos antigos. Custo: cresce em tamanho.

4. **LoRA + task vectors:** fine-tuning com adaptadores separados por tarefa, merge seletivo.

## Variantes

| Cenário | Desafio específico |
|---------|--------------------|
| Task-incremental | Sabe qual tarefa está executando |
| Domain-incremental | Mesma tarefa, distribuição muda |
| Class-incremental | Novas classes sem acesso às antigas |

## Por que importa

Para sistemas de agentes em produção: modelos precisam absorver novos documentos, políticas e fatos sem re-treino completo (caro). Relevância prática: RAG resolve parte do problema (contexto dinâmico), mas não substitui atualização de conhecimento procedural. Fine-tuning contínuo com replay é o padrão emergente para modelos especializados que precisam de updates frequentes.

## Related
- [[03-RESOURCES/concepts/llm-ml-foundations/_index]]
- [[03-RESOURCES/concepts/llm-ml-foundations/fine-tuning]]
- [[03-RESOURCES/concepts/synthetic-training-data]]
- [[03-RESOURCES/concepts/llm-ml-foundations/rag]]
