---
name: evolve
description: "Use when extracting reusable patterns from the current session to crystallize as new skills. Scans conversation for techniques that worked, filters by quality criteria, and proposes skill creation with confidence scores."
slug: evolve
version: 1.1
model: claude-sonnet-4-6
trigger: "/evolve"
---

# Skill: /evolve

Ao ser invocado com `/evolve`, executa:

## Fase 1 — Retrospectiva da Sessão

Varrer o contexto da conversa atual e identificar:

```
□ Padrões que funcionaram (abordagem que resolveu problema real)
□ Heurísticas descobertas (regra que se revelou útil, não óbvia)
□ Sequências de passos que não existiam como skill
□ Correções aplicadas que deveriam ser permanentes
□ Decisões recorrentes que poderiam ser automatizadas
```

**Filtro de qualidade:** só capturar se:
- Não é óbvio da documentação existente
- Resolveu um problema real (não teórico)
- Aplicável em sessões futuras (não apenas nesta)
- Não duplica skill existente em `04-SYSTEM/skills/`

## Fase 2 — Draft da Nova Skill

Para cada padrão identificado, gerar draft aplicando **princípios Pocock de qualidade** (ver `references/writing-great-skills-pocock.md`):

```markdown
---
name: <slug-descritivo>
version: 1.0
model: <modelo mínimo necessário>
trigger: <quando usar>
confidence: <0.0–1.0>  # quão genérico é o padrão
origin_session: <data>
---

# Skill: <Nome>

## Contexto
<Qual problema resolve e em que situações. Deve conter um leading word — conceito compacto do pretraining que ancora comportamento.>

## Protocolo
<Passos concretos, não abstratos. Cada passo termina em completion criterion: checkable + exhaustive.>

## Completion
- [ ] <critério checkable>

## Failure modes
- **<modo>**: <sintoma> → <defesa>

## Quando NÃO usar
<Restrições. Aplicar no-op test em cada NUNCA: "Isso muda comportamento vs default do modelo?" Se não, deletar.>
```

**Quality gate antes de apresentar ao usuário:**
- [ ] Leading word identificado (conceito compacto do pretraining)
- [ ] Completion criterion é checkable (agent distingue done de not-done)
- [ ] Failure modes documentados (mínimo 2)
- [ ] No-op test aplicado nas restrições (NUNCA que não muda comportamento = deletar)
- [ ] Se skill >80 linhas: considerar progressive disclosure (splitar reference em `references/`)

## Fase 3 — Triagem e Decisão

Apresentar ao usuário:

```
EVOLVE REPORT — <data>

Padrões candidatos: N

[1] <nome> — confiança: X.X
    Capturado de: <resumo do que aconteceu>
    Aplicável quando: <trigger>
    → Criar skill? [S/N]

[2] ...

Ação: confirme quais criar. Discarded ficam no log mas não viram skill.
```

## Fase 4 — Criação

Para cada padrão aprovado:
1. Criar arquivo em `04-SYSTEM/skills/core/<slug>.md`
2. Registrar em `04-SYSTEM/wiki/hot.md` se alta frequência esperada
3. Reportar: "Skill `<slug>` criada. Trigger: `<quando usar>`."

## Self-Improvement Loop Integration

When a sessão reveals that rotinas/agents/skills have most prerequisites of the autoresearch-loop pattern but are missing one (typically the **lessons log**), do NOT create a new skill — patch the existing rotina/agent/skill to close the loop.

The 5 prerequisites (from `autoresearch-loop` concept): fitness function, executor, keep-or-revert, lessons log, budget.

**Pattern:** add a bash-only `## Self-improvement log` block that appends 1 line of metrics to `06-GENERATED/tasks/lessons.md`. Zero AI cost. See `references/self-improvement-loop-integration.md` for the full compatibility matrix and integration template.

**When NOT to patch:** rotinas that are output-only (daily-brief, x-thread-weekly) or one-shot (vault-backup) are not loops by design — forcing lessons log on them is over-engineering.

**Skill-to-rotina integration:** when auditing existing skills after upgrades, check if new/upgrade skills fit into existing rotinas as conditional triggers. See `references/skill-rotina-agent-integration.md` for the cross-referencing methodology and session 2026-06-24 results (3 rotina integrations + 5 agent integrations).

**Multi-component phase injection:** when an existing skill fills a gap in multiple components (skills, agents, rotinas), inject it as a new phase in each — with skip conditions per component. Inverse of skill-to-rotina: existing skill → find components. See `references/skill-rotina-agent-integration.md` Session 2026-06-24b (4 skill integrations: forge, ralph-loop, complexity-ratchet, requesting-code-review + 2 agent protocol injections: herald, pena).

**Community skill gap analysis:** when comparing external tool skills against vault agents, inject structured protocols into existing agents rather than creating new skills. Classify gaps as covered/partial/gap, inject protocol into the owning agent, divide labor between overlapping agents. See `references/skill-rotina-agent-integration.md` Session 2026-06-24b (herald: 4 protocols, pena: 1 protocol).

