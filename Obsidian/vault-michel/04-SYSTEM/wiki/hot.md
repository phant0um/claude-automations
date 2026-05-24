---
title: Hot Cache
type: hot-cache
updated: 2026-05-24
sweep-protocol: mensal — remover entradas > 30 dias não acessadas novamente
kv-cache: stable-first — OPERACIONAL+CONCEITOS+INGEST são estáveis → cacheados; SESSÕES ao final
---

> **Sweep Protocol:** Este arquivo deve ser curado mensalmente.
> Entradas com mais de 30 dias sem referência cruzada nova → mover para `[ARQUIVO]`.
> Objetivo: hot.md = memória de trabalho ativa, não landfill acumulativo.
> Agente responsável: `hill` — trigger: "sweep hot.md" ou rotina mensal (`vault-hot-sweep`).
>
> **Estrutura KV-cache-friendly:** seções estáveis primeiro → prompt cache hit na maioria das sessões.
> [SESSÕES-RECENTES] fica ao final — conteúdo dinâmico não quebra cache do prefixo estável.

---

## [OPERACIONAL] — Ações Pendentes

**🔴 BLOQUEADOR: Bash allowlist para wiki-ingest subagents**
- Sem permissão → subagents não executam pdftotext, git, find, etc.
- Desbloqueia: 9 score-8 + 35 score-6/7 + 64 FIAP PDFs + 55 concurso = **163 ingests pendentes**
- Fix: adicionar permissões Bash ao `.claude/settings.json` (ou `settings.local.json`) do vault para wiki-ingest agents

**Conceitos a criar:**
- `llm-evaluation` — 4+ sources convergem (29-llm-eval, agent-eval-framework, AHE, llm-as-a-judge) → [[03-RESOURCES/concepts/agent-systems/llm-evaluation]]
- `browser-skills-agents` — Browse.sh + macOS dual-cursor → [[03-RESOURCES/concepts/agent-systems/browser-skills-agents]]

**Entidades a criar:**
- `Fireworks AI` — fine-tuning agent + inference engines → [[03-RESOURCES/entities/Fireworks-AI]]
- `kepano` — criador obsidian-skills → [[03-RESOURCES/entities/kepano]]

**Concurso — pendente:**
- 64 stubs legislação restantes (ver [[04-SYSTEM/wiki/lint-report-2026-05-24]])

---

## [CONCEITOS-ATIVOS] — Threads Abertas

| Conceito | Status | Próxima ação |
|---------|--------|-------------|
| [[03-RESOURCES/concepts/agent-systems/harness-engineering]] | 8+ sources; AHE data adicionado | Link com 9 Clippings score-8 quando ingestados |
| [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] | Memory Lifecycle (Mercury consciente/subconsciente) | Link EvolveMem quando ingestado |
| [[03-RESOURCES/concepts/agent-systems/agent-security-stack]] | Criado 2026-05-23 | Link Hermes×Bitwarden quando ingestado |
| [[03-RESOURCES/concepts/llm-ml-foundations/inference-engines-hardware-first]] | Criado 2026-05-23 | Link Inference Engines 2026 quando ingestado |
| [[03-RESOURCES/concepts/agent-systems/model-bound-vs-harness-bound]] | Criado 2026-05-24 | 4 fontes convergem; expandir |
| [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]] | Atualizado 2026-05-18 | +Wolfe patterns; aguarda 29-llm-eval ingest |
| [[02-AREAS/concurso/concurso-index]] | 63 sources mapeadas | Expandir 64 stubs restantes |

---

## [INGEST-PENDENTE]

**Status:** bloqueado por Bash allowlist (ver OPERACIONAL). Fix first → wiki-ingest agents desbloqueados.

### Score-8 — 9 Clippings (prioridade máxima)

