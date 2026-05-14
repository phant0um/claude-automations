---
title: "You Prompt (the New) Claude Wrong. Do This Instead."
type: source
source_type: clipping
source_file: "Clippings/You prompt (the new) Claude wrong. Do this instead.md"
source_url: "https://x.com/rubenhassid/status/2053324202321834073"
author: "Ruben Hassid (@rubenhassid)"
created: 2026-05-14
tags: [claude-opus-47, prompting, adaptive-thinking, prompt-engineering, claude-skills, rubenhassid]
---

# You Prompt (the New) Claude Wrong. Do This Instead.

**Author:** Ruben Hassid — @rubenhassid  
**Based on:** Anthropic's 31-page Opus 4.7 prompting guide

## Old vs. New Claude Behavior Changes

| Dimension | Claude 4.6 | Claude 4.7 |
|---|---|---|
| Instruction following | Infers intent, interprets loosely | Does exactly what you typed |
| Response length | Roughly consistent regardless of input | Sizes to perceived task size |
| Tone | Warmer, validation-forward, "Great question!" | More direct, minimal emojis |
| Tool calls | Called frequently | Calls fewer; reasons more between calls |

## 7 Prompting Fixes for Opus 4.7

**1. Replace vague verbs with explicit scope**
- Old: "Review this contract."
- New: "Review this contract. Flag risks per clause. Rate severity 1–5. Suggest one rewrite per risky clause. Return as a table."

**2. Define length explicitly**
- Old: "Summarize this report."
- New: "Summarize this report in exactly 5 bullet points. Each bullet under 15 words. First word: an action verb."

**3. Use positive instructions only — negatives stick literally**
- Old: "Don't use jargon."
- New: "Write in plain English a 16-year-old could read aloud. Replace 'leverage' with 'use'."

**4. Use action verbs only — 4.7 ships specifics**
- Old: "Can you help me with the email?"
- New: "Go to my Gmail. Find [contact] and read our last conversation. Write the answer email. Final draft. Send-ready. Goal: book a meeting with the CRO of Snowflake by Friday. Length: under 90 words. Tone: confident, casual, specific."

**5. For tool use — prompt explicitly if you want more**
- Default: 4.7 reasons more, calls fewer tools
- Force: "Use web search aggressively. Verify every claim with at least 2 sources."

**6. To restore warmth if desired**
- "Use a warm, conversational tone. Acknowledge the user's framing before answering."
- Or: paste 2–3 sentences in the voice you want, tell Claude to match the rhythm.

**7. "Go beyond the basics" on creative tasks**
- From Anthropic's own 4.7 doc
- Pushes 4.7 past the literal minimum on open-ended work

## Trick: Force Maximum Reasoning

Adaptive Thinking does not reason by default. Add to any prompt:

> **"Think before answering (maximum reasoning)"**

Combined with selecting xhigh thinking mode in the UI.

## Skill Strategy: Use a Skill to Optimize Prompts

Author created a `/47` skill that takes any lazy prompt and rewrites it as an Opus 4.7-optimized prompt. Pattern:
1. User types `/47 [lazy prompt]`
2. Claude uses the skill, reasons about the prompt
3. Outputs a polished, structured Opus 4.7 prompt
4. User pastes into new chat

## Key Entities

- [[03-RESOURCES/entities/Ruben-Hassid]] — author
- [[03-RESOURCES/entities/Claude-Opus-47]] — the model being addressed

## Connections

- [[03-RESOURCES/concepts/prompt-engineering-patterns]] — update: Opus 4.7 literal behavior changes patterns
- [[03-RESOURCES/concepts/adaptive-thinking]] — Adaptive Thinking behavior explained
- [[03-RESOURCES/concepts/claude-skills]] — /47 skill as a prompt-optimization skill
- [[03-RESOURCES/concepts/token-efficiency-prompting]] — positive instructions reduce wasted tokens
