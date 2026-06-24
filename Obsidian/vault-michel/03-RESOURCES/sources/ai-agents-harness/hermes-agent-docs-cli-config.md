---
title: "Hermes Agent — Official Docs: CLI, Configuration, Secrets, Profiles & Deployment"
type: source
created: 2026-06-14
tags: [hermes, ai-agents, official-docs, cli, configuration, secrets, profiles, docker, mcp]
---

# Hermes Agent — Official Docs: CLI, Configuration, Secrets, Profiles & Deployment

Consolidação de 16 páginas oficiais de `hermes-agent.nousresearch.com/docs/user-guide/*` e `/docs/reference/*`, ingeridas em 2026-06-14. Documentação primária/normativa do [[03-RESOURCES/entities/hermes|Hermes]] ([[03-RESOURCES/entities/Hermes-Agent|Hermes Agent]]), complementando os sources oficiais existentes (`hermes-agent-docs-onboarding`, `-features`, `-features-2`, `-integrations`, `-reference`). Foco: interface CLI completa, sistema de configuração (`~/.hermes/config.yaml`), secrets/security, profiles/multi-agente, sessões, desktop app, Docker e MCP config reference. Profundidade > brevidade — config keys, exemplos YAML e specs preservados na íntegra.

---

## 1. CLI

### 1.1 Interface Layout & Status Bar

A CLI interativa (`hermes` ou `hermes chat`) roda em modo TUI com uma status bar que mostra: modelo ativo, profile, modo (YOLO/normal), contador de tokens, working directory. Layout adapta a largura do terminal (tiers de largura para esconder/mostrar elementos).

Keybindings principais: navegação multi-linha, histórico de input, scroll de output, atalhos para slash commands.

### 1.2 Slash Commands

Comandos centrais durante uma sessão:

- `/model` — troca modelo principal interativamente
- `/yolo` — toggle YOLO mode (bypassa aprovação de comandos perigosos)
- `/voice on` / `/voice tts` — modo voz (push-to-talk + respostas falladas)
- `/compress` — comprime contexto da sessão manualmente
- `/new [título]` — nova sessão (opcionalmente com título inicial)
- `/resume <título|id>` — retoma sessão anterior
- `/title <texto>` — define/mostra título da sessão
- `/handoff <platform>` — transfere sessão CLI ativa para plataforma de mensagens (Telegram/Discord/Slack/etc.)
- `/sethome` — configura canal home de uma plataforma (necessário para `/handoff`)
- `/background` — suspende sessão para background
- `/clear`, `/reset`, `/undo`, `/quit --delete` (`/exit --delete`) — comandos destrutivos, com confirmação se `approvals.destructive_slash_confirm: true`
- `/reload-mcp` — recarrega config MCP (invalida cache de tools)
- `/skill` — carrega/gerencia skills da sessão

### 1.3 Quick Commands & Personalities

Quick commands (`quick_commands` em `config.yaml`) definem comandos custom que executam shell sem LLM (`type: exec`, zero-token) ou aliases para outros slash commands (`type: alias`):

```yaml
quick_commands:
  status:
    type: exec
    command: systemctl status hermes-agent
  disk:
    type: exec
    command: df -h /
  update:
    type: exec
    command: cd ~/.hermes/hermes-agent && git pull && pip install -e .
  gpu:
    type: exec
    command: nvidia-smi --query-gpu=name,utilization.gpu,memory.used,memory.total --format=csv,noheader
  restart:
    type: alias
    target: /gateway restart
```

Características: timeout de 30s, prioridade sobre skill commands, não aparecem no autocomplete de slash commands built-in, tipos suportados `exec`/`alias` apenas. Funcionam em CLI e todas as plataformas de mensagem.

Personalities pré-definidas podem ser carregadas via flag/comando para alterar o tom do agente (ver `-features` source para detalhes do sistema SOUL.md).

### 1.4 Multi-line Input, Interrupt & Busy Mode

Input multi-linha suportado nativamente. Durante execução, o usuário pode interromper o agente; comportamento de input enquanto o agente está "busy" é controlado por `display.busy_input_mode`.

### 1.5 Tool Progress Display

`display.tool_preview_length` controla quanto do output de uma tool é mostrado inline antes de truncar. Tool progress é exibido de forma compacta durante execução.

### 1.6 Session Management, Resume & Compression (CLI)

```bash
# Resume última sessão CLI
hermes --continue
hermes -c

# Resume por nome
hermes -c "my project"   # resolve lineage mais recente automaticamente

# Resume por ID ou título
hermes --resume 20250305_091523_a1b2c3d4
hermes --resume "refactoring auth"
```

Ao retomar, exibe painel de recap com últimas 10 trocas (mensagens user/assistant truncadas, tool calls colapsados em contagem). Para desabilitar:

```yaml
display:
  resume_display: minimal   # default: full
```

