---
title: "Hermes Agent — Official Docs: Features Part 2 (Memory Providers, Plugins/Hooks, Kanban, Reliability, Editor Integration, Code Execution)"
type: source
created: 2026-06-14
tags: [hermes, ai-agents, official-docs, features, memory, kanban, plugins, lsp, acp]
---

# Hermes Agent — Official Docs: Features (Part 2)

Consolidação de 17 páginas oficiais de `hermes-agent.nousresearch.com/docs/user-guide/features/`, ingeridas em 2026-06-14. Continuação de [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-features|Features Part 1]] (que cobriu Persistent Memory, Skills, Personality, Context Files, Tools). Esta página foca em: provedores de memória externos, sistema de extensibilidade (plugins/hooks), o sistema Kanban multi-agente, mecanismos de confiabilidade (fallback providers, provider routing), execução de código, referências de contexto, metas persistentes, LSP, e integração com editores (ACP). Documentação primária/normativa do [[03-RESOURCES/entities/hermes|Hermes]] ([[03-RESOURCES/entities/Hermes-Agent|Hermes Agent]]).

---

## 1. Memory Providers (External)

Hermes ships com 8 plugins de memory provider externos que complementam (não substituem) a memória built-in MEMORY.md/USER.md descrita em [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-features|Features Part 1, seção 1]]. Apenas **um** provider externo pode estar ativo por vez; a memória built-in continua ativa em paralelo.

### Setup

```bash
hermes memory setup      # picker interativo + configuração
hermes memory status      # checa o que está ativo
hermes memory off         # desativa provider externo
```

Ou manualmente em `~/.hermes/config.yaml`:

```yaml
memory:
  provider: openviking   # ou honcho, mem0, hindsight, holographic, retaindb, byterover, supermemory
```

### Ciclo de vida quando um provider está ativo

1. **Injeta contexto do provider** no system prompt
2. **Prefetch de memórias relevantes** antes de cada turno (background, non-blocking)
3. **Sincroniza turnos de conversa** com o provider após cada resposta
4. **Extrai memórias no fim da sessão** (para providers que suportam)
5. **Espelha writes da memória built-in** para o provider externo
6. **Adiciona tools específicas do provider** (busca, armazenamento, gestão de memórias)

### Providers disponíveis (resumo)

| Provider | Best for | Requer | Storage | Custo |
| --- | --- | --- | --- | --- |
| **Honcho** | Multi-agent systems, cross-session context | `pip install honcho-ai` + API key (honcho.dev) ou self-hosted | Honcho Cloud ou self-hosted | Honcho pricing / free (self-hosted) |
| **OpenViking** | Knowledge management self-hosted, browsing estruturado | `pip install openviking` + server rodando | Self-hosted | Free (open-source, AGPL-3.0) |
| **Mem0** | Extração de fatos hands-off via LLM server-side | `pip install mem0ai` + API key | Mem0 Cloud | Mem0 pricing |
| **Hindsight** | Knowledge graph, entity resolution, cross-memory synthesis (`hindsight_reflect`) | — | — | — |
| Holographic, RetainDB, ByteRover, Supermemory | (não detalhados nesta varredura) | — | — | — |

### Honcho — detalhe (provider plugin)

Honcho é tratado em duas páginas oficiais sobrepostas (Honcho Memory + Memory Providers); ambas convergem no mesmo modelo. Honcho é um backend de memória "AI-native" que adiciona **dialectic reasoning** e **deep user modeling** sobre a memória built-in — em vez de key-value storage, mantém um modelo vivo de quem é o usuário (preferências, estilo, objetivos, padrões), raciocinando sobre conversas após elas acontecerem.

**Comparação Built-in vs Honcho:**

| Capability | Built-in Memory | Honcho |
| --- | --- | --- |
| Cross-session persistence | File-based MEMORY.md/USER.md | Server-side com API |
| User profile | Curadoria manual do agente | Dialectic reasoning automático |
| Session summary | — | Context injection escopado por sessão |
| Multi-agent isolation | — | Per-peer profile separation |
| Observation modes | — | Unified ou directional |
| Conclusions (insights derivados) | — | Reasoning server-side sobre padrões |
| Search | FTS5 session search | Semantic search sobre conclusions |

**Setup:**

```bash
hermes memory setup    # selecionar "honcho"
```

```yaml
memory:
  provider: honcho
```

```bash
echo 'HONCHO_API_KEY=***' >> ~/.hermes/.env
```

**Two-Layer Context Injection** (toda turn, em modo `hybrid` ou `context`):

1. **Base context** — session summary, user representation, peer card, AI self-representation, AI identity card. Refresh em `contextCadence`. Camada "quem é esse usuário".
2. **Dialectic supplement** — reasoning LLM-sintetizado sobre estado/necessidades atuais do usuário. Refresh em `dialecticCadence`. Camada "o que importa agora".

Ambas concatenadas e truncadas ao budget `contextTokens` (se configurado).

**Cold/Warm prompt selection** (automático, baseado em se base context já existe):
- **Cold start** (sem base context): query geral — "Quem é essa pessoa? Quais são suas preferências, objetivos, estilo de trabalho?"
- **Warm session** (base context existe): query escopada à sessão — "Dado o que foi discutido nesta sessão, o que é mais relevante agora?"

**Três knobs ortogonais** controlam custo e profundidade independentemente:

| Knob | Controla | Default |
| --- | --- | --- |
| `contextCadence` | Turnos entre chamadas `context()` API (refresh da base layer) | `1` |
| `dialecticCadence` | Turnos entre chamadas `peer.chat()` LLM (refresh da dialectic layer) | `2` (recomendado 1–5) |
| `dialecticDepth` | Número de passes `.chat()` por invocação dialética (1–3) | `1` |

Exemplo: `contextCadence: 1, dialecticCadence: 5, dialecticDepth: 2` → refresh do contexto base toda turn, dialectic a cada 5 turns, cada run de dialectic faz 2 passes.

**Dialectic Depth (Multi-Pass)**: quando `dialecticDepth` > 1:
- **Pass 0**: prompt cold ou warm
- **Pass 1**: self-audit — identifica lacunas/contradições no pass anterior (detalhe truncado na fonte)

**Tools Honcho (5):** `honcho_profile` (read/update peer card), `honcho_search` (semantic search), `honcho_context` (session context: summary, representation, card, messages), `honcho_reasoning` (LLM-synthesized), `honcho_conclude` (create/delete conclusions)

**Config:** `$HERMES_HOME/honcho.json` (profile-local) ou `~/.honcho/config.json` (global). Resolution order: `$HERMES_HOME/honcho.json` > `~/.hermes/honcho.json` > `~/.honcho/config.json`.

**Multi-peer / workspace model:**

| Conceito | O que é |
| --- | --- |
| **Workspace** | Ambiente compartilhado. Todos os profiles Hermes sob um workspace veem a mesma identidade de usuário. |
| **User peer** (`peerName`) | O humano. Compartilhado entre profiles no workspace. |
| **AI peer** (`aiPeer`) | Um por profile Hermes. Host key `hermes` → default; `hermes.<profile>` para outros. |
| **Observation** | Toggles per-peer controlando o que Honcho modela de quem. `directional` (default, todos os 4 ligados) ou `unified` (pool single-observer). |

