---
name: cite-or-flag
description: Verificação de fato/citação — cita fonte real ou marca [não-verificado]. Anti-fabricação cross-system.
type: skill
created: 2026-06-27
---

# cite-or-flag — citar ou sinalizar

Aplica quando: agente afirma fato verificável (número, lei, norma, citação, data, preço).
Reusa o mecanismo citation-verify (T37/opendraft) generalizado p/ além de papers.

## Regra
1. Fato verificável → tem fonte? Sim: citar (autor/lei-art./URL/data).
2. Não tem fonte → marcar `[não-verificado]`, não afirmar como certo.
3. Texto normativo/citação literal → **verbatim**, nunca parafrasear (ver T41a).

## Systems de alto risco de fabricação (registrar disponível)
- **concurso-coach** + **edu-Banca:** lei seca, súmula, jurisprudência.
- **finance:** preço, Selic, DARF, múltiplo, data de balanço.
- **tjam-Lex:** artigo/inciso/norma.
- knowledge já tem `source-validator` (equivalente) — não duplicar, referenciar.

## Liga a
hallucination-gate (T15/adversarial-gate), citation-verify (T37), source-validator (knowledge).