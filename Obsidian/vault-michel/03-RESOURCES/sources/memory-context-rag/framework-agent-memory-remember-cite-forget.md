---
title: "A Framework for Agent Memory: Remember, Cite, Forget"
type: source
source: Clippings/A Framework for Agent Memory Remember, Cite, Forget.md
author: "@Voxyz_ai"
published: 2026-05-22
created: 2026-05-22
ingested: 2026-05-23
tags: [ai-agents, memory, framework]
score: 8
---

## Tese central
Memória de agent tem 3 jobs simultâneos: **Remember** (o que deve ser guardado), **Cite** (o que deve ser confiado/rastreado), **Forget** (o que deve expirar). Falhar em qualquer um quebra o agent. Framework emergiu de X Manager (cron agent com múltiplos jobs diários).

## Argumentos principais
- "More storage ≠ agent vai usar" — instinto de "guardar mais" é errado
- 6 camadas de memória em prática, com lifespan e modo de falha distintos
- Remember: determinar o que tem valor persistente
- Cite: rastrear proveniência para confiança e debugging
- Forget: expiração ativa = decisão de design, não acidente

## Key insights
- **6 camadas de memória:**
  1. **Hot session** (working memory): contexto em progresso — deve ser limpa ao fim da task
  2. **Day-state** (whiteboard diário): o que o agent fez hoje, onde está, o que vem a seguir — instrução mais nova + timestamp mais recente apaga anterior
  3. **Project memory** (lições long-running): o que o projeto tropeçou, padrões que funcionaram — sobrescrito por lições mais novas
  4. **User profile** (preferências estáveis): estilos, restrições, valores — raramente sobrescrito
  5. **World knowledge** (fatos externos): atualizações síncronas com mudanças no mundo
  6. **Skill library** (procedimentos reutilizáveis): workflows que funcionaram → reusable
- Cite: cada claim na memória deveria ter proveniência rastreável → debugging + confiança
- Forget: memória sem expiração = agent usando nota de 3 meses como se fosse atual

## Exemplos e evidências
- X Manager (cron agent): múltiplos jobs ao dia → memória multi-layer em produção
- Hot session failure: "no emoji" foi esquecido após compressão de contexto
- Day-state failure: instrução da manhã sobrevivia instrução da tarde sem timestamp
- lossless-claw: raw messages em SQLite preservados para grep quando necessário

## Implicações para o vault
Framework direto para o design de memória do vault: hot.md = day-state + hot session; memory/ files = project memory + user profile; sources/ = world knowledge; skills/ = skill library. Gap: Cite está ausente — nenhum source page tem proveniência rastreável de onde vêm as afirmações.

## Links
- [[04-SYSTEM/wiki/hot]]
- [[03-RESOURCES/sources/memory-context-rag/ai-agents-state-memory-consistency]]
- [[03-RESOURCES/sources/memory-context-rag/evolvemem-self-evolving-memory-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-layers]]
