---
title: "Hermes Agent Docs: Automation & Cron"
type: source
source: "Hermes Agent official docs — Automate Anything with Cron + Automation Templates + Cron Troubleshooting (guides)"
created: 2026-06-14
ingested: 2026-06-14
tags: [ai-agents]
---

# Hermes Agent Docs: Automation & Cron

## Tese central

Cron jobs no Hermes rodam em sessões frescas sem memória do chat atual — prompts devem ser completamente self-contained. Existem padrões reais documentados (website monitor, weekly report, repo watcher, data pipeline), templates copy-paste para os três tipos de trigger (schedule/GitHub event/API call), e um fluxo de troubleshooting em 3 categorias (jobs not firing, delivery failures, skill loading failures).

## Argumentos principais

- Conceito-chave: cron jobs rodam em sessões frescas sem memória do chat atual — prompts devem ser completamente self-contained.
- **Zero-token alternatives**: para watchdogs recorrentes que já produzem a mensagem exata (alertas de memória/disco, heartbeats) → script-only cron (`no_agent=True`); para one-shot de scripts já em execução (CI, post-commit, deploy) → `hermes send` faz pipe direto pra Telegram/Discord/Slack sem criar cron entry.
- Três tipos de trigger, todos suportam delivery a Telegram/Discord/Slack/SMS/email/GitHub comments/arquivos locais: **Schedule** (cadência hora/noite/semana, tool `cronjob`/`/cron`), **GitHub Event** (PR opens, pushes, issues, CI — webhook platform, `hermes webhook subscribe`), **API Call** (POST JSON externo — webhook platform, config.yaml routes ou `hermes webhook subscribe`).
- Fluxo de troubleshooting tem 3 categorias: Jobs Not Firing, Delivery Failures, Skill Loading Failures.

## Key insights

**5 padrões reais de cron** (complementa o tutorial básico de daily briefing bot e a referência de [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-features-2|Scheduled Tasks/Cron]]):

- **Pattern 1 — Website Change Monitor**: script Python (`~/.hermes/scripts/`) faz fetch+hash, compara com state salvo, imprime `CHANGE DETECTED` ou `NO_CHANGE`. Cron job (`every 1h`) com `--script` lê o stdout e só age se houver mudança. **`[SILENT]` trick**: se a resposta final do agente contém `[SILENT]`, a delivery é suprimida — notifica só quando algo relevante aconteceu.
- **Pattern 2 — Weekly Report**: `hermes cron create "0 9 * * 1" "..." --name "Weekly AI digest" --deliver telegram` — agrega web search, GitHub trending, HN, formata em <500 palavras.
- **Pattern 3 — GitHub Repository Watcher**: `every 6h`, prompt inclui comandos `gh issue list`/`gh pr list` explícitos (filtros de tempo, formatos JSON) — reforça o princípio self-contained.
- **Pattern 4 — Data Collection Pipeline**: script coleta dados (ex: preços crypto via CoinGecko API) e salva em `~/.hermes/data/`; agente analisa tendências depois.
- **Pattern 5**: não capturado no trecho lido da fonte original — provavelmente multi-skill workflow combinando os padrões acima.

**Automation Templates** (recipes copy-paste):

| Trigger | Mecanismo | Tool |
| --- | --- | --- |
| **Schedule** | cadência (hora/noite/semana) | `cronjob` tool / `/cron` |
| **GitHub Event** | PR opens, pushes, issues, CI | Webhook platform (`hermes webhook subscribe`) |
| **API Call** | POST JSON externo | Webhook platform (config.yaml routes / `hermes webhook subscribe`) |

Templates documentados:
- **Nightly Backlog Triage** — `hermes cron create "0 2 * * *"` roda `gh issue list`, sugere prioridade (P0-P3) e categoria (bug/feature/docs/security) para issues novas, digest para Telegram, `[SILENT]` se nada novo.
- **Automatic PR Code Review** — duas opções: (A) dynamic subscription via `hermes webhook subscribe github-pr-review --events pull_request --prompt "..." --skill github-code-review --deliver github_comment`; (B) static route em `config.yaml` com `skills:`, `deliver: github_comment`, `deliver_extra.repo`/`pr_number`. Review cobre segurança, performance, qualidade, testes faltantes.
- **Docs Drift Detection** — scan semanal de PRs merged checando se mudanças em `tools/*.py`, `hermes_cli/commands.py`/`main.py`/`config.py`, env vars têm a doc correspondente atualizada na mesma PR.

**Cron Troubleshooting — Jobs Not Firing**:
1. `hermes cron list` — confirmar estado `[active]` (não `[paused]`/`[completed]`; se completed, repeat count exaurido).
2. Validar expressão de schedule — tabela de exemplos (`0 9 * * *`, `0 9 * * 1`, `every 2h`, `30m`, ISO timestamp). Jobs one-shot desaparecem da lista após disparar (esperado).
3. Gateway precisa estar rodando — ticker de background a cada 60s; sessão CLI normal não dispara cron. Debug manual: `hermes cron tick`.
4. Clock/timezone — jobs usam timezone local; comparar `date` com `next_run` de `hermes cron list`.

**Cron Troubleshooting — Delivery Failures**:
1. Targets são case-sensitive e exigem plataforma configurada — tabela completa de requisitos (telegram→`TELEGRAM_BOT_TOKEN`, discord→`DISCORD_BOT_TOKEN`, slack→`SLACK_BOT_TOKEN`+`chat:write`, email→SMTP, local→write access a `~/.hermes/cron/output/`, `origin`→chat onde foi criado). Plataformas extras: mattermost, homeassistant, dingtalk, feishu, wecom, weixin, bluebubbles, qqbot, webhook. Sintaxe `platform:chat_id` para alvo específico. Falha de delivery não impede a execução do job.
2. `[SILENT]` mal configurado — prompt que diz "responda [SILENT] se nada mudou" pode engolir respostas não-vazias acidentalmente; revisar lógica condicional.
3. Permissões de token por plataforma (bot precisa ser admin no Telegram, ter permissão de envio no Discord, escopo `chat:write` no Slack).
4. Response wrapping (`cron.wrap_response: true` por default) pode ser desabilitado se a plataforma não lida bem com header/footer.

**Cron Troubleshooting — Skill Loading Failures**:
1. `hermes skills list` — skill precisa estar instalada antes de ser usada em cron.
2. Nome da skill é case-sensitive e deve casar com o nome da pasta instalada.
3. Cron jobs rodam com toolsets `cronjob`, `messaging`, `clarify` desabilitados — anti-loop (sem cron recursivo), sem DM direto, sem prompts interativos. Skills que dependem desses toolsets não funcionam em cron.
4. Multi-skill ordering: skills carregam na ordem declarada (`--skill context-skill --skill target-skill`) — dependências devem vir primeiro.

## Implicações para o vault

- **Cron `[SILENT]` pattern** e **script-only cron (`no_agent=True`)** são análogos a jobs de automação no `04-SYSTEM/agents/` que evitam custo de LLM para checagens mecânicas.

## Links

- [[03-RESOURCES/entities/hermes]]
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-features-2]]
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-providers-cloud]]
