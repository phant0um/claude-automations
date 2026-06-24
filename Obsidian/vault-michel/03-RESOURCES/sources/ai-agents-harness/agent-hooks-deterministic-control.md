---
title: Agent Hooks: Deterministic Control for Agent Workflows
type: source
source: Clippings/Agent Hooks Deterministic Control for Agent Workflows.md
created: 2026-05-15
ingested: 2026-05-15
tags: [ai-agents]
triagem_score: 8
---

## Tese central
Hooks = handlers determinísticos em lifecycle points (PreToolUse, PostToolUse, Stop) que executam SEM depender de o modelo lembrar.

## Key insights
- Prompts orientam; hooks aplicam — "não edite generated files" pode ser texto OU PreToolUse hook que bloqueia o write.
- Modelo operacional: event → matcher/filter → handler → outcome. Handler pode ser shell, HTTP, MCP, LLM, ou subagent.
- 6 lifecycle points cobrem fluxo principal: SessionStart, UserPromptSubmit, PreToolUse, PostToolUse, Stop, SessionEnd.

## O modelo operacional em detalhe

O pipeline de um hook é: **event → matcher/filter → handler → outcome**.

**Event**: um dos 6 lifecycle points (SessionStart, UserPromptSubmit, PreToolUse, PostToolUse, Stop, SessionEnd). O evento carrega payload com contexto: qual ferramenta foi chamada, com quais argumentos, qual foi o output (para PostToolUse).

**Matcher/filter**: condição que determina se o hook se aplica a esse evento específico. Exemplo: `PreToolUse` com matcher `Write` só dispara quando o agente chama a ferramenta Write, não qualquer ferramenta.

**Handler**: o executor — pode ser:
- `shell`: comando de shell arbitrário (linting, formatação, notificação)
- `HTTP`: POST para webhook (Slack, PagerDuty, CI/CD)
- `MCP`: chamada para um MCP server
- `LLM`: outro modelo processa o evento (LLM-as-judge em real time)
- `subagent`: delega a decisão a um agente especializado

**Outcome**: o hook pode bloquear a ação (exit code não-zero no caso de shell), modificar os argumentos, ou apenas observar e logar.

