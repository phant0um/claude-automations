---
title: "Managed Agents Have a Portability Problem. I Ran One Agent Folder on Anthropic, Google, and Open AI."
type: source
source: "Clippings/Managed Agents Have a Portability Problem. I Ran One Agent Folder on Anthropic, Google, and Open AI..md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, portability, managed-runtimes, multi-provider]
---

## Tese central

Managed runtimes (Anthropic Managed Agents, Google Vertex Agent Engine) impõem formatos proprietários que quebram a portabilidade dos agentes, ao contrário dos frameworks self-hosted que já eram model-agnostic. A solução é manter a definição do agente como uma pasta neutra (o "folder-as-definition") e tratar o runtime como escolha de deploy intercambiável.

## Argumentos principais

- Frameworks model-agnostic (LangGraph, CrewAI, Mastra) resolveram portabilidade quando você roda o agente localmente; managed runtimes fazem o oposto — você entrega a orquestração ao vendor e sua definição assume o formato desse vendor.
- Anthropic usa YAML/ant CLI, Google usa ADK Python, OpenAI usa visual node graph — nenhum é neutro, e 20 agentes em qualquer formato exigem re-autoria completa ao mudar.
- A proposta do autor: o `agentlift` como compilador com três back-ends sobre uma única definição em pasta (`.managed-agents/`), com subagentes, skills e MCP declarados em frontmatter sem qualquer vendor.
- Anthropic é o único deploy com 8/8 capabilities nativas; Google tem deploy live com emulação de subagentes via ADK; OpenAI é export + self-host (sem orchestração hospedada).

## Key insights

- "Own the definition. Rent the runtime." — a definição (pasta markdown + config) é o ativo permanente; o runtime é commoditizado.
- A diferença real entre providers é WHO runs the orchestration loop: Anthropic e Google hospedam server-side; OpenAI requer que o app cliente rode o loop.
- `agentlift audit` roda offline e reporta por provider: native, emulated, degraded, unsupported — funciona como diagnóstico de compilador, não marketing table.
- Skills compartilhadas ficam em `shared/` e são attachadas a qualquer agente que as nomear; resolução: nome privado primeiro, depois shared.
- O `ant` CLI da Anthropic é apenas um dos outputs do `agentlift`, não um competidor.

## Exemplos e evidências

- Demo real: pasta `lead → bug-finder + researcher` deployada em Anthropic Managed Agents e Google Vertex reasoningEngine (ambas consultadas live), e exportada para OpenAI como `as_tool` script.
- Capability map publicado no repo com evidências de runtime (não apenas texto de resposta).
- Google: skills viajam como ADK `load_skill_from_dir`, MCP como `McpToolsets` com `tool_filter`, auth resolvida de env var local para Agent Engine env var (secret nunca cai no source).
- Google limitations: sem bash/web sandbox (só Python/JS), sem per-tool `:ask` approval no VertexAiSessionService.

## Implicações para o vault

- Reforça o padrão de "agent as folder" que o vault já usa (`.claude/agents/`, `.managed-agents/`).
- O conceito de "runtime como deploy choice" é diretamente aplicável ao design dos agentes do vault — manter system prompts em markdown neutro.
- `agentlift` é ferramenta concreta para testar portabilidade dos agentes existentes.
- Conecta ao debate provider lock-in para decisões de infraestrutura de agentes.

## Links

- [[03-RESOURCES/concepts/ai-agents/agent-portability]]
- [[03-RESOURCES/concepts/ai-agents/managed-runtimes]]
- [[03-RESOURCES/entities/agentlift]]
