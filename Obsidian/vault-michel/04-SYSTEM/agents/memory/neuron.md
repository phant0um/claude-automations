---
agent: Neuron
type: agent-memory
updated: 2026-05-29
---

# Memory — Neuron (Data & AI / OCR)

Memória persistente cross-session. Padrão [[_template|agent-memory]].

**Protocolo:**
- Ao iniciar sessão de pipeline/OCR/ML: leia este arquivo.
- Ao encerrar com decisão notável: append à seção relevante.
- Formato: `[YYYY-MM-DD] [tipo] observação` — `DECISION·PATTERN·CONSTRAINT·FAILURE·PREFERENCE`.

---

## Padrões Aprendidos

- `[2026-05-29] PATTERN` Memoizar checagens de dependência de OCR
  (`verificar_tesseract`/`_configurar_tesseract_cmd` com `lru_cache`): um
  subprocess `tesseract --version` por página/imagem é desperdício; a
  disponibilidade não muda durante a execução.
- `[2026-05-29] PATTERN` Pipeline OCR: extrair texto nativo primeiro
  (`get_text() >= 50 chars`) e só cair em OCR quando necessário — não OCR à toa.

---

## Falhas Documentadas

- `[2026-05-29] FAILURE` `pytesseract` decodifica o **stderr** do Tesseract como
  UTF-8 → `UnicodeDecodeError` quando o Tesseract emite bytes não-UTF8 (ex:
  imagens em branco). **Mesma classe** do bug do antiword: dependência externa
  emitindo não-UTF8. Capturar bytes. (Pendente: hardening em
  `image_converter.py` — atualmente mascara como "Falha no processamento".)

---

## Preferências do Usuário

- `[2026-05-29] PREFERENCE` OCR PT-BR é o caso de uso central — idioma
  `por+eng`, e robustez a acentos/Latin-1 em toda a cadeia.

---

## Contexto Ativo

- Falhas de teste de OCR locais podem ser **ambientais** (bug do pytesseract no
  stderr), não regressão — validar contra base limpo. Ver
  [[retrospectiva-pdf2md]] e [[maestro]].
