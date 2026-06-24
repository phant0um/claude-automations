---
title: "34% of Claude Code Tokens Go to Hook Fights — The 3-Line Fix"
type: source
source_file: Clippings/34% of your Claude Code tokens go to hook fights. Here's the 3-line fix..md
origin: post no X (@Mnilax)
author: "@Mnilax"
published: 2026-05-11
ingested: 2026-05-14
tags: [claude-code, hooks, token-efficiency, plugins, settings-json, cascade]
triagem_score: 9
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

- [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]] — mecanismo base dos hooks
- [[03-RESOURCES/concepts/llm-ml-foundations/token-efficiency-prompting]] — eficiência de tokens
- [[03-RESOURCES/concepts/claude-code-tooling/claude-agent-harness-architecture]] — harness layers

---

## Mecanismo Detalhado dos Conflitos

### Por que PostToolUse Cascade é difícil de detectar

O conflito de formatadores em cadeia é especialmente traiçoeiro porque cada hook individual parece correto. O Prettier hook faz exatamente o que deveria: formata o arquivo após uma edição. O ESLint hook também faz exatamente o que deveria: verifica regras de linting após uma edição. O problema só emerge quando os dois coexistem no mesmo trigger, porque a escrita do Prettier dispara o trigger `Edit` novamente, que dispara o ESLint, que se o ESLint fizer qualquer auto-fix, dispara o Prettier de novo.

Sem instrumentação (proxy HTTP entre Claude Code e a API), esse loop é invisível — você vê apenas que edições ficaram lentas e o uso de tokens aumentou. Com o proxy, você vê os 7 PostToolUse encadeados claramente.

### Por que múltiplos code reviewers degradam qualidade

O problema não é apenas duplicação de custo — é que os 3 reviewers produzem feedback contraditório. O Superpowers diz para usar `const` aqui; o code-reviewer diz para usar `let` por razões de legibilidade; o ECC diz que a função deveria ser refatorada completamente. Claude recebe as 3 revisões no mesmo contexto e tenta reconciliá-las.

O modelo não tem como saber qual reviewer tem mais autoridade. Em vez de seguir o melhor conselho, tende a produzir código que satisfaz critérios superficiais de todos (syntactically pleasing to each reviewer) mas perde a coerência arquitetural que qualquer reviewer individualmente teria preservado.

### A matemática do UserPromptSubmit injection

6.400 tokens de prefixo antes de cada pergunta real é mais do que parece. Com um context window de 200K tokens (Claude Sonnet 4.5), 6.400 tokens por prompt significa que em uma sessão de 30 perguntas, você gastou 192.000 tokens só em prefixos — quase um context window completo desperdiçado em overhead de contexto.

A queda de compliance com CLAUDE.md (78% → 41%) é consequência direta: quanto mais tokens o modelo processa antes de chegar às instruções relevantes, mais atenção foi "gasta" no overhead. Instruções no fim de um contexto longo recebem menos peso de atenção.

## Como Implementar o Lock File na Prática

O lock file de 3 linhas resolve o PostToolUse cascade, mas requer algumas configurações adicionais para funcionar corretamente em todos os ambientes:

```bash
# Criar diretório .claude se não existir
mkdir -p .claude

# Adicionar ao .gitignore
echo ".claude/.hook-lock" >> .gitignore
```

Se múltiplos hooks precisam rodar (não só Prettier), o pattern se expande:

```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Edit|Write|MultiEdit",
      "hooks": [{
        "type": "command",
        "command": "[ -f .claude/.hook-lock ] && exit 0; touch .claude/.hook-lock; npx prettier --write \"$CLAUDE_TOOL_INPUT_FILE_PATH\" 2>/dev/null; npx eslint --fix \"$CLAUDE_TOOL_INPUT_FILE_PATH\" 2>/dev/null; rm -f .claude/.hook-lock; exit 0"
      }]
    }]
  }
}
```

A chave: todos os formatadores ficam dentro do mesmo hook command, protegidos pelo mesmo lock. O lock é criado uma vez, todos rodam em sequência, o lock é removido uma vez.

## Diagnóstico: Como Confirmar que Você Tem o Problema

Antes de implementar o fix, confirme que o problema existe no seu setup:

1. **Inspecione o settings.json consolidado:** Abra `~/.claude/settings.json` e todos os `.claude/settings.json` de projetos ativos. Liste todos os hooks com trigger `PostToolUse`. Se mais de um usa `Edit|Write` como matcher, você provavelmente tem cascade.

2. **Monitore via hook de debug:** Temporariamente adicione um hook que loga cada disparo:
   ```json
   {"type": "command", "command": "echo \"$(date +%T) PostToolUse disparado\" >> /tmp/hook-debug.log"}
   ```
   Faça uma edição simples e conte as linhas em `/tmp/hook-debug.log`. Mais de 2-3 linhas por edição = cascade.

3. **Meça tokens por operação:** O proxy HTTP da análise original não é necessário — basta comparar o custo de token de uma edição simples (mudar uma string) com e sem os plugins suspeitos ativados.

## Princípio Geral: Menos é Mais em Hooks

A descoberta de 34% de desperdício aponta para um princípio mais amplo: hooks são infraestrutura, e infraestrutura tem custo de manutenção e custo de interação. Cada novo hook adicionado ao sistema aumenta a probabilidade de conflito com hooks existentes — o risco cresce de forma não-linear com o número de hooks.

A estratégia de mínimo viável para hooks:
- Um hook de formatação consolidado (todos os formatadores no mesmo command)
- Um hook de lint consolidado (separado do de formatação, mas também com lock)
- Um hook de git context se necessário (UserPromptSubmit, não PostToolUse)
- Zero hooks de code review automático (deixar para skills manuais)

Qualquer adição além desse baseline deve ser justificada por evidência de valor — não por "seria útil ter".
