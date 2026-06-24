---
title: Meta-programming
type: concept
created: 2026-06-23
updated: 2026-06-23
tags: [concept, ai-agents, meta-programming, code-generation, frontier-models]
---

# Meta-programming

Estratégia onde frontier models (GPT-5.4, Claude Opus 4.6) escrevem programas Python que geram código em linguagem alvo desconhecida, ao invés de escrever diretamente na linguagem.

## O padrão

```
Linguagem desconhecida → Model escreve Python que gera código → debug Python localmente → executa → output na linguagem alvo
```

## Por que funciona

- Decomposição: problema difícil (linguagem desconhecida) → problema fácil (Python) + transformation
- Debug loop local (Python) antes de output final = mais confiável
- Python como "meta-language" universal para code generation
- Diferencia top agents de agents comuns

## Evidências

- [[03-RESOURCES/sources/ai-agents/gracker-meta-programming]] — 2 papers arXiv sobre GPT-5.4 e Claude Opus 4.6

## Links

- [[03-RESOURCES/entities/GPT-5]]
- [[03-RESOURCES/entities/Claude-Opus]]
- [[03-RESOURCES/concepts/ai-agents/agent-loop-pattern]]