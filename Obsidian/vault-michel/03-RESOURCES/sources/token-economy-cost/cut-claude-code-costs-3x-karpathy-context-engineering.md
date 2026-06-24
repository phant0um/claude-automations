---
title: "How to Cut Claude Code Costs by 3x (Using Karpathy's Context Engineering Principles)"
type: source
author: Nainsi Dwivedi
author_handle: "@NainsiDwiv50980"
source_file: ".raw/articles/How to cut Claude Code costs by 3x (using Karpathy's context engineering….md"
created: 2026-05-03
updated: 2026-05-03
tags: [claude-code, cost-optimization, context-engineering, karpathy, token-efficiency, ai-legible-backend, backend-architecture]
triagem_score: 8
---

# How to Cut Claude Code Costs by 3x (Using Karpathy's Context Engineering Principles)

**Author:** Nainsi Dwivedi (@NainsiDwiv50980)

## Core Experiment

Two identical builds run side by side:
- Same app, same prompt, same model
- Only difference: backend architecture

| Setup | Tokens | Errors | Intervention |
|-------|--------|--------|-------------|
| Standard backend | 10.4M | Multiple | Constant retries |
| AI-legible backend | 3.7M | Zero | Almost none |

**Result: 2.8x token reduction** from infrastructure design alone.

## Root Cause: Discovery Tax

AI agents don't "understand" systems instantly — they discover state step by step. When the backend is designed for humans (dashboards, scattered configs, vague logs), the AI must:

- Query multiple tools to piece together state
- Read large chunks of irrelevant documentation
- Interpret unclear error messages
- Retry when things fail

Every discovery step = more tokens. One session saw the AI retry the same failing operation **8 times** — fixing code that wasn't even the real problem.

## The Counterintuitive Finding

**Better models amplify poor infrastructure costs.**

A more capable model doesn't skip over missing context — it leans into it. It explores more deeply, runs more checks, tries more fixes. The smarter the model, the more expensive poor infrastructure becomes.

## The Three Failure Modes (High-Cost Setup)

1. **Overloaded responses** — Agent asked for something specific; received massive, broad responses far beyond need
2. **No single source of truth** — Understanding the backend required multiple calls returning partial data; agent had to stitch everything together
3. **Unstructured errors** — When something broke, agent couldn't tell if issue was in code, config, or platform → repeated trial-and-error loops

## The Fix: AI-Legible Backend

Treat the backend as part of the AI's context window. The optimized setup:

- Provided a structured snapshot of the entire system upfront
- Returned only relevant, minimal information per task
- Exposed clear, machine-readable error signals

**Result:** AI didn't need to guess. It already knew. It could just execute.

## Key Insight

> "The best-performing AI systems aren't the ones doing the most thinking. They're the ones that don't need to think much at all."

The right question when building with AI agents:
- Not: "How do I get better outputs?"
- But: **"How much does the AI need to figure out before it can even start?"**

Every missing piece of context creates: extra reasoning + extra tool calls + extra retries + extra tokens — which compounds in multi-step workflows.

## Framing

This is a backend design problem, not a prompt engineering or model selection problem. The article explicitly critiques the obsession with prompt engineering and model upgrades as **optimizing the wrong layer**.

## Related Pages

- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — Karpathy's foundational concept: fill context with exactly the right information
- [[03-RESOURCES/concepts/dev-foundations/ai-legible-backend]] — The new concept this article defines
- [[03-RESOURCES/concepts/learning-cognition/karpathy-four-principles]] — Four principles framework (think, simplicity, surgical, goal-driven)
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-caching]] — Complementary technique for context cost reduction
- [[03-RESOURCES/concepts/llm-ml-foundations/context-rot]] — What happens when context degrades
- [[03-RESOURCES/entities/Andrej Karpathy]] — Author of context engineering principles applied here
- [[03-RESOURCES/sources/skills-prompting-mcp/karpathy-inspired-claude-code-guidelines]] — Related article by Forrest Chang
- [[03-RESOURCES/sources/claude-code-skills/clipping-agent-skills-real-world-execution]] — Same author (Nainsi Dwivedi), agent skills topic

---

## O conceito de AI-Legible Backend

O artigo define **AI-legible backend** como infraestrutura projetada especificamente para que um AI agent possa entender o estado do sistema com o mínimo de tokens consumidos. Isso inverte o design tradicional de backend, que é projetado para que dashboards humanos e APIs de terceiros consumam.

