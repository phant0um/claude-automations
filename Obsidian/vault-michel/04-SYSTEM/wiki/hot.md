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

**Career Uplift — plano 6 meses (2026-06-24):**
- Novo projeto: [[01-PROJECTS/career-uplift/overview]] — gap analysis Amplify IT (26 vagas) + plano 6 fases
- F1: TS/React/Next.js · F2: Node/Docker/CI-CD · F3: Go · F4: LangChain/FastAPI · F5: AWS/Terraform · F6: Go advanced/Portfolio
- Go incluído como segunda linguagem backend (mercado cloud-native, alta demanda/baixa oferta)
- Projeto prático central: migração FutManager ecosystem (vanilla JS → Next.js → Docker → Go API → AI layer → AWS)
- 7 projetos alternativos mapeados de sources do vault (cass clone, React Doctor, Knowledge Graph, Quant Loop, Security Auditor, Memory Layer, RAG Agent)
- Curriculum completo: [[01-PROJECTS/career-uplift/curriculum]] — 48 aulas via edu-system agents (Tutor + Stack + Sintese + Trilha)
- Fluxo semanal: @tutor (conceito) → @tutor/@stack (lab) → @sintese (flashcards Anki + resumo Obsidian) — sem aulas tradicionais
- Ref: [[01-PROJECTS/career-uplift/progress]] | [[03-RESOURCES/sources/guides-courses-howtos/effective-go-official-guide]]

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

### 2026-06-28

**process-queue run:** 1 task na fila → `plano-melhorias-agents-2026-06-27.md` skip (revisão-manual). 48+ sub-tarefas excede backpressure (max 10/run); sub-tarefas T9/T39 editam `AGENTS.md` e `Constitution.md` (invariantes → exigem confirmação humana). Task permanece para ação humana. Consolidado: `06-GENERATED/queue/2026-06-28-process-queue-1.md`.

---

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
- 🔄 process-queue 2026-06-22: 1 task na fila, 0 processadas, 1 skip (revisão-manual — `execucao: manual` explícita, aguardando Michel) — [[06-GENERATED/queue/2026-06-22-process-queue-0]]

## Revisão Semanal 2026-06-22
**System:** stale=0 drift=0 (fecho CLAUDE.md 375 arquivos, 100% fresh) | log.md NO-UPDATED
**Lint:** orphans=n/a dead=0 (15 amostra, todos bash false-positive) dups=59 (manifest) | hot.md 247 linhas
**Conexões:** 3 encontradas (1 cross-domain HMM↔algo-trading wikilink aplicado, 1 padrão-3+ já doc, 1 evolução média), 2 wikilinks adicionados
**Meta-coaching:** top waste: structural thrashing 04-SYSTEM/agents/ (3 reorgs/7d, freeze chegou tarde) | WP2 recorrência: 130 arquivos não commitados
→ [[06-GENERATED/revisao-semanal/2026-06-22-revisao-semanal]]

## Pipeline Semanal 2026-06-22 (Run 2)
**Veredito:** PIPELINE OK
**Triagem:** 227 candidatos → 157 novos → 64 evaporados → 93 existentes → 93 aprovados (63 A, 30 B)
**Ingest:** 97 source pages; manifest +186 entries; 93 Clippings arquivados (63 A, 30 B)
**F2.8:** 3 spot-checked — 1 link corrigido, 1 page thin expandida
**F3.6 top insight:** Loop engineering amadureceu de conceito para framework — 20 sources em 2 runs, com implementações reais (Foundry, OpenEnv, Pi LoopFlows)
**F3.7:** orphan 68% (esperado para novas pages), avg backlinks 0.40 → flag connection-finder
**Top action:** atualizar loop-engineering-patterns concept com 12 novas sources
**Process gap:** 3/3 subagentes timaram (600s) — cleanup manual. Considerar batch size 32→15.
→ [[06-GENERATED/relatorios/2026-06-22-relatorio-semanal-run2]]

## Connections 2026-06-22 (run 2) | 8 connections found
**Top:** "Process > output" meta-pattern — 5 independent sources converge: agent value is in verifiable process steps, not confident answers
→ [[06-GENERATED/connections/connections-2026-06-22-run2]]