| Source | Categoria |
|--------|-----------|
| 29 LLM Evaluation Concepts Every Engineer Needs to Know | ai-agents-harness |
| 9 Agentic Patterns, Simply Explained | ai-agents-harness |
| Give your agents an interpreter | ai-agents-harness |
| Hermes x Bitward - The Security Stack AI Agents Actually Need | ai-agents-harness |
| How Claude Code works in large codebases | claude-code-skills |
| Inference Engines for LLMs & Local AI Hardware (2026 Edition) | ai-agents-harness |
| The Anatomy of a Claude Skill | claude-code-skills |
| We Gave an AI Agent a Conscious and Subconscious Mind | ai-agents-harness |
| kepano/obsidian-skills | claude-code-skills |

### Score-6/7 — 35 Clippings

Ver [[06-GENERATED/triagem/triagem-2026-05-23-v3]] — seção "Aprovados para Ingest".

### FIAP PDFs — 64 arquivos (score 8)

Fases 1–6 completas. Auto-aprovados. Requerem pdftotext + fiap-ingest agent.
Ver [[06-GENERATED/triagem/triagem-2026-05-23-v3]] — seção "FIAP PDFs — Auto-aprovados".

### Concurso — 55 sources (score 5-7)

Ver [[06-GENERATED/triagem/triagem-2026-05-23-v2]] — seção pendente.

---

## [SESSÕES-RECENTES]

### 2026-05-24 (continuação)

**Clippings Archive Reorganization (sessão 4):**
- Analisados v1/v2/v3 triagems: distribuição scores, overlap detection
- Estrutura criada: A (score 8-9) | B (score 7) | C (score 6) | D (resto + raw)
- Raw consolidation: 465 arquivos `.raw/articles/*.md` copiados → D/2026-05-23/
- Total D agora: 704 files (252 Clippings + 452 raw articles)
- Limpeza: deletado clippings-ingested/ e triagem-rejeitados/ (stale structures)
- Estado final: A=1, B=8, C=2, D=704 | Raws centralizados em D

### 2026-05-24

**Implementações (sessão 3):**
- **Item 1 (Stop hook quality gate)** — `stop-quality-gate.sh` criado; verifica sources→manifest; wired em Stop hooks
- **Item 2 (Sprint contract skill)** — `~/.claude/skills/sprint-contract.md` criado (GAN: Planner+Generator+Evaluator; critérios before sprint)
- **Item 5 (Skill frontmatter audit)** — 4 skills com YAML frontmatter: `token-economy`, `agent-eval`, `caveman-mode`, `kv-cache-explainer` → auto-routing via progressive disclosure
- **Item 8 (Rotinas remotas)** — `vault-monday-ops` (weekly Mon 16h Manaus: ingest-report+wiki-lint) + `vault-hot-sweep` (mensal 1º 16h); `auto-push.sh` com 4 guards (opt-in sentinel, quality gate re-verify, todo.md check, conflict check)
- **Item 3 (hot.md restructure)** — KV cache optimization: stable-first structure (OPERACIONAL→CONCEITOS→INGEST→SESSÕES→ARQUIVO)

**Lint + Melhorias (sessão 2–4):**
- Fix 1 — 16 sources: `concepts/ai-agents/` → `concepts/agent-systems/`
- Fix 2 — 6 concepts criados: `agentic-patterns`, `claude-skills-architecture`, `self-evolving-systems`, `token-economy`, `workflow-compilation`, `model-bound-vs-harness-bound`
- Fix 3 — 231 concepts: `status: developing` adicionado via batch
- Fix 4 — 5 stubs concurso expandidos: CTN, CF88, L7713, RIR/2018, L8112
- **Sessão 3: tributario/ completo (21/21)**: CSLL, ITR, PIS/COFINS, IOF, IPI, IRPJ, LRF, Simples, sigilo bancário, PAF, IFRS, PIS/COFINS importação, REFIS, CIDE-Tech, CIDE-Comb, transparência, PIS histórico, PASEP, RITR
- **Sessão 4 (atual): irpf/ (4/4) + irpf/manual-mir/ (10/10)**: PRONAC, deduções incentivadas, IRRF/retenção, L4506; rendimentos trabalho/capital/outros, bens financeiros/imóveis-móveis, despesas dedutíveis/não-dedutíveis/doações-não-dedutíveis, decisão judicial, entrega DAA
- Pendente: administrativo/ (12), previdenciário/ (6), aduaneiro/ (5), penal/ (3), societário/ (4) → [[04-SYSTEM/wiki/lint-report-2026-05-24]]

