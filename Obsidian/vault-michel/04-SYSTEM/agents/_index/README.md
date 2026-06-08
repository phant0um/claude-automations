# Agents Navigation Guide

## Quick Reference: 8 Categories

| Folder | Purpose | Files | Depends On |
|--------|---------|-------|-----------|
| `00-core/` | Quality gates, security, health + spec→impl→verify | 8 | None |
| `02-domain-experts/` | Functional agents by domain | 21 | varies |
| `TJAM Institutional System/` | TJAM compliance & governance | 5 | varies |
| `04-infrastructure/` | Proxies, system integrations | 1 | None |
| `_index/` | Documentation & references | 5 | - |

**Total: 37 agents + 5 reference files**

---

## Dependency Flow

```
00-core (no deps)
    ↓
02-domain-experts (mostly independent)
    ├ escrita-conteudo/ (4 agents)
    ├ tech-dev/ (5 agents)
    ├ design-visual/ (2 agents)
    ├ content-personal-brand/ (2 agents)
    ├ educacao/ (5 agents)
    ├ travel/ (2 agents)
    └ legal-gov/ (1 agent)
    
TJAM Institutional System (independent, governance)
    ├ chefia/
    ├ dados/
    ├ juridico/
    ├ pca/
    └ pls/
    
04-infrastructure (system-level)
    └ claude-hermes-proxy.md
```

---

## How to Trigger Agents

**System firmware agentes** (core):
```bash
@guard [code]          # Security audit (Guard)
@verify                # Post-impl QA (Verify)
@review                # Repo hygiene (Review)
@spec [feature]        # Spec-driven dev (Spec)
@extend [agent]        # Agent extension (Extend)
@hill [agent]          # Hill-climbing (Hill)
```

**Domain experts & functional agents:**
Trigger manually via `@` mention or `/skill` + `@ingest-report` for automation.

**Infrastructure:**
`claude-hermes-proxy` starts automatically at 127.0.0.1:8080 for OpenAI-compat access.

---

## Adding New Agents

1. **Determine category** by function/domain
2. **Create file** in appropriate subfolder (e.g., `02-domain-experts/tech-dev/new-agent.md`)
3. **Update** `ai-agents-index.md` with wikilink under that category
4. **Test** trigger syntax in a Nexus call

**Example:** New writing agent → `02-domain-experts/escrita-conteudo/novo-agente.md`

---

## Migration Status

- ✓ Phase 1: Folder structure created (2026-05-14)
- ✓ Phase 2: All 37 agents moved to categories (2026-05-14)
- ✓ Phase 2b: All 8 skills moved to type-based folders (2026-05-14)
- ✓ Phase 3: ai-agents-index.md remapped + reorganized (2026-05-14)
- ✓ Phase 4: README.md navigation guide created (2026-05-14)
- Pending: Phase 5 — Full verification (AGENTS.md test, wikilink validation)

---

## Files in This Folder (_index/)

- `ai-agents-index.md` — Master index (categorized, remapped)
- `README.md` — This file
- `AI agents.md` — Legacy artifact (reference)
- `AGENTS.md` — System firmware (in parent dir, not moved)
- `prompt-review-2026-05-09.md` — Timestamped review artifact

---

## Gotchas & Fixes

| Issue | Fix |
|-------|-----|
| Wikilinks 404 | Check `ai-agents-index.md` path format: ``[[04-SYSTEM/agents/category/filename]]`` |
| Triggers broken | Test via `@nexus [agent]` — firmware in AGENTS.md controls routing |
| Skills not found | Check `04-SYSTEM/skills/{core,reasoning,orchestration,foundational}/` |
| Missing subcategory | Contact maintainer; new domains go in `02-domain-experts/` |

---

## Key References

- `[[03-RESOURCES/wiki-index]]` — Vault home
- `[[04-SYSTEM/wiki/hot]]` — Hot cache (frequently accessed)
- `[[04-SYSTEM/AGENTS]]` — System firmware & Nexus orchestration
- `[[04-SYSTEM/agents/_index/ai-agents-index]]` — Master agent registry
- `[[04-SYSTEM/skills/foundational/spec-lifecycle]]` — Spec-driven philosophy

---

**Last updated:** 2026-05-14 · **Migration:** Complete · **Ready for 12+ agent expansion**
