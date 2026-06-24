---
title: "How Claude Code Harness turns agent coding into a contract-first delivery loop"
type: source
source: Clippings/How Claude Code Harness turns agent coding into a contract-first delivery loop.md
author: "@AlphaSignalAI"
published: 2026-05-29
created: 2026-05-29
ingested: 2026-05-29
tags: [ai-agents, claude-code, harness, spec-driven, delivery, go-runtime, guardrails]
---

## Tese central

Claude Code Harness é um plugin MIT-licensed que envolve o trabalho do agente em um loop de cinco verbos e trata dois arquivos como fonte de verdade (`spec.md` e `Plans.md`). A mudança que representa não é uma camada de segurança mágica, mas um sistema de evidência de entrega: agente tooling movendo de chat output para delivery evidence.

## Argumentos principais

- **O problema que resolve**: quando Claude Code trabalha sem estrutura, planos vivem no chat, testes se tornam opcionais, review acontece tarde demais, e release notes são reconstruídos de memória.
- **Dois arquivos como fonte de verdade**: `spec.md` (o contrato do produto — o que deve permanecer verdadeiro) e `Plans.md` (o ledger de tarefas — o que está sendo trabalhado, o que está feito, o que está bloqueando).
- **Loop de cinco verbos**: `/harness-setup`, `/harness-plan`, `/harness-work`, `/harness-review`, `/harness-release`. Cada estágio tem um gate explícito.
- **Contract-first**: usuário aprova o contrato gerado antes de qualquer código ser escrito. Major review findings bloqueiam completude. Release preflight verifica tag, versão, changelog e empacotamento de evidência.
- **Regra de dados não vistos**: dados que o agente não viu diretamente ficam desconhecidos em vez de serem silenciosamente inventados — declarado na spec, não implícito.
- **Runtime Go**: reescrito a partir de v4.0 ("Hokage"). Cold start target de 1–2ms vs. ~40–60ms do caminho bash+TypeScript anterior. SQLite via `modernc.org/sqlite` (pure-Go driver, sem CGO, sem Node.js, sem toolchain de compilador para instalar).
- **Separação de concerns no código**: `hook-fastpath` (rule evaluation, codec, types — sem I/O, sem rede, sem goroutines) vs. `worker-runtime` (SQLite store, session lifecycle, OTel export).
- **Config single-source**: `harness.toml` é o source. `harness sync` regenera `plugin.json`, `hooks.json`, e `settings.json` a partir dele. Usuário edita um arquivo, não cinco.
- **58 command-hook entries + 4 agent-hook entries** via hooks/hooks.json, cobrindo pre-tool, post-tool, permission, session, notification, stop e task events.
- **Fail-open em erros de infraestrutura**: hook system falha aberto em erros de infraestrutura. Regras deny determinísticas ainda bloqueiam quando rodam. Mas se o plumbing do hook quebra, o design prefere aprovar a ação a quebrar a sessão do usuário — tradeoff honesto documentado.

## Key insights

