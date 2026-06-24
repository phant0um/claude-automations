---
title: "Hermes Agent Docs: Webhooks & Pipelines"
type: source
source: "Hermes Agent official docs — Automated GitHub PR Comments with Webhooks + Operate the Teams Meeting Pipeline (guides)"
created: 2026-06-14
ingested: 2026-06-14
tags: [ai-agents]
---

# Hermes Agent Docs: Webhooks & Pipelines

## Tese central

Webhooks oferecem uma alternativa event-driven ao polling por cron para automações como review de PR. O Teams Meeting Pipeline depende de subscriptions do Microsoft Graph que expiram em até 72h — renovação automática é obrigatória em produção, sob risco de falha silenciosa.

## Argumentos principais

- **Automated GitHub PR Comments with Webhooks**: setup completo de review automático de PR via webhook (alternativa ao polling por cron — ver [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-features-2|Features Part 2]] para o cron-based "GitHub PR Review Agent").
- **Prereqs**: `hermes gateway` rodando, `gh` CLI autenticado no host do gateway, URL pública (ou ngrok p/ teste local), admin access no repo (para gerenciar webhooks).
- Campos-chave da config de rota: `secret` (route-level, fallback para `extra.secret` global), `events` (lista de `X-GitHub-Event`; vazio = aceita tudo), `prompt` (template com `{field}`/`{nested.field}` resolvidos do payload), `deliver` (`github_comment` via `gh pr comment`, ou `log`).
- **Importante**: o payload do webhook NÃO contém o diff — o prompt instrui o agente a buscar via `gh pr diff`; toolset `terminal` já vem incluído no `hermes-webhook` default toolset.
- **Operate the Teams Meeting Pipeline**: runbook operacional pós-setup (após habilitar a feature em Teams Meetings — ver Features Part 2).
- Subscriptions do Microsoft Graph expiram em no máximo 72h. Sem renovação, notificações de reunião param silenciosamente após 3 dias — o #1 modo de falha operacional em integrações Graph-backed.

> [!warning] Prompt injection risk
> Payloads de webhook contêm dados controlados pelo atacante (título, commits, descrição da PR). Se o endpoint está exposto à internet, rodar o gateway em ambiente sandboxed (Docker, SSH backend).

> [!warning] Renovação automática é OBRIGATÓRIA em produção
> Subscriptions do Microsoft Graph expiram em no máximo 72h. Sem renovação, notificações de reunião param silenciosamente após 3 dias — o #1 modo de falha operacional em integrações Graph-backed.

## Key insights

**Config de webhook** (`~/.hermes/config.yaml`):

```yaml
platforms:
  webhook:
    enabled: true
    extra:
      port: 8644
      rate_limit: 30
      routes:
        github-pr-review:
          secret: "your-webhook-secret-here"
          events: [pull_request]
          prompt: |
            A pull request event was received (action: {action}).
            PR #{number}: {pull_request.title}
            Branch: {pull_request.head.ref} → {pull_request.base.ref}
            ...
            1. Run: gh pr diff {number} --repo {repository.full_name}
            2. Review the code changes...
            3. Write a concise, actionable review comment and post it.
          deliver: github_comment
          deliver_extra:
            repo: "{repository.full_name}"
            pr_number: "{number}"
```

**Passos de setup do webhook GitHub**: `hermes gateway` → verificar `curl localhost:8644/health` → registrar webhook no GitHub (Settings → Webhooks → Payload URL `/webhooks/github-pr-review`, content-type JSON, secret igual, evento "Pull requests") → GitHub envia `ping` (ignorado silenciosamente, log DEBUG) → abrir PR de teste → comentário em 30-90s → acompanhar via `tail -f logs/gateway.log`.

**Teams Meeting Pipeline — comandos core**:
- `hermes teams-pipeline validate` — validar config snapshot após qualquer mudança.
- `hermes teams-pipeline token-health [--force-refresh]` — checar saúde do token Graph.
- `hermes teams-pipeline subscriptions` — inspecionar subscriptions ativas.
- `hermes teams-pipeline maintain-subscriptions [--dry-run]` — renovar subscriptions próximas de expirar.

**Três opções de automação para `maintain-subscriptions`**:
1. **Hermes cron (recomendado se já roda o gateway)**: script-only cron (`--no-agent --script`) em `~/.hermes/scripts/maintain-teams-subscriptions.sh`, schedule `0 */12 * * *` (12h = 6× headroom contra a janela de 72h), `--deliver local`. Verificar com `hermes cron list`/`hermes cron status`.
2. **systemd timer** (Linux produção): `.service` (oneshot, `ExecStart=hermes teams-pipeline maintain-subscriptions`) + `.timer` companion.
3. (terceira opção não capturada no trecho lido da fonte original).

Página também cobre go-live checklist e rollout worksheet (não detalhados na fonte original).

## Implicações para o vault

Nenhuma ação direta — referência para eventual automação de webhooks/pipelines no vault.

## Links

- [[03-RESOURCES/entities/hermes]]
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-features-2]]
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-providers-cloud]]
