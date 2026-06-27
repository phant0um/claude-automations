---
name: connection-finder
description: "Scan sources from last 7 days vs entire vault. Surface non-obvious cross-domain connections, contradictions, and converging patterns. Apply high-confidence wikilinks bidirectionally."
skill: connection-finder
version: 2.2
schedule: "Sunday 6 AM (after wiki-lint at 4 AM)"
tags: [routine, connections, cross-link, compounding]
sources:
  - CyrilXBT Connection Finder
  - DamiDefi JARVIS
  - 08-ARCHIVE/B/connection-finder.md
---

# Connection Finder

Scan sources from last 7 days vs entire vault. Surface connections humans wouldn't see.

---

## Trigger

- Scheduled: Sunday 6 AM
- Manual: `@connection-finder` or "find connections"
- Post-ingest: after batch ingest of 5+ sources

---

## Execution

### 1. Collect recent sources

Prefer `ingested:` frontmatter field over `mtime -7` — mtime resets on git checkout/sync and produces false positives/negatives.

```bash
cd $VAULT_DIR
SEVEN_DAYS_AGO=$(date -v-7d -I 2>/dev/null || date -d '7 days ago' -I 2>/dev/null)
grep -rl "^ingested:" 03-RESOURCES/sources/ 2>/dev/null | while read f; do
  date=$(grep "^ingested:" "$f" | head -1 | sed 's/ingested: *//')
  if [[ "$date" > "$SEVEN_DAYS_AGO" ]]; then
    echo "$f"
  fi
done > /tmp/recent_sources.txt
RECENT_COUNT=$(wc -l < /tmp/recent_sources.txt | tr -d ' ')
```

0 sources -> stop. Report "No new sources this week."

### 2. Collect older vault content

```bash
# Portable random sample (gshuf > shuf > sort -R — shuf absent on macOS, L05)
rnd() { if command -v gshuf >/dev/null 2>&1; then gshuf; elif command -v shuf >/dev/null 2>&1; then shuf; else sort -R; fi; }

# Older sources excluding recent ones
find 03-RESOURCES/sources/ -name "*.md" | \
  grep -vF -f /tmp/recent_sources.txt | rnd | head -50 > /tmp/old_sources.txt
# All concepts (small corpus, high value for cross-linking)
find 03-RESOURCES/concepts/ -name "*.md" | rnd | head -30 >> /tmp/old_sources.txt
```

### 3. Extract themes from each recent source

Read frontmatter (tags) + first 20 lines. Extract:
- Central thesis (1 sentence)
- Domain (agent-systems, pkm, ml-research, etc.)
- Key entities referenced

### 4. Match against older vault

For each recent source, find 2-3 older items with:
- Overlapping tags but **different** domain
- Complementary or contradictory thesis
- Same entity referenced in different context
- Same numerical claim with different magnitude

**Theme clustering shortcut:** Extract all tags from recent sources, count frequency, and focus analysis on the top 3-5 tag clusters. A cluster with 3+ sources converging on the same insight = Pattern 3+ candidate. This is far more efficient than reading every source individually when the recent set is large (>50). With 276 recent sources (2026-06-22), theme clustering identified `loop-engineering` (17 sources) as the dominant pattern in seconds — individual reading would have missed the convergence.

```bash
grep -h "^tags:" $(cat /tmp/recent_sources.txt) 2>/dev/null | \
  sed 's/tags: *\[//;s/\]//' | tr ',' '\n' | \
  sed 's/^ *//;s/ *$//' | sort | uniq -c | sort -rn | head -20
```

**Tese extraction for top clusters:** For each top cluster, extract the `## Tese central` line from 10-15 sources to identify convergence/contradiction patterns:

```bash
grep -l "TAG_NAME" $(cat /tmp/recent_sources.txt) | while read f; do
  echo "=== $(basename $f) ==="
  grep -A2 "^## Tese" "$f" | head -3
done
```

### 5. Classify connections

| Type | Criteria | Value |
|------|----------|-------|
| **Cross-domain** | Different areas, shared insight | HIGH |
| **Contradiction** | Same claim, opposite conclusions | HIGH |
| **Pattern 3+** | 3+ sources converge on same point | HIGH |
| **Q&A** | Older source asks question, recent answers | MEDIUM |
| **Evolution** | Same idea, updated version | MEDIUM |

Only **non-obvious** connections qualify. Same tags + similar thesis = obvious = skip.

### 6. Generate output

Output: `06-GENERATED/connections/connections-YYYY-MM-DD.md`

