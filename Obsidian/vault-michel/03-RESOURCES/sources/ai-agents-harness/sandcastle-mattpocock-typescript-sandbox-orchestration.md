---
title: "Sandcastle — Orchestrate Sandboxed Coding Agents in TypeScript (mattpocock)"
type: source
source: "Clippings/mattpococksandcastle Orchestrate sandboxed coding agents in TypeScript with sandcastle.run().md"
origin: "https://github.com/mattpocock/sandcastle"
author: "Matt Pocock (ai-hero)"
created: 2026-05-31
ingested: 2026-05-31
tags: [ai-agents, sandcastle, typescript, sandbox, claude-code, docker, orchestration, branch-strategy, session-resume]
---

## Tese central

Sandcastle é uma biblioteca TypeScript que orquestra agentes de coding (Claude Code, Codex, Pi, Cursor, etc.) em sandboxes isoladas, gerenciando automaticamente branch strategy, lifecycle hooks, session capture/resume/fork e structured output — com uma API de alto nível (`sandcastle.run()`) que abstrai toda a complexidade de container, git worktrees e sincronização de arquivos.

## Argumentos principais

- **Provider-agnostic**: suporte nativo para `claudeCode()`, `codex()`, `pi()`, `cursor()`, `opencode()`, `copilot()` — troca por parâmetro.
- **Sandbox providers**: Docker (bind-mount), Podman (rootless), Vercel (Firecracker microVMs), noSandbox, e custom providers via `createBindMountSandboxProvider` / `createIsolatedSandboxProvider`.
- **Branch strategies**: `head` (write direto ao host), `merge-to-head` (temp branch + merge), `branch` (named branch para PRs) — configurável por `run()`.
- **Session capture/resume/fork**: Claude Code, Codex e Pi capturam JSONL de sessão automaticamente; `run()` aceita `resumeSession`; `result.resume?.()` e `result.fork?.()` para fan-out.
- **Lifecycle hooks**: `host.onWorktreeReady`, `host.onSandboxReady`, `sandbox.onSandboxReady` — com suporte a `sudo`, `timeoutMs`, execução paralela.
- **Structured output**: `Output.object()` com Zod/Valibot/ArkType extrai payload tipado do stdout do agente via XML tags.
- **`createSandbox()`**: reutiliza um único container para múltiplos runs (implement → review no mesmo branch).
- **`createWorktree()`**: worktree como conceito independente de sandbox — permite sessão interativa seguida de AFK agent no mesmo branch.
- **Prompt system**: `promptFile` com `{{KEY}}` substitution, `` !`command` `` expansion (dentro do sandbox, em paralelo), built-in `{{SOURCE_BRANCH}}` e `{{TARGET_BRANCH}}`.
- **Completion signal**: `<promise>COMPLETE</promise>` para early termination; `completionTimeoutSeconds` para hanging processes.
- **Templates**: blank, simple-loop, sequential-reviewer, parallel-planner, parallel-planner-with-review.

## Key insights

1. **Fork é session-only**: `--fork-session` isola o JSONL da sessão mas NÃO isola branch/worktree/sandbox. Fan-out seguro com `Promise.all` requer `branchStrategy: { type: "branch" }` para cada filho — branch `head` e `merge-to-head` não são seguros para forks concorrentes (ADR 0018).
2. **Bind-mount vs. isolated**: bind-mount (Docker, Podman) não precisa sync — o agente escreve diretamente no filesystem do host via mount. Isolated (Vercel) usa `copyIn`/`copyFileOut`.
3. **Hanging processes gracefully**: após `completionSignal`, Sandcastle aguarda `completionTimeoutSeconds` (padrão 60s) antes de resolver com sucesso + warning — evita que processos filhos (gh, git, MCP server) desperdicem o resultado dos commits já feitos.
4. **`await using` para cleanup automático**: worktrees com mudanças não commitadas são preservados em disco; worktrees limpos são removidos automaticamente.
5. **Session capture rewrite de cwd**: Sandcastle reescreve `cwd` fields no JSONL de sessão para o path do host — o comando nativo `claude --resume <id>` funciona sem ajustes.
6. **parallel-planner template**: agente planeja issues paralelizáveis, executa em branches separados, depois merge — padrão mais sofisticado disponível out-of-the-box.

## Exemplos e evidências

- `run()` com `claudeCode("claude-opus-4-7", { effort: "high" })` + `docker()` — loop completo de uma issue.
- Multi-run implement-then-review: mesmo container, mesmo branch, `claude-opus-4-7` implementa, `claude-sonnet-4-6` revisa.
- Fan-out via `parent.fork?.()`: parent lê codebase, dois filhos em branches separados revisam áreas distintas em paralelo.
- `Output.object()` com Zod: extrai `{ summary: string, score: number }` do stdout do agente.
- `StructuredOutputError` com `sessionId`: retoma sessão que produziu output inválido sem repetir o trabalho.

## Implicações para o vault

- Padrão direto para agentes AFK no vault: workflows de ingestão, hill, extend poderiam rodar via `sandcastle.run()` em Docker isolado.
- Branch strategy `merge-to-head` é o default seguro para CI/unattended — confirma prática atual de trabalhar em branches temporários.
- Session fork para fan-out de revisão: padrão guard/review paralelo pode ser implementado como `parent.fork?.()` com branches separados.
- Completion signal como protocolo: `<promise>COMPLETE</promise>` é padrão Matt Pocock — já referenciado em outras skills do vault.

## Links

- [[03-RESOURCES/entities/Claude Code]]
- [[03-RESOURCES/concepts/agent-systems/agentic-harness]]
- [[03-RESOURCES/sources/claude-code-skills/mattpocock-skills-claude-code]]
- [[03-RESOURCES/sources/ai-agents-harness/clipping-components-of-a-coding-agent]]
