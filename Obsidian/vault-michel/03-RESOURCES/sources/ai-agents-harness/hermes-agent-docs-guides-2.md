---
title: "Hermes Agent — Official Docs: Guides Part 2 (Local LLMs, Tutorials, Customization, Embedding)"
type: source
created: 2026-06-14
tags: [hermes, ai-agents, official-docs, guides, local-llm, cron, skills, soul, python-library]
---

# Hermes Agent — Official Docs: Guides Part 2

Consolidação de 10 páginas oficiais de tutoriais práticos (`hermes-agent.nousresearch.com/docs/guides/*`), ingeridas em 2026-06-14. Estas páginas são documentação primária do [[03-RESOURCES/entities/hermes|Hermes]] ([[03-RESOURCES/entities/Hermes-Agent|Hermes Agent]]) e complementam [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-guides-1|Guides Part 1]] — aqui o foco é modelos locais/alternativos, automação script-only, três tutoriais end-to-end completos, customização de identidade/skills, e embedding do Hermes como library Python.

---

## 1. Modelos Locais/Alternativos

### 1.1 Run Local LLMs on Mac

Source: `docs/guides/local-llm-on-mac`

Guia para servir um LLM local com API OpenAI-compatível no macOS, full privacy + zero custo de API. Dois backends, ambos Apple Silicon (M1+):

| Backend | Install | Melhor em | Formato |
|---|---|---|---|
| **llama.cpp** | `brew install llama.cpp` | TTFT (time-to-first-token), KV cache quantizado | GGUF |
| **omlx** | [omlx.ai](https://omlx.ai/) | Geração de tokens, Metal nativo | MLX (safetensors) |

**Modelo recomendado para começar:** `Qwen3.5-9B` — cabe em 8GB+ unified memory com quantização. Regra de bolso: tamanho do modelo + KV cache. Q4 9B = ~5GB; KV cache f16 a 128K contexto = ~16GB; com `--cache-type-k q4_0 --cache-type-v q4_0` cai para ~4GB (-75%).

**llama.cpp start:**
```bash
llama-server -m ~/models/Qwen3.5-9B-Q4_K_M.gguf \
  -ngl 99 -c 131072 -np 1 -fa on \
  --cache-type-k q4_0 --cache-type-v q4_0 --host 0.0.0.0
```

**Benchmarks (M5 Max, 128GB, Qwen3.5-9B):**

| Métrica | llama.cpp (Q4_K_M) | MLX (mxfp4) | Vencedor |
|---|---|---|---|
| TTFT avg | **67ms** | 289ms | llama.cpp (4.3x) |
| Geração | 70 tok/s | **96 tok/s** | MLX (+37%) |
| Total (512 tok) | 7.3s | **5.5s** | MLX (-25%) |

**Recomendação por uso:** chat interativo/low-latency → llama.cpp; geração longa/batch → MLX; memória restrita (8-16GB) → llama.cpp (KV cache quantizado é insuperável); múltiplos modelos simultâneos → omlx; compatibilidade Linux → llama.cpp.

**Conectar ao Hermes:** `hermes model` → "Custom endpoint" → URL base + nome do modelo.

**Timeouts automáticos:** Hermes detecta endpoints locais (localhost/LAN) e relaxa timeouts de streaming automaticamente — stream read sobe de 120s (default) para 1800s; stale stream detection é desabilitado. Override via `HERMES_STREAM_READ_TIMEOUT`, `HERMES_STREAM_STALE_TIMEOUT`, `HERMES_API_TIMEOUT`.

### 1.2 Run Nemotron 3 Ultra Free in Hermes Agent

Source: `docs/guides/run-nemotron-3-ultra-free`

Nous Research foi incluída na **Nemotron Coalition** (com NVIDIA) — parceria com Nebius oferece `nvidia/nemotron-3-ultra:free` gratuito no Nous Portal por tempo limitado (4–18 jun 2026, oferta de exemplo da doc). O `:free` suffix é obrigatório para manter no tier sem custo.

**Desktop app (recomendado):** instalar Hermes Desktop → "Let's get you set up" → conectar Nous Portal (criar conta, plano Free, autorizar) → trocar modelo default para `nvidia/nemotron-3-ultra:free` ("Free tier" variant) → "Start chatting".

**CLI:** `curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash` → `hermes setup` → Quick Setup → conectar Nous Portal (plano Free) → selecionar `nvidia/nemotron-3-ultra:free` → `hermes`.

**Trocar depois:** `/model nvidia/nemotron-3-ultra:free` em qualquer sessão, ou `/model` para abrir o picker.

**Troubleshooting:** modelo não aparece → verificar conexão Nous Portal + plano Free (`hermes portal info`); variante errada → re-selecionar com o suffix `:free`; browser não abre (CLI remoto) → ver [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-guides-1|OAuth over SSH]].