```markdown
---
title: "Weekly Connections — YYYY-MM-DD"
type: report
connections_found: N
sources_scanned: N
generated_by: claude-code
created: YYYY-MM-DD
---

# Non-Obvious Connections of the Week

## Cross-domain
[[source-A]] <-> [[source-B]]
**Connection:** reason (2-3 sentences max)
**Action:** wikilink to create / concept to consolidate

## Contradictions
...

## Patterns 3+
...

## Suggestions
- Create [[concept-X]] — N sources converge
- Consolidate [[source-A]] + [[source-B]]

### 7. Link Repair (added 2026-06-23)

**Princípio**: conexões novas são valiosas mas links quebrados são dívida.
Antes de sugerir novas conexões, reparar links quebrados existentes.

**Script reutilizável**: `scripts/repair_links.py` — scan de source pages,
basename matching contra filesystem, criação de stubs, verificação de
resolução. Rodar após ingest batches para garantir 100% link resolution.

```bash
python3 scripts/repair_links.py
# Output: /tmp/link_repair_summary.md com links reparados, stubs criados, % resolução
```

Para batches pequenos ou verificação inline, usar o snippet bash abaixo:

```bash
# Scan all source pages for broken concept/entity links
BROKEN_LINKS="/tmp/broken_links.txt"
> "$BROKEN_LINKS"
for f in $(cat /tmp/recent_sources.txt); do
  links=$(grep -oE '\[\[03-RESOURCES/(concepts|entities)/[^\]]+\]\]' "$f" 2>/dev/null)
  for link in $links; do
    path=$(echo "$link" | sed 's/\[\[//;s/\]\]//')
    [[ -f "$VAULT/$path.md" || -f "$VAULT/$path" ]] || echo "$f|$link" >> "$BROKEN_LINKS"
  done
done

BROKEN_COUNT=$(wc -l < "$BROKEN_LINKS" | tr -d ' ')
if [[ $BROKEN_COUNT -gt 0 ]]; then
  echo "## Broken Links Repaired"
  echo "| Source | Broken Link | Action |"
  echo "|--------|-------------|--------|"
  while IFS='|' read -r src link; do
    # Try basename match against existing files
    basename=$(echo "$link" | sed 's/.*\///;s/\]\]//')
    match=$(find "$VAULT/03-RESOURCES/concepts/" "$VAULT/03-RESOURCES/entities/" \
      -name "${basename}.md" -print -quit 2>/dev/null)
    if [[ -n "$match" ]]; then
      correct_path="${match#$VAULT/}"
      correct_path="${correct_path%.md}"
      sed -i '' "s|$link|[[${correct_path}]]|g" "$src"
      echo "| $(basename $src) | $link → [[${correct_path}]] | redirected |"
    else
      echo "| $(basename $src) | $link | create stub |"
    fi
  done < "$BROKEN_LINKS"
fi
```

### 8. Generate output
- Investigate contradiction X vs Y
```

### 7. Update hot cache

Append to `04-SYSTEM/wiki/hot.md`:
```
## Connections YYYY-MM-DD | N connections found
**Top:** [most valuable connection in 1 line]
-> `[[06-GENERATED/connections/connections-YYYY-MM-DD]]`
```

### 8. Apply wikilinks

**High confidence** (pattern 3+ or Q&A):
- Add bidirectional wikilink in `## Relations` of involved sources
- Confirm link resolves before adding

**Medium confidence**: only suggest in report. Do NOT edit sources.

---

## Constraints

- Max 10 connections per report (quality > quantity)
- If <3 real connections found, report <3. Never invent forced connections
- Do NOT modify sources without high confidence
- Random sampling of older vault avoids recency bias
- Cross-domain connections > same-domain (higher value)

---

## Quality Gate

## Completion

Before finalizing report:
- [ ] Every [[wikilink]] resolves to existing file
- [ ] No duplicate connections (check previous report)
- [ ] Each connection has concrete action item
- [ ] Hot cache entry added
- [ ] Max 10 connections por relatório (qualidade sobre quantidade)
- [ ] Wikilinks bidirecionais aplicados apenas em alta confiança

## Failure modes

- **Fabricated connections**: inventar convergência com <2 sources concordando → mínimo 2 sources para convergência
- **Orphan inflation por mtime**: usar mtime em vez de `ingested:` frontmatter → false positives de "recentes"
- **Over-linking**: adicionar wikilinks em média confiança → só alta confiança edita source page, média vai no relatório

---

## Changelog

- v2.3 (2026-06-23 run 2): +Step 7 Link Repair — scan source pages for broken
  concept/entity wikilinks, basename match against filesystem, create stubs for
  gaps. Reusable script: `scripts/repair_links.py`. Validated with 230 source
  pages: 224/1215 broken (18%) → 1215/1215 resolved (100%) after repair + stub
  creation. Pitfall: create stubs at the EXACT path the wikilink references, not
  at the path the script thinks is "correct" — CATEGORY_MAP mismatch caused
  stubs to be created in wrong subdirs.
- v2.2 (2026-06-22): Added tese extraction snippet for top clusters — grep `## Tese central` from cluster sources to identify convergence/contradiction without reading every file. Validated with 276 recent sources: theme clustering identified loop-engineering (17 sources) as dominant pattern in seconds.
- v2.1 (2026-06-22): Backported portability fixes from revisao-semanal v3/v7: `ingested:` frontmatter instead of `mtime -7` (mtime resets on git checkout/sync); `gshuf||shuf||sort -R` fallback (shuf absent on macOS). Added theme clustering shortcut for large recent-source sets. Added missing `description:` frontmatter.
- v2.0 (2026-05-25): Formalized from archive B draft. Added quality gate, post-ingest trigger, confidence-based wikilink rules.
- v1.0 (2026-05-09): Created. Inspired by CyrilXBT + DamiDefi.
