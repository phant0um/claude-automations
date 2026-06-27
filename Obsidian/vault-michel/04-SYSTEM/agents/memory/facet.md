---
agent: Facet
model: claude-sonnet-4-6
type: agent-memory
updated: 2026-05-29
---

# Memory — Facet (Frontend & Swift bridge)

Memória persistente cross-session. Padrão [[_template|agent-memory]].

**Protocolo:**
- Ao iniciar sessão de UI/Swift/bridge: leia este arquivo.
- Ao encerrar com decisão notável: append à seção relevante.
- Formato: `[YYYY-MM-DD] [tipo] observação` — `DECISION·PATTERN·CONSTRAINT·FAILURE·PREFERENCE`.

---

## Padrões Aprendidos

- `[2026-05-29] PATTERN` Confinamento de path por **componente**:
  `path == home || path.hasPrefix(home + "/")`. `hasPrefix(home)` cru deixa
  `/Users/bob` prefixar `/Users/bobby`.
- `[2026-05-29] PATTERN` Estado de processo assíncrono com **dono único**:
  `cancelar()` apenas sinaliza/termina; a cauda do loop liquida a UI. Evita
  corrida quando o usuário reinicia durante o teardown.

---

## Falhas Documentadas

- `[2026-05-29] FAILURE` **Deadlock `Process` + `Pipe`**: ler
  `readDataToEndOfFile()` **depois** de `waitUntilExit()`, com stderr nunca
  drenado, congela — o pipe (~64KB) enche, o filho bloqueia em `write()` e nunca
  sai. Drenar stdout **e** stderr concorrentemente, em paralelo ao wait
  (`readToEnd()` em `Task.detached` separadas). Guard `isRunning` antes de
  `terminate()`.
- `[2026-05-29] FAILURE` Cancelamento zerava `estaProcessando` síncrono,
  reabilitando "Converter" antes da Task cancelada terminar → nova execução +
  cauda da antiga se atropelam. Ver dono único acima.

---

## Contexto Ativo

- Lições de pdf2md (SwiftUI shell + bridge Process↔Python). Ver
  [[retrospectiva-pdf2md]].
- Bridge consome JSON por linha do binário; stdout precisa ser **puro JSON** —
  ruído nativo de libs C é problema do core ([[stratum]]).

## Self-Improvement

Após cada execução com output significativo:
1. Se usuário corrigir output → `/meta-learn` extrai princípio (não regra)
2. Se padrão recorrente de erro (≥2×) → flag para `@hill <slug>` com contexto
3. Lições append em `06-GENERATED/tasks/lessons.md` (formato: `- YYYY-MM-DD: [<slug>] <observação>`)

> Ver: [[04-SYSTEM/skills/core/meta-learn]] · [[04-SYSTEM/skills/reasoning/hill-climb]] · [[03-RESOURCES/concepts/pkm-obsidian/autoresearch-loop]]
