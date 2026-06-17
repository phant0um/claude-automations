---
name: contradiction-sweep
skill: contradiction-sweep
version: 1.0
schedule: "Bi-weekly Saturday 8 AM (after connection-finder)"
tags: [routine, quality, contradictions, reconciliation, vault-health]
sources:
  - obsidian-second-brain (Eugeniu Ghelbur) — /obsidian-reconcile
  - connection-finder v2 — contradiction type
---

# Contradiction Sweep

Scan vault for contradictory claims across sources and concepts. Reconcile or flag for human decision.

---

## Trigger

- Scheduled: bi-weekly Saturday 8 AM
- Manual: `@contradiction-sweep` or "sweep contradictions"
- Post-connection-finder: when connection report has >2 contradictions

---

## Execution

### 1. Collect candidate pairs

Sources of contradictions:
```bash
cd $VAULT_DIR
# Recent connection reports with contradiction sections
grep -l "## Contradi" 06-GENERATED/connections/*.md | tail -5
# Sources with overlapping tags but different conclusions
# (cross-reference via frontmatter tags)
```

Also scan:
- Concepts with >3 sources linked — higher chance of conflicting claims
- Sources from same domain published >30 days apart (knowledge evolves)

### 2. Detect contradiction types

| Type | Description | Resolution |
|------|-------------|------------|
| **Factual** | Different numbers for same metric | Find primary source, update stale one |
| **Methodological** | Same goal, opposite approach recommended | Document both with context where each applies |
| **Temporal** | Claim was true, no longer is | Add temporal marker, update concept |
| **Perspective** | Valid from different viewpoints | Create synthesis noting both perspectives |
| **Superseded** | Newer evidence invalidates older | Mark older as superseded, link to newer |

### 3. Auto-resolve (high confidence only)

Automatically fix:
- **Temporal**: source from 2024 says X, source from 2026 says NOT X with evidence -> mark 2024 claim as `[superseded YYYY-MM-DD]`
- **Factual with primary source**: official docs > blog post > social media

Do NOT auto-resolve:
- Methodological (both can be valid)
- Perspective (requires judgment)
- Any contradiction where confidence < 80%

### 4. Generate report

Output: `06-GENERATED/reports/contradiction-sweep-YYYY-MM-DD.md`

```markdown
---
title: "Contradiction Sweep — YYYY-MM-DD"
type: report
contradictions_found: N
auto_resolved: N
pending_human: N
generated_by: claude-code
created: YYYY-MM-DD
---

# Contradiction Sweep

## Auto-Resolved
### [Type] Short description
- **Source A**: [[path]] — claim
- **Source B**: [[path]] — counter-claim
- **Resolution**: what was done and why
- **Confidence**: HIGH

## Pending Human Decision
### [Type] Short description
- **Source A**: [[path]] — claim
- **Source B**: [[path]] — counter-claim
- **Options**:
  A) Adopt Source A because [reason]
  B) Adopt Source B because [reason]
  C) Keep both with context note
- **Recommendation**: [A/B/C]
```

### 5. Update hot cache (only if pending items)

If pending_human > 0, append to `04-SYSTEM/wiki/hot.md`:
```
## Contradictions YYYY-MM-DD | N pending human decision
-> `[[06-GENERATED/reports/contradiction-sweep-YYYY-MM-DD]]`
```

---

## Constraints

- Max 20 contradiction pairs per sweep (focus on highest impact)
- Never auto-resolve methodological contradictions
- Never delete source content — only add markers/notes
- If >20 contradictions found: likely a systemic issue (e.g., outdated domain). Flag for `review` agent
- Primary source hierarchy: academic paper > official docs > expert blog > social media

---

## Quality Gate

- [ ] Every [[wikilink]] in report resolves
- [ ] Auto-resolved items cite evidence for resolution
- [ ] Pending items have concrete options (not vague)
- [ ] No source content was deleted or overwritten

---

## Changelog

- v1.0 (2026-05-25): Created. Inspired by Ghelbur's /obsidian-reconcile + connection-finder contradiction detection.
