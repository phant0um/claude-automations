---
title: "MCP - A Deep Dive"
type: source
source_type: article
author: "Neo Kim / Eric Roby"
created: 2026-05-06
tags: [mcp, protocol, tools, integration]
triagem_score: 8
---

Deep dive into Model Context Protocol: architecture, server/client patterns, tool registration, resource management. How MCP enables standardized tool connectivity for LLM applications.

## Source

Ingested from: `clippings/MCP - A Deep Dive.md`
Ingested: 2026-05-06 (daily scheduled task)

---

## O Problema que MCP Resolve

Antes do MCP (Model Context Protocol), cada integração entre LLM e ferramenta externa era construída manualmente e de forma incompatível:
- Um plugin do ChatGPT não funcionava com Claude
- Uma integração Notion para um app de chat não reaproveitava nada para um app de código
- Cada desenvolvedor reimplementava auth, serialização de schema, tratamento de erros, e streaming

MCP padroniza essa camada de integração com uma especificação JSON-RPC que qualquer LLM client pode implementar e qualquer ferramenta pode expor. É o USB-C das integrações LLM: um conector que funciona com qualquer dispositivo compatível.

## Arquitetura MCP

### Componentes Principais

**MCP Host**: a aplicação LLM que inicia conexões com servidores MCP. Exemplos: Claude Desktop, Claude Code, Cursor, Cline. O host gerencia o ciclo de vida das conexões e injeta as definições de tool no contexto do modelo.

**MCP Client**: embutido no host, implementa o protocolo MCP. Responsável por: descoberta de tools, chamadas de ferramenta, streaming de resultados, e tratamento de erros de protocolo.

**MCP Server**: processo separado que expõe tools, resources, e prompts via protocolo MCP. Pode ser local (processo filho) ou remoto (via HTTP/SSE). O server implementa a lógica de negócio; o protocolo é genérico.

### Transport Layers

MCP suporta dois transports principais:

**stdio** (local): o host inicia o server como processo filho e se comunica via stdin/stdout. Mais simples, mais rápido, sem overhead de rede. Adequado para servers locais (filesystem, banco de dados local, ferramentas CLI).

**HTTP + SSE** (remoto): o server é um serviço web. O client usa HTTP para enviar requests e Server-Sent Events para receber respostas em streaming. Adequado para APIs externas, serviços compartilhados entre múltiplos hosts.

```
Host (Claude Code)
  → MCP Client
    → stdio → MCP Server local (filesystem)
    → HTTP/SSE → MCP Server remoto (GitHub API)
```

## Os Três Primitivos do MCP

**Tools** (ações): funções que o modelo pode chamar. Cada tool tem: nome, descrição (em linguagem natural, lida pelo modelo para decidir quando usar), schema de input (JSON Schema), e lógica de execução. Ferramentas têm side effects — criam, modificam, deletam.

**Resources** (contexto): dados que o server pode expor para o host injetar no contexto. Diferente de tools, resources são somente leitura e não têm side effects. Exemplos: conteúdo de arquivo, esquema de banco de dados, estado atual de um sistema. O host decide quando e se injeta um resource no contexto.

**Prompts** (templates): sequências de mensagens pré-construídas que o server pode oferecer ao host. Permitem que servers exponham workflows completos como prompts reutilizáveis, não apenas tools isoladas.

## Fluxo de Descoberta e Execução

```
1. Host conecta ao server
2. Host envia tools/list → server responde com schemas de tools disponíveis
3. Host injeta schemas no system prompt do modelo
4. Modelo recebe pergunta do usuário
5. Modelo decide usar tool X com argumentos Y
6. Host envia tools/call(X, Y) ao server
7. Server executa ação, retorna resultado
8. Host injeta resultado no contexto
9. Modelo gera resposta final com base no resultado
```

O passo crítico é 3 e 8: o host controla o que o modelo vê, não o server. Isso mantém o server stateless e o host em controle da conversa.

## Segurança e Permissões

MCP introduz uma superfície de ataque nova: um server malicioso pode definir tools com descrições que manipulam o modelo a fazer coisas não-intencionais (prompt injection via tool description). Mitigações:

- **Tool approval**: hosts podem exigir aprovação humana antes de executar qualquer tool call (modo padrão em Claude Code para ferramentas com side effects)
- **Sandboxing**: servers locais podem ser executados em containers com acesso limitado ao sistema de arquivos
- **Schema validation**: o host valida que os argumentos fornecidos pelo modelo correspondem ao schema antes de executar
- **Auditoria**: todo tools/call é logável — diferente de chamadas diretas a APIs que o modelo "imagina"

## MCP vs Alternativas

| Abordagem | Standardização | Side Effects | Streaming | Multi-host |
|---|---|---|---|---|
| **MCP** | sim (spec aberta) | tools/resources | sim (SSE) | sim |
| **OpenAI Function Calling** | parcial (OpenAI-specific) | sim | não nativo | não |
| **LangChain Tools** | não (Python-specific) | sim | parcial | não |
| **Direct API calls** | não | sim | manual | não |

## Estado do Ecossistema (2026)

O ecossistema MCP cresceu rapidamente após o lançamento pela Anthropic em novembro 2024. Servidores notáveis: GitHub (code navigation), Obsidian (vault read/write), Postgres (query execution), Brave Search, Filesystem, Docker, e dezenas de integrações SaaS.

Claude Code usa MCP extensivamente: o vault-michel conecta via MCP ao Obsidian para leitura e escrita de notas em tempo real — esse é o mecanismo que permite ao Claude "ler e escrever no segundo cérebro."

## Relevância para o Vault

O vault-michel depende de MCP para sua operação: o servidor Obsidian MCP permite ao Claude Code ler notas, atualizar hot.md, e escrever novos arquivos sem copiar/colar conteúdo no chat. Entender MCP é entender a camada de infraestrutura do segundo cérebro.

## Relações

- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — conceito central
- [[03-RESOURCES/entities/Claude Code]] — host MCP principal do vault
- [[03-RESOURCES/entities/Obsidian]] — acessado via MCP server
- [[03-RESOURCES/concepts/agent-systems/agent-harness]] — MCP é a camada de ferramentas do harness
- [[03-RESOURCES/concepts/llm-ml-foundations/context-window]] — resources MCP são injetados no contexto
