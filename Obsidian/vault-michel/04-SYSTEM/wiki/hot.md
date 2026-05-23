---
title: Hot Cache
type: hot-cache
updated: 2026-05-23
---

## Sources Subfolder Reorganization — 2026-05-23

**580 files** moved from flat `03-RESOURCES/sources/` into 14 subfolders.

| Subfolder | Files |
|-----------|-------|
| `ai-agents-harness/` | 73 |
| `claude-code-cowork/` | 11 |
| `claude-code-skills/` | 52 |
| `fiap-academic/` | 83 |
| `financial-trading/` | 12 |
| `guides-courses-howtos/` | 82 |
| `hermes-agent/` *(new)* | 23 |
| `memory-context-rag/` | 39 |
| `misc-low-confidence/` | 54 |
| `ml-research-papers/` | 45 |
| `open-source-ecosystems/` | 24 |
| `pkm-obsidian-second-brain/` | 26 |
| `skills-prompting-mcp/` | 40 |
| `token-economy-cost/` | 16 |

**3082 wikilinks** updated across vault. `sources-index.md` stays at root.

---

## Batch Ingest FIAP — 2026-05-20

**60 source stubs criados** (Fases 1–6) + 60 entradas no manifest. Fase 7 já existia (15 stubs).

| Fase | Stubs | Tema |
|------|-------|------|
| Fase 1 | 10 | Dev Environment — Python, SCRUM, requisitos |
| Fase 2 | 9 | Prototyping — Python avançado, UML, UX/UI |
| Fase 3 | 9 | Modelling — BD relacional, ER, DDL, normalização |
| Fase 4 | 12 | View — HTML, CSS, Bootstrap, JS, GitHub |
| Fase 5 | 12 | OO — Java, classes, encapsulamento, herança, IA |
| Fase 6 | 12 | Model — JDBC, SQL completo, Java + Oracle |

**Total FIAP no vault:** 75 apostilas (7 fases) → 75 stubs em `03-RESOURCES/sources/fiap-fase-NN-*`.

**Pages criadas:** sources=75 (clips=26, fiap=75, ebook=2)

---

## Relatório Pós-Ingest Semanal — 2026-05-19

**Sources analisadas:** 20 de 224 | **Clusters:** 7

1. **Agent OS & Multi-Harness** — Oz lança multi-harness cloud (Claude Code + Codex + Warp); harness-as-infrastructure. Hermes self-writing skills + agentic evolution = sistemas que melhoram próprio toolset.
2. **RL Research** — scaling laws para RL pós-pretraining (RLVR/STaR). Rubric rewards estende RLVR a domínios não-verificáveis. CNA (Nous): 0.1% neurônios MLP distinguem harmful/benign.
3. **Memory & Continuity** — ActiveGraph (BabyAGI): grafo semântico cross-session. agentmemory: R@5 95.2%, $10/ano, substitui full-context paste. δ-mem: online memory delta O(n).
4. **Arquitetura de Agentes** — *(já coberto 05-18)* sub-agents = compressão; 7 topologias; Hermes Kanban cross-day.
5. **Token Engineering** — cut-87%: cache hit rate como KPI único. Prompt caching: context-first ordering = harness + prompting unificados.
6. **Eval & Benchmarks** — 4 partes de experimento; manual antes de automatizar (3+ runs). Rubric LLM-judge > benchmark contaminado.
7. **AI-Native Paradigm** — AI como colega vs. harris (fricção = feature). Contradição não resolvida: autonomy boundary precisa ser documentada.

**Top insight:** Multi-harness control plane (Oz) marca harness-as-infrastructure — harnesses compõem across cloud providers, não apenas máquinas locais. Novo primitivo arquitetural.
**Top action:** Criar `concepts/model-bound-vs-harness-bound.md` — 4 fontes independentes na semana, conceito ausente do vault.

**Cross-connections chave:**
- [agent-performance-model-bound] ↔ [is-grep-all-you-need] — harness ROI > model upgrade; teoria + PwC empirical convergem
- [activegraph-continuity] ↔ [delta-mem] — mesmo problema (long-running state), camadas ortogonais (graph + attention)
- [hermes-self-writing-skills] ↔ [harnessing-agentic-evolution] — sistemas que escrevem próprias skills = próxima fronteira; 2 fontes independentes

→ [[06-GENERATED/ingest-report/relatorio-pos-ingest-2026-05-19-semanal]]

