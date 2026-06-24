---
title: Personal Curriculum
type: concept
status: developing
created: 2026-05-09
updated: 2026-05-09
tags: [ai-learning, curriculum, adaptive-learning, diagnostic, personalization]
---

# Personal Curriculum

A learning path constructed from a diagnostic assessment of the individual's actual knowledge state — not a generic course outline. Starts where the learner is, not where a curriculum designer assumed they would be. Skips what is already known; prioritizes what blocks progress.

## Why Generic Curricula Fail

A course covers everything, in order, for the median learner. Two failure modes:

1. **Over-coverage** — learner already knows half the material; time wasted, engagement drops.
2. **Under-scaffolding** — course assumes foundational knowledge the learner lacks; content is incomprehensible without external help.

A personal curriculum eliminates both by beginning with diagnosis.

## Building the Learning Map (Diagnostic Prompt)

```
I want to learn [skill]. Before we start, I want you to diagnose
my current knowledge accurately. Ask me 10 questions that test
different levels of understanding of this skill, from foundational
concepts to intermediate application to advanced nuance.

After I answer, give me:
1. An honest assessment of where my knowledge is strong
2. The specific gaps that will block my progress if not addressed first
3. The concepts I am close to understanding that will click
   quickly with targeted explanation
4. An estimated learning timeline based on my starting point

Do not be encouraging. Be accurate.
```

The output is the **learning map**: what to cover, what to skip, what requires foundational work first, and a realistic timeline.

## Maintenance Cadence

Update the map every 2–3 weeks. As understanding develops, gaps shift. The map should reflect current state, not the starting state.

## Relation to Adaptive Learning Systems

Adaptive learning systems continuously analyze learner behavior, skills, and performance to adjust paths in real time. The personal curriculum is the human-directed version: the learner runs the diagnostic and updates the map intentionally, rather than having a system do it automatically. Simpler; requires discipline.

## Connections

- [[03-RESOURCES/concepts/agent-systems/ai-tutor-pattern]] — Module 1 produces the personal curriculum; the rest of the system builds on it
- [[03-RESOURCES/concepts/pkm-obsidian/socratic-learning-loop]] — targets specific concepts identified by the learning map
- [[03-RESOURCES/concepts/pkm-obsidian/spaced-learning-llm]] — reviews concepts from the curriculum at optimal intervals
- [[03-RESOURCES/concepts/agent-systems/autonomous-learning]] — agent-side parallel: systems that self-build their own learning paths
- [[03-RESOURCES/sources/guides-courses-howtos/personal-ai-learning-system-half-time-course]] — source
