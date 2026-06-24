---
title: "Hermes Agent Docs: Security Model"
type: source
source: "Hermes Agent official docs — user-guide/security"
created: 2026-06-10
ingested: 2026-06-10
tags: [ai-agents]
---

# Hermes Agent Docs: Security Model

## Tese central

Hermes uses a **defense-in-depth** model with seven layers: user authorization, dangerous command approval, container isolation, MCP credential filtering, context file scanning, cross-session isolation, and input sanitization (working-directory allowlisting against shell injection).

## Argumentos principais

**Dangerous Command Approval.** Configured via `approvals.mode` in `~/.hermes/config.yaml` (`manual` | `smart` | `off`), with `timeout` (default 60s, fail-closed/deny on timeout), `cron_mode` (`deny`/`approve` for headless cron), `mcp_reload_confirm`, and `destructive_slash_confirm` (gates `/clear`, `/new`, `/reset`, `/undo`). `manual` always prompts; `smart` uses an auxiliary LLM to auto-approve low-risk commands and auto-deny clearly dangerous ones, escalating uncertain cases; `off` disables all checks (equivalent to `--yolo`).

**YOLO mode** bypasses all approval prompts for the session — via `hermes --yolo`/`hermes chat --yolo`, the `/yolo` toggle, or `HERMES_YOLO_MODE=1`. Two persistent UI reminders (red banner + status-bar `⚠ YOLO` fragment) keep it visible.

**Hardline blocklist** is the floor below `--yolo` — `tools/approval.py::UNRECOVERABLE_BLOCKLIST` catches `rm -rf /` and variants, fork bombs, `mkfs` on mounted root, `dd` to physical disks, and curl-pipe-to-sh at rootfs top level. No override exists, even with `--yolo`, `approvals.mode: off`, cron `approve` mode, or "always allow."

**Approval triggers** (from `tools/approval.py`) include recursive deletes, `chmod 777`/world-writable perms, `chown -R root`, filesystem format/disk-write commands, SQL `DROP`/`DELETE without WHERE`/`TRUNCATE`, system-config overwrites (`> /etc/`), service stop/restart, kill-all patterns, fork bombs, shell `-c`/`-e` script execution, curl/wget-pipe-to-shell, `tee`/redirect to sensitive files (`/etc/`, `~/.ssh/`, `~/.hermes/.env`), `xargs rm`/`find -exec rm`, copy/move into `/etc/`, in-place sed on system config, and self-termination prevention (`pkill hermes`). **Container bypass**: docker/singularity/modal/daytona backends skip dangerous-command checks entirely — the container *is* the boundary.

CLI approval flow offers **once / session / always / deny** (default deny); gateway/messaging flow accepts text replies (yes/y/approve/ok/go vs no/n/deny/cancel), with `HERMES_EXEC_ASK=1` set automatically. "Always" patterns persist to `command_allowlist` in `config.yaml`.

**User Authorization (Gateway)** — `_is_user_authorized()` checks in order: per-platform allow-all flag → DM pairing approved list → platform allowlists (`TELEGRAM_ALLOWED_USERS`, etc.) → global allowlist (`GATEWAY_ALLOWED_USERS`) → global allow-all (`GATEWAY_ALLOW_ALL_USERS`) → default deny. If nothing is configured, **all users denied** with a startup warning.

**DM Pairing** (OWASP + NIST SP 800-63-4 based): 8-char codes from a 32-char unambiguous alphabet, cryptographically random, 1-hour TTL, rate-limited (1/user/10min, max 3 pending), 5 failed attempts → 1-hour lockout, files `chmod 0600`, codes never logged. CLI: `hermes pairing list/approve/revoke/clear-pending`.

**Container Isolation (Docker)** — every container gets `--cap-drop ALL` plus minimal re-adds (`DAC_OVERRIDE`, `CHOWN`, `FOWNER`), `no-new-privileges`, `--pids-limit 256`, size-limited `/tmp` (512m) and no-exec `/var/tmp` (256m). `SETUID`/`SETGID` added conditionally only for root-starting images doing privilege drop. Resource limits (`container_cpu`, `container_memory` default 5GB, `container_disk` default 50GB) and persistence mode (`container_persistent: true` bind-mounts `/workspace` + `/root` from `~/.hermes/sandboxes/docker/<task_id>/`; `false` uses ephemeral tmpfs) are configurable.

