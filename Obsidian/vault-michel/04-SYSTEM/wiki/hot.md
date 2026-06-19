---
title: Hot Cache
type: hot-cache
updated: 2026-06-07
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
- ✅ Agente Fatura criado — [[04-SYSTEM/agents/finance-system/00-SYSTEM-PROMPTS/fatura]] (Santander, Porto Seguro, Revolut; relatório em 06-GENERATED/faturas/)
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

**Vault SO — melhorias pendentes (2026-05-29):**
- ✅ Forge agent criado — [[04-SYSTEM/agents/fullstack-agent-system/00-SYSTEM-PROMPTS/forge]] (5E rubric, score 0–100, refactor) (2026-05-29)
- ✅ code-optimize skill criada — [[04-SYSTEM/skills/core/code-optimize]] (5 dimensões, modelo por etapa) (2026-05-29)
- ✅ Maestro routing atualizado — Forge na sequência pre-deploy; v2.1.0 (2026-05-29)

**Vault SO — melhorias pendentes (2026-05-28):**
- ✅ Nexus SOUL.md block adicionado (identity, core truths, worldview, voice, manias, memory policy) — [INVARIANT] protegido (2026-05-28)
- ✅ Golden cases criados — 20 casos: Nexus(7) + guard(7) + hill(6) → [[04-SYSTEM/wiki/golden-cases]]
- ✅ Invariant section no CLAUDE.md do vault — `<!-- [INVARIANT] -->` em Principles + Identity (2026-05-28)
- ✅ Verification skill para ingest — `04-SYSTEM/skills/core/ingest-verify.md` (2026-05-28)

**Conceitos criados (2026-05-28):**
- ✅ `llm-evaluation` → [[03-RESOURCES/concepts/agent-systems/llm-evaluation]] (taxonomia completa: métricas, LLM-judge, agent eval, estatística)
- ✅ `browser-skills-agents` → [[03-RESOURCES/concepts/agent-systems/browser-skills-agents]] (Browse.sh, Autobrowse, dual-cursor)
- ✅ `Fireworks AI` → [[03-RESOURCES/entities/Fireworks-AI]] (fine-tuning agentico, self-improving loop)
- ✅ `kepano` → [[03-RESOURCES/entities/kepano]] (CEO Obsidian, obsidian-skills)

**Automações criadas (2026-05-28):**
- ✅ SRS Concurso → [[02-AREAS/concurso/srs-tracker]] + [[07-QUEUE/rotinas/srs-concurso]] (SM2, 16 disciplinas, trigger diário 08h)
- ✅ Métricas de Ingest → [[07-QUEUE/rotinas/metricas-ingest]] (orphans, volume, hot.md health, trigger domingo 22h)

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

### 2026-06-10

**Stub cleanup fase 2 — 03-RESOURCES/sources:**
- 39 stubs duplicados deletados (3 lotes — dup do reorg fase 1)
- 5 ghost stubs deletados (sem fonte, aprovado pelo user)
- 4 stubs preenchidos via 08-ARCHIVE/A+B (company-brain pt1/pt3, horizon-length paper, multi-agent coordination paper)
- 5 stubs preenchidos via WebSearch (match forte): ahe-paper-fudan-nexau, lessons-building-claude-code-skills, post-0x_kaize-token-savings, post-dr-cintas→kepano-obsidian-skills, understanding-hermes-samyak
- 6 stubs preenchidos via WebSearch (match fraco/aproximado, c/ caveat): kloss-goal-23-usecases, garrytan-gbrain, security-scanner-jp, explorax-video-skill, llms-improving-llms, nicos-worktrees
- 1 stub sem match (`fseixas-super-geo-agent-readiness`) → marcado `review-needed`, deleção pendente confirmação
- 132 stubs concurso/legislação → RESOLVIDO 2026-06-10: todos dup órfãos (filename corrompido espaço/cedilha) de conteúdo já completo em legislacao/+normas_cfc/+dirs limpos. Deletados 132 (66 legislação/ + 39 no rmas_cfc/ + 27 top-level), 0 conteúdo perdido. Vault: 416→284 .md em concurso/
- **Folder consolidation:** sources/ 24→15 subfolders (9 small folders merged into ai-agents-harness, skills-prompting-mcp, misc-low-confidence); concepts/ 10→11 subfolders (98 loose .md files distributed into existing folders + 1 new: accessibility; _index.md portal stays in root)

**pipeline-diario v4.3 — 2ª run (16h): manifest path-bug fix + audit archive**
- 42 Clippings/ marcados "ghost ingest" (manifest aponta `pages_created` flat path
  inexistente) → todos Case A: source page real existe em subpasta categorizada
  (causado pelo reorg sources/ 24→15 acima). 6 agentes wiki-ingest paralelos
  corrigiram manifest (`path_corrected_at`) + moveram originais →
  `08-ARCHIVE/B/2026-06-10/`. 0 páginas novas, 0 perda de conteúdo.
- Auditoria 08-ARCHIVE/A+B (1061 arquivos): sem ghost real em clippings/FIAP
  (13 `pages_created:[]` já têm página real; 4 docx FIAP Fase 7 cobertos por
  CONTENT.md consolidado).
- ✅ 155 aulas CGAM (12 cursos): falso positivo (path bug igual aos 42
  Clippings) — os 12 cursos já estavam 100% consolidados em
  `concurso/<disciplina>/index.md`+`aula-NN.md`. Manifest corrigido
  (`path_corrected_at`), 0 trabalho de consolidação necessário.
- ⚠️ Novo: ~20 arquivos "Hermes Agent *" caíram em Clippings/ às 21:53 (sync
  durante a sessão) — não processados, próximo F1 pega.
- Detalhe: [[06-GENERATED/triagem/triagem-2026-06-10]]

---

### 2026-06-07

