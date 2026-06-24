---
title: "Agent Design Decision Framework"
type: concept
created: 2026-06-09
updated: 2026-06-09
tags: [agent-systems, architecture, decision-framework, enterprise, patterns]
status: developing
---

# Agent Design Decision Framework

Framework de 3 perguntas para selecionar o padrão arquitetural correto para sistemas de IA, da Anthropic. Principio central: **alinhar complexidade técnica com valor de negócio** — nunca escolher pela sofisticação máxima.

## As 3 Perguntas Críticas

### 1. Nível de controle necessário?

| Controle | Arquitetura recomendada | Exemplo |
|----------|------------------------|---------|
| **Alto** — regulatório, financeiro, segurança crítica | Single agent ou sequential workflows | Aprovação de empréstimos (auditável) |
| **Moderado** — suporte, conteúdo, análise | Hierarchical multi-agent | Supervisor + especialistas |
| **Baixo** — pesquisa, brainstorming, análise complexa | Collaborative multi-agent | Swarm explorativo |

Regra prática: se precisar explicar a decisão para auditores ou reguladores, use single agent com critérios claros.

### 2. Complexidade do domínio?

| Problema | Arquitetura | Exemplo |
|----------|-------------|---------|
| **Domínio único** (responder produto, processar retornos) | Single agent | Não over-engineer |
| **Multi-domínio previsível** (onboarding, compliance) | Sequential ou parallel workflows | Expertise diferente em cada stage |
| **Aberto e complexo** (análise estratégica, troubleshooting) | Multi-agent | Perspectivas múltiplas necessárias |

### 3. Restrições de recurso?

| Restrição | Decisão |
|-----------|---------|
| Budget/tokens limitados | Single agent ou parallel workflows com design cuidadoso |
| Time-to-market urgente | Single agent primeiro; planejar path de evolução |
| Iniciativa estratégica longa | Modular desde o início; interface compatível para adicionar agentes |
| Multi-agent necessário | Multi-agent consome **10–15x mais tokens** que single — calcular volume antes |

### 4. (Adicional) Expertise de domínio necessária?

- **Domínio único com workflows estabelecidos** → Single agent + Agent Skills especializadas (evitar pular para multi-agent)
- **Múltiplos domínios distintos que precisam coordenar** → Multi-agent com Skills por agente especialista

## Pattern Selection Guide

| Padrão | Melhor para |
|--------|-------------|
| **Single agent** | Customer service produto definido, processamento de documentos, code review básico, análise rotineira |
| **Sequential workflow** | Aprovações multi-step, pipelines de conteúdo (draft→review→publish), transformação de dados, compliance multi-critério |
| **Parallel workflow** | Múltiplas perspectivas melhoram qualidade, análises independentes simultâneas, velocidade > overhead de coordenação |
| **Multi-agent system** | Resolução de problemas complexos com expertise diversa, pesquisa e análise, interações dinâmicas com múltiplos sistemas, planejamento estratégico |

## Evolução Incremental: Caso E-commerce

```
Fase 1: Single agent → customer inquiries (prova ROI)
Fase 2: Routing pattern → order status vs produto vs reclamações
Fase 3: Specialized agents por categoria + shared context
Fase 4: Multi-agent com coordenação inventory + payment + shipping
Fase 5: Evaluator agents para QA contínuo
```

## Princípio Central

> "Start with single agents to prove ROI, build observable systems from day one, and evolve your architecture based on what the data tells you. The best architecture is the simplest one meeting today's requirements while providing a path to tomorrow's capabilities."

## Hybrid Architectures (produção)

Sistemas em produção frequentemente combinam padrões:
- **Hierarchical + parallel**: supervisor delega a especialistas que rodam análises paralelas internamente
- **Sequential + dynamic routing**: pipeline linear que invoca diferentes tipos de agente por complexidade
- **Single + multi-agent escalation**: single agent rotineiro → aciona sistema multi-agent para edge cases

## Links

- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/hierarchical-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/agentic-patterns]]
- [[03-RESOURCES/concepts/agent-systems/evaluator-optimizer-workflow]]
- [[03-RESOURCES/concepts/agent-systems/agent-model-routing]]
- [[03-RESOURCES/concepts/agent-systems/context-budget-constraint]]
- [[03-RESOURCES/sources/building-effective-ai-agents-anthropic]]
