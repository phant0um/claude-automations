---
title: "Claude Dynamic Workflows for Your Second Brain"
type: source
source: "Clippings/Claude Dynamic Workflows for Your Second Brain.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents]
---

## Tese central

Dynamic Workflows não são apenas para desenvolvedores: são a maior atualização do Claude Code desde skills e sub-agentes, e o caso de uso mais valioso é justamente o knowledge worker que usa o vault como segundo cérebro — minerando sessões, notas diárias e notebooks para extrair padrões, corrigir comportamentos e gerar insights acionáveis de forma determinística e reproduzível.

## Argumentos principais

- A grande promessa: workflows resolvem três problemas crônicos de sub-agentes — (1) agent laziness em tarefas grandes, (2) self-preferential bias do agente principal, (3) goal drift ao longo de sessões longas
- Como funciona tecnicamente: programa determinístico em JavaScript que spawna sub-agentes com contextos isolados — não é possível "parar antes de acabar" como com sub-agentes manuais
- Sub-agentes com contextos isolados eliminam o bias de auto-preferência: cada um opera independentemente, sem acesso ao histórico da sessão principal
- Padrão recomendado: não manter workflows separados das skills — encapsular workflows JavaScript dentro de SKILL.md files para tudo ficar self-contained num único entity

## Key insights

- Caso de uso 1 — Minerar 50 sessões para extrair correções recorrentes: 10 agentes paralelos extraem, 1 agrupa, agentes finais reconciliam com CLAUDE.md existente; output: HTML report com 86 correções de 49 sessões analisadas
- Caso de uso 2 — Notas diárias: Haiku sub-agents por nota (muito rápidos), Opus para síntese cross-notes; output: insights rankeados com evidência citada (data + bullet point exato)
- Caso de uso 3 — NotebookLM: extração de transcritos → síntese → prompts paste-ready para implementar ideias
- Padrões avançados identificados: classify-and-act, fan-out-and-synthesize, tournament (tentativas → juiz → pick), loop-until-done, deep-verification (extrator de claims → verificador por fonte → relatório final verificado)
- Insight sobre skills: "I keep everything self-contained within the skills" — o arquivo JavaScript do workflow fica dentro da skill directory

## Exemplos e evidências

- Report HTML gerado: 49 sessões analisadas, 86 correções mineradas, cada citação verificada contra a sessão original
- Notas diárias: 31 notas analisadas com Haiku por nota; relatório com evidências datadas e bullet points exatos
- Modelo econômico: Haiku para extração barata em escala, Opus para síntese de qualidade
- Referência oficial: post de Thariq no blog do Claude sobre Dynamic Workflows

## Implicações para o vault

Aplicação direta ao vault-michel: o pipeline de ingestão poderia usar Dynamic Workflows para processar múltiplos sources em paralelo com sub-agentes isolados. A análise de notas diárias via workflow é aplicação direta à pasta `05-DAILY/`. O padrão de encapsular workflows dentro de skills é adotar como convenção. Contradição potencial com o design atual de skills separadas de workflows.

## Links

- [[03-RESOURCES/concepts/agent-systems/dynamic-workflows]]
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- [[03-RESOURCES/concepts/agent-systems/subagent-spawning]]
- [[03-RESOURCES/concepts/pkm-obsidian]]
- [[03-RESOURCES/concepts/second-brain]]
- [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]]
