---
title: Solo SaaS Stack 2026
type: concept
status: developing
tags: [saas, indie-hacker, solo-founder, claude, open-saas, supabase, vercel, stripe]
updated: 2026-05-19
---

# Solo SaaS Stack 2026

## O que é

Conjunto mínimo de ferramentas que permite a um solo developer lançar um SaaS completo em 1-2 semanas com ~$20/mês de custo, sem precisar de um time. O paradigma mudou radicalmente de 2020 para 2026.

## Antes vs. Agora

| | 2020 | 2026 |
|---|---|---|
| Team | Developers necessários | Solo builder |
| Investimento | $10K+ | ~$20/mês |
| Tempo | 3-6 meses | 1-2 semanas |

## A Stack Canônica

```
Open SaaS  → app structure (auth, payments, admin, file upload)
Supabase   → database (PostgreSQL + APIs auto-geradas)
Repomix    → contexto completo do projeto para Claude
Claude     → escreve o código que realmente funciona
Skills     → Anthropics/VoltAgent — prebuilt integrations
Flowise    → AI features (chatbot, doc assistant) sem código
LangChain  → AI features avançadas
Vercel     → deploy (uma linha)
Stripe     → payments
```

## Princípio Central

Não construa infraestrutura genérica (login, pagamento, dashboard). Use fundações prontas. Comece a construir seu **produto real** no Dia 1.

## Path para $10K/mês

```
100 users × $29 = $2.900
200 users × $29 = $5.800
350 users × $29 = $10.150
```

Foco: resolver um único problema real para um nicho específico.

## Evidências
- **[2026-06-22]** 9 sistemas Claude Code organizados em 3 tiers (produto/operação/crescimento) substituem headcount de time: build loop + reviewer subagent + headless CI cobrem produto; STATE.md + MCP cobrem operação; roteamento de modelo por custo evita "Top-tier model for everything" — [[03-RESOURCES/sources/how-to-build-a-solo-company-with-claude-code-9-systems-that-run-it]]

- **[2026-06-22]** Stack Obsidian+Hermes como alternativa de produtização de expertise individual sem ser autor/curso/software-company — três modelos de acesso (managed/supervised/licensed) como progressão de maturidade — [[03-RESOURCES/sources/how-to-productize-your-expertise-into-a-hermes-and-obsidian-system-clients-pay-to-access]]

## Relações

- [[03-RESOURCES/sources/misc-low-confidence/zero-to-30k-month-claude-saas]] — fonte original
- [[03-RESOURCES/entities/Repomix]] — peça crítica para dar contexto ao Claude
- [[03-RESOURCES/concepts/agent-systems/ai-agents-negocios]] — framework mais amplo de AI como produto
- [[03-RESOURCES/entities/Claude Code]] — coding agent central
