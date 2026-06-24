---
title: Subagent Spawning Patterns
type: concept
status: developing
updated: 2026-04-25
tags: [claude, opus-47, subagents, parallelism, delegation]
---

# Subagent Spawning Patterns

Comportamento do [[03-RESOURCES/entities/Claude-Opus-47|Claude Opus 4.7]] no spawning automático de subagentes em paralelo. Mudança significativa vs Opus 4.6 — modelo é **mais conservador** por padrão.

## Mudança de comportamento

| Aspecto | Opus 4.6 | Opus 4.7 |
|---|---|---|
| Spawning automático | Liberal — cria subagentes facilmente | Conservador — questiona necessidade |
| Quando spawna | Qualquer trabalho "parallelizável" | Apenas quando explicitamente pedido |
| Trade-off | Mais paralelismo, potencial overhead | Menos overhead, menos latência |

## Regra de ouro (Opus 4.7)

**NÃO spawne subagentes para trabalho que você consegue completar em uma única resposta.**

### Exemplo: NÃO fazer isso
```
[Você já consegue ver o arquivo]
Refatore a função doLogin() para usar async/await

[❌ Não spawne subagente]
```

### Exemplo: FAZER isso
```
[Você não consegue ver todos os arquivos]
Refatore todos os 15 componentes em /src/components para usar React Hooks.
Spawn um subagente por componente (ou por grupo se forem simples).
```

## Quando spawnar múltiplos subagentes

**Em um único turn**, pedir explicitamente para trabalho que é:
1. **Fan-out across files**: múltiplos arquivos independentes
2. **Fan-out across items**: múltiplas tarefas parallelizáveis (e.g., migrar 10 APIs)
3. **Não-bloqueante**: subagentes não dependem um do outro

### Exemplo bom
```
Implemente testes para todos os 50 handlers em /api/handlers.
Spawn um subagente por grupo de 5 handlers. Rodem em paralelo.
```

## Como pedir paralelismo

```
Refatore estes 5 módulos em paralelo:
1. /auth/
2. /database/
3. /cache/
4. /logging/
5. /storage/

Spawn um subagente por módulo. Coordene ao final.
```

**Ou:**

```
Processe estas 100 requisições de usuário em paralelo.
Fan-out: um subagente por batch de 20.
```

## Implicação em Effort Levels

- Spawning é **independente** de [[03-RESOURCES/concepts/claude-code-tooling/effort-levels-opus47|Effort Level]]
- Mesmo em `max`, o modelo spawna conservadoramente
- Você controla via linguagem natural explícita

## Diferença vs "Task delegation"

- **Task delegation (tool):** Você chama uma ferramenta de job queue
- **Subagent spawning:** Claude automaticamente cria subagentes no Claude Code harness
- Ambos demandam **pedir explicitamente** no Opus 4.7

## LinkedIn GTM Use Cases

Three proven patterns from [[03-RESOURCES/concepts/ai-strategy-org/linkedin-gtm-system]]:
1. **Batch qualification:** 500 leads × 10 sub-agents → 12 min instead of 2 hours
2. **Writing + critiquing:** separate critic sub-agent with different instructions (no cheerleading) → honest feedback
3. **Parallel hook exploration:** 5 sub-agents each write same post with different hook type; compare and ship best

**Reliability math:** 10 parallel agents at 95% individual success ≈ 60% joint success rate. Build retry loops for critical tasks.

## Custo fixo por sub-agent

Todo sub-agent spawna com **~20.000 tokens de overhead** antes de executar qualquer trabalho útil. Esse número está documentado empiricamente, não no marketing page.

**Implicações de design:**

| Cenário | Overhead total |
|---------|---------------|
| 1 sub-agent | ~20K tokens |
| 5 sub-agents | ~100K tokens |
| 10 sub-agents | ~200K tokens |

**Regras derivadas:**
- Sub-agent vale o overhead quando o trabalho > ~5K tokens de output útil
- Fan-out de 14 sub-agents para tarefas simples = ~280K tokens desperdiçados antes de começar
- Sobrevivência empírica: de 14 sub-agents construídos, apenas 4 justificaram o overhead; os outros 10 foram descartados

**Design pattern correto:**
1. Avaliar output esperado por sub-agent antes de spawnar
2. Consolidar tarefas pequenas em batches maiores por sub-agent
3. Usar subagentes só quando paralelismo ou isolamento de contexto compensam o overhead

*Fonte: [[03-RESOURCES/sources/ai-agents-harness/14-claude-code-sub-agents]] — análise de 60 dias, 14 sub-agents*

## Evidências

- **[2026-06-19]** Cada sub-agente do swarm Kimi K2.6 opera em janela de contexto própria e isolada, retornando só output estruturado ao coordenador — evita colapso por lossy summarization em tarefas longas — [[03-RESOURCES/sources/self-improving-loop-300-agent-swarm-kimi]]
- **[2026-06-22]** Subagents de pesquisa com contexto e acesso web próprios mantêm o "ruído" (dezenas de fontes abertas) fora do thread principal, retornando só a síntese — padrão "research department" para solo founders — [[03-RESOURCES/sources/how-to-build-a-solo-company-with-claude-code-9-systems-that-run-it]]

- **[2026-06-24]** Set the agent's runtime config in agent.ts with defineAgent, including the model and compaction. — [[agent-ts]]
- **[2026-06-24]** We let Codex and Claude Code autonomously iterate on the nanoGPT speedrun optimizer track for two weeks, producing ~10k — [[autonomous-ai-research-for-nanogpt-speedrun]]
- **[2026-06-24]** Your agent writes clean code for 12 steps.Step 13: wrong file. Step 14: ignores your rules. Step 15: deletes something i — [[claude-code-hooks-what-nobody-tells-you-until-step-20-breaks-everything]]
- **[2026-06-24]** The session and run contract you touch: continuation tokens, stream handles, the NDJSON event stream, and reconnecting. — [[sessions-runs-streaming]]
## Fontes

- [[03-RESOURCES/sources/guides-courses-howtos/best-practices-claude-opus-47-claude-code]]
- [[03-RESOURCES/sources/ai-agents-harness/claude-code-linkedin-playbook]] — reliability math; 3 LinkedIn batching patterns
- [[03-RESOURCES/sources/ai-agents-harness/14-claude-code-sub-agents]] — ~20K token overhead empírico
- **[2026-06-19]** Progressão de 3 níveis (copy-paste role → Skill → sub-agent) descreve quando vale a pena promover um role a sub-agent isolado — [[03-RESOURCES/sources/how-to-run-claude-as-a-team-not-a-tool]]
