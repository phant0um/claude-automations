---
title: "/goal — Como Estruturar o Melhor Comando no Codex e Claude Code"
type: source
source_file: Clippings/Post by @kloss_xyz on X.md
origin: post no X (@kloss_xyz)
ingested: 2026-05-14
tags: [goal-command, claude-code, codex, hermes, prompt-engineering, agent-workflow]
---
# /goal — Como Estruturar o Melhor Comando no Codex e Claude Code

> [!key-insight] Core point
> O comando /goal é o mais poderoso no Codex, Claude Code e Hermes — mas a maioria usa errado escrevendo apenas "não cometa erros"; a estrutura correta define missão, contexto, constraints, plano, critérios de done e stop rules.

## Conteúdo

### Por que a maioria usa errado

- Escrevem "não cometa erros" e rezam
- Falta estrutura para: missão clara, classificação de incertezas, eliminação de scope creep, fechamento de loops

### Estrutura completa do /goal

```
GOAL:
<resultado único claro e mensurável; apenas uma missão>

CONTEXT:
<repositório/arquivos/arquitetura/estado atual>
<suposições conhecidas, dependências e decisões anteriores relevantes>

CONSTRAINTS:
<o que não deve mudar>
<padrões/requisitos obrigatórios>
<arquivos/ações proibidos, se houver>

PRIORITY: (opcional)
1. <prioridade mais alta>
2. <prioridade secundária>
3. <prioridade terciária>

PLAN:
<entenda primeiro, depois aja>
<reafirme o entendimento antes de executar mudanças não triviais>
<prefira mudanças mínimas suficientes em vez de reescritas amplas>

DONE WHEN:
<estado de conclusão verificável>
<comportamento esperado preservado ou melhorado>

VERIFY:
<testes/build/lint/typecheck/validação manual>
<declare o que não pôde ser verificado e por quê>
<inclua plano de rollback/contenção para mudanças destrutivas>

OUTPUT:
<resumo conciso/docs/auditoria/resultado>
<arquivos alterados, decisões chave, riscos e follow-ups>

STOP RULES:
<pare em ambiguidades ou riscos de alto impacto>
<superfície incertezas com propostas de maior confiança antes de agir>
<não continue expandindo escopo após objetivo satisfeito>
```

## Conexões

- [[03-RESOURCES/concepts/goal-prompt-structure]]
- [[03-RESOURCES/concepts/prompt-engineering-patterns]]
- [[03-RESOURCES/entities/Hermes-Agent]]
- [[03-RESOURCES/entities/Claude Code]]
