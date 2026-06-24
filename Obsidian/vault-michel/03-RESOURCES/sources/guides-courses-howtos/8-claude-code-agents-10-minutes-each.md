---
title: "8 Claude Code Agents You Can Build in Under 10 Minutes Each"
type: source
author: "@zodchiii"
url: "https://x.com/zodchiii/status/2054853752587235778"
published: 2026-05-14
ingested: 2026-05-14
tags: [claude-code, subagents, agents, automation, developer-workflow]
triagem_score: 8
---

# 8 Claude Code Agents You Can Build in Under 10 Minutes Each

## Summary

Thread por @zodchiii demonstrando 8 agents prontos para uso no Claude Code, cada um como um único arquivo markdown em `.claude/agents/`. O argumento central: tarefas repetitivas de dev (PR, deps, changelog, coverage, dead code, migrations, docs, logs) podem ser delegadas a agents isolados que retornam apenas resumos limpos ao contexto principal — reduzindo uso de tokens em ~90%.

## Como Agents Funcionam (mecanismo)

- Crie um arquivo `.md` em **`.claude/agents/`** (escopo projeto) com frontmatter YAML
- Campos obrigatórios: `name`, `description`, `model`, `tools`
- Claude auto-delega quando a tarefa bate com `description`, ou invocação manual via `@agent-name`
- Cada agent roda em sua **própria context window isolada** — verbose output não contamina a sessão principal

```yaml
---
name: agent-name
description: When to use this agent
model: claude-sonnet-4-5-20250929
tools:
  - Read
  - Grep
  - Glob
---
```

### Configurações-chave

| Campo | Recomendação |
|-------|-------------|
| `model` | Sonnet para economia (Opus = 5x mais caro) |
| `tools` | Restringir ao mínimo (read-only para reviewers, write para geradores) |
| `memory` | `user` para aprendizados persistentes; `none` para tarefas únicas |

## Os 8 Agents

### 1. PR Summarizer (`pr-summarizer`)
Lê diff do branch e gera descrição estruturada (What/Why/Changes/Testing) pronta para GitHub.
Tools: Read, Grep, Glob, Bash

### 2. Dependency Updater (`dep-updater`)
`npm outdated` → categoriza PATCH/MINOR/MAJOR → lista priorizada com breaking changes.
Tools: Read, Bash, Grep

### 3. Changelog Writer (`changelog`)
Git log desde última tag → changelog formatado (Added/Fixed/Changed/Docs).
Tools: Read, Bash, Grep

### 4. Test Coverage Checker (`coverage-checker`)
Roda suite com coverage → identifica arquivos com menor cobertura → recomendações específicas.
Tools: Read, Bash, Grep, Glob

### 5. Dead Code Finder (`dead-code`)
Unused exports, orphaned files, funções não chamadas, console.log em prod, código comentado >5 linhas.
Tools: Read, Grep, Glob

### 6. Migration Generator (`migration-gen`)
Lê migrations existentes → gera nova migration com UP+DOWN, indexes e sem NOT NULL sem DEFAULT.
Tools: Read, Write, Glob, Bash

### 7. API Doc Builder (`api-docs`)
Lê route files → gera documentação OpenAPI-style com métodos, params, auth, responses, errors.
Tools: Read, Grep, Glob

### 8. Error Log Analyzer (`error-analyzer`)
Filtra ERROR/WARN de logs → agrupa por padrão → frequência, root cause, fix sugerido.
Tools: Read, Bash, Grep

## Uso

```text
# Invocação manual
@agent-pr-summarizer summarize changes on this branch
@agent-dead-code scan src/ for unused exports
@agent-error-analyzer check logs/app.log

# Execução paralela
Run @agent-coverage-checker and @agent-dead-code in parallel on the src/ directory
```

**Auto-delegação:** Claude lê as `description` dos agents e delega automaticamente quando a tarefa bate.

## Cost Math

```
Sem agents: 300.000+ tokens na sessão principal
Com agents: ~30.000 tokens no contexto principal + ~20.000 por agent (contexto isolado)
Resultado: 90% menos token waste na sessão principal
```

## Estrutura de Arquivos

```
.claude/agents/
├── pr-summarizer.md
├── dep-updater.md
├── changelog.md
├── coverage-checker.md
├── dead-code.md
├── migration-gen.md
├── api-docs.md
└── error-analyzer.md
```

## Relações

- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — subagents como extensão do ecossistema Claude Code
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — pattern de agents isolados com contextos separados
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — context isolation como técnica central
- [[03-RESOURCES/concepts/claude-code-tooling/claude-folder-anatomy]] — `.claude/agents/` como subdiretório do `.claude/`
- [[03-RESOURCES/entities/zodchiii]] — autor da thread

---

## Por que context isolation é a feature central, não as tasks específicas

