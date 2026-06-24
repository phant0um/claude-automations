---
title: "9 Claude Cowork prompt-templates that run my 8-hour workday in 47 minutes of active supervision"
type: source
source: "Clippings/9 Claude Cowork prompt-templates that run my 8-hour workday in 47 minutes of active supervision..md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents]
---

## Tese central

Nove slash commands (saved prompts com structured inputs) no Claude Cowork, construídos com três propriedades essenciais — TERMINATION explícito, output shape definido e role no first line — produziram uma economia real de 34 horas semanais (verificadas por logs de maio vs. abril), reduzindo 8 horas de workday para 47 minutos de supervisão ativa.

## Argumentos principais

- A camada que importa não é o plugin, é o slash command: "O plugin é a cozinha. O slash command é a receita"
- 21 templates foram descartados; os 9 sobreviventes compartilham exatamente três propriedades — a ausência de qualquer uma causa falha
- Os dois failure modes dos 21 descartados: (1) sem TERMINATION limpo → iteração infinita, output cresce e piora; (2) mission creep → sem role definition, prompt de triagem de email vira gerador de estratégia de contatos
- Sub-agentes (template 8 — Research deep-dive) são a maior economia individual: de 4h para 28 min via 5 agentes paralelos por categoria de fonte

## Key insights

- **Três propriedades que todo template sobrevivente tem:**
  1. TERMINATION explícito: condição checkável pelo output (contagem de páginas, campos preenchidos, completude estrutural) — sem isso, sessão expande para preencher o bloco inteiro
  2. Structured output shape: seções nomeadas com conteúdos específicos — modelo escreve dentro da shape, não inventa a shape
  3. Role definition na primeira linha: "chief of staff", "audit-only", "coordinator" — limita o que o modelo acha que deve produzir
- "Do not invent metrics not present in source data" — a regra mais importante do artigo inteiro (Cowork fabrica números quando acha que a audiência espera)
- Voice-matching via "last 5 sent emails to the same person": 3 emails perde voz em tópicos raros, 10 overfit a padrões antigos, 5 é o sweet spot
- "Never use the same opening line across channels" — sem isso, todas as adaptações de conteúdo abrem com a mesma frase

## Exemplos e evidências

9 templates com tempos before/after medidos em 30 dias de paired runs (maio 2026):

| Template | Before | After |
|---|---|---|
| Daily intelligence briefing | 47 min | 4 min |
| Competitive landscape scan | 3h | 18 min |
| Email triage + draft replies | 90 min | 11 min |
| Meeting prep dossier | 30 min | 3 min |
| Weekly status report | 2h | 7 min |
| Document review with Q&A | 90 min | 9 min |
| Polymarket position audit | 45 min | 3 min |
| Research deep-dive (sub-agents) | 4h | 28 min |
| Content repurposing | 90 min | 12 min |

- Saving real semanal: 34h (após subtrair: sobreposição de inputs, tempo de review/tuning ~35h/semana, tarefas feitas em paralelo de qualquer forma)
- "Do not predict the future" cortou 40 min/run do competitive scan (Cowork sempre adiciona strategic outlook idêntico com diferentes roupagens)
- TERMINATION "do not summarize the summary" cortou 60% do output sem perda de qualidade no morning brief

## Implicações para o vault

Os três princípios de design de templates são diretamente aplicáveis ao design de skills e agents deste vault: TERMINATION equivale ao critério de conclusão, structured output shape corresponde ao formato de output das skills, role definition já está presente em alguns agents mas pode ser reforçado. O sistema de slash commands do Cowork é análogo ao sistema de skills do vault. Referência concreta para melhorar as skills existentes em `04-SYSTEM/skills/`.

## Links

- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- [[03-RESOURCES/concepts/agent-systems/subagent-spawning]]
- [[03-RESOURCES/concepts/prompt-engineering]]
- [[03-RESOURCES/concepts/agent-systems/context-management]]
- [[03-RESOURCES/entities/Claude-Cowork]]
