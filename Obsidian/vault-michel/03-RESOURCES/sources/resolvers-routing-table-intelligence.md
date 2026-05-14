---
title: "Resolvers: The Routing Table for Intelligence"
type: source
source_file: .raw/articles/Resolvers The Routing Table for Intelligence.md
author: Garry Tan (@garrytan)
ingested: 2026-04-17
tags: [resolvers, agent-governance, routing, context-rot, gbrain, gstack]
---

# Resolvers: The Routing Table for Intelligence

> [!summary]
> Garry Tan explica como resolvers (tabelas de roteamento de contexto) são a camada de governança invisível de sistemas agênticos. Sem eles, skills inventam lógica própria de filing e o sistema vira uma gaveta de lixo. Com eles, 200 linhas substituem 20.000 linhas de contexto.

## O Problema: 20.000 linhas de confissão

CLAUDE.md cresceu para 20k linhas. Resultado: atenção degradada, respostas lentas e imprecisas, mais alucinações. O próprio Claude pediu para cortar.

**A fix foi um arquivo de 200 linhas**: árvore de decisão numerada + ponteiros para documentos. Quando o modelo precisa arquivar algo, percorre a árvore.

## O que é um Resolver

Um resolver é uma tabela de roteamento para contexto. Quando o tipo de tarefa X aparece, carregue o documento Y primeiro.

**Resolvers são fractais** — existem em toda camada do sistema:
- **Skill resolver** (AGENTS.md): tipo de tarefa → arquivo de skill
- **Filing resolver** (RESOLVER.md): tipo de conteúdo → diretório
- **Context resolver** (dentro de cada skill): sub-roteamento interno

## O Problema Invisível: Skills não Registradas

Audit de 13 skills: apenas 3 referenciavam o resolver. 10 tinham paths hardcoded.

Depois de 40+ skills: 6 eram completamente inalcançáveis (15% das capacidades no escuro).

**Fix:** `check-resolvable` — meta-skill que percorre toda a cadeia e encontra dead links. Roda semanalmente.

## Context Rot

- Dia 1: resolver perfeito
- Dia 30: 3 novas skills sem registro
- Dia 60: trigger descriptions obsoletas
- Dia 90: o resolver é um documento histórico

**Solução emergente**: RLM (reinforcement learning) que observa cada dispatch de tarefa e reescreve triggers baseado em evidências observadas. AutoDream do Claude Code é uma versão primitiva disso.

## Resolvers como Gestão

Skills = funcionários. Resolver = organograma. Filing rules = processo interno. check-resolvable = auditoria de compliance. Trigger evals = avaliações de desempenho.

> [!insight]
> O problema não é que modelos não são inteligentes o suficiente. O problema é que construímos organizações sem camada de gestão. Apenas uma pilha de funcionários talentosos e a esperança de que vão se coordenar.

## Projetos Open-Source

- **GBrain** — sistema de memória pessoal; ships com resolver pattern built-in (`gbrain init`)
- **GStack** — 72.000+ stars; fat skills em markdown; layer de coding
- **OpenClaw / Hermes Agent** — harness fino; condutor do agent loop

## Conceitos Relacionados

- [[resolver-pattern]]
- [[claude-agent-harness-architecture]]
- [[claude-skills]]
- [[context-engineering]]

## Entidades Mencionadas

- [[Garry-Tan]] — autor (@garrytan); YC partner; criador do GBrain/GStack
- [[GBrain]] — sistema de memória pessoal open-source
- [[GStack]] — 72k+ stars; fat skills em markdown
- [[OpenClaw]] — harness agent de Garry Tan
