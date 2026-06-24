---
title: "The Three Harness Layers and How to Audit Your Stack"
type: source
source: Clippings/The Three Harness Layers and How to Audit Your Stack.md
author: "@AlphaSignalAI"
published: 2026-04-30
created: 2026-05-21
ingested: 2026-05-23
tags: [ai-agents, harness-engineering, audit, claude-code]
score: 8
---

## Tese central
Síntese do paper "Code as Agent Harness" (UIUC/Meta/Stanford) em framework prático de auditoria: 3 layers + 3 perguntas de diagnóstico. A maioria das falhas de agents são falhas de harness, não de reasoning.

## Argumentos principais
- Paper: 100 páginas, 40+ pesquisadores, 400+ papers sintetizados
- 3 layers do sistema agent: (1) model-internal capabilities (reasoning/planning), (2) system-provided infrastructure (tools/sandboxes/memory/telemetry), (3) **agent-initiated code artifacts** (testes, tools temporários, DSL programs, skills)
- Interface: código como medium para reasoning, action, environment state
- Mechanisms: planning, memory, tool use + plan-execute-verify loop
- Scaling: multi-agent via shared code artifacts
- 3 perguntas de auditoria (uma por layer):
  1. Interface: "Raciocínio/ação/estado do seu agent passa por código?"
  2. Mechanisms: "Tem dead-end detection? Log de trajectories? Evidence bundle por ação?"
  3. Scaling: "Agents compartilham code artifacts? Tem coordenação revisável?"

## Key insights
- Oracle adequacy: avaliações colapsam qualidade modelo + tool reliability + harness quality → bottleneck central
- Verification gap: green tests ≠ especificação correta → cada ação deveria ter evidence bundle (checks ran, assumptions held, untested parts, risks)
- Approvals que resetam na sessão = agent repete ação insegura; permission rules deveriam mutar com decisões humanas
- "Ler como vocabulário, não roadmap" — taxonomia afila como falar sobre o stack

## Exemplos e evidências
- Claude Code, Codex, SWE-agent, Voyager, MetaGPT, OpenHands como sistemas âncora
- Voyager skill library + Claude Code skill files = primeiros "agent-initiated code artifacts"
- Dead-end detection ausente: agent passa em testes mas loopeia entre estratégias falhando

## Implicações para o vault
Framework de auditoria direta para o vault: (1) skills são agent-initiated artifacts ✓, (2) hooks criam feedback loop ✓, (3) guard agent = verification layer ✓. Gap identificado: evidence bundles ausentes nos outputs dos agentes do vault.

## Links
- [[03-RESOURCES/sources/ai-agents-harness/code-as-agent-harness]]
- [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
- [[04-SYSTEM/agents/core/guard]]
