---
name: prototype
description: "Build a throwaway prototype to flesh out a design — terminal app for state/logic questions, or UI variants for look questions. Use when answering a design question cheaply."
skill: prototype
version: 1.0
author: Nexus Agent System
source: mattpocock/skills (prototype)
trigger: "/prototype" | "@prototype"
model: claude-sonnet-4-6
tags: [prototype, throwaway, design, logic, ui, terminal, variants]
---

# Skill: Prototype

## Propósito

Protótipo é **throwaway code que responde uma pergunta**. A pergunta decide a forma.

> **Leading word: throwaway.** Protótipo não é produção. É código que responde uma pergunta e depois é deletado ou absorvido.

---

## Condições de Ativação

Ative quando:
- User precisa responder uma pergunta de design barato antes de commit
- "Does this logic/state model feel right?" → LOGIC branch
- "What should this look like?" → UI branch
- Antes de implementar feature complexa sem clareza

NÃO ative para: features já especificadas (→ /implement); hotfixes; refactors.

---

## Pick a Branch

Identificar a pergunta:
- **"Does this logic / state model feel right?"** → [LOGIC.md](references/prototype-logic.md)
- **"What should this look like?"** → [UI.md](references/prototype-ui.md)

Se ambíguo e user indisponível: defaultar para branch que melhor matcha código adjacente (backend → logic; page/component → UI). State assumption no topo.

---

## Rules que aplicam a ambos

1. **Throwaway from day one.** Código próximo de onde será usado, mas nomeado como prototype.
2. **One command to run.** Task runner existente (pnpm, python, bun, etc).
3. **No persistence by default.** State em memória. DB só se a pergunta envolve DB (scratch DB com nome "PROTOTYPE — wipe me").
4. **Skip the polish.** Sem testes, sem error handling além do runnable, sem abstrações.
5. **Surface the state.** Após cada action (logic) ou variant switch (UI), print/render full relevant state.
6. **Delete or absorb when done.** Resposta capturada → delete prototype ou fold na real code.

---

## Completion

- [ ] Branch identificada (LOGIC ou UI)
- [ ] Pergunta explicitamente escrita no topo do prototype
- [ ] 1 comando para rodar
- [ ] State surfaced após cada action/switch
- [ ] Resposta capturada (commit message, ADR, NOTES.md, ou conversa)
- [ ] Prototype deletado ou absorvido na real code

## Failure modes

- **Production prototype**: adicionar testes, error handling, abstrações → prototype não é produção
- **DB wiring**: conectar DB real sem ser scratch → persistence é o que se está testando, não depender disso
- **Generalise**: "what if we wanted X later" → prototype responde 1 pergunta, não é genérico
- **Logic/TUI blur**: logic referencing console.log para control flow → logic deve ser pure, TUI imports logic
- **No answer captured**: protótipo respondeu mas resposta não foi registrada → capturar antes de deletar

---

## Self-Improvement

Após cada execução:
1. Se protótipo não respondeu a pergunta → registrar por quê em `06-GENERATED/tasks/lessons.md`
2. Se protótipo virou produção (não foi deletado) → flag para revisão
3. Lições append: `- YYYY-MM-DD: [prototype] branch=X, pergunta=Y, resposta=Z`

> Ver: [[04-SYSTEM/skills/reasoning/hill-climb]] · [[03-RESOURCES/concepts/pkm-obsidian/autoresearch-loop]]

---

## Restrições

- NUNCA adicione testes ao protótipo
- NUNCA wire DB real (use in-memory ou scratch)
- NUNCA generalize além da pergunta
- NUNCA deixe protótipo rotting no repo — delete ou absorva

---

## Relacionado

- [[04-SYSTEM/skills/foundational/spec-lifecycle]] — spec antes de implementar; prototype antes de spec
- [[04-SYSTEM/skills/core/tdd]] — TDD durante implementação, não protótipo
- [[04-SYSTEM/skills/core/implement]] — implementação após prototype validar design
- [[03-RESOURCES/sources/ai-agents/matt-pocock-skills-14-analysis]] — fonte original