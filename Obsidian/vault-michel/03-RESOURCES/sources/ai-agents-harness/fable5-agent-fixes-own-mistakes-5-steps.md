---
title: "How to Build an Agent With Fable 5 That Fixes Its Own Mistakes in 5 Steps"
type: source
source: "[@0xMortyx](https://x.com/0xMortyx/status/2065380171327111225)"
created: 2026-06-13
ingested: 2026-06-13
tags: [ai-agents]
---

## Tese central

5 passos práticos, prontos para copiar em system prompts, para que um agente detecte e corrija seus próprios erros antes de reportar "done".

## Argumentos principais

1. **Goal + success criteria mensuráveis** — "DONE means ALL of these are true: [critérios testáveis]". Sem isso, não há padrão para autocorreção.
2. **Loop PLAN → DO → VERIFY → fix-and-reverify baked no prompt** — instruir explicitamente o ciclo, não assumir que o modelo já faz.
3. **Agente escreve seus próprios testes/checklists**: "This output is correct IF... / WRONG if I see..." — para código, testes reais; para texto/research, checklist de revisor rigoroso.
4. **Rodar em harness** (Claude Code / managed agent) — loop PLAN-DO-VERIFY precisa de múltiplos passos/ferramentas, não cabe em 1 mensagem.
5. **Exigir self-report honesto com prova**: ao reportar "done", mostrar critérios checados, resultado pass/fail de cada um, erros corrigidos, confiança final (High/Medium/Low + porquê) — nunca "done" como claim nu.

## Implicações para o vault

Os 5 blocos verbatim deste artigo são quase idênticos aos blocos do artigo "How to Actually Prompt Claude Fable 5" ([[03-RESOURCES/sources/claude-code-cowork/how-to-actually-prompt-claude-fable-5]], seção 4) — terceira fonte independente convergindo no mesmo padrão "progress audit / honest self-report". Confirma [[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]]. Sem ação nova — apenas mais validação cruzada do CLAUDE.md atual.

Ver também [[03-RESOURCES/sources/ai-agents-harness/fable5-self-improving-system-14-steps]] e [[03-RESOURCES/sources/ai-agents-harness/autonomous-long-running-coding-agents]] — convergem no mesmo padrão de verificador/evaluator independente do self-critique.

## Links

- [[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]]
- [[03-RESOURCES/sources/claude-code-cowork/how-to-actually-prompt-claude-fable-5]]
