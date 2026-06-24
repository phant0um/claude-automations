---
title: Managed Agents Harness
type: concept
created: 2026-06-06
updated: 2026-06-06
tags: [agent-systems, managed-agents, harness, claude-api, infrastructure]
---

# Managed Agents Harness

Sistema de harness gerenciado da Anthropic (`managed-agents-2026-04-01`, beta) — alternativa de mais alto nível à Messages API direta. Em vez de o desenvolvedor orquestrar loops de tool-use manualmente, a Anthropic hospeda e gerencia o ciclo completo: provisionamento de sandbox, injeção de credenciais per-user, streaming de eventos, coordenação multiagente e avaliação de outcomes. Consolida 14 fontes ingeridas em 2026-06-06 — em vez de 14 stubs fragmentados, este concept mapeia como as peças se encaixam num sistema único e coerente.

## Os 4 conceitos centrais

O modelo inteiro reduz a uma cadeia: **Agent → Environment → Session → Events**.

1. **Agent** — blueprint reutilizável e versionado (model, system prompt, tools, MCP servers, skills). Não carrega segredos — é compartilhável entre usuários. Definido em [[03-RESOURCES/sources/define-your-agent]].
2. **Environment** — configuração reutilizável de *como* o sandbox é provisionado (pacotes, rede). Tipo `cloud` = hospedado pela Anthropic. Você cria um environment uma vez, referencia por ID em N sessions. Ver [[03-RESOURCES/sources/cloud-environment-setup]] e [[03-RESOURCES/sources/cloud-sandbox-reference]] (o que vem pré-instalado).
3. **Session** — instância de um agent rodando dentro de um environment; "an agent instance within an environment". Ciclo de vida em duas etapas: criar (provisiona sandbox) → enviar evento de usuário (inicia trabalho). É aqui que identidade, credenciais e recursos são injetados em runtime. Ver [[03-RESOURCES/sources/start-a-session]] e [[03-RESOURCES/sources/session-operations]] (retrieve/list/update/archive/delete + máquina de estados).
4. **Events** — modelo de comunicação assíncrono baseado em stream: enviar eventos de usuário, interromper/redirecionar mid-execução, confirmar tool calls, retomar sessions inativas, rastrear consumo de tokens. Mecanismo central pelo qual todas as outras camadas se comunicam. Ver [[03-RESOURCES/sources/session-event-stream]].

Visão geral consolidada em [[03-RESOURCES/sources/claude-managed-agents-overview]].

## Padrão arquitetural transversal: definição vs. credencial

O design de segurança do sistema inteiro converge num único princípio, repetido em praticamente todas as 14 fontes: **separar blueprint (sem segredo, compartilhável) de runtime (identidade, credenciais e recursos injetados por sessão)**.

- Agent definitions nunca carregam segredos — são portáveis e auditáveis.
- Sessions injetam identidade per-user, tokens e recursos no momento da criação — e **não depois**: anexação de memory stores, vaults e arquivos só acontece na criação da session (não suportado em session já rodando).
- Recursos (arquivos, repos, credenciais) são montados como **leitura imutável, referenciados por ID** — nunca ecoados de volta. Campos de segredo são *write-only*.
- Least-privilege como padrão transversal: tokens com escopo mínimo, redes limitadas, vaults com refresh automático.

Este é o mesmo princípio "definição vs. credencial" que aparece em [[03-RESOURCES/concepts/agent-security]] sob o Zero-Trust Framework — a Managed Agents API é uma implementação de produção desse modelo em escala.

## Camada de infraestrutura

- **Sandboxes `cloud`**: hospedados pela Anthropic, com hardware/SO, linguagens e bancos de dados pré-instalados — ver especificação completa em [[03-RESOURCES/sources/cloud-sandbox-reference]].
- **Claude Platform on AWS**: via de acesso enterprise — toda a stack (Messages API, Skills, code execution, Managed Agents) através da conta AWS do cliente, **operada pela Anthropic** (não pela AWS — diferença chave vs. Bedrock). Auth via IAM/SigV4, billing via AWS Marketplace. Único delta operacional vs. pilha nativa: limite de 6h para reautenticação em sessões autônomas. Ver [[03-RESOURCES/sources/claude-platform-on-aws]].

## Três vias de injeção de conteúdo

A API documenta exatamente três mecanismos para trazer conteúdo externo para dentro de uma sessão — todos seguindo o mesmo padrão "montagem imutável referenciada por ID":

