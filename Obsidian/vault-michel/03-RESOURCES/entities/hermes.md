---
title: Hermes
type: entity
category: tools
created: 2026-05-01
updated: 2026-05-18
tags: [entity, tool, ai, agent-framework]
---

# Hermes

Agent framework open-source da [[Nous Research]] — 150k★ GitHub, #1 OpenRouter global token usage. Transforma um modelo em **operador persistente** com memória inter-sessão, skills built-in (123+), e 20+ surfaces de interação (telegram, discord, slack, email, voice, terminal).

## Posicionamento

Hermes é **rails** (opinionated, batteries-included, produtivo dia 1, agente decide mais por você). Contraponto: [[OpenClaw]] = linux (primitives, flexível, você compõe tudo).

Se você já usou [[03-RESOURCES/entities/Claude Code]] ou OpenClaw → mesma forma, filosofia diferente.

## Capacidades core

- **Persistent memory** — sobrevive entre sessões
- **Self-writing skills** — escreve próprias skills enquanto trabalha
- **123 skills built-in:** GitHub workflows, [[Obsidian]], Google Workspace, Linear, Notion, Typefully, Perplexity, Deep Research, +100 outras
- **Multi-surface:** runtime em laptop, Docker, VPS, serverless
- **20+ interfaces:** telegram, discord, slack, email, voice mode, terminal

## Setup: 4-Part Mental Model

1. **You** — operador
2. **Control Room** — UI / dashboards
3. **Agents** — workers
4. **Optional Task Bus** — coordenação multi-agent

4 níveis: agente único local → agente time em VPS controlado por celular.

## Padrões aplicados

### SOUL.md — Operating Contract

System prompt operacional (170 linhas típico). NÃO "you are a helpful assistant" — define identidade, pushback rules, what's allowed without asking, current projects, what counts as waste of time.

> "You are [user]'s autonomous operator and thought partner. You don't wait for orders. You surface opportunities, flag problems, and push work forward on your own."

Pushback é OBRIGATÓRIO: "disagree openly and directly", earn the right (evidência: data, examples, reasoning). Source: [[03-RESOURCES/sources/hermes-agent/soulmd-170-line-hermes-operating-contract]]

### Paperclip — AI Org Layer

Paperclip = camada gerencial sobre Hermes: roles (CEO, Marketing, SEO, Support agents), tickets, heartbeats, reporting. Estrutura de empresa, não bag de prompts.

Setup 24h: NÃO criar 10 agentes; conectar Hermes ↔ Paperclip, 1 time pequeno, 1 job claro/agente, observar tickets fluindo. Source: [[03-RESOURCES/sources/hermes-agent/paperclip-and-hermes-24-hours]]

### Agent UI — Control Room

Hermes Agent UI = camada visual. Dois paths:
- **WebUI** — simples, 1 agente, baixa fricção
- **Workspace** — swarms, kanban, conductor, missions, mobile, customização

Source: [[03-RESOURCES/sources/hermes-agent/hermes-agent-ui-control-room]]

## Operator Guide

Para configurar agent control room + specialist agents + escalar de 1 agente até time inteiro em 1 VPS: ver [[03-RESOURCES/sources/guides-courses-howtos/how-to-become-hermes-agent-operator]].

## Integrações relevantes

- [[03-RESOURCES/sources/memory-context-rag/rohitg00-agentmemory-persistent-llm-wiki]] — native plugin + MCP
- [[03-RESOURCES/concepts/claude-code-tooling/goal-command]] — Hermes suporta `/goal` nativo
- [[03-RESOURCES/concepts/agent-systems/agent-governance-layers]] — SOUL.md = Intent Boundary

### Framework 4-Jobs para Superagent (Mai/2026)

@itsolelehmann documenta que Hermes sem integrações é "cérebro num pote". As 12 integrações mapeiam em 4 jobs: **Research** (Firecrawl, Reddit, YouTube Transcripts), **Action** (Browserbase, Bland/Twilio, Stripe), **Workspace** (Google Workspace, Discord, GitHub), **Memory** (Readwise, Granola, Obsidian). Obsidian = "Karpathy-style LLM wiki second-brain maxxing". Ver [[03-RESOURCES/sources/hermes-agent/hermes-superagent-12-integrations]].

## Dados recentes (maio 2026)

