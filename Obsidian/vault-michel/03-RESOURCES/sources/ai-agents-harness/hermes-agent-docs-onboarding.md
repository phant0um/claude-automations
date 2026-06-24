---
title: "Hermes Agent — Official Docs: Onboarding"
type: source
created: 2026-06-10
tags: [hermes, ai-agents, official-docs, onboarding]
---

# Hermes Agent — Official Docs: Onboarding

Five official documentation pages from `hermes-agent.nousresearch.com/docs/`, covering installation, quickstart, configuration, learning path, and the docs landing page. These are **canonical reference docs** from Nous Research, complementing the 52 community-content sources already in this folder about [[03-RESOURCES/entities/hermes]] / [[03-RESOURCES/entities/Hermes-Agent]]. Consolidated into one page per Karpathy "1 page > many fragments" — grouped under the "onboarding" theme of the 2026-06-10 docs ingest (4 thematic groups total).

---

## 1. Installation

Source: `docs/getting-started/installation`

Get Hermes running in under two minutes. Two install paths:

- **Hermes Desktop installer** (macOS/Windows, recommended) — download from `hermes-agent.nousresearch.com/desktop`.
- **CLI-only install:**
  - Linux/macOS/WSL2/Android (Termux): `curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash`
  - Windows (native, PowerShell): `iex (irm https://hermes-agent.nousresearch.com/install.ps1)`
  - To add Hermes Desktop after a CLI-only install: `hermes desktop`

**What the installer does automatically:** installs all dependencies (Python 3.11 via `uv`, Node.js v22, ripgrep, ffmpeg), clones the repo, sets up a virtual environment, configures the global `hermes` command, and walks through LLM provider setup. The only hard prerequisite on non-Windows platforms is **Git**.

**Install layout** depends on user vs root:

| Installer | Code lives at | `hermes` binary | Data directory |
|---|---|---|---|
| pip install | Python site-packages | `~/.local/bin/hermes` (console_scripts) | `~/.hermes/` |
| Per-user (git installer) | `~/.hermes/hermes-agent/` | `~/.local/bin/hermes` (symlink) | `~/.hermes/` |
| Root-mode (`sudo curl \| sudo bash`) | `/usr/local/lib/hermes-agent/` | `/usr/local/bin/hermes` | `/root/.hermes/` (or `$HERMES_HOME`) |

Root-mode follows the FHS layout (`/usr/local/lib/...`, `/usr/local/bin/hermes`) for shared-machine deployments; per-user config (auth, skills, sessions) stays under each user's `~/.hermes/` or explicit `HERMES_HOME`.

**After install:** `source ~/.bashrc` (or `.zshrc`), then `hermes` to start chatting. Reconfiguration commands: `hermes model`, `hermes tools`, `hermes gateway setup`, `hermes config set`, `hermes setup` (full wizard).

**Fastest path — Nous Portal:** `hermes setup --portal` — one OAuth login covers 300+ models plus the Tool Gateway (web search, image gen, TTS, cloud browser) in one command.

**Nix users:** dedicated setup path with a Nix flake, declarative NixOS module, and optional container mode (separate "Nix & NixOS Setup" guide).

**Manual/developer install:** clone the repo for contributing or running from a specific branch — see "Development Setup" in the Contributing guide.

**Non-sudo / system-service-user installs:** the only step on the install path that genuinely needs root is Playwright's `--with-deps` (installs Chromium's shared libs via `apt`). Recommended split for Debian/Ubuntu:
1. Admin (with sudo, one time): `sudo npx playwright install-deps chromium`
2. Service user: run the regular installer — it detects missing sudo, skips `--with-deps`, installs Chromium into the user's local Playwright cache. To skip browser automation entirely: `curl ... | bash -s -- --skip-browser`
3. Ensure `~/.local/bin` is on the service user's PATH, or symlink `hermes` system-wide.
4. Verify with `hermes doctor`. A `ModuleNotFoundError: No module named 'dotenv'` means you're invoking the repo's raw `hermes` script with system Python instead of the venv launcher (`venv/bin/hermes`).

The same sudo-detection pattern applies on Arch, Fedora/RHEL, and openSUSE (the installer prints the right `dnf`/`zypper`/`pacman` commands).

