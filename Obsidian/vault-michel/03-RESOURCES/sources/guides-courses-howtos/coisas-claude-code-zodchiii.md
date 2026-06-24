---
title: "12 Things You Didn't Know Claude Code Can Do (No Extensions Needed)"
type: source
source_file: Clippings/12 Things You Didn't Know Claude Code Can Do (No Extensions Needed).md
origin: thread X
author: "@zodchiii"
ingested: 2026-05-14
tags: [claude-code, keyboard-shortcuts, built-in-commands, productivity, developer-tools]
triagem_score: 8
---

# 12 Things You Didn't Know Claude Code Can Do (No Extensions Needed)

> [!key-insight] Insight principal
> Claude Code tem 60+ comandos e atalhos built-in. A maioria dos usuários usa 5. Os outros 55 estão no terminal, esperando ser usados — sem instalar nada.

## Content summary

### Os 12 recursos por categoria

| # | Recurso | O que faz |
|---|---------|-----------|
| 1 | `/init` | Auto-gera CLAUDE.md escaneando o projeto (stack, build/test/lint) em 10s |
| 2 | `Shift+Tab` | Cicla modos de permissão: default → acceptEdits → plan |
| 3 | `/compact [instrução]` | Compact com contexto customizado — preserva decisões arquiteturais específicas |
| 4 | `/memory` | Memória persistente entre sessões; add entries manuais |
| 5 | `-p` (headless) | Claude Code como Unix pipe: `git diff \| claude -p "write commit"` |
| 6 | `$ARGUMENTS` em skills | Skills aceitam args posicionais: `$ARGUMENTS`, `$1`, `$2` |
| 7 | `@arquivo` | Mention direto de arquivo com autocomplete de path |
| 8 | `/rewind` | Desfaz com 3 opções: code+conversa / só code / só conversa |
| 9 | `-w` (worktree) | Claude trabalha em git worktree isolado — branch principal intacta |
| 10 | `/btw` | Pergunta lateral sem poluir contexto; single-turn, sem tool calls |
| 11 | `--max-budget-usd` | Cap de gasto em dólares por task (essencial em headless/CI) |
| 12 | `Ctrl+S` | Stash de prompt — salva input atual, responde outra coisa, restaura |

### Tabela completa de atalhos de teclado

```
Escape          → para geração (não Ctrl+C)
Escape Escape   → abre menu rewind
Shift+Tab       → cicla modos de permissão
Ctrl+S          → stash do input atual
Ctrl+O          → toggle transcript viewer
Alt+P           → troca modelo
Alt+T           → toggle thinking visibility
Alt+O           → toggle fast mode
! prefixo       → roda shell direto (! ls -la)
```

### Top 3 para começar

1. `/init` — gera CLAUDE.md em 10s
2. `Shift+Tab` — para de clicar "Allow" 30× por sessão
3. `/memory` — para de re-explicar o projeto todo chat

### Detalhe: `/rewind`

A opção 2 é a mais subestimada: **Rewind code only** — reverte os arquivos mas mantém a conversa. Útil quando a abordagem estava errada mas a análise estava certa.

### Detalhe: `/btw`

Criado por Erik Schluntz (engenheiro Anthropic) como side project. O tweet de lançamento teve 1.5M views.

## Conexões

- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — `$ARGUMENTS` e skills com argumentos
- [[03-RESOURCES/concepts/claude-code-tooling/claude-folder-anatomy]] — `/memory` e onde ele persiste
- [[03-RESOURCES/concepts/llm-ml-foundations/context-rot]] — `/compact` customizado evita perda de contexto relevante
- [[03-RESOURCES/entities/Claude Code]]

## Análise por Recurso — Mecanismo e Casos de Uso

### `/init` — O Gerador de CLAUDE.md Automático

O `/init` não cria um CLAUDE.md genérico — ele escaneia o projeto ativamente antes de escrever. O processo:
1. Lê o `package.json`, `pyproject.toml`, `Cargo.toml`, ou equivalente para identificar a stack
2. Detecta scripts de build, test, e lint a partir dos scripts declarados
3. Examina a estrutura de diretórios para inferir convenções de organização
4. Identifica arquivos de configuração (`.eslintrc`, `pytest.ini`, etc.) para inferir tooling

O CLAUDE.md gerado inclui: stack identificada, comandos de build/test/lint, convenções inferidas, e uma seção vazia para regras adicionais. Leva ~10 segundos e produz um ponto de partida funcional que pode ser editado manualmente.

**Quando NÃO usar `/init`:** em projetos com CLAUDE.md existente e bem configurado. O `/init` sobrescreve o CLAUDE.md existente — sempre verificar se há um antes de rodar.

### `Shift+Tab` — Ciclo de Modos de Permissão

Os três modos de permissão têm semânticas distintas que afetam fundamentalmente o comportamento do agente:

**Default mode:** Claude pede confirmação antes de executar tool calls. Ideal para exploração onde você quer ver o que Claude propõe antes de ele fazer.

**acceptEdits mode:** Claude edita arquivos sem confirmação, mas ainda pede para executar shell commands. Ideal para coding sessions onde você confia nas edições mas quer revisar execuções.