1. **GitHub** — mount de repositório no sandbox + abertura de PRs via GitHub MCP. Ver [[03-RESOURCES/sources/accessing-github]].
2. **Files API** — camada de armazenamento "create-once, use-many-times"; upload referenciável por `file_id`, sem reenvio a cada chamada. Genérica (não exclusiva de Managed Agents). Ver [[03-RESOURCES/sources/files-api]].
3. **Adding files** — monta arquivos da Files API no sandbox da sessão para leitura/processamento (datasets, configs, código). Depende diretamente da Files API como camada subjacente. Ver [[03-RESOURCES/sources/adding-files]].

## Autenticação — vaults e credentials

Primitivas que permitem registrar credenciais de serviços terceiros **uma vez por usuário final** e referenciá-las por ID na criação de sessões — sem secret store próprio, sem retransmitir tokens a cada chamada, sem perder rastreabilidade de "em nome de quem" o agente agiu. Sustenta autenticação per-user em toda a stack (GitHub, MCP, Files). Ver [[03-RESOURCES/sources/authenticate-with-vaults]].

## Coordenação multiagente e outcomes

- **Multiagent sessions**: coordenar múltiplos agentes numa única session via modelo coordenador/roster, threads isolados de contexto, sandbox/credenciais compartilhados. Construído sobre o campo `multiagent` do Agent e o modelo de Events. Limite documentado: 20 skills totais por sessão, contadas coletivamente entre todos os agentes (não por agente). Ver [[03-RESOURCES/sources/multiagent-sessions]] e [[03-RESOURCES/sources/skills]].
- **Outcomes**: eleva uma session de "conversa" para "trabalho" — define como o resultado final deve parecer e como medir qualidade (rubric); o agente itera e se autoavalia até atingir o alvo, com um segundo agente "grader" fechando o ciclo de avaliação. Camada construída sobre Session + Events. Ver [[03-RESOURCES/sources/define-outcomes]].

## Por que importa

- **Para o vault**: 14 das 40 fontes ingeridas em 2026-06-06 (35% do lote) descrevem peças desta mesma superfície — sinal de que a Anthropic está investindo pesado numa nova camada de produto. Vale monitorar evolução (ainda beta).
- **Padrão replicável**: o modelo "definição-sem-segredo + injeção-de-runtime + recursos-imutáveis-por-ID" é um princípio de design de segurança generalizável para qualquer harness multi-tenant que o vault venha a desenhar (ex.: Hermes, agentes `00-core`).
- **Contraste com Messages API direta**: onde a Messages API exige orquestração manual do loop de tool-use, Managed Agents terceiriza isso — trade-off entre controle fino e velocidade de entrega. Relevante para decisões futuras de arquitetura de agentes do vault.

## Fontes (lote 2026-06-06)
- [[03-RESOURCES/sources/claude-managed-agents-overview]] — visão geral, os 4 conceitos
- [[03-RESOURCES/sources/define-your-agent]] — Agent
- [[03-RESOURCES/sources/define-outcomes]] — Outcomes
- [[03-RESOURCES/sources/start-a-session]] — Session (criação)
- [[03-RESOURCES/sources/session-operations]] — Session (CRUD/estados)
- [[03-RESOURCES/sources/session-event-stream]] — Events
- [[03-RESOURCES/sources/multiagent-sessions]] — coordenação multiagente
- [[03-RESOURCES/sources/cloud-environment-setup]] — Environment
- [[03-RESOURCES/sources/cloud-sandbox-reference]] — sandbox pré-instalado
- [[03-RESOURCES/sources/claude-platform-on-aws]] — deploy AWS
- [[03-RESOURCES/sources/accessing-github]] — injeção via GitHub
- [[03-RESOURCES/sources/adding-files]] — injeção via Files
- [[03-RESOURCES/sources/files-api]] — armazenamento subjacente
- [[03-RESOURCES/sources/authenticate-with-vaults]] — credenciais

## Related
- [[03-RESOURCES/concepts/agent-systems/harness-adaptation]]
- [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]]
- [[03-RESOURCES/concepts/agent-security]]
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/agent-observability]]

## Evidências
- [[03-RESOURCES/sources/announcing-claude-managed-agents-on-cloudflare]]: Cloudflare integra Claude Managed Agents com Sandboxes — decoupling brain (loop gerenciado na Anthropic) / hands (execução em microVM ou isolate V8), egress via outbound proxy com credential injection zero-trust.
