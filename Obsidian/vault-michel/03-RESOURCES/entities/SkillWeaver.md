---
title: SkillWeaver
type: entity
subtype: research-method
created: 2026-04-19
updated: 2026-05-19
tags: [web-agents, skill-learning, python-api, autonomous-exploration]
paper: https://arxiv.org/abs/2504.07079
---

# SkillWeaver

**Framework** de aprendizado de skills para agentes web via exploração autônoma de websites.

**Autores:** Boyuan Zheng, Michael Y. Fatemi, Zora Zhiruo Wang, Yu Su et al. (2025)

## Como funciona

- Explora websites autonomamente (sem tasks predefinidas)
- Descobre padrões de interação
- Compila skills como **Python APIs** diretamente invocáveis

## Limitações (identificadas pelo WebXSkill)

- Skills são **black-box** — agente não vê o que acontece internamente
- **Sem step-level guidance** — difícil adaptar quando execução falha
- Concentra >60% das skills em Retrieval (extração de dados); categorias como Input (0.2%) e Editing (0.7%) quase ausentes
- 87.6 skills médias por site, mas só 37.7% das tasks invocam ao menos uma skill
- Skill execution success rate: 84.1% (alta, mas skills muito simples — 1.6 operações/skill em média)

## Comparação com WebXSkill

| Eixo | SkillWeaver | WebXSkill |
|------|------------|----------|
| Executável | ✓ | ✓ |
| Step guidance | ✗ | ✓ |
| Aquisição | Exploração autônoma | Trajetórias sintéticas |
| Context-aware retrieval | ✗ | ✓ (skill graph) |

## Conexões no vault

- [[03-RESOURCES/concepts/agent-systems/web-agent-skill-learning]] — campo de pesquisa
- [[03-RESOURCES/sources/claude-code-skills/webxskill-skill-learning-autonomous-web-agents]] — paper que compara com SkillWeaver
- [[03-RESOURCES/entities/WALT]] — método similar (code-based, sem guidance)
