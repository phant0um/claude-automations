---
title: "Prompt Master — Claude Skill"
type: source
created: 2026-04-24
updated: 2026-04-24
tags: [prompt-engineering, claude-skills, ai-tools]
source_file: "Prompt Master.md"
repo: https://github.com/nidhinjs/prompt-master
---

# Prompt Master — Claude Skill

**Tipo:** Claude Skill (instalável via claude.ai → Skills → Upload ou clone em `~/.claude/skills/`)  
**Autor:** nidhinjs  
**Versão atual:** 1.5.0

## O Problema Resolvido

Usuários desperdiçam créditos escrevendo prompts vagos → recebem output errado → repromptam 3–4 vezes. Prompt Master elimina esse loop ao gerar o prompt correto na primeira tentativa.

> "The best prompt is not the longest. It's the one where every word is load-bearing."

## Pipeline Interno (7 Etapas)

1. **Detecta a ferramenta-alvo** — roteamento silencioso (usuário nunca vê)
2. **Extrai 9 dimensões de intent** — task, input, output, constraints, context, audience, memory, success criteria, examples
3. **Faz até 3 perguntas de clarificação** — só se informação crítica estiver faltando
4. **Roteia para o framework correto** — pick automático, nunca exposto ao usuário
5. **Aplica 5 técnicas seguras** — role assignment, few-shot, XML structure, grounding anchors, memory block
6. **Executa token efficiency audit** — elimina palavras que não mudam o output
7. **Entrega o prompt** — 1 bloco copiável + nota de estratégia de 1 linha

## Técnicas Excluídas Intencionalmente

Tree of Thought, Graph of Thought, Universal Self-Consistency, prompt chaining — excluídos por produzir alucinações ou outputs imprevisíveis.

## Memory Block System

Para sessões longas, prepend automático de decisões anteriores:
```
## Memory (Carry Forward from Previous Context)
- Stack: React 18 + TypeScript + Supabase
- Auth: JWT em httpOnly cookies
- Naming: PascalCase, sem default exports
```
Resolve o problema de re-prompts causados pelo AI "esquecendo" decisões anteriores.

## Cobertura de Ferramentas (30+ perfis)

| Categoria | Ferramentas |
|-----------|------------|
| Reasoning LLMs | Claude, ChatGPT/GPT-5.x, Gemini 2.x, DeepSeek-R1, MiniMax |
| Thinking LLMs | o3/o4-mini — instrução curta apenas, sem CoT externo |
| Agentic AI | Claude Code (stop conditions + file scope), Cursor/Windsurf, Cline, Devin |
| Image AI | Midjourney (comma-separated descriptors), DALL-E 3, Stable Diffusion (weight syntax), ComfyUI |
| Video AI | Sora/Runway (camera movement + duration), LTX/Dream Machine/Kling |
| Voice AI | ElevenLabs (emotion + pacing + emphasis) |
| Automation | Zapier/Make/n8n (trigger/action + field mapping) |
| 3D AI | Meshy/Tripo/Rodin (style + export + polygon budget) |

Para ferramentas fora da lista: **Universal Fingerprint** — 4 perguntas que permitem gerar prompt de qualidade para qualquer AI desconhecida.

## 35 Padrões Detectados (anti-patterns)

Agrupados em 5 categorias: Task (7), Context (6), Format (6), Scope (6), Reasoning (5), Agentic (5).

## Invocação

```
Write me a prompt for Cursor to refactor my auth module
/prompt-master
I want to ask Claude Code to build a todo app with React and Supabase
```

## Conexões

- [[03-RESOURCES/concepts/prompt-engineering-patterns]] — padrões que Prompt Master detecta e corrige
- [[03-RESOURCES/concepts/claude-skills]] — Prompt Master é um SKILL.md instalável
- [[03-RESOURCES/concepts/context-engineering]] — o Memory Block é context engineering aplicado a re-prompts
- [[03-RESOURCES/concepts/token-efficiency]] — audit de tokens como etapa explícita no pipeline
- [[03-RESOURCES/entities/Claude Code]] — perfil específico com stop conditions + file scope + checkpoint output
