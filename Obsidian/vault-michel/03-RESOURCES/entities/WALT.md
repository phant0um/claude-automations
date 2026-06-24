---
title: WALT (Web Agents that Learn Tools)
type: entity
subtype: research-method
created: 2026-04-19
updated: 2026-05-19
tags: [web-agents, skill-learning, tool-use, reverse-engineering]
paper: https://openreview.net/forum?id=cgIDqcJcoI
venue: ICLR 2026
---

# WALT — Web Agents that Learn Tools

**Framework** para agentes web que reverse-engineered funcionalidade interna de websites em tool calls determinísticos.

**Autores:** Viraj Prabhu, Yutong Dai et al. — Salesforce AI Research (ICLR 2026)

## Como funciona

- Analisa o funcionamento interno do website (APIs, formulários, fluxos)
- Converte em **deterministic tool calls** com input schemas validados
- 8.2 skills médias por site (cobertura muito limitada)

## Limitações

- Apenas 41 skills totais — cobertura esparsa
- **Black-box deployment** — sem step-level guidance
- Alta utilization rate (22%) mas baixa cobertura absoluta (~1.8 unique skills invoked por site)
- Depende de exploração de internals — não escalável para live websites

## Comparação no campo

| Eixo | WALT | WebXSkill |
|------|------|----------|
| Executável | ✓ | ✓ |
| Step guidance | ✗ | ✓ |
| Aquisição | Reverse-engineering | Trajetórias sintéticas |
| Context-aware | ✗ | ✓ |

## Conexões no vault

- [[03-RESOURCES/concepts/agent-systems/web-agent-skill-learning]] — campo de pesquisa
- [[03-RESOURCES/sources/claude-code-skills/webxskill-skill-learning-autonomous-web-agents]] — paper comparativo
- [[03-RESOURCES/entities/SkillWeaver]] — método similar
