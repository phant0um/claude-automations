---
title: "Miles Deutscher: Connected Entire Business to Hermes x Obsidian"
type: source
source: Clippings/Miles Deutscher on X "I connected my entire business to Hermes x Obsidian.Client notes, SOPs, meeting logs, business decisions - all of it.My Hermes agent now runs automations I didn't even know I needed, and my agent self-evolves over time.Here.md
created: 2026-06-20
ingested: 2026-06-21
tags: [ai-agents, hermes, obsidian, business-automation, self-evolving, source, score-A]
---

## Tese central

Miles Deutscher descreve um setup de 3 passos: criar business vault no Obsidian, conectar Hermes ao vault, deixar o agente ingerir notas automaticamente e construir automações overnight. O agente self-evolves over time e roda automações que o usuário não sabia que precisava.

## Argumentos principais

- **Step 1 — Business vault**: Obsidian vault "Business Brain" com client notes, CRM, SOPs, meeting notes, OKRs, financial data. "The more you feed it, the more powerful it gets."
- **Step 2 — Connect Hermes**: prompt "I want to connect you to my business Obsidian vault, and have you act as my business orchestrator"
- **Step 3 — Let it build**: ingest automático de notas, prompt "Based on everything you know, what automations should we build first?" e "Every night while sleeping, ingest data and autonomously build automations"
- **Self-evolution**: agente evolui overnight, roda automações não antecipadas

## Key insights

- Setup é simples (3 passos) mas o valor está em "let it build" — autonomia para ingerir e criar automações semInstruction explícita
- "Automations I didn't even know I needed" — o agente descobre patterns que o humano não via
- Business context = living memory — notas são ingested continuamente, não one-shot
- Overnight autonomous building é o padrão mais poderoso

## Exemplos e evidências

- X thread com 20681+ impressions
- Replies: preocupação com scalable long-term (paper vs AI), security (client notes leak), SOP rewriting in comprehensible-only-to-agent ways

## Implicações para o vault

- Setup é isomórfico ao vault-michel — Obsidian + Hermes + cron jobs + self-evolution
- "Let it build overnight" é exatamente o que o pipeline-semanal faz (cron domingo 22h)
- Reforça [[03-RESOURCES/concepts/pkm-obsidian/self-improving-vault]] e [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]]
- Reply sobre "SOP rewriting in agent-only-comprehensible ways" é risk real para o vault — governança de conventions é defense

## Minha Síntese

**O que muda:** Valid que o pattern vault-michel (Obsidian + Hermes + cron + self-evolution) é o que early adopters estão fazendo. A diferença: vault-michel tem system layer (04-SYSTEM) com governance que Miles não menciona.

**Conexão pessoal:** O setup de Miles é mais simples mas menos robusto. O vault-michel já tem o que Miles descreve + governance (guard, review, hill), conventions, e pipeline estruturado.

**Próximo passo:** O risk de "SOP rewriting in agent-only ways" é real — o review agent deveria flaggar conventions drift. Confirmar que [[04-SYSTEM/agents/core/review]] cobre isto.

## Links

- [[03-RESOURCES/concepts/pkm-obsidian/self-improving-vault]]
- [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]]
- [[03-RESOURCES/concepts/agent-systems/hermes-agent-architecture]]
- [[03-RESOURCES/entities/Hermes-Agent]]