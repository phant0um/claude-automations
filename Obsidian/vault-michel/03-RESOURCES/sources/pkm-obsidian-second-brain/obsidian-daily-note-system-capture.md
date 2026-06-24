---
title: "The Exact Obsidian Daily Note System I Use to Never Lose an Idea Again"
type: source
source: Clippings/The Exact Obsidian Daily Note System I Use to Never Lose an Idea Again..md
author: "@DamiDefi"
published: 2026-05-28
ingested: 2026-05-28
tags: [obsidian, daily-notes, pkm, capture, quickadd, templater, knowledge-compounding]
---

## Tese central

Ideas morrem por fricção, não por falta de disciplina — a infraestrutura de captura precisa ser mais rápida que a racionalização "vou lembrar depois". Sistema: Templater cria daily note automaticamente + QuickAdd para captura 1-tap + Claude faz review noturno e extrai o que importa.

## Argumentos principais

- **Problema central**: fricção entre ter ideia e capturá-la — cada segundo de delay = chance do cérebro dizer "vou lembrar"
- **Disciplina não escala**: infraestrutura escala
- **Daily note automática**: Templater cria na abertura do vault, já estruturada, sem trabalho mental
- **6 seções mínimas**: Today's Focus, Captures, Research Signals, Content Ideas, Links to Process, Claude Review
- **Today's Focus**: 1-3 itens, não lista de tarefas — declaração de foco; 60 segundos no máximo
- **QuickAdd para mobile**: 1 tap → campo de texto → salvo → volta para o que estava fazendo
- **Claude Review noturno (21h)**: lê todas as seções do dia, extrai: decisões tomadas, padrões visíveis, ideias para aprofundar, itens urgentes para amanhã
- **Fleeting → Permanent**: weekly review move captures para notas permanentes; o que não foi movido em 7 dias = provavelmente não importava

## Key insights

- **"Discipline is not scalable. Infrastructure is."** — frase central do sistema
- Sistema em 1 frase: "daily note automática + captura 1-tap + review IA noturno"
- Seções permanecem vazias até algo chegar — sem pressão para preencher, sem mínimo
- Captura imediata, unpolished — processar depois; não na hora da ideia
- **6 meses de operação sem nenhuma ideia perdida** — validação empírica
- Claude Review = triagem automática sem custo cognitivo no momento da captura

## Exemplos práticos

```yaml
# Template daily note (Templater)
---
date: {{date:YYYY-MM-DD}}
day: {{date:dddd}}
week: {{date:YYYY-[W]WW}}
---
## Today's Focus
- 
## Captures
[Everything lands here throughout the day]
## Research Signals
[Market observations, narrative moves]
## Content Ideas
[Angles, titles, hooks — unpolished]
## Links to Process
[URLs to file into vault later]
## Claude Review
[Populated automatically at 9pm]
```

## Implicações para o vault

O vault-michel tem `05-DAILY/template-diario.md` — este source sugere adicionar QuickAdd para mobile capture e Claude Review noturno via pipeline-diario (já existe). A seção "Claude Review" no daily note pode ser o output da Fase 3 do pipeline direcionado à nota do dia.

Complementa [[03-RESOURCES/concepts/pkm-obsidian/knowledge-compounding]] com mecanismo de captura sem fricção. Liga a [[07-QUEUE/rotinas/pipeline-diario]] — o pipeline já faz o review; integrar output ao daily note fecha o loop.

## Links

- [[03-RESOURCES/concepts/pkm-obsidian/knowledge-compounding]]
- [[05-DAILY/template-diario]]
- [[07-QUEUE/rotinas/pipeline-diario]]
- [[03-RESOURCES/sources/pkm-obsidian-second-brain/obsidian-pm-system-claude-auto-update]]