**Vault Improvements (sessão 1):**
- 7 implementações: H4 (protect-sources hook), V1 (frontmatter enforcement+scan), V2 (epistemic-tagging), N2 (vault-graph.md), N3 (skill-memory pattern), N4 (mem0 agents/memory/), N5 (ACP concept page)
- Artefatos: `protect-sources.sh`, `frontmatter-scan.sh`, `vault-graph.md`, `skill-memory.md`, `agents/memory/`, `epistemic-tagging.md`, `acp-agent-client-protocol.md`

**Ingest Clippings Pendentes:**
35 fontes criadas (19 score-7 + 16 score-6). Manifest: 570 → 605.
Destaques: ACP protocol, Browse.sh, Fireworks fine-tuning, CodeGraph, directional-prompting, obra/superpowers, context engineering, vercel knowledge agent, PM Brain OS, dual-cursor.

**kepano/obsidian-skills instalado:**
5 skills via `skills add` → `defuddle`, `json-canvas`, `obsidian-bases`, `obsidian-cli`, `obsidian-markdown`

---

### 2026-05-23

**Pipeline Diário v3 (scheduled):**
Triagem: 120→108 aprovados, 6 rejeitados. Ingest: 9 score-8 bloqueados (Bash permission). Top action: `harness-engineering` — 8+ sources convergem.
→ [[06-GENERATED/ingest-report/ingest-diario-2026-05-23]] | [[06-GENERATED/triagem/triagem-2026-05-23-v3]]

**Melhorias F3.3:**
Updated: `harness-engineering` +5 fontes | `agent-memory-architecture` +Memory Lifecycle | `llm-as-a-judge` +29 eval concepts
Created: `agent-security-stack` | `inference-engines-hardware-first` | `afrfb-base-legal`

**Ingest Legislação — Batch Completo:**
69 novas source pages em `concurso-legislacao/`. Manifest: 493 → 562.
irpf/(16) + tributario/(22) + administrativo/(13) + previdenciario/(6) + societario/(4) + constitucional/(2) + aduaneiro/(5) + penal/(3)
→ [[02-AREAS/concurso/concurso-index]]

**Pipeline Diário v2:**
212 candidatos → 212 aprovados. Ingest: 24 sources. Skipped 7 dups.
→ [[06-GENERATED/triagem/triagem-2026-05-23-v2]]

**Sources Subfolder Reorganization:**
580 files → 14 subfolders. 3082 wikilinks updated.

---

### 2026-05-20

**Batch Ingest FIAP:**
60 source stubs (Fases 1–6) + 60 manifest entries. Total FIAP: 75 apostilas.
Fase 1(10) + Fase 2(9) + Fase 3(9) + Fase 4(12) + Fase 5(12) + Fase 6(12).

---

### 2026-05-19

**Relatório Pós-Ingest Semanal:**
20/224 sources | 7 clusters: Agent OS Multi-Harness, RL Research, Memory & Continuity, Arquitetura Agentes, Token Engineering, Eval & Benchmarks, AI-Native Paradigm.
Top insight: Multi-harness control plane (Oz) = harness-as-infrastructure. Novo primitivo arquitetural.
Cross-connections: [agent-performance-model-bound]↔[is-grep-all-you-need] | [activegraph]↔[delta-mem] | [hermes-self-writing]↔[harnessing-agentic-evolution]
→ [[06-GENERATED/ingest-report/relatorio-pos-ingest-2026-05-19-semanal]]

