---
title: "Anthropic Quietly Shipped Dreaming — Setup Guide for Claude Managed Agents"
type: source
source_file: "Clippings/Anthropic Quietly Shipped Dreaming. Your Claude Agent Now Improves Itself Overnight..md"
origin: "x.com/@Zephyr_hg"
author: "@Zephyr_hg"
published: 2026-05-27
ingested: 2026-05-28
tags: [claude-managed-agents, dreaming, memory, self-improvement, automation, workflow]
triagem_score: 8
---
# Anthropic Dreaming — Setup Prático para Claude Managed Agents

> [!key-insight] Tese central
> Dreaming é um processo agendado dentro do Claude Managed Agents que lê logs e memória da sessão, detecta padrões e erros recorrentes, e produz um novo memory store consolidado — fazendo o agente acordar mais afiado a cada noite sem intervenção manual.

## Conteúdo

### O que é Dreaming

Enquanto o agente está idle, o Dreaming:
1. Lê os session logs e o memory store
2. Identifica padrões, erros recorrentes, preferências capturadas nas correções do usuário
3. Produz um novo memory store: duplicatas mescladas, entradas obsoletas removidas, insights novos adicionados

Resultado: o agente de amanhã é mais afiado que o de hoje, **sem retraining manual**.

### Setup em 8 minutos

1. Claude Console → Managed Agent → seção "Dreaming cadence"
2. Escolher schedule: hourly / daily / weekly / manual trigger
3. **Default recomendado:** daily às 3 AM
4. Controle: `Auto-update` (reescreve memória sozinho) vs `Review mode` (diff para aprovação)
5. **Estratégia:** começar em review mode por 7 dias; flip para auto-update após ganhar confiança

### Por que compõe

- Agente regular: desempenho constante do dia 1 ao dia 100 (sem tuning manual)
- Dreaming agent: cada noite incorpora as correções do dia anterior
- Ao fim de 30 dias: agent conhece preferências, edge cases, estilo do usuário
- Ao fim de 90 dias: sabe coisas que o próprio usuário esqueceu de ter ensinado

### 3 workflows onde o compounding é mais forte

**Sales pipeline que se treina sozinho:** correções de lead scoring e voz de resposta viram memory updates automáticos; ao dia 30 as replies raramente precisam edição.

**Content gate que aprende seu estilo:** detecta violações de tom que o usuário nunca explicitou — inferidas do padrão de rejeições.

**Monday brief que compõe:** ao filtrar o que você flaggou como relevante, aprende a curar; na semana 8 entrega só o que importa.

## Key Insights

- Dreaming é Managed Agents nativo — não precisa código, apenas configuração no Console
- "Review mode por 7 dias" é a rampa de confiança correta antes de auto-update
- A funcionalidade existe há tempo mas ficou "atrás de menus que as pessoas nunca abrem" (junto com Memory, Skills, Scheduled Tasks, Routines, Cowork)
- Distinção do RLanceMartin post (já no vault): esse artigo foca no setup prático; o outro cobre a mecânica técnica de Outcomes + Dreaming

## Implicações para o vault

- Complementa [[03-RESOURCES/sources/ml-research-papers/rlancemartin-outcomes-dreaming-managed-agents]] com ângulo prático de setup
- Reforça [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]] com caso de uso concreto
- Conexão: [[03-RESOURCES/concepts/pkm-obsidian/dream-cycle-self-consolidation]] — mesmo mecanismo no vault

## Links

- Fonte: `Clippings/Anthropic Quietly Shipped Dreaming. Your Claude Agent Now Improves Itself Overnight..md`
- Fonte relacionada: [[03-RESOURCES/sources/ml-research-papers/rlancemartin-outcomes-dreaming-managed-agents]]
- Conceito: [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]]
- Conceito: [[03-RESOURCES/concepts/pkm-obsidian/dream-cycle-self-consolidation]]
