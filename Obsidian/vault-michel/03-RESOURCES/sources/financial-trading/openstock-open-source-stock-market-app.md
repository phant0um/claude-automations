---
title: "OpenStock — Open-Source Stock Market App"
type: source
created: 2026-04-24
updated: 2026-04-24
tags: [open-source, stock-market, nextjs, fintech, mongodb, finnhub]
triagem_score: 4
---

# OpenStock — Open-Source Stock Market App

**Repositório:** [github.com/Open-Dev-Society/OpenStock](https://github.com/Open-Dev-Society/OpenStock)
**Organização:** Open Dev Society (ODS)
**Licença:** AGPL-3.0

## O que é

OpenStock é uma alternativa open-source a plataformas pagas de mercado financeiro. Permite rastrear preços em tempo real, configurar alertas personalizados e explorar detalhes de empresas. Não é uma corretora — dados de mercado podem estar atrasados conforme as regras do provedor.

> "Built openly, for everyone, forever free." — Open Dev Society

## Tech Stack

### Core
- **Next.js 15** (App Router) + **React 19**
- **TypeScript** (~93.4% do código)
- **Tailwind CSS v4** (via @tailwindcss/postcss — sem tailwind.config separado)
- **shadcn/ui** + **Radix UI** primitives + **Lucide** icons

### Auth & Dados
- **Better Auth** (email/password) com MongoDB adapter
- **MongoDB** + Mongoose (watchlist por usuário, sessões)
- **Finnhub API** — símbolos, perfis de empresas, notícias de mercado
- **TradingView** — widgets embeddable (candlestick, heatmap, quotes, timeline)

### Automação & Comunicação
- **Inngest** — eventos, cron jobs, AI inference via Gemini
- **Nodemailer** — Gmail transport; templates de email
- **next-themes**, **cmdk** (command palette), **react-hook-form**

### AI (opcional)
- Google Gemini (default), MiniMax, Siray — configurável via `AI_PROVIDER` env

## Funcionalidades Principais

| Feature | Implementação |
|---------|--------------|
| Autenticação | Better Auth + MongoDB; rotas protegidas via middleware Next.js |
| Busca global | Cmd+K palette; debounced search via Finnhub; popular stocks idle |
| Watchlist | MongoDB, único símbolo por usuário |
| Detalhes de ação | TradingView: candlestick, baseline, technicals, company profile |
| Sentimento | Opcional: Reddit, X.com, news, Polymarket (via Adanos API) |
| Market overview | Heatmap, quotes, top stories (TradingView widgets) |
| Onboarding | País, objetivos, tolerância a risco, indústria preferida |
| Email AI | Welcome email personalizado por Gemini via Inngest |
| Daily news | Cron 0 12 * * * → summary email por watchlist |

## Estrutura do Projeto

```
app/
  (auth)/         # sign-in, sign-up
  (root)/         # dashboard, stocks/[symbol]
  api/inngest/    # Inngest webhook
components/
  ui/             # shadcn/radix primitives
  forms/          # InputField, SelectField, etc.
database/
  models/watchlist.model.ts
  mongoose.ts
lib/
  actions/        # server actions (auth, finnhub, user, watchlist)
  inngest/        # client, functions, prompts
  nodemailer/     # transporter, email templates
scripts/
  test-db.mjs     # validação de conectividade DB
```

## Integrações de Dados

- **Finnhub** — free tier suportado; tempo real pode exigir plano pago; respeitar rate limits
- **Adanos** (opcional) — sentiment snapshots cross-source; ADANOS_API_KEY
- **TradingView** — widgets embeddable; i.ibb.co allowlistado no next.config.ts
- **Inngest** — `app/user.created` → welcome email; `cron 0 12 * * *` → daily news summary

## Setup Rápido

```bash
git clone https://github.com/Open-Dev-Society/OpenStock.git
cd OpenStock
pnpm install
# configurar .env (MONGODB_URI, BETTER_AUTH_SECRET, FINNHUB_API_KEY, etc.)
pnpm test:db      # verificar conectividade
pnpm dev          # Next.js + Turbopack
npx inngest-cli@latest dev  # workflows, cron, AI
```

## Docker

`docker-compose.yml` inclui dois serviços: `openstock` e `mongodb` (com volume persistente). Para Docker local, usar:
```
MONGODB_URI=mongodb://root:example@mongodb:27017/openstock?authSource=admin
```

## Variáveis de Ambiente Essenciais

| Variável | Obrigatório | Descrição |
|---------|-------------|-----------|
| `MONGODB_URI` | sim | Atlas ou local Docker |
| `BETTER_AUTH_SECRET` | sim | secret de autenticação |
| `NEXT_PUBLIC_FINNHUB_API_KEY` | sim | necessário no Vercel |
| `INNGEST_SIGNING_KEY` | prod | deploy em Vercel |
| `NODEMAILER_EMAIL` + `_PASSWORD` | sim | Gmail app password |
| `GEMINI_API_KEY` | opcional | AI welcome email |
| `ADANOS_API_KEY` | opcional | sentiment insights |

> Manter chaves privadas server-side. `NEXT_PUBLIC_*` é exposto ao browser.

## Manifesto — Open Dev Society

ODS crê que tecnologia deve pertencer a todos. Promessas explícitas: nunca cobrar por acesso, nunca trancar conhecimento, nunca trocar confiança por dinheiro. Financiado por doações e pela comunidade.

## Contribuidores

- **ravixalgorithm** — desenvolveu a aplicação completa (auth, UI, API, AI, deploy)
- **Priyanshuu00007** — logo oficial e identidade visual
- **chinnsenn** — configuração Docker
- **koevoet1221** — fix de problemas Docker/MongoDB
- **ettoreciolli1** — README

## Conexões no Vault

- [[03-RESOURCES/concepts/ai-strategy-org/open-source-fintech]] — OpenStock como caso de estudo de fintech open-source
- [[03-RESOURCES/entities/Open-Dev-Society]] — organização mantenedora
- [[03-RESOURCES/entities/Finnhub]] — provedor de dados de mercado
- [[03-RESOURCES/entities/Inngest]] — orquestração de workflows e cron jobs
- [[03-RESOURCES/concepts/agent-systems/crypto-trading-agent]] — domínio adjacente (trading agents)
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — integração potencial para dados de mercado em tempo real
