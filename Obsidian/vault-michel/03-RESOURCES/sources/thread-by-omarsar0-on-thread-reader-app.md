---
title: "Thread by @omarsar0 on Thread Reader App — Dynamic Workflows reverse-engineered"
type: source
source: "Clippings/Thread by @omarsar0 on Thread Reader App.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, dynamic-workflows, agent-orchestration, claude-code, dair-ai]
---

## Tese central

Elvis (@omarsar0, DAIR.AI) reverse-engineered os Dynamic Workflows do Claude Code para seu próprio orchestrator customizado, demonstrando que o primitivo de "geração de harness on-the-fly" funciona além do ecossistema Claude Code — com Codex, Pi e até agentes nano customizados — e construiu um monitoring dashboard em HTML artifact para rastrear tarefas, métricas e relatórios.

## Argumentos principais

- Dynamic workflows funcionam fora do Claude Code: Elvis testou com Codex, Pi e um agente nano-like (inspirado em @karpathy style) construído para o DAIR.AI — todos compatíveis com o primitivo de geração de harness.
- O primitivo de dynamic workflows, como agent skills, é um componente fundamental que outros ecosistemas de agentes de coding (Codex, etc.) precisarão adotar — não é propriedade exclusiva do Claude Code.
- A ideia de owning the orchestrator and harness é a lição central: quem controla o harness controla o comportamento, os fluxos de verificação e a composição dos agentes.
- Use cases bem-sucedidos do autor: branching deep research com verificação, parallel deep research, session mining de sessões de agente, bug hunting, triaging, fact-checking, LLM councils, AI simulations, data synthesis, geração de evals.

## Key insights

- Primeiro caso conhecido de dynamic workflows funcionando efetivamente fora do ecossistema Claude Code — "this might be the first instance/proof, as far as I know."
- A combinação monitoring dashboard (HTML artifact) + orchestrator customizado demonstra que o ciclo completo de orquestração + observabilidade pode ser self-contained.
- "Dynamic workflows, like agent skills, feel like an important primitive to not only get the most out of agents but also incorporate dynamic behaviors and important components like cooperation and verification."
- O escopo vai muito além de coding tasks: ciência, pesquisa, casos de negócio, e qualquer domínio com tarefas longas e estruturadas se beneficiam do paradigma.
- O autor está planejando evento público em 25 de junho de 2026 ("Dynamic Workflows: Generating harnesses on the fly") para compartilhar o aprendizado.

## Exemplos e evidências

- Agente nano-like desenvolvido para DAIR.AI — demonstra que mesmo o agente mais simples pode aproveitar o primitivo de dynamic workflows.
- Monitoring dashboard em HTML artifact: rastreia tasks, metrics e reports de workflows em execução.
- Thread adicional sobre `/spec-init` slash command: usa AskUserQuestion tool para entrevistar o usuário e construir spec detalhada antes da execução — análogo ao spec-driven development do vault.

## Implicações para o vault

Confirma que o design de dynamic workflows é um primitivo arquitetural portável, não uma feature proprietária. A skill `spec-init` descrita no thread (usar AskUserQuestion para construir spec detalhada) é diretamente análoga ao agente `spec` do vault (`04-SYSTEM/agents/core/spec.md`). O conceito de LLM councils (múltiplos modelos deliberando) e AI simulations são extensões interessantes dos padrões de multi-agent já documentados no vault.

## Links

- [[03-RESOURCES/sources/a-harness-for-every-task-dynamic-workflows-in-claude-code]]
- [[03-RESOURCES/concepts/ai-agents/dynamic-workflows]]
- [[03-RESOURCES/concepts/ai-agents/multi-agent-orchestration]]
- [[03-RESOURCES/entities/dair-ai]]
