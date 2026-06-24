---
title: "Hermes Agent Masterclass"
type: source
category: guide
author: "[[Akshay-Pachaar]]"
published: 2026-04-30
ingested: 2026-05-16
source_url: "https://x.com/akshay_pachaar/status/2054564519280804028"
tags: [hermes, agent-framework, memory, skills, GEPA, multi-agent]
triagem_score: 8
---

# Hermes Agent Masterclass

Guia completo de [[hermes|Hermes Agent]] por [[Akshay-Pachaar]]: arquitetura interna, sistema de memória em 3 tiers, skills auto-evolutivas, GEPA, e setup de múltiplos agentes especializados.

## Key Insight

Hermes é o único agente open-source que combina os três: **runtime skill learning** + **persistent multi-layer memory** + **offline optimization pipeline (GEPA)**. Resultado: agente que melhora quanto mais você usa.

## Arquitetura Core

Tudo flui por uma única classe `AIAgent` em `run_agent.py`. CLI, gateway de mensagens, batch runner, IDE — todos são entry points no mesmo agente.

- **Loop:** ReAct-style, síncrono
- **6 execution backends:** local terminal, Docker, SSH, Modal, Daytona, Singularity
- **Hard cap:** 90 turnos/task (anti-loop, vale para subagentes também)
- **Model-agnostic:** translation layer unifica OpenAI / Anthropic / Google / local (Ollama)

## SOUL.md — Identity Layer

`~/.hermes/SOUL.md` — slot #1 no system prompt, antes de tudo. Define personalidade, tom, limites. Estático (hand-authored). Tudo o que o agente aprende (memória, skills) passa pelo filtro desta identidade.

## Memória em 3 Tiers

Ver [[gepa|GEPA]] para otimização offline das skills.

| Tier | O que é | Capacidade | Velocidade |
|------|---------|------------|------------|
| 1 | `MEMORY.md` (2.200 chars) + `USER.md` (1.375 chars) | Tiny | Sempre no context |
| 2 | SQLite FTS5 — histórico completo de sessões | Ilimitado | Requer busca ativa |
| 3 | 8 external memory providers plugáveis | Varia | Pre-fetch automático |

**Tier 1 comprime quando >80%** — agente consolida entradas antigas em versões mais densas.

## Skills Auto-Evolutivas

Skills são `.md` com YAML frontmatter. Anatomia:

```yaml
---
name: k8s-pod-debug
description: Activate for crashing pods, CrashLoopBackOff...
version: 1.2.0
author: agent
---
```

**Progressive disclosure** (economia de tokens):
- Level 0: nomes + descriptions (~3k tokens para catálogo completo)
- Level 1: conteúdo completo quando necessário
- Level 2: arquivos de referência dentro da skill

**Criação autônoma via `skill_manage`** — dispara quando: task complexa (5+ tool calls), erro resolvido após tentativas, usuário corrigiu approach, workflow não-trivial descoberto.

## The Curator (Background GC)

Não é cron daemon — **inactivity check**: 7 dias desde último run + agente idle 2h → fork em background.

- **Fase 1** (determinístico): stale após 30 dias sem uso; archived após 90 dias
- **Fase 2** (LLM, até 8 iterações): keep / patch / consolidate / archive por skill
- Nunca auto-deleta — pior caso: arquivo em `~/.hermes/skills/.archive/`
- Snapshot `tar.gz` antes de cada pass — rollback com 1 comando
- `hermes curator pin <skill>` — protege de archive (mas patches ainda passam)

## GEPA — Otimização Offline

Ver [[gepa]] para detalhes completos. Resumo: pipeline offline que lê traces de execução, identifica falhas reais (não auto-avaliação), propõe variantes via busca evolutiva, e abre PR (nunca commit direto). Custo: $2–10/run. Sem GPU.

## Multi-Agent com Profiles

```bash
hermes profile create designer --clone
hermes profile create programmer --clone
hermes profile create researcher --clone
```

Cada profile = instância isolada (config, memória, skills, SOUL.md próprios). Nada compartilhado por padrão.

**Programmer profile + Claude Code:**
- Hermes orquestra; Claude Code executa (lê arquivos, edita, git, testa)
- Usa OAuth da assinatura Max — sem ANTHROPIC_API_KEY separada
- Ativar: prompt único "I have Claude Max subscription... use Claude Code for all executions"