- 73.000 GitHub stars
- #1 most-used AI agent por daily inference volume no OpenRouter (maio 2026)
- 647 skills no ecossistema (atualização de 123 built-in para 647 total)
- Lançado por Nous Research em fevereiro 2026
- 3-tier memory system + self-evolving skills via GEPA
- Natural language cron: "every weekday at 9am, summarise inbox and post to Slack"
- Model routing: Gemini Flash Lite (mecânico) → Claude Sonnet (ambíguo) → Claude Opus (raciocínio profundo)
- Auto-hosted, sem telemetria, dados locais

Source: [[03-RESOURCES/sources/ai-agents-harness/5-tool-ai-stack-differentiated]]

> [!contradiction]
> Dado de 73k★ GitHub conflita com 150k★ em entradas anteriores. A fonte mais recente (2026-05-29) diz 73k, entrada anterior diz 150k. Verificar no GitHub.

## memory-os — 7-Layer Memory Architecture (2026-06)

Implementação externa que resolve o problema raiz do Hermes: cada sessão começa do zero. 7 camadas em concerto (flat files → Qdrant), injeção cirúrgica de contexto, Ground Truth hierarchy. Roda localmente (Docker + Qdrant + Redis + ARQ + Python 3.11+).

Layers: Workspace (markdown injetado todo turno) → Sessions (SQLite FTS5) → Structured Facts (HRR + trust scoring) → Vector Semantic (Qdrant) → Fabric Recall → Wiki auto-curada → Context Injection coordinator.

Fonte: [[03-RESOURCES/sources/memory-os-7-layer-hermes-agent]] | Concept: [[03-RESOURCES/concepts/agent-systems/hermes-agent-architecture]]

## Lições de 60 Dias em Produção (2026-05)

@0xJeff documenta 60 dias rodando Hermes em workflows de análise de investimentos:
- Agentes falham em arquitetura (tools conflitantes), não em inteligência
- Provider direto (DeepSeek) consistentemente melhor que multi-hop (OpenRouter) em latência
- Hermes auto-cria skill quando detecta workflow repetitivo: 3 min manual → 10s na segunda vez
- Hierarquia de tool quality: API/MCP/skill direto > Exa/Firecrawl > Browser CDP > web search

Fonte: [[03-RESOURCES/sources/6-workflows-6-lessons-60-days-hermes]]

## Related Sources

- [[03-RESOURCES/sources/hermes-agent/soulmd-170-line-hermes-operating-contract]]
- [[03-RESOURCES/sources/hermes-agent/paperclip-and-hermes-24-hours]]
- [[03-RESOURCES/sources/hermes-agent/hermes-agent-ui-control-room]]
- [[03-RESOURCES/sources/guides-courses-howtos/how-to-become-hermes-agent-operator]]
- [[03-RESOURCES/sources/memory-context-rag/rohitg00-agentmemory-persistent-llm-wiki]]
- [[04-SYSTEM/wiki/hot]] for recent mentions

## Arquitetura (Masterclass 2026-04-30)

`AIAgent` class em `run_agent.py` — entry point único para CLI, gateway, batch, IDE. Loop ReAct-style, síncrono.

- **6 backends de execução:** local, Docker, SSH, Modal, Daytona, Singularity
- **Hard cap:** 90 turnos/task (subagentes compartilham o budget — anti-loop)
- **Skills progressive disclosure:** Level 0 (nomes+desc, ~3k tokens) → Level 1 (full) → Level 2 (refs)
- **687 skills** no hub: 87 built-in | 79 opcionais | 16 Anthropic | 505 LobeHub
- **Cron em linguagem natural:** `/cron add "every weekday at 8am" "daily digest"`

## Profiles — Multi-Agent Isolado

```bash
hermes profile create designer --clone
hermes profile create programmer --clone  # usa Claude Code como executor
```

Cada profile: config, memória, skills, SOUL.md próprios. Sem compartilhamento.

Programmer + Claude Code: Hermes orquestra, Claude Code executa via OAuth Max (sem API key separada).

## GEPA — Otimização Offline

Ver [[gepa]] — pipeline companion (não integrado ao runtime). Lê traces de execução, gera variantes via busca evolutiva, abre PR. $2–10/run, sem GPU. ICLR 2026 Oral.

## v0.14.0 — Foundation Release (Maio 2026)

