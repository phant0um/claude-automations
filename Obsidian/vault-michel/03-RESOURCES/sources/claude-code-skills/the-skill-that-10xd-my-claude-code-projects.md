---
title: "The Skill That 10x'd My Claude Code Projects"
type: source
source: "Clippings/The Skill That 10x'd My Claude Code Projects.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [claude-code, skills, context-extraction, grill-me, prompting]
---

## Tese central

O verdadeiro gargalo em projetos com Claude Code não é o prompt — é a extração: tirar tudo da sua cabeça e colocar no sistema como contexto reutilizável. A skill `grill-me` automatiza esse processo de entrevista sistemática com checkpointing, elevando a qualidade da iteração inicial de ~70% para ~90%.

## Argumentos principais

- Todos rodam o mesmo modelo; o que diferencia o output é o contexto fornecido — gosto, voz, decisões extraídas da cabeça do usuário.
- Um brain dump de 5 minutos no Claude Code nunca é suficiente; o processo correto é uma entrevista sistemática até não restar gaps ou buracos.
- O autor adicionou checkpointing após cada pergunta para resolver o problema de context window: quando a sessão dura uma hora, as respostas dadas 40 minutos atrás podem se perder.
- Resultado de cada sessão: pasta `brainstorms/` na raiz do projeto com decisões-chave, log Q&A completo e highlights.

## Key insights

- A skill original de @mattpocockuk é apenas 4 frases: "Interview me relentlessly about every aspect of this plan... Walk down each branch... For each question, provide your recommended answer. Ask questions one at a time." — mostra que skill não precisa ser automação complexa, pode ser apenas um prompt que você não quer redigitar.
- Melhorias emergentes: após sessão de "packaging grill", a skill notou que a knowledge base e skill existentes de packaging não tinham os nuances discutidos, e pediu para atualizar ambos.
- Flagging de gaps: quando o usuário não sabe explicar um processo (porque outra pessoa o roda), a skill sinaliza quem consultar e aguarda a informação.
- Old way: iteração começa em ~70%, chega a ~95% após 10-30 iterações. Grill-me way: começa em ~90%, convergindo mais rápido.
- "Se eu tivesse 6 horas para cortar uma árvore, passaria as primeiras 4 afiando o machado."

## Exemplos e evidências

- Sessão sobre "o negócio completo": walkthrough de cada decisão e processo, resultando em um OS que "sabe como o negócio realmente funciona".
- Sessão de funnel map: revelou processos que o usuário não conseguia explicar bem — flag para consultar pessoa responsável.
- Skills e docs de packaging atualizados automaticamente com nuances da sessão de grill.

## Implicações para o vault

- O padrão grill-me é diretamente aplicável ao vault: criar uma skill de entrevista sistemática para extração de contexto antes de criar novos agentes.
- Checkpointing em brainstorm docs replica o que o vault já faz com sources e manifests — validação do padrão.
- A ideia de skill como "prompt que você não quer redigitar" é exatamente o design de skills do vault (SKILL.md files).
- Conecta ao princípio "context is the new infrastructure" do artigo de agentic development.

## Links

- [[03-RESOURCES/concepts/ai-agents/context-engineering]]
- [[04-SYSTEM/skills/core/codex-retrospective]]
- [[03-RESOURCES/entities/Claude]]
