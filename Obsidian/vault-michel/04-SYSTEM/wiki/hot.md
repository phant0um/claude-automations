---
title: Hot Cache
type: hot-cache
updated: 2026-06-22
sweep-protocol: mensal — remover entradas > 30 dias não acessadas novamente
kv-cache: stable-first — OPERACIONAL+CONCEITOS+INGEST são estáveis → cacheados; SESSÕES ao final
rotation-policy: "SESSÕES-RECENTES max 5 entries; ARQUIVO max 30 rows; ceiling 300 lines; overflow → hill sweep"
---

> **Sweep Protocol:** Curado mensalmente. Entradas > 30 dias sem referência nova → `[ARQUIVO]`.

## Automação Pipeline

- launchd: domingo 22h (Manaus UTC-4 = seg 02h UTC) — pipeline semanal
- Daily scan: 16h diário (bash-only, zero AI cost)
- Script: `04-SYSTEM/scripts/pipeline-semanal.sh`
- Modelos: Claude Haiku/Sonnet (F1–F3) + Claude Pro (F3.5 Nexus review)
- Config: `04-SYSTEM/config/com.michel.pipeline-semanal.plist`
- Controle: [[04-SYSTEM/wiki/controle-pipeline]]
> Agente responsável: `hill` — trigger: "sweep hot.md" ou rotina mensal (`vault-hot-sweep`).
>
> **Rotation Rules (prevenção compression aging — AgingBench 2026):**
> - `[SESSÕES-RECENTES]` max **5 entries**. Overflow → comprimir oldest → `[ARQUIVO]` table row
> - `[ARQUIVO]` max **30 rows** total. Rows > 90 dias → drop
> - Ceiling: **300 linhas**. Se excedido → sweep imediato antes de appends
> - Compression format: `| Data | Evento | Resultado |` (1 linha por sessão)
>
> **Estrutura KV-cache-friendly:** seções estáveis primeiro → cache hit na maioria das sessões.
> `[SESSÕES-RECENTES]` ao final — conteúdo dinâmico não quebra cache do prefixo estável.

---

## [RETRIEVAL GUIDE]

> Carregue apenas a seção relevante — não leia o arquivo inteiro quando a tarefa exige só um bloco.
>
> | Task | Anchor | Linhas típicas |
> |------|--------|----------------|
> | Ações pendentes / SO ops | `SECTION:operacional` | ~35 |
> | Threads de conceito abertas | `SECTION:conceitos-ativos` | ~20 |
> | O que ingestar a seguir | `SECTION:ingest-pendente` | ~10 |
> | Contexto da última sessão | `SECTION:sessoes-recentes` | ~65 |
> | Lookup histórico | `SECTION:arquivo` | ~45 |
>
> Uso: `grep -n "SECTION:" 04-SYSTEM/wiki/hot.md` → obter números de linha → `Read` com `offset`+`limit`.

---

<!-- SECTION:operacional -->
## [OPERACIONAL] — Ações Pendentes

**Agents flatten + resolver reconcile (2026-06-20):**
- ✅ Estrutura flat (commit 4c97666): numbered dirs + 00-SYSTEM-PROMPTS/ removidos
- ✅ AGENTS.md v1.4: 11 agentes fantasma + 22 skills registrados → fs 94 = resolver (drift 0)
- ✅ Raiz agents/ limpa: 3 ref-docs → [[03-RESOURCES/concepts/agent-systems/]]; agentic-reasoning merged; nexus.md v2.0 stale removido → canônico [[04-SYSTEM/agents/nexus-agent-system/nexus]] v3.0.1 (4 inbound repointados)
- ✅ check-resolvable filtro exclui `*-project-setup.md` (commit 977b88d)
- Disk-only: AGENTS.md + 03-RESOURCES gitignored (igual flatten)

**Sources Reorganização (2026-06-10):**
- ✅ 230 arquivos soltos `03-RESOURCES/sources/` → distribuídos em 14 categorias temáticas
- ✅ 185 arquivos merged com pastas existentes (agents→ai-agents-harness +101, claude-api→claude-code-skills +39, skills→skills-prompting-mcp +21, memory→memory-context-rag +11, pkm→pkm-obsidian-second-brain +5, guides→guides-courses-howtos +8)
- ✅ 39 arquivos em novas categorias (llm-theory +11, deployment +2, architecture-design +6, research +4, security +1, metadata +4, mcp +2, specialized +9)
- ⚠️ Estrutura anterior: 858 files em 16 pastas + 1192 files únicos em `08-ARCHIVE/` (A:323, B:702, C:311, D:191)
- Top action: Auditoria de duplicatas (119 entre current e Archive-B); trazer 1TDS-FIAP (78 files) de archive pra fiap-academic
- Ref: [[03-RESOURCES/sources/]] | Manifest: 1280 entries

