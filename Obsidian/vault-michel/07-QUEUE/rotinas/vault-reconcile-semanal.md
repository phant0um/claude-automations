---
title: Vault Reconcile Semanal — Archive vs Sources
type: rotina
schedule: "quarta 22h"
last_improved: 2026-06-24
version: 4
tags: [rotina, reconciliação, audit, vault-reconcile, ollama]
---

# Vault Reconcile Semanal

Reconciliação `08-ARCHIVE/[A|B]/` vs `03-RESOURCES/sources/` — detecta drift,
complementa source pages via append, cria concepts/entities faltantes, registra
wikilinks quebrados.

Scheduled run. Caveman full. Roteamento Ollama: [[04-SYSTEM/agents/nexus-agent-system/model-router]].

**Princípio**: Append > rewrite. Preservar informação > condensar. A/ antes de B/.

> **Skill wiring:** ao detectar concept/entity com `updated:` stale (>30d sem revisita),
> acionar skill `evaporation-reconcile` para verificar se conteúdo evaporou ou apenas
> não foi revisitado. Diferencia drift real de stale-but-still-valid.

---

## NEXUS GATE — Início `[Sonnet]`

```bash
cd ~/Obsidian/vault-michel
tail -10 04-SYSTEM/wiki/hot.md
ls 08-ARCHIVE/A/*.md 08-ARCHIVE/B/*.md 2>/dev/null | wc -l
```

`@nexus vault-reconcile-semanal iniciando — $(date -I)` — Nexus checa hot.md +
volume de arquivos em A/B. 0 arquivos em A/+B/ → skip, log em hot.md, parar. **Cost: 0.**

Se bloqueado → parar. Reportar motivo. Aguardar instrução.

---

## FASE 1 — Reconciliação `[vault-reconcile / nemotron-3-ultra:cloud]`

Disparar:

```
@vault-reconcile — auditoria semanal $(date -I)
```

Agente: [[04-SYSTEM/agents/nexus-agent-system/vault-reconcile]]

Faz: varre A/ depois B/, compara cada raw com source page correspondente, append
de seções faltantes (nunca rewrite), cria concepts/entities ausentes (zero stubs),
registra wikilinks quebrados, gera `06-GENERATED/audits/$(date -I)-vault-reconcile.md`,
chama `@ledger`.

Escalada Ollama→Claude: 2× output vazio ou ambiguidade conceitual → Sonnet.

---

## FASE 2 — Nexus final review `[Sonnet]`

`@nexus revisar $(date -I)-vault-reconcile` — Nexus lê relatório:
- Score de cobertura aceitável (>70%)?
- Concepts/entities criados fazem sentido (zero stub)?
- Wikilinks quebrados registrados corretamente?

Aprova → segue para hot cache. Rejeita → reportar issue, aguardar instrução.

---

## Hot cache `[bash — pós aprovação Nexus]`

```bash
{
  echo ""
  echo "## Vault Reconcile $(date -I)"
  echo "**Cobertura:** $COVERAGE_SCORE"
  echo "**Complementos:** $APPENDS_COUNT sources, $CONCEPTS_COUNT concepts, $ENTITIES_COUNT entities"
  echo "**Wikilinks quebrados:** $BROKEN_COUNT"
  echo "→ [[06-GENERATED/audits/$(date -I)-vault-reconcile]]"
} >> 04-SYSTEM/wiki/hot.md
# runtime-trace (WP3 — não confiar que o append rodou)
grep -q "Vault Reconcile $(date -I)" 04-SYSTEM/wiki/hot.md \
  && echo "✅ hot.md atualizado $(date -I)" \
  || echo "⚠️ hot.md NÃO recebeu entrada vault-reconcile — investigar"
```

---

## Commit gate

Executado por `@ledger` dentro do `vault-reconcile` (ver Critério de Done).
Threshold: >3 arquivos rastreados em sources/concepts/entities/hot.md → commit automático.

Se `@ledger` falhar: reportar `⚠️ commit pendente — <motivo>` no hot.md, não bloquear.

---

## Cost budget

| Step | Modelo | Tokens Claude |
|------|--------|----------------|
| NEXUS GATE início | Sonnet | ~80 |
| vault-reconcile (varredura + appends + relatório) | nemotron-3-ultra:cloud | 0 |
| Nexus final review | Sonnet | ~100 |
| ledger (commit + log) | minimax-m3:cloud (fallback Haiku) | 0–50 |

**Total Claude estimado**: ~180–230 tokens/run.

---

## Self-improvement log `[bash]`

```bash
mkdir -p 06-GENERATED/tasks
echo "- $(date -I): [vault-reconcile] cobertura=${COVERAGE_SCORE:-N/A}, appends=${APPENDS_COUNT:-0}, concepts=${CONCEPTS_COUNT:-0}, broken=${BROKEN_COUNT:-0}" >> 06-GENERATED/tasks/lessons.md
```

---

## Guardrails

- **Append > rewrite em tudo** — nunca destruir informação
- A/ antes de B/ — A tem maior valor
- Zero stubs — concepts/entities criados completos
- Wikilinks quebrados: registrar, não corrigir (decisão Nexus)
- Execução semanal (não diária) — Nemotron uso "High" no Ollama Cloud
- Se Nexus bloquear: parar, não pular gate
- Se 0 arquivos em A/+B/: skip total, **Cost: 0**

---

## Acceptance Criteria

- [ ] `$(date -I)-vault-reconcile.md` gerado (ou skip logado se 0 arquivos)
- [ ] A/ e B/ varridos
- [ ] Source pages desatualizadas complementadas via append
- [ ] Concepts/entities faltantes criados (zero stub)
- [ ] Wikilinks quebrados registrados
- [ ] hot.md atualizado
- [ ] Nexus final review aprovado
- [ ] `@ledger` chamado para commit gate

---

## Changelog

- v4 (2026-06-24): + self-improvement log — append métricas (cobertura, appends, concepts, broken) em `06-GENERATED/tasks/lessons.md`. Completa pré-requisito lessons log do padrão autoresearch-loop.
- v3 (2026-06-20): naming — output invertido p/ `06-GENERATED/audits/YYYY-MM-DD-vault-reconcile.md` (prefixo de data). Wikilink hot.md, ref `@nexus revisar` e acceptance criteria atualizados. Relatórios já criados mantidos.
- v2 (2026-06-19): + runtime-trace no append de hot.md (WP3 — gate que escreve hot.md verifica que a linha existe, não confia no spec).
- v1 (2026-06-09): criado. Schedule sexta 22h, conforme sugestão do `vault-reconcile`
  agent (ADR-002). Formato alinhado às demais rotinas locais (NEXUS GATE, fases,
  hot cache, commit gate, cost budget, changelog).
