---
title: Introduction to Claude Cowork
type: source
source_file: .raw/articles/Introduction to Claude Cowork.md
author: Anthropic
ingested: 2026-05-09
tags: [claude-cowork, introduction, anthropic, agents, workflows, getting-started]
---

# Introduction to Claude Cowork

Official introductory course from Anthropic covering the Claude Cowork platform — what it is, how to set it up, and how to use it for knowledge work delegation.

## What is Cowork

Cowork is an agentic task execution layer built on the same architecture as [[03-RESOURCES/entities/Claude-Cowork|Claude Code]], available in the Claude Desktop app. The key shift: from conversation (ask → get text back) to **delegation** (describe outcome → Claude plans, executes, delivers a finished file to your drive).

Three primitives that enable this:
- **Plan** — Claude shows its approach before starting; you review, adjust, approve.
- **Execute** — work runs in an isolated environment on your machine; file creation, long-running tasks, you can step away.
- **Connect** — Cowork reaches email, shared drives, and tools you are already signed into; context flows in without copy-paste.

## When to use Cowork vs Chat

| Signal | Cowork | Chat |
|--------|--------|------|
| Output needed | Finished file on drive | Answer or draft |
| Material source | Files + connected tools | Fits in single paste |
| Steps | Multi-step, many items | Turn-by-turn iteration |
| Scale | Too large for one conversation | Single context window |

## Key Components

### Connectors
Link Cowork to services (Slack, Google Drive, Gmail, Calendar). Set up once; reference naturally in prompts. Claude can also act in connected tools (draft email, save to Drive).

### Claude in Chrome
Reach pages without a connector (internal dashboards, vendor portals). Install from Customize area; grant per-site permissions.

### Plugins
Domain expertise bundles for a specific role. Each plugin contains:
- **Skills** — markdown files teaching Claude one workflow; invokable with `/` or triggered automatically
- **Connectors** — links to role-specific systems (CRM, docs, messaging)
- **Subagents** — parallel mini-Claudes for independent sub-tasks

Plugin structure: plain folder of markdown + JSON, no build step. Everything is editable. See [[03-RESOURCES/concepts/claude-cowork-plugins]] for full detail.

### Scheduled Tasks
Any Cowork task can run on a recurring cadence (`/schedule`). Composed naturally with skills: a skill encodes *what* to do; a scheduled task encodes *when*.

### Subagents
When a task has independent pieces, Cowork spins up parallel workstreams, each with its own fresh context. Results synthesize into one output.

## Setup Overview

1. Open Claude Desktop → mode selector → **Cowork**
2. Click **Work in a folder** — select a directory; Claude reads all files inside and saves results there
3. Connect tools in the **Customize** area (toggle connectors)
4. (Optional) Install Claude in Chrome for web pages behind login
5. Create a **Project** to wrap a folder with persistent Instructions and memory across sessions

### Project Instructions (persistent context)
The Instructions panel is read on every task from that project. Useful content: who's involved (names + roles), where things live (paths), output preferences, project-specific rules. Global instructions (Settings → Cowork → Global Instructions) apply to every task.

## The Task Loop

1. **Describe** what you want back (input + transformation + output)
2. **Answer clarifying questions** Claude asks
3. **Step away or steer** — progress panel shows each step; type in chat to redirect mid-run
4. **Open the finished file** — treat as a capable colleague's first draft, yours to refine

## Prompt Pattern for File Tasks

`[Input] → [Transformation] → [Output]`

"Sort my Downloads folder by file type into dated subfolders" hits all three; "Clean up my files" hits none.

## Research & Analysis at Scale

Cowork fits better than chat when the work has:
- **Volume** — too many/large files to hold in one chat
- **Parallelism** — same analysis across N items simultaneously
- **In-place computation** — run code on files in place, write results back

Framing that produces signal: ask the specific question you'd answer yourself if you had time, not "summarize everything".

## Permissions and Safety

- Isolated execution environment (separate from OS)
- Controlled folder access (you grant, Claude sees)
- Network policies respected
- Deletion gated — requires explicit approval
- Conversation history stored locally on machine

## Model Tiers

| Model | Use case |
|-------|----------|
| Opus | Most complex multi-step work, highest allocation cost |
| Sonnet | Sensible default for everyday tasks |
| Haiku | Quick, lightweight tasks |

## Connections

- Entity: [[03-RESOURCES/entities/Claude-Cowork]]
- Entity: [[03-RESOURCES/entities/anthropic]]
- Concept: [[03-RESOURCES/concepts/claude-cowork-plugins]]
- Concept: [[03-RESOURCES/concepts/cowork-scheduled-automations]]
- Concept: [[03-RESOURCES/concepts/cowork-slash-commands]]
- Related sources: [[03-RESOURCES/sources/cowork-setup-guide-coreyganim]] · [[03-RESOURCES/sources/cowork-plugin-guide-coreyganim]] · [[03-RESOURCES/sources/clipping-claude-cowork-ultimate-starter-pack-2026]]
