---
title: "Agent Loop Design"
type: concept
status: developing
created: 2026-06-09
updated: 2026-06-09
tags: [agent-systems, loop-design, agentic-loops, feedback-loops, stop-conditions, context-building]
---

# Agent Loop Design

O padrão de engenharia para construir sistemas que continuam prompting um agente automaticamente — turn a turn — até que o trabalho esteja concluído, sem intervenção humana a cada passo.

> "A prompt is a single move. A loop is a strategy."

## Por que loops e não prompts únicos

Tarefas reais exigem múltiplos passos: escrever código → rodar testes → ler erro → corrigir → repetir. Um prompt único cobre apenas um movimento. O loop é o conjunto de regras que decide cada movimento, verifica o estado após cada um, e continua até o objetivo ser atingido.

A habilidade nova não é escrever o prompt perfeito. É construir o sistema que mantém o prompting ativo por conta própria.

## As 5 Partes do Loop

```
Build Context → [Agent] → Capture Result → Check Done? ──Yes──→ Stop
      ↑                                         |
      └──────────── feedback (No) ──────────────┘
      
Stop conditions envolvem todo o loop
```

### 1. Define What "Done" Looks Like

Escrever a verificação de conclusão **em código**, antes de qualquer outra coisa. O loop chama essa função após cada turn. Sem check em código, o loop não tem heartbeat.

```python
def is_done(result):
    return result.tests_passed  # ou: schema válido, score > threshold, etc.
```

Exemplos de "done": testes passam, output bate com schema, score cruza threshold.

### 2. Build the Context, Not the Instruction

Não digitar instruções manualmente. Construir o prompt a partir do **estado atual**: arquivos, ferramentas, logs de erro da última run, tentativas anteriores.

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

O loop é constante em estrutura; só o contexto muda a cada turn.

### 3. Act and Capture Everything

Rodar o agente e capturar tudo: diff, stdout, mensagem de falha, novo estado. O output não é o fim — é a matéria-prima do próximo prompt. Descartar o output quebra o loop.

```python
def act_and_capture(prompt, state):
    output = agent.run(prompt)
    return run_checks(output)  # diff + logs + pass/fail
```

### 4. Close the Loop with Feedback

Dois caminhos pós-captura:
- **Passou** → parar, retornar resultado.
- **Falhou** → transformar a falha no próximo prompt automaticamente.

```python
state.last_error = result.error
state.past_attempts.append(result)
# próximo build_prompt inclui esse erro automaticamente
```

O agente re-prompta a si mesmo usando o que acabou de acontecer — sem digitação humana.

### 5. Stop Conditions (Guardrails)

Um loop sem saída é um custo que nunca para. Três guardrails obrigatórios:

| Guardrail | Implementação |
|-----------|--------------|
| Cap de retries | `while turns < max_turns` |
| Budget de custo | `while cost < max_cost` |
| Human checkpoint | Pausa antes de operações irreversíveis (delete, push prod, transações financeiras) |