## Pipeline Semanal 2026-06-23
**Veredito:** PIPELINE OK
**Triagem:** 129 candidatos → 57 novos (apos dedup) → 18 aprovados (5 A, 13 B) → 39 C/D arquivados
**Ingest:** 18 source pages criadas; manifest +54 keys (18 entries x 3); 18 Clippings arquivados (5 A, 13 B)
**Dedup:** 1 duplicata exata ("By 2027 AI Fluency") arquivada; 1 arquivo fantasma limpo
**F2.8:** 3 spot-checked — teses validadas, informacao preservada, frontmatter correto
**F3.7:** orphan 50% (40/80 links unresolved — concepts/entities a criar), avg backlinks 4.44 → flag connection-finder
**F3.6 top insight:** "Beautiful Nonsense" — 3 sources independentes (@ItsRoboki, @DamiDefi, @s4yonnara) convergem no mesmo padrao: agent loops sem validador externo geram output convincente mas invalido. Validador = CI server pattern.
**Top action:** criar concepts agent-loop-pattern, beautiful-nonsense, prompt-debt (40 links unresolved pointing to estes)
**Process gap:** candidates_aprovados.txt foi corrompido por rescore script (pipe-delimited grade appended) — fix aplicado, mas recomendo add validation no F1.0b
→ [[06-GENERATED/relatorios/2026-06-23-relatorio-semanal]]
- ✅ process-queue 2026-06-23: 1 task na fila, 0 processadas, 1 arquivada (plano-acoes-revisao-2026-06-21 já executada manualmente 2026-06-22) — [[06-GENERATED/queue/2026-06-23-process-queue-1]]

## Pipeline Semanal 2026-06-23 (Run 2)
**Veredito:** PIPELINE OK
**Triagem:** 237 candidatos → 230 aprovados (97%) → 7 C/D rejeitados
**Ingest:** 230 source pages; manifest +460 entries; 230 Clippings arquivados (187 A, 43 B)
**F2.8:** 3/3 spot-checked — APROVADO
**F2.5:** 222 evidence entries appended em 14+ concepts/entities (3 subagentes paralelos)
**F2.9:** 99 Minha Síntese escritas (placeholders substituídos por reflexões reais)
**Link repair:** 51 concept/entity stubs criados, 1215/1215 wikilinks resolvem (100%)
**F3.6 top insight:** Agent runtime é o novo attack surface — 8+ sources, vetores distintos (skill poisoning, memory contagion, tool poisoning, runtime audit)
**F3.6 insight 2:** Loop engineering consolidado — 6+ sources convergem: loop > agent como unidade de valor
**F3.6 insight 3:** Formal methods atingiu tipping point — 5+ papers aplicando verificação em agent code
**Padrões detectados:** 24 recorrentes (agent harness 11+, security 10+, skills 5+, multi-agent 6+)
**Commits:** 0cd48ef (pipeline), 95966bd (deep analysis + link repair)
**Top action:** Preencher 51 stubs com definições reais. Recategorizar 74 "concurso" → articles/ai-agents.
**Pendências:** F2.10 SRS tracker (166 Score A). Connection-finder (orphan rate). Recategorização.
→ [[06-GENERATED/relatorios/2026-06-23-relatorio-semanal-run2]]

## Pipeline Semanal 2026-06-23 (Run 3)
**Veredito:** PIPELINE OK
**Triagem:** 237 candidatos (batch 1) → 100% evaporation (Readwise sync) → re-scan 39 → 38 aprovados (32 A, 7 B) → 1 dedup
**Ingest:** 38 source pages (35 ai-agents, 3 finance); manifest +76 entries; 38 Clippings arquivados (32 A, 7 B)
**F2.8:** 3 spot-checked — teses validadas, informação preservada, frontmatter correto
**F3.6 top insight:** Loop engineering amadureceu de conceito para disciplina — "delegar julgamento, não código". O gate (humano/CI) é o ponto crítico, não o agent.
**F3.7:** orphan 100% (38/38 new pages sem backlinks) — subagentes não linkaram concepts/entities. Flag connection-finder.
**Top action:** atualizar loop-engineering-patterns concept com 5 novas sources + criar entity GLM-5.2 e concept multi-model-fusion
**Process gap:** File evaporation 237→39 (100% batch 1). Subagentes sem vault context = zero wikilinks. Próxima run: passar concepts/entities como contexto.
→ [[06-GENERATED/relatorios/2026-06-23-relatorio-semanal]]
⚠️ commit pendente — vault-michel não tem .git próprio (git root = ~/). Arquivos rastreados: .raw/.manifest.json, hot.md, relatorio. Considerar init git repo no vault.
- ⚠️ daily-scan: 141 candidatos ≥ threshold (30) — considerar rodar pipeline-semanal — 2026-06-24

