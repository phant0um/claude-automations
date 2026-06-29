---
title: Weekly Ops — Scheduler Health + Fix Tracking (Runtime Truth)
type: rotina
schedule: "segunda 07h"
version: 2
created: 2026-06-20
replaces: [rotina-health, fix-tracker]
tags: [rotina, health, scheduler, fix-tracking, runtime-verify, meta-learn, kanban]
---

# Weekly Ops

Fecha o **loop de verdade-de-runtime** do vault, toda segunda. Une duas metades que
compartilham o mesmo princípio durável (**WP3** + **Meta-Learn F3.8**): *"alegado ≠ verificado".*

- **PARTE A — Scheduler Health**: as rotinas **dispararam**? cron bate com o arquivo? (execução)
- **PARTE B/C — Fix Tracking**: as recomendações viraram **ticket com dono/prazo**, e os fixes
  marcados "feito" deixaram **rastro real**? (loop dos relatórios)

São o mesmo gesto aplicado a alvos diferentes: *"o changelog/scheduler diz que sim — o runtime
confirma?"*. Por isso fundidas (antes eram `rotina-health` 07h + `fix-tracker` 08h, gêmeas de
segunda: mesma cadência, mesmo modelo, mesmas fontes, mesma lógica). Fusão B (2026-06-20).

**Evidências que motivaram cada metade:**
- A: `pipeline-diario` rodou o pipeline semanal **todo dia** ~3 semanas e `daily-scan`/`srs-sources`/
  `vault-reconcile` **nunca dispararam** — invisível porque a audit mensal só lê os `.md`, não o scheduler.
- B/C: o gate FIAP do pipeline foi marcado "implementado" no changelog e **nunca rodou** por 3 semanas —
  virou seção de relatório, não ticket rastreado com verificação.

**Referências:**
- [[06-GENERATED/meta-coaching/meta-coaching-2026-06-07]] (WP3 + Meta-Learn F3.8)
- [[07-QUEUE/kanban/vault-impact-kanban]] — destino dos tickets
- [[07-QUEUE/rotinas/rotina-audit-mensal]] — complementar: ela audita *conformidade* (spec segue princípios?), esta audita *execução* (rodou? deixou rastro?)
- [[04-SYSTEM/skills/core/meta-learn]]

---

## NEXUS GATE — Início

```bash
tail -10 04-SYSTEM/wiki/hot.md
```

`@nexus weekly-ops iniciando — $(date -I)`

---

# PARTE A — Scheduler Health (execução)

## A1 — Estado ao vivo do scheduler `[MCP]`

Chamar `mcp__scheduled-tasks__list_scheduled_tasks`. Capturar por task:
`taskId`, `cronExpression`, `enabled`, `lastRunAt`, `nextRunAt`.

## A2 — Estado dos arquivos `[bash]`

```bash
cd ~/Obsidian/vault-michel
# Rotinas e o schedule declarado no frontmatter
for f in 07-QUEUE/rotinas/*.md; do
  [ "$(basename "$f")" = "_template.md" ] && continue
  sched=$(grep -m1 "^schedule:" "$f" | sed 's/schedule: *//')
  echo "$(basename "$f" .md) :: $sched"
done
```

**Manuais (não esperam task agendada)**: `srs-concurso`, `ingest-fiap-batch`.

