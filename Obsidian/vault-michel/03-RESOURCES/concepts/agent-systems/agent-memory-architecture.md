---
title: agent-memory-architecture
type: concept
status: developing
tags: [agent-memory, episodic, semantic, procedural, vector, graph, cognee]
created: 2026-04-17
updated: 2026-05-19
---

# Agent Memory Architecture

Estrutura de como agentes persistem, organizam e recuperam informação entre sessões. Memória não é sobre cramear mais texto no prompt — é sobre estruturar o que o agente lembra para encontrar o que importa.

## Framework Cognitivo (Lilian Weng, 2023)

**Agent = LLM + Memory + Planning + Tool Use**

Memória humana → componentes de agentes:

| Humano | Agente |
|--------|--------|
| Sensory (fração de segundo) | Input imediato / tokens atuais |
| Working (7±2 items) | Context window |
| Long-term (sem limite prático) | Persistência externa |

## Tipos de Memória Long-Term

- **Episódica**: eventos específicos passados ("na terça, o cluster PostgreSQL caiu")
- **Semântica**: fatos e conceitos ("PostgreSQL é um banco relacional")
- **Procedural**: skills e workflows ("quando usuário pede reembolso, verificar data da compra primeiro")

**Memory consolidation**: o agente destila eventos episódicos repetidos em conhecimento semântico geral. Sem consolidação, o agente replay eventos individuais em vez de aprender.

## 4 Camadas de Implementação

### Layer 1: Lista Python
- Funciona para multi-turn básico
- Morre com o processo; cresce unbounded

### Layer 2: Markdown Files
- Persistência entre sessões; legível por humanos; Git-friendly
- Claude Code usa esse padrão (CLAUDE.md / MEMORY.md)
- Limite de escala: com 2000+ fatos, keyword search é frágil (sinônimos falham)
- **"Storage sem retrieval inteligente é uma biblioteca sem catálogo"**

### Layer 3: Vector Search
- Resolve sinônimos via embeddings
- Problema estrutural: queries multi-hop falham
- "Was Alice's project affected by Tuesday's outage?" — o fato-ponte não aparece

### Layer 4: Graph-Vector Híbrido
- Combina 3 paradigmas: relational (proveniência) + vector (semântica) + graph (relacionamentos)
- Queries multi-hop funcionam via travessia de grafo
- Implementação: [[Cognee]]

## Estrutura .agent/memory/

```
memory/
├── working/          # estado volátil da tarefa atual
│   ├── WORKSPACE.md
│   └── ACTIVE_PLAN.md
├── episodic/         # o que aconteceu em runs anteriores
│   └── AGENT_LEARNINGS.jsonl
├── semantic/         # abstrações que sobrevivem episódios
│   ├── LESSONS.md
│   ├── DECISIONS.md
│   └── DOMAIN_KNOWLEDGE.md
├── personal/         # preferências do usuário
│   └── PREFERENCES.md
└── auto_dream.py     # compressão noturna episódico→semântico
```

## Auto Dream / Memory Consolidation

Nightly cycle que comprime o que o agente aprendeu no dia: episodic → semantic. Claude Code tem AutoDream primitivo que comprime contexto acumulado. Cognee tem `memify()` com otimização RL-inspired.

**Dreams (Anthropic, API formal — jun/2026):** a Anthropic formalizou esse exato padrão como produto em Claude Managed Agents. Um `dream` é um job assíncrono que lê uma memory store + 1-100 sessões e produz uma **nova** store separada (input nunca modificado): duplicatas mescladas, entradas obsoletas substituídas, insights novos surfaced. Lifecycle de 5 estados (`pending→running→completed/failed/canceled`), `instructions` como guia de síntese de alto nível (não editor de texto pontual), custo linear com nº/tamanho de sessões, limite de 100 sessões/dream. É evidência direta a favor do argumento de Xu et al. (C-engineering) logo abaixo — Dreams opera inteiramente em C-space (reorganiza texto/contexto), não atualiza pesos. Ver [[03-RESOURCES/sources/dreams]] (referência de API completa), [[03-RESOURCES/sources/ml-research-papers/rlancemartin-outcomes-dreaming-managed-agents]] (mecânica conceitual), [[03-RESOURCES/sources/ai-agents-harness/anthropic-dreaming-claude-managed-agents-setup]] (setup prático).

