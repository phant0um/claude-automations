---
title: "6 Workflows, 6 Lessons, 60 Days with Hermes Analyst"
type: source
source: "Clippings/6 Workflows, 6 Lessons, 60 Days with Hermes Analyst.md"
created: 2026-05-25
ingested: 2026-06-02
tags: [ai-agents, hermes-agent, workflows, model-selection, memory]
author: "@0xJeff"
---

## Tese central
Após 60 dias rodando Hermes Agent em workflows reais de análise de investimentos: agentes falham na arquitetura, não na inteligência. Tools e skills importam mais que o modelo escolhido.

## Argumentos principais
- Agentes como Hermes falham por ferramentas conflitando entre si, não por modelo burro
- Troca de provider custa 2-3 sessões de debugging (API compat, auth flows, timeouts) — escolher 1 e manter
- Open-weight labs atingiram nível próximo a frontier labs em inteligência, a custo muito menor
- Hermes auto-cria skill quando percebe que o workflow será repetido — poupa tempo e custo de inferência
- Muitas skills > poucas skills: contexto bloats menos que ter skills insuficientes para o job
- Usuário é responsável por direcionar o agente para a ferramenta certa (não o agente decidir sozinho)
- Memória externa (Hindsight) permite recall de aprendizados passados — mas atenção ao custo de inferência

## Key insights
- Hierarquia de tools por qualidade: API/MCP/markdown skill > Exa/Firecrawl > Browser CDP > web search manual
- Provider direto (DeepSeek API direto) consistentemente melhor que multi-hop (OpenRouter) em latência
- Hermes skill auto-creation: 3 min manual → 10 seg na segunda vez — padrão replicável para qualquer workflow repetitivo
- External memory provider > memória nativa para recall de longo prazo com relações entre fatos
- Para one-off/exploração: Browser CDP + agentic search. Para workflows recorrentes: tool direto obrigatório

## Exemplos e evidências
- 5-6 provider setups em 60 dias: OpenRouter, Opencode Go, DeepSeek direto, Venice AI, Grok
- Exa (structured web search) + Firecrawl (JS-heavy sites) > search manual
- DeepSeek: 75% desconto em API direta antes de disponibilizar no OpenRouter
- 3 min workflow manual → 10s com skill criada automaticamente pelo agente

## Implicações para o vault
- Princípio tools > model confirmado: vault investe mais em skills/hooks que em seleção de modelo
- Padrão de skill auto-creation já existe no vault via hill + extend — pode ser documentado como conceito
- Hierarquia de tool quality é framework acionável para decisões de design de agentes no vault

## Links
- [[03-RESOURCES/concepts/agent-systems/agent-model-routing]]
- [[03-RESOURCES/concepts/agent-systems/context-budget-constraint]]
- [[04-SYSTEM/agents/nexus]]
