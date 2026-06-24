---
title: "CodeGraph: Pre-indexed code knowledge graph for Claude Code and AI agents"
type: source
created: 2026-05-18
updated: 2026-05-18
source_url: https://github.com/colbymchenry/codegraph
author: colbymchenry
published: 2026-05-18
category: ai-agents
tags: [ai-agents]
triagem_score: 8
---

# CodeGraph: Pre-indexed Code Knowledge Graph

## Tese central

CodeGraph pré-indexa a estrutura de uma codebase em um knowledge graph de símbolos/relacionamentos, permitindo que Explore agents de Claude Code consultem o grafo em vez de fazer grep/glob/Read a cada exploração — redução de ~92% em tool calls e ~71% em tempo.

## Key insights

- **Problema:** Claude Code Explore agents fazem grep, glob e Read em cada exploração, consumindo tokens em cada tool call; em codebases grandes isso se acumula rapidamente.
- **Solução:** grafo pré-indexado de símbolos, call graphs e estrutura de código. Agents consultam o grafo instantaneamente em vez de escanear arquivos.
- **Benchmarks (6 codebases reais, Claude Opus 4.6 + Claude Code v2.1.91):**
  - VS Code (TypeScript): 94% menos tool calls, 82% mais rápido
  - Excalidraw: 94% menos, 72% mais rápido
  - Claude Code (Python+Rust): 93% menos, 43% mais rápido
  - Média: 92% menos tool calls, 71% mais rápido
- **Setup:** `npx @colbymchenry/codegraph` instala e configura automaticamente para Claude Code, Cursor, Codex CLI, opencode. 100% local.
- **Filosofia fat-skill thin-harness:** o conhecimento pré-processado (grafo) vive no skill/ferramenta, não em tool calls do harness em tempo real.
- Compatível com múltiplos agentes: Claude Code, Cursor, Codex, OpenCode.

## Como o grafo é estruturado

O CodeGraph indexa a codebase em três camadas de informação:

1. **Símbolos:** funções, classes, variáveis, tipos — com localização exata (arquivo + linha)
2. **Relacionamentos:** quem chama quem, quem importa quem, quem herda de quem
3. **Estrutura:** hierarquia de diretórios, agrupamentos lógicos, entry points

Quando um agente precisa entender "como a função `processPayment` funciona e quem a chama", a consulta ao grafo retorna imediatamente: a localização da função, todos os callers, todos os callees, e os tipos envolvidos — sem nenhum `grep`, `glob`, ou `Read` de arquivo.

## Por que 92% de redução em tool calls importa

Tool calls são a unidade de custo em agentes de código. Cada `Read`, `grep`, e `Bash` consome tokens e tempo. Em uma exploração típica de codebase por Claude Code:

- Fase de orientação: 5–10 `glob` + `Read` para entender a estrutura
- Fase de localização: 3–8 `grep` para encontrar onde algo está definido
- Fase de contexto: 5–15 `Read` para entender dependências

Com CodeGraph, a fase de orientação e localização vira uma única consulta ao grafo. Apenas a fase de contexto (ler o código que vai ser modificado) ainda requer `Read`. Isso é o que produz 92% de redução.

## Comparação com abordagens alternativas

| Abordagem | Latência | Tokens | Precisão |
|---|---|---|---|
| grep/glob/Read (padrão) | Alta (N tool calls) | Alto | Média (pode perder contexto) |
| Vector search (RAG) | Média (embedding query) | Médio | Variável (depende da qualidade do embedding) |
| CodeGraph (grafo de símbolos) | Muito baixa (índice pré-construído) | Mínimo | Alta (relações exatas, não aproximadas) |

A diferença do CodeGraph para RAG é fundamental: RAG usa similaridade semântica (aproximada por natureza), CodeGraph usa relações estruturais exatas. "Quem chama esta função?" é uma pergunta com resposta exata — não aproximada. O grafo a responde com precisão de 100%; embeddings podem errar se o caller tem código semanticamente distante.

## Setup e compatibilidade

```bash
# Instalar e configurar automaticamente
npx @colbymchenry/codegraph

# O script configura automaticamente para:
# - Claude Code (adiciona ao CLAUDE.md)
# - Cursor (adiciona ao .cursorrules)
# - Codex CLI (adiciona ao codex.md)
# - opencode (adiciona ao opencode.md)
```

100% local significa que o código nunca sai da máquina — relevante para codebases com código proprietário ou dados sensíveis.

## Limitações

- **Custo de indexação:** a primeira indexação de uma codebase grande pode levar minutos
- **Staleness:** o grafo precisa ser reindexado após mudanças estruturais grandes. Para repos com merge frequente, o índice pode ficar desatualizado
- **Linguagens suportadas:** o benchmark usou TypeScript, Python, e Rust. Linguagens menos comuns podem ter suporte parcial
- **Código gerado:** arquivos gerados (tipos de GraphQL, protobuf, etc.) podem inflar o grafo sem valor navegacional

## Relação com a filosofia fat-skill thin-harness

O CodeGraph é um exemplo perfeito do princípio "conhecimento pré-processado no skill, não em tool calls em runtime". O trabalho pesado de análise da codebase é feito uma vez (indexação), e o resultado fica disponível como consulta barata. O harness (Claude Code) fica thin — não precisa explorar, apenas consultar.

Isso contrasta com a abordagem padrão onde o harness faz exploração em tempo real a cada sessão, repetindo o mesmo trabalho de entendimento da codebase que já foi feito na sessão anterior.

## Links

- [[03-RESOURCES/concepts/llm-ml-foundations/no-vector-retrieval]]
- [[03-RESOURCES/concepts/llm-ml-foundations/optical-context-retrieval]]
