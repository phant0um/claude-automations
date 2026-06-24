---
title: Skill Development (Human-First Approach to AI Prompting)
type: concept
status: developing
tags: [skills, prompt-engineering, writing, claude-skills, clarity, education]
created: 2026-05-01
updated: 2026-05-01
---

# Skill Development — Human-First Approach to AI Prompting

## Core Principle

The skill of building effective AI prompts is the same skill as building effective education products for humans. Teaching a human and instructing an AI require identical clarity of thought — only the audience changes.

> "Great prompts are education products copy-pasted into AI." — [[03-RESOURCES/entities/Nicolas-Cole]]

## The Underlying Skill: Clarity of Thought

Writing is not primarily a communication skill — it is a **thinking clarification tool**. When you write:
- You force yourself to sequence steps logically.
- You expose gaps in your own understanding.
- You produce an artifact that can be handed off to any learner — human or AI.

This is why practicing writing remains valuable even when AI can write: the output of writing practice is a clearer mental model, not just prose.

## Education Products as Long-Form Prompts

| Format | Audience | What it is |
|---|---|---|
| Book | Human | Long-form prompt for behavioral change |
| Video course | Human | Sequential multi-step instructional prompt |
| Digital product | Human | Packaged workflow for a specific outcome |
| Claude Skill (SKILL.md) | AI | Same content; one-line wrapper at the top |

The structure is identical. The distinction is which learner processes it.

## The Human-First Writing Process for Skill Creation

1. **Write the long-form version** for a human reader — your smartest friend over coffee.
2. **Get every step on the page** in excruciating detail.
3. **Identify the complete workflow** before touching the AI tooling.
4. **Add a one-line wrapper** (e.g., "You are an expert in X. Use the following process:").
5. **Test step by step** — if output is bad, the documentation is wrong, not Claude.

This process contrasts with "prompt engineering tricks" — iterative tweaks applied to vague instructions. Clarity beats technique.

## Skill-Building Anti-Patterns

| Anti-pattern | Consequence |
|---|---|
| Letting AI make strategic decisions | Mediocre skills; Claude takes the wheel |
| Building the whole skill at once | One janky output; 3 days of debugging |
| Vague documentation | Claude generates plausible but wrong outputs |
| Prompt engineering tricks over clarity | Fragile prompts that break on slight variation |

## Build Loop (Incremental Approach)

```
1. Define full skill workflow upfront (all steps, in order)
2. Build Step 1 only
3. Test with a real example
4. Good output → ship to output doc → next step
5. Bad output → fix documentation → retest
6. Repeat for each step
7. Package the full skill
```

This is the same principle as test-driven development applied to skill construction: verify each unit before integrating.

## Relation to Human Expertise

Skill quality is bounded by the depth of the human's expertise in the domain. An expert writer building a writing skill produces a better skill than a non-writer using the same tooling. The AI amplifies existing clarity; it does not replace the need for it.

## Connections

- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — the technical format produced by this process (SKILL.md)
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]] — Cole's approach: clarity over tricks
- [[03-RESOURCES/concepts/pkm-obsidian/progressive-disclosure]] — Skills load in layers; matches the documentation depth principle
- [[03-RESOURCES/concepts/agent-systems/ai-tutor-pattern]] — 7-module system for applying skill-building principles via Claude
- [[03-RESOURCES/concepts/pkm-obsidian/socratic-learning-loop]] — active generation principle in practice
- [[03-RESOURCES/entities/Nicolas-Cole]] — primary source for this framework
- [[03-RESOURCES/sources/claude-code-skills/how-to-build-claude-skill-from-scratch-nicolascole]] — source article
- [[03-RESOURCES/sources/guides-courses-howtos/personal-ai-learning-system-half-time-course]] — application layer: AI-tutored skill acquisition
