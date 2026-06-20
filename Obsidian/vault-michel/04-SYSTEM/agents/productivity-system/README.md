---
title: "Productivity System"
description: "Sistema de produtividade pessoal: GTD, OKRs e reflexão estruturada"
version: "1.0.0"
updated: 2026-05-16
status: active
tags: [agents, produtividade, gtd, okr, journaling, claude]
---

# Productivity System

3 agentes especializados orquestrados pelo **Pulso** para operar o ciclo completo de produtividade pessoal — do dia a dia ao trimestre.

## Arquitetura

```
Pulso (orchestrator)
├── Eixo  → GTD: captura, clarificação, next actions, weekly review
├── Norte → OKRs: definir, check-in, grade, retrospectiva trimestral
└── Eco   → Reflexão: journaling diário, semanal e mensal, análise de padrões
```

## Ciclos

| Ciclo | Agente | Frequência |
|-------|--------|-----------|
| Next actions / captura | Eixo | Diário |
| Weekly review | Eixo | Semanal |
| Reflexão semanal | Eco | Semanal |
| Check-in OKR | Norte | Mensal |
| Retrospectiva | Eco | Mensal |
| Grade e novo ciclo OKR | Norte | Trimestral |

## Quando usar qual

| Situação | Agente |
|----------|--------|
| Tudo na cabeça, precisa organizar | Eixo (captura) |
| O que fazer agora? | Eixo (next actions) |
| Fechar semana, o que ficou em aberto | Eixo (weekly review) |
| Definir metas do trimestre | Norte |
| Checar progresso das metas | Norte (check-in) |
| Refletir sobre o dia / semana / mês | Eco |
| Padrão que se repete, travamento recorrente | Eco (análise de padrões) |
| Não sei onde começar | Pulso |

## Skills

| Skill | Função | Usado por |
|-------|--------|-----------|
| `gtd-horizons.md` | 6 níveis GTD + checklist weekly review | Eixo |
| `okr-format.md` | Estrutura OKR + escala de grade | Norte |

## Como invocar

```
@pulso — [descreva o que precisa]
@eixo — capturar: [lista de tudo na cabeça]
@eixo — weekly review
@eixo — quais são minhas próximas ações?
@norte — definir OKRs Q[N] [ano]
@norte — check-in OKR
@eco — prompt do dia
@eco — reflexão da semana
@eco — retrospectiva do mês
```

## project-setup (Claude Projects)

System prompt: `"Leia o documento Pulso.md e opere conforme as instruções nele."`

Upload:
```
Pulso.md
Eixo.md
Norte.md
Eco.md
skills/gtd-horizons.md
skills/okr-format.md
docs/progress.md        ← atualizar após cada weekly review e check-in OKR
```
