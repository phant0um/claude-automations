---
title: "TsinghuaC3I/Awesome-Memory-for-Agents — A Collection of Papers about Memory for Language Agents"
type: source
source: "Clippings/TsinghuaC3IAwesome-Memory-for-Agents A Collection of Papers about Memory for Language Agents.md"
origin_url: "https://github.com/TsinghuaC3I/Awesome-Memory-for-Agents"
author: "Hongyi Liu, Yu Fu, Kaiyan Zhang et al. (TsinghuaC3I)"
created: 2026-05-31
ingested: 2026-05-31
tags: [source, agent-memory, rag, long-term-memory, short-term-memory, paper-list, benchmark, personalization, learning-from-experience, long-horizon]
---

## Tese central

Repositório curado de papers sobre memória para agentes de linguagem, estruturado por uma taxonomia central: Short-Term Memory (dentro do context window) vs. Long-Term Memory (externa, persistente entre tarefas), com Long-Term subdividida em Experience (validada por outcomes) e Memory (sem referência a outcomes de tarefa).

## Argumentos principais

1. **Taxonomia de memória para agentes:**
   - **Short-Term Memory:** informação transiente dentro do context window para uma única tarefa
   - **Long-Term Memory / Experience:** conhecimento explicitamente validado por outcomes de tarefa (sucesso/falha) — cross-task, transferível
   - **Long-Term Memory / Memory:** informação persistente sem referência a outcomes

2. **Três cenários de aplicação (mapeiam para a taxonomia):**

   | Aplicação | Conteúdo da Memória | Descrição |
   |-----------|---------------------|-----------|
   | Personalization | User profiles, histórico de interação, fatos | Interação contínua personalizada; pool externo com retrieval |
   | Learning from Experience | Trajectories, lessons success/failure, reusable skills | Acumulação e transferência de experiência cross-task |
   | Long-horizon Agentic Task | Intermediate results, reasoning traces, env observations | Context management via summarization, reflection, scratchpad |

3. **Tendências nos papers (2023–2026):** Explosão em 2025–2026 de trabalhos em memória hierárquica, memória episódica, reinforcement learning para memória, KV cache gerenciamento, e self-evolving agents. Mais de 150 papers catalogados.

4. **Papers fundacionais (2023):**
   - MemGPT (→ Letta): LLMs como sistemas operacionais com gerenciamento de memória
   - Reflexion: verbal reinforcement learning via reflexão
   - ExpeL: agentes como aprendizes experienciais
   - MemoryBank: augmentação com memória de longo prazo

5. **Papers recentes de destaque (2025–2026):**
   - Mem0: long-term memory para agentes em produção (2025-04)
   - MemOS (2025-07): Memory OS para AI systems
   - MEM1 (2025-06): synergize memory + reasoning para long-horizon
   - A-MEM (2025-02): agentic memory para LLM agents
   - Zep/Graphiti (2025-01): temporal knowledge graph para agent memory

6. **Benchmarks de memória emergentes (2024–2026):**
   - LongMemEval (2024-10): benchmarking assistants em interactive memory de longo prazo
   - MemBench (2025-06): avaliação mais abrangente de memória de agentes
   - LifelongAgentBench (2025-05): agentes como lifelong learners
   - CloneMem (2026-01): long-term memory para AI clones

7. **Produtos e projetos de infraestrutura (2025–2026):**
   - **Dakera** (2026-05): servidor de memória self-hosted, 87.8% no LoCoMo benchmark, decay-weighted vector recall, hybrid BM25+HNSW, 83 MCP tools, single Rust binary + RocksDB
   - **MisakaNet** (2026-05): git-based distributed swarm memory; cross-agent lesson sync via GitHub Issues
   - **Omnigraph** (2026-04): typed graph DB com branching Git-like; S3-native, Rust, traversal+vector+BM25
   - **Lorg** (2026-03): permanent intelligence archive com quality gate e hash-chaining
   - **Mem0** (2025-04): production-ready scalable long-term memory
   - **Graphiti/Zep** (2025-01): temporal knowledge graph architecture
   - **Letta/MemGPT** (2023-10): LLMs como operating systems

## Key insights

- **Rust como infraestrutura de memória de agentes:** Dakera e Omnigraph, dois dos projetos mais avançados de memória (2026), são escritos em Rust — pattern de escolha por performance e segurança de memória na camada de storage.
- **Git-like versioning para memória de agentes:** MisakaNet e Omnigraph aplicam metáforas git (branch/merge, Issues) para sincronização de memória entre agentes — paradigma emergente.
- **MCP como interface padrão:** Dakera expõe 83 ferramentas MCP — confirma MCP como protocolo de facto para memory infrastructure.
- **Decay-weighted recall:** Dakera implementa decay de relevância temporal — memórias recentes têm peso maior, memórias antigas decaem (biomimética).
- **RAG está sendo superado:** projetos como SuperLocalMemory V2 (dual MCP+A2A), A-MEM, e papers de graph-based retrieval sugerem movimento além de RAG simples para memória tipada, causal, e temporal.
- **LoCoMo como benchmark de referência:** Dakera cita 87.8% nele; LoCoMo é "Evaluating Very Long-Term Conversational Memory" (2024-02).

## Exemplos e evidências

- 150+ papers catalogados de 2020 a 2026, com explosão em 2025–2026.
- Reflexion (2023-03): primeiro paper a usar "verbal RL" — agentes melhoram via reflexão em linguagem natural.
- MemGPT (2023-10): fundou o paradigma de OS-like memory management para LLMs.
- Dakera: 83 MCP tools em single Rust binary com RocksDB persistence.
- Survey 2025-05: "Rethinking Memory in AI: Taxonomy, Operations, Topics, and Future Directions" — survey abrangente.

## Implicações para o vault

- Referência central para domínio de `memory-context-rag` — pode ser linked de múltiplas páginas de agentes.
- Dakera e MisakaNet são infraestruturas novas que merecem páginas de entidade.
- Confirma e expande `[[03-RESOURCES/concepts/llm-ml-foundations/factual-memory]]` e conceitos relacionados.
- O padrão Rust+RocksDB para storage de memória de agentes conecta ao Rust book.
- MCP como interface de memória reforça `[[03-RESOURCES/entities/Claude Code]]` e arquitetura de agentes do vault.
- Graphiti/Letta já podem ter páginas no vault (verificar).

## Links

- [[03-RESOURCES/concepts/llm-ml-foundations/factual-memory]]
- [[03-RESOURCES/concepts/llm-ml-foundations/memory-transfer-learning]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-window]]
- [[03-RESOURCES/sources/memory-context-rag/anatomy-of-llm-interactive-visual-guide]]
- [[03-RESOURCES/sources/ml-research-papers/the-rust-programming-language-book]]
