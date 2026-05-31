---
agent: Stratum
model: claude-sonnet-4-6
type: agent-memory
updated: 2026-05-29
---

# Memory — Stratum (Backend & Core)

Memória persistente cross-session. Padrão [[_template|agent-memory]].

**Protocolo:**
- Ao iniciar sessão de backend/core: leia este arquivo.
- Ao encerrar com decisão notável: append à seção relevante.
- Formato: `[YYYY-MM-DD] [tipo] observação` — `DECISION·PATTERN·CONSTRAINT·FAILURE·PREFERENCE`.

---

## Padrões Aprendidos

- `[2026-05-29] PATTERN` Eficiência PDF: `pymupdf4llm.to_markdown(str(path),
  page_chunks=True)` em **uma passada**, não por-página — reabrir+reparsear o
  documento por página é O(n).
- `[2026-05-29] PATTERN` Decode de saída de binário externo: capturar **bytes**
  (sem `text=True`) e decodificar defensivamente `utf-8 → cp1252 → latin-1`
  (latin-1 nunca falha). Ferramentas legadas (antiword) emitem Latin-1.

---

## Falhas Documentadas

- `[2026-05-29] FAILURE` **Perda de dados**: nome de saída por `stem` só →
  `a.pdf` + `a.docx` colidem em `a.md`; sob ThreadPool, `write_text` concorrente
  no mesmo path = último vence, silencioso. Desambiguar por extensão,
  determinístico.
- `[2026-05-29] FAILURE` `subprocess.run(text=True)` decodifica com o locale
  (UTF-8 no macOS); antiword emite **Latin-1** → `UnicodeDecodeError` em PT-BR
  (público-alvo). Capturar bytes + decode defensivo.
- `[2026-05-29] FAILURE` Bibliotecas C (MuPDF via pymupdf4llm) escrevem no **fd 1
  nativo**; `contextlib.redirect_stdout` (troca só `sys.stdout`) **não** captura.
  Para proteger protocolo JSON no stdout, redirecionar no nível de fd
  (`os.dup2(2, 1)`) ao redor da chamada.
- `[2026-05-29] FAILURE` Display de duração com `.1f` arredondava conversões em
  ms (texto leva milissegundos) para "0.0s". Sub-segundo deve exibir em ms.

---

## Contexto Ativo

- Lições de pdf2md. Ver [[retrospectiva-pdf2md]] e [[code-review-ciclo2]].
- Catálogo de resolução de path para subprocess de binário de sistema é
  responsabilidade compartilhada com [[bastion]].
