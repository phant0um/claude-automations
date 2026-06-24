---
title: "Hermes Agent Docs: Tips & Best Practices"
type: source
source: "Hermes Agent official docs — guides/tips"
created: 2026-06-10
ingested: 2026-06-10
tags: [ai-agents]
---

# Hermes Agent Docs: Tips & Best Practices

## Tese central

A collection of usage tips spanning prompting, CLI shortcuts, context files, memory vs. skills, performance/cost, messaging, and security best practices for day-to-day Hermes operation.

## Argumentos principais

**Getting better results** — be specific (file paths, line numbers, exact errors, not "fix the code"); front-load context (paste tracebacks directly, the agent parses them); use `AGENTS.md` for recurring instructions ("use tabs not spaces", "tests use pytest") so they're injected automatically every session; let the agent use its tools rather than hand-holding each step; check `/skills` before writing a long explanatory prompt — invoke existing skills directly (`/axolotl`, `/github-pr-workflow`).

**CLI power-user shortcuts**: Alt+Enter / Ctrl+J / Shift+Enter for multi-line input (Shift+Enter needs Kitty keyboard protocol support — works by default in Kitty/foot/WezTerm/Ghostty, needs enabling in iTerm2/Alacritty/VS Code terminal); paste detection auto-buffers multi-line pastes as one message; **Ctrl+C once** interrupts mid-response (then redirect with new input), double-press within 2s force-exits; `hermes -c` resumes last session, `hermes -r "title"` resumes by name; **Ctrl+V** pastes clipboard images directly for vision analysis; `/` + Tab autocompletes all commands and skills; `/verbose` cycles tool-output display **off → new → all → verbose**.

**Context files** — `AGENTS.md` in project root = "project's brain" (architecture decisions, conventions, instructions), auto-injected every session. `SOUL.md` (`~/.hermes/SOUL.md` or `$HERMES_HOME/SOUL.md`) = durable instance-wide personality, auto-seeded with a starter on first run. `.cursorrules`/`.cursor/rules/*.mdc` are read natively — no duplication needed. Discovery: top-level `AGENTS.md` loads into the system prompt at session start; subdirectory `AGENTS.md` files are discovered lazily during tool calls (`subdirectory_hints.py`) and injected into tool results, not the system prompt. Tip: keep context files concise — every char counts against token budget on every message.

**Memory vs Skills** — memory = facts (environment, preferences, project locations); skills = procedures (multi-step workflows, recipes). If a 5+ step task will recur, ask the agent to "save what you just did as a skill called `deploy-staging`" → invoke later via `/deploy-staging`. Memory is bounded (~2,200 chars MEMORY.md, ~1,375 chars USER.md) and self-consolidates; you can prompt cleanup ("clean up your memory", "replace the old Python 3.9 note"). **Important caveat**: memory writes to disk immediately but is a frozen snapshot for the running session — changes don't appear in the system prompt (and don't invalidate the prompt cache) until the next session starts.

**Performance & cost** — keep the system prompt stable (same context files/memory, don't switch models mid-session) to preserve provider-side prompt-cache hits; run `/compress` proactively when responses slow/truncate (check with `/usage`); use `delegate_task` for parallel research — subagents run independently and only final summaries return to the main context; for batch file ops, ask the agent to write+run one script (e.g., rename all `.jpeg`→`.jpg`) rather than per-file terminal commands; use `/model` to switch between frontier models (Claude Sonnet/Opus, GPT-4o) for architecture/reasoning vs faster models for formatting/boilerplate; `/insights` gives a 30-day usage-pattern view.

**Messaging tips** — `/sethome` designates the channel that receives cron results and proactive messages (without it, the agent has nowhere to push proactive output); `/title <name>` names sessions for `hermes sessions list` / `hermes -r "name"` lookup; DM pairing (`hermes pairing approve telegram <code>`) avoids manual user-ID collection for team access; `/verbose` controls tool-activity visibility — "new" recommended for messaging, "all" for CLI live-viewing; sessions on messaging platforms auto-reset after 24h idle or daily at 4 AM (configurable per-platform).

**Security tips** — use `docker`/`daytona` backend (`TERMINAL_BACKEND=docker`) for untrusted repos/code, since destructive commands inside a container can't reach the host; on Windows, open files with explicit `encoding="utf-8"` to avoid `UnicodeEncodeError` from `cp125x` default encodings (and switch PowerShell sessions to UTF-8 via `$OutputEncoding`); when approving dangerous commands, prefer **session** over **always** until confident — "always" permanently allowlists the pattern; never disable command approval in production; never set `GATEWAY_ALLOW_ALL_USERS=true` on a bot with terminal access — use platform allowlists or DM pairing instead.

## Key insights

Quick model-pick shortcut noted in the doc: `hermes setup --portal` gives access to 300+ models (Claude, GPT-5, Gemini) under one Nous Portal subscription.

## Links

- [[03-RESOURCES/entities/hermes]]