**Troubleshooting table:**

| Problem | Solution |
|---|---|
| `hermes: command not found` | Reload shell or check PATH |
| `API key not set` | `hermes model`, or `hermes config set OPENROUTER_API_KEY your_key` |
| Missing config after update | `hermes config check` then `hermes config migrate` |

`hermes doctor` diagnoses most issues, including auto-detecting the install method (pip, git installer, Homebrew, NixOS) so `hermes update` prints the correct update command for that path.

---

## 2. Quickstart

Source: `docs/getting-started/quickstart`

Goal: a working Hermes setup that survives real use — install, choose a provider, verify chat works, know the recovery path.

**Fastest-path table** (pick by goal):

| Goal | Do this first | Then |
|---|---|---|
| Just want it working | `hermes setup` | Run a real chat |
| Already know provider | `hermes model` | Save config, chat |
| Bot / always-on | `hermes gateway setup` after CLI works | Connect Telegram/Discord/Slack/etc |
| Local/self-hosted model | `hermes model` → custom endpoint | Verify endpoint, model name, context length |
| Multi-provider fallback | `hermes model` first | Add routing/fallback only after base chat works |

**Rule of thumb:** don't add gateway/cron/skills/voice/routing until a plain chat works.

**Step 1 — Install:** same commands as above; Termux users should follow the dedicated Termux guide.

**Step 2 — Choose a provider:** `hermes model` walks through it interactively. `hermes setup --portal` is the easiest path (Nous Portal — one OAuth, 300+ models + Tool Gateway). The doc lists ~25 supported providers with setup method (OAuth vs API key env var), including Anthropic, OpenAI Codex, OpenRouter, Z.AI, Kimi/Moonshot, Arcee AI, GMI Cloud, MiniMax (OAuth and key-based, intl + China), Alibaba/Qwen (DashScope, also Qwen OAuth), Hugging Face, AWS Bedrock, Azure Foundry, Google AI Studio + Gemini OAuth, xAI (+ Grok OAuth for SuperGrok/Premium+), NovitaAI, StepFun, Xiaomi MiMo, Tencent TokenHub, Ollama Cloud, LM Studio, Kilo Code, OpenCode Zen/Go, DeepSeek, NVIDIA NIM, GitHub Copilot (+ ACP), and Custom Endpoint (any OpenAI-compatible API).

> **Minimum context: 64K tokens.** Hermes rejects models with smaller context windows at startup — multi-step tool-calling needs that working memory. For local models: `--ctx-size 65536` (llama.cpp) or `-c 65536` (Ollama).

**Settings storage split:** secrets/tokens → `~/.hermes/.env`; non-secret settings → `~/.hermes/config.yaml`. `hermes config set` routes values to the correct file automatically, e.g.:
```bash
hermes config set model anthropic/claude-opus-4.6
hermes config set terminal.backend docker
hermes config set OPENROUTER_API_KEY sk-or-...
```

**Step 3 — First chat:** `hermes` (classic CLI) or `hermes --tui` (modern TUI with modal overlays, mouse selection, non-blocking input — both share sessions/slash-commands/config). Success = banner shows model/provider, replies without error, can use a tool, conversation continues across turns.

**Step 4 — Verify sessions:** `hermes --continue` / `hermes -c` resumes the most recent session. If it fails, check you're in the same profile and that the session actually saved.

**Step 5 — Key features to try:**
- Terminal: agent runs shell commands and shows results.
- Slash commands (type `/` for autocomplete): `/help`, `/tools`, `/model`, `/personality pirate`, `/save`.
- Multi-line input: `Alt+Enter`, `Ctrl+J`, or `Shift+Enter` (Shift+Enter needs Kitty keyboard protocol support — works by default in Kitty/foot/WezTerm/Ghostty, needs enabling in iTerm2/Alacritty/VS Code terminal).
- Interrupt: type a new message + Enter, or `Ctrl+C`.