## Exemplos concretos de configuração

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "filter": "rm -rf",
        "hooks": [{ "type": "command", "command": "echo 'Blocked: rm -rf' && exit 1" }]
      },
      {
        "matcher": "Write",
        "hooks": [{ "type": "command", "command": "npx prettier --check $FILE || exit 1" }]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [{ "type": "command", "command": "npx eslint $FILE" }]
      }
    ],
    "Stop": [
      {
        "hooks": [{ "type": "command", "command": "curl -X POST $SLACK_WEBHOOK -d '{\"text\":\"Session ended\"}'" }]
      }
    ]
  }
}
```

## Comparação: prompts vs hooks para enforçamento de regras

| Dimensão | Prompt no CLAUDE.md | Hook PreToolUse |
|---|---|---|
| Confiabilidade | Alta, mas não 100% | 100% determinístico |
| Custo de contexto | Carrega toda sessão | Zero custo de contexto |
| Inspecionabilidade | Depende do modelo explicitar | Log de audit automático |
| Latência | Zero | Milliseconds (shell) |
| Flexibilidade | Qualquer instrução | Limitado a handlers configuráveis |

Para regras críticas (segurança, dados sensíveis, operações irreversíveis): hooks. Para guidelines (estilo, preferências): CLAUDE.md.

## Hooks no vault-michel

O vault opera com hooks de sessão via `~/.claude/settings.json`. O hook de SessionStart carrega o checklist de 9 passos da session-startup. O hook Stop poderia ser usado para atualizar `04-SYSTEM/wiki/hot.md` com as páginas acessadas na sessão — atualmente isso é feito manualmente.

Um PreToolUse hook bloqueando writes fora de `vault-michel/` seria uma camada de segurança adicional contra edições acidentais de configs do sistema.

## Links
- [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]]
- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
- [[03-RESOURCES/concepts/agent-systems/agent-governance-layers]]

---

## Por que "determinístico" importa mais do que parece

A palavra "determinístico" no título não é jargão — é a propriedade que distingue hooks de prompts de sistema. Um prompt no CLAUDE.md diz "não edite arquivos gerados automaticamente". Com alta probabilidade, o modelo vai seguir essa instrução. Mas com qualquer probabilidade não-zero de falha, uma sessão longa com muitas operações vai eventualmente produzir uma violação — especialmente sob pressão de contexto ou quando a instrução entra em conflito com outra diretiva.

Um hook `PreToolUse` com matcher `Write` e filtro para arquivos em `generated/` bloqueia a ação **incondicionalmente** — sem gastar tokens de atenção, sem competir com outras instruções, sem depender de o modelo "lembrar" da regra. O determinismo não é preferível ao prompt — é de uma categoria diferente de ferramenta.

---

## Hierarquia de confiança para escolher entre prompt e hook

Uma heurística prática para decidir qual mecanismo usar:

**Use CLAUDE.md quando:**
- A regra é sobre estilo, preferência ou guidelines de qualidade
- A consequência de uma violação é corrigível (formatação errada, tom inadequado)
- Você quer que o modelo use julgamento para casos limítrofes

**Use hooks quando:**
- A consequência de uma violação é irreversível ou cara (delete, push, chamada de API externa)
- A regra é binária sem exceções legítimas (nunca `rm -rf`, sempre notificar no Slack ao encerrar)
- Você precisa de audit trail automático para debugging de sessão

**Use ambos quando:**
- A regra tem uma dimensão de guidelines (CLAUDE.md) e uma dimensão de enforcement (hook)
- Exemplo: "Prefira não modificar arquivos de configuração" (CLAUDE.md) + hook que notifica quando configs são modificadas (PostToolUse + logger)

---

## Padrões de hook por categoria

### Segurança
```json
{
  "PreToolUse": [
    { "matcher": "Bash", "filter": "rm -rf", 
      "hooks": [{ "type": "command", "command": "exit 1" }] },
    { "matcher": "Bash", "filter": "curl.*secret",
      "hooks": [{ "type": "command", "command": "echo 'Blocked: credential exfiltration risk' && exit 1" }] }
  ]
}
```

### Qualidade de código
```json
{
  "PostToolUse": [
    { "matcher": "Write", "filter": "\\.py$",
      "hooks": [{ "type": "command", "command": "python -m ruff check $FILE || true" }] },
    { "matcher": "Write", "filter": "\\.ts$",
      "hooks": [{ "type": "command", "command": "npx tsc --noEmit 2>&1 | head -20" }] }
  ]
}
```

### Observabilidade
```json
{
  "PostToolUse": [
    { "matcher": "*",
      "hooks": [{ "type": "command", "command": "echo \"$(date) TOOL=$TOOL_NAME\" >> ~/.claude/audit.log" }] }
  ]
}
```

---

## Limitações dos hooks

- **Sem acesso ao contexto completo da conversa**: hooks recebem payload do evento específico, não o histórico de raciocínio do modelo. Um hook não sabe "por que" o modelo está chamando a ferramenta.
- **Shell handlers são síncronos**: um hook lento atrasa a execução. Operações pesadas (análise de ML, chamadas de rede com timeout alto) devem ser offloaded para background processes ou HTTP handlers.
- **Handlers LLM-as-judge adicionam custo**: usar um segundo LLM como handler de PreToolUse multiplica os tokens consumidos por tool call. Reservar para casos de alto risco onde o custo é justificado.
- **Matching por string é frágil**: o filtro `"rm -rf"` não captura `rm  -rf` (dois espaços) ou `rm -r -f`. Para enforcement de segurança, combinar hook com análise semântica do comando antes de executar.
- **Loop de feedback impossível**: um hook não pode enviar mensagem de volta ao modelo no meio de um turn. Pode apenas bloquear (exit 1) ou deixar passar. Para feedback, usar o canal de stderr que o modelo vê como tool output.

---

## Hooks como camada de governança

Os hooks implementam concretamente a **Policy Layer** do framework de Agent Governance Layers: cada política operacional ("nunca escrever em produção sem aprovação") ganha uma implementação técnica verificável. A auditoria (`~/.claude/audit.log`) alimenta a Audit Layer do mesmo framework.

Essa correspondência é intencional no design do Claude Code: hooks são o ponto onde intenção humana (CLAUDE.md) e execução determinística (handler) se encontram. A governança que existe apenas como texto é aspiração; a governança implementada como hook é garantia.
