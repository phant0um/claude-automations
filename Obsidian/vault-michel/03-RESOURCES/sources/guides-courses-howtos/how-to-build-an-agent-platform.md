---
title: "How to Build an Agent Platform"
type: source
source_file: "clippings/How to Build an Agent Platform.md"
author: "@ashpreetbedi"
published: 2026-05-07
ingested: 2026-05-09
tags: [agent-platform, multi-agent, infrastructure, agent-runtime, agentic-architecture]
triagem_score: 9
---

# How to Build an Agent Platform

**Source:** https://x.com/ashpreetbedi/status/2052413981487427871
**Author:** [[03-RESOURCES/entities/Ashpreet-Bedi]] ([@ashpreetbedi](https://x.com/ashpreetbedi))
**Published:** 2026-05-07

## Thesis

Every company building a fleet of agents needs an **agent platform** — a unified OS-like system that runs agents, collects data, manages security, and enables recursive self-improvement. Stitching multiple vendors (separate trace tools, memory services, orchestration layers) reproduces the painful unbundling of the data era. Owning the stack is what closes the improvement loop.

> "The agents you ship today are the smallest part of what you've built. The platform underneath them, and the iteration loop it enables, is the thing that matters."

## Platform Layers (5 components)

| Layer | Role |
|---|---|
| **Runtime** | Service that runs agents — heavy lifting. FastAPI + Docker. |
| **Storage** | Postgres: sessions, memory, knowledge, traces, eval history. |
| **Connectors** | Tools via MCP, API, or CLI in one place (security boundary). |
| **Interfaces** | Slack, Discord, Telegram, custom UIs. Unified user identity across surfaces. |
| **Infrastructure** | Docker (local) / Railway (prod, ~$20/mo). |

Implementation: [[03-RESOURCES/entities/Agno]] framework, `AgentOS` class. Template: `agno-agi/agentos-railway-template`.

## Orchestration Modes (beyond single agents)

- **Coordinate** — leader decomposes, calls specialists, synthesizes.
- **Route** — router picks one specialist per request.
- **Broadcast** — all specialists run in parallel, aggregated.

Rule: *agents for open questions, teams for routing, workflows for processes.*

## Recursive Improvement Loop

1. Run agent live on platform.
2. Claude Code hits live agent via curl.
3. Traces in Postgres are readable by Claude Code.
4. Claude Code iterates agent code.
5. Evals (`evals/cases.py`) lock in behavior — run on schedule, fail on drift.

Key insight: the loop only closes because **trace data and iteration tool share the same stack**. Vendor-stitched setups split this surface and the loop never closes.

## Security Model

- JWT-based token auth ON by default.
- Per-request identity: `user_id`, `session_id` injected from token.
- Granular RBAC: user tokens vs admin tokens.
- Rationale: auth-off defaults get deployed to public internet and stay there.

## Opinions / Recommendations

- Don't split data across 3 providers — you lose the auto-improvement loop.
- Data sovereignty: traces in your own DB = compliance + iteration capability.
- Railway for fast/cheap hosting; auto-deploy from GitHub main.
- Non-technical users: no-code UI at `os.agno.com`.
- Scheduled evals weekly in production — catch drift before users feel it.

## Conexoes

- [[03-RESOURCES/concepts/agent-systems/agent-platform-architecture]] — five-layer model extracted here
- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]] — evals as regression tests, eval_db pattern
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — coordinate/route/broadcast modes
- [[03-RESOURCES/entities/Agno]] — framework providing AgentOS, teams, workflows
- [[03-RESOURCES/entities/Ashpreet-Bedi]] — author, ex-cloud/data platform builder

## Por Que "Não Fragmentar o Stack" É um Argumento de Engenharia, Não de Preferência

A recomendação central do artigo — "don't split data across 3 providers" — tem uma justificativa técnica específica: o recursive improvement loop só funciona quando trace data e iteration tool compartilham o mesmo stack.

O loop:
```
Agente em produção → gera traces → Claude Code lê traces → Claude Code melhora código → novo deploy
```

Se os traces estão no Datadog, a memória está no LangSmith, e o código está no GitHub, Claude Code precisa de três autenticações e três formatos de API para ler o estado completo do sistema antes de fazer qualquer melhoria. O custo de configuração de cada iteração aumenta até que o loop seja abandonado na prática.

Com tudo no Postgres local: `SELECT * FROM traces WHERE agent_id = 'my-agent' ORDER BY created_at DESC LIMIT 50` é o único acesso necessário. Claude Code pode fazer isso em um tool call. O loop fecha.

## As Cinco Camadas — Responsabilidades Técnicas Detalhadas

### Runtime (FastAPI + Docker)

O runtime é onde o código do agente realmente executa. FastAPI fornece:
- Endpoints REST para invocação do agente (via Slack, webhook, curl, ou Claude Code)
- Middleware para autenticação JWT antes de qualquer execução
- Request/response logging antes e depois de cada invocação (para traces)