## 7 Failure Modes sem Memória

1. Context amnesia
2. Zero personalização
3. Falha em tarefas multi-step
4. Erros repetidos
5. Sem acumulação de conhecimento
6. Alucinação por context overflow
7. Colapso de identidade

## Ver também

- [[context-engineering]]
- [[resolver-pattern]]
- [[knowledge-compounding]]
- [[claude-agent-harness-architecture]]
- [[memory-transfer-learning]] — como memórias cross-domain melhoram agentes (MTL, ICML 2025)
- [[03-RESOURCES/concepts/llm-ml-foundations/kv-cache-llms]] — mecanismo de cache de ativações K/V; hot.md como implementação prática de semantic memory caching

## Entidades Relacionadas

- [[Cognee]] — implementação graph-vector open-source
- [[claude-mem]] — persistência SQLite+Chroma para Claude Code

## Organizational-Scale Extension

At organizational scale, the same layers apply but add constraints absent from coding-agent models: provenance (who created/modified/owns an artifact), permissions (who can see it), freshness signals, and cross-tool relationship traversal. This is described as a [[03-RESOURCES/concepts/pkm-obsidian/semantic-file-system]] in the [[03-RESOURCES/concepts/pkm-obsidian/company-brain]] framework.

- [[03-RESOURCES/concepts/llm-ml-foundations/factual-memory]] — Layer 1 of Company Brain; org-scale semantic memory with provenance and permissions

## Implementação com hierarquia estruturada: MemPalace

[[03-RESOURCES/entities/MemPalace]] adiciona uma dimensão ao Layer 3 (vector search): em vez de corpus flat, organiza em **wings → rooms → drawers** (pessoas/projetos → tópicos → conteúdo verbatim). Armazena texto original sem sumarização. Benchmark: 96.6% R@5 no LongMemEval com zero API key. MCP server com 29 ferramentas. Ver [[03-RESOURCES/sources/memory-context-rag/mempalace-open-source-ai-memory]].

## C-Engineering vs. θ-Engineering (Xu et al., 2026)

Xu et al. formalize a critical distinction for all memory systems: [[03-RESOURCES/concepts/ai-strategy-org/c-theta-engineering]].

**All deployed agentic memory is C-engineering** (context manipulation). The "Episodic" row in the table above is all that exists in production. The "Experiential" row (fine-tuning on agent experience) is the **missing half**.

Key consequences:
- **Generalization Gap**: retrieval needs Ω(k²) stored compositions; fine-tuning needs O(d/δ). Gap is independent of context window size.
- **Frozen Novice**: agents accumulate notes but never develop expertise — each session starts from identical frozen weights.
- **Security compounding**: injected content in episodic store propagates across all future sessions (evil²).

The fix: a **consolidation channel** from episodic store → weights, running asynchronously (like biological sleep). Building blocks exist: LoRA, MEMIT, TTT layers.

> [!contradiction]
> The "Memory Consolidation" concept described above (auto_dream.py, Cognee memify) operates in **C-space** (compresses text, not weights). Xu et al. (2026) argue this is insufficient — true consolidation must update θ, not just reorganize context. The existing auto_dream pattern is a better-organized filing cabinet, not expertise.

## Implementação de referência: agentmemory

[[03-RESOURCES/entities/agentmemory]] é a implementação mais completa deste padrão em produção (2026-05-16, trending +1,879 stars). Usa triple-stream retrieval (BM25 + vector + graph com RRF fusion), 4-tier consolidation (Working/Episodic/Semantic/Procedural), e decaimento por curva de Ebbinghaus. Benchmark: **95.2% R@5** no LongMemEval-S — superior ao MemPalace (96.6% R@5 diferente benchmark), mem0 (68.5%) e Letta (83.2%). Zero dependências externas (SQLite + iii-engine). Ver [[03-RESOURCES/sources/memory-context-rag/agentmemory-persistent-coding-agent]].

## Memory Curse — Trade-off Cooperação vs. Recall