- **Grok nativo via SuperGrok OAuth** — sem API key; grok-4.3 com 1M tokens de contexto + `x_search` tool nativa
- **`hermes proxy`** — transforma subscrições Claude Pro/ChatGPT/SuperGrok em API OpenAI-compatível local (Aider, Cline, Cursor, Codex)
- **Cold start:** 14s+ → 1.5s; browser automation 180× mais rápido (shared WebSocket)
- Claude prompt cache cross-session (1 hora); `/handoff` troca de modelo mid-conversation sem perder contexto
- 22 plataformas (novas: Microsoft Teams, LINE, SimpleX Chat); Windows Beta nativo
- LSP auto-diagnóstico pós-write (elimina alucinação "disse que mudou mas não mudou")
- Refactor de base: lazy-loading, OAuth PKCE isolado, plugin architecture mais estável

Source: [[03-RESOURCES/sources/hermes-agent/hermes-agent-v014-foundation-release]]

## v0.12.0 — "The Curator" Release

- **Auto-Curator** — agente background (a cada 7 dias): analisa skills instaladas vs usadas, remove obsoletas, sugere novas. Usa rubric-based self-improvement loop.
- **5 novos providers:** GMI Cloud, Azure AI Foundry, LM Studio (first-class), MiniMax (OAuth PKCE), Tencent Tokenhub
- **Breaking changes:** `flush_memories` removido → usar `memory clear`; slash commands `/provider` e `/plan` removidos; secret redaction agora **desativado por padrão** (opt-in: `redaction.enabled: true`)
- **TUI cold start:** −57% tempo de inicialização

## SKILL.md + Portabilidade

Hermes adota o open standard SKILL.md (Anthropic, dez/2025). Skills de [[03-RESOURCES/entities/Matt-Pocock]] (mattpocock/skills), OpenClaw e Claude Code são portáveis sem modificação. Auto-Curator roda sobre essa base.

## GBrain Integration (2026-05-23)

Hermes é o runtime principal do **GBrain** em produção:
- `gbrain init --pglite` + `gbrain skillpack scaffold --all` → 43 skills para Hermes
- Skillpack cobre: signal capture, ingest (idea/media/meeting), enrichment, querying, brain ops, daily task manager, cron, voice, soul audit, skill creation, eval framework
- Skill routing via `skills/RESOLVER.md` — Hermes lê uma vez por request

Relacionado: [[03-RESOURCES/entities/garry-tan]]

## Hermes Dreaming (v0.1.0, Mai/2026)

