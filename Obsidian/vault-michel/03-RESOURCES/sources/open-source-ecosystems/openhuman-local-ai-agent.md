---
title: "openhuman — Private Local AI Agent"
type: source
tags: [rust, local-ai, privacy, agent, self-hosted, open-source]
source: https://github.com/tinyhumansai/openhuman
author: tinyhumansai
ingested: 2026-05-16
triagem_score: 7
---

# openhuman — Private Local AI Agent

**Repo:** [tinyhumansai/openhuman](https://github.com/tinyhumansai/openhuman)
**Homepage:** https://tinyhumans.ai/openhuman
**Creator:** [@senamakel](https://x.com/intent/follow?screen_name=senamakel)
**License:** GNU GPL v3.0
**Language:** Rust (desktop shell via Tauri + CEF; UI via pnpm/Node.js)
**Status:** Early Beta — active development
**Stars at ingest:** 10,724 (+3,329 spike on 2026-05-16, largest of the trending day)

## What it is

OpenHuman is an open-source, local-first agentic assistant. Its tagline: "Your Personal AI super intelligence. Private, Simple and extremely powerful." It runs entirely on-device — no cloud dependency. All workflow data stays on your machine, encrypted locally.

## Architecture & Key Features

### Memory Tree + Obsidian Wiki
Local-first knowledge base. Every connected data source is canonicalized into ≤3k-token Markdown chunks, scored, and folded into hierarchical summary trees stored in SQLite on-device. The same chunks land as `.md` files in an Obsidian-compatible vault — directly inspired by Karpathy's obsidian-wiki workflow.

### Auto-Fetch (20-minute loop)
Every active integration is polled every 20 minutes; fresh data is pulled into the memory tree without user intervention. The agent wakes up with tomorrow's context already loaded.

### 118+ Integrations via OAuth
Gmail, Notion, GitHub, Slack, Stripe, Calendar, Drive, Linear, Jira and the rest of the stack via one-click OAuth. Each connection is exposed to the agent as a typed tool.

### TokenJuice — Smart Token Compression
Every tool call, scrape result, email body, and search payload runs through a compression layer before touching any LLM. HTML→Markdown, long URL shortening, non-ASCII removal. Claims up to 80% cost/latency reduction.

### Model Routing
Built-in routing: reasoning, fast, or vision model per task. One subscription, no BYOK required.

### Batteries Included
- Web search + web-fetch scraper
- Full coder toolset (filesystem, git, lint, test, grep)
- Native voice: STT in, ElevenLabs TTS out, mascot lip-sync
- Live Google Meet agent participation
- Optional local AI via Ollama for on-device workloads

### Desktop Mascot
The agent has a face — a desktop mascot that speaks, reacts to surroundings, joins Google Meets as a real participant, and remembers the user across weeks.

### agentmemory Backend (optional)
Can proxy to an existing `agentmemory` backend via `memory.backend = "agentmemory"` in `config.toml`, sharing durable memory with Claude Code, Cursor, Codex, and OpenCode.

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Core | Rust 1.93.0 |
| Desktop shell | Tauri + CEF |
| UI | Node.js 24+ / pnpm 10.10.0 |
| Storage | SQLite (local) |
| Build tools | CMake, Ninja, ripgrep |

## Competitive Positioning (self-reported)

| | Claude Cowork | OpenClaw | Hermes | OpenHuman |
|--|--|--|--|--|
| Open-source | No | MIT | MIT | GNU GPL |
| Simple start | Yes | Terminal-first | Terminal-first | Yes |
| Memory | Chat-scoped | Plugin-reliant | Self-learning | Memory Tree + Obsidian |
| Auto-fetch | No | No | No | Yes (20 min) |
| Integrations | Few | BYO | BYO | 118+ OAuth |
| Model routing | Single | Manual | Manual | Built-in |

## Installation

```bash
# macOS / Linux x64
curl -fsSL https://raw.githubusercontent.com/tinyhumansai/openhuman/main/scripts/install.sh | bash

# Windows
irm https://raw.githubusercontent.com/tinyhumansai/openhuman/main/scripts/install.ps1 | iex
```

Or download DMG/EXE from https://tinyhumans.ai/openhuman

## Por que Memory Tree + Obsidian é a combinação certa para agentes locais

A maioria dos sistemas de memória para agentes escolhe entre dois extremos: memória em banco de dados vetorial (busca semântica, mas opaco — você não sabe o que o agente "lembra") ou memória em arquivos de texto simples (transparente, mas sem estrutura para busca eficiente).

O Memory Tree do OpenHuman combina os dois: cada chunk de informação é canonicalizado em Markdown (transparente, editável por humanos no Obsidian) e indexado em SQLite com metadados de acesso e scores de relevância (eficiente para busca por agentes). O usuário vê os arquivos .md no Obsidian, edita quando necessário, e o agente usa SQLite para navegar eficientemente.

Isso resolve um problema concreto: a maioria dos sistemas de memória para agentes é uma caixa preta. Você não sabe o que está lá, não pode editar, e quando o agente produz resposta estranha não consegue debugar. Com o padrão Obsidian, toda "memória" do agente é auditável pelo usuário.

## TokenJuice — o que a compressão de 80% significa na prática

A claim de "até 80% de redução de custo e latência" via compressão precisa ser contextualizada. O TokenJuice funciona sobre o *input* de ferramentas externas — especificamente o payload bruto retornado por APIs, páginas web, e buscas.

**Exemplo prático**: uma busca web retorna uma página HTML completa (~40k tokens se enviada ao LLM). O TokenJuice converte para Markdown limpo (~8k tokens) antes de enviar ao modelo. Essa redução de 80% é real — mas só para inputs de ferramentas externas, não para o contexto já no agente.

**O que não comprime**: conversas existentes, memória de sessão, arquivos já no vault. A compressão é pontual, sobre dados brutos de entrada, não sobre o contexto de raciocínio do agente.

## Auto-Fetch a cada 20 minutos — trade-off de frescor vs custo

O polling de 20 minutos em 118+ integrações é a feature que diferencia o OpenHuman de praticamente todos os concorrentes. A maioria dos assistentes locais opera em pull (você pede → sistema busca). O OpenHuman opera em push contínuo: o sistema busca mesmo quando você não está usando.

**Benefício**: o agente acorda com contexto já carregado. Gmail, Calendar, Slack, Notion — tudo já sincronizado. Sem latência de primeira consulta.

**Custo**: 118 integrações × polling a cada 20 minutos × processamento de novos dados = carga computacional contínua. Em laptops com bateria, isso é relevante. O `config.toml` permite configurar quais integrações têm auto-fetch ativo — não precisa habilitar todas.

## Comparativo com o stack deste vault

| Aspecto | OpenHuman | Vault-michel (Claude Code + Obsidian) |
|---|---|---|
| Privacidade | On-device, GNU GPL | Local-first, proprietário (Anthropic) |
| Integração | 118+ OAuth automáticas | MCPs manuais configurados |
| Memória | SQLite + Obsidian sincronizados | Obsidian primário, .claude/memory/ secundário |
| Auto-ingest | Polling 20 min automático | Manual (wiki-ingest) ou via schedule |
| Modelo | Routing entre modelos | Claude exclusivo |
| Mascote | Desktop mascot com voz | Sem interface de voz |

O vault-michel tem mais controle granular (você decide o que ingere e quando) mas menos automação de captura. OpenHuman tem mais automação mas menos controle sobre o que fica no contexto do agente.

## Rust + Tauri — por que essas escolhas tecnológicas importam

**Rust**: performance de sistema com segurança de memória garantida em compile-time. Para um agente que roda continuamente (auto-fetch a cada 20 minutos, polling de 118 integrações), vazamento de memória seria fatal. Rust elimina essa classe de bug.

**Tauri**: framework para apps desktop que usa o webview do sistema operacional (ao invés de empacotar Chromium completo como o Electron). Resultado: binários ~10x menores que Electron, arranque mais rápido, consumo de memória menor.

**CEF (Chromium Embedded Framework)**: necessário para o mascote desktop e para automação de browser. É o Chromium completo, mas usado apenas para funcionalidades que requerem um browser completo (web scraping, automação de UI web).

A combinação Tauri + CEF é incomum — Tauri geralmente dispensa CEF. O OpenHuman usa Tauri para a shell principal e CEF apenas onde precisar de browser real. Arquitetura híbrida que equilibra leveza e capacidade.

## Status early beta — o que esperar

Com 10k+ stars em um dia e "Early Beta" no README, o OpenHuman está exatamente na curva onde a maioria dos usuários vai encontrar:
- Instalação funcional na maioria dos sistemas
- Features core (memória, buscas, integrações principais) estáveis
- Features avançadas (mascote, Google Meet) em desenvolvimento ativo
- Breaking changes possíveis entre versões

Para exploração e uso pessoal não-crítico: aceitável. Para workflows de produção que não podem tolerar instabilidade: aguardar v1.0.

## Conexoes

- [[03-RESOURCES/entities/openhuman]] — tool entity page
- [[03-RESOURCES/entities/tinyhumansai]] — org entity page
- [[03-RESOURCES/concepts/llm-ml-foundations/local-ai]] — concept: running AI entirely on-device
- [[03-RESOURCES/concepts/ai-strategy-org/privacy-first-ai]] — concept: local data sovereignty
- [[03-RESOURCES/concepts/dev-foundations/rust-systems]] — concept: Rust for systems-level AI tooling
- [[03-RESOURCES/concepts/agent-systems/agent-architecture]] — concept: harness + memory + tools pattern
- [[03-RESOURCES/concepts/llm-ml-foundations/self-hosted-ai]] — concept: self-hosted AI infrastructure
- [[03-RESOURCES/entities/Andrej Karpathy]] — workflow inspiration (LLM Knowledgebase / Obsidian wiki)