**Env var / credential passthrough** — `execute_code` and `terminal` strip vars matching `KEY|TOKEN|SECRET|PASSWORD|CREDENTIAL|PASSWD|AUTH`. Skills declaring `required_environment_variables` get automatic passthrough (merged into Docker/Modal forwarding since v0.5.1). `required_credential_files` (e.g., OAuth tokens) get read-only bind mounts in Docker, synced mounts in Modal. MCP subprocesses get only `PATH, HOME, USER, LANG, LC_ALL, TERM, SHELL, TMPDIR` + `XDG_*`, plus explicitly configured `env` keys; tool error messages are scanned and redact GitHub PATs, OpenAI-style keys, bearer tokens, and `key=`/`secret=`/`password=` params.

**Website blocklist & SSRF protection** — `security.website_blocklist` can deny domains/glob patterns across `web_search`, `web_extract`, `browser_navigate`, etc. SSRF protection (always on for internet-facing use, fail-closed on DNS failure, redirect chains re-validated per hop) blocks RFC 1918 private ranges, loopback, link-local (incl. `169.254.169.254` cloud metadata), CGNAT (`100.64.0.0/10`), and cloud metadata hostnames. `security.allow_private_urls: true` opts out for legitimate LAN use cases (home Ollama, internal wikis) but the Unicode-homograph host-substring guard stays on regardless.

**Tirith pre-exec scanning** — integrates [tirith](https://github.com/sheeki03/tirith) for content-level threat detection (homograph URLs, pipe-to-interpreter, terminal injection) beyond pattern matching. Auto-installs with SHA-256 + cosign verification. Config: `security.tirith_enabled` (default true), `tirith_timeout` (5s), `tirith_fail_open` (default true — set false for high-security). No prebuilt binary on Windows (use WSL); findings feed the approval flow with severity/description/safer-alternatives.

**Context file injection protection** — `AGENTS.md`/`.cursorrules`/`SOUL.md` scanned for prompt injection (ignore-prior-instructions phrasing, hidden HTML comments, secret-reading attempts, curl exfiltration, invisible Unicode). Blocked files produce a visible `[BLOCKED: ... contained potential prompt injection]` warning.

**Production deployment checklist** (10 items): explicit allowlists (never `GATEWAY_ALLOW_ALL_USERS=true`), `terminal.backend: docker`, resource limits, secrets in `~/.hermes/.env` (chmod 600), DM pairing over hardcoded IDs, periodic `command_allowlist` audits, scoped `terminal.cwd`, non-root gateway, log monitoring (`~/.hermes/logs/`), and `hermes update` regularly.

**Supply-chain advisory scanner** (`hermes_cli/security_advisories.py`) flags known-compromised pip packages (e.g., the May 2026 `mistralai 2.4.6` worm) via `importlib.metadata.version()` checks at every startup — CLI banner, `hermes doctor` for remediation, gateway log entry. Acks persist to `config.security.acked_advisories` via `hermes doctor --ack <id>`; old advisories are kept in the catalog intentionally.

**Lazy install of optional deps** (`tools/lazy_deps.py`) — features like Mistral TTS, ElevenLabs, Honcho, Bedrock install on first use rather than via `[all]`, isolating one poisoned/broken extra from breaking the rest. Guarantees: venv-scoped installs only, PyPI-by-name only (no `--index-url`/`git+`/file: paths), allowlisted `LAZY_DEPS` map, opt-out via `security.allow_lazy_installs: false`, no silent retries (`FeatureUnavailable` on failure).

## Implicações para o vault

> [!note] Comparison to vault's guard agent
> This vault's [[04-SYSTEM/agents/core/guard]] (security/Opus layer for the Vault SO) and Hermes's approval/blocklist/container-isolation stack solve the same class of problem — gating destructive operations behind human-in-the-loop or hard-coded floors — but at different scopes: `guard` protects the vault's own file operations and agent actions, while Hermes's model protects an end-user's full shell/filesystem/network surface across CLI, gateway, and cron. Hermes's three-tier structure (configurable approval mode → hardline blocklist floor → container-as-boundary) is a useful reference pattern if `guard` is ever extended with a "no override regardless of mode" floor.

## Links

- [[04-SYSTEM/agents/core/guard]]
- [[03-RESOURCES/entities/Hermes-Agent]]
- [[03-RESOURCES/entities/hermes]]