**Fintech FIAP — docs vault sincronizados (2026-06-01):**
- ✅ `overview.md`: stack corrigida (HTML→React 18+Vite), endpoints REST, rotas frontend, repo structure
- ✅ `progress.md`: Fase 2+3 marcadas ✅; Fase 4 🔄; bloqueios VPN Oracle + 5 entidades sem REST
- ✅ `README.md`: comandos corrigidos (`exec:java`→`spring-boot:run`; `open index.html`→`npm run dev`)
- ✅ `changelog.md`: entradas adicionadas para backend JPA + frontend React
- Ref: [[01-PROJECTS/Fintech/overview]]

**Finance System — Fatura agent (2026-05-29):**
- ✅ Agente Fatura criado — [[04-SYSTEM/agents/finance-system/fatura]] (Santander, Porto Seguro, Revolut; relatório em 06-GENERATED/faturas/)
- ✅ Skill fatura-parser criada — [[04-SYSTEM/agents/finance-system/skills/fatura-parser]] (detecção banco, categorias, fallback)
- Drop zone PDFs: `.raw/faturas/` | Output: `06-GENERATED/faturas/YYYY-MM-banco.md`

**Vault SO — ECC patterns implementados (2026-05-31):**
- ✅ Constrained tools + model_tier formal em guard/hill/verify/extend/review (frontmatter estruturado)
- ✅ Nexus v2.0 — tabela de roteamento + skill injection protocol ao delegar
- ✅ Skill `/evolve` criada — [[04-SYSTEM/skills/core/evolve]] (extrai padrões da sessão → nova skill)
- ✅ Guard adversarial mode — `@guard --adversarial` (attacker + defender + auditor em paralelo)
- ✅ 5 novas skills: `/probe` `/debate` `/trace` `/brief` `/score-drift` (reasoning/ + orchestration/ + core/)
- ✅ 4 skills tier-1 das sources A/B: `/council` `/adversarial-gate` `/decisions` `/meta-learn`
- ✅ `04-SYSTEM/wiki/decisions.md` criado — 2 entradas iniciais desta sessão
- ✅ Melhorias: subagent-team (skill injection no briefing), heavy-think (vs debate), codex-retrospective (link evolve)

**Vault SO — melhorias 2026-05-28/29 (✅ arquivado):** Forge agent + code-optimize skill + Maestro v2.1.0; Nexus SOUL [INVARIANT]; golden-cases (20: Nexus/guard/hill) [[04-SYSTEM/wiki/golden-cases]]; CLAUDE.md invariant markers; ingest-verify v1.0.

**Conceitos criados (2026-05-28):**
- ✅ `llm-evaluation` → [[03-RESOURCES/concepts/agent-systems/llm-evaluation]] (taxonomia completa: métricas, LLM-judge, agent eval, estatística)
- ✅ `browser-skills-agents` → [[03-RESOURCES/concepts/agent-systems/browser-skills-agents]] (Browse.sh, Autobrowse, dual-cursor)
- ✅ `Fireworks AI` → [[03-RESOURCES/entities/Fireworks-AI]] (fine-tuning agentico, self-improving loop)
- ✅ `kepano` → [[03-RESOURCES/entities/kepano]] (CEO Obsidian, obsidian-skills)

**Automações criadas (2026-05-28):**
- ✅ SRS Concurso → [[02-AREAS/concurso/srs-tracker]] + [[07-QUEUE/rotinas/srs-concurso]] (SM2, 16 disciplinas, trigger diário 08h)
- ✅ Vault Health → absorvido em [[07-QUEUE/rotinas/revisao-semanal]] FASE 0 (metricas-ingest retirada 2026-06-20, Fusão A)

**Concurso — pendente:**
- ✅ concurso/legislacao/ + concurso/normas_cfc/ consolidados (116 total, 71 legislação + 45 normas): COMPLETO
- ✅ FIAP PDFs: 64 arquivos ingestados (2026-05-20), source pages existem
- ✅ Stubs FIAP expandidos (fases 1-6 + projeto-fintech + projeto-careplus): 8–10KB cada (2026-05-28)

