---
title: Claude Code Workflow — EPCC (Explore → Plan → Code → Commit)
type: concept
status: developing
tags: [claude-code, workflow, epcc, plan-mode, subagents, code-review, advanced-techniques]
created: 2026-04-20
updated: 2026-05-02
---

# Claude Code Workflow — EPCC

O workflow de quatro fases recomendado oficialmente pela Anthropic para uso efetivo do Claude Code. Evita o erro mais comum: pular direto para "escreva código" sem contexto adequado.

> Regra de ouro: quanto mais cedo você course-corrige, mais barato (em tempo, tokens e re-trabalho).

---

## Fase 1 — Explore

**Objetivo:** dar ao Claude o contexto relevante sem escrever código ainda.

**Como:** ativar **Plan Mode** (Shift + Tab até aparecer "Plan Mode") e descrever o que precisa ser feito.

Claude usa ferramentas somente-leitura para:
- Ler arquivos relevantes do codebase
- Buscar documentação na web
- Entender dependências existentes
- Mapear onde a mudança se encaixa na arquitetura

> Dica: é possível usar o subagent de exploração fora do Plan Mode para obter summary geral do codebase sem intenção de fazer mudanças.

---

## Fase 2 — Plan

**Objetivo:** revisar e validar o plano antes de qualquer código ser escrito.

Claude retorna plano detalhado após Explore. O plano inclui:
- Arquivos que serão modificados
- Dependências a instalar
- Sequência de implementação
- Clarificações se necessário

**Este é o momento certo para course-correct.** Pedir revisões específicas aqui é grátis — nenhum código foi escrito ainda.

Após aprovação do plano, Claude usa o plano como **success criteria** para medir quando terminou.

---

## Fase 3 — Code

**Objetivo:** implementação guiada pelo plano aprovado.

Aceitar plano → Claude executa cada item. Você controla o nível de aprovação:
- **Auto-accept:** edições automáticas; comandos ainda pedem aprovação
- **Approval:** aprovação explícita em cada edição e comando

### Tips para Code Phase

**Defina success criteria explícito.**
Claude precisa saber o que "correto" significa. Inclua no prompt/plano:
- Comportamento esperado
- Casos de borda
- Saídas esperadas

**Adicione ferramentas.**
Exemplo: instalar Claude in Chrome extension para testar UIs diretamente — elimina o loop "editar → descrever o que vejo → Claude corrige".

**Include a test suite.**
Claude pode escrever os testes. Uma test suite confiável permite validação autônoma contínua. Garantir que os testes são fonte de verdade (sem false positives).

**Se Claude repetir o mesmo erro, pedir para salvar a solução no CLAUDE.md.**

---

## Fase 4 — Commit

**Objetivo:** revisão final + push seguro.

### Subagent Code Review
Antes do commit: criar subagent reviewer com **ferramentas read-only** para revisar as mudanças.

Por que subagent e não o mesmo Claude?
- Contexto **fresh** — sem o bias de ter escrito o código
- Vê o resultado final sem "o caminho que levou até aqui"
- Configurar reviewer uma vez e commitar no repo → time todo usa

### Commit message
Pedir ao Claude para gerar commit message no seu estilo.

### Skill `/commit-push-pr`
Automatiza commit + push + PR creation em um passo.

Se Slack MCP configurado com canais no CLAUDE.md → PR link postado automaticamente no canal da equipe.

### Retomar PRs com `--from-pr`
```bash
claude --from-pr <PR_NUMBER>
```
Retoma a sessão vinculada ao PR — útil para endereçar review comments ou corrigir builds quebrados.

---

## Resumo EPCC

| Fase | O que acontece | Output |
|------|---------------|--------|
| **Explore** | Claude lê codebase + docs (read-only) | Entendimento do contexto |
| **Plan** | Claude propõe plano detalhado | Plano aprovado = success criteria |
| **Code** | Implementação com aprovação controlada | Código testado |
| **Commit** | Subagent review → commit → PR | PR criado e revisado |

---

---

## Advanced Techniques (35 técnicas, 5 categorias)

