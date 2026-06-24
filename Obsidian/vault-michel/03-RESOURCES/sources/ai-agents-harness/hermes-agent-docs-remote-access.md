---
title: "Hermes Agent Docs: Remote Access"
type: source
source: "Hermes Agent official docs — OAuth over SSH / Remote Hosts (guide)"
created: 2026-06-14
ingested: 2026-06-14
tags: [ai-agents]
---

# Hermes Agent Docs: Remote Access

## Tese central

Quando Hermes roda numa máquina remota, o OAuth loopback redirect (xAI Grok, Spotify, MCP servers remotos) quebra porque o browser do laptop tenta `127.0.0.1:<port>` localmente enquanto o listener está bound no servidor remoto. A solução principal é SSH local-forward; para hosts browser-only sem SSH client existe `--manual-paste`.

## Argumentos principais

- Resolve o problema de **OAuth loopback redirect** (xAI Grok OAuth, Spotify, MCP servers remotos como Linear/Sentry/Atlassian/Asana/Figma) quando Hermes roda numa máquina remota — o browser do laptop tenta `127.0.0.1:<port>` no laptop, mas o listener está bound no servidor remoto.
- **Fix principal — SSH local-forward**: tunnel preserva a URI loopback ponta-a-ponta.
- **`--manual-paste`** (novo, issue #26923) — para hosts browser-only sem SSH client (GCP Cloud Shell, GitHub Codespaces, EC2 Instance Connect, Gitpod). Mesmo PKCE verifier/state/nonce que o fluxo normal — é só mudança de transporte no callback hop, não é downgrade de segurança. Funciona também em `hermes model --manual-paste`.
- **Por que o listener não pode bindar `0.0.0.0`**: xAI e Spotify validam `redirect_uri` contra allowlist que exige forma loopback exata (`http://127.0.0.1:<port>/callback`). O SSH tunnel preserva essa URI loopback ponta-a-ponta.

## Key insights

**SSH local-forward — comandos**:

```bash
# No laptop, terminal separado:
ssh -N -L 56121:127.0.0.1:56121 user@remote-host
# Na sessão SSH existente no remoto:
hermes auth add xai-oauth --no-browser
```

Porta `56121` = xAI; `43827` = Spotify. Hermes imprime a porta exata no log "Waiting for callback on...".

**`--manual-paste`**:

```bash
hermes auth add xai-oauth --manual-paste
# Abrir URL no browser do laptop, aprovar, copiar a URL completa da página que falhou
# (ou ?code=...&state=..., ou o bare code quando a página renderiza o código in-page)
```

**Tabela de portas/necessidade de tunnel**:

| Provider | Loopback port | Tunnel necessário? |
| --- | --- | --- |
| `xai-oauth` (SuperGrok) | 56121 | Sim, se Hermes remoto |
| Spotify | 43827 | Sim, se Hermes remoto |
| MCP servers (`auth: oauth`) | auto per server | Sim, se Hermes remoto |
| `anthropic` (Claude Pro/Max) | n/a | Não — paste-the-code |
| `openai-codex` | n/a | Não — device code |
| `minimax`, `nous-portal` | n/a | Não — device code |

**MCP servers remotos**: duas opções — (1) colar a redirect URL de volta no prompt interativo do Hermes (`?code=...&state=...` também aceito), sem setup extra; (2) SSH port-forward igual xAI/Spotify, útil para fluxos não-interativos/scriptados.

> [!warning] Pitfall — 30s config-reload race
> Editar `~/.hermes/config.yaml` para adicionar um MCP server OAuth dentro de uma sessão Hermes rodando dispara auto-reload de conexões MCP com timeout de 30s — insuficiente para completar OAuth interativo. Usar `hermes mcp login <server>` de um terminal fresco (sem cap, espera até 5min).

## Implicações para o vault

Nenhuma ação direta — referência técnica para eventual operação remota de agentes neste vault.

## Links

- [[03-RESOURCES/entities/hermes]]
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-providers-cloud]]
