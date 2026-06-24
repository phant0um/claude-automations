---
title: Weekly Ops — 2026-06-22
type: relatorio
created: 2026-06-22
tags: [rotina, weekly-ops, scheduler, fix-tracking]
---

# Weekly Ops — 2026-06-22

## Scheduler Health

| Rotina | Cron | lastRun | Flag |
|--------|------|---------|------|
| daily-brief | 0 23 * * 1-5 | 2026-06-20 | ✅ |
| daily-scan | 0 16 * * * | 2026-06-21 | ✅ |
| pipeline-semanal | 0 22 * * 0 | 2026-06-22 | ✅ |
| process-queue (queue-processor) | 0 8,20 * * * | 2026-06-22 | ✅ corrigido — arquivo atualizado pra "2×/dia (08h,20h)" pra bater com cron real (decisão do usuário: manter 2×/dia) |
| revisao-semanal | 0 4 * * 0 | 2026-06-21 | ✅ |
| rotina-audit-mensal | 0 2 * * 6 | 2026-06-20 | ✅ (gate interno "só 1º sábado" no próprio arquivo — cron semanal é esperado, ver changelog do arquivo) |
| srs-sources | 0 9 * * * | 2026-06-21 | ✅ |
| vault-backup | 0 1 * * * | 2026-06-22 | ✅ |
| vault-hot-sweep | 0 3 1 * * | nunca rodou | ✅ falso positivo — task criada 2026-06-07, dia 1 do mês já tinha passado; próxima ocorrência real 2026-07-01 (hot.md:193 confirma criação/agendamento). Sem histórico de execução é esperado, não bug. |
| vault-reconcile-semanal | 0 22 * * 5 | 2026-06-20 | ✅ |
| weekly-ops (rotina-health) | 0 7 * * 1 | 2026-06-22 (agora) | ✅ |
| x-thread-weekly (ai-weekly-x-thread) | 0 20 * * 0 | 2026-06-22 | ✅ |
| ingest-fiap-batch | manual | n/a | ✅ (manual, não esperado agendado) |
| srs-concurso | manual | n/a | ✅ (manual, não esperado agendado) |

**Tasks desativadas com nota (OK, não flag):** pipeline-diario (substituído), fix-tracker (fundido em weekly-ops).
**Task fora do escopo rotinas:** readme-redesign (one-time, não é rotina recorrente).

**Issues de execução:** 0 — process-queue corrigido (arquivo ajustado), vault-hot-sweep era falso positivo (task nova, ainda não chegou no dia 1)

## Fix Tracking

**Novos tickets:** 12 (harvest de rotina-audit-2026-06 + meta-coaching-2026-06-21 + revisao-semanal-2026-06-21, dedup interno aplicado — "congelar reorgs" citado em 2 fontes = 1 ticket só) → [[07-QUEUE/kanban/vault-impact-kanban]]
**Resolvidos (rastro confirmado):** 1 — hot.md trim 306→249 linhas (rastro: linha idêntica em hot.md e no relatório revisao-semanal-2026-06-21, já feito antes deste ciclo, não precisa de ticket)
**🔴 RUNTIME-UNVERIFIED:** 0 (primeira execução da rotina fundida — kanban Pendente estava vazio antes deste ciclo, nada do ciclo anterior pra verificar)
**⚠️ STALE (>30d):** 0 (kanban Pendente estava vazio)

## Ação

Resolvido nesta sessão: process-queue.md ajustado pra "2×/dia (08h,20h)"; vault-hot-sweep confirmado sem bug. Nenhuma ação scheduler pendente. Próximo: revisar tickets do kanban (12 novos, dono manual/@hill).
