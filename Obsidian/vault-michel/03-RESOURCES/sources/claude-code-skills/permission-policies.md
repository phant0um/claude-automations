---
title: "Permission Policies (Claude Managed Agents)"
type: source
source: "Clippings/Permission policies.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, tool-use, managed-agents, agent-security]
---

## Tese central

Documentação oficial da Anthropic (`managed-agents/permission-policies`, beta header `managed-agents-2026-04-01`) que cobre **controle de execução de ferramentas dentro de uma sessão de Managed Agent**: quando uma ferramenta roda automaticamente vs. quando espera aprovação humana. É o complemento de governança de [[03-RESOURCES/sources/tools]] — aquela página configura *quais* ferramentas existem; esta configura *se elas executam sem confirmação*. Cobre exclusivamente a superfície de **Managed Agents** (não Messages API).

## Argumentos principais

**Escopo das permission policies — o que elas governam e o que não:**
- Permission policies controlam se ferramentas **server-executed** (o agent toolset pré-construído + MCP toolset) rodam automaticamente ou esperam aprovação.
- **Custom tools são executadas pela aplicação e controladas por você** — portanto **não são governadas por permission policies**. Essa é uma distinção estrutural central: a política só se aplica onde a Anthropic/servidor está no controle da execução; onde a aplicação já está no controle, não há necessidade de uma camada adicional.

**As duas políticas (tabela completa):**

| Policy | Comportamento |
|---|---|
| `always_allow` | A ferramenta executa automaticamente, sem confirmação |
| `always_ask` | A sessão pausa e espera sua aprovação antes de executar |

**Configuração de política por toolset:**

*Agent toolset:* ao criar um agente, você pode opcionalmente aplicar uma política a **todas** as ferramentas do `agent_toolset_20260401` via `default_config.permission_policy`:
```yaml
ant beta:agents create <<'YAML'
name: Coding Assistant
model: claude-opus-4-8
tools:
  - type: agent_toolset_20260401
    default_config:
      permission_policy:
        type: always_ask
YAML
```
Se você omitir `default_config`, o agent toolset é habilitado com a política padrão **`always_allow`**.

*MCP toolset:* **toolsets MCP usam `always_ask` por padrão** — isso garante que novas ferramentas adicionadas a um servidor MCP não executem na sua aplicação sem aprovação. Para auto-aprovar ferramentas de um servidor MCP confiável, você seta `default_config.permission_policy` no entry `mcp_toolset`. O `mcp_server_name` precisa bater com o `name` referenciado no array `mcp_servers`:
```yaml
ant beta:agents create <<'YAML'
name: Dev Assistant
model: claude-opus-4-8
mcp_servers:
  - type: url
    name: github
    url: https://mcp.example.com/github
tools:
  - type: agent_toolset_20260401
  - type: mcp_toolset
    mcp_server_name: github
    default_config:
      permission_policy:
        type: always_allow
YAML
```

**Override individual de política por ferramenta** — usando o array `configs` para sobrescrever o default em ferramentas específicas. Exemplo: permite o toolset inteiro por padrão, mas exige confirmação só para `bash`:
```yaml
- type: agent_toolset_20260401
  default_config:
    permission_policy:
      type: always_allow
  configs:
    - name: bash
      permission_policy:
        type: always_ask
```

**O fluxo completo de confirmação (quando uma ferramenta com `always_ask` é invocada) — quatro passos:**
1. A sessão emite um evento `agent.tool_use` ou `agent.mcp_tool_use`.
2. A sessão pausa com um evento `session.status_idle` contendo `stop_reason: requires_action`. Os IDs dos eventos bloqueantes ficam em `stop_reason.event_ids`.
3. Você envia um evento `user.tool_confirmation` para cada um, passando o ID do evento no parâmetro `tool_use_id`. Seta `result` para `"allow"` ou `"deny"`. Use `deny_message` para explicar uma negação.
4. Uma vez todos os eventos bloqueantes resolvidos, a sessão volta para `running`.

```bash
# Allow the tool to execute
ant beta:sessions:events send \
  --session-id "$SESSION_ID" \
  --event "{type: user.tool_confirmation, tool_use_id: $AGENT_TOOL_USE_EVENT_ID, result: allow}"

# Or deny it with an explanation
ant beta:sessions:events send \
  --session-id "$SESSION_ID" \
  --event "{type: user.tool_confirmation, tool_use_id: $MCP_TOOL_USE_EVENT_ID, result: deny,
    deny_message: Don't create issues in the production project. Use the staging project.}"
```

