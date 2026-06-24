---
title: Spaced Learning via LLM
type: concept
status: developing
created: 2026-05-09
updated: 2026-05-09
tags: [ai-learning, spaced-repetition, memory, retention, claude]
---

# Spaced Learning via LLM

Using an LLM as the logistics engine for spaced repetition — generating review questions at scientifically optimal intervals — without requiring a dedicated flashcard app. The learner handles scheduling (calendar reminders); the LLM handles question generation and concept integration.

## The Problem with Manual Spaced Repetition

Tracking intervals, recalling what was learned when, and following through at the right times is enough overhead that most learners abandon it. The LLM offloads the generation and formatting burden; a simple calendar is sufficient for the scheduling.

## Prompt Templates

**Post-session (generate review set):**
```
I just finished learning [what you covered today]. Generate
five questions that test my understanding of the key concepts
from this session. Make them applied, not definitional — I
should have to use the knowledge, not just recall a term.

Save these as my review set for this concept. I will ask you
to generate a review session in 3 days, then 7 days, then 14 days.
```

**Review session:**
```
Review session for [concept], [X] days after initial learning.
Generate the five questions you created after my initial session,
plus two new questions that connect this concept to what I have learned since then.
```

## The Connection Questions

The +2 integration questions are the highest-value part. Forcing links between new knowledge and prior knowledge is where deep understanding forms — concepts stop living in isolated compartments.

## Review Schedule

- Day 3 — first review
- Day 7 — second review
- Day 14 — third review

No flashcard app required. Calendar reminders are sufficient.

## Applied vs. Definitional Questions

The prompt explicitly specifies applied questions ("use the knowledge, not just recall a term"). This ensures review sessions test real understanding rather than rote memorization — consistent with the [[03-RESOURCES/concepts/pkm-obsidian/socratic-learning-loop]] principle that active generation outperforms familiarity-building.

## Connections

- [[03-RESOURCES/concepts/agent-systems/ai-tutor-pattern]] — Module 3 of the full system
- [[03-RESOURCES/concepts/pkm-obsidian/socratic-learning-loop]] — Module 2; same principle (active generation)
- [[03-RESOURCES/concepts/pkm-obsidian/personal-curriculum]] — the learning map governs what gets reviewed
- [[03-RESOURCES/sources/guides-courses-howtos/personal-ai-learning-system-half-time-course]] — source
