---
title: "html-artifacts: Claude Skill for Self-Contained HTML Artifacts"
type: source
source_file: "Clippings/A Claude skill for producing self-contained HTML artifacts instead of markdown when the task warrants it..md"
author: dogum
source_url: https://github.com/dogum/html-artifacts
published:
ingested: 2026-05-09
tags: [claude-skills, html, artifacts, markdown, output-format, claude-code]
---

# html-artifacts — Claude Skill for Self-Contained HTML Artifacts

GitHub repo by [[03-RESOURCES/entities/dogum]] that operationalizes [[03-RESOURCES/entities/trq212-tariq]]'s "Unreasonable Effectiveness of HTML" post into a Claude skill (`.skill` file / Claude Code skill folder).

## Core Thesis

The skill addresses the recognition problem: not "always answer in HTML" but "when does HTML structurally beat markdown for this specific task type?" It identifies nine categories where HTML wins and provides per-category reference patterns.

## Skill Structure

```
skill/
├── SKILL.md                        # recognition heuristic, universal rules, carve-outs
└── references/
    ├── exploration-and-planning.md
    ├── code-review-and-pr.md
    ├── design-and-prototypes.md
    ├── diagrams-and-illustrations.md
    ├── reports-and-research.md
    ├── decks.md
    ├── custom-editors.md
    └── matching-your-style.md
```

`SKILL.md` is always in context when the skill triggers. Reference files are pulled in only when relevant — lazy loading per task category.

## Recognition Heuristic

HTML is triggered for: comparisons, plans, code reviews, explainers, status reports, custom editors, decks, diagrams with SVG, design prototypes.

Explicit carve-outs (use markdown instead): short conversational replies, code-only outputs, terminal-style answers, content that is genuinely a few sentences.

## Anti-Aesthetic Design

The skill actively prevents the "default AI aesthetic" (gradients, four shades of indigo, emoji-decorated headers, glass morphism). `references/matching-your-style.md` includes patterns to avoid and a baseline typographic CSS. Also includes the design-system-from-codebase trick from Thariq's FAQ.

## Install Methods

- **Claude.ai**: upload `.skill` file via Settings → Capabilities → Skills
- **Claude Code**: clone repo, copy `skill/` into `~/.claude/skills/html-artifacts`
- **Anthropic API**: organization-wide deployment via upload endpoint

## Examples Produced

| Pattern | Prompt |
|---|---|
| Side-by-side comparison | SSE streaming comparison in Hono backend |
| Concept explainer + live demo | Quarter-car IRI explainer with interactive simulation |
| Custom editor with export | Ticket triage Kanban → copy-as-markdown |
| Weekly status report | Platform team status |
| Annotated flowchart | Deploy pipeline with failure paths |
| Slide deck | Case for HTML over markdown |

## Conexões

- [[03-RESOURCES/concepts/html-as-llm-artifact]] — the concept this skill operationalizes
- [[03-RESOURCES/concepts/single-file-html-pattern]] — one of the patterns taught by the skill
- [[03-RESOURCES/concepts/claude-skills]] — belongs to the Claude skills ecosystem
- [[03-RESOURCES/entities/dogum]] — author
- [[03-RESOURCES/entities/trq212-tariq]] — intellectual source (Unreasonable Effectiveness of HTML)
- [[03-RESOURCES/sources/claude-code-unreasonable-effectiveness-of-html]] — original source this skill responds to