```bash
hermes profile create coder --clone   # cria host block hermes.coder, AI peer eager-criado
hermes honcho sync                    # backfilla host blocks para profiles existentes, idempotente
```

**Observation toggles** (`observeMe`, `observeOthers`) — presets via `observationMode`:
- **`"directional"`** (default) — todos os 4 flags ligados. Full mutual observation, habilita cross-peer dialectic.
- **`"unified"`** — user `observeMe: true`, AI `observeOthers: true`, resto false. Single-observer pool.

> [!note] Migração
> `hermes honcho setup` (legado) ainda funciona — redireciona para `hermes memory setup`. Configs e dados server-side preexistentes permanecem intactos.

---

## 2. Plugin System & Event Hooks

### Plugin System

Sistema de plugins para adicionar tools, hooks e integrações customizadas **sem modificar o core**. Diferente do developer guide "Adding Tools" (que é para tools built-in que vivem em `tools/` e `toolsets.py`).

**Estrutura:**

```
~/.hermes/plugins/my-plugin/
├── plugin.yaml      # manifest
├── __init__.py      # register() — wires schemas to handlers
├── schemas.py       # tool schemas (o que o LLM vê)
└── tools.py         # tool handlers (o que executa quando chamado)
```

Drop a directory, restart Hermes — tools aparecem ao lado das built-in, modelo pode chamá-las imediatamente.

**Exemplo minimal** (`hello-world` plugin): `plugin.yaml` com `name`, `version`, `description`; `__init__.py` define `register(ctx)` que registra schema + handler via `ctx.register_tool(name=..., toolset=..., schema=..., handler=..., description=...)` e um hook via `ctx.register_hook("post_tool_call", on_tool_call)`.

> Project-local plugins em `./.hermes/plugins/` são desabilitados por default. Habilitar apenas para repos confiáveis via `HERMES_ENABLE_PROJECT_PLUGINS=true`.

**API `ctx.*` disponível dentro de `register(ctx)`:**

| Capability | Como |
| --- | --- |
| Add tools | `ctx.register_tool(name=..., toolset=..., schema=..., handler=...)` |
| Add hooks | `ctx.register_hook("post_tool_call", callback)` |
| Add slash commands | `ctx.register_command(name, handler, description)` — adiciona `/name` no CLI e gateway |
| Dispatch tools from commands | `ctx.dispatch_tool(name, args)` — invoca tool registrada com contexto do parent-agent auto-wired |
| Add CLI commands | `ctx.register_cli_command(name, help, setup_fn, handler_fn)` — adiciona `hermes <plugin> <subcommand>` |
| Inject messages | `ctx.inject_message(content, role="user")` |
| Ship data files | `Path(__file__).parent / "data" / "file.yaml"` |
| Bundle skills | `ctx.register_skill(name, path)` — namespaced como `plugin:skill`, carregado via `skill_view("plugin:skill")` |
| Gate on env vars | `requires_env: [API_KEY]` em plugin.yaml — prompted durante `hermes plugins install` |
| Distribute via pip | `[project.entry-points."hermes_agent.plugins"]` |
| Register gateway platform | `ctx.register_platform(name, label, adapter_factory, check_fn, ...)` |
| Register image-gen backend | `ctx.register_image_gen_provider(provider)` |
| Register video-gen backend | `ctx.register_video_gen_provider(provider)` |

> Guia recomendado para construir um plugin do zero: "Build a Hermes Plugin" (link nos docs oficiais).

### Event Hooks — três sistemas

| Sistema | Registrado via | Roda em | Use case |
| --- | --- | --- | --- |
| **Gateway hooks** | `HOOK.yaml` + `handler.py` em `~/.hermes/hooks/` | Gateway apenas | Logging, alertas, webhooks |
| **Plugin hooks** | `ctx.register_hook()` num plugin | CLI + Gateway | Tool interception, métricas, guardrails |
| **Shell hooks** | bloco `hooks:` em `~/.hermes/config.yaml` apontando para shell scripts | CLI + Gateway | Scripts drop-in para blocking, auto-formatting, context injection |

Todos os três são non-blocking — erros em qualquer hook são capturados e logados, nunca derrubam o agente.

### Gateway Event Hooks — detalhe

Cada hook é um diretório sob `~/.hermes/hooks/`:

```
~/.hermes/hooks/
└── my-hook/
    ├── HOOK.yaml      # declara quais eventos escutar
    └── handler.py     # função handler Python
```

`HOOK.yaml`:

```yaml
name: my-hook
description: Log all agent activity to a file
events:
  - agent:start
  - agent:end
  - agent:step
```

`handler.py` deve definir uma função `handle(event_type, context)` — pode ser `async def` ou `def`.

**Eventos disponíveis:**

| Event | Quando dispara | Context keys |
| --- | --- | --- |
| `gateway:startup` | Processo do gateway inicia | `platforms` |
| `session:start` | Nova sessão de mensageria criada | `platform`, `user_id`, `session_id`, `session_key` |
| `session:end` | Sessão terminada (antes do reset) | `platform`, `user_id`, `session_key` |
| `session:reset` | Usuário rodou `/new` ou `/reset` | `platform`, `user_id`, `session_key` |
| `agent:start` | Agente começa a processar mensagem | `platform`, `user_id`, `session_id`, `message` |
| `agent:step` | Cada iteração do loop tool-calling | `platform`, `user_id`, `session_id`, `iteration`, `tool_names` |
| `agent:end` | Agente termina de processar | `platform`, `user_id`, `session_id`, `message`, `response` |
| `command:*` | Qualquer slash command executado | `platform`, `user_id`, `command`, `args` |

**Wildcard matching**: handlers registrados para `command:*` disparam para qualquer evento `command:` (ex: `command:model`, `command:reset`).

**Exemplos**: Telegram alert quando agente roda mais de N steps (`agent:step` + threshold); Command Usage Logger para `command:*` que registra uso de slash commands em JSONL.

---

## 3. Kanban (Multi-Agent Board)

Task board durável SQLite-backed, compartilhado entre todos os profiles Hermes, para colaboração multi-agente sem subagent swarms in-process fráteis. Cada task é uma row em `~/.hermes/kanban.db`; cada handoff é uma row que qualquer profile pode ler/escrever; cada worker é um processo OS completo com identidade própria.

> Ver também tutorial dedicado com walkthroughs de 4 user stories (solo dev, fleet farming, role pipeline com retry, circuit breaker) — seção 3.2 abaixo.

### Duas superfícies

- **Agentes** dirigem o board via toolset dedicado `kanban_*`: `kanban_show`, `kanban_list`, `kanban_complete`, `kanban_block`, `kanban_heartbeat`, `kanban_comment`, `kanban_create`, `kanban_link`, `kanban_unblock`. O dispatcher spawna cada worker já com essas tools no schema; profiles orquestradores também podem habilitar o toolset `kanban` explicitamente.
- **Humanos/scripts/cron** dirigem via `hermes kanban …` no CLI, `/kanban …` como slash command, ou o dashboard.

