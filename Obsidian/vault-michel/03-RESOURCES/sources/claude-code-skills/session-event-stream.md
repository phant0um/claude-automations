---
title: Session event stream
type: source
source: "Clippings/Session event stream.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, managed-agents, event-streaming, anthropic-api]
---

## Tese central

Documenta o modelo de comunicação **baseado em eventos** com Claude Managed Agents — como enviar eventos de usuário, fazer streaming de respostas, interromper/redirecionar mid-execução, lidar com confirmações de tools e custom tool calls, retomar sessions inativas e rastrear consumo de tokens. É o detalhamento mais profundo do conceito **Events** introduzido em [[03-RESOURCES/sources/claude-managed-agents-overview]] e o mecanismo central pelo qual todas as outras camadas (outcomes, multiagent) se comunicam.

## Argumentos principais

- **Modelo de comunicação**: "communication with Claude Managed Agents is event-based" — você envia *user events* ao agente e recebe *agent* e *session events* de volta para rastrear status.
- **Duas direções de fluxo de eventos**:
  - **User events**: o que você envia ao agente para iniciar uma session e direcioná-la conforme progride
  - **Session events, span events e agent events**: enviados a você para observabilidade do estado da session e progresso do agente
- **Convenção de nomenclatura**: strings de tipo de evento seguem `{domain}.{action}` (ex.: `user.message`, `agent.tool_use`, `session.status_idle`).
- **`processed_at`**: todo evento inclui um timestamp `processed_at` indicando quando foi registrado server-side. **Se `processed_at` é null, significa que o evento foi enfileirado pelo harness e será processado após eventos anteriores terminarem** — um sinal explícito de fila/ordem de processamento.
- **Integração básica**: enviar `user.message` para iniciar/continuar o trabalho do agente — exemplo com `content: [{type: text, text: "Analyze the performance of..."}]`.
- **Interromper e redirecionar**: enviar `user.interrupt` para parar o agente mid-execução, seguido de um novo `user.message` para redirecioná-lo. **O agente reconhece a interrupção e muda para a nova tarefa.**
- **Lidando com custom tool calls** — fluxo de 4 passos:
  1. A session emite um evento `agent.custom_tool_use` contendo nome da tool e input
  2. A session pausa com `session.status_idle` contendo `stop_reason: requires_action` — IDs de eventos bloqueantes em `stop_reason.event_ids`
  3. Execute a tool no seu sistema e envie um `user.custom_tool_result` para cada uma, passando o ID do evento em `custom_tool_use_id` junto com o conteúdo do resultado
  4. Uma vez que todos os eventos bloqueantes são resolvidos, a session transiciona de volta para `running`
  - Nota explícita: "this workflow does not translate well to a one-off shell command — use one of the SDK examples"
- **Confirmação de tools** — fluxo análogo de 4 passos quando uma permission policy exige confirmação:
  1. A session emite `agent.tool_use` ou `agent.mcp_tool_use`
  2. A session pausa com `session.status_idle` / `stop_reason: requires_action` (IDs em `stop_reason.event_ids`)
  3. Envie `user.tool_confirmation` para cada um, passando o ID em `tool_use_id`, com `result` igual a `"allow"` ou `"deny"` (use `deny_message` para explicar uma negação)
  4. Eventos bloqueantes resolvidos → session volta para `running`
- **Resumindo uma session inativa**:
  - Sessions persistem entre interações; histórico de conversa é preservado a menos que a session seja explicitamente deletada
  - Quando uma session fica `idle`, seu sandbox é **checkpointed** — preservando estado completo (filesystem, pacotes instalados, arquivos criados pelo agente) — permitindo retomada limpa de inatividade
  - **Limite crítico**: enquanto o histórico da session persiste até deleção, **checkpoints só são preservados por 30 dias após a última atividade**. Se o workflow exige que o estado completo do sandbox persista além de 30 dias, é preciso enviar `user.message` periódicos para resetar o timer de inatividade antes do checkpoint expirar
  - Para retomar: simplesmente envie um `user.message` como de costume
- **Rastreando uso (`usage`)**:
  - O objeto session inclui um campo `usage` com estatísticas cumulativas de tokens
  - Busque a session após ela ficar `idle` para ler os totais mais recentes; use para rastrear custos, aplicar orçamentos ou monitorar consumo
  - `input_tokens` reporta tokens de input **não-cacheados**; `output_tokens` reporta total de tokens de output através de todas as chamadas de modelo na session
  - `cache_creation_input_tokens` e `cache_read_input_tokens` refletem atividade de prompt caching
  - **Cache entries usam TTL de 5 minutos** — turnos consecutivos dentro dessa janela se beneficiam de cache reads, que reduzem custo por token
- **Observabilidade no Console**: visão de timeline visual das sessions — lista de sessions (status, hora de criação, modelo), tracing view (visão cronológica de eventos com conteúdo/timestamps/uso de tokens — **acessível apenas a Developers e Admins**), e detalhes de execução de tools
- **Dicas de debugging**:
  - Verifique eventos da session — erros são transmitidos via evento `session.error`
  - Revise resultados de tools — falhas de execução de tools frequentemente explicam comportamento inesperado do agente
  - Rastreie uso de tokens — monitore consumo para otimizar prompts e reduzir custos
  - Use system prompts — adicione instruções de logging ao system prompt para fazer o agente explicar seu raciocínio

