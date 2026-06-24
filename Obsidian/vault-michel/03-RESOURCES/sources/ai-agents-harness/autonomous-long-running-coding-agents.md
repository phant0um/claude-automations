---
title: "Autonomous Long-Running Coding Agents"
type: source
source: "[@omarsar0](https://x.com/omarsar0/status/2065880971031834786) (DAIR.AI Academy session)"
created: 2026-06-15
ingested: 2026-06-15
tags: [ai-agents]
---

## Tese central

Mudança de "melhor prompting" → "melhores sistemas de controle": agentes embrulhados em goals, evaluators, loops e artifacts que continuam trabalhando após o humano parar de digitar.

## Argumentos principais

- **Goal como contrato, não prompt longo**: estado-final desejado, evidência de sucesso, constraints, budget de turnos. Goal fraco → modelo encurta caminho; goal forte → alvo mensurável repetidamente.
- **Evaluator como componente de 1ª classe**: deterministic checks (testes, lint, types) como piso; agente/LLM-judge para critério "fuzzy" (coerência, fidelidade a paper, UI vs design intent). Combinação reduz "hallucinated success".
- **Verifier define a fronteira de confiança**: explicação do agente não é evidência — evidência vem de check externo que o agente não controla. Verifier vago → modelo satisfaz a interpretação mais fácil; verifier estreito → overfit no verifier, perde intenção. Observação: modelos frontier ainda têm problema OOD em tarefas de verificação fora da distribuição de treino.
- **Loop = o que mantém autonomia viva**: modelos param antes de terminar (turn limit, contexto, falsa sensação de "pronto"). Loop = inspeciona progresso, roda checks, decide continuar. Versão simples = Ralph loop; versão flexível = evaluator agent decidindo o próximo passo.
- **Planejamento é onde entra expertise humana**: ainda preciso inspecionar plano gerado, desafiar premissas, afiar critério de sucesso antes de delegar pro loop. "Model choice becomes an architecture decision" — modelo planejador ≠ modelo executor ≠ modelo avaliador.
- **Artifacts visuais como control surface**: terminal transcript não escala com múltiplos agentes paralelos. Separar storage (markdown/vault = estado durável) de presentation (HTML artifact = visual/interativo).
- **Session mining**: sessões passadas são dados de workflow — falhas recorrentes (mesmo erro, mesmo path errado, mesmo retry quebrado) devem virar regras em CLAUDE.md/skills, não ficar enterradas em logs.

## Implicações para o vault

Confirma e nomeia explicitamente padrões já em uso no pipeline-diario: F2.8/F3.5 = evaluator/verifier (Sonnet gates), retry-cap = controle de loop, hot.md = artifact de estado durável. **Novo/reforço**: "session mining" formaliza o que `errors.md` + `hill` já tentam fazer — ponto de cross-link direto com [[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]] e [[03-RESOURCES/concepts/agent-systems/agent-loop-design]]. O ponto sobre "model choice as architecture decision" (planner≠executor≠evaluator) reforça `model-router.md` — já implementado (Haiku triagem/Sonnet ingest/Sonnet gates).

É a **formalização mais explícita até agora** dos 3 gates Sonnet do pipeline-diario — bom material de referência se algum dia precisar justificar/documentar a arquitetura dos gates pra alguém de fora. Ver também [[03-RESOURCES/sources/ai-agents-harness/fable5-agent-fixes-own-mistakes-5-steps]] e [[03-RESOURCES/sources/ai-agents-harness/loop-driven-development-next-layer-ai-coding]].

## Links

- [[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]]
- [[03-RESOURCES/concepts/agent-systems/agent-loop-design]]
- [[04-SYSTEM/agents/core/hill]]
- [[04-SYSTEM/wiki/errors]]
