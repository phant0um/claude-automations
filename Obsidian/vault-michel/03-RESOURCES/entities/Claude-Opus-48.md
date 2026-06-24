---
title: Claude Opus 4.8
type: entity
category: model
created: 2026-05-29
updated: 2026-05-29
tags: [claude, anthropic, model, opus, effort-control, dynamic-workflows]
---

# Claude Opus 4.8

Modelo mais capaz da Anthropic lançado em 2026-05-28/29. Substitui o [[03-RESOURCES/entities/Claude-Opus-47]] como padrão para coding agêntico e tarefas complexas. As mudanças operacionais (effort control, dynamic workflows, fast mode 3x mais barato) são mais significativas que os ganhos de benchmark.

## Especificações

| Spec | Valor |
|---|---|
| Model ID | `claude-opus-4-8` |
| Preço padrão | $5 / $25 por milhão tokens (input/output) |
| Fast mode | $10 / $50 por milhão tokens (2.5x mais rápido) |
| Fast mode anterior | $30 / $150 — agora 3x mais barato |
| Context window | 1.000.000 tokens |
| Max output | 128.000 tokens |
| SWE-bench | 88.6% (vs 87.6% em 4.7) |
| Bugs não sinalizados | 4x menos que 4.7 |
| Honestidade | 0% uncritical reporting de resultados falhos |

## Novas features operacionais

### Effort Control
Controle explícito de quanto raciocínio Claude aplica por task:

| Nível | Uso | Trade-off |
|---|---|---|
| `low` | Perguntas simples, formatação | Mínimo de tokens |
| `medium` | Coding cotidiano | Balanceado |
| `high` | **Default** (equivalente ao default do 4.7) | Balanceado |
| `max` | Decisões de arquitetura complexas | Máximo raciocínio |
| `ultracode` | Runs inteiras de workflow/audit | Max reasoning + orchestração automática |

- Rodar Low em 60% dos prompts simples corta gasto diário significativamente
- Config padrão: `export CLAUDE_CODE_DEFAULT_EFFORT=high`

### Fast Mode (3x mais barato)
- Antes: $30/$150 → Agora: $10/$50 por milhão tokens
- 2.5x mais rápido que standard
- Ideal para: large refactoring entre muitos arquivos, geração de código de specs, documentação, geração de testes

### Dynamic Workflows
- Até **1.000 subagentes por run** em paralelo
- Trigger: `/effort ultracode` ou descrever task grande naturalmente
- Claude planeja dinamicamente, quebra em subtasks, faz fan-out para subagents
- **Runs resumíveis** — se laptop fechar ou terminal fechar, workflow resume onde parou
- Budget cap obrigatório: `claude -p "task" --max-budget-usd 50.00`
- Custo: 100 subagents pode custar $50-200 dependendo de complexidade

### Honestidade melhorada
- 4x menos propenso a deixar flaws não sinalizados no próprio código
- 0% uncritical reporting de resultados falhos
- Prático: modelo que sinaliza incerteza no turno 15 economiza 2h de debug no turno 40

## Routing matrix (cost optimization)

```
Task                          Model      Effort    Mode
─────────────────────────────────────────────────────────
Quick question                Haiku      Low       Standard
Format this code              Sonnet     Low       Standard
Write a test                  Sonnet     Medium    Standard
Daily coding                  Opus 4.8   High      Standard
Code review                   Opus 4.8   High      Standard
Large refactor (speed)        Opus 4.8   High      Fast
Complex architecture          Opus 4.8   Max       Standard
Full codebase audit           Opus 4.8   Ultracode Dynamic
Migration (200+ files)        Opus 4.8   Ultracode Dynamic
```

Custo mensal estimado com routing correto: ~$205/mês vs ~$400-600/mês sem routing (economia ~50%).

## Config recomendada

```bash
export CLAUDE_CODE_DEFAULT_EFFORT=high
export CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1
export CLAUDE_CODE_SUBAGENT_MODEL="claude-sonnet-4-5-20250929"
export ANTHROPIC_MODEL="claude-opus-4-8"
```

## Fontes

- [[03-RESOURCES/sources/token-economy-cost/claude-opus-48-setup-guide]]