---

## Manutenção Vault — 2026-05-19

**Claude Code:** 2.1.108 → **2.1.144** (RCE deeplink patched) | Hook duplicado caveman corrigido (marketplace/cache double-load → -30 tokens/turn)

**MOC Fase 7:** fase-7-index.md → 15/15 apostilas linkadas via wikilinks nos títulos

**Connection-finder (cluster memória):** Memory Curse paradox + δ-mem + Memory≡Skills adicionados a `agent-memory-architecture` e `agent-memory-four-layers` | `llm-wiki-pattern` + source wiki+recording

**Conceitos novos:** [[03-RESOURCES/concepts/agent-systems/subagent-pattern-empirical]] — sub-agents vencem 7/10 prod; heurística de decisão

**Frontmatter batch fix:** 175 concept/entity pages → `updated: 2026-05-19` adicionado

**AGENTS.md:** seção "Padrões de Orquestração" adicionada — sub-agent = compressão (não paralelismo), heurística 7/10

**ECC entity:** promovida a hub — 8 cross-links para conceitos relacionados

**Hot.md:** 368 → 220 linhas (-40%) | `projeto-fintech.md` criado (5 dead links) | `_index.md` renomeado (6 dead links)

---

## Queue Processor — 2026-05-19

Queue vazia. 0 tarefas processadas. [[06-GENERATED/queue/process-queue-0-2026-05-19]]

---

## Lint Semanal — 2026-05-19

**1086 files escaneados** | Orphans: 21 | Dead links: 277 | Frontmatter gaps: 194

**Resolvido 2026-05-19:** 5 source stubs corrigidos via rename (288 dead links eliminados): `20-agentic-skills-claude-chatgpt-gemini`, `67-claude-skills-full-dev-team`, `3-formulas-polymarket-trading`, `25-claude-prompts-15-hours-week`, `12-recursos-claude-code`. `concepts-index.md` é orphan mas é destino de `_index` (6 refs) — renomear.

**Resolvido 2026-05-19:** Dead links estruturais — `agentic-reasoning` (3 refs → path corrigido p/ `concepts/`), `agent-patterns` (2 refs → redirect p/ `interactive-vs-agentic-patterns`), `analista-de-investimentos-br-eua` (1 ref → nota de remoção). `projeto-fintech` já existia. Pendente: `Claude Code` agent ref + 175 concept/entity pages sem campo `updated`.

**Orphans notáveis:** kv-cache-llms, geo-generative-engine-optimization, git-worktrees-agent-parallelism (conceitos novos sem inbound links).

→ [[04-SYSTEM/wiki/lint-report-2026-05-19]]

---

## Relatório Pós-Ingest Semanal — 2026-05-18

**Sources analisadas:** 20 de 127 | **Clusters:** 7

1. **Hermes Agent OS** — v0.14 Foundation Release: Grok nativo (SuperGrok OAuth, zero custo extra), proxy OpenAI-compat local, cold start <1.5s, 22 plataformas, browser 180× mais rápido. Four-agent content pipeline em produção.
2. **Arquitetura de Agentes** — sub-agentes = compressão (8k → 200 tokens), não paralelismo. Multi-agent = coordenação. 7 topologias mapeadas; Hermes Kanban = único durable cross-day.
3. **Skills & Harness** — ECC v2 (182k stars, 232 skills, Rust alpha). Superpowers: TDD + subagent-driven com skills auto-trigger. 14 slash commands documentados.
4. **Workflow Reliability** — 90% morrem em 30 dias por falha silenciosa + job description vaga. Fix: success condition explícita + checksum de conteúdo.
5. **Segurança** — Claude Code RCE via deeplink (CVE). `eagerParseCliFlag` não distinguia flag de valor. Patched v2.1.118.
6. **Auto-melhoria** — Manual before automated: 3+ runs manuais antes de automatizar qualquer loop. Tríade: HALO (harness) + LLMs→LLMs (modelo) + Karpathy manual (calibração).
7. **FIAP Fase 7** — 14 caps ingestados: Node.js/TS → React → Next.js → Watson → Node-RED → métricas → ESG. Stack Spring Boot + Next.js = top-3 vagas BR.

**Top insight:** Claude Code RCE deeplink — trust boundary em CLI agents é mais frágil que assumido; qualquer harness com `--prefill` + argv parsing precisa ser context-aware.
**Top action:** `claude --version` → verificar ≥ v2.1.118 agora. Auditar hook setup (pendente 05-17).

