---
title: "chopratejas/headroom: Compress tool outputs, logs, files, and RAG chunks before they reach the LLM. 60-95% fewer tokens, same answers. Library, proxy, MCP server."
type: source
source: "Clippings/chopratejasheadroom Compress tool outputs, logs, files, and RAG chunks before they reach the LLM. 60-95% fewer tokens, same answers. Library, proxy, MCP server..md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, token-economy, context-compression, mcp, claude-code]
---

## Tese central

Headroom é uma camada de compressão de contexto para agentes de IA que comprime tool outputs, logs, RAG chunks, arquivos e histórico de conversa antes de chegarem ao LLM, alcançando 60–95% de redução de tokens com accuracy preservada — disponível como biblioteca Python/TypeScript, proxy drop-in, e servidor MCP.

## Argumentos principais

- Headroom opera localmente (dados nunca saem da máquina) e suporta compressão reversível via CCR (Contextual Compression with Retrieval): originais nunca deletados, LLM pode recuperar sob demanda.
- Seis algoritmos de compressão são roteados automaticamente pelo ContentRouter conforme o tipo de conteúdo: SmartCrusher (JSON), CodeCompressor (AST), Kompress-base (texto/prosa), compressão de imagem (ML router), CacheAligner (estabilização de prefixo para KV cache), IntelligentContext (seleção por importância).
- Compatível com Claude Code, Codex, Cursor, Aider, Copilot CLI, OpenClaw via `headroom wrap <agente>` ou proxy OpenAI-compatible.
- Cross-agent memory: contexto comprimido compartilhado entre Claude, Codex, Gemini com auto-dedup e provenance de agente.
- `headroom learn` minera sessões com falha e escreve correções automáticas em `CLAUDE.md` / `AGENTS.md` / `GEMINI.md`.

## Key insights

- CacheAligner estabiliza prefixos de prompt para que o KV cache do provider (Anthropic/OpenAI) realmente acerte — amplifica savings além da compressão pura.
- O ciclo de vida do pipeline é explícito e extensível: Setup → Pre-Start → Post-Start → Input Received → Input Cached → Input Routed → Input Compressed → Input Remembered → Pre-Send → Post-Send → Response Received.
- Headroom é a única solução local+reversível+multi-conteúdo; RTK cobre apenas outputs de CLI; soluções hospedadas (Compresr, Token Co.) não são locais e não são reversíveis.
- O projeto cita RTK explicitamente como complementar: RTK reescreve outputs de shell antes do Headroom comprimir o downstream.
- Kompress-base é um modelo HuggingFace treinado em traces agênticos para compressão de prosa.

## Exemplos e evidências

| Workload | Antes | Depois | Savings |
|---|---|---|---|
| Code search (100 resultados) | 17.765 tokens | 1.408 tokens | 92% |
| SRE incident debugging | 65.694 tokens | 5.118 tokens | 92% |
| GitHub issue triage | 54.174 tokens | 14.761 tokens | 73% |
| Codebase exploration | 78.502 tokens | 41.254 tokens | 47% |

Benchmarks de accuracy: GSM8K ±0.000, TruthfulQA +0.030, SQuAD v2 97% com 19% compressão, BFCL 97% com 32% compressão.

Demo ao vivo: 10.144 → 1.260 tokens — mesmo FATAL encontrado.

## Implicações para o vault

Diretamente relevante para o sistema RTK já em uso no vault (o CLAUDE.md global referencia RTK). Headroom é uma camada superior ao RTK que cobre o que RTK não cobre (RAG, logs, histórico, imagens). O conceito de `headroom learn` que escreve em CLAUDE.md é análogo ao mecanismo de self-improvement do vault. Possível candidato a integração com o pipeline de agentes.

## Links

- [[03-RESOURCES/concepts/ai-agents/token-economy]]
- [[03-RESOURCES/concepts/ai-agents/context-compression]]
- [[03-RESOURCES/concepts/ai-agents/kv-cache]]
- [[03-RESOURCES/entities/headroom]]