**Step 6 — Add the next layer (only after base chat works):**
- Bot/shared assistant: `hermes gateway setup` → Telegram, Discord, Slack, WhatsApp, Signal, Email, Home Assistant, Microsoft Teams.
- Automation: `hermes tools` (per-platform tool access), `hermes skills` (browse/install reusable workflows), cron (only after CLI/bot is stable).
- Sandboxed terminal: `hermes config set terminal.backend docker` or `... ssh`.
- Voice mode: `cd ~/.hermes/hermes-agent && uv pip install -e ".[voice]"` (includes faster-whisper for free local STT), then `/voice on`, `Ctrl+B` to record.
- **Skills:** on-demand instruction docs (`SKILL.md` files) teaching Hermes specific procedures. Agent reads short descriptions for free, loads full content only when relevant — doesn't bloat every request. Bundled skills live in `~/.hermes/skills/`. Hub commands: `hermes skills browse`, `hermes skills search <keyword>`, `hermes skills install <source/path>` (runs a security scan first). Every installed skill becomes a slash command (e.g. `/k8s deploy the staging manifest`).
- **MCP servers:** add under `mcp_servers:` in `~/.hermes/config.yaml` (example shows GitHub MCP server with `npx -y @modelcontextprotocol/server-github`).
- **Editor integration (ACP):** ships with `[all]` extras — run `hermes acp`. If installed without `[all]`: `cd ~/.hermes/hermes-agent && uv pip install -e ".[acp]"`.

**Common failure modes table:**

| Symptom | Likely cause | Fix |
|---|---|---|
| Empty/broken replies | Provider auth or model wrong | `hermes model` again |
| Custom endpoint returns garbage | Wrong base URL/model name, not OpenAI-compatible | Verify endpoint in separate client |
| Gateway up but no messages received | Bot token/allowlist/setup incomplete | `hermes gateway setup`, `hermes gateway status` |
| `--continue` can't find session | Wrong profile or session not saved | `hermes sessions list` |
| Model unavailable / odd fallback | Routing/fallback too aggressive | Keep routing off until base provider stable |
| `hermes doctor` flags problems | Config missing/stale | Fix config, retest plain chat |

**Recovery toolkit (in order):** `hermes doctor` → `hermes model` → `hermes setup` → `hermes sessions list` → `hermes --continue` → `hermes gateway status`.

**Quick reference commands:** `hermes`, `hermes model`, `hermes tools`, `hermes setup`, `hermes doctor`, `hermes update`, `hermes gateway`, `hermes --continue`.

---

## 3. Configuration

Source: `docs/user-guide/configuration`

All settings live under `~/.hermes/`:
```
~/.hermes/
├── config.yaml     # model, terminal, TTS, compression, etc.
├── .env            # API keys and secrets
├── auth.json       # OAuth provider credentials (Nous Portal, etc.)
├── SOUL.md         # Primary agent identity (slot #1 in system prompt)
├── memories/       # MEMORY.md, USER.md
├── skills/         # Agent-created skills (via skill_manage tool)
├── cron/           # Scheduled jobs
├── sessions/       # Gateway sessions
└── logs/           # errors.log, gateway.log (secrets auto-redacted)
```

**Management commands:** `hermes config` (view), `hermes config edit`, `hermes config set KEY VAL`, `hermes config check` (find missing options after updates), `hermes config migrate` (interactively add missing options). `config set` auto-routes secrets to `.env`, everything else to `config.yaml`.

**Configuration precedence (highest first):** 1) CLI args (e.g. `hermes chat --model ...`) → 2) `config.yaml` → 3) `.env` (required for secrets) → 4) built-in defaults.

**Env var substitution:** `${VAR_NAME}` syntax works in `config.yaml` (e.g. `api_key: ${GOOGLE_API_KEY}`); multiple refs per value supported (`"${HOST}:${PORT}"`); undefined vars left verbatim; only `${VAR}` syntax supported, not bare `$VAR`.

**Provider timeouts:** `providers.<id>.request_timeout_seconds` (request timeout) and `providers.<id>.stale_timeout_seconds` (stale-call detector), each with model-specific overrides via `providers.<id>.models.<model>.*`. Legacy defaults if unset: `HERMES_API_TIMEOUT=1800s`, `HERMES_API_CALL_STALE_TIMEOUT=300s`, native Anthropic 900s. Not wired for AWS Bedrock (boto3 owns timeouts there).