**Hill-climbing audit 2026-06 — drift cleanup (9 itens):**
- Nexus gates completados: `x-thread-weekly` v2 (único sem gate), `metricas-ingest` v2 (gate incompleto)
- Arquivados: `manutencao-semanal`/`meta-coaching-semanal` → `08-ARCHIVE/rotinas/`; `kore.md`/`brainstorm.md` (stubs duplicados de agentes reais) → `08-ARCHIVE/agent-stubs-duplicados/`
- Skills órfãs Von-Neumann + fat-skill-thin-harness → linkadas em `principles.md` §VII
- **Correção de metodologia:** "8/9 agentes sem Layer 1" era falso positivo (grep de string literal vs. seções equivalentes) — guard/hill/extend/review/spec/verify/vault-audit já cumprem via Identidade+Restrições+Fora do Escopo. `rotina-audit-mensal` v7 corrigida pra checar seção, não string
- Tier de complexidade adicionado ao rubric token-economy (rotinas leves avaliam 5/8 camadas)
- **Probe suites geradas** (6): guard/hill/verify/extend/review/nexus → `06-GENERATED/probe/*-probe-2026-06-07.md` (~16-18 vetores cada, 7 categorias) — desbloqueia score-drift (6.6)
- Rotinas remote deletadas (`07-QUEUE/rotinas/remote/`); `vault-hot-sweep` migrada e agendada (mensal, dia 1, 3h)
→ [[06-GENERATED/audits/rotina-audit-2026-06]]

---

### 2026-06-01

**Stub Fill — 03-RESOURCES completo:**
- **206 stubs preenchidos** (203 conteúdo real + 3 placeholders deletados)
- **127 concepts:** FIAP/OOP (encapsulamento/herança/polimorfismo/MVC/DAO/Collections), LLM/ML foundations, agent systems, Claude/tools, RAG patterns, finance-trading, misc
- **79 entities:** modelos (Claude family, GPT, Gemini, Llama), tools (MCP, GitHub, LangChain, Mem0), orgs (Microsoft, Meta, Google DeepMind), pessoas (heynavtoor, kidpakerot, nateherk, etc.)
- **3 templates criados:** `04-SYSTEM/wiki/templates/` (concept/source/entity)
- **Método:** 8 agentes paralelos (2 sessões, session limit hit na 1ª)
→ Zero stubs restantes em `03-RESOURCES/`

---

### 2026-05-29

**Pipeline Diário 2026-05-29:**
**Triagem:** 37 candidatos → 26 aprovados (A:10/B:16), 11 rejeitados (C:10/D:1)
**Ingest:** 26 sources (ai-agents=20, pkm=4, articles=2)
**Top action:** Criar conceito `interpreter-skills` — TypeScript module embutido em skill, nova extensão do sistema
→ [[06-GENERATED/ingest-report/ingest-diario-2026-05-29]]

**Pipeline Diário 2026-05-29 v2 (batch concurso + ai-agents):**
**Triagem:** 76 candidatos → 70 aprovados (A:17/B:53), 6 rejeitados (C:3/D:3)
**Ingest:** 56 sources (ai-agents=10, concurso-auditoria=45, fiap=1 nova + 15 archive-only)
**Top action:** Criar entity `normas-auditoria-cfc` — index navegável das 45 NBC pages para concurso auditoria
→ [[06-GENERATED/ingest-report/ingest-diario-2026-05-29-v2]]

---

### 2026-05-28

**Pipeline Diário 2026-05-28 — CONCLUÍDO:**
- **Triagem:** 175 candidatos → 151 aprovados (A=81, B=70), 24 rejeitados (C=20, D=4)
- **FIAP:** 64 PDFs já tinham source pages (2026-05-20) → manifest atualizado, arquivados
- **Ingest:** 88 Clippings via 9 agentes paralelos → 65 source pages criadas
- **Conceitos novos:** 4 (agent-lifespan-engineering, agent-memory-four-layers, floor-raising-vs-benchmark-maxing, runtime-architecture-patterns-sdb)
- **Entidades novas:** 8 (koylanai, wirthkarl, trq212-tariq, Akshay-Pachaar, AlexFinn, Andrej Karpathy, Nimbalyst, heygurisingh)
- **Archive:** A=65, B=86, C=+20, D=+4; Manifest: 734 sources
- **Post-pipeline:** harness-engineering +4 fontes; AgingBench entity criada; floor-raising concept criada
- **Post-pipeline extra:** hot.md rotation policy (169 linhas, ceiling 300); CLAUDE.md invariant markers; ingest-verify skill v1.0
→ [[06-GENERATED/ingest-report/ingest-diario-2026-05-28]] · [[06-GENERATED/triagem/triagem-2026-05-28]]

**Pipeline Diário v2 (scheduled incremental):** Triagem: 9 candidatos → 7 aprovados (A=3, B=4) + 2 rejeitados (C=1, D=1). Ingest: 7 source pages criadas. Manifest: 734→741.
**Top action:** Enriquecer `context-engineering.md` com framework 5 layers (Identity→Knowledge→Memory→Tool→Conversation).
**Clusters:** Context Engineering setup (4) · Claude Code engineering (1) · PKM+Obsidian (2).
→ [[06-GENERATED/ingest-report/ingest-diario-2026-05-28-v2]] · [[06-GENERATED/triagem/triagem-2026-05-28-v2]]

---

### 2026-05-25

**Archive A Analysis + Vault Upgrades:**
Model versions: 14 files updated (`sonnet-4-5`→`4-6`, `opus-4-5`→`4-7`). AGENTS.md v1.1: +6 sistemas + 11 rotas (33+ agentes visíveis).
NEW: `pre-mortem.md` (Gary Klein) · `check-resolvable.md` (agentes fantasma) · `frozen-novice-problem` concept.
Guard: +Skill Trust Checklist. Principles.md v2–v4: Resolver Discipline + Harness Stress Test + instruction-following decay data.

**Agent Quality Audit (7-gap item F):**
77 agentes auditados: +Fora do Escopo, +Critério de Qualidade, +Exemplo.
10 sistemas; critérios domain-specific; orchestrators: roteamento, nunca execução direta.

---

## [ARQUIVO]

### 2026-05-24 a 2026-05-20

<!-- SECTION:arquivo -->
| Data | Evento | Resultado |
|------|--------|-----------|
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

## Pipeline Diário 2026-05-30
**Triagem:** 165 candidatos → 161 aprovados (2A, 159B), 4 rejeitados (2C, 2D)
**Ingest:** 18 source pages — concurso=14 (12×CGE-AM + MCASP), artigos=2 (agentic-eng + obsidian-learning), fiap=3 (métricas, node-red, esg)
**Estratégia:** 159 aulas CGE-AM → 12 course-level pages (Karpathy Simplicity First)
**Novo entity:** [[03-RESOURCES/entities/CGE-AM]] — Auditor de Controle Interno, 12 disciplinas mapeadas
**Top action:** Criar active recall (retrieval practice) por disciplina CGE-AM — material ingestado, gap é prática ativa
→ [[06-GENERATED/ingest-report/ingest-diario-2026-05-30]]

