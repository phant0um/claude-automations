---
title: "COG — Self-Evolving Second Brain (huytieu)"
type: source
author: huytieu
source_file: "Clippings/huytieuCOG-second-brain..."
published: 2026-05-22
ingested: 2026-05-23
tags: [second-brain, ai-agents, obsidian, self-evolving, skills, people-crm, git, claude-code]
triagem_score: 7
---

# COG — Self-Evolving Second Brain

> **Cognition + Obsidian + Git** — Second brain auto-evoluível em arquivos `.md`. Sem banco de dados, sem vendor lock-in. Inspirado diretamente no GBrain e GStack do Garry Tan.

GitHub: `huytieu/COG-second-brain` | Licença: MIT | v3.5 (atual)

---

## O que É

Sistema de segundo cérebro baseado em:
- **17 skills** (Claude Code nativo) + suporte Cursor, Kiro, Gemini CLI, Codex
- **6 worker agents** especializados
- **People CRM** embutido (`05-knowledge/people/`)
- **Auto-update** — framework evolui sem tocar no conteúdo pessoal
- Zero banco de dados — tudo em `.md` + Git + iCloud opcional

```
Você → [linguagem natural] → AI Agent
                              ↓ runs
                          17 Skills ← → 6 Worker Agents
                              ↓ reads/writes
                          .md Files → Git → iCloud
                              ↓ syncs
                          GitHub / Linear / Slack / PostHog
```

---

## Skills: Categorias e Propósito

### Core (Conhecimento Pessoal)

| Skill | Função |
|-------|--------|
| **onboarding** | Personaliza COG para seu workflow (rodar primeiro) |
| **braindump** | Captura pensamentos com classificação automática |
| **daily-brief** | Inteligência de notícias verificadas (7-day freshness) |
| **url-dump** | Salva URLs com insights auto-extraídos |
| **weekly-checkin** | Análise de padrões cross-domain |
| **knowledge-consolidation** | Constrói frameworks a partir de notas dispersas |
| **update-cog** | Atualiza framework sem tocar no conteúdo |

### Team Intelligence (Líderes de Produto/Engenharia)

| Skill | Função |
|-------|--------|
| **team-brief** | GitHub + Linear + Slack + PostHog → daily brief com Linear sync-back |
| **meeting-transcript** | Gravações → decisões estruturadas + action items + dinâmicas de equipe |
| **comprehensive-analysis** | Análise profunda 7-day (~8-12 min) para board prep / planejamento estratégico |

### PM Workflow

| Skill | Função |
|-------|--------|
| **create-user-story** | User stories com dedup contra Linear/GitHub/Jira |
| **generate-prd** | PRD com approval gate antes de publicar em Confluence/Notion |
| **generate-release-notes** | Release notes de GitHub milestones / Linear cycles |
| **export-open-issues** | Auditoria e export de issues para vault summary |
| **publish-to-confluence** | Qualquer `.md` do vault → Confluence |
| **update-knowledge-base** | Mantém knowledge base a partir de releases e features |

**PM lifecycle completo:** Auto-research → PRD → Stories → Dev → Release Notes → Knowledge Base

---

## Arquitetura de Pastas

```
COG-second-brain/
├── 01-daily/           # Briefs & check-ins
├── 02-personal/        # Braindumps pessoais (privado)
├── 03-professional/    # Braindumps profissionais & estratégia
├── 04-projects/        # Tracking por projeto
├── 05-knowledge/       # Insights consolidados & padrões
│   └── people/         # People CRM profiles
└── 06-templates/       # Templates de documentos
```

Organização por **tipo de nota** (igual à abordagem do [[03-RESOURCES/sources/pkm-obsidian-second-brain/i-connected-claude-obsidian-vault-damidefi|DamiDefi]]), não por tópico.

---

## Agent Support Matrix

| Surface | Suporte | Formato |
|---------|---------|---------|
| Claude Code | 17 skills nativas + 6 worker agents | `.claude/skills/` |
| Cursor | Plugin manifest + rules | `.cursor-plugin/plugin.json` |
| Kiro | 7 powers nativos | `.kiro/powers/` |
| Gemini CLI | 7 commands nativos | `GEMINI.md` + `.gemini/commands/` |
| Codex / outros | 17 commands documentados | `AGENTS.md` |

---

## Setup

```bash
git clone https://github.com/huytieu/COG-second-brain
cd COG-second-brain
# No Claude Code: "Run onboarding"

# Ou via skills.sh:
npx skills add huytieu/COG-second-brain
```

~2 minutos para personalização. Git opcional (mas recomendado). iCloud sync disponível.

---

## Resultados Reportados

- 120+ braindumps processados
- Daily briefs com 95%+ de source accuracy
- 5 insights estratégicos descobertos
- Zero manutenção manual

---

## Diferencial vs. Obsidian Puro / Notion

COG adiciona inteligência auto-evoluível em cima do storage. Não apenas armazena — aprende, analisa, sintetiza automaticamente. Framework evolui sem tocar no conteúdo pessoal (update system detecta arquivos customizados e permite escolha por arquivo).

---

## Conexões

- [[03-RESOURCES/entities/Garry-Tan]] — inspiração direta: GBrain (people CRM, tiered enrichment, brain-first lookup) + GStack (specialist sessions, operating gears, repo-local skill distribution)
- [[03-RESOURCES/entities/Hermes-Agent]] — ecossistema relacionado (SKILL.md standard, agent interoperability)
- [[03-RESOURCES/concepts/agent-systems/harness-engineering]] — COG como exemplo de harness com skill routing + worker agents
- [[03-RESOURCES/concepts/agent-systems/agent-memory-layers]] — knowledge-consolidation skill implementa project memory layer; people CRM implementa entity memory
- [[03-RESOURCES/sources/pkm-obsidian-second-brain/i-connected-claude-obsidian-vault-damidefi]] — abordagem similar (Claude+Obsidian), foco diferente: DamiDefi usa N8N+síntese, COG usa skills nativas
- [[03-RESOURCES/sources/claude-code-skills/clipping-kepanoobsidian-skills-agent-skills-for-obsidian-teach-your-a]] — skills oficiais Obsidian complementam o skill system do COG
- [[03-RESOURCES/entities/COG-second-brain]] — entity page
