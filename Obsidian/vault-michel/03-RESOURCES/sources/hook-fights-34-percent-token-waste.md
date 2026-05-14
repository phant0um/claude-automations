---
title: "34% of Claude Code Tokens Go to Hook Fights — The 3-Line Fix"
type: source
source_file: Clippings/34% of your Claude Code tokens go to hook fights. Here's the 3-line fix..md
origin: post no X (@Mnilax)
author: "@Mnilax"
published: 2026-05-11
ingested: 2026-05-14
tags: [claude-code, hooks, token-efficiency, plugins, settings-json, cascade]
---

# Hook Fights — 34% Token Waste Fix

Análise de 14 setups de Claude Code ao longo de 11 dias, com proxy HTTP entre Claude Code e a API Anthropic para medir cada hook e request. Descoberta: **34% dos tokens gastos antes de qualquer output útil**, causado por 3 padrões de conflito entre plugins.

## Os 3 Conflitos Principais

### Conflito 1: PostToolUse Cascade (formatadores em guerra)
Dois plugins com PostToolUse sobre `Edit|Write` disparam em cadeia: Prettier escreve o arquivo → ESLint hook dispara → escreve → Prettier dispara novamente. Um único Edit pode gerar 7 PostToolUse encadeados. Custo: **3x o token normal** por operação.

### Conflito 2: Múltiplos Code Reviewers
Superpowers + code-reviewer plugin + ECC todos revisam o mesmo PR. Resultado: Claude recebe 3 revisões contraditórias e tenta obedecer todas. Qualidade cai.

### Conflito 3: UserPromptSubmit Injection Wars
Cada plugin injeta contexto em todo prompt. ECC + claude-mem + git-context = 6.400 tokens de prefixo antes da pergunta real. Compliance com CLAUDE.md caiu de 78% para 41%.

## O Fix de 3 Linhas (Lock File)

```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Edit|Write|MultiEdit",
      "hooks": [{
        "type": "command",
        "command": "[ -f .claude/.hook-lock ] && exit 0; touch .claude/.hook-lock; npx prettier --write \"$CLAUDE_TOOL_INPUT_FILE_PATH\" 2>/dev/null; rm -f .claude/.hook-lock; exit 0"
      }]
    }]
  }
}
```

**Princípio:** lock file filesystem-level = mutex entre hooks. Primeiro hook cria o lock; todos subsequentes (do mesmo plugin ou diferentes) veem o lock e saem. Remove no fim.

Adicionar ao `.gitignore`: `.claude/.hook-lock`

## Ordem de Carregamento dos Hooks

1. Personal-level (`~/.claude/settings.json`) — primeiro
2. Project-level (`.claude/settings.json`) — segundo
3. Plugin-level — na ordem de instalação
4. Dentro do mesmo nível: alfabético por nome do plugin

## Mental Model Correto

| Camada | Papel |
|--------|-------|
| **Hooks** | Infraestrutura determinística. Sempre roda. Não pensa. |
| **Skills** | Procedimentos especializados. Carregados on-demand. |
| **Subagents** | Workers isolados com contexto próprio. |
| **Agent Teams** | Coordenação sobre subagents. Requer Opus 4.6. 5x custo. |
| **CLAUDE.md** | Contrato suave (~80% compliance). |

Hooks = "deve sempre acontecer". Agent Teams = "trabalho paralelo complexo com velocidade".

## Sintomas de Estar com Este Problema

- Hits no usage limit mais de 2 dias antes do reset semanal
- "Claude ficou burro" após instalar 2-3 plugins
- Instruções do CLAUDE.md ignoradas que funcionavam antes
- Edits notavelmente mais lentos
- PostToolUse disparando mais de uma vez por Edit

## Conexões

- [[03-RESOURCES/concepts/claude-hooks]] — mecanismo base dos hooks
- [[03-RESOURCES/concepts/token-efficiency-prompting]] — eficiência de tokens
- [[03-RESOURCES/concepts/claude-agent-harness-architecture]] — harness layers
