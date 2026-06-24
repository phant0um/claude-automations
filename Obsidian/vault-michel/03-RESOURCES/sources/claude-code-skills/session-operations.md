---
title: Session operations
type: source
source: "Clippings/Session operations.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, managed-agents, session-lifecycle, anthropic-api]
---

## Tese central

Documenta as operações de gestão de uma **Session** já existente — retrieve, list, update (configuração mid-session), archive e delete — além da máquina de estados de status pelos quais toda session passa. É o complemento operacional de [[03-RESOURCES/sources/start-a-session]] (que cobre criação e início) e funciona como referência para o que acontece "depois" de uma session estar rodando.

## Argumentos principais

- Escopo da página: "once a session exists, use these operations to read, update, archive, or delete it" — operações pós-criação; criação e envio de trabalho ficam em [[03-RESOURCES/sources/start-a-session]].
- Todas as requisições requerem o header beta `managed-agents-2026-04-01`.
- **Status de session — máquina de estados completa** (tabela):
  | Status | Descrição |
  | --- | --- |
  | `idle` | Agente aguardando input — incluindo mensagens de usuário ou confirmações de tool. **Sessions começam em `idle`** |
  | `running` | Agente executando ativamente |
  | `rescheduling` | Erro transiente ocorreu, retentando automaticamente |
  | `terminated` | Session terminou por erro irrecuperável |
- **Atualizar configuração do agent mid-session**: é possível atualizar `agent.tools` e `agent.mcp_servers` de uma session — incluindo permission policies — **sem criar uma nova versão do agent**. Updates são **session-local** e **não propagam de volta** para o agent subjacente.
- **Semântica de update é substituição total**: o array fornecido é o novo valor inteiro. Para preservar entradas existentes, é preciso fazer `GET` da session, modificar o array, e `POST` de volta — o mesmo padrão de "full replacement" já visto em [[03-RESOURCES/sources/define-your-agent]] para campos array do agent.
- **Restrição de status para update**: a session precisa estar `idle` para atualizar o agent. Se estiver `running`, é preciso interromper a session primeiro (`user.interrupt`).
- **Retrieve**: `ant beta:sessions retrieve --session-id "$SESSION_ID"` — busca uma session específica
- **List**: `ant beta:sessions list --agent-id "$AGENT_ID"` — lista sessions associadas a um agent
- **Archive**: previne envio de novos eventos enquanto preserva o histórico. **Uma session `running` não pode ser arquivada** — é preciso enviar um evento de interrupt primeiro se precisar arquivar imediatamente.
- **Delete**: remove permanentemente o registro da session, seus eventos e o sandbox associado. **Uma session `running` não pode ser deletada** — mesma exigência de interrupt prévio.
- **Independência de recursos na deleção**: "Files, memory stores, vaults, skills, environments, and agents are independent resources and are not affected by session deletion" — deletar uma session não tem efeito cascata sobre nenhum desses outros recursos.

## Key insights

- A regra **"updates de tools/MCP servers são session-local e não propagam para o agent"** é uma decisão de design crucial para segurança operacional: você pode experimentar configurações ad-hoc numa session específica sem risco de "vazar" essas mudanças para todas as outras sessions que usam o mesmo agent. É o oposto do comportamento de versionamento de agent visto em [[03-RESOURCES/sources/define-your-agent]] — uma dualidade clara entre "mudança permanente versionada" (agent update) e "mudança efêmera local" (session update).
- A **restrição "session precisa estar `idle` para atualizar o agent"** + "running não pode ser archived/deleted" forma um padrão consistente: **toda operação de gestão estrutural exige primeiro estabilizar o estado via interrupt**. Isso simplifica o modelo mental do builder — "se a operação falhar por causa de status, mande um interrupt e tente de novo" — mas impõe uma dependência de orquestração não-trivial em pipelines automatizados.
- A **independência total de recursos na deleção de sessions** ("files, memory stores, vaults, skills, environments e agents não são afetados") é uma decisão de design que evita "deleções em cascata" surpreendentes — segue o princípio de menor superfície de efeitos colaterais, mas exige que o builder gerencie limpeza desses recursos separadamente se quiser remoção completa de dados (relevante para o tema ZDR/HIPAA levantado em [[03-RESOURCES/sources/claude-managed-agents-overview]]).
- A máquina de estados com apenas **4 estados** (`idle`, `running`, `rescheduling`, `terminated`) é deliberadamente simples — `rescheduling` é o único estado que sinaliza recuperação automática de erro transiente, enquanto `terminated` é terminal e irrecuperável. Essa simplicidade contrasta com a riqueza de sub-estados implícitos vista em [[03-RESOURCES/sources/session-event-stream]] (`stop_reason: requires_action`, etc.) — sugerindo que o status de alto nível é deliberadamente "grosso" e a granularidade fina vive nos eventos.

