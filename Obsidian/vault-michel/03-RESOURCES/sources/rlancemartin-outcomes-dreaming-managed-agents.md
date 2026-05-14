---
title: "RLanceMartin — Outcomes & Dreaming in Claude Managed Agents"
type: source
source_file: "Clippings/Thread by @RLanceMartin on Thread Reader App.md"
origin: thread no X (@RLanceMartin)
ingested: 2026-05-14
tags: [claude-managed-agents, self-verification, dreaming, memory, harness]
---
# RLanceMartin — Outcomes & Dreaming in Claude Managed Agents

> [!key-insight] Core point
> Self-verification (Outcomes loop) + offline cross-session learning (Dreaming) são dois novos pilares do Claude Managed Agents apresentados no Code With Claude.

## Conteúdo

### Outcomes (Self-Verification)
- É um "Ralph loop": compara output do agente contra um rubric fornecido pelo usuário via grader sub-agent
- Benefício de isolamento: verificador separado é mais confiável (ver: [Anthropic harness-design blog](https://www.anthropic.com/engineering/harness-design-long-running-apps))
- Exemplo: agente gerou UI com métricas em SVG; Outcomes melhorou timing de renderização iterativamente
- **Rubric tuning**: usar Claude Code + `claude-api` skill para puxar session logs e atualizar rubric com base em feedback

### Dreaming (Cross-Session Learning)
- Processo **offline** (entre sessões) para pruning/consolidação de memória e aprendizado de skills a partir de padrões observados
- Complementa a memória intra-sessão (agentes escrevem no filesystem enquanto trabalham)
- Talk de @maheshmurag: [youtu.be/RtywqDFBYnQ](https://youtu.be/RtywqDFBYnQ)
- Talk de @jess__yan + Lance: [youtube.com/live/E9gaQHrw_rg](https://www.youtube.com/live/E9gaQHrw_rg)

### Memory em Managed Agents
- Lançado semanas antes: agentes escrevem num filesystem **durante** a sessão
- Dreaming opera **entre** sessões — dois layers distintos

## Conexões
- [[03-RESOURCES/entities/Claude-Managed-Agents]]
- [[03-RESOURCES/entities/Lance-Martin]]
- [[03-RESOURCES/concepts/agent-memory-architecture]]
- [[03-RESOURCES/concepts/self-improving-vault]]
- [[03-RESOURCES/concepts/agentic-harness-engineering]]