Ambas superfícies passam pela mesma camada `kanban_db` — leituras consistentes, writes não driftam.

### Casos de uso cobertos (que `delegate_task` não cobre)

- **Research triage** — pesquisadores paralelos + analyst + writer, human-in-the-loop
- **Scheduled ops** — briefs diários recorrentes construindo um journal ao longo de semanas
- **Digital twins** — assistentes nomeados persistentes (`inbox-triage`, `ops-review`) acumulando memória
- **Engineering pipelines** — decompor → implementar em worktrees paralelos → review → iterar → PR
- **Fleet work** — um especialista gerenciando N subjects (50 contas sociais, 12 serviços monitorados)

### Kanban vs `delegate_task`

| | `delegate_task` | Kanban |
| --- | --- | --- |
| Shape | RPC call (fork → join) | Durable message queue + state machine |
| Parent | Bloqueia até child retornar | Fire-and-forget após `create` |
| Child identity | Subagent anônimo | Profile nomeado com memória persistente |
| Resumability | Nenhuma — failed = failed | Block → unblock → re-run; crash → reclaim |
| Human in the loop | Não suportado | Comment/unblock em qualquer ponto |
| Agents per task | Uma call = um subagent | N agentes ao longo da vida da task (retry, review, follow-up) |
| Audit trail | Perdido em context compression | Rows duráveis em SQLite para sempre |
| Coordination | Hierárquica (caller → callee) | Peer — qualquer profile lê/escreve qualquer task |

**Distinção em uma frase**: `delegate_task` é uma function call; Kanban é uma work queue onde todo handoff é uma row que qualquer profile (ou humano) pode ver e editar.

**Use `delegate_task`** quando o parent precisa de resposta de raciocínio curta antes de continuar, sem humanos envolvidos, resultado volta pro contexto do parent.

**Use Kanban** quando o trabalho cruza fronteiras de agentes, precisa sobreviver a restarts, pode precisar de input humano, pode ser pego por um role diferente, ou precisa ser descobrível depois.

Coexistem: um worker kanban pode chamar `delegate_task` internamente durante seu run.

### Conceitos centrais

- **Board** — fila standalone de tasks com SQLite DB própria, diretório de workspaces, e dispatcher loop próprios. Uma instalação pode ter múltiplos boards (um por projeto/repo/domínio). Usuários single-project ficam no board `default` e nunca veem a palavra "board".
- **Task** — row com title, body opcional, um assignee (nome de profile), status (`triage | todo | ready | running | blocked | done | archived`), tenant namespace opcional, idempotency key opcional (dedup para automação retried).
- **Link** — row `task_links` registrando relações parent → child.

### 3.1 Worker Lanes (contrato)

Um **worker lane** é uma classe de processo para a qual o dispatcher kanban pode rotear tasks. Cada lane tem: identidade (assignee string), spawn mechanism, e contrato do que fazer com a task uma vez spawnada.

**Hierarquia:**

```
Hermes Kanban  =  ciclo de vida canônico da task + audit trail
Worker lane    =  executor de implementação para um card assignado
Reviewer       =  humano ou human-proxy que gateia "done"
GitHub PR      =  artefato upstreamable (opcional, para code lanes)
```

Kanban possui a verdade do lifecycle (`ready` → `running` → `blocked`/`done`/`archived`); worker lanes executam trabalho mas nunca possuem essa verdade — tudo flui de volta pelo kernel kanban via tools `kanban_*` (ou, para workers externos não-Hermes, via API).

**O que um lane deve fornecer:**

1. **Assignee string** — dispatcher casa `task.assignee` com nome de profile Hermes (lane shape default) ou identificador registrado não-spawnable (lane shape plugin). Tasks cujo assignee não resolve ficam em `ready` com evento `skipped_nonspawnable`.
2. **Spawn mechanism** — para profile lanes, `_default_spawn` roda `hermes -p <assignee> chat -q <prompt>` no workspace pinned da task, com env vars: `HERMES_KANBAN_TASK`, `HERMES_KANBAN_DB`, `HERMES_KANBAN_BOARD`, `HERMES_KANBAN_WORKSPACES_ROOT`, `HERMES_KANBAN_WORKSPACE`, `HERMES_KANBAN_RUN_ID`, `HERMES_KANBAN_CLAIM_LOCK`, `HERMES_PROFILE`, `HERMES_TENANT`. Para lanes não-Hermes (via plugin), o plugin fornece `spawn_fn` próprio recebendo `task`, `workspace`, `board` e retornando pid opcional.
3. **Lifecycle terminator** — cada claim deve terminar em exatamente um de:
   - `kanban_complete(summary=..., metadata=...)` — sucesso, status → `done`
   - `kanban_block(reason=...)` — espera input humano, status → `blocked`. Dispatcher respawna quando `kanban_unblock` roda.
   - Processo sai sem tool call → kernel reaper emite `crashed` (PID morreu), `gave_up` (circuit breaker de falhas consecutivas), ou `timed_out` (max_runtime excedido). Worker que não chama nenhum dos dois e sai normalmente é tratado como `crashed`.

**Convenção review-required**: para tasks que mudam código, em vez de `kanban_complete`, usar `kanban_block(reason="review-required: ...")` — sinaliza ao dashboard/`hermes kanban show` que a row aguarda revisão humana. Metadata estruturada vai num `kanban_comment` primeiro (já que `kanban_block` só carrega `reason` legível por humano).

Para quem escreve o código do worker em si (o agente rodando *dentro* de um lane), a skill `kanban-worker` (`skills/devops/kanban-worker/SKILL.md` no repo) cobre o detalhe procedural.

### 3.2 Tutorial — Setup e UI do board

```bash
hermes kanban init           # opcional; primeiro `hermes kanban <qualquer coisa>` auto-inicia
hermes dashboard              # abre http://127.0.0.1:9119 no browser
# clicar em Kanban no nav lateral
```

Workers spawnados pelo dispatcher **nunca veem** o dashboard ou CLI — dirigem o board via toolset `kanban_*`. Todas as três superfícies (dashboard, CLI, worker tools) passam pelo mesmo SQLite per-board (`~/.hermes/kanban.db` para o board default, `~/.hermes/kanban/boards/<slug>/kanban.db` para boards adicionais).

**Seis colunas do board:**