Ver seção [5. Sessions](#5-sessions) para detalhes completos do sistema de sessões.

### 1.7 Background Sessions & Quiet Mode

`/background` suspende a sessão atual para background, permitindo continuar trabalho enquanto outra tarefa roda. Quiet mode reduz verbosidade de output (útil para scripts/automação).

### 1.8 CLI Commands Reference (`hermes <command>`)

Entrypoint global com tabela de opções (`--help`, `--version`, flags globais). Principais comandos top-level:

| Comando | Função |
| --- | --- |
| `hermes chat` (default) / `hermes -z "<prompt>"` | Sessão interativa ou one-shot |
| `hermes model` | Gerencia modelo principal e auxiliares |
| `hermes gateway` | Gerencia gateway de mensageria (run/start/stop/restart/status/install/uninstall) |
| `hermes lsp` | Diagnósticos semânticos (~25 language servers) |
| `hermes setup` | Wizard de configuração inicial |
| `hermes portal` | Integração Nous Portal |
| `hermes whatsapp` / `hermes slack` | Setup de plataformas específicas |
| `hermes send` | Envia mensagem via plataforma configurada |
| `hermes secrets` | Gerencia secrets (incl. `bitwarden` subcomandos) |
| `hermes migrate` | Migração de config/dados entre versões |
| `hermes proxy` | Proxy de API |
| `hermes security` | Comandos de segurança |
| `hermes auth` | Autenticação de providers |
| `hermes status` | Status geral do sistema |
| `hermes cron` | Tarefas agendadas |
| `hermes kanban` | Board multi-agente (boards, tasks, dispatcher, specify/decompose) |
| `hermes webhook` | Webhooks entrantes |
| `hermes doctor` | Diagnóstico de saúde + advisories de supply-chain |
| `hermes dump` | Dump de estado/config para debug |
| `hermes debug` | Comandos de debug |
| `hermes backup` | Backup de dados |
| `hermes checkpoints` | Gerencia checkpoints (ver seção 2.3) |
| `hermes import` | Importa dados |
| `hermes logs` | Visualiza logs |
| `hermes prompt-size` | Mede tamanho do system prompt |
| `hermes config` | Edita/inspeciona config.yaml (`hermes config edit`) |
| `hermes pairing` | Gerencia pairing de DMs (`list`/`approve`/`revoke`/`clear-pending`) |
| `hermes skills` | Gerencia skills |
| `hermes bundles` | Gerencia bundles de skills |
| `hermes curator` | Curadoria de memória/skills |
| `hermes fallback` | Configuração de fallback providers |
| `hermes hooks` | Plugin/event hooks |
| `hermes memory` | Gerencia MEMORY.md/USER.md |
| `hermes acp` | Integração ACP (VS Code/Zed/JetBrains) |
| `hermes mcp` | Gerencia servidores MCP |
| `hermes plugins` | Gerencia plugins |
| `hermes tools` | Gerencia toolsets e backends (web search, browser) |
| `hermes computer-use` | Ferramenta de controle de desktop |
| `hermes sessions` | Gerencia sessões (ver seção 5) |
| `hermes insights` | Analytics (token usage, custo, breakdown de tools) |
| `hermes claw` | (comando especializado — ver reference completo) |
| `hermes dashboard` | Web dashboard |
| `hermes profile` | Gerencia profiles (ver seção 4) |
| `hermes completion` | Tab completion para shell |
| `hermes update` | Atualiza Hermes |

`hermes chat --checkpoints` habilita checkpoints para a sessão (ver seção 2.3). `hermes -w` ativa modo git worktree automático (ver seção 8).

---

## 2. Configuração & Modelos

### 2.1 Estrutura de Diretórios e Precedência

`~/.hermes/` contém: `config.yaml`, `.env`, `SOUL.md`, `state.db`, `sessions/`, `memories/`, `checkpoints/`, `pairing/`, `bin/`, `sandboxes/`, `mcp-tokens/`, `logs/`.

Comandos de gerenciamento: `hermes config edit` (abre editor), `hermes config` (inspeção). Precedência de configuração: flags CLI > env vars > `config.yaml` > defaults internos. Variáveis de ambiente suportam substituição em `config.yaml`.

### 2.2 Terminal Backends

Backends suportados: `local`, `docker`, `ssh`, `modal`, `daytona`, `singularity`. Cada um tem config YAML própria (imagem/host/credenciais), tabela de lifecycle de container, e overrides via env vars. `local` roda no host sem isolamento; os demais isolam comandos em container/cloud sandbox/máquina remota.

```yaml
terminal:
  backend: docker
  docker_image: "nikolaik/python-nodejs:python3.11-nodejs20"
  docker_forward_env: []
  container_cpu: 1
  container_memory: 5120
  container_disk: 51200
  container_persistent: true
  cwd: /home/myuser/projects   # override de working directory
```

Persistent shell mantido entre comandos no mesmo backend. Ver seção 7 (Docker) para detalhes completos do backend `docker`.

### 2.3 Checkpoints e Rollback

Sistema opt-in de snapshots automáticos antes de operações destrutivas de arquivo. Ativação:

```bash
hermes chat --checkpoints
```

ou:

```yaml
checkpoints:
  enabled: false           # default: false (opt-in)
  max_snapshots: 20        # por diretório
  max_total_size_mb: null
  max_file_size_mb: null
  auto_prune: true
  retention_days: null
  delete_orphans: true
  min_interval_hours: null
```

Mecanismo: repositório git "shadow" compartilhado em `~/.hermes/checkpoints/store/`, isolado do `.git` do projeto. Checkpoints são criados automaticamente antes de operações que modificam/deletam arquivos.

**Quick reference de comandos:**

| Comando | Ação |
| --- | --- |
| `/rollback` | Lista checkpoints recentes |
| `/rollback <N>` | Restaura checkpoint N |
| `/rollback diff <N>` | Mostra diff do checkpoint N |
| `/rollback <N> <file>` | Restaura apenas um arquivo do checkpoint N |
| `hermes checkpoints list/show/restore` | Equivalentes via CLI |

Safety guards: limites de tamanho (`max_file_size_mb`, `max_total_size_mb`) evitam snapshot de arquivos grandes; `min_interval_hours` evita checkpoints excessivos; `delete_orphans` limpa checkpoints sem referência. Estrutura de diretórios documentada com árvore completa em `~/.hermes/checkpoints/`. Há guia de migração de checkpoints v1 → v2 (mudança do esquema de armazenamento) e best practices (habilitar para sessões de refactor grande, não para sessões read-only).

### 2.4 Configurando Modelos

Dois grupos de model slots: **main model** (modelo principal de conversação) e **11 auxiliary task slots**: `vision`, `web_extract`, `compression`, `approval`, `skills_hub`, `mcp`, `triage_specifier`, `kanban_decomposer`, `profile_describer`, `curator`, `title_generation`.

`model:` no `config.yaml` aceita string vazia (`""` = auto/inherit) ou mapping completo `{provider, model, ...}`.

**Setting principal:**

```yaml
model:
  provider: anthropic
  model: claude-opus-4-1
```

**Auxiliary overrides** — cada slot pode ter override individual; quando ausente, usa `auto` (modelo rápido/barato escolhido automaticamente):

```yaml
auxiliary:
  compression:
    provider: openrouter
    model: google/gemini-3-flash-preview
  vision:
    provider: anthropic
    model: claude-haiku-4-5
  # demais slots em auto se omitidos
```

**Quando mudanças têm efeito:** CLI aplica no próximo turno; gateway requer restart do processo (`hermes gateway restart`); dashboard aplica em tempo real via API.

**Troubleshooting comum:** nenhum provider autenticado (`hermes auth`/`.env` faltando), modelo principal não muda (cache de sessão — `/new` força reload), override auxiliary não aplica (verificar indentação YAML), troca de provider no OpenRouter (formato `provider/model` obrigatório).

**Métodos alternativos:**

- Slash command `/model` (interativo)
- Aliases customizados: `model_aliases:` (canônico, top-level) vs `model.aliases.<name>` (string curta)
- `hermes model` subcommand (CLI não-interativo)
- Edição direta de `config.yaml`
- REST API: `GET /api/model/options`, `GET /api/model/auxiliary`, `POST /api/model/set` (exemplos com `curl` na doc original)

### 2.5 Context Compression

Config completa em `compression.*` e `auxiliary.compression.*`. Compressão reduz contexto ativo mantendo lineage de sessão (cria sessão "filha" — ver seção 5.4 Auto-Lineage). Hot-reload: mudanças em `compression.*` aplicam sem restart.

`/compress` força compressão manual. Compressão automática dispara perto do limite de contexto do modelo.

### 2.6 Context Engine

`context.engine` seleciona estratégia de montagem de contexto (system prompt + histórico + injeções). Detalhes específicos do engine ficam fora do escopo desta página — ver `-features`/`-features-2` para skills/memory injection.

### 2.7 Iteration Budget, Timeouts & Credential Pools

```yaml
agent:
  max_turns: <int>            # budget de iterações por turno
  api_max_retries: <int>
  reasoning_effort: <string>  # configura esforço de raciocínio do modelo
  tool_use_enforcement: <...> # força uso de tools quando aplicável
  disabled_toolsets: []       # desabilita toolsets globalmente
```

Tabela de timeouts de API por provider documentada na fonte original. Avisos de "context pressure" emitidos quando aproxima do limite. Credential pools suportam múltiplas chaves por provider com estratégias de rotação. Prompt caching: paths Claude usam cache de 1h TTL.

### 2.8 Skills, Memory, File Safety & Tool Output

```yaml
skills:
  config:
    guard_agent_created: <bool>

memory:
  # ver -features para MEMORY.md/USER.md

file_read_max_chars: <int>   # limite de leitura de arquivo

tool_output:
  # limites de truncamento de output de tools
```

Git worktree isolation é configurável para rodar agentes em árvores de trabalho separadas (ver seção 8).

### 2.9 Provider Options & Common Setups

Tabela de opções por provider (Anthropic, OpenRouter, Nous Portal, Copilot, Z.ai, Kimi-coding, MiniMax, etc.) e exemplos de "common setups" combinando main + auxiliary + provider. Variáveis de ambiente legacy mantidas para compatibilidade.

### 2.10 TTS / STT (Voice Mode)

```yaml
voice:
  record_key: "ctrl+b"
  max_recording_seconds: 120
  auto_tts: false
  beep_enabled: true
  silence_threshold: 200
  silence_duration: 3.0
```

`/voice on` ativa modo microfone; `record_key` inicia/para gravação; `/voice tts` ativa respostas falladas. STT (`stt.*`) e TTS (`display.*`/provider-specific) configuráveis por provider (todas as opções documentadas na fonte original — múltiplos backends de TTS suportados).

### 2.11 Display Settings & Privacy

```yaml
display:
  tool_progress: <...>
  runtime_footer: <...>
  file_mutation_verifier: <...>
  language: <...>
  streaming: true
  show_reasoning: true
  resume_display: minimal   # default: full
  busy_input_mode: <...>
  tool_preview_length: <int>
  interim_assistant_messages: true
  platforms:
    telegram:
      streaming: true   # default per-plataforma
    discord:
      streaming: false  # default per-plataforma

privacy:
  redact_pii: <bool>
```

Streaming master switch (`streaming.enabled`) é `false` por default globalmente; uma vez habilitado, comportamento por plataforma segue `display.platforms.<platform>.streaming`. Overflow de mensagem (~4096 chars) finaliza e abre nova mensagem automaticamente. "Fresh final" no Telegram (`fresh_final_after_seconds`, default 60) evita timestamp obsoleto em respostas longas via edição progressiva.

### 2.12 Streaming Detalhado (Gateway)

```yaml
streaming:
  enabled: true
  transport: edit
  edit_interval: 0.3
  buffer_threshold: 40
  cursor: " ▉"
  fresh_final_after_seconds: 60
```

Plataformas sem suporte a edição de mensagem (Signal, Email, Home Assistant) detectam automaticamente e desabilitam streaming sem flood de mensagens.

### 2.13 Outras Configurações Gerais

```yaml
max_concurrent_sessions: null   # null/0 = ilimitado
group_sessions_per_user: true   # isolamento por usuário em grupos/canais
unauthorized_dm_behavior: pair  # pair | ignore

human_delay:
  mode: "off"   # off | natural | custom
  min_ms: 800
  max_ms: 2500

code_execution:
  mode: project   # project | strict
  timeout: 300
  max_tool_calls: 50

web:
  backend: firecrawl   # firecrawl | searxng | parallel | tavily | exa
  search_backend: "searxng"
  extract_backend: "firecrawl"

browser:
  inactivity_timeout: 120
  command_timeout: 30
  record_sessions: false
  cdp_url: ""
  dialog_policy: must_respond   # must_respond | auto_dismiss | auto_accept
  dialog_timeout_s: 300
  camofox:
    managed_persistence: false
    user_id: ""
    session_key: ""
    adopt_existing_tab: false

timezone: "America/New_York"   # IANA timezone, default server-local

discord:
  require_mention: true
  free_response_channels: ""
  auto_thread: true

clarify:
  timeout: 120

delegation:
  max_concurrent_children: 3
  max_spawn_depth: 1
  orchestrator_enabled: true
```

**Web search backends** — tabela de capacidades:

| Backend | Env Var | Search | Extract |
| --- | --- | --- | --- |
| Firecrawl (default) | `FIRECRAWL_API_KEY` | sim | sim |
| SearXNG | `SEARXNG_URL` | sim | não |
| Parallel | `PARALLEL_API_KEY` | sim | sim |
| Tavily | `TAVILY_API_KEY` | sim | sim |
| Exa | `EXA_API_KEY` | sim | sim |

Auto-detecção de backend por chaves disponíveis quando `web.backend` não setado. SearXNG é self-hosted/sem API key, mas search-only.

**Delegation** — subagents herdam provider/model do pai por default; `delegation.provider`/`model`/`base_url` fazem override. `max_concurrent_children` (default 3, sem teto) e `max_spawn_depth` (1-3, default 1 = flat) controlam largura/profundidade da árvore de delegação. Custo escala multiplicativamente (3×3×3=27 leafs no máximo).

**Context Files (SOUL.md, AGENTS.md)** — prioridade: `.hermes.md` → `AGENTS.md` → `CLAUDE.md` → `.cursorrules` (primeiro encontrado vence; SOUL.md sempre carregado independentemente, slot #1 do system prompt). AGENTS.md é hierárquico (combina subdiretórios). Cap de 20.000 chars com truncamento inteligente. Ver [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-personality-soul|hermes-agent-docs-features]] para detalhes do sistema de personalidade/SOUL.md.

> [!note] Comparação com este vault
> O sistema de context files do Hermes (`.hermes.md` > `AGENTS.md` > `CLAUDE.md` > `.cursorrules`, com SOUL.md como identidade base) é estruturalmente equivalente ao par `CLAUDE.md` + memória persistente usado neste vault — reforça o padrão "identidade fixa + instruções de projeto + memória líquida" já documentado em `-features`.

---

## 3. Secrets & Security

### 3.1 Secrets — Overview

Hermes suporta managers externos de secrets para evitar plaintext em `.env`. Token de bootstrap fica em `.env`; o manager resolve os demais. Atualmente: **Bitwarden Secrets Manager**. Outros backends (HashiCorp Vault, AWS Secrets Manager, 1Password CLI) são fáceis de adicionar pela arquitetura existente.

### 3.2 Bitwarden Secrets Manager

**Como funciona:**

1. Cria-se uma **machine account** no Bitwarden Secrets Manager com acesso de leitura a um projeto, gera-se um **access token**.
2. Hermes guarda o token em `~/.hermes/.env` como `BWS_ACCESS_TOKEN`.
3. A cada início (`hermes`, gateway, cron), após carregar `.env`, Hermes chama `bws secret list <project_id>` e injeta as chaves em `os.environ`.
4. Por default, Bitwarden **sobrescreve** valores já presentes no ambiente (`override_existing: true`) — rotação no app web propaga automaticamente.

O binário `bws` é auto-baixado em `~/.hermes/bin/` no primeiro uso, com verificação SHA-256.

**Por que machine accounts (sem 2FA):** machine accounts não são 2FA-gated (sem humano no loop) — o token é a credencial. Setup do machine account acontece no app web (onde 2FA normal aplica); depois disso o token é autônomo.

**Setup:**

1. No app web Bitwarden: criar/escolher Project, adicionar secrets (nome = nome da env var, ex. `OPENROUTER_API_KEY`), criar Machine Account com Read access ao projeto, gerar Access Token (prefixo `0.`, não recuperável depois).
2. Rodar wizard:

```bash
hermes secrets bitwarden setup
```

Faz: baixa/verifica `bws v2.0.0`, prompt para token (stored em `.env`), pergunta região (US Cloud / EU Cloud / self-hosted → `secrets.bitwarden.server_url`), lista projects (→ `secrets.bitwarden.project_id`), test-fetch, seta `enabled: true`.

Setup não-interativo:

```bash
hermes secrets bitwarden setup \
  --access-token "$BWS_ACCESS_TOKEN" \
  --server-url https://vault.bitwarden.eu \
  --project-id <project-uuid>
```

3. Confirmar: `hermes secrets bitwarden status`

**CLI:**

| Comando | Ação |
| --- | --- |
| `hermes secrets bitwarden setup` | Wizard interativo |
| `hermes secrets bitwarden status` | Mostra config + versão do binário + presença do token |
| `hermes secrets bitwarden sync` | Dry-run: mostra o que seria aplicado |
| `hermes secrets bitwarden sync --apply` | Aplica no ambiente do shell atual |
| `hermes secrets bitwarden install` | Baixa apenas o binário `bws` |
| `hermes secrets bitwarden disable` | `enabled: false`, mantém token/project id |

**Configuração:**

```yaml
secrets:
  bitwarden:
    enabled: false
    access_token_env: BWS_ACCESS_TOKEN
    project_id: ""
    server_url: ""
    cache_ttl_seconds: 300
    override_existing: true
    auto_install: true
```

| Key | Default | Descrição |
| --- | --- | --- |
| `enabled` | `false` | Master switch |
| `access_token_env` | `BWS_ACCESS_TOKEN` | Nome da env var do token bootstrap |
| `project_id` | `""` | UUID do projeto |
| `server_url` | `""` | Região/endpoint (`""` = US Cloud; EU = `https://vault.bitwarden.eu`) |
| `cache_ttl_seconds` | `300` | TTL de cache do fetch (0 = sem cache, por processo) |
| `override_existing` | `true` | Bitwarden sobrescreve env existente |
| `auto_install` | `true` | Auto-baixa `bws` |

**Failure modes** (nunca bloqueia o startup — warning em stderr e continua com `.env`): token ausente/revogado, region mismatch (`invalid_client`), timeout de rede, binário indisponível, checksum mismatch — cada um com fix documentado na fonte original.

**Segurança:** o `BWS_ACCESS_TOKEN` é em si sensível (trate como API key de alto valor); Hermes recusa deixar Bitwarden sobrescrever o próprio token bootstrap.

**Quando NÃO usar:** setups single-machine onde `.env` já basta, ambientes air-gapped, CI/CD com mecanismo de secrets próprio já estabelecido. Bom caso: fleets multi-máquina, dev boxes compartilhadas, VPSes de gateway — rotação/revogação centralizadas.

### 3.3 Security — Defense-in-Depth Model

Sete camadas de segurança:

1. **User authorization** — allowlists, DM pairing
2. **Dangerous command approval** — human-in-the-loop para operações destrutivas
3. **Container isolation** — Docker/Singularity/Modal com hardening
4. **MCP credential filtering** — isolamento de env vars para subprocessos MCP
5. **Context file scanning** — detecção de prompt injection em arquivos de projeto
6. **Cross-session isolation** — sessões não acessam dados/estado umas das outras; paths de cron hardened contra path traversal
7. **Input sanitization** — parâmetros de working directory validados contra allowlist (anti shell injection)

#### Dangerous Command Approval

```yaml
approvals:
  mode: manual          # manual | smart | off
  timeout: 60
  cron_mode: deny        # deny | approve
  mcp_reload_confirm: true
  destructive_slash_confirm: true
```

| Mode | Comportamento |
| --- | --- |
| `manual` (default) | Sempre pede aprovação para comandos perigosos |
| `smart` | LLM auxiliar avalia risco; baixo risco auto-aprova, alto risco auto-nega, incerto escala para manual |
| `off` | Desabilita toda checagem — equivalente a `--yolo` |

> [!warning]
> `approvals.mode: off` desabilita todos os prompts de segurança. Usar só em ambientes confiáveis (CI/CD, containers).

**YOLO mode** — bypassa aprovação para a sessão atual. Ativação: flag `hermes --yolo`/`hermes chat --yolo`, slash command `/yolo` (toggle), ou env var `HERMES_YOLO_MODE=1`. Indicadores visuais persistentes (banner vermelho + fragmento `⚠ YOLO` na status bar).

> [!danger]
> YOLO desabilita TODAS as checagens de segurança de comandos — EXCETO o hardline blocklist.

**Hardline Blocklist (sempre ativo)** — comandos catastróficos irreversíveis bloqueados independente de `--yolo`/`approvals.mode: off`/cron `approve`/"allow always". Inclui: `rm -rf /` e variantes, fork bombs, `mkfs` em device root montado, `dd if=/dev/zero of=/dev/sd*`, pipe de URLs não confiáveis para `sh` no root do filesystem.

**Approval timeout** — se sem resposta dentro de `approvals.timeout` (default 60s), comando é **negado** (fail-closed).

**What Triggers Approval** — tabela extensa de patterns: `rm -r`/`rm .../`, `chmod 777/666`/`o+w`/`a+w`, `chown -R root`, `mkfs`, `dd if=`, `> /dev/sd`, SQL `DROP`/`DELETE` sem WHERE/`TRUNCATE`, `> /etc/`, `systemctl stop/restart/disable/mask`, `kill -9 -1`/`pkill -9`, fork bombs, `bash -c`/`sh -c`/etc, `python -e`/`perl -e`/etc, `curl|sh`/`wget|sh`, process substitution `bash <(curl ...)`, `tee`/redirect para `/etc/`, `~/.ssh/`, `~/.hermes/.env`, `xargs rm`, `find -exec rm`/`find -delete`, `cp`/`mv`/`install` para `/etc/`, `sed -i` em `/etc/`, self-kill de hermes/gateway, `gateway run &`/`disown`/`nohup`/`setsid`.

> [!note] Container bypass
> Em backends `docker`/`singularity`/`modal`/`daytona`, checagens de comando perigoso são **skipadas** — o container é a fronteira de segurança.

**Approval Flow (CLI)** — dialog inline com 4 opções: **once**, **session**, **always** (salva em `command_allowlist` no `config.yaml`), **deny** (default).

**Approval Flow (Gateway)** — agente envia detalhes do comando no chat; usuário responde `yes`/`y`/`approve`/`ok`/`go` ou `no`/`n`/`deny`/`cancel`. `HERMES_EXEC_ASK=1` setado automaticamente no gateway.

**Permanent allowlist:**

```yaml
command_allowlist:
  - rm
  - systemctl
```

#### User Authorization (Gateway)

Ordem de checagem (`_is_user_authorized()`):

1. Per-platform allow-all flag (ex. `DISCORD_ALLOW_ALL_USERS=true`)
2. DM pairing approved list
3. Platform-specific allowlists (ex. `TELEGRAM_ALLOWED_USERS=...`)
4. Global allowlist (`GATEWAY_ALLOWED_USERS=...`)
5. Global allow-all (`GATEWAY_ALLOW_ALL_USERS=true`)
6. Default: deny

```bash
TELEGRAM_ALLOWED_USERS=123456789,987654321
DISCORD_ALLOWED_USERS=111222333444555666
WHATSAPP_ALLOWED_USERS=15551234567
SLACK_ALLOWED_USERS=U01ABC123
GATEWAY_ALLOWED_USERS=123456789
DISCORD_ALLOW_ALL_USERS=true
GATEWAY_ALLOW_ALL_USERS=true
```

> [!warning]
> Sem allowlists configuradas e sem `GATEWAY_ALLOW_ALL_USERS`, **todos os usuários são negados** — gateway loga warning no startup.

**DM Pairing System** — usuários desconhecidos recebem código de pairing de 8 chars (alfabeto sem 0/O/1/I, gerado com `secrets.choice()`), owner aprova via `hermes pairing approve <platform> <code>`. TTL 1h, rate limit 1/10min por usuário, max 3 pending por plataforma, lockout após 5 falhas (1h). Armazenamento: `~/.hermes/pairing/{platform}-pending.json`, `-approved.json`, `_rate_limits.json` (chmod 0600).

```yaml
unauthorized_dm_behavior: pair   # pair | ignore
whatsapp:
  unauthorized_dm_behavior: ignore
```

#### Container Isolation (Docker backend)

```python
_BASE_SECURITY_ARGS = [
    "--cap-drop", "ALL",
    "--cap-add", "DAC_OVERRIDE",
    "--cap-add", "CHOWN",
    "--cap-add", "FOWNER",
    "--security-opt", "no-new-privileges",
    "--pids-limit", "256",
    "--tmpfs", "/tmp:rw,nosuid,size=512m",
    "--tmpfs", "/var/tmp:rw,noexec,nosuid,size=256m",
]
```

`SETUID`/`SETGID` adicionados condicionalmente apenas no path de privilege-drop do s6 (containers que iniciam como root). `/run` tmpfs montado por imagem (`noexec` default, `exec` para imagens s6-overlay).

```yaml
terminal:
  backend: docker
  docker_image: "nikolaik/python-nodejs:python3.11-nodejs20"
  docker_forward_env: []
  container_cpu: 1
  container_memory: 5120
  container_disk: 51200
  container_persistent: true
```

Persistent mode bind-mounta `/workspace` e `/root` de `~/.hermes/sandboxes/docker/<task_id>/`; ephemeral usa tmpfs (perde tudo no cleanup).

**Terminal Backend Security Comparison:**

| Backend | Isolamento | Dangerous Cmd Check | Melhor para |
| --- | --- | --- | --- |
| local | Nenhum (host) | sim | Dev, usuários confiáveis |
| ssh | Máquina remota | sim | Rodar em servidor separado |
| docker | Container | não (container é a fronteira) | Gateway produção |
| singularity | Container | não | HPC |
| modal | Cloud sandbox | não | Isolamento cloud escalável |
| daytona | Cloud sandbox | não | Workspaces cloud persistentes |

#### Environment Variable Passthrough

Dois mecanismos liberam env vars específicas para sandboxes:

1. **Skill-scoped (automático)** — skill declara `required_environment_variables` no frontmatter; vars setadas no ambiente são auto-registradas como passthrough para `execute_code`, `terminal` local e remote backends (Docker, Modal). Desde v0.5.1, `docker_forward_env` e skill passthrough são unificados.
2. **Config-based (manual):**

```yaml
terminal:
  env_passthrough:
    - MY_CUSTOM_KEY
    - ANOTHER_TOKEN
```

**Credential file passthrough** — skills declaram `required_credential_files` (ex. `google_token.json`); Hermes monta read-only no Docker (`-v host:container:ro`), sincroniza no Modal, no-op em local. Também configurável manualmente:

```yaml
terminal:
  credential_files:
    - google_token.json
    - my_custom_oauth_token.json
```

Paths relativos a `~/.hermes/`, montados em `/root/.hermes/` no container.

**What Each Sandbox Filters** — tabela: `execute_code` bloqueia vars com `KEY`/`TOKEN`/`SECRET`/`PASSWORD`/`CREDENTIAL`/`PASSWD`/`AUTH` no nome; `terminal` local bloqueia vars de infra Hermes; Docker/Modal não passam env por default exceto passthrough; MCP bloqueia tudo exceto safe vars + `env` config explícito.

#### MCP Credential Handling

Apenas `PATH, HOME, USER, LANG, LC_ALL, TERM, SHELL, TMPDIR` + `XDG_*` passam para subprocessos MCP stdio por default. Vars explícitas em `mcp_servers.<server>.env` também passam. Erros de tools MCP têm credenciais redigidas (`[REDACTED]`): GitHub PATs (`ghp_...`), OpenAI-style keys (`sk-...`), Bearer tokens, `token=`/`key=`/`API_KEY=`/`password=`/`secret=`.

#### Website Blocklist & SSRF Protection

```yaml
security:
  website_blocklist:
    enabled: true
    domains:
      - "*.internal.company.com"
      - "admin.example.com"
      - "*.local"
    shared_files:
      - "/etc/hermes/blocked-sites.txt"
```

Aplica a `web_search`, `web_extract`, `browser_navigate` e todas as tools com URL. Suporta domínios exatos, wildcard de subdomínio, wildcard de TLD. Shared files: uma regra por linha, comentários `#`. Cache de policy de 30s.

**SSRF protection** (sempre ativa, fail-closed em falha de DNS): bloqueia redes privadas (RFC 1918), loopback, link-local (inclui metadata cloud `169.254.169.254`), CGNAT/RFC 6598 (Tailscale/WireGuard), hostnames de metadata cloud (`metadata.google.internal`), endereços reservados/multicast. Redirect chains revalidados a cada hop.

Opt-out global para casos legítimos (LAN Ollama, redes home):

```yaml
security:
  allow_private_urls: true   # default: false
```

Host-substring guard (anti-homograph) permanece ativo independente dessa flag.

#### Tirith Pre-Exec Scanning

Integração com [tirith](https://github.com/sheeki03/tirith) para scanning de conteúdo antes da execução — detecta homograph URL spoofing, pipe-to-interpreter, terminal injection. Auto-instala via GitHub releases com verificação SHA-256 (+ cosign se disponível).

```yaml
security:
  tirith_enabled: true
  tirith_path: "tirith"
  tirith_timeout: 5
  tirith_fail_open: true
```

`tirith_fail_open: true` (default) permite execução se tirith indisponível/timeout. Em plataformas sem binário prebuilt (Windows), tirith é skipado silenciosamente — usar WSL para tirith no Windows.

#### Context File Injection Protection

Arquivos de contexto (AGENTS.md, .cursorrules, SOUL.md) são escaneados antes de entrar no system prompt: instruções para ignorar prompts anteriores, comentários HTML ocultos suspeitos, tentativas de ler `.env`/credentials/`.netrc`, exfiltração via `curl`, caracteres Unicode invisíveis (zero-width, bidi overrides). Arquivos bloqueados mostram `[BLOCKED: ... contained potential prompt injection ...]`.

#### Best Practices — Production Deployment

Checklist: allowlists explícitas (nunca `GATEWAY_ALLOW_ALL_USERS=true` em prod), `terminal.backend: docker`, limites de recursos apropriados, secrets em `.env` com permissões corretas, DM pairing em vez de hardcode de IDs, auditar `command_allowlist` periodicamente, `terminal.cwd` longe de diretórios sensíveis, nunca rodar gateway como root, monitorar `~/.hermes/logs/`, `hermes update` regular.

**Network isolation** — para máxima segurança, gateway em máquina/VM separada via `terminal.backend: ssh`, com credenciais SSH em `.env` (não `config.yaml`), separando conexões de mensageria da execução de comandos do agente.

#### Supply-chain Advisory Checking

Scanner built-in que flagra pacotes Python na venv ativa que batem com catálogo de versões comprometidas conhecidas (supply-chain worms — ex. poisoning de `mistralai 2.4.6` em maio/2026). Implementação em `hermes_cli/security_advisories.py`.

Como roda: banner de warning no startup CLI (aponta para `hermes doctor`), `hermes doctor` mostra advisories ativos com remediação passo-a-passo, gateway loga em `gateway.log` + banner no primeiro turno interativo. Cada advisory tem id estável; dismiss com `hermes doctor --ack <advisory-id>` (persiste em `config.security.acked_advisories`). Advisories antigos não são removidos do catálogo (mantém aviso sobre versões poisoned que podem estar em mirror privado). Check é stdlib-only, uma lookup `importlib.metadata.version()` por advisory — seguro rodar a cada startup.

**Lazy install de optional deps** (`tools/lazy_deps.py`) — features que dependem de pacotes opcionais (Mistral TTS, ElevenLabs, Honcho, Bedrock, Slack, Matrix) instalam lazily no primeiro uso em vez de via `hermes-agent[all]`. Resolve fragilidade (um dep poisoned/yanked não quebra `[all]` inteiro) e bloat. Guarantees: venv-scoped only (nunca system Python), PyPI by name only (sem `--index-url`/`git+`/`file:` — config.yaml malicioso não redireciona install), allowlist (`LAZY_DEPS` map in-tree), opt-out (`security.allow_lazy_installs: false`), sem retries silenciosos (`FeatureUnavailable` com pip stderr).

```yaml
security:
  allow_lazy_installs: false   # default: true
```

> [!note] Relação com guard
> O modelo de defense-in-depth do Hermes (hardline blocklist como "floor" abaixo de `--yolo`, approval modes manual/smart/off, container bypass) é o paralelo direto do approval-floor pattern já documentado em [[04-SYSTEM/agents/core/guard]] e discutido em `-reference` — útil como referência de design ao revisar políticas do `guard`.

---

## 4. Profiles & Multi-Agent

### 4.1 Profiles — Conceito

Profiles são diretórios `HERMES_HOME` isolados — cada um com seu próprio `config.yaml`, `.env`, `SOUL.md`, `sessions/`, `memories/`, `state.db`. Permitem rodar múltiplos agentes independentes (bots diferentes, contas diferentes, ambientes de teste) na mesma máquina.

**Criação:**

```bash
hermes profile create <name>                    # vazio
hermes profile create <name> --clone <source>   # clona config de outro profile
hermes profile create <name> --clone-all        # clona tudo (incl. memórias/sessões)
hermes profile create <name> --clone-from <path>
```

Nota: Honcho (memory provider externo) tem comportamento especial em clones — ver `-features-2`.

**Uso:**

- Flag `-p <profile>` em qualquer comando: `hermes -p work chat`
- Sticky default: `hermes profile use <name>` — define profile default para a sessão de shell
- Verificar profile ativo via status bar / `hermes profile show`
- Command aliases podem ser criados por profile

### 4.2 Profiles vs Workspaces vs Sandboxing

Profiles isolam **identidade/config/memória/sessões** do agente. `terminal.cwd` (por profile) controla o **working directory** — diferente de isolamento de execução (que é função do `terminal.backend`, ver seção 2.2/3.3). Um profile pode ter `terminal.backend: docker` para sandboxing completo, independente de outros profiles.

### 4.3 Gateways por Profile

Cada profile pode rodar seu próprio gateway com tokens de bot diferentes (Telegram/Discord/Slack distintos). Token locks evitam dois processos usando o mesmo bot token simultaneamente. Gateways podem rodar como serviços persistentes (LaunchAgent/systemd — ver seção 4.6). Em Docker, múltiplos profiles rodam como service slots s6 dentro do mesmo container (ver seção 7).

### 4.4 Gerenciando Profiles

```bash
hermes profile list
hermes profile show <name>
hermes profile rename <old> <new>
hermes profile export <name> <path>
hermes profile import <path>
hermes profile delete <name>
```

Tab completion disponível para nomes de profile. Internamente, `HERMES_HOME` env var é resolvida via `get_hermes_home()` — 119+ pontos no código resolvem paths através dessa função, garantindo isolamento completo entre profiles.

### 4.5 Profile Distributions

Uma **profile distribution** é um repositório git que empacota um agente completo e compartilhável: manifest `distribution.yaml`, `SOUL.md`, `config.yaml`, `skills/`, `cron/`, `mcp.json`.

**Por que git:** versionamento, tags de release, diff entre versões, distribuição via clone/pull padrão.

**Lifecycle — Authors:**

1. Criar profile → adicionar `distribution.yaml` → push para repo git → tag de releases versionadas
2. Distinção entre arquivos **distribution-owned** (atualizados por `update`) vs **user-owned** (preservados — customizações locais)

**Lifecycle — Installers:**

```bash
hermes profile install <git-url>                # instala distribution
hermes profile install <git-url> --name <novo-nome>  # override nome do profile
# preenchimento de env vars necessárias é solicitado
hermes profile show <name>                      # ver o que foi instalado
hermes profile update <name>                    # atualiza para versão mais recente
hermes profile uninstall <name>
```

**Recipes:** pin de versão (tag específica), checar versão instalada, manter customizações locais durante update, force clean reinstall, fork + customize, testar localmente antes de push.

**O que NUNCA está em uma distribution** (hard-excluded): `auth.json`, `.env`, `memories/`, `sessions/`, `state.db*`, `logs/`, `workspace/`, `plans/`, `home/`, `*_cache/`, `local/`. Segurança: distributions de terceiros devem ser tratadas como código — revisar antes de instalar (podem incluir skills com `required_environment_variables` que solicitam credenciais).

**Use cases:** sync pessoal entre máquinas, distribuição em equipe, comunidade (templates públicos), produtos (agente pré-configurado para um nicho), setups efêmeros (CI/teste).

### 4.6 Running Many Gateways at Once

Quick start: criar N profiles, configurar cada um com bot token próprio, instalar e iniciar N gateways.

**Gerenciar um profile:**

```bash
hermes -p <profile> gateway run       # foreground
hermes -p <profile> gateway start     # background/service
hermes -p <profile> gateway stop
hermes -p <profile> gateway restart
hermes -p <profile> gateway status
hermes -p <profile> gateway install   # instala como serviço do sistema
hermes -p <profile> gateway uninstall
```

**Service files:**

| Plataforma | Local |
| --- | --- |
| macOS | LaunchAgent (`~/Library/LaunchAgents/`) |
| Linux | systemd user service |

**Start/stop/restart todos de uma vez** — wrapper script `hermes-gateways` (shell) itera sobre profiles instalados.

**Logs** — por profile, em diretórios separados; `tail -f` múltiplos simultaneamente.

**Identificar o que está rodando** — comandos de status por profile + lista de processos.

**Manter o host ativo:**

- macOS: `caffeinate` com flags específicas (tabela na fonte original)
- Linux: `systemd-inhibit` / `loginctl`

**Token-conflict safety** — comando de audit (`grep`) para garantir que tokens de bot não se repetem entre profiles.

**Troubleshooting:** erro de launchd, PID obsoleto, hard reset, health check — procedimentos documentados na fonte original.

---

## 5. Sessions

### 5.1 Como Sessões Funcionam

Toda conversa (CLI, Telegram, Discord, Slack, WhatsApp, Signal, Matrix, Teams, etc.) é armazenada como sessão com histórico completo em **SQLite** (`~/.hermes/state.db`, com FTS5 full-text search). Campos: session ID, source platform, user ID, título único, modelo/config, snapshot do system prompt, histórico completo (role/content/tool calls/results), token counts, timestamps, parent session ID (para lineage de compressão).

**O que conta para o contexto:** Hermes não re-envia tudo que já processou — cada turno vê system prompt selecionado + janela de conversa atual + injeções explícitas do turno. Anexos de mídia são turn-scoped: imagens analisadas uma vez (vision ou descrição textual se sem vision nativo), áudio transcrito via STT, documentos de texto incluem texto extraído. Bytes crus de mídia não são recopiados em turnos futuros — apenas paths/descrições/respostas ficam no transcript. Causa mais comum de crescimento de contexto: texto verboso (logs, diffs grandes, transcripts colados) — preferir resumos/paths/tool-backed lookups.

**Session sources** — tabela com 21 valores: `cli`, `telegram`, `discord`, `slack`, `whatsapp`, `signal`, `matrix`, `mattermost`, `email`, `sms`, `dingtalk`, `feishu`, `wecom`, `weixin`, `bluebubbles`, `qqbot`, `homeassistant`, `webhook`, `api-server`, `acp`, `cron`, `batch`.

### 5.2 CLI Session Resume

```bash
hermes --continue   # ou -c — resume sessão CLI mais recente
hermes chat --continue

hermes -c "my project"   # resume por título (lineage mais recente automaticamente)

hermes --resume 20250305_091523_a1b2c3d4   # ou -r
hermes --resume "refactoring auth"          # por título
```

Session IDs: formato `YYYYMMDD_HHMMSS_<hex>` — CLI/TUI usam sufixo hex de 6 chars, gateway usa 8 chars. Resumível por ID (completo ou prefixo único) ou título, com `-c` e `-r`.

**Recap panel ao resumir** — painel estilizado mostrando últimas 10 trocas: mensagens user (●) e assistant (◆), truncadas (300/200 chars), tool calls colapsados em contagem, sistema/tool results/reasoning ocultos, dim styling.

```yaml
display:
  resume_display: minimal   # default: full
```

### 5.3 Cross-Platform Handoff

`/handoff <platform>` transfere sessão CLI ativa para o canal home de uma plataforma — mesmo session id, transcript completo com tool calls.

```bash
/handoff telegram
```

Fluxo: (1) valida plataforma habilitada + home channel configurado (`/sethome` na origem); (2) marca sessão pending e block-polls o gateway (refusa se agente está mid-turn); (3) gateway watcher cria thread fresco no destino — Telegram (forum topic), Discord (thread auto-archive 1440min), Slack (seed message + thread ts), WhatsApp/Signal/Matrix/SMS (fallback para home channel direto); (4) gateway re-binda destino à sessão CLI existente, forja turno sintético pedindo confirmação/resumo; (5) ao sucesso, CLI imprime hint de `/resume` e sai.

**Resume de volta ao CLI:** `/resume <título>` ou `hermes -r "<título>"`.

**Failure modes:** sem home channel (`/sethome` hint), plataforma desabilitada/gateway off (timeout 60s, sessão CLI intacta), falha de criação de thread (fallback para home channel, handoff completa sem isolamento), falha de `adapter.send` (marcado failed, retry possível).

**Limitação:** plataformas sem thread e grupos multi-user — turno sintético chaveia como sessão DM-style (funciona para self-DM home channel típico, não ideal para grupos genuinamente compartilhados).

### 5.4 Session Naming & Auto-Lineage

**Auto-generated titles** — Hermes gera título descritivo (3-7 palavras) após a primeira troca, via auxiliary model em background thread (sem latência adicional). Só dispara uma vez por sessão; skip se título já setado manualmente.

**Setting manual:**

```markdown
/title my research project
```

Aplicado imediatamente; se sessão não existe ainda no DB, fica queued. Também via CLI:

```bash
hermes sessions rename 20250305_091523_a1b2c3d4 "refactoring auth module"
```

**Title rules:** único (sem duplicatas), max 100 chars, sanitizado (control chars/zero-width/RTL overrides removidos), Unicode normal OK (emoji, CJK, acentos).

**Auto-lineage on compression** — ao comprimir (`/compress` ou automático), cria sessão de continuação; se a original tinha título, a nova recebe título numerado: `"my project"` → `"my project #2"` → `"my project #3"`. `hermes -c "my project"` resolve automaticamente para a mais recente da lineage.

`/title` funciona em todas as plataformas de mensagem: `/title My Research` (set) ou `/title` (show atual).

### 5.5 Session Management Commands

```bash
# Listar
hermes sessions list                    # últimas 20
hermes sessions list --source telegram
hermes sessions list --limit 50

# Exportar
hermes sessions export backup.jsonl
hermes sessions export telegram-history.jsonl --source telegram
hermes sessions export session.jsonl --session-id 20250305_091523_a1b2c3d4

# Deletar
hermes sessions delete 20250305_091523_a1b2c3d4
hermes sessions delete 20250305_091523_a1b2c3d4 --yes

# Renomear
hermes sessions rename 20250305_091523_a1b2c3d4 "debugging auth flow"
hermes sessions rename 20250305_091523_a1b2c3d4 debugging auth flow  # multi-word sem quotes

# Prune
hermes sessions prune                              # > 90 dias (default)
hermes sessions prune --older-than 30
hermes sessions prune --source telegram --older-than 60
hermes sessions prune --older-than 30 --yes

# Estatísticas
hermes sessions stats
```

`stats` retorna total de sessões/mensagens, breakdown por plataforma, tamanho do DB. Para analytics mais profundos (tokens, custo, tools), usar `hermes insights`. Prune só remove sessões **ended** (ativas nunca são prunadas).

### 5.6 Session Search Tool (`session_search`)

Tool built-in do agente — full-text search via SQLite FTS5 across todas as conversas passadas, com scroll de sessão. Sem chamadas LLM extra, sem truncamento — retorna mensagens reais do DB.

**Três formatos de chamada (inferidos pelos argumentos, sem param `mode`):**

1. **Discovery** (`query`):

```python
session_search(query="auth refactor", limit=3)
```

FTS5 → dedupe por lineage → top N sessões, cada uma com `session_id`, `title`, `when`, `source`, `snippet` (highlight FTS5), `bookend_start` (3 primeiras trocas), `messages` (±5 ao redor do match, anchor flagged), `bookend_end` (3 últimas trocas), `match_message_id`, `messages_before/after`. Wall time típico: 15-50ms.

2. **Scroll** (`session_id` + `around_message_id`):

```python
session_search(session_id="20260510_174648_805cc2", around_message_id=590803, window=10)
```

Janela ± `window` mensagens centrada no anchor, sem FTS5/bookends. Scroll forward: passar `messages[-1].id`; backward: `messages[0].id`. Wall time: 1-2ms.

3. **Browse** (sem args):

```python
session_search()
```

Sessões recentes cronologicamente (títulos, previews, timestamps) — "o que eu estava fazendo".

**FTS5 syntax:** keywords (AND implícito), `"phrase"`, `OR`/`NOT`, prefix `deploy*`.

**Optional params:** `sort` (`newest`/`oldest`, default relevance), `role_filter` (default `user,assistant`; `user,assistant,tool` ou `tool` para debug de tool output).

**Quando é usado:** prompt do agente instrui usar `session_search` quando usuário referencia conversa passada ("fizemos isso antes", "lembra quando", "como mencionei") ou contexto relevante suspeito fora da janela atual.

### 5.7 Per-Platform Session Tracking

**Gateway sessions** — chaveadas deterministicamente:

| Tipo de chat | Formato da chave | Comportamento |
| --- | --- | --- |
| Telegram DM | `agent:main:telegram:dm:<chat_id>` | Uma sessão por chat DM |
| Discord DM | `agent:main:discord:dm:<chat_id>` | Uma sessão por chat DM |
| WhatsApp DM | `agent:main:whatsapp:dm:<canonical_identifier>` | Uma por usuário (LID/phone aliases colapsam) |
| Group chat | `agent:main:<platform>:group:<chat_id>:<user_id>` | Por usuário, se plataforma expõe user ID |
| Group thread/topic | `agent:main:<platform>:group:<chat_id>:<thread_id>` | Compartilhada por default; per-user com `thread_sessions_per_user: true` |
| Channel | `agent:main:<platform>:channel:<chat_id>:<user_id>` | Por usuário, se plataforma expõe user ID |

Sem identificador de participante → fallback para sessão compartilhada da sala.

**Shared vs Isolated:**

```yaml
group_sessions_per_user: true   # default
```

`true`: Alice e Bob no mesmo canal Discord não compartilham transcript; tarefas tool-heavy de um não poluem o contexto do outro; interrupt handling é per-user. `false`: reverte para "room brain" único — contexto compartilhado mas também custos/interrupt state/crescimento de contexto compartilhados.

**Session reset policies:** `idle` (N min de inatividade), `daily` (hora específica), `both` (o que vier primeiro), `none` (nunca). Antes do reset, agente tem um turno para salvar memórias/skills importantes. Sessões com background processes ativos nunca são auto-reset.

### 5.8 Storage Locations & Schema

| O quê | Path | Descrição |
| --- | --- | --- |
| SQLite DB | `~/.hermes/state.db` | Metadata + mensagens, FTS5 |
| Gateway messages | `~/.hermes/state.db` | Store canônico de mensagens |
| Gateway routing index | `~/.hermes/sessions/sessions.json` | Mapeia session keys → session IDs ativos |

WAL mode para concurrent readers + single writer (adequado à arquitetura multi-plataforma do gateway).

> [!note] Legacy JSONL
> Sessões pré-state.db podem ter `*.jsonl` residual em `~/.hermes/sessions/` — não mais lidos/escritos, safe to delete após verificar existência no state.db.

**Tabelas-chave:** `sessions` (metadata — id, source, user_id, model, title, timestamps, token counts; títulos com unique index, NULLs permitidos), `messages` (histórico completo), `messages_fts` (virtual table FTS5).

### 5.9 Expiry e Cleanup

**Automático:**

- Gateway reseta conforme policy configurada
- Antes do reset, agente salva memórias/skills
- Auto-prune opt-in: `sessions.auto_prune: true` → sessões ended mais antigas que `retention_days` (default 90) são prunadas no startup CLI/gateway
- Após prune com remoções, `state.db` é `VACUUM`ed
- Prune roda no máximo 1x por `min_interval_hours` (default 24), timestamp compartilhado dentro do `state.db` (cross-process no mesmo `HERMES_HOME`)

```yaml
sessions:
  auto_prune: true          # default: false
  retention_days: 90
  vacuum_after_prune: true
  min_interval_hours: 24
```

Default off — histórico é valioso para `session_search`; deleção silenciosa surpreenderia usuários. Sessões ativas nunca são auto-prunadas.

**Manual:**

```bash
hermes sessions prune
hermes sessions delete <session_id>
hermes sessions export backup.jsonl
hermes sessions prune --older-than 30 --yes
```

> [!note] Performance
> DB cresce lentamente (~10-15MB para centenas de sessões). Habilitar auto-prune se gateway/cron pesado deixar `state.db` afetar performance (caso observado: 384MB com ~1000 sessões degradando FTS5 inserts e listagem `/resume`).

---

## 6. Desktop App

### 6.1 O Que É

Mesmo agente core do CLI/gateway, com UI desktop nativa. Instalação:

```bash
hermes desktop
```

### 6.2 O Que Tem no App

- **Chat** com status bar — model picker inline, toggle YOLO per-sessão
- **File browser**
- **Voice** — integração com modo voz
- **Settings & onboarding**
- **Management panes** — skills, cron, profiles, messaging, agents
- **Keyboard & navigation**
- **Sessions & profiles** — picker de sessões, troca de profile

### 6.3 Updating / Uninstalling

Update via mecanismo nativo do app ou `hermes update`. Uninstall em 3 níveis (documentados na fonte original — provavelmente: remover app, remover dados de profile, remover `~/.hermes/` completo).

### 6.4 CLI Reference (`hermes desktop`)

Tabela de flags do comando `hermes desktop` (lançamento, profile, modo remoto) — ver fonte original para lista completa.

### 6.5 Connecting to a Remote Backend

Duas formas de autenticação para conectar o desktop app a um backend remoto (gateway/dashboard rodando em outra máquina):

1. **OAuth via Nous Portal**
2. **Username/password** — setup com env vars `HERMES_DASHBOARD_BASIC_AUTH_*`

Passos de setup completos documentados na fonte original.

### 6.6 Troubleshooting & Building from Source

Seção de troubleshooting comum + instruções para build do desktop app a partir do código-fonte.

---

## 7. Docker

### 7.1 Duas Formas de Intersecção

Docker intersecta Hermes de duas formas: (1) como **terminal backend** (`terminal.backend: docker` — isola execução de comandos, ver seção 3.3); (2) como **forma de empacotar/rodar o próprio Hermes** (imagem oficial, gateway/dashboard em container).

### 7.2 Quick Start

```bash
docker run ... setup
```

(comando completo de setup interativo na fonte original — baixa imagem oficial e roda wizard).

### 7.3 Gateway Mode

Container roda sob supervisão **s6-overlay**. API server configurável via env vars.

### 7.4 Dashboard

```bash
HERMES_DASHBOARD=1
```

Tabela de env vars do dashboard + lógica de auth gate (basic auth vs OAuth, ver seção 6.5).

### 7.5 Persistent Volumes

`/opt/data` contém dados persistentes — config, sessions, memories, skills, etc. (tabela completa de conteúdo na fonte original).

### 7.6 Multi-Profile Support

Cada profile roda como **service slot s6** dentro do mesmo container, com comandos de lifecycle próprios (start/stop/restart por profile).

**Por que um container, múltiplos profiles** — tabela comparativa: menor overhead de recursos, logs centralizados, update único, vs. isolamento mais fraco entre profiles (compartilham kernel/namespace do container).

**Quando você QUER containers separados** — exemplo com docker compose (um serviço por profile) quando isolamento entre profiles é requisito (ex. profiles de clientes diferentes).

### 7.7 Onde Vão os Logs

Tabela com 4 superfícies de log: stdout do container (s6), `~/.hermes/logs/` (por profile), `gateway.log`, logs do dashboard.

### 7.8 Environment Variable Forwarding & Compose Example

Forwarding de env vars do host para o container documentado, com exemplo completo de `docker-compose.yml`.

### 7.9 Audio Bridge (Linux Desktop)

Bridge opcional para áudio em desktop Linux (TTS/voice mode dentro do container).

### 7.10 Resource Limits

Tabela de limites de recursos configuráveis (CPU, memória, disco) para o container Hermes.

### 7.11 O Que o Dockerfile Faz

- Base: `debian:13.4`
- Ferramentas incluídas (lista na fonte original)
- ENTRYPOINT `/init` — sequência de boot s6
- Shim de drop de privilégio para `docker exec` (entra como root, dropa para usuário não-root via SETUID/SETGID condicionais — ver seção 3.3)

### 7.12 Per-Profile Gateway Supervision & Upgrading

Supervisão s6 por profile-gateway; processo de upgrade da imagem/container.

### 7.13 Skills e Credential Files

Skills e arquivos de credencial (`required_credential_files` — ver seção 3.3) dentro do container — paths e montagem.

### 7.14 Instalando Mais Ferramentas

Cinco abordagens:

1. `npx`/`uvx` ad-hoc (sem persistência)
2. `apt install` + lembrar de re-instalar (ou script de init)
3. Imagem derivada (`FROM` a imagem oficial + `apt install`)
4. Sidecar container
5. Contribuir upstream (adicionar ao Dockerfile oficial)

### 7.15 Conectando a Inference Servers Locais

vLLM/Ollama via docker compose (serviço adicional na mesma rede) ou standalone (apontando `OPENAI_API_BASE`/equivalente para o host).

### 7.16 Troubleshooting

Seção de troubleshooting comum para deploys Docker — ver fonte original.

---

## 8. Git Worktrees

### 8.1 Por Que Usar com Hermes

Worktrees permitem múltiplos agentes Hermes trabalharem em branches/diretórios diferentes do mesmo repo simultaneamente, sem conflito de working directory.

### 8.2 Quick Start

```bash
git worktree add ../my-feature feature-branch
cd ../my-feature
hermes
```

### 8.3 Rodando Múltiplos Agentes em Paralelo

Cada worktree é um diretório independente — um agente Hermes por worktree, sem interferência de estado de arquivos.

### 8.4 Limpeza Segura

Procedimento para remover worktrees (`git worktree remove`) sem perder trabalho não commitado — checagens antes de remover.

### 8.5 Modo Automático `-w`

```bash
hermes -w
hermes -w -z "implementar feature X"
```

`-w` cria automaticamente um worktree em `.worktrees/` para a sessão, isolando o agente do working directory principal. Combina com `-z` para one-shot em worktree isolado.

### 8.6 Best Practices

Recomendações: nomear worktrees descritivamente, limpar após merge, evitar múltiplos agentes no mesmo worktree simultaneamente.

---

## 9. MCP Config Reference

> [!note] Relação com -features-2/-integrations
> Esta seção é a **referência de configuração** (`mcp_servers:` YAML shape completo) do protocolo MCP. O conceito geral de MCP, casos de uso e exemplos de servidores já estão cobertos em [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-integrations|hermes-agent-docs-integrations]] — aqui o foco é a especificação de config key-by-key, sem duplicar.

### 9.1 Root Config Shape

```yaml
mcp_servers:
  <server_name>:
    # stdio transport
    command: "npx"
    args: ["-y", "@modelcontextprotocol/server-github"]
    env:
      GITHUB_PERSONAL_ACCESS_TOKEN: "ghp_..."

    # OR http/sse transport
    url: "https://mcp.example.com"
    headers:
      Authorization: "Bearer ..."

    # TLS (mTLS)
    ssl_verify: true
    client_cert: "/path/to/cert.pem"
    client_key: "/path/to/key.pem"

    # comuns a ambos transports
    enabled: true
    timeout: 30
    connect_timeout: 10
    supports_parallel_tool_calls: true
    auth: oauth   # opcional — ver 9.7

    tools:
      include: []
      exclude: []
      resources: true
      prompts: true

    sampling:
      # config de sampling, se suportado pelo servidor
```

### 9.2 Server Keys

Tabela de keys no nível do server: `command`/`args`/`env` (stdio), `url`/`headers` (http/sse), `ssl_verify`/`client_cert`/`client_key` (mTLS), `enabled`, `timeout`, `connect_timeout`, `supports_parallel_tool_calls`, `tools`, `auth`, `sampling`.

### 9.3 Tools Policy Keys

```yaml
tools:
  include: ["create_issue", "list_issues"]   # allowlist
  exclude: ["delete_repo"]                    # blocklist
  resources: true
  prompts: true
```

**Filtering semantics:** `include` vence sobre `exclude` — se `include` não vazio, apenas tools listadas são registradas (independente de `exclude`); se `include` vazio, todas as tools menos as em `exclude` são registradas.

**Utility-tool policy:** `list_resources`, `read_resource`, `list_prompts`, `get_prompt` controladas por `resources`/`prompts` independentemente das tools normais.

**Capability-aware registration:** Hermes só registra tools/resources/prompts que o servidor MCP efetivamente anuncia suportar.

`enabled: false` — servidor não é contatado, nenhuma tool registrada (silencioso).

**Empty result behavior** — se `include` resulta em zero tools (typos, tools renomeadas), servidor é registrado sem tools (não é erro fatal).

### 9.4 Exemplos de Config

**Safe GitHub allowlist:**

```yaml
mcp_servers:
  github:
    command: "npx"
    args: ["-y", "@modelcontextprotocol/server-github"]
    env:
      GITHUB_PERSONAL_ACCESS_TOKEN: "ghp_..."
    tools:
      include: ["create_issue", "list_issues", "get_issue", "add_comment"]
```

**Stripe blacklist:**

```yaml
mcp_servers:
  stripe:
    url: "https://mcp.stripe.com"
    auth: oauth
    tools:
      exclude: ["create_refund", "delete_customer"]
```

**Resource-only docs server:**

```yaml
mcp_servers:
  docs:
    command: "npx"
    args: ["-y", "@example/docs-mcp"]
    tools:
      include: []     # nenhuma tool ativa
      resources: true
      prompts: false
```

**TLS client cert / mTLS** (variantes: combinado, separado, encrypted, custom CA):

```yaml
mcp_servers:
  internal-api:
    url: "https://internal-mcp.company.com"
    ssl_verify: true
    client_cert: "/etc/hermes/certs/client.pem"   # combinado cert+key
    # OU separados:
    # client_cert: "/etc/hermes/certs/client-cert.pem"
    # client_key: "/etc/hermes/certs/client-key.pem"
    # client_key pode ser encrypted (prompt de senha)
    # custom CA via ssl_verify: "/path/to/ca-bundle.pem"
```

### 9.5 Reloading Config

```markdown
/reload-mcp
```

Recarrega `mcp_servers:` sem restart completo. Se `approvals.mcp_reload_confirm: true` (default), pede confirmação antes (rebuild invalida o cache de tool schemas no system prompt — próxima mensagem re-envia tokens de input completos).

### 9.6 Tool Naming

Tools MCP são expostas como `mcp_<server>_<tool>`. Hífens e pontos no nome do server/tool são sanitizados (substituídos por underscore) para compatibilidade com nomenclatura de tools.

### 9.7 OAuth 2.1 Authentication

```yaml
mcp_servers:
  <server_name>:
    url: "https://mcp.example.com"
    auth: oauth
```

Quando `auth: oauth`, Hermes conduz o fluxo OAuth 2.1 e persiste o token resultante em `~/.hermes/mcp-tokens/<server>.json`. Reutilizado em invocações subsequentes até expirar/revogar.

---

## Relacionado

- [[03-RESOURCES/entities/Nous-Research]] — organização criadora
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-onboarding]] — instalação, quickstart, config de referência básica
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-personality-soul]] — memory, skills, personality, context files, tools
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-personality-soul-2]] — memory providers externos, plugins, kanban, delegation, cron
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-integrations]] — MCP overview e casos de uso
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-security-model]] — security model (overview), architecture, tips, FAQ
- [[04-SYSTEM/agents/core/guard]] — comparação de approval-floor patterns
- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
