---
skill: managed-agents-quickref
version: 1.0
author: Nexus Agent System
tags: [managed-agents, claude-api, reference, cheat-sheet, agent-systems]
---

# Skill: Managed Agents Quickref

## Propósito
Cheat-sheet consolidado da **Managed Agents API** (`managed-agents-2026-04-01`, beta) — referência rápida para os 4 conceitos centrais, o padrão de segurança transversal, limites documentados e onde achar cada peça entre as 14 fontes ingeridas em 2026-06-06 (consolidadas em [[03-RESOURCES/concepts/agent-systems/managed-agents-harness]]).

## Condições de Ativação
Ative quando precisar de resposta rápida sobre:
- Como desenhar/configurar um agent, environment ou session via Managed Agents API
- Limites documentados (skills, memory stores, MCP, reautenticação)
- O fluxo Agent → Environment → Session → Events e onde cada peça injeta o quê
- Comparar Managed Agents vs. Messages API direta vs. Claude Code para a mesma funcionalidade (skills, MCP, memória)

NÃO ative para: dúvidas conceituais profundas (→ ler [[03-RESOURCES/concepts/agent-systems/managed-agents-harness]] direto) ou implementação passo-a-passo (→ ler a fonte específica linkada abaixo).

---

## Modelo mental — a cadeia em 1 linha

**Agent** (blueprint reutilizável, sem segredo) → **Environment** (como provisionar o sandbox) → **Session** (instância rodando; aqui é onde identidade/credenciais/recursos são injetados) → **Events** (stream assíncrono — todo o resto se comunica por aqui).

## Cheat-sheet por componente

| Componente | O que é | Ponto-chave | Fonte |
|---|---|---|---|
| **Agent** | Blueprint versionado (model, system prompt, tools, MCP, skills) — compartilhável, sem segredo | Reutilizável entre N sessions | [[03-RESOURCES/sources/define-your-agent]] |
| **Environment** | Config de *como* provisionar o sandbox (pacotes, rede) | Tipo `cloud` = hospedado Anthropic; cria 1×, referencia por ID em N sessions | [[03-RESOURCES/sources/cloud-environment-setup]] |
| **Session** | Instância do agent rodando num environment | Ciclo: criar (provisiona) → enviar evento (inicia trabalho). Identidade/credenciais/recursos injetados SÓ AQUI — não pode anexar depois | [[03-RESOURCES/sources/start-a-session]], [[03-RESOURCES/sources/session-operations]] |
| **Events** | Comunicação assíncrona via stream | Enviar/interromper/redirecionar/confirmar tool call/retomar/rastrear tokens | [[03-RESOURCES/sources/session-event-stream]] |
| **Outcomes** | "O que é pronto" — rubrica de qualidade + auto-avaliação + grader | Eleva session de "conversa" → "trabalho mensurável" | [[03-RESOURCES/sources/define-outcomes]] |
| **Multiagent** | Coordenador/roster, threads isolados, sandbox/credenciais compartilhados | Limite de skills é coletivo (ver tabela de limites) | [[03-RESOURCES/sources/multiagent-sessions]] |

## Limites documentados (tabela rápida)

| Limite | Valor | Nota |
|---|---|---|
| Skills por sessão | **20 total** | Contado coletivamente entre TODOS os agentes da sessão — não por agente |
| Memory stores por sessão | **8** | Controle `read_write` (default) ou `read_only` (filesystem-level) |
| Tamanho de memória / store | **100kB / memória, 2.000 memórias / store** | Reforça "many small focused files" |
| Reautenticação (AWS) | **6 horas** | Único delta operacional vs. pilha nativa em sessões autônomas |
| `instructions` por memory store | **4096 caracteres** | Orientação contextual mostrada ao agente junto de `name`/`description` |

## Padrão de segurança transversal: "definição vs. credencial"

Repetido em quase todas as 14 fontes — princípio único:
- Agent definitions NUNCA carregam segredo (portáveis, auditáveis).
- Sessions injetam identidade/tokens/recursos SÓ na criação — não depois.
- Recursos montados como **leitura imutável, referenciados por ID**, nunca ecoados de volta. Campos de segredo são *write-only*.
- Least-privilege como padrão: tokens com escopo mínimo, redes limitadas, vaults com refresh automático.

Mesmo princípio do Zero-Trust Framework em [[03-RESOURCES/concepts/agent-security]] — aqui é a versão de produção em escala.

## 3 vias de injeção de conteúdo (todas "montagem imutável por ID")

1. **GitHub** — mount de repo + PRs via GitHub MCP → [[03-RESOURCES/sources/accessing-github]]
2. **Files API** — storage "create-once, use-many-times", referenciável por `file_id` → [[03-RESOURCES/sources/files-api]]
3. **Adding files** — monta arquivos da Files API no sandbox da session → [[03-RESOURCES/sources/adding-files]]

## Armadilhas de nomenclatura — não confundir

- `mcp-connector` (Messages API, beta `mcp-client`) **≠** `mcp-connector-1` (Managed Agents) — mesma funcionalidade, superfícies diferentes. Ver [[03-RESOURCES/sources/mcp-connector]] / [[03-RESOURCES/sources/mcp-connector-1]].
- Limite de skills: Messages API = 8/requisição · Managed Agents = 20/sessão (coletivo) · Claude Code = sem hard limit documentado.
- "Skill" tem 3 mecanismos de anexação distintos por superfície: array `skills` (Managed Agents) / `container.skills` (Messages API) / `SKILL.md` em diretório (Claude Code).

## Índice — as 14 fontes do lote 2026-06-06

`claude-managed-agents-overview` (overview) · `define-your-agent` (Agent) · `define-outcomes` (Outcomes) · `start-a-session` + `session-operations` (Session) · `session-event-stream` (Events) · `multiagent-sessions` (coordenação) · `cloud-environment-setup` + `cloud-sandbox-reference` (Environment/sandbox) · `claude-platform-on-aws` (deploy) · `accessing-github` + `adding-files` + `files-api` (injeção de conteúdo) · `authenticate-with-vaults` (credenciais) · `skills` (Skills nesta superfície)

## Restrições

- NUNCA tratar `mcp-connector` e `mcp-connector-1` como sinônimos — são docs de superfícies diferentes (risco de citar limite errado).
- NUNCA assumir que memory stores/vaults/arquivos podem ser anexados a uma session já em execução — só na criação.
- Para detalhe de implementação, sempre seguir o link da fonte específica — este cheat-sheet é ponto de entrada, não substitui a leitura completa.

## Related
- [[03-RESOURCES/concepts/agent-systems/managed-agents-harness]]
- [[03-RESOURCES/concepts/agent-security]]
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
