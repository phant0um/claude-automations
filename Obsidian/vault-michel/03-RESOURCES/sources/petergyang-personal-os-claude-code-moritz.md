---
title: "Peter Yang — Personal OS com Claude Code (baseado em Moritz)"
type: source
source_file: "Clippings/Thread by @petergyang on Thread Reader App.md"
origin: thread no X (@petergyang)
ingested: 2026-05-14
tags: [claude-code, personal-os, memory, skills, routines, moritz]
---
# Peter Yang — Personal OS com Claude Code (baseado em Moritz)

> [!key-insight] Core point
> 5 takeaways de Moritz sobre como montar um Personal OS com Claude Code: estrutura de arquivos, memory loop, CLIs/MCPs, skills por workflow, e routines locais + remotas.

## Conteúdo

### 1. Estrutura de arquivos base
- `soul.md` — personalidade e tom do agente
- `user.md` — o que o agente sabe sobre você
- `tools.md` — lista de CLIs/MCPs/APIs disponíveis
- `memory/` — notas diárias de chats passados + arquivo de memória long-term

### 2. Memory Loop
- Regra no `claude.md`: após toda conversa, escrever uma linha num arquivo de memória diária
- Rotina noturna ("Dreaming"): comprime arquivos diários em memória long-term

### 3. CLIs, MCPs e APIs críticos
- `gws` CLI — Google Workspace
- `wacli` — WhatsApp
- `postiz cli` — posting em social platforms

### 4. Skill por workflow repetido
- Qualquer workflow feito 2× → virar skill
- Exemplos: skill de compras (reabastece carrinho da semana anterior), skill de upload de vídeo (cria pastas Drive para editor)
- Anthropic official skills: [github.com/anthropics/skills](https://github.com/anthropics/skills)

### 5. Routines locais e remotas
- **Local:** CEO Brief (sumário do dia), todo diário, Dream (compressão noturna de memória)
- **Remote (GitHub):** planejamento semanal de conteúdo, YouTube monitor de canais concorrentes

**Recursos:** [Tutorial completo (YouTube)](https://youtu.be/ACRd0Ikg_KI) | [Post escrito](https://creatoreconomy.so/p/build-a-claude-code-personal-os-step-by-step-moritz)

## Conexões
- [[03-RESOURCES/entities/Peter-Yang]]
- [[03-RESOURCES/concepts/claude-code-workflow]]
- [[03-RESOURCES/concepts/agent-memory-architecture]]
- [[03-RESOURCES/concepts/agentic-skills]]
- [[03-RESOURCES/concepts/self-writing-vault]]