**plan mode:** Claude lista as ações que tomaria mas não executa nenhuma. Ideal para revisar o plano de ataque antes de autorizar execução. Equivalente ao "approve plan" do `/goal` workflow.

O `Shift+Tab` cicla entre esses modos sem interromper a sessão. O modo atual aparece no indicador da UI. Prática recomendada: começar em plan mode para tasks novas, mudar para acceptEdits quando o plano está aprovado.

### `/compact [instrução]` — O Parâmetro Ignorado

A maioria dos usuários conhece o `/compact` básico (sem argumentos). O argumento customizado é o recurso desconhecido: a instrução adicional instrui Claude sobre o que preservar na compactação.

**Diferença prática:**
- `/compact` básico: preserva decisões e código significativo, descarta raciocínio intermediário
- `/compact preserve architectural decisions about the auth system and current PR state`: instrui explicitamente a priorizar contexto específico

Para sessões longas de refactoring ou debugging, o argumento customizado previne que context rot elimine o contexto mais valioso — a thread de raciocínio sobre o problema específico que está sendo resolvido.

### `-p` (Headless) — Claude Code Como Ferramenta Unix

O modo headless é o que transforma Claude Code de uma ferramenta interativa em um componente de pipeline de automação. A interface Unix pipe (`|`) significa que qualquer output de qualquer comando pode ser o input para Claude Code.

**Casos de uso práticos:**

```bash
# Escrever commit message baseado no diff atual
git diff --cached | claude -p "write a conventional commit message for this diff"

# Analisar logs de erro
cat error.log | claude -p "identify the root cause and suggest a fix"

# Gerar changelog a partir de commits
git log --oneline HEAD~20..HEAD | claude -p "write a changelog in keep-a-changelog format"

# Code review em CI
git diff main...HEAD | claude -p "review this PR for security issues and breaking changes"
```

O `-p` é essencial para integrar Claude Code em workflows de CI/CD ou scripts de automação sem interação humana.

### `$ARGUMENTS` em Skills — Templates Dinâmicos

A capacidade de skills receberem argumentos posicionais transforma skills de templates estáticos em templates parametrizados:

```markdown
# Skill: git-commit
description: Escreve commit messages no formato conventional commits

$ARGUMENTS recebe o tipo de commit (feat, fix, docs, refactor, test, chore)

Escreva uma commit message em inglês no formato:
$1(scope?): description

onde $1 é o tipo fornecido como argumento.
```

Invocação: `/git-commit feat` ou `/git-commit fix`

O `$ARGUMENTS` recebe a string completa após o comando; `$1`, `$2` são os argumentos individuais separados por espaço.

### `/rewind` — As Três Opções Explicadas

O `/rewind` tem três opções com casos de uso distintos:

**Opção 1 — Rewind code + conversation:** desfaz arquivos editados E remove as mensagens correspondentes da conversa. Use quando o Claude tomou uma direção completamente errada e você quer recomeçar como se aqueles turnos nunca tivessem acontecido.

**Opção 2 — Rewind code only (mais subestimada):** reverte os arquivos para o estado anterior mas mantém a conversa intacta. Use quando a abordagem de implementação estava errada mas a análise do problema estava correta. Você mantém o contexto de debugging, a compreensão do problema, e as instruções dadas — apenas a implementação é revertida.

**Opção 3 — Rewind conversation only:** remove as mensagens mas mantém os arquivos editados. Útil quando você quer "limpar" o histórico de uma exploração e continuar de um estado de código específico com contexto fresco.

### `-w` (Worktree) — Branch Principal Intacta

O modo worktree resolve um problema específico: você quer que Claude faça mudanças experimentais sem afetar o branch principal ou o working tree atual.

Internamente: cria um `git worktree` em um diretório temporário, Claude trabalha nele, você pode revisar as mudanças antes de decidir se quer mergear. Se as mudanças não prestam, o worktree é deletado sem nenhum impacto no repo principal.

**Caso de uso primário:** exploração de soluções arriscadas. "Tente refatorar este módulo usando async/await" em um worktree — se ficar bom, você faz merge; se ficar ruim, você descarta sem cleanup manual.

### `Ctrl+S` — Stash de Prompt

O stash de prompt é análogo ao `git stash`: salva o input atual sem enviar, permitindo que você responda outra coisa (uma pergunta de um colega, um contexto novo que surgiu), e depois restaura exatamente o que estava digitando.

Para sessões longas onde interrupções são comuns, isso previne a perda de prompts elaborados mid-typing. O stash persiste enquanto a sessão está aberta — não é perdido se Claude demora a responder.

## Os Atalhos de Teclado Como Camada de Eficiência

A tabela completa de atalhos revela uma filosofia de design: modos e meta-operações (mudar modelo, ver thinking, trocar modo de permissão) são keyboard-accessible para minimizar cliques durante sessões de alta velocidade.

**Os mais impactantes em ordem de ROI:**
1. `Shift+Tab` — ciclar permissões sem menu
2. `Escape` (simples) — parar geração imediatamente (não `Ctrl+C` que pode matar a sessão)
3. `Alt+P` — trocar modelo na sessão sem reiniciar
4. `Ctrl+O` — rever transcript para context-checking rápido
