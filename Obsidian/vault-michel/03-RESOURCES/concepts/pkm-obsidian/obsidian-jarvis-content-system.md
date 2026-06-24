---
title: Obsidian JARVIS Content System
type: concept
status: developing
created: 2026-04-24
updated: 2026-04-24
tags: [obsidian, claude-code, content-production, pkm, second-brain, jarvis]
---

# Obsidian JARVIS Content System

Sistema de captura, conexão e produção de conteúdo construído dentro do Obsidian com Claude Code como camada de inteligência. Criado e documentado por @cyrilXBT.

## Distinção central

Diferente de um [[03-RESOURCES/concepts/pkm-obsidian/second-brain]] clássico (PKM focado em conhecimento) ou de um [[03-RESOURCES/concepts/pkm-obsidian/life-operating-system]] (focado em execução de tarefas), o JARVIS Content System tem como output **conteúdo publicável** com voz autêntica do autor.

| Dimensão | Second Brain (PKM) | Life OS (Jarvis Sid) | JARVIS Content System |
|----------|-------------------|---------------------|----------------------|
| Output | Conhecimento organizado | Tarefas executadas | Conteúdo publicado |
| Foco | Retenção/recuperação | Automação de workflow | Conexão → produção |
| IA papel | Auxiliar | Executive assistant | Co-autor com voz |

## Princípio arquitetural: tipo sobre tópico

Organizar notas por **tipo** (observations, reactions, patterns, questions, numbers) e não por tópico.

**Por quê:** quando organizado por tópico, uma nota sobre "estratégia de conteúdo AI" e uma sobre "psicologia da atenção" nunca se encontram. Quando organizado por tipo, ambas ficam em `patterns/` e Claude Code encontra a conexão automaticamente.

## As 4 skills do sistema

1. **Process Inbox** — classifica, afina, tag (3 exatos), arquiva
2. **Weekly Connections** — 4 tipos (A: cross-domain, B: contradição, C: pattern, D: pergunta-resposta)
3. **Generate Brief** — ONE THING + PROOF + TRANSFORMATION + 3 HOOKS + 3 CLOSERS
4. **Write Content** — hook → proof → body → closer; indistinguível da voz do autor

Ver detalhes completos em [[03-RESOURCES/sources/pkm-obsidian-second-brain/jarvis-obsidian-claude-code-cyrilxbt]] e [[03-RESOURCES/sources/pkm-obsidian-second-brain/jarvis-obsidian-second-brain-thinks-full-setup]] (DamiDefi, mai 2026).

## CLAUDE.md como núcleo do sistema

O arquivo `CLAUDE.md` é o que transforma o vault de uma pasta aleatória em um sistema que Claude Code trata como familiar. Conteúdo crítico:

- Identidade + audiência + content pillars
- Descrição precisa de cada pasta
- Voz do autor em termos específicos (não "escreva bem" — "sentenças curtas, stops duros, cada ideia na própria linha")
- Hard rules explícitas
- Jobs prioritários

> "Vague CLAUDE.md files produce vague outputs." — @cyrilXBT

## Loop de performance como diferencial

JARVIS compila ao longo do tempo via feedback de performance em `04-PUBLISHED/`. Sessão mensal de análise retorna:
- Tópicos com melhor bookmarks/impression ratio
- Formatos de hook acima da média
- Ângulos inexplorados sugeridos pelos melhores posts

Depois de 6 meses o sistema conhece a audiência melhor que qualquer dashboard de analytics — porque lê conteúdo + dados juntos.

## Conexões no vault

- [[03-RESOURCES/sources/pkm-obsidian-second-brain/jarvis-obsidian-claude-code-cyrilxbt]] — fonte completa
- [[03-RESOURCES/concepts/pkm-obsidian/life-operating-system]] — Jarvis de Sid Bharath (execução pessoal)
- [[03-RESOURCES/concepts/pkm-obsidian/second-brain]] — base conceitual
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — as 4 skills são instâncias do padrão SKILL.md
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — CLAUDE.md rico = output específico