**Queue 2026-05-31 (scheduled):** 1 task em `07-QUEUE/`, 0 processadas — `ingest-progress.md` já `revisão-manual` (tracker 350/350 completo, aguarda arquivamento manual)
→ [[06-GENERATED/queue/process-queue-0-2026-05-31]]

## Pipeline Diário 2026-05-31
**Triagem:** 62 candidatos → 36 aprovados (8A + 28B), 26 rejeitados (20C + 6D)
**Ingest:** 34 source pages — ai-agents-harness=8, claude-code-ecosystem=7, hermes-agent=3, memory-context-rag=3, pkm-obsidian=2, open-source=5, outros=6
**Top action:** Aplicar SkillOpt nas 3 skills mais usadas do vault (wiki-ingest, pipeline-diario, relatorio-artigos) — +59.7pp benchmarks reportados com 920 tokens ótimos, sem alterar pesos
→ [[06-GENERATED/ingest-report/ingest-diario-2026-05-31]]

## Manutenção Semanal 2026-05-31
**Lint:** dead-links=25+ orphans-manifest=20 frontmatter-gaps=582 hot-lines=226 agent-sem-project-setup=10
**Conexões:** 7 encontradas (padrões-3+=2, pergunta-resposta=1, cross-domain=4), 3 wikilinks adicionados
**Top action:** Criar concept `skill-optimization-gradient-descent` — 4 sources convergem; fix `created:` em 30+ entities; dead links FIAP
→ [[06-GENERATED/wiki-lint/manutencao-semanal-2026-05-31]]

**Action items executados 2026-05-31:**
- ✅ `created:` adicionado em 36 entities
- ✅ Dead FIAP links: falso positivo (fase-1→7 indexes existem)
- ✅ Concept criado: [[03-RESOURCES/concepts/agent-systems/skill-optimization-gradient-descent]] (score 9, 4 sources, backlinks bidirecionais)

## Pipeline Diário 2026-05-31 v2 (16h scheduled)
**Triagem:** 67 candidatos → 0 aprovados, 67 rejeitados (todos C — duplicatas PDF→MD)
**Causa:** Manifest registrava .pdf; conversor criou .md em Clippings/ — falsos positivos
**Fix aplicado:** +67 entradas no manifest (basenames .md, status:duplicate)
**Ingest:** 0 sources — pipeline encerrado na triagem
**Recomendação:** Normalizar manifest check por stem sem extensão
→ [[06-GENERATED/triagem/triagem-2026-05-31-v2]]

**Action items 4-9 executados 2026-05-31:**
- ✅ Item 4: manifest — 84 orphans marcados como `skipped`
- ✅ Item 5: project-setup.md criado — Nexus, Concurso Coach, Productivity
- ✅ Item 6: concept [[03-RESOURCES/concepts/agent-systems/context-budget-constraint]] (score 8)
- ✅ Item 7: concept [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]] (score 7)
- ✅ Item 8: [[03-RESOURCES/concepts/agent-systems/agent-security-stack]] — Layer 3 skill-security adicionada
- ✅ Item 9: [[03-RESOURCES/concepts/agent-systems/agent-model-routing]] — OptILM + context-budget adicionados

**Action items 10-12 executados 2026-05-31:**
- ✅ Item 10: orphan scan completo (3.632 arquivos) → 363 orphans; 4 concepts acionados; relatório: [[06-GENERATED/wiki-lint/orphan-scan-2026-05-31]]
- ✅ Item 11: [[06-GENERATED/tasks/lessons]] criado — 14 lições operacionais
- ✅ Item 12: tags: adicionadas em sources-index, concepts/_index, entities-index
  — 4 orphan concepts resolvidos: acp-protocol, interpreter-skills, binary-quantization, epistemic-tagging

- ✅ Concurso orphans: 8 entry points linkados em concurso-index (150 aulas brutas, pdf2md — pendente wiki-ingest por disciplina)

## Revisão Semanal 2026-05-31
**System:** stale=0 drift=1 (memory agents sem model: frontmatter)
**Lint:** orphans=363(processados) dead=? dups=1(manifest) frontmatter-gaps=1234 hot.md=267L
**Conexões:** 7 encontradas, 3 wikilinks adicionados → [[06-GENERATED/connections/connections-2026-05-31]]
**Meta-coaching:** top waste: same-day duplicate pipeline (manifest hash não normalizado por stem)
**Top fix:** stem-normalization no manifest + FIAP/concurso absence flag no pipeline
→ [[06-GENERATED/revisao-semanal/revisao-semanal-2026-05-31]]

## Pipeline Diário 2026-05-31 v3 (16h scheduled)
**Triagem:** 24 candidatos → 17 aprovados, 7 rejeitados (5C + 2D)
**Ingest:** 17 sources (ai-agents=11, articles=6, fiap=0)
**Top action:** criar conceito [[03-RESOURCES/concepts/agent-systems/harness-adaptation]] — 5 sources convergem (Life-Harness, Harnesses-for-Alignment, ECC, SkillOpt, Hermes)
→ [[06-GENERATED/ingest-report/ingest-diario-2026-05-31-v3]]

## Pipeline Diário 2026-06-02
**Triagem:** 9 candidatos → 7 aprovados (4A + 3B), 2 rejeitados (2C)
**Ingest:** 7 sources (ai-agents=7, fiap=0, concurso=0)
**Top action:** criar conceito [[03-RESOURCES/concepts/agent-systems/hermes-agent-architecture]] — 3 sources convergem (memory-os, complete-guide, 6-workflows)
→ [[06-GENERATED/ingest-report/ingest-diario-2026-06-02]]

## Melhorias pós-pipeline 2026-06-02
- ✅ Conceito [[03-RESOURCES/concepts/agent-systems/hermes-agent-architecture]] criado (7-layer memory + self-improvement + Kanban)
- ✅ Conceito [[03-RESOURCES/concepts/agent-systems/enterprise-context-layer]] criado (Knowledge/Expertise/Norms framework)
- ✅ Entidade [[03-RESOURCES/entities/cisco-ai-defense]] criada (skill-scanner + AITech taxonomy)
- ✅ [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]] — decision framework ask→Skill→Subagent→Workflow adicionado
- ✅ [[03-RESOURCES/entities/hermes]] — memory-os 7 layers + lições 60 dias adicionadas