**Manutenção Vault:**
Claude Code 2.1.108→2.1.144 (RCE patched). Caveman hook duplicate fixed (-30 tokens/turn).
MOC Fase 7: 15/15 linkadas. ECC entity → hub 8 cross-links. 175 pages `updated: 2026-05-19`.
AGENTS.md: sub-agent=compressão (não paralelismo) adicionado. hot.md: 368→220 linhas.
Concepts novos: `subagent-pattern-empirical` — sub-agents vencem 7/10 prod.

**Lint Semanal:**
1086 files | Orphans: 21 | Dead links: 277 | Frontmatter gaps: 194.
Resolvido: 5 stubs renomeados (288 dead links). Estruturais: `agentic-reasoning`, `agent-patterns`, `analista-de-investimentos-br-eua`.
→ [[04-SYSTEM/wiki/lint-report-2026-05-19]]

**Daily Ingest:**
40 novos sources. Manifest: 361→405. 39 Clippings cleaned.
→ [[06-GENERATED/ingest-report/ingest-diario-2026-05-19]]

---

### 2026-05-18

**Relatório Pós-Ingest Semanal:**
20/127 sources | 7 clusters: Hermes Agent OS, Arquitetura Agentes, Skills & Harness, Workflow Reliability, Segurança, Auto-melhoria, FIAP Fase 7.
Top insight: Claude Code RCE deeplink — trust boundary em CLI agents mais frágil que assumido.
Cross-connections: [hermes-proxy]↔[ecc-v2-proxy] | [sub-agents-isolation]↔[workflow-silent-failure] | [harris-vibe-code]↔[halo-harness]
→ [[06-GENERATED/ingest-report/relatorio-pos-ingest-2026-05-18-semanal]]

**Concepts + Skills criados:**
- NEW `kv-cache-llms` — mecanismo Attention(Q,K,V), prompt-caching/hot.md
- NEW `geo-generative-engine-optimization` — MCP+llms.txt+OAuth AI search
- UPD `agent-evaluation-production` +Wolfe patterns +ECHO world model
- NEW skill `agent-eval.md` | NEW skill `kv-cache-explainer.md`
- NEW agent `security-scanner.md` (3 modos: static/dynamic/harness)

**Daily Ingest:**
41 sources. Manifest: 320→361. Pages-chave: sub-agents-vs-multi-agents (win 7/10), echo-terminal-agents, 12-factor-agents, claude-code-rce-deeplink, cut-token-bill-87%.
→ [[06-GENERATED/ingest-report/ingest-diario-2026-05-18]]

---

### 2026-05-17

**Relatório Pós-Ingest Semanal:**
20/147 sources | 6 clusters: Memory Paradox, Harness Engineering, Multi-Agent, ML Research, Skills & Context, Org AI.
Top insight: Memory Curse — recall expandido erode cooperação em multi-agent. Mais memória ≠ melhor sistema.
Cross-connections: [memory-curse]↔[delta-mem] | [llms-improving-llms]↔[halo-rlm] | [is-grep-all-you-need]↔[memory-skills-same-harness]
→ [[06-GENERATED/ingest-report/relatorio-pos-ingest-2026-05-17-semanal]]

**Connections:**
8 conexões. Top: agent-governance-layers↔SOUL.md → "governed autonomy". Padrão 3+: Harness>modelo.
→ [[06-GENERATED/connections/connections-2026-05-17]]

**Daily Ingest:**
43 sources. Triagem: 43 aprovados / 14 rejeitados.
Pesquisa (9 papers: δ-mem, Memory Curse, LLMs→LLMs, MAS survey, Is-Grep, Geometric, Token Superposition, Lighthouse, Co-mathematician).
Prático (27: memória, MCP, Hermes, Cowork, frontend toolkit, cybersecurity, local AI).

---

## [ARQUIVO]

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