## Skills Hub

687 skills disponíveis:
- 87 built-in | 79 opcionais | 16 da Anthropic | 505 do LobeHub

```bash
hermes skills tap add yourname/your-skills-repo
hermes skills install yourname/skill-name
```

## Cron em Linguagem Natural

```bash
# exemplos
/cron add "every weekday at 8am" "daily AI digest to Telegram"
/cron add 30m "check build"
/cron add "every 2h" "server status"
```

Gateway daemon tick = 60s. Jobs em sessões isoladas. Output em `~/.hermes/cron/output/`.

## Layout `~/.hermes/`

```
~/.hermes/
├── SOUL.md          # identity (slot #1 system prompt)
├── config.yaml      # source of truth (modelo, tools, MCP)
├── .env             # secrets
├── memories/
│   ├── MEMORY.md    # agent facts (2.2k chars max)
│   └── USER.md      # user model (1.375k chars max)
├── skills/          # skills hub + agent-created
├── state.db         # SQLite FTS5 (session search)
└── cron/jobs.json   # scheduled jobs
```

## SOUL.md como diferencial arquitetural

A maioria dos agentes armazena "identidade" dentro do system prompt, misturada com instruções operacionais. O Hermes separa isso explicitamente: SOUL.md é slot #1 no system prompt, carregado antes de qualquer instrução operacional, memória, ou skill. Isso não é apenas organização — é uma decisão de precedência: a identidade do agente filtra tudo o que segue.

Em prática, significa que quando o Hermes aprende um novo pattern via GEPA ou cria uma nova skill via `skill_manage`, o resultado passa pelo filtro da identidade antes de ser incorporado. Skills que contradizem os limites declarados no SOUL.md são ou descartadas pelo Curator ou sinalizadas para revisão. É um mecanismo de alignment de escala pequena: não garante safety, mas garante coerência de comportamento com a identidade declarada.

Para o vault-michel, o CLAUDE.md de projeto serve uma função análoga ao SOUL.md — define o contexto de operação antes de qualquer instrução específica. A diferença é que SOUL.md é pensado como imutável (hand-authored, não editado por automação), enquanto CLAUDE.md pode ser atualizado via operações de melhoria contínua.

## O Curator como garbage collection de knowledge

O mecanismo de Curator — inactivity check em vez de cron daemon, com snapshot antes de cada pass — resolve um problema específico de agentes que acumulam skills ao longo do tempo: sem limpeza, a biblioteca de skills cresce indefinidamente, degradando retrieval e aumentando ruído no contexto.

O design de nunca auto-deletar (pior caso: arquivo em `.archive/`) é uma decisão conservadora que prioriza recuperabilidade sobre limpeza agressiva. Uma skill arquivada pode ser restaurada; uma skill deletada não pode. Para sistemas onde as skills representam conhecimento operacional acumulado ao longo de meses de uso real, a recuperabilidade é mais valiosa do que economizar storage.

O cap de 8 iterações por skill na Fase 2 é outro design conservador: limita o quanto o LLM pode modificar uma skill por pass, evitando que múltiplas iterações compoundem erros de refinamento.

## GEPA e o custo do aprimoramento offline

O custo de $2–10 por run do GEPA é relevante como referência de escala para otimização offline de harness. Este é o custo de uma iteração de evolução — busca de variantes via evolutionary search, avaliação em traces reais, proposta de PR. Para skills críticas usadas diariamente, esse custo amortiza rapidamente. Para skills ocasionais, a otimização via GEPA pode não ter ROI positivo.

A decisão de nunca fazer commit direto (sempre via PR) é uma escolha de governance: mantém um humano no loop para toda modificação de skill proposta por automação. Em um sistema onde as skills definem o comportamento operacional do agente, ter essa revisão é um guardrail de qualidade que o GEPA sozinho não fornece.

## Relacionado

- [[hermes]] — entity page completa
- [[gepa]] — Genetic-Pareto Prompt Evolution (otimização offline)
- [[Nous-Research]] — organização criadora
- [[Akshay-Pachaar]] — autor
- [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]] — pattern do Curator
- [[04-SYSTEM/agents/core/claude-hermes-proxy]] — proxy que permite Hermes usar Claude Code como backend