## Pipeline Diário 2026-06-06
**Triagem:** 69 candidatos → 58 aprovados (22A + 36B), 11 rejeitados (9C + 2D)
**Ingest:** 58 sources (ai-agents=54, articles=4, fiap=0, concurso=0)
**Top action:** criar conceito [[03-RESOURCES/concepts/ai-agents/context-engineering]] — 8 sources convergem
**⚠️ Alerta segurança:** Zero-Trust eBook — auditar API keys em config/agents vs static-key policy
**Validações externas:** hot.md=Layer3-memory ✓ | Haiku→Sonnet routing ✓ | Nexus=Opus-orchestrator ✓
→ [[06-GENERATED/ingest-report/ingest-diario-2026-06-06]]

## Melhorias pós-pipeline 2026-06-06
- ✅ Conceito [[03-RESOURCES/concepts/llm-ml-foundations/token-compression]] criado (RTK+Headroom stack completo)
- ✅ Conceito [[03-RESOURCES/concepts/agent-systems/agent-observability]] expandido (harness-observed paradigma + adversarial 2-níveis)
- ✅ Conceito [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] expandido (5 padrões Claude Code + context>model evidence)
- ✅ Conceito [[03-RESOURCES/concepts/agent-security]] expandido (Zero-Trust framework + audit checklist)
- ✅ Conceito [[03-RESOURCES/concepts/agent-systems/harness-adaptation]] expandido (portabilidade multi-provider + omarsar0 case)
- ✅ [[04-SYSTEM/wiki/adr.md]] criado (6 ADRs arquiteturais do vault)
- ✅ Entidade [[03-RESOURCES/entities/omarsar0]] criada (Elvis Saravia / DAIR.AI)
- ✅ Auditoria Zero-Trust concluída: PASS — zero static keys (settings, agents, MCP). Detalhe em [[03-RESOURCES/concepts/agent-security]]

