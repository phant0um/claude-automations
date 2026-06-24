---
title: Prompt Master
type: concept
status: developing
created: 2026-04-24
updated: 2026-04-24
tags: [prompt-engineering, claude-skills, token-efficiency]
---

# Prompt Master

Claude Skill que transforma intenção vaga em prompt preciso para qualquer ferramenta de IA. Resolve o problema de re-prompting — 3–4 tentativas desnecessárias que desperdiçam créditos.

## Princípio Central

> "The best prompt is not the longest. It's the one where every word is load-bearing."

Ao contrário de geradores de prompt tradicionais que tornam prompts mais longos, Prompt Master os torna mais **afiados** via token efficiency audit explícito.

## Pipeline de 7 Etapas

```
Detecta ferramenta → Extrai 9 dimensões → Clarifica (max 3 perguntas)
→ Roteia framework → Aplica técnicas seguras → Audit de tokens → Entrega prompt
```

**9 dimensões de intent:** task, input, output, constraints, context, audience, memory, success criteria, examples.

## Roteamento por Categoria de Ferramenta

| Tipo de ferramenta | Abordagem |
|--------------------|-----------|
| Thinking LLMs (o3, o4-mini) | Instrução curta apenas — nunca adiciona CoT (eles pensam internamente) |
| Agentic AI (Claude Code, Devin) | Stop conditions + file scope + checkpoint output |
| Image AI (Midjourney) | Comma-separated descriptors + negative prompt |
| Stable Diffusion | Weight syntax `(word:1.3)` + CFG guidance + negative obrigatório |
| Voice AI (ElevenLabs) | Emotion + pacing + emphasis + speech rate |
| Automation (Make/n8n) | Trigger app + event + action app + field mapping |

## Memory Block

Para sessões longas, prepend automático de decisões anteriores para evitar contradições. É a solução estrutural para re-prompts causados por esquecimento do AI em sessões multi-turn.

## Anti-patterns Detectados

35 padrões divididos em: Task (7), Context (6), Format (6), Scope (6), Reasoning (5), Agentic (5).

## Técnicas Explicitamente Excluídas

Tree of Thought · Graph of Thought · Universal Self-Consistency · prompt chaining — todos excluídos por risco de alucinação ou output imprevisível.

## Instalação

```bash
# Recomendado: claude.ai → Customize → Skills → Upload
# Alternativo:
git clone https://github.com/nidhinjs/prompt-master.git ~/.claude/skills/prompt-master
```

## Relações

- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]] — anti-patterns que Prompt Master detecta
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — Prompt Master segue a especificação SKILL.md
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — Memory Block = context engineering para re-prompts
- [[03-RESOURCES/concepts/learning-cognition/adaptive-thinking]] — Thinking LLMs (o3/o4) recebem instrução curta por design
- [[03-RESOURCES/sources/skills-prompting-mcp/prompt-master-claude-skill]] — fonte completa
