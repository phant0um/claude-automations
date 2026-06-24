---
title: "Hermes Agent Docs: FAQ & Troubleshooting"
type: source
source: "Hermes Agent official docs — reference/faq"
created: 2026-06-10
ingested: 2026-06-10
tags: [ai-agents]
---

# Hermes Agent Docs: FAQ & Troubleshooting

## Tese central

Official FAQ covering supported providers, platform support, privacy/cost, memory-vs-skills framing, Python library usage, common troubleshooting scenarios, profiles, and selected workflow patterns.

## Argumentos principais

**Providers** — Hermes works with any OpenAI-compatible API: OpenRouter (hundreds of models, one key), Nous Portal (300+ models + web/image/TTS/browser via OAuth, recommended for newcomers), OpenAI (GPT-5.4, GPT-5-codex, GPT-4.1, GPT-4o), Anthropic (direct API, OAuth via `hermes auth add anthropic`, or OpenRouter/proxy), Google Gemini (direct, `google-gemini-cli` OAuth, or proxy), z.ai/ZhipuAI (GLM), Kimi/Moonshot, MiniMax (global + China endpoints), and local models via Ollama/vLLM/llama.cpp/SGLang or any OpenAI-compatible server. Configure via `hermes model` or `~/.hermes/.env`.

**Platform support** — native Windows via PowerShell installer (`iex (irm https://hermes-agent.nousresearch.com/install.ps1)`), no WSL required (provisions PortableGit for the terminal backend); WSL2 remains fully supported via the standard `install.sh`. For WSL2 users wanting to control native Windows Chrome: prefer an MCP bridge (`chrome-devtools-mcp` via `cmd.exe`/`powershell.exe`) over `/browser connect` — more reliable than crossing the WSL2/Windows boundary directly. Android/Termux has a tested install path via the same `install.sh`, but the full `.[all]` extra is unavailable (the `voice` extra's `ctranslate2` dependency has no Android wheels) — use `.[termux]` instead.

**Privacy/cost** — no telemetry; API calls go only to the configured LLM provider; conversations/memory/skills stored locally in `~/.hermes/`. Hermes itself is free/MIT; you pay only for LLM usage (local models = free). Local/offline setup: `hermes model` → "Custom endpoint" → enter base URL (e.g., `http://localhost:11434/v1`), API key (`ollama`), model name, and **context length** (Hermes minimum 64000 — must match the server's actual window; Ollama's `/api/show` reports max, not your configured `num_ctx`). Local endpoints get auto-relaxed streaming timeouts (120s → 1800s read timeout, stale-stream detection disabled); override via `HERMES_STREAM_READ_TIMEOUT=1800` if needed.

**Memory vs skills** (FAQ framing) — memory = facts retrieved by relevance; skills = procedures recalled by task similarity; both persist across sessions.

**Python library usage** — `from run_agent import AIAgent; agent = AIAgent(model="anthropic/claude-opus-4.7"); agent.chat("...")`.

**Troubleshooting highlights:**
- *`hermes: command not found`* — reload shell profile (`source ~/.bashrc`/`~/.zshrc`) or verify `~/.local/bin/hermes` is on PATH.
- *Python version* — requires 3.11+; installer normally handles this.
- *Terminal tools (`node`, `nvm`, `pyenv`, `cargo`) not found* — Hermes snapshots env via `bash -l`, which doesn't source `~/.bashrc`. Auto-sources `~/.bashrc` by default; for zsh-managed PATH or custom init files, add to `terminal.shell_init_files` in `config.yaml` (note: setting this list disables the default `~/.bashrc` auto-source unless explicitly included). Disable entirely with `terminal.auto_source_bashrc: false`.
- *Provider/model issues* — `/model` only shows **already-configured** providers; add new ones via `hermes model` from the terminal (exit session first), then start a new session. API key issues: `hermes config show`, `hermes model`, or `hermes config set OPENROUTER_API_KEY ...`. Context length exceeded: `/compress`, fresh session, larger-context model, or set `model.context_length` explicitly in `config.yaml` (per-model override under `custom_providers` for custom endpoints).
- *Terminal* — dangerous-command blocks are working as intended (approve with `y` or ask for a safer alternative); `sudo` doesn't work via messaging gateway (no interactive TTY) — configure passwordless sudo for specific commands or use `hermes chat`; Docker backend issues usually mean the daemon isn't running or user isn't in the `docker` group (`sudo usermod -aG docker $USER && newgrp docker`).
- *Messaging* — check `hermes gateway status`/`start` and `~/.hermes/logs/gateway.log`; allowlist modes are **Allowlist** (specific IDs), **DM pairing** (first DM claims access), **Open** (not recommended). Gateway won't start → `pip install "hermes-agent[messaging]"`, check port conflicts (`lsof -i :8080`). WSL gateway instability → run `hermes gateway run` in foreground/tmux/nohup rather than relying on systemd (WSL2 systemd support is unreliable). macOS gateway can't find Node/ffmpeg → launchd's minimal PATH; re-run `hermes gateway install` to re-snapshot PATH after installing new tools.
- *Performance* — slow responses: try a smaller model, reduce active toolsets (`hermes chat -t "terminal"`), check network latency / GPU VRAM for local models. High token usage / long sessions: `/compress`, `/usage`, or start fresh with `hermes chat --continue` to resume later.
- *MCP* — server not connecting: `uv pip install -e ".[mcp]"`, verify `node`/`npx`, test server manually. Tools not appearing: check `tools.include`/`exclude`/`resources`/`prompts` config and run `/reload-mcp`. Timeouts: increase server timeout, check the MCP server's own logs (not just Hermes's).

