---
title: Agentic Reasoning
type: concept
status: developing
created: 2026-05-01
updated: 2026-06-20
tags: [concept, agentic-reasoning, ai, agents, llm, tool-use, chain-of-thought, planning]
---

# Agentic Reasoning

Como agentes raciocinam: estratégias de planejamento, chain-of-thought, e tomada de decisão em contextos de múltiplos passos com ferramentas externas.

## Definition

Agentic reasoning is the capability of an LLM to **plan and execute multi-step tasks using external tools** without human intervention between steps. The model must:

1. **Understand task decomposition** — break a goal into steps
2. **Select appropriate tools** — decide which actions to invoke
3. **Interpret tool outputs** — update internal state based on feedback
4. **Continue planning** — adjust strategy based on results

## O Problema Central

LLMs padrão respondem a perguntas. Agentes resolvem tarefas — sequências de ações com estado, falha, e incerteza. A diferença está na qualidade do raciocínio intermediário.

## Estratégias de Raciocínio

### Chain-of-Thought (CoT)

Raciocínio explícito antes da ação. "Antes de chamar a tool, penso em voz alta."

- Melhora accuracy em tarefas multi-step
- Torna raciocínio auditável (o que deu errado?)
- Custo: tokens extras antes da ação

### ReAct (Reason + Act)

Loop: **Thought** → **Action** → **Observation** → **Thought** → ...

```
Thought: Preciso encontrar a função login no codebase
Action: bash("grep -r 'def login' src/")
Observation: src/auth/views.py:45
Thought: Encontrei. Vou ler o arquivo nessa linha.
Action: Read("src/auth/views.py", offset=40, limit=20)
```

Vantagem: cada ação é precedida de raciocínio — erros são detectados cedo.

### Tree-of-Thought (ToT)

Expande múltiplos "ramos" de raciocínio antes de escolher. Análogo a MCTS (Monte Carlo Tree Search).

- Melhor em puzzles e problemas de planejamento complexo
- Mais caro: N raciocínios em vez de 1
- Uso no vault: plan mode com alternativas explícitas

### Self-Consistency

Gera K caminhos de raciocínio independentes → vota na resposta majoritária. Reduz alucinações em tarefas factuais.

### Reflexão e Autocrítica

Agente avalia próprio output antes de entregar:
1. Gera resposta
2. Pergunta: "O que está errado aqui?"
3. Corrige
4. Entrega

Implementado em `verify` e `review` do vault.

## Core Skills

- **Tool-use:** Invoking APIs, commands, file operations
- **Error handling:** Recovering from failed tool calls
- **Long-horizon reasoning:** Maintaining goal state across 5-20+ steps
- **Verification:** Checking intermediate results match expectations
- **Backtracking:** Undoing failed paths and trying alternatives

## Planejamento Antes de Execução

Para tasks não-triviais (3+ passos, multi-source, reestruturação):
1. **Entrar em plan mode** — listar passos, confirmar escopo
2. **Gerar sub-tasks** — dependências explícitas
3. **Executar** — checar estado após cada passo
4. **Replanejar** — se estado inesperado → parar e reavaliar

Regra do vault (Karpathy Princípio 1): *Think before acting. If ambiguous: state assumption explicitly and ask before acting.*

## Raciocínio sob Incerteza

| Situação | Estratégia |
|----------|------------|
| Instrução ambígua | Estado assumption explícita → pergunta |
| Estado inesperado | Para → replaneja (não força) |
| Conflito de memória | Citation order: instrução direta > policy > memória antiga |
| Falha de tool | 3 tentativas diferentes → escalona para humano |

## Agentic Training

Models optimized for agentic reasoning require:

1. **Diverse RL environments** — training on varied task types (terminal, web, APIs, file systems)
2. **Multi-step trajectories** — SFT data with explicit planning → execution → verification
3. **Tool-specific corpora** — code, terminal output, API documentation
4. **Failure modes** — safe error recovery without user intervention

**Example:** Nemotron 3 Super trained on OpenHands (software engineering), terminal commands, and general tool-use benchmarks.

## Metrics

- **Success rate** on benchmark tasks (e.g., SWE-Bench, OpenHands)
- **Steps-to-completion** (lower = more efficient planning)
- **Error recovery rate** (what % of failures lead to recovery vs giving up)
- **Tool invocation accuracy** (correct API calls vs hallucinated calls)

## Limites do Raciocínio Agentico

- **Context drift**: raciocínio de turn 1 some após compressão — decisões importantes devem ser escritas em arquivo
- **Alucinação de estado**: agente "lembra" o que não aconteceu — ler estado real, não assumir
- **Over-planning**: plano detalhado para task de 2 min é desperdício
- **Reasoning collapse**: modelos menores colapsam CoT em respostas diretas sem raciocinar

## No Vault

- **Plan mode** (`/plan`) — raciocínio explícito antes de mudanças grandes
- **Karpathy 4P** — think before acting, simplicity first, surgical changes, verify before done
- **hot.md** — contexto quente reduz raciocínio redundante a cada sessão
- **errors.md** — raciocínios que falharam → não repetir

## Evidências

- **[2026-06-19]** Agente adapta espontaneamente composição de ferramentas ao tipo de pergunta espacial, sem prompt ou roteamento específico por categoria — [[03-RESOURCES/sources/spatialclaw-rethinking-action-interface]]
- **[2026-06-21]** ToRL treina LLMs para usar computational tools via RL diretamente de base models (sem SFT prévio). ToRL-7B alcança 43.3% em AIME24 (+14% vs RL sem tools, +17% vs melhor TIR model). Cognitive behaviors emergem sem instruction: strategic t... — [[torl-scaling-tool-integrated-rl]]

## Links / Related Concepts

- [[03-RESOURCES/concepts/agent-systems/agent-patterns]] — catálogo de padrões
- [[03-RESOURCES/concepts/agent-systems/agentic-patterns]] — padrões de execução detalhados
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/tool-use-behavior-opus47]]
- [[03-RESOURCES/concepts/multi-step-planning]]
- [[03-RESOURCES/concepts/reasoning-models]] — modelos com extended thinking
- [[03-RESOURCES/concepts/parallel-reasoning]] — raciocínio paralelo
- [[03-RESOURCES/concepts/learning-cognition/karpathy-four-principles]] — princípios de execução no vault

**Sources:** [[03-RESOURCES/sources/ml-research-papers/nemotron-3-super-hybrid-mamba-attention-moe]]
