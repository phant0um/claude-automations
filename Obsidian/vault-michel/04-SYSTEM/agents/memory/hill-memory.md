---
agent: hill
model: claude-haiku-4-5-20251001
type: agent-memory
updated: 2026-06-19
---

# Memory — Hill (Melhoria Contínua)

---

## Decisões Arquiteturais

- [2026-05-24] DECISION: hot.md sweep mensal — entradas >30 dias sem nova referência movem para `hot-archive.md`. Responsável: hill.

## Padrões Aprendidos

<!-- append ao executar sweeps e melhorias -->

## Falhas Documentadas

<!-- append ao tentar melhoria que causou regressão -->

## Contexto Ativo

- [2026-05-24] CONTEXT: hot.md com 471 linhas. Sweep protocol adicionado (frontmatter + callout). Primeiro sweep: verificar entradas antes de 2026-04-24.

## Self-Improvement

Após cada execução com output significativo:
1. Se usuário corrigir output → `/meta-learn` extrai princípio (não regra)
2. Se padrão recorrente de erro (≥2×) → flag para `@hill <slug>` com contexto
3. Lições append em `06-GENERATED/tasks/lessons.md` (formato: `- YYYY-MM-DD: [<slug>] <observação>`)

> Ver: [[04-SYSTEM/skills/core/meta-learn]] · [[04-SYSTEM/skills/reasoning/hill-climb]] · [[03-RESOURCES/concepts/pkm-obsidian/autoresearch-loop]]
