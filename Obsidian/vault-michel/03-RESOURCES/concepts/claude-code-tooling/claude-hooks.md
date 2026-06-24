---
title: Claude Hooks
type: concept
status: developing
tags: [claude-code, hooks, context-injection, automacao, second-brain, settings-json]
updated: 2026-05-19
---

# Claude Hooks

## O que é

**Hooks** são event handlers que disparam automaticamente em pontos específicos do workflow do Claude Code. Tornam comportamentos **determinísticos** — o script roda toda vez, sem exceção (ao contrário de instruções em CLAUDE.md que o modelo pode não seguir).

Configurados em `settings.json` (ou `settings.local.json`) sob a chave `hooks`.

## Exit codes — a mecânica crítica

| Código | Comportamento |
|--------|--------------|
| `0` | Sucesso — execução continua normalmente |
| `1` | Erro **não-bloqueante** — apenas loga, não interrompe nada |
| `2` | **Bloqueia execução** + envia stderr ao Claude para auto-correção |

> [!warning] Erro mais comum
> Hooks de segurança com `exit 1` não bloqueiam nada. Para bloquear um comando perigoso ou impedir que Claude declare "done", **sempre use exit 2**.

## Eventos disponíveis

| Evento | Trigger | Uso típico |
|--------|---------|-----------|
| `PreToolUse` | Antes de qualquer tool rodar | Gate de segurança — bloquear comandos perigosos |
| `PostToolUse` | Após tool ter sucesso | Formatador, linter automático |
| `Stop` | Quando Claude declara "done" | Quality gate — testes devem estar verdes |
| `UserPromptSubmit` | Ao pressionar Enter | Injeção de contexto, enriquecimento de prompt |
| `Notification` | Notificações do Claude | Alertas desktop (osascript/notify-send) |
| `SessionStart` | Início de sessão | Injeção de contexto global |
| `SessionEnd` | Fim de sessão | Cleanup, aprendizado (`/learn` skill) |

**Matcher regex** no evento filtra quais tools disparam: `"Write|Edit|MultiEdit"` → só mudanças de arquivo; `"Bash"` → só shell; sem matcher → tudo.

## Configuração em settings.json

```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Write|Edit|MultiEdit",
      "hooks": [{
        "type": "command",
        "command": "jq -r '.tool_input.file_path' | xargs npx prettier --write 2>/dev/null"
      }]
    }],
    "PreToolUse": [{
      "matcher": "Bash",
      "hooks": [{
        "type": "command",
        "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/bash-firewall.sh"
      }]
    }]
  }
}
```

## Localização dos scripts

```
.claude/hooks/
├── bash-firewall.sh    # PreToolUse: bloqueia rm -rf, git push --force, DROP TABLE
├── auto-format.sh      # PostToolUse: formata arquivos editados
└── enforce-tests.sh    # Stop: garante testes verdes antes de "done"
```

Scripts globais (notificações desktop) ficam em `~/.claude/settings.json`.

## PreToolUse como filtro de tokens: log files

Claude reading a 10,000-line log file costs thousands of tokens. A `PreToolUse` hook with `grep ERROR|WARN | head -50` filters before Claude sees the file — reducing 10k lines to 50 relevant lines (**99.5% token reduction**):

```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Bash(cat *log*)",
      "hooks": [{
        "type": "command",
        "command": "grep -n 'ERROR\\|WARN' $file | head -50"
      }]
    }]
  }
}
```

Same pattern works for any large file: filter, truncate, or summarize before Claude processes it. Source: [[03-RESOURCES/sources/token-economy-cost/7-claude-code-mistakes-token-waste]]

## Custo de contexto: MCP servers e skills acumulados

> [!warning] Token cost is silent and compounding
> - **Cada MCP server** carrega sua definição completa de tools no contexto em toda turn: alguns adicionam **18.000+ tokens** apenas por estar conectados. 5 servidores = ~90k tokens de overhead por turn antes do primeiro prompt.
> - **Skills acumulados**: 160 skills registrados ≈ **~25k tokens por chamada**. Vercel encontrou skills nunca invocadas em 56% dos casos de teste.
> - Um desenvolvedor acumulou um system prompt de 607k tokens de plugins e MCP servers.
>
> Execute `/mcp` e remova qualquer servidor não usado ativamente na sessão.

