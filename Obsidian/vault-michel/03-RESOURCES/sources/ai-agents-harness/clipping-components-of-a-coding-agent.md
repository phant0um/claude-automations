---
title: "Components of A Coding Agent"
type: source
source: clipping
created: 2026-05-01
updated: 2026-05-01
tags: [clipping, ai-agents, tools]
triagem_score: 8
---

# Components of A Coding Agent

**Source File:** Components of A Coding Agent.md  
**Size:** 25523 bytes

## Summary

--- title: "Components of A Coding Agent" source: "https://magazine.sebastianraschka.com/p/components-of-a-coding-agent" author: - "[[Sebastian Raschka]]" - "[[PhD]]" published: 2026-04-04 created: 2026-04-27 description: "How coding agents use tools, memory, and repo context to make LLMs work better in practice" tags: - "clippings" --- ### How coding agents use tools, memory, and repo conte

---

**Original Location:** `Clippings/Components of A Coding Agent.md`

---

## Visão Geral — Sebastian Raschka sobre Coding Agents

Sebastian Raschka (PhD, Staff Research Engineer @ Lightning AI) publicou este artigo em abril de 2026 como análise aprofundada dos blocos construtivos que diferenciam um coding agent eficaz de um LLM simples com acesso a ferramentas. A tese central: **a soma das partes importa mais que o modelo base** — um harness bem projetado com Claude Sonnet supera um harness ruim com Claude Opus.

---

## Os Componentes Principais

### 1. Context Management (Gestão de Contexto)

O context window é o recurso mais escasso de um coding agent. Raschka descreve 3 camadas de context management:

- **In-context:** O que está literalmente no prompt. CLAUDE.md, arquivos lidos, histórico de tool calls.
- **In-cache:** Prompt caching (KV cache) para porções estáticas do prompt. CLAUDE.md deve ser posicionado no início para maximizar cache hits.
- **External:** Arquivos no disco, banco de dados, resultados de busca — recuperados sob demanda.

A decisão crítica é quais informações promover de external → in-cache → in-context. Agentes que jogam tudo no contexto desperdiçam tokens; agentes que deixam muito externo fazem retrieval excessivo.

### 2. Tool Use (Uso de Ferramentas)

Coding agents precisam de ferramentas primitivas de baixo nível, não de ferramentas de alto nível abstratas. Raschka identifica o conjunto mínimo:

- **Read file / Write file:** Básico mas crítico — agente deve poder ler e modificar código.
- **Bash/Terminal:** Executar comandos (testes, linters, compiladores). Feedback real do ambiente.
- **Search (grep/ripgrep):** Encontrar símbolos, padrões, ocorrências. Mais confiável que embeddings para código.
- **Web fetch:** Para documentação, issues, PRs. Agente deve poder pesquisar o que não sabe.

**Anti-pattern:** Ferramentas de "alto nível" que combinam múltiplas operações (ex: "refactor_function") removem controle do agente e dificultam debugging.

### 3. Memory Architecture

Raschka categoriza memória em 4 camadas (alinhado com [[03-RESOURCES/concepts/agent-systems/agent-memory-four-layers]]):

1. **In-context:** Histórico da sessão atual.
2. **External (episódic):** Logs de sessões anteriores, decisões tomadas.
3. **Procedural (skills/CLAUDE.md):** Como fazer tarefas — persiste entre sessões.
4. **Semantic (knowledge base):** Fatos sobre o codebase — pode ser grep-indexed ou embedding-indexed.

### 4. Repo Context

Para operar em um codebase, o agente precisa de contexto estrutural que vai além de ler arquivos individuais:

- **CLAUDE.md / README:** Convenções, arquitetura, comandos frequentes.
- **Dependency graph:** Quem importa quem. Permite entender impacto de mudanças.
- **Test coverage map:** Quais arquivos têm testes. Guia onde gerar testes faltantes.
- **Git history:** Por que uma decisão foi tomada. `git blame` como memória episódica.

### 5. Planning e Decomposição

Coding agents eficazes planejam antes de agir. Raschka descreve o padrão:

1. Entender o task completo antes de escrever código.
2. Decompor em subtasks menores com critérios de sucesso claros.
3. Identificar dependências entre subtasks.
4. Executar com auto-verificação (rodar testes) após cada subtask.

**Problema comum:** Agentes que começam a editar arquivos imediatamente sem plano acabam em estados inconsistentes que são difíceis de reverter.

### 6. Self-Verification

Todo coding agent precisa verificar seu próprio trabalho:

- Rodar testes automaticamente após mudanças.
- Checar que o código compila.
- Verificar lint/formatação.
- Re-ler arquivos editados para confirmar que o diff é correto.

Agentes sem self-verification entregam código que "parece certo" mas quebra em runtime.

---

## Harness vs. Modelo — A Insight Principal

O artigo conclui com a mesma tese de HALO e Claude Code: o harness (conjunto de ferramentas, context management, planning strategy) determina mais o desempenho que o tamanho do modelo. Evidência: coding agents com modelos menores mas harnesses bem projetados superam agentes com modelos maiores e harnesses pobres em benchmarks SWE-bench.

---

## Comparação com Outros Frameworks

| Framework | Foco principal | Diferencial |
|---|---|---|
| Claude Code | Harness completo | CLAUDE.md + hooks + skills |
| Codex CLI | Minimalismo | Terminal-first, sem UI |
| Cursor | UX/Editor | IDE integration |
| Devin | Autonomia longa | Long-horizon planning |

---

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-four-layers]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]]
- [[03-RESOURCES/sources/memory-context-rag/grep-vs-embeddings-coding-agents]]
- [[03-RESOURCES/sources/ai-agents-harness/how-claude-code-works-in-large-codebases]]
- [[03-RESOURCES/sources/ml-research-papers/halo-rlm-self-improving-agents]]
