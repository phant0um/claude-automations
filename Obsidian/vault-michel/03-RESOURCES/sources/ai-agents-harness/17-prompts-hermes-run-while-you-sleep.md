---
title: "17 prompts that make Hermes run while you sleep"
type: source
source: "Clippings/17 prompts that make Hermes run while you sleep (copy-paste inside).md"
created: 2026-06-10
ingested: 2026-06-10
tags: [ai-agents]
---

## Tese central
Um Hermes Agent recém-instalado é apenas um runtime ocioso ("blank install"); o valor real vem de um conjunto curado de prompts que transformam a engine em workflow — jobs com gatilho (schedule/evento), corpo (o que fazer) e regra de escalada (quando incomodar o usuário). Sem os três elementos, o prompt falha silenciosamente, faz a coisa errada ou produz ruído.

## Argumentos principais
- Ferramentas baseadas em sessão (Claude Code, Cursor, chat) morrem com o fechamento da aba — não servem para trabalho que não é "session-shaped" (briefing matinal, monitoramento de build no fim de semana, triagem de inbox contínua).
- Hermes preenche essa lacuna por ser: persistente (memória sobrevive à sessão), agendado (age por relógio, não por atenção do usuário) e alcançável (Telegram, Discord, Slack, WhatsApp, Signal, email).
- Pré-requisitos antes de qualquer prompt funcionar:
  - Modelo com contexto real — modelos locais pequenos derrubam tool calls em tarefas multi-etapa; modelo frontier (Claude) resolve isso.
  - Backend serverless que hiberna quando ocioso (evita pagar 24h por um agente que roda poucos minutos/dia).
  - Home persistente (VPS de $5, não o laptop do usuário).
- O recurso escasso nunca foi tempo, foi atenção — o ponto de um agente persistente é parar de competir por ela.
- "Turn a good run into a permanent skill": após qualquer execução bem-sucedida, pedir ao Hermes para salvar o formato como skill reutilizável (gera SKILL.md a partir da própria execução) — elimina re-explicação repetida.

## Key insights
1. **Morning brief (7am, dias úteis)**: pull de notificações GitHub não lidas + PRs abertos, resumo do que mudou/bloqueia, enviado via Telegram em 3-5 bullets. Eliminou ~35min/dia de triagem manual (~3h/semana).
2. **Repo watch silencioso**: monitora CI/issues, mas só fala quando CI fica vermelho ou issue com label "bug" abre — "a skill está no silêncio". Detecta CI quebrado em ~90s vs. descoberta 3 dias depois.
3. **Triagem de inbox horária multi-canal**: agrupa por remetente/urgência, auto-arquiva newsletters, só escala se houver prazo, pessoa esperando ou dinheiro envolvido. Resolve o problema de ~120 mensagens/dia em 6 plataformas.
4. **Digest de pesquisa sextas 18h**: dedupe contra o que já foi enviado na semana anterior — a cláusula de dedupe é o truque que garante novidade real.
5. **"Make sense of this repo"**: clone + resumo de arquitetura em 5 bullets + entrypoint + arquivo mais arriscado + draft de PR workflow — comprime o "cold-start day" para ~4min de mapa.
6. **Tarefa noturna assíncrona**: "não espere por mim, faça suposições razoáveis e liste no topo" — transforma travamento de madrugada em resultado pronto pela manhã.
7. **Watch de changelogs de concorrentes (9am diário)**: só notifica mudança real (feature, preço, deprecation), citando o diff exato.
8. **Code review noturno (23h)**: flagga TODO esquecido, console.log shipado, função >80 linhas, path alterado sem teste — "a revisão de código mais barata que rodo".
9. **Stand-up automático (9:55am)**: monta "fechado ontem / em progresso / bloqueado" a partir de repos e canais conectados.
10. **Radar de menções**: busca diária por menções do projeto/handle, ignora elogios, escala bug reports/reclamações/perguntas sem resposta.
11. **Talk-to-bullets**: pega URL de vídeo/podcast, extrai transcript, retorna argumento em 5 bullets com timestamps, pula intro e sponsor read.
12. **Explain-this-error**: dado um stack trace, busca a causa no repo, explica em 2 frases, propõe o menor patch possível sem tocar em mais nada.
13. **Inbox-zero com drafts**: para emails de rotina, redige resposta na voz do usuário e segura numa fila para aprovação com um toque — nunca envia sozinho.
14. **On-call diagnosis**: ao disparar alerta de monitoramento, puxa últimas 50 linhas de log relevantes, verifica deploys recentes, envia hipótese de causa em um parágrafo junto do alerta cru.
15. **Config de modelo**: `hermes config set model anthropic/claude-opus-4.8` — trocar para Claude corrigiu de uma vez todas as falhas sutis dos recipes 1-14, que eram falhas do modelo (drop de tool calls), não dos prompts.
16. **Backend serverless**: `hermes config set terminal.backend daytona` — reduziu custo de idle (23h/dia ocioso) de "mais que o próprio trabalho custava" para centavos.
17. **Salvar como skill permanente**: comando final que converte qualquer run bem-sucedido em SKILL.md reutilizável.

## Exemplos e evidencias
- Experimento de 5 semanas em VPS de $5, com Claude como modelo subjacente.
- Comparação de uma semana de trabalho feito manualmente vs. pelo Hermes com os mesmos prompts — métrica "Unattended" = executado em schedule/async sem input do usuário após o prompt inicial.
- Erros cometidos e documentados:
  1. Schedules vagos ("send me updates on my repos") geram firehose sem regra de escalada — todo prompt agendado precisa de cláusula explícita "only tell me when X".
  2. Falta de token budget em jobs horários — triagem horária "tagarela" gastou mais numa semana do que o planejado para o mês inteiro.
  3. Modelo barato/local para economizar — derruba tool calls em tarefas multi-etapa, parece bug de prompt mas é limitação de modelo.
- Trade-offs honestos: usuário vira "o admin" (updates, uptime, modelo de permissão); o agente roda comandos shell — sandbox (Docker/serverless com isolamento) é decisão de dia 1, não depois; hype de star count é ruidoso, julgar pelo resultado real na semana.
- Instalação: `curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash` seguido de `hermes setup`.

## Implicacoes para o vault
- Confirma e expande o registro já existente em `[[03-RESOURCES/entities/hermes]]` (Nous Research, agent framework com memória persistente e skills built-in) — este artigo fornece a camada operacional concreta (os 17 prompts) que faltava como exemplo prático aplicável.
- Reforça `[[03-RESOURCES/concepts/agent-systems/agent-shared-memory]]` no ponto "turn a good run into a permanent skill" — mecanismo de auto-escrita de skills a partir de execuções bem-sucedidas é o mesmo padrão de "self-writing vault" mencionado na maturidade do vault (memory MEMORY.md).
- A regra "trigger + body + escalation rule" para prompts persistentes é um framework reutilizável para qualquer rotina agendada do vault (ex.: pipeline-diario, ingest-report).
- Nota: o concept `[[03-RESOURCES/concepts/hermes]]` documenta um agente diferente (vídeo-gen de kidpakerot, mesmo nome) — não confundir; a entity `hermes.md` é o Nous Research Hermes Agent referenciado aqui.
- Não há concept novo necessário — overlap claro com `entities/hermes.md` (Nous Research Hermes), que recebe link de volta.

## Links
- [[03-RESOURCES/entities/hermes]]
- [[03-RESOURCES/concepts/agent-systems/agent-shared-memory]]
