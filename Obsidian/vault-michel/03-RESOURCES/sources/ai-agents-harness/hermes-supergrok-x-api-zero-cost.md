---
title: "How I'm using Hermes Agent + SuperGrok + X API for $0"
slug: hermes-supergrok-x-api-zero-cost
type: source
category: tools/hermes
author: "@karankendre"
source_url: "https://x.com/karankendre/status/2056098267470205270"
published: 2026-05-17
ingested: 2026-05-18
tags: [hermes, supergrok, xai, grok, x-api, oauth, zero-cost, tools]
triagem_score: 5
---

# How I'm using Hermes Agent + SuperGrok + X API for $0

## Tese central

X Premium / Premium+ subscribers can get Grok-powered AI agent with live X search for $0 extra by connecting Hermes Agent to SuperGrok via OAuth — no separate xAI API key or paid X API tier required.

## Key insights

1. **Zero-cost stack:** X Premium subscription already grants SuperGrok access. Hermes OAuth flow connects to it directly. X search tool in Hermes uses the existing subscription entitlement, not a separate API key.

2. **Setup flow (4 steps):** Install Hermes CLI → `hermes model` → select "xAI Grok OAuth (SuperGrok)" → enable X Search tool in `hermes tools` (off by default — most users miss this step).

3. **X Search tool is opt-in:** not enabled by default. Must toggle on via `hermes tools` → arrow to "X (Twitter) Search" → Space to enable → Enter to save.

4. **Recommended model:** grok-4.3 or latest reasoning model via the OAuth provider.

5. **Cross-platform:** works on Linux, macOS, WSL2.

6. **Gateway extension:** once basics work, `hermes gateway` adds Telegram/Discord control surfaces over the same agent.

7. **OAuth vs API key distinction:** OAuth flow uses browser auth linked to X Premium account. No API tier subscription needed. Common failure: Brave browser blocks auth redirect — use Chrome/Firefox fallback or `--no-browser` device-code flow.

8. **Useful diagnostic commands:** `hermes auth status xai-oauth`, `hermes auth add xai-oauth`, `hermes setup`, `hermes update`.

## Links

- [[03-RESOURCES/entities/hermes]] — Hermes Agent framework; this source covers provider configuration
- [[03-RESOURCES/entities/Hermes-Agent]] — entity with multi-provider support
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]] — tools/skills enabled per session