**Profiles FAQ** — profiles are a managed layer over `HERMES_HOME` (auto directory structure, shell aliases like `hermes-work`, `~/.hermes/active_profile` tracking, cross-profile skill sync, tab completion). Two profiles **cannot** share a messaging bot token (each platform requires exclusive token access — create separate bots per profile). Profiles do **not** share memory/sessions/skills (fully isolated; clone with `hermes profile create newname --clone-all`). `hermes update` runs once globally, then syncs skills to all profiles. No hard limit on profile count — practical limit is disk + concurrent gateway processes; idle profiles use no resources.

**Workflows & patterns** (selected):
- *Multi-model delegation* — set `delegation.model`/`delegation.provider` in `config.yaml` so `delegate_task` subagents run on a different model (e.g., Gemini Flash for content while main session stays on GPT-5.4); or switch ad hoc with `/model`.
- *Multi-agent on one WhatsApp number* — **not supported**: each Hermes profile needs its own WhatsApp session (Baileys = one session per number). Workarounds: single profile with `/personality`/per-chat `AGENTS.md`, cron jobs for specialized tasks, separate numbers, or switch to Telegram/Discord (native per-chat/per-channel session keying).
- *Hiding logs/reasoning in Telegram* — `display.tool_progress: "off"|"new"|"all"|"verbose"` in `config.yaml` (off = final response only); `/verbose` toggles per-session if `display.tool_progress_command: true`.
- *Telegram skill limit (100 commands)* — `hermes skills config` → `skills.platform_disabled.telegram: [skill-a, skill-b]`, then restart gateway to rebuild the command menu. Skill descriptions truncate to 40 chars in the Telegram menu — payload size, not just count, can hide skills.
- *Shared thread sessions* — Hermes keys sessions per-user by design (privacy/isolation). For shared multi-user context: use Slack (thread-keyed sessions), a single "operator" relaying in group chat, or a dedicated Discord channel (channel-keyed sessions).
- *Machine migration* — `hermes backup` zips all of `~/.hermes/` (config, keys, memories, skills, sessions, profiles) → `hermes import <zip>` on the new machine, then `hermes setup` to verify. Single-profile move: `hermes profile export <name> ./backup.tar.gz` → `hermes profile import ./backup.tar.gz <name>` (credentials excluded from profile exports, included in full backups). Manual fallback: `rsync -av --exclude='hermes-agent' ~/.hermes/ newmachine:~/.hermes/`.
- *Error 400 on first run* — usually a model-name/provider mismatch; check `hermes config show`, re-run `hermes model`, or test with a known-good model (`hermes chat -q "hello" --model anthropic/claude-opus-4.7`). On OpenRouter, 400 often means the model needs a paid plan or has a typo'd ID.

## Links

- [[03-RESOURCES/entities/hermes]]