---

<!-- SECTION:conceitos-ativos -->
## [CONCEITOS-ATIVOS] — Threads Abertas

| Conceito | Status | Próxima ação |
|---------|--------|-------------|
| [[03-RESOURCES/concepts/agent-systems/harness-engineering]] | 11+ sources; Wirth+Belemedath+Srinivasan adicionados | Criar consolidação SDB + 8 pillars + 8 levels |
| [[03-RESOURCES/concepts/agent-systems/agent-lifespan-engineering]] | Criado 2026-05-28 | Ligar hot.md rotation policy como implementação de prevenção |
| [[03-RESOURCES/concepts/agent-systems/floor-raising-vs-benchmark-maxing]] | Criado 2026-05-28 | Golden cases como implementação concreta |
| [[03-RESOURCES/concepts/agent-systems/runtime-architecture-patterns-sdb]] | Criado 2026-05-28 | Link com Srinivasan source page |
| [[03-RESOURCES/entities/AgingBench]] | Criado 2026-05-28 | Referência para eval framework e vault aging monitor |
| [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] | Memory Lifecycle (Mercury consciente/subconsciente) | Link EvolveMem quando ingestado |
| [[03-RESOURCES/concepts/agent-systems/agent-memory-four-layers]] | Criado 2026-05-28 (dunik_7) | Relacionar com agent-memory-architecture |
| [[03-RESOURCES/concepts/agent-systems/agent-security-stack]] | Criado 2026-05-23 | Link Hermes×Bitwarden quando ingestado |
| [[03-RESOURCES/concepts/llm-ml-foundations/inference-engines-hardware-first]] | Criado 2026-05-23 | Link Inference Engines 2026 quando ingestado |
| [[03-RESOURCES/concepts/agent-systems/model-bound-vs-harness-bound]] | Criado 2026-05-24 | 4 fontes convergem; expandir |
| [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]] | Atualizado 2026-05-18 | +Wolfe patterns; aguarda 29-llm-eval ingest |
| [[02-AREAS/concurso/concurso-index]] | 69 legislação stubs expandidos | Expandir stubs FIAP (64 fontes ingestadas) |

---

<!-- SECTION:ingest-pendente -->
## [INGEST-PENDENTE]

**Clippings:** pipeline processou 88 (2026-05-28). Readwise adiciona ~10/dia → próximo run capta.
**Concurso:** 55 sources pendentes → [[06-GENERATED/triagem/triagem-2026-05-23-v2]]
**Score-8 (2026-05-23 backlog):** verificar se processados em 2026-05-24 batch ou ainda em Clippings/
- 29 LLM Evaluation Concepts · 9 Agentic Patterns · Give agents interpreter · Hermes×Bitwarden
- How Claude Code works in large codebases · Inference Engines · Anatomy of Claude Skill
- We Gave AI Agent Conscious Mind · kepano/obsidian-skills

---

<!-- SECTION:sessoes-recentes -->
## [SESSÕES-RECENTES]

### 2026-06-22

**Plano de ações revisão 2026-06-21 — 3 itens executados:**
- Item 1 (frontmatter): 5 agentes TJAM com `model:` adicionado (Fase 2); `claude-hermes-proxy.md` movido de `agents/core/` para `specs/` (não é agente, é spec); exceção `platform: claude-chat` documentada em `conventions.md`
- Item 2 (freeze): registrado em `decisions.md` — sem reorgs estruturais em `04-SYSTEM/agents/` até 2026-07-05
- Item 3 (coverage): 242 sources ingeridas 2026-06-14→21, 188/242 (78%) com concept link, 54 sem link, 110 concepts únicos linkados — **0 concepts/7d = reuso saudável de concepts maduros**, não backlog
- Item 4 (duplicatas): já executado na Fase 2 — 335 duplicatas = lineage (versões originais no archive vs processadas em sources/), não drift

---

### 2026-06-21

