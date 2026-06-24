---
title: "How To Build A Claude Skill From Scratch (1-Hour Masterclass)"
type: source
source_url: "https://x.com/Nicolascole77/status/2049829813561749947"
author: "Nicolas Cole"
author_handle: "@Nicolascole77"
published: 2026-04-30
created: 2026-05-01
tags: [clippings, claude-skills, skill-building, prompt-engineering, writing, cowork, notion]
triagem_score: 8
---

# How To Build A Claude Skill From Scratch

**Source:** [X Thread by @Nicolascole77](https://x.com/Nicolascole77/status/2049829813561749947)
**Author:** [[03-RESOURCES/entities/Nicolas-Cole]]
**Published:** 2026-04-30

## Core Thesis

> "Great prompts are education products copy-pasted into AI."

Cole's central insight: building a Claude skill and building a digital education product for humans are the same activity. A 5,000-word course module becomes a 5,000-word prompt with a one-line wrapper at the top. The audience changes (human → AI); the structure does not.

## Key Argument: Writing Well = Using AI Well

Getting good output from AI has nothing to do with AI knowledge. It has everything to do with the ability to articulate what you want. The writers with clarity-of-thought advantage will outperform prompt-engineering-tricks learners because:

- Books, video courses, and digital products are long-form prompts for humans.
- Clarity of thought is the underlying skill that transfers to AI prompting.
- Writing → teaching → prompting form a single skill progression.

## The Anti-Pattern: Letting AI Take the Wheel

The biggest failure mode when building with AI: deferring to Claude for strategic decisions.

> "Claude says, 'Here's what I'd recommend…' And you go, 'Sure, sounds good.'"

Outcome: mediocre skills and prompts. The human must own the strategy; Claude executes.

## 3-Step Skill-Building Process (Cowork + Notion)

The masterclass uses [[03-RESOURCES/entities/Claude-Cowork]] paired with Notion. Notion acts as both the knowledge hub (like a Claude Project) and the word processor where Cowork drafts outputs.

### Step 1: Level-Set the Environment

Start clean to avoid "secret doc" contamination:
1. Create a fresh Notion page with a relevant title.
2. Add Notion as a connector in Cowork.
3. When Cowork asks about existing pages, say no — build from scratch.

### Step 2: Tell Claude the Entire Skill Upfront

Describe all steps in order before building anything. Cole's example (Digital Product AI Hub):
- Step 1: Generate 10 digital product ideas in any niche
- Step 2: Run the chosen idea through the Offer Creation Checklist
- Step 3: Build the full product outline using the Bookends Framework
- Step 4: Write each module using the 7-Section Module Template

### Step 3: Package One Step at a Time

The most common failure: building the whole skill at once, getting bad output, then spending days debugging.

**The correct loop:**
1. Build Step 1 only.
2. Test with a real example.
3. If output is good → ship to Notion → move on.
4. If output is bad → the problem is your documentation, not Claude. Fix the input.
5. Repeat until every step works.
6. Package the full skill.

## Cowork + Notion vs Claude Projects

| Feature | Claude Projects | Cowork + Notion |
|---|---|---|
| Persistent context | Yes | Yes (via Notion hub) |
| Chained prompts / skills | No | Yes |
| Word processor output | No | Yes (Notion drafting) |
| Skill sequencing | No | Yes |

## The Ultimate Heuristic

> "Write the long-form version of the thing you're trying to teach. Write it for a human first. Write it the way you'd explain it to your smartest friend over coffee. Get every step on the page in excruciating detail. Then take that writing and turn it into a prompt. That's the whole game."

## Connections in Vault

- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — the technical format this process produces
- [[03-RESOURCES/concepts/learning-cognition/skill-development]] — the human-first writing approach to AI skill creation
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]] — Cole's approach opposes tricks; favors clarity of thought
- [[03-RESOURCES/entities/Claude-Cowork]] — the execution environment for this workflow
- [[03-RESOURCES/concepts/claude-code-tooling/claude-projects]] — the simpler alternative Cowork supersedes for skill chaining

## Why the "write for a human first" principle is mechanistically correct

Cole's heuristic — write the skill content for a human first — is not just stylistic advice. It is mechanistically sound because LLMs are trained on human-readable text. A skill written the way a skilled teacher would explain a process to a capable colleague will retrieve better from the model's training distribution than a skill written in terse bullet-point shorthand optimized for machine parsing.

The failure mode Cole identifies ("letting Claude take the wheel") is a coordination failure: the human provides incomplete specification, the model fills gaps from its training prior, and the result reflects the prior rather than the user's actual intent. The more concrete and complete the specification — even if it feels redundant or obvious — the less room the model has to substitute its own defaults.

## The iterative loop is debugging the input, not the output

The most operationally useful insight from Cole's process is the reframe in Step 3: if the output is bad, the problem is the documentation, not Claude. This shifts the debugging target from "how do I prompt better in the moment" to "what is missing or ambiguous in my skill specification."

This is a more productive frame because it makes the skill file a persistent artifact that improves over time. Each bad output is evidence that the specification is underspecified in some dimension — and fixing the spec fixes all future invocations of the skill, not just the current session.

## Aplicação para o vault-michel

O processo de Cole mapeia diretamente para a criação de skills no vault. A pasta `04-SYSTEM/skills/` contém skills que seguem exatamente esse padrão: descrição completa do workflow antes de qualquer instrução para o modelo, construídas e testadas passo a passo. O princípio "a output ruim = documentação incompleta" é especialmente relevante para skills de ingestão e wiki-update, onde o comportamento esperado é mais sutil do que parece na primeira especificação.
