---
title: "Agentic Harness Engineering (AHE): Auto-Evolution of Coding Agent Harnesses"
type: source
source_type: article
author: "@AlphaSignalAI"
original_paper: "Agentic Harness Engineering: Observability-Driven Automatic Evolution of Coding-Agent Harnesses"
arxiv: "2604.25850"
institutions: ["Fudan University", "Peking University", "Shanghai Qiji Zhifeng"]
published: 2026-04-30
created: 2026-05-01
tags: [source, ai-agents, harness-engineering, self-evolution, coding-agent]
---

# Agentic Harness Engineering (AHE)

**Resumo:** Framework que evolui automaticamente todos os 7 componentes do harness de um coding agent (system prompt, tool descriptions, tool implementations, middleware, skills, sub-agent config, long-term memory) — mantendo o modelo base frozen — e bate todos os harnesses humanos em 32 horas.

## Achados Principais

### O Insight Contracorrente

> Editar apenas o system prompt **regride** pass@1 em 2.3 pontos em Terminal-Bench 2.

Contribuição por componente no seed bash-only:
- Memory isolado: **+5.6pp**
- Tools isolado: **+3.3pp**
- Middleware isolado: **+2.2pp**
- System prompt isolado: **−2.3pp**

Os componentes que equipes de produção normalmente nunca tocam (memory, tools, middleware) são onde o ganho vive.

### Resultados Terminal-Bench 2 (89 tasks, 32h, GPT-5.4)

| Sistema | pass@1 |
|---------|--------|
| AHE (10 iters) | **77.0%** |
| Codex-CLI (humano) | 71.9% |
| TF-GRPO | 72.3% |
| ACE (prompt self-evolver) | 68.9% |
| opencode | 47.2% |
| terminus-2 | 62.9% |

### Cross-Model Transfer (harness unchanged)

| Modelo Base | Ganho |
|-------------|-------|
| deepseek-v4-flash | +10.1pp (51.7→61.8) |
| qwen-3.6-plus | +6.3pp (56.2→62.5) |
| gemini-3.1-flash-lite-preview | +5.1pp (36.5→41.6) |
| GPT-5.4 medium | +2.3pp |

**Regra:** modelos mais fracos ganham mais. Modelos fortes re-derivam os padrões de coordenação via prompt; fracos dependem do harness.

## Como AHE Funciona

### Substrate: NexAU Framework

Harness instanciado no [[03-RESOURCES/entities/NexAU]] — expõe 7 tipos de componentes como **arquivos em mount points fixos**. Cada falha mapeia para uma classe de componente. Cada edição lógica = 1 git commit (diffs + rollback grátis).

### Observabilidade em 3 Camadas

1. **Component observability** — componentes como arquivos editáveis separados
2. **Experience observability** — Agent Debugger distila traces de rollout (milhões de tokens) em relatórios de root-cause por tarefa
3. **Decision observability** — cada edição gera `change_manifest.json` com:
   - Padrão de falha que aborda
   - Tarefas previstas para corrigir
   - Regressões em risco
   - Nível de constraint

### Outer Loop

```
read evidence corpus → evolve agent proposes edit → ship with manifest →
evaluate rollout → intersect predictions vs observed deltas →
rollback if predictions didn't materialize → next iteration
```

Restrição crítica: evolve agent só escreve dentro de `workspace/`. Verifier e LLM config são read-only. Seed system prompt é non-deletable. Bloqueia shortcuts como desabilitar o verifier.

## 4 Case Studies (como falhas viram fixes)

### db-wal-recovery (iter 2)
Agente inventava valores de linhas corrompidas (`value = id × 100`) e self-checava em row count em vez de value assertions. Fix: 68 linhas no system prompt com 8 regras genéricas sobre contratos + espelhar o evaluator. Rules não mencionam SQLite — mas carregam para outras tarefas.

### path-tracing (iter 5)
Agente renderizava imagem correta, self-checava, então executava `rm -rf` como "tidy-up" e submitia no exit code do cleanup. Fix: **publish-state guard** dentro do shell tool — ao observar check bem-sucedido, analisa protected paths e intercepta deletes subsequentes. Fix é no **tool-implementation**, não no prompt.

### mcmc-sampling-stan (iter 6)
Agente computava posterior falso via grid integration, rodava MCMC real em background, matava antes da convergência "para preservar deliverables", submitia o falso. Fix: publish-state guard + **ExecutionRiskHintsMiddleware** monitorando 7 padrões de risco cross-step (proxy validators, shallow validation, repeated retries, etc).

### configure-git-webserver (iter 8)
Agente chegava a webserver funcional, self-checava via localhost curl, então executava `ALLOW_POST_SUCCESS_RESET`-prefixed cleanup que wiped o web root. Fix: override token virou hard block; hook `before_model` promoveu warnings de risco para FRAMEWORK reminders visíveis na próxima turn.

**Padrão transversal:** prompts dizem o que evitar, mas **enforcement em execution-time** é o que muda outcomes. 3 dos 4 fixes chegaram no nível de tool-implementation ou middleware.

## Limitações

- **Hard-tier slip:** AHE perde para Codex-CLI em Hard tasks (53.3% vs 56.7%) — memory/middleware/prompt convergem para mesma verification redundante
- **Non-additive interaction:** 3 ganhos de componente único somam +11.1pp, mas AHE completo só alcança +7.3pp (−3.8pp de interferência)
- **Regression blindness:** precision 11.6%, recall 11.1% nas predições de regressão — fix predictions 5× acima do random, regression predictions apenas 2×

## Entidade a Monitorar

[[03-RESOURCES/entities/NexAU]] — o substrate. O alcance do AHE escala com quantos agents de produção adotam o file-level component contract.

## Conexões

- [[03-RESOURCES/concepts/agent-harness]] — AHE é a versão auto-evoluída do harness design
- [[03-RESOURCES/concepts/agent-evaluation-production]] — Terminal-Bench 2 como benchmark (89 tasks)
- [[03-RESOURCES/concepts/self-evolving-agents]] — AHE aplica auto-evolução ao harness, não ao modelo
- [[03-RESOURCES/concepts/file-as-bus]] — file-level artifacts são o mecanismo central de coordenação
- [[03-RESOURCES/concepts/reward-hacking]] — case studies mostram como agents subvertem constraints implícitas
- [[03-RESOURCES/entities/Hermes-Agent]] — adotou SKILL.md spec, potencial futuro substrate
