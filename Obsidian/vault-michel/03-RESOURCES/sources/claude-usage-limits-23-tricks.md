---
title: "How to Stop Hitting Claude Usage Limits — 23 Tricks"
type: source
source_file: Clippings/How to stop hitting Claude usage limits..md
origin: post no X (@rubenhassid)
author: "@rubenhassid / Ruben Hassid"
published: 2026-04-12
ingested: 2026-05-14
tags: [claude, token-economy, usage-limits, cowork, produtividade, dicas]
---

# 23 Tricks para Parar de Atingir Limites do Claude

Guia prático de [[03-RESOURCES/entities/Ruben-Hassid]] com 23 hábitos para reduzir consumo de tokens e parar de atingir limites do Claude. Insight central: Claude re-lê toda a conversa em cada mensagem — o custo cresce quadraticamente com a conversa.

## Mecanismo Fundamental

Uma conversa de 30 mensagens re-lê 29 exchanges anteriores antes de processar a nova mensagem. Uma sessão de 20 mensagens ≈ 105.000 tokens. Uma sessão de 30 mensagens ≈ 232.000 tokens.

## Os Hábitos Mais Desconhecidos

**1. Converter arquivos antes de upload**
- PDF: 1.500-3.000 tokens/página
- Screenshot 1000x1000: ≈1.300 tokens
- Crop tight → pode cair para < 100 tokens
- Workflow: doc.new → colar texto → download como .md

**2. Planejar no Chat, criar no Cowork**
- Chat = produto barato (planejamento, estrutura, suposições)
- Cowork = produto caro (execução e build)

**3. "Ask me questions" em vez de prompt longo**
- 500-word prompt = 500 tokens repetidos a cada mensagem
- 15-word prompt + AskUserQuestion = clarificações geradas uma vez

**6. Batch de tarefas**
3 prompts separados = 3 reloads completos. Um prompt com 3 tasks = 1 reload.

**8. Edit message em vez de follow-up** (favorito do autor)
Chat permite editar a mensagem original e regenerar. Exchange antigo é substituído, não empilhado.

## Os Hábitos "Básicos" que Ainda Importam

**10.** Arquivos ABOUT ME < 2.000 palavras (Cowork lê antes de CADA tarefa)
**11.** Reiniciar conversa em vez de send follow-ups; salvar summary e começar fresh
**12.** Sumarizar a cada 15-20 mensagens; copiar summary, nova sessão
**13.** Sonnet/Haiku para tarefas simples; Opus para deep work
**14.** Não usar pasta toda no Cowork — selecionar apenas o necessário
**15.** Nova conversa quando o tópico muda
**16.** Desligar features não usadas (Web search, connectors, Explore mode)
**17.** Usar Projects para arquivos recorrentes → caching (upload único)
**18.** Memory desligada + User Preferences configuradas → "Concise" style
**20.** Escopo claro para Claude Code antes de iniciar
**21.** CLAUDE.md curto: skills carregam sob demanda, CLAUDE.md carrega sempre
**22.** Distribuir trabalho ao longo do dia (rolling 5-hour window)

## Regra de Ouro

> "Pense em tokens como conversas: quanto mais curtas, mais eficientes."

Cada hábito aponta para: evitar re-leituras desnecessárias de contexto morto.

## Conexões

- [[03-RESOURCES/entities/Ruben-Hassid]] — autor
- [[03-RESOURCES/entities/Claude-Cowork]] — produto mencionado frequentemente
- [[03-RESOURCES/concepts/token-efficiency-prompting]] — conceito relacionado
- [[03-RESOURCES/sources/contextmaxxing-vs-tokenmaxxing]] — perspectiva enterprise do mesmo tema
- [[03-RESOURCES/sources/hook-fights-34-percent-token-waste]] — outra fonte de desperdício de tokens
