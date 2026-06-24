---
title: "How to Build a Claude Skill (So You Never Paste the Same Prompt Twice)"
type: source
source: "Clippings/How to Build a Claude Skill (So You Never Paste the Same Prompt Twice).md"
author: "@0xLagosaur"
published: 2026-06-21
created: 2026-06-22
ingested: 2026-06-22
tags: [claude-code-skills, skills, prompting, automation]
score: A
---

## Tese Central

Um prompt é algo que você lembra de usar. Uma Skill é algo que Claude lembra de usar por você. Essa é a mudança inteira. Se você colou um prompt mais de 3 vezes, deveria ser uma Skill. Se explicou a mesma preferência mais de 2 vezes, deveria ser uma Skill.

## Pontos-Chave

1. **Skill ≠ Prompt**: prompt é temporário, Skill é permanente. Claude lê a situação e puxa a Skill automaticamente quando a task fits a description que você deu.
2. **Estrutura minimal**: folder com um required file `SKILL.md`. Header (name + description = trigger) + instructions. Código é plain English.
3. **Cross-platform**: mesma folder roda no Claude app, Claude Code, e API. Build once, use everywhere.
4. **Lazy loading**: só a one-line description fica no context sempre. Instruções completas carregam apenas quando a task triggera a Skill. 20 Skills instaladas = quase zero context cost para as 19 não em uso.
5. **Description é o trigger**: escreva como "Use when I…" com frases reais que você digita. Vago = Skill nunca fires. Específico = fires exatamente quando quer.
6. **4 Skills copy-paste**: my-voice (voice consistency), fact-check (verify claims), should-i (decision filter: ship/fix/kill), checkpoint (compress long chats).
7. **3-layer architecture**: Layer 1 Description (always loaded), Layer 2 Instructions (load when triggered), Layer 3 Reference files (load only when needed). 50-page brand book sem arrastar em toda conversa.
8. **Pro moves**: keep heavy material em `references/` subfolder. Claude carrega apenas quando necessário. Skill pode conhecer brand book de 50 páginas sem custar context em toda conversa.
9. **Skills como open standard**:Anthropic publica official skills em github.com/anthropics/skills. Skills se tornaram standard aberto em late 2025 — Copilot, Cursor, Codex, e 40+ tools leem o mesmo formato.
10. **Debugging**: Never Fires = description não match sua linguagem. Fires Too Often = description broad demais. Ignores Rules = instruções longas/contraditórias/multi-job. Stale = editar e re-upload.

## Conceitos

- Skill = prompt persistente com auto-activation
- Lazy loading de context (description always, instructions on trigger, references on demand)
- Description como trigger phrase ("Use when I…")
- 3-layer context architecture
- Skills como open standard cross-tool

## Minha Síntese

**O que muda:** Este é o guia prático mais claro de como buildar uma Skill. A regra "pastou 3+ vezes → Skill" e "explicou 2+ vezes → Skill" é o critério de priorização que faltava. As 4 Skills copy-paste são templates imediatatos para o vault.

**Conexão pessoal:** O vault tem 36+ skills em 04-SYSTEM/skills/. A maioria foi criada sem seguir o 3-layer pattern. References/ subfolder é quase inexistente — skills carregam tudo no SKILL.md. Migrar para 3-layer reduziria context cost.

**Próximo passo:** Auditar top 5 skills mais usadas e refatorar para 3-layer (separar references/). Adicionar description triggers com frases reais que eu uso.

## Links

- [[03-RESOURCES/concepts/claude-code-tooling]]
- [[03-RESOURCES/entities/Claude]]
- [[03-RESOURCES/sources/claude-code-skills/claude-code-skills-the-hidden-system-prompt-layer-that-turns-claude-into-a-senior-engineer]]
- [[04-SYSTEM/skills/core/triagem-scoring]]