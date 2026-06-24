---
title: "Hermes Agent Docs: Architecture / Internals"
type: source
source: "Hermes Agent official docs — developer-guide/architecture"
created: 2026-06-10
ingested: 2026-06-10
tags: [ai-agents]
---

# Hermes Agent Docs: Architecture / Internals

## Tese central

Top-level map of Hermes internals. **Entry points** — CLI (`cli.py`), Gateway (`gateway/run.py`), ACP adapter (IDE integration), Batch Runner, API Server, and direct Python library usage — all converge on a single **`AIAgent`** class in `run_agent.py`, which handles prompt building, provider resolution, tool dispatch, compression/caching, session storage, and tool backends (terminal, browser, web, MCP, file, vision).

## Argumentos principais

**Directory structure highlights:**
- `run_agent.py` — `AIAgent`, the core synchronous conversation loop (large file)
- `cli.py` — `HermesCLI`, interactive terminal UI
- `model_tools.py` — tool discovery, schema collection, dispatch
- `hermes_state.py` — SQLite session/state DB with FTS5
- `agent/` — `prompt_builder.py` (system prompt assembly), `context_engine.py` (pluggable ABC), `context_compressor.py` (default lossy summarization engine), `prompt_caching.py` (Anthropic cache breakpoints), `auxiliary_client.py` (side-task LLM for vision/summarization), `memory_manager.py`/`memory_provider.py`
- `hermes_cli/` — `main.py` (all `hermes` subcommands), `config.py` (`DEFAULT_CONFIG`), `commands.py` (`COMMAND_REGISTRY`), `auth.py` (`PROVIDER_REGISTRY`), `runtime_provider.py`, `plugins.py` (`PluginManager`)
- `tools/` — `registry.py` (central registry), `approval.py` (dangerous command detection), `terminal_tool.py`, `mcp_tool.py`, `delegate_tool.py` (subagent delegation), `environments/` (6 terminal backends: local, docker, ssh, modal, daytona, singularity)
- `gateway/` — `run.py` (`GatewayRunner`), `session.py` (`SessionStore`), `pairing.py`, `hooks.py`, `platforms/` (20 adapters: telegram, discord, slack, whatsapp, signal, matrix, mattermost, email, sms, dingtalk, feishu, wecom×2, weixin, bluebubbles, qqbot, homeassistant, webhook, api_server, yuanbao)
- `tests/` — ~25,000 tests across ~1,250 files

**Data flows:**
- *CLI*: input → `HermesCLI.process_input()` → `AIAgent.run_conversation()` → `prompt_builder.build_system_prompt()` → `runtime_provider.resolve_runtime_provider()` → API call (one of `chat_completions`/`codex_responses`/`anthropic_messages`) → tool calls loop via `model_tools.handle_function_call()` → response → SessionDB.
- *Gateway*: platform event → `Adapter.on_message()` → `GatewayRunner._handle_message()` → authorize user → resolve session key → fresh `AIAgent` with session history → `run_conversation()` → deliver via adapter.
- *Cron*: scheduler tick → load due jobs from `jobs.json` → fresh `AIAgent` (no history) → inject attached skills as context → run job prompt → deliver → update job state/`next_run`.

**Major subsystems** (each links to a deeper doc): Agent Loop (orchestration, retries, fallback, 3 API modes), Prompt System (`stable → context → volatile` tiering, prompt caching, context compression), Provider Resolution (maps `(provider, model)` → `(api_mode, api_key, base_url)` for 18+ providers, OAuth, credential pools), Tool System (`tools/registry.py`, 70+ tools / ~28 toolsets, self-registration at import time), Session Persistence (SQLite + FTS5, lineage tracking across compressions, per-platform isolation, atomic writes), Messaging Gateway (20 adapters, allowlists+pairing, hooks, cron ticking), Plugin System (3 discovery sources: `~/.hermes/plugins/`, `.hermes/plugins/`, pip entry points; memory providers and context engines are single-select), Cron (first-class agent tasks, JSON storage, multi-format schedules), ACP Integration (stdio/JSON-RPC for VS Code/Zed/JetBrains), Trajectories (ShareGPT-format export for training data).

**Design principles:** prompt stability (no mid-conversation system prompt mutation except explicit `/model`), observable execution (every tool call visible via callbacks/spinner/chat messages), interruptible (cancel mid-flight), platform-agnostic core (one `AIAgent` for CLI/gateway/ACP/batch/API), loose coupling (registry patterns + `check_fn` gating for optional subsystems), profile isolation (each `hermes -p <name>` gets its own `HERMES_HOME`, config, memory, sessions, gateway PID — multiple profiles run concurrently).

**File dependency chain**: `tools/registry.py` (no deps) ← `tools/*.py` (each self-registers at import) ← `model_tools.py` (triggers discovery) ← `run_agent.py`/`cli.py`/`batch_runner.py`/`environments/`. Tool registration happens entirely at import time before any agent instance exists.

## Implicações para o vault

This complements the existing [[03-RESOURCES/concepts/agent-systems/hermes-agent-architecture]] concept page and the masterclass-derived architecture notes already on [[03-RESOURCES/entities/hermes]] (6 backends, 90-turn hard cap, skills progressive disclosure).

## Links

- [[03-RESOURCES/concepts/agent-systems/hermes-agent-architecture]]
- [[03-RESOURCES/entities/hermes]]
