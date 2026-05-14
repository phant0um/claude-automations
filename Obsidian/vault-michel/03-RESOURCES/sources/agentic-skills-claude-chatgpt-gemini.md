---
title: "20 Powerful Agentic-Skills for Claude, ChatGPT & Gemini"
type: source
source_file: .raw/articles/20-agentic-skills-claude-chatgpt-gemini-2026-04-15.md
origin: post no X (autor não identificado)
ingested: 2026-04-15
tags: [skills, agentes, produtividade, escrita, video, codigo]
---

# 20 Agentic-Skills — Claude, ChatGPT & Gemini

Curadoria de 20 skills escritas em `.md` (padrão Claude), mas agnósticas de modelo — podem ser coladas no ChatGPT ou Gemini diretamente.

> [!key-insight] Diferencial em relação à lista de 67 skills
> As skills do artigo anterior ([[03-RESOURCES/sources/67-claude-skills-full-dev-team]]) são instaladas via `npx` e ficam no sistema de arquivos. Estas aqui são **portáteis**: arquivos `.md` que funcionam como system prompts colados em qualquer modelo. Menor fricção de adoção, menor dependência de tooling.

## As 5 categorias e 22 skills

### Writing & Content (5)

| Skill | Função |
|---|---|
| `scqa-writing-framework` | Estrutura Situation → Complication → Question → Answer. Usado em consultoria e conteúdo. |
| `content-repurposing-engine` | Long-form → múltiplos formatos (threads, scripts, resumos) |
| `tone-style-enforcer` | Garante voz de marca consistente em todos os outputs |
| `long-form-summary-compressor` | Texto longo → resumo conciso, sem perder informação crítica |
| `structured-copywriting-skill` | Copy com hook forte, fluxo estruturado e CTA |

### Visual & Infographic (4)

| Skill | Função |
|---|---|
| `excalidraw-diagram-generator` | Conceitos textuais → instruções de diagrama para Excalidraw |
| `infographic-builder` | Texto → formato de infográfico estruturado |
| `flowchart-decision-builder` | Input textual → árvore de decisão / fluxograma com branching condicional |
| `ui-ux-layout-advisor` | Sugestões de layout: clareza, espaçamento, hierarquia, acessibilidade |

### Research & Analysis (5)

| Skill | Função |
|---|---|
| `deep-research-synthesizer` | Grandes datasets → insights filtrados + padrões + resumo acionável |
| `onchain-transaction-analyzer` | Transações blockchain → explicação em linguagem simples |
| `source-validation-skill` | Scoring de confiabilidade de fontes + detecção de viés |
| `competitive-intelligence-skill` | Comparação SWOT de produtos/ferramentas/protocolos |
| `knowledge-structuring-skill` | Informação desestruturada → frameworks e hierarquias claras |

### Video (4)

| Skill | Função |
|---|---|
| `video-script-generator` | Scripts com hook, seções, pacing e CTA |
| `video-editing-planner` | Estrutura de edição: cortes, transições, pacing |
| `hook-generator` | Ganchos de atenção para vídeos, posts e intros |
| `caption-subtitle-formatter` | Legendas com timing correto e legibilidade |

### Coding & Automation (4)

| Skill | Função |
|---|---|
| `code-review-skill` | Bugs, ineficiências, boas práticas + sugestões acionáveis |
| `workflow-automation-agent` | Objetivo → workflow passo a passo com ferramentas mapeadas |
| `skill-creator-meta-skill` | Meta skill: gera novas skills em `.md` automaticamente |
| `devops-assistant` | Commit, versioning, deployment, automação de workflow |

## Padrões de design das skills

Cada skill contém: `name`, `description`, `Overview`, `Keywords`, `Features`, `Output Format`, `Instructions`, `Constraints`.

O campo **Constraints** é análogo às "restrições negativas" identificadas em [[03-RESOURCES/concepts/prompt-engineering-patterns]] — define limites que previnem comportamentos indesejados.

## Conexões
- [[03-RESOURCES/concepts/claude-skills]] — mesmo mecanismo de SKILL.md, mas portátil (sem instalação via npx)
- [[03-RESOURCES/concepts/prompt-engineering-patterns]] — Constraints como restrições negativas estruturadas
- [[03-RESOURCES/sources/67-claude-skills-full-dev-team]] — lista complementar: skills via npx para Claude Code
