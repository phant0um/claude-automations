---
title: "7 skills for any serious Hermes agent"
source: "https://x.com/cobi_bean/status/2067962559441908208"
author:
  - "[[@cobi_bean]]"
published: 2026-04-14
created: 2026-06-22
description: "i keep coming back to the same Hermes lesson:if i have to remind an agent how to work more than twice, that behavior probably belongs in a s..."
tags:
  - "clippings"
---
![Image](https://pbs.twimg.com/media/HLLfNSBXcAATzxy?format=jpg&name=large)

i keep coming back to the same Hermes lesson:

> if i have to remind an agent how to work more than twice, that behavior probably belongs in a skill.

that’s the useful part of Hermes for me. you can turn “please do this every time” into part of the agent’s environment that gets invoked every time you ask for **"the thing"** to get done.

the first skills/tools i’d add are boring on purpose:

\> design before implementation > identity before autonomy > repo memory before rediscovery > session memory before context resets > safe workspace access before “let the model click around” > diagrams before hand-wavy systems > skill creation before repeating the same workflow forever

**here are the 7 i’d add to any serious Hermes agent:**

## 1\. superpowers - brainstorming

most agents want to run straight at the artifact.

code, content plan, workflow, diagram, system design, whatever. the failure mode is the same: clean-looking output built on a shaky read of the task.

superpowers brainstorming gives the agent a design gate before it acts. it pushes the agent to understand the project, ask one question at a time, propose a few approaches, write the design, wait for approval, then move into a plan.

that sounds basic until you watch an agent spend 40 minutes confidently building the wrong thing.

> “too simple to need design” is usually where the mistake starts.

i’d use this for coding agents, yes. but also for content sprints, product decisions, workflow design, agent behavior specs, research plans, launch plans, and messy “help me think through this” work.

any time the cost of being confidently wrong is higher than the cost of asking one more question, this skill earns its slot.

USE IT WHEN

- the task is bigger than one command
- there are real tradeoffs
- you’re shaping a workflow, sprint, spec, or system
- the agent needs to ask before it acts

![Image](https://pbs.twimg.com/media/HLLaXwSXAAAhb27?format=jpg&name=large)

[GET IT HERE](https://www.skills.sh/obra/superpowers/brainstorming)

## 2\. soul-grader-skill

a weak soul.md turns a Hermes agent into generic helpful assistant #4837.

you notice it in small ways first:

- the agent forgets what it is actually for
- it accepts work it should refuse
- it invents authority it does not have
- it mixes project boundaries
- it writes pretty sentences instead of enforcing rules

soul-grader-skill grades that identity layer with a 100-point rubric.

the frame i care about: soul.md should be a compact constitution for the agent. keep lore, costume work, giant runbooks, and “be helpful and honest” filler out of it.

the grader checks mission, role boundaries, hard constraints, authority + escalation, truthfulness, success artifacts, and runtime hygiene.

the fail conditions are the useful part: secrets, false access claims, ungated publishing/spend/destructive actions, cross-client contamination, contradictions with companion docs, and runtime junk stuffed into the wrong place.

i’d run this whenever i create or revise a profile, especially before the agent gets tools, memory, cron jobs, repo access, or posting authority.

USE IT WHEN

- you’re writing a new soul.md
- the agent feels generic
- the agent keeps overstepping
- you want a reviewable standard instead of “seems fine”

> Jun 14
> 
> i open sourced a Hermes skill for grading SOUL.md files. 100pt rubric for the identity layer: > mission > role boundaries > hard constraints > authority + escalation > truthfulness > success artifacts > runtime hygiene repo in reply:

## 3\. project-memory-skill

a coding agent should not rediscover the same repo every session.

open repo. scan files. guess conventions. forget the weird decision from yesterday. ask the question you already answered. lose half the session reloading context.

**project-memory-skill fixes that at the repo level.**

it creates a small append-only memory convention inside the project:

> docs/memory/yyyy-mm-dd/descriptive-slug-memory-yyyy-mm-dd.md

**before work**, the agent checks project memory. **after meaningful work,** it writes what changed, what was learned, decisions made, open decisions, files touched, source docs, verification, constraints, gotchas, and next steps.

the key is that the memory travels with the repo. that’s useful for open-source work, multi-day coding sessions, and projects where the next agent run needs to understand why something exists.

this is not transcript dumping. good project memory is small, dated, searchable, and useful to the next run.

USE IT WHEN

- a repo has recurring decisions
- the agent keeps asking old questions
- setup gotchas matter
- future-you needs to understand why something was done

boring infrastructure. exactly the stuff that makes agents feel less stupid.

> May 18
> 
> if you’ve built a bunch of agents and somehow got worse at finishing apps, this SKILL is for you. i’ve built 60+ agents and learned the annoying lesson the hard way: memory is everything. not “save every chat” memory. i mean the boring project memory that keeps the next

## 4\. agent-memory-wiki

project memory is for the repo.

[agent-memory-wiki](https://github.com/cobibean/agent-memory-wiki) is for the operator layer around the agent.

it is an obsidian-backed memory/wiki bundle with three pieces:

- obsidian: safe vault access, markdown notes, wikilinks, and write boundaries
- prepforreset: daily logs and session logs before resets or session ends
- wikijanitor: conservative cleanup, janitor reports, gaps, and review candidates

this matters when you use Hermes through telegram, gateways, scheduled runs, long-running chats, or multiple context windows.

the useful version of memory is curated. decisions, rationale, alternatives, artifacts, open loops, routing candidates, source refs, gotchas.

the transcript-dump version usually turns into “save every token and pray retrieval works.”

i’d use this for personal agents, content agents, research agents, ops agents, pm agents — anything with continuity across days.

USE IT WHEN

- you reset contexts often
- decisions matter more than raw transcript
- you want a human-readable wiki
- the next session needs a clean handoff

![Image](https://pbs.twimg.com/media/HLLbGd7XwAE-fpu?format=jpg&name=large)

## 5\. gogcli

yeah, i know this one is not technically a Hermes skill.

keeping it in the list anyway.

if your agent touches gmail, calendar, drive, docs, sheets, slides, tasks, youtube, or google workspace admin stuff, you want a tool surface like this.

gogcli is a script-friendly google workspace cli built for terminals, shell scripts, ci, and coding agents.

the reason i care: safe, parseable tool access beats browser chaos.

useful details:

- \--json and --plain outputs
- human hints/progress on stderr
- multiple accounts and auth styles
- runtime allowlists/denylists
- safety-profile binaries
- dry-run and audit-friendly commands
- typed mcp server
- read-only mcp behavior by default

the goal is structured reach into the places where work lives: inbox, calendar, docs, sheets, drive folders, tasks, reports.

i’d put gogcli underneath a Hermes skill or mcp setup. the tool gives the agent the handle. the skill defines the behavior around the handle: when to search, what requires approval, what can be drafted, what can never be sent/deleted, and what audit trail gets left behind.

USE IT WHEN

- your agent needs google workspace access
- you care about auditability
- you want json/plain outputs
- you want read-only defaults and approval gates

> May 10
> 
> gogcli 0.16.0 is out Workspace admin grew up: - create/delete users, aliases, temp passwords - org units - Meet, Sites, YouTube, GA4/Search Console - Drive changes/activity A lot more Google API from one boring binary.

## 6\. hermeshub diagram maker

agents can explain systems forever and still leave you with mush.

a diagram forces the structure to show itself.

diagram maker generates render-ready mermaid diagrams from natural language. the important part is not “pretty diagram.” it is valid syntax and visible structure.

llm mermaid breaks in dumb ways: labels, brackets, arrows, subgraphs, reserved words, html tags, semicolons, oversized diagrams.

a diagram skill that knows those failure modes saves you from the loop where the agent fixes one broken label and breaks the next one.

i’d use this for agent routing maps, memory architecture, tool permission flows, multi-agent handoffs, repo architecture, onboarding docs, cron pipelines, product workflows, and debugging maps.

if the agent cannot diagram the workflow clearly, it probably does not understand the workflow yet.

USE IT WHEN

- the system has multiple steps
- there are handoffs
- memory/tool boundaries matter
- you need docs other people can inspect

> Apr 14
> 
> This skill is now built in to Hermes! Use /architecture-diagram \<prompt> after updating hermes, and you're good to go! Thanks to the author of the skill making it MIT we were able to port it over directly into Hermes Agent as a built in skill!

## 7\. hermeshub skill factory

this is the meta one.

skill factory turns repeated work into new skills.

a serious Hermes setup should not treat every hard session as a one-off. if the agent had to recover from the same failure, combine the same tools, follow the same 3+ step process, or obey the same correction, that should become procedural memory.

make it a skill the next run can use, instead of another note you forget.

it watches for repeated actions, recurring fixes, tool combinations, domain workflows, frustration hints, “we keep doing this” moments, and complex tasks that should become repeatable.

then it can propose or generate a skill.md with triggers, steps, examples, pitfalls, and sometimes a plugin/slash-command interface.

that is the compounding loop i care about: the agent gets better because the workflow gets encoded.

the restraint matters too. it should ignore one-offs, trivial single steps, workflows already covered by another skill, and stuff too context-specific to reuse.

USE IT WHEN

- you keep repeating the same workflow
- the agent made a mistake you want prevented later
- a tool sequence worked
- a project developed a reusable operating pattern
- session wrap-up reveals a skill candidate

> Jun 17
> 
> THESE 5 SKILLS TURN HERMES AGENT INTO A SELF-RUNNING POWERHOUSE - ON NOUS RESEARCH’S #1 AGENT ON OPENROUTER. Hermes already writes its own skills and remembers across sessions. These 5 from the community ecosystem push it further - drop them in ~/.hermes/skills/ and go.

## how i’d think about the stack

these 7 are useful because they cover different failure modes.

![Image](https://pbs.twimg.com/media/HLLf4MjXgAAr7QK?format=jpg&name=large)

the mental model is simple:

> **give the agent working habits.**

a serious Hermes agent needs more than a big prompt and a pile of tools.

it needs rules for how to start, what to remember, what authority it has, how to touch external systems, how to make work visible, and how to turn repeated work into better future behavior.

i would not install every random skill just because it exists.

i’d watch where the agent keeps failing and add skills there.

![Image](https://pbs.twimg.com/media/HLLgCj7WgAALGvr?format=jpg&name=large)

that’s the whole game.

stop explaining the same operating procedure every session.

turn it into the agent’s environment.