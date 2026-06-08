---
skill: adversarial-gate
version: 1.0
trigger: "@adversarial-gate [plano]" | "/adversarial-gate" | "inject adversarial gate"
model: claude-sonnet-4-6
tags: [quality-gate, adversarial, planning, subagents, review, in-flight]
source: "[[03-RESOURCES/sources/skills-prompting-mcp/blader-adversarial-subagent-review-gate]]"
---

# Skill: Adversarial Gate

## Propósito

Injetar um portão de revisão adversarial em qualquer plano ativo — antes de marcar qualquer tarefa como concluída, um subagente com contexto isolado valida a tarefa. Elimina viés de confirmação do agente principal em runs longas.

**Diferença de `verify`:** verify = quality gate no fim do sprint. adversarial-gate = validação contínua tarefa a tarefa *durante* execução.

**Diferença de `guard`:** guard = auditoria de segurança. adversarial-gate = validação de qualidade/completude em tempo real.

**Diferença de `probe`:** probe = gera suite de testes adversariais. adversarial-gate = subagente adversarial valida cada tarefa antes de marca como done.

---

## Condições de Ativação

Ative quando:
- Run longa (>5 tarefas, >30 min estimado) — vale o overhead
- Plano com tarefas sequencialmente dependentes (erro em T1 propaga para T5)
- Implementação de agente crítico (guard, nexus, verify)
- Usuário quer "meta runs" de alta qualidade

NÃO ative para: tarefas únicas isoladas; runs < 3 tarefas; operações mecânicas sem julgamento (bash scripts, manifest updates).

---

## Modelo por Etapa

| Etapa | Modelo | Razão |
|-------|--------|-------|
| Injeção da instrução no plano | Haiku | Edição de texto simples |
| Subagente adversarial por tarefa | Sonnet | Validação com julgamento real |
| Decisão final (pass/block) | Sonnet | Binário fundamentado |

---

## Protocolo

### Fase 1 — Localizar Plano Ativo *(Haiku)*

Verificar em ordem:
```bash
ls .claude/todo.md 2>/dev/null
ls sprint-contract.md 2>/dev/null
ls progress.md 2>/dev/null
ls 06-GENERATED/hill-proposals/*/REPORT.md 2>/dev/null | head -1
```

Se nenhum plano encontrado: perguntar ao usuário onde está o plano ativo.

### Fase 2 — Injetar Instrução no Plano *(Haiku)*

Adicionar ao topo do plano ativo:

```markdown
## [ADVERSARIAL GATE — ATIVO]

> Antes de marcar qualquer tarefa como concluída:
> 1. Pausar execução
> 2. Lançar subagente adversarial com contexto isolado (sem histórico da sessão)
> 3. Subagente recebe: (a) descrição da tarefa, (b) output produzido, (c) critério de done
> 4. Subagente emite: PASS | BLOCK com justificativa
> 5. PASS → marcar done, continuar. BLOCK → corrigir antes de avançar.
```

### Fase 3 — Template do Subagente Adversarial *(Sonnet)*

Cada subagente recebe este prompt (contexto isolado — sem história da sessão principal):

```
Você é um revisor adversarial. Seu papel é encontrar por que esta tarefa NÃO está done.
Seja cético por padrão. Confirmar "done" é o resultado mais difícil de atingir.

TAREFA: [descrição da tarefa]
CRITÉRIO DE DONE: [o que "concluído" significa para esta tarefa]
OUTPUT PRODUZIDO: [o que o agente principal produziu]

AVALIE:
1. O output satisfaz TODOS os critérios de done? (binário por critério)
2. Há efeitos colaterais não intencionais?
3. A próxima tarefa do plano poderia falhar por causa de algo neste output?
4. O que o agente principal provavelmente não testou?

VEREDICTO: PASS | BLOCK
Se BLOCK: lista exata do que está faltando ou errado (não vague "pode melhorar").
```

### Fase 4 — Decisão

```
ADVERSARIAL GATE: [nome da tarefa]

Subagente avaliou: [N critérios]
Veredicto: PASS | BLOCK

[Se BLOCK:]
  Bloqueantes:
    - [issue 1 específico]
    - [issue 2 específico]
  Próxima ação: corrigir antes de avançar
```

**Regra de bloqueio:** qualquer issue que afete a próxima tarefa dependente = BLOCK automático.

---

## Restrições

- NUNCA usar o mesmo contexto da sessão principal no subagente adversarial — isolamento é o mecanismo crítico
- NUNCA bloquear por preferência estética — só por critério de done não satisfeito ou impacto na próxima tarefa
- NUNCA remover o gate depois de injetado sem confirmação explícita do usuário
- Se subagente retornar BLOCK 3× seguidas na mesma tarefa: escalar para usuário, não continuar iterando

---

## Relacionado

- [[04-SYSTEM/agents/00-core/verify]] — quality gate no fim do sprint; adversarial-gate é durante
- [[04-SYSTEM/skills/reasoning/probe]] — gera casos de teste; adversarial-gate usa subagente em tempo real
- [[04-SYSTEM/skills/orchestration/subagent-team]] — orquestração de subagentes; adversarial-gate é subagente especializado em revisão
