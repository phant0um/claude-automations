---
title: Agent Loop Pattern
type: concept
created: 2026-06-23
updated: 2026-06-23
tags: [concept, ai-agents, agent-loop, pattern]
---

# Agent Loop Pattern

Um agent loop é um LLM usando tools em um loop para alcançar um goal. Não é um prompt clever — é o sistema em volta: job, tools, loop que permite tentar, verificar, tentar de novo.

## Definição

```
Agent = goal + tools + loop
```

O loop executa: **predict → act → observe → update → repeat** até que o goal seja alcançado ou o stop condition dispare.

## Variantes

- **Human-in-the-loop**: humano é o engine — prompt, review, prompt again. Funciona, tem ceiling.
- **Autonomous loop** (/loop, /goal): agent roda sem humano. Em teoria: você dorme, agent shippa. Na prática: você acorda com $400 bill e build quebrado.
- **Code review loop**: agent escreve → validator externo score → se < threshold, loop repete. Funciona porque feedback é binário.

## 3 things that kill agents in production

1. **Laziness**: faz 8 de 12 steps, declara done
2. **Goal drift**: esquece regras por turn 40
3. **No real verification**: diz "done" sem prova

## O validador é o Missing Piece

Loops sem validador externo geram [[03-RESOURCES/concepts/ai-agents/beautiful-nonsense|Beautiful Nonsense]]. O fix não é prompt melhor — é um validador que o modelo não pode influenciar (CI server pattern).

**4 critérios para loop fazer sentido**:
1. Task repete pelo menos semanalmente
2. Algo pode automaticamente reject bad output sem judgment humano
3. Agent faz trabalho end-to-end
4. Done é objetivo, não questão de gosto

## Evidências

- [[03-RESOURCES/sources/ai-agents/missing-piece-every-agent-loop]] — "Beautiful Nonsense" pattern: 3 dias de output convincente mas inválido
- [[03-RESOURCES/sources/ai-agents/i-tested-agentic-loops-real-code]] — Loops funcionam só com feedback binário (Greptile score ≥4)
- [[03-RESOURCES/sources/ai-agents/how-to-build-claude-agent-trust-production-full-course]] — 14 passos: agent = loop, não prompt
- [[03-RESOURCES/sources/ai-agents/the-problem-is-prompt-debt]] — Prompt debt amplifica em loops
- [[03-RESOURCES/sources/ai-agents/how-frontier-teams-are-reinventing-ai-native-development]] — Frontier teams: feed agents, não babysit
- [[03-RESOURCES/sources/articles/aws-transform-continuous-modernization]] — Detect → prioritize → remediate → verify = loop pattern
- [[03-RESOURCES/sources/ai-agents/lambda-microvms-claude-managed-agents]] — Sandbox isolation per session no loop

## Aplicação no vault

Pipeline-semanal é um agent loop. Tem feedback binário (PIPELINE OK/FAIL) mas o veredito vem do report-agent (mesmo modelo). Gap: gate bash-only incontestável seria o CI server equivalente.

## Links

- [[03-RESOURCES/concepts/ai-agents/beautiful-nonsense]]
- [[03-RESOURCES/concepts/ai-agents/agent-production-patterns]]
- [[04-SYSTEM/agents/core/verify]]
- [[04-SYSTEM/agents/core/hill]]