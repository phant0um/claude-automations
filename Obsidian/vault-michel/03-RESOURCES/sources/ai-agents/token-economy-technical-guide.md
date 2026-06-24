---
title: "Token Economy: A Technical Guide to AI"
type: source
created: 2026-06-23
updated: 2026-06-23
tags:
  - ai-agents
  - token-economy
  - prompt-engineering
  - optimization
  - source
---

# Token Economy: A Technical Guide to AI

**Source:** [X post by @kocer_eth](https://x.com/kocer_eth/status/2068031996098478210) · Published 2026-06-19

## Central Thesis

Most people do not run out of AI because the model is bad. They run out because every request is wasteful — too much context, too many vague instructions, too many unnecessary explanations. Tokens are the real currency of AI work. This guide is about token economy: how to use AI in a way that is cheaper, faster, and more predictable, not by using magic prompts, but by setting clear rules, cutting noise, structuring inputs, and making the model do exactly the amount of work needed.

## Part 1: Settings, System Prompt, and Language

### 1. Set Up System Rules

In ChatGPT: Settings → Personalization → Custom Instructions → Enable. In the API: system/developer instructions. These are the basic rules the AI follows every time.

### 2. Basic System Prompt for Saving Tokens

Write system instructions in English (shorter for the tokenizer; final answer can still be any language):

```
You are an efficiency-first AI assistant.
Core rules:
1. Be concise, direct, and practical.
2. Do not start with greetings, apologies, or phrases like "Sure" / "Конечно".
3. Do not restate the user's request.
4. Give the result immediately.
5. Do not reveal chain-of-thought. Give conclusions, checks, and final answer only.
6. For simple tasks: final answer only.
7. For complex tasks: give a short 3-step plan, then the result.
8. Ask at most one clarifying question only if the missing detail blocks the task.
9. Prefer plain text and short bullet points.
10. Avoid tables unless explicitly requested.
11. Default answer length: 1200–2500 characters.
12. If source text is provided inside tags, process only that tagged text.
13. If the user asks for a draft, return ready-to-use copy.
14. If facts may be outdated, say that verification is needed.
15. Prioritize accuracy, brevity, and usefulness over politeness.
```

### 3. Native Language Mode

- Instructions in English
- Source data in original language
- Final answer in required language

No need to translate everything. Keep the source in its original language for meaning/style preservation.

### 4. System Prompt for a Telegram Editor

Specialized system prompt for a specific use case — pre-configures style, structure, rules so you never need to repeat "make it beautiful, clear, without filler."

### 5. How to Write a Regular Request

**Bad**: "Please take a look, I have this text, I want to somehow improve it so that it is normal, clear, interesting..."

**Good**:
```
Task: adapt the text for Telegram.
Audience: regular users.
Style: clear, confident, without filler.
Format: headline; short introduction; 10 points; final conclusion.
Limits: up to 3500 characters; no long introductions; no invented facts.
<text>insert the source text here</text>
```

AI does not need to be persuaded. It needs to be given a clear task.

## Part 2: Cache, Models, Files, and Workflow

### 6. Use XML Tags

Tags show the model where the instruction is and where the data is:
```
Task: find risks in the contract.
<contract_fragment>insert the required contract fragment here</contract_fragment>
```

For multiple documents, use nested `<documents>` with `<document id="N">` tags.

### 7. Don't Ask "Think Step by Step" Without a Reason

"Think step by step" increases token usage. For simple tasks: "Give final answer only. No reasoning." For medium: "Give a short 3-step plan, then the final answer." For complex: "Analyze carefully, but show only: conclusion, key reasons, risks, next steps."

### 8. Configure Reasoning/Thinking Mode

- Simple tasks: low/minimal/fast/economy
- Medium tasks: medium
- Complex tasks: high

Don't enable maximum thinking to fix a text or make a list. "That is like calling special forces to open a jar of pickles."

### 9. Limit Answer Length

```
Answer in Spanish. Max length: 1500 characters. No intro
```

Or specify exact output format: "Return only: headline; post text; CTA."

### 10. Don't Keep an Endless Chat

A long chat is not memory — it is a heavy backpack. **New task = new chat.** Transfer only a short summary if old context is needed.

### 11. Don't Upload Unnecessary Files

If the question is about one clause, upload only that fragment in tags, not the whole contract.

### 12. Cache: The Main API Saving Rule

Cache likes stability. Structure:

```
[STABLE BLOCK] — system rules (role, style, output format, restrictions, examples)
[VARIABLE BLOCK] — user task (specific task, new text, new data)
```

Don't touch the stable block. Add new data at the end.

### 13. Choose the Model for the Task

- **Lightweight model**: editing, shortening, headlines, simple translation, lists, posts, template emails
- **Strong model**: complex logic, code, strategy, document analysis, legal risks, medicine, finance, multi-step tasks

Saving starts not with the prompt but with choosing the right model.

### 14. Universal Request Template

```
Task: [what needs to be done]
Audience: [who the result is for]
Context: [why this is needed]
Style: [tone and delivery]
Output format: [answer structure]
Limits: [length, language, restrictions]
Source:
<text>[source data]</text>
```

This replaces 90% of "secret prompts."

### 15. Mini Checklist Before Sending

- Is the task formulated briefly?
- Is the answer language specified?
- Is the answer format specified?
- Is the length limit specified?
- Has unnecessary context been removed?
- Is the source text separated with tags?
- Am I not asking it to "think deeply" without a reason?
- Am I not continuing an old chat unnecessarily?
- Have I chosen the right model?
- Does the system prompt stay the same each time?

**The main saving formula:** stable system prompt + short English instruction + tags for data + length limit + right model = fewer tokens, faster answer, higher quality.

## Minha Síntese

Guia técnico prático sobre economia de tokens — a moeda real do trabalho com IA. O insight central é que o desperdício estrutural (contextos longos, prompts vagos, chats infinitos) mata a eficiência mais que a qualidade do modelo. A separação stable block / variable block para cache é o insight de maior impacto econômico para quem usa APIs. A regra "new task = new chat" ressoa com o conceito de fresh context em [[03-RESOURCES/sources/ai-agents/loop-engineering-delegating-judgment-not-code]] — progresso deve viver no disco, não na conversa. O template universal de request é diretamente aplicável como padrão de operação no vault. Conecta também com [[03-RESOURCES/sources/ai-agents/glm-52-open-source-ai-setup]] — "token minimizing and output maxing" é a mesma tese vista pelo lado da escolha de modelo.