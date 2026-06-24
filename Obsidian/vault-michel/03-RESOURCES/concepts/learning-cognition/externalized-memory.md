---
title: "Externalized Memory"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, agent-systems]
status: developing
---

# Externalized Memory

Memória armazenada fora dos pesos do modelo — em arquivos, bancos de dados, ou vector stores — permitindo escalar além dos limites do context window.

## O que é

Externalized memory é o padrão arquitetural onde o "conhecimento" de um agente não vive nem nos pesos do modelo (memória paramétrica) nem no contexto da conversa (memória in-context), mas em armazenamento externo que o agente lê e escreve explicitamente. O vault Michel é um exemplo: a memória do sistema está em `.md` files, não no modelo.

## Como funciona

**Tipos de armazenamento externo:**

- **Arquivos estruturados** (Markdown, JSON, YAML): legíveis por humanos e agentes; o vault usa isso como camada primária.
- **Vector stores** (FAISS, Pinecone, Chroma): recuperação semântica por similaridade de embedding; escala para milhões de documentos.
- **Bancos relacionais/de grafos**: memória com estrutura e relações explícitas; útil para entidades e suas conexões.
- **Key-value stores** (Redis, DynamoDB): acesso rápido por chave para memória de trabalho e sessão.

**Contraste com in-context memory**: in-context é limitada pelo context window (200k tokens no máximo), cara (todos os tokens são processados a cada chamada), e efêmera (descartada ao fim da sessão). Externalized memory persiste, não tem limite de tamanho, e é acessada seletivamente (só o relevante entra no contexto).

**Operações típicas do agente**: `READ` (carrega hot.md, recupera chunk relevante), `WRITE` (salva nota, atualiza manifest), `SEARCH` (embedding search, grep).

## Por que importa

Context windows, mesmo em 200k tokens, não são memória de longo prazo. Externalized memory é o que permite agentes operar como segundo cérebro persistente — acumulando conhecimento entre sessões, compartilhando entre agentes, e escalando além de qualquer context window. É a base do vault como SO.

## Evidências
- **[2026-06-19]** Template Vercel Labs injeta memória de longo prazo em toda sessão do agente para usuários autenticados, com fluxo de importação manual (export de outro assistente → categorias fixas → bloco de prosa) somado a propostas incrementais via `save_memory` exigindo aprovação — [[03-RESOURCES/sources/vercel-labs-personal-agent-template]]

## Related
- [[03-RESOURCES/concepts/agent-systems/_index]]
- [[03-RESOURCES/concepts/agentic-memory-taxonomy]]
- [[03-RESOURCES/concepts/agent-systems/context-management]]