## Pipeline Semanal 2026-06-24
**Veredito:** PIPELINE OK
**Triagem:** 141 candidatos → 126 aprovados (89.4%) → 15 C/D rejeitados
**Ingest:** 124 source pages (105 ai-agents, 15 articles, 4 fiap); manifest +168 entries; 126 Clippings arquivados (72 A, 54 B)
**F2.8:** 3/3 spot-checked — APROVADO (1 malformado, resto sólido)
**F2.5:** 487 evidence entries appended em 55+ concepts
**F2.9:** 3 Minha Síntese escritas
**F3.7:** orphan 11/124 (8%) — excelente (vs 100% em runs anteriores)
**F3.6 top insight:** Agent security é o novo attack surface definitivo — 20+ sources, vetores distintos
**Clusters:** Loop Engineering (23), Agent Architecture (20), Inference/Token (15), RAG (15), Coding Agents (12)
**Top action:** Rodar connection-finder nos 11 orphans
→ [[06-GENERATED/relatorios/2026-06-24-relatorio-semanal]]

## Pipeline Semanal 2026-06-24 (Incremental — 41 Clippings restantes)
**Veredito:** PIPELINE OK
**Triagem:** 41 candidatos → 40 aprovados → 1 D rejeitado
**Ingest:** 40 source pages (35 ai-agents, 5 articles); manifest +80 entries; 40 Clippings arquivados (15 A, 25 B)
**F2.5:** 138 evidence entries appended
**F2.9:** 3 reflections (NVIDIA BioNeMo, metacognição Claude Code, agent loops scenarios)
**Clippings/:** 0 arquivos remanescentes
**Total dia:** 166 source pages, 625 evidence appends, 6 reflections

## 2026-06-24 — Skill Audit Pocock + Self-Improvement Loop Wiring

**Skill audit:** 37 vault skills auditadas contra princípios Pocock (Writing Great Skills)
- Completion criterion: 4/37 (11%) — crítico
- Failure modes: 4/37 (11%) — crítico
- Sprawl (>80 linhas): 34/37 (92%) — 5 skills >200 linhas (triagem-scoring 722, pre-ingest-dedup 466, ingest-verify 462)
- Progressive disclosure: 0/37 — nenhuma skill tem GLOSSARY
- No-op risk: 16/37 com NUNCA x3+
→ [[06-GENERATED/audits/2026-06-24-skill-audit-pocock]]

**Ingest:** [[03-RESOURCES/sources/ai-agents/writing-great-skills-matt-pocock]] (Score A)
**Conceito:** [[03-RESOURCES/concepts/ai-agents/skill-authoring-principles]]

**Self-improvement loop wiring (sessão 2026-06-24):**
- 7 rotinas: lessons log adicionado (daily-scan, ingest-fiap-batch, process-queue, srs-concurso, srs-sources, vault-hot-sweep, vault-reconcile-semanal)
- 63 agentes: bloco ## Self-Improvement injetado
- 3 skills: complexity-ratchet, code-optimize, archive-cleanup
- `06-GENERATED/tasks/lessons.md` criado (sink central, append-only, cap 30)
- adversarial-gate-v2 integrada ao pipeline-semanal (F2.10 Batch Quality Gate)
- Rotinas compatíveis com autoresearch-loop: 4→11/14 (29%→79%)
- X-thread: [[06-GENERATED/x-thread/2026-06-24-ai-weekly]] (meta-loop encadeado, 13 tweets)

## 2026-06-24 — Pocock Skills Analysis + P0-P5 Upgrades

**Ingest:** [[03-RESOURCES/sources/ai-agents/matt-pocock-skills-14-analysis]] — 14 skills engineering/personal analisadas
**Conceito:** [[03-RESOURCES/concepts/ai-agents/skill-authoring-principles]] atualizado com patterns Pocock