**13 guardrail rules (R01–R13):**
- **Deny**: sudo, git push --force, --no-verify, --no-gpg-sign, writes para .env/.git/*.pem/*.key, git reset --hard em branches protegidas
- **Ask**: rm -rf, instalações de packages, force-with-lease pushes, npx, direct pushes para main ou master
- **Warn**: leituras de arquivos com padrão de segredos (permitidos, mas flagged), edições em package.json, Dockerfiles, CI workflows

**R14 (TDD guardrail)**: registrado como local-trial path, não como regra blocking — TDD enforcement desativado por padrão em harness.toml apesar do README implicar verificação TDD no work step.

**Como começar:**
```bash
claude
/plugin marketplace add Chachamaru127/claude-code-harness
/plugin install claude-code-harness@claude-code-harness-marketplace
/harness-setup
/harness-plan Improve the README onboarding flow
```

**Harness-plan output**: delta de spec escrito em `spec.md` (ou "spec skip reason" documentado), rows de tarefas em `Plans.md` com scope, acceptance criteria, dependencies, unknowns, stop conditions.

**Harness-work**: implementa uma approved slice e registra evidência de verificação. Recusa expansão silenciosa de escopo — se o trabalho cresce além da row aprovada, o loop para e pergunta.

**Harness-review**: passo separado, não misturado com implementação. Formato fixo: APPROVE ou REQUEST_CHANGES.

**Harness-release --dry-run**: checa estado do changelog, version sync entre VERSION/plugin.json/harness.toml, tag boundaries, e empacotamento de release-evidence.

**Breezing benchmark**: 14/15 passes com instruções de validação vs. 3/15 sem, em 30 runs. Limites declarados: 3 tarefas, 1 modelo (GLM-4.5-air via Z.AI haiku tier), 2 categorias reais de bug, design adaptativo de 2 estágios. Sinal útil, não prova de eficácia do sistema.

**Quatro rough edges documentados:**
1. **Version drift no repo clonado**: VERSION/plugin.json/harness.toml reportam v4.12.3, binários incluídos reportam 4.11.4 (Hokage). `cd go && make install` resolve; install via marketplace não tem esse problema.
2. **TDD não enforced por padrão**: contradição entre README e harness.toml.
3. **Breezing benchmark é mais estreito do que parece**: três tarefas, um modelo, limitado.
4. **Documentation drift da era TypeScript**: docs/CLAUDE_CODE_COMPATIBILITY.md ainda referencia v3.10.2 e Node.js. `deleted-concepts.yaml` existe exatamente porque esse resíduo continua aparecendo após cada migração.

**Compatibilidade multi-plataforma**:
- Claude Code (full): pré-hook enforcement, contract injection, post-run checks
- Codex CLI: contract injection + post-run checks (sem pre-tool hook enforcement)
- OpenCode: mirror de skills (runtime parity não garantida)

**Contexto do projeto**: criado em dezembro 2025, 1.730+ stars, 190+ forks, v4.12.7, Go-native, 1.529 arquivos rastreados, 33 shared skills. Desenvolvedor solo (@Chachamaru), japonês, sem HN thread, sem Reddit discussion, sem YouTube demo — cadência de release diária, under-the-radar.

**Posicionamento correto**: tratar como sistema de workflow e evidência. Não como camada de segurança acabada.

## Exemplos e evidências

- **Cold start**: 1–2ms (Go runtime) vs. 40–60ms (bash+TypeScript anterior)
- **Tracking files**: 1.529 arquivos rastreados
- **Stars/forks**: +1.700 stars, +190 forks em v4.12.7
- **Hook entries**: 58 command-hook + 4 agent-hook
- **Linguagens**: Shell 2.13MB, Go 1.56MB, JS, TS, Python (thin layer)
- **Guardrails**: 13 regras R01–R13 + R14 (TDD, disabled)
- **Breezing**: 14/15 (93%) com validação vs. 3/15 (20%) sem

## Implicações para o vault

Complementa e aprofunda [[03-RESOURCES/concepts/agent-systems/spec-driven-development]] com a implementação concreta do Claude Code Harness. O padrão de "dois arquivos como fonte de verdade" (spec.md + Plans.md) é diretamente aplicável ao workflow do vault.

Relaciona-se com [[03-RESOURCES/concepts/claude-code-tooling/claude-agent-harness-architecture]] — Harness é um exemplo concreto de harness-engineering com Go runtime de alta performance.

O comportamento fail-open em erros de infraestrutura é uma instância do trade-off documentado em [[03-RESOURCES/concepts/agent-systems/agent-governance-layers]].

O TDD enforcement desativado por padrão é um padrão recorrente: [[03-RESOURCES/sources/ai-agents-harness/clipping-224-of-247-claude-skills-23-kept]] (skills que existem mas não são ativadas).

## Links

- [[03-RESOURCES/concepts/agent-systems/spec-driven-development]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-agent-harness-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agent-governance-layers]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]]
- [[03-RESOURCES/entities/Claude Code]]
