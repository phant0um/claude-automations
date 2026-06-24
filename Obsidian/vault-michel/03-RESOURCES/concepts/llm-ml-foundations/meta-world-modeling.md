---
title: "Meta World Modeling"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, llm-ml-foundations]
status: developing
---

# Meta World Modeling

Aprender a aprender modelos de mundo — sistemas que generalizam para novos ambientes com poucos exemplos, em vez de precisar re-treinar do zero.

## O que é

Meta world modeling combina **meta-learning** com **modelos de mundo**. Um modelo de mundo representa como o ambiente muda em resposta a ações. Meta world modeling vai além: treina o sistema para adquirir modelos de mundo de novos ambientes rapidamente, usando experiência prévia em múltiplos ambientes como prior.

## Como funciona

- **MAML** (Model-Agnostic Meta-Learning): treina parâmetros iniciais que permitem adaptação rápida (poucas atualizações de gradiente) a qualquer tarefa do domínio. É a abordagem base.
- **Meta-learning de transições**: o meta-aprendiz treina em distribuição de MDPs (Markov Decision Processes); em tempo de teste, adapta o modelo de transição com poucos rollouts.
- **In-context world modeling**: LLMs como GPT-4 demonstram capacidade emergente de simular dinâmicas de ambiente sem treinamento explícito — o contexto atua como "modelo de mundo temporário".
- **Relação com few-shot**: meta world modeling é o mecanismo por trás da capacidade de agentes se adaptarem a novos ambientes com poucas observações.

## Por que importa

Agentes de propósito geral precisam operar em ambientes que não existiam no treinamento. Sem meta world modeling, cada novo ambiente exige retreinamento custoso. Com ele, o agente generaliza a partir de estrutura compartilhada entre ambientes — base para robôs adaptáveis, agentes de código que lidam com novas stacks, e LLM-agents em novos sistemas.

## Related
- [[03-RESOURCES/concepts/llm-ml-foundations/_index]]
- [[03-RESOURCES/concepts/world-model]]
- [[03-RESOURCES/concepts/model-based-reinforcement-learning]]
