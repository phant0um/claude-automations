---
title: "5 Lessons for an Agent Personality File (SOUL.md)"
type: source
source: "Clippings/5 Lessons for an Agent Personality File Get OpenClaw and Hermes Past the Generic Assistant.md"
created: 2026-05-31
ingested: 2026-05-31
tags: [ai-agents, agent-personality, soul-md, hermes, openclaw]
---

## Tese central

Personality files eficazes especificam comportamento padrão em situações reais — não acumulam adjetivos. O que importa é o que o agente faz por default quando uma situação real aparece, e os melhores resultados vêm de remover restrições corporativas e permitir opiniões fortes.

## Argumentos principais

- **Default behavior > adjetivos** — empilhar "smart, warm, reliable" não muda comportamento; é necessário especificar o que o agente faz por default em situações reais
- **SOUL.md é o coração** — OpenClaw e Hermes ambos usam SOUL.md; diferença é storage: OpenClaw distribui por workspace files, Hermes empacota em profile portátil
- **Opiniões fortes quebram o tom corporativo** — um único "well-placed curse" faz mais pelo tom direto do que dez regras mandando "ser direto"
- **Memória por relevância** — o que o agente lembra não deve ser qualquer coisa dita, mas o que é relevante para o trabalho; curar memória é tão importante quanto criá-la
- **Trabalho repetitivo vira script** — padrões de trabalho recorrentes devem virar scripts automáticos no SOUL, não ficar dependendo de instrução explícita a cada vez

## Key insights

- "Molty prompt" do OpenClaw: reescreva SOUL.md com opiniões fortes, delete regras corporativas, nunca abra com "Great question", brevidade obrigatória
- Distinção OpenClaw vs. Hermes: OpenClaw = workspace files (granular, editável), Hermes = profile portátil (copiável como unidade)
- Armadilha da personalidade: quanto mais longa fica, mais genérica parece — SOUL.md vira "junk drawer"

## Implicações para o vault

- Relevante para o arquivo de identidade do Nexus (`04-SYSTEM/agents/nexus.md`) e do cluster-agent
- O conceito de "instinct" do ECC e o "default behavior" do SOUL.md convergem: o que o agente faz sem instrução explícita

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]]
- [[03-RESOURCES/sources/ecc-agent-harness-system]]
- [[04-SYSTEM/agents/nexus]]