```python
def loop(state, max_turns=10, max_cost=5.0):
    turns, cost = 0, 0.0
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

## Custo Real do Loop

O custo não está em gerar uma resposta — está no número de turns. Um loop sem guardrails rodando a noite toda pode executar milhares de turns. A principal responsabilidade do engenheiro passou a ser garantir que o loop **para**, não escrever o prompt inteligente.

Implicação: monitorar turns e custo acumulado, não apenas tokens por call.

## Reusable Skills dentro do Loop

Uma **skill** é uma ferramenta pequena que faz um trabalho bem feito e pode ser chamada pelo loop diretamente. Regra: quando o mesmo passo se repete, extrair como skill nomeada.

- Loop sem skills: modelo resolve o mesmo problema do zero a cada turn.
- Loop com skills: problemas recorrentes custam próximo de zero após a primeira vez.

O loop cresce mais valioso conforme skills são adicionadas — ao invés de só queimar dinheiro.

## Common Mistakes

| Erro | Consequência |
|------|-------------|
| Sem `is_done` em código | Loop nunca para ou para cedo demais |
| Hand-feeding prompts manualmente | Não é loop, é trabalho humano sequencial |
| Descartar output | Sem feedback, sem próximo contexto |
| Sem stop conditions | Loop infinito = custo infinito |
| Forçar loop em tarefa única | Loop só compensa em tarefas repetíveis e verificáveis |
| Sem skills | Reinvenção do problema a cada turn |

## Diferença de conceitos relacionados

- [[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]] — instância específica: um gerador + um verificador em dois papéis. Agent Loop Design é o padrão geral de 5 partes.
- [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]] — foco em aprendizado contínuo com feedback humano pós-deploy. Agent Loop Design foca na mecânica de execução autônoma.
- [[03-RESOURCES/concepts/agent-systems/harness-engineering]] — o harness é a infraestrutura que hospeda o loop; o loop é o padrão de comportamento.

## Aplicação no vault-michel

- Rotinas (`07-QUEUE/rotinas/`) devem seguir o padrão: `is_done` explícito, context building via estado, captura de resultado, feedback ao próximo ciclo, `max_turns`.
- Human checkpoint mapeia ao [[04-SYSTEM/agents/core/guard]] — gate obrigatório antes de operações destrutivas.
- Skills em `04-SYSTEM/skills/` são as "reusable skills" do loop — cada uma evita recomputação a cada execução.

## Fontes

- [[03-RESOURCES/sources/design-loop-prompts-agent]] — Amit Shekhar (@amitiitbhu), Outcome School, 2026-06-08
- [[03-RESOURCES/sources/feedback-loops-help-claude-code-complete-ambitious-tasks-with-less-babysitting]]
- [[03-RESOURCES/sources/how-to-run-claude-on-autopilot-in-14-steps-loop-routines-and-the-full-automation-stack]]

## Related

- [[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]]
- [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]]
- [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
- [[03-RESOURCES/concepts/agent-systems/skill-authoring]]
- [[03-RESOURCES/concepts/agent-systems/context-budget-constraint]]
- [[03-RESOURCES/concepts/agent-systems/dynamic-workflows]]

## Evidências
- **[2026-06-19]** Loop de otimização roda em sinal numérico (não pass/fail): benchmark→hipótese→mudança única→re-benchmark→manter ou reverter, com mediana de 50 execuções pós-warmup como medição honesta — [[how-to-build-a-claude-code-agent-that-optimizes-code-in-a-loop]]
- **[2026-06-19]** Bom primeiro loop tem 3 propriedades: schedule claro, job estreito não-ambíguo, output verificável em segundos — comece com 1 loop, não 10 — [[03-RESOURCES/sources/how-to-set-up-claude-loops]]
- **[2026-06-19]** Arquitetura de 3 camadas (Loop = cron+decisão, Skill = workflow durável, Orchestrator = motor de execução/retry/observabilidade) formaliza o que falta num while-loop ingênuo — [[03-RESOURCES/sources/the-agent-loop-architecture]]
- **[2026-06-22]** Google TF→JAX migration: Coder agent opera test-and-fix loop (read→write→build→test→self-correct) até produzir componente compilável. Verificação matemática (gradient ascent) separada do loop de geração — [[03-RESOURCES/sources/ai-agents/6x-faster-migration-tensorflow-to-jax]]
- **[2026-06-22]** Anatomia de 5 partes (Discover/Plan/Action/Verification/Memory) — só Verification e Memory exigem pensamento real; loop mínimo funcional ("Ralph") em 20 linhas de bash com contexto fresco por iteração, progresso mantido em disco/git — [[03-RESOURCES/sources/loop-engineering-the-anatomy-of-an-autonomous-loop]]
- **[2026-06-22]** Distinção /loop (polling, agente avalia próprio trabalho) vs /goal (condição escrita avaliada por modelo separado via Stop hook session-scoped) — [[03-RESOURCES/sources/i-spent-a-week-inside-ai-loops-prompting-is-dead-here-is-what-replaced-it]]
- **[2026-06-22]** Distinção /loop (cadência fixa) vs /goal (condição verificável julgada por modelo separado) aplicada a pipeline de trading: /loop = data pull por hora, /goal = iterar até Sharpe > 1.5 — [[03-RESOURCES/sources/how-to-use-loop-engineering-to-build-a-self-improving-quant-trading-system]]
- **[2026-06-24]** /makeloop gera loop prompts lendo conversation + codebase. Separa closed loop (goal+verify+stop) de open loop... — [[loop-makeloop-internals]]
- **[2026-06-24]** Agent Loops = reason→act→observe→repeat com goal+action+stop. 7 cenários mais utilizáveis: research→artifact, creative... — [[agent-loops-most-usable-scenarios]]
