---
title: "Karpathy's Second Brain Clearly Explained (and how to build your own with no code)"
type: source
source_type: article
category: articles
author: Corey Ganim (@coreyganim)
url: "https://x.com/coreyganim/status/2041144598446092411"
hash: 085eaa3e061b1bf7e161a177ca73f18e
published: 2026-04-06
ingested: 2026-05-05
tags: [pkm, second-brain, llm-wiki-pattern, no-code, knowledge-management, karpathy]
---

# Karpathy's Second Brain Clearly Explained

Practitioner's explainer by Corey Ganim on [[03-RESOURCES/entities/Andrej Karpathy|Andrej Karpathy]]'s personal knowledge base workflow. Focuses on a no-code, weekend-buildable implementation. 41K bookmarks on the original Karpathy post.

## Core Architecture

Three folders, nothing else:

```
raw/      — junk drawer: articles, notes, screenshots, meeting transcripts. Never manually organize.
wiki/     — AI-maintained output: summaries, topic pages, connections. Human never edits by hand.
outputs/  — AI-generated answers, reports, research against the knowledge base.
```

## The Schema File (CLAUDE.md)

A single file in the project root that tells the AI what the knowledge base is about and how to organize it. Equivalent to an employee training manual.

Key rules to include:
- Every topic gets its own `.md` file in `03-RESOURCES/`
- Every wiki file starts with a one-paragraph summary
- Link related topics with `[[topic-name]]` format
- Maintain an `INDEX.md` listing every topic
- When new raw sources are added, update relevant wiki articles

This is the mechanism that makes outputs consistent and structured — without it, the AI guesses at what matters.

## Workflow

1. Drop everything unorganized into `raw/` (articles, notes, PDFs, screenshots)
2. Prompt the AI: *"Read everything in raw/. Compile a wiki in wiki/ following the rules in CLAUDE.md."*
3. Walk away — the AI creates topic pages, links, and an index

## The Compounding Loop

Once the wiki has 10+ articles, ask cross-cutting questions:
- "What are the three biggest gaps in my understanding of [topic]?"
- "Compare what source A says about [concept] vs source B. Where do they disagree?"
- "Write a 500-word briefing on [topic] using only what's in this knowledge base."

Save answers back into the knowledge base — every question improves the next answer. See [[03-RESOURCES/concepts/knowledge-compounding|Knowledge Compounding]].

## Monthly Health Check

Prompt the AI monthly:
> "Review the entire wiki/ directory. Flag contradictions between articles. Find topics mentioned but never explained. List claims not backed by a source in raw/. Suggest 3 new articles to fill gaps."

This maps to the [[03-RESOURCES/concepts/llm-wiki-pattern|LLM Wiki Pattern]]'s linting / health check component.

## Against Tool Maximalism

Explicit argument that Obsidian plugins are unnecessary: "A folder of .md files and a good schema file will outperform a fancy tool stack 90% of the time." Stop configuring tools; start building.

## Ver também

- [[03-RESOURCES/entities/Andrej Karpathy|Andrej Karpathy]] — originator of the pattern
- [[03-RESOURCES/concepts/llm-wiki-pattern|LLM Wiki Pattern]] — the underlying concept
- [[03-RESOURCES/concepts/second-brain|Second Brain]] — broader PKM context
- [[03-RESOURCES/concepts/knowledge-compounding|Knowledge Compounding]] — why the loop gains value over time
- [[03-RESOURCES/sources/karpathy-llm-knowledge-bases|Fonte primária: Karpathy LLM Knowledge Bases]] — Karpathy's own post (the 41K-bookmark source)
