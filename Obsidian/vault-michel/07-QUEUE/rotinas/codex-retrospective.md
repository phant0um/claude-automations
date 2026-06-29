---
title: Codex Retrospective — Padrões Temporais de Comportamento
type: rotina
schedule: "domingo 5h"
version: 1
created: 2026-06-29
tags: [rotina, retrospective, self-improvement, temporal, session-review]
---

# Codex Retrospective

Revisão temporal dos últimos 14 dias para identificar padrões de comportamento, erros recorrentes, e oportunidades de melhoria. Complementar à revisao-semanal (que olha a semana) — esta olha **2 semanas para trás** com perspectiva temporal mais ampla.

**Princípio:** revisao-semanal captura o que aconteceu nesta semana. evolve captura padrões da sessão atual. codex-retrospective captura padrões que só são visíveis com perspectiva de 2+ semanas — drift lento, regressões silenciosas, padrões que uma semana não revela.

**Skill:** `codex-retrospective` — carregar com `skill_view(name='codex-retrospective')` antes de executar.

**Referências:**
- [[04-SYSTEM/skills/core/evolve]] — complementar: retrospective = N dias para trás; evolve = sessão atual
- [[04-SYSTEM/skills/core/meta-learn]] — se retrospective revelar correções recorrentes
- [[04-SYSTEM/agents/core/hill]] — recebe propostas do retrospective como levers

---

## NEXUS GATE — Início

```bash
tail -20 04-SYSTEM/wiki/hot.md
```

`@nexus codex-retrospective iniciando — $(date -I)`

Nexus lê hot.md, verifica contexto. Autoriza ou bloqueia.

---

## FASE 1 — Coletar histórico [Haiku]

Skill: `codex-retrospective` — Step 1 (Coletar histórico)

```bash
cd ~/Obsidian/vault-michel

# Commits dos últimos 14 dias
git log --since="14 days ago" --name-only --pretty=format:"%ad | %s" --date=short | head -100

# Volume por área
git log --since="14 days ago" --name-only --pretty=format:"" | \
  grep -oE "^[^/]+" | sort | uniq -c | sort -rn

# Errors.md entradas dos últimos 14 dias
grep -A5 "^## 2026-06-2[0-9]" 04-SYSTEM/wiki/errors.md 2>/dev/null | head -60

# Lessons log dos últimos 14 dias
tail -30 06-GENERATED/tasks/lessons.md 2>/dev/null

# Relatórios gerados nos últimos 14 dias
ls -t 06-GENERATED/revisao-semanal/*.md 06-GENERATED/meta-coaching/*.md 06-GENERATED/audits/*.md 2>/dev/null | head -10
```

## FASE 2 — Analisar padrões [Sonnet]

Skill: `codex-retrospective` — Step 2 (Analisar padrões)

Para o período revisado, identificar:

| Categoria | Pergunta |
|-----------|---------|
| Erros repetidos | Mesmo tipo de erro ≥2x em 14d? |
| Desvios de princípio | Ações fora das guidelines de CLAUDE.md? |
| Fricção recorrente | Mesmo passo manual ≥3x? |
| Gaps de skill | Tarefa sem skill existente ≥2x? |
| Routing incorreto | Modelo errado para tipo de tarefa? |
| **Drift temporal** | Comportamento mudou gradualmente de semana 1 → semana 2? |
| **Regressão silenciosa** | Algo que funcionava parou de funcionar sem alerta? |

## FASE 3 — Proposta [Sonnet]

Skill: `codex-retrospective` — Step 3 (Proposta — máx 3 itens)

```markdown
## Retrospectiva [YYYY-MM-DD] — últimos 14 dias

### Padrão detectado 1
- **O que aconteceu:** <descrição concreta com exemplos de 2+ commits/sessions>
- **Causa provável:** <diagnóstico>
- **Proposta:** <mudança específica — onde aplicar, o quê mudar>
- **Arquivo alvo:** `<path>`

### Padrão detectado 2
...

### Itens sem mudança proposta
- <observação sem ação necessária>
```

## FASE 4 — Gate antes de aplicar [Sonnet]

Toda proposta de mudança em `04-SYSTEM/agents/` ou `CLAUDE.md` requer confirmação explícita do usuário antes de aplicar. Esta rotina produz a proposta; `@nexus` ou usuário aprova.

Mudanças em `04-SYSTEM/skills/` podem ser aplicadas autonomamente se escopo for cirúrgico (1 arquivo, ≤20 linhas).

## FASE 5 — Disparar hill/meta-learn se padrão confirmado [Sonnet]

Se FASE 2 revelar:
- **Correção recorrente (≥2×)**: disparar `meta-learn` para extrair princípio
- **Erro de comportamento de agente (≥2×)**: flag para `@hill <slug>` com contexto
- **Drift temporal confirmado**: flag para `@hill <slug>` com diagnóstico de drift

## FASE 6 — Output

`06-GENERATED/retrospective/$(date -I)-retrospective.md`

```markdown
---
title: "Retrospectiva — YYYY-MM-DD"
type: report
period: YYYY-WNN-WNN+1
days_analyzed: 14
commits_analyzed: N
generated_by: hermes-cron
created: YYYY-MM-DD
---
```

---

## Self-improvement log `[bash]`

```bash
mkdir -p 06-GENERATED/tasks
echo "- $(date -I): [codex-retrospective] 14d, commits=$COMMITS_COUNT, patterns=$PATTERNS_FOUND, proposals=$PROPOSALS_COUNT, hill_flags=$HILL_FLAGS" >> 06-GENERATED/tasks/lessons.md
```

---

## Guardrails

- Máximo 3 padrões identificados — forçar priorização
- Nenhuma mudança aplicada em agents/CLAUDE.md sem gate explícito
- Propostas para skills: aplicáveis autonomamente se escopo cirúrgico (1 arquivo, ≤20 linhas)
- Drift temporal só é válido se confirmado por ≥2 pontos de dados (não 1 sessão isolada)

---

## Changelog

- v1 (2026-06-29): criado para fechar Gap 7 — retrospective temporal sem periodicidade. Semanal, domingo 5h (1h antes da revisao-semanal 4h... wait, revisao é 4h AM e esta é 5h — ajustar para 3h para rodar antes). Schedule: domingo 5h (após revisao-semanal 4h, lê seu output como contexto). 17 rotinas → 17.