**Agentes/skills — sweep de melhorias pós-aprendizados (3 ondas, 11 itens):**
- Onda 1: AGENTS.md tabela memory 3→9 (paths mortos corrigidos, codenomes fullstack documentados); equivalência `description`≈SDD registrada em `conventions.md`; 36ª skill (`managed-agents-quickref`) auditada — sem gap real
- Onda 2: `check-resolvable` rodado — **94/94 agentes + 36/36 skills disco↔AGENTS.md, 0 fantasmas, 0 dead links** (fecha split-brain de 2026-06-20); `agent-registry.md` convertido a ponteiro puro (tabelas stale 2026-05-16 removidas); `ai-agents-index.md` mantém wikilinks de navegação mas perde anotações de modelo/trigger duplicadas (causa raiz do split-brain)
- Onda 3: refresh `opus-4-7`→`opus-4-8` em 28 arquivos de config viva (frontmatter `model:` + tabelas de roteamento), verificado via contagem independente (61 ocorrências, 0 resíduo); 4 citações históricas (`Opus 4.5` em principles.md/fat-skill-thin-harness, changelog progress.md, draft x-thread) preservadas intactas — não são config; `audit-agentes-mensal` ganhou passo 11 (firmware-freshness check mensal, evita recorrência do split-brain)
- Não-ação reportada (fora do escopo, não corrigido): 4 skills com `created: YYYY-MM-DD` placeholder vazio; `ai-agents-index.md` sem 4 sistemas (marketing/nexus/productivity/concurso-coach); `audit-agentes-mensal.md` tem staleness própria maior (23 agentes, paths `/02-domain-experts/` mortos, `name:` duplicado no frontmatter)

---

### 2026-06-10

**Stub cleanup + pipeline-diario v4.3:**
- 39 stubs dup deletados, 5 ghost stubs, 9 preenchidos (archive+web); 132 stubs concurso deletados (dup órfãos)
- sources/ 24→15 subfolders; concepts/ 10→11; 42 Clippings ghost ingest corrigidos
→ [[06-GENERATED/triagem/triagem-2026-06-10]]

→ Arquivado 2026-06-22 (revisão-semanal F1.3) — ver `03-RESOURCES/log.md`

---

## [ARQUIVO]

### 2026-05-24 a 2026-05-20

<!-- SECTION:arquivo -->
| Data | Evento | Resultado |
|------|--------|-----------|
| 2026-06-01 | Stub Fill 03-RESOURCES | 206 stubs preenchidos; zero restantes |
| 2026-05-29 | Pipeline Diário (2 runs) | 82 sources; `interpreter-skills` + `normas-auditoria-cfc` |
| 2026-05-28 | Pipeline Diário + v2 | 95 sources; 4 concepts + 8 entities; manifest→741 |
| 2026-05-25 | Archive A Analysis + Vault Upgrades | 77 agentes auditados; pre-mortem+check-resolvable criados |
| 2026-05-24 | Implementações + lint + ingest Clippings | stop-quality-gate, sprint-contract, 4 skills YAML, hot.md KV restructure; 231 status updates, concurso merge 116 files; 35 fontes ingest, manifest 570→605; Clippings reorg A|B|C|D, D total 704 files |
| 2026-05-20 | Batch FIAP ingest | 60 source stubs Fases 1–6; manifest 405→465 |
| 2026-05-19 | Daily ingest + lint + semanal + manutenção | 40 sources; 1086 files; 21 orphans; 277 dead links; hot.md 368→220 |
| 2026-05-18 | Daily ingest + concepts/skills + semanal | 41 sources; RCE deeplink; agent-eval skill; kv-cache-explainer; security-scanner |
| 2026-05-17 | Daily ingest + semanal + connections | 43 sources; Memory Curse insight; 8 cross-connections |

### 2026-05-13 a 2026-05-16

| Data | Evento | Resultado |
|------|--------|-----------|
| 2026-05-16 | Hermes Masterclass ingest | GEPA concept + Nous-Research entity; 687 skills hub |
| 2026-05-15 | Daily ingest 29+13 sources | goal-command, agent-governance-layers, ai-engineering-checklists |
| 2026-05-15 | Wiki Lint | Orphans 172, dead 266, dup clusters 15; HIGH fixes aplicados |
| 2026-05-15 | Relatório semanal (20/380) | Hermes/goal/HALO/memória/skills/org-AI/estratégia |
| 2026-05-15 | Agente analista BR+EUA v2.1 | 5 modos, NÃO FAÇA, templates por modo |
| 2026-05-14 | Ingest 2 papers | Conductor (Sakana) + Synthetic Computers (MS) |
| 2026-05-14 | Naming pattern rotinas | `{rotina}-{YYYY-MM-DD}.md` standardizado |
| 2026-05-13 | Reorganização vault | SO numerado (00–08), 527 wikilinks atualizados |

### 2026-05-01 a 2026-05-09

