---
title: "How to Actually Use Claude: 18 Steps That Unlock 100% of Its Potential"
type: source
author: "[[03-RESOURCES/entities/Anatoli-Kopadze]]"
source_url: "https://x.com/AnatoliKopadze/status/2054568935274549597"
published: 2026-05-13
ingested: 2026-05-14
tags: [claude, prompts, produtividade, prompt-engineering, projects, token-economy]
triagem_score: 6
---

# How to Actually Use Claude: 18 Steps That Unlock 100% of Its Potential

Thread by [[03-RESOURCES/entities/Anatoli-Kopadze]] (@AnatoliKopadze). 18 actionable steps for getting full value from Claude, structured around setup, mindset shifts, token economy, and ready-to-use prompts.

## Summary

Most users operate at ~10% of Claude's capability. The gap is not complexity — it is configuration and technique. This thread covers persistent setup, interaction patterns, and concrete prompts across 18 steps.

## Key Themes

### 1. Persistent Setup (Steps 1–3)
- **Projects over chats** — Projects give Claude persistent context across all sessions in a workspace. Setup once; every session starts with Claude already knowing the user.
- **Identity file** — A structured self-description (name, role, goals, use cases, knowledge level, communication style, anti-patterns) saved in the Project knowledge base.
- **Custom Instructions from identity** — Metaprompt Claude to generate its own operating instructions from the identity file. Paste output into Project Instructions. Under 400 words, second person, specific.

### 2. Mindset Shift (Steps 4–5)
- **Claude is not a search engine** — It is a thinking partner. Treating it as a retrieval tool cuts usefulness by 80%. Shift from "What is X?" to "Help me think through X given this context."
- **Ask questions first** — Before any complex task, tell Claude to ask the 5 most important questions before starting. Eliminates assumptions; dramatically improves first-pass output.

### 3. Power Techniques (Steps 6–9)
- **Style cloning** — Provide 3–5 writing samples. Ask Claude to analyze patterns (sentence length, rhythm, vocabulary, paragraph structure, what you avoid). After analysis, Claude matches voice rather than defaulting to its own.
- **Sparring partner** — Ask Claude to *attack* a plan (find every wrong assumption, argue the opposite as hard as possible, no qualifications), then steelman it, then give its real opinion.
- **Extended Thinking** — Brain icon in UI or explicit "Think through this step by step, show reasoning, identify uncertainty, then conclude." Significant quality gain on hard questions.
- **Claude writes prompts for Claude** — Metaprompting: ask Claude to write the best possible prompt for a task (including role, context, format, constraints), then use it immediately.

### 4. Token Economy (Steps 10–13)
- **Specify output length** — Explicit length constraints ("Answer in 3 sentences", "5 bullet points no explanations", "under 150 words") cut token usage 40–60% without value loss.
- **Remove preamble via Custom Instructions** — Add to Project Instructions: never start with affirmations, restatements, or disclaimers; go directly to the answer; no closing summary unless asked.
- **Never re-explain context** — Use Projects + Custom Instructions so background is read automatically. Never paste personal context again.
- **New chat for new topic** — Switching topics inside a long chat loads irrelevant context on every response (context bleed, slower, more tokens). Start fresh chat in same Project.

### 5. Ready-to-Use Prompts (Steps 14–18)
- **Feynman via analogies** — "Explain [topic] using only analogies and everyday examples. After each analogy, ask me one question to check comprehension. Keep going until I can explain it back without jargon."
- **Personalized travel planning** — Input travel style, budget, pace, what to avoid; get a full day-by-day itinerary tailored to actual preferences.
- **Expense analysis** — Paste raw bank data; get categorized analysis with specific recommended changes and financial impact.
- **Personal thinking partner** — Structured self-reflection: Claude asks questions first, reflects back what it hears (including what's underneath the facts), then gives honest opinion.
- **Stress-test business idea** — Adversarial analysis: wrong assumptions, existing competitors, why the customer won't pay, what must be true, the single biggest problem. Then: what the idea would need to look like to actually work.

## Canonical Prompts

### Identity template (Step 2)
```
My name is [your name].
I work as [role]. My main responsibilities are [2-3 things].
Right now my biggest goals are [1-3 goals].
I use Claude mostly for [use cases].
My background and knowledge level: [what you know, what you're learning].
How I like to receive information: [style preference].
Things I don't want: [anti-patterns — no disclaimers, no "Great question", etc.].
Topics and areas I care about: [interests, domain].
```

### Custom Instructions generator (Step 3)
```
Based on everything I've told you about myself, write me a set of custom instructions for this Claude Project.
The instructions should:
- Describe who I am and what I do
- Set my default communication style and format
- Tell Claude what to never do when working with me
- Define the tone I want in every response
- Include any default behaviors I would want in every session
Write them in second person, as if Claude is reading rules about how to help me. Be specific. No generic advice. Under 400 words.
```

### Questions-first pattern (Step 5)
```
Before you start, ask me the 5 most important questions that would help you do this well.
After I answer, then begin.
```

### Style cloning (Step 6)
```
Here are 3 examples of my writing:
[sample 1]
[sample 2]
[sample 3]
Analyze my writing style in detail. Look at: sentence length, rhythm, vocabulary choices, how I open and close paragraphs, what I avoid, how formal or informal I am, and any patterns that make my writing distinct.
After this, when I ask you to write anything for me, match this style exactly. Do not default to your own patterns.
```

### Sparring partner / stress-test (Step 7)
```
Here is my plan: [describe plan]
Your job is to destroy it. Find every assumption I'm making that could be wrong. Find every way this could fail. Argue the opposite position as hard as you can. Do not be polite. Do not add qualifications. Just attack.
After that, steelman my position. Build the strongest possible case for why I'm right.
Then tell me what you actually think.
```

### Preamble removal (Step 11)
```
Never start responses with preamble, affirmations, or restatements of my question.
Go directly to the answer.
Do not add a summary at the end unless I specifically ask for one.
No disclaimers unless the topic genuinely requires one.
```

### Metaprompting (Step 9)
```
I need Claude to help me [describe task].
Write me the best possible prompt for this task.
Include role, context, format instructions, and any constraints that would improve the output.
Then use that prompt immediately.
```

### Feynman via analogies (Step 14)
```
Explain [topic] to me using only analogies and everyday examples. No jargon. Assume I have no background in this field.
After each analogy, check whether I've actually understood it by asking me one question. Based on my answer, go deeper or adjust the explanation.
Keep going until I can explain it back to you in my own words without using any technical terms.
```

### Business stress-test (Step 18)
```
I have a business idea I want to stress-test before I invest serious time in it.
Here's the idea: [describe it — what it is, who it's for, how it makes money, why you think it works]
Your job is to find everything wrong with it. Specifically:
1. What assumptions am I making that could be wrong
2. Who already does this and why I might lose to them
3. Why the target customer might not actually pay for this
4. What would have to be true for this to work, and how likely is that
5. The single biggest problem with this idea
Be specific. Generic risks are not useful. Give me the real version of each problem.
After that, tell me what the idea would need to look like to actually work.
```

## Related
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-projects]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-power-user-framework]]
- [[03-RESOURCES/entities/Anatoli-Kopadze]]
