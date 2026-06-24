---
title: Local SEO with AI
type: concept
status: developing
created: 2026-04-24
updated: 2026-04-24
tags: [seo, local-seo, google-business-profile, ai, claude-cowork, prompts]
---

# Local SEO with AI

Uso de modelos de linguagem (especialmente via [[03-RESOURCES/entities/Claude-Cowork]]) para automatizar e escalar operações de SEO local — o conjunto de técnicas que determinam se um negócio aparece no **Map Pack** do Google para buscas com intenção local.

## Por que SEO local é diferente

SEO local compete em **entidades geográficas**: o ranking não é só do site, mas do Google Business Profile (GBP) + site + autoridade de entidade combinados. Os três pilares são:

1. **Relevância** — categorias, atributos, keywords no GBP e site
2. **Distância** — proximidade geográfica do buscador
3. **Autoridade** — reviews, backlinks, citations, entity signals

## Framework de 4 Partes (Sarvesh Shrivastava)

Fonte: [[03-RESOURCES/sources/claude-code-cowork/claude-cowork-seo-20-prompts-sarvesh]]

### 1. Google Business Profile (GBP)
- **Categorias** são o controle mais direto sobre quais buscas ativam o Map Pack
- **Review velocity** (reviews/mês) pesa mais que review total
- **Posts** sinalizam atividade; neighborhood-specific posts constroem relevância geográfica
- **Fotos** com naming convention + geotagging afetam rankings locais

### 2. Website
- Google rankeia **páginas**, não sites → uma página por serviço × cidade
- **Page 2 goldmine**: posições 11–20 com 100+ impressões/mês têm o maior ROI de qualquer otimização (uma mudança de title tag pode mover para top 3)
- **Review sentiment analysis**: copiar a linguagem emocional exata dos reviews dos clientes para o copy do site aumenta conversão

### 3. Backlinks + Authority
- 2–4 links contextuais/mês compõem mais rápido que 20 directory submissions
- **NAP consistency** (Name, Address, Phone) cross-web é um trust signal; inconsistências suprimem rankings
- **4 buyer journey stages**: problem-unaware → problem-aware → solution-aware → ready to hire. Stage 4 converte 5–10× mais

### 4. Entity Optimization
O conceito mais avançado: Google rankeia entidades (não só páginas). Construir a entidade no knowledge graph via:
- LocalBusiness schema (JSON-LD no homepage)
- Wikidata / Crunchbase / LinkedIn company page
- Knowledge Panel
- NAP consistency como sinal de entidade

## Regras Práticas

| Regra | Detalhe |
|-------|---------|
| Velocity > volume | 3–5 fotos/semana > 50 fotos em um dia |
| Stage 4 first | Keywords "ready to hire" têm menor volume mas convertem 5–10× |
| Template reviews | Pedir que clientes usem palavras-chave específicas aumenta SEO passivo |
| Test descriptions | 3 versões da GBP description → rotacionar mensalmente e medir |
| Sentiment copy | Escrever copy do site em linguagem dos clientes (extraída de reviews) > linguagem da empresa |

## Ferramentas

- **Google Business Profile** — painel central
- **Google Search Console** — dados de posição e impressão por query
- **SEMrush** — Keyword Gap, Content Gap
- **Ahrefs** — backlink profiles
- **Wikidata + Rich Results Test** — entity validation

## Conexões no Vault

- [[03-RESOURCES/concepts/gbp-optimization]] — táticas específicas de GBP
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]] — patterns de prompt aplicados a SEO
- [[03-RESOURCES/entities/Claude-Cowork]] — plataforma de execução dos prompts
- [[03-RESOURCES/sources/claude-code-cowork/claude-cowork-seo-20-prompts-sarvesh]] — fonte completa com os 20 prompts
