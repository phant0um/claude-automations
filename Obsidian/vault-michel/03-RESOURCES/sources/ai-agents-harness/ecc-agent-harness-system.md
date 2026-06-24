---
title: "ECC: Agent Harness Performance Optimization System"
type: source
source: "Clippings/affaan-mECC The agent harness performance optimization system. Skills, instincts, memory, security, and research-first development for Claude Code, Codex, Opencode, Cursor and beyond..md"
created: 2026-05-31
ingested: 2026-05-31
tags: [ai-agents, harness, skills, cross-harness, agent-systems]
---

## Tese central

ECC é um sistema operator harness-native completo — não apenas configs, mas skills, instincts, memory optimization, continuous learning, security scanning e research-first development — construído de 10+ meses de uso diário intensivo em produtos reais, funcionando cross-harness (Claude Code, Codex, Cursor, OpenCode, Gemini, Zed, GitHub Copilot).

## Argumentos principais

- **Sistema, não configs** — ECC empacota o ciclo completo: skills (procedures reutilizáveis), instincts (comportamentos automáticos), memory optimization (qual informação persistir e como), continuous learning (melhoria contínua do próprio sistema), security scanning, e research-first development
- **Production-ready, evolutivo** — 10+ meses de evolução em uso real construindo produtos, não experimentos de laboratório
- **Cross-harness por design** — mesmos skills funcionam em Claude Code, Codex, Cursor, OpenCode, Gemini, Zed; abstração sobre o harness específico
- **182K stars / 28K forks** — tração de comunidade como sinal de product-market fit para o conceito de harness optimization
- **ECC v2.0.0-rc.1** — adiciona história pública do operador Hermes sobre a camada ECC reutilizável; cross-harness architecture documentada

## Key insights

- "Harness-native operator system" = o operador (usuário/equipe) tem um sistema completo que transcende qualquer harness específico
- Research-first development: padrão de pesquisar antes de implementar, embutido no próprio sistema como instinct
- Instincts = behaviors automáticos disparados por contexto, diferentes de skills (procedures explícitas) — distinção importante para vault
- Separação OSS (MIT) vs. ECC Pro (hosted GitHub App, $19/seat) como modelo de negócio sustentável para ferramentas de agência

## Exemplos e evidências

- 182K+ stars, 28K+ forks, 170+ contributors
- 12+ language ecosystems
- Anthropic (Claude Code), OpenAI (Codex), Google (Gemini), Cursor, Zed, GitHub Copilot

## Implicações para o vault

- ECC é o sistema externo mais próximo da arquitetura do vault (skills + memory + hooks + security)
- Conceito de "instincts" não está explicitado no vault — vale distinguir instincts (automáticos, reflexivos) de skills (explícitos, triggados)
- Cross-harness design do ECC sugere que skills do vault devem ser portáveis entre sessões e agentes, não amarradas ao harness Claude Code

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]]
- [[03-RESOURCES/concepts/agent-systems/agent-security-stack]]
- [[03-RESOURCES/sources/skillopt-self-evolving-agent-skills]]
- [[04-SYSTEM/agents/nexus]]