**Update behavior** (`updates:` block): `pre_update_backup` (full HERMES_HOME zip before update), `backup_keep` (count), `non_interactive_local_changes: stash|discard`. Git installs auto-stash dirty/untracked files before pulling; interactive updates prompt to restore the stash, non-interactive updates follow the configured policy. `package-lock.json` diffs from npm churn are restored before the stash step — commit/stash intentional lockfile edits first.

**Terminal backends — six options:** `local | docker | ssh | modal | daytona | singularity`. Common keys: `terminal.cwd`, `terminal.timeout` (default 180s), `terminal.env_passthrough`. Cloud sandboxes (Modal/Daytona) support `container_persistent: true` (filesystem state preserved across recreation, not live processes).

- **Local** (default): no isolation, runs as your user.
- **Docker**: ONE persistent container shared across session/`/new`/`/reset`/subagents — `docker exec` into it for terminal/file/`execute_code`. Working dir, packages, `/workspace` files, and **background processes** all persist across calls and across Hermes process restarts (the next process attaches via labeled lookup `hermes-agent=1`, `hermes-task-id`, `hermes-profile`). Container is torn down only when: `docker_persist_across_processes: false`, the idle reaper fires (only in non-persist mode, default `lifetime_seconds: 300`), the orphan reaper sweeps `Exited` containers older than `2×lifetime_seconds` (default 600s, profile-scoped), or a direct `docker rm -f`/prune/Desktop restart. Security hardening: `--cap-drop ALL` (+ `DAC_OVERRIDE`/`CHOWN`/`FOWNER`), `--security-opt no-new-privileges`, `--pids-limit 256`, size-capped tmpfs. Key config: `docker_image`, `docker_mount_cwd_to_workspace`, `docker_run_as_host_user` (avoids root-owned files in bind mounts, but loses `apt install`/root-path writes), `docker_forward_env` (forward host/`​.env` secrets) vs `docker_env` (inject literal KV pairs), `docker_volumes` (`host:container[:ro]`), `docker_extra_args` (raw `docker run` flags like `--gpus=all`), `container_cpu/memory/disk`. Podman supported via `HERMES_DOCKER_BINARY=podman`. Parallel `delegate_task` subagents share this one container — concurrent `cd`/writes can collide; isolated sandboxes need `register_task_env_overrides()`.
- **SSH**: ControlMaster reuse (5min idle keepalive), persistent shell on by default (`persistent_shell: true`). Required env: `TERMINAL_SSH_HOST`, `TERMINAL_SSH_USER`. Optional: `TERMINAL_SSH_PORT` (22), `TERMINAL_SSH_KEY`, `TERMINAL_SSH_PERSISTENT`.
- **Modal**: isolated cloud VM per task; needs `MODAL_TOKEN_ID`+`MODAL_TOKEN_SECRET` or `~/.modal.toml`; snapshots tracked in `~/.hermes/modal_snapshots.json`.
- **Daytona**: needs `DAYTONA_API_KEY`; stop/resume persistence; sandbox names `hermes-{task_id}`; 10 GiB disk cap (requests above are clamped with a warning).
- **Singularity/Apptainer**: for HPC/shared machines without Docker; needs `apptainer`/`singularity` in PATH; `docker://...` images auto-converted to cached SIF; `--containall --no-home` isolation.

**Remote-to-host file sync (SSH/Modal/Daytona):** on session teardown, modified files sync back to `~/.hermes/cache/remote-syncs/<session-id>/` — covers the whole modified tree (additions/edits/deletions), capped by `terminal.file_sync_max_mb` (default 100MB), togglable via `file_sync_enabled`.

**Docker volume mounts:** `host_path:container_path[:options]`; useful for providing/receiving files; for gateway `MEDIA:` exports, mount a host-visible dir like `/home/user/.hermes/cache/documents:/output` and emit the **host path** in `MEDIA:`, never an in-container-only path.

**Persistent shell:** keeps a single long-lived bash alive across commands — preserves cwd, exported env vars, shell vars. Default `true` for SSH, `false` for local (override via `TERMINAL_LOCAL_PERSISTENT=true`). Commands needing `stdin_data`/sudo fall back to one-shot mode.

