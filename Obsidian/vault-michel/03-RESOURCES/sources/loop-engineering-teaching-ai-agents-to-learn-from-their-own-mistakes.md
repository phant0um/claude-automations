---
title: "Loop Engineering: Teaching AI Agents to Learn from Their Own Mistakes"
type: source
source: "Clippings/Loop Engineering Teaching AI Agents to Learn from Their Own Mistakes.md"
created: 2026-06-20
ingested: 2026-06-21
tags: [ai-agents, loop-engineering]
---

## Tese central
Loop engineering trata codificação não como prompt único mas como ciclo repetido de feedback: planejar, agir, observar o resultado, ajustar até o trabalho estar de fato pronto. Diferente de prompt engineering (escrever uma pergunta melhor), loop engineering é construir um processo melhor — as ferramentas que o agente pode usar, a validação em que ele confia, e as regras de quando parar.

## Argumentos principais
- Ciclo central de 6 etapas: Plan (quebrar em passos concretos) → Search (achar arquivos/símbolos/testes/convenções relevantes) → Modify (menor mudança coerente) → Verify (rodar type check/teste/build/lint) → Repair (usar output de verificação para corrigir) → Summarize (explicar o que mudou e o que é risco).
- Um teste falhando não é só uma mensagem de erro — é contexto novo; um erro de tipo não é só um bloqueio — é sinal de que uma suposição estava errada. O poder não está em nenhuma etapa isolada, está em fechar o loop entre elas.
- 5 critérios de um bom loop: objetivos claros e observáveis (não "melhore o dashboard", mas "reduza tempo de carregamento inicial deferindo gráficos não-críticos mantendo filtros"), contexto relevante (nem pouco nem demais), ações pequenas e reversíveis, observabilidade confiável (testes rápidos e direcionados, screenshots), regras de parada explícitas.
- Padrões de loop por tipo de sinal: Test-Driven (reproduzir falha → corrigir até passar, bom para bugs/regressão), Compiler-Driven (mudança → type checker → usar erro para guiar próxima mudança).

## Key insights
- O exemplo do bug de apostrophe em billing settings ilustra a diferença entre "loop fraco" (assume SQL escaping, aplica patch direto) e "loop forte" (localiza form, rota de API, schema de validação, caminho de update no banco — reproduz a falha, observa em qual camada está o problema, só então corrige a menor parte relevante) — é o argumento mais concreto contra "corrigir pelo sintoma" em qualquer debugging, agêntico ou humano.
- "Ações pequenas e reversíveis reduzem risco de merge conflict e facilitam revisão" é diretamente equivalente ao princípio de Surgical Changes (Karpathy #3) já adotado neste vault — mesma lógica, vocabulário de loop engineering.

## Exemplos e evidências
- Caso detalhado do bug de billing com apostrophe no nome da empresa, comparando loop fraco vs loop forte passo a passo.

## Implicações para o vault
Vocabulário técnico (Plan/Search/Modify/Verify/Repair/Summarize) útil para descrever explicitamente o que já ocorre implicitamente nos specs de `04-SYSTEM/agents/` — reforça que regras de parada explícitas (stopping rules) deveriam estar mais presentes nos specs de agente do vault, não só critério de sucesso.

## Links
- [[03-RESOURCES/concepts/agent-systems/claude-code-agent]]
- [[03-RESOURCES/concepts/learning-cognition/karpathy-four-principles]]