**Cross-connections chave:**
- [hermes-proxy] ↔ [ecc-v2-proxy] — padrão proxy-local como primitivo de abstração de custo emerge de dois times independentes
- [sub-agents-isolation] ↔ [workflow-silent-failure] — isolamento de contexto não é só performance; contém propagação de falha silenciosa
- [harris-vibe-code] ↔ [halo-harness] — mesmo diagnóstico (modelo não é o teto), conclusão oposta sobre agência

→ [[06-GENERATED/ingest-report/relatorio-pos-ingest-2026-05-18-semanal]]

---

## Relatório Pós-Ingest Semanal — 2026-05-17

**Sources analisadas:** 20 de 147 | **Clusters:** 6

1. **Memory Paradox** — Memory Curse (CMU/Harvard/Michigan): mais memória = mais defecção em MAS. δ-mem resolve custo, não cooperação. Mem0 temporal decay ativo.
2. **Harness Engineering** — grep > RAG (PwC). HALO +10% alterando só harness. Hook fights: 34% tokens desperdiçados por cascata PostToolUse.
3. **Multi-Agent** — failure attribution = gargalo (survey). AGENTS.md como onboarding para agentes.
4. **ML Research** — Lighthouse Attention O(n) (Nous). Mech interp: calculadora geométrica em Llama 3.1. Autonomous math discovery (Google).
5. **Skills & Context** — superpowers: metodologia completa TDD+subagents. Context = 3 camadas (imediato/sessão/persistente).
6. **Org AI** — a16z: SoR → SoI. Dorsey: company as mini-AGI, 5 layers → 2-3.

**Top insight:** Memory Curse paradox — recall expandido erode cooperação em multi-agent. Mais memória ≠ melhor sistema.
**Top action:** Auditar hook setup do vault-michel (PostToolUse cascade = 34% token waste potencial).

**Cross-connections chave:**
- [memory-curse] ↔ [delta-mem] — paradox + técnica na mesma semana; problema não é onde se pensava
- [llms-improving-llms] ↔ [halo-rlm] — auto-melhoria composável: modelo (descoberta) + harness (otimização)
- [is-grep-all-you-need] ↔ [memory-skills-same-harness] — primitivos simples > abstrações complexas

→ [[06-GENERATED/ingest-report/relatorio-pos-ingest-2026-05-17-semanal]]

---

## Connections 2026-05-17 | 8 conexões encontradas

**Top:** C8 — agent-governance-layers ↔ SOUL.md → gap conceitual "governed autonomy" (autonomia vs. controle, mesmo dia, visões opostas)
**Runner-up:** C5 — Why Second Brain Breaks (05-01) → agentmemory + mem0 chegaram como resposta técnica 16 dias depois
**Padrão 3+:** Harness > modelo (HALO + grep-vs-embeddings + PageIndex) → HeavySkill sugere ganhos migram para dentro do modelo
**Novos conceitos sugeridos:** governed-autonomy · compounding-ratchet · intentional-forgetting · physical-agent-sensing
→ [[06-GENERATED/connections/connections-2026-05-17]]

---

## Arquivo — 2026-05-13 a 2026-05-16 (compactado)

| Data | Evento | Resultado |
|------|--------|-----------|
| 2026-05-16 | Hermes Masterclass ingest | GEPA concept + Nous-Research entity; 687 skills hub |
| 2026-05-15 | Daily ingest 29+13 sources | goal-command, agent-governance-layers, ai-engineering-checklists criados |
| 2026-05-15 | Wiki Lint | Orphans 172, dead 266, dup clusters 15; HIGH fixes aplicados |
| 2026-05-15 | Relatório semanal (20/380) | Hermes/goal/HALO/memória/skills/org-AI/estratégia |
| 2026-05-15 | Agente analista BR+EUA v2.1 | 5 modos, NÃO FAÇA, templates por modo |
| 2026-05-14 | Ingest 2 papers | Conductor (Sakana) + Synthetic Computers (MS) |
| 2026-05-14 | Naming pattern rotinas | `{rotina}-{YYYY-MM-DD}.md` standardizado |
| 2026-05-13 | Reorganização vault | SO numerado (00–08), 527 wikilinks atualizados |

**Arquivo completo 05-01 a 05-09:** `03-RESOURCES/log.md`

