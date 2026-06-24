---
title: Ollama
type: entity
category: tool
tags: [llm, local, open-source, gemma, hardware]
created: 2026-04-17
updated: 2026-05-19
---

# Ollama

Ferramenta open-source para rodar LLMs localmente. Site: [ollama.com](https://ollama.com/). Permite rodar modelos como Gemma 4 sem dependência de APIs cloud, sem rate limits e sem alterações server-side.

## Integração com Claude Code

```bash
ollama pull gemma4
export ANTHROPIC_BASE_URL=http://localhost:11434
export ANTHROPIC_AUTH_TOKEN=ollama
claude --model gemma4
```

Permite usar Claude Code apontado para um modelo local em vez da API da Anthropic.

## Verificação de hardware

**whatmodelscanirun.com** — selecionar GPU/VRAM, retorna imediatamente o maior modelo que roda confortavelmente.

## Contexto de uso

Mencionado como solução para o "Claude Code Tax" de ~20K tokens invisíveis em versões v2.1.100+. Gemma 4 tem performance state-of-the-art em coding + multimodal para hardware compatível.

## Fontes

- [[03-RESOURCES/sources/token-economy-cost/fix-claude-code-rate-limits-quality]]
- [[03-RESOURCES/sources/ai-agents-harness/openjarvis-local-first-ai-ollama]] — OpenJarvis v1.0 usa Ollama como runtime padrão para agentes pessoais locais
