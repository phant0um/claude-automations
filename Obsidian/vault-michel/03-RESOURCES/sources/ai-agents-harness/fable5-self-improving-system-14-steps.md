---
title: "Build self-improving agent system with Fable 5 in 14 steps"
type: source
source: "[@0xCodez](https://x.com/0xCodez/status/2065089060104720776)"
created: 2026-06-13
ingested: 2026-06-13
tags: [ai-agents]
---

## Tese central

Self-improvement é propriedade do sistema construído em volta do modelo, não do modelo em si. Um roadmap de 14 passos descreve como sair de "Fable 5 como Sonnet com mais contexto" até um sistema que compõe memória, skills e prompts a cada execução — modelo permanece o mesmo, o harness fica mais afiado.

## Argumentos principais

- **Self-improving ≠ self-learning**: self-learning = pesos do modelo mudam (não existe em produção); self-improving = o *sistema em volta* compõe — memória, skills, prompts ficam mais afiados a cada run, modelo fica igual.
- **Compound stack de 4 camadas** (bottom-up): Primitivos (Fable 5, subagentes, worktrees) → Orquestração (`/goal`/Outcomes, Dynamic Workflows, Routines) → Memória (state files, Skills, KBs) → Self-improvement (vision self-check, eval loops, distilação de regras → grava de volta na Camada 3).
- **Matriz de custo/capacidade**: Fable 5 = orquestrador (planeja dias, delega, vision-check); Opus 4.8 = subtasks difíceis-mas-limitadas + fallback de classifier block; Sonnet 4.6 = trabalho de alto volume; Haiku 4.5 = graders/classificadores baratos. Padrão de produção: "orchestrator Fable 5, workers Sonnet 4.6, graders Haiku 4.5, fallback Opus 4.8".
- **Verificador > self-critique**: confirmado empiricamente — verificador independente sem acesso ao raciocínio do maker explora espaços de hipótese maiores e recupera de resultados negativos intermediários (Parameter Golf: Fable 5 + verificador = ~6x mais melhoria que Opus 4.7).
- **Progressão de memória em 5 estágios**: Fail → Investigate → Verify → Distill → Consult. Sonnet 4.6 para no passo 1 (memória não compõe); Opus 4.7 chega ao 3 (verification coverage 7-33%); Fable 5 completa a progressão (73% coverage no Continual Learning Bench).
- **STATE.md** com 5 seções mapeando os 5 estágios (Verified facts / General rules / Open failures / Lessons learned / Last session); regra: "write before walking away, read at session start" — sem isso até Fable 5 regride a comportamento Sonnet.
- **Skills que compõem**: após qualquer falha não-trivial, a lição vai para o SKILL.md (não só STATE.md) — Skills são memória procedural cross-project, STATE.md é memória de projeto.
- **Mythos safety boundary**: Fable 5 tem classifiers que recusam em cyber/bio/chem/distillation, fallback automático para Opus 4.8. Sistemas autônomos devem arquitetar para esse fallback explicitamente — bloqueio silencioso parece erro real.

## Key insights

- "Self-improvement is a property of the system you build, not the model."
- Os 9 erros mais comuns formam um checklist de auditoria direto: usar Fable 5 como Sonnet com mais contexto, self-critique em vez de verificador, sem STATE.md, Skills que nunca recebem updates, Fable 5 em tasks que Sonnet resolveria, sessões longas em laptop (precisa CMA/Routines), ignorar o safety boundary, sem vision-verify em tasks visuais, sem `/goal`/Outcomes.

## Implicações para o vault

Mapeia quase 1:1 com [[03-RESOURCES/concepts/agent-systems/agent-memory-four-layers]], [[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]] e [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]] — confirma que esses concepts já capturam o estado da arte. O **STATE.md de 5 seções** é um template concreto e imediatamente aplicável: candidato a adotar em `.claude/todo.md` ou em arquivo de memória de projetos longos do vault (ex: pipeline-diario, FIAP).

Este artigo faz parte de um cluster de convergência: ver também [[03-RESOURCES/sources/ai-agents-harness/anatomy-of-a-reliable-ai-agent]], [[03-RESOURCES/sources/ai-agents-harness/loop-driven-development-next-layer-ai-coding]], [[03-RESOURCES/sources/ai-agents-harness/autonomous-long-running-coding-agents]] e [[03-RESOURCES/sources/ai-agents-harness/claude-code-maxxing-project-loop]] — todos reformulam o mesmo tema (sistema > modelo) já bem documentado nos concepts; tratar como triangulação de fontes, não como gaps.

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-memory-four-layers]]
- [[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]]
- [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]]
