---
title: "Memory Transfer Learning: How Memories are Transferred Across Domains in Coding Agents"
type: source
created: 2026-04-19
tags: [memory, transfer-learning, coding-agents, self-evolving-agents, ICML, ai-research]
authors: [Kangsan Kim, Minki Kang, Taeil Kim, Yanlai Yang, Mengye Ren, Sung Ju Hwang]
institutions: [KAIST, NYU, DeepAuto.ai]
venue: ICML
url: https://memorytransfer.github.io/
triagem_score: 9
---

# Memory Transfer Learning: How Memories are Transferred Across Domains in Coding Agents

## Resumo

Paper ICML da KAIST/NYU/DeepAuto.ai investigando **Memory Transfer Learning (MTL)** — o uso de memórias geradas em tarefas heterogêneas (cross-domain) para melhorar a performance de coding agents. Resultado central: +3,7% de ganho médio em 6 benchmarks ao usar memórias cross-domain com formato Insight.

## Contribuições Centrais

1. **MTL melhora coding agents em média 3,7%** usando memórias de domínios heterogêneos (Pass@3 em 6 benchmarks).
2. **O valor transferível está no meta-conhecimento**, não no código específico: validation routines, inspection-before-editing, minimal-patch strategies.
3. **Abstração dita transferibilidade**: Insight (alto) > Summary > Workflow > Trajectory (baixo). Memórias de baixa abstração causam negative transfer por brittle anchoring.
4. **Escala positiva**: mais memórias no pool e mais domínios → melhor performance.
5. **Cross-model transfer funciona**: memórias de GPT-5-mini melhoram Qwen3-Coder e DeepSeek V3.2, e vice-versa — meta-conhecimento é model-agnostic.

## 4 Formatos de Memória

| Formato | Abstração | Descrição |
|---------|-----------|-----------|
| **Trajectory** | Baixa | Concatenação de comandos + outputs (sem reasoning). Task-specific, propensa a negative transfer. |
| **Workflow** | Média-baixa | Subconjunto de ações relevantes com goal. Mais curto que Trajectory. |
| **Summary** | Média-alta | Parágrafo de experiência: o que aconteceu, por que funcionou/falhou. |
| **Insight** | Alta | Título + descrição + conteúdo generalizável. Sem menção a arquivos/detalhes específicos. |

## Benchmarks Usados

- **LiveCodeBenchv6** — competitive/function-level
- **Aider-Polyglot** — competitive/function-level polyglot
- **SWE-Bench Verified** — repository-level software engineering
- **TerminalBench2** — repository-level CLI tasks
- **ReplicationBench** — scientific paper replication code
- **MLGym-Bench** — machine learning research tasks

## Resultados Principais (GPT-5-mini, Pass@3)

| Benchmark | Zero-shot | MTL (Insight) | Δ |
|-----------|-----------|---------------|---|
| LiveCodeBenchv6 | 0.910 | 0.930 | +2.0% |
| Aider-Polyglot | 0.470 | 0.470 | 0.0% |
| SWEBench-Verified | 0.730 | 0.770 | +4.0% |
| TerminalBench2 | 0.315 | 0.360 | +4.5% |
| ReplicationBench | 0.111 | 0.189 | +7.8% |
| MLGym-Bench | 0.667 | 0.750 | +8.3% |
| **Avg** | **0.523** | **0.560** | **+3.7%** |

MTL com apenas 431 memórias supera AgentKB (5.899 memórias) e ReasoningBank (97 memórias).

## Mecanismo de Transferência — Meta-Conhecimento

Análise LLM + case studies revelam que memórias cross-domain contribuem principalmente via:

1. **Iterative Workflow Discipline** — inspect → edit → verify → submit
2. **Test-Driven Verification** — criar scripts de reprodução quando testes oficiais estão ausentes
3. **Environmental Adaptation** — navegar constraints do OS/shell
4. **Anti-Pattern Avoidance** — evitar one-shot refactors, blind overwrites
5. **API and Interface Compliance** — respeitar function signatures e output schemas
6. **Algorithmic Strategy Transfer** — apenas 5,5% dos ganhos (limitado)