**Skill settings:** skills declare config under `skills.config.<skillname>.*` in `config.yaml`; `hermes config migrate` scans and prompts for unconfigured settings. `skills.guard_agent_created: true` (default `false`) scans agent-written skills for dangerous patterns before they land.

**Memory config:** `memory.memory_enabled`, `memory.user_profile_enabled`, `memory.memory_char_limit` (default 2200, ~800 tokens), `memory.user_char_limit` (default 1375, ~500 tokens).

**File read safety:** `file_read_max_chars` (default 100000 ≈ 25-35K tokens) caps a single `read_file` call; reads exceeding it error and ask for `offset`/`limit`. Raise for large-context models (e.g. 200000), lower for small-context local models (e.g. 30000). Reads are deduplicated automatically (resets on context compression).

**Tool output truncation** (`tool_output:`): `max_bytes` (default 50000 — terminal output cap, keeps first 40%/last 60% with `[OUTPUT TRUNCATED]`), `max_lines` (default 2000 — `read_file` pagination cap), `max_line_length` (default 2000 — per-line cap, appends `... [truncated]`).

**Global toolset disable:** `agent.disabled_toolsets: [memory, web, ...]` — applied after per-platform `platform_toolsets`, always wins.

**Git worktree isolation:** `worktree: true` (or per-session `-w` flag) creates an isolated worktree under `.worktrees/` with its own branch per session — supports parallel agents on the same repo. `.worktreeinclude` lists gitignored files (e.g. `.env`, `.venv/`, `node_modules/`) to copy into worktrees.

**Context compression** (`compression:` block): `enabled` (true), `threshold` (0.50 — % of context limit that triggers compression), `target_ratio` (0.20 — fraction of threshold preserved as recent tail), `protect_last_n` (20 — min recent messages kept), `protect_first_n` (3 — non-system head messages pinned across compactions; system prompt always preserved), `hygiene_hard_message_limit` (400 — gateway pre-compression safety valve for runaway message counts). Summarizer model configured separately under `auxiliary.compression.{model, provider, base_url}` — defaults to the main chat model; can point at a cheaper model (e.g. Gemini Flash). **Critical constraint:** the summary model's context window must be ≥ the main model's, or mid-conversation turns get silently dropped without a summary on overflow. Legacy `compression.summary_model/provider/base_url` auto-migrate to `auxiliary.compression.*` (config v17). Gateway hot-reloads `model.context_length` and any `compression.*` change on the next message — no restart/reset needed (API keys/tools/skills still need normal reload).

**Context engine:** `context.engine: "compressor"` (default, lossy summarization) or a plugin name (e.g. `"lcm"` for lossless context management) — plugins are never auto-activated, must be explicitly set, browsable via `hermes plugins`.

**Iteration budget pressure:** default `agent.max_turns: 90`. Warnings injected into the last tool result's JSON as `_budget_warning` (not separate messages, preserves prompt caching): 70% → "Caution... Start consolidating", 90% → "WARNING... Respond NOW". On full exhaustion, CLI shows `⚠ Iteration budget reached (90/90)` and the agent emits a summary of what it accomplished. `agent.api_max_retries` (default 3) controls retries before fallback-provider switching — set to `0` to fail over immediately if fallback providers are configured.

**API timeouts table:**

| Timeout | Default | Local providers | Config/env |
|---|---|---|---|
| Socket read | 120s | auto-raised to 1800s | `HERMES_STREAM_READ_TIMEOUT` |
| Stale stream | 180s | auto-disabled | `HERMES_STREAM_STALE_TIMEOUT` |
| Stale non-stream | 300s | auto-disabled if implicit | `providers.<id>.stale_timeout_seconds` / `HERMES_API_CALL_STALE_TIMEOUT` |
| API call (non-stream) | 1800s | unchanged | `providers.<id>.request_timeout_seconds` / `HERMES_API_TIMEOUT` |

**Context pressure warnings:** separate from iteration budget — tracks proximity to the compaction threshold. ≥60% → info (cyan bar / informational gateway notice); ≥85% → warning (bold yellow / "compaction imminent"). Purely a UI notification, doesn't alter the message stream.

**Credential pool strategies:** `credential_pool_strategies.<provider>: fill_first|round_robin|least_used|random` for rotating multiple API keys/OAuth tokens for the same provider.

