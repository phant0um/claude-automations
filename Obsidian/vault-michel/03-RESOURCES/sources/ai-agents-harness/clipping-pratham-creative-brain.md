---
title: "prathamcreates/creative-brain — Personalized Creative Context"
type: source
created: 2026-05-24
updated: 2026-05-24
tags: [source, agent-memory, creative, personalization, taste, voice, second-brain]
score: 6
author: "prathamcreates"
source_url: "https://github.com/prathamcreates/creative-brain"
domain: ai-agents-harness
---

# prathamcreates/creative-brain — Personalized Creative Context

Repo que agente roda para construir "creative brain" personalizado do usuário — taste, voice, references — em markdown.

## Como Funciona

```
Clone → abrir no coding agent → dizer:
"Read README.md and AGENTS.md. Interview me to build my creative brain."
```

Agente entrevista você sobre:
- O que você faz
- Como você soa (voice)
- O que parece brega para você
- Referências que moldam seu gosto
- O que parece vivo vs morto no output
- O que está construindo agora

Resultado: pasta `outputs/creative-brain/` com:
```
identity.md / voice.md / taste.md / anti-slop.md /
references.md / content-system.md / ideas.md /
current-state.md / feedback-memory.md
```

## O Loop

```
interview → draft brain → feedback → update memory → use brain
```

Primeira versão não é perfeita. Cada vez que você aprova/rejeita/edita output, agente atualiza `feedback-memory.md`. Brain fica mais afiado.

## Regra Crítica

> "Do not let the agent skip the interview. If it writes before understanding your taste, it will probably produce slop."

## Por Que Existe

> "Most people ask AI to create from zero. That is why the output feels generic."

## Compatibilidade

Claude Code, Hermes, Cursor, OpenClaw.

## Ver Também

- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/sources/pkm-obsidian-second-brain/clipping-pm-brain-os]]
