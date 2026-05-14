---
title: "arc. — 10 trucos para usar Claude todo el día sin agotar tokens"
type: source
source_file: "Clippings/Thread by @arceyul on Thread Reader App.md"
origin: thread no X (@arceyul)
ingested: 2026-05-14
tags: [claude, token-efficiency, prompts, produtividade, trucos]
---
# arc. — 10 trucos para usar Claude todo el día sin agotar tokens

> [!key-insight] Core point
> Claude conta tokens, não mensagens — 10 técnicas para maximizar uso diário sem atingir o limite, com estimativas de economia por técnica.

## Conteúdo

| # | Técnica | Economia estimada |
|---|---|---|
| 1 | Editar prompt original (ícone ✏️) em vez de acumular follow-ups | Até 40% tokens |
| 2 | Nova conversa a cada ~20 mensagens (pedir resumo, copiar, reabrir) | Até 50× menos tokens/turno |
| 3 | Agrupar várias perguntas num único mensagem | Proporcional ao nº de turnos economizados |
| 4 | Subir arquivos recorrentes a Projetos (cache) | Zero custo por reusar |
| 5 | Configurar memória + instruções personalizadas uma vez (Settings → Memory) | Elimina 3-5 msgs de setup |
| 6 | Desativar busca web, modo pesquisa, conectores quando não necessários | Tokens extra eliminados |
| 7 | Usar Haiku para tarefas simples (formatação, gramática, brainstorm) | Custo significativamente menor |
| 8 | Escolher modelo pela tarefa: Haiku / Sonnet / Opus | Até 5× diferença de custo |
| 9 | Distribuir em 2-3 sessões diárias (janela de 5h reinicia) | 150-200 msgs/dia vs 45 em sessão única |
| 10 | Identificar maiores consumidores (docs extensos, conversas longas, busca web) | Otimiza casos de uso custosos |

**Prompt de resumo para nova conversa:**
```
Resume los puntos clave de esta conversación en 5 viñetas concisas,
incluyendo el contexto esencial, decisiones tomadas y próximos pasos,
para que pueda continuar en un nuevo chat.
```

## Conexões
- [[03-RESOURCES/entities/arceyul]]
- [[03-RESOURCES/concepts/token-efficiency-prompting]]
- [[03-RESOURCES/concepts/prompt-caching]]