**Prompt caching:** automatic, no config. For Claude on native Anthropic / OpenRouter / Nous Portal, Hermes attaches `cache_control` with 1-hour TTL on system prompt + skill blocks — first send per hour pays full rate, subsequent sends (any session) hit cached-read pricing. Qwen Cloud (DashScope) caps TTL at 5 minutes. Bedrock/Azure Foundry use provider defaults. xAI Grok uses session-pinned conversation IDs. Always-on, no disable knob.

**Auxiliary models:** side tasks (vision, web_extract, approval, compression, skills_hub, mcp dispatch, triage_specifier, kanban_decomposer, profile_describer, title_generation) default to `provider: "auto"` → routes to your **main chat model**. Configure interactively via `hermes model` → "Configure auxiliary models" (per-task picker), or directly in `config.yaml` under `auxiliary.<task>.{provider, model, base_url, api_key, timeout}`. `base_url` overrides provider; `provider: "main"` is valid only for auxiliary/compression/fallback (not `model.provider` — use `provider: custom` there for custom endpoints). Provider list mirrors the main provider catalog (openrouter, nous, codex, anthropic, gemini, minimax-oauth, xai-oauth, bedrock, etc., or any `custom_providers` entry). OpenRouter-specific routing prefs (`provider_routing`, `min_coding_score`) don't propagate to auxiliary tasks automatically — set per-task via `extra_body.provider`/`extra_body.plugins` (Pareto Code router).

**Reasoning effort:** `agent.reasoning_effort: ""` (empty = medium). Options: `none, minimal, low, medium, high, xhigh`. Runtime control via `/reasoning [level|show|hide]`.

**Tool-use enforcement:** `agent.tool_use_enforcement: "auto"` (default) — enabled for models matching `gpt|codex|gemini|gemma|grok`, disabled for Claude/DeepSeek/Qwen/etc. Can be `true` (always), `false` (never), or a list of model-name substrings. Injects up to 3 layers of system-prompt guidance: general tool-use enforcement, OpenAI execution discipline (GPT/Codex), Google operational guidance (Gemini/Gemma).

**TTS config** (`tts:` block): provider options `edge | elevenlabs | openai | minimax | mistral | gemini | xai | neutts`, each with provider-specific voice/model/speed settings. Speed fallback: per-provider speed → global `tts.speed` → `1.0`.

**Display settings** (`display:` block): `tool_progress: off|new|all|verbose` (cycle with `/verbose`), `tool_progress_command` (enable `/verbose` on gateways), `platforms: {}` (per-platform overrides — valid keys include telegram, discord, slack, signal, whatsapp, matrix, mattermost, email, sms, homeassistant, dingtalk, feishu, wecom, weixin, bluebubbles, qqbot), `interim_assistant_messages` (gateway mid-turn updates as separate messages), `skin`, `compact`, `resume_display: full|minimal`, `bell_on_complete`, `show_reasoning`, `streaming`, `show_cost`, `timestamps`, `tool_preview_length`, `runtime_footer.{enabled, fields}` (appends `model`/`context_pct`/`cwd` footer to final gateway replies, toggle via `/footer`), `file_mutation_verifier` (default `true` — appends an advisory if `write_file`/`patch` failed and was never superseded, e.g. "3 file(s) were NOT modified this turn"), `language` (UI language for static messages only — en, zh, zh-hant, ja, de, es, fr, tr, uk, af, ko, it, ga, pt, ru, hu; does NOT translate agent responses).

**Privacy:** `privacy.redact_pii: false` (default) — when `true`, gateway hashes phone numbers/user IDs/chat IDs to `user_<12-char-sha256>` for WhatsApp, Signal, Telegram (Discord/Slack excluded — their `<@user_id>` mentions need real IDs). Hashes are deterministic.

**STT config** (`stt:` block): `provider: local|groq|openai|mistral`. `local` uses `faster-whisper` (install separately). Fallback order: `local → groq → openai`.

**Voice mode (CLI):** `voice.record_key` (default `ctrl+b`), `max_recording_seconds` (120), `auto_tts`, `beep_enabled`, `silence_threshold`/`silence_duration` for auto-stop.

