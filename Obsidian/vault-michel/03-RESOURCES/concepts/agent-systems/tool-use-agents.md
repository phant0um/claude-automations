---
title: "Tool-Use Agents"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, agent-systems]
status: developing
---

# Tool-Use Agents

LLMs equipados com acesso a ferramentas externas — funções, APIs, file systems — que ampliam radicalmente o que o modelo pode fazer além de gerar texto.

## O que é

Um tool-use agent é um LLM que, além de produzir texto, pode emitir **tool calls** estruturadas (JSON) que são executadas pelo ambiente e cujos resultados retornam ao modelo como contexto. O modelo decide quando chamar uma ferramenta, com quais argumentos, e como usar o resultado.

## Como funciona

**Ciclo:** `prompt → model → tool_call (JSON) → execução externa → resultado → model → resposta final`

**Formato de tool call (Anthropic API):**
```json
{
  "type": "tool_use",
  "name": "read_file",
  "input": { "path": "/vault/hot.md" }
}
```

**Roteamento:** o modelo escolhe entre as ferramentas disponíveis baseado na descrição de cada uma. Descrições claras e específicas reduzem erros de roteamento.

**Tratamento de erros:** tool calls podem falhar. Agentes robustos tratam erros retornados como contexto e ajustam a estratégia — não assumem sucesso.

**Autorização:** ambientes como Claude Code controlam quais ferramentas o modelo pode usar via listas de permissão (`settings.json`). Ferramentas destrutivas requerem confirmação explícita.

**MCP como padrão:** o Model Context Protocol padroniza o contrato de tool-use para que qualquer servidor MCP exponha ferramentas de forma interoperável entre modelos e ambientes.

## Por que importa

Toda a camada SO do vault-michel — ingestão, wikilinks, hot.md updates, git commits — é executada via tool-use agents. Entender o ciclo de tool call explica por que descrições de ferramentas MCP importam e como diagnosticar falhas de roteamento.

## Doc oficial — três rotas de execução (jun/2026)

A documentação da Anthropic (Messages API) detalha o ciclo descrito acima em três categorias distintas por **onde o código roda**: (1) user-defined tools (client-executed, a maioria do tráfego), (2) Anthropic-schema tools como `bash`/`text_editor`/`computer`/`memory` — preferíveis porque seus schemas são "trained-in" (Claude foi otimizado em milhares de trajetórias usando exatamente essas assinaturas, chamando-as com mais confiabilidade e recuperando-se de erros melhor do que com equivalentes custom), e (3) server-executed tools (`web_search`, `web_fetch`, `code_execution`, `tool_search`) onde a Anthropic roda o loop inteiro — a aplicação nunca constrói `tool_result` para essas. O loop client-side é um `while stop_reason == "tool_use"`; o loop server-side tem limite de iterações e retorna `stop_reason: "pause_turn"` quando incompleto. Ver [[03-RESOURCES/sources/how-tool-use-works]] e [[03-RESOURCES/sources/tool-use-with-claude]].

Na superfície de **Managed Agents**, o mesmo contrato se aplica: custom tools são "análogas às user-defined client tools da Messages API", mas o agente já vem com um toolset autônomo pré-construído. Execução de ferramentas server-executed e MCP é governada por **permission policies** (`always_allow`/`always_ask`) — ver [[03-RESOURCES/sources/tools]] e [[03-RESOURCES/sources/permission-policies]].

## Related
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]]
- [[03-RESOURCES/concepts/agent-systems/claude-code-skills]]
- [[03-RESOURCES/concepts/tool-selection-patterns]]
- [[03-RESOURCES/sources/how-tool-use-works]]
- [[03-RESOURCES/sources/tool-use-with-claude]]
- [[03-RESOURCES/sources/tools]]
- [[03-RESOURCES/sources/permission-policies]]

## Evidências
- **[2026-06-19]** SpatialClaw: código com kernel persistente como interface de ação supera tool-call estruturado em +11.2pp; >70% das vitórias rastreiam a composição que API fixa não provê — [[03-RESOURCES/sources/spatialclaw-rethinking-action-interface]]
- **[2026-06-21]** ToRL treina LLMs para usar computational tools via RL diretamente de base models (sem SFT prévio). ToRL-7B alcança 43.3% em AIME24 (+14% vs RL sem tools, +17% vs melhor TIR model). Cognitive behaviors emergem sem instruction: strategic t... — [[torl-scaling-tool-integrated-rl]]

- **[2026-06-24]** tags: — [[the-latent-bridge-a-continuous-slow-fast-channel-for-real-time-game-agents]]