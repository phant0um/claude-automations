---
title: "Kimi K2.6"
type: entity
category: ai-model
organization: "Moonshot AI"
created: 2026-05-01
updated: 2026-05-01
tags: [entity, ai-model, multi-agent, long-horizon]
---

# Kimi K2.6

Modelo LLM da **Moonshot AI** (China) com arquitetura de multi-agent swarm nativamente escalável. Demonstrou coordenação de **300 sub-agentes paralelos** para completar revisões de literatura de 104 páginas em sessão única.

## Capacidades Documentadas

- **Escala:** até 300 sub-agentes paralelos em execução simultânea
- **Horizonte:** tarefas de 12–13 horas com 4.000+ tool calls
- **Output:** literatura reviews de 104 páginas one-shot
- **Contexto:** mantém coerência de propósito e dependências entre centenas de agentes paralelos

## Arquitetura Multi-Agent

Kimi K2.6 usa orquestração por **swarm** — diferente do padrão hierárquico (orchestrator → specialist agents), onde o orquestrador é um gargalo. O swarm distribui a coordenação e escala horizontalmente.

Distinção crítica:
- **Hierárquico:** 1 orchestrator + N workers → orchestrator é bottleneck
- **Swarm (Kimi):** coordenação distribuída → cada agente pode iniciar sub-agentes conforme necessário

## Implicações para Multi-Agent Orchestration

A escala de 300 agentes simultâneos coloca pressão em:
1. **Context isolation** — cada agente precisa de contexto escopado sem contaminar outros
2. **State synchronization** — 4K+ tool calls precisam de file-as-bus ou similar
3. **Cost management** — coordenação de 300 agentes em 12h exige eficiência extrema de tokens

## Casos de uso documentados (2026)

- 5-day continuous-ops agent trace para monitoring e incident response
- 12-hour Zig port autônomo
- 13-hour exchange-core refactor
- Geração de código a partir de inputs visuais (UI visual-to-code): layouts estruturados, elementos interativos, animações com precisão estética
- Acesso via API: DeepInfra (`moonshotai/Kimi-K2.6`), context window 256K tokens

## Relacionado

- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — arquitetura geral + Kimi como caso de escala extrema
- [[03-RESOURCES/concepts/pkm-obsidian/file-as-bus]] — padrão de coordenação via artefatos duráveis (compatível com swarm)
- [[03-RESOURCES/entities/AiScientist]] — outro sistema de longo-horizonte (74 ciclos em 23h)
- [[03-RESOURCES/sources/ai-agents-harness/5-tool-ai-stack-differentiated]]
- Fonte primária: `Clippings/How Kimi K2.6 Deploys 300 Sub Agents and One Shot a 104 Page Literature Review.md`