Docker fornece:
- Isolamento de processo: cada agente pode ter suas próprias dependências Python sem conflito
- Portabilidade: mesmo Dockerfile roda local (desenvolvimento) e Railway (produção)
- Restart policies: container reinicia automaticamente se crashar

### Storage (Postgres — Por Que Não SQLite ou Redis)

Postgres escolhido sobre SQLite (sem concorrência entre múltiplos agentes) e Redis (sem query expressiva para análise de traces). O schema tem cinco tabelas principais:

- `sessions`: registro de cada conversa com user_id, timestamps, model usado
- `memory`: armazenamento de fatos persistentes por user_id e session_id
- `knowledge`: embeddings de documentos para retrieval semântico
- `traces`: log de cada step do agente (tool calls, reasoning, outputs)
- `eval_history`: resultados de runs de evaluation ao longo do tempo

A combinação memória + traces + eval_history em um só banco é o que fecha o improvement loop: você pode fazer JOIN entre "qual foi o output do agente" (traces) e "esse output passou na eval?" (eval_history) em uma query.

### Conectores (Ferramenta com Fronteira de Segurança)

A camada de conectores é onde vivem as ferramentas que os agentes podem usar: MCP servers, chamadas de API, execução de CLI. O papel desta camada como "fronteira de segurança" significa:

- Todo acesso externo passa pelo conector layer — o agente não chama APIs diretamente
- Permissões são declaradas no conector layer, não no código do agente
- Auditoria de tool use é centralizada: um log no conector layer captura cada invocação

Esta separação permite revogar o acesso de um agente a uma ferramenta específica sem reescrever o código do agente — apenas desabilitando o conector correspondente.

## Orchestration Modes — Quando Usar Cada Um

### Coordinate (Leader → Specialists → Synthesis)

Melhor quando: a tarefa é complexa e requer especialização em múltiplas dimensões, mas o output final deve ser coerente (não uma coleção de outputs paralelos).

O leader agent decompõe a tarefa, determina quais specialists precisam contribuir, e sintetiza as respostas em um output coerente. O leader é o responsável pela qualidade do output final — os specialists são workers que respondem a queries específicas.

**Custo:** comunicação multi-turno entre leader e specialists. Maior latência, maior custo. Justificado quando a síntese requer raciocínio sobre as contribuições dos specialists — não apenas concatenação.

### Route (Router → One Specialist)

Melhor quando: diferentes tipos de input requerem fundamentalmente diferentes capacidades, e a escolha do specialist é determinável antes da execução.

O router é um classificador: ele lê o input, determina qual specialist é mais adequado, e passa a execução. Não há síntese posterior — o specialist produz o output final diretamente.

**Custo:** baixo. Uma chamada ao router + uma chamada ao specialist. Melhor relação custo/qualidade para casos de uso onde a routing decision é clara.

### Broadcast (All Specialists → Aggregation)

Melhor quando: múltiplas perspectivas independentes são necessárias e a agregação é um merge simples (não síntese complexa).

Todos os specialists recebem o mesmo input e executam em paralelo. O resultado é aggregated — pode ser uma lista de perspectivas, um voto majoritário, ou uma tabela comparativa. A aggregation deve ser determinística (não outro LLM call).

**Custo:** mais alto em tokens absolutos (N specialists × custo individual). Justificado pela paralelização: a latência é determinada pelo specialist mais lento, não pela soma de todos.

## Security Model — Auth-On by Default

A decisão de habilitar JWT auth por padrão (em vez de deixar como opção) é baseada em observação empírica: setups "deixar para configurar depois" frequentemente vão para produção sem autenticação. Um agente público sem auth é um vetor de abuso imediato.

**Estrutura do JWT para agentes:**
```python
token_payload = {
    "user_id": "user_123",
    "session_id": "sess_456",
    "permissions": ["read", "write"],
    "agent_id": "my-agent",
    "exp": timestamp + 3600
}
```

O `user_id` injetado do token permite auditoria completa: toda action tomada pelo agente é rastreável ao usuário que fez a request. Tokens de admin têm permissões adicionais (modificar outros agentes, acesso a traces de outros usuários).

## Evals Como Testes de Regressão

O `evals/cases.py` pattern trata avaliações de agentes da mesma forma que testes unitários tratam funções: casos concretos com input + expected output, rodados automaticamente, falha = bloqueia deploy.

A diferença de implementação: expected output para agentes não é uma string exata — é um conjunto de critérios verificáveis (contém a informação X, não menciona Y, formato Z). O eval runner usa um LLM-as-judge para verificar critérios qualitativos.

**Schedule semanal em produção:** rodar evals em cada deploy captura regressões imediatamente. O schedule semanal adicional captura drift por mudanças externas — documentação de referência desatualizada, APIs externas que mudaram comportamento, mudanças no modelo subjacente.
