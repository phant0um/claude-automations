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

Para cada padrão identificado, gerar draft:

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
<Qual problema resolve e em que situações>

## Protocolo
<Passos concretos, não abstratos>

## Quando NÃO usar
<Restrições e exceções>
```

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

## Restrições

- NUNCA criar skill para padrão usado apenas 1x nessa sessão sem justificativa
- NUNCA duplicar skill existente — verificar `04-SYSTEM/skills/` antes
- Confidence < 0.6 → apresentar mas não recomendar criação
- Máximo 3 novas skills por `/evolve` — forçar priorização

## Exemplo

**Contexto:** sessão identificou que ao delegar para subagente sem injetar skills, o agente produzia outputs genéricos.

**Output:** Skill `skill-injection-at-delegation.md` criada. Conteúdo: protocolo de injetar skills no prompt do subagente antes de delegar. Trigger: qualquer delegação via Agent tool.