## Arquivo — 2026-05-01 a 2026-05-09

| Data | Evento | Resultado |
|------|--------|-----------|
| 2026-05-09 | Relatório semanal (72 sources) | PKM/Self-Writing top; harness > modelo confirmado |
| 2026-05-09 | Ingest 13 clippings + agente MD→HTML | 17 páginas; Karpathy 12 rules ingerido |
| 2026-05-09 | Daily ingest 41 sources | Bulk clippings batch |
| 2026-05-06 | Daily ingest 56 clippings | 49 sources; stubs para 6 research papers |
| 2026-05-04 | FIAP Fase 7 (15 PDFs) | fase-7-index + CONTENT criados; 21 stubs |
| 2026-05-03 | Dedup Wave 4 (10 ops) | Sources 139→131; 0 broken wikilinks |
| 2026-05-03 | Ingest Karpathy Context Engineering | ai-legible-backend concept; 10.4M→3.7M tokens |
| 2026-05-02 | Wiki Refactor concepts | 115→107 concepts; MCP merge; vault cleanup |
| 2026-05-01 | Clippings Batch (39 sources) | 14 entity pages; bulk sources |
| 2026-05-01 | Nemotron 3 Super (arXiv) | LatentMoE concept; 7 pages |
| 2026-05-01 | Batch Index Enrichment (19 articles) | 10 concepts + 6 entities indexed |

**Arquivo completo:** `03-RESOURCES/log.md`

## Triagem 2026-05-17
**Candidatos:** 57 | **Aprovados:** 43 | **Rejeitados:** 14
FIAP Fase 7 (15 PDFs) + 2 ebooks + 27 Clippings aprovados. 14 rejeitados movidos para `08-ARCHIVE/triagem-rejeitados/`.

---

## Daily Ingest 2026-05-17

**Total novos:** 43 | **Triagem:** sim (43 aprovados / 14 rejeitados de 57 candidatos)
**Pages criadas:** sources=43 (clips=26, fiap=15, ebook=2)

### Clippings — Pesquisa
- [[03-RESOURCES/sources/memory-context-rag/delta-mem-efficient-online-memory]] — online memory δ-mem (NTU/Fudan/SJTU)
- [[03-RESOURCES/sources/ml-research-papers/beyond-individual-intelligence-multi-agent-survey]] — survey MAS: collaboration, failure attribution, self-evolution
- [[03-RESOURCES/sources/ml-research-papers/llms-improving-llms-agentic-discovery]] — LLMs descobrindo test-time scaling (UMD/Google/Meta)
- [[03-RESOURCES/sources/memory-context-rag/memory-curse-expanded-recall-cooperative-intent]] — memory curse: recall expandido erode cooperação (CMU/Harvard/Michigan)
- [[03-RESOURCES/sources/memory-context-rag/is-grep-all-you-need-agent-harnesses-search]] — PwC: harness > RAG vetorial
- [[03-RESOURCES/sources/ml-research-papers/geometric-calculator-inside-neural-network]] — mech-interp: calc geométrico em Llama 3.1
- [[03-RESOURCES/sources/ml-research-papers/efficient-pretraining-token-superposition]] — Nous Research: token superposition
- [[03-RESOURCES/sources/memory-context-rag/long-context-pretraining-lighthouse-attention]] — Nous Research: Lighthouse attention O(n)
- [[03-RESOURCES/sources/ml-research-papers/ai-co-mathematician-google]] — Google: agente co-matemático

