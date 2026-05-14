---
title: "60 Claude Cowork Commands You Didn't Know Existed"
type: source-summary
source_type: social-media-thread
author: "@heynavtoor"
published: 2026-04-30
created: 2026-05-01
tags: [claude-cowork, commands, automation, workflows, productivity]
---

# 60 Claude Cowork Commands You Didn't Know Existed

**Author:** @heynavtoor
**Signal:** Exhaustive Cowork command reference — slash commands, custom skills, file system ops, connector workflows, scheduled automations.

## Command Categories

### Core Slash Commands (15)
- `/plan` — enter plan mode; Claude reasons before executing
- `/schedule <task> at <time>` — cron-style automation
- `/loop <n> times` — repeat task with variation
- `/if <condition> then <action>` — conditional execution
- `/parallel <task1> | <task2>` — concurrent execution
- `/memory set <key> <value>` — persistent storage
- `/memory get <key>` — retrieve stored value
- `/memory list` — show all stored keys
- `/compact` — compress context, keep summaries
- `/clear` — wipe context window
- `/skills` — list loaded skills
- `/skill load <name>` — activate a skill
- `/export <format>` — export conversation output
- `/share` — generate shareable link
- `/status` — show active connectors + usage

### File System Commands (10)
- `/read <path>` — read local file into context
- `/write <content> to <path>` — write output to file
- `/append <content> to <path>` — append to existing
- `/move <source> to <dest>` — move/rename files
- `/delete <path>` — delete file (with confirmation)
- `/list <dir>` — list directory contents
- `/search <pattern> in <dir>` — grep-style search
- `/diff <file1> <file2>` — compare files
- `/sync <local> with <remote>` — sync folders
- `/watch <path> then <action>` — file watcher + trigger

### Connector Workflows (12)
- `/gmail search <query>` — search email
- `/gmail draft <to> <subject>` — create draft
- `/calendar today` — today's schedule
- `/calendar add <event>` — create event
- `/drive find <query>` — search Drive
- `/slack read <channel>` — read messages
- `/slack post <channel> <msg>` — post message
- `/notion read <page>` — read Notion page
- `/notion create <title>` — create page
- `/github issues <repo>` — list issues
- `/github pr <repo>` — list PRs
- `/sheets read <id> <range>` — read spreadsheet data

### Custom Skills (8)
- `/skill create <name>` — scaffold new skill file
- `/skill edit <name>` — open skill in editor
- `/skill test <name>` — test skill with sample
- `/skill publish` — push to team library
- `/skill import <url>` — import from URL
- `/skill chain <a> | <b>` — pipe skill output to next
- `/skill loop <name> for each <list>` — batch execution
- `/skill if-fail <fallback>` — error handling

### Scheduled Automations (8)
- `/daily at 9am <task>` — daily trigger
- `/weekly on monday <task>` — weekly trigger
- `/on email from <addr> do <task>` — email trigger
- `/on slack msg in <channel> do <task>` — Slack trigger
- `/on file change <path> do <task>` — file change trigger
- `/on calendar event <name> do <task>` — calendar trigger
- `/on form submit <id> do <task>` — form trigger
- `/cancel <automation-id>` — stop automation

### Pro Patterns (7)
- Templates with `{{variable}}` substitution
- Multi-step pipelines: `step1 | step2 | step3`
- Conditional branching: `if success then X else Y`
- Loop with accumulator: collect results across iterations
- Error recovery: automatic retry with backoff
- Context preservation: `/memory` across sessions
- Parallel connectors: query multiple sources simultaneously

## Key Insight
Cowork transforms Claude from chat to **operating system**. Commands compose — `/schedule` + `/parallel` + `/slack post` = autonomous daily briefing with no human touch.

## Connections
- [[03-RESOURCES/entities/Claude-Cowork]] — product entity
- [[03-RESOURCES/concepts/claude-cowork-plugins]] — plugin system
- [[03-RESOURCES/sources/30-claude-code-subagents-heynavtoor]] — same author, agent-side
- [[03-RESOURCES/concepts/claude-folder-anatomy]] — `.claude/` structure
