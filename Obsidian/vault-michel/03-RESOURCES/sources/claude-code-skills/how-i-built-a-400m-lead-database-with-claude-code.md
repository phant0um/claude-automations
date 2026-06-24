---
title: "how i built a 400M lead database with Claude Code"
type: source
source: "Clippings/how i built a 400M lead database with Claude Code.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, claude-code, lead-gen, scraping, data-engineering]
---

## Tese central
A lead-gen industry inteira depende de 5 fontes saturadas (Apollo, ZoomInfo, etc.) enquanto 400M de leads verificados existem em fontes públicas governamentais, nonprofits e diretórios setoriais — acessíveis via scraping com Claude Code como motor de manutenção contínua.

## Argumentos principais
- Fontes regulatórias (médicos, advogados, contractors) já têm dados verificados pelo governo: SAM.gov, state licensing boards, IRS 990s, court filings
- Listas proprietárias custam $15k–$50k/ano; scrapers customizados custam ~$40/mês (VPS + proxies residenciais) — o crossover é ~50k leads
- Reply rates em listas customizadas rodam 3–5x acima das compradas no Apollo, porque não passaram pelo mesmo ciclo de spam
- Deliverability é melhor: emails em diretórios públicos não foram pelo "meat grinder" de spam traps e bounce filters dos agregadores
- O real unlock do Claude Code não é escrever o primeiro scraper — é reescrever scrapers quebrados em 90 segundos quando sites mudam (antes a manutenção era o gargalo)

## Key insights
- Intent já está embutido em listas de licenciamento: um board estadual confirma que a pessoa É um plumber ativo com licença válida, sem step de verificação adicional
- Breakdown dos 400M: ~180M de licensing boards, ~90M de IRS 990s, ~70M de trade associations, ~40M de specialty platforms, ~20M de eventos/podcasts
- Deduplicação agressiva é crítica: base de 400M com 50% de duplicatas é efetivamente uma base de 200M desperdiçando budget
- Enrichment pipeline: listing → verify email (NeverBounce/MillionVerifier) → append firmographic (domain age, tech stack, hiring signals)
- Compliance B2B EUA: CAN-SPAM cobre maioria desde que inclua unsubscribe + endereço físico; GDPR exige legitimate interest basis para EU

## Exemplos e evidências
- Caso private clinics: state medical boards + Healthgrades + state business registries produz lista que Apollo literalmente não consegue porque os dados existem em 3 fontes públicas que os agregadores não scraparam
- Workflow com Claude Code: terminal → aponta para página → "build me a scraper for this site that handles pagination and outputs to CSV" → Claude inspeciona, escreve Playwright ou requests+BS4, roda, vê output quebrado, itera sem intervenção humana
- Sites fáceis: paginated URLs, clean HTML → requests + BeautifulSoup; sites difíceis: JS-rendered, captcha'd → Playwright + rotating proxies + delays

## Implicações para o vault
Documenta um use case concreto de Claude Code como motor de automação de dados em escala — reforça o conceito de agentes como amplificadores de trabalho repetitivo/manutenção. Complementa páginas existentes sobre [[03-RESOURCES/entities/everything-claude-code]] e padrões de tooling.

## Links
- [[03-RESOURCES/entities/everything-claude-code]]
- [[03-RESOURCES/concepts/agent-security]]
- [[03-RESOURCES/concepts/externalized-memory]]