### Clippings — Prático (Claude/Agents)
- [[03-RESOURCES/sources/memory-context-rag/memory-skills-same-harness-tricalt]] — memória + skills = mesmo harness
- [[03-RESOURCES/sources/guides-courses-howtos/5-agent-content-pipeline-300k]] — 5-agent content pipeline
- [[03-RESOURCES/sources/skills-prompting-mcp/claude-mcp-servers-complete-guide-cyrilxbt]] — MCP zero-to-everything (@cyrilXBT)
- [[03-RESOURCES/sources/hermes-agent/paperclip-hermes-10-agents]] — Paperclip + Hermes 10 agents
- [[03-RESOURCES/sources/memory-context-rag/agent-wiki-recording-not-bigger-desk]] — wiki + recording > context window maior
- [[03-RESOURCES/sources/claude-code-cowork/claude-cowork-setup-es]] — Claude Cowork setup ES
- [[03-RESOURCES/sources/open-source-ecosystems/wilwaldon-claude-code-frontend-toolkit]] — frontend toolkit GitHub
- [[03-RESOURCES/sources/open-source-ecosystems/tmylla-awesome-llm4cybersecurity]] — 612+ papers LLM4Cybersecurity
- [[03-RESOURCES/sources/open-source-ecosystems/light-heart-labs-dreamserver]] — local AI stack completo
- [[03-RESOURCES/sources/hermes-agent/openhuman-vs-hermes-vs-openclaw]] — comparativo agent operators
- [[03-RESOURCES/sources/guides-courses-howtos/10-claude-code-workflows-build-software]] — 10 workflows Claude Code
- [[03-RESOURCES/sources/guides-courses-howtos/12-claude-code-setup-tricks-real-engineer]] — 12 setup tricks
- [[03-RESOURCES/sources/guides-courses-howtos/backend-1m-users-design]] — backend 1M users
- [[03-RESOURCES/sources/guides-courses-howtos/40-claude-code-practices-10x]] — 40 práticas Claude Code
- [[03-RESOURCES/sources/pkm-obsidian-second-brain/obsidian-beginner-productivity-trap]] — anti-patterns Obsidian
- [[03-RESOURCES/sources/hermes-agent/post-shannholmberg-hermes-prototype-production]] — Hermes prototype→prod
- [[03-RESOURCES/sources/pkm-obsidian-second-brain/openai-founder-obsidian-second-brain-jp]] — Obsidian second-brain JP

### FIAP — Fase 7
- [[03-RESOURCES/sources/fiap-academic/fiap-fase-07-01-juntando-tudo]]
- [[03-RESOURCES/sources/fiap-academic/fiap-fase-07-02-estudo-caso-backend]]
- [[03-RESOURCES/sources/fiap-academic/fiap-fase-07-03-nodejs-typescript]]
- [[03-RESOURCES/sources/fiap-academic/fiap-fase-07-04-reactjs-vite]]
- [[03-RESOURCES/sources/fiap-academic/fiap-fase-07-05-reactjs-estrutura-props-router]]
- [[03-RESOURCES/sources/fiap-academic/fiap-fase-07-06-reactjs-state-effect-context]]
- [[03-RESOURCES/sources/fiap-academic/fiap-fase-07-07-nextjs]]
- [[03-RESOURCES/sources/fiap-academic/fiap-fase-07-08-nextjs-api-mock]]
- [[03-RESOURCES/sources/fiap-academic/fiap-fase-07-09-estudo-caso-frontend]]
- [[03-RESOURCES/sources/fiap-academic/fiap-fase-07-10-plataformas-chatbots]]
- [[03-RESOURCES/sources/fiap-academic/fiap-fase-07-11-chatbot-watson]]
- [[03-RESOURCES/sources/fiap-academic/fiap-fase-07-12-analise-metricas]]
- [[03-RESOURCES/sources/fiap-academic/fiap-fase-07-13-orquestracao-node-red]]
- [[03-RESOURCES/sources/fiap-academic/fiap-fase-07-14-grand-finale]]
- [[03-RESOURCES/sources/fiap-academic/fiap-fase-07-cap6-sustentabilidade]]
- **Entidade nova:** [[03-RESOURCES/entities/fiap/fase-7]]

### Ebooks
- [[03-RESOURCES/sources/fiap-academic/ebook-ciencia-de-dados-luiza-reixach]] — Data Science completo (ADS FIAP)
- [[03-RESOURCES/sources/claude-code-skills/ebook-complete-guide-building-skill-claude]] — guia definitivo Claude Skills



## Triagem 2026-05-18 (CORRIGIDA)
**Candidatos:** 67 | **Aprovados:** 46 | **Rejeitados:** 21
Bug corrigido: `Clippings/` dir key escondia 59 arquivos; unicode NFC/NFD fix para FIAP Fase 5
Top aprovados: Agent Evaluation (10), ECHO Terminal Agents (10), codegraph (10), 12-factor-agents (10), セキュリティ診断 (10), RAO (10)
Clusters novos: agent-evaluation, GEO, Hermes ecosystem (8 files)

---

## Queue Processor — 2026-05-18

0 tarefas processadas. 1 skip (revisão-manual): `07-QUEUE/ingest-progress.md` — tipo `progress`, 350/350 completo, sem campo priority.
Output: [[06-GENERATED/queue/process-queue-0-2026-05-18]]