## Key insights

- O sinal **`processed_at: null` = "enfileirado, ainda não processado"** é uma forma elegante e barata de expor estado de fila sem precisar de um campo de status dedicado — um detalhe de design que builders precisam conhecer para não interpretar mal eventos "incompletos" no stream.
- O fluxo idêntico de 4 passos para **custom tool calls** e **tool confirmation** (ambos usam `requires_action` + `stop_reason.event_ids` + resposta correlacionada por ID) revela um **padrão arquitetural unificado de "human/system-in-the-loop"**: qualquer ponto onde o agente precisa de uma resposta externa usa exatamente o mesmo mecanismo de pausa-e-correlação. Isso reduz a superfície de aprendizado para builders — uma vez entendido um fluxo, o outro é trivial.
- O **limite de 30 dias para checkpoints** (vs. histórico de eventos que persiste indefinidamente até deleção) revela uma **assimetria de custo de armazenamento**: manter logs de conversa é barato, manter sandboxes completos (filesystem + pacotes) é caro o suficiente para justificar expiração automática. Builders com workflows de longa duração precisam ativamente "manter o sandbox vivo" enviando heartbeats — um detalhe operacional facilmente esquecido que pode causar perda silenciosa de estado.
- O **TTL de cache de 5 minutos** é uma restrição de design que recompensa padrões de uso "em rajada" (turnos consecutivos próximos no tempo) e penaliza sessions com gaps longos entre interações — algo a considerar ao desenhar a cadência de `user.message` em pipelines automatizados.
- A nota repetida **"this workflow does not translate well to a one-off shell command — use SDK examples"** (aparecendo tanto para custom tools quanto tool confirmation) é um sinal explícito de que a CLI `ant` documentada no restante do lote é apenas para operações simples — fluxos de produção real exigem o SDK completo (Python/TS), com gerenciamento de estado que um one-liner shell não consegue expressar.
- A restrição de **tracing view a Developers/Admins** introduz uma dimensão de controle de acesso/governança ao observability que não aparece em nenhuma outra parte do lote — relevante para times que precisam delegar debugging a roles menos privilegiados.

## Exemplos e evidências

- Exemplo de `user.message`: `content: [{type: text, text: "Analyze the performance of the sort function in utils.py"}]`
- Exemplo completo de interrupt + redirect:
  ```yaml
  events:
    - type: user.interrupt
    - type: user.message
      content:
        - type: text
          text: Instead, focus on fixing the bug in line 42.
  ```
- JSON de exemplo de `session.thread_status_idle` com `stop_reason: {type: requires_action, event_ids: [...]}`(reutilizado/análogo ao de multiagent)
- Código Python de retomada de session: `client.beta.sessions.events.send("sesn_01...", events=[{"type": "user.message", "content": [...]}])`
- JSON de objeto session com `usage`: `{"id": "sesn_01...", "status": "idle", "usage": {"input_tokens": 5000, "output_tokens": 3200, "cache_creation_input_tokens": 2000, "cache_read_input_tokens": 20000}}`

## Implicações para o vault

Esta página é o coração técnico do conceito **Events** mapeado em [[03-RESOURCES/sources/claude-managed-agents-overview]] e referenciado por praticamente todas as outras fontes do lote:

- [[03-RESOURCES/sources/start-a-session]] reusa exatamente o mesmo padrão de `user.message` para iniciar trabalho — esta página assume o relay descrevendo como continuar a conversa
- [[03-RESOURCES/sources/define-outcomes]] estende este modelo com a família `span.outcome_evaluation_*` e reaproveita `user.interrupt` com semântica adicional (resultado `interrupted`)
- [[03-RESOURCES/sources/multiagent-sessions]] estende o modelo de "tool confirmation" e "custom tool calls" descrito aqui para um cenário de múltiplos threads — o mesmo fluxo `requires_action`/`event_ids`/resposta correlacionada é "cross-posted" para o thread primário com `session_thread_id` adicional
- [[03-RESOURCES/sources/session-operations]] depende deste mecanismo: a restrição "session precisa estar `idle` para update/archive/delete" só é satisfazível enviando um `user.interrupt` documentado aqui

O **padrão unificado de "pausa + correlação por ID + resposta"** (custom tool result / tool confirmation / multiagent cross-posting) é candidato natural a um concept dedicado — algo como "human-in-the-loop event correlation pattern" — que ainda não existe explicitamente no vault, embora [[03-RESOURCES/concepts/agent-systems/agent-observability]] e o (sugerido) `managed-agents-harness` cubram partes adjacentes.

O sistema de `usage`/cache (TTL de 5 minutos, `cache_creation_input_tokens`/`cache_read_input_tokens`) conecta-se a temas de eficiência de contexto e custo já presentes no vault em torno de prompt caching — vale revisar concepts de `context-budget-constraint` e `context-management` para conexões adicionais.

## Links

- [[03-RESOURCES/sources/claude-managed-agents-overview]]
- [[03-RESOURCES/sources/start-a-session]]
- [[03-RESOURCES/sources/define-outcomes]]
- [[03-RESOURCES/sources/session-operations]]
- [[03-RESOURCES/sources/multiagent-sessions]]
- [[03-RESOURCES/concepts/agent-systems/agent-observability]]
- [[03-RESOURCES/concepts/agent-systems/harness-adaptation]]
