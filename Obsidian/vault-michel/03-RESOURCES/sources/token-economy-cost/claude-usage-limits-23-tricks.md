---
title: "How to Stop Hitting Claude Usage Limits — 23 Tricks"
type: source
source_file: Clippings/How to stop hitting Claude usage limits..md
origin: post no X (@rubenhassid)
author: "@rubenhassid / Ruben Hassid"
published: 2026-04-12
ingested: 2026-05-14
tags: [claude, token-economy, usage-limits, cowork, produtividade, dicas]
triagem_score: 8
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
- [[03-RESOURCES/concepts/llm-ml-foundations/token-efficiency-prompting]] — conceito relacionado
- [[03-RESOURCES/sources/memory-context-rag/contextmaxxing-vs-tokenmaxxing]] — perspectiva enterprise do mesmo tema
- [[03-RESOURCES/sources/token-economy-cost/hook-fights-34-percent-token-waste]] — outra fonte de desperdício de tokens

## O Mecanismo do Crescimento Quadrático

A afirmação central — "Claude re-lê toda a conversa em cada mensagem" — tem uma consequência matemática que a maioria dos usuários não calcula explicitamente.

Se cada mensagem tem comprimento médio M tokens, uma sessão de N mensagens acumula:
- Turno 1: 1×M tokens lidos (só o primeiro prompt)
- Turno 2: 2×M tokens lidos (turno 1 + turno 2)
- Turno N: N×M tokens lidos

Total de tokens consumidos ao longo de N turnos: M × (1 + 2 + 3 + ... + N) = M × N(N+1)/2

Para N=20 mensagens de M=100 tokens cada: 100 × 210 = 21,000 tokens
Para N=30 mensagens de M=100 tokens cada: 100 × 465 = 46,500 tokens

A sessão de 30 mensagens não custa 50% mais que a de 20 — custa 2.2× mais. Este crescimento quadrático é o mecanismo por trás dos números citados (20 mensagens ≈ 105.000 tokens, 30 mensagens ≈ 232.000 tokens).

**Implicação direta:** cortar uma sessão de 30 mensagens para 15 mensagens não reduz o custo pela metade — reduz para ~25%. O início de uma nova sessão com summary é a única intervenção que reinicia o contador.

## Por Que a Edição de Mensagem é o Hábito Mais Valioso

O hábito #8 ("Edit message em vez de follow-up") é citado como favorito do autor e merece explicação técnica. Quando você edita uma mensagem anterior e regenera:

- O exchange antigo é **substituído**, não empilhado
- A conversa continua a partir daquele ponto como se o exchange original nunca tivesse ocorrido
- Tokens do exchange substituído não são incluídos em turnos futuros

Comparação:
- **Follow-up:** "Na verdade, pode reformular o parágrafo 3?" → adiciona a pergunta + a resposta anterior + a nova resposta ao histórico
- **Edit + regenerate:** substitui a resposta anterior pela nova → histórico permanece do mesmo tamanho

Para sessões de iteração (rascunho → feedback → revisão → feedback → revisão), o hábito de editar em vez de fazer follow-up pode reduzir o tamanho total da sessão em 40-60%.

## Hábito #3 — "Ask me questions" — Análise Detalhada

O hábito de substituir um prompt de 500 palavras por um prompt curto + pedido de clarificações parece contraintuitivo (parece adicionar turnos). Por que funciona:

**Sem o hábito:**
- Turno 1: prompt de 500 tokens
- Turno 2: resposta + 500 tokens de história = 650 tokens lidos
- Turno 3: follow-up + 650 tokens de história = 800 tokens lidos
- ...continua crescendo com 500 tokens de overhead desnecessário em cada turno

**Com o hábito:**
- Turno 1: prompt de 15 tokens + "ask me questions"
- Turno 2: 3-5 perguntas de clarificação do Claude (geradas uma vez)
- Turno 3: suas respostas às perguntas (30-50 tokens)
- Turno 4: resposta final com contexto perfeito

O overhead por turno é 15 tokens (o prompt curto) em vez de 500 tokens. Em uma sessão de 10 turnos, a diferença é 10 × 485 = 4.850 tokens economizados.

## O Papel dos Projects para Caching

O hábito #17 (usar Projects para arquivos recorrentes) conecta diretamente ao mecanismo de prompt caching. Quando um arquivo é carregado em um Project:
- O primeiro upload computa o contexto e armazena em cache
- Sessões subsequentes servem o arquivo do cache em vez de reprocessar
- O cache persiste entre sessões (diferente do contexto in-session)

Para arquivos grandes (briefings, especificações, contexto de projeto), a economia é proporcional ao tamanho do arquivo × número de sessões. Um documento de contexto de 10.000 tokens usado em 20 sessões custa 10.000 tokens na primeira sessão e ~0 tokens nas 19 seguintes (apenas a cache hit cost, que é ordens de magnitude menor).

O hábito #10 (ABOUT ME < 2.000 palavras) é o complemento: o arquivo de contexto carregado antes de cada tarefa no Cowork precisa ser pequeno para que o custo do cache hit permaneça baixo mesmo quando o cache estiver quente.

## Hábito #22 — Rolling Window: Mecânica dos Limites

O Claude (planos pagos) usa um sistema de rolling window de 5 horas para limits de uso, não um reset diário. Isso tem uma implicação contraintuitiva: distribuir o trabalho em rajadas concentradas ao longo do dia esgota a window rapidamente. Distribuir uniformemente (trabalho contínuo ao longo de 12 horas) mantém o consumo dentro do window de forma mais estável.

A estratégia de "trabalho de manhã + trabalho à noite" com pausa no meio pode ser mais eficiente que uma sessão ininterrupta de 8 horas — a pausa deixa o início da window expirar enquanto a segunda sessão consome um window fresher.

## Habitual vs. Situacional — Aplicabilidade dos 23 Hábitos

Nem todos os 23 hábitos têm o mesmo ROI para todos os workflows:

**Alta alavancagem para todos os usuários:**
- Hábito #8 (edit em vez de follow-up): zero custo de implementação, redução imediata
- Hábito #6 (batch de tarefas): mesma operação, menos reloads
- Hábito #15 (nova conversa quando tópico muda): evita o crescimento quadrático entre tópicos não relacionados

**Alta alavancagem para usuários de Cowork:**
- Hábito #10 (ABOUT ME < 2.000 palavras): Cowork carrega ABOUT ME antes de cada tarefa
- Hábito #14 (seleção de pasta): não carregar todo o projeto quando só uma pasta é relevante

**Alta alavancagem para usuários de Claude Code:**
- Hábito #20 (escopo claro antes de iniciar): evita exploração desnecessária do codebase
- Hábito #21 (CLAUDE.md curto): overhead em cada turno

Para vault-michel, os hábitos mais aplicáveis são #21 (CLAUDE.md curto — já implementado), #8 (edit em vez de follow-up — prática recomendada), e #20 (escopo claro — alinha com o princípio Karpathy de "think before acting").
