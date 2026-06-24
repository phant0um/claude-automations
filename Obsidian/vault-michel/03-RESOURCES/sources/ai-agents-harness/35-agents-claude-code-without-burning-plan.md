---
title: "How I Ran 35 Agents in Claude Code Without Burning My Plan"
type: source
source: "Clippings/How I Ran 35 Agents in Claude Code Without Burning My Plan.md"
created: 2026-05-31
ingested: 2026-06-02
tags: [ai-agents, claude-code, dynamic-workflows, parallel-agents, token-economy]
author: "@iammurataslan"
---

## Tese central
Dynamic workflows em Claude Code (Claude escreve JavaScript que spawna agentes paralelos) podem rodar dezenas de agentes em paralelo a custo mínimo se: escolher modelo correto (Haiku), escopo cirúrgico por agente, e apontar para a tarefa certa.

## Argumentos principais
- Dynamic workflow = Claude escreve script JS que spawna N agentes em paralelo → mergeia resultados em 1 resposta
- Script é salvo e reutilizável — audit de skills vira um botão que pode ser pressionado sempre que novos skills são adicionados
- 35 agentes simultâneos para auditar 35 skills — cada agente lê 1 skill, score em 3 critérios, reporta fix prioritário
- Custo mínimo por 3 regras: modelo correto (Haiku), escopo por agente (1 skill), 2 agentes de síntese no final
- Hierarquia de escolha: 1-quick=ask Claude, 2-repeat=Skill, 3-parallel=Subagent, 4-coordinated=Workflow
- 4.5 minutos para 35 agentes no total — velocidade viabilizada pela paralelização

## Critérios de scoring de skill por agente
Cada agente avaliou 1 skill em:
1. **Clareza** — quão clara é a instrução
2. **Frontmatter** — se está sólido e completo
3. **Trigger accuracy** — se dispararia no momento certo
Retornou 1 fix único mais útil por skill.

## Resultados reais do audit
- Score médio da biblioteca: 75.8/100
- Pior skill: score 22 — falhou no frontmatter completamente (template nunca limpo)
- Segundo pior: score 28 — 750 palavras onde deveriam ser 5 bullet points
- Melhor skill: score 92 — fez uma coisa e fez claramente
- Padrão geral: skills dependem de arquivos externos em vez de dizer o que fazem upfront; faltam exemplos concretos; faltam notas sobre quando NÃO usar

## Key insights
- /workflows view: 35 agentes rodando lado a lado — "para de parecer 1 assistente, começa a parecer um time"
- Hierarquia de complexidade determina ferramenta: ask → Skill → Subagent → Workflow
- O custo do workflow não é o modelo — é apontar para o job errado (jobs que precisam de contexto acumulado)
- Workflows são ideais para: audits, análises paralelas, scoring em lote — não para tasks que dependem umas das outras
- Script reutilizável = skill que cria automação, não só executa tarefa

## Exemplos e evidências
- Caso concreto: 35 skills auditadas em 4.5 minutos, todo em Haiku = custo quase nulo
- Relatório final abrível no browser com ranking pior→melhor + padrões cross-skills

## Implicações para o vault
- Pattern diretamente aplicável: pipeline-diario pode usar dynamic workflow para F1.1 scoring de múltiplos candidatos
- Critérios de skill score (clareza, frontmatter, trigger) = template para audit das skills do vault
- Hierarquia ask→Skill→Subagent→Workflow formaliza decisão que hoje é implícita no vault
- Score médio 75.8 com pior=22 e melhor=92: distribuição esperada ao auditar skills do vault-michel

## Links
- [[03-RESOURCES/concepts/agent-systems/context-budget-constraint]]
- [[03-RESOURCES/concepts/agent-systems/agent-model-routing]]
- [[04-SYSTEM/wiki/hot.md]]