- **Triage** — ideias cruas. Por default o dispatcher auto-roda o **decomposer** em tasks aqui: usa `auxiliary.kanban_decomposer`, lê o roster de profiles + descrições, produz um grafo de child tasks roteadas aos especialistas mais adequados. A task original fica viva como parent para que seu assignee (`kanban.orchestrator_profile`, ou o profile default ativo) acorde para julgar a completude quando tudo terminar. Toggle **Orchestration: Auto/Manual** no topo da página kanban alterna os modos. Em modo Manual: clicar **⚗ Decompose** num card, ou `hermes kanban decompose <id>` / `/kanban decompose <id>`. Para tasks únicas sem fan-out, **✨ Specify** faz reescrita de spec one-shot (goal, approach, acceptance criteria) e promove para `todo`. Modelos configuráveis em `auxiliary.kanban_decomposer` e `auxiliary.triage_specifier`.
- **Todo** — criada mas esperando dependências, ou não assignada ainda
- **Ready** — assignada e esperando o dispatcher claimar
- **In progress** — worker ativo rodando a task. Com "Lanes by profile" ligado (default), a coluna se sub-agrupa por assignee
- **Blocked** — worker pediu input humano, ou circuit breaker disparou
- **Done** — completado

Barra superior: filtros (search, tenant, assignee), toggle "Lanes by profile", botão "Nudge dispatcher" (roda um tick de dispatch imediatamente). Clicar num card abre seu drawer à direita.

**Flat view**: toggle "Lanes by profile" off colapsa "In progress" numa lista flat ordenada por claim time.

**Story 1 — Solo dev shipping a feature**: design schema → implementar API → escrever testes, três tasks com dependências parent→child:

```bash
SCHEMA=$(hermes kanban create "Design auth schema" --assignee backend-dev ...)
```

(demais 3 stories do tutorial — fleet farming, role pipeline com retry, circuit breaker — não detalhadas nesta varredura; ver tutorial completo nos docs oficiais para screenshots do dashboard.)

---

## 4. Reliability: Fallback Providers & Provider Routing

### 4.1 Fallback Providers — três camadas de resiliência

1. **Credential pools** — rotação entre múltiplas API keys do *mesmo* provider (tentado primeiro)
2. **Primary model fallback** — troca automaticamente para um *provider:model* diferente quando o modelo principal falha
3. **Auxiliary task fallback** — resolução de provider independente para tarefas auxiliares (vision, compression, web extraction)

Credential pools tratam rotação same-provider (ex: múltiplas keys OpenRouter). Esta seção cobre cross-provider fallback. Ambos opcionais, funcionam independentemente.

**Primary Model Fallback**: quando o provider LLM principal encontra erros (rate limits, server overload, auth failures, connection drops), Hermes troca automaticamente para um par provider:model backup mid-session, sem perder a conversa.

**Configuração:**

```bash
hermes fallback   # manager interativo — add, list/ls, remove/rm, clear
```

Ou editar `~/.hermes/config.yaml` diretamente:

```yaml
fallback_providers:
  - provider: openrouter
    model: anthropic/claude-sonnet-4
```

Cada entrada requer `provider` e `model`; entradas faltando um campo são ignoradas.

> [!note] `fallback_model` vs `fallback_providers`
> `fallback_providers` (plural, list) é o shape atual, suporta múltiplos fallbacks em ordem. `fallback_model` (singular) é a key legada de fallback único — ainda honrada para back-compat, mas `hermes fallback` escreve `fallback_providers` e migra config legado on write. Quando ambos setados, `fallback_providers` tem prioridade.

**Providers suportados** (lista extensa — ~30 providers incluindo OpenRouter, Nous Portal, OpenAI Codex, GitHub Copilot/Copilot ACP, Anthropic, z.ai/GLM, Kimi/Moonshot, MiniMax (+ CN/OAuth variants), DeepSeek, NVIDIA NIM, GMI Cloud, StepFun, Ollama Cloud, Google Gemini (OAuth + AI Studio), xAI/Grok (+ OAuth), AWS Bedrock, Qwen Portal OAuth, OpenCode Zen/Go, Kilo Code, Xiaomi MiMo, Arcee AI, Alibaba/DashScope (+ Coding Plan), Tencent TokenHub, Microsoft Foundry, LM Studio local) — cada um com env var de credencial específica. Lista completa na fonte original se necessário para troubleshooting de um provider específico.

### 4.2 Provider Routing (OpenRouter)

