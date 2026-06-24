---
title: "How to Run Multiple Agents in Parallel"
type: source
source_url: "https://x.com/NebulaAI/status/2058601239307272486"
author: "@NebulaAI"
published: 2026-05-24
ingested: 2026-05-28
tags: [ai-agents, parallel, orchestration, multi-agent, fan-out, lead-agent]
---

# Running Multiple Agents in Parallel

**Tese central:** Paralelismo de agentes pode reduzir workflows de 2h para 20 min, mas a maioria dos developers tenta manualmente e vira o gargalo eles mesmos. A solução é estrutural: canais dedicados por tipo de trabalho + um Lead Agent que despacha tarefas + um results-channel centralizado.

## Key insights

- **Framework de decisão — cooking analogy**: "Você não espera o arroz cozinhar para picar os legumes." Se uma task não depende do output da anterior → paralela. Se depende → sequencial. A maioria dos workflows é 60% paralelo no início, 40% sequencial no final (síntese).
- **3 padrões de workflows paralelos**:
  1. **Fan-out**: 1 input, múltiplos agentes processam diferente (ex: mesmo artigo → versão SEO + versão X + versão email)
  2. **Independent batch**: 1 agente clonado N vezes, cada instância com 1 item de uma lista (ex: 10 tópicos → 10 research agents)
  3. **Specialist swarm**: agentes diferentes em partes diferentes de um deliverable (ex: script + SFX + title cards em paralelo)
- **O problema oculto**: sem estrutura, o humano vira o middleware — roteando outputs entre chats, mantendo contexto na cabeça. Overhead de orquestração come toda a economia de tempo.
- **Solução NebulaAI**: Channels (workspaces dedicados por tipo) + Lead Agent (despacha tarefas, lê channels, não executa) + Results Channel centralizado (todo output vai para lá).
- **Regra de ouro**: *"Onde o output aterra importa mais do que quanta coisa você produziu."* Configurar o results channel primeiro, depois construir tudo ao redor.
- **Um time bem estruturado de 2 agentes bate um time desorganizado de 20.**

## Implicações para o vault

- Os 3 padrões (fan-out, batch, swarm) complementam [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]].
- Lead Agent como dispatcher é instância do padrão [[03-RESOURCES/concepts/agent-systems/hierarchical-orchestration]].
- Results channel centralizado é análogo ao output routing em [[03-RESOURCES/concepts/agent-systems/coordination-layer-llm]].

## Links

- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/hierarchical-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/coordination-layer-llm]]
- [[03-RESOURCES/entities/Claude Code]]