Plugin standalone de staged self-improvement por @tonysimons_ (https://github.com/asimons81/hermes-dreaming). Adiciona uma camada de **reviewable autonomy** sobre os mecanismos de self-improvement existentes do Hermes (memory, skills, user notes, facts).

**Princípio**: mutação controlada com receipts. Cada run produz um artifact bundle (manifest.json + REPORT.md + sources.jsonl + proposals.jsonl) que o operador pode inspecionar, validar, aplicar ou descartar antes que qualquer coisa toque o estado live.

**Lifecycle**: `scan → stage → diff → validate → apply → discard`

**Install**: `hermes plugins install asimons81/hermes-dreaming --enable`

Fonte: [[03-RESOURCES/sources/hermes-agent/hermes-dreaming-reviewable-self-improvement]]

## Hermes + Obsidian + NotebookLM Stack (Jun 2026)

Build guide completo: cron job Hermes lê `Sources/` no vault, push para notebook NotebookLM via `notebooklm-py`, ask com grounding, escreve resposta em `Research/YYYY-MM-DD-<slug>.md`.

**Primitivo chave:** no-agent cron mode com `find -newer .last-pushed` — zero tokens LLM, idempotente, escala a milhares de arquivos. Provar o cron primeiro antes das skills LLM-calling.

**4 failure modes:** hallucinar citação via rephrasing interno; ask a notebook vazio (ID mudou); drift vault/notebook após rename; secrets em skill files.

Fonte: [[03-RESOURCES/sources/hermes-obsidian-notebooklm-stack]] | Autor: @tonysimons_

## Obsidian Provider — v0.14 (Mai 2026)

Hermes v0.14 introduziu provider nativo para Obsidian. Um comando conecta o agente ao vault para leitura e escrita de markdown via Obsidian Local REST API plugin (localhost:27123):

```bash
hermes memory setup --provider obsidian --path ~/vault
hermes memory status
```

**Impacto**: o vault passa de contexto *manual* (Claude Projects) para contexto *vivo* — capturas novas ficam disponíveis ao agente automaticamente sem intervenção. Morning brief cross-month em vez de cross-week. Skill files acumulam em ~23 entradas após 6 semanas.

**Scoped access recomendado**: começar com pasta `04-Claude/hermes/` antes de expandir ao vault completo.

Fonte: [[03-RESOURCES/sources/hermes-agent/hermes-agent-obsidian-vault-integration]]

### Self-Running Vault — padrão @zeuuss_01 (Jun 2026)

Resultado documentado em 1.400 notas / 3 semanas: vault tornou-se "parceiro de pesquisa que leu cada palavra". Custo: <$20/mês. 23 skills acumuladas em 6 semanas. 0 horas de manutenção manual.

**Loop de 4 estágios** (2 pontos de toque humano): entrada → ingestão automática → enriquecimento → output entregue. O humano toca na entrada e no output final; as etapas intermediárias rodam no agente.

**SOUL.md — 3 elementos que quase todos pulam:**
1. Obsessões atuais (perguntas específicas *agora*, não interesses gerais) — agente sinaliza qualquer nota que toque nelas, sem ser solicitado
2. Como quer ser desafiado (ex: "surfaça contradições entre o que creio hoje vs. 6 semanas atrás")
3. O que nunca quer (recaps genéricos, bajulação, padding) — nomear elimina

**Compounding duplo**: Obsidian acumula links ao longo de meses; Hermes acumula skills a cada sessão. Quanto mais rico o vault, melhor o raciocínio do agente; quanto mais o agente produz, mais rico fica o vault.

**Limite honesto**: volume de output é inimigo, não meta. Tunar briefs para menos e mais afiado. Julgamento profundo e gosto permanecem humanos.

Fonte: [[03-RESOURCES/sources/obsidian-hermes-autonomous-system]]

## "Personal AI Operating System" — análise v0.16.0 (Jun 2026)

Artigo mapeia 13 camadas Hermes a conceitos de SO tradicional (memória=filesystem, profiles=processos, Kanban=scheduler, Tool Search=dynamic linker, Gateway+SSEP=network stack/compositor, Curator=garbage collector). Confirma 4-layer security stack (Bitwarden → iron-proxy → Promptware Defense → OpenShell) e benchmark Hermes 14/18 vs Claude Code+OpenClaw. Fonte: [[03-RESOURCES/sources/hermes-agent-personal-ai-operating-system]]

## "17 prompts" — workflow operacional para Hermes (Jun 2026)

Conjunto curado de 17 prompts (jobs com trigger + body + escalation rule) que transformam um install vazio em automação real: morning brief, repo watch silencioso, triagem de inbox multi-canal, digest semanal com dedupe, on-call diagnosis, e "save this run as a reusable skill". Erros comuns documentados: schedules vagos sem regra de escalada, jobs horários sem token budget, e modelo local barato derrubando tool calls (resolvido com `hermes config set model anthropic/claude-opus-4.8`). Fonte: [[03-RESOURCES/sources/17-prompts-hermes-run-while-you-sleep]]

## Docs Oficiais — Features (Jun/2026)

Consolidação de 5 páginas oficiais (`hermes-agent.nousresearch.com/docs/user-guide/features/`): Persistent Memory (MEMORY.md/USER.md, session search FTS5), Skills System (progressive disclosure, bundles, Skills Hub, agent-managed skills), Personality & SOUL.md (identity slot #1, built-in personalities), Context Files (.hermes.md/AGENTS.md/CLAUDE.md/.cursorrules priority chain, security scanning, size limits), Tools & Toolsets (terminal backends, Docker persistent container). Inclui comparações diretas com o setup deste vault (Claude Code MEMORY.md/CLAUDE.md/skills). Fonte: [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-persistent-memory]]

## Docs Oficiais — Features Part 2 (Jun/2026)

Consolidação de 17 páginas oficiais (`hermes-agent.nousresearch.com/docs/user-guide/features/`): Memory Providers externos (Honcho dialectic reasoning, OpenViking, Mem0, Hindsight + outros), Plugin System & Event Hooks (gateway/plugin/shell hooks), Kanban Multi-Agent Board (worker lanes, dispatcher, tutorial), Fallback Providers + Provider Routing (resiliência cross-provider, OpenRouter), Code Execution (`execute_code` via RPC socket), Context References (`@file`/`@diff`/`@url`), Persistent Goals (`/goal`, `/subgoal`, Ralph loop), Subagent Delegation (`delegate_task`), Scheduled Tasks (cron), LSP Semantic Diagnostics (~25 language servers), ACP Editor Integration (VS Code/Zed/JetBrains), Batch Processing (geração de trajectory data para fine-tuning). Fonte: [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-features-2]]

## Docs Oficiais — CLI, Configuration, Secrets, Profiles & Deployment (Jun/2026)

Consolidação de 16 páginas oficiais (`hermes-agent.nousresearch.com/docs/user-guide/*` e `/docs/reference/*`): CLI Interface + CLI Commands Reference (slash commands, quick commands, full command tree), Configuração & Modelos (estrutura `~/.hermes/`, terminal backends, checkpoints/rollback, model slots principal + 11 auxiliary, compression, display/streaming/privacy), Secrets & Security (Bitwarden Secrets Manager, defense-in-depth de 7 camadas — approval modes/YOLO/hardline blocklist, container isolation, SSRF/tirith, supply-chain advisories), Profiles & Multi-Agent (profiles, profile distributions, múltiplos gateways), Sessions (resume, handoff cross-platform, session_search FTS5, lineage), Desktop App, Docker (deployment, multi-profile, Dockerfile internals), Git Worktrees, MCP Config Reference (`mcp_servers:` shape completo, tools policy, OAuth 2.1). Fonte: [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-cli-config]]

