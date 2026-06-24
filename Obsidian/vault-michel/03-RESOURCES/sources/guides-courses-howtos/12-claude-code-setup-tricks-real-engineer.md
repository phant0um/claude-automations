---
title: "These 12 Claude Code Setup Tricks Made AI Feel Like a Real Engineer"
type: source
source: Clippings/These 12 Claude Code Setup Tricks Made AI Feel Like a Real Engineer.md
created: 2026-05-17
ingested: 2026-05-17
tags: [claude-code, setup, tricks, productivity]
triagem_score: 7
---

## Tese central
12 ajustes de setup (CLAUDE.md prescritivo, MCP filesystem + git + browser, hooks de validação, slash commands) transformam Claude Code de chat-com-IDE em par-programmer sério.

## Key insights
- Stack mínima: CLAUDE.md curto + 3-4 MCPs + 2 hooks = fluência alta
- Slash commands customizados para workflows recorrentes (review, commit, plan)
- Verificação pós-edit automatizada > confiar cego no diff

## Links
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-md-cost-optimization]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-folder-anatomy]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]]

---

## Os 12 Tricks em Detalhe

### Trick 1 — CLAUDE.md Prescritivo, Não Descritivo

A maioria dos CLAUDE.md erram ao descrever o projeto em vez de prescrever comportamentos. Descrição ("este projeto usa Next.js e TypeScript") é contexto que o agente pode descobrir sozinho lendo o código. Prescrição ("sempre rodar `npm test` antes de commitar") é comportamento que o agente não pode inferir.

**Regra:** todo parágrafo do CLAUDE.md deve mudar algum comportamento do agente. Se não muda nada, delete.

### Trick 2 — MCP Filesystem como Memória de Longo Prazo

O MCP de filesystem não é só para editar arquivos — é para persistir memória entre sessões. Arquivo `notes/session-context.md` que o agente atualiza ao final de cada sessão e lê no início da próxima cria continuidade sem depender da memória nativa do harness.

```markdown
# Contexto da Última Sessão - 2026-05-17
## O que foi feito
## Decisões tomadas
## Próximos passos pendentes
```

### Trick 3 — MCP Git para Autonomia de Commit

Com MCP Git, o agente pode commitar autonomamente após verificação bem-sucedida. Fluxo:
1. Agente faz edit
2. Hook de validação roda
3. Se validação passa: agente commita com mensagem padronizada
4. Se falha: agente itera sem commitar

Isso elimina o ciclo "espere o agente terminar → revise → commite manualmente".

### Trick 4 — MCP Browser para Documentação em Contexto

MCP de browser permite ao agente buscar documentação em tempo real enquanto escreve código. Em vez de hallucinar uma API que mudou na versão mais recente, o agente lê a documentação oficial. Especialmente valioso para bibliotecas com breaking changes frequentes.

### Trick 5 — Slash Command /review com Template

Um slash command de code review específico para o projeto é mais valioso que o review genérico. O template deve incluir:
- Verificação de convenções do projeto
- Checklist de segurança relevante ao domínio
- Pontos de verificação de performance específicos à stack
- Perguntas sobre edge cases do domínio

### Trick 6 — Slash Command /commit com Conventional Commits

Conventional Commits (`feat:`, `fix:`, `docs:`, etc.) são mais legíveis em histórico e habilitam geração automática de CHANGELOG. Um slash command que formata automaticamente reduz fricção.

### Trick 7 — Hook PostToolUse para Validação Automática

```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Write|Edit|MultiEdit",
      "hooks": [{
        "type": "command",
        "command": "npm run typecheck 2>&1 | tail -20"
      }]
    }]
  }
}
```

O output do hook é devolvido ao agente automaticamente. Se type check falha, o agente vê o erro e corrige sem intervenção humana.

### Trick 8 — Hook PreToolUse para Proteção de Arquivos

Bloquear edições em arquivos críticos via hook:

```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Write|Edit",
      "hooks": [{
        "type": "command",
        "command": "if echo '$file' | grep -q 'production.env'; then echo 'BLOCKED: production env'; exit 1; fi"
      }]
    }]
  }
}
```

### Trick 9 — Workspace Settings vs User Settings

Settings em `.claude/settings.json` (workspace) afetam apenas o projeto atual. Settings em `~/.claude/settings.json` (user) afetam todos os projetos. Colocar permissões de MCP no workspace settings aumenta a segurança — um MCP perigoso num projeto não fica disponível globalmente.

### Trick 10 — Plan Mode para Tasks com >3 Arquivos

Regra prática: se a task vai tocar mais de 3 arquivos, entrar em plan mode primeiro. Não é uma regra absoluta, mas captura a maioria dos casos onde a execução direta leva a surpresas.

### Trick 11 — Subagentes para Tasks Paralelas

Claude Code suporta subagentes via `Task` tool internamente. Para tasks independentes (gerar docs + rodar testes + atualizar README), o agente pode paralelizar sem esperar cada uma terminar sequencialmente. Isso reduz o tempo de wall-clock mesmo que o token-cost seja similar.

### Trick 12 — Verificação Pós-Sessão com Checklist

Ao final de cada sessão de desenvolvimento, verificar uma checklist fixa:
- [ ] Testes passando
- [ ] Lint limpo
- [ ] Nenhum arquivo fora do escopo modificado
- [ ] Commits com mensagens descritivas
- [ ] CLAUDE.md atualizado se houver nova convenção

Esta checklist pode ser um slash command `/done` que o agente executa e reporta.

---

## Stack Mínima para Fluência Alta

O artigo conclui que a combinação mínima para transformar Claude Code em par-programmer sério é:

```
CLAUDE.md (curto, prescritivo)
+ MCP Filesystem
+ MCP Git
+ Hook PostToolUse (type check ou lint)
+ 2-3 Slash Commands (review, commit, plan)
```

Tudo além disso é opcional e deve ser adicionado apenas quando existe um workflow específico que justifica.

---

## Relevância para o Vault-Michel

O vault já implementa: CLAUDE.md prescritivo (skill-driven), MCP Filesystem (vault-michel), e slash commands via skill system. Os próximos ganhos mais altos seriam:
- Hook PostToolUse para verificação de wikilinks pós-edit
- MCP Git para commits automáticos pós-ingest verificado
- Slash command `/done` com checklist de finalização de sessão

---

## Limitações

- Alguns tricks assumem projeto TypeScript/Node — adaptação necessária para Python, Rust, etc.
- Hooks com validação lenta (testes de integração) tornam o ciclo edit→verify demorado demais; restringir a validações rápidas (<5s)
- MCP Browser pode consumir tokens extras em chamadas desnecessárias; configurar com allow-list de domínios confiáveis
