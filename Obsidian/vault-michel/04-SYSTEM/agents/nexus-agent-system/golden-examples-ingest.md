---
title: "Golden Examples — Ingest Agent Source Pages"
type: reference
created: 2026-06-23
updated: 2026-06-23
tags: [reference, ingest, golden-examples, few-shot, quality]
---

# Golden Examples — Source Pages

2-3 exemplos anotados de Score A source pages de alta qualidade para uso como
few-shot examples pelo ingest-agent. Cada exemplo mostra o que "good" parece
em cada seção obrigatória.

---

## Example 1: Agent-as-a-Router (Score A, ai-agents)

### Frontmatter ✅
```yaml
---
title: "Agent-as-a-Router: Agentic Model Routing for Coding Tasks"
type: source
source: "Clippings/Agent-as-a-Router Agentic Model Routing for Coding Tasks.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---
```
Todos os campos presentes. `score: A` explícito. Tags corretas.

### Tese central ✅
> Real-world users typically have access to multiple Large Language Models (LLMs) from different providers, and these LLMs often excel at distinct domains. This paper proposes agentic model routing...

3 frases. Argumento principal + contexto. Sem bleeding de frontmatter.

### Argumentos principais ✅
Section headers preservados com conteúdo real:
- ### 1 Motivation and significance
- ### 2.1 Software architecture
- ### 2.2 Software functionalities

Não é apenas um dump — cada seção tem 3-5 linhas de conteúdo significativo.

### Key insights ✅
Bullet points extraídos do paper:
- "Real-world users typically have access to multiple Large Language Models..."
- "The compiler lowers the whole graph to the Model Intermediate Language..."

Cada bullet é uma insight real, não um heading.

### Links ✅
Todos resolvem para arquivos existentes:
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/entities/Python]]

### Minha Síntese ✅ (Score A)
```markdown
## Minha Síntese
**O que muda:** Model routing não é mais manual — agentes podem decidir qual modelo usar por requisição, reduzindo custo sem perder qualidade.

**Conexão pessoal:** O vault-michel usa model routing implícito (Haiku para triagem, Sonnet para ingest). Este paper formaliza o padrão.

**Próximo passo:** Avaliar se o model-router agent do vault pode usar este paper como base para roteamento dinâmico.
```

3 campos preenchidos com conteúdo real. Nenhum placeholder.

---

## Example 2: ANEForge (Score B, ai-agents)

### Tese central ✅
> ANEForge is a Python package that programs the Apple Neural Engine (ANE), the fixed-function neural accelerator on every recent Apple device, directly and without CoreML.

Tese clara e específica. Diferente de "Article about ANEForge."

### Argumentos principais ✅
Conteúdo preservado com nuances técnicas:
- Software architecture (lazy operator graph → MIL → ANE program)
- 58 fused operators + 19 bridge operators
- Weight compression (int8 2x, int4 LUT 4x, sparse)

Informação preservada, não condensada artificialmente.

### Minha Síntese ✗ (Score B — SKIP correto)
Score B não tem Minha Síntese. Correto per F2.9 guardrail.

---

## Checklist de Qualidade (para ingest-verify)

- [ ] Frontmatter: title, type, source, created, ingested, score, tags
- [ ] Tese central: 1-3 frases, sem frontmatter bleeding
- [ ] Argumentos: section headers + conteúdo real (não só headers)
- [ ] Key insights: bullet points reais, não headings
- [ ] Links: todos resolvem para arquivos existentes
- [ ] Minha Síntese (só Score A + ai-agents/articles): 3 campos com conteúdo real, sem placeholders
- [ ] Nenhum "A ser analisado" ou "placeholder" em nenhum lugar