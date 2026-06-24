---
title: "@blader — Adversarial Subagent Review Gate"
type: source
source_url: "https://x.com/blader/status/2058303538674217319"
author: "@blader"
published: 2026-05-23
ingested: 2026-05-28
tags: [subagents, review, adversarial, quality-gate, planning, meta-runs]
---

# @blader — Adversarial Subagent Review Gate

## Tese central

Adicionar um portão de revisão de subagente adversarial ao plano de execução aumenta significativamente a qualidade e a durabilidade de runs longas no Claude Code.

## Key insights

- **Técnica:** antes de marcar qualquer tarefa como concluída, o plano exige validação por um subagente adversarial separado.
- **Prompt de injeção no plano:**
  > "atualize este plano: antes de marcar uma tarefa como concluída, valide a tarefa com uma revisão de subagente adversarial"
- Contexto: usar com `/meta` (goal loop) para runs de maior duração e qualidade.
- Subagente adversarial tem contexto isolado → menos viés de confirmação do agente principal.
- Padrão lightweight: não requer scaffold complexo — basta atualizar o plano com a instrução.

## Implicações para o vault

- Implementação concreta de [[03-RESOURCES/concepts/agent-systems/]] review gate pattern.
- Complementa [[03-RESOURCES/concepts/claude-code-tooling/goal-command]] — o portão adversarial pode ser embutido diretamente em `GOAL.md`.
- Candidato a skill: `adversarial-review-gate` que injeta o portão em qualquer plano ativo.
- Ver também [[03-RESOURCES/sources/ai-agents-harness/clipping-four-subagent-patterns-2026]] para padrões de subagentes.

## Links

- [[03-RESOURCES/concepts/claude-code-tooling/goal-command]]
- [[03-RESOURCES/concepts/agent-systems/]]
- [[03-RESOURCES/sources/ai-agents-harness/clipping-four-subagent-patterns-2026]]
