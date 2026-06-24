---
title: rohitg00/agentmemory: Persistent Memory for Coding Agents
type: source
source: Clippings/rohitg00agentmemory 1 Persistent memory for AI coding agents based on real-world benchmarks.md
created: 2026-05-15
ingested: 2026-05-15
tags: [ai-agents]
triagem_score: 8
---

## Tese central
agentmemory = implementação do LLM Wiki pattern de Karpathy estendido com confidence scoring, lifecycle, knowledge graph e hybrid search.

## Key insights
- Funciona com qualquer agente via hooks/MCP/REST: Claude Code (12 hooks + plugin), Codex CLI (6 hooks), OpenClaw, Hermes, pi, Cursor, Gemini CLI, OpenCode, Cline.
- Install: `npm i -g @agentmemory/agentmemory` → server :3111 → `agentmemory connect claude-code`.
- Todos os agentes compartilham mesmo memory server — memória persistente cross-agent, cross-session.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/learning-cognition/karpathy-four-principles]]

---

## O LLM Wiki Pattern de Karpathy

Andrej Karpathy propôs que agentes de IA deveriam manter um "wiki" — arquivo de texto simples que cresce incrementalmente com fatos aprendidos. Cada vez que o agente descobre algo útil, adiciona ao wiki. A cada nova sessão, o wiki é incluído no contexto.

**Limitações do pattern original:**
- Append-only: contradições não são resolvidas, fatos desatualizados permanecem.
- Sem estrutura: busca linear no arquivo cresce lentamente com O(n).
- Sem lifecycle: memórias nunca expiram, mesmo quando irrelevantes.
- Sem priorização: todos os fatos têm mesmo peso independente de frequência de uso.

**agentmemory resolve cada limitação:**

### Confidence Scoring
Cada memória tem score de confiança (0.0–1.0) que aumenta quando confirmada por múltiplas sessões e diminui quando contradita ou não usada. Memórias com score <0.3 são marcadas como "uncertain" e apresentadas ao agente com disclaimer.

Formula de atualização: `confidence = confidence * (1 - decay) + evidence * learning_rate`

### Lifecycle Management
Memórias têm estados: `active`, `stale`, `archived`, `conflicted`. O sistema monitora last_access e decai automaticamente memórias não acessadas. Memórias `archived` não são carregadas no contexto mas ficam disponíveis para busca explícita.

### Knowledge Graph
Além de armazenar memórias como texto, o sistema mantém grafo de relações entre entidades. Permite queries como "o que sei sobre X que está relacionado a Y?" — impossível com texto plano.

### Hybrid Search
Combina BM25 (keyword matching exato, rápido) com embeddings (semântico, mais lento). Para queries exatas (nomes de funções, erros específicos), BM25 domina. Para queries semânticas ("como fazer autenticação neste projeto"), embeddings dominam. O peso entre os dois é ajustável por query type.

---

## Arquitetura Técnica

```
[Agent] → [hooks/MCP/REST] → [agentmemory server :3111] → [SQLite + vector store]
                                         ↓
                              [Knowledge Graph (Neo4j-like)]
                              [Hybrid Search Index]
                              [Lifecycle Manager]
```

**Claude Code integration (12 hooks):**
- `PreToolUse`: Busca memórias relevantes antes de cada tool call.
- `PostToolUse`: Extrai e salva memórias de resultados de ferramentas.
- `Stop`: Consolida memórias da sessão, atualiza confidence scores.
- 9 hooks adicionais para casos específicos (file read, bash exec, etc.)

**REST API** permite integração com qualquer agente que não suporte hooks nativos. Endpoints: `POST /memories`, `GET /memories/search`, `DELETE /memories/:id`, `PUT /memories/:id/confidence`.

---

## Cross-Agent Memory Sharing

O modelo mais poderoso: múltiplos agentes compartilham o mesmo servidor agentmemory. Claude Code aprende que "a função X tem bug na linha 42" → Codex CLI acessa a mesma memória → Cursor também tem acesso.

Isso cria **memória organizacional** — não só por sessão ou por agente, mas por projeto, persistindo além da sessão de qualquer agente individual.

**Riscos:** Memória incorreta de um agente polui o contexto de outros. O confidence scoring mitiga isso — memória de baixa confiança não é carregada automaticamente.

---

## Comparação com Alternativas

| Sistema | Persistence | Cross-agent | Confidence | Knowledge Graph |
|---|---|---|---|---|
| CLAUDE.md (vanilla) | Entre sessões | Não | Não | Não |
| Mem0 | Entre sessões | Não | Sim (temporal) | Não |
| agentmemory | Entre sessões | Sim | Sim | Sim |
| hot.md (vault) | Entre sessões | Manual | Não | Via wikilinks |

---

## Limitações

- Servidor adicional: operacional overhead de manter :3111 rodando.
- SQLite não escala bem acima de ~100k memórias — para projetos grandes, migrar para PostgreSQL.
- Confidence scoring precisa de calibração: taxa de learning_rate e decay depende do domínio.
- Knowledge graph adiciona complexidade: queries relacionais são poderosas mas difíceis de debugar.

---

## Aplicação no Vault-Michel

O vault usa variante manual deste pattern: `hot.md` é o "wiki" de alta confiança, `errors.md` captura aprendizados negativos, e wikilinks entre conceitos formam o knowledge graph. agentmemory seria upgrade natural para o vault quando o volume de memórias justificar automação.

---

## Conexões

- [[03-RESOURCES/sources/memory-context-rag/clipping-memory-is-state-not-a-service]] — debate filosófico sobre onde vive a memória
- [[03-RESOURCES/sources/memory-context-rag/mem0-temporal-reasoning-memory-decay]] — abordagem alternativa com temporal reasoning
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
