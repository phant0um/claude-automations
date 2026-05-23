---
title: Agentes de IA
type: index
space: ai-agents
created: 2026-04-14
updated: 2026-05-15
---

# Agentes de IA — Prompts & Workflows

Biblioteca de 37 agentes Claude organizados em 8 categorias. Prompts otimizados com Claude Sonnet 4.6 / Opus.

## Core (Qualidade, Segurança, Infra + Feature Dev)

**Propósito:** Gates contínuos de qualidade, validação de segurança, saúde do repositório e pipeline de desenvolvimento

- [[04-SYSTEM/agents/00-core/guard|Guard]] — Security auditor (OWASP LLM Top 10) · `@guard` · Opus
- [[04-SYSTEM/agents/00-core/verify|Verify]] — Post-impl QA gate · `@verify` · Opus
- [[04-SYSTEM/agents/00-core/review|Review]] — Drift review docs↔code↔config · `@review` · Sonnet
- [[04-SYSTEM/agents/00-core/ingest-report|Ingest Report]] — Relatório semanal Clippings/ · Manual/cron · Haiku
- [[04-SYSTEM/agents/00-core/spec|Spec]] — Spec-Driven Development · `@spec` · Haiku
- [[04-SYSTEM/agents/00-core/extend|Extend]] — Extensão cirúrgica de agentes · `@extend` · Sonnet
- [[04-SYSTEM/agents/00-core/hill|Hill]] — Hill-climbing: eval→diagnose→fix · `@hill` · Haiku

## Knowledge System (Pesquisa, Escrita, Decisões)

**Propósito:** Pesquisa aprofundada, produção de texto, decisões complexas e otimização de prompts

- [[04-SYSTEM/agents/Knowledge System/kore|Kore]] — Orquestrador · `@kore`
- [[04-SYSTEM/agents/Knowledge System/farol|Farol]] — Pesquisa e aprendizado
- [[04-SYSTEM/agents/Knowledge System/pena|Pena]] — Escrita e clarificação
- [[04-SYSTEM/agents/Knowledge System/bussola|Bussola]] — Decisões e projetos complexos
- [[04-SYSTEM/agents/Knowledge System/sigma|Sigma]] — Otimização de prompts

## Edu System (Concurso, Idiomas, TI & Carreira)

**Propósito:** Estudos para concurso público, idiomas, formação em TI e desenvolvimento de carreira

- [[04-SYSTEM/agents/Edu System/00-SYSTEM-PROMPTS/Mestre|Mestre]] — Orquestrador · `@mestre`
- [[04-SYSTEM/agents/Edu System/00-SYSTEM-PROMPTS/Banca|Banca]] — Concurso público (aulas, questões, plano por banca)
- [[04-SYSTEM/agents/Edu System/00-SYSTEM-PROMPTS/Babel|Babel]] — Idiomas para viajantes (4 modos: situacional, conversação, técnico)
- [[04-SYSTEM/agents/Edu System/00-SYSTEM-PROMPTS/Stack|Stack]] — TI, ADS e carreira tech (tutor adaptativo, projeto guiado, entrevista)
- [[04-SYSTEM/agents/Edu System/00-SYSTEM-PROMPTS/Sintese|Sintese]] — Resumos Obsidian, flashcards Anki, questões, mapa mental
- [[04-SYSTEM/agents/Edu System/00-SYSTEM-PROMPTS/Trilha|Trilha]] — CV PT-BR + EN, otimização ATS, LinkedIn, estágios
- [[04-SYSTEM/agents/Edu System/00-SYSTEM-PROMPTS/Tutor|Tutor]] — Tutor adaptativo geral

## Travel System (Viagens end-to-end)

**Propósito:** Busca de voos/hotéis, criação e refinamento de itinerários

- [[04-SYSTEM/agents/Travel System/rota|Rota]] — Orquestrador · `@rota`
- [[04-SYSTEM/agents/Travel System/00-SYSTEM-PROMPTS/Caca|Caça]] — Busca estratégica de voos, hotéis e carros
- [[04-SYSTEM/agents/Travel System/rumo|Rumo]] — Criação de itinerário (roteiros diários)
- [[04-SYSTEM/agents/Travel System/ajuste|Ajuste]] — Refinamento de roteiros já fechados

## Finance System (Investimentos & Mercado)

**Propósito:** Análise de ativos, portfólio, cripto e macro

- [[04-SYSTEM/agents/Finance System/00-SYSTEM-PROMPTS/Nexo|Nexo]] — Orquestrador · `@nexo`
- [[04-SYSTEM/agents/Finance System/00-SYSTEM-PROMPTS/Valor|Valor]] — Fundamentalista (ações BR/EUA)
- [[04-SYSTEM/agents/Finance System/00-SYSTEM-PROMPTS/Fluxo|Fluxo]] — ETF e FII
- [[04-SYSTEM/agents/Finance System/00-SYSTEM-PROMPTS/Macro|Macro]] — Macro, BCB, IBGE, Fed
- [[04-SYSTEM/agents/Finance System/00-SYSTEM-PROMPTS/Quant|Quant]] — Análise quantitativa
- [[04-SYSTEM/agents/Finance System/00-SYSTEM-PROMPTS/Cripto|Cripto]] — Criptomoedas e DeFi

## Standalone

- [[04-SYSTEM/agents/standalone/mtg-arena-coach|MTG Arena Coach]] — Coach de MTG Arena (draft, sealed, constructed)
- [[04-SYSTEM/agents/standalone/irpf-consolidator|IRPF Consolidador]] — Extrai informes de rendimento e mapeia fichas IRPF (trigger: `@irpf`)

## Institutional (TJAM — Compliance & Governança)

**Propósito:** Agentes role-based para fluxos institucionais do TJAM

- [[04-SYSTEM/agents/TJAM Institutional System/chefia/assistente-de-chefia|Assistente de Chefia]] — suporte à chefia, despachos, comunicações internas
- [[04-SYSTEM/agents/TJAM Institutional System/dados/analista-de-dados|Analista de Dados]] — análise institucional, Google Sheets ETL
- [[04-SYSTEM/agents/TJAM Institutional System/juridico/assessor-juridico-administrativo|Assessor Jurídico Administrativo]] — minutas, pareceres, direito administrativo
- [[04-SYSTEM/agents/TJAM Institutional System/pca/assessor-pca|Assessor PCA]] — Plano de Contratações Anuais, normativas
- [[04-SYSTEM/agents/TJAM Institutional System/pls/assessor-pls|Assessor PLS]] — Plano de Logística Sustentável, CNJ 400/2021

## Infrastructure (Proxies, Integrations)

**Propósito:** System-level integrations e extensões de acesso

- [[04-SYSTEM/agents/04-infrastructure/claude-hermes-proxy|Claude-Hermes Proxy]] — HTTP proxy OpenAI-compat para Claude Code · 127.0.0.1:8080

## Referências

- [[03-RESOURCES/concepts/prompt-engineering|Prompt Engineering]] — princípios e técnicas
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns|Prompt Engineering Patterns]] — 10 padrões
- [[03-RESOURCES/concepts/agent-systems/agentic-agents|Agentic Agents]] — agentes IA
- [[03-RESOURCES/entities/anthropic|Anthropic]] — empresa por trás do Claude
