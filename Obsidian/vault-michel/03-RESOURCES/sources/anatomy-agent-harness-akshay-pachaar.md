---
title: "The Anatomy of an Agent Harness"
type: source
source_file: Clippings/The Anatomy of an Agent Harness.md
origin: post no X
author: "@akshay_pachaar"
published: 2026-04-06
ingested: 2026-05-14
tags: [agent-harness, orchestration, memory, context-management, langchain, openai, anthropic, production]
---

# The Anatomy of an Agent Harness

> [!key-insight] Core insight
> "If you're not the model, you're the harness." Um harness de produção tem 12 componentes distintos — e dois produtos com modelos idênticos podem ter performance radicalmente diferente com base apenas no design do harness. LangChain mudou só o harness e pulou do top-30 para posição 5 no TerminalBench 2.0.

## Sections

### Definição Canônica

- **Agent**: o comportamento emergente (entidade orientada a goals que usa ferramentas e se auto-corrige)
- **Harness**: a maquinaria que produz esse comportamento
- "When someone says 'I built an agent,' they mean they built a harness and pointed it at a model."

Analogia Beren Millidge (2023): LLM cru = CPU sem RAM, sem disco, sem I/O. Context window = RAM. Bancos externos = disco. Tools = device drivers. **Harness = Sistema Operacional.** "We have reinvented the Von Neumann architecture."

### 3 Níveis de Engenharia

1. **Prompt engineering**: crafts instruções que o modelo recebe
2. **Context engineering**: gerencia o que o modelo vê e quando
3. **Harness engineering**: engloba os dois + toda infraestrutura: tool orchestration, state persistence, error recovery, verification loops, safety, lifecycle

### Os 12 Componentes de Produção

| # | Componente | Função |
|---|-----------|--------|
| 1 | Orchestration Loop | TAO/ReAct cycle; "dumb loop" — inteligência vive no modelo |
| 2 | Tools | Schemas + registro + sandboxed execution + result formatting |
| 3 | Memory | Short-term (sessão) + long-term (CLAUDE.md, MEMORY.md, SQLite/Redis) |
| 4 | Context Management | Evitar context rot; compaction, observation masking, JIT retrieval, sub-agents |
| 5 | Prompt Construction | Hierarquia: system > tool defs > memory > history > user message |
| 6 | Output Parsing | Native tool_calls structs; schema-constrained via Pydantic |
| 7 | State Management | Git commits (Claude Code), LangGraph typed dicts, previous_response_id |
| 8 | Error Handling | 4 tipos: transient/LLM-recoverable/user-fixable/unexpected; cap 2 retries (Stripe) |
| 9 | Guardrails & Safety | Input + output + tool guardrails; tripwire mechanism; ~40 tool capabilities no Claude Code |
| 10 | Verification Loops | Rules-based + visual (Playwright) + LLM-as-judge; Boris Cherny: 2-3x quality improvement |
| 11 | Subagent Orchestration | Fork/Teammate/Worktree (Claude); agents-as-tools/handoffs (OpenAI); nested graphs (LangGraph) |
| 12 | (implícito) Prompt Caching | Prefixo imutável cacheado; crítico para custo |

### Context Rot

Pesquisa Chroma + Stanford "Lost in the Middle": **performance degrada 30%+ quando conteúdo chave cai em posições mid-window** — mesmo com janelas de 1M tokens. Estratégias de produção: compaction, observation masking, JIT retrieval, sub-agent delegation.

### 7 Decisões de Harness Design

1. Single-agent vs multi-agent (maximizar single primeiro; split só quando >10 tools sobrepostas)
2. ReAct vs plan-and-execute (LLMCompiler: 3.6x speedup vs ReAct sequencial)
3. Context window management (ACON: 26-54% redução preservando 95%+ accuracy)
4. Verification loop (guides vs sensors: feedforward vs feedback)
5. Permission/safety architecture (permissive vs restrictive)
6. Tool scoping (Vercel: removeu 80% das tools, performance aumentou)
7. Harness thickness (Anthropic aposta em harnesses mais finos conforme modelos melhoram)

### Ralph Loop (Anthropic)

Para tarefas multi-context-window: **Initializer Agent** configura ambiente (init script, progress file, feature list, git commit inicial) → **Coding Agent** em cada sessão subsequente lê git logs + progress files, escolhe feature de maior prioridade incompleta, trabalha, commita, escreve summaries. Filesystem fornece continuidade.

### Co-evolução Harness-Modelo

Claude Code foi treinado com harness específico. Mudar implementações de tools pode degradar performance. "Future-proofing test": se performance escala com modelos mais poderosos sem adicionar complexidade ao harness, o design é sólido.

### Frameworks Comparados

- **Claude Agent SDK**: query() function, async iterator, "dumb loop", Gather-Act-Verify cycle
- **OpenAI Agents SDK**: Runner class (async/sync/streamed), code-first Python
- **LangGraph**: state graph explícito, deprecou AgentExecutor (v0.2) por ser difícil de estender
- **CrewAI**: role-based multi-agent; Flows layer = "deterministic backbone with intelligence where it matters"
- **AutoGen**: conversation-driven; 5 padrões: sequential/concurrent/group chat/handoff/magentic

## Conexões

- [[03-RESOURCES/concepts/agent-harness]] — conceito central; adicionar contexto 12 componentes e Ralph Loop
- [[03-RESOURCES/entities/Akshay-Pachaar]] — autor
- [[03-RESOURCES/concepts/context-engineering]] — component #4 (context management)
- [[03-RESOURCES/concepts/multi-agent-orchestration]] — component #11 (subagent orchestration)
- [[03-RESOURCES/concepts/agent-memory-architecture]] — component #3 (memory)
- [[03-RESOURCES/concepts/context-rot]] — degradação por posição mid-window
- [[03-RESOURCES/concepts/prompt-caching]] — prefixo imutável; crítico para custo
