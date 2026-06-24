---
title: "The Anatomy of a Claude Skill: How a 40-Line Markdown File Replaces a $1,200/Month Contractor"
type: source
source: "Clippings/The Anatomy of a Claude Skill How a 40-Line Markdown File Replaces a $1,200Month Contractor.md"
author: "@heynavtoor"
published: 2026-05-22
created: 2026-05-22
ingested: 2026-05-23
tags: [claude-code, skills, prompting, automation]
score: 8
---

## Tese central
Skill ≠ prompt. Skill = memória procedural legível: diz ao model COMO você faz as coisas, toda vez, em toda sessão, em toda máquina, para sempre. 40 linhas de markdown substituem contratos mensais de $400-$1200 em assistentes especializados.

## Argumentos principais
- Prompt: diz o que fazer uma vez. Skill: job description — como você faz as coisas sempre
- Anthropic lançou Skills em 2026; comunidade criou 600+ em 90 dias; Lobehub: 500+ community skills
- Skill sem os 6 componentes = rota em semanas
- Diferença entre "skill que funciona" e "skill que morreu" = completude dos 6 componentes

## Key insights
- **6 componentes de um skill de produção:**
  1. **Frontmatter**: nome + descrição + trigger phrase → o que model lê primeiro ao escanear skill library
  2. **Trigger**: sinal que diz "use este skill agora" — concreto ("quando usuário pede tweet draft") bate vago ("para social media tasks")
  3. **Role**: qual especialista o model deve ser para esta task
  4. **Process**: passos que o especialista seguiria — elimina improviso
  5. **Format**: output structure esperado — evita reformatting manual
  6. **Examples**: one-shot ou few-shot → calibra julgamento sem instrução extra
- Skills sobrevivem machine switches, sessões, semanas — prompts não
- "The skill is the cheapest senior hire you'll ever make"

## Exemplos e evidências
- $400-$1200/mês para copy editor, research VA, social media assistant → 40 linhas markdown faz o mesmo
- Anthropic marketplace: 16 skills oficiais; Lobehub: 500+ community skills
- 600 skills criados em 90 dias após launch

## Implicações para o vault
Confirma o design do sistema de skills do vault (04-SYSTEM/skills/). Os 6 componentes são checklist para auditar skills existentes. Frontmatter + trigger = como o vault carrega skills no contexto correto.

## Links
- [[04-SYSTEM/agents/nexus]]
- [[03-RESOURCES/concepts/agent-systems/claude-skills-architecture]]
- [[03-RESOURCES/sources/ai-agents-harness/spec-driven-development-ai-coding]]
