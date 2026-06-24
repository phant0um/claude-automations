---
title: "Experience Compression Spectrum"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, learning-cognition]
status: developing
---

# Experience Compression Spectrum

O espectro que vai da experiência bruta não processada até o insight cristalizado — e como o vault comprime conhecimento ao longo desse eixo.

## O que é

Toda informação que chega à mente (ou ao vault) passa por graus crescentes de compressão antes de se tornar conhecimento reutilizável. O "experience compression spectrum" descreve essa hierarquia e os trade-offs de cada nível: mais compressão = menos detalhe, mais portabilidade.

## Como funciona / Detalhes

**Hierarquia de compressão:**

```
Experiência bruta
  → Nota / Clipping (captura fiel, alto fidelidade, alto volume)
    → Source (estruturado, contexto preservado)
      → Concept (síntese destilada, aplicável, ~30-50 linhas)
        → Principle (insight universal, uma frase)
```

**Analogia com compressão de dados:**
- **Lossless** (sem perda): transcrição, OCR, cópia fiel — preserva tudo, ocupa mais espaço
- **Lossy** (com perda): resumo, síntese, concept note — descarta detalhes, retém estrutura e significado
- **Ultra-compressão**: princípio, aforismo — máxima portabilidade, mínimo contexto

**No vault (pipeline de ingestão):**
1. `Clippings/` — artigos brutos (lossless, alta fidelidade)
2. `.raw/` — fontes catalogadas
3. `03-RESOURCES/sources/` — source note estruturada (lossy nível 1)
4. `03-RESOURCES/concepts/` — conceito destilado (lossy nível 2)
5. `04-SYSTEM/wiki/principles.md` — princípios operacionais do SO (máxima compressão)

**Trade-off chave:**
- Comprimir cedo demais perde contexto valioso para revisão futura
- Comprimir tarde demais mantém ruído que dilui sinal
- Ponto ideal: concept note de 30-50 linhas captura 80% do valor em 10% do volume

## Por que importa

Para Michel: entender o espectro ajuda a decidir *o que* ingerir e *quanto* processar. Para concursos, o estudo eficiente é comprimir apostilas → concept notes → flashcards (máxima compressão para active recall).

## Related
- [[03-RESOURCES/concepts/learning-cognition/_index]]
- [[03-RESOURCES/concepts/socratic-method]]
- [[03-RESOURCES/concepts/selective-refinement]]