**Backend tradicional (human-legible):**
- Estado espalhado em múltiplos endpoints e dashboards
- Erros em linguagem natural para leitura humana, mas sem estrutura machine-readable
- Respostas verbose com contexto amplo "para ajudar o usuário a entender"

**Backend AI-legible:**
- **Snapshot único de estado:** um endpoint retorna o estado completo do sistema de forma estruturada — o agente não precisa consultar 5 endpoints e montar o quadro
- **Respostas mínimas e relevantes:** cada resposta contém apenas o que é necessário para a task atual
- **Erros estruturados e acionáveis:** `{"error": "config_missing", "field": "DATABASE_URL", "fix": "Set DATABASE_URL in .env", "docs": "..."}` em vez de "Internal server error"

---

## O Discovery Tax em operação

O artigo descreve um caso onde o agente tentou a mesma operação falha **8 vezes** — não por incompetência, mas porque cada tentativa fornecia informação nova que levava a outra hipótese. O backend estava revelando estado piecemeal, forçando um loop de descoberta iterativa.

A matemática desse loop:
- Cada tentativa: N tokens de contexto acumulado + M tokens de raciocínio + K tokens de output
- Após 8 tentativas: 8 × (N + M + K) tokens consumidos
- Com estado completo fornecido upfront: 1 × (N' + M + K) tokens, onde N' << N×8

O ponto contra-intuitivo: **melhor modelo = loop mais caro**. Um modelo mais capaz não abandona o loop prematuramente — ele persiste com hipóteses mais sofisticadas, testa mais edge cases, explora mais possibilidades. Exatamente as propriedades que tornam um modelo "melhor" amplificam o custo quando o backend é ambíguo.

---

## Os três failure modes: análise

**Failure 1 — Overloaded responses:** o backend retorna contexto "útil" além do que foi pedido. Um endpoint de status que retorna não apenas o status atual mas também o histórico de 30 dias de status, logs recentes, configurações ativas e telemetria relacionada. O agente recebe 50k tokens quando precisava de 200 tokens.

**Failure 2 — No single source of truth:** "O que é o estado atual do deployment?" requer chamar infrastructure-status, deployment-history, health-checks e config-service. O agente consome tokens montando o quadro que um único endpoint poderia fornecer.

**Failure 3 — Unstructured errors:** "Something went wrong" (com um stack trace de 200 linhas em Python) vs. `{"error": "database_timeout", "host": "db.prod", "timeout_ms": 30000, "retry_after": 60}`. O primeiro requer raciocínio para diagnosticar; o segundo é acionável diretamente.

---

## Aplicação prática: o que torna um backend AI-legible

Checklist para transformar um backend existente:

**1. State snapshot endpoint:** criar `GET /api/agent-context` que retorna o estado completo do sistema em formato JSON estruturado — o agente consulta uma vez no início da sessão em vez de múltiplas consultas ao longo.

**2. Erros com ação:** cada erro deve incluir: código de erro (machine-readable), descrição (human-readable), ação sugerida, referência de docs. O agente consegue tomar ação imediata em vez de raciocinar sobre o que o erro significa.

**3. Respostas filtradas por relevância:** ao invés de retornar todos os campos de um objeto, retornar apenas os campos relevantes para a query. `?fields=id,status,last_updated` em vez de o objeto completo.

**4. Endpoints de healthcheck semântico:** não apenas "está de pé" mas "está em estado válido para a operação X". `GET /api/health/can-deploy` retorna booleano + razão, eliminando a necessidade do agente verificar múltiplas precondições.

---

## Conexão com context-engineering de Karpathy

O artigo usa explicitamente os princípios de Karpathy como framework, mas adiciona uma dimensão que o trabalho original de Karpathy não cobre: **o lado do servidor**.

Context engineering de Karpathy foca em o que o agente coloca no contexto — quais arquivos, quais instruções, qual histórico. O artigo de Nainsi adiciona: o que o servidor entrega quando o agente consulta também é context engineering. Um backend que entrega informação exata, mínima e estruturada está fazendo context engineering no lado do servidor.

A combinação das duas perspectivas é mais poderosa que qualquer uma isolada:
- Bom context engineering no agente, mas backend que entrega respostas verbose: o agente pede pouco mas recebe muito
- Backend AI-legible, mas agente com má disciplina de contexto: o servidor entrega bem mas o agente acumula mal

O 2.8x de redução do experimento do artigo vem **apenas** de melhorar o backend — sem tocar no prompt ou no modelo. O potencial adicional de melhorar ambos simultaneamente não foi medido.