## Exemplos e evidências

- Tabela de 4 status de session com descrições completas
- Comando de update da config do agent mid-session (YAML completo):
  ```yaml
  agent:
    tools:
      - type: agent_toolset_20260401
      - type: mcp_toolset
        mcp_server_name: linear
    mcp_servers:
      - type: url
        name: linear
        url: https://mcp.linear.app/sse
  ```
  via `ant beta:sessions update --session-id "$SESSION_ID"`
- Comando retrieve: `ant beta:sessions retrieve --session-id "$SESSION_ID"`
- Comando list: `ant beta:sessions list --agent-id "$AGENT_ID"`
- Comando archive: `ant beta:sessions archive --session-id "$SESSION_ID"`
- Comando delete: `ant beta:sessions delete --session-id "$SESSION_ID"`

## Implicações para o vault

Esta página completa o ciclo de vida de Session iniciado em [[03-RESOURCES/sources/start-a-session]] — juntas, as duas cobrem o conceito **Session** por inteiro:

- Referencia diretamente [[03-RESOURCES/sources/session-event-stream]] para o mecanismo de interrupt (`user.interrupt`) que destrava as restrições de status (`running` não pode ser archived/deleted/updated)
- A restrição "agent update requer session `idle`" cria uma dependência operacional explícita com o ciclo de eventos — para gerenciar uma session em produção, é preciso orquestrar status + eventos em conjunto, não tratá-los como sistemas independentes
- Reaproveita o mesmo padrão de "full replacement em campos array" visto em [[03-RESOURCES/sources/define-your-agent]], agora aplicado a um escopo session-local em vez de agent-global — útil para entender a simetria/assimetria entre os dois níveis de configuração
- O status `idle` aparece como estado de chegada recorrente em [[03-RESOURCES/sources/define-outcomes]] (toda avaliação de outcome termina levando a session de volta a `idle`) — esta página fornece a definição canônica desse estado: "agent is waiting for input, including user messages or tool confirmations"
- A independência de recursos na deleção conecta-se ao tema de retenção de dados levantado em [[03-RESOURCES/sources/claude-managed-agents-overview]] (Managed Agents não elegível para ZDR/HIPAA) — esta página esclarece que deletar uma session não limpa arquivos/vaults/skills associados, exigindo limpeza explícita separada

Relevante para [[03-RESOURCES/concepts/agent-systems/agent-observability]]: a tabela de status + os eventos `session.error`/`session.thread_status_*` (vistos em outras páginas do lote) formam juntos o vocabulário mínimo de observabilidade operacional do produto.

## Links

- [[03-RESOURCES/sources/start-a-session]]
- [[03-RESOURCES/sources/session-event-stream]]
- [[03-RESOURCES/sources/define-your-agent]]
- [[03-RESOURCES/sources/define-outcomes]]
- [[03-RESOURCES/sources/claude-managed-agents-overview]]
- [[03-RESOURCES/concepts/agent-systems/agent-observability]]
