---
title: "The 7 Claude Sub-Agents That Replace a $200K Team"
type: source
source_file: Clippings/The 7 Claude Sub-Agents That Replace a $200K Team.md
origin: post no X
author: "@heynavtoor"
published: 2026-05-10
ingested: 2026-05-14
tags: [claude-code, sub-agents, agents-folder, markdown-agents, solo-founder, team-replacement]
---

# The 7 Claude Sub-Agents That Replace a $200K Team

> [!key-insight] Core insight
> Um sub-agent é um arquivo Markdown com job description + brain + rules. 7 arquivos em `.claude/agents/` substituem $780K de folha de pagamento anual — cada um roda em seu próprio context window, sem contaminar o thread principal.

## Sections

### O Que É Um Sub-Agent

- Arquivo Markdown em `.claude/agents/<name>.md`
- Claude encontra automaticamente e pode chamar via `/agents` ou selecionar o correto
- Roda em context window próprio com instruções próprias
- Instalação: Claude Code (`.claude/agents/`), Claude.ai Settings → Sub-Agents, Claude Desktop/Cowork Settings

### Os 7 Sub-Agents (com prompts completos)

| # | Agent | Salário substituído | Core behavior |
|---|-------|--------------------|-|
| 1 | Researcher | $90K Research Analyst | Primary sources only; 3 findings + 3 contradictions + 3 open questions + confidence level |
| 2 | Editor | $85K Senior Editor | Lê, encontra tese, corta 30%, reescreve abertura + fechamento; lista o que cortou e por quê |
| 3 | Project Manager | $110K PM | Goal + deadline + team → milestones + critical path + top 3 risks; "O projeto morre se ___ escorrega." |
| 4 | Analyst | $120K Data Analyst | Dados → 3 números mais importantes + 2 outliers + headline + ação recomendada + chart spec |
| 5 | Recruiter | $95K Talent Sourcer | Função → 5 canais específicos + outreach 5 linhas + rubrica de screening + rejection email |
| 6 | Ops Lead | $100K Operations Manager | Processo → mapa step-by-step + AUTOMATE/KILL/KEEP/DOCUMENT + SOP; "O step que nunca deve ser automatizado é ___." |
| 7 | CFO | $180K Fractional CFO | Números → runway + burn + bleeding line + cut list; "Se não cortar nada, fica sem dinheiro em ___." |

Total: $780K de folha de pagamento. $200K é o que um fundador/freelancer pode realisticamente economizar imediatamente.

### Regras de Design (Universais nos Prompts)

- Nunca inventar citações
- Prefixo immutable do sistema: YAML frontmatter com `name` e `description`
- Perguntar antes de prosseguir sem dados suficientes
- Sem filler, sem hedging — dar a resposta direta
- Encerrar com linha de síntese acionável

### Por Onde Começar (por Perfil)

- **Fundador solo**: CFO + PM + Recruiter
- **Freelancer**: Researcher + Editor + PM
- **Engenheiro**: Researcher + Analyst + Ops Lead
- **Creator**: Researcher + Editor + Analyst
- **Operador em empresa**: PM + Ops Lead + Analyst

### Como um Dia Realmente Corre

Monday morning: Researcher → brief pré-reunião → Editor → proposta 30% menor → PM → plano da semana → Analyst → headline dos números → CFO → decisão de contratação. 90 minutos. Trabalho de 5 pessoas.

> "O compounding não é em nenhum sub-agent individual. O compounding é em rodá-los em sequência, todo dia, no mesmo negócio."

## Conexões

- [[03-RESOURCES/concepts/multi-agent-orchestration]] — sub-agents em sequência, context separado
- [[03-RESOURCES/concepts/claude-skills]] — sub-agent = skill especializado com job description
- [[03-RESOURCES/entities/Claude Code]] — plataforma base (.claude/agents/)
- [[03-RESOURCES/concepts/claude-folder-anatomy]] — pasta .claude/agents/
- [[03-RESOURCES/concepts/ai-agents-negocios]] — substituição de equipe com agents