Os 8 agents específicos importam menos do que o mecanismo que os habilita: **context isolation**. Cada agent roda em sua própria context window, independente da sessão principal. Isso resolve um dos problemas mais sérios de sessões de coding longas.

Sem agents isolados, uma sessão de análise de coverage que lê 200 arquivos de teste polui o contexto principal com informação irrelevante para a task seguinte. O modelo na task seguinte está processando 200 arquivos de teste no fundo — o que aumenta custo, aumenta latência, e piora a qualidade do raciocínio por diluição de atenção.

Com agents isolados:
- O coverage-checker lê os 200 arquivos de teste em sua própria janela
- Retorna um **resumo estruturado** para o contexto principal — talvez 500 tokens
- A task seguinte começa com contexto limpo + 500 tokens de summary, não 200 arquivos

**O math do artigo (90% less token waste) é uma subestimativa**: em sessões muito longas com muitas tasks exploratórias, a diferença pode chegar a 95%+.

---

## Como o frontmatter YAML define o comportamento do agent

O frontmatter é o "job description" do agent — o que determina quando é invocado e com quais capacidades:

```yaml
---
name: pr-summarizer
description: |
  Summarize git diffs into structured PR descriptions with What/Why/Changes/Testing sections.
  Use when: user asks for PR description, wants to document changes, or says 'write PR'
model: claude-sonnet-4-5-20250929
tools:
  - Read
  - Grep
  - Glob
  - Bash
memory: none
---
```

**`description`:** Claude lê essa description para decidir auto-delegação. Uma description bem escrita usa linguagem próxima às frases que o usuário vai usar ("wants to document changes", "says 'write PR'"). Uma description vaga ou técnica demais resulta em auto-delegação incorreta ou ausente.

**`model`:** a economia mais significativa. Sonnet custa ~20% do Opus para tasks bem especificadas. Os 8 agents do artigo usam Sonnet não porque Opus faria pior — mas porque a task não requer o nível de raciocínio do Opus. Dead code finder lendo código com regex não precisa do mesmo modelo que arquitetura de sistema.

**`tools`:** restricts o blast radius do agent. Um reviewer com apenas Read+Grep+Glob não pode escrever arquivos por acidente — a restrição é técnica, não apenas instrucional.

**`memory: none`:** agents com `none` não retêm estado entre invocações. Agents com `user` retêm aprendizados no espaço de memória do usuário. Para tarefas repetitivas (PR summarizer é rodado muitas vezes), `user` memory permite o agent aprender preferências de formatação ao longo do tempo.

---

## Padrão de agent para o vault-michel

Os 8 agents do artigo são para dev workflow. O mesmo padrão se aplica ao vault-michel:

**`wiki-ingest-agent`:**
```yaml
name: wiki-ingest
description: Ingest a source into the vault. Use when user says 'ingest', 'add to wiki', or provides a URL/file to process.
model: claude-sonnet-4-5
tools: [Read, Write, Bash, WebFetch]
memory: none
```

**`wikilink-repair-agent`:**
```yaml
name: wikilink-repair
description: Find and fix broken wikilinks in vault notes. Use when user asks to repair links, clean up orphans, or check link validity.
model: claude-haiku-4-5
tools: [Read, Write, Grep, Glob]
memory: none
```

**`hot-cache-updater`:**
```yaml
name: hot-cache-updater
description: Update hot.md with recently accessed concepts. Use after any session that touched multiple concept pages.
model: claude-haiku-4-5
tools: [Read, Write, Bash]
memory: none
```

Cada agent roda sem contaminar a sessão do Nexus principal — que pode continuar com outra task enquanto o ingest acontece em paralelo.

---

## Auto-delegação vs. invocação manual: quando usar cada uma

**Auto-delegação** (Claude decide quando invocar o agent baseado na description):
- Melhor para: tasks que ocorrem naturalmente no fluxo de trabalho sem planning explícito
- Exemplo: usuário diz "escreve a PR description" → Claude auto-delega para pr-summarizer
- Risco: auto-delegação errada se description for ambígua

**Invocação manual** (`@agent-name task`):
- Melhor para: tasks onde você sabe exatamente qual agent usar e quer controle explícito
- Exemplo: `@coverage-checker analyze src/auth/` → invocação precisa com escopo claro
- Benefício: sem ambiguidade, sem chance de delegação errada

**Execução paralela** (`Run @agent-a and @agent-b in parallel`):
- Melhor para: tasks independentes que podem rodar simultaneamente
- Exemplo: coverage + dead code scan no mesmo diretório
- Benefício: tempo de execução do mais lento, não da soma de todos

A recomendação prática: para os primeiros dias com um novo agent, usar invocação manual para calibrar o comportamento. Após verificar que o agent produz outputs corretos, habilitar auto-delegação para o fluxo natural.
