---
title: "How to Use /goal In Codex Like a Pro"
type: source
source_file: Clippings/How to Use goal In Codex Like a Pro.md
origin: post no X
author: "@ziwenxu_"
published: 2026-05-01
ingested: 2026-05-14
tags: [codex, goal-command, agentic, openai, outcome-declaration, long-running-sessions]
---

# How to Use /goal In Codex Like a Pro

> [!key-insight] Core insight
> `/goal` transforma o Codex de um executor de passos em um motor de verificação de realidade: em vez de "faça X", você declara "X é verdade" — e o agente continua trabalhando até que seja.

## Sections

### O Conceito Central

- Prompt regular = instrução (o que fazer)
- `/goal` = condição de sucesso (o que deve ser verdade ao final)
- "Intention Decay": em chats normais, a missão original se perde sob o peso do trabalho conforme o context window enche; `/goal` age como âncora persistente de sessão

### Toolkit de Comandos

| Comando | Função |
|---------|--------|
| `/goal <objetivo>` | Define ou substitui a missão |
| `/goal` | Verifica status |
| `/goal pause` | Pausa |
| `/goal resume` | Retoma |
| `/goal clear` | Limpa antes de trabalho não relacionado |
| `Shift+Tab` | Sai do Plan Mode antes de executar |
| `codex resume <id>` | Recupera sessões longas |

### Status Possíveis

- **PURSUING / ACTIVE** — loop em execução
- **PAUSED** — aguardando ajuste de constraints
- **ACHIEVED / COMPLETE** — missão cumprida
- **UNMET** — agente não encontrou caminho para o objetivo
- **BUDGET_LIMITED** — limite de tokens atingido

### Template de /goal Bem Escrito

```
/goal Make [final outcome] true.
Scope: [what Codex can touch]

Constraints:
- [what must not change]
- [rules to follow]

Done when:
1. [verifiable condition]
2. [test/command/file that proves progress]
3. [final evidence]

Stop if:
- [condition where Codex should pause]
- [anything risky or destructive]
```

### 6 Falhas Comuns

1. **Plan Mode Trap** — `/goal` dentro de `/plan` não inicia loop; exit via Shift+Tab primeiro
2. **Mid-Run Amnesia** — auto-compact durante goal pode perder o "North Star"; não use `/compact` manual durante goal
3. **Ghost Session** — iniciar thread com `/goal` esconde na história; enviar uma linha de status antes
4. **Vague Adjectives** — "improve", "all", "thorough" são poison; usar estados verificáveis
5. **No Kill Switch** — adicionar sempre "Limit this run to X tokens"
6. **Sledgehammer Problem** — agente pode deletar/dropar para limpar; usar "Stop if" para operações destrutivas

### Quando Usar (e Quando Não Usar)

**Bom:** bug com testes + risk review, preparar repo para launch, sync de docs/scripts/tests, migração com limites claros, implementar spec, auditoria end-to-end

**Ruim:** perguntas pontuais, edições mínimas, pedidos vagos ("improve everything"), decisões de produto que precisam de taste, operações destrutivas sem aprovação humana

### O Pattern Arquiteto

1. **Plan** até a condição de sucesso estar clara
2. **Audit** o plano contra o repo
3. **Execute** com /goal

> "Prompts are for conversation. Goals are for shipping."

## Conexões

- [[03-RESOURCES/concepts/goal-command]] — conceito central; atualizar com contexto Codex CLI
- [[03-RESOURCES/concepts/context-engineering]] — intention decay é problema de context rot
- [[03-RESOURCES/concepts/multi-agent-orchestration]] — long-running sessions 10h-20h
- [[03-RESOURCES/entities/Claude Code]] — /goal também disponível no Claude Code
