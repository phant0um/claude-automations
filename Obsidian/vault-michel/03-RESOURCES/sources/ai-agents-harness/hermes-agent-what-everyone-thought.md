---
title: "Hermes Agent Is What Everyone Thought AI Agents Would Become"
type: source
source: Clippings/Hermes Agent Is What Everyone Thought AI Agents Would Become.md
author: "@NainsiDwiv50980"
published: 2026-05-21
created: 2026-05-22
ingested: 2026-05-23
tags: [hermes-agent, ai-agents, persistent-memory, skill-learning]
score: 8
---

## Tese central
Hermes Agent (Nous Research) é o primeiro sistema agent apontando para AI que genuinamente "composta" — não por context windows maiores, não por benchmarks, mas por aprendizado operacional persistente: transformar workflows repetidos em skills reutilizáveis.

## Argumentos principais
- Maioria dos agentes atuais: completam task, esquecem tudo, reiniciam no zero
- 2 anos de otimização em: context mais longo, melhor tool use, inferência mais rápida, custo menor, UIs mais limpas — memória continua quebrada
- Hermes: agents podem transformar workflows repetidos em skills reutilizáveis → sistema composta
- Quando agents comprimem experiência em comportamentos reutilizáveis → para de ser chatbot, começa a ser worker
- Persistent operational learning = real unlock que a indústria ainda não resolveu

## Key insights
- **Skills como memória procedural**: sistema aprende procedures de experiência, não apenas armazena histórico
- Shift qualitativo: "procedimento bem-sucedido → reusable skill" → compound ao longo do tempo
- Skills evoluem: refinam workflows over time, persistem abstrações operacionais
- "AI that compounds" — não maior, não mais rápido, mas que aprende operacionalmente
- Problema atual: "toda conversa começa do zero" → Hermes ataca isso diretamente

## Exemplos e evidências
- Comparação: "glorified session-based wrappers" vs Hermes com operational learning
- Skills de Hermes: learn from experience → reuse → refine → persist
- Nous Research architecture: designed around persistent operational knowledge

## Implicações para o vault
Valida o conceito de skills do vault como memória procedural (04-SYSTEM/skills/). O vault já implementa o que Hermes propõe: skills persistentes que evoluem com uso. Pipeline de self-improvement (hill agent) deveria incorporar feedback loop de "qual skill funcionou melhor".

## Links
- [[03-RESOURCES/sources/hermes-agent/hermes-agent-masterclass]]
- [[03-RESOURCES/concepts/agent-systems/claude-skills-architecture]]
- [[04-SYSTEM/agents/core/hill]]
