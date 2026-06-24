---
title: "Socratic Method"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, learning-cognition]
status: developing
---

# Socratic Method

Aprender através de perguntas guiadas em vez de instrução direta — o interlocutor chega às respostas por dedução própria.

## O que é

O método socrático (elenchus) foi desenvolvido por Sócrates (~470-399 a.C.) como técnica de descoberta da verdade por meio de questionamento sistemático. A premissa: o conhecimento não é transferido, é evocado. O tutor faz perguntas que expõem contradições no raciocínio do aprendiz até que ele reconstrua o entendimento correto.

## Como funciona / Detalhes

**Estrutura do elenchus:**
1. O aprendiz afirma algo (hipótese)
2. O tutor faz perguntas que testam a consistência da hipótese
3. Contradições são expostas (aporia — estado de dúvida produtiva)
4. O aprendiz reconstrói entendimento mais refinado
5. Ciclo repete

**Por que funciona (ciência cognitiva):**
- **Active recall** — recuperar informação é mais eficaz que relê-la (effect size alto em estudos de memória)
- **Desirable difficulty** — o esforço de formular a resposta consolida a memória (Bjork, 1994)
- **Metacognição** — perguntas forçam o aprendiz a examinar o que sabe vs. o que acha que sabe

**LLM como tutor socrático:**
- Em vez de dar a resposta diretamente, o modelo faz perguntas: *"O que você entende por X? Como isso se relaciona com Y?"*
- Vault possui skill `grill-me` que implementa esse padrão — sessão de perguntas sobre um conceito
- Ver [[04-SYSTEM/skills/core/socratic-learning-loop]] para o ciclo implementado no vault

**Comparação com instrução direta:**
- Instrução direta: eficiente para conteúdo novo e densamente técnico
- Socrático: superior para consolidação, debugging de misconceptions, pensamento crítico

## Por que importa

Para Michel: método socrático é o modo mais eficiente de preparação para concursos — em vez de reler apostilas, sessões de perguntas activas ("grill-me") consolidam mais em menos tempo. FIAP cobra raciocínio, não memorização.

## Related
- [[03-RESOURCES/concepts/learning-cognition/_index]]
- [[03-RESOURCES/concepts/experience-compression-spectrum]]

## Evidências
- **[2026-06-24]** You finish a great book. Two weeks later you cannot remember a single chapter. Not because you are dumb. Because nobody — [[the-feynman-method-why-you-forget-90-of-what-you-read-and-the-4-prompts-that-fix-it]]