## Negative Transfer — 3 Causas

1. **Domain-mismatched anchoring**: memória superficialmente similar mas estruturalmente irrelevante distorce o raciocínio.
2. **False validation confidence**: memórias de verificação criam loops de auto-confirmação (checks superficiais em vez de critérios formais).
3. **Misapplied best-practice transfer**: padrões de sucesso aplicados indiscriminadamente violam semântica do novo task.

## Modelagem Formal (Apêndice C)

Embedding de memória decomposto em:  
`e(m) = z_inv(m) + z_sp(m)`  
(invariante de domínio + específico de domínio)

Abstraction level A = ‖z_inv‖² / (‖z_inv‖² + ‖z_sp‖²)

**Proposição 1**: Ganho empírico de transferência aumenta estritamente com A.

## Retrieval: Simple Beats Advanced

Curiosamente, embedding similarity simples supera LLM Reranking e Adaptive Rewriting para MTL. Isso sugere que retrieval projetado para cenários estáticos não generaliza bem para ambientes agentic multi-step.

## Sistemas Relacionados

- **ReasoningBank** (Ouyang et al., 2025) — insights in-domain via test-time scaling
- **AgentKB** (Tang et al., 2025) — pool unificado cross-domain (general reasoning + coding)
- **AWM** (Wang et al., 2024) — workflows de web agents
- **ReMe** (Cao et al., 2025) — geração + retrieval + refinement de memória
- **Dynamic Cheatsheet** (Suzgun et al., 2025) — evolving memory com reusable strategies

## Implicação prática: o que escrever na sua MEMORY.md

O resultado central do paper — abstração alta transfere melhor — tem uma implicação direta para como estruturar memórias em agentes do vault-michel. Memórias no formato Insight têm duas propriedades que as tornam transferíveis:

1. **Sem referências a arquivos ou paths específicos.** "Prefira editar arquivos existentes em vez de criar novos" transfere para qualquer projeto. "No arquivo `/src/utils/helpers.py`, o padrão correto é X" não transfere.
2. **Princípio generalizável com título descritivo.** O título serve de índice para retrieval; o conteúdo deve poder ser lido sem contexto do task original.

Para o vault-michel, isso significa que a MEMORY.md global em `~/.claude/projects/.../memory/MEMORY.md` deve conter Insights — não trajetórias de sessões passadas. Trajetórias ficam no histórico de sessão (se necessário), não na memória persistente.

## Por que embedding similarity simples supera LLM reranking para MTL

O paper reporta um resultado contra-intuitivo: retrieval por embedding similarity simples supera LLM Reranking e Adaptive Rewriting na tarefa de MTL. A explicação é que reranking e rewriting foram projetados para retrieval em contextos estáticos (busca em corpus fixo com query single-hop). Em ambientes agentic multi-step, o contexto da tarefa muda a cada tool call, e técnicas projetadas para consultas estáticas ficam desalinhadas com o estado dinâmico do agente.

Isso sugere que para memória de longo prazo em coding agents, manter embedding similarity como método de retrieval é preferível a sistemas mais complexos — pelo menos até que novos métodos específicos para cenários agentic sejam desenvolvidos.

## Negative transfer e sua prevenção

O paper identifica três causas de negative transfer, mas a que tem implicação mais imediata para sistemas de memória reais é a "false validation confidence": memórias de verificação que induzem o agente a fazer checks superficiais acreditando que satisfazem critérios formais. Isso é particularmente perigoso porque não falha ruidosamente — o agente completa com aparente sucesso, mas a verificação foi inadequada.

A contra-medida prática é escrever Insights de verificação com critérios explícitos e mensuráveis: "Sempre rodar a test suite antes de marcar uma tarefa concluída; 'parece correto' não é verificação" é preferível a "Verificar o trabalho antes de finalizar."

## Conceitos Relacionados

- [[03-RESOURCES/concepts/llm-ml-foundations/memory-transfer-learning]] — conceito central deste paper
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — arquitetura mais ampla de memória em agentes
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — contexto de agentes cooperativos
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — gerenciamento do que entra no contexto do agente