## Comunidade (consolidação 2026-06-14)

~52 sources da comunidade (Reddit/X/blogs) sobre Hermes, fragmentados, consolidados em 3 pages temáticas em `ai-agents-harness/` (cross-linkadas com as 9 docs oficiais acima, sem duplicar conteúdo):

- [[03-RESOURCES/sources/ai-agents-harness/hermes-community-onboarding]] — masterclasses, quickstart variants, arquitetura memória/skills, comparações OpenHuman/OpenClaw/Claude Code, lições de operadores (6 "diagnósticos neurológicos" de agentes)
- [[03-RESOURCES/sources/ai-agents-harness/hermes-community-integrations]] — 12 integrações de terceiros, voz/telefonia via ElevenLabs+Twilio, X API (`xurl` skill) + SuperGrok zero-cost, iron-proxy security, release notes v0.12.0
- [[03-RESOURCES/sources/ai-agents-harness/hermes-community-multiagent-usecases]] — Kanban field manual, Paperclip/Agent Army (10 agentes paralelos), Personal AI OS 13-layer breakdown, case studies (trading agent, ViralBuilder video stack)

## Relacionado

- [[03-RESOURCES/entities/Nous-Research]] — organização criadora
- [[03-RESOURCES/entities/Claude Code]]
- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
- [[03-RESOURCES/concepts/finance-trading/gepa]]
- [[04-SYSTEM/agents/core/claude-hermes-proxy]] — proxy Claude Code como backend OpenAI-compat
- [[03-RESOURCES/sources/hermes-agent/hermes-agent-masterclass-akshay-pachaar]]
- [[03-RESOURCES/sources/hermes-agent/hermes-agent-v014-foundation-release]]

## Docs oficiais — Integrations (MCP, Messaging, Voice)

[[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-integrations]] — 5 páginas oficiais (hermes-agent.nousresearch.com/docs/) cobrindo MCP (catalog, OAuth, filtering, Hermes-as-MCP-server), Messaging Gateway (~20 plataformas, admin/user tiers, circuit breaker) e Voice Mode (CLI, Telegram/Discord, Discord VC). Referência canônica de config/comandos complementando os relatos da comunidade.

## Docs Oficiais — Messaging Channels (Jun/2026)

[[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-discord]] — 5 páginas oficiais cobrindo setup detalhado por canal: Discord (intents, slash commands, voice FX, forum channels), Telegram (privacy mode, topics/`/topic`, webhook vs polling, local Bot API server), SMS via Twilio (webhook signature, allowlists), Email via IMAP/SMTP (vs. skill Himalaya), e Nous Portal (subscription unificada, 300+ modelos, Tool Gateway). Detalhamento por canal complementando a visão geral do Messaging Gateway em -integrations.md.

