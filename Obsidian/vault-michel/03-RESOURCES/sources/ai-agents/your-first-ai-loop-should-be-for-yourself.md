---
title: "Your first AI loop should be for yourself (template included)"
type: source
source_url: "https://x.com/cathrynlavery/status/2069193102586474781"
author: "@cathrynlavery"
published: 2026-06-22
created: 2026-06-22
updated: 2026-06-22
score: B
category: ai-agents
tags: [source, ai-agents, self-improvement-loop, claude-code, codex, content-creation, session-mining, loop-engineering]
---

# Your first AI loop should be for yourself (template included)

O primeiro loop que vale a pena construir não é um agent loop onde o ponto é "make the agent more autonomous" — é um **self-improvement loop** onde o ponto é: minar o trabalho que você já está fazendo e usá-lo para melhorar a si mesmo, seu setup, e seu conteúdo.

## Tese Central

Seu terminal é um registro honesto de como você trabalha. Lendo suas próprias sessões de Claude Code/Codex como evidence (não como conversas), você descobre padrões: o que repete, o que explica aos agentes várias vezes, o que fez no terminal que seria artigo/prompt/diagrama/tutorial. O loop faz duas perguntas a cada sessão recente: (1) What should I create from this? (2) What should I fix so tomorrow is easier? Noticing é a parte fácil; decidir que tipo de lição encontrou e onde ela pertence é a parte difícil.

## Pontos-Chave

### Por que este Loop Primeiro

- Maioria mira AI em output porque output é o win visível
- Oportunidade maior é o pattern por baixo do output
- Terminal = accidental curriculum: o que está aprendendo, o que repeatedly fixa, shortcuts que usa sem pensar, onde tools annoy, o que deveria ensinar
- Compõe em duas direções: melhora o work (todo fix em context file/command/skill/hook/tool/config paga em toda sessão futura) + gera ideas de content (todo repeated behavior é possível artigo/tweet/workshop)

### The Two-Loop Version

- **Inner loop**: trabalho que já está fazendo em Claude Code/Codex/GLM 5.2 — agentic coding, research, debug
- **Outer loop**: assiste essas runs after the fact. Não re-faz o trabalho. Pergunta o que o trabalho revelou sobre você e seu setup

### As Duas Perguntas

> What did I do here that is worth turning into content?
> What reusable improvement would have made this session shorter, safer, cheaper, more correct, or less annoying?

### Sete Homes para a Lição

1. **Content idea** — algo que outra pessoa pediria para explicar
2. **Tool fix** — agent usou comando errado porque help text é ruim
3. **Context-file fix** — corrigiu mesma repo convention pela terceira vez
4. **Slash command** — digitou mesmo workflow de 5 steps de novo
5. **Skill** — comportamento que merece ser encapsulado
6. **Hook** — ação automática que deveria rodar em trigger
7. **Config / CLI** — custom-built CLI que poderia ser melhor

### Self-Improving Agent ≠ Self-Rewriting Agent

"Self-improving agent" não significa que o agent pode wander around rewriting itself. É um scout que traz back evidence e diz "this part of the day had signal." Você decide o que muda.

## Conceitos

- [[03-RESOURCES/concepts/agent-systems/loop-engineering-patterns]] — loop patterns
- [[03-RESOURCES/concepts/pkm-obsidian/self-improving-vault]] — vault que melhora a si mesmo
- [[03-RESOURCES/concepts/pkm-obsidian/self-rewrite-hooks]] — hooks de auto-rewriting
- [[03-RESOURCES/concepts/learning-cognition/continuous-learning-v2]] — aprendizagem contínua
- [[03-RESOURCES/concepts/learning-cognition/skill-development]] — skill dev
- [[03-RESOURCES/concepts/pkm-obsidian/obsidian-agent-skills]] — agent skills no Obsidian
- [[03-RESOURCES/concepts/learning-cognition/externalized-memory]] — memória externalizada

## Links

- [[03-RESOURCES/entities/Claude-Code]] — tool usada
- [[03-RESOURCES/entities/hermes]] — Hermes Agent (analogia)