## Concepts criados 2026-05-18
- **NEW**: `concepts/llm-ml-foundations/kv-cache-llms.md` — mecanismo Attention(Q,K,V), conexão prompt-caching/hot.md
- **NEW**: `concepts/ai-strategy-org/geo-generative-engine-optimization.md` — MCP+llms.txt+OAuth para AI search
- **UPD**: `concepts/agent-systems/agent-evaluation-production.md` — +Wolfe long-horizon patterns +ECHO world model

## Skills + Agente criados 2026-05-18
- **NEW skill** `~/.claude/skills/agent-eval.md` — framework eval: paradigma, trajetória, scaffold vs modelo
- **NEW skill** `~/.claude/skills/kv-cache-explainer.md` — diagnóstico cache miss, TTL, hot.md optimization
- **NEW agent** `04-SYSTEM/agents/standalone/security-scanner.md` — 3 modos: static/dynamic/harness; complementa guard.md

## Daily Ingest 2026-05-18
**Total novos:** 41 (de 46 triagem aprovados; 5 já em manifest)
**Pages criadas:** sources=41 | entities atualizadas: 5+ (everything-claude-code, hermes, trq212-tariq, Akshay-Pachaar, neil-xbt, Cocoon-AI, Claude Code)
**Manifest:** 320 → 361 entries

### Clusters dominantes
- **Agent harness/skills** (15+): codegraph, ECC v2, 100-repos, agency-agents, 12-factor, archify, super-geo
- **Hermes ecosystem** (5): v0.14, 入门指南, SuperGrok+X, 12 integrations, Akshay top-12
- **Token economy / benchmarks** (3): 87%-7-days, Auggie 33%-less, kv-caching
- **Security** (3): RCE deeplink, sabakan 100% detection, AI infra repos
- **Eval/research** (4): Cameron Wolfe eval guide, ECHO world models, RAO recursive, DFT writing
- **Multi-agent vs sub-agents** (2): Sub-agents Full Guide (7/10 win), 多智能体 division of labor
- **Strategy** (1): Diamandis 6 moats unhobbling

### Pages-chave do dia
- [[03-RESOURCES/sources/ai-agents-harness/sub-agents-vs-multi-agents-full-guide]] — production data: sub-agents win 7/10
- [[03-RESOURCES/sources/ai-agents-harness/echo-terminal-agents-world-models]] — terminal world model grátis via GRPO
- [[03-RESOURCES/sources/ai-agents-harness/12-factor-agents-humanlayer]] — princípios produção LLM software
- [[03-RESOURCES/sources/skills-prompting-mcp/claude-code-rce-deeplink-vulnerability]] — RCE patched v2.1.118, deeplink risk
- [[03-RESOURCES/sources/token-economy-cost/cut-token-bill-87-percent-7-days]] — token engineering open-source
- [[03-RESOURCES/sources/ai-agents-harness/agent-evaluation-detailed-guide]] — Cameron Wolfe long-horizon eval patterns
- [[03-RESOURCES/sources/memory-context-rag/codegraph-pre-indexed-knowledge-graph]] — 94% fewer tool calls

## Triagem 2026-05-19
**Candidatos:** 119 | **Aprovados:** 107 | **Rejeitados:** 12
Fontes: 62 FIAP PDFs (Fases 1-6) + 4 images + 1 article + 40 Clippings
Rejeitados: tweets baixo valor, listicles sem densidade, fora escopo (datacenter infra, iOS biz, design)
Anomalias: 1 arquivo mislabeled (X API → ActiveGraph), 1 já ingested no frontmatter, 4 images com ingested-date sem manifest entry
Relatório: [[06-GENERATED/triagem/triagem-2026-05-19]]

## Daily Ingest 2026-05-19

**Total novos sources:** 40 (40 md) | **Triagem:** sim ([[06-GENERATED/triagem/triagem-2026-05-19]]) | **FIAP PDFs:** deferred
**Manifest:** +44 entries (361 → 405) | **Clippings cleaned:** 39

### Sources criados


**ai-agents**