## Pipeline Diário 2026-06-06 (2ª execução)
**Triagem:** 46 candidatos → 40 aprovados (7A + 33B), 5 rejeitados (5C) + 1 duplicata removida pré-ingest
**Ingest:** 40 sources (ai-agents=40 — majoritariamente docs oficiais Claude Managed Agents API beta managed-agents-2026-04-01)
**Top action:** avaliar risco "memória envenenada via prompt injection" no modelo hot.md/MEMORY.md — [[03-RESOURCES/sources/using-agent-memory]] documenta o mesmo vetor de ataque na API oficial
**⚠️ Bug detectado:** F1.0b new-candidate match falha em apóstrofo curvo (’) vs reto (') — causou falsa detecção de "novo" para source já ingerido na 1ª execução; corrigido manualmente, normalizar unicode no matching
**Manifest:** +40 (1179→1219) | **Links:** 639 verificados, 0 quebrados (3 corrigidos in-place)
→ [[06-GENERATED/ingest-report/ingest-diario-2026-06-06-v2]]

## Monthly Audit 2026-06-06 | Rotinas
**Score:** 74/100 (9 rotinas ativas)
**Drift:** 6 rotinas (daily-brief, process-queue, ingest-fiap-batch, metricas-ingest, srs-concurso, x-thread-weekly) — 4 são estruturalmente leves, drift parcial falso-positivo
**Quick wins:** (1) atualizar lista de rotinas em rotina-audit-mensal.md — auto-drift, lista 7 rotinas mas vault tem 11; (2) Layer 1 Intent Boundary em 8/9 agentes core com bash/write_file; (3) adicionar Nexus gate em x-thread-weekly (único sem)
**Next focus:** rotina-audit-mensal.md — corrigir self-reference antes do próximo ciclo
→ [[06-GENERATED/audits/rotina-audit-2026-06]]

## F3.3 Vault Impact — execução 2026-06-07
**Disparo:** "executar melhorias do F3.3 Vault impact" (continuação autônoma do pipeline-diario 2026-06-06 v2)
**8/8 itens concluídos:** [[03-RESOURCES/concepts/agent-systems/managed-agents-harness]] · [[03-RESOURCES/concepts/agent-systems/skill-authoring]] · [[04-SYSTEM/logs/skill-audit-2026-06-effective-skills]] · risco "memória envenenada" avaliado em [[03-RESOURCES/concepts/agent-security]] · [[03-RESOURCES/concepts/agent-systems/compound-engineering]] · [[03-RESOURCES/concepts/agent-systems/orchestration-mode-pattern]] · fix unicode F1.0b (pipeline-diario.md) · [[04-SYSTEM/skills/core/managed-agents-quickref]]
**Achado lateral (auditoria skills):** 8 stubs órfãos no root de `04-SYSTEM/skills/` duplicando nomes de skills reais em subpastas — candidatos a limpeza (reportado, não removido)
→ status detalhado na tabela F3.3 de [[06-GENERATED/ingest-report/ingest-diario-2026-06-06-v2]]

## Revisão Semanal 2026-06-07
**System:** stale=0 drift=1 (AGENTS.md "40+ agentes" vs 170 .md/91 specs reais)
**Lint:** orphans=397 dead=373(real) dups-manifest=17 dup-concepts=6 | manifest tem 1 entrada corrompida
**Conexões:** 4 encontradas (0 alta-confiança → 0 wikilinks aplicados)
**Meta-coaching:** top waste: WP2 — 18 arquivos/+346 linhas não commitados (risco perda); WP1 — 2ª semana sem atividade FIAP/concurso
→ [[06-GENERATED/revisao-semanal/revisao-semanal-2026-06-07]]

## Pipeline Diário 2026-06-08
**Triagem:** 139 candidatos → 0 aprovados, 139 rejeitados
**Ingest:** 0 sources (artigos=0, fiap=0, clips=0)
**Top action:** revisar sources criadas hoje
→ [[06-GENERATED/ingest-report/ingest-diario-2026-06-08]]

## Nexus v2 → v3 — Model Router Layer + 4 Agentes Vault-Nativos
**Data:** 2026-06-09
**Status:** PIPELINE OK
**Mudanças:**
- `00-SYSTEM-PROMPTS/model-router.md` — Model Router Layer (Claude vs Ollama)
- `triagem-agent` — F1 scoring A–D via minimax-m3:cloud
- `ingest-agent` — F2 vault builder via minimax-m3 / kimi-k2.6 (FIAP)
- `report-agent` — F3 relatório via deepseek-v4-pro / nemotron-3-ultra
- `vault-reconcile` — auditoria semanal via nemotron-3-ultra (1M ctx)
- `wiki/adr/adr-nx-001-ollama-model-router.md` — decisão de roteamento
- `wiki/adr/adr-nx-002-vault-reconcile-agent.md` — decisão de reconciliação
- README v1.0.0 → v3.0.0 · 7 → 11 agentes
**Guardrails preservados:** SOUL, Shield (Opus), Ledger (git) intocados
**Decisão:** pipeline `pipeline-diario.md` v3.5 mantido como referência — agents vault-nativos operam por cima
**Top action:** testar `@triagem-agent` em próximo batch real (validar modelo Ollama em produção)

## pipeline-diario v4.1 — reverte Ollama, Claude-only
**Data:** 2026-06-09
- F1-F3: Ollama→Claude (Haiku/Sonnet). 3 agentes mantidos, só modelo trocado. ADR-003 supersede parcial ADR-001.
- Motivo: usuário não paga licença Ollama + scoring minimax≠Haiku (F1=scoring)
- triagem-agent v1.1: heurística bash (triagem-scoring, ≥60% sem AI) + batch Haiku borderline (era loop, abaixo cache floor 4096) + cap Clippings 8000
- ingest-agent v1.1: Sonnet único (remove split kimi/FIAP)
- report-agent v1.1: Sonnet+Haiku(F3.5) + F3.0 skip se sources<2
- triagem §Sugestões/Melhorias → ultra (rascunho); F3.2/F3.3=canônico
- guardrail cache: zero data/timestamp vivo em prosa agent-spec/CLAUDE.md
- redução honesta ~35-45% (não 70-80%)
- vault-reconcile NÃO afetado (nemotron 1M ctx, follow-up redesenho)
**Top action:** próximo run real validar `triagem-<data>.md` mostra `motivo: heurística (score X)`

## pipeline v4.2 — 2 levers (varredura 13 sources token-economy)
**Data:** 2026-06-09
- retry cap: máx 3/chamada, 10/fase → abortar+logar, não travar (v4.1 tirou Ollama, ficou sem cap)
- handoff trim: report lê só Aprovados+flags do triagem, não tabela Score Individual inteira
- 3 agentes → v1.2.0
- resto das sources já coberto (model routing=advisor, CLEAN=log filter, SKILL.md=fat-skill) ou harness-level
- zero contradição c/ v4.1

## pipeline-diario 2026-06-09 — F1 triagem completa, F2/F3 PAUSADO
**Data:** 2026-06-09
- 59 candidatos novos (Clippings/, backlog acumulado — normal é poucos/dia)
- Heurística bash: 40/59 resolvidos sem AI (68%). Borderline: 19 → batch Haiku
- Resultado: 21 A, 36 B, 2 C (archive), 0 D
- Aprovados: 57 arquivos → excede limiar de 50 (confirm-before-large-restructure, CLAUDE.md)
- ⚠️ PAUSADO antes de F2 (ingest). Relatório: `06-GENERATED/triagem/triagem-2026-06-09.md`
- Top action: usuário decidir — ingest completo (57 source pages, custo alto) vs
  processar em lotes (ex: 10-15/dia) vs dispatch `claude-obsidian:wiki-ingest` paralelo

## pipeline-diario v4.3 — fix dedup bug + cleanup stubs
**Data:** 2026-06-10
- F1.0b: grep não batia chave manifest c/ prefixo (`Clippings/x.md`) → re-triagem de já-ingeridos
- Fix: checa caminho completo + `/basename"` além do formato antigo
- 9 source pages corrompidas (texto "API Error...") apagadas em 03-RESOURCES/sources/
- F2 (53 pendentes) ainda não processado — sessão anterior estourou limite, 0 escrita
- Top action: rodar F2 em lotes pequenos (1-2 fontes/lote) ao longo de várias sessões

## pipeline-diario v4.3 — F2 completo: 53/53 ingeridos
**Data:** 2026-06-10
- 53 pendentes processados em 5 rounds (2 agentes/round, evita session limit)
- ~41 source pages novas em `03-RESOURCES/sources/` (categoria predominante: ai-agents)
- 12 dedup-skips (já existiam pages cobrindo conteúdo — não duplicadas)
- 1 consolidação (3 guias-de-estudo concurso → 1 página, Karpathy: 1 page > fragmentos)
- Manifest atualizado: 1233→1280 entries (+47, jq atômico)
- Concepts/entities enriquecidos via append: hermes, agent-shared-memory, agent-memory-architecture,
  multi-agent-orchestration, model-routing, agent-vfs-pattern, agentic-sdlc, mythos-moment-ai, etc.
- Concept novo: `ai-skills-testing-process.md` (metodologia Pinterest)
- Todos originais arquivados em `08-ARCHIVE/A` ou `08-ARCHIVE/B`
- Top action: F3 report (cluster analysis) + atualizar `triagem-2026-06-09.md` (53 vs 57)
- ⚠️ dedup-gap pattern: ~12 arquivos do batch já tinham source equivalente não detectada
  pela triagem original (slugs divergentes) — considerar wiki-lint pra achar mais casos
⚠️ FIAP/concurso: 0 commits em 7d — considerar priorização de estudo

## pipeline-diario v4.3 — 2026-06-10 (2ª run, 16h)
**Data:** 2026-06-10
- F1.0: 0 dups. F1.0b: 0 candidatos novos → pipeline encerrado, cost 0
- Brief vazio: `06-GENERATED/triagem/triagem-2026-06-10.md`
- Backlog do dia (53 sources, F2 completo) já reportado na entrada anterior
- Top action: revisar entrada anterior (F3 report pendente) + FIAP/concurso ainda 0 commits 7d

## pipeline-diario v4.3 — 2026-06-10 (3a run, 16h): 19 docs oficiais Hermes
**Data:** 2026-06-10
- F1: 19 candidatos (Clippings, hermes-agent.nousresearch.com/docs/), heurística 100% (0 AI), 19/19 A/B aprovados
- F2: consolidado 19→4 source pages (vs 19 fragmentos) — 4 wiki-ingest agents paralelos
  - `hermes-agent-docs-onboarding.md`, `-features.md`, `-integrations.md`, `-reference.md`
  - todas em `03-RESOURCES/sources/ai-agents-harness/`
- `hermes.md` (entity) +4 seções "Docs Oficiais" linkando as novas pages
- 19 Clippings arquivados: 8→`08-ARCHIVE/A/`, 11→`08-ARCHIVE/B/`. Manifest +19 entries
- F2.8 spot-check: 2 link issues fix (broken `[[tool-gateway]]`, `[[as_document]]`/`[[audio_as_voice]]` falsos wikilinks)
- ⚠️ overlap-risk: vault já tinha 52 sources community Hermes — estes 4 são docs oficiais (canônicos), complementares
- F3: cluster único (ai-agents/Hermes). Cross-conn: paralelos diretos c/ Claude Code memory/CLAUDE.md/skills (Persistent Memory, Context Files), MCP setup do vault, `[[04-SYSTEM/agents/00-core/guard]]` (security)
- F3.5 veredito: PIPELINE OK
- Top action: considerar consolidar os 52 sources community Hermes existentes (muita fragmentação) + FIAP/concurso ainda 0 commits 7d

## pipeline-diario v4.3 — 2026-06-13 (16h): PAUSADO pré-F2 (anomalia volume)
**Data:** 2026-06-13
- F1.0: 0 dups (stem dup = .manifest.json.bak, ignorado)
- F1.0b: 105 candidatos novos (recorde — máx anterior 53)
- F1: heurística 90/105, batch borderline 15/105. 99 aprovados (5A/94B), 6 arquivados (1D/5C)
- Relatório: `06-GENERATED/triagem/triagem-2026-06-13.md`
- ⚠️ ANOMALIA: 99 aprovados = ~2x volume típico. 36/99 são docs oficiais Hermes
  Agent (vault já tem 52 community + 4 official pages 18-31KB, overlap-risk
  flagado 2026-06-10 sem resolução). 9/99 = série mattpocockskills 1-9.
- **Pipeline PAUSADO antes de F2** — aguardando revisão humana. Aprovados
  permanecem em `Clippings/` (não movidos). F3 skipped (0 sources ingeridos).
- Top action: revisar triagem-2026-06-13.md, decidir estratégia de
  consolidação (Hermes append vs novo cluster) antes de liberar F2 +
  considerar consolidar 52 sources Hermes community pendente (flag 2026-06-10)
- FIAP/concurso ainda 0 commits 7d (flag já registrada)

## pipeline-diario v4.3 — 2026-06-14 (16h): BLOQUEADO no NEXUS GATE
**Data:** 2026-06-14
- Nexus gate: decisão pendente de 2026-06-13 (consolidação Hermes 99
  aprovados / overlap 52 community + 4 official) ainda não resolvida —
  Clippings/ ainda com backlog (918 .md), sem evidência de decisão tomada.
- Re-rodar F1 hoje re-detectaria o mesmo backlog (99 aprovados não movidos,
  manifest não atualizado) — repetiria a mesma pausa, gastando tokens à toa.
- ⚠️ NOVO ACHADO (fora do scope do pipeline): 247 arquivos com mudanças
  uncommitted fora de 07-QUEUE/06-GENERATED/Clippings/.raw/sources/AREAS —
  deleções inteiras de agent systems (Concurso Coach/Edu/Finance/etc, ~`git
  status` 248 total). Risco: F3 commit gate (`@ledger`, threshold >3 arquivos)
  rodaria sobre este diff gigante e não-relacionado se disparado — bloqueado
  preventivamente até revisão humana.
- **Pipeline BLOQUEADO no Nexus Gate inicial** — nenhuma fase executada
  (F1/F2/F3 skip, cost: ~150 tokens só o gate). Aguardando instrução humana
  sobre (1) decisão Hermes consolidação 2026-06-13 e (2) os 247 arquivos
  uncommitted (commit separado? revert? trabalho em andamento?).
- FIAP/concurso: 0 commits em 7d (flag já registrada novamente acima).

## pipeline-diario v4.3 — 2026-06-14 (16h, retomada pós-bloqueio): F2/F3 — 99 sources
**Data:** 2026-06-14
- Retomado backlog de 2026-06-13 (99 aprovados, 5A/94B), sem nova rodada F1
  (mesmo backlog, nada movido desde então — F1.0 reaproveitado).
- **Cluster 1 — Hermes Agent docs oficiais (61 arquivos → 5 pages novas)**:
  `hermes-agent-docs-features-2.md` (17, memory providers/plugins/kanban/LSP/ACP),
  `-cli-config.md` (16), `-messaging.md` (5, Discord/Telegram/SMS/Email/Nous Portal),
  `-guides-1.md` (12), `-guides-2.md` (10) + user-stories→append onboarding.md.
  `hermes.md` entity +5 seções "Docs Oficiais". Vault agora tem 9 pages
  oficiais Hermes + 52 community (overlap-risk 06-10 ainda não resolvido —
  consolidação dos 52 community fica pra outra rodada).
- **Cluster 2 — mattpocockskills + Claude/Fable5 guides (23 arquivos)**: 100%
  já ingeridos em sessão anterior 06-13 (`mattpocock-additional-skills-2026-06.md`,
  `claude-cowork-fable5-practical-guides-2026-06.md`, `agent-design-essays-2026-06.md`)
  — manifest não tinha esses entries (gap no F1.0 dedup), agora corrigido.
- **Cluster 3 — misc agent tools/finance/produto (15 arquivos)**: 12 já
  cobertos (`5-agent-tools-skills-2026-06.md`, `quant-trading-signal-frameworks-2026-06.md`,
  `agent-design-essays-2026-06.md`), 3 novos → 2 pages novas
  (`product-growth-essays-2026-06.md`, `nessie-context-layer-2026-06.md`).
- **Manifest**: +99 entries (5 pages_created reais [Hermes] + 2 pages_created
  [cluster 3] + 92 pages_updated apontando pra pages já existentes).
- **Archive**: 99 Clippings → `08-ARCHIVE/[A|B]/2026-06-14/` (5A/94B).
- F2.8 spot-check (3 amostras: features-2, messaging, product-growth-essays):
  tese central OK, profundidade preservada (54KB/14KB/8KB), wikilinks resolvem.
- F3 cross-conn: Hermes features-2 ↔ features.md (memory continuum), ↔
  integrations.md (messaging gateway geral vs setup por canal); nessie-context-layer
  = nova entity candidata (ferramenta de contexto, ainda sem entity própria).
- **F3.5 veredito: PIPELINE OK** (com 2 follow-ups, não bloqueantes):
  (1) ~~consolidar 52 sources Hermes community~~ — ✅ feito 2026-06-14: 37
  fontes consolidadas em 3 pages temáticas (`hermes-community-onboarding`,
  `-integrations`, `-multiagent-usecases`) em `ai-agents-harness/`, cross-link
  na entity [[03-RESOURCES/entities/hermes]] seção "Comunidade";
  (2) considerar criar `[[03-RESOURCES/entities/Nessie]]` (ferramenta nova,
  2 sources já cobrem).
- `sources-index.md` regenerado 2026-06-14 a partir de `.raw/.manifest.json`
  (920 pages, 13 categorias).
- FIAP/concurso: 0 commits 7d (flag mantida).

## 2026-06-15 — Pipeline BLOQUEADO (anomalia Nexus Gate)

- F1.0b scan: 800 candidatos novos (normal: 30-100/dia).
- 790/800 = `Clippings/curso-XXXXXX-aulaXX-*-completo.md` (Receita Federal —
  AFRFB/ATRFB, Português/Legislação), convertidos PDF→MD em 2026-06-14,
  ~200KB/644 linhas cada, nunca passaram por manifest/triagem.
- Outros 10 novos: 5 artigos AI/agents + 5 concurso (cns101/102/201/202,
  serfb-01-gabaritos).
- **Decisão**: pipeline diário bloqueado para o lote de 790 aulas — custo
  estimado (triagem+ingest 790 source pages) excede budget normal em ~10-20x
  e provavelmente precisa estratégia diferente (consolidação por curso/disciplina,
  não 1 page por aula). Aguardando instrução do usuário sobre tratamento
  (batch dedicado vs pipeline normal vs consolidação).
- Os 10 candidatos restantes (5 AI/agents + 5 concurso pequenos) podem seguir
  fluxo normal numa rodada separada se autorizado.
- FIAP/concurso: 24 commits 7d (flag anterior "0 commits" removida — falso,
  havia atividade git fora do escopo de Clippings).

## 2026-06-15 — Pipeline retomado (10 aprovados, rodada manual)

Lote dos 790 aulas RFB segue bloqueado (ver entrada acima). Os 10 restantes
processados manualmente (corpus <20, sem heurística/batch — triagem direta):

**5 AI/agents (Clippings, todos A/B, sem condensação)**:
- "9 Things My Obsidian Vault Does While I Sleep" (@DamiDefi, A) → append
  `pkm-obsidian-second-brain/obsidian-vault-smarter-every-day-automation.md`
  (9 specs N8N node-a-node, complementa arquitetura 4-camadas existente)
- "Autonomous Long-Running Coding Agents" (@omarsar0, A) → novo ensaio #9 em
  `ai-agents-harness/agent-design-essays-2026-06.md` (goal/evaluator/verifier/loop,
  formaliza os 3 gates Sonnet do pipeline)
- "claude code-maxxing: project loop" (@Voxyz_ai, A) → ensaio #10 mesma page
  (CLAUDE.md/.claude/rules/hooks como memória de projeto — confirma
  hot.md/memory/handoff pattern já em uso)
- "The 7-day Hermes setup" (@zaimiri, B) → append
  `ai-agents-harness/hermes-agent-complete-guide.md` (sequência de
  implementação Identity→Memory→Skills→Tools→Telegram→Crons→Profiles)
- "A frontier without an ecosystem is not stable" (@satyanadella, B) →
  ensaio #11 mesma page agent-design-essays (capital humano/token capital,
  valida tese "conhecimento em arquivos = sovereignty")

