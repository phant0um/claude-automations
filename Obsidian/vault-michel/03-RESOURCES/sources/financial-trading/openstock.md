---
title: OpenStock — Open-Source Stock Market Platform
type: source
created: 2026-04-24
updated: 2026-04-24
tags: [open-source, fintech, nextjs, mongodb, finnhub, tradingview, inngest]
triagem_score: 4
---

# OpenStock

**Repo:** [github.com/Open-Dev-Society/OpenStock](https://github.com/Open-Dev-Society/OpenStock)
**Org:** [[03-RESOURCES/entities/Open-Dev-Society]]
**License:** AGPL-3.0

## O que é

OpenStock é uma alternativa open-source a plataformas de mercado pagas (Bloomberg, etc.). Rastreia preços em tempo real, permite alertas personalizados e explora insights detalhados de empresas. Não é uma corretora — é uma ferramenta de visualização e acompanhamento.

## Tech Stack

| Camada | Tecnologia |
|--------|-----------|
| Frontend | Next.js 15 (App Router), React 19, TypeScript |
| Estilo | Tailwind CSS v4, shadcn/ui, Radix UI, Lucide icons |
| Auth | Better Auth (email/password) + MongoDB adapter |
| Banco | MongoDB + Mongoose |
| Dados de mercado | Finnhub API (símbolos, perfis, notícias) |
| Gráficos | TradingView widgets (candlestick, heatmap, quotes) |
| Automação/AI | Inngest (events, cron, AI via Gemini) |
| Email | Nodemailer (Gmail transport) |
| UI extras | cmdk (command palette), next-themes, react-hook-form |

**Composição de linguagem:** TypeScript 93.4% · CSS 6% · JS 0.6%

## Features Principais

- **Auth:** Email/password com rotas protegidas via middleware Next.js
- **Busca global:** Cmd+K palette; debounced search via Finnhub; popular stocks idle
- **Watchlist:** Por usuário, persistida em MongoDB (símbolo único por usuário)
- **Stock detail:** TradingView charts (candlestick, baseline, technicals), company profile, financials
- **Sentiment insights (opcional):** Reddit, X.com, news, Polymarket via Adanos API
- **Market overview:** Heatmap, quotes, top stories
- **Onboarding personalizado:** País, metas de investimento, tolerância a risco, indústria preferida
- **Email automatizado:** Welcome email personalizado por AI (Gemini via Inngest); Daily news summary por watchlist (cron diário 12h00)

## Integrações de Dados

- **Finnhub:** Dados primários; free tier pode ter delay; real-time requer paid
- **TradingView:** Widgets embeddable; não requer API key separada
- **Adanos:** Sentimento agregado (opcional); cross-source; não substitui Finnhub/TV
- **Inngest workflows:** `user.created` → Welcome Email AI-personalizado; Cron `0 12 * * *` → Daily News

## Setup Rápido

```bash
git clone https://github.com/Open-Dev-Society/OpenStock.git
cd OpenStock && pnpm install
# Configurar .env (MONGODB_URI, FINNHUB_KEY, BETTER_AUTH_SECRET, GEMINI_KEY, NODEMAILER_*)
pnpm dev          # Next.js + Turbopack
npx inngest-cli@latest dev  # Workflows locais
```

Docker: `docker compose up -d mongodb && docker compose up -d --build`

## Estrutura do Projeto

```
app/(auth)/       sign-in, sign-up
app/(root)/       home, stocks/[symbol], help
app/api/inngest/  workflows endpoint
components/ui/    shadcn/radix primitives
lib/actions/      server actions (auth, finnhub, user, watchlist)
lib/inngest/      client, functions, prompts
database/models/  watchlist.model.ts
scripts/          test-db.mjs
```

## Contribuidores

| GitHub | Contribuição |
|--------|-------------|
| ravixalgorithm | Desenvolveu a aplicação completa (auth, UI, API, AI, deploy) |
| Priyanshuu00007 | Logo e identidade visual |
| chinnsenn | Configuração Docker |
| koevoet1221 | Fix de problemas MongoDB Docker |
| ettoreciolli1 | README |

## Conexões no Vault

- [[03-RESOURCES/concepts/ai-strategy-org/open-source-fintech]] — conceito novo
- [[03-RESOURCES/entities/Open-Dev-Society]] — organização por trás do projeto
- Usa [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] via Finnhub e TradingView (analogia ao [[03-RESOURCES/entities/TradingView-MCP]])
- Inngest para automação = mesmo padrão de [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] (event-driven workflows)
- AI-personalized email via Gemini = instância de [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] aplicado a comunicação
