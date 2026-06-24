---
title: "Post @0x_kaize — Claude Code token savings (CLAUDE.md optimization)"
type: source
source_type: post-x
source_url: https://x.com/0x_kaize/status/2048427803272483238
created: 2026-05-31
updated: 2026-06-10
tags: [memory-context-rag, token-economy, claude-code]
status: seed
---

# Post @0x_kaize — CLAUDE.md Token Savings

## Resumo

@0x_kaize aponta: a maioria dos usuários Claude Code paga $200/mês e usa 1% do potencial — desperdício concentrado em **CLAUDE.md inchado**.

**Pontos centrais:**
- 20.000–30.000 tokens carregam antes do usuário digitar qualquer coisa: system prompt + CLAUDE.md + memory + nomes de tools MCP + descriptions de skills
- CLAUDE.md é pago **toda mensagem, toda sessão** — arquivo mais caro que você controla
- Exemplo demonstrado: 3.847 tokens → 312 tokens (mesmo comportamento), **91.9% de redução**
- Técnica: comentários HTML (`<!-- nota interna -->`) são removidos antes da injeção — custam zero tokens, úteis pra notas de equipe sem custo
- `.claude/rules/` — regras com frontmatter `paths:` carregam só quando arquivo correspondente é lido (lazy-load, zero custo até trigger)

## Por que importa (vault)

Conecta direto com [[03-RESOURCES/concepts/llm-ml-foundations/token-compression]] e práticas RTK já em uso neste vault. Validar: CLAUDE.md do vault usa `<!-- [INVARIANT] -->` (HTML comment) — já alinhado à técnica 1.

## Notes
Conteúdo via WebSearch (2026-06-10) — Clippings original consumido.
