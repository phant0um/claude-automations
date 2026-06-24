---
title: "How to Run Your LinkedIn Inbox from Claude Code"
type: source
source: "Clippings/How to Run Your LinkedIn Inbox from Claude Code.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
## Who you're working for
You run the LinkedIn inbox for [name], founder of [company]. You sort replies,
draft responses in my voice, chase the quiet ones, and surface only what needs me. You never send a message on your own.

## Argumentos principais
### What you're actually building
It's four pieces, and it helps to picture the entire shape of it before you wire anything.
1. The first is an orchestrator: a single context file that runs the whole operation. It tells the agent who you are, what you sell, how you talk, and what it's never allowed to do. That one file is why the drafts come out sounding like you. Without it, you get a robot wearing your name tag.
2. The second is a capture, which grabs every reply the moment it lands so nothing rots unread.

### First, build the orchestratorh
Most people point an AI at their inbox, get generic mush back, and decide the whole idea doesn't work. The mush is the problem, and it comes from giving the thing no context. With nothing to go on, it guesses. Give it the real picture of your business and it starts to sound like you on a decent day.
Brandon Charleson, who built the open-source HeyReach CLI, puts it as context plus capability. The capability is the tools, and you already wired those up in the first playbook, when you connected the HeyReach CLI to Claude Code. The context is the part you're about to write.
In your project folder, make a CLAUDE.md. Claude Code reads it automatically every session, so it becomes the agent's standing brief. Fill it in for real:

### Who you're working for
You run the LinkedIn inbox for [name], founder of [company]. You sort replies,
draft responses in my voice, chase the quiet ones, and surface only what needs me.
You never send a message on your own.

### What we sell
[One plain sentence: the product, and the result it gets people.]
ICP: [titles], at [company type and size], usually feeling [the pain].
The one outcome we sell: [what the buyer actually wants].

### How I talk in DMs
- Plain English, lowercase is fine, like a text not an email.
- Two or three sentences. One question, never two.
- Never pitch in a reply. Move the conversation one step, usually toward a short call.

### Hard rules
- Only use facts that are in the actual thread. Never invent anything about their company.
- If a reply is a real objection or a pricing question, flag it for me. Don't template it.
- If you're unsure what they mean, ask me. Don't guess and don't send.

### Catch every reply the second it lands
Two ways to make sure nothing slips, and you'll use both.
The simple one is to pull everything unread on demand:
```bash

### Sorting two hundred replies in two minutes
This is the engine. You hand the agent a reply along with the full thread, and it hands back clean data you can branch on: a category, a confidence score, a one-line read, and a draft. That last bit, the structure, is what lets every step after this run on its own.
Here's the sorting prompt. Put it in your CLAUDE.md or keep it as a saved command. It's doing real work, so read it once:
```javascript

### It drafts. You approve.
One rule sits above all of this, and you'll want it as badly as I do: the AI never sends on its own. It drafts, you read, you approve, and only then does it go out. That's what keeps the whole thing trustworthy.
In practice it's a single instruction:
```javascript

### Everything else files itself
Your live five came to you. Everything else should file itself, because nothing slows you down like a cluttered inbox. Set up your tags once so the agent has somewhere to put things:
```bash
heyreach lead-tags create --tags-json '[

### The meetings hiding in the silence
This is the piece that turns a clever inbox into an actual pipeline system. Almost no deals die on a flat "no". The killer is silence. Somebody was interested, you had a good exchange, and then life got in the way, the thread trailed off, and nobody picked it back up. A real opportunity quietly disappeared.
Your agent should be hunting those down. Pull the raw material first:
```bash

### The one prompt you'll paste every morning
All of it collapses into one thing you paste with your coffee:
```javascript
Run my LinkedIn inbox.

### Read the funnel like an operator
Now the whole funnel is visible from the same window you work in, so you can actually adjust it. Pull the numbers:
```bash
heyreach stats overview --start-date 2026-06-01 --end-date 2026-06-22


## Key insights
- Plain English, lowercase is fine, like a text not an email.
- Two or three sentences. One question, never two.
- Never pitch in a reply. Move the conversation one step, usually toward a short call.
- Banned: "touch base", "just following up", "let's reconnect", exclamation-mark stacks.
- Only use facts that are in the actual thread. Never invent anything about their company.
- If a reply is a real objection or a pricing question, flag it for me. Don't template it.
- If you're unsure what they mean, ask me. Don't guess and don't send.
- You draft. I approve. Then you send. That order, every time.
- Use only facts from the thread. Never invent a detail about their company or role.
- A draft is plain, two or three sentences, one question max, no pitch, moving toward a short call.

## Exemplos e evidências
See original source at `Clippings/How to Run Your LinkedIn Inbox from Claude Code.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/entities/Claude]]
- [[03-RESOURCES/entities/LinkedIn]]
- [[03-RESOURCES/entities/Rust]]

## Minha Síntese
**O que muda:** Um orchestrator file (CLAUDE.md) com identidade, regras hard, tom de voz e sorting prompt é suficiente para transformar Claude Code em um inbox manager que rascunha mas nunca envia sem aprovação.

**Conexão pessoal:** Este é o padrão exato do vault — CLAUDE.md como standing brief, hard rules como guardrails, e human-in-the-loop no envio. Diretamente aplicável a inbox de clientes.

**Próximo passo:** Adaptar este padrão para gerenciar inbox de e-mails profissionais usando Claude Code + HeyReach ou equivalente.
