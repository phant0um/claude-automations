---
agent: Maestro
model: claude-sonnet-4-6
type: agent-memory
updated: 2026-05-29
---

# Memory — Maestro (Orquestração)

Memória persistente cross-session. Padrão [[_template|agent-memory]].

**Protocolo:**
- Ao iniciar qualquer ciclo: leia este arquivo + `progress.md` (File-as-Bus).
- Ao encerrar ciclo com decisão notável: append à seção relevante.
- Formato: `[YYYY-MM-DD] [tipo] observação` — `DECISION·PATTERN·CONSTRAINT·FAILURE·PREFERENCE`.

---

## Decisões Arquiteturais

- `[2026-05-29] DECISION` **Nova dependência externa via subprocess** dispara
  checagem obrigatória contra o catálogo de fixes (`grep subprocess.run core/`).
  Anti META-FALHA 1: o sistema tinha o fix do Tesseract em código e não o
  reusou para o antiword → 2 releases quebrados.
- `[2026-05-29] DECISION` **Code-review max-effort** (5 finders + verify + sweep)
  é **gate pré-release obrigatório**, não faxina posterior. ROI comprovado: pegou
  15 bugs que os gates pularam.

---

## Padrões Aprendidos

- `[2026-05-29] CONSTRAINT` Gate exige **evidência** (findings + score reais),
  **nunca "score estimado"**. "Resolvido inline" ≠ revisado. Anti META-FALHA 2.
- `[2026-05-29] PATTERN` Distinguir falha de teste **ambiental** de regressão:
  validar contra o base limpo (`git stash`) antes de culpar a mudança. 5 falhas
  de OCR no pdf2md eram bug do pytesseract no ambiente, não regressão.
- `[2026-05-29] PATTERN` Toda mudança a `main` via branch + PR + CI verde
  (branch protegida); releases públicos são **red task** — confirmar antes.

---

## Falhas Documentadas

- `[2026-05-29] FAILURE` Ciclo 2 do pdf2md fechado com Gate 2 pulado e
  auto-avaliação "≥85" sem evidência → bugs críticos shippados. Não fechar ciclo
  sem evidência de gate.

---

## Contexto Ativo

- Hill-climbing (Constituição #6) alimentado por [[retrospectiva-pdf2md]].
- Memórias dos especialistas: [[bastion]] · [[stratum]] · [[facet]] ·
  [[sentinel]] · [[neuron]].
- Pendência: promover o code-review max-effort a etapa fixa do pipeline e
  registrar o catálogo subprocess-path em `docs/standards-anti-patterns.md`.
