---
title: Agent Feedback Loop Learning
type: concept
status: developing
created: 2026-05-14
updated: 2026-05-14
tags: [agents, feedback-loops, meta-learning, principles, skill-as-code, compounding-judgement]
---

# Agent Feedback Loop Learning

The design pattern where agents doing judgment-heavy work improve continuously from human feedback embedded in normal team workflows — rather than relying on a single perfected prompt written at deploy time.

> [!key-insight] Core thesis
> The best prompt you write today will not be the best prompt a month from now. The question shifts from "how do we write the perfect prompt?" to "how do we build agents that keep learning from the team after they ship?"

## The Problem: Agents That Almost Work

Many judgment agents reach a plateau: output quality is good enough to generate hope but not good enough to trust. The team keeps tweaking the prompt, hoping the next version closes the gap. This is the wrong level of abstraction.

Static prompts fail judgment domains because:
- The product changes over time
- The team's taste is refined through use
- New edge cases continuously emerge
- No exhaustive decision tree can cover all situations

Domains affected: social replies, customer outreach, support responses, code review comments, product feedback analysis, docs, recruiting messages — any task requiring knowing *what matters* and *when not to act*.

## Principles Beat Rules

The first iteration of most judgment agents is a long checklist of rules: "If X, say Y." This is brittle: the prompt grows, replies become robotic, and the agent breaks the moment an unlisted situation appears.

The shift: replace enumerated rules with **durable principles** — descriptions of *how to think*, not *what to do*.

Examples from Warp's Buzz agent:
- Be helpful, not defensive.
- Do not talk down to the user.
- Check factual claims against the docs.
- Sound like someone who builds the product, not someone who processes feedback.

**Why principles transfer:** rules overfit to observed cases; principles apply to unobserved cases via reasoning.

## Feedback Is Not Learning Unless the Agent Can Generalize

When feedback is applied naively, agents convert every correction back into a rule. If a reply felt "too marketing-y," a rule-oriented agent writes: "Never mention pricing in the first sentence." The actual transferable principle is: "If someone is venting, lead with empathy, not a pitch."

The agent needs a **separate meta-skill that learns how to learn** — a second layer that looks at the agent's suggestion, what the human did instead, and the current instructions, then identifies what principle is missing or unclear.

### The 7-Step Learning Process

1. **Identify what went wrong (or right)** — start from specific feedback, be concrete
2. **Ask: why?** — the failure is a symptom; find the underlying cause
3. **Zoom out to the pattern** — would this apply beyond this one case?
4. **Check against existing principles** — sharpen, edit, delete, or add?
5. **Write it as a principle, not a rule** — describe how to think, not what to do
6. **Put it where it belongs** — section placement matters for the agent to apply them correctly
7. **Edit and commit** — update the skill file, keep it tight, merge overlapping principles

## The Feedback Loop Must Fit the Team

A learning system only works if people actually use it. Design requirements:
- Lives where the team already works (Slack, email, daily tools)
- Minimum friction: one emoji reaction is sufficient signal
- Optional thread adds context but is not required

At Warp: Buzz posts each mention in Slack with recommendation + draft reply. Team reacts with an emoji for what they actually did. Once per day, Buzz collects reactions and thread feedback, extracts learnings, updates skill files, and opens a PR.

## Skill-as-Code: Human Review Before Merge

Giving an agent the ability to rewrite its own instructions is safe only when treated like a code change:

- Skill files live in a version-controlled repo
- The learning agent does **not** directly change production behavior
- It opens a **PR** showing: what feedback it reviewed, what principle it thinks should change, the exact diff to the skill file
- A human reviews and merges like any other change

This provides the value of self-improvement without loss of control. The daily PR is the safety valve.

> [!note] Skill-as-code vs self-evolving agents
> This pattern differs from [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]] (Autogenesis): self-evolving agents modify themselves without human review, optimizing autonomously against a fixed metric. Feedback loop learning deliberately keeps humans in the merge decision — compounding human taste, not replacing it.

## Compounding Judgement

The goal is not to remove human judgment from the system — it is to make human judgment **compound**.

Every correction from the team: → new principle → reviewed PR → merged → next run improves.

Over time, the skill file becomes a working memory of how the team thinks, not just a prompt someone wrote once.

> The best teams will not just write better prompts. They will build better loops.
> — Petra Donka, Warp

## Implementation Summary

| Component | What it does |
|-----------|-------------|
| Principles-based skill file | Encodes durable judgment, not brittle rules |
| Feedback interface | Slack emoji + optional thread; 1 click = sufficient signal |
| Meta-learning skill | Converts specific corrections into generalized principles |
| Daily PR | Learning agent proposes skill updates; human reviews diff |
| Version control | Skill history, rollbacks, accountability |

## Related Concepts

- [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]] — fully autonomous variant; no human review in the loop
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — skill-as-code mechanism; SKILL.md in version control
- [[03-RESOURCES/concepts/agent-systems/agentic-agents]] — agent loop fundamentals
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — separating the learning agent from the task agent
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — fat skills as living context

## Organizational Scale: Feedback → Company Rule (Single Grain)

At company-brain scale, the same mechanism operates across the entire agent fleet rather than a single agent. Ericosiu (Single Grain, 2026-05-29) describes Layer 5 of the company brain:

- Agent uses stiff phrase → voice rule updates
- Agent cites unsafe example → source rule updates
- Agent misses CRM risk signal → pipeline scan rule updates
- Agent routes work incorrectly → workflow rule updates

**Key difference from single-agent feedback:** corrections compound across all agents sharing the same rule layer, not just the one that made the mistake. One human correction trains the whole operating system.

> "Without feedback loops, you're just babysitting software. With feedback loops, every correction becomes a training rep for the whole operating system."

→ [[03-RESOURCES/sources/memory-context-rag/how-we-built-single-company-brain]]

## Complementary Pattern: Backpressure Loop (Mechanical)

> [!note] Distinct from meta-learning feedback
> The **Backpressure Loop** (bibryam, 2026-06-06) is about mechanical in-session feedback — type checkers, tests, linters — reaching the agent before the human, enabling autonomous self-repair within a single session. This concept covers **learning from human judgment over time** (skill files, PRs, compounding taste). The two operate at different timescales and complement each other.
>
> → [[03-RESOURCES/sources/backpressure-loop-coding-agents]]

## Sources

- [[03-RESOURCES/sources/ai-agents-harness/agents-need-feedback-loops-not-perfect-prompts]] — Petra Donka (@petradonka), Warp; 2026-05-14
- [[03-RESOURCES/sources/memory-context-rag/how-we-built-single-company-brain]] — Ericosiu / Single Grain; organizational-scale feedback→rule compounding; 2026-05-29
- [[03-RESOURCES/sources/backpressure-loop-coding-agents]] — bibryam; mechanical backpressure (type checker/test/linter) before human; 2026-06-06

## Evidências
- **[2026-06-19]** Loop externo lê comentário de correção humana (ex.: "reclassificado porque havia ambiguidade") como sinal de treino direto para gerar diff de melhoria — [[03-RESOURCES/sources/how-to-build-a-self-improvement-loop-for-skills]]
- **[2026-06-19]** Prompt como "apprentice" que se reescreve a cada lote de ~100 decisões humanas (não a cada ação — 1 decisão é ruído); 2 camadas: evaluator barato em todo input + apprentice caro só no lote — [[03-RESOURCES/sources/how-to-make-claudes-prompt-update-itself-after-100-decisions]]
