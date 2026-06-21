---
title: Agentes de IA
type: index
space: ai-agents
created: 2026-04-14
updated: 2026-06-20
---

# Agentes de IA — Prompts & Workflows

> ⚠️ **Índice de navegação — não-canônico como fonte de roteamento.** Fonte canônica = `[[04-SYSTEM/AGENTS]]` (V.1 "AGENTS.md é o resolver"). Este índice mantém wikilinks por agente para navegação; contagem/rosters podem divergir do disco (recount via `@review` + `check-resolvable`).

Biblioteca de agentes Claude com wikilinks por categoria. Prompts otimizados com Claude Sonnet / Opus.

## Core (Qualidade, Segurança, Infra + Feature Dev)

**Propósito:** Gates contínuos de qualidade, validação de segurança, saúde do repositório e pipeline de desenvolvimento

- [[04-SYSTEM/agents/core/guard|Guard]] — Security auditor (OWASP LLM Top 10) · `@guard` · Opus
- [[04-SYSTEM/agents/core/verify|Verify]] — Post-impl QA gate · `@verify` · Opus
- [[04-SYSTEM/agents/core/review|Review]] — Drift review docs↔code↔config · `@review` · Sonnet
- [[04-SYSTEM/agents/core/ingest-report|Ingest Report]] — Relatório semanal Clippings/ · Manual/cron · Haiku
- [[04-SYSTEM/agents/core/spec|Spec]] — Spec-Driven Development · `@spec` · Haiku
- [[04-SYSTEM/agents/core/extend|Extend]] — Extensão cirúrgica de agentes · `@extend` · Sonnet
- [[04-SYSTEM/agents/core/hill|Hill]] — Hill-climbing: eval→diagnose→fix · `@hill` · Haiku

## Knowledge System (Pesquisa, Escrita, Decisões)

**Propósito:** Pesquisa aprofundada, produção de texto, decisões complexas e otimização de prompts

- [[04-SYSTEM/agents/knowledge-system/kore|Kore]] — Orquestrador · `@kore`
- [[04-SYSTEM/agents/knowledge-system/farol|Farol]] — Pesquisa e aprendizado
- [[04-SYSTEM/agents/knowledge-system/pena|Pena]] — Escrita e clarificação
- [[04-SYSTEM/agents/knowledge-system/bussola|Bussola]] — Decisões e projetos complexos
- [[04-SYSTEM/agents/knowledge-system/sigma|Sigma]] — Otimização de prompts

## Edu System (Concurso, Idiomas, TI & Carreira)

**Propósito:** Estudos para concurso público, idiomas, formação em TI e desenvolvimento de carreira

- [[04-SYSTEM/agents/edu-system/mestre|mestre]] — Orquestrador · `@mestre`
- [[04-SYSTEM/agents/edu-system/banca|banca]] — Concurso público (aulas, questões, plano por banca)
- [[04-SYSTEM/agents/edu-system/babel|babel]] — Idiomas para viajantes (4 modos: situacional, conversação, técnico)
- [[04-SYSTEM/agents/edu-system/stack|stack]] — TI, ADS e carreira tech (tutor adaptativo, projeto guiado, entrevista)
- [[04-SYSTEM/agents/edu-system/sintese|sintese]] — Resumos Obsidian, flashcards Anki, questões, mapa mental
- [[04-SYSTEM/agents/edu-system/trilha|trilha]] — CV PT-BR + EN, otimização ATS, LinkedIn, estágios
- [[04-SYSTEM/agents/edu-system/tutor|tutor]] — Tutor adaptativo geral

## Travel System (Viagens end-to-end)

**Propósito:** Busca de voos/hotéis, criação e refinamento de itinerários

- [[04-SYSTEM/agents/travel-system/rota|Rota]] — Orquestrador · `@rota`
- [[04-SYSTEM/agents/travel-system/caca|Caça]] — Busca estratégica de voos, hotéis e carros
- [[04-SYSTEM/agents/travel-system/rumo|Rumo]] — Criação de itinerário (roteiros diários)
- [[04-SYSTEM/agents/travel-system/ajuste|Ajuste]] — Refinamento de roteiros já fechados

