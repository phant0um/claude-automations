---
title: "Agent Memory Layers"
type: concept
status: developing
created: 2026-05-23
updated: 2026-05-23
tags: [concept, ai-agents, memory, state, consistency, retrieval, knowledge-graph]
---

# Agent Memory Layers

**Definição:** Arquitetura em camadas para memória de agentes IA. Cada camada tem lifespan, autoridade e modo de falha distintos. Memória não estruturada em camadas cria inconsistência, alucinação de contexto, e perda silenciosa de dados.

> Mais armazenamento não significa que o agente usará melhor. Memória tem que fazer 3 jobs: **Lembrar** por camada, **Citar** por proveniência, **Esquecer** por expiração.

---

## As 6 Camadas (Framework Voxyz)

| Camada | Lifespan | Autoridade | Falha Típica |
|--------|----------|------------|--------------|
| **Hot session** | Duração da task | Alta — contexto imediato | User disse "sem emoji" na turn 2, compressão derruba na turn 3 |
| **Day-state** | 1 dia (whiteboard) | Instrução mais nova vence | Tarefa A prioritária pela manhã, tarde muda pra B, agente continua pesquisando A |
| **Project memory** | Weeks/meses | Lição atual supera antiga | Nota de 3 meses "user quer markdown" ainda formata output, user mudou preferência |
| **Retrieval / Index** | Persistente, mas decai | Superfície candidatos — não decide | Vector search retorna plano de 6 meses atrás tratado como resposta atual |
| **Canonical policy** | Longo prazo | Alta — "constituição" do agente | Ignorado por instrução de sessão sem traceback explícito |
| **Direct instruction** | Task atual | Mais alta para task corrente | Resumo de sessão substitui instrução original sem preservar fonte |

---

## Hierarquia de Autoridade (Citation Order)

Quando há conflito entre camadas, esta ordem determina quem vence:

1. Original direct instruction (com rastreabilidade)
2. Canonical policy (AGENTS.md, SOUL.md)
3. Decisão de projeto mais recente
4. Long-term memory com source attribution
5. Resumo de retrieval
6. Compressed summary

**Ponto crítico:** "O usuário pareceu autorizar" derivado de summary **não** conta como autorização. Só instrução original rastreável substitui canonical policy.

---

## Três Jobs da Memória Confiável

### 1. Remember — Lembrar por Camada
Cada camada responde à pergunta: qual nível de decisão esta memória pode afetar? Hint? Evidência citável? Pode decidir?

### 2. Cite — Citar por Proveniência
Antes de entrar no decision loop, toda memória precisa responder:
- De onde veio? (canonical file, dia, mensagem)
- É derivada de outra memória? (derivada ≠ original)

Caso Air Canada (2024): bot informou que cliente poderia pedir reembolso retroativo de tarifa bereavement. Policy oficial dizia o oposto. Tribunal condenou Air Canada — "não importa se informação vem de página estática ou chatbot." Lição: canonical policy sempre vence, agente não pode contradizer.

### 3. Forget — Expirar por Validade
Memória velha que **parece** válida é mais perigosa que ausência de memória. Três mecanismos:

| Mecanismo | Como Funciona | Uso Ideal |
|-----------|--------------|-----------|
| **Hard expiry** | `valid_from` / `valid_until` — fato novo escreve timestamp de expiração no antigo | Policy, pricing, regulação |
| **Bitemporal** | 4 timestamps: `created_at / valid_at / invalid_at / expired_at` — separa "quando era verdade" de "quando sistema soube que deixou de ser" | Fatos que mudam no tempo |
| **Soft decay** | Retrieval ranking demota memórias não-usadas (floor ~0.3×) — não deleta, desranka | Preferências, hábitos, background |

---

## Consistência: State vs. Memory

| Dimensão | State | Memory |
|----------|-------|--------|
| **O que é** | Picture do NOW — plano ativo, constraints, progresso | Conhecimento acumulado — lições, preferências, facts |
| **Update** | Imediato (nova instrução → state muda agora) | Gradual (padrão precisa se sustentar antes de escrever) |
| **Escopo** | Task / sessão atual | Cross-session, long-term |
| **Falha** | Agente perde thread, repete perguntas | Agente usa informação obsoleta como se fosse atual |

---

## Arquitetura de Referência (4 Camadas)

```
┌─────────────────────────────┐
│  Brain (LLM + reasoning)    │  ← toma decisões
├─────────────────────────────┤
│  State (task tracker)       │  ← plano, constraints, progresso NOW
├─────────────────────────────┤
│  Memory (knowledge base)    │  ← layers 1-6 acima
├─────────────────────────────┤
│  External Systems           │  ← APIs, DBs, docs, webhooks
└─────────────────────────────┘
```

---

## Self-Evolving Memory (EvolveMem)

Sistemas de memória tradicionais fixam a retrieval infrastructure — só o conteúdo evolui. **EvolveMem** (UNC/Berkeley, 2026) expõe a configuração completa de retrieval como action space otimizado por LLM:

- Em cada rodada: módulo de diagnóstico lê failure logs por pergunta
- Identifica padrões de falha → modifica scoring functions, fusion strategies, answer-generation policies
- Resultado: memória que co-evolui conteúdo E mecanismo de retrieval

Benchmarks (LongMemEval): EvolveMem supera arquiteturas de memória fixas em tasks multi-sessão.

---

## Implementações de Referência

| Sistema | Abordagem | Destaque |
|---------|-----------|---------|
| **GBrain** | 6-tier source resolver + bitemporal facts + hard expiry | Produção real (Garry Tan, 146k pages) |
| **LangGraph** | Short-term + long-term (semantic / episodic / procedural) | Framework padrão |
| **Mem0** | Conversation / session / user / org + soft decay | Decay como feature, não compliance |
| **Zep** | 4-timestamp bitemporal | Mais granular para temporal reasoning |

---

## Audit Rápido (3 Perguntas)

Antes de qualquer memória entrar no decision loop:

1. **Que nível de decisão pode afetar?** Hint / evidência citável / decisão final?
2. **De onde veio?** Canonical file, dia, mensagem, ou derivada?
3. **Ainda é válida?** O que faria esta memória ser substituída?

Se as 3 forem respondíveis → entra no decision path. Se não → fica como background context apenas.

---

## Ver Também

- [[03-RESOURCES/sources/ai-agents-harness/anatomy-agent-harness-akshay-pachaar]] — 12 componentes do harness; memória como componente 3
- [[03-RESOURCES/concepts/agent-systems/harness-engineering]] — camada que orquestra memória + tools + estado
- [[03-RESOURCES/entities/garry-tan]] → [[03-RESOURCES/entities/hermes-agent]] — GBrain como implementação de referência
- [[03-RESOURCES/concepts/agent-systems/agent-memory-four-layers]] — conceito anterior (4 layers); este é mais granular (6)
- [[03-RESOURCES/concepts/pkm-obsidian/knowledge-compounding]] — memória como engine de compounding
- Fontes:
  - [[03-RESOURCES/sources/memory-context-rag/framework-agent-memory-remember-cite-forget]] — framework principal (Voxyz)
  - [[03-RESOURCES/sources/memory-context-rag/ai-agents-state-memory-consistency]] — state vs. memory vs. consistency
  - [[03-RESOURCES/sources/memory-context-rag/evolvemem-self-evolving-memory-architecture]] — EvolveMem (UNC/Berkeley)
  - [[03-RESOURCES/sources/memory-context-rag/tencent-agent-memory-runtime]] — context explosion solution
  - [[03-RESOURCES/sources/memory-context-rag/agentic-rag-deep-dive]] — RAG agentico vs padrão
