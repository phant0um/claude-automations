---
title: "Claude Code Subagents"
type: concept
created: 2026-05-31
updated: 2026-06-09
tags: [concept, claude-code-tooling]
status: developing
---

# Claude Code Subagents

Mecanismo do Claude Code para delegar trabalho a agentes filhos paralelos ou sequenciais, mantendo o contexto principal limpo.

## O que é

Subagents são instâncias de Claude lançadas pelo agente principal via a ferramenta `Agent`. Cada subagente roda em contexto isolado, recebe um prompt autocontido e retorna apenas o resultado — sem poluir o contexto da conversa principal.

## Como funciona

- **Invocação**: a ferramenta `Agent` recebe `prompt` (string autocontida) e opcionalmente `worktree` (para isolamento de filesystem).
- **Isolamento de worktree**: quando `EnterWorktree` é usado, o subagente opera em branch/diretório separado — sem conflito com o trunk.
- **Paralelo vs sequencial**: múltiplos subagentes podem rodar em paralelo (batch ingest, análise multi-fonte) ou em cadeia (output de um é input do próximo).
- **Background vs foreground**: subagentes podem rodar com `run_in_background=true`; o agente principal é notificado ao término.
- **Prompt autocontido**: o prompt deve incluir tudo que o subagente precisa — paths absolutos, contexto, critérios de saída. Sem memória compartilhada.

## Por que importa

No vault-michel, o pipeline de ingest usa um subagente por fonte, rodando em paralelo — mantém o contexto do Nexus limpo para orquestração. Reduz context bloat em sessões longas e permite escalar para 10+ fontes sem degradação.

**Quando subagent vs inline:**
- Subagent: tarefa > 5 passos, contexto pesado, resultado independente
- Inline: edição cirúrgica, 1-2 passos, precisa do contexto atual

## Padrão: Receipt Protocol

Subagentes eficazes retornam um "recibo" estruturado com veredicto `ready` ou `blocked`. Bloqueio é hard stop — propaga pela cadeia. Agentes de verificação não podem sobrescrever agentes de segurança.

**Restrição estrutural > instrucional**: excluir `Edit`/`Write` da lista de ferramentas de um agente de revisão impede fisicamente modificações — mais confiável que instruir via prompt.

**Self-check embutido**: cada agente deve declarar sua condição de bloqueio automático. Ex: "diff contains file not in spec = blocked receipt".

## 10 Papéis Especializados Provados

Cinco starred (uso diário): **bounded-implementer**, **test-proof**, **code-reviewer**, **repro-debugger**, **done-checker**.

| Arquivo | Job | Bloqueio |
|---------|-----|---------|
| `bounded-implementer.md` | Executa exatamente o escopo | Arquivo fora do spec no diff |
| `test-proof.md` | Cobre mudanças com testes e roda | Teste escrito mas não executado |
| `code-reviewer.md` | Revisa diff, nunca modifica | Qualquer Edit/Write call |
| `repro-debugger.md` | Reproduz → root cause → minimal fix | Fix sem reprodução antes/depois |
| `security-auditor.md` | Audita auth/payment/secrets | Achado high-severity ou qualquer edit |
| `repo-scout.md` | Mapeia repo antes de editar | Qualquer write |
| `task-splitter.md` | Quebra requisito em tarefas verificáveis | Qualquer modificação de código |
| `integration-checker.md` | Verifica callers após mudança de interface | Caller usando interface antiga |
| `ui-acceptance-tester.md` | Valida estados UI (loading/empty/error) | Só happy path testado |
| `done-checker.md` | Agrega evidências → go/no-go | Qualquer upstream bloqueado |

Ver cadeia completa e arquivos prontos: [[03-RESOURCES/sources/10-claude-code-subagents-kept]]

## Fact-Checker (4ª camada de honestidade)

Subagente complementar focado em verificar *claims factuais* (símbolos, testes, libs) em vez de escopo de edição: lê arquivos/roda greps/executa testes para confirmar cada afirmação feita na conversa, retornando VERIFIED / WRONG / UNVERIFIABLE. Parte de um setup de 4 camadas (CLAUDE.md honesty rules + verification protocol + hooks PostToolUse/Stop + fact-checker). Ver [[03-RESOURCES/sources/claude-code-honesty-setup-4-layers]].

## Evidências
- **[2026-06-19]** Sete revisores especializados (engineering, design, executive, legal, UX research, devil's advocate, customer voice), cada um lendo um framework diferente em contexto isolado, evitam que um único chat "medianize" perspectivas conflitantes de PRD review — [[03-RESOURCES/sources/a-product-org-of-one-lean-pms-review-on-demand]]
- **[2026-06-19]** Subagentes com query como arquivo `.txt` (não string inline) evitam reinflar o mesmo briefing 200 vezes no output do pai ao paralelizar pesquisa — [[03-RESOURCES/sources/ai-agents-harness/filesystem-pilling-your-vertical-agent]]

- **[2026-06-22]** Kits verticais (ClaudeKit) combinam subagents read-only com slash commands e skills por domínio, vendidos como "departamento contratável" — [[03-RESOURCES/sources/how-to-turn-claude-code-into-a-full-team-of-specialists]]

## Related
- [[03-RESOURCES/concepts/claude-code-tooling/_index]]
- [[03-RESOURCES/concepts/tool-use-agents]]
- [[03-RESOURCES/concepts/claude-ecosystem]]
- [[03-RESOURCES/concepts/agent-orchestration]]
- [[03-RESOURCES/sources/10-claude-code-subagents-kept]]
- [[04-SYSTEM/agents/core/cluster-agent]]
