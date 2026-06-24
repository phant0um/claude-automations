---
title: "Meta-Coaching — 2026-06-22"
type: report
period: 2026-W25
commits_analyzed: 8
generated_by: hermes-agent
created: 2026-06-22
---

# Meta-Coaching — 2026-06-22

Baseline: [[06-GENERATED/meta-coaching/meta-coaching-2026-06-07]]

## F3.1 — Atividade da semana

8 commits desde 2026-06-16, todos tocando `04-SYSTEM/` (204 arquivos). Working tree: **130 arquivos não commitados** — novamente trabalho substancial invisível ao git log.

## F3.3 — Cluster por intent

| Grupo | Commits | Arquivos | Escopo |
|-------|---------|----------|--------|
| agent | 3 | ~100 (flatten + root cleanup + ref merge) | reorg estrutural `04-SYSTEM/agents/` |
| rotina | 1 | rotinas (16→14, fusão A+B) | consolidação de rotinas redundantes |
| ingest | 2 | pipeline-semanal ×2 (06-19, 06-22) | 55 + 50 sources ingeridas |
| fix | 1 | pipeline-diario (28 files, drift fixes) | agents/skills drift correction |
| fiap/concurso | 0 | — | nenhuma atividade acadêmica |
| other | 1 | 04-SYSTEM session log | prompt-engineering ref merge |

## F3.4 — Waste patterns

### WP1 — Structural thrashing em `04-SYSTEM/agents/` (ALTO — 3ª semana)

**Evidência:** 3 commits de reorg estrutural em 7 dias (flatten 4c97666, root cleanup 977b88d, ref merge 849fd52). Semana anterior (06-07) já reportou hill-climbing audit com 9 itens de drift. Working tree tem 130 arquivos pendentes.

**Causa raiz:** Decisão de freeze (2026-07-05, registrada em `decisions.md` em 2026-06-22) ainda não tinha sido tomada na maior parte da semana. Reorgs em série sem cooldown entre eles — cada reorg cria drift que o próximo reorg tenta corrigir.

**Custo:** Cada reorg quebra wikilinks temporariamente, consome contexto de agentes que dependem da estrutura, e gera trabalho de reconciliation (`check-resolvable` rodou 3× em 2 dias). O freeze até 2026-07-05 é a resposta correta — mas chegou tarde.

### WP2 — 130 arquivos não commitados no working tree (ALTO — recorrência de WP2-2026-06-07)

**Evidência:** `git status --short` retorna 130 arquivos. Commit gate da revisão semanal (v2, adicionado 2026-06-07) só stages `04-SYSTEM/agents|skills|hot.md` — mas o working tree tem muito mais (03-RESOURCES, 06-GENERATED, etc., gitignored por design).

**Causa raiz:** O allowlist do `.gitignore` exclui `03-RESOURCES/`, `06-GENERATED/`, `02-AREAS/` — então edições nessas áreas *nunca* entram no commit gate. O gate funciona para agents/skills/hot.md, mas o resto do trabalho fica invisível. Isso é by-design (L15), mas significa que ~80% do trabalho do vault não tem backup git.

**Custo:** Próximo crash perde trabalho em sources/concepts/connections. Backup manual (`vault-backup`) é o último salvavidas — confirmado em hot.md (91M, 11122 arquivos, 2026-06-21).

### WP3 — Zero atividade FIAP/concurso, 3ª semana consecutiva (MÉDIO — recorrência)

**Evidência:** 0 commits tocando `02-AREAS/fiap` ou `concurso` em 7 dias. Já reportado em 2026-06-07 e persistente.

**Causa raiz:** Pipeline-diário só processa feeds (Readwise/clippings), que são ~100% AI/tech. Não existe gatilho para captura acadêmica. O freeze de reorgs até 2026-07-05 pode liberar bandwidth para conteúdo acadêmico.

**Custo:** Objetivo primário (ADS @ FIAP + concurso) continua deslocado pelo secundário (AI second brain).

## F3.5 — Surprises

1. **Freeze decision registrada mas não refletida em commits da semana.** A decisão de congelar reorgs até 2026-07-05 foi registrada em 2026-06-22, mas 3 dos 8 commits da semana *são* reorgs. O freeze chegou tarde — a semana já tinha consumido o budget de reorg.

2. **Vault Health: 0 concepts criados em 7d — mas isso é saudável.** 276 sources ingeridas sem concepts novos significa reuso de concepts maduros (loop-engineering, harness-engineering, algorithmic-trading etc.). Não é estagnação — é maturidade da rede de concepts. O alerta da rotina ("concepts=0 = cobertura estagnada") precisa de refinamento: distinguir "0 concepts + 0 sources" (estagnação real) de "0 concepts + 276 sources" (reuso saudável).

## F3.6 — Top 2 fixes

### Fix WP1 — Respeitar o freeze (decisão já tomada)

**O quê:** A decisão de freeze até 2026-07-05 está em `decisions.md`. O fix não é uma nova ação — é *não fazer*. Qualquer proposta de reorg estrutural em `04-SYSTEM/agents/` deve ser bloqueada por Nexus gate até 2026-07-05.

**Métrica de verificação:** Próxima revisão semanal deve ter 0 commits de reorg estrutural em `04-SYSTEM/agents/`.

**Custo de não fazer nada:** 4ª semana de thrashing, drift acumulando, agentes perdendo contexto.

### Fix WP3 — Alerta de Vault Health precisa distinguir estagnação de maturidade

**O quê:** O bullet "concepts=0 em 7d = cobertura estagnada" em FASE 0 da rotina `revisao-semanal` deve ser refinado: `concepts=0 AND sources_recentes=0` = estagnação; `concepts=0 AND sources_recentes>50` = reuso saudável (não alertar).

**Métrica de verificação:** Próxima revisão semanal não deve disparar alerta de estagnação quando sources_recentes > 50.

**Custo de não fazer nada:** Falsos positivos toda semana, desperdiçando atenção do operador.

## F3.7-F3.9

- **F3.7 Evolve:** Padrão "freezes preventivos como resposta a thrashing" é cristalizável — mas já existe `decisions.md` como mecanismo. Adicionar skill seria over-engineering.
- **F3.8 Meta-Learn:** WP2 (trabalho não commitado) é recorrência de 2026-06-07. Princípio: *"Commit gate só cobre paths rastreados; trabalho em dirs gitignored fica sem backup."* Já documentado em L15. Não há novo princípio a extrair.
- **F3.9 Pre-Mortem:** Não disparado — freeze é uma *não-ação*, não mudança arquitetural.