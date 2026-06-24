---
title: "Engenharia de Software"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, dev-foundations]
status: developing
---

# Engenharia de Software

Construir software de forma sistemática, disciplinada e mensurável — a diferença entre hackear soluções e entregar produtos.

## O que é

Engenharia de Software é a disciplina que aplica princípios de engenharia ao desenvolvimento de software: processo, metodologia, ferramentas e métricas para construir sistemas confiáveis, no prazo e dentro do custo. É diferente de "programar" — programar é uma atividade, engenharia de software é o processo completo do ciclo de vida.

O **SDLC (Software Development Life Cycle)** define as fases: levantamento de requisitos → análise → design (arquitetura) → implementação → testes → implantação → manutenção. As metodologias diferem em como iterar por essas fases.

**Waterfall** executa as fases em sequência linear — funciona bem quando os requisitos são estáveis e conhecidos (projetos governamentais, sistemas embarcados). **Agile** itera em ciclos curtos (sprints de 1-4 semanas), entrega valor frequente e adapta-se a requisitos mutáveis. **Scrum** é o framework Agile mais usado: Product Owner (visão/backlog), Scrum Master (facilita), Time de Desenvolvimento. Cerimônias: Sprint Planning, Daily Standup, Sprint Review, Retrospectiva.

## Como funciona

Artefatos Scrum essenciais:
- **Product Backlog:** lista priorizada de tudo que o produto precisa
- **Sprint Backlog:** subset do backlog comprometido para a sprint atual
- **Incremento:** software funcionando entregue ao final de cada sprint
- **Definition of Done (DoD):** critérios que todo item deve satisfazer para ser "pronto"

Métricas ágeis: **velocity** (story points por sprint), **burndown chart** (trabalho restante × tempo), **lead time** (do pedido à entrega).

## Por que importa

No mercado brasileiro de TI, praticamente toda empresa de produto usa Scrum ou Kanban. A FIAP cobra Agile/Scrum nos projetos em grupo desde a Fase 1. Para concursos de Analista de TI (governo federal), questões de Engenharia de Software são extensas — SDLC, Waterfall vs Agile, métricas de qualidade (ISO 9126/25010), testes de software são tópicos recorrentes no edital.

## Exemplo

Sprint de 2 semanas em um projeto FIAP: Planning na segunda (seleciona itens do backlog), Daily de 15 min todo dia, Review na última sexta (demonstra ao "cliente"), Retrospectiva (o que melhorar). Resultado: incremento funcional a cada 2 semanas, não no final do semestre.

## Related
- [[03-RESOURCES/concepts/dev-foundations/_index]]
- [[03-RESOURCES/concepts/user-stories]]
- [[03-RESOURCES/concepts/mvc-architecture]]
- [[03-RESOURCES/concepts/uml]]
- [[03-RESOURCES/concepts/gestao-projetos]]
