---
title: "The 7 Claude Sub-Agents That Replace a $200K Team"
type: source
source_url: "https://x.com/heynavtoor/status/2053422550567502046"
author: "@heynavtoor"
platform: X/Twitter
published: 2026-05-10
ingested: 2026-05-15
tags: [claude-code, sub-agents, agent-harness, social-media]
triagem_score: 7
---

## Tese central

7 sub-agent markdown files replace $780K/year in real roles — each agent runs in own context window, doesn't contaminate main thread, doesn't forget its identity.

## Instalação

3 paths: `.claude/agents/<name>.md` (Claude Code auto-discovers), Claude.ai Settings → Sub-Agents, Claude Desktop/Cowork Settings → Sub-Agents.

## Os 7 Sub-Agents

| # | Nome | Salário substituído | Função |
|---|------|--------------------|----|
| 01 | Researcher | $90K Research Analyst | Deep primary-source research; 3 findings + 3 contradictions + 3 open questions; confidence rating |
| 02 | (Drafter) | ~$80K | Drafting from researcher brief |
| 03 | (Reviewer) | ~$70K | Reviewing draft output |
| 04 | (Publisher) | ~$60K | Final formatting + publishing |
| 05–07 | (outros 3) | ~$480K total | Pipeline completion |

> Thread corta em 3000 chars — primeiros 2 agentes detalhados. Full thread em source_url.

## Padrão do Agent File (Researcher)

```
---
name: researcher
description: Use when the user needs deep research on a topic, company, person, or trend.
---
You are a research analyst. Go deep, not wide.
1. Restate the research question in one sentence.
2. List 5 best primary sources (no blogs, no SEO).
3. Pull facts/dates/numbers/quotes — cite inline.
4. Flag contradictions between sources.
5. Return: Findings (3), Contradictions (3), Open Questions (3).
End with: "Confidence: High/Medium/Low" + one sentence why.
```

## Key insight

"Most people use Claude as one assistant. The smarter move is to use Claude as a team of seven."

Sub-agent = markdown file + job + brain + rules. Drop in folder. Claude calls on demand.

## Por que sub-agents funcionam melhor que um agente único

O argumento central não é sobre capacidade — é sobre contaminação de contexto e identidade. Um único agente acumulando todas as tarefas em uma sessão sofre de dois problemas: (1) **rot de contexto** — instruções iniciais ficam diluídas por ruído de execução conforme a janela cresce; (2) **role drift** — sem um papel fixo, o modelo oscila entre ser pesquisador, redator e revisor, aplicando critérios inconsistentes.

Sub-agents resolvem isso criando contextos descartáveis especializados. Cada invocação começa limpa, com identidade clara e memória zero de tarefas anteriores. O contexto "filho" não contamina o contexto "pai" — apenas o resultado volta.

## Padrão do Agent File (Drafter — exemplo inferido)

Com base no padrão do Researcher, o Drafter seguiria estrutura similar:

```
---
name: drafter
description: Use when researcher output is ready and a draft document is needed.
---
You are a senior writer. Transform research into prose.
1. Read the researcher brief completely.
2. Identify the primary argument and 3 supporting points.
3. Write section by section — intro, body, conclusion.
4. Each section: 1 claim, 1 evidence, 1 implication.
5. Return: Draft + word count + one sentence on what was omitted and why.
End with: "Completeness: High/Medium/Low" + reason.
```

O padrão se repete: papel, instrução de processo sequencial, output estruturado com meta-avaliação.

## Comparação com abordagens alternativas

**Conversas longas com um agente:** mais simples de iniciar, mas degradam com o tempo. A qualidade do output da iteração 10 é tipicamente inferior à iteração 1 porque o contexto está saturado.

**Workflows de prompt chaining:** similar em conceito, mas sem encapsulamento de identidade. Um prompt chain é uma sequência de inputs/outputs; um sub-agent tem uma identidade persistente que guia cada resposta além dos inputs recebidos.

**Agentes hospedados (Claude Agent SDK):** mais poderosos mas requerem infra. Sub-agents via arquivos `.md` são a versão sem servidor — funcionam em qualquer instância do Claude Code sem deploy.

## Custo real vs $780K

O cálculo de "substitui $780K" assume:
- Research Analyst ($90K): 8h/semana de pesquisa primária = ~$18K de valor anual se o agente cobrir isso
- O número real depende de volume de tarefas, qualidade aceitável, e supervisão humana necessária

Mais honesto: sub-agents comprimem o tempo gasto em trabalho analítico repetitivo. Para um fundador solo ou equipe pequena, o valor é em multiplicação de capacidade, não substituição de headcount.

## Limitações práticas

- Sub-agents não têm acesso a ferramentas externas a menos que configurados — o Researcher não "navega a web" automaticamente; precisa de MCP ou permissões de Bash explícitas
- A qualidade do pesquisador depende do que está em contexto. Se os "5 primary sources" não estão acessíveis, o agente preenche com o que sabe (risco de alucinação)
- O padrão "Confidence: High/Medium/Low" é autoavaliação do modelo — não verificação externa. Deve ser tratado como sinal, não como garantia

## Aplicação no vault

O vault usa `.claude/agents/` para sub-agentes especializados. Os agentes do sistema (`guard`, `hill`, `review`, `spec`) seguem exatamente o mesmo padrão descrito: arquivo markdown com identidade + regras + output esperado. A tese de heynavtoor valida a arquitetura já em uso — cada agente do vault é um sub-agent especializado, não um fork do Nexus genérico.

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-harness]] — sub-agents as harness pattern
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — agent files as skill variant
- [[03-RESOURCES/sources/ai-agents-harness/claude-code-subagents-heynavtoor]] — prior heynavtoor post (different thread)
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — context isolation as core benefit of sub-agents
- [[04-SYSTEM/agents/]] — vault's own sub-agent implementations
