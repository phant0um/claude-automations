---
title: "Most Ideas Die in 90 Seconds. Here Is How I Capture Mine in 3."
type: source
source: "Clippings/Most Ideas Die in 90 Seconds. Here Is How I Capture Mine in 3..md"
created: 2026-06-19
ingested: 2026-06-19
tags: [articles, pkm]
---

## Tese central
Ideias têm janela de ~90 segundos antes que o contexto ao redor as sobrescreva — não metáfora, observação prática de memória sob distração. Sistemas de captura normais perdem a ideia no intervalo entre ela chegar e o sistema estar pronto pra receber (abrir app, navegar, categorizar, digitar). O plugin Obsidian **QuickAdd** reduz isso a 1 ação: atalho de teclado → caixa flutuante → digita → enter → ideia no vault, sem interromper o que estava fazendo. ~3 segundos testados repetidamente.

## Argumentos principais
- 4 workflows de captura, cada um com hotkey e destino fixo: **General Capture** (Cmd+Shift+C → `## Captures` na nota diária, qualquer coisa que não encaixe nas outras 3), **Research Signal** (Cmd+Shift+R → `## Research`, dado que desafia uma tese ou fonte a investigar), **Content Idea** (Cmd+Shift+I → `## Ideas`, ângulos/ganchos), **Source/Link** (Cmd+Shift+L → nota standalone em 00-Inbox com data, URL + 1 linha de por-quê salvou).
- Checar conflito de hotkey antes de configurar (System Settings → Keyboard no Mac, Settings → Hotkeys no Obsidian) — conflito silencioso (atalho "não faz nada") é a causa mais comum do setup parecer quebrado na primeira tentativa.
- Setup técnico: Settings → QuickAdd → + → tipo Capture → "File to append to" com sintaxe `{{DATE:YYYY-MM-DD}}` → "Capture Format" controla a formatação (`{{VALUE}}` puro, ou `[{{DATE:HH:mm}}] {{VALUE}}` com timestamp, ou checkbox `- [ ] {{VALUE}}`). Multi-valor possível via vírgula no input (`{{VALUE:1}}`, `{{VALUE:2}}`) pra capturar ideia + categoria numa tacada, mas é opcional — captures single-value cobrem a maioria dos casos.
- Falha de setup mais comum: nota diária não existe ainda quando o primeiro capture do dia dispara — falha silenciosa ou cria arquivo sem os headings. Fix: habilitar "Create file if it doesn't exist" + "Create file from template" apontando pro template da nota diária.
- Captures relacionados caindo em seções diferentes da mesma nota (sem link entre si) é esperado e não deve ser resolvido no momento da captura — tentar linkar manualmente reintroduz a pausa de avaliação que o QuickAdd existe pra eliminar. A conexão entre captures relacionados é exatamente o que um processo de síntese (revisão noturna/semanal) deve achar depois.
- Mobile: keyboard shortcut não funciona igual — solução é bot Telegram conectado a workflow N8N, mensagem cai em 00-Inbox em <30s como nota markdown.
- **O hábito que faz o sistema funcionar**: capturar antes de avaliar. A pausa de "vale a pena salvar isso?" já dura mais que os 90 segundos — pelo tempo que decide, a ideia já degradou. Regra: capture first, evaluate never; o processador de inbox noturno é quem decide o que descartar, não o momento de captura.

## Key insights
- O ganho não é só "menos atrito" — é mudança de distribuição de qualidade: ideias que o autor teria avaliado como "não vale salvar" e perdido se tornaram sementes de algumas das melhores linhas de pesquisa do mês.
- Colisões cross-context (ideia de uma caminhada conectando com ideia de uma leitura) só são possíveis se as capturas de todos os contextos estiverem de fato no vault — volume bruto de captura é pré-requisito pra esse tipo de síntese emergente, não ruído a ser filtrado antes.
- "QuickAdd não é ferramenta de produtividade, é o mecanismo que determina se o resto do sistema tem algo com que trabalhar" — captura é o bottleneck real do PKM, não a etapa de síntese.

## Implicações para o vault
Aplicável diretamente: este vault usa `00-INBOX/` pra capturas brutas mas não tem (até onde documentado) um mecanismo de captura sub-3-segundos tipo QuickAdd — hoje a captura provavelmente depende de abrir o Obsidian/Claude Code manualmente. Vale avaliar se o workflow "capture first, evaluate never" (sem avaliação no momento de captura, processamento de inbox depois) já é seguido ou se o pipeline de triagem atual já faz esse papel de avaliação tardia — parece compatível: F1 (triagem) já avalia depois da captura (Readwise/Clippings), não no momento.

## Links
- [[03-RESOURCES/concepts/pkm-obsidian/knowledge-compounding]]
