---
title: "Revisão Semanal — 2026-06-22"
type: report
generated_by: hermes-agent
created: 2026-06-22
---

# Revisão Semanal — 2026-06-22

## System Review

### Stale (>30d por frontmatter `updated:`)
- `04-SYSTEM/vault-identity.md` — updated: 2026-05-24 (29d, 1 dia antes do threshold)
- `03-RESOURCES/entities.md` — updated: 2026-05-31 (22d)
- `03-RESOURCES/index.md` — updated: 2026-05-31 (22d)
- `03-RESOURCES/session-startup-checklist.md` — updated: 2026-05-28 (25d)
- `03-RESOURCES/log.md` — **NO-UPDATED** (sem campo `updated:` no frontmatter)

### Drift detectado
- **Agent count:** 157 arquivos .md em `04-SYSTEM/agents/` (inclui READMEs, _index, project-setup). AGENTS.md registra 94 agentes roteáveis. Diferença = artefatos de suporte (README, project-setup, _index, _template), não drift de agentes.
- **Agentes sem `model:`:** 0 (após fix de 2026-06-22 que adicionou `model:` aos 5 agentes TJAM).
- **Agentes sem `name:`** (frontmatter): 9 arquivos em `memory/` (nexus-memory, sentinel, maestro, facet, hill-memory, bastion, stratum, neuron, _template) + 1 em `tjam-institutional-system/project-setup.md`. Memory agents são arquivos de memória, não agentes roteáveis — falso positivo.

### Vault Health
- Concepts+entities criados em 7d: **0** (276 sources ingeridas — reuso saudável de concepts maduros, não estagnação)
- Queue depth: **1** task
- Rotinas ativas: **14**
- Alertas: queue <5 ✅ | concepts=0 mas sources=276 → reuso, não estagnação (ver F3.5 do meta-coaching)

### Ref-graph CLAUDE.md (F0.1)
- Fecho transitivo (prof. 2): **375 arquivos**
- Stale (>30d): **0**
- Dead-refs: **37** (maioria padrões wikilink de exemplo em código/bash: `[[! -f "$file"]]`, `[[02-AREAS/fiap/fase-X-index.md]]` com escaped dots, `memory/*.md` paths relativos — não são refs reais)
- Ambíguos: **9** (README.md, _template.md, ai-agents-index.md, changelog.md, claude-hermes-proxy.md, decisions.md, kore.md, overview.md, progress.md — bare-name wikilinks com múltiplos candidatos)

### Action items — System Review
- [média] `03-RESOURCES/log.md` sem campo `updated:` no frontmatter — adicionar
- [baixa] `04-SYSTEM/vault-identity.md` a 1 dia do threshold — refresh na próxima semana se não atualizado

## Lint

### F1.1 — Wiki lint
- Orphans: scan timed out (vault muito grande para grep recursivo por arquivo). Estimativa baseada em revisão anterior: ~1 orphan concept.
- Dead wikilinks: 15 amostrados, **todos falsos positivos** de bash `[[ ]]` em code blocks (não são wikilinks reais).
- Stale claims: 0 (fecho CLAUDE.md 100% fresh)
- Frontmatter gaps: **1197** (1176 sources, 21 concepts, 0 entities) — sources sem campos completos é esperado (ingest em massa)
- Duplicate concepts: 0 novos
- Empty sections: não scanneado (timeout)

### F1.2 — Manifest
- Duplicates (mesmo hash): **59**
- Null fields (pages_created ou category null): **1317** — conforme L02, `category` é opcional; orphans reais = `pages_created == null AND status == null`
- **NÃO alterar manifest.**

### F1.3 — Hot cache
- hot.md: **247 linhas** (abaixo do ceiling 300 — sem trim necessário)

### F1.4 — Agent system scan
- 13 sistemas em `04-SYSTEM/agents/` (core, edu, finance, marketing, knowledge, productivity, travel, nexus-agent, tjam-institutional, concurso-coach, fullstack, hobby, memory)
- Agentes sem frontmatter `name:`: 9 (todos em `memory/` — artefatos de memória, não agentes)
- `project-setup.md` presente em: concurso-coach, edu, finance (verificado via hot.md)

### F1.5 — Lessons
- `06-GENERATED/tasks/lessons.md`: 76 linhas, **15 entries** (limite 30) — sem necessidade de consolidação

### F1.5b — Frontmatter audit
- 1971 arquivos verificados, 1197 com gaps
- Output: `06-GENERATED/frontmatter-audit-2026-06-22.md`
- 1176 gaps em sources (esperado — ingest em massa), 21 em concepts

### F1.6 — Queue cleanup
- `07-QUEUE/.archive/` entries >30d: **0** — sem cleanup necessário

## Conexões

- Sources recentes: **276** | Pool antigo: **80**
- Conexões encontradas: **3** (cross-domain=1, padrões-3+=1 já documentada, evolução=1 média confiança)
- Wikilinks adicionados: **2** (bidirecional: quant-hmm ↔ algorithmic-trading; unidirecional: quant-hmm → trading-automation)
- → [[06-GENERATED/connections/2026-06-22-connections]]

## Meta-Coaching

- Commits analisados: **8**
- Top waste pattern: **Structural thrashing em `04-SYSTEM/agents/`** (3 reorgs/7d — freeze até 2026-07-05 chegou tarde)
- WP2 recorrência: 130 arquivos não commitados (commit gate só cobre paths rastreados)
- WP3 recorrência: 0 atividade FIAP/concurso, 3ª semana
- Top fixes: (1) respeitar freeze até 2026-07-05, (2) refinar alerta Vault Health (distinguir estagnação de maturidade)
- → [[06-GENERATED/meta-coaching/2026-06-22-meta-coaching]]

## Action items (prioridade)

- [alta] Respeitar freeze de reorgs em `04-SYSTEM/agents/` até 2026-07-05 (decisão já em `decisions.md`)
- [média] Refinar alerta "concepts=0 = estagnação" em `revisao-semanal.md` FASE 0: distinguir `concepts=0 AND sources>50` (reuso saudável) de `concepts=0 AND sources=0` (estagnação real)
- [média] `03-RESOURCES/log.md` sem campo `updated:` — adicionar ao frontmatter
- [baixa] `04-SYSTEM/vault-identity.md` a 1 dia do staleness threshold — monitorar

### Firmware drift (human-gated)
- [ ] Dead-refs do fecho CLAUDE.md (37): maioria são padrões wikilink de exemplo em bash code blocks e paths relativos `memory/*.md` — requer sessão Nexus para distinguir refs reais de falsos positivos (não autônomo)