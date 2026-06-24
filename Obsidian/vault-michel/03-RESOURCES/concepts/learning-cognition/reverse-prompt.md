---
title: Reverse Prompt (Prompt Reverso)
type: concept
status: developing
tags: [prompt-engineering, ia-workflow, agente, produtividade]
created: 2026-05-14
updated: 2026-05-14
---

# Reverse Prompt (Prompt Reverso)

Técnica de prompting que **inverte o fluxo padrão**: em vez de o usuário fazer perguntas à IA, o usuário instrui a IA a fazer perguntas ao usuário para descobrir o que ela precisa saber para ajudá-lo melhor.

## Mecanismo

1. O usuário descreve seu contexto, objetivos e ambições.
2. Usa o prompt reverso: *"Com base no que você sabe sobre mim e meus objetivos, que informações adicionais eu posso fornecer para que você me ajude a alcançar meus objetivos mais rápido?"*
3. A IA identifica suas próprias lacunas de contexto e as solicita.
4. Complemento: *"Quais tarefas você pode fazer por mim agora para nos aproximar das nossas ambições?"*

## Por que funciona

O modelo tem melhor visibilidade das suas próprias limitações de contexto do que o usuário. Ao ser instruído a perguntar, ele revela o que o usuário nunca pensaria em fornecer espontaneamente.

**Resultado:** usuários reportam pensar em 100x mais coisas para fazer com a IA do que imaginavam antes.

## Diferença de abordagem padrão

| Abordagem padrão | Prompt Reverso |
|---|---|
| Usuário → pergunta → IA responde | Usuário → contexto → IA pergunta → usuário fornece → IA age |
| IA age com contexto incompleto | IA solicita o contexto que falta |
| Output limitado pelo que o usuário sabe perguntar | Output limitado pelo que a IA precisa saber |

## Aplicações

- Definição de estratégia pessoal/carreira
- Onboarding de agente novo (Hermes, Claude Code) ao contexto do usuário
- Discovery de tarefas que o usuário não sabia que podia delegar

## Fontes

- [[03-RESOURCES/sources/skills-prompting-mcp/post-alexfinn-reverse-prompt]]

## Relacionado

- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]]
- [[03-RESOURCES/entities/AlexFinn]]
