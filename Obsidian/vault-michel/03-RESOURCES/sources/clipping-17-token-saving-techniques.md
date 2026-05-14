---
title: "17 Token-Saving Techniques for Claude"
type: source
source: https://x.com/codi_fyy/status/2049880130043158813
author: Codi Fyy (@codi_fyy)
created: 2026-05-02
ingested: 2026-05-02
language: Portuguese
tags:
  - token-optimization
  - cost-reduction
  - workflow-efficiency
  - file-formats
  - prompt-patterns
---

# 17 Token-Saving Techniques for Claude

Practical optimization tactics addressing common token waste patterns.

## Format Optimization

### 1. Convert Files Before Upload

**Don't upload PDFs/screenshots.**
- PDF page: 1,500–3,000 tokens
- Same text as markdown: <200 tokens
- **Savings**: 10x reduction, just from format

Process:
- Copy text → Google Doc
- Download as .md
- Upload markdown instead

### 2. Plan in Chat, Build in Cowork

- Chat planning = lightweight, cheap
- Cowork file creation = heavier token cost
- **Strategy**: Plan architecture cheaply, build when ready

## Prompt Optimization

### 3. Use AskUserQuestion Instead of Long Prompts

**Instead of**: 500-word prompt
**Do**: "I want [task] for [success criteria]. Ask me questions."

Token math:
- Clicking options: ~0 tokens
- 500-word prompt: 500 tokens
- **Savings**: Let Claude ask, you click

### 4. Selective Refactoring, Not Full Rewrites

**Instead of**: "Redo everything"
**Do**: "Redo section 3 only. Keep rest identical. Be precise."

Token math:
- Full rewrite (2,000 tokens): 2,000 lost
- Targeted fix (1 section): ~300 tokens
- **Savings**: Pay for only what changes

## Continuation (clippings show items 5-17 covering similar patterns)

Items 5-17 address:
- Batch processing
- Avoiding redundant reworks
- Context window management
- Choosing right tools
- Prompt specificity
- Chunking large tasks

## Core Principle

**Most people hit Claude limits because they burn tokens on things that don't need tokens.**

Anthropic isn't the limitation — workflow efficiency is.

## Related Concepts

- [[03-RESOURCES/concepts/token-efficiency-prompting]] — Efficiency patterns
- [[03-RESOURCES/concepts/prompt-engineering-patterns]] — Structured prompts
- [[03-RESOURCES/concepts/context-rotation]] — Managing context loads
- [[03-RESOURCES/concepts/selective-refinement]] — Targeted iteration
