---
title: "AI Skills Testing Process"
type: concept
created: 2026-06-10
updated: 2026-06-10
tags: [agent-systems, skills, testing, evaluation]
---

# AI Skills Testing Process

Metodologia para validar empiricamente se um agente invoca uma skill custom de forma confiável, em vez de assumir que o frontmatter está bem escrito.

## O que é

Um harness de testes com 3 componentes:
1. **Core tool**: script que envia prompts ao agente (`claude --print --verbose --output-format stream-json`) e captura logs.
2. **Casos de teste**: prompts "positivos" (cobrindo o domínio da skill) e "negativos"/edge (tarefas genéricas que não deveriam invocar a skill, expondo falsos positivos).
3. **Heurísticas de log parsing**: detectam invocação via padrões no JSON (`"name":"Skill"`, `"command":"<skill-name>"`) ou strings de log (`Launching skill: <name>`).

Métricas: `CORE_SUCCESS_RATE` (taxa de invocação correta em positivos), `EDGE_FALSE_POSITIVE_RATE` (invocação indevida em negativos), `OVERALL_ACCURACY`. Suite roda múltiplas vezes para compensar não-determinismo.

## Por que importa

Baseline medido pela Pinterest Engineering: 73% (Codex GPT 5.2-codex) e 62% (Claude Opus 4.5) — inaceitável para workflows críticos. A técnica de maior ROI e agnóstica a agente é enriquecer a `description` do frontmatter com contexto arquitetural específico. Linguagem agressiva ("YOU MUST LOAD THIS SKILL IF") funciona mas é considerada feia. Combinar técnicas só compõe ganhos no Codex, não no Claude. Pedir ao agente para "melhorar" suas próprias adições de skill reduz a taxa de invocação.

## Exemplo

100 testes = 5 runs × (15 prompts positivos + 5 negativos), aplicado à skill "rx-mvvm-architecture" (arquitetura iOS da Pinterest).

## Related
- [[03-RESOURCES/sources/ai-skills-testing-process-pinterest]]
- [[03-RESOURCES/sources/skill-authoring-best-practices]]
- [[03-RESOURCES/concepts/agent-systems/_index]]