**Custom tools — fluxo separado e sem política:**
- Permission policies não se aplicam a custom tools.
- Quando o agente invoca uma custom tool, a aplicação recebe um evento `agent.custom_tool_use` e é **responsável por decidir se executa** antes de enviar de volta um `user.custom_tool_result`.

## Key insights

- **A assimetria de defaults entre agent toolset (`always_allow`) e MCP toolset (`always_ask`) é uma decisão de design deliberada de segurança**: ferramentas que a Anthropic controla e versiona (bash, read, write etc.) recebem confiança por padrão; ferramentas de servidores MCP de terceiros — que podem mudar/adicionar capacidades sem aviso — exigem aprovação explícita até que você declare confiança. É um modelo de "trust but verify externally-sourced capability."
- **A negação com `deny_message` é um canal de feedback estruturado**, não apenas um "não" — permite injetar contexto corretivo de volta na sessão (ex.: "Don't create issues in the production project. Use the staging project."), o que potencialmente redireciona o comportamento do agente sem encerrar a sessão.
- **A separação "quem controla a execução determina quem precisa de política"** é o princípio organizador de toda a página: server-executed (Anthropic/MCP) → permission policy; client/custom-executed (sua aplicação) → seu próprio fluxo de decisão (`agent.custom_tool_use` → `user.custom_tool_result`). Essa é exatamente a mesma linha divisória traçada em [[03-RESOURCES/sources/how-tool-use-works]] entre as três categorias de execução de ferramentas — confirma que a arquitetura de Managed Agents herda a taxonomia da Messages API e constrói governança em cima dela.
- **O modelo de pausa/retomada (`requires_action` → `user.tool_confirmation` → `running`) é estruturalmente idêntico ao padrão `pause_turn` documentado em** [[03-RESOURCES/sources/how-tool-use-works]] **para o loop server-side da Messages API** — ambos são "a sessão para, espera um sinal externo, e continua de onde parou." É um padrão recorrente de design em toda a stack de agentes da Anthropic.

## Exemplos e evidências

- Beta header obrigatório (compartilhado com [[03-RESOURCES/sources/tools]]): `managed-agents-2026-04-01`.
- Tipos de evento documentados: `agent.tool_use`, `agent.mcp_tool_use`, `agent.custom_tool_use`, `session.status_idle`, `user.tool_confirmation`, `user.custom_tool_result`.
- Stop reason de bloqueio: `requires_action`, com `stop_reason.event_ids` listando IDs bloqueantes.
- Comando CLI completo para enviar confirmação/negação (`ant beta:sessions:events send`).
- Exemplo concreto de `deny_message` mostrando uso real: redirecionar de produção para staging.

## Implicações para o vault

- Forma um **par funcional direto** com [[03-RESOURCES/sources/tools]]: aquela define o catálogo e habilitação de ferramentas; esta define a camada de aprovação sobre esse catálogo. Juntas descrevem o ciclo de vida completo de uma ferramenta numa sessão de Managed Agent — da configuração à execução governada.
- É a evidência oficial mais direta para [[03-RESOURCES/concepts/agent-systems/agent-trust-layer]] e [[03-RESOURCES/concepts/agent-systems/agent-governance-layers]] de como a Anthropic implementa human-in-the-loop em produção: políticas declarativas (`always_allow`/`always_ask`) + eventos de confirmação assíncronos, com canal de feedback (`deny_message`).
- A distinção "quem controla execução → quem precisa de política" amarra de volta com precisão à taxonomia de três categorias de [[03-RESOURCES/sources/how-tool-use-works]] — confirma que entender aquela taxonomia é pré-requisito para entender por que esta política existe do jeito que existe (não é arbitrário; segue a fronteira de responsabilidade de execução).
- Conecta-se a [[03-RESOURCES/concepts/agent-systems/agent-security-stack]] como exemplo concreto de "permission gate" em produção — útil para comparar com o modelo de allowlist em `settings.json` do Claude Code, que [[03-RESOURCES/concepts/tool-use-agents]] já menciona como análogo informal.

## Links
- [[03-RESOURCES/sources/tools]]
- [[03-RESOURCES/sources/how-tool-use-works]]
- [[03-RESOURCES/sources/tool-use-with-claude]]
- [[03-RESOURCES/concepts/tool-use-agents]]
- [[03-RESOURCES/concepts/agent-systems/agent-trust-layer]]
- [[03-RESOURCES/concepts/agent-systems/agent-security-stack]]
- [[03-RESOURCES/concepts/agent-systems/agent-governance-layers]]
