---
title: "The 7 Claude Sub-Agents That Replace a $200K Team"
type: source
source_file: Clippings/The 7 Claude Sub-Agents That Replace a $200K Team.md
origin: post no X
author: "@heynavtoor"
published: 2026-05-10
ingested: 2026-05-14
tags: [claude-code, sub-agents, agents-folder, markdown-agents, solo-founder, team-replacement]
triagem_score: 8
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

- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — sub-agents em sequência, context separado
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — sub-agent = skill especializado com job description
- [[03-RESOURCES/entities/Claude Code]] — plataforma base (.claude/agents/)
- [[03-RESOURCES/concepts/claude-code-tooling/claude-folder-anatomy]] — pasta .claude/agents/
- [[03-RESOURCES/concepts/agent-systems/ai-agents-negocios]] — substituição de equipe com agents

---

## O modelo mental: job description + brain + rules

O artigo descreve sub-agents como "arquivo Markdown com job description + brain + rules". Cada elemento cumpre uma função específica:

**Job description** (frontmatter YAML `description`): define o escopo do agent. Um Researcher sem job description vai tentar fazer análise quando deveria apenas coletar. Um CFO sem job description vai ser genérico quando deveria ser implacavelmente focado em runway e burn.

**Brain** (o corpo do prompt do agent): o conjunto de skills, heurísticas e conhecimento de domínio que o agent aplica. O CFO do artigo tem "brain" específico: lê números → identifica runway atual → projeta burn → identifica a bleeding line → produz cut list. Não é raciocínio geral sobre finanças — é um workflow específico que um CFO experiente executaria.

**Rules** (seção de restrições): o que o agent nunca faz. "Nunca inventar citações" para o Researcher. "Dar a resposta direta" para todos. "Encerrar com linha síntese acionável" para todos. As rules são o que diferencia um agent profissional de um agente genérico que hedges infinitamente.

---

## O compounding como mecanismo central

A citação mais importante do artigo: "O compounding não é em nenhum sub-agent individual. O compounding é em rodá-los em sequência, todo dia, no mesmo negócio."

Isso captura algo que a maioria das pessoas perde: o valor de agents especializados não é o que cada um produz individualmente — é o que o contexto compartilhado acumula ao longo do tempo.

**Segunda semana:** o Researcher já sabe quais fontes são mais confiáveis para o negócio específico. O Editor já aprendeu o voice do fundador. O PM já conhece os stakeholders e dependências críticas.

**Segundo mês:** o Analyst já tem baseline histórico para comparar métricas atuais. O CFO já identificou os patterns de gasto que se repetem. O Recruiter já tem mapa de quais canais produzem candidatos de qualidade.

Nenhum desses aprendizados vem de uma única interação — eles emergem de uso consistente no mesmo negócio, com o mesmo contexto compartilhado alimentando todos os agents.

---

## Análise dos prompts: o que torna cada agent efetivo

**Researcher (3 findings + 3 contradictions + 3 open questions + confidence level):** a estrutura explícita de 3+3+3 força o agent a procurar ativamente por contradições em vez de confirmar o que o usuário já acredita. A maioria dos sistemas de pesquisa retorna confirmação; este design exige dissonância cognitiva produtiva.

**Editor (lê, encontra tese, corta 30%, reescreve abertura + fechamento):** o corte de 30% não é sugestão — é constraint. Isso força decisões difíceis sobre o que fica. Sem o número específico, o editor tende a sugerir cortes marginais que não melhoram o documento substancialmente.

**PM (O projeto morre se ___ escorrega):** a sentença de preenchimento força identificação do critical path real, não dos riscos que ficam bem num deck. Um PM que não consegue completar essa frase não entende o projeto suficientemente.

**CFO (Se não cortar nada, fica sem dinheiro em ___):** mesma lógica — força concretude. "Runway de X meses" é abstrato; "sem dinheiro em [data específica]" é urgência real.

---

## Implementação técnica: o arquivo Markdown completo

Exemplo de implementação do Researcher:

```yaml
---
name: researcher
description: Deep research on any topic using primary sources. Use when you need facts, market data, competitive intelligence, or expert perspectives on a topic.
model: claude-sonnet-4-5-20250929
tools:
  - WebSearch
  - WebFetch
  - Read
memory: user
---

You are a Senior Research Analyst with 15 years of experience in primary source research.

For every research request:
1. Identify and access primary sources — not summaries or aggregations
2. Produce exactly 3 key findings with supporting evidence
3. Identify exactly 3 contradictions or tensions in the evidence
4. List exactly 3 open questions the research didn't resolve
5. State your confidence level (Low/Medium/High) with rationale

Rules:
- Never invent citations. If you can't verify, say so.
- Never hedge excessively. State what the evidence shows.
- End with one actionable synthesis: "Based on this research, the most important thing to do/know is: ___"
```

Esse formato garante que o agent tem job description clara para auto-delegação, brain com workflow específico, e rules com restrições explícitas.

---

## Limitações e considerações

**Custo de setup:** criar 7 agents bem calibrados com prompts de qualidade requer 2-4 horas de trabalho inicial. O ROI é na repetição — uma hora de setup que elimina 30 minutos por semana de trabalho manual paga em 4-8 semanas.

**Necessidade de feedback:** agents ficam melhores com feedback explícito no `memory: user` — o que requer o usuário notar e corrigir quando o output não é o esperado. Sem feedback, o agent estagna no nível do prompt inicial.

**Scope creep:** agents sem rules explícitas tendem a expandir escopo com o tempo — o Researcher que começa a fazer análise, o PM que começa a tomar decisões executivas. As rules são o mecanismo de contenção.

**Não substituem julgamento humano:** o compounding funciona quando o usuário usa os outputs para tomar decisões melhores — não quando delega as decisões para o agent. O CFO dá o corte list; o fundador decide o que cortar.