**Gate interno mensal (cron semanal esperado, não é CRON-DIVERGE)**: `rotina-audit-mensal`, `skill-audit`
— frontmatter declara "mensal" mas cron dispara semanal por design (cron não expressa "Nº dia-da-semana
do mês" sem ambiguidade); cada arquivo tem gate interno (`date +%-d` ≤7) que filtra a execução real pro
1º dia-da-semana do mês. Ver GATE no topo de cada arquivo antes de flagar.

**Alias de taskId** (evita falso TASK-ÓRFÃ/NÃO-AGENDADA): a task `rotina-health` (taskId legado)
roda este arquivo `weekly-ops.md`; a task `fix-tracker` está `enabled:false` (deprecada, fundida aqui).
Ao reconciliar: `weekly-ops` ↔ task `rotina-health` = ✅ OK; `fix-tracker` desativada com nota = ✅ OK.

## A3 — Reconciliar e flagar `[Haiku]`

Para cada rotina, classificar:

| Flag | Condição |
|------|----------|
| ❌ **NÃO-AGENDADA** | arquivo existe, sem task no scheduler, e não é manual |
| ❌ **CRON-DIVERGE** | `cronExpression` ≠ `schedule:` do arquivo (ex: arquivo diz "domingo 22h", cron `0 16 * * *`) |
| ⚠️ **NÃO-DISPAROU** | `lastRunAt` mais velho que a cadência esperada × 1.5 (diária >2d, semanal >10d, mensal >38d) |
| ⚠️ **DESATIVADA** | `enabled: false` mas o arquivo não declara deprecação |
| 🗑️ **TASK-ÓRFÃ** | task no scheduler sem arquivo de rotina correspondente (nem manual) |
| ✅ OK | task ativa, cron bate, disparou na janela esperada |

Cadência derivada do cron: `* * *` diário, `* * N` semanal, `N * *` mensal.
Task `enabled: false` com nota de deprecação no `description` = OK, não flag.

Issues ❌ (não-agendada/cron-diverge) podem ser corrigidas na hora via
`create_scheduled_task`/`update_scheduled_task` **se Nexus autorizar**. ⚠️ (não-disparou) → investigar erro.

---

# PARTE B — Fix Harvest (colher recomendações)

## B1 — Coletar recs abertas `[bash + Haiku]`

```bash
# Relatórios mais recentes de cada fonte
ls -t 06-GENERATED/audits/*rotina-audit*.md 2>/dev/null | head -1
ls -t 06-GENERATED/meta-coaching/*meta-coaching*.md 2>/dev/null | head -1
ls -t 06-GENERATED/revisao-semanal/*revisao-semanal*.md 2>/dev/null | head -1
```

Extrair itens acionáveis:
- Audit → seção "Hill-Climbing Backlog" (linhas da tabela com Esforço/Impacto)
- Meta-coaching → "F3.6 Top 2 fixes" + "Ações próximo mês"
- Revisão → "Action items (prioridade)"

## B2 — Dedup vs kanban + append `[bash + Haiku]`

```bash
KANBAN="07-QUEUE/kanban/vault-impact-kanban.md"
```

Para cada rec: se já existe no kanban (match por tema) → pular. Senão → append em `## Pendente`:

```markdown
- [ ] **<rec>** · fonte: <relatório> · prazo: <hoje+14d> · dono: <agente|manual> · criado: <hoje>
```

**Prazo default 14d.** Dono = agente que implementa (`@hill`/`@extend`) ou `manual` se exige usuário.
Não duplicar tickets do pipeline F3.3 (já no kanban).

---

# PARTE C — Runtime Verify (o sinal de ouro — WP3)

Para cada fix que um relatório do ciclo anterior marcou "✅ implementado"/"feito":

```bash
# Procurar rastro real do fix (marcador em hot.md, commit, arquivo criado)
grep -riE "<marcador esperado>" 04-SYSTEM/wiki/hot.md
git -C ~ log --oneline --since="14 days ago" | grep -i "<tema>"
```

| Resultado | Ação |
|-----------|------|
| Rastro encontrado | ✅ marcar resolvido no kanban |
| Changelog diz "feito" mas **zero rastro** | 🔴 **RUNTIME-UNVERIFIED** → reabrir ticket, flag para Nexus (padrão WP3) |

> Mesma lógica da PARTE A aplicada a fixes em vez de tasks: scheduler é a fonte de verdade da
> execução; hot.md/git é a fonte de verdade do fix. Changelog dizendo "feito" sem rastro é pior
> que "não feito" (falsa confiança) — **sempre reabrir, nunca confiar no `.md`**.

## PARTE D — Stale sweep `[bash]`

Tickets no kanban com `prazo` vencido > 30d e ainda `[ ]` → flag `⚠️ STALE` para Nexus
decidir (executar, reescopar ou arquivar).

## PARTE E — Kanban consumption `[bash + Haiku]`

**Objetivo:** Fechar o loop do kanban — itens pendentes precisam ser consumidos, não
apenas acumular. Sem esta fase, o kanban é write-only.

### E1 — Coletar itens pendentes `[bash]`

```bash
cd ~/Obsidian/vault-michel
KANBAN="07-QUEUE/kanban/vault-impact-kanban.md"

# Itens pendentes (não-resolvidos) da tabela
grep -E "^\| .* \| \[ \]" "$KANBAN" 2>/dev/null | head -20

# Contar por dono
grep -E "^\| .* \| \[ \]" "$KANBAN" 2>/dev/null | \
  sed 's/.*Dono: *//;s/ *|.*//' | sort | uniq -c | sort -rn
```

### E2 — Processar por dono `[Haiku]`

Para cada item pendente:
- **Dono @hill**: verificar se há eval suite em `evals/cases_<slug>.py`. Se sim →
  flag para `@hill <slug>` executar. Se não → flag para criação de eval suite.
- **Dono @extend**: flag para `@extend <slug>` com contexto do item.
- **Dono manual**: reportar no relatório como "requer ação humana — não autônomo".
- **Sem dono**: assignar dono baseado no tipo (Segurança→@hill/guard, Processo→@hill,
  Drift→@hill/review, Concept→@hill/kore, Improvement→@extend).

### E3 — Output

```markdown
### Kanban Consumption
- Itens pendentes: N
- Processados (dispatched): N → @hill/@extend
- Aguardando humano: N
- Stale >30d: N (flag already from PARTE D)
```

---

## Relatório + hot.md

```markdown
## Weekly Ops — {data}

### Scheduler Health
| Rotina | Cron | lastRun | Flag |
|--------|------|---------|------|
| ... | ... | ... | ✅/❌/⚠️ |
**Issues de execução:** N (lista de ❌/⚠️/🗑️)

### Fix Tracking
**Novos tickets:** N | **Resolvidos (rastro confirmado):** N
**🔴 RUNTIME-UNVERIFIED:** N (changelog diz feito, runtime mudo)
**⚠️ STALE (>30d):** N

### Ação
[1 ação concreta — ex: "recriar task X", "reabrir ticket Y runtime-unverified"]
```

```bash
SCHED_ISSUES=$(echo "$FLAGS" | grep -cE "❌|⚠️|🗑️")
echo "- 🩺 weekly-ops $(date -I): $SCHED_ISSUES issues scheduler, +$NEW tickets, $UNVERIFIED runtime-unverified" >> 04-SYSTEM/wiki/hot.md
grep -q "weekly-ops $(date -I)" 04-SYSTEM/wiki/hot.md && echo "✅ hot.md logado" || echo "⚠️ não logado"
```

## NEXUS GATE — Fim

`@nexus revisar $(date -I)-weekly-ops` — issues ❌ (scheduler) e 🔴 (runtime-unverified) viram
ação imediata. ⚠️ (não-disparou / stale) → investigar.

---

## Self-improvement log `[bash]`

```bash
mkdir -p 06-GENERATED/tasks
echo "- $(date -I): [weekly-ops] scheduler=$SCHED_STATUS, runtime_verified=$RUNTIME_OK, kanban_items=$KANBAN_COUNT" >> 06-GENERATED/tasks/lessons.md
```

---

## Guardrails

- **Scheduler é a fonte de verdade da execução; hot.md/git é a fonte de verdade do fix.** Não confiar no `.md`.
- **RUNTIME-UNVERIFIED é o sinal de ouro** — changelog "feito" sem rastro = pior que "não feito". Sempre reabrir.
- **Kanban é append-only** — nunca remover ticket, só mover `[ ]`→`[x]` ou flag.
- **Prazo sem dono = inválido** — todo ticket tem dono (agente ou `manual`).
- Manuais (`srs-concurso`, `ingest-fiap-batch`) nunca contam como NÃO-AGENDADA.
- Correções no scheduler (criar/ajustar task) exigem aprovação Nexus.
- Não duplica a audit mensal: aqui é *execução*; lá é *conformidade*.
- Custo: ~1–2 calls Haiku (reconciliação + harvest) — bash faz coleta/dedup.

---

## Trigger manual

```
@nexus weekly-ops          → tudo: scheduler health + fix harvest + runtime verify
@nexus weekly-ops health   → só PARTE A (scheduler↔arquivos)
@nexus weekly-ops fix      → só PARTE B/C (colher recs + verificar runtime)
@nexus weekly-ops verify   → só PARTE C (verificação de runtime do ciclo anterior)
```

---

## Changelog

- v2 (2026-06-20): consumer globs da PARTE B1 viram infix (`*rotina-audit*`, `*meta-coaching*`, `*revisao-semanal*`) — casa tanto o formato antigo `nome-DATA` quanto o novo `DATA-nome`, senão o harvest de recs perderia os relatórios re-nomeados. Sem mudança de lógica.
- v1 (2026-06-20): criado pela **Fusão B** — merge de `rotina-health` (v1, scheduler-reconcile, seg 07h)
  + `fix-tracker` (v1, harvest+runtime-verify, seg 08h). Eram gêmeas de segunda (mesma cadência, modelo
  Haiku, fontes hot.md/relatórios, e a mesma lógica "alegado≠verificado" — A verifica se tasks dispararam,
  C verifica se fixes deixaram rastro). Unificadas num gate só, sem perda de cobertura. 15→14 rotinas,
  remove a colisão de slot seg 07h/08h.
