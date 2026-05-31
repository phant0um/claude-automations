---
title: Hot Cache
type: hot-cache
updated: 2026-05-30
sweep-protocol: mensal — remover entradas > 30 dias não acessadas novamente
kv-cache: stable-first — OPERACIONAL+CONCEITOS+INGEST são estáveis → cacheados; SESSÕES ao final
rotation-policy: "SESSÕES-RECENTES max 5 entries; ARQUIVO max 30 rows; ceiling 300 lines; overflow → hill sweep"
---

> **Sweep Protocol:** Curado mensalmente. Entradas > 30 dias sem referência nova → `[ARQUIVO]`.
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

**Finance System — Fatura agent (2026-05-29):**
- ✅ Agente Fatura criado — [[04-SYSTEM/agents/Finance System/00-SYSTEM-PROMPTS/Fatura]] (Santander, Porto Seguro, Revolut; relatório em 06-GENERATED/faturas/)
- ✅ Skill fatura-parser criada — [[04-SYSTEM/agents/Finance System/skills/fatura-parser]] (detecção banco, categorias, fallback)
- Drop zone PDFs: `.raw/faturas/` | Output: `06-GENERATED/faturas/YYYY-MM-banco.md`

**Vault SO — melhorias pendentes (2026-05-29):**
- ✅ Forge agent criado — [[04-SYSTEM/agents/Fullstack Agent System/00-SYSTEM-PROMPTS/Forge]] (5E rubric, score 0–100, refactor) (2026-05-29)
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

### 2026-05-24

**Implementações:** stop-quality-gate · sprint-contract skill · 4 skills com YAML frontmatter · vault-monday-ops + vault-hot-sweep crons · auto-push.sh (4 guards) · hot.md KV restructure.
**Lint+Melhorias:** concepts path fix · 6 concepts · 231 status updates. concurso/ merge COMPLETO (116 files).
**Ingest Clippings:** 35 fontes (19 score-7 + 16 score-6). Manifest: 570→605.

**Clippings Archive Reorganization:**
Estrutura: A|B|C|D. Raw consolidation: 465 arquivos → D/2026-05-23/. Total D: 704 files.

---

## [ARQUIVO]

### 2026-05-17 a 2026-05-20

<!-- SECTION:arquivo -->
| Data | Evento | Resultado |
|------|--------|-----------|
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

## Pipeline Diário 2026-05-31 v2 (16h scheduled)
**Triagem:** 67 candidatos → 0 aprovados, 67 rejeitados (todos C — duplicatas PDF→MD)
**Causa:** Manifest registrava .pdf; conversor criou .md em Clippings/ — falsos positivos
**Fix aplicado:** +67 entradas no manifest (basenames .md, status:duplicate)
**Ingest:** 0 sources — pipeline encerrado na triagem
**Recomendação:** Normalizar manifest check por stem sem extensão
→ [[06-GENERATED/triagem/triagem-2026-05-31-v2]]