**P0 — diagnose v1→v2:** ETAPA 0 Build Tight Feedback Loop adicionada (10 ways de loop, tight/red-capable concepts, proibição de hipótese sem loop)
**P1 — tdd skill criada:** vertical slices, tracer bullets, anti-pattern horizontal, good/bad tests, mocking em system boundaries
**P2 — git-guardrails hook:** `.claude/hooks/block-dangerous-git.sh` (PreToolUse, bloqueia push/reset --hard/clean -D)
**P3 — grill-me upgraded:** Doc Capture section (cria ADRs + glossário durante grilling, sharpen fuzzy terms)
**P4 — decisions upgraded:** Domain Modeling Ativo (challenge terms, sharpen language, cross-ref código, ADR sparingly com 3 critérios)
**P5 — code-optimize upgraded:** Deep Modules section (Ousterhout: shallow→deep, deletion test, friction signals, deepening opportunities)

**Vault score:** 38 skills (37 + tdd nova), 36/38 com Completion + Failure modes (95%)

## 2026-06-24 — 5 Skills Faltantes Criadas + 2 Upgrades

**5 skills criadas (Pocock engineering):**
- `implement` — PRD/issues com TDD, typecheck, review, commit
- `prototype` — throwaway: TUI para lógica, variant switcher para UI
- `resolving-merge-conflicts` — resolver merge/rebase preservando ambas intents
- `to-issues` — quebrar PRD em vertical-slice tracer bullet issues
- `triage` — state machine: needs-triage → needs-info → ready-for-agent/human/wontfix

**2 upgrades:**
- `pena` (agente): Melhoria de Escrita ganhou DAG de seções + max 240 chars/parágrafo (de edit-article)
- `spec-lifecycle`: FASE 1 ganhou "sintetizar sem entrevistar" + FASE 1.5 Identify Test Seams com leading word `seam` (de to-prd)

**Cobertura Pocock 14/14:** 6 upgrades (P0-P5) + 5 skills criadas + 2 upgrades + 1 já existia (obsidian-vault via CLAUDE.md) = 14/14 ✅

## 2026-06-24 — process-queue
✓ Queue: 0 tarefas processadas | Alta: 0 | Média: 0 | Baixa: 0 | Erros: 0 | Nexus: aprovado (queue vazia)
→ [[06-GENERATED/queue/2026-06-24-process-queue-0]]
- 2026-06-24: Nova rotina skill-audit (mensal, 1ª segunda) — skill health (Pocock criteria) + agent behavioral drift (score-drift + vault-probe) + Pocock coverage check. 15→16 rotinas ativas.
- ⚠️ **CORREÇÃO 2026-06-28:** Contagem real = **15 rotinas** (`ls 07-QUEUE/rotinas/*.md | wc -l = 15`). A entrada acima cita "15→16" mas skill-audit nunca foi criada como arquivo em `07-QUEUE/rotinas/` — drift recorrente detectado em revisão-semanal 2026-06-27 e 2026-06-28. Contagem canônica: **15**.
- 2026-06-24: 5 integrações de skills externas — forge Query Review (8 categorias Supabase, on-demand), skill SDD (subagent-driven development, meio termo ralph-loop↔subagent-team), guard Agentic AI Top 10 (10 vetores agentic), requesting-code-review receiving section, plan eval data (Global Constraints 0/5→5/5, Interfaces 0→100%, right-sizing 9.4→8.4)
- ⚠️ daily-scan: 681 candidatos ≥ threshold (30) — considerar rodar pipeline-semanal — 2026-06-27

## Revisão Semanal 2026-06-27
**System:** stale=0 drift=1(rotinas 15 vs 16 citado) anomalia=git-toplevel
**Lint:** orphans~766(heurística,ruído esperado) dead~329(missing-pages backlog) manifest-dups=370
**Conexões:** 3 encontradas (confiança média/baixa), 0 wikilinks adicionados
**Meta-coaching:** top waste: F3.3 Vault Impact retrofitting (3 commits de patch pra 1 item)
→ [[06-GENERATED/revisao-semanal/2026-06-27-revisao-semanal]]

## Vault Reconcile 2026-06-27 — SKIP
**Motivo:** 0 arquivos em 08-ARCHIVE/A/ + B/ — gate cost-0, sem reconciliação a fazer.

