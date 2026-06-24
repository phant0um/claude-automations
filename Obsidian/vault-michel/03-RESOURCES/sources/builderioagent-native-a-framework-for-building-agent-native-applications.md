---
title: "BuilderIO/agent-native: A framework for building agent-native applications"
type: source
source: Clippings/BuilderIOagent-native A framework for building agent-native applications..md
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents]
---

## Tese central
Agent-Native é um framework open-source que trata agente e UI como cidadãos iguais do mesmo sistema: em vez de "chat ao lado do app", a mesma "action" definida uma vez serve UI, agente, HTTP, MCP, A2A e CLI simultaneamente. O objetivo é eliminar a divisão entre "ferramenta SaaS polida mas rígida" e "agente raw poderoso mas sem interface", oferecendo templates completos e abertos (não scaffolds) que o agente pode modificar diretamente.

## Argumentos principais
- **Uma action, seis superfícies**: `defineAction()` com schema Zod gera automaticamente endpoint HTTP, tool MCP, capability A2A, comando CLI e ação de UI — define-se a lógica de negócio uma vez.
- **Agent runtime integrado**: chat, tools, skills, memória, jobs, observabilidade e handoffs já vêm acoplados ao framework, em vez de serem integrados manualmente projeto a projeto.
- **Backend agnostic**: qualquer banco SQL suportado por Drizzle + qualquer host compatível com Nitro — sem lock-in de banco/hosting.
- **Sincronização real-time bidirecional**: humano e agente editam o mesmo documento como peers; mudanças de qualquer lado aparecem instantaneamente do outro.
- **Agentes chamam agentes**: tag de outro agente em qualquer app dispara coordenação via protocolo A2A (Agent-to-Agent).
- **Self-improving**: o próprio agente pode adicionar features, corrigir bugs e refinar a UI da aplicação ao longo do tempo — a aplicação evolui pelo uso.
- **Templates completos, não scaffolds**: Calendar, Content (Obsidian-like para MDX), Plans (visual plan mode `/visual-plan` + `/visual-recap` para coding agents), Slides, Analytics, Clips — cada um é um SaaS open-source clonável e 100% editável.
- **Skill instalável sem app completo**: `npx @agent-native/core@latest skills add visual-plan` adiciona `/visual-plan` (plano revisável com diagramas/wireframes antes de codar) e `/visual-recap` (recap visual de PR/diff) a qualquer harness (Claude Code, Codex, Cursor, Pi, OpenCode, Copilot).
- **Posicionamento competitivo explícito**: tabela comparando SaaS Tools (UI polida, rígida), Raw AI Agents (poder, sem UI), Internal Tools (customização total, alta manutenção) vs. Agent-Native (UI completa + agente integrado desde o design + você é dono do código).

## Key insights
- A divisão "produto SaaS" vs. "agente cru" é falsa quando a action é a unidade atômica compartilhada — o mesmo código de negócio vira interface clicável e capability de agente sem trabalho duplicado.
- "Context-aware": selecionar texto na UI e pedir ação ao agente (Cmd+I) funciona porque o agente já sabe o que está sendo visualizado — não é um chat genérico desconectado do estado da aplicação.
- O modelo de negócio de templates "cloneável, não scaffolded" resolve o trade-off ownership vs. velocidade: você começa com um produto funcional completo e tem o código, não um esqueleto.

## Exemplos e evidências
- Snippet de código mostrando `defineAction` com schema Zod e função `run` — uma única definição que "powers UI, agent, HTTP, MCP, A2A, and CLI".
- Seis templates completos disponíveis no momento da publicação: Calendar, Content, Plans, Slides, Analytics, Clips — cada um com analogia a produto SaaS estabelecido (Google Calendar/Calendly, Obsidian, Google Slides/Pitch, Amplitude/Mixpanel, Loom).
- Quick start de 4 comandos (`npx create my-app` → `cd` → `pnpm install` → `pnpm dev`), com opções de template completo, chat mínimo, ou headless (action-first sem UI).

## Implicações para o vault
- Caso concreto do padrão "uma definição, múltiplas superfícies de exposição" (UI/API/MCP/A2A/CLI) que se relaciona com [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]] — aqui a unidade atômica é a "action" de negócio, não skill/comando.
- Reforça a tendência de frameworks agent-first competindo diretamente com frameworks tradicionais de app (Next.js, Rails) ao invés de serem apenas wrappers de chat sobre apps existentes.
- Relevante para o projeto vault-michel como referência de "self-improving application" — o conceito de "agent modifica a própria app ao longo do tempo" ecoa [[03-RESOURCES/concepts/pkm-obsidian/self-improving-vault]], mas aplicado a software de produto em vez de second brain.

## Links
- [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]]
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]]
- [[03-RESOURCES/concepts/agent-systems/acp-agent-client-protocol]]
- [[03-RESOURCES/concepts/pkm-obsidian/self-improving-vault]]
