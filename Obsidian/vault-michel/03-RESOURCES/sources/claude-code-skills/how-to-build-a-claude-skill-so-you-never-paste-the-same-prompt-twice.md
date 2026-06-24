---
title: "How to Build a Claude Skill (So You Never Paste the Same Prompt Twice)"
type: source
source: "https://x.com/0xLagosaur/status/2068693290581414390"
author: "[[@0xLagosaur]]"
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents, claude-code, skills, reusability, prompt-engineering]
---

## Tese central

Skills transformam prompt repetition em reusable capabilities. Package expertise uma vez, Claude carrega quando relevante. A diferença: prompt é algo que você lembra de usar; Skill é algo que Claude lembra de usar por você.

## A Skill Is Not a Prompt

- **Prompt**: você decide, toda vez, que é o momento de usar
- **Skill**: Claude lê a situação e puxa a Skill automaticamente quando a task match a description

Under the hood: Skill = pasta com um arquivo obrigatório (`SKILL.md`) com header (trigger) + instructions (how). Código é plain English.

**3 fatos antes de buildar:**

1. **Cross-platform**: mesma Skill roda em Claude app, Claude Code, API. Build once, use everywhere.
2. **Lazy loading**: só a one-line description fica no context sempre. Instructions completas loadam só quando trigger match. 20 Skills instaladas = quase zero context cost para as 19 não em uso.
3. **Open standard (late 2025)**: Skills não são só Claude — Copilot, Cursor, Codex, 40+ tools leem o mesmo formato. Build one, use everywhere.
4. **Anthropic official Skills**: `github.com/anthropics/skills` — cada uma é uma pasta com SKILL.md, mesma estrutura.

## Build Your First Skill in 5 Minutes

1. **Pasta**: lowercase, no spaces. Ex: `tighten-draft/`
2. **SKILL.md** dentro da pasta:

```text
---
name: tighten-draft
description: Use when I ask to edit, tighten,
shorten, or clean up a piece of writing.
---

You are my editor.

Cut 20% on every pass and guard my voice.

- Kill filler, hedging, and repeated ideas.
- Flag any sentence that says nothing.
- Never change my meaning, only tighten.

Return the edited version,
then 3 bullets on what you cut and why.
```

3. **Upload**: Settings → Capabilities → Skills → Add folder

**A linha mais importante**: `description` é o trigger. Claude decide se usa a Skill baseado nela. Escreva como "Use when I..." com frases reais que você digita.

- Bad: `Use for strategic evaluation.`
- Good: `Use when I ask: is this worth doing? should I build this? should I ship this?`

Vague description = Skill never fires. Specific description = Skill fires exactly when you want.

## 4 Skills Worth Stealing

### 1. My Voice (voice consistency)

```text
---
name: my-voice
description: Use whenever you write or rewrite
anything meant to sound like me:
posts, emails, captions, replies.
---

Write in my voice.

My voice:
- direct, concrete, no corporate language
- short lines, lots of white space
- specific numbers and examples over vague claims
- lead with the point, no throat-clearing intro

Rules:
- never use "delve", "leverage" (verb), "unlock", "game-changer"
- no em dashes, no hashtags, no emoji
- end on a statement, never a question

If a line could appear on any brand's feed,
rewrite it until it could only be mine.
```

### 2. Fact-Checker

```text
---
name: fact-check
description: Use when I ask you to fact-check,
verify, or check claims in a draft before publishing.
---

You are my fact-checker.

Verify, never invent.

For each factual claim:
- mark it Verified
- mark it Unverified
- mark it Wrong

For anything not Verified:
- say exactly what's missing

Also:
- separate vendor claims from independent facts
- flag any number without a source

Return a claim-by-claim list.
Do not rewrite the piece. Just judge it.
```

### 3. Decision Filter (kill bad ideas)

```text
---
name: should-i
description: Use when I'm deciding whether to
build, write, ship, or commit to something.
---

You are my strategist.

Judge before I build.

- Is this worth doing at all?
- Who exactly is it for?
- What is the single most likely reason it fails?
- What should I cut or simplify?

Return:
- ship / fix / kill
- one line of reasoning

Do not be polite.
If it's a kill, say so plainly.
```

### 4. Session Saver (checkpoint long chats)

```text
---
name: checkpoint
description: Use when a chat is getting long,
or when I say "checkpoint" or "save progress".
---

Compress everything so far into a short handoff:

- original goal
- what's done
- key decisions made
- what's left to do

Keep it under 200 words.

Then continue the work from that summary
as the new starting point.
```

## Pro Moves

### Keep heavy material in separate files

Pasta pode ter mais que SKILL.md:

```text
my-voice/
├── SKILL.md
└── references/
    ├── brand-guide.md
    ├── examples.md
    └── style-rules.md
```

Claude loads reference files only when needed. Skill conhece 50-page brand book sem arrastar para toda conversa.

**Arquitetura 3 camadas:**

| Layer | Conteúdo | Context cost |
|-------|----------|-------------|
| 1 | Description | Always loaded |
| 2 | Instructions | Load when triggered |
| 3 | Reference files | Load only when needed |

### Write descriptions using your real language

Trigger é tudo. Se description diz "Use for strategic evaluation" mas você digita "Is this worth doing?", Skill nunca fire. Match com palavras reais.

## When a Skill Misbehaves

| Problema | Causa | Fix |
|----------|-------|-----|
| Never fires | Description não match sua linguagem | Rewrite as "Use when I..." com frases exatas |
| Fires too often | Description muito broad | Narrow the job, remove vague triggers |
| Ignores own rules | Instructions long/contradictory/multiple jobs | One Skill, one job. Split. |
| Stale | Preferences mudaram | Edit SKILL.md, re-upload. Living files. |

## What to Turn Into a Skill First

Regra: **pastou um prompt 3+ vezes → é Skill. Explicou mesma preference 2+ vezes → é Skill.**

Start with the one that annoys you most. The instructions you retype every day.

## The Shift

People getting absurd leverage out of Claude aren't writing better prompts in the moment. They built their best thinking into Skills once. Every session starts with the model already knowing how they work.

## Minha Síntese

Este artigo é a essência do que já fazemos no vault-michel com Hermes Skills — `~/.hermes/skills/` tem 100+ skills que carregam automaticamente. A regra "pastou 3+ vezes → Skill" é exatamente o padrão que sigo. O ponto sobre 3-layer architecture (description/instructions/references) reflete a estrutura já usada: SKILL.md + references/ + scripts/. Próximo passo: auditar skills existentes por trigger quality — descriptions vagas são o #1 motivo de skill nunca carregar.

## Links

- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-tooling]]
- [[03-RESOURCES/sources/claude-code-skills/claude-code-skills-the-hidden-system-prompt-layer-that-turns-claude-into-a-senior-engineer]]
- [[04-SYSTEM/skills/foundational/hermes-agent-skill-authoring|Skill authoring skill]]
- [[03-RESOURCES/concepts/agent-systems/loop-engineering-patterns]]