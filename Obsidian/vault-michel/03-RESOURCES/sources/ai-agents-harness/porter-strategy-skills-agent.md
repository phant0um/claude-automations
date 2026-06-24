---
title: "Porter Strategy Skills: 12 Skills Executáveis para Análise Competitiva com AI"
type: source
source: "Clippings/gnurioporter-strategy-skills 12 executable AI agent skills..."
url: "https://github.com/gnurio/porter-strategy-skills"
published: 2026-05-24
ingested: 2026-05-28
tags: [ai-agent-skills, competitive-strategy, porter, business-strategy, claude-code]
triagem_score: 7
---

## O que é

12 skills executáveis + 1 orchestrator extraídos de *Competitive Strategy* de Michael Porter. Cada sub-fator, checklist e árvore de decisão foi validado contra o livro original via NotebookLM. Disponível para Claude Code, Cursor, e Cowork.

## As 12 skills por tier

### Tier 1 — Entry points (sem dependências)

| Skill | Descrição | Cap. Porter |
|-------|-----------|-------------|
| `/analyze-five-forces` | 32 sub-fatores (8 barreiras entrada, 8 rivalidade, 7 poder comprador, 6 poder fornecedor, 3 substitutos) | Ch. 1 |
| `/profile-competitor` | Perfil 4-componentes: goals, assumptions, strategy, capabilities → response profile | Ch. 3 |
| `/map-strategic-groups` | 13 dimensões estratégicas, barreiras de mobilidade, rivalry por grupo | Ch. 7 |
| `/diagnose-industry-type` | Classifica indústria: emergente, fragmentada, em maturidade, declínio (14 processos evolutivos) | Ch. 8–12 |

### Tier 2 — Baseado em outputs do Tier 1

| Skill | Descrição |
|-------|-----------|
| `/select-generic-strategy` | Cost leadership vs. differentiation vs. focus + stuck-in-the-middle diagnostic |
| `/read-market-signals` | 11 tipos de sinais, bluff vs. commitment, fighting brands |
| `/analyze-market-entry` | Custo real de entrada, 7 mecanismos, modelagem de retaliação |
| `/strategize-fragmented-industry` | 5 passos, 11 causas de fragmentação, 9 estratégias de coping |
| `/strategize-emerging-industry` | Shape vs. adapt, pioneer vs. follower, 8 características estruturais |
| `/strategize-declining-industry` | Matriz 2×2: Leadership / Niche / Harvest / Divest |

### Tier 3 — Requer Tier 1+2

| Skill | Descrição |
|-------|-----------|
| `/design-competitive-move` | Move que explora mixed motives: rational response prejudica goals do competitor |
| `/audit-strategy-consistency` | 12 testes de consistência: internal, environmental fit, resource fit, communication |

### Orchestrator

`/orchestrate-porter-strategy` — detecta intent, roteia, encadeia outputs, acumula contexto. 5 workflows pré-construídos.

## Workflows pré-construídos

| Workflow | Chain |
|----------|-------|
| Quick Industry Check | five-forces → diagnose-type → type-strategy |
| Competitor Deep Dive | profile-competitor → read-signals |
| Should We Enter? | five-forces → market-entry |
| What Move? | profile-competitor → generic-strategy → competitive-move |
| Full Strategic Audit | five-forces → strategic-groups → generic-strategy → consistency |

## Conteúdo adicional

- `heuristics/catalog.md` — 57 heurísticas derivadas de Porter
- `failures/catalog.md` — 65 failure modes com causas raiz
- `routing/context-rules.md` — matriz de ativação completa

## Instalação Claude Code

```bash
git clone https://github.com/gnurio/porter-strategy-skills.git ~/.claude/skills/porter-strategy
```

## Ligações vault

- [[03-RESOURCES/concepts/ai-strategy-org/ai-org-design]]
- [[03-RESOURCES/concepts/ai-strategy-org/complexity-ratchet]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