### 1.3 xAI Grok OAuth (SuperGrok / X Premium+)

Source: `docs/guides/xai-grok-oauth`

Login OAuth 2.0 PKCE (browser, `accounts.x.ai`) para usar Grok no Hermes **sem `XAI_API_KEY`** — requer assinatura SuperGrok ativa ou X Premium+ (xAI linka automaticamente). Reusa o adapter `codex_responses` (xAI Responses API) — reasoning, tool-calling, streaming e prompt caching funcionam sem mudanças.

| Item | Valor |
|---|---|
| Provider ID | `xai-oauth` |
| Transport | xAI Responses API (`codex_responses`) |
| Modelo default | `grok-4.3` |
| Endpoint | `https://api.x.ai/v1` |
| Auth server | `https://accounts.x.ai` |

O mesmo bearer token cobre **TTS, image gen, video gen e transcrição** direto da xAI — um login só.

**Quick start:** `hermes model` → "xAI Grok OAuth (SuperGrok / X Premium+)" → browser → aprovar → escolher `grok-4.3`. Credenciais salvas em `~/.hermes/auth.json`, refresh automático.

**Login manual:** `hermes auth add xai-oauth`. Remoto/headless: loopback listener fica em `127.0.0.1:56121` na máquina remota — requer `ssh -L 56121:127.0.0.1:56121` ou `--manual-paste` (Cloud Shell, Codespaces, EC2 Instance Connect).

**Modelos disponíveis:** `grok-4.3` (default), `grok-4.20-0309-reasoning`, `grok-4.20-0309-non-reasoning`, `grok-4.20-multi-agent-0309`; imagem `grok-imagine-image`/`-quality`; vídeo `grok-imagine-video` (off por padrão, habilitar em `hermes tools`).

> [!-warning] Tier gating
> xAI pode restringir acesso OAuth por tier — login bem-sucedido mas inferência retorna `HTTP 403` mesmo com assinatura ativa (issue #26847). Fix: definir `XAI_API_KEY` e `hermes config set model.provider xai`.

**Aliases de provider:** `xai-oauth` (canônico), `grok-oauth`, `x-ai-oauth`, `xai-grok-oauth` — todos resolvem para o mesmo provider.

---

## 2. Automação sem LLM

### 2.1 Script-Only Cron Jobs (No LLM)

Source: `docs/guides/cron-script-only`

**No-agent mode** — cron sem chamada de LLM. Um script roda no timer; stdout (se não-vazio) vai para Telegram/Discord/Slack/Signal/etc. Zero tokens, zero loop de agente.

```
scheduler tick (every N min) → run script (bash/python) → stdout → delivery router
```

**Quando usar:** watchdogs de memória/disco/GPU, hooks de CI, métricas periódicas, pollers de eventos externos, heartbeats — qualquer caso onde o stdout do script JÁ É a mensagem. Para casos que exigem raciocínio (sumarizar, escolher destaques), usar cron normal LLM-driven.

**Criar via chat** — o próprio agente decide `no_agent=True` quando a frase é do tipo "alerte-me quando X" / "a cada N minutos verifique Y":

```python
write_file(path="~/.hermes/scripts/memory-watchdog.sh", content='''#!/usr/bin/env bash
ram_pct=$(free | awk '/^Mem:/ {printf "%d", $3 * 100 / $2}')
if [ "$ram_pct" -ge 85 ]; then echo "RAM ${ram_pct}% on $(hostname)"; fi
''')
cronjob(action="create", schedule="every 5m", script="memory-watchdog.sh",
        no_agent=True, deliver="telegram", name="memory-watchdog")
```

**Criar via CLI:**
```bash
hermes cron create "every 5m" --no-agent --script memory-watchdog.sh \
  --deliver telegram --name "memory-watchdog"
hermes cron list
hermes cron run <job_id>
```

**Mapeamento output → delivery:**

| Comportamento do script | Resultado |
|---|---|
| Exit 0, stdout não-vazio | stdout entregue verbatim |
| Exit 0, stdout vazio | tick silencioso |
| `{"wakeAgent": false}` na última linha | tick silencioso (gate compartilhado com jobs LLM) |
| Exit ≠ 0 | alerta de erro entregue |
| Timeout | alerta de erro entregue |

**Regras de script:** devem ficar em `~/.hermes/scripts/` (enforced em criação e execução — paths absolutos, `~/`, `../` rejeitados). `.sh`/`.bash` → `/bin/bash`; qualquer outra extensão → `sys.executable` (Python atual). Shebangs `#!/...` **não** são honrados — interpretador explícito reduz superfície de confiança.

**Lifecycle completo igual aos jobs LLM:** `hermes cron list|pause|resume|edit --schedule|edit --agent|edit --no-agent --script|remove`. Edição `--agent`/`--no-agent` permite alternar entre os dois modos no mesmo job.

**Delivery targets:** `--deliver telegram[:chat_id[:topic_id]]`, `discord:#canal`, `slack:#canal`, `signal:+numero`, `local` (salva em `~/.hermes/cron/output/`). Plataformas com bot-token não exigem gateway rodando no momento do disparo — chamam o REST endpoint direto com credenciais de `~/.hermes/.env`/`config.yaml`.

**Comparação de abordagens:**

| Abordagem | O que roda | Quando usar |
|---|---|---|
| `cronjob --no-agent` | seu script no scheduler do Hermes | watchdogs/alertas recorrentes sem raciocínio |
| `cronjob` (default, LLM) | agente + pre-check script opcional | mensagem requer raciocínio sobre dados |
| OS cron + `curl` → webhook | seu script no scheduler do OS | monitorar saúde do próprio Hermes (independente do gateway) |

Relacionado: [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-skills-system-2|Scheduled Tasks reference]], [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-messaging|Webhook Subscriptions]].