## Docs Oficiais — Onboarding (Jun/2026)

Official docs (onboarding): [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-onboarding]] — Installation, Quickstart, Configuration (full reference: terminal backends, compression, auxiliary models, display/streaming/privacy), Learning Path, e a página inicial dos docs, direto de hermes-agent.nousresearch.com/docs/. Complementa as 52 fontes de conteúdo da comunidade já presentes no vault.

## Docs Oficiais — Guides Part 2 (Local LLMs, Tutoriais, Customização, Embedding) (Jun/2026)

Consolidação de 10 páginas oficiais de tutoriais práticos (`hermes-agent.nousresearch.com/docs/guides/*`): Run Local LLMs on Mac (llama.cpp vs MLX/omlx, benchmarks, KV cache quantizado), Run Nemotron 3 Ultra Free (oferta Nous Portal + Nemotron Coalition/NVIDIA), xAI Grok OAuth (SuperGrok/X Premium+, grok-4.3, sem API key), Script-Only Cron Jobs (no-agent mode — watchdogs sem LLM), 3 tutoriais end-to-end (Daily Briefing Bot, GitHub PR Review Agent, Team Telegram Assistant — incluindo DM pairing, Docker terminal backend), Use SOUL.md (identidade primária vs AGENTS.md), Working with Skills (progressive disclosure, Hub, skills vs memory), Using Hermes as a Python Library (`AIAgent`, `chat()`/`run_conversation()`, batch processing, FastAPI/Discord/CI integrations). Inclui síntese de padrões de uso reais via [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-onboarding|User Stories]] (memória/Obsidian backbone, cron natural-language, self-hosting de baixo custo, delegação multi-agente). Fonte: [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-guides-2]]

## Docs Oficiais — Guides Part 1 (Providers, Cron, Webhooks, Plugins, Delegation, Remote Access) (Jun/2026)

Consolidação de 12 páginas oficiais de tutoriais práticos (`hermes-agent.nousresearch.com/docs/guides/*`): AI Providers (28+ providers, Nous Portal recomendado, `hermes model` vs `/model`), AWS Bedrock (Converse API, Guardrails, cross-region inference), Microsoft Foundry (auto-detecção OpenAI/Anthropic transport, Entra ID keyless), Register Microsoft Graph App (pré-requisito Teams pipeline), 5 padrões reais de cron (website monitor, weekly report, repo watcher, data pipeline — todos self-contained, `[SILENT]` trick), Automation Templates (Nightly Backlog Triage, Automatic PR Code Review, Docs Drift Detection), Cron Troubleshooting (jobs not firing/delivery failures/skill loading), webhook-based GitHub PR review (config completo + prompt injection warning), Teams Meeting Pipeline runbook (renovação de Graph subscriptions a cada 72h é crítica), Build a Hermes Plugin (mapa de decisão de superfícies de extensão + exemplo `calculator`), Delegation & Parallel Work (padrões de uso de `delegate_task` — research, code review, compare alternatives, refactoring), OAuth over SSH (loopback redirect fix via SSH tunnel ou `--manual-paste`). Fonte: [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-providers-cloud]]

## Docs Oficiais — Reference (Security, Architecture, Tips, FAQ) (Jun/2026)

Consolidação de 4 páginas oficiais (`hermes-agent.nousresearch.com/docs/`): Security model (defense-in-depth de 7 camadas — approval modes, YOLO, hardline blocklist, container isolation, SSRF/tirith scanning, supply-chain advisories), Architecture internals (`AIAgent` class, data flows CLI/gateway/cron, 28 toolsets, 6 terminal backends), Tips & Best Practices (prompt tips, AGENTS.md/SOUL.md, memory vs skills, cost optimization), FAQ & Troubleshooting (providers, Windows/WSL/Termux, profiles, multi-model delegation, backup/migration). Inclui nota comparativa com [[04-SYSTEM/agents/core/guard]] sobre approval-floor patterns. Fonte: [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-security-model]]

## Evidências
- **[2026-06-23]** Ruixiao Lin[1,2,][†] , Xinhao Deng[2,3,][†] , Qingming Li[1] , Jianan Ma[4,2] , Yunhao Feng[2] , Yuqi Qing[2,3] , Zhenyuan Li[1] , Yechao Zhang[5] , S — [[260623075v1]]