- [[03-RESOURCES/sources/claude-code-skills/20-claude-skills-most-builders-don-t-know-exist]]
- [[03-RESOURCES/sources/memory-context-rag/activegraph-a-continuity-layer-for-long-running-agents]]
- [[03-RESOURCES/sources/ai-agents-harness/agent-evaluation-a-detailed-guide]]
- [[03-RESOURCES/sources/ai-agents-harness/agent-performance-model-bound-versus-harness-bound]]
- [[03-RESOURCES/sources/guides-courses-howtos/before-you-build-you-need-to-understand-how-llms-actually-work]]
- [[03-RESOURCES/sources/misc-low-confidence/claude]]
- [[03-RESOURCES/sources/misc-low-confidence/claude-code]]
- [[03-RESOURCES/sources/hermes-agent/claude-hermes]]
- [[03-RESOURCES/sources/claude-code-skills/composiohqawesome-claude-skills-a-curated-list-of-awesome-claude-skills-resource]]
- [[03-RESOURCES/sources/ai-agents-harness/harnessing-agentic-evolution]]
- [[03-RESOURCES/sources/hermes-agent/hermes-agent-masterclass]]
- [[03-RESOURCES/sources/open-source-ecosystems/hkudscli-anything-cli-anything-making-all-software-agent-native-cli-hub-httpscli]]
- [[03-RESOURCES/sources/misc-low-confidence/how-openhuman-works-and-how-to-set-it-up-in-5-minutes]]
- [[03-RESOURCES/sources/guides-courses-howtos/how-to-become-a-claude-power-user-for-free-full-course]]
- [[03-RESOURCES/sources/hermes-agent/how-to-become-a-hermes-agent-operator]]
- [[03-RESOURCES/sources/guides-courses-howtos/how-to-build-llm-architectures-from-scratch-10-practical-lessons-most-people-lea]]
- [[03-RESOURCES/sources/misc-low-confidence/how-to-make-your-hermes-agent-go-supergrok]]
- [[03-RESOURCES/sources/misc-low-confidence/i-tried-letting-my-scheduled-agents-deliver-only-html-and-i-m-not-going-back]]
- [[03-RESOURCES/sources/ml-research-papers/imbad0202academic-research-skills-academic-research-skills-for-claude-code-resea]]
- [[03-RESOURCES/sources/misc-low-confidence/introducing-multi-harness-orchestration]]
- [[03-RESOURCES/sources/claude-code-skills/k-dense-aiscientific-agent-skills-a-set-of-ready-to-use-agent-skills-for-researc]]
- [[03-RESOURCES/sources/memory-context-rag/prompt-caching-clearly-explained]]
- [[03-RESOURCES/sources/misc-low-confidence/teng-linnotebooklm-py-unofficial-python-api-and-agentic-skill-for-google-noteboo]]
- [[03-RESOURCES/sources/skills-prompting-mcp/the-5-claude-prompting-techniques-anthropic-engineers-use-internally-that-aren-t]]
- [[03-RESOURCES/sources/open-source-ecosystems/tinyhumansaiopenhuman-your-personal-ai-super-intelligence-private-simple-and-ext]]
- [[03-RESOURCES/sources/claude-code-skills/top-13-skills-et-plugins-claude-code-en-2026]]

**articles**

- [[03-RESOURCES/sources/ai-agents-harness/2026-ai-native]]
- [[03-RESOURCES/sources/ai-agents-harness/ai-native]]
- [[03-RESOURCES/sources/ai-agents-harness/from-models-to-systems]]
- [[03-RESOURCES/sources/misc-low-confidence/post-by-aurimas-gr-on-x]]
- [[03-RESOURCES/sources/misc-low-confidence/post-by-itsolelehmann-on-x]]
- [[03-RESOURCES/sources/misc-low-confidence/post-by-suryanshti777-on-x]]

**ml-research**

- [[03-RESOURCES/sources/ml-research-papers/applying-statistics-to-llm-evaluations]]
- [[03-RESOURCES/sources/ml-research-papers/continual-learning-with-rl-for-llms]]
- [[03-RESOURCES/sources/ml-research-papers/rl-scaling-laws-for-llms]]
- [[03-RESOURCES/sources/ml-research-papers/rubric-based-rewards-for-rl]]
- [[03-RESOURCES/sources/ml-research-papers/targeted-neuron-modulation-via-contrastive-pair-search]]
- [[03-RESOURCES/sources/ml-research-papers/the-anatomy-of-an-llm-benchmark]]
- [[03-RESOURCES/sources/hermes-agent/x-api-hermes-via-xurl-skill]]

**obsidian**

