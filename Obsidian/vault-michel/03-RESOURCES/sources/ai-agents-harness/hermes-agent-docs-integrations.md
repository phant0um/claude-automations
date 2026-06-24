---
title: "Hermes Agent — Official Docs: Integrations (MCP, Messaging, Voice)"
type: source
created: 2026-06-10
tags: [hermes, ai-agents, official-docs, mcp, integrations]
---

# Hermes Agent — Official Docs: Integrations (MCP, Messaging Gateway, Voice Mode)

Source: [hermes-agent.nousresearch.com/docs/](https://hermes-agent.nousresearch.com/docs/) — 5 official documentation pages covering Hermes Agent's external integration surfaces. These complement the 52 community-content sources already in this vault under `03-RESOURCES/sources/ai-agents-harness/` (which cover real-world deployments, agent stacks, and operational war stories). The official docs are the canonical reference for config syntax, commands, and supported behavior — useful for verifying claims made in community posts and as a configuration cookbook.

Entity: [[03-RESOURCES/entities/hermes]] (Hermes Agent, [[03-RESOURCES/entities/Nous-Research]]).
Concept: [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] (MCP — Model Context Protocol).

---

## 1. MCP (Model Context Protocol) — Feature Reference

MCP lets Hermes connect to external tool servers — GitHub, databases, filesystems, browsers, internal APIs — without writing native Hermes tools. Supports stdio (local subprocess) and HTTP (remote) servers in the same `~/.hermes/config.yaml`, with automatic tool discovery at startup and `/reload-mcp` for runtime changes.

**Quick start:**
```bash
cd ~/.hermes/hermes-agent
uv pip install -e ".[mcp]"
```
```yaml
mcp_servers:
  filesystem:
    command: "npx"
    args: ["-y", "@modelcontextprotocol/server-filesystem", "/home/user/projects"]
```

**Catalog system** — `hermes mcp` opens an interactive picker over a curated, Nous-reviewed catalog (`optional-mcps/` in the hermes-agent repo). `hermes mcp install <name>` installs by name; `hermes mcp catalog` lists entries as plain text. Catalog entries can require API keys (written to `~/.hermes/.env`), OAuth (remote MCP, `auth: oauth`), or third-party OAuth via `hermes auth <provider>`. At install time Hermes probes the server and presents a tool checklist — pre-checked rows come from prior selection, then the manifest's `tools.default_enabled`, then everything. Only checked tools land in `tools.include`. Manifests pin a `manifest_version`; newer entries than your Hermes understands surface a warning.

**Trust model:** installing a catalog entry runs `git clone`, bootstrap commands (`pip install`/`npm install`), and the server's own code. PR-reviewed by Nous, but users should still inspect `source:`, `install.bootstrap:`, and `transport.command:` before installing.

**Two transport types:**
```yaml
mcp_servers:
  github:
    command: "npx"
    args: ["-y", "@modelcontextprotocol/server-github"]
    env:
      GITHUB_PERSONAL_ACCESS_TOKEN: "***"

  remote_api:
    url: "https://mcp.example.com/mcp"
    headers:
      Authorization: "Bearer ***"
```

**OAuth-authenticated HTTP servers** (Linear, Sentry, Atlassian, Asana, Figma, Stripe...): `auth: oauth` triggers Hermes's full OAuth 2.1 flow (discovery, DCR, PKCE, refresh) via the MCP Python SDK. Tokens cached at `~/.hermes/mcp-tokens/<server>.json` (0o600). Remote/headless hosts can use paste-back redirect URLs or SSH port forwarding. **Pitfall:** providers that reject dynamic client registration (Google Drive, Atlassian) appear to authenticate successfully (since `tools/list` works without auth) but every real tool call times out — requires manually registering an OAuth client and supplying `client_id`/`client_secret`.

**mTLS support** via `client_cert`/`client_key`, accepting a combined PEM, a `[cert, key]` pair, or `[cert, key, password]` for encrypted keys.

**Per-server tool filtering** — the core safety mechanism:
```yaml
mcp_servers:
  github:
    tools:
      include: [create_issue, list_issues]   # whitelist — wins if both present
  stripe:
    tools:
      exclude: [delete_customer]              # blacklist
  docs:
    tools:
      prompts: false      # disable list_prompts/get_prompt wrappers
      resources: false    # disable list_resources/read_resource wrappers
```
If everything is filtered out, Hermes does not create an empty toolset for that server — keeps the tool list clean.

**Tool naming:** MCP tools register as `mcp_<server_name>_<tool_name>` (e.g. `mcp_github_create_issue`). Utility wrappers (`list_resources`, `read_resource`, `list_prompts`, `get_prompt`) are capability-aware — only registered if both the config allows them AND the server session actually supports that capability.

**Dynamic Tool Discovery:** servers can send `notifications/tools/list_changed`; Hermes auto-refetches and updates the registry (lock-protected against overlapping refreshes) — no manual reload needed.

**Parallel tool calls** — opt-in per server via `supports_parallel_tool_calls: true`, for read-only/safe-concurrent tools.

**MCP Sampling** — servers can request LLM inference from Hermes via `sampling/createMessage`, enabled by default with rate limiting:
```yaml
mcp_servers:
  my_server:
    sampling:
      enabled: true
      model: "openai/gpt-4o"
      max_tokens_cap: 4096
      timeout: 30
      max_rpm: 10
      max_tool_rounds: 5
```

**Hermes as an MCP server** — `hermes mcp serve` exposes Hermes's messaging layer (10 tools: `conversations_list`, `messages_send`, `events_poll`/`events_wait` for near-real-time, `permissions_respond`, etc.) as a stdio MCP server, so Claude Code/Cursor/Codex can read and send Telegram/Discord/Slack messages through Hermes. Reads from `~/.hermes/sessions/sessions.json` + SQLite; gateway must be running for sends, not for reads. Stdio-only today; no push notifications; text-only sends.

**Comparison note:** this vault's own session config uses MCP servers (filesystem-vault, obsidian, etc. — see project CLAUDE.md). Hermes's `mcp_servers.yaml`/`config.yaml` schema (`command`/`args`/`env` for stdio, `url`/`headers` for HTTP, `tools.include`/`tools.exclude` for filtering) maps directly onto the same MCP spec described in [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — Hermes's catalog + per-server filtering is essentially a more curated/guided UX over the same primitives Claude Code exposes via `.mcp.json`.

---

## 2. Use MCP with Hermes — Practical Guide

Companion guide focused on *how* to adopt MCP safely, not just config syntax.

**When to use MCP vs. not:** use it when a tool already exists in MCP form, you want fine-grained per-server exposure control, or you're connecting to internal APIs/databases without touching Hermes core. Avoid it when a built-in tool already solves the job, the server exposes a huge dangerous surface you're not ready to filter, or a native tool would be simpler.

**Mental model:** MCP servers contribute tools; Hermes discovers them at startup/reload; the model uses them like normal tools. "Good MCP usage is not connect everything — it's connect the right thing, with the smallest useful surface."

**Recommended progression:** start with one safe server (e.g. filesystem scoped to a single project dir), verify it loaded (`/reload-mcp`, ask Hermes what tools it has), then start filtering immediately for any server with a large tool surface — whitelist (`tools.include`) is the default-safe choice for sensitive systems.

**WSL2 → Windows Chrome bridge** — a notable pattern: when Hermes runs in WSL2 and the target browser is Windows Chrome, `/browser connect` often fails (WSL can't reach the same host-local endpoint). Solution: launch a stdio MCP server through Windows interop:
```bash
hermes mcp add chrome-devtools-win --command cmd.exe --args /c npx -y chrome-devtools-mcp@latest --autoConnect --no-usage-statistics
hermes mcp test chrome-devtools-win
```
Then `/reload-mcp`. Pitfalls: start Hermes from a Windows-mounted path (`/mnt/c/...`) to avoid UNC current-directory warnings; reduce frozen Chrome tabs if `--autoConnect` times out.

**Filtering affects two categories:** (1) server-native tools via `tools.include`/`tools.exclude`, (2) Hermes-added utility wrappers via `tools.resources`/`tools.prompts`. Wrappers only appear if config allows AND the server supports the capability — Hermes won't fake resources/prompts a server doesn't have.

**Common patterns documented:**
- **Local project assistant** — filesystem + git MCP servers scoped to one repo
- **GitHub triage assistant** — whitelist `[list_issues, create_issue, update_issue, search_code]`, disable prompts/resources
- **Internal API assistant** — strict whitelist (`list_customers, get_customer, list_invoices`), resources/prompts off
- **Documentation/knowledge servers** — enable `prompts: true`/`resources: true` since these servers are knowledge assets, not action surfaces

**End-to-end tutorial progression:** Phase 1 (tight GitHub whitelist) → Phase 2 (expand `include` list, `/reload-mcp`) → Phase 3 (add a second server, e.g. filesystem, with a different policy) — combining servers is "where MCP gets powerful: multi-system workflows without changing Hermes core."

**Safe usage recommendations:** prefer allowlists for anything financial/customer-facing/destructive starting from the smallest set; disable unused resource/prompt utilities; scope servers narrowly (one project dir, one repo, read-heavy API exposure); always `/reload-mcp` after config changes.

**Recommended first servers:** filesystem, git, GitHub, fetch/documentation servers, one narrow internal API. Avoid: giant business systems with many destructive actions and no filtering, or anything you don't understand well enough to constrain.

---

## 3. Messaging Gateway — Feature Reference

The gateway is a single background process connecting Hermes to ~20 messaging platforms simultaneously: Telegram, Discord, Slack, Google Chat, WhatsApp, Signal, SMS, Email, Home Assistant, Mattermost, Matrix, DingTalk, Feishu/Lark, WeCom (+ Callback variant), Weixin, BlueBubbles (iMessage), QQ, Yuanbao, Microsoft Teams, LINE, ntfy, plus an OpenAI-compatible API server and Webhooks. It also runs the cron scheduler (60s ticks) and per-chat session stores. Each platform adapter routes messages through a session store to the central `AIAgent` (`run_agent.py`).

**Platform capability matrix** (selected): Telegram, Discord, Slack, Mattermost, Matrix, Feishu/Lark support the full set (voice, images, files, threads, reactions, typing, streaming). WhatsApp/Signal/SMS/Email lack threads/voice (Email has threads but no voice). SMS and ntfy are minimal (no images/files/voice/streaming).

**Setup:**
```bash
hermes gateway setup        # interactive wizard, all platforms
hermes gateway              # run in foreground
hermes gateway install      # user/launchd service
hermes gateway start/stop/status
```

**Chat commands** (work across platforms): `/new`/`/reset`, `/model [provider:model]`, `/personality`, `/retry`, `/undo`, `/status`, `/whoami`, `/stop`, `/approve`/`/deny`, `/sethome`, `/compress`, `/title`, `/resume`, `/usage`, `/insights`, `/reasoning`, `/voice`, `/rollback`, `/background <prompt>`, `/reload-mcp`, `/update`, `/<skill-name>`.

**Session reset policies:** daily (default 4 AM), idle (default 1440 min), or both; per-platform overrides via `~/.hermes/gateway.json`'s `reset_by_platform`.

**Security:** default-deny — only allowlisted or DM-paired users can interact. Per-platform allowlist env vars (`TELEGRAM_ALLOWED_USERS`, `DISCORD_ALLOWED_USERS`, etc.) or generic `GATEWAY_ALLOWED_USERS`; `GATEWAY_ALLOW_ALL_USERS=true` is explicitly not recommended for bots with terminal access. **DM pairing** is an alternative: unknown users get a one-time code, approved via `hermes pairing approve <platform> <code>` (codes expire in 1 hour, rate-limited).

**Admin/user tiers** — new finer-grained access control on top of allowlists: admins get all slash commands, regular users get only an explicitly enabled subset (floor: `/help`, `/whoami`). Configured per platform/scope via `gateway.platforms.<name>.extra.allow_admin_from` / `user_allowed_commands`. Backward compatible — if `allow_admin_from` unset, every allowed user has full access.

**Interrupt model:** any new message interrupts the running agent (SIGTERM→SIGKILL after 1s on terminal commands; in-flight tool calls cancelled, queued ones skipped; multiple interrupting messages get combined). Alternatives: `queue` (wait for current task) and `steer` (`/steer`-style injection mid-run via `display.busy_input_mode: steer`).

**Background sessions** — `/background <prompt>` spawns an isolated agent instance (own session, no shared context, inherits model/provider/toolsets) that reports back to the originating chat on completion. `display.background_process_notifications` controls long-running-process updates (`all`/`result`/`error`/`off`).

**Operations at scale:** `/platform list|pause|resume <name>` inspects/steers individual adapters without restarting the gateway. Each adapter has an automatic circuit breaker — repeated failures auto-pause it (with an operator notification to another live platform's home channel) but it does NOT auto-resume; requires manual `/platform resume`. Restart notifications and session auto-resume (`restart_interrupted` flag) are on by default per platform.

**Platform-specific toolsets:** each platform gets its own toolset name (`hermes-telegram`, `hermes-discord`, etc.) with full tool access including terminal, except the API server toolset (`hermes-api-server`) which drops `clarify`, `send_message`, `text_to_speech` since there's no interactive user.

---

## 4. Voice Mode — Feature Reference

Full voice support across CLI (`hermes`/`hermes --tui`), and messaging (Telegram, Discord text + Discord voice channels).

**Install:**
```bash
pip install "hermes-agent[voice]"      # CLI mic + playback (sounddevice, numpy)
pip install "hermes-agent[messaging]"  # Discord/Telegram incl. discord.py[voice]
pip install "hermes-agent[tts-premium]" # ElevenLabs
pip install "hermes-agent[all]"
```
System deps: PortAudio (mic/playback), ffmpeg (format conversion), Opus (Discord codec), espeak-ng (NeuTTS phonemizer). On macOS: `brew install portaudio ffmpeg opus espeak-ng`.

**STT** (speech-to-text): `local` (faster-whisper, free, zero API key, ~150MB model auto-downloads), `groq` (fast, free tier), `openai` (paid). Fallback priority: local > groq > openai. Models from `tiny` to `large-v3`.

**TTS** (text-to-speech): `edge` (free, default, 322 voices/74 languages), `elevenlabs` (premium, paid), `openai`, `neutts` (free local), `mistral`, `gemini`, `xai`, `kittentts`, `piper`.

**CLI voice mode** — `/voice on` then **Ctrl+B** to record (880Hz beep), live audio level bar, auto-stops after 3s silence (660Hz double-beep), transcribes via Whisper, optionally speaks reply via streaming TTS (sentence-by-sentence, strips markdown/`<think>` blocks), then auto-restarts recording. Hallucination filter removes 26 known Whisper phantom phrases ("Thank you for watching" etc.) plus a regex for repetitive variants. Two-stage silence detection: speech confirmation (RMS > 200 for 0.3s) then end detection (3.0s continuous silence); 15s total silence aborts.

**Gateway voice replies (Telegram/Discord):** `/voice on|tts|off|status` — modes: `off` (text only, default), `voice_only` (speak only when user sent voice), `all` (speak every reply). Telegram delivers Opus/OGG voice bubbles (ffmpeg converts MP3→Opus); Discord similarly, falling back to file attachment if the voice-bubble API fails. Setting persists across gateway restarts.

**Discord voice channels** — most advanced mode: bot joins VC, transcribes each user's audio independently (1.5s silence after 0.5s+ speech triggers processing), runs the full agent pipeline, speaks reply back via TTS, and posts transcripts (`[Voice] @user: ...`) in the text channel where `/voice join` was issued. Requires Connect+Speak Discord permissions (permission integer `274881432640` for text+voice) and three privileged intents (Presence, Server Members, Message Content). Echo prevention: bot pauses its listener while playing TTS. Access restricted to `DISCORD_ALLOWED_USERS`.

**Config reference (`config.yaml`):**
```yaml
voice:
  record_key: "ctrl+b"
  max_recording_seconds: 120
  auto_tts: false
  beep_enabled: true
  silence_threshold: 200
  silence_duration: 3.0

stt:
  enabled: true
  provider: "local"
  local:
    model: "base"

tts:
  provider: "edge"
  edge:
    voice: "en-US-AriaNeural"
```

Note: `stt.enabled: false` still caches the audio file and passes its path to the agent for custom pipelines (diarization, archival, etc.) — it just skips auto-transcription.

---

## 5. Use Voice Mode with Hermes — Practical Guide

Companion adoption guide. Recommends a strict progression: get text working → install voice extras → CLI voice mode with local STT + Edge TTS → enable `/voice on` in Telegram/Discord → only then attempt Discord VC mode. "That progression keeps the debugging surface small."

**Three voice experiences compared:**

| Mode | Best for | Platform |
|---|---|---|
| Interactive microphone loop | Hands-free CLI use | CLI |
| Voice replies in chat | Spoken responses alongside text | Telegram, Discord |
| Live voice channel bot | Group/personal live conversation | Discord VC |

**Provider recommendations by goal:**
- **Easiest/cheapest:** STT `local`, TTS `edge` — zero API keys
- **Best quality:** STT `local large-v3` or Groq `whisper-large-v3`, TTS ElevenLabs
- **Best speed/convenience:** STT `local base` or Groq, TTS Edge

**NeuTTS setup wizard behavior:** if NeuTTS is selected but missing, the setup wizard checks for the `neutts` package and `espeak-ng`, offers to install both (espeak-ng via platform package manager), then runs `python -m pip install -U neutts[all]`. Falls back to Edge TTS if the install fails or is skipped.

**CLI tuning knobs:**
- `voice.silence_threshold` — raise (e.g. 250) if recording starts/stops too aggressively
- `voice.silence_duration` — raise (e.g. 4.0) if you pause a lot mid-sentence
- `voice.record_key` — change from `ctrl+b` if it conflicts with terminal/tmux bindings

**Discord VC best practices:** keep `DISCORD_ALLOWED_USERS` tight, use a dedicated test channel first, verify STT/TTS work in plain text-chat voice mode before attempting VC mode.

**Common failure modes documented:** "No audio device found" → install portaudio; "Bot joins but hears nothing" → check allowed-users list, mute state, privileged intents, Connect/Speak permissions; "It transcribes but does not speak" → check TTS provider config/quota/ffmpeg; "Whisper outputs garbage" → quieter environment, higher `silence_threshold`, different STT model/provider, shorter utterances; "works in DMs but not server channels" → Discord's default `@mention` requirement (`DISCORD_REQUIRE_MENTION=false` to disable).

---

## Related

- [[03-RESOURCES/entities/hermes]]
- [[03-RESOURCES/entities/Hermes-Agent]]
- [[03-RESOURCES/entities/Nous-Research]]
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]]
- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
