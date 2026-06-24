---
title: "How to Design a Loop That Prompts Your Agent"
type: source
source: "Clippings/How to design a loop that prompts your agent?.md"
url: "https://x.com/amitiitbhu/status/2063983640535847093"
author: "@amitiitbhu (Amit Shekhar)"
org: "Outcome School"
published: 2026-06-08
created: 2026-06-09
ingested: 2026-06-09
category: ai-agents
tags: [ai-agents, agent-loops, loop-design, tutorial, agentic-systems]
---

# How to Design a Loop That Prompts Your Agent

## Tese central

Um único prompt não é suficiente para tarefas reais de múltiplos passos. A habilidade nova não é escrever o prompt perfeito — é construir o sistema que continua prompting o agente por conta própria até o trabalho estar concluído. Esse sistema é o **loop**.

> "A prompt is a single move. A loop is a strategy."

## Argumentos principais

1. Single prompts não escalam — tarefas reais exigem ciclos (escrever código → rodar testes → ler erro → corrigir → repetir).
2. O loop escreve os próximos prompts automaticamente a partir do estado do sistema, sem intervenção humana.
3. O custo real não está em gerar a resposta uma vez; está no número de turns que o loop executa — stop conditions são essenciais.
4. Skills reutilizáveis dentro do loop evitam que o modelo resolva o mesmo problema do zero a cada turn.

## Key insights — 5 partes do loop

### Parte 1: Define What "Done" Looks Like
Escrever a verificação de conclusão **em código** antes de qualquer outra coisa. O loop chama essa função após cada turn.
```python
def is_done(result):
    return result.tests_passed
```
Sem esse check em código, o loop não sabe quando parar.

### Parte 2: Build the Context, Not the Instruction
Não digitar cada instrução manualmente. Construir o prompt a partir do **estado atual do sistema**: arquivos, ferramentas disponíveis, logs de erro da última run, tentativas anteriores.
```python
def build_prompt(state):
    return f"""
    Goal: {state.goal}
    Files: {state.files}
    Last error: {state.last_error}
    Past attempts: {state.past_attempts}
    Decide the next step and make the change.
    """
```
O loop é constante; só o contexto muda.

### Parte 3: Let the Agent Act and Capture Everything
Rodar o agente e capturar **tudo** que saiu: diff de mudanças, stdout, mensagem de falha, novo estado. O output não é o fim — é a matéria-prima do próximo prompt.
```python
def act_and_capture(prompt, state):
    output = agent.run(prompt)
    result = run_checks(output)
    return result
```

### Parte 4: Close the Loop with Feedback
Dois caminhos: se passou → parar. Se falhou → transformar a falha no próximo prompt automaticamente ("Tests failed with this error. Fix it."). O agente re-prompta a si mesmo usando o que acabou de acontecer.
```python
state.last_error = result.error
state.past_attempts.append(result)
```

### Parte 5: Set the Stop Conditions (guardrails)
Um loop sem saída não é um sistema — é um custo que nunca para. Três guardrails essenciais:
- **Cap de retries** — parar após N turns mesmo sem sucesso.
- **Budget de custo** — parar se cruzar limite de tempo/dinheiro.
- **Human checkpoint** — pausar para ação humana em operações irreversíveis (delete, push to prod, envio de dinheiro).
```python
def loop(state, max_turns=10, max_cost=5.0):
    turns = 0
    cost = 0.0
    while turns < max_turns and cost < max_cost:
        turns += 1
        prompt = build_prompt(state)
        result = act_and_capture(prompt, state)
        cost += result.cost
        if is_done(result): return result
        state.last_error = result.error
        state.past_attempts.append(result)
    return "stopped: hit a guardrail"
```

## Exemplos e evidências

**Walkthrough — "fix the failing login bug":**
- Turn 1: estado inicial → agente muda código → testes falham com "password check returns true for empty password" → salvo no estado.
- Turn 2: `build_prompt` inclui o erro do Turn 1 → agente corrige a linha exata → testes passam.
- Turn 3: não existe. `is_done` retornou True no Turn 2.

Nenhum prompt foi digitado manualmente durante o run.

## Cost of Running the Loop

O modelo produz código em segundos por custo mínimo. Mas o loop roda esse modelo repetidamente, turn a turn, potencialmente por horas. Um loop que roda a noite toda pode executar milhares de turns. O trabalho principal passou a ser garantir que o loop **para** — não escrever o prompt inteligente.

## Reusable Skills

Uma **skill** é uma ferramenta pequena e reutilizável que faz um trabalho bem feito. Regra: quando o mesmo passo se repete, extrair como skill nomeada. Um loop sem skills pede ao modelo para resolver os mesmos problemas do zero em cada turn — desperdício de tempo e tokens.

## Common Mistakes

| Erro | Consequência |
|------|-------------|
| Sem check "done" em código | Loop nunca sabe quando parar |
| Hand-feeding prompts | Não é um loop, é trabalho manual |
| Descartar o output | Sem feedback, sem próximo prompt |
| Sem stop conditions | Loop infinito = custo infinito |
| Forçar loop em tarefa única | Loop só vale quando o trabalho repete e pode ser verificado |
| Sem skills no loop | Mesmo problema resolvido do zero a cada turn |

## Implicações para o vault

- O padrão de 5 partes mapeia diretamente ao design de rotinas do vault: cada rotina precisa de `is_done`, context building via estado, captura de resultado, feedback ao próximo ciclo, e `max_turns`.
- Human checkpoint (Parte 5) alinha com o [[04-SYSTEM/agents/core/guard]] — operações irreversíveis devem pausar para confirmação.
- Skills reutilizáveis = skills em `04-SYSTEM/skills/` — cada skill evita reinvenção a cada execução do agente.
- O conceito de "custo do loop vs custo do único prompt" reforça o princípio de RTK/token-economy: monitorar turns, não só tokens por call.

## Links

- Conceito derivado: [[03-RESOURCES/concepts/agent-systems/agent-loop-design]]
- Relacionado: [[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]]
- Relacionado: [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]]
- Relacionado: [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
- Relacionado: [[03-RESOURCES/concepts/agent-systems/skill-authoring]]
- Relacionado: [[04-SYSTEM/agents/core/guard]]

## Ver tambem (loop engineering cluster)

- [[03-RESOURCES/sources/wtf-is-a-loop-steinberger-cherny]]
- [[03-RESOURCES/sources/loop-engineering-14-step-roadmap]]
- [[03-RESOURCES/sources/what-are-agent-loops-tutorial]]
- [[03-RESOURCES/sources/designing-loops-with-fable-5]]
- [[03-RESOURCES/sources/most-devs-dont-need-agent-loops-yet]]