## Revisão Semanal 2026-06-28
**System:** stale=0 drift=1(rotinas 15 vs 16 citado, recorrente) anomalia=git-toplevel confirmada (.git no home dir — SEGURANÇA, human-gated)
**Lint:** orphans~766 dead~839 manifest-dups=370 (estável)
**Conexões:** 3 encontradas, 2 wikilinks adicionados (agent-security-stack ↔ mosaicleaks+agenticos)
**Meta-coaching:** top waste: F3.3 retrofitting fragmentado (recorrente, piorou 3→5 commits)
→ [[06-GENERATED/revisao-semanal/2026-06-28-revisao-semanal]]
- ⚠️ daily-scan: 746 candidatos ≥ threshold (30) — considerar rodar pipeline-semanal — 2026-06-28

## Pipeline Semanal 2026-06-28
**Veredito:** PIPELINE OK (partial batch)
**Triagem:** 774 candidatos → 722 aprovados (93.3%), 52 rejeitados (51 evaporados + 1 C)
**Ingest:** 5 source pages criadas (batch parcial — 717 backlog)
**Clusters:** Loop Engineering, Context Engineering, Wiki LLM, Personal Agent
**Top action:** formalizar concept loop-engineering (4-layer stack) + progressive-disclosure
**F2.5:** 2 concepts absorvidos (harness-engineering + agent-loop-design)
**F2.9:** 1 reflection (self-improving-company-brain)
→ [[06-GENERATED/ingest-report/ingest-diario-2026-06-28]]

## 2026-06-28 — pipeline-semanal
**Batch**: 774 candidatos → 722 aprovados → 722 source pages
**Clusters**: ai-agents (333), memory-context-rag (196), llm-theory (56), claude-code-skills (42)
**Quality**: F2.10 OK, F2.8 3/3 spot-check OK, 0 erros
**Insights**: Loop Engineering dominante (10+ sources), Agent Memory converging, Claude Code ecosystem expanding
→ [[06-GENERATED/relatorios/2026-06-28-relatorio-semanal]]

## 2026-06-28 — melhorias/otimizações (5 subagentes paralelos)
**Despachado**: hygiene + plano-melhorias T0-T48 + F3.3 items
**Fontes**: triagem, revisao-semanal ×2, meta-coaching, connections, ingest-diario, plano-melhorias 2518 linhas
→ Resultados pendentes (5 subagentes background)

## 2026-06-28 — melhorias concluídas (plano-melhorias T0-T48)
**Plano**: 48 tarefas, 5 subagentes paralelos, 44 arquivos criados, 17 modificados
**Lote 1**: ADR 0001, Constitution §7 What&Why, backend-dev+standards+forge, triagem domain tagging, 6 hot-*.md, F3.8 síntese cruzada, F2.11 explainer
**Lotes 2-3**: AGENTS.md v1.6 aidd, 3 writing skills, council+debate mechanisms, golden-example Go, iwe, iFixAi frontier-risk, prd-taskmaster, Agent-Reach, 3 security skills, archify, design.md, pentest ref, sources
**Lotes 4-13**: cc-switch, OpenBB, ECC, firecrawl, design cluster, skill sourcing, karpathy compare, repo-radar, tooling-eval, prd-grade, memory-engine eval, timesfm, hedge-fund, opendraft, gstack+office-hours+STRIDE, firmware universal, cite-or-flag, 3 domain guards, hooks spec, wiring, stack SaaS, evo+hill tree-search, paperclip, no-op audit, rewind+ship-page
**F3.3 items**: 5/5 concluídos (loop-engineering 4-layer, progressive-disclosure, generator-evaluator-split, evaporation-reconcile skill, context-budget-alert hook)
**Hygiene**: rotinas drift corrigido, 9→8 agent-memory concepts (1 canonical + 7 stubs), manifest 0 sem categoria (vs 1442), F3.3 squash guardrail
→ [[07-QUEUE/plano-melhorias-agents-2026-06-27]] (status: concluido)

## Vault Reconcile 2026-06-28
**Status:** SKIP — 0 arquivos em 08-ARCHIVE/A/ + 08-ARCHIVE/B/
**Cost:** 0
- 🩺 weekly-ops 2026-06-28: 2 issues scheduler (❌skill-audit não-agendada, ❌rotina-audit-mensal cron-diverge), +4 tickets, 0 runtime-unverified (5/5 F3.3 verificados)