**Streaming:** CLI `display.streaming: true` (token-by-token) and `show_reasoning`. Gateway `streaming.{enabled, transport: edit|off, edit_interval, buffer_threshold, cursor, fresh_final_after_seconds}` — master switch off by default; per-platform defaults differ (Telegram streams by default, Discord doesn't). Overflow (>~4096 chars) finalizes current message and starts a new one. `fresh_final_after_seconds` (default 60) sends a brand-new message on completion for Telegram so the timestamp reflects completion time.

**Session/concurrency controls:** `max_concurrent_sessions` (null/0 = unlimited; positive int caps active sessions, best-effort/fail-open). `group_sessions_per_user: true` (default) gives each sender their own session in shared channels; `false` reverts to one shared session per chat. Threads stay isolated regardless.

**Unauthorized DM behavior:** `unauthorized_dm_behavior: pair` (default — denies access but sends a one-time pairing code) or `ignore` (silent drop); overridable per-platform (e.g. `whatsapp.unauthorized_dm_behavior: ignore`).

**Quick commands:** `quick_commands.<name>` define zero-token shell-exec commands or slash-command aliases, useful from messaging platforms for status checks.

---

## 4. Learning Path

Source: `docs/getting-started/learning-path`

Helps choose what to read based on experience level and goal. Assumes Installation + Quickstart already done. First-time users should run `hermes setup --portal` (one OAuth → model + 4 Tool Gateway tools).

**By experience level:**

| Level | Goal | Reading order | Time |
|---|---|---|---|
| Beginner | Basic conversations, built-in tools | Installation → Quickstart → CLI Usage → Configuration | ~1 hour |
| Intermediate | Messaging bots, memory, cron, skills | Sessions → Messaging → Tools → Skills → Memory → Cron | ~2-3 hours |
| Advanced | Custom tools, skills, RL training, contributing | Architecture → Adding Tools → Creating Skills → Contributing | ~4-6 hours |

**By use case (each with reading order):**

- **CLI coding assistant**: Installation → Quickstart → CLI Usage → Code Execution → Context Files → Tips & Tricks. Tip: pass files via context files for the agent to read/edit/run.
- **Telegram/Discord bot**: Installation → Configuration → Messaging Overview → Telegram Setup → Discord Setup → Voice Mode → Use Voice Mode with Hermes → Security. Project examples: "Daily Briefing Bot", "Team Telegram Assistant".
- **Task automation**: Quickstart → Cron Scheduling → Batch Processing → Delegation → Hooks. Cron enables scheduled tasks (daily summaries, periodic checks) without the user present.
- **Custom tools/skills**: Plugins → Build a Hermes Plugin → Tools Overview → Skills Overview → MCP → Architecture → Adding Tools → Creating Skills. Note: most custom tool work should start with Plugins, not core "Adding Tools" (that's for built-in Hermes development).
- **RL training**: Quickstart → Configuration → Atropos RL Environments (external, github.com/NousResearch/atropos) → Provider Routing → Architecture. Recommended only after the Beginner path.
- **Python library integration**: Installation → Quickstart → Python Library Guide → Architecture → Tools → Sessions.

**Feature directory table** (feature → link): Tools, Skills, Memory, Context Files, MCP, Cron, Delegation, Code Execution, Browser, Hooks, Batch Processing, Provider Routing — each maps to its own `user-guide/features/*` page.

**"What to read next" decision tree:** just installed → Quickstart; finished Quickstart → CLI Usage + Configuration; comfortable with basics → Tools/Skills/Memory; setting up for a team → Security + Sessions; ready to build → Developer Guide/Architecture; want examples → Guides section.

---

## 5. Documentation Overview (Docs Landing Page)

Source: `docs/` (root)

Hermes Agent is described as **"the self-improving AI agent"** built by Nous Research — "the only agent with a built-in learning loop": it creates skills from experience, improves them during use, nudges itself to persist knowledge, and builds a deepening model of the user across sessions. This framing is the canonical one-line positioning for [[03-RESOURCES/entities/hermes]].

**Install** (same commands as Installation page above — Hermes Desktop or `install.sh`/`install.ps1`). Fastest path: `hermes setup --portal`.

**"What is Hermes Agent?"** — explicitly NOT a coding-copilot-tethered-to-an-IDE or a chatbot wrapper around a single API. It's framed as an **autonomous agent that gets more capable the longer it runs**, deployable on a $5 VPS, a GPU cluster, or serverless infra (Daytona, Modal) that costs nearly nothing idle — controllable from Telegram while it works on a cloud VM the user never SSHes into.

**Quick links table** — full doc map: Installation, Quickstart, Learning Path, Configuration, Messaging Gateway, Tools & Toolsets (60+ built-in tools), Memory System, Skills System ("procedural memory the agent creates and reuses"), MCP Integration + "Use MCP with Hermes" guide, Voice Mode + "Use Voice Mode with Hermes" guide, Personality & SOUL.md, Context Files, Security (command approval, authorization, container isolation), Tips & Best Practices, Architecture, FAQ & Troubleshooting.

**Key features summary** (matches/extends what's documented elsewhere in the vault):
- Closed learning loop: agent-curated memory with periodic nudges, autonomous skill creation + self-improvement during use, FTS5 cross-session recall with LLM summarization, [Honcho](https://github.com/plastic-labs/honcho) dialectic user modeling.
- 6 terminal backends (local, Docker, SSH, Daytona, Singularity, Modal) — Daytona/Modal offer serverless persistence (hibernate when idle).
- 20+ messaging platforms from one gateway: Telegram, Discord, Slack, WhatsApp, Signal, Matrix, Mattermost, Email, SMS, DingTalk, Feishu, WeCom, Weixin, QQ Bot, Yuanbao, BlueBubbles, Home Assistant, Microsoft Teams, Google Chat, and more.
- Built by Nous Research (also behind Hermes models, Nomos, Psyche). Compatible with Nous Portal, OpenRouter, OpenAI, or any endpoint.
- Built-in cron with delivery to any platform.
- Delegation: spawn isolated subagents for parallel workstreams; `execute_code` (Programmatic Tool Calling) collapses multi-step pipelines into single inference calls.
- Open-standard skills compatible with [agentskills.io](https://agentskills.io/) — portable, shareable, community-contributed via the Skills Hub.
- MCP support for connecting to any MCP server.
- Research-ready: batch processing, trajectory export, RL training via Atropos.

**For LLMs and coding agents:** the docs site publishes machine-readable indexes —
- `/llms.txt` (~17KB) — curated index of every doc page with short descriptions, safe to load into an LLM context.
- `/llms-full.txt` (~1.8MB) — every doc page concatenated into one markdown file for one-shot ingestion.

Both also resolve at `/docs/llms.txt` and `/docs/llms-full.txt`, regenerated on every deploy. Useful for any future bulk-ingest of the full Hermes docs corpus.

---

## Ver também: User Stories da comunidade

Source: `docs/user-stories` (200+ relatos coletados de X, GitHub, Reddit, Discord, HN, YouTube, podcasts).

Padrões recorrentes confirmam o posicionamento "self-improving agent": (1) **memória/Obsidian como backbone** — múltiplos relatos (incl. um com 794 upvotes no Reddit) usam o vault Obsidian como camada de memória durável, alinhado com [[03-RESOURCES/sources/obsidian-hermes-autonomous-system]]; (2) **cron natural-language como killer feature** — "every weekday at 9am, summarize my inbox" repete-se em dezenas de variações (briefings, PR reviews, watchdogs, standups); (3) **custo extremo via self-hosting** — VPS de $5-20/mês, Raspberry Pi, modelos locais (Qwen3.5 4B/9B/27B) e roteamento para providers baratos (DeepSeek, MiniMax) trocam por "$130→$10 a cada 5 dias"; (4) **delegação multi-agente** — padrões "plan → code → QA → ship" com sub-agentes especializados (research/coder/QA) e Kanban multi-agent board citados repetidamente como diferencial sobre [[03-RESOURCES/entities/OpenClaw|OpenClaw]].

---

## See also

- [[03-RESOURCES/entities/hermes]] — main entity page (architecture, releases, integrations)
- [[03-RESOURCES/entities/Hermes-Agent]] — secondary entity page (deployment patterns)
- 52 community-content sources already in `03-RESOURCES/sources/ai-agents-harness/` and `03-RESOURCES/sources/hermes-agent/`