**Full-cycle community skill mapping:** when user asks about a batch of external skills, follow the full cycle: research → map (covered/partial/gap) → integrate partials → close gaps by extending agents → create rotina if structural gaps unmonitored → log. See `references/skill-rotina-agent-integration.md` Session 2026-06-24c (9 community skills mapped: 4 covered, 4 partial→resolved, 1 gap→resolved; forge migration review; skill-audit rotina created).

**Gap → extend agent vs create skill:** when a gap maps to an agent's territory but the agent lacks the capability, extend the agent with a new phase rather than creating a standalone skill. Decision criterion: would a new skill duplicate the agent's routing? If yes → extend the agent. If no → create a skill.

**Vault sources as build blueprints:** when creating a study plan or career roadmap and the user asks about exploring existing vault sources as projects to build from scratch, map already-ingested source pages to constructible projects. Scan sources for architecture-describing content, extract reduced-scope MVP shape, integrate as "parallel projects" in study plan phases. This is the inverse of normal skill-source-audit (vault sources → learning goals, not external repos → vault). See `skill-source-audit/references/vault-sources-as-build-blueprints.md`. Session 2026-06-24: 7 projects mapped from vault sources (React Doctor, Knowledge Graph, Session Search CLI, Quant Loop, AI Scouting Agent, Security Auditor, Memory Layer) integrated into career-uplift 6-phase plan.

**Skill-authoring quality:** when drafting new skills in Fase 2, apply Matt Pocock's writing-great-skills principles — leading words, progressive disclosure, no-op pruning. See `references/writing-great-skills-pocock.md`.

**Skill audit:** when auditing existing skills against Pocock principles (sprawl, completion criterion, no-op risk, failure modes), use the 7-dimension script in `references/skill-audit-methodology.md`.

**Orphan detection:** when user asks about unused skills or during monthly audit, follow the detection + integration protocol in `references/orphan-skill-detection.md`.

## Session 2026-06-24 — Pocock Audit + Skill Creation Summary

This session applied Pocock's "writing-great-skills" framework to audit and upgrade the entire vault skill library:

- **37→43 skills** (6 created: tdd, implement, prototype, resolving-merge-conflicts, to-issues, triage)
- **Completion criterion: 4→41/43 (95%)** — added ## Completion to 35 skills (checkable + exhaustive)
- **Failure modes: 4→41/43 (95%)** — added ## Failure modes to 35 skills
- **No-op prune: 2 deleted** from code-optimize + meta-meta-prompt
- **6 skills upgraded** (P0-P5): diagnose v2 (tight loop), tdd (new), git-guardrails hook, grill-me (Doc Capture), decisions (domain modeling), code-optimize (deep modules)
- **14/14 Pocock skills covered** (6 upgrades + 5 created + 2 equivalents + 1 via CLAUDE.md)
- **8 leading words** (ratchet, gate, probe, tight, deep, tracer bullet, seam, throwaway)
- **3 rotina integrations**: revisao-semanal F3.4 (diagnose + grill-me), rotina-audit-mensal §6.8 (code-optimize)
- **5 agent integrations**: forge (deep modules), extend (tight loop), spec (Doc Capture), verify (diagnose), orchestrator (deep modules)

## Completion

- [ ] Fase 1 retrospectiva: padrões que funcionaram identificados (não teóricos)
- [ ] Fase 2 drafts gerados com frontmatter completo (name, version, model, trigger, confidence)
- [ ] Fase 3 triagem apresentada ao usuário com confidence scores
- [ ] Fase 4 skills aprovadas criadas em `04-SYSTEM/skills/core/<slug>.md`
- [ ] Skills não-duplicadas (verificado contra `04-SYSTEM/skills/` existente)
- [ ] Máximo 3 novas skills por /evolve (priorização forçada)
- [ ] Hot.md atualizado se alta frequência esperada

## Failure modes

- **Confidence inflation**: padrão usado 1x marcado como confidence 0.8 → mínimo 2 usos para confidence > 0.6
- **Skill duplicada**: criar skill que já existe com outro nome → sempre grep `04-SYSTEM/skills/` antes
- **Padrão teórico**: capturar padrão que não resolveu problema real → só capturar se resolveu algo concreto na sessão
- **Over-creation**: 5+ skills propostas num único /evolve → forçar priorização, máximo 3

---

## Restrições

- NUNCA criar skill para padrão usado apenas 1x nessa sessão sem justificativa
- NUNCA duplicar skill existente — verificar `04-SYSTEM/skills/` antes
- Confidence < 0.6 → apresentar mas não recomendar criação
- Máximo 3 novas skills por `/evolve` — forçar priorização

## Exemplo

**Contexto:** sessão identificou que ao delegar para subagente sem injetar skills, o agente produzia outputs genéricos.

**Output:** Skill `skill-injection-at-delegation.md` criada. Conteúdo: protocolo de injetar skills no prompt do subagente antes de delegar. Trigger: qualquer delegação via Agent tool.