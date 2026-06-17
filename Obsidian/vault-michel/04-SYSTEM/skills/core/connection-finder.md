---
name: connection-finder
skill: connection-finder
version: 2.0
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

```bash
cd $VAULT_DIR
find 03-RESOURCES/sources/ -name "*.md" -mtime -7 -type f 2>/dev/null
```

0 sources -> stop. Report "No new sources this week."

### 2. Collect older vault content

```bash
# Random sample of older sources (avoid recency bias)
find 03-RESOURCES/sources/ -name "*.md" -mtime +7 | shuf | head -50
# All concepts (small corpus, high value for cross-linking)
find 03-RESOURCES/concepts/ -name "*.md"
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

Before finalizing report:
- [ ] Every [[wikilink]] resolves to existing file
- [ ] No duplicate connections (check previous report)
- [ ] Each connection has concrete action item
- [ ] Hot cache entry added

---

## Changelog

- v2.0 (2026-05-25): Formalized from archive B draft. Added quality gate, post-ingest trigger, confidence-based wikilink rules.
- v1.0 (2026-05-09): Created. Inspired by CyrilXBT + DamiDefi.
