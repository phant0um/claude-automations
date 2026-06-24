---
title: Claude Managed Agents
type: entity
category: product
tags: [claude, anthropic, managed-agents, cloud, infraestrutura, agentes, api]
created: 2026-04-17
updated: 2026-05-19
---

# Claude Managed Agents

Plataforma hospedada da Anthropic para construir e deployar agentes autônomos de IA em escala. Lançado em **public beta em abril de 2026**. É o quarto e mais técnico produto Claude — infraestrutura, não interface.

## O que faz

- Roda Claude como agente autônomo de longa duração no cloud (minutos a horas sem supervisão)
- Fornece harness pré-construído (loop que chama Claude e roteia tool calls)
- Sandbox seguro com bash, operações de arquivo, web search, execução de código
- Suporte a MCP servers para conexão com serviços externos
- Persistência de sessão — agente retoma de onde parou após interrupção
- Multi-agent workflows — múltiplos agentes coordenando em tarefas complexas
- Prompt caching, context compaction e otimizações de performance built-in

## Arquitetura (3 componentes desacoplados)

```
1. Brain (Claude + harness)  → raciocínio e decisão de próxima ação
2. Hands (sandboxes + tools) → execução real do trabalho
3. Session (event log)       → registro durável de tudo que o agente fez
```

**Resiliência:** cada componente pode falhar e recuperar independentemente.
- Sandbox crasha → brain spawna novo sandbox
- Harness falha → novo harness carrega o event log e retoma
- Credentials ficam em vault seguro fora do sandbox

## Para quem

Desenvolvedores e empresas construindo produtos com IA. Empresas como **Notion, Asana, Sentry** já usam. Para embedar a inteligência do Claude em produtos próprios que rodam sem interação humana constante.

Não é produto consumer — requer API access, implementação técnica e design de workflows de agente.

## Preço

Usage-based via Claude API. Paga pelos tokens consumidos pelos agentes. Disponível para todas as contas API.

## Relação com outros produtos Claude

| Produto | Para quem | Autonomia |
|---|---|---|
| Claude Chat | Qualquer pessoa | Zero — usuário é intermediário |
| Claude Code | Desenvolvedores | Alta — age no repositório |
| Claude Cowork | Knowledge workers | Média — age no computador/apps |
| **Managed Agents** | Builders/devs | Total — corre no cloud sem supervisão |

## Conexão com harness architecture

O padrão de arquitetura descrito em [[03-RESOURCES/concepts/claude-code-tooling/claude-agent-harness-architecture]] é exatamente o que os Managed Agents implementam como produto. A "quarta camada" (infraestrutura) que Rohit descrevia agora tem produto oficial.

## Regulated Domain Use (May 2026)

Finance agent templates deploy as Managed Agents for autonomous, nightly/batch runs across whole books of deals. Infrastructure includes per-tool permissions, managed credential vaults, and full audit log in Claude Console for compliance teams. Leads Vals AI Finance Agent benchmark at 64.37% (Opus 4.7). See [[03-RESOURCES/sources/financial-trading/agents-for-financial-services]] and [[03-RESOURCES/concepts/agent-systems/regulated-domain-agents]].

## Toolset e governança (jun/2026)

A plataforma expõe um **agent toolset** built-in (`agent_toolset_20260401`: bash, read, write, edit, glob, grep, web_fetch, web_search) configurável por agente, mais suporte a **custom tools** (análogas às user-defined client tools da Messages API) e **MCP toolsets**. Outputs de ferramenta acima de 100.000 tokens são automaticamente despejados em arquivo no sandbox (overflow to disk). A execução é governada por **permission policies** (`always_allow` / `always_ask`), com defaults assimétricos — agent toolset confia por padrão (`always_allow`), MCP toolsets exigem aprovação por padrão (`always_ask`) — e um fluxo de confirmação assíncrono via eventos (`agent.tool_use` → `session.status_idle` com `requires_action` → `user.tool_confirmation`). Ver [[03-RESOURCES/sources/tools]] e [[03-RESOURCES/sources/permission-policies]].

## Modelo oficial da API: Agent / Environment / Session / Events (jun/2026)

A documentação oficial da API beta (`managed-agents-2026-04-01`) usa uma taxonomia de **quatro conceitos centrais** — Agent (modelo + system prompt + tools + MCP servers + skills, recurso versionado e referenciável por ID), Environment (cloud sandbox ou self-hosted), Session (instância de agente em execução, stateful, com checkpoints de sandbox preservados por 30 dias) e Events (comunicação bidirecional via SSE com convenção `{domain}.{action}`). Essa taxonomia mapeia, em granularidade mais fina, para a arquitetura "Brain / Hands / Session" descrita acima (Agent≈Brain+config, Environment≈Hands+infra, Session≈Session). Pontos centrais documentados nesse lote:

- **Agent**: recurso versionado; updates geram novas versões mas não propagam automaticamente para coordenadores que já o referenciam (roster fica "pinado" na versão snapshotada)
- **Outcomes**: mecanismo que "eleva uma session de conversa para trabalho" — define um alvo mensurável via rubric markdown, com um *grader* de contexto isolado (evita auto-avaliação enviesada) avaliando e iterando até `satisfied` (default 3, máx. 20 iterações)
- **Sessions**: máquina de estados simples (`idle`/`running`/`rescheduling`/`terminated`); updates de tools/MCP servers são session-local e não propagam ao agent
- **Multiagent**: coordenador delega a até 20 agentes em roster, cada um rodando em **session thread** isolado por contexto (máx. 25 threads concorrentes); profundidade de delegação limitada a **1 nível** (depth > 1 ignorada)

Ver lote completo de fontes técnicas (FASE 2, pipeline-diario 2026-06-06): [[03-RESOURCES/sources/define-your-agent]], [[03-RESOURCES/sources/define-outcomes]], [[03-RESOURCES/sources/start-a-session]], [[03-RESOURCES/sources/session-operations]], [[03-RESOURCES/sources/session-event-stream]], [[03-RESOURCES/sources/multiagent-sessions]].

## Fontes

- [[03-RESOURCES/sources/guides-courses-howtos/claude-ultimate-guide-april-2026]] — descrição completa do produto e arquitetura
- [[03-RESOURCES/sources/financial-trading/agents-for-financial-services]] — financial services agent templates and deployment patterns
- [[03-RESOURCES/sources/claude-managed-agents-overview]] — página-âncora da família de docs técnicas (Agent/Environment/Session/Events), beta header `managed-agents-2026-04-01`
- [[03-RESOURCES/sources/tools]] — configuração do toolset built-in e custom tools
- [[03-RESOURCES/sources/permission-policies]] — controle de execução e fluxo de confirmação de ferramentas
- [[03-RESOURCES/sources/define-your-agent]] — configuração e versionamento de agents
- [[03-RESOURCES/sources/define-outcomes]] — outcomes orientados a rubric com grader isolado
- [[03-RESOURCES/sources/start-a-session]] — criação e início de sessions
- [[03-RESOURCES/sources/session-operations]] — gestão do ciclo de vida de sessions (status, archive, delete)
- [[03-RESOURCES/sources/session-event-stream]] — streaming de eventos, interrupção, custom tools, retomada
- [[03-RESOURCES/sources/multiagent-sessions]] — coordenação de múltiplos agentes em threads isolados
