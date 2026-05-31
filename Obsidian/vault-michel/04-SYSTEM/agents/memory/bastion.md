---
agent: Bastion
model: claude-sonnet-4-6
type: agent-memory
updated: 2026-05-29
---

# Memory — Bastion (Infra & Empacotamento)

Memória persistente cross-session. Padrão [[_template|agent-memory]].

**Protocolo:**
- Ao iniciar sessão de infra/empacotamento/CI: leia este arquivo.
- Ao encerrar com decisão notável: append à seção relevante.
- Formato: `[YYYY-MM-DD] [tipo] observação` — `DECISION·PATTERN·CONSTRAINT·FAILURE·PREFERENCE`.

---

## Decisões Arquiteturais

- `[2026-05-29] CONSTRAINT` Build de release vive em **script versionado**
  (`scripts/build_app.sh`), nunca comandos one-off. Build manual perdeu
  reprodutibilidade entre v0.1.0 e v0.2.0 do pdf2md.

---

## Padrões Aprendidos

- `[2026-05-29] CONSTRAINT` **Binário PyInstaller one-file = PATH mínimo** (sem
  `/opt/homebrew/bin/`). Todo `subprocess` de binário de sistema (tesseract,
  antiword, ...) precisa de **resolução de path explícita** (PATH → fallback
  Homebrew → nome literal). Catálogo: `_configurar_tesseract_cmd`,
  `_resolver_antiword`. Ver META-FALHA 1 em [[retrospectiva-pdf2md]].
- `[2026-05-29] PATTERN` **DMG via hdiutil**: NÃO usar `create -srcfolder` com
  symlink `/Applications` — o auto-size segue o symlink e estoura ("no space")
  com binário grande. Receita: imagem RW de **tamanho explícito** (`du -sm +
  margem`) → montar → copiar app + symlink → **detach por device node** (`-force`;
  por mountpoint dá "resource busy") → `convert UDZO`. (`-format` exige
  `-srcfolder`; para imagem RW vazia, só `-size -fs`.)
- `[2026-05-29] PATTERN` Em PyInstaller one-file usar **ThreadPoolExecutor**, não
  ProcessPoolExecutor: `spawn` re-executa o binário congelado com flags que o
  Typer rejeita. fitz/tesseract liberam o GIL em C → threads paralelizam de fato.

---

## Falhas Documentadas

- `[2026-05-29] FAILURE` Empacotou e publicou v0.1.0 com o bug do Tesseract
  (PATH) e v0.2.0 com o bug idêntico do antiword. Dois releases quebrados pela
  mesma causa-raiz. Lição: ao adicionar dep externa, replicar o catálogo de
  resolução de path **antes** de empacotar.

---

## Contexto Ativo

- Projeto-fonte das lições: pdf2md (macOS, Python+SwiftUI). Ver
  [[retrospectiva-pdf2md]].
- Pendência: adicionar o catálogo subprocess-path + idioma hdiutil em
  `docs/Standards-Anti-Patterns.md`.
