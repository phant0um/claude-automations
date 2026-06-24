---
title: Hermes Agent Architecture
type: concept
area: agent-systems
created: 2026-06-02
updated: 2026-06-02
score: 8
tags: [concept, agent-systems, hermes-agent, self-improvement, memory, multi-agent]
---

# Hermes Agent Architecture

## Tese central

Hermes diferencia-se de outros agentes por 3 propriedades arquiteturais — memória local transparente, self-improvement nativo (edita próprias skills após cada task), e session recall full-text. Agentes falham em arquitetura (tools conflitantes), não em inteligência do modelo.

## Os 3 Diferenciais

### 1. Memória local (não cloud)
Tudo em markdown na máquina do usuário. Transparência total — usuário lê, edita, deleta. Sem black box, sem vendor lock-in para memória.

### 2. Self-improvement
Após cada task concluída: o agente revisa o que funcionou, o que não funcionou, como fazer melhor. **Edita suas próprias skills automaticamente.** Resultado: agente exponencialmente melhor com uso.

Padrão equivalente no vault-michel: [[04-SYSTEM/agents/core/hill]] + [[04-SYSTEM/agents/core/extend]]

### 3. Session recall
Toda conversa logada com SQLite FTS5 + LLM summarization. Recall de qualquer conversa de meses atrás via full-text search.

## 7-Layer Memory OS (memory-os)

Arquitetura completa de memória para Hermes (ClaudioDrews/memory-os):

```
Layer 1 — WORKSPACE
  MEMORY.md · USER.md · CREATIVE.md
  → Injetados no system prompt a cada turno
  Equivalente vault: hot.md + CLAUDE.md

Layer 2 — SESSIONS
  state.db (SQLite + FTS5)
  → Full-text search em todo histórico de conversas

Layer 3 — STRUCTURED FACTS
  memory_store.db (SQLite + HRR + FTS5 + trust scoring)
  → Fatos duráveis com resolução de entidades

Layer 4 — VECTOR SEMANTIC
  Qdrant
  → Busca semântica cross-session

Layer 5 — FABRIC RECALL
  → Recall de padrões e hábitos recorrentes

Layer 6 — WIKI PIPELINE
  → Wiki auto-curada — organização automática de conhecimento

Layer 7 — CONTEXT INJECTION (coordinator)
  → Injeção cirúrgica: só contexto relevante ao momento
  → "Ground Truth hierarchy" instrui agente a usar a memória injetada
```

**Princípio chave**: surgical injection > dump completo. Injetar só o relevante = qualidade + economia de tokens.

## Multi-Agent via Kanban (v0.12.0+)

```
Board Kanban → agentes tomam tasks → trabalham em paralelo → handoff quando bloqueados
```

Permite delegação natural de tasks complexas sem coordenação manual. Skills auto-criadas quando workflow é reconhecido como recorrente: 3 min manual → 10s na segunda vez.

## Posicionamento vs Claude Code

| | Hermes | Claude Code |
|---|---|---|
| **Job** | General-purpose employee, operações diárias | Deep focused coding sessions |
| **Força** | Memória, self-improvement, 24/7 | Engenharia de software complexa |
| **Quando usar** | Research, docs, tasks recorrentes, automação | Apps complexos, end-to-end testing |

**Não são concorrentes** — complementares. Hermes orquestra, Claude Code executa (via `hermes proxy`).

## Hierarquia de Falha

Agentes falham por arquitetura, não inteligência:
1. Tools conflitando entre si (mais comum)
2. Provider com alta latência (multi-hop vs direto)
3. Skills insuficientes para o job
4. Memória não estruturada para recall eficiente

## Implicações para vault-michel

- vault implementa Layers 1-3 da memória (hot.md, sessions/, sources/) — faltam Layers 4-7
- Self-improvement de Hermes = hill + extend do vault → padrão convergente validado
- Kanban multi-agent é arquitetura candidata para pipeline de ingest com >20 fontes
- Obsidian provider nativo (v0.14): vault-michel como memória externa do Hermes

## Relacionado

- [[03-RESOURCES/entities/hermes]] — entidade completa com versões e dados
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — framework geral de memória
- [[03-RESOURCES/concepts/agent-systems/agent-skill-graduation]] — self-improvement como padrão
- [[03-RESOURCES/sources/hermes-agent-complete-guide]]
- [[03-RESOURCES/sources/memory-os-7-layer-hermes-agent]]
- [[03-RESOURCES/sources/6-workflows-6-lessons-60-days-hermes]]

## Evidências
- **[2026-06-19]** Comunidade de usuários do Hermes debate operação real: modelo barato (DeepSeek) operacionaliza escolha de modelo, roteamento padrão de tráfego web sem disclosure gerou maior controvérsia do mês, e o argumento pró-Hermes vs. Claude é ownership/controle, não polish — [[hermes-users-are-turning-agents-into-chores-side-businesses-and-security-debates]]
- **[2026-06-19]** Setup de 3 perfis isolados (Scout/Analyst/Briefer) com wakeAgent gates por arquivo custa US$19-27/mês e produz brief diário priorizado vs. US$1.500-3.000/mês de um assistente de pesquisa humano — [[hermes-agent-notebooklm-obsidian-3-agent-research-department]]
- **[2026-06-21]** A maioria dos usuários raspa a superfície do Hermes Agent usando-o como chatbot; o valor real está em 12 casos de uso de alto ROI que tratam o agente como funcionário autônomo — desde caça de empregos até coordenação multi-agente — sempr... — [[hermes-agent-12-high-roi-use-cases]]
- **[2026-06-21]** A maioria dos usuários de Hermes Agent fica no nível 1 (chatbot, one-shot prompts) e usa só ~10% do potencial do agente. O artigo mapeia 15 níveis progressivos em 3 fases — fundação, paralelismo/memória e autonomia 24/7 — cada um com set... — [[15-levels-of-hermes-agent-from-chatbot-to-247-autonomous-system]]
- **[2026-06-21]** A maioria das automações cron com agentes desperdiça tokens disparando um turno completo do modelo a cada tick, mesmo sem nada para decidir. O fix é manter o modelo fora do loop até ser realmente necessário e encolher seu trabalho quando... — [[3-easy-ways-to-build-cheap-or-free-automation-pipelines-with-hermes-agent]]

- **[2026-06-22]** Modelo de monetização em 3 camadas (managed $500-2k/mês, supervised $200-800/mês, licensed) para expertise encodada via Hermes+Obsidian — primeira source a tratar a arquitetura como oferta comercial, não só produtividade pessoal — [[03-RESOURCES/sources/how-to-productize-your-expertise-into-a-hermes-and-obsidian-system-clients-pay-to-access]]
- **[2026-06-24]** In late 2023, a mid-sized systematic fund in Chicago - managing roughly $2. — [[how-quants-use-llm-agents-to-mine-alpha-from-unstructured-data-the-complete-rag-framework]]

## Perspectivas

- **[2026-06-21]** Os 15 níveis progressivos (chatbot → autonomia 24/7) mostram que a maioria dos usuários de agentes pessoais nunca passa do nível 1 — o gap não é capacidade do modelo, é desenho de workflow. — [[15-levels-of-hermes-agent-from-chatbot-to-247-autonomous-system]]
- **[2026-06-24]** Hermes é um runtime persistente, não um workflow — os prompts que você dá no dia 1 é que transformam o repo em... — [[17-prompts-that-make-hermes-run-while-you-sleep-copy-paste-inside]]