---

## 3. Tutoriais End-to-End

### 3.1 Daily Briefing Bot

Source: `docs/guides/daily-briefing-bot`

Bot que pesquisa tópicos, sumariza e entrega briefing diário via Telegram/Discord — combina web search + cron + delegação + messaging, sem código.

**Fluxo:** 8:00 AM cron dispara → sessão fresca do Hermes → web search → sumarização → delivery.

**Pré-requisitos:** gateway rodando (`hermes gateway install` / `sudo ... --system` / `hermes gateway` foreground), `FIRECRAWL_API_KEY` para web search, messaging opcional (sem messaging → `deliver: "local"` salva em `~/.hermes/cron/output/`).

**Passo 1 — testar manualmente:**
```
hermes
> Search for the latest news about AI agents and open source LLMs.
  Summarize the top 3 stories in a concise briefing format with links.
```

**Passo 2 — criar cron job.** Linguagem natural ou `/cron add`:
```
/cron add "0 8 * * *" "Search the web for the latest news about AI agents
and open source LLMs. Find at least 5 recent articles from the past 24 hours.
Summarize the top 3 most important stories... Format with emoji bullet points
and end with a total story count."
```

**Golden Rule — Self-Contained Prompts:** cron jobs rodam em sessão **completamente fresca**, sem memória de conversas anteriores. O prompt precisa conter TUDO — o que buscar, quantos artigos, formato, tom. "Do my usual morning briefing" não funciona.

**Customizações:**
- **Multi-topic:** um prompt cobrindo 3 áreas (AI/ML, crypto, espaço) com headers e emoji.
- **Delegação paralela:** `/cron` instrui Hermes a delegar 3 sub-agentes (1 por tópico) que pesquisam em paralelo e o agente principal combina — ver [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-skills-system-2|Delegation]].
- **Weekday-only:** `0 8 * * 1-5`.
- **Twice-daily:** dois jobs (8am manhã, 6pm recap).
- **Contexto pessoal:** já que cron não usa memória conversacional, baking de persona/contexto direto no prompt ("You are creating a briefing for a senior ML engineer who cares about...").

**Gestão:** `/cron list`, `/cron remove <id>`, `hermes cron status` (verificar gateway). Padrão genérico: "se você descreve em um prompt, você pode agendar" — monitoramento de concorrente, GitHub repo digests, previsão do tempo, portfolio, health checks, daily joke.

### 3.2 GitHub PR Review Agent

Source: `docs/guides/github-pr-review-agent`

