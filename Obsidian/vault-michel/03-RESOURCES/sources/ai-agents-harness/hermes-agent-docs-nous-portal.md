---
title: "Hermes Agent Docs: Nous Portal (Integration)"
type: source
source: "Hermes Agent official docs — Nous Portal (Integration)"
created: 2026-06-14
ingested: 2026-06-14
tags: [ai-agents]
---

# Hermes Agent Docs: Nous Portal (Integration)

## Tese central

Gateway de subscription unificado da Nous Research — forma recomendada de rodar o Hermes Agent. Não é um canal de mensageria per se, mas a integração que simplifica provisionamento de modelo + Tool Gateway que os canais de mensageria consomem.

## Argumentos principais

### Setup de um comando

```bash
hermes setup --portal
```

Roda OAuth, escolhe modelo Nous, seta `provider: nous` em `config.yaml`, liga o Tool Gateway (web/image/TTS/browser).

### O que inclui

- **300+ modelos frontier** com uma fatura só (roteamento via OpenRouter): Claude Opus/Sonnet/Haiku, GPT-5.5 family, Gemini 3 family, DeepSeek V4, Qwen3, Kimi K2.6, Grok 4.3, Hermes-4-70B/405B, etc.
- **Tool Gateway** (5 backends, um login): web search/extract (Firecrawl), image gen (FAL, 9 modelos), TTS (OpenAI), browser automation (Browser Use), terminal sandbox (Modal)
- **Nous Chat** (chat.nousresearch.com) — web UI com o mesmo catálogo
- Sem credenciais em dotfiles — só `~/.hermes/auth.json` (refresh token), JWTs de curta duração mintados por request

## Key insights

> [!warning] Hermes-4 não recomendado para uso como agente
> Hermes-4-70B/405B são modelos chat/reasoning híbridos fortes (matemática, roleplay, long-form), mas **não tunados para tool-calling loop**. Para uso como agente, usar `anthropic/claude-sonnet-4.6`, `openai/gpt-5.5-pro`, `google/gemini-3-pro-preview` ou `deepseek/deepseek-v4-pro`. Aviso oficial da própria Nous Research, não opinião do Hermes.

### Token handling & troubleshooting

JWT de curta duração mintado a cada inference call a partir do refresh token; refresh/retry automático em 401 transitório. Se o refresh token for invalidado (mudança de senha, revoke), é quarantinado localmente — próxima call pede re-autenticação (`hermes auth add nous`).

## Exemplos e evidências

### Comandos úteis

```bash
hermes portal            # login + setup one-shot
hermes portal info       # status: auth, model, tool gateway routing
hermes portal tools      # catálogo detalhado do Tool Gateway
hermes portal open       # abrir página de subscription management
hermes tools             # escolher backend por tool (mix Portal + próprias contas)
```

`hermes tools` permite mixing — ex: usar Tool Gateway para web search/image mas manter Browserbase próprio para browser automation. Opt-in por tool, não all-or-nothing.

### Comparação rápida (Nous Portal)

| Credencial principal | Webhook obrigatório? | Allowlist default |
| --- | --- | --- |
| OAuth (`~/.hermes/auth.json`) | N/A | N/A — provisiona modelo/tools |

## Implicações para o vault

Aviso oficial sobre Hermes-4 não ser recomendado para tool-calling é dado relevante para qualquer nota do vault sobre escolha de modelo para agentes — vale cross-referenciar em [[03-RESOURCES/concepts/learning-cognition/karpathy-four-principles]] ou notas de model routing se houver menção a Hermes-4 como agente.

## Links

- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-integrations]] — visão geral do Messaging Gateway, MCP, Voice Mode
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-persistent-memory]] — Memory, Skills, Personality, Context Files, Tools
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-onboarding]] — Installation, Quickstart, Configuration
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-security-model]] — Security model, Architecture, FAQ
- [[03-RESOURCES/entities/hermes]]
