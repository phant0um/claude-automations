---
name: tdd
description: "Test-driven development. Use when building features or fixing bugs test-first, mentions red-green-refactor, or wants integration tests."
skill: tdd
version: 1.0
author: Nexus Agent System
source: mattpocock/skills (tdd)
trigger: "/tdd" | "@tdd" | "red-green-refactor" | "test-first"
model: claude-sonnet-4-6
tags: [testing, tdd, red-green-refactor, tracer-bullet, vertical-slices]
---

# Skill: TDD

## Propósito

Desenvolvimento test-first com vertical slices (tracer bullets). Cada teste é uma slice end-to-end que corta todas as camadas — não horizontal slices de uma camada só.

> **Leading word: tracer bullet.** Um teste que corta todas as camadas end-to-end, prova que o path funciona, e guia o próximo.

---

## Condições de Ativação

Ative quando:
- `@tdd` ou `/tdd` chamado explicitamente
- User menciona "red-green-refactor" ou "test-first"
- Implementação de feature nova com interface definida
- Fix de bug que deveria ter sido pego por teste

NÃO ative para: config pura, docs, migrations de DB sem lógica, protótipos throwaway.

---

## Anti-Pattern: Horizontal Slices

**NÃO escreva todos testes primeiro, depois toda implementação.** Isso é "horizontal slicing" — tratar RED como "escrever todos testes" e GREEN como "escrever todo código."

Produz **crap tests**:
- Testes em bulk testam behavior imaginado, não atual
- Testam shape de coisas (data structures, signatures) não behavior user-facing
- Testes ficam insensíveis a mudanças reais — passam quando behavior quebra
- Você ultrapassa seus headlights, commitando estrutura de teste antes de entender a implementação

**Correto**: Vertical slices via tracer bullets. 1 teste → 1 implementação → repeat.

```
ERRADO (horizontal):
  RED: test1, test2, test3, test4, test5
  GREEN: impl1, impl2, impl3, impl4, impl5

CORRETO (vertical):
  RED→GREEN: test1→impl1
  RED→GREEN: test2→impl2
  RED→GREEN: test3→impl3
  ...
```

---

## Protocolo

### 1. Planning

Antes de escrever código:
- [ ] Confirmar com user quais mudanças de interface são necessárias
- [ ] Confirmar quais behaviors testar (priorizar)
- [ ] Identificar oportunidades para deep modules (interface pequena, implementação profunda)
- [ ] Listar behaviors a testar (não steps de implementação)
- [ ] Aprovação do user no plano

> Não dá para testar tudo. Confirmar com user exatamente quais behaviors importam mais.

### 2. Tracer Bullet

Escreva 1 teste que confirma 1 coisa:

```
RED: Escreve teste para primeiro behavior → teste falha
GREEN: Escreve código mínimo para passar → teste passa
```

Este é o tracer bullet — prova que o path funciona end-to-end.

### 3. Incremental Loop

Para cada behavior restante:

```
RED: Escreve próximo teste → falha
GREEN: Código mínimo para passar → passa
```

Regras:
- 1 teste por vez
- Apenas código suficiente para passar o teste atual
- Não antecipar testes futuros
- Testes focados em behavior observável

### 4. Refactor

Após todos testes passarem:
- [ ] Extrair duplicação
- [ ] Deepen modules (mover complexidade atrás de interfaces simples)
- [ ] Aplicar SOLID onde natural
- [ ] Considerar o que o código novo revela sobre código existente
- [ ] Rodar testes após cada step de refactor

> **Nunca refactor enquanto RED.** Chegue ao GREEN primeiro.

---

## Checklist por ciclo

```
[ ] Teste descreve behavior, não implementação
[ ] Teste usa apenas interface pública
[ ] Teste sobreviveria a refactor interno
[ ] Código é mínimo para este teste
[ ] Sem features especulativas
```

---

## Completion

- [ ] Plano aprovado pelo user (behaviors priorizados)
- [ ] Tracer bullet executado (1 teste → 1 impl → pass)
- [ ] Loop incremental completo (todos behaviors cobertos)
- [ ] Refactor executado com testes verdes após cada step
- [ ] Suite completa passa
- [ ] Zero features especulativas adicionadas

## Failure modes

- **Horizontal slicing**: escrever 5 testes depois 5 impls → testes imaginam behavior, não verificam
- **Implementation-detail tests**: mockar collaborators internos, testar private methods → testes quebram em refactor sem behavior change
- **Speculative features**: adicionar código "que vai ser útil" sem teste que exija → YAGNI violation
- **Refactor while RED**: refactorear com testes falhando → sempre GREEN antes de refactor

---

## Good vs Bad Tests

**Good**: integration-style, exercita code paths reais via API pública. Lê como especificação: "user can checkout with valid cart".

**Bad**: coupled a implementação. Mocka internals, testa private methods, verifica via DB query em vez de interface. Sinal: teste quebra em refactor sem behavior change.

---

## Mocking

Mock apenas em **system boundaries**:
- APIs externas (payment, email)
- Databases (preferir test DB)
- Time/randomness
- Filesystem (às vezes)

NÃO mock:
- Suas próprias classes/módulos
- Collaborators internos
- Qualquer coisa que você controla

---

## Self-Improvement

Após cada execução:
1. Se teste quebra em refactor sem behavior change → registrar padrão de implementation-detail test em `06-GENERATED/tasks/lessons.md`
2. Se horizontal slicing detectado → flag para @hill com contexto
3. Lições append: `- YYYY-MM-DD: [tdd] N tracer bullets, M refactors, behavior coverage=X%`

> Ver: [[04-SYSTEM/skills/reasoning/hill-climb]] · [[03-RESOURCES/concepts/pkm-obsidian/autoresearch-loop]]

---

## Restrições

- NUNCA escrever todos testes antes de toda implementação (horizontal slicing)
- NUNCA testar private methods ou internals
- NUNCA adicionar features especulativas sem teste que exija
- NUNCA refactor enquanto RED

---

## Relacionado

- [[04-SYSTEM/skills/foundational/spec-lifecycle]] — spec antes de implementar; TDD executa a implementação
- [[04-SYSTEM/skills/core/complexity-ratchet]] — coverage ratchet complementa TDD
- [[04-SYSTEM/skills/core/spec-verify]] — verifica spec contra implementação
- [[03-RESOURCES/sources/ai-agents/matt-pocock-skills-14-analysis]] — fonte original