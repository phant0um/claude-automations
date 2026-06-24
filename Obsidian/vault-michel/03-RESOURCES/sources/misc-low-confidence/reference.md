---
title: "Reference — Claude Managed Agents API Reference (event types, worker CLI, MCP, rate limits, branding)"
type: source
source: "Clippings/Reference.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, claude-managed-agents, api-reference, webhooks, mcp, rate-limits, self-hosted-sandboxes, branding]
---

## Tese central
Página de referência consolidada da Anthropic para **Claude Managed Agents** (não confundir com a documentação geral de "Reference" da Messages API — esta é especificamente a página `/docs/en/managed-agents/reference`). Reúne quatro blocos de material de referência factual: tipos de evento da stream de sessão, flags da CLI do self-hosted worker, tipos de servidor MCP suportados, limites de taxa por organização, e diretrizes de branding para parceiros que integram Managed Agents em seus produtos.

## Argumentos principais

- **Beta header obrigatório:** todas as requisições à API de Managed Agents exigem o header `managed-agents-2026-04-01`. O SDK define esse header automaticamente.

### Event types (convenção `{domain}.{action}`)
| Tipo | Descrição |
|---|---|
| `user.message` | Mensagem do usuário com conteúdo de texto |
| `user.interrupt` | Para o agente no meio da execução |
| `user.custom_tool_result` | Resposta a uma chamada de custom tool feita pelo agente |
| `user.tool_confirmation` | Aprova ou nega chamada de ferramenta do agente/MCP quando uma policy de permissão exige confirmação |
| `user.define_outcome` | Define um [outcome](https://platform.claude.com/docs/en/managed-agents/define-outcomes) para o agente buscar |
| `user.tool_result` | Apenas para sessões com ambientes `self_hosted` — a integração é responsável por fornecer resultados de `agent_toolset` (helpers do SDK e CLI fazem isso automaticamente) |

### Self-hosted worker — flags da CLI `ant beta:worker`
| Flag | Descrição |
|---|---|
| `--environment-id` | Ambiente a ser monitorado para trabalho; também lê de `ANTHROPIC_ENVIRONMENT_ID` |
| `--environment-key` | Autentica o worker com o ambiente; também lê de `ANTHROPIC_ENVIRONMENT_KEY` |
| `--workdir` | Diretório onde skills são baixadas e ferramentas leem/escrevem arquivos. Default `.` (diretório atual); o default do sistema é `/workspace` |
| `--on-work` | Script chamado para cada item de trabalho reivindicado, em vez de rodar ferramentas in-process; recebe detalhes da sessão como variáveis de ambiente |
| `--unrestricted-paths` | Permite que chamadas de ferramenta acessem caminhos fora de `--workdir` |
| `--max-idle` | Quanto tempo esperar após a sessão ficar idle com stop reason `end_turn` antes de desligar. **Default: `60s`** |
| `--log-format` | Formato de saída de log; `json` para ingestão estruturada, default `text` |

- O pré-built worker é o que conduz um ambiente `self_hosted` — a página remete a "Self-hosted sandboxes" para configuração completa, execução do worker e opções de SDK helper.

### MCP server types suportados
- Claude Managed Agents conecta a **remote MCP servers** que expõem endpoint HTTP, ou a **private MCP servers via MCP tunnels**.
- **Requisito de protocolo:** o servidor deve suportar o transporte **streamable HTTP** do protocolo MCP.
- Remete ao "MCP connector" para declarar servidores em um agente, e à documentação oficial do Model Context Protocol (modelcontextprotocol.io) para mais informações sobre construção de servidores MCP.

### Rate limits (por organização)
| Operação | Limite |
|---|---|
| Create endpoints (agents, sessions, environments) | **300 requisições/minuto** |
| Read endpoints (retrieve, list, stream) | **600 requisições/minuto** |
- Limites de gasto e rate limits baseados em tier organizacional **também se aplicam** por cima destes.

### Branding guidelines para parceiros
- Uso da marca Claude é **opcional** para parceiros integrando Managed Agents.
- **Permitido:** "Claude Agent" (preferido para menus dropdown); "Claude" (dentro de um menu já rotulado "Agents"); "{YourAgentName} Powered by Claude" (se o parceiro já tem nome de agente próprio).
- **Não permitido:** "Claude Code" ou "Claude Code Agent"; "Claude Cowork" ou "Claude Cowork Agent"; arte ASCII de marca Claude Code ou elementos visuais que imitem Claude Code.
- Regra geral: o produto do parceiro deve manter sua própria marca e **não parecer ser** Claude Code, Claude Cowork, ou qualquer outro produto Anthropic. Dúvidas de conformidade de branding devem ir ao time de vendas da Anthropic.

## Key insights

- Esta é uma página **puramente de referência factual** (tabelas, flags, limites) — sem narrativa de "como usar"; o valor está em ser o ponto único de consulta para constantes operacionais (rate limits, defaults de CLI, convenção de nomenclatura de eventos) que de outra forma estariam espalhadas em múltiplas páginas guiadas-por-tarefa.
- A separação de rate limits entre **create** (300/min) e **read** (600/min) — o dobro para leitura — sinaliza um design consciente para suportar polling/streaming intensivo (list, retrieve, stream) sem penalizar a criação de recursos, que é naturalmente mais cara no backend.
- O default `--max-idle: 60s` é um detalhe operacional crítico para quem opera workers self-hosted: depois de 60 segundos idle com `end_turn`, o worker desliga — isso molda decisões de custo/disponibilidade de infraestrutura self-hosted.
- A lista de "Not permitted" em branding revela que a Anthropic está protegendo ativamente a identidade visual/textual de **Claude Code** e **Claude Cowork** especificamente — sugere que esses dois produtos têm valor de marca suficiente para gerar confusão de mercado se replicados por terceiros via Managed Agents.
- O requisito de suporte a **streamable HTTP** para servidores MCP é uma restrição de protocolo que filtra quais implementações de MCP server são compatíveis com Managed Agents — relevante para quem constrói integrações MCP esperando usá-las tanto localmente (Claude Code) quanto via Managed Agents.

## Exemplos e evidências

- Convenção de nomenclatura `{domain}.{action}` exemplificada por toda a tabela de event types (`user.message`, `user.interrupt`, `user.custom_tool_result`, etc.).
- Tabela completa de rate limits com valores exatos: 300 req/min (create), 600 req/min (read).
- Lista exaustiva de 6 flags da CLI `ant beta:worker` com defaults explícitos onde aplicável (`--workdir` = `.`, sistema default `/workspace`; `--max-idle` = `60s`; `--log-format` = `text`).
- Três frases de branding permitido vs. três categorias de branding proibido, com exemplos textuais exatos ("Claude Agent", "{YourAgentName} Powered by Claude" vs. "Claude Code Agent", "Claude Cowork Agent").

## Implicações para o vault

- **Nota de disambiguação importante:** o título genérico "Reference.md" do clipping mascarava que esta é, na verdade, a página de referência específica de **Managed Agents** (`/docs/en/managed-agents/reference`), não uma referência geral da Messages API. Isso foi corrigido no título desta source page para evitar confusão futura ao buscar "Reference" no vault.
- Estabelece constantes operacionais concretas (rate limits, defaults de CLI, convenção de eventos) que complementam — sem sobrepor — as fontes já existentes sobre Managed Agents no vault: [[03-RESOURCES/sources/managed-agents-have-a-portability-problem-i-ran-one-agent-folder-on-anthropic-google-and-open-ai]] (foco em portabilidade cross-provider) e [[03-RESOURCES/sources/ai-agents-harness/claude-managed-agents-beginners-guide]] (foco introdutório).
- Os event types listados aqui (`user.message`, `user.interrupt`, `user.tool_confirmation`, `user.define_outcome`, etc.) são o lado "user-initiated" do par com os eventos de **webhook** (lado "session-state-change") documentados em [[03-RESOURCES/sources/subscribe-to-webhooks]] — juntas, as duas fontes mapeiam o vocabulário completo de eventos do Managed Agents.
- Relevante para [[03-RESOURCES/concepts/agent-systems/harness-adaptation]]: as flags do self-hosted worker (`--unrestricted-paths`, `--on-work`, `--workdir`) são primitivos de "environment contract" — definem exatamente como o ambiente expõe observações e capacidades ao agente, um dos "componentes adaptáveis no harness" descritos no concept.
- Sem contradições identificadas com fontes existentes — é material de referência puramente complementar.

## Links
- [[03-RESOURCES/sources/subscribe-to-webhooks]]
- [[03-RESOURCES/sources/managed-agents-have-a-portability-problem-i-ran-one-agent-folder-on-anthropic-google-and-open-ai]]
- [[03-RESOURCES/sources/ai-agents-harness/claude-managed-agents-beginners-guide]]
- [[03-RESOURCES/concepts/agent-systems/harness-adaptation]]