**5 concurso RFB (todos preservados integrais, sem condensação)**:
- 4 provas AFRFB/ATRFB (manhã/tarde, TIPO 1 BRANCA) → nova pasta
  `02-AREAS/concurso/provas/rfb-afrfb-atrfb-2026/` + index.md
- gabarito preliminar edital 01/2022 (prova 2023-03-19) →
  `02-AREAS/concurso/provas/rfb-edital-01-2022/`

**Manifest**: +10 entries (0 pages_created novos de fato — todos appends/moves
para pages/pastas existentes ou novas mas dentro de estrutura existente).
**Archive**: 5 Clippings AI/agents → `08-ARCHIVE/[A|B]/2026-06-15/` (3A/2B).
5 concurso movidos diretamente (sem archive — pattern "reorganized" igual
aulas, arquivo permanece no destino final).

Spot-check: wikilinks `[[prova-*]]` resolvem (mesma pasta), seções novas
renderizam (14 `##` em agent-design-essays, +1 Complemento em cada page
pkm/hermes).

**F3.5 veredito: PIPELINE OK** (rodada parcial — 10/800).
**Commit gate**: só 2 arquivos rastreados por git mudaram (hot.md,
code-optimize.md pré-existente) — abaixo do threshold (>3), sem commit
automático.