Quando usando [OpenRouter](https://openrouter.ai/) como provider, Hermes suporta **provider routing** — controle fino sobre quais providers subjacentes atendem requests e como são priorizados (otimizar para custo, velocidade, qualidade, ou enforçar requisitos de provider específicos).

> Tráfego via Nous Portal ainda respeita configs de routing/priority per-model — e subscribers Portal ganham 10% off em providers cobrados por token.

**Configuração** (`~/.hermes/config.yaml`):

```yaml
provider_routing:
  sort: "price"           # como ranquear providers
  only: []                 # whitelist
  ignore: []                # blacklist
  order: []                 # ordem explícita de prioridade
  require_parameters: false  # só providers que suportam todos os parâmetros
  data_collection: null      # "allow" ou "deny"
```

> Provider routing só se aplica usando OpenRouter — sem efeito em conexões diretas (ex: API Anthropic direta).

**Opções:**

| Opção | Valores/Efeito |
| --- | --- |
| `sort` | `"price"` (mais barato primeiro), `"throughput"` (mais tokens/s primeiro), `"latency"` (menor TTFT primeiro) |
| `only` | Whitelist — apenas estes providers são usados, demais excluídos |
| `ignore` | Blacklist — estes providers nunca são usados mesmo se mais baratos/rápidos |
| `order` | Ordem explícita de prioridade; não listados são fallback |
| `require_parameters` | Quando `true`, só roteia para providers que suportam todos os parâmetros do request (`temperature`, `top_p`, `tools`, etc.) — evita parameter drops silenciosos |
| `data_collection` | `"allow"` ou `"deny"` — controla se providers podem usar prompts para training |

**Exemplos práticos**: otimizar para custo (`sort: "price"`), otimizar para velocidade interativa (`sort: "latency"`), otimizar para throughput em geração longa (`sort: "throughput"`), travar em providers específicos (`only: ["Anthropic"]`), evitar providers por privacidade (`ignore: [...]`, `data_collection: "deny"`), ordem preferida com fallback (`order: [...]`, `require_parameters: true`).

**Mecanismo**: preferências de routing são passadas à API OpenRouter via campo `extra_body.provider` em toda API call — tanto em modo CLI (config lido no startup) quanto modo Gateway (config lido quando gateway inicia).

---

## 5. Code Execution (`execute_code`)

Tool que permite o agente escrever scripts Python que chamam tools Hermes programaticamente, colapsando workflows multi-step em uma única LLM turn. O script roda em child process no host do agente, comunicando com Hermes via Unix domain socket RPC.

### Como funciona

1. Agente escreve script Python usando `from hermes_tools import ...`
2. Hermes gera um módulo stub `hermes_tools.py` com funções RPC
3. Hermes abre um Unix domain socket e inicia uma thread RPC listener
4. Script roda em child process — tool calls viajam pelo socket de volta ao Hermes
5. Só o output de `print()` do script retorna ao LLM; resultados intermediários de tools nunca entram na context window

**Tools disponíveis dentro de scripts:** `web_search`, `web_extract`, `read_file`, `write_file`, `search_files`, `patch`, `terminal` (foreground only).

### Quando o agente usa isso

- **3+ tool calls** com lógica de processamento entre elas
- Filtragem em massa ou branching condicional
- Loops sobre resultados

Benefício chave: resultados intermediários nunca entram na context window — só o `print()` final volta, reduzindo drasticamente uso de tokens.

### Exemplos práticos (padrões)

- **Data Processing Pipeline**: `search_files` + `read_file` em loop, agregando configs em JSON
- **Multi-Step Web Research**: `web_search` + `web_extract` em loop, agregando summaries
- **Bulk File Refactoring**: `search_files` + `patch` com `replace_all=True` em loop, contando arquivos corrigidos
- **Build and Test Pipeline**: `terminal` rodando `pytest`, parseando output para contar passed/failed/errors

### Execution Modes

Controlado por `code_execution.mode` em `~/.hermes/config.yaml`:

| Mode | Working directory | Python interpreter |
| --- | --- | --- |
| **`project`** (default) | Working directory da sessão (mesmo que `terminal()`) | `VIRTUAL_ENV`/`CONDA_PREFIX` python ativo, fallback para python do próprio Hermes |
| `strict` | Diretório de staging temporário isolado do projeto do usuário | `sys.executable` (python do próprio Hermes) |

**Quando deixar em `project`**: quer que `import pandas`, `from my_project import foo`, ou paths relativos como `open(".env")` funcionem igual a `terminal()`. Quase sempre o desejado.

**Quando trocar para `strict`**: precisa de reprodutibilidade máxima — mesmo interpreter toda sessão independente do venv ativo, scripts quarentenados da árvore do projeto (sem risco de leitura acidental de arquivos do projeto via path relativo).

---

## 6. Context References (`@`-syntax)

Digitar `@` seguido de uma referência injeta conteúdo diretamente na mensagem. Hermes expande a referência inline e adiciona o conteúdo sob uma seção `--- Attached Context ---`.

### Sintaxes suportadas

| Sintaxe | Descrição |
| --- | --- |
| `@file:path/to/file.py` | Injeta conteúdo do arquivo |
| `@file:path/to/file.py:10-25` | Injeta range de linhas específico (1-indexed, inclusive) |
| `@folder:path/to/dir` | Injeta listing da árvore de diretório com metadata |
| `@diff` | Injeta `git diff` (mudanças não staged) |
| `@staged` | Injeta `git diff --staged` |
| `@git:5` | Injeta últimos N commits com patches (max 10) |
| `@url:https://example.com` | Busca e injeta conteúdo de página web |

Múltiplas referências funcionam numa mensagem só. Pontuação trailing (`,`, `.`, `;`, `!`, `?`) é removida automaticamente do valor da referência.

### CLI Tab Completion

No CLI interativo, `@` dispara autocomplete: `@` mostra todos os tipos de referência; `@file:` e `@folder:` disparam completion de path com metadata de tamanho; `@` + texto parcial mostra arquivos/pastas correspondentes do diretório atual.

### Line Ranges

```
@file:src/main.py:42        # linha única 42
@file:src/main.py:10-25     # linhas 10-25 (inclusive)
```

1-indexed. Ranges inválidos são silenciosamente ignorados (retorna arquivo completo).

### Limites de tamanho

| Threshold | Valor | Comportamento |
| --- | --- | --- |
| Soft limit | 25% do context length | Warning anexado, expansão prossegue |
| Hard limit | 50% do context length | Expansão recusada, mensagem original retornada inalterada |
| Folder entries | máx 200 arquivos | Entradas excedentes substituídas por `- ...` |
| Git commits | máx 10 | `@git:N` clamped ao range [1, 10] |

### Segurança

**Sensitive Path Blocking** — sempre bloqueados de `@file:`:
- SSH: `~/.ssh/id_rsa`, `~/.ssh/id_ed25519`, `~/.ssh/authorized_keys`, `~/.ssh/config`
- Shell profiles: `~/.bashrc`, `~/.zshrc`, `~/.profile`, `~/.bash_profile`, `~/.zprofile`
- Credenciais: `~/.netrc`, `~/.pgpass`, `~/.npmrc`, `~/.pypirc`
- Hermes env: `$HERMES_HOME/.env`

Diretórios totalmente bloqueados (qualquer arquivo dentro): `~/.ssh/`, `~/.aws/`, `~/.gnupg/`, `~/.kube/`, `$HERMES_HOME/skills/.hub/`

**Path Traversal Protection**: todos os paths resolvidos relativos ao working directory; referências que resolvem fora do workspace permitido são rejeitadas.

**Binary File Detection**: detectada via MIME type + null-byte scanning. Extensões de texto conhecidas (`.py`, `.md`, `.json`, `.yaml`, `.toml`, `.js`, `.ts`, etc.) pulam detecção MIME. Binários rejeitados com warning.

### Platform Availability

Context references são primariamente feature de **CLI**. Em messaging platforms (Telegram, Discord, etc.) a sintaxe `@` não é expandida pelo gateway — mensagens passam as-is. O agente ainda pode referenciar arquivos via tools `read_file`, `search_files`, `web_extract`.

### Interação com Context Compression

Quando o contexto é compactado, o conteúdo expandido das referências é incluído no summary de compressão — arquivos grandes injetados via `@file:` contribuem para uso de tokens e, se compactados depois, são sumarizados (não preservados verbatim). Para arquivos muito grandes, usar line ranges.

---

## 7. Persistent Goals (`/goal`, `/subgoal`)

`/goal` dá a Hermes um objetivo permanente que persiste entre turnos. Após cada turno, um judge model leve checa se o goal foi satisfeito pela última resposta do assistente. Se não, Hermes alimenta automaticamente um prompt de continuação na mesma sessão e continua trabalhando — até o goal ser alcançado, o usuário pausar/limpar, ou o turn budget esgotar.

É a versão Hermes do **Ralph loop**, diretamente inspirada pelo `/goal` do Codex CLI 0.128.0 (Eric Traut, OpenAI). A ideia central — manter um goal vivo entre turnos e não parar até ser alcançado — é deles; a implementação aqui é independente e adaptada à arquitetura do Hermes.

### Quando usar

Para tasks onde você quer que Hermes itere sozinho sem re-prompt a cada turno:

- "Fix every lint error in src/ and verify ruff check passes"
- "Port feature X from repo Y, including tests, and get CI green"
- "Investigate why session IDs sometimes drift on mid-run compression and write up a report"
- "Build a small CLI to rename files by their EXIF dates, then test it against the photos/ folder"

Tasks de um turno só não precisam de `/goal`. Tasks onde você normalmente diria "continue" três vezes são onde isso brilha.

### Quick start

```
/goal Fix every failing test in tests/hermes_cli/ and make sure scripts/run_tests.sh passes for that directory
```

Sequência: (1) **Goal accepted** — `⊙ Goal set (20-turn budget): <goal>`; (2) **Turn 1 runs** — Hermes começa a trabalhar como se o goal fosse mensagem normal; (3) **Judge runs** — após o turno, judge model decide `done` ou `continue`; (4) **Loop fires if needed** — se `continue`, mostra `↻ Continuing toward goal (N/20): <reason>` e Hermes segue automaticamente; (5) **Terminates** — `✓ Goal achieved: <reason>` ou `⏸ Goal paused — N/20 turns used`.

### Comandos `/goal`

| Comando | O que faz |
| --- | --- |
| `/goal <text>` | Seta (ou substitui) o goal permanente. Dispara o primeiro turno imediatamente. |
| `/goal` ou `/goal status` | Mostra goal atual, status, turns usados |
| `/goal pause` | Para o loop de auto-continuação sem limpar o goal |
| `/goal resume` | Resume o loop (reseta o contador de turnos para zero) |
| `/goal clear` | Remove o goal completamente |

Funciona identicamente no CLI e em toda plataforma gateway (Telegram, Discord, Slack, Matrix, Signal, WhatsApp, SMS, iMessage, Webhook, API server, web dashboard).

### `/subgoal` — critérios adicionais mid-goal

Com um goal ativo, `/subgoal <text>` adiciona critério de aceitação extra sem resetar o loop. Cada call adiciona um item numerado à lista de subgoals; o **prompt de continuação** que o agente vê no próximo turno inclui o goal original + bloco "Additional criteria the user added mid-loop"; o **judge prompt** é reescrito para que o veredito considere todo subgoal — goal não é marcado `done` até o objetivo original **e** todos os subgoals serem atendidos.

| Comando | O que faz |
| --- | --- |
| `/subgoal <text>` | Adiciona critério à lista (requer `/goal` ativo) |
| `/subgoal` (sem args) | Mostra lista numerada de subgoals atuais |
| `/subgoal remove <N>` | Remove o Nº subgoal (1-based) |
| `/subgoal clear` | Remove todos os subgoals, mantém o goal original |

Subgoals persistem junto do goal em `SessionDB.state_meta`, sobrevivem `/resume`. Setar novo `/goal <text>` substitui o goal e limpa a lista de subgoals; `/goal clear` faz o mesmo.

**Caso de uso**: iniciar um loop ("fix the failing tests") e no meio do caminho querer "and add a regression test for the bug you just patched" — `/subgoal add a regression test` aperta o critério de sucesso sem quebrar o loop em execução.

### The judge (mecânica)

Após cada turno, Hermes chama um modelo auxiliar com: o texto do goal permanente, a última resposta final do agente (últimos ~4 KB de texto), e um system prompt instruindo o judge a decidir `done`/`continue` (detalhe truncado na fonte original).

---

## 8. Subagent Delegation (`delegate_task`)

Tool que spawna instâncias filhas de `AIAgent` com contexto isolado, toolsets restritos, e sessões de terminal próprias. Cada child recebe conversa fresca e trabalha independentemente — só seu summary final entra no contexto do parent.

### Single Task

```python
delegate_task(
    goal="Debug why tests fail",
    context="Error: assertion in test_foo.py line 42",
    toolsets=["terminal", "file"]
)
```

### Parallel Batch

Até 3 subagentes concorrentes por default (configurável via `delegation.max_concurrent_children`, sem hard ceiling):

```python
delegate_task(tasks=[
    {"goal": "Research topic A", "toolsets": ["web"]},
    {"goal": "Research topic B", "toolsets": ["web"]},
    {"goal": "Fix the build", "toolsets": ["terminal", "file"]}
])
```

### Subagents Know Nothing

> [!warning] Crítico
> Subagents começam com conversa **completamente fresca**. Zero conhecimento do histórico do parent, tool calls prévias, ou qualquer coisa discutida antes da delegação. O único contexto do subagent vem dos campos `goal` e `context` populados pelo parent na call.

Isso significa o parent deve passar **tudo** que o subagent precisa na call:

```python
# RUIM - subagent não sabe o que é "the error"
delegate_task(goal="Fix the error")

# BOM - subagent tem todo contexto necessário
delegate_task(
    goal="Fix the TypeError in api/handlers.py",
    context="""The file api/handlers.py has a TypeError on line 47: ...
    The project is at /home/user/myproject and uses Python 3.11."""
)
```

O subagent recebe um system prompt focado, construído a partir de `goal`+`context`, instruindo-o a completar a task e fornecer summary estruturado: o que fez, o que encontrou, arquivos modificados, issues encontradas.

### Padrões de uso

- **Parallel Research**: múltiplos tópicos pesquisados simultaneamente, cada um com `toolsets: ["web"]` e contexto/foco específico
- **Code Review + Fix**: delega review-and-fix para contexto fresco — descreve módulo, stack, foco de segurança, e pede para rodar test suite após
- **Multi-File Refactoring**: delega refactor que inundaria o contexto do parent — instruções precisas de padrão de substituição (`print()` → `logger.X()`), exclusões (test files), validação via `pytest`

### Batch Mode

Quando fornecido array `tasks`, subagents rodam em **paralelo** via thread pool — máximo 3 concorrentes por default (configurável via `delegation.max_concurrent_children` ou equivalente).

---

## 9. Scheduled Tasks (Cron)

Schedule de tasks automatizadas via linguagem natural ou expressões cron, gerenciadas por uma única tool `cronjob` com operações action-style (em vez de tools separadas schedule/list/remove).

### O que cron pode fazer

- Agendar tasks one-shot ou recorrentes
- Pause, resume, edit, trigger, remove jobs
- Atachar zero, um ou múltiplos skills a um job
- Entregar resultados de volta ao chat de origem, arquivos locais, ou targets de plataforma configurados
- Rodar em sessões de agente frescas com a lista de tools estática normal
- Rodar em **no-agent mode** — script agendado, stdout entregue verbatim, zero envolvimento de LLM

Tudo isso disponível ao próprio Hermes via tool `cronjob` — criar, pausar, editar, remover jobs pedindo em linguagem natural, sem precisar do CLI.

> Cron jobs usam o provider que `hermes model` selecionou. `hermes setup --portal` é a opção de menor fricção para runs unattended (OAuth refresh automático).

> [!warning]
> Sessões cron-run não podem recursivamente criar mais cron jobs — Hermes desabilita tools de gerenciamento de cron dentro de execuções cron para prevenir loops de scheduling descontrolados.

### Criação de tasks agendadas

**Via `/cron` no chat:**

```bash
/cron add 30m "Remind me to check the build"
/cron add "every 2h" "Check server status"
/cron add "every 1h" "Summarize new feed items" --skill blogwatcher
/cron add "every 1h" "Use both skills and combine the result" --skill blogwatcher --skill maps
```

**Via CLI standalone:**

```bash
hermes cron create "every 2h" "Check server status"
hermes cron create "every 1h" "Summarize new feed items" --skill blogwatcher
hermes cron create "every 1h" "Use both skills and combine the result" \
  --skill blogwatcher --skill maps --name "Skill combo"
```

**Via conversação natural**: pedir normalmente ("Every morning at 9am, check Hacker News for AI news and send me a summary on Telegram") — Hermes usa a tool `cronjob` internamente.

### Skill-backed cron jobs

Um cron job pode carregar um ou mais skills antes de rodar o prompt.

**Single skill:**

```python
cronjob(
    action="create",
    skill="blogwatcher",
    prompt="Check the configured feeds and summarize anything new.",
    schedule="0 9 * * *",
    name="Morning feeds",
)
```

**Multiple skills** (carregados em ordem, prompt é a instrução da task sobre essas skills):

```python
cronjob(
    action="create",
    skills=["blogwatcher", "maps"],
    prompt="Look for new local events and interesting nearby places, then combine them into one short brief.",
    schedule="every 6h",
    name="Local brief",
)
```

Útil para um agente agendado herdar workflows reutilizáveis sem stuff do texto completo do skill no prompt cron.

### Rodando dentro de um diretório de projeto

Por default, cron jobs rodam desacoplados de qualquer repo — sem `AGENTS.md`, `CLAUDE.md`, `.cursorrules` carregados; tools terminal/file/code-exec rodam a partir do working directory que o gateway iniciou. Passar `--workdir` (CLI) ou `workdir=` (tool call) muda isso:

```bash
hermes cron create "every 1d at 09:00" \
  "Audit open PRs, summarize CI health, and post to #eng" \
  --workdir /home/me/projects/acme
```

```python
cronjob(
    action="create",
    schedule="every 1d at 09:00",
    workdir="/home/me/projects/acme",
    prompt="Audit open PRs, summarize CI health, and post to #eng",
)
```

Quando `workdir` setado: `AGENTS.md`, `CLAUDE.md`, `.cursorrules` desse diretório são injetados no system prompt (mesma ordem de discovery do CLI interativo); `terminal`, `read_file`, `write_file`, `patch`, `search_files`, `execute_code` usam esse diretório como working directory. Path deve ser diretório absoluto existente — paths relativos/inexistentes são rejeitados.

> Ver "no-agent mode" nos docs originais para detalhe de script-only jobs (não detalhado nesta varredura).

---

## 10. LSP — Semantic Diagnostics

Hermes roda language servers completos — `pyright`, `gopls`, `rust-analyzer`, `typescript-language-server`, `clangd` e ~20 outros — como subprocessos de background, alimentando seus diagnostics semânticos no post-write lint check usado por `write_file` e `patch`. Quando o agente edita um arquivo, vê exatamente os erros que aquela edição introduziu — não só syntax errors, mas **type errors, undefined names, missing imports, e issues semânticos project-wide** que o language server detecta.

Mesma arquitetura usada por coding agents top-tier — Hermes ships self-contained: sem editor host requerido, sem plugins, sem daemon separado.

### Quando LSP roda

Gated em **detecção de workspace git**. Quando o working directory do agente (ou o arquivo sendo editado) está dentro de um repo git, LSP roda contra esse workspace. Quando nenhum está em repo git, LSP fica dormant — útil para messaging gateways onde o cwd é o home do usuário sem projeto para diagnosticar.

Check em camadas: syntax check in-process primeiro (microsegundos), depois LSP diagnostics quando syntax está limpo. Servidor flaky ou faltante nunca quebra um write — todo path de falha LSP cai silenciosamente para resultado syntax-only.

**Fluxo a cada `write_file`/`patch` bem-sucedido:**

1. Hermes captura baseline de diagnostics atuais do arquivo
2. Executa o write
3. Re-query o language server, filtra diagnostics já presentes na baseline, surfaça só os novos

Output exemplo:

```json
{
  "bytes_written": 42,
  "dirs_created": false,
  "lint": {"status": "ok", "output": ""},
  "lsp_diagnostics": "LSP diagnostics introduced by this edit:\n<diagnostics file=\"/path/to/foo.py\">\nERROR [42:5] Cannot find name 'foo' [reportUndefinedVariable] (Pyright)\nERROR [50:1] Argument of type \"str\" is not assignable to \"int\" [reportArgumentType] (Pyright)\n</diagnostics>"
}
```

`lint` carrega o resultado do syntax-check (parse in-process via `ast.parse`, `json.loads`, etc.); `lsp_diagnostics` carrega os diagnostics semânticos do language server real. Dois canais, sinais independentes — agente pode ver um arquivo syntax-clean com problemas semânticos como `lint: ok` + `lsp_diagnostics` populado.

### Linguagens suportadas (seleção)

| Linguagem | Server | Auto-install |
| --- | --- | --- |
| Python | `pyright-langserver` | npm |
| TypeScript/JS/JSX/TSX | `typescript-language-server` | npm |
| Vue / Svelte / Astro | `@vue/language-server` / `svelte-language-server` / `@astrojs/language-server` | npm |
| Go | `gopls` | `go install` |
| Rust | `rust-analyzer` | manual (rustup) |
| C/C++ | `clangd` | manual (LLVM) |
| Bash/Zsh | `bash-language-server` | npm |
| YAML | `yaml-language-server` | npm |
| PHP | `intelephense` | npm |
| Java | `jdtls` | manual |
| ~14 outras (Lua, OCaml, Dockerfile, Terraform, Dart, Haskell, Julia, Clojure, Nix, Zig, Gleam, Elixir, Prisma, Kotlin) | várias | manual em geral |

Para entradas "manual", instalar via toolchain manager apropriado (rustup, ghcup, opam, brew, etc.). Hermes auto-detecta o binário em PATH ou em `<HERMES_HOME>/lsp/bin/`. `typescript-language-server` requer o SDK `typescript` importável da mesma árvore `node_modules` — Hermes instala ambos juntos via `hermes lsp install typescript` ou auto-install no primeiro uso.

### CLI

```bash
hermes lsp status          # estado do serviço + status de instalação por server
hermes lsp list             # registry, opcionalmente --installed-only
hermes lsp install <id>     # instala eagerly um server
hermes lsp install-all       # tenta todo server com recipe conhecido
hermes lsp restart           # tear down de clients rodando
hermes lsp which <id>        # imprime path do binário resolvido
```

`hermes lsp status` é o melhor ponto de partida — mostra quais linguagens terão diagnostics semânticos hoje e quais precisam de binário instalado.

---

## 11. ACP Editor Integration

Hermes pode rodar como servidor ACP, permitindo que editores compatíveis com ACP (VS Code, Zed, JetBrains) conversem com Hermes via stdio e renderizem: chat messages, tool activity, file diffs, terminal commands, approval prompts, streamed thinking/response chunks.

ACP é adequado quando você quer Hermes comportando-se como coding agent nativo do editor em vez de CLI standalone ou bot de mensageria.

### O que Hermes expõe em modo ACP

Roda com toolset curado `hermes-acp` desenhado para workflows de editor:

- file tools: `read_file`, `write_file`, `patch`, `search_files`
- terminal tools: `terminal`, `process`
- web/browser tools
- memory, todo, session search
- skills
- `execute_code` e `delegate_task`
- vision

Exclui intencionalmente coisas que não cabem em UX de editor típico, como messaging delivery e cronjob management.

### Instalação

```bash
pip install -e '.[acp]'
```

Instala a dependência `agent-client-protocol` e habilita `hermes acp`, `hermes-acp`, `python -m acp_adapter`.

Para Zed registry installs, Zed lança Hermes via a entrada oficial do ACP Registry — usa distribuição `uvx` que roda `uvx --from 'hermes-agent[acp]==<version>' hermes-acp`. Garantir `uv` no PATH.

### Lançando o servidor ACP

Qualquer um destes inicia Hermes em modo ACP:

```bash
hermes acp
hermes-acp
python -m acp_adapter
```

Hermes loga para stderr — stdout fica reservado para tráfego ACP JSON-RPC.

```bash
hermes acp --version
hermes acp --check
```

### Browser tools (opcional)

Browser tools (`browser_navigate`, `browser_click`, etc.) dependem do pacote npm `agent-browser` + Chromium, não inclusos no wheel Python:

```bash
hermes acp --setup-browser           # interativo (prompt antes de ~400 MB download)
hermes acp --setup-browser --yes     # aceita download não-interativamente
```

Faz: instala Node.js 22 LTS em `~/.hermes/node/` se faltante; `npm install -g agent-browser @askjo/camofox-browser` nesse prefix (sem sudo); instala Playwright Chromium ou usa Chrome/Chromium do sistema se detectado. Bootstrap idempotente.

### Editor setup

**VS Code**: instalar extensão "ACP Client". Abrir painel ACP Client na Activity Bar, selecionar "Hermes Agent" da lista built-in, conectar. Configuração manual via `acp.agents`:

```json
{
  "acp.agents": {
    "Hermes Agent": {
      "command": "hermes",
      "args": ["acp"]
    }
  }
}
```

**Zed**: v0.221.x+ instala agentes externos via ACP Registry oficial. Abrir Agent Panel → "Add Agent" ou comando `zed: acp registry` → buscar "Hermes Agent" → instalar → novo thread de agente externo. Pré-requisitos: credenciais configuradas via `hermes model` (ou `~/.hermes/.env`/`config.yaml`); `uv` instalado. Para dev local antes do registry entry: agent server customizado em settings do Zed:

```json
{
  "agent_servers": {
    "hermes-agent": {
      "type": "custom",
      "command": "hermes",
      "args": ["acp"]
    }
  }
}
```

**JetBrains**: usar plugin compatível com ACP apontando para `/path/to/hermes-agent/acp_registry`.

### Registry manifest

Metadata oficial do ACP Registry do Hermes vive em `acp_registry/agent.json` no repo (detalhe truncado na fonte original).

---

## 12. Batch Processing

Permite rodar o agente Hermes através de centenas/milhares de prompts em paralelo, gerando trajectory data estruturada — usado primariamente para **geração de dados de treino**: trajetórias formato ShareGPT com estatísticas de uso de tools, para fine-tuning ou avaliação.

### Overview

O batch runner (`batch_runner.py`) processa um dataset JSONL de prompts, rodando cada um por uma sessão de agente completa com acesso a tools. Cada prompt tem ambiente isolado próprio. Output: trajectory data estruturada com histórico de conversa completo, estatísticas de tool calls, métricas de cobertura de reasoning.

### Quick Start

```bash
# Run básico
python batch_runner.py \
    --dataset_file=data/prompts.jsonl \
    --batch_size=10 \
    --run_name=my_first_run \
    --model=anthropic/claude-sonnet-4.6 \
    --num_workers=4

# Resume de run interrompido
python batch_runner.py \
    --dataset_file=data/prompts.jsonl \
    --batch_size=10 \
    --run_name=my_first_run \
    --resume

# Listar distributions disponíveis
python batch_runner.py --list_distributions
```

> **Custo previsível em escala**: batch runs sobem muitas sessões de agente concorrentes, cada fazendo model calls e tool calls. Uma subscription Nous Portal empacota acesso a modelos + web search, image gen, TTS, cloud browsers numa única conta — útil para custo-por-trajetória estável sem gerenciar rate limits entre 5 contas de vendor. Setup com `hermes setup --portal`, então apontar `--model` para um modelo Nous.

### Formato do Dataset

JSONL (um objeto JSON por linha), cada entry precisa de campo `prompt`:

```json
{"prompt": "Write a Python function that finds the longest palindromic substring"}
{"prompt": "Create a REST API endpoint for user authentication using Flask"}
{"prompt": "Debug this error: TypeError: cannot unpack non-iterable NoneType object"}
```

Campos opcionais por entry: `image`/`docker_image` (container image para o sandbox do prompt — funciona com Docker, Modal, Singularity backends), `cwd` (override de working directory para a sessão terminal da task).

### Configuration Options (principais)

| Parâmetro | Default | Descrição |
| --- | --- | --- |
| `--dataset_file` | (obrigatório) | Path para dataset JSONL |
| `--batch_size` | (obrigatório) | Prompts por batch |
| `--run_name` | (obrigatório) | Nome do run (output dir + checkpointing) |
| `--distribution` | `"default"` | Toolset distribution para sample |
| `--model` | `claude-sonnet-4.6` | Modelo a usar |
| `--base_url` | `https://openrouter.ai/api/v1` | API base URL |
| `--api_key` | (env var) | API key para o modelo |
| `--max_turns` | `10` | Máx iterações de tool-calling por prompt |
| `--num_workers` | `4` | Worker processes paralelos |
| `--resume` | `false` | Resume de checkpoint |
| `--verbose` | `false` | Logging verboso |
| `--max_samples` | todos | Processar só os primeiros N samples |
| `--max_tokens` | default do modelo | Máx tokens por resposta |

**Provider Routing (OpenRouter)** — flags batch-specific: `--providers_allowed`, `--providers_ignored`, `--providers_order`, `--provider_sort` (`"price"`/`"throughput"`/`"latency"`) — mesma semântica da seção 4.2, aplicada por run de batch.

**Reasoning Control**: `--reasoning_effort` (`none`, `minimal`, `low`, `medium`, `high`, `xhigh`), `--reasoning_disabled` (desliga completamente reasoning/thinking tokens).

**Advanced**: `--ephemeral_system_prompt` (usado na execução mas NÃO salvo nas trajectories), `--log_prefix_chars` (chars mostrados em log previews, default 100), `--prefill_messages_file` (path para JSON com prefill messages para few-shot priming).

### Toolset Distributions

Cada prompt recebe um conjunto de toolsets sampleado aleatoriamente de uma **distribution** — garante cobertura diversa de combinações de tools nos dados de treino. `--list_distributions` lista todas disponíveis.

Na implementação atual, distributions atribuem uma probabilidade a **cada toolset individual**. O sampler flipa cada toolset independentemente, depois garante que ao menos um toolset esteja habilitado — diferente de uma tabela hand-authored de combinações pré-montadas.

### Output Format

Todo output vai para `data/<run_name>/` (estrutura detalhada truncada na fonte original).

---

## Relacionado

- [[03-RESOURCES/entities/hermes]]
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-persistent-memory]] — Part 1 (Persistent Memory built-in, Skills, Personality, Context Files, Tools)
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-onboarding]]
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-integrations]]
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-security-model]]
