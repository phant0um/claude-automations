---
title: "OpenJarvis: a local-first personal AI is now available to run with Ollama"
type: source
source: "https://ollama.com/blog/openjarvis"
created: 2026-06-22
updated: 2026-06-22
tags: [ai-agents, local-first, ollama, openjarvis, stanford, personal-ai]
---

## Tese Central

OpenJarvis v1.0 é um framework open-source de Stanford's Hazy Research e Scaling Intelligence labs para construir personal AI agents que rodam no hardware próprio. Local-first é o default — models rodam localmente, cloud é opcional. Energy, cost, e latency são tracked alongside accuracy, como parte do "Intelligence Per Watt" research.

## Pontos-Chave

1. **Local-first como default**: Local models já handleiam day-to-day chat e reasoning, mas personal AI ainda envia tudo para cloud. OpenJarvis inverte: models locais, cloud opcional.
2. **Built-in Ollama support**: Install script auto-detecta Ollama existente. Config via `~/.openjarvis/config.toml` com default_model e preferred_engine.
3. **Built-in agents (presets)**: Morning briefing (calendar, email, news), Research across files (web + local docs com citations), Local coding agent (escreve e roda Python).
4. **Intelligence Per Watt**: Research de Stanford sobre efficient local AI. Energy, cost, latency tracked ao lado de accuracy — métricas de efficiency são first-class.

## Conceitos

- **Local-first AI**: models rodam no hardware do usuário, cloud é opcional
- **Intelligence Per Watt**: research program sobre efficient local AI medindo performance/energy
- **Agent presets**: bundles de agent + engines + tools prontos para run

## Links

- [[03-RESOURCES/entities/Ollama]]
- [[03-RESOURCES/entities/OpenJarvis]]
- [[03-RESOURCES/concepts/agent-systems/agent-architecture]]
- [[03-RESOURCES/concepts/llm-ml-foundations/inference-optimization]]