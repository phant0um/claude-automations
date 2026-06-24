---
title: "Anthropic dropped Ant quietly: full guide do ant CLI e Managed Agents"
type: source
source: "Clippings/Anthropic dropped Ant quietly. (Here's the full guide).md"
created: 2026-06-10
ingested: 2026-06-10
tags: [ai-agents]
---

## Tese central
Em 2 de junho de 2026 a Anthropic lançou o `ant` CLI (Go, MIT, open source) — um cliente típado completo para a Claude API que cobre mensagens, modelos, arquivos, batch jobs, agentes, sessões, ambientes e skills. Não é um wrapper estilo curl: é a "camada operacional" de uma plataforma que vem migrando silenciosamente de "model provider" para infraestrutura completa de agentes desde abril de 2026 (lançamento de Managed Agents).

## Argumentos principais
- **`ant` ≠ curl**: curl entrega HTTP cru (precisa montar body, headers, paginação manual, parsear com jq). `ant` é um cliente típado: passa flags → monta request → lida com auth → pagina automaticamente → formata resposta conforme contexto.
- **Binário único, zero dependências de runtime**, código em github.com/anthropics/anthropic-cli.
- **Estrutura de comando consistente**: `recurso então ação`, dois-pontos para recursos aninhados. Ex.: `ant models list`, `ant messages create --model claude-opus-4-8 --max-tokens 1024`, `ant beta:agents retrieve --agent-id ...`, `ant beta:sessions:events list --session-id ...`. Familiar para quem usa GitHub CLI ou Stripe CLI.
- **Recursos beta** (agents, sessions, deployments, environments, skills, vaults, memory stores) ficam sob prefixo `beta:`. O CLI envia automaticamente o header `anthropic-beta: managed-agents-2026-04-01` — usuário nunca precisa tocar nisso.
- **Instalação**: `brew install anthropics/tap/ant` (macOS), `curl -fsSL https://console.anthropic.com/install/cli | sh` (Linux/WSL), ou `go install github.com/anthropics/ant-cli@latest`. Verificar com `ant --version`.
- **Autenticação**: lê de `ANTHROPIC_API_KEY`. Pegar chave em platform.claude.com/settings/keys. ATENÇÃO: se `ANTHROPIC_API_KEY` está setada como env var E há um profile nomeado configurado, a env var sempre vence — primeiro lugar a checar se comandos atingem workspace errado.
- **`--base-url`** disponível em qualquer comando — útil para proxies, staging, ou roteamento via AWS Bedrock.

## Key insights
- **Output adaptativo**: resposta vem como JSON pretty-printed por padrão; ao fazer pipe para outro comando, o CLI muda automaticamente para JSON compacto — detecção de contexto automática.
- **Formatos de output**: `--format yaml` (mais fácil de escanear), `--format jsonl` (um objeto por linha, ideal para pipelines), `--format explore` (TUI interativo navegável com setas, `/` para buscar, `q` para sair — útil para ler trajetórias de agentes com centenas de linhas JSON).
- **`--transform` flag** (a parte que "a maioria nunca encontra"): aceita um GJSON path e remodela a resposta antes de imprimir. Em endpoints de listagem, roda contra cada item individualmente. Ex.: `ant beta:agents list --transform "{id,name,model}" --format jsonl`. Se o resultado é string, imprime sem aspas (como jq). Combinar com `--raw-output` para extrair IDs para o próximo comando: `AGENT_ID=$(ant beta:agents list --transform id --raw-output | head -1)`.
- **Referências de arquivo inline**: qualquer flag aceita `@path` — o CLI inspeciona o tipo de arquivo automaticamente (texto vai como string literal, binários como imagens/PDFs viram base64). Para forçar encoding: `@file://path` (texto) ou `@data://path` (base64). Ex.: `--system @./prompts/researcher.txt`.
- Combinando `--transform` com grep/awk/jq/head, `ant` vira uma camada de automação totalmente scriptável sem código adicional.

## Exemplos e evidencias
- **As quatro primitivas de Managed Agents** (lançado em beta pública em 8 de abril de 2026):
  - **Agent**: configuração — modelo (Sonnet 4.6, Opus 4.7, Opus 4.8), system prompt, tools acessíveis, MCP servers conectados. Criado uma vez, referenciado por ID em toda sessão.
  - **Environment**: container cloud provisionado pela Anthropic — networking, sandboxing, pacotes pré-instalados (Python, Node.js, Go), regras de acesso à rede, arquivos montados.
  - **Session**: instância em execução de um agent dentro de um environment. Durável por design — se o container crasha no meio de uma task, uma instância nova lê o event log append-only e retoma exatamente de onde parou.
  - **Events**: o protocolo — mensagens de usuário, resultados de tools e status flow bidirecionalmente como SSE (Server-Sent Events). Ao terminar, agente emite `session.status_idle`.
- **Workflow de deploy de primeiro managed agent**:
  - Criar agent: `ant beta:agents create --name "Code Reviewer" --model '{id: claude-opus-4-8}' --system "..." --tool '{type: agent_toolset_20260401}'`
  - `agent_toolset_20260401` dá toolkit prebuilt completo: bash execution, file operations, web search.
  - Resposta retorna `{id, version, name, model}` — versão atua como optimistic lock para updates em CI (evita race conditions).
  - Recuperar IDs perdidos: `ant beta:agents list --transform "{id,name}" --format jsonl`.
  - Agentes podem ser definidos como YAML e versionados em Git (GitOps completo para configs de agente): `ant beta:agents create < code-reviewer.yaml`.
- Exemplo de chamada básica: `ant messages create --model claude-opus-4-8 --max-tokens 1024 --message '{role: user, content: "Hello Claude"}'` retorna JSON com `model`, `id`, `usage.input_tokens/output_tokens`, etc.

## Implicacoes para o vault
- Atualiza/expande `[[03-RESOURCES/sources/claude-managed-agents-overview]]` com a peça que faltava: a interface de linha de comando (`ant`) que opera as primitivas de Managed Agents (Agent/Environment/Session/Events) descritas lá.
- Relevante para `[[03-RESOURCES/concepts/claude-code-tooling/mcp-cli-bridge]]` — `ant` é outro exemplo de CLI tipado como camada de automação sobre uma API de LLM, padrão similar ao discutido em CLI bridges.
- Para o vault SO: `ant beta:agents create < code-reviewer.yaml` com versionamento em Git é um padrão GitOps aplicável a `04-SYSTEM/agents/` — agentes do vault como configs versionadas e atualizáveis via API, não apenas arquivos `.md` estáticos.
- Modelos citados (claude-opus-4-8, claude-opus-4-7) são mais recentes que os já catalogados em `[[03-RESOURCES/entities/Claude-Opus-47]]` / `[[03-RESOURCES/entities/Claude-Opus-48]]` — confirma a linha do tempo desses releases.

## Links
- [[03-RESOURCES/sources/claude-managed-agents-overview]]
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-cli-bridge]]
- [[03-RESOURCES/entities/Claude-Opus-47]]
- [[03-RESOURCES/entities/Claude-Opus-48]]
- [[03-RESOURCES/entities/Claude-Managed-Agents]]
