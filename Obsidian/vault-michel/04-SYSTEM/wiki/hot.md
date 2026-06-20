---
title: Hot Cache
type: hot-cache
updated: 2026-06-20
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

**Vault SO — melhorias pendentes (2026-05-29):**
- ✅ Forge agent criado — [[04-SYSTEM/agents/fullstack-agent-system/forge]] (5E rubric, score 0–100, refactor) (2026-05-29)
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
- **3 templates criados:** `04-SYSTEM/templates/` (concept/source/entity)
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

## Pipeline Log

Log cronológico (pipeline diário/semanal) movido para `04-SYSTEM/logs/pipeline-log.md` em 2026-06-20 (hill sweep, ceiling 300). Histórico antigo condensado em `[ARQUIVO]` acima.
