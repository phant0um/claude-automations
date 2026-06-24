---
title: "affaan-m/everything-claude-code — GitHub README (v2.0.0-rc.1)"
type: source
category: ai-agents
author: "affaan-m"
source_url: "https://github.com/affaan-m/everything-claude-code"
published: 2026-05-18
ingested: 2026-05-18
tags: [source, ai-agents, ecc, agent-harness, claude-code, agentshield, cross-harness]
triagem_score: 8
---

# affaan-m/everything-claude-code — GitHub README (v2.0.0-rc.1)

## Tese central

[[03-RESOURCES/entities/everything-claude-code|ECC]] é um performance optimization system para agent harnesses (não só Claude Code), com 182K+ stars, 60 agentes, 232 skills, AgentShield, e a v2.0.0-rc.1 introduzindo um Rust control-plane (ECC 2.0 alpha) e operator workflows públicos via [[03-RESOURCES/entities/hermes|Hermes]].

## Key insights

**Escala atual (v2.0.0-rc.1, Abril 2026):**
- 182K+ stars | 28K+ forks | 170+ contributors | 12 language ecosystems
- 60 agentes | 232 skills | 75 legacy command shims
- Cross-harness: Claude Code, Codex, Cursor, OpenCode, Gemini, Zed, GitHub Copilot

**v2.0.0-rc.1 destaques:**
- Dashboard GUI (Tkinter/npm) com dark/light, font customization
- ECC 2.0 alpha em Rust (`ecc2/`): commands `dashboard`, `start`, `sessions`, `status`, `stop`, `resume`, `daemon` — alpha, não GA
- Operator story pública: start com Hermes setup guide, depois cross-harness architecture
- `ecc status --markdown --write status.md` → snapshot portátil: readiness, active sessions, skill-run health, pending governance events, linear/github work items
- Operator workflows: brand-voice, social-graph-ranker, customer-billing-ops, workspace-surface-audit

**v1.9.0 (Mar 2026):**
- Selective install architecture (manifest-driven: `install-plan.js` + `install-apply.js`)
- SQLite state store com query CLI
- 6 novos agentes de linguagem (typescript-reviewer, pytorch-build-resolver, java/kotlin reviewers)
- Session adapters + skill evolution foundation (self-improving skills)
- Observer loop prevention: 5-layer guard

**v1.8.0 — Harness Performance System:**
- Frame oficial: ECC = agent harness performance system, não config pack
- Hook runtime controls: `ECC_HOOK_PROFILE=minimal|standard|strict`
- `/harness-audit`, `/loop-start`, `/loop-status`, `/quality-gate`, `/model-route`
- NanoClaw v2: model routing + skill hot-load + session branch/search/export/compact/metrics

**Pilar de segurança:** [[03-RESOURCES/entities/AgentShield]] (1.282 testes, pipeline red-team 3 agentes)

## Arquitetura do Rust control-plane (ECC 2.0)

A decisão de reescrever o control-plane em Rust (`ecc2/`) reflete um problema concreto em harnesses de alta escala: o overhead de inicialização de Node.js ou Python torna-se perceptível quando o harness está gerenciando dezenas de sessões simultâneas e coordenando hook callbacks em < 100ms. O Rust control-plane reduz latência de hook dispatch e melhora a previsibilidade de garbage collection.

Os comandos alpha do ECC 2.0 — `dashboard`, `start`, `sessions`, `status`, `stop`, `resume`, `daemon` — formam um modelo de processo persistente: ao contrário do ECC 1.x onde cada sessão é independente, o daemon mantém estado global de sessões e skills, permitindo coordenação cross-session e hot-reload de skills sem restart.

## Selective install e install-plan.js

A arquitetura de instalação seletiva introduzida na v1.9.0 resolve o problema de harnesses monolíticos: instalar tudo aumenta o contexto base de toda sessão, mesmo quando a maioria dos capabilities nunca é usada. O fluxo `install-plan.js → install-apply.js` permite ao operador escolher quais agentes, skills e hooks instalar por projeto, mantendo o footprint de contexto mínimo.

O SQLite state store com query CLI é significativo: habilita auditoria de sessões passadas, debugging de comportamentos inesperados via SQL direto, e correlação entre skill invocations e resultados de qualidade.

## AgentShield como red-team contínuo

Com 1.282 testes e pipeline de red-team com 3 agentes, o AgentShield representa uma abordagem diferente de segurança de harness: ao invés de listas estáticas de ações bloqueadas, usa agentes adversariais para encontrar novos vetores de ataque contra o próprio harness. Isso é particularmente relevante porque harnesses como o ECC, ao ganhar mais capabilities, criam superfícies de ataque novas que listas estáticas não conseguem antecipar.

## Observer loop prevention (5-layer guard)

Um problema específico de harnesses com self-improvement: o agente que monitora outros agentes pode entrar em loop de observação — observador observa o observador. O 5-layer guard do ECC v1.9.0 é uma solução estrutural: cada camada de prevenção detecta um padrão diferente de loop (recursão direta, recursão indireta, loop via shared state, loop via skill re-invocation, loop via cross-session callback).

## Cross-harness como moat competitivo

A compatibilidade com Claude Code, Codex, Cursor, OpenCode, Gemini, Zed e GitHub Copilot transforma o ECC de uma extensão do Claude Code em infraestrutura de equipe independente de harness. Uma equipe que padroniza workflows no ECC não fica locked-in a nenhum provider específico — a mesma skill de code review funciona independentemente de qual CLI o desenvolvedor usa no dia.

## Operator story e o conceito de workflow público

A novidade arquitetural mais significativa da v2.0.0-rc.1 não é o Rust control-plane — é o conceito de **operator story pública**. Até a v1.x, ECC era um conjunto de capabilities para operadores técnicos. Com a v2, a narrativa muda: existem workflows pré-definidos (brand-voice, social-graph-ranker, customer-billing-ops, workspace-surface-audit) que são entry points para usuários que não são engenheiros de harness.

Isso é coerente com a direção mais ampla do Claude Code: o `ecc status --markdown --write status.md` que produz um snapshot portátil de readiness, sessões ativas, e pending governance events é pensado para consumo por stakeholders não-técnicos, não apenas por desenvolvedores. O harness como infraestrutura gerenciável por times inteiros, não apenas pelo engenheiro que o instalou.

## Evolução das estrelas: o que o crescimento 140K → 182K indica

O salto de 140K (v1.10, Abril 2026) para 182K+ (v2.0.0-rc.1) em semanas é notável. Parte do crescimento é orgânico pelo tamanho da base. Mas o driver principal é o cross-harness: cada vez que um desenvolvedor de Cursor ou Gemini CLI descobre que o ECC funciona com seu harness, a base potencial multiplica. A estratégia de não ser Claude-only converte o ECC de extensão de um produto em padrão de mercado.

Para equipes avaliando qual harness adotar, isso tem implicação de lock-in: adotar ECC não significa apostar em Claude Code permanentemente. As skills, os agentes e os workflows são portáteis.

## Links

- [[03-RESOURCES/entities/everything-claude-code]] — entidade principal
- [[03-RESOURCES/entities/affaan-m]] — autor/maintainer
- [[03-RESOURCES/entities/AgentShield]] — componente de segurança
- [[03-RESOURCES/entities/hermes]] — Hermes operator story no ECC v2
- [[03-RESOURCES/sources/open-source-ecosystems/everything-claude-code-ecc]] — source técnico v1.10 anterior
- [[03-RESOURCES/concepts/agent-systems/agent-harness]] — arquitetura harness
- [[03-RESOURCES/concepts/agent-systems/agentic-harness-engineering]] — engineering patterns
