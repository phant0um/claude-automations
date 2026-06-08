---
title: "Agentic Reasoning"
type: concept
created: 2026-05-31
updated: 2026-05-31
tags: [concept, agentic-reasoning, chain-of-thought, planning, tool-use]
status: developing
---

# Agentic Reasoning

Como agentes raciocinam: estratégias de planejamento, chain-of-thought, e tomada de decisão em contextos de múltiplos passos com ferramentas externas.

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

## Links

- [[03-RESOURCES/concepts/agent-systems/agentic-patterns]] — padrões de execução detalhados
- [[03-RESOURCES/concepts/reasoning-models]] — modelos com extended thinking
- [[03-RESOURCES/concepts/parallel-reasoning]] — raciocínio paralelo
- [[04-SYSTEM/agents/agent-patterns]] — catálogo de padrões
- [[03-RESOURCES/concepts/learning-cognition/karpathy-four-principles]] — princípios de execução no vault