> [!contradiction]
> **Memory Curse** (CMU/Harvard/Michigan, 2026): expandir memória episódica em agentes MAS aumenta **defecção**, não cooperação. Agentes com recall longo lembram de traições passadas → retaliação dominante. Mais memória ≠ sistema cooperativo melhor.
> Implicação: Layer 2/3 (episodic + semantic) devem ter políticas de decay **agressivas** em contexts multi-agente. Decay de Ebbinghaus (agentmemory) e archiving 90 dias (dream cycle) são mitigadores parciais, não solução total.

→ [[03-RESOURCES/sources/memory-context-rag/memory-curse-expanded-recall-cooperative-intent]]

## Memory = Skills = Harness

**Memory e skills não são camadas separadas** — são o mesmo harness em fases distintas (retrieval vs. execução). Tratar como plugins independentes gera fragmentação e duplicação de storage layer.

Consequência arquitetural: unificar storage/retrieval/exec em uma estrutura = [[03-RESOURCES/concepts/agent-systems/agent-harness]].

→ [[03-RESOURCES/sources/memory-context-rag/memory-skills-same-harness-tricalt]]

## δ-mem: Eficiência de Atualização Incremental

Alternativa à re-codificação total: δ-mem (NTU/Fudan/SJTU) atualiza memória de forma **incremental** (delta updates) sem re-processar todo histórico — endereça o problema de custo das Layers 2-3 em agentes de longa duração.

→ [[03-RESOURCES/sources/memory-context-rag/delta-mem-efficient-online-memory]]

## Memory Lifecycle (Mercury / Remember-Cite-Forget)

Context window ≠ memória. Stanford "Lost in the Middle": modelos lutam para recuperar informação **no meio** de contextos longos, mesmo dentro dos limites. Solução: memória como lifecycle, não storage.

**3 operações fundamentais (framework remember/cite/forget):**
- **Remember** — o que merece persistir (projetos, preferências, decisões, falhas)
- **Cite** — trazer de volta contextualmente, não integralmente
- **Forget** — purgar o que não agrega; memória infinita = ruído

**Mercury Second Brain:**
- **Consciente** (hot): working context, task state, current decisions — carregado ativamente
- **Subconsciente** (archive): padrões, histórico, preferências — retrievado contextualmente
- Sem este split, cada sessão = reconstrução. Agente que não lembra = encontra você pela primeira vez toda vez.

**EvolveMem (+25.7% LoCoMo):** reflexão contínua via LLM, não só storage — memória que melhora com uso.

→ [[03-RESOURCES/sources/ai-agents-harness/clipping-mercury-agent-memory-layers]]
→ [[03-RESOURCES/sources/memory-context-rag/framework-agent-memory-remember-cite-forget]]
→ [[03-RESOURCES/sources/memory-context-rag/evolvemem-self-evolving-memory-architecture]]

---

## Retrieval-Over-Context-Size: Single Grain Evidence

Single Grain's 90+ agent fleet found that persistent memory files consuming 40% of context window made agents "technically smarter but operationally much messier." The fix: retrieval layer that surfaces the 6 task-relevant context pieces, not the entire history. Confirms that memory architecture without a purpose-built retrieval layer degrades to noise at production scale (500K+ tokens, 2,862 call transcripts).

→ [[03-RESOURCES/sources/memory-context-rag/how-we-built-single-company-brain]]

## Taxonomia Formal TsinghuaC3I (2026)

Classificação por **persistência** e **dependência de outcomes**:

```
Short-Term Memory
  └── Informação transitória dentro do context window (tarefa única)

Long-Term Memory
  ├── Memory: informação sem referência a outcomes de tarefas
  │     └── Aplicações: Personalization (perfis, histórico, fatos)
  └── Experience: conhecimento validado por outcomes (success/failure)
        └── Aplicações: Learning from Experience (trajetórias, skills, lições)
```

**Mapeamento para vault-michel:**
| Tipo TsinghuaC3I | Componente vault |
|-----------------|-----------------|
| Short-Term | `hot.md` (TTL implícito) |
| Long-Term Memory | `03-RESOURCES/sources/` |
| Experience | `04-SYSTEM/wiki/errors.md` |

**Implicação:** `errors.md` já é "Experience Memory" formal — accumula outcomes (erros confirmados) para evitar repetição. hot.md é ST Memory com eviction implícita por comprimento.