| Data | Evento | Resultado |
|------|--------|-----------|
| 2026-05-09 | Relatório semanal (72 sources) | PKM/Self-Writing top; harness > modelo confirmado |
| 2026-05-09 | Ingest 13 clippings + agente MD→HTML | 17 páginas; Karpathy 12 rules ingerido |
| 2026-05-09 | Daily ingest 41 sources | Bulk clippings batch |
| 2026-05-06 | Daily ingest 56 clippings | 49 sources; stubs para 6 research papers |
| 2026-05-04 | FIAP Fase 7 (15 PDFs) | fase-7-index + CONTENT; 21 stubs |
| 2026-05-03 | Dedup Wave 4 (10 ops) | Sources 139→131; 0 broken wikilinks |
| 2026-05-03 | Ingest Karpathy Context Engineering | ai-legible-backend concept; 10.4M→3.7M tokens |
| 2026-05-02 | Wiki Refactor concepts | 115→107 concepts; MCP merge; vault cleanup |
| 2026-05-01 | Clippings Batch (39 sources) | 14 entity pages; bulk sources |
| 2026-05-01 | Nemotron 3 Super (arXiv) | LatentMoE concept; 7 pages |
| 2026-05-01 | Batch Index Enrichment (19 articles) | 10 concepts + 6 entities indexed |

**Arquivo completo:** `03-RESOURCES/log.md`

**Assets — novos (2026-05-29):**
- ✅ Claude Opus 4.8 launch template → `04-SYSTEM/assets/claude-opus-4.8-launch.html` (responsive HTML)

## Pipeline Log

Log cronológico (pipeline diário/semanal) movido para `04-SYSTEM/logs/pipeline-log.md` em 2026-06-20 (hill sweep, ceiling 300). Histórico antigo condensado em `[ARQUIVO]` acima.

→ Arquivado 2026-06-22 (revisão-semanal F1.3) — ver `03-RESOURCES/log.md`

## Pipeline Semanal 2026-06-21
**Veredito:** PIPELINE OK | 125→65 aprovados; 64 sources; orphan 14.1%
→ [[06-GENERATED/relatorios/2026-06-21-relatorio-semanal]]

## Pipeline Semanal 2026-06-22
**Veredito:** PIPELINE OK
**Correção:** versão anterior desta entrada cobria só 5/50 sources (subagente rodou F3 prematuro no próprio batch) — corrigida para refletir run completo (6 batches)
**Triagem:** 76 candidatos → 50 aprovados (14 A, 36 B) → 26 rejeitados
**Ingest:** 50 source pages; F2.5 concept absorption ~16 evidências em concepts existentes + 1 concept novo (diffusion-language-models); F2.9 reflections: 6 Score A (cap spec=3 — overage auto-flagado)
**F3.4:** 1 contradição (scale vs efficiency, carry-over)
**F3.6 top insight:** "loop engineering" como sucessor de "prompt engineering" — 8 sources independentes convergem na mesma semana
**F3.7:** orphan 0% (0/50), avg backlinks 4.26
**Top action:** revisar loop-engineering-patterns contra framing "sucessor do prompt engineering" → kanban alta
**Process gap auto-flagado:** F2.9 cap overage (6 vs 3) por falta de contador global entre dispatches paralelos; off-by-one em triagem (51→50, dedup manual pós-triagem)
→ [[06-GENERATED/relatorios/2026-06-22-relatorio-semanal]]
- ⚠️ daily-scan: 75 candidatos ≥ threshold (30) — considerar rodar pipeline-semanal — 2026-06-22
- 🔄 process-queue 2026-06-22: 1 task na fila, 0 processadas, 1 skip (revisão-manual — `execucao: manual` explícita, aguardando Michel) — [[06-GENERATED/queue/2026-06-22-process-queue-0]]

## Revisão Semanal 2026-06-22
**System:** stale=0 drift=0 (fecho CLAUDE.md 375 arquivos, 100% fresh) | log.md NO-UPDATED
**Lint:** orphans=n/a dead=0 (15 amostra, todos bash false-positive) dups=59 (manifest) | hot.md 247 linhas
**Conexões:** 3 encontradas (1 cross-domain HMM↔algo-trading wikilink aplicado, 1 padrão-3+ já doc, 1 evolução média), 2 wikilinks adicionados
**Meta-coaching:** top waste: structural thrashing 04-SYSTEM/agents/ (3 reorgs/7d, freeze chegou tarde) | WP2 recorrência: 130 arquivos não commitados
→ [[06-GENERATED/revisao-semanal/2026-06-22-revisao-semanal]]
