---
title: "md or html? — 3-Question Format Decision Framework"
type: source
source_file: "Clippings/md or html?.md"
author: "@the_smart_ape"
source_url: https://x.com/the_smart_ape/status/2053034897514660074
published: 2026-05-08
ingested: 2026-05-09
tags: [markdown, html, output-format, token-economy, llm-workflow, format-decision]
---

# md or html? — 3-Question Format Decision Framework

Thread by [[03-RESOURCES/entities/the-smart-ape]] reframing the MD-vs-HTML debate as a decision problem with three measurable dimensions, not a format preference. Published 2026-05-08.

## Core Thesis

"Stop having format opinions. Start asking 3 questions. Let the doc tell you what it wants to be."

Both MD-fundamentalists and HTML-converts are wrong. The question is not MD vs HTML — it is: for this specific document, who reads it, who edits it, how long does it live?

## The 3 Questions

Every LLM-produced document has three properties, each voting for a format:

| Property | Question | Vote for MD | Vote for HTML |
|---|---|---|---|
| **Audience** | Who actually reads this? | Claude (re-ingestion, RAG, future sessions) | Humans, one-time |
| **Lifecycle** | How many times edited? | >2–3 edits | Write-once or throwaway |
| **Horizon** | How long does it live? | Days → forever (needs grep/index) | Ephemeral, one-shot |

When 3 votes align → clear answer. When split → hybrid pattern.

## Token Cost of HTML (Quantified)

Real-document measurement (800 words, 6 sections, 2 code blocks):
- As markdown: ~1,100 tokens
- As HTML with inline styles, small SVG: ~3,200 tokens
- **3× token cost.** Multiply by 30 reference files = 60k extra tokens burned.

Additionally: most retrieval pipelines (Claude Projects, Cursor index, Continue, LangChain loaders) chunk HTML worse than markdown. Embedding vector relevance degrades **15–25%** due to markup diluting semantic signal.

Rule: doc is reference material Claude will re-read → MD, no exceptions.

## Markup Drift (Named Phenomenon)

When an HTML doc is edited 5–10 times by an LLM, it drifts: 3 different spacing systems, 4 color schemes in the same file. Nothing looks broken; everything is broken. Visible only when diffing v1 against v8.

This is the core failure mode of using HTML as an iteration format. HTML is a publication format, not an iteration format.

See [[03-RESOURCES/concepts/markup-drift]].

## Hybrid Pattern: One MD Source, Many HTML Renders

The recommended approach for long-lived, frequently-edited documents:

1. Write canonical document in Markdown (stays reviewable, indexable, greppable).
2. Generate HTML views on-demand for specific audiences.

Example — `architecture.md` becomes:
- Exec view: one page, top-level, no jargon
- Engineering view: full doc + interactive SVG diagrams
- Onboarding view: same content + inline quizzes + progress tracker

Implementation: 10-line script piping MD into Claude with three different system prompts. No infrastructure, no lock-in.

## Reversibility Test (30-second heuristic)

Before committing to HTML: "If I had to convert this back to clean markdown right now, could I do it in one prompt?"

If no → content is trapped inside the markup. Warning sign. Content should always be cleanly extractable from format.

## Decision Examples

| Document | Audience | Lifecycle | Horizon | Format |
|---|---|---|---|---|
| Product spec | humans + Claude in coding | edited weekly | months | MD |
| Weekly Slack status | humans, once | write once | a week | HTML (if visual hierarchy adds info) |
| PR description | humans + GitHub + Claude | write once | indexed forever | MD |
| Animation prototype | humans, in a meeting | throwaway | one hour | HTML |
| System architecture doc | everyone including future Claude | evolves | years | MD source + HTML on demand |

## Legitimate HTML Exceptions

1. Sales demo / external one-pager where aesthetic is the content.
2. True one-shot: literally never touched again.
3. Interactive prototype where the interaction is the deliverable.

## Conexões

- [[03-RESOURCES/concepts/html-as-llm-artifact]] — enriched with token cost data and audience dimension
- [[03-RESOURCES/concepts/markup-drift]] — new concept named by this source
- [[03-RESOURCES/concepts/format-decision-framework]] — framework extracted from this source
- [[03-RESOURCES/concepts/prompt-caching]] — adjacent token-economy concern
- [[03-RESOURCES/entities/the-smart-ape]] — author