## Fullstack Agent System (Dev, Infra, Segurança)

**Propósito:** Desenvolvimento fullstack end-to-end — backend, frontend, infra, dados e segurança

- [[04-SYSTEM/agents/fullstack-agent-system/orchestrator|orchestrator]] — Orquestrador · `@orchestrator`
- [[04-SYSTEM/agents/fullstack-agent-system/backend-dev|backend-dev]] — APIs, DB, lógica de negócio
- [[04-SYSTEM/agents/fullstack-agent-system/frontend-dev|frontend-dev]] — UI, componentes, UX
- [[04-SYSTEM/agents/fullstack-agent-system/infra-cloud|infra-cloud]] — Cloud, IaC, CI/CD
- [[04-SYSTEM/agents/fullstack-agent-system/data-ai|data-ai]] — ML, pipelines de dados
- [[04-SYSTEM/agents/fullstack-agent-system/security|Sentinel]] — Review qualitativo + veto de deploy · `@sentinel` · Opus
- [[04-SYSTEM/agents/fullstack-agent-system/probe|probe]] — Testes automatizados de segurança (static/dynamic/harness) · `@probe`

## Finance System (Investimentos & Mercado)

**Propósito:** Análise de ativos, portfólio, cripto e macro

- [[04-SYSTEM/agents/finance-system/nexo|nexo]] — Orquestrador · `@nexo`
- [[04-SYSTEM/agents/finance-system/valor|valor]] — Fundamentalista (ações BR/EUA)
- [[04-SYSTEM/agents/finance-system/fluxo|fluxo]] — ETF e FII
- [[04-SYSTEM/agents/finance-system/macro|macro]] — Macro, BCB, IBGE, Fed
- [[04-SYSTEM/agents/finance-system/quant|quant]] — Análise quantitativa
- [[04-SYSTEM/agents/finance-system/cripto|cripto]] — Criptomoedas e DeFi
- [[04-SYSTEM/agents/finance-system/contador|contador]] — Extrai informes de rendimento e mapeia fichas IRPF (trigger: `@irpf`)

## Hobby System

- [[04-SYSTEM/agents/hobby-system/mtg-arena-coach|MTG Arena Coach]] — Coach de MTG Arena (draft, sealed, constructed)

## Institutional (TJAM — Compliance & Governança)

**Propósito:** Agentes role-based para fluxos institucionais do TJAM

- [[04-SYSTEM/agents/tjam-institutional-system/assistente-de-chefia|Assistente de Chefia]] — suporte à chefia, despachos, comunicações internas
- [[04-SYSTEM/agents/tjam-institutional-system/analista-de-dados|Analista de Dados]] — análise institucional, Google Sheets ETL
- [[04-SYSTEM/agents/tjam-institutional-system/assessor-juridico-administrativo|Assessor Jurídico Administrativo]] — minutas, pareceres, direito administrativo
- [[04-SYSTEM/agents/tjam-institutional-system/assessor-pca|Assessor PCA]] — Plano de Contratações Anuais, normativas
- [[04-SYSTEM/agents/tjam-institutional-system/assessor-pls|Assessor PLS]] — Plano de Logística Sustentável, CNJ 400/2021

## Infrastructure (Proxies, Integrations)

**Propósito:** System-level integrations e extensões de acesso

- [[04-SYSTEM/agents/core/claude-hermes-proxy|Claude-Hermes Proxy]] — HTTP proxy OpenAI-compat para Claude Code · 127.0.0.1:8080

## Referências

- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns|Prompt Engineering]] — princípios, técnicas + 10 padrões
- [[03-RESOURCES/concepts/agent-systems/agentic-agents|Agentic Agents]] — agentes IA
- [[03-RESOURCES/entities/anthropic|Anthropic]] — empresa por trás do Claude