Fonte completa: [[03-RESOURCES/sources/35-claude-code-commands-tricks-workflows]] (Khairallah AL-Awady).

### Gestão de Sessão
- `/compact` — comprime histórico após 30-45min; mantém Claude afiado
- `/clear` — nova task = nova conversa; evita contaminação
- `/cost` — monitorar gasto de tokens
- Multi-Model Switching — Opus para arquitetura, Sonnet para implementação

### Produtividade
- **Reference File:** apontar arquivo existente como padrão
- **Test-First:** testes antes de implementação
- **Incremental Build:** 5 passos pequenos > 1 prompt massivo
- **Diff Review:** após mudanças, pedir diff de TODOS arquivos
- **Error Paste:** error completo + stack trace + "step-by-step diagnosis"
- **Undo Checkpoint:** `git commit -m "checkpoint"` antes de mudanças grandes
- **Parallel Session:** dois terminais com contextos isolados

### Arquitetura
- **Architecture Audit:** pedir 2 abordagens com diagrama, prós/contras
- **Pattern Enforcer:** documentar arquivos de referência no CLAUDE.md
- **Migration Builder:** lista de TODOS arquivos afetados antes de mudar
- **Security/Performance Scan:** prompts estruturados para auditoria
- **Refactoring Planner:** "Propose plan. Do NOT start yet."

### Automação Workflow
- Git hooks com Husky (linter, type check, console.log scan)
- GitHub Actions CI via conversa
- `setup.sh` de onboarding gerado pelo Claude
- Release notes a partir do git log
- Database seed com edge cases

### Debug + Recovery
- **Reproduction Prompt:** minimal repro → failing test → fix
- **Blame Investigator:** git log da semana anterior
- **Recovery Mode:** quando ciclo longo acumula erros — PARAR, voltar via git, restartar diferente

### Setup Inicial (5 min)
1. `/init` → gera CLAUDE.md
2. Adicionar coding standards ao CLAUDE.md
3. `/memory` → regras persistentes globais
4. Plan Mode (Shift+Tab) → arquitetura antes de código
5. Build incremental com testes

---

## Relação com Outros Conceitos

- [[03-RESOURCES/concepts/agent-systems/agentic-agents]] — EPCC é o workflow do Claude Code como agente
- [[03-RESOURCES/concepts/llm-ml-foundations/context-window]] — Plan Mode economiza context na fase Explore/Plan
- [[03-RESOURCES/concepts/llm-ml-foundations/context-rot]] — causa dos sintomas que /compact e /clear resolvem
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — MCP servers são as ferramentas usadas em todas as fases
- [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]] — hooks automatizam partes do Code + Commit (formatação, gates)
- [[03-RESOURCES/concepts/claude-code-tooling/claude-folder-anatomy]] — CLAUDE.md, /init, /memory, regras por path
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — subagents no Commit e na Explore phase

## Fontes

- [[03-RESOURCES/sources/guides-courses-howtos/claude-code-101]] — descrição oficial do workflow EPCC
- [[03-RESOURCES/sources/35-claude-code-commands-tricks-workflows]] — 35 técnicas avançadas (tabelas completas)
- [[03-RESOURCES/sources/skills-prompting-mcp/clipping-claudemd-senior-engineer-srishticodes]] — workflows de [[03-RESOURCES/entities/Boris-Cherny]]; self-improvement loop; autonomous bug fixing como extensão do EPCC
- [[03-RESOURCES/sources/skills-prompting-mcp/boris-cherny-claude-md-anatomy]] — 13 princípios numerados de Cherny; tabela verbatim → significado prático; adiciona Minimal Impact como regra explícita (#13)

## Evidências
- **[2026-06-24]** SNS não cresce por falta de sistema, não de talento. Claude Code + 3 materiais (口調/型/ネタ) = pipeline de conteúdo... — [[claude-code-sns-auto-operation]]
- **[2026-06-24]** Artifacts é prototipagem rápida visível/tocável, não app de produção. Ideal para: screenshot → mockup, ferramentas... — [[claude-artifacts-practical-guide]]