- [[03-RESOURCES/sources/guides-courses-howtos/how-to-build-an-obsidian-dashboard-that-shows-you-everything-that-matters-today]]

Relatório: [[06-GENERATED/ingest-report/ingest-diario-2026-05-19]]

## Triagem 2026-05-23
**Candidatos:** 108 | **Aprovados:** 71 | **Rejeitados:** 37
Clusters: agent-memory (4 fontes), harness-engineering (3), obsidian-claude (3)
Top scores: Code-as-Agent-Harness (9), Compiling-Agentic-Workflows (9), EvolveMem (8), I-Connected-Claude-Obsidian (8), Anatomy-Claude-Skill (8)
Conceitos faltando: `agent-memory-layers`, `harness-engineering` | Entidades: Hermes Agent, Garry Tan
Relatório: [[06-GENERATED/triagem/triagem-2026-05-23]]

### Ingest 2026-05-23 — Prioritárias Triagem
- **I Connected Claude to Obsidian Vault** → [[03-RESOURCES/sources/pkm-obsidian-second-brain/i-connected-claude-obsidian-vault-damidefi]] — síntese diária via N8N + CLAUDE.md como cognitive partner
- **COG second-brain** → [[03-RESOURCES/sources/pkm-obsidian-second-brain/huytieu-cog-second-brain]] — 17 skills, 6 worker agents, People CRM, auto-evolve; inspirado GBrain/GStack

## Pipeline Diário v2 2026-05-23
**Triagem v2:** 212 candidatos → 212 aprovados, 0 rejeitados (64 FIAP PDFs + 71 ai-agents + 77 concurso)
**Ingest:** 24 sources (ai-agents-harness=7, memory-rag=5, ml-research=3, open-source=2, pkm=2, skills=1, concurso=3)
**Skipped (já existiam):** i-connected-claude-obsidian, multi-agent-arch, rag-deep-dive, vector-db, mcp-deep, codegraph, cog-second-brain = 7 dups
**Top action:** criar conceito `harness-engineering` — 5 sources convergem (code-as-agent-harness, three-harness-layers, agent-harness-breakdown-chinese, harness-engineering-10x-chinese, how-to-build-ai-os)
**Destaques score 9:** Code as Agent Harness (UIUC/Meta/Stanford 100p survey), Compiling Agentic Workflows (128-462× mais barato), EvolveMem (+25.7% LoCoMo)
**Pendentes next run:** 188 candidatos (64 FIAP PDFs + 55 concurso 5-7 + 69 ai-agents 5-7)
→ [[06-GENERATED/ingest-report/ingest-diario-2026-05-23]]
→ [[06-GENERATED/triagem/triagem-2026-05-23-v2]]

## Ingest Legislação 2026-05-23 — Batch Completo
**69 novas source pages** criadas em `03-RESOURCES/sources/concurso-legislacao/`
**Manifest:** 562 entradas (was 493 → +69 legislação)

### Estrutura final concurso-legislacao/
| Pasta | Arquivos | Highlights |
|-------|----------|-----------|
| `irpf/` | 6 | L7713, L4506, IRRF, D9580, PRONAC, Deduções incentivadas |
| `irpf/manual-mir/` | 10 | Rendimentos T/K/Outros, Bens F/Imóveis, Despesas, Doações, Decisão, Entrega |
| `tributario/` | 22 | CTN, CSLL, ITR, PIS/COFINS, CIDE, LRF, IOF, IPI, REFIS, IFRS |
| `administrativo/` | 13 | L8112, NLLC, Improbidade, LAI, EPD, Carreiras RFB, Concursos |
| `previdenciario/` | 6 | RGPS, LCOS, LBPS, Fator Prev |
| `societario/` | 4 | SA, CC, IFRS, Finanças Públicas |
| `constitucional/` | 2 | CF88, EC132 |
| `aduaneiro/` | 5 | II, IE, Reg Aduaneiro, IN1600 |
| `penal/` | 3 | CP, Crimes Tributários, Sonegação |

→ [[02-AREAS/concurso/concurso-index]]
→ [[03-RESOURCES/sources/concurso-legislacao/irpf/lei-7713-irpf-1988]]
→ [[03-RESOURCES/sources/concurso-legislacao/constitucional/cf88-compilada]]
→ [[03-RESOURCES/sources/concurso-legislacao/tributario/lei-5172-ctn-1966]]
