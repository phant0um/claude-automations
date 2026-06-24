---
title: "Claude on a Mac Mini: the second brain that builds itself"
type: source
source: Clippings/Claude on a Mac Mini the second brain that builds itself.md
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents]
---

## Tese central
Um Mac Mini barato e sempre-ligado + Obsidian (vault local em markdown) + Claude API (Sonnet para pensar, Haiku para tagging/sanity-check barato) formam uma "segunda mente" que se constrói sozinha via 3 loops cron: lectures→notas, artigos→notas, manhã→brief de spaced-repetition. O ponto central não é o hardware — é que algo "always on" elimina o humano como gatilho do loop.

## Argumentos principais
- **Anatomia do loop**: TRIGGER → DO → VERIFY → ITERATE. Os 3 erros mais comuns: (1) verify "de vibe" em vez de regra dura (o modelo se autoavalia generosamente), (2) loop sem memória do que já tentou (repete o mesmo erro), (3) sem condição de parada (roda a noite toda cobrando por nada).
- **Stack de 3 camadas**: box (Mac Mini + cron/launchd + Python), store (Obsidian — markdown puro, scripts leem/escrevem direto na pasta, nada trancado em API), brain (Claude API, Sonnet vs Haiku por tarefa). "A cola entre as três camadas é ~200 linhas de Python."
- **Loop 1 (lecture→nota)**: yt-dlp → Whisper local → Claude extrai 5 conceitos + 3 quotes + 5 perguntas de revisão + wikilinks. Verify: nota tem as 4 seções E pelo menos 2 wikilinks reais — regra dura, não opinião do modelo.
- **Loop 2 (artigo→nota)**: scan noturno do export Pocket/Readwise → resumo + claims + quote + pergunta + wikilinks. Stop condition explícita: artigo fluff → marca "low signal" e segue, nunca fica re-tentando infinitamente.
- **Loop 3 (brief matinal)**: notas tocadas há 7/30/90 dias → Haiku gera pergunta de spaced-repetition, score próprio, regenera se <8.
- **Ordem recomendada para não quebrar em produção**: (1) provar manualmente no chat, (2) virar script Python, (3) embrulhar com verify+stop, (4) só então colocar no cron. "Pular pra agendar algo que você não provou na mão é exatamente como loops explodem enquanto você dorme."
- **Regra de custo**: Haiku ~12x mais barato que Sonnet; reservar Sonnet só onde "pensar" importa de fato.

## Key insights
- O framing "you are the trigger, close the tab and work stops" descreve com precisão a diferença entre usar um LLM via chat vs operar um sistema autônomo — e é exatamente o motivo de existir um pipeline-semanal/scheduled-task neste vault.
- Verify como regra dura (contável, não subjetiva) é o ponto mais transferível do artigo: qualquer pipeline autônomo deste vault (triagem, ingest) já segue esse princípio (ex: "score ≥5 = aprovado", não "parece bom").
- A progressão manual→script→loop→cron é uma sequência de hardening que vale para qualquer skill/agente novo antes de ser promovido a automação recorrente — eco direto de [[03-RESOURCES/concepts/agent-systems/agent-skill-graduation]].

## Exemplos e evidências
- Prompt de "loop manual" completo e copiável, usável só no chat antes de automatizar (PLAN→DO→VERIFY→DECIDE, critérios 1-10, "Never call it done until every criterion is 8+").
- Números de custo concretos: brief matinal custa "menos de um centavo por manhã".

## Implicações para o vault
- Confirma a arquitetura já em uso aqui (vault-michel = Obsidian + scheduled-task `pipeline-semanal` + agentes Claude) — o artigo é essencialmente uma descrição externa do mesmo padrão que este vault já implementa, o que valida as escolhas de design (markdown-first, verify por regra dura, modelo certo pra tarefa certa).
- Reforça [[03-RESOURCES/concepts/agent-systems/loop-engineering-patterns]] com um exemplo de domínio "PKM pessoal" (vs os exemplos existentes de trading/code-fixing/code-optimization).

## Minha Síntese
**O que mudou no meu entendimento:** Não vi nada estruturalmente novo — mas a clareza com que o artigo nomeia "você é o trigger, feche a aba e o trabalho para" cristalizou por que o pipeline-semanal deste vault (scheduled task, não chat manual) é a escolha certa, não um exagero de automação.

**Onde isso se conecta com o que já sei:** Os 3 loops do artigo (lecture, artigo, brief) mapeiam quase 1:1 nas fases deste vault: F2 ingest (artigo→nota com wikilinks obrigatórios) e F2.10 SRS register (brief de revisão) já implementam a mesma lógica, só que via pipeline markdown em vez de cron Python solto.

**Próxima ação concreta:** Nenhuma — confirma que a arquitetura atual (CLAUDE.md + scheduled-task + agentes) já está no ponto que o artigo descreve como "a versão real" pós-hardening manual.

## Links
- [[03-RESOURCES/concepts/agent-systems/loop-engineering-patterns]]
- [[03-RESOURCES/concepts/agent-systems/agent-skill-graduation]]