**Top action / pendências**:
1. Decisão sobre lote 790 aulas RFB (ver entrada anterior) — ainda em aberto.
2. Considerar criar entity `Receita Federal do Brasil` (AFRFB/ATRFB) —
   155 curso/aula entries + agora +5 provas, sem entity própria.

## 2026-06-15 — Entities criadas + manifest dedup bug corrigido (lote 789)

**Entities**: `02-AREAS/concurso/entities/receita-federal-do-brasil.md` criada
(cargos AFRFB/ATRFB, legislação carreira, links provas/materias). Nessie já
existia — confirmado, nenhuma ação. Link-back em `concurso-index.md`.

**Lote 789 RFB — causa raiz identificada**: não é conteúdo novo não-processado
— é **manifest dedup bug** (v4.3 changelog). 581/789 arquivos `curso-*-completo.md`
em Clippings/ já foram consumidos em `02-AREAS/concurso/materias/*/aula-NN.md`
(source frontmatter confere 1:1), só faltava registro no manifest →
F1.0b os reapresentava como "candidatos novos" a cada rodada.

**Fix aplicado**: 581 entries registradas retroativamente em
`.raw/.manifest.json` (`hash: batch-moved`, `category: concurso`,
`pages_created` apontando pro aula-NN.md/-questoes.md correspondente,
`note: "registro retroativo (manifest dedup bug v4.3, lote 789)"`).
Manifest: 1408 → **1989 entries**.

**Restante genuinamente novo**: 208 arquivos, ~12 cursos
(244682/244684/244688/244689/244692/249584/249588/249600/249602/249605/
249609/249617/249622/315533/315541/344665) + simulados/gabaritos/conteúdo
extra — decisão de ingest ainda em aberto (escopo menor, ~25% do lote
original).

**Próxima rodada F1.0b**: deve cair de ~800 candidatos pra ~208 + diários.

## 2026-06-15 — Mapa old↔new (10 disciplinas concurso, via Concurso Coach System)

