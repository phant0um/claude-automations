---
skill: codex-retrospective
version: 1.0
created: 2026-05-29
tags: [retrospective, self-improvement, session-review, behavior, vault-improvement]
trigger: "@retrospective [N dias]" | "revisar sessões dos últimos N dias"
model: sonnet
---

# Skill: codex-retrospective

Revisão do histórico de sessões dos últimos N dias para identificar padrões de comportamento, erros recorrentes, e oportunidades de melhoria. Produz proposta de ajuste cirúrgico (1-3 mudanças concretas), não reescrita completa.

## Quando usar

- Após série de erros similares repetidos
- Semanal como manutenção preventiva
- Antes de `@hill` para dar contexto de diagnóstico
- Quando comportamento do vault parece derivar do esperado

## Protocolo

### 1. Coletar histórico
```bash
# Sessões recentes
ls -t ~/.claude/projects/*/sessions/ 2>/dev/null | head -20

# Logs de erros do vault
tail -50 04-SYSTEM/wiki/errors.md 2>/dev/null

# Commits recentes como proxy de atividade
git log --oneline --since="N days ago" 04-SYSTEM/ 03-RESOURCES/sources/
```

### 2. Analisar padrões

Para cada período revisado, identificar:

| Categoria | Pergunta |
|-----------|---------|
| Erros repetidos | Mesmo tipo de erro ≥2x? |
| Desvios de princípio | Ações fora das guidelines de CLAUDE.md? |
| Fricção recorrente | Mesmo passo manual ≥3x? |
| Gaps de skill | Tarefa sem skill existente ≥2x? |
| Routing incorreto | Modelo errado para tipo de tarefa? |

### 3. Proposta (máx 3 itens)

```markdown
## Retrospectiva [YYYY-MM-DD] — últimos N dias

### Padrão detectado 1
- **O que aconteceu:** <descrição concreta com exemplos>
- **Causa provável:** <diagnóstico>
- **Proposta:** <mudança específica — onde aplicar, o quê mudar>
- **Arquivo alvo:** `<path>`

### Padrão detectado 2
...

### Itens sem mudança proposta
- <observação sem ação necessária>
```

### 4. Gate antes de aplicar

Toda proposta de mudança em `04-SYSTEM/agents/` ou `CLAUDE.md` requer confirmação explícita do usuário antes de aplicar. Esta skill produz a proposta; `@nexus` ou usuário aprova.

Mudanças em `04-SYSTEM/skills/` podem ser aplicadas autonomamente se escopo for cirúrgico (1 arquivo, ≤20 linhas).

## Output esperado

- Máximo 3 padrões identificados
- 1 proposta concreta por padrão
- Nenhuma mudança aplicada sem gate explícito para agents/CLAUDE.md

## Relacionado

- [[04-SYSTEM/skills/core/evolve]] — complementar: retrospective = olha N dias para trás; evolve = captura padrões da sessão ATUAL antes que sumam do contexto. Usar evolve ao fim de sessão intensa, retrospective como manutenção periódica.
- [[04-SYSTEM/skills/reasoning/hill-climb]] — melhoria de agente específico (hill tem escopo, retrospective tem perspectiva temporal)
- [[04-SYSTEM/agents/core/hill]] — agente que implementa as mudanças propostas
- [[04-SYSTEM/wiki/errors]] — log de erros que alimenta esta skill
- [[03-RESOURCES/sources/skills-prompting-mcp/claude-arsenal-codex-retrospective-skill]] — inspiração original
