---
title: 7 Claude Code Prompts Every Designer Should Run
type: source
created: 2026-05-01
updated: 2026-05-01
source: "https://threadreaderapp.com/thread/2050048092662313307.html"
author: "@Zara_Ashford"
platform: "Thread Reader App"
tags: [clippings, design, claude-code, prompts, automation, ux]
triagem_score: 5
---

## Core Insight

Claude Code is implementation partner, not search engine. Most designers underuse it—leaving hours/week on table.

**Golden Rule:** Vague prompts → vague results. Specific, context-rich prompts → shippable work at 10x speed.

---

## 7 Designer Prompts (Run Every Project)

### 1. Slim Down Your Code
Kill dead weight: unused CSS, redundant JS imports, uncompressed assets, sync loading patterns.

**Prompt:** "Audit this codebase for file size and loading performance issues. Identify unused CSS, redundant JS imports, uncompressed assets, and synchronous loading patterns. Implement the top 5 fixes with explanations."

Result: Found duplicate CSS + blocking JS in minutes.

### 2. Theming System
Build proper dark mode (not afterthought).

**Prompt:** "Create a CSS custom property theming system supporting light/dark mode with root class toggle — no JS on initial load. Use semantic naming. Ensure WCAG AA contrast in both themes."

### 3. Release Notes
Structure release notes in reverse chronological order.

**Prompt:** "Build a release notes page in reverse chronological order, grouped by month. Date + headline + 2-3 sentence detail. Here's my changelog: [paste]. Create the structure and populate it."

Works with messy Slack exports.

### 4. Sitemap Fix
Accurate priority values: primary 1.0, hubs 0.8, articles 0.6.

**Prompt:** "Audit sitemap.xml against current site structure. Fix missing/outdated URLs. Regenerate with accurate priority values — primary pages 1.0, hubs 0.8, articles 0.6."

Stale sitemaps = slower indexing.

### 5. GA4 Event Tracking
Track clicks, copy-to-clipboard, filters, scroll depth (25/50/75/100%).

**Prompt:** "Add GA4 event tracking — clicks on nav, copy-to-clipboard on code, filter/search interactions, scroll depth at 25/50/75/100%. Use GA4 naming conventions. Don't break existing functionality."

Most sites only track pageviews (tells almost nothing).

### 6. UX Audit
Spot friction points, unclear affordances, missing feedback states.

**Prompt:** "Review this site's interface from a UX perspective. Find friction points, unclear affordances, missing feedback states. For each issue — describe the problem, why it matters, specific fix. Prioritize by user impact."

Found empty search state after months of blindness—4 min fix.

### 7. Prompt Cookbook (Meta-Move)
Build markdown file in repo with reusable prompts:
- Pre-launch checklist prompts
- Periodic UX + accessibility audits
- Post-feature side-effect checks

Treat prompts like components: define once, reuse forever.

---

## Related Concepts

- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]] — Workflow patterns
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]] — Prompting specificity
- [[03-RESOURCES/concepts/design-automation]] — Design workflows
- [[03-RESOURCES/concepts/performance-audit]] — Code audits
- [[03-RESOURCES/concepts/accessibility]] — WCAG AA contrast

## Related Entities

- [[03-RESOURCES/entities/Zara-Ashford]] — Author (@Zara_Ashford)
