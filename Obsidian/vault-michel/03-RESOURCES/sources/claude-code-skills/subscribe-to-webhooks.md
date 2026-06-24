---
title: "Subscribe to webhooks"
type: source
source: "Clippings/Subscribe to webhooks.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, claude-managed-agents, webhooks, event-driven, sessions, multi-agent, signature-verification]
---

## Tese central
Documentação oficial da Anthropic sobre o sistema de webhooks do Claude Managed Agents: como assinar endpoints para receber notificações de mudanças de estado de sessão sem polling, como verificar assinaturas criptográficas de entrega, os 8 tipos de evento suportados, e o comportamento de entrega (ordenação, retries, redirects, auto-disable).

## Argumentos principais

- **Por que webhooks existem ao lado da SSE event stream:** sessões são interações de longa duração; a maior parte das interações em tempo real acontece via [SSE event stream](https://platform.claude.com/docs/en/managed-agents/events-and-streaming), mas webhooks notificam sobre **mudanças maiores de estado** sem exigir polling contínuo.
- **Princípio de design "magro":** eventos de webhook retornam apenas `type` e `id` do evento — não o objeto completo. O receptor deve fazer uma chamada `GET` para buscar o objeto diretamente. Isso evita entregar dados obsoletos em retries e mantém cada entrega pequena.

### Tipos de evento suportados (8 total)
| Evento | Gatilho |
|---|---|
| `session.status_run_started` | Execução do agente iniciada — dispara em toda transição de status da sessão para `running` |
| `session.status_idled` | Agente esperando input (ex.: aprovação de permissão de ferramenta, nova mensagem do usuário) |
| `session.status_rescheduled` | Erro transiente ocorreu e a sessão está retentando automaticamente |
| `session.status_terminated` | Sessão atingiu erro terminal |
| `session.thread_created` | Nova [thread multiagente](https://platform.claude.com/docs/en/managed-agents/multi-agent) aberta — agente adicional chamado pelo coordenador está iniciando trabalho |
| `session.thread_idled` | Um agente em interação multiagente está esperando input |
| `session.thread_terminated` | Uma thread multiagente foi arquivada |
| `session.outcome_evaluation_ended` | [Avaliação de outcome](https://platform.claude.com/docs/en/managed-agents/define-outcomes) para uma única iteração foi concluída |

### Configuração de endpoint (Console: Manage > Webhooks)
Um webhook endpoint consiste em três componentes:
- **URL:** deve ser HTTPS na porta 443, com hostname publicamente resolvível
- **Event types:** lista de valores `data.type` que o endpoint recebe — um endpoint só recebe eventos aos quais está inscrito, **mais eventos de teste**
- **Signing secret:** segredo de 32 bytes prefixado `whsec_`, gerado na criação. **Mostrado apenas uma vez** — deve ser armazenado de forma segura para verificar entregas

### Verificação de assinatura
- Toda entrega carrega um header `X-Webhook-Signature`.
- O helper `unwrap()` do SDK verifica a assinatura e faz parse do evento em um único passo. **Lança exceção** se a assinatura é inválida OU se o payload tem mais de **5 minutos** de idade.
- Configurar `ANTHROPIC_WEBHOOK_SIGNING_KEY` com o segredo `whsec_` mostrado na criação do endpoint.
- Padrão de implementação: capturar exceção do `unwrap()` → retornar `400 invalid signature`; se válido, `switch` em `event.data.type` e retornar `2xx`.

### Estrutura do payload de evento
Toda entrega tem a mesma estrutura: `type: "event"`, `id` (identificador único do **evento**, não da entrega), `created_at` (timestamp), e `data` contendo `type`, `id`, `organization_id`, `workspace_id` do objeto afetado.

### Como tratar um evento
- Fazer parse do body, fazer switch em `data.type`, buscar o recurso pelo ID via API.
- Retornar qualquer `2xx` para confirmar recebimento — qualquer outra coisa (**incluindo `3xx`**) conta como falha e dispara retry.
- O `event.id` top-level é único **por evento, não por entrega** — receber o mesmo `event.id` duas vezes significa retry, e pode ser descartado com segurança.

### Comportamento de entrega (4 garantias/restrições documentadas)
1. **Ordenação não é garantida** — `session.status_idled` pode chegar antes de `session.outcome_evaluation_ended` mesmo que o outcome tenha sido produzido primeiro. Usar o timestamp `created_at` para ordenar quando a ordem importa.
2. **Retries:** Anthropic retenta **pelo menos uma vez**; o retry entrega o mesmo `event.id`.
3. **Redirects não são seguidos** — um `3xx` é tratado como falha. Se o endpoint mudar de URL, é preciso atualizar no Console.
4. **Auto-disable:** um endpoint é automaticamente definido como `disabled` (com `disabled_reason` legível por máquina) após aproximadamente **20 falhas consecutivas de entrega**, ou **imediatamente** se o hostname resolve para um IP privado ou o endpoint retorna um redirect. Reabilitação é manual, via Console, após resolver o problema.

## Key insights

- O design "fetch-on-notify" (webhook carrega só `type`+`id`, receptor busca o objeto via GET) é uma escolha de engenharia deliberada que resolve dois problemas simultaneamente: stale data em retries (o GET sempre traz o estado atual) e payload bloat (entregas continuam pequenas independentemente do tamanho do objeto). É um padrão reutilizável para qualquer sistema de notificação assíncrona que o vault possa vir a projetar.
- A distinção entre `event.id` (único por evento) e "delivery" (pode repetir o mesmo `event.id` em retry) é a chave para implementar idempotência correta — sem entender essa distinção, um handler ingênuo processaria o mesmo evento duas vezes.
- "Immediately disabled if hostname resolves to a private IP" é uma proteção de segurança implícita contra SSRF (Server-Side Request Forgery) — a Anthropic não permite que webhooks apontem para infraestrutura interna, mesmo que o usuário configure assim por engano.
- A garantia de não-ordenação combinada com o exemplo concreto (`status_idled` podendo chegar antes de `outcome_evaluation_ended` mesmo sendo produzido depois) é um alerta direto contra qualquer lógica de aplicação que assuma ordem de chegada — força o uso de `created_at` como única fonte de verdade temporal.
- Os 8 tipos de evento revelam a topologia de estados de uma sessão Managed Agent: `run_started → idled/rescheduled/terminated` no nível de sessão, espelhado por `thread_created/idled/terminated` no nível de subagentes multiagente, mais um evento de avaliação (`outcome_evaluation_ended`) que é ortogonal ao ciclo de vida — essa topologia é um mapa útil de onde "coisas importantes" acontecem num agente gerenciado de longa duração.

## Exemplos e evidências

- Exemplo de payload de evento JSON completo: `{ "type": "event", "id": "event_01ABC...", "created_at": "2026-03-18T14:05:22Z", "data": { "type": "session.status_idled", "id": "sesn_01XYZ...", "organization_id": "...", "workspace_id": "..." } }`.
- Exemplo de servidor Flask completo usando `client.beta.webhooks.unwrap()`, capturando exceção para retornar 400 em assinatura inválida, e despachando em `event.data.type`.
- Exemplo de handler que busca a sessão via `client.beta.sessions.retrieve(event.data.id)` e retorna `204`.
- Limite numérico exato: **~20 falhas consecutivas** para auto-disable; **5 minutos** de tolerância de idade do payload no `unwrap()`; secret de **32 bytes** prefixado `whsec_`.

## Implicações para o vault

- Esta fonte mapeia o **lado "session-state-change"** dos eventos de Managed Agents — complementar (não sobreposto) ao [[03-RESOURCES/sources/reference]], que documenta os event types do tipo `user.*` (eventos iniciados pelo usuário/integração). Juntas, formam o vocabulário completo de eventos: `user.*` (entrada) + `session.*`/webhook (saída/notificação).
- O padrão "fetch-on-notify + idempotência por event.id + proteção SSRF automática" é uma referência de design que vale considerar caso o vault (ou um agente do ecossistema Nexus) precise implementar qualquer mecanismo de notificação push/callback no futuro.
- Conecta-se perifericamente a [[03-RESOURCES/concepts/agent-systems/agent-observability]] — webhooks são um mecanismo de observabilidade orientado a eventos (estado muda → notificação), embora a doc deixe claro que servem para *major state changes*, não para tracing granular (esse é o papel da SSE event stream).
- Sem contradições com fontes existentes — preenche uma lacuna específica (event-driven notification layer) que ainda não estava documentada em profundidade no vault.

## Links
- [[03-RESOURCES/sources/reference]]
- [[03-RESOURCES/concepts/agent-systems/agent-observability]]
- [[03-RESOURCES/sources/managed-agents-have-a-portability-problem-i-ran-one-agent-folder-on-anthropic-google-and-open-ai]]