Aulas "old" (sem `curso:`, visão geral/multi-tema) vs "new" (lote AFRFB 06-14,
deep-dive por tema) não são duplicatas — granularidades diferentes. Em vez de
substituir/mesclar conteúdo (custo alto), adicionada seção "## Mapa old↔new
(visão geral vs deep-dive AFRFB)" nos `index.md` de 10 disciplinas — tabela
old aula → subtemas → aulas new relacionadas (navegação, zero rewrite):

| Disciplina | Linhas tabela | Old sem match |
|---|---|---|
| direito-constitucional | 16 | 1 (aula-07) |
| lingua-portuguesa | 16 | 3 (aula-08/09/10) |
| direito-administrativo | 19 | 1 (aula-09) |
| analise-demonstracoes-contabeis | 6 | 1 (aula-04) |
| contabilidade-geral | 27 | 1 (aula-26) |
| financas-publicas | 3 | 1 (aula-03) |
| contabilidade-publica | 24 | 7 |
| afo | 15 | 6 |
| adm-publica | 21 | 1 (aula-12) |
| auditoria-governamental | 14 | 0 |

9 disciplinas (direito-previdenciario, direito-tributario, discursivas-rfb,
estatistica, fluencia-dados, legislacao-aduaneira, legislacao-tributaria,
lingua-inglesa, logica) não têm aulas old — 100% lote AFRFB, sem mapa
necessário.

Commit pendente (10 index.md alterados, abaixo/no threshold — verificar).

## Pipeline Diário 2026-06-16
**Triagem:** 248 candidatos → 234 aprovados (A:230, B:4), 14 rejeitados (C:12, D:2)
**Ingest:** 156 pe-aula files (concurso PE, 9 disciplinas) copiadas 08-ARCHIVE/A→materias/ + 21 articles retroativo
**Manifest:** 1989→2211 (+222: 201 concurso + 21 articles)
**Clusters:** Loop engineering (7 fonts) · Self-improving agents (4) · Concurso PE (8 cursos, 156 aulas) · PKM+Obsidian (2)
**Top action:** Dedup-gap fix — slug-normalization no F1.0b + criar conceito `loop-engineering-patterns`
**Veredito:** PIPELINE OK · 0 AI calls scoring (heurística bash 100%)
→ [[06-GENERATED/triagem/triagem-2026-06-16]] · [[06-GENERATED/ingest-report/ingest-diario-2026-06-16]]

## Pipeline Diário 2026-06-17
**Triagem:** 19 candidatos → 0 aprovados, 19 rejeitados (todos C — dedup-gap generalizado)
**Ingest:** 0 sources (todas já ingeridas em sessões 06-14/15/16, manifest gap)
**Fix:** +19 entries retroativas no manifest (995→1014). Regression test F1.0b: 0 novos após fix
**Archive:** 19 arquivos → 08-ARCHIVE/C/2026-06-17/. Clippings/ 31→12 arquivos
**Veredito:** PIPELINE OK · 0 AI calls (heurística 100%, cost ~150 tokens Nexus gate)
**Top action:** dedup-gap estrutural recorrente (lotes 789+19) — F2 manifest-write bug. Considerar F2.6 audit automático pós-batch
→ [[06-GENERATED/triagem/triagem-2026-06-17]] · [[06-GENERATED/ingest-report/ingest-diario-2026-06-17]]

## Pipeline Semanal 2026-06-19
**Triagem:** 53 candidatos → 46 aprovados (27 A, 19 B), 7 rejeitados (3 C, 4 D — inclui 1 duplicata exata)
**Ingest:** 46 source pages criadas (03-RESOURCES/sources/), tema dominante loop engineering/agent harness (35/46)
**Manifest:** 1014→1106 (+92: 46 sources + 46 aliases sem extensão) — fix manual (subagent não persistiu, sessão expirou antes do F2.6)
**Clusters:** Loop engineering (8) · Agent harness/frameworks (5) · Hermes ecosystem (3) · Second brain/PKM (3) · Modelos Fable/GLM/Kimi (5) · Articles diversos (19)
**Kanban:** +1 item alta (compressão tool-output → token-economy)
**Top action:** appendar técnica de compressão de tool-output (PR Hermes) ao concept de token-economy existente
**Veredito:** PIPELINE OK (ressalva: manifest gap do subagent corrigido manualmente)
→ [[06-GENERATED/triagem/triagem-2026-06-19]] · [[06-GENERATED/ingest-report/ingest-diario-2026-06-19]]

## Pipeline Semanal 2026-06-19b (regression test + segundo lote)
**Regression test:** F1.0b rodado de novo pós-fix manifest — 29 Clippings restantes → só 13 novos (16 já reconhecidos corretamente). Dedup-gap recorrente (06-15/06-16/06-17) confirmado resolvido.
**Triagem:** 13 candidatos → 10 aprovados (6 A, 4 B), 3 rejeitados (3 C)
**Ingest:** 10 source pages criadas, manifest 1106→1126 (+20: 10 sources + 10 aliases)
**Achado notável:** fonte "Inspect at Scale" (Ramp) documenta caso real de RTK em produção (150k sessões) onde economia teórica de US$1M virou líquido questionável por retrabalho — relevante porque este vault usa RTK ativamente. Kanban +1 item (auditar `rtk gain --history`).
**Melhorias implementadas (sessão anterior, F3.3):** entity Eve criada, evidência cross-ref em token-economy
**Veredito:** PIPELINE OK
→ [[06-GENERATED/triagem/triagem-2026-06-19b]]

## Restructure: split 8 batch source pages (2026-06-19c)
**Motivo:** usuário pediu reprocesso de ingests 06-06→06-14 (excl. fiap/concurso). 191 entries no manifest; 168 já eram 1:1 e profundas (53-559 linhas) — sem ação. 8 páginas-batch (consolidavam 45 fontes em "## N." numeradas) quebravam o padrão atual 1-fonte-1-página.
**Ação:** 8 agents paralelos splitaram cada batch em página individual, preservando profundidade + síntese cross-source (distribuída como "Ver também" nas novas páginas).
**Resultado:** 45 novas source pages (`03-RESOURCES/sources/`), manifest +45/-8 keys, sources-index.md atualizado (8 linhas→45), 8 páginas antigas movidas para `08-ARCHIVE/superseded/batch-pages-split-2026-06-19/` (preservadas, não deletadas), ~20 backlinks corrigidos em arquivos que referenciavam as páginas antigas.
**Achado:** 1 wikilink pré-existente quebrado (`04-SYSTEM/wiki/model-routing`, não existe) — descoberto durante split, não inventado link substituto.
