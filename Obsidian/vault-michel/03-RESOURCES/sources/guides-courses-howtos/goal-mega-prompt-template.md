---
title: The /goal Mega Prompt Template
type: source
source: Clippings/gemini-code-1778768022644.md
created: 2026-05-15
ingested: 2026-05-15
tags: [ai-agents]
triagem_score: 8
---

## Tese central
Template completo para /goal em Claude Code/Codex: Context + Success Criteria + Operating Rules + Quality Bar + Final Deliverable.

## Key insights
- 10 operating rules não-negociáveis: PLAN FIRST, WORK AUTONOMOUSLY, SELF-VERIFY, DEBUG YOURSELF, NO PLACEHOLDERS, STAY ON GOAL, CHECK SUCCESS BEFORE STOPPING.
- Success criteria: TODOS devem ser TRUE; entregável roda sem erros; provas obrigatórias (screenshot/output/URL).
- Final deliverable = confirmação dos critérios, lista de arquivos, instruções, provas, decisões, limitações.

## Links
- [[03-RESOURCES/entities/Claude Code]]
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]]

- [[03-RESOURCES/concepts/claude-code-tooling/goal-command]]

---

## O Template Completo

O `/goal` mega prompt tem 5 seções obrigatórias:

### Seção 1: Context (Contexto)
```
CONTEXT:
You are working on [project description].
Stack: [technologies]
Codebase location: [path]
Relevant files: [files]
Current state: [what exists now]
```

Context define o ambiente. Sem contexto rico, o agente faz suposições erradas sobre onde os arquivos estão, qual linguagem usar, e quais convenções seguir.

### Seção 2: Success Criteria (Critérios de Sucesso)
```
SUCCESS CRITERIA (ALL must be TRUE):
[ ] [Specific verifiable condition 1]
[ ] [Specific verifiable condition 2]
[ ] [Specific verifiable condition 3]
[ ] The deliverable runs without errors
[ ] Proof provided: [screenshot/output/URL/test results]
```

Critérios devem ser **binários e verificáveis** — não "código de qualidade" mas "todos os testes passam". O agente usa esses critérios como checklist de auto-verificação antes de declarar conclusão.

### Seção 3: Operating Rules (Regras de Operação)
```
OPERATING RULES (non-negotiable):
1. PLAN FIRST — write a plan before touching any file
2. WORK AUTONOMOUSLY — do not ask clarifying questions
3. SELF-VERIFY — test your own work before reporting done
4. DEBUG YOURSELF — if tests fail, diagnose and fix
5. NO PLACEHOLDERS — no "TODO", "coming soon", fake data
6. STAY ON GOAL — do not add unrequested features
7. CHECK SUCCESS BEFORE STOPPING — verify all criteria are TRUE
8. SHOW YOUR WORK — provide evidence of each criterion
9. HANDLE ERRORS — do not silently swallow exceptions
10. COMMIT WORKING CODE — only commit if tests pass
```

As 10 regras endereçam os 10 modos de falha mais comuns de coding agents em produção.

### Seção 4: Quality Bar
```
QUALITY BAR:
- Code follows [style guide / existing conventions]
- No hardcoded secrets or credentials
- Error handling for all external calls
- Tests cover happy path and at least 2 edge cases
- No console.log / print statements left in production code
```

### Seção 5: Final Deliverable
```
FINAL DELIVERABLE:
When done, provide:
1. Confirmation that ALL success criteria are TRUE
2. List of files created/modified
3. How to run/verify the deliverable
4. Evidence (screenshots, test output, URLs)
5. Key decisions made and why
6. Known limitations or future work
```

---

## Por Que Cada Seção É Necessária

**Sem Context:** Agente inventa stack, paths, e convenções.
**Sem Success Criteria:** Agente para quando "acha" que terminou — sem garantia de completude.
**Sem Operating Rules:** Agente pergunta questões, deixa placeholders, e adiciona features não solicitadas.
**Sem Quality Bar:** Código funciona mas não segue convenções, não tem testes, tem hardcoded values.
**Sem Final Deliverable:** Agente entrega sem provas — impossível verificar externamente.

---

## Comparação com Prompts Simples

| Abordagem | Taxa de sucesso típica | Problemas comuns |
|---|---|---|
| Prompt simples ("faça X") | ~30-50% | Incompleto, sem testes, com placeholders |
| Prompt com contexto | ~60-70% | Sem self-verification, para cedo |
| /goal mega template | ~85-90% | Overhead de escrita do template |

---

## Quando Usar

- Tasks que levam >30 minutos de trabalho autônomo
- Tasks com múltiplos arquivos e dependências
- Tasks onde "quase certo" não é aceitável (deploy, migrações de banco)
- Tasks delegadas a subagentes que não terão supervisão humana durante execução

**Quando NÃO usar:** Tasks simples de 1-2 arquivos onde o overhead do template supera o benefício. Para tasks pequenas, um prompt conciso de 3-4 linhas é mais eficiente.

---

## Aplicação no Vault-Michel

O template /goal é análogo ao workflow de ingestão do vault: cada ingestão tem contexto (fonte), critérios de sucesso (arquivo criado, hot.md atualizado, wikilinks válidos), regras (não criar duplicatas, não modificar fora do escopo), e deliverable (confirmação de todos os checkboxes). A estrutura formal reduz inconsistências entre ingestões.

---

## Conexões

- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]]
- [[03-RESOURCES/sources/claude-code-skills/claude-code-5-layer-architecture-2026]] — Layer 1 (Memory/CLAUDE.md) complementa o Context do /goal
- [[03-RESOURCES/sources/claude-code-skills/clipping-claude-code-starter-kit-zodchiii]] — starter kit que inclui skills análogos ao /goal