→ [[03-RESOURCES/sources/memory-context-rag/tsinghua-awesome-memory-agents-paper-list]]

## Fontes

- [[03-RESOURCES/sources/memory-context-rag/build-agents-that-never-forget]]
- [[03-RESOURCES/sources/ai-agents-harness/ai-agent-stack-2026]]
- [[03-RESOURCES/sources/memory-context-rag/clipping-company-brain-part-2-factual-memory]]
- [[03-RESOURCES/sources/memory-context-rag/agentmemory-persistent-coding-agent]]
- [[03-RESOURCES/sources/memory-context-rag/mempalace-open-source-ai-memory]]
- [[03-RESOURCES/sources/memory-context-rag/contextual-agentic-memory-is-a-memo]] — formalizes C/θ distinction, proves Generalization Gap
- [[03-RESOURCES/sources/memory-context-rag/memory-curse-expanded-recall-cooperative-intent]] — Memory Curse paradox (MAS cooperative degradation)
- [[03-RESOURCES/sources/memory-context-rag/delta-mem-efficient-online-memory]] — incremental memory updates, no re-encoding
- [[03-RESOURCES/sources/memory-context-rag/memory-skills-same-harness-tricalt]] — memory ≡ skills = same harness primitive
- [[03-RESOURCES/sources/dreams]] — referência oficial de API para Dreams (Managed Agents): lifecycle, instructions, erros, billing, limites
- [[03-RESOURCES/sources/memory-architecture-github-copilot]] — caso de produção (GitHub Copilot): memória como objeto estruturado (subject/fact/citations/reason) com citação ancorada a código, verificada just-in-time, sliding expiry de 28 dias; PR merge rate 83%→90% (A/B real)

## Evidências
- **[2026-06-19]** LoopState como memória explícita de curto prazo (failure_patterns, success_patterns) separada do histórico de conversa, que é truncado para evitar context overflow em loops externos longos — [[how-to-apply-loop-engineering-to-quantitative-research-complete-guide-with-code]]
- **[2026-06-19]** Arquitetura em camadas (superfícies → agente → API interna autenticada → DB → conectores externos) com memória de longo prazo injetada nas instruções do agente a cada início de sessão — [[03-RESOURCES/sources/vercel-labs-personal-agent-template]]
- **[2026-06-19]** Grafo Cue-Tag-Content (MRAgent): memória reconstruída via navegação ativa multi-passo (não retrieve-then-reason), 5,4x menos tokens que A-Mem no LONGMEMEVAL; ganho vem da combinação estrutura+reasoning, não da estrutura isolada — [[03-RESOURCES/sources/graph-memory-reconstruction-for-llms]]
- **[2026-06-21]** A maioria dos usuários de Hermes Agent fica no nível 1 (chatbot, one-shot prompts) e usa só ~10% do potencial do agente. O artigo mapeia 15 níveis progressivos em 3 fases — fundação, paralelismo/memória e autonomia 24/7 — cada um com set... — [[15-levels-of-hermes-agent-from-chatbot-to-247-autonomous-system]]

- **[2026-06-22]** Sem camada de memória, agente redescobre e re-aprende a mesma correção toda conversa; com memória, melhora monotonicamente em perguntas recorrentes (caso Skipper/Cloudflare) — [[03-RESOURCES/sources/how-we-built-cloudflare-s-data-platform-and-an-ai-agent-on-top-of-it]]

- **[2026-06-24]** tags: — [[governed-shared-memory-for-multi-agent-llm-systems]]
- **[2026-06-24]** 很多 AI 记忆系统，最后都会变成同一种形状：把聊天记录、用户信息、上传文档、工作流结果，全部切成 chunk，塞进向量库里，等下一次需要的时候再 RAG 出来。这当然有用。但问题是，“记得更多”不等于“记得更好”。真正难的是：不同类型的记 — [[wiki-reflection-agent-memory]]
## Perspectivas

- **[2026-06-21]** Paralelismo e memória persistente são tratados como a segunda fase (não a primeira) na progressão de maturidade de um agente — vem depois da fundação, antes da autonomia plena. — [[15-levels-of-hermes-agent-from-chatbot-to-247-autonomous-system]]