Source: [[03-RESOURCES/sources/token-economy-cost/7-claude-code-mistakes-token-waste]]

## Cuidados

- **Não hot-reload**: hooks são snapshottados no início da sessão; alterações exigem reiniciar
- **PostToolUse não desfaz**: a tool já rodou; use PreToolUse para prevenir ações
- **Disparam recursivamente** para ações de subagentes também
- **Rodam com permissões completas do usuário** — sem sandboxing; sempre citar variáveis shell, validar JSON, usar caminhos absolutos
- **Stop hook**: verificar flag `stop_hook_active` no payload JSON — sem ela, hook bloqueia → Claude retenta → hook bloqueia novamente → loop infinito

## Caso de uso principal: Context Enrichment Hook

Script `~/.claude/hooks/context-enrichment.sh`:
1. Extrai termos e nomes do prompt
2. Roda buscas paralelas (vsearch + BM25) contra coleção [[03-RESOURCES/entities/QMD]]
3. Retorna top resultados como contexto em bloco `<context>`
4. Deve completar em <2 segundos (matar buscas mais lentas)

Registrado em `~/.claude/settings.local.json` como `UserPromptSubmit`.

**Efeito:** Claude vê o contexto enriquecido; o usuário não vê o overhead — chat permanece limpo.

## Por que isso é poderoso

Sem hooks: cada prompt começa do zero; usuário precisa lembrar de adicionar contexto.
Com hooks: contexto relevante aparece automaticamente em todo prompt, sem esforço cognitivo.

**Resultado (caso Ryan Wiggins):** prompts lazy ("como está o funil?") encontram documentos sobre taxas de conversão sem mencionar "funil" — vsearch entende o significado.

## Relação com o learning loop

O hook `UserPromptSubmit` é a camada de entrada. A skill `/learn` (SessionStop) é a camada de saída — atualiza CLAUDE.md com aprendizados da sessão. Juntos, formam um ciclo fechado.

## Hooks no Workflow EPCC

No [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]]:
- **Code phase:** PostToolUse para auto-formatting após cada edição
- **Commit phase:** Stop hook como quality gate (testes devem estar verdes antes de "done")
- **Blocking:** PreToolUse para bloquear operações destrutivas em qualquer fase

## Compartilhamento com Time

Hooks em `.claude/settings.json` (nível projeto) são commitados no repo → time todo recebe automaticamente. Usar `$CLAUDE_PROJECT_DIR` para referenciar scripts no projeto, garantindo que rodam independente do diretório atual do Claude.

## Stop Hook — exit code semantics (/goal integration)

`/goal` uses a Stop hook internally. When writing custom Stop hooks:

- `exit 0` → Claude **may** stop (condition satisfied)
- non-zero exit → Claude **keeps going** (condition not yet met)

Two variants: **script-based** (run real tests, CI checks, file checks — deterministic, no model needed) and **prompt-based** (model evaluates natural-language condition against transcript — same mechanism as `/goal` but persistent across all sessions via settings file).

See [[03-RESOURCES/sources/claude-code-skills/complete-guide-goal-loop-schedule-stop-hooks]] and [[03-RESOURCES/concepts/claude-code-tooling/goal-command]] for full pattern.

## Onde aparece no vault
- [[03-RESOURCES/sources/guides-courses-howtos/claude-code-101]] — seção Hooks do curso oficial
- [[03-RESOURCES/sources/pkm-obsidian-second-brain/second-brain-claude-code-ryanwiggins]] — implementação completa do hook de contexto
- [[03-RESOURCES/concepts/pkm-obsidian/second-brain]] — hooks são a infraestrutura técnica do Second Brain
- [[03-RESOURCES/sources/token-economy-cost/7-claude-code-mistakes-token-waste]] — PreToolUse como filtro de log; custo de MCP servers e skills acumulados
- [[03-RESOURCES/sources/claude-code-skills/complete-guide-goal-loop-schedule-stop-hooks]] — guia completo de Stop hooks script-based vs prompt-based; exit code semantics

## Evidências
- **[2026-06-19]** Hook PostToolUse (matcher Write|Edit) roda testes automaticamente após cada edição, tornando auto-checagem automática em vez de sob demanda — falha aparece no mesmo fluxo, antes de empilhar mudanças sobre código quebrado — [[how-to-build-a-claude-code-agent-that-fixes-its-own-bugs-in-a-loop]]
