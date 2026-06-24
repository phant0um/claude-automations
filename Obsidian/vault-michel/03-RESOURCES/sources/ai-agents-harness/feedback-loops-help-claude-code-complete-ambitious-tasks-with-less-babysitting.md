---
title: "Feedback loops: Help Claude Code complete ambitious tasks with less babysitting"
type: source
source: "Clippings/Feedback loops Help Claude Code complete ambitious tasks with less babysitting.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, claude-code, feedback-loops, skills, verification, autonomous-coding]
---

## Tese central

À medida que delegamos tarefas mais ambiciosas ao Claude Code, a capacidade de auto-verificação do agente é o multiplicador principal de autonomia — encoding de processos como skills permite que Claude verifique seu próprio trabalho contra critérios explícitos, reduzindo babysitting e acelerando convergência para o resultado final.

## Argumentos principais

- Claude já auto-verifica contra sinais determinísticos (type errors, lint errors, failing tests, runtime errors); o gap está nos checks manuais que o desenvolvedor faz após cada resposta e antes do merge.
- Quanto mais checks forem encodados como ferramentas que Claude pode executar, mais próxima a primeira resposta chega do resultado final desejado.
- Dois camadas de verificação: (1) verificação inline durante o loop agêntico (skill de verificação domain-específica); (2) review por segundo agente antes do merge — isolamento garante ausência dos biases do agente que escreveu o código.
- Opções de code review escaláveis: `/review` (built-in, single-pass), `/code-review` plugin (subagentes paralelos por ângulo, scores de confidence, posta no PR), Claude Code Review (managed service, automático em todo PR via GitHub para Team/Enterprise).

## Key insights

- Sessões de coding viram um "jogo por turnos" quando checks dependem do humano — perder a propriedade de autonomia é o custo real.
- O processo de criação de skill de verificação: escrever o processo best-practices → encodar como skill via `skill-creator` → incluir ferramentas domain-específicas (Chrome DevTools MCP, Agent browser, performance budgets, accessibility checklists).
- Um segundo agente de review não carrega os biases do primeiro — contexto isolado torna o review mais honesto e captura o que o primeiro agente perdeu.
- Frontend verification example: Step 1 — verificar que o elemento renderiza e comporta como esperado (embedded preview ou Chrome DevTools MCP); Step 2 — mobile audit com performance trace e Core Web Vitals.
- Skill que chama outras skills: simplify → verify → design check → open PR → watch CI → fix failures — processo completo bundled em uma skill.

## Exemplos e evidências

- Skill `frontend-verify` example com frontmatter estruturado, instruções de dois passos (comportamento + mobile audit), referência a Chrome DevTools MCP.
- O Claude Code team usa uma skill de workflow para features que bundle simplification, verification, design check, PR opening, CI watching e fix de failures em sequência.
- Chrome DevTools MCP permite capturar performance traces, auditar Core Web Vitals, e abrir URLs — viabilizando verificação real de frontend dentro do loop agêntico.

## Implicações para o vault

O conceito de "encode your process as a skill" é central ao paradigma de skills do vault. A estrutura de dois níveis de verificação (inline + pre-merge) pode ser adaptada para o pipeline de ingestão do vault (verificação inline de wikilinks + review de segundo agente antes de marcar ingestão como completa). O padrão de skill-que-chama-skills é o padrão de workflow que o vault deveria usar para pipelines complexos.

## Links

- [[03-RESOURCES/concepts/ai-agents/feedback-loops]]
- [[03-RESOURCES/concepts/ai-agents/claude-code-skills]]
- [[03-RESOURCES/concepts/ai-agents/adversarial-verification]]
