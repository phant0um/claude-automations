---
title: "I Tried a Ton of Claude Code Subagents. These 10 Are the Ones I Kept."
type: source
source: "Clippings/I Tried a Ton of Claude Code Subagents. These 10 Are the Ones I Kept..md"
author: "@Voxyz_ai"
published: 2026-06-08
created: 2026-06-09
ingested: 2026-06-09
tags: [ai-agents, claude-code, subagents, practical]
---

## Tese central

Claude Code sem guardrails é um agente ansioso: edita arquivos errados, pula testes, revisa o próprio trabalho, depura por tentativa e erro, e declara "done" cedo demais. A solução não é prompt engineering no agente principal — é uma cadeia de subagentes especializados, cada um com job único, receipt protocol e self-check obrigatório.

Cinco são starred (uso diário): **Only Touch What's Asked**, **Prove It Works**, **Second Eyes**, **Reproduce First**, **Merge Gate**.

## Os 10 Agentes

| # | Nome | Arquivo | Problema resolvido | Ferramentas | maxTurns |
|---|------|---------|-------------------|-------------|----------|
| 1 ⭐ | Only Touch What's Asked | `bounded-implementer.md` | Edita arquivos fora do escopo | Read, Edit, Write, Bash | — |
| 2 ⭐ | Prove It Works | `test-proof.md` | Diz "done" sem rodar testes | Read, Edit, Write, Bash | — |
| 3 ⭐ | Second Eyes | `code-reviewer.md` | Revisa o próprio código | Read, Grep, Bash | 5 |
| 4 ⭐ | Reproduce First | `repro-debugger.md` | Debuga por adivinhação | Read, Edit, Bash | — |
| 5 | Security Gate | `security-auditor.md` | Quebra auth/payment/secrets | Read, Grep, Glob | 4 |
| 6 | Map First | `repo-scout.md` | Edita antes de entender o repo | Read, Glob, Grep, Bash | 6 |
| 7 | Break It Down | `task-splitter.md` | Perde o fio em requisitos grandes | Read | 4 |
| 8 | Check the Ripple | `integration-checker.md` | Quebra callers ao mudar interface | Read, Grep, Glob, Bash | 5 |
| 9 | UI Walkthrough | `ui-acceptance-tester.md` | Botões quebrados, estados vazios | Read, Bash, Glob | 6 |
| 10 ⭐ | Merge Gate | `done-checker.md` | "Done" sem evidência completa | Read, Bash | 3 |

## Key insights

**Receipt protocol**: cada agente retorna um "recibo" estruturado — lista do que fez, o que encontrou, e veredicto `ready` ou `blocked`. O `blocked` é hard stop: propaga pela cadeia e Merge Gate não pode sobrescrever Security Gate.

**Ferramenta como restrição**: Second Eyes e Security Gate excluem `Edit`/`Write` da lista de ferramentas deliberadamente. Sem acesso de escrita, o agente fisicamente não pode modificar código — a restrição é estrutural, não só instrucional.

**Self-check embutido**: cada agente tem uma seção `## Self-check` que define condição de bloqueio automático. Ex: "diff contains a file not mentioned in the spec = blocked receipt".

**Subagents não herdam histórico**: o agente principal deve passar explicitamente o recibo anterior e contexto relevante a cada novo subagente — sem memória compartilhada.

**Compatibilidade Codex**: mesmo design funciona em Codex — regras de projeto em `AGENTS.md`, agentes em `.codex/agents/`. Claude Code auto-delega por `description`; Codex prefere trigger explícito.

**Diferença de Plan Mode**: `task-splitter` (Break It Down) não é o Plan Mode nativo do Claude Code. Plan mode faz pesquisa de codebase; este quebra um requisito grande em subtarefas verificáveis com critérios de aceitação.

## Exemplo de cadeia completa

Requisito: "Add a batch export endpoint to the API"

1. **Map First** → mapeia `src/routes/`, `src/services/`, identifica CODEOWNERS em auth middleware
2. **Break It Down** → 3 tarefas: rota + service / conversão CSV/JSON / permission + rate limit
3. **Only Touch What's Asked** executa Task 1 → diff limpo, 2 arquivos
4. **Prove It Works** → 4 testes novos, todos passando
5. **Second Eyes** → encontra falta de paginação para datasets grandes (severity medium) → bloqueado
6. Only Touch What's Asked corrige → pagination cap 10k rows → Prove It Works + Second Eyes passam
7. Task 3 toca auth → **Security Gate** → sem rate limit → bloqueado
8. Only Touch What's Asked adiciona rate limit → Security Gate passa
9. **Check the Ripple** → tipo frontend desatualizado → bloqueado → corrigido
10. **Merge Gate** → agrega tudo → `ready`

## Setup

```bash
mkdir -p .claude/agents
# salvar cada .md acima em .claude/agents/
```

Regra mestre para `CLAUDE.md` do projeto:

```markdown
## Subagent workflow rule
1. Treat every subagent output as a receipt.
2. If a receipt contains `blocked`, stop the current step.
3. Pass the previous receipt to the next subagent.
4. `done-checker` cannot override `security-auditor`.
```

Para agentes globais (todos os projetos): `~/.claude/agents/`. Projeto tem prioridade sobre user-level. Subagents não podem chamar outros subagents — orquestração é responsabilidade da sessão principal.

## Argumentos principais

- O padrão de "um agente faz tudo" cria acoplamento de responsabilidades que amplifica cada fraqueza do modelo
- Separar concerns por agente especializado + protocolo de receipt é mais robusto que prompt engineering monolítico
- Restrições estruturais (lista de ferramentas) > restrições instrucionais para garantir comportamento
- Bloqueio propagado por cadeia elimina falsos positivos de "done"

## Implicações para o vault

- Os agentes desta fonte são **diretamente adotáveis** no vault-michel: `bounded-implementer`, `test-proof`, `code-reviewer`, `repro-debugger`, `done-checker` como agentes em `04-SYSTEM/agents/`
- O receipt protocol (`ready`/`blocked`) pode ser adotado como padrão de output para todos os agentes do vault
- O self-check embutido é análogo ao `verify` gate já existente no vault SO
- `repo-scout` é especialmente útil para onboarding em novos módulos FIAP

## Links
- [[03-RESOURCES/concepts/claude-code-subagents]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]]
- [[03-RESOURCES/concepts/agent-orchestration]]
- [[03-RESOURCES/concepts/agent-security]]
- [[03-RESOURCES/concepts/agentic-execution]]
- [[04-SYSTEM/agents/core/guard]]
- [[04-SYSTEM/agents/core/verify]]
