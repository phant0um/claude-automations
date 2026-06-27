---
name: daily-brief
skill: daily-brief
version: 2.0
schedule: "Mon-Fri 11 PM"
tags: [routine, brief, daily, context, compounding]
sources:
  - CyrilXBT Daily Context Generator
  - DamiDefi daily ritual
  - 08-ARCHIVE/B/daily-brief.md v1
---

# Daily Brief

Nightly vault summary. What changed, what connects, what to think about tomorrow.

---

## Trigger

- Scheduled: Mon-Fri 11 PM
- Manual: `@daily-brief` or "brief do dia"
- Weekends: skip (maintenance routines run instead)

---

## Execution

### 1. Collect today's changes

```bash
cd $VAULT_DIR
# Files modified today
find 03-RESOURCES/ 04-SYSTEM/ 06-GENERATED/ 07-QUEUE/ -name "*.md" -mtime 0 -type f 2>/dev/null
# Git changes if tracked
git diff --name-only --diff-filter=ACMR HEAD~1 2>/dev/null | grep -E "^(03-RESOURCES|04-SYSTEM|06-GENERATED|07-QUEUE)/"
```

### 2. Check previous brief follow-up

```bash
# Read yesterday's question and suggestions
ls 06-GENERATED/daily-briefs/ | tail -1
```

Note if yesterday's question was addressed or suggestions acted upon.

### 3. Read hot cache (actionable items)

```bash
head -60 04-SYSTEM/wiki/hot.md
```

Extract: blockers, pending concepts/entities, active threads.

### 4. Detect drift (inactivity)

Flag areas with 0 changes in 7+ days:
- `02-AREAS/fiap/` — study drift?
- `02-AREAS/concurso/` — prep drift?
- `04-SYSTEM/agents/` — system maintenance drift?

Only flag if area was previously active. Dormant areas don't count.

### 5. Scan queue

```bash
find 07-QUEUE/ -maxdepth 1 -name "*.md" -not -name "_template.md" | wc -l
```

### 6. Generate brief

Output: `06-GENERATED/daily-briefs/daily-brief-YYYY-MM-DD.md`

```markdown
---
title: "Daily Brief — YYYY-MM-DD"
type: brief
generated_by: claude-code
created: YYYY-MM-DD
---

# Brief — YYYY-MM-DD (day of week)

## Follow-up de ontem
- [Was yesterday's question addressed? Status of previous suggestions]
- (skip if first brief or no previous)

## O que mudou hoje
- [list of files created/modified with 1 line of context]

## Queue e blockers
- Queue: N tasks pending
- Blockers: [from hot.md OPERACIONAL]
- Next routine: [name] in [when]

## Drift alert
- [areas with 7+ days inactivity that were previously active]
- (skip if no drift detected)

## 3 conexoes sugeridas
Based on today's changes vs existing vault:
1. [recent] <-> [older] — why (1 sentence)
2. ...
3. ...

## 1 pergunta pra pensar amanha
[Provocative question based on emerging pattern — genuine, not generic]

## Contexto ativo
- **FIAP:** [current topic, next deadline]
- **Concurso:** [current prep status]
- **AI Agents:** [experiment/improvement in progress]
```

---

## Constraints

- Max 35 lines total
- If nothing changed: 5-line brief ("Nothing changed. Queue: N. Next routine: X.")
- Connections: non-obvious only. If <3, report however many found
- Question: must reference real vault data, not generic platitudes
- Mon-Fri only
- Do NOT write to hot.md — brief is ephemeral

## Cleanup

Briefs >7 days old can be deleted by wiki-lint.

---

## Changes from v1

- Added follow-up section (track if previous suggestions were acted on)
- Added drift detection (flag neglected active areas)
- Added blockers from hot.md (surface operational issues)
- Structured queue section with blockers
- Max lines raised 30->35 to accommodate new sections

---

## Completion

- [ ] Brief tem máx 35 linhas
- [ ] Follow-up section: ações da semana anterior tracked (acted on / pending)
- [ ] Drift detection: áreas ativas negligenciadas flagadas
- [ ] Blockers do hot.md surfaced
- [ ] Queue section com blockers destacados

## Failure modes

- **Over-length**: brief >35 linhas → cortar para essencial
- **No follow-up**: não checar se suggestions anteriores foram acted on → follow-up é obrigatório
- **Miss blockers**: não ler hot.md para blockers → surface operational issues

---

## Changelog## Changelog

- v2.0 (2026-05-25): Enhanced from v1. Added follow-up tracking, drift detection, hot.md blockers.
- v1.0 (2026-05-09): Created.
