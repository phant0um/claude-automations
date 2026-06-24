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
triagem_score: 8
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

## Items 5–17: Remaining Techniques

### 5. Batch Related Tasks Together

Grouping related questions in a single message avoids the context overhead of separate conversations. Each new conversation reloads system prompt, context, and prior history. Batching: one conversation opener, one context load, multiple outputs.

### 6. Use Claude's Native Output Formats

Asking Claude to produce output in the format it will actually be used eliminates reformatting steps. "Give me a Python list I can paste directly" vs. "explain the items and I'll extract them manually" — same information, one step vs. three.

### 7. Pre-process Long Documents

Instead of uploading a 50-page PDF, extract only the sections relevant to the task. Document preprocessing — even manual skimming and pasting the relevant 2 pages — frequently outperforms uploading the full document because:
- Fewer tokens loaded
- Less noise for the model to filter
- Faster, cheaper response

### 8. Anchor on Examples, Not Explanations

"Match this format: [example]" typically produces better results than a 300-word explanation of the desired format. Examples are dense specifications; Claude pattern-matches on them efficiently.

### 9. Use Structured Prompts for Complex Tasks

Dividing a complex prompt into labeled sections (Background / Task / Constraints / Output Format) reduces ambiguity resolution overhead. The model spends tokens on the task, not on inferring what the task is.

### 10. Avoid Asking Claude to Explain What It Did

Post-hoc explanations consume tokens without adding to the output. If you need the explanation, ask for it before the output ("explain your approach as you go") — this integrates it into the generation rather than generating the output twice.

### 11. Set Output Length Constraints Explicitly

"In under 200 words" or "maximum 5 bullet points" prevents over-generation. Without explicit constraints, Claude calibrates length to what seems complete — which is often longer than necessary for the actual use case.

### 12. Use Haiku for Draft, Opus for Final

For iterative refinement, use the cheapest model for early drafts (where you're still discovering requirements) and upgrade to the best model only for the final pass. The quality differential between models is smallest in early drafts where requirements are still vague.

### 13. Cache System Prompts

For repeated sessions with the same system prompt, prompt caching (Anthropic API feature) avoids re-tokenizing the same instructions on every call. The first call is full price; subsequent calls with the same prefix cost 10% of input token price. This is especially impactful for long CLAUDE.md files or detailed personas.

### 14. Compress Conversation History

Before continuing a long conversation, ask Claude to summarize the context into a compact brief. Starting a new session with the compressed brief costs far less than continuing with the full conversation history — and usually preserves all the information that matters.

### 15. Avoid Redundant Rewrites

"Rewrite this email to be more professional" on a good email wastes tokens. Better: "Is this email appropriately professional? What specifically would you change, if anything?" — the question is cheap; the rewrite only happens if actually needed.

### 16. Prefer Structured Data Requests

When you need specific fields from a document, asking "extract these 5 fields as JSON: [field list]" is more token-efficient than "summarize this document" followed by manual extraction. The structured request focuses generation on exactly what you need.

### 17. Know When to Stop Iterating

Each iteration of an AI-assisted task adds context overhead. At some point — usually when the output is "good enough" — additional refinement cycles cost more in tokens than they improve the output. The marginal value of the 6th revision is almost always lower than the 1st. Recognizing this threshold is a workflow skill, not a technical one.

## The Economics of Token Efficiency

The core economic insight: token costs compound across tasks. A workflow that saves 30% per task saves 30% over the lifetime of every task you run. Optimizing for token efficiency is highest ROI precisely because it scales with usage — the more you use Claude, the more the savings multiply.

The techniques above address different leverage points in the token consumption chain:
- Format (technique 1): 10× reduction possible
- Prompt structure (techniques 3, 9, 16): 2-5× reduction
- Iteration strategy (techniques 4, 6, 15, 17): 2-3× reduction
- Model selection (technique 12): 10-20× cost reduction

## Related Concepts

- [[03-RESOURCES/concepts/llm-ml-foundations/token-efficiency-prompting]] — Efficiency patterns
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]] — Structured prompts
- [[03-RESOURCES/concepts/context-rotation]] — Managing context loads
- [[03-RESOURCES/concepts/selective-refinement]] — Targeted iteration