Agente que monitora repos, revisa PRs (bugs, segurança, qualidade) e entrega summary — via polling com cron (funciona detrás de NAT/firewall, sem endpoint público). Alternativa real-time: [webhook-based PR review](https://hermes-agent.nousresearch.com/docs/guides/webhook-github-pr-review).

**Pré-requisitos:** gateway rodando, `gh` CLI autenticado (`gh auth login`), messaging opcional (`deliver: "local"`).

**Passo 1-2 — verificar acesso e teste manual:**
```
Run: gh pr list --repo NousResearch/hermes-agent --state open --limit 3
Review this pull request... Run: gh pr diff 3888 --repo NousResearch/hermes-agent
```

**Passo 3 — criar skill `code-review`** (`~/.hermes/skills/code-review/SKILL.md`) com checklist: Bugs, Security (injection, auth bypass, secrets, SSRF), Performance (N+1, loops, leaks), Style, Tests. Output format por finding: File:Line, Severity (Critical/Warning/Suggestion), problema, fix. Termina com APPROVE/REQUEST_CHANGES/COMMENT.

**Passo 4 — ensinar convenções via memory** ("Remember: in our backend repo we use Python with FastAPI... no raw SQL, só SQLAlchemy ORM...") — memórias persistem para sempre, reviewer aplica sem repetir.

**Passo 5 — cron job (a cada 2h):**
```bash
hermes cron create "0 */2 * * *" \
  "Check for new open PRs and review them.
   Repos: myorg/backend-api, myorg/frontend-app
   1. gh pr list --repo REPO --state open --limit 5 --json number,title,author,createdAt
   2. Para cada PR das últimas 4h: gh pr diff NUMBER --repo REPO; revisar com code-review
   3. Format: ## PR Reviews — today / ### [repo] #[number]: [title] ..." \
  --name "pr-review" --deliver telegram --skill code-review
```

**Outros schedules úteis:** `0 */2 * * *` (2h), `0 9,13,17 * * 1-5` (3x/dia weekday), `0 9 * * 1` (weekly Monday), `30m` (repos de alto tráfego).

**Run on demand:** `hermes cron run pr-review` ou `/cron run pr-review`.

**Going further:**
- **Postar review direto no GitHub:** `gh pr review NUMBER --repo REPO --comment/--request-changes/--approve --body "..."` — requer token `gh` com scope `repo`.
- **Weekly PR Dashboard:** segunda 9am, overview de open PR count, merged na semana, PRs stale (>5 dias), sem reviewer.
- **Multi-repo:** agente processa sequencialmente, sem setup extra.

**Troubleshooting:** `gh: command not found` (gateway roda em ambiente mínimo — garantir `gh` no PATH + restart gateway); reviews genéricas → adicionar skill + ensinar convenções via memory; rate limits → GitHub permite 5.000 req/h, cada review usa ~3-5 (mesmo 100 PRs/dia fica dentro do limite).

### 3.3 Team Telegram Assistant

Source: `docs/guides/team-telegram-assistant`

Bot Telegram compartilhado pela equipe — code help, research, sysadmin, com sessões por usuário e autorização.

**Passo 1 — criar bot via @BotFather:** `/newbot` (display name + username terminando em `bot`) → copiar token. Opcional: `/setdescription`, `/setcommands` (menu: new/model/status/help/stop).

**Passo 2 — configurar gateway:** `hermes gateway setup` (wizard interativo) ou manual em `~/.hermes/.env`:
```bash
TELEGRAM_BOT_TOKEN=7123456789:AAH...
TELEGRAM_ALLOWED_USERS=123456789
```
User ID numérico via [@userinfobot](https://t.me/userinfobot) (não o `@username`, que pode mudar).

**Passo 3 — iniciar gateway:** `hermes gateway` (foreground/teste) → produção: `hermes gateway install` (systemd no Linux, launchd no macOS) ou `sudo hermes gateway install --system` (Linux boot-time). Comandos: `start|stop|status`; logs via `journalctl --user -u hermes-gateway -f` (Linux) ou `~/.hermes/logs/gateway.log` (macOS). `sudo loginctl enable-linger $USER` mantém rodando após logout SSH.

> [!-success] macOS PATH
> O plist do launchd captura o PATH do shell no momento do install — re-rodar `hermes gateway install` após instalar novas tools (Node, ffmpeg).

**Passo 4 — acesso da equipe, duas abordagens:**
- **Allowlist estática:** `TELEGRAM_ALLOWED_USERS=id1,id2,id3` em `.env`, restart gateway.
- **DM Pairing (recomendado):** colega manda DM → bot responde código de pareamento de uso único → colega envia código por outro canal → owner aprova `hermes pairing approve telegram <CODE>` → acesso imediato. Gestão: `hermes pairing list|revoke|clear-pending`.

**Segurança:** nunca `GATEWAY_ALLOW_ALL_USERS=true` em bot com acesso a terminal; pairing codes expiram em 1h; rate limit 1 req/usuário/10min, máx 3 pending/plataforma; 5 falhas → lockout de 1h; dados de pairing com `chmod 0600`.

**Passo 5 — configurar bot:**
- **Home channel** (destino de cron jobs e mensagens proativas): `/sethome` no chat, ou `TELEGRAM_HOME_CHANNEL` + `_NAME` em `.env`.
- **Tool progress display** (`config.yaml`): `display.tool_progress: off|new|all|verbose` — `new` recomendado para messaging. Override por sessão: `/verbose`.
- **SOUL.md** para personalidade — ver seção 4.1.
- **AGENTS.md** com contexto do projeto (stack, CI/CD, convenções) — injetado em todo system prompt; manter conciso.

**Passo 6 — scheduled tasks:** daily standup (PRs/issues/CI das últimas 24h, weekday 9am), server health check (a cada 6h: `df -h`, `free -h`, `docker ps`, reportar anomalias >80%). Gestão via `hermes cron list|status` ou `/cron list|remove`.

> [!-warning] Self-contained prompts
> Mesma regra do Daily Briefing — cron jobs sem memória de conversas anteriores; o prompt precisa de todos os paths/URLs/instruções.

**Production tips:**
- **Docker como terminal backend** para isolar comandos do host: `TERMINAL_BACKEND=docker`, `TERMINAL_DOCKER_IMAGE=nikolaik/python-nodejs:python3.11-nodejs20`, ou em `config.yaml` (`terminal.backend: docker`, `container_cpu`, `container_memory`, `container_persistent`).
- **Update:** `/update` via Telegram, ou `hermes update && hermes gateway stop && hermes gateway start`.
- **Log locations:** gateway logs (journalctl/`gateway.log`), cron output (`~/.hermes/cron/output/{job_id}/{timestamp}.md`), cron defs (`~/.hermes/cron/jobs.json`), pairing (`~/.hermes/pairing/`), sessions (`~/.hermes/sessions/`).
- **Multi-platform:** mesmo gateway roda Discord, Slack, WhatsApp simultaneamente.

---

## 4. Customização

### 4.1 Use SOUL.md with Hermes

Source: `docs/guides/use-soul-with-hermes`

`SOUL.md` é a **identidade primária** — slot #1 do system prompt, define quem o Hermes é, como fala, o que evita. Localização única: `~/.hermes/SOUL.md` (ou `$HERMES_HOME/SOUL.md`).

**Usar para:** tom, personalidade, estilo, diretividade/calor, como lidar com incerteza/discordância/ambiguidade.

**NÃO usar para:** convenções de código, paths, comandos, portas, arquitetura, workflow de projeto — isso é `AGENTS.md`. Regra: se aplica em tudo → SOUL.md; se é de um projeto específico → AGENTS.md.

**First-run:** Hermes semeia um SOUL.md inicial automaticamente se não existir. Se já existe, não sobrescreve; se existe mas vazio, nada é injetado.

**Como Hermes usa:** lê SOUL.md no início da sessão, escaneia contra prompt-injection, trunca se necessário, usa como slot #1 — **substitui completamente** a identidade default embutida. Se ausente/vazio/falha → fallback para identidade default.

**4 estilos de exemplo no doc:** pragmatic engineer, research partner, teacher/explainer, tough reviewer — cada um com seção Style + Avoid.

**SOUL.md forte:** estável, amplamente aplicável, específico em voz, não sobrecarregado de instruções temporárias. **SOUL.md fraco:** repleto de detalhes de projeto, contraditório, micro-gerenciando formato de cada resposta, filler genérico ("be helpful").

**Estrutura sugerida:**
```markdown
# Identity
# Style
# Avoid
# Defaults
```

**SOUL.md vs /personality:** SOUL.md = baseline durável; `/personality` = troca temporária de modo (ex: `/personality teacher` por uma sessão, depois volta ao SOUL base).

**SOUL.md vs AGENTS.md — erro mais comum:**
- SOUL: "Be direct.", "Avoid hype language.", "Push back when the user is wrong."
- AGENTS: "Use pytest, not unittest.", "Frontend lives in `frontend/`.", "API runs on port 8000."

**Workflow prático:** começar do seed → trim → adicionar 4-8 linhas de tom/defaults → conversar → ajustar iterativamente (melhor que "design perfeito" de uma vez).

**Troubleshooting:** Hermes "sounds the same" → checar arquivo correto, não vazio, sessão reiniciada, sem overlay `/personality` dominando; "ignorando partes" → instruções de prioridade maior, conflito interno, arquivo truncado por tamanho, ou trechos parecidos com prompt-injection bloqueados pelo scanner.

> [!note]+ Cross-link com Features
> A seção "2. Skills System" de [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-skills-system|hermes-agent-docs-features]] cobre a especificação técnica de skills (frontmatter, progressive disclosure). Esta seção (4.2) foca em **padrões de uso prático** — buscar, instalar, criar, gerenciar por plataforma.

### 4.2 Working with Skills | Hermes Agent

Source: `docs/guides/work-with-skills`

Skills = documentos de conhecimento on-demand que ensinam workflows específicos.

**Encontrar:** `/skills` (chat) ou `hermes skills list` — lista compacta nome+descrição. Buscar: `/skills search docker`. **Skills Hub** (oficiais opcionais, não ativos por default): `/skills browse`, `/skills search blockchain`.

**Usar:** toda skill instalada é um slash command — `/ascii-art ...`, `/plan ...`, `/github-pr-workflow ...`. Ou via conversa natural (agente carrega via `skill_view`).

**Progressive Disclosure** (3 níveis):
1. `skills_list()` — lista compacta (~3k tokens), carregada no início da sessão
2. `skill_view(name)` — SKILL.md completo, carregado quando o agente decide usar
3. `skill_view(name, file_path)` — arquivo de referência específico, só se necessário

Skills não custam tokens até serem usadas.

**Instalar do Hub:**
```bash
hermes skills install official/research/arxiv
/skills install official/creative/songwriting-and-ai-music
hermes skills install https://sharethis.chat/SKILL.md
```
Copiado para `~/.hermes/skills/`, aparece em `skills_list`, vira slash command. Efeito em novas sessões — `/reset` ou `--now` (custa tokens extra) para sessão atual.

**Plugin-provided skills:** namespace `plugin:skill` (ex: `skill_view("superpowers:writing-plans")`) evita colisão com built-ins. Não aparecem em `skills_list` — opt-in explícito; quando carregadas, mostram banner com skills "sibling" do mesmo plugin.

**Config de skill** via frontmatter (`metadata.hermes.config` — key/description/prompt/url); valores ficam em `config.yaml` sob `skills.config.*`. Gestão: `hermes skills config <skill>`, `hermes config show | grep '^skills\.config'`.

**Criar skill própria** (~5 min):
```bash
mkdir -p ~/.hermes/skills/my-category/my-skill
```
`SKILL.md` com frontmatter (`name`, `description`, `version`, `metadata.hermes.tags/category`) + seções When to Use / Procedure / Pitfalls / Verification. Arquivos de referência opcionais em `references/`, `templates/`, `scripts/` — referenciados via `skill_view("my-skill", "references/api-docs.md")`. Testar: `hermes chat -q "/my-skill ..."`. Sem registro — drop em `~/.hermes/skills/` e está live. Agente também pode criar/atualizar skills via `skill_manage`.

**Per-platform management:** `hermes skills` abre TUI para habilitar/desabilitar skills por plataforma (CLI, Telegram, Discord) — útil para manter skills de dev fora do Telegram.

**Skills vs Memory:**

| | Skills | Memory |
|---|---|---|
| O quê | conhecimento procedural (como fazer) | conhecimento factual (o que é) |
| Quando | on-demand, só quando relevante | injetado toda sessão |
| Tamanho | pode ser grande (centenas de linhas) | compacto |
| Custo | zero até carregar | custo pequeno constante |
| Quem cria | você, agente, ou Hub | agente, baseado em conversas |

Regra de bolso: se você colocaria num documento de referência → skill; se colocaria num post-it → memory.

**Tips:** skills focadas (não "todo o DevOps", sim "deploy app Python no Fly.io"); deixar o agente criar skills após tarefas complexas (capturam pitfalls descobertos); categorizar em subdiretórios; atualizar skills que ficam obsoletas.

---

## 5. Embedding — Using Hermes as a Python Library

Source: `docs/guides/python-library`

Hermes não é só CLI — `AIAgent` pode ser importado e usado em scripts próprios, web apps, pipelines.

**Instalação:**
```bash
pip install git+https://github.com/NousResearch/hermes-agent.git
# ou: uv pip install git+https://github.com/NousResearch/hermes-agent.git
```
Mesmas env vars da CLI — mínimo `OPENROUTER_API_KEY` (ou `OPENAI_API_KEY`/`ANTHROPIC_API_KEY`).

**Uso básico — `chat()`:**
```python
from run_agent import AIAgent
agent = AIAgent(model="anthropic/claude-sonnet-4.6", quiet_mode=True)
response = agent.chat("What is the capital of France?")
```
`chat()` gerencia todo o loop (tool calls, retries) e retorna só o texto final. **Sempre `quiet_mode=True`** ao embedar — senão polui output com spinners/progress.

**Controle total — `run_conversation()`** retorna dict com `final_response` e `messages` (histórico completo). Aceita `system_message` custom (sobrescreve o ephemeral system prompt naquela call). `task_id` é armazenado para VM isolation mas não retornado.

**Toolsets:** `enabled_toolsets=["web"]` (whitelist, agente mínimo locked-down) ou `disabled_toolsets=["terminal"]` (blacklist, mantém maioria mas restringe específicos).

**Multi-turn:** passar `conversation_history` (lista `messages` de resultado anterior) — agente copia internamente, lista original não é mutada.

**Trajectory saving** (`save_trajectories=True`) — salva em `trajectory_samples.jsonl` formato ShareGPT, útil para training data/debug.

**Custom system prompts:** `ephemeral_system_prompt` — guia comportamento sem ser salvo em trajectories (mantém dados de treino limpos). Ideal para agentes especializados (code reviewer, SQL assistant) sobre o mesmo tooling.

**Batch processing:** `batch_runner.py --input prompts.jsonl --output results.jsonl`, ou custom com `ThreadPoolExecutor` — **sempre uma `AIAgent` por thread/task** (estado interno não é thread-safe).

```python
import concurrent.futures
from run_agent import AIAgent

def process_prompt(prompt):
    agent = AIAgent(model="anthropic/claude-sonnet-4", quiet_mode=True, skip_memory=True)
    return agent.chat(prompt)

with concurrent.futures.ThreadPoolExecutor(max_workers=3) as executor:
    results = list(executor.map(process_prompt, prompts))
```

**Integration examples no doc:** FastAPI endpoint (`skip_context_files=True, skip_memory=True` para statelessness), Discord bot (`platform="discord"`), CI/CD step (review de PR diff com `disabled_toolsets=["terminal","browser"]`).

**Key constructor params:**

| Param | Tipo | Default | Descrição |
|---|---|---|---|
| `model` | str | `""` | formato OpenRouter |
| `quiet_mode` | bool | `False` | suprime output CLI |
| `enabled_toolsets`/`disabled_toolsets` | list | `None` | whitelist/blacklist |
| `save_trajectories` | bool | `False` | salva JSONL ShareGPT |
| `ephemeral_system_prompt` | str | `None` | system prompt custom |
| `max_iterations` | int | `90` | limite de tool-calling iterations |
| `skip_context_files` | bool | `False` | não carrega AGENTS.md |
| `skip_memory` | bool | `False` | desliga memória persistente |
| `api_key` / `base_url` | str | `None` | override de credencial/endpoint |
| `platform` | str | `None` | hint de formatação (`"discord"`, `"telegram"`) |

**Notas importantes:** thread safety (1 `AIAgent` por thread), resource cleanup automático ao fim de conversa, `max_iterations=90` é generoso — reduzir para Q&A simples (ex: 10) evita loops e controla custo.

---

## Relacionado

- [[03-RESOURCES/entities/hermes]] — entidade principal
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-providers-cloud]] — Guides Part 1 (providers, cron LLM, webhooks, plugins, delegation, remote access)
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-skills-system]] — Skills System (spec técnica)
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-skills-system-2]] — Scheduled Tasks, Delegation, Memory Providers
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-onboarding]] — Installation, Quickstart, Configuration
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-cli-config]] — Secrets, Profiles, MCP Config
