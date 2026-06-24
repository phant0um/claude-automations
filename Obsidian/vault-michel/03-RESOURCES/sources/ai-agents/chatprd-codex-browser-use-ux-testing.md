---
title: "How I ChatPRD: Codex browser use for UX testing automation"
type: source
created: 2026-06-23
updated: 2026-06-23
tags:
  - ai-agents
  - codex
  - browser-use
  - ux-testing
  - chatprd
  - vercel-sandboxes
  - source
---

# How I ChatPRD: Codex browser use for UX testing automation

**Source:** [X post by @clairevo](https://x.com/clairevo/status/2069269234681827337) · Published 2026-06-23

## Central Thesis

At ChatPRD, they've nailed the product document writing use case ("better than Claude" is common feedback). But they're also seeing "doing this in Claude" as a churn reason. So they're working on new features including a modern wireframing tool. In the process, the author used Codex + browser-use for automated UX testing — having an agent loop through every feature, create user stories, test them manually in Chrome, and fix reproducible issues.

## Key Arguments

### Building a Modern Wireframing Tool

- ChatPRD is building a wireframing tool inside the product using Vercel sandboxes and opinionated tools
- Inspired by @codewithantonio's "Build a Lovable Clone" tutorial and Vercel's blog on AI-powered prototyping with design systems
- Philosophy: less "full vibe to prod" and more "pair this with my PRD so design + eng can do the real work"

### Codex Browser Use for User Story Generation + UX Testing

Inspired by @tomosman, the author used Codex + a `/goal` to build a user story spreadsheet and test against technical implementation and user experience.

#### The Loop Approach

> "Goal: go over every single feature in this app, create a user story with expected behavior based on the code, keep a single canonical spreadsheet tracking the features status — when done, switch loop to testing every user story."

However, the initial loop caught functional bugs but **missed UX bugs and use cases**. That's when browser testing and explicit UX instructions were added.

#### The Full Goal Prompt

The prompt (abridged key points):
1. **Inventory** every route, screen, control, function, form, dialog, navigation item, state transition, retry path, and generated-prototype action
2. **Create/update** user stories in canonical Sheet
3. **Manually exercise** every function in Chrome on desktop and mobile:
   - Click every button, link, tab, toggle, menu, card action
   - Submit every form, verify resulting state
   - Test loading, success, empty, validation, failure, retry, cancellation states
4. **Evaluate usability explicitly**:
   - Discoverability and affordances
   - Information hierarchy and workflow ordering
   - Copy clarity and feedback
   - Mobile spacing, scrolling, safe areas
   - Dialog behavior
   - Keyboard navigation, focus, labels, contrast, accessibility
   - Error recovery and prevention of duplicate actions
   - Perceived performance
5. **Correlate** UI failures with exact thread, prototype, run, stage, error
6. **Record** defects in canonical Sheet with repro steps, expected/actual behavior, severity, evidence
7. **Fix** every reproducible issue
8. **Retest** every user story manually after fixes, then run automated regression suite
9. **Completion gates**:
   - 100% of functions manually tested on rendered surface
   - 100% of user stories pass post-fix retesting
   - Zero open issues
   - No console, request, navigation, accessibility, or overflow errors
   - No unusable, hidden, ambiguous, overlapping, or no-op controls
   - Canonical Sheet reports Release ready = YES

Note: Codex `/goals` have a 4000 character limit.

### Results

- Looped for ~1 hour, ran 99 runs against the prototyping tool
- Caught everything from **race condition bugs to accessibility nits**
- Cost: ~100k tokens — "not terrible at all"
- After completion, had it push a branch and write a Slack message for the engineering team

### Other Tips & Observations

- Using `/side` a lot more to save context + ask random questions about the current thread
- Codex is getting good at spreadsheets
- Cannot get Codex + Chrome to work reliably (calls for help)
- Prototyping tool is not yet a one-shot engineering problem
- "I'm scared of this branch. We might write from scratch once we nail it. What a time to be alive."

## Key Insights

1. **Browser-use as UX sensor**: This is a practical implementation of the "visual verification layer" described in [[03-RESOURCES/sources/ai-agents/foundation-engineering]] — the third layer of the nine-layer judgment ladder that tsc cannot see
2. **Loop with explicit UX evaluation**: The prompt doesn't just test "does it work?" but evaluates discoverability, hierarchy, copy clarity, mobile spacing, accessibility — these are judgment criteria encoded into the loop's completion condition
3. **Completion gates as legislation**: The prompt's release gates are a form of "legislating what counts as correct" — exactly what dashen.wang describes as the legislator's job
4. **Token economics**: ~100k tokens for exhaustive testing across 99 runs is remarkably efficient — validates the "token minimizing and output maxing" thesis from [[03-RESOURCES/sources/ai-agents/glm-52-open-source-ai-setup]]