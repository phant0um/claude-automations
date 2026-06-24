---
title: Claude Opus 4.7
type: entity
category: model
updated: 2026-04-16
tags: [claude, anthropic, model, opus]
created: 2026-05-31
---

# Claude Opus 4.7

Modelo mais capaz da Anthropic, lançado em 16/04/2026. Substitui o [[03-RESOURCES/entities/Claude Code|Opus 4.6]] para coding, workflows enterprise e tarefas agênticas longas.

## Posicionamento na hierarquia

| Modelo | Uso ideal |
|---|---|
| **Opus 4.7** | Raciocínio profundo, coding, tarefas agênticas longas |
| Sonnet 4.6 | Web search, tarefas do dia a dia com internet |
| Haiku 4.5 | Varredura de arquivos, leituras rápidas, baixo custo |

> Regra: Opus = modelo. [[03-RESOURCES/entities/Claude-Cowork|Cowork]] = produto. Opus roda dentro do Cowork.

## Níveis de esforço

- `xhigh` — **novo nível padrão recomendado**; entre `high` e `max`; ideal para a maioria dos trabalhos agênticos
- `max` — reservar para tarefas extremamente difíceis; retorno decrescente; tende a "overthinking"

## Mudanças vs 4.6

- Respostas mais curtas em tarefas simples (não verboso por padrão)
- Chama ferramentas **menos**, raciocina **mais** antes de agir
- Spawna **menos subagentes** automaticamente — pedir paralelismo explicitamente
- **[[03-RESOURCES/concepts/learning-cognition/adaptive-thinking|Adaptive Thinking]]** substituiu Extended Thinking com budget fixo

## Boas práticas

- Especificar tudo no **primeiro turn**: intent, constraints, acceptance criteria, localização dos arquivos
- Reduzir número de turns — cada turn adiciona overhead de raciocínio
- Para mais raciocínio: `"Think carefully and step-by-step; this problem is harder than it looks"`
- Para resposta rápida: `"Prioritize responding quickly rather than thinking deeply"`
- Para paralelismo: pedir explicitamente que spawne múltiplos subagentes em paralelo

## Auto Mode

Disponível em research preview para **Claude Code Max**. Ativa-se com `Shift+Tab`. Elimina check-ins frequentes, ideal para tasks longas com contexto completo fornecido no primeiro turn.

## Notificações por hook

Claude pode criar seu próprio hook de notificação (ex: tocar um som ao terminar). Pedir diretamente ao modelo para configurar.

## AlphaZero Benchmark (Sherwood et al., 2026)

In a controlled evaluation of frontier coding agents building an AlphaZero-style Connect Four ML pipeline autonomously within 3 hours:
- Opus 4.7 won as first-mover against the Pascal Pons perfect solver **7/8 trials** (vs. 2/8 for Opus 4.6, 0/8 for GPT-5.4 and Gemini 3.1 Pro)
- Statistically significantly better than all other agents (Kruskal-Wallis H=20.2, p<0.001)
- Some trials exceeded the solver's 2000 BT rating — Opus 4.7's self-play training made it exploit weak opponents better than the deterministic solver
- Opus 4.7 models were smaller (~518K params) but stronger than Opus 4.6 (~1.79M params), suggesting better architectural choices
- Task went from impossible (January 2026) to near-saturated (April 2026)

See [[03-RESOURCES/sources/ai-agents-harness/frontier-coding-agents-alphazero-connect-four]].

## Sucessor

Substituído por [[03-RESOURCES/entities/Claude-Opus-48]] (lançado 2026-05-28/29), que adiciona effort control granular (low/medium/high/max/ultracode), dynamic workflows (até 1.000 subagentes), e fast mode 3x mais barato.

## Fontes

- [[03-RESOURCES/sources/misc-low-confidence/claude-knowledge-digest-abril-2026]]
- [[03-RESOURCES/sources/guides-courses-howtos/best-practices-claude-opus-47-claude-code]]
- [[03-RESOURCES/sources/ai-agents-harness/frontier-coding-agents-alphazero-connect-four]]
