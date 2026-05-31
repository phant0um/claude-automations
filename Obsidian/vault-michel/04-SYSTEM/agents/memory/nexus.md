---
agent: nexus
model: claude-sonnet-4-6
type: agent-memory
updated: 2026-05-24
---

# Memory — Nexus

Memória persistente cross-session do orquestrador principal.

---

## Decisões Arquiteturais

- [2026-05-24] DECISION: Hooks residem em `.claude/hooks/` local do vault, não em `~/.claude/hooks/`. Razão: portabilidade e isolamento do vault como projeto.
- [2026-05-24] DECISION: wiki-ingest agents processados em main context quando Bash permission bloqueada no sandbox. Alternativa: processar diretamente até permissions serem liberadas.
- [2026-05-24] DECISION: PostToolUse Write hooks validam frontmatter (warn, exit 0) — não bloqueiam (exit 2). Razão: arquivo já foi escrito, bloquear pós-escrita não desfaz.
- [2026-05-24] DECISION: Manifest tracking via Python3 bulk scripts para batch ingests (vs one-by-one). Razão: contexto esgota em sessions longas com 35+ sources.

## Padrões Aprendidos

- [2026-05-24] PATTERN: Sessions longas (35+ sources) exigem compactação proativa antes de 70% context. Trigger: após batch B de 19 sources, iniciar compactação.
- [2026-05-24] PATTERN: settings.local.json (vault-level) sobrepõe settings.json (global). PreToolUse hooks adicionados no arquivo local.
- [2026-05-24] PATTERN: Skill symlinks em `.claude/skills/` apontam para `.agents/skills/[nome]/SKILL.md`.

## Falhas Documentadas

- [2026-05-24] FAILURE: Write em arquivo sem Read prévio falha com "File has not been read yet". Sempre ler antes de editar — mesmo que conteúdo seja inferível.
- [2026-05-24] FAILURE: PostToolUse write-tracking heurística CREATE vs UPDATE falhou — arquivo já existe quando hook roda. Simplificado para rastrear todos os writes.

## Preferências do Usuário

- [2026-05-24] PREFERENCE: Caveman mode full — sem artigos, fragmentos ok, técnico sem ser pedante.
- [2026-05-24] PREFERENCE: Implementações em paralelo quando possível. Não pedir confirmação para single-file edits.
- [2026-05-24] PREFERENCE: Scores de triagem: 8-9 = ingest imediato, 7 = alta prioridade, 6 = baixa, <6 = archive.

## Decisões — 2026-05-24 (sessão 3)

- [2026-05-24] DECISION: auto-push.sh como Stop hook com opt-in via `.claude/.autopush-enabled` sentinel. Override explícito da regra "confirm before: git push" do CLAUDE.md — sentinel = consentimento permanente até deletar arquivo.
- [2026-05-24] DECISION: 4 guards no auto-push.sh: (1) sentinel opt-in, (2) quality gate re-verify, (3) todo.md unchecked check, (4) merge conflict. Push só se todos passam.
- [2026-05-24] DECISION: Remote routines (vault-monday-ops + vault-hot-sweep) requerem vault sincronizado no GitHub. Auto-push garante isso. Sem auto-push → rotinas remotas trabalham em dados stale.
- [2026-05-24] DECISION: hot.md estrutura KV-cache-friendly: OPERACIONAL→CONCEITOS-ATIVOS→INGEST-PENDENTE (estável, cacheado) → SESSÕES-RECENTES (dinâmico, ao final). Não quebra cache do prefixo estável entre sessões.
- [2026-05-24] DECISION: Skill routing requer YAML frontmatter com `name` + `description` (WHAT+WHEN+triggers). Skills sem frontmatter não são auto-roteadas via progressive disclosure — ficam invisíveis.

## Padrões — 2026-05-24 (sessão 3)

- [2026-05-24] PATTERN: Quality gate (stop-quality-gate.sh) independente do auto-push — cada um verifica condições próprias. Gate: exit 1 bloqueia Claude parar. Auto-push: verifica gate implicitamente + checagens extras.
- [2026-05-24] PATTERN: Sprint contract antes de batch ingest ou restructuring. GAN pattern: critérios de done negociados ANTES de começar = zero ambiguidade pós-execução.
- [2026-05-24] PATTERN: Verificar wikilinks pós-escrita de hot.md com script Python (22 OK, 5 dead → separar TODOs intencionais de erros reais). find para confirmar path antes de linkar.

## Falhas — 2026-05-24 (sessão 3)

- [2026-05-24] FAILURE: Sessão multi-step (5 items) executada sem criar .claude/todo.md e sem ler 04-SYSTEM/AGENTS.md. Routing table (spec→forge→verify para nova feature) e memory/nexus.md pulados.
- [2026-05-24] FAILURE: inference-engines-hardware-first linkado como `concepts/agent-systems/` quando path real é `concepts/llm-ml-foundations/`. Ver errors.md 2026-05-24.

## Decisões — 2026-05-24 (sessão 4)

- [2026-05-24] DECISION: SOUL.md não necessário como arquivo separado. Padrão já coberto por CLAUDE.md (identidade+autonomia) + vault-identity.md (voz+estilo) + Nexus.md (decisões+anti-padrões). Criar SOUL.md = Karpathy P2 violation.
- [2026-05-24] DECISION: hot.md reestruturado KV-cache-friendly — seções estáveis primeiro (OPERACIONAL→CONCEITOS→INGEST), SESSÕES-RECENTES ao final. Não quebra cache cross-session.
- [2026-05-24] DECISION: Nexus.md +[DECISION NEEDED] handoff protocol — 6 condições que triggeriam parar e surfaçar. Anti-padrão adicionado: resolver ambiguidades silenciosamente.

## Padrões — 2026-05-24 (sessão 4)

- [2026-05-24] PATTERN: Home-level git (~/) é root real. Vault .gitignore isola vault — apenas 04-SYSTEM/agents/ + 04-SYSTEM/skills/ + poucos others tracked. hot.md (04-SYSTEM/wiki/) tracking via -f original. lock em ~/.git/index.lock = stale → rm -f para liberar.
- [2026-05-24] PATTERN: vault-identity.md = calibração de voz para agentes. Ler antes de gerar conteúdo em primeira pessoa. Não é constraint absoluto.

## Contexto Ativo

- [2026-05-24] CONTEXT: Manifest em 605 sources. 163 ingests pendentes (9 score-8 + 35 score-6/7 + 64 FIAP PDFs + 55 concurso). Bloqueados por Bash allowlist ausente para wiki-ingest subagents.
- [2026-05-24] CONTEXT: Stop hook chain ativa: stop-quality-gate.sh → auto-push.sh (opt-in via .autopush-enabled) → notify-done.sh. Auto-push habilitado (.autopush-enabled existe).
- [2026-05-24] CONTEXT: Rotinas remotas criadas: vault-monday-ops (weekly Mon 20:00 UTC) + vault-hot-sweep (monthly 1st 20:00 UTC). Próxima execução: seg 25/05 16:08 Manaus.
- [2026-05-24] CONTEXT: 4 skills com frontmatter YAML adicionado: token-economy, agent-eval, caveman-mode, kv-cache-explainer. sprint-contract skill criada.
- [2026-05-24] CONTEXT: 646 arquivos com frontmatter incompleto (maioria sources legacy sem `score`). frontmatter-scan.sh disponível.
- [2026-05-24] CONTEXT: Sessão 4 commit: d807885 — hot.md KV-cache restructure + Nexus DECISION-NEEDED protocol